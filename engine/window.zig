const std = @import("std");

const builtin = @import("builtin");

const system = @import("system.zig");
const __system = @import("__system.zig");
const __windows = @import("__windows.zig");
const __android = @import("__android.zig");
const math = @import("math.zig");

pub const window_state = enum {
    Restore,
    Maximized,
    Minimized,
};

pub const window_show = enum(i32) {
    NORMAL = __windows.win32.SW_NORMAL,
    DEFAULT = __windows.win32.SW_SHOWDEFAULT,
    MAXIMIZE = __windows.win32.SW_MAXIMIZE,
    MINIMIZE = __windows.win32.SW_MINIMIZE,
};

pub const screen_orientation = enum {
    unknown,
    landscape90,
    landscape270,
    vertical180,
    vertical360,
};

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
    if (system.platform == .windows) {
        return @atomicLoad(i32, &__system.init_set.window_x, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN window_x not support mobile platform.\n", .{});
        return 0;
    }
    @compileError("not support platform.");
}
pub fn window_y() i32 {
    if (system.platform == .windows) {
        return @atomicLoad(i32, &__system.init_set.window_y, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN window_y not support mobile platform.\n", .{});
        return 0;
    }
    @compileError("not support platform.");
}
pub fn can_maximize() bool {
    if (system.platform == .windows) {
        return @atomicLoad(bool, &__system.init_set.can_maximize, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN can_maximize not support mobile platform.\n", .{});
        return false;
    }
    @compileError("not support platform.");
}
pub fn can_minimize() bool {
    if (system.platform == .windows) {
        return @atomicLoad(bool, &__system.init_set.can_minimize, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN can_minimize not support mobile platform.\n", .{});
        return false;
    }
    @compileError("not support platform.");
}
pub fn can_resizewindow() bool {
    if (system.platform == .windows) {
        return @atomicLoad(bool, &__system.init_set.can_resizewindow, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN can_resizewindow not support mobile platform.\n", .{});
        return false;
    }
    @compileError("not support platform.");
}
pub fn get_screen_mode() system.screen_mode {
    if (system.platform == .windows) {
        return @atomicLoad(system.screen_mode, &__system.init_set.screen_mode, std.builtin.AtomicOrder.monotonic);
    } else if (system.platform == .android) {
        system.print("WARN get_screen_mode not support mobile platform.\n", .{});
        return system.screen_mode.WINDOW;
    }
    @compileError("not support platform.");
}

pub fn get_window_title() []const u8 {
    return __system.title[0 .. __system.title.len - 1];
}
pub fn set_window_title(title: []const u8) void {
    __system.allocator.free(__system.title);
    title = __system.allocator.dupeZ(u8, title) catch |e| system.handle_error3("set_window_title.title = allocator.dupeZ", e);

    __windows.set_window_title();
}

pub fn set_window_size(w: u32, h: u32) void {
    if (system.platform == .windows) {
        __windows.set_window_size(w, h);
    } else {
        system.print_error("WARN window.set_window_size not support mobile platform.\n", .{});
        return;
    }
}
pub fn set_window_pos(x: i32, y: i32) void {
    if (system.platform == .windows) {
        __windows.set_window_pos(x, y);
    } else {
        system.print_error("WARN window.set_window_pos not support mobile platform.\n", .{});
        return;
    }
    @atomicStore(i32, &__system.init_set.window_x, __system.prev_window.x, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_y, __system.prev_window.y, std.builtin.AtomicOrder.monotonic);
}

pub fn set_window_mode() void {
    if (system.platform == .windows) {
        __windows.set_window_mode();
    } else {
        system.print_error("WARN window.set_window_mode not support mobile platform.\n", .{});
        return;
    }
    @atomicStore(system.screen_mode, &__system.init_set.screen_mode, system.screen_mode.WINDOW, std.builtin.AtomicOrder.monotonic);
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
}
pub fn set_window_mode2(pos: math.point(i32), size: math.point(u32), state: system.window_state, _can_maximize: bool, _can_minimize: bool, _can_resizewindow: bool) void {
    if (system.platform == .windows) {
        __windows.set_window_mode2(pos, size, state, state, _can_maximize, _can_minimize, _can_resizewindow);
    } else {
        system.print_error("WARN monitor_info.set_window_mode not support mobile platform.\n", .{});
        return;
    }
    @atomicStore(system.screen_mode, &__system.init_set.screen_mode, system.screen_mode.WINDOW, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_maximize, _can_maximize, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_minimize, _can_minimize, std.builtin.AtomicOrder.monotonic);
    @atomicStore(bool, &__system.init_set.can_resizewindow, _can_resizewindow, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_x, pos.x, std.builtin.AtomicOrder.monotonic);
    @atomicStore(i32, &__system.init_set.window_y, pos.y, std.builtin.AtomicOrder.monotonic);

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
