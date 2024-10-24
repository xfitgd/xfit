const std = @import("std");
const builtin = @import("builtin");

const ArrayList = std.ArrayList;

const root = @import("root");

const xfit = @import("xfit.zig");
const __android = @import("__android.zig");
const __windows = @import("__windows.zig");
const window = @import("window.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");
const __system = @import("__system.zig");
const math = @import("math.zig");
const file = @import("file.zig");
const datetime = @import("datetime.zig");

pub const windows = __windows.win32;
pub const android = __android.android;
pub const vulkan = __vulkan.vk;

pub inline fn get_processor_core_len() u32 {
    return __system.processor_core_len;
}

pub inline fn a_fn(func: anytype) @TypeOf(func) {
    return @atomicLoad(@TypeOf(func), &func, std.builtin.AtomicOrder.monotonic);
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
    refleshrate: u32,
};

pub const monitor_info = struct {
    const Self = @This();
    rect: math.recti,

    is_primary: bool,
    primary_resolution: ?*screen_info = null,
    resolutions: ArrayList(screen_info),
    __hmonitor: if (xfit.platform == .windows) windows.HMONITOR else void = if (xfit.platform == .windows) undefined else {},

    name: [32]u8 = std.mem.zeroes([32]u8),

    fn save_prev_window_state() void {
        if (__system.init_set.screen_mode == .WINDOW) {
            __system.prev_window = .{
                .x = window.window_x(),
                .y = window.window_y(),
                .width = window.window_width(),
                .height = window.window_height(),
                .state = if (xfit.platform == .windows) __windows.get_window_state() else window.window_state.Restore,
            };
        }
    }

    pub fn set_fullscreen_mode(self: Self, resolution: *const screen_info) void {
        save_prev_window_state();
        if (xfit.platform == .windows) {
            __windows.set_fullscreen_mode(&self, resolution);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.FULLSCREEN, std.builtin.AtomicOrder.monotonic);
        } else {}
    }
    pub fn set_borderlessscreen_mode(self: Self) void {
        save_prev_window_state();
        if (xfit.platform == .windows) {
            __windows.set_borderlessscreen_mode(&self);
            @atomicStore(xfit.screen_mode, &__system.init_set.screen_mode, xfit.screen_mode.BORDERLESSSCREEN, std.builtin.AtomicOrder.monotonic);
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
pub inline fn current_resolution() ?*const screen_info {
    return __system.current_resolution;
}

pub inline fn get_platform_version() *const platform_version {
    return &__system.platform_ver;
}

pub fn notify() void {
    if (xfit.platform == .windows) {
        _ = __windows.win32.FlashWindow(__windows.hWnd, __windows.TRUE);
    } else {
        @compileError("not support platform");
    }
}
pub fn text_notify(text: []const u8) void {
    _ = text;
    if (xfit.platform == .windows) {
        //TODO 윈도우즈 텍스트 알림 구현
    } else if (xfit.platform == .android) {
        //TODO 안드로이드 텍스트 알림 구현
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
