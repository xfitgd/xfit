const std = @import("std");

const builtin = @import("builtin");

const system = @import("system.zig");
const __system = @import("__system.zig");
const __linux = @import("__linux.zig");
const __vulkan = @import("__vulkan.zig");
const math = @import("math.zig");

const xfit = @import("xfit.zig");

const __windows = if (xfit.platform == .windows) @import("__windows.zig") else void;
const __android = if (xfit.platform == .android) @import("__android.zig") else void;

pub const window_state = enum(i32) {
    Restore = if (xfit.platform == .windows) __windows.win32.SW_NORMAL else 1,
    Maximized = if (xfit.platform == .windows) __windows.win32.SW_MAXIMIZE else 3,
    Minimized = if (xfit.platform == .windows) __windows.win32.SW_MINIMIZE else 6,
};

pub const window_show = enum(i32) {
    NORMAL = if (xfit.platform == .windows) __windows.win32.SW_NORMAL else 1,
    DEFAULT = if (xfit.platform == .windows) __windows.win32.SW_SHOWDEFAULT else 10,
    MAXIMIZE = if (xfit.platform == .windows) __windows.win32.SW_MAXIMIZE else 3,
    MINIMIZE = if (xfit.platform == .windows) __windows.win32.SW_MINIMIZE else 6,
};

pub const screen_orientation = enum {
    unknown,
    landscape90,
    landscape270,
    vertical180,
    vertical360,
};

pub inline fn get_monitor_from_window() *const system.monitor_info {
    if (xfit.platform == .windows) return __windows.get_monitor_from_window();
    if (xfit.platform == .linux) return __linux.get_monitor_from_window();
    return system.primary_monitor();
}

pub fn get_screen_orientation() screen_orientation {
    return @atomicLoad(screen_orientation, &__system.__screen_orientation, std.builtin.AtomicOrder.monotonic);
}

pub fn window_width() u32 {
    return @atomicLoad(u32, &__system.init_set.window_width, std.builtin.AtomicOrder.monotonic);
}
pub fn window_height() u32 {
    return @atomicLoad(u32, &__system.init_set.window_height, std.builtin.AtomicOrder.monotonic);
}
pub fn window_x() i32 {
    if (xfit.is_mobile) {
        return 0;
    }
    return @atomicLoad(i32, &__system.init_set.window_x, std.builtin.AtomicOrder.monotonic);
}
pub fn window_y() i32 {
    if (xfit.is_mobile) {
        return 0;
    }
    return @atomicLoad(i32, &__system.init_set.window_y, std.builtin.AtomicOrder.monotonic);
}
pub fn can_maximize() bool {
    if (xfit.is_mobile) {
        return false;
    }
    return @atomicLoad(bool, &__system.init_set.can_maximize, std.builtin.AtomicOrder.monotonic);
}
pub fn can_minimize() bool {
    if (xfit.is_mobile) {
        return false;
    }
    return @atomicLoad(bool, &__system.init_set.can_minimize, std.builtin.AtomicOrder.monotonic);
}
pub fn can_resizewindow() bool {
    if (xfit.is_mobile) {
        return false;
    }
    return @atomicLoad(bool, &__system.init_set.can_resizewindow, std.builtin.AtomicOrder.monotonic);
}
pub fn get_screen_mode() xfit.screen_mode {
    if (xfit.is_mobile) {
        return xfit.screen_mode.WINDOW;
    }
    return @atomicLoad(xfit.screen_mode, &__system.init_set.screen_mode, std.builtin.AtomicOrder.monotonic);
}

pub fn get_window_title() []const u8 {
    return __system.title[0 .. __system.title.len - 1];
}
pub fn set_window_title(title: []const u8) void {
    std.heap.c_allocator.free(__system.title);
    __system.title = std.heap.c_allocator.dupeZ(u8, title) catch |e| xfit.herr3("set_window_title.title = allocator.dupeZ", e);

    if (xfit.platform == .windows) {
        __windows.set_window_title();
    } else if (xfit.platform == .linux) {
        //TODO
    }
}

