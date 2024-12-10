const std = @import("std");
const builtin = @import("builtin");

const ArrayList = std.ArrayList;

const root = @import("root");

const xfit = @import("xfit.zig");

const __windows = if (xfit.platform == .windows) @import("__windows.zig") else void;
const __android = if (xfit.platform == .android) @import("__android.zig") else void;
const __linux = @import("__linux.zig");
const window = @import("window.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");
const __system = @import("__system.zig");
const math = @import("math.zig");
const file = @import("file.zig");
const datetime = @import("datetime.zig");

pub const windows = if (xfit.platform == .windows) __windows.win32 else void;
pub const android = if (xfit.platform == .android) __android.android else void;
pub const vulkan = __vulkan.vk;

pub inline fn get_processor_core_len() u32 {
    return __system.processor_core_len;
}

pub inline fn a_load(value: anytype) @TypeOf(value) {
    return @atomicLoad(@TypeOf(value), &value, std.builtin.AtomicOrder.monotonic);
}
pub inline fn a_fn(func: anytype) @TypeOf(func) {
    return @atomicLoad(@TypeOf(func), &func, std.builtin.AtomicOrder.monotonic);
}

pub const a_fn_error = error{null_func};

fn a_fn_call_return_type(func_type: type) type {
    if (@typeInfo(func_type) == .optional) {
        const child = @typeInfo(@typeInfo(func_type).optional.child);
        if (child == .pointer) {
            return @typeInfo(child.pointer.child).@"fn".return_type.?;
        }
        return child.@"fn".return_type.?;
    } else if (@typeInfo(func_type) == .pointer) {
        return @typeInfo(@typeInfo(func_type).pointer.child).@"fn".return_type.?;
    }
    return @typeInfo(func_type).@"fn".return_type.?;
}

pub inline fn a_fn_call(func: anytype, args: anytype) a_fn_error!a_fn_call_return_type(@TypeOf(func)) {
    const res = a_fn(func);
    if (@typeInfo(@TypeOf(res)) == .optional) {
        if (res == null) return a_fn_error.null_func;
        return @call(.auto, res.?, args);
    }
    return @call(.auto, res, args);
}

pub const platform_version = struct {
    pub const android_api_level = enum(u32) {
        Nougat = 24,
        Nougat_MR1 = 25,
        Oreo = 26,
        Oreo_MR1 = 27,
        Pie = 28,
        Q = 29,
        R = 30,
        S = 31,
        S_V2 = 32,
        Tiramisu = 33,
        UpsideDownCake = 34,
        VanillaIceCream = 35,
        Unknown = 0,
        _,
    };
    pub const windows_version = enum {
        Windows7,
        WindowsServer2008R2,
        Windows8,
        WindowsServer2012,
        Windows8Point1,
        WindowsServer2012R2,
        Windows10,
        WindowsServer2016,
        Windows11,
        WindowsServer2019,
        WindowsServer2022,
        Unknown,
    };

    platform: xfit.XfitPlatform,
    version: union {
        windows: struct {
            version: windows_version,
            build_number: u32,
            service_pack: u32,
        },
        android: struct {
            api_level: android_api_level,
        },
    },
};

pub const screen_info = struct {
    monitor: *monitor_info,
    size: math.pointu,
    refleshrate: f64,
};

pub const monitor_info = struct {
    const Self = @This();
    rect: math.recti,

    is_primary: bool,
    resolution: screen_info = undefined,
    __hmonitor: if (xfit.platform == .windows) windows.HMONITOR else void = if (xfit.platform == .windows) undefined else {},

    name: []const u8 = undefined,

    pub fn set_fullscreen_mode(self: Self) void {
        if (window.get_screen_mode() == .FULLSCREEN or __system.size_update.load(.acquire)) return;
        __vulkan.fullscreen_mutex.lock();
        defer __vulkan.fullscreen_mutex.unlock();

        __system.save_prev_window_state();
        if (xfit.platform == .windows) {
            __windows.set_fullscreen_mode(&self);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.FULLSCREEN, std.builtin.AtomicOrder.monotonic);
            __system.size_update.store(true, .release);
        } else if (xfit.platform == .linux) {
            __linux.set_fullscreen_mode(&self);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.FULLSCREEN, std.builtin.AtomicOrder.monotonic);
            __system.size_update.store(true, .release);
        }
    }
    pub fn set_borderlessscreen_mode(self: Self) void {
        if (window.get_screen_mode() == .BORDERLESSSCREEN or __system.size_update.load(.acquire)) return;
        __vulkan.fullscreen_mutex.lock();
        defer __vulkan.fullscreen_mutex.unlock();

        __system.save_prev_window_state();
        if (xfit.platform == .windows) {
            __windows.set_borderlessscreen_mode(&self);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.BORDERLESSSCREEN, std.builtin.AtomicOrder.monotonic);
            __system.size_update.store(true, .release);
        } else if (xfit.platform == .linux) {
            __linux.set_borderlessscreen_mode(&self);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.BORDERLESSSCREEN, std.builtin.AtomicOrder.monotonic);
            __system.size_update.store(true, .release);
        } else {}
    }
};

pub inline fn monitors() []const monitor_info {
    return __system.monitors.items;
}
pub inline fn primary_monitor() *const monitor_info {
    return __system.primary_monitor;
}
pub inline fn current_monitor() ?*const monitor_info {
    return __system.current_monitor;
}

pub inline fn get_platform_version() *const platform_version {
    return &__system.platform_ver;
}

pub fn notify() void {
    if (xfit.platform == .windows) {
        _ = __windows.win32.FlashWindow(__windows.hWnd, __windows.TRUE);
    } else {
        if (!xfit.__xfit_test) @compileError("not support platform");
    }
}
pub fn text_notify(text: []const u8) void {
    _ = text;
    if (xfit.platform == .windows) {
        //TODO implement windows text notification
    } else if (xfit.platform == .android) {
        //TODO implement android text notification
    } else if (xfit.platform == .linux) {
        //TODO implement linux text notification
    } else {
        @compileError("not support platform");
    }
}

pub fn set_execute_all_cmd_per_update(_on_off: bool) void {
    __vulkan_allocator.execute_all_cmd_per_update.store(_on_off, .monotonic);
}
pub fn get_execute_all_cmd_per_update() bool {
    return __vulkan_allocator.execute_all_cmd_per_update.load(.monotonic);
}
