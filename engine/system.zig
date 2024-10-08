const std = @import("std");
const builtin = @import("builtin");

const ArrayList = std.ArrayList;

const root = @import("root");

const __android = @import("__android.zig");
const __windows = @import("__windows.zig");
const window = @import("window.zig");
const __vulkan = @import("__vulkan.zig");
const __system = @import("__system.zig");
const math = @import("math.zig");
const file = @import("file.zig");
const datetime = @import("datetime.zig");

pub const windows = __windows.win32;
pub const android = __android.android;
pub const vulkan = __vulkan.vk;

pub const dbg = builtin.mode == .Debug;

pub const vulkan_ext = struct {
    pub const vkCreateDebugUtilsMessengerEXT = __vulkan.vkCreateDebugUtilsMessengerEXT;
    pub const vkDestroyDebugUtilsMessengerEXT = __vulkan.vkDestroyDebugUtilsMessengerEXT;
};

pub const screen_mode = enum { WINDOW, BORDERLESSSCREEN, FULLSCREEN };

pub inline fn get_processor_core_len() u32 {
    return __system.processor_core_len;
}

pub inline fn pause() bool {
    return __system.pause.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn activated() bool {
    return __system.activated.load(std.builtin.AtomicOrder.monotonic);
}

pub inline fn exiting() bool {
    return __system.exiting.load(std.builtin.AtomicOrder.monotonic);
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

    platform: XfitPlatform,
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

pub const platform = @import("build_options").platform;
pub const XfitPlatform = @TypeOf(platform);

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

    name: [32]u8 = std.mem.zeroes([32]u8),

    fn save_prev_window_state() void {
        if (__system.init_set.screen_mode == .WINDOW) {
            __system.prev_window = .{
                .x = window.window_x(),
                .y = window.window_y(),
                .width = window.window_width(),
                .height = window.window_height(),
                .state = if (platform == .windows) __windows.get_window_state() else window.window_state.Restore,
            };
        }
    }

    pub fn set_fullscreen_mode(self: Self, resolution: *screen_info) void {
        save_prev_window_state();
        if (platform == .windows) {
            __windows.set_fullscreen_mode(&self, resolution);
            @atomicStore(screen_mode, &__system.init_set.screen_mode, screen_mode.FULLSCREEN, std.builtin.AtomicOrder.monotonic);
        } else {
            @compileError("not support platform");
        }
    }
    pub fn set_borderlessscreen_mode(self: Self) void {
        save_prev_window_state();
        if (platform == .windows) {
            __windows.set_borderlessscreen_mode(&self);
            @atomicStore(screen_mode, &__system.init_set.screen_mode, screen_mode.BORDERLESSSCREEN, std.builtin.AtomicOrder.monotonic);
        } else {
            @compileError("not support platform");
        }
    }
};

///_int * 1000000000 + _dec
pub inline fn sec_to_nano_sec(_int: anytype, _dec: anytype) u64 {
    return @intCast(_int * 1000000000 + _dec);
}

pub inline fn sec_to_nano_sec2(_sec: anytype, _milisec: anytype, _usec: anytype, _nsec: anytype) u64 {
    return @intCast(_sec * 1000000000 + _milisec * 1000000 + _usec * 1000 + _nsec);
}

pub const init_setting = struct {
    pub const DEF_POS_SIZE = __windows.CW_USEDEFAULT;
    pub const PRIMARY_SCREEN_INDEX = std.math.maxInt(u32);
    //*ignore field mobile
    window_width: i32 = DEF_POS_SIZE,
    window_height: i32 = DEF_POS_SIZE,
    window_x: i32 = DEF_POS_SIZE,
    window_y: i32 = DEF_POS_SIZE,

    window_show: window.window_show = window.window_show.DEFAULT,
    screen_mode: screen_mode = screen_mode.WINDOW,
    screen_index: u32 = PRIMARY_SCREEN_INDEX,

    can_maximize: bool = true,
    can_minimize: bool = true,
    can_resizewindow: bool = true,
    use_console: bool = if (dbg) true else false,

    window_title: []const u8 = "Xfit",
    icon: ?[]const u8 = null,
    cursor: ?[]const u8 = null,
    //*

    ///nanosec 단위 1프레임당 1sec = 1000000000 nanosec
    maxframe: u64 = 0,
    refleshrate: u32 = 0,
    vSync: bool = true,
};

pub inline fn monitors() []const monitor_info {
    return __windows.monitors.items;
}
pub inline fn primary_monitor() *const monitor_info {
    return __system.primary_monitor;
}

///nanosec 1 / 1000000000 sec
pub inline fn dt_i64() u64 {
    return __system.delta_time;
}
pub inline fn dt() f64 {
    return @as(f64, @floatFromInt(__system.delta_time)) / 1000000000.0;
}

///nanosec 1 / 1000000000 sec
pub inline fn get_maxframe_u64() u64 {
    return @atomicLoad(u64, &__system.init_set.maxframe, std.builtin.AtomicOrder.monotonic);
}
pub inline fn get_maxframe() f64 {
    return @as(f64, @floatFromInt(get_maxframe_u64())) / 1000000000.0;
}
///nanosec 1 / 1000000000 sec
pub inline fn set_maxframe_u64(_maxframe: u64) void {
    @atomicStore(u64, &__system.init_set.maxframe, _maxframe, std.builtin.AtomicOrder.monotonic);
}

pub inline fn get_platform_version() *const platform_version {
    return &__system.platform_ver;
}
pub fn print(comptime fmt: []const u8, args: anytype) void {
    if (platform != .android) {
        std.debug.print(fmt, args);
    } else {
        const str = std.fmt.allocPrint(__system.allocator, fmt ++ " ", args) catch unreachable2();
        defer __system.allocator.free(str);

        str[str.len - 1] = 0;
        _ = __android.LOGV(str.ptr, .{});
    }
}
pub fn print_with_time(comptime fmt: []const u8, args: anytype) void {
    const now_str = datetime.Datetime.now().formatHttp(__system.allocator) catch unreachable2();
    defer __system.allocator.free(now_str);

    print("{s} @ " ++ fmt, .{now_str} ++ args);
}
pub fn print_debug_with_time(comptime fmt: []const u8, args: anytype) void {
    const now_str = datetime.Datetime.now().formatHttp(__system.allocator) catch unreachable2();
    defer __system.allocator.free(now_str);

    print_debug("{s} @ " ++ fmt, .{now_str} ++ args);
}
pub fn notify() void {
    if (platform == .windows) {
        _ = __windows.win32.FlashWindow(__windows.hWnd, __windows.TRUE);
    } else {
        @compileError("not support platform");
    }
}
pub fn text_notify(text: []const u8) void {
    _ = text;
    if (platform == .windows) {
        //TODO 윈도우즈 텍스트 알림 구현
    } else if (platform == .android) {
        //TODO 안드로이드 텍스트 알림 구현
    } else {
        @compileError("not support platform");
    }
}

pub fn print_debug(comptime fmt: []const u8, args: anytype) void {
    if (dbg) {
        if (platform != .android) {
            std.log.debug(fmt, args);
        } else {
            const str = std.fmt.allocPrint(__system.allocator, fmt ++ " ", args) catch {
                unreachable2();
            };
            defer __system.allocator.free(str);

            str[str.len - 1] = 0;
            _ = __android.LOGD(str.ptr, .{});
        }
    }
}

pub fn print_error(comptime fmt: []const u8, args: anytype) void {
    @branchHint(.cold);
    const now_str = datetime.Datetime.now().formatHttp(__system.allocator) catch unreachable2();
    defer __system.allocator.free(now_str);

    // var fs: file = .{};
    // defer fs.close();
    const debug_info = std.debug.getSelfDebugInfo() catch unreachable2();
    if (platform != .android) {
        const str = std.fmt.allocPrint(__system.allocator, "{s} @ " ++ fmt, .{now_str} ++ args) catch unreachable2();
        defer __system.allocator.free(str);

        var str2 = ArrayList(u8).init(__system.allocator);
        defer str2.deinit();
        std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch unreachable2();
        std.debug.print("{s}\n{s}", .{ str, str2.items });

        if (a_fn(__system.error_handling_func) != null) a_fn(__system.error_handling_func).?(str, str2.items);
        // fs.open("xfit_err.log", .{ .truncate = false }) catch fs.open("xfit_err.log", .{ .exclusive = true }) catch unreachable2();
    } else {
        const str = std.fmt.allocPrint(__system.allocator, "{s} @ " ++ fmt ++ " ", .{now_str} ++ args) catch unreachable2();
        defer __system.allocator.free(str);

        // const path = std.fmt.allocPrint(__system.allocator, "{s}/xfit_err.log" ++ fmt, .{__android.get_file_dir()} ++ args) catch unreachable2();
        // defer __system.allocator.free(path);

        // fs.open(path, .{ .truncate = false }) catch fs.open(path, .{ .exclusive = true }) catch unreachable2();

        str[str.len - 1] = 0;
        _ = __android.LOGE(str.ptr, .{});

        var str2 = ArrayList(u8).init(__system.allocator);
        defer str2.deinit();

        std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch unreachable2();
        str2.append(0) catch unreachable2();
        _ = __android.LOGE(str2.items.ptr, .{});

        if (a_fn(__system.error_handling_func) != null) a_fn(__system.error_handling_func).?(str, str2.items);
    }
    // fs.seekFromEnd(0) catch unreachable2();
    // _ = fs.write(str) catch unreachable2();

    // std.debug.writeCurrentStackTrace(fs.writer(), debug_info, std.io.tty.detectConfig(fs.hFile), @returnAddress()) catch unreachable2();

    // _ = fs.write("\n") catch unreachable2();
}

pub inline fn set_error_handling_func(_func: *const fn (text: []u8, stack_trace: []u8) void) void {
    @atomicStore(@TypeOf(__system.error_handling_func), &__system.error_handling_func, _func, std.builtin.AtomicOrder.monotonic);
}

pub inline fn unreachable2() void {
    if (platform == .android) {
        std.c.abort();
        return;
    }
    if (builtin.mode == std.builtin.OptimizeMode.Debug or builtin.mode == std.builtin.OptimizeMode.ReleaseSafe) {
        unreachable;
    } else {
        std.process.abort();
    }
}

pub inline fn handle_error_msg(errtest: bool, msg: []const u8) void {
    if (!errtest) {
        print_error("ERR {s}\n", .{msg});
        unreachable;
    }
}
pub inline fn handle_error_msg2(msg: []const u8) void {
    print_error("ERR {s}\n", .{msg});
    unreachable;
}

pub inline fn handle_error2(comptime fmt: []const u8, args: anytype) void {
    print_error("ERR " ++ fmt ++ "\n", args);
    unreachable;
}

pub inline fn handle_error(errtest: bool, comptime fmt: []const u8, args: anytype) void {
    if (!errtest) {
        print_error("ERR " ++ fmt ++ "\n", args);
        unreachable;
    }
}

pub inline fn handle_error3(funcion_name: []const u8, err: anytype) void {
    print_error("ERR {s} {s}\n", .{ funcion_name, @errorName(err) });
    unreachable;
}

pub inline fn sleep(ns: u64) void {
    if (platform == .windows) {
        __windows.nanosleep(ns);
    } else {
        std.time.sleep(ns);
    }
}