pub fn set_window_size(w: u32, h: u32) void {
    if (get_screen_mode() != .WINDOW or __system.size_update.load(.acquire)) return;
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    if (xfit.platform == .windows) {
        __windows.set_window_size(w, h);
    } else if (xfit.platform == .linux) {
        __linux.set_window_size(w, h);
    } else {
        return;
    }
}
pub fn set_window_pos(x: i32, y: i32) void {
    if (get_screen_mode() != .WINDOW or __system.size_update.load(.acquire)) return;
    if (xfit.platform == .windows) {
        __windows.set_window_pos(x, y);
    } else if (xfit.platform == .linux) {
        __linux.set_window_pos(x, y);
    } else {
        return;
    }
    @atomicStore(i32, &__system.init_set.window_x, __system.prev_window.x, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_y, __system.prev_window.y, std.builtin.AtomicOrder.monotonic);
}

pub fn set_window_mode() void {
    if (get_screen_mode() == .WINDOW or __system.size_update.load(.acquire)) return;
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();

    if (xfit.platform == .windows) {
        __windows.set_window_mode();
    } else if (xfit.platform == .linux) {
        __linux.set_window_mode();
    } else {
        return;
    }
    @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.WINDOW, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_x, __system.prev_window.x, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_y, __system.prev_window.y, std.builtin.AtomicOrder.monotonic);

    switch (__system.prev_window.state) {
        .Restore => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.NORMAL, std.builtin.AtomicOrder.monotonic);
        },
        .Maximized => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.MAXIMIZE, std.builtin.AtomicOrder.monotonic);
        },
        .Minimized => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.MINIMIZE, std.builtin.AtomicOrder.monotonic);
        },
    }
    __system.size_update.store(true, .release);
}
pub fn set_window_mode2(pos: math.point_(i32), size: math.point_(u32), state: window_state, _can_maximize: bool, _can_minimize: bool, _can_resizewindow: bool) void {
    if (__system.size_update.load(.acquire)) return;
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    if (xfit.platform == .windows) {
        __windows.set_window_mode2(pos, size, state, state, _can_maximize, _can_minimize, _can_resizewindow);
    } else if (xfit.platform == .linux) {
        //TODO _can_maximize, _can_minimize will be supported later(?)
        __linux.set_window_mode2(pos, size, state, _can_maximize, _can_minimize, _can_resizewindow);
    } else {
        return;
    }
    @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.WINDOW, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_maximize, _can_maximize, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_minimize, _can_minimize, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_resizewindow, _can_resizewindow, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_x, pos[0], std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_y, pos[1], std.builtin.AtomicOrder.monotonic);

    switch (state) {
        .Restore => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.NORMAL, std.builtin.AtomicOrder.monotonic);
        },
        .Maximized => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.MAXIMIZE, std.builtin.AtomicOrder.monotonic);
        },
        .Minimized => {
            @atomicStore(window_show, &__system.init_set.window_show, window_show.MINIMIZE, std.builtin.AtomicOrder.monotonic);
        },
    }
}
pub inline fn set_window_move_func(_func: *const fn () void) void {
    @atomicStore(@TypeOf(__system.window_move_func), &__system.window_move_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_window_size_func(_func: *const fn () void) void {
    @atomicStore(@TypeOf(__system.window_size_func), &__system.window_size_func, _func, std.builtin.AtomicOrder.monotonic);
}

pub fn get_window_state() window_state {
    if (xfit.platform == .windows) {
        return __windows.get_window_state();
    } else {
        return .Restore;
    }
    return __system.prev_window.state;
}

pub fn get_min_window_width() u32 {
    return @atomicLoad(u32, &__system.init_set.min_window_width, .monotonic);
}
pub fn get_min_window_height() u32 {
    return @atomicLoad(u32, &__system.init_set.min_window_height, .monotonic);
}
pub fn get_max_window_width() u32 {
    return @atomicLoad(u32, &__system.init_set.max_window_width, .monotonic);
}
pub fn get_max_window_height() u32 {
    return @atomicLoad(u32, &__system.init_set.max_window_height, .monotonic);
}
pub fn set_min_window_width(v: u32) void {
    @atomicStore(u32, &__system.init_set.min_window_width, v, .monotonic);
}
pub fn set_min_window_height(v: u32) void {
    @atomicStore(u32, &__system.init_set.min_window_height, v, .monotonic);
}
pub fn set_max_window_width(v: u32) void {
    @atomicStore(u32, &__system.init_set.max_window_width, v, .monotonic);
}
pub fn set_max_window_height(v: u32) void {
    @atomicStore(u32, &__system.init_set.max_window_height, v, .monotonic);
}
