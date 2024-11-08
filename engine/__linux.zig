const std = @import("std");
const xfit = @import("xfit.zig");
const system = @import("system.zig");
const __system = @import("__system.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");

pub const c = @cImport({
    @cInclude("X11/Xlib.h");
    @cInclude("linux/input.h");
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

fn input_func() void {
    //var ring = std.os.linux.IoUring.init(32, 0) catch |e| xfit.herr3("input_func IoUring.init", e);

    while (!xfit.exiting()) {}
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
    _ = c.XMapWindow(display, window);
    del_window = c.XInternAtom(display, "WM_DELETE_WINDOW", 0);
    _ = c.XSetWMProtocols(display, window, &del_window, 1);
    _ = c.XFlush(display);

    input_thread = std.Thread.spawn(.{}, input_func, .{});
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
    __vulkan_allocator.execute_and_wait_all_op();

    var event: c.XEvent = undefined;
    while (true) {
        while (0 < c.XPending(display)) {
            _ = c.XNextEvent(display, &event);
            switch (event.type) {
                c.ClientMessage => {
                    if (event.xclient.data.l[0] == del_window) {
                        __system.exiting.store(true, std.builtin.AtomicOrder.release);
                        _ = c.XDestroyWindow(event.xclient.display, event.xclient.window);
                        return;
                    }
                },
                else => {},
            }
        }

        __system.loop();
    }
    __vulkan_allocator.execute_and_wait_all_op();

    __vulkan.wait_device_idle();
}

pub fn linux_destroy() void {
    input_thread.join();

    _ = c.XCloseDisplay(display);
    std.heap.c_allocator.free(screens);
}
