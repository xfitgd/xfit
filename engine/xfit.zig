const std = @import("std");
const root = @import("root");
const builtin = @import("builtin");

pub const system = @import("system.zig");
pub const animator = @import("animator.zig");
pub const asset_file = @import("asset_file.zig");
pub const collision = @import("collision.zig");
pub const components = @import("components.zig");
pub const datetime = @import("datetime.zig");
pub const file = @import("file.zig");
pub const font = @import("font.zig");
pub const general_input = @import("general_input.zig");
pub const geometry = @import("geometry.zig");
pub const graphics = @import("graphics.zig");
pub const image_util = @import("image_util.zig");
pub const lua = @import("lua.zig");
pub const math = @import("math.zig");
pub const raw_input = @import("raw_input.zig");
pub const render_command = @import("render_command.zig");
pub const sound = @import("sound.zig");
pub const timer_callback = @import("timer_callback.zig");
pub const timezones = @import("timezones.zig");
pub const webp = @import("webp.zig");
pub const window = @import("window.zig");
pub const xbox_pad_input = @import("xbox_pad_input.zig");
pub const input = @import("input.zig");
pub const mem = @import("mem.zig");
pub const ini = @import("ini.zig");
pub const s2s = @import("s2s.zig");

//system engine only headers
const __system = @import("__system.zig");
const __windows = @import("__windows.zig");
const __android = @import("__android.zig");
const __vulkan = @import("__vulkan.zig");
const __linux = @import("__linux.zig");

pub const platform = @import("build_options").platform;
pub const subsystem = @import("build_options").subsystem;
pub const XfitPlatform = @TypeOf(platform);
pub const SubSystem = @TypeOf(subsystem);

pub const dbg = builtin.mode == .Debug;
pub const enable_log: bool = @import("build_options").enable_log;

pub const __android_entry = if (platform == .android) __android.android.ANativeActivity_createFunc else {};
//

pub fn xfit_main(_allocator: std.mem.Allocator, _init_setting: *const init_setting) void {
    __system.init(_allocator, _init_setting);

    if (platform == .windows) {
        __windows.system_windows_start();

        if (subsystem == SubSystem.Console) {
            root.xfit_init() catch |e| {
                herr3("xfit_init", e);
            };

            root.xfit_destroy() catch |e| {
                herr3("xfit_destroy", e);
            };
        } else {
            __windows.windows_start();
            //vulkan_start, root.xfit_init()는 별도의 작업 스레드에서 호출(거기서 렌더링)

            __windows.windows_loop();
        }

        __system.destroy();

        root.xfit_clean() catch |e| {
            herr3("xfit_clean", e);
        };

        __system.real_destroy();
    } else if (platform == .android) {
        __vulkan.vulkan_start();

        root.xfit_init() catch |e| {
            herr3("xfit_init", e);
        };
    } else if (platform == .linux) {
        if (subsystem == SubSystem.Console) {
            root.xfit_init() catch |e| {
                herr3("xfit_init", e);
            };

            root.xfit_destroy() catch |e| {
                herr3("xfit_destroy", e);
            };
        } else {
            __linux.system_linux_start();
            __linux.linux_start();

            __linux.linux_loop();

            __linux.linux_destroy();
            __system.destroy();

            root.xfit_clean() catch |e| {
                herr3("xfit_clean", e);
            };

            __system.real_destroy();
        }
    } else {
        @compileError("not support platform");
    }
}

pub inline fn herrm2(errtest: bool, msg: []const u8) void {
    if (!errtest) {
        print_error("ERR {s}\n", .{msg});
        unreachable;
    }
}
pub inline fn herrm(msg: []const u8) void {
    print_error("ERR {s}\n", .{msg});
    unreachable;
}

pub inline fn herr2(comptime fmt: []const u8, args: anytype) void {
    print_error("ERR " ++ fmt ++ "\n", args);
    unreachable;
}

pub inline fn herr(errtest: bool, comptime fmt: []const u8, args: anytype) void {
    if (!errtest) {
        print_error("ERR " ++ fmt ++ "\n", args);
        unreachable;
    }
}

pub inline fn herr3(funcion_name: []const u8, err: anyerror) void {
    print_error("ERR {s} {s}\n", .{ funcion_name, @errorName(err) });
    unreachable;
}

