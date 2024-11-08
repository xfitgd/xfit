const std = @import("std");
const xfit = @import("xfit.zig");
const system = @import("system.zig");
const window = @import("window.zig");
const input = @import("input.zig");
const __system = @import("__system.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");
const root = @import("root");

pub const c = @cImport({
    @cDefine("XK_LATIN1", "1");
    @cDefine("XK_MISCELLANY", "1");
    @cInclude("X11/Xlib.h");
    @cInclude("X11/keysym.h");
});

pub var display: ?*c.Display = null;
pub var def_screen_idx: usize = 0;
pub var wnd: c.Window = 0;
pub var screens: []?*c.Screen = undefined;
pub var del_window: c.Atom = undefined;

var input_thread: std.Thread = undefined;

pub fn system_linux_start() void {
    display = c.XOpenDisplay(null);
    if (display == null) xfit.herrm("system_linux_start XOpenDisplay");
    def_screen_idx = @max(0, c.DefaultScreen(display));
    screens = std.heap.c_allocator.alloc(?*c.Screen, @max(0, c.ScreenCount(display))) catch unreachable;
    var i: usize = 0;
    while (i < screens.len) : (i += 1) {
        screens[i] = c.ScreenOfDisplay(display, i);
    }
}

fn render_func() void {
    //var ring = std.os.linux.IoUring.init(64, 0) catch |e| xfit.herr3("input_func IoUring.init", e);
    //var sqe = ring.get_sqe() catch |e| xfit.herr3("input_func ring.get_sqe", e);
    __vulkan.vulkan_start();

    root.xfit_init() catch |e| {
        xfit.herr3("xfit_init", e);
    };

    __vulkan_allocator.execute_and_wait_all_op();

    while (!xfit.exiting()) {
        __system.loop();
    }
    __vulkan_allocator.execute_and_wait_all_op();

    __vulkan.wait_device_idle();

    root.xfit_destroy() catch |e| {
        xfit.herr3("xfit_destroy", e);
    };

    __vulkan.vulkan_destroy();
}

pub fn linux_start() void {
    if (__system.init_set.window_width == xfit.init_setting.DEF_SIZE or __system.init_set.window_width == 0) __system.init_set.window_width = 960;
    if (__system.init_set.window_height == xfit.init_setting.DEF_SIZE or __system.init_set.window_height == 0) __system.init_set.window_height = 540;
    if (__system.init_set.window_x == xfit.init_setting.DEF_POS) __system.init_set.window_x = 0;
    if (__system.init_set.window_y == xfit.init_setting.DEF_POS) __system.init_set.window_y = 0;

    if (__system.init_set.screen_index > screens.len - 1) __system.init_set.screen_index = @intCast(def_screen_idx);

    wnd = c.XCreateWindow(
        display,
        @as(c_ulong, @intCast(c.RootWindow(display, __system.init_set.screen_index))),
        __system.init_set.window_x,
        __system.init_set.window_y,
        __system.init_set.window_width,
        __system.init_set.window_height,
        0,
        c.CopyFromParent,
        c.CopyFromParent,
        c.CopyFromParent,
        0,
        null,
    );
    _ = c.XSelectInput(display, wnd, c.KeyPressMask | c.KeyReleaseMask | c.ButtonReleaseMask | c.ButtonPressMask | c.StructureNotifyMask);
    _ = c.XMapWindow(display, wnd);
    del_window = c.XInternAtom(display, "WM_DELETE_WINDOW", 0);
    _ = c.XSetWMProtocols(display, wnd, &del_window, 1);
    _ = c.XFlush(display);

    input_thread = std.Thread.spawn(.{}, render_func, .{}) catch unreachable;
}

