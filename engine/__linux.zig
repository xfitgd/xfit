const std = @import("std");
const xfit = @import("xfit.zig");
const system = @import("system.zig");
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
pub var window: c.Window = 0;
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

    window = c.XCreateWindow(
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
    _ = c.XSelectInput(display, window, c.KeyPressMask | c.KeyReleaseMask);
    _ = c.XMapWindow(display, window);
    del_window = c.XInternAtom(display, "WM_DELETE_WINDOW", 0);
    _ = c.XSetWMProtocols(display, window, &del_window, 1);
    _ = c.XFlush(display);

    input_thread = std.Thread.spawn(.{}, render_func, .{}) catch unreachable;
}

pub fn vulkan_linux_start(vkSurface: *__vulkan.vk.SurfaceKHR) void {
    __vulkan.load_instance_and_device();
    if (vkSurface.* != .null_handle) {
        __vulkan.vki.?.destroySurfaceKHR(vkSurface.*, null);
    }
    const xlibSurfaceCreateInfo: __vulkan.vk.XlibSurfaceCreateInfoKHR = .{
        .window = window,
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
            c.ClientMessage => {
                if (event.xclient.data.l[0] == del_window) {
                    __system.exiting.store(true, std.builtin.AtomicOrder.release);
                    return;
                }
            },
            c.KeyPress => {
                system.a_fn_call(__system.key_down_func, .{@as(input.key, @enumFromInt(@as(u16, @intCast(c.XLookupKeysym(&event.xkey, 0)))))}) catch {};
            },
            else => {},
        }
    }
}

pub fn linux_close() void {
    var event: c.XEvent = undefined;
    event.xclient.type = c.ClientMessage;
    event.xclient.window = window;
    event.xclient.message_type = c.XInternAtom(display, "WM_PROTOCOLS", 1);
    event.xclient.format = 32;
    event.xclient.data.l[0] = @intCast(c.XInternAtom(display, "WM_DELETE_WINDOW", 0));
    event.xclient.data.l[1] = c.CurrentTime;
    _ = c.XSendEvent(display, window, c.False, c.NoEventMask, &event);
}

pub fn linux_destroy() void {
    input_thread.join();
    _ = c.XDestroyWindow(display, window);
    _ = c.XCloseDisplay(display);

    std.heap.c_allocator.free(screens);
}