pub fn print_error(comptime fmt: []const u8, args: anytype) void {
    @branchHint(.cold);
    const now_str = datetime.Datetime.now().formatHttp(std.heap.c_allocator) catch return;
    defer std.heap.c_allocator.free(now_str);

    // var fs: file = .{};
    // defer fs.close();
    const debug_info = std.debug.getSelfDebugInfo() catch return;
    if (platform != .android) {
        const str = std.fmt.allocPrint(std.heap.c_allocator, "{s} @ " ++ fmt, .{now_str} ++ args) catch return;
        defer std.heap.c_allocator.free(str);

        var str2 = std.ArrayList(u8).init(std.heap.c_allocator);
        defer str2.deinit();
        std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch return;
        std.debug.print("{s}\n{s}", .{ str, str2.items });

        system.a_fn_call(__system.error_handling_func, .{ str, str2.items }) catch {};
        // fs.open("xfit_err.log", .{ .truncate = false }) catch fs.open("xfit_err.log", .{ .exclusive = true }) catch  return;
    } else {
        const str = std.fmt.allocPrint(std.heap.c_allocator, "{s} @ " ++ fmt ++ " ", .{now_str} ++ args) catch return;
        defer std.heap.c_allocator.free(str);

        // const path = std.fmt.allocPrint(std.heap.c_allocator, "{s}/xfit_err.log" ++ fmt, .{__android.get_file_dir()} ++ args) catch  return;
        // defer std.heap.c_allocator.free(path);

        // fs.open(path, .{ .truncate = false }) catch fs.open(path, .{ .exclusive = true }) catch  return;

        str[str.len - 1] = 0;
        _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_ERROR, "xfit", str.ptr);

        var str2 = std.ArrayList(u8).init(std.heap.c_allocator);
        defer str2.deinit();

        std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch return;
        str2.append(0) catch return;
        _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_ERROR, "xfit", str2.items.ptr);

        system.a_fn_call(__system.error_handling_func, .{ str, str2.items }) catch {};
    }
    // fs.seekFromEnd(0) catch return;
    // _ = fs.write(str) catch return;

    // std.debug.writeCurrentStackTrace(fs.writer(), debug_info, std.io.tty.detectConfig(fs.hFile), @returnAddress()) catch return;

    // _ = fs.write("\n") catch return;
}
pub fn print(comptime fmt: []const u8, args: anytype) void {
    if (platform != .android) {
        std.debug.print(fmt, args);
    } else {
        const str = std.fmt.allocPrint(std.heap.c_allocator, fmt ++ " ", args) catch return;
        defer std.heap.c_allocator.free(str);

        str[str.len - 1] = 0;
        _ = __android.LOGV(str.ptr, .{});
    }
}
pub fn write(_str: []const u8) void {
    if (platform != .android) {
        _ = std.io.getStdOut().write(_str) catch return;
    } else {
        const str = std.heap.c_allocator.dupeZ(u8, _str) catch return;
        defer std.heap.c_allocator.free(str);
        _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_VERBOSE, "xfit", str.ptr);
    }
}
pub inline fn print_log(comptime fmt: []const u8, args: anytype) void {
    if (!enable_log) return;
    print(fmt, args);
}
pub fn write_log(_str: []const u8) void {
    if (!enable_log) return;
    write(_str);
}
pub fn print_with_time(comptime fmt: []const u8, args: anytype) void {
    const now_str = datetime.Datetime.now().formatHttp(std.heap.c_allocator) catch return;
    defer std.heap.c_allocator.free(now_str);

    print("{s} @ " ++ fmt, .{now_str} ++ args);
}
pub fn print_debug_with_time(comptime fmt: []const u8, args: anytype) void {
    if (dbg) {
        const now_str = datetime.Datetime.now().formatHttp(std.heap.c_allocator) catch return;
        defer std.heap.c_allocator.free(now_str);

        print_debug("{s} @ " ++ fmt, .{now_str} ++ args);
    }
}

pub fn print_debug(comptime fmt: []const u8, args: anytype) void {
    if (dbg) {
        if (platform != .android) {
            std.log.debug(fmt, args);
        } else {
            const str = std.fmt.allocPrint(std.heap.c_allocator, fmt ++ " ", args) catch return;
            defer std.heap.c_allocator.free(str);

            str[str.len - 1] = 0;
            _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_DEBUG, "xfit", str.ptr);
        }
    }
}