pub fn vulkan_linux_start(vkSurface: *__vulkan.vk.SurfaceKHR) void {
    __vulkan.load_instance_and_device();
    if (vkSurface.* != .null_handle) {
        __vulkan.vki.?.destroySurfaceKHR(vkSurface.*, null);
    }
    const xlibSurfaceCreateInfo: __vulkan.vk.XlibSurfaceCreateInfoKHR = .{
        .window = wnd,
        .dpy = @ptrCast(display.?),
    };
    vkSurface.* = __vulkan.vki.?.createXlibSurfaceKHR(&xlibSurfaceCreateInfo, null) catch |e|
        xfit.herr3("createXlibSurfaceKHR", e);
}

pub fn linux_loop() void {
    var event: c.XEvent = undefined;
    while (!xfit.exiting()) {
        _ = c.XNextEvent(display, &event);
        switch (event.type) {
            c.ConfigureNotify => {
                const w = window.window_width();
                const h = window.window_height();
                if (w != event.xconfigure.width or h != event.xconfigure.height) {
                    @atomicStore(u32, &__system.init_set.window_width, @abs(event.xconfigure.width), std.builtin.AtomicOrder.monotonic);
                    @atomicStore(u32, &__system.init_set.window_height, @abs(event.xconfigure.height), std.builtin.AtomicOrder.monotonic);

                    if (__system.loop_start.load(.monotonic)) {
                        root.xfit_size() catch |e| {
                            xfit.herr3("xfit_size", e);
                        };
                        __system.size_update.store(true, .monotonic);
                    }
                }
            },
            c.ClientMessage => {
                if (event.xclient.data.l[0] == del_window) {
                    __system.exiting.store(true, std.builtin.AtomicOrder.release);
                    return;
                }
            },
            c.KeyPress => {
                const keyr = c.XLookupKeysym(&event.xkey, 0);
                if (keyr > 0xffff) continue;
                var keyv: u16 = @intCast(keyr);
                const key: input.key = @enumFromInt(keyv);
                if (keyv > 0xff and keyv < 0xff00) {
                    @branchHint(.cold);
                    xfit.print("WARN linux_loop KeyPress out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keyv });
                    continue;
                } else if (keyv >= 0xff00) {
                    keyv = keyv - 0xff00 + 0xff;
                }
                //다른 스레드에서 __system.keys[keyv]를 수정하지 않고 읽기만하니 weak로도 충분하다.
                if (__system.keys[keyv].cmpxchgWeak(false, true, .monotonic, .monotonic) == null) {
                    //xfit.print_debug("input key_down {d}", .{wParam});
                    system.a_fn_call(__system.key_down_func, .{key}) catch {};
                }
            },
            c.KeyRelease => {
                const keyr = c.XLookupKeysym(&event.xkey, 0);
                if (keyr > 0xffff) continue;
                var keyv: u16 = @intCast(keyr);
                const key: input.key = @enumFromInt(keyv);
                if (keyv > 0xff and keyv < 0xff00) {
                    @branchHint(.cold);
                    xfit.print("WARN linux_loop KeyRelease out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keyv });
                    continue;
                } else if (keyv >= 0xff00) {
                    keyv = keyv - 0xff00 + 0xff;
                }
                __system.keys[keyv].store(false, std.builtin.AtomicOrder.monotonic);
                //xfit.print_debug("input key_up {d}", .{wParam});
                system.a_fn_call(__system.key_up_func, .{key}) catch {};
            },
            else => {},
        }
    }
}

pub fn linux_close() void {
    var event: c.XEvent = undefined;
    event.xclient.type = c.ClientMessage;
    event.xclient.window = wnd;
    event.xclient.message_type = c.XInternAtom(display, "WM_PROTOCOLS", 1);
    event.xclient.format = 32;
    event.xclient.data.l[0] = @intCast(c.XInternAtom(display, "WM_DELETE_WINDOW", 0));
    event.xclient.data.l[1] = c.CurrentTime;
    _ = c.XSendEvent(display, wnd, c.False, c.NoEventMask, &event);
}

pub fn linux_destroy() void {
    input_thread.join();
    _ = c.XDestroyWindow(display, wnd);
    _ = c.XCloseDisplay(display);

    std.heap.c_allocator.free(screens);
}