pub inline fn paused() bool {
    return __system.pause.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn activated() bool {
    return __system.activated.load(std.builtin.AtomicOrder.monotonic);
}

pub inline fn exiting() bool {
    return __system.exiting.load(std.builtin.AtomicOrder.acquire);
}
///nanosec 1 / 1000000000 sec
pub inline fn dt_u64() u64 {
    return @atomicLoad(u64, &__system.delta_time, .monotonic);
}
pub inline fn dt() f64 {
    return @as(f64, @floatFromInt(@atomicLoad(u64, &__system.delta_time, .monotonic))) / 1000000000.0;
}
///nanosec 1 / 1000000000 sec
pub inline fn program_time_u64() u64 {
    return @atomicLoad(u64, &__system.program_time, .monotonic);
}
pub inline fn program_time() f64 {
    return @as(f64, @floatFromInt(@atomicLoad(u64, &__system.program_time, .monotonic))) / 1000000000.0;
}
pub inline fn set_error_handling_func(_func: *const fn (text: []u8, stack_trace: []u8) void) void {
    @atomicStore(@TypeOf(__system.error_handling_func), &__system.error_handling_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn sleep_ex(ns: u64) void {
    if (platform == .windows) {
        __windows.nanosleep(ns);
    } else {
        std.time.sleep(ns);
    }
}
pub fn sleep(ns: u64) void {
    if (platform == .windows) {
        std.os.windows.kernel32.Sleep(@intCast(ns / 1000000));
    } else {
        const s = ns / std.time.ns_per_s;
        const ns_ = ns % std.time.ns_per_s;
        if (builtin.os.tag == .linux) {
            const linux = std.os.linux;

            var req: linux.timespec = .{
                .sec = std.math.cast(linux.time_t, s) orelse std.math.maxInt(linux.time_t),
                .nsec = std.math.cast(linux.time_t, ns_) orelse std.math.maxInt(linux.time_t),
            };
            var rem: linux.timespec = undefined;

            while (true) {
                switch (linux.E.init(linux.clock_nanosleep(.MONOTONIC, .{ .ABSTIME = false }, &req, &rem))) {
                    .SUCCESS => return,
                    .INTR => {
                        req = rem;
                        continue;
                    },
                    .FAULT,
                    .INVAL,
                    .OPNOTSUPP,
                    => unreachable,
                    else => return,
                }
            }
        }
        std.posix.nanosleep(s, ns_);
    }
}

pub inline fn console_pause() void {
    if (platform == .windows) {
        _ = __system._system("pause");
    } else if (platform == .linux) {
        const conio_c = @cImport({
            @cInclude("conio.h");
        });
        write("Press any key to continue...\n");
        _ = conio_c.getch();
    }
}
pub inline fn console_cls() void {
    if (platform == .windows) {
        _ = __system._system("cls");
    } else if (platform == .linux) {
        write("\x1Bc");
    }
}

var exit_mutex: std.Thread.Mutex = .{};
pub fn exit() void {
    exit_mutex.lock();
    defer exit_mutex.unlock();
    if (__system.exiting.load(.acquire)) return;
    if (subsystem == .Console) {
        std.posix.exit(0);
        return;
    }
    if (platform == .windows) {
        __system.exiting.store(true, std.builtin.AtomicOrder.release);
    } else if (platform == .android) {
        __system.exiting.store(true, .release);
        @atomicStore(bool, &__android.app.destroryRequested, true, .monotonic);
    } else if (platform == .linux) {
        __system.exiting.store(true, .release);
        __linux.linux_close();
    }
}

pub const screen_mode = enum { WINDOW, BORDERLESSSCREEN, FULLSCREEN };

pub const vSync_mode = enum { none, double, triple };

pub const init_setting = struct {
    pub const DEF_SIZE = @as(u32, @bitCast(__windows.CW_USEDEFAULT));
    pub const DEF_POS = __windows.CW_USEDEFAULT;
    pub const PRIMARY_SCREEN_INDEX = std.math.maxInt(u32);
    //*ignore field mobile
    window_width: u32 = DEF_SIZE, //or 0
    window_height: u32 = DEF_SIZE,
    window_x: i32 = DEF_POS,
    window_y: i32 = DEF_POS,
    max_window_width: u32 = DEF_SIZE, //or 0
    max_window_height: u32 = DEF_SIZE,
    min_window_width: u32 = DEF_SIZE,
    min_window_height: u32 = DEF_SIZE,

    window_show: window.window_show = window.window_show.DEFAULT,
    screen_mode: screen_mode = screen_mode.WINDOW,
    screen_index: u32 = PRIMARY_SCREEN_INDEX,

    can_maximize: bool = true,
    can_minimize: bool = true,
    can_resizewindow: bool = true,
    use_console: bool = if (dbg) true else false,

    window_title: []const u8 = "XfitTest",
    icon: ?[]const u8 = null,
    cursor: ?[]const u8 = null,
    //*

    ///nanosec 단위 1프레임당 1sec = 1000000000 nanosec
    maxframe: f64 = 0,
    refleshrate: u32 = 0,
    vSync: vSync_mode = .double,
};

///nanosec 1 / 1000000000 sec
pub inline fn get_maxframe() f64 {
    if (@sizeOf(usize) == 4) @compileError("32bit not support");
    //     const native_endian = @import("builtin").target.cpu.arch.endian();
    //     const low: u64 = @atomicLoad(u32, @as(*u32, @ptrCast(&__system.init_set.maxframe)), std.builtin.AtomicOrder.monotonic);
    //     const high: u64 = @atomicLoad(u32, &@as([*]u32, @ptrCast(&__system.init_set.maxframe))[1], std.builtin.AtomicOrder.monotonic);

    //     return switch (native_endian) {
    //         .big => low << 32 | high,
    //         .little => high << 32 | low,
    //     };
    // ! } Not Use
    return @atomicLoad(f64, &__system.init_set.maxframe, std.builtin.AtomicOrder.monotonic);
}
//nanosec 1 / 1000000000 sec
pub inline fn set_maxframe_64(_maxframe: u64) void {
    @atomicStore(u64, &__system.init_set.maxframe, _maxframe, .monotonic);
}

//_int * 1000000000 + _dec
pub inline fn sec_to_nano_sec(_int: anytype, _dec: anytype) u64 {
    return @intCast(_int * 1000000000 + _dec);
}

pub inline fn sec_to_nano_sec2(_sec: anytype, _milisec: anytype, _usec: anytype, _nsec: anytype) u64 {
    return @intCast(_sec * 1000000000 + _milisec * 1000000 + _usec * 1000 + _nsec);
}
