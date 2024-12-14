const std = @import("std");
const root = @import("root");
const builtin = @import("builtin");

pub const XfitPlatform = enum(u32) {
    windows,
    android,
    linux,
};

pub const modules = struct {
    pub const meta = @import("meta.zig");
    pub const system = @import("system.zig");
    pub const animator = @import("animator.zig");
    pub const collision = @import("collision.zig");
    pub const components = @import("components.zig");
    pub const general_input = @import("general_input.zig");
    pub const geometry = @import("geometry.zig");
    pub const graphics = @import("graphics.zig");
    pub const gui = @import("gui.zig");
};

pub const datetime = @import("datetime.zig");
pub const timezones = @import("timezones.zig");
pub const xml = @import("xml");
///!pub const yaml = @import("yaml"); FAIL test unknown reason (error code 11) (zig_yaml)
pub const s2s = @import("s2s.zig");
pub const ini = @import("ini.zig");
pub const gltf = @import("gltf");

pub const windows = @import("__windows.zig").win32;
pub const android = @import("__android.zig").android;
pub const vulkan = __vulkan.vk;
pub const freetype = @import("include/freetype.zig");

pub var render_cmd: ?[]*render_command = null;

//?meta
pub const is_slice = modules.meta.is_slice;
pub const parse_value = modules.meta.parse_value;
pub const init_default_value_and_undefined = modules.meta.init_default_value_and_undefined;
pub const set_value = modules.meta.set_value;
pub const create_bit_field = modules.meta.create_bit_field;
//?system
pub const get_processor_core_len = modules.system.get_processor_core_len;
pub const a_load = modules.system.a_load;
pub const a_fn = modules.system.a_fn;
pub const a_fn_call = modules.system.a_fn_call;
pub const a_fn_error = modules.system.a_fn_error;
pub const platform_version = modules.system.platform_version;
pub const screen_info = modules.system.screen_info;
pub const monitor_info = modules.system.monitor_info;
pub const monitors = modules.system.monitors;
pub const primary_monitor = modules.system.primary_monitor;
pub const current_monitor = modules.system.current_monitor;
pub const get_platform_version = modules.system.get_platform_version;
pub const notify = modules.system.notify;
pub const text_notify = modules.system.text_notify;
pub const set_execute_all_cmd_per_update = modules.system.set_execute_all_cmd_per_update;
pub const get_execute_all_cmd_per_update = modules.system.get_execute_all_cmd_per_update;
//?animator
pub const ianimate_object = modules.animator.ianimate_object;
pub const multi_animate_player = modules.animator.multi_animate_player;
pub const animate_player = modules.animator.animate_player;
//?asset_file
pub const asset_file = @import("asset_file.zig");
//?file
pub const file = @import("file.zig");
//?font
pub const font = @import("font.zig");
//?collision
pub const iarea_type = modules.collision.iarea_type;
pub const iarea = modules.collision.iarea;
//?components
pub const button = modules.components.button;
pub const pixel_button = modules.components.pixel_button;
pub const button_state = modules.components.button_state;
pub const button_sets = modules.components.button_sets;
//?general_input
pub const GENERAL_INPUT_BUTTONS = modules.general_input.GENERAL_INPUT_BUTTONS;
pub const GENERAL_INPUT_STATE = modules.general_input.GENERAL_INPUT_STATE;
pub const CallbackFn = modules.general_input.CallbackFn;
pub const start_general_input = modules.general_input.start_general_input;
pub const destroy_general_input = modules.general_input.destroy_general_input;
pub const set_general_input_callback = modules.general_input.set_general_input_callback;
//?geometry
pub const curve_type = modules.geometry.curve_type;
pub const line_error = modules.geometry.line_error;
pub const shapes_error = modules.geometry.shapes_error;
pub const convert_quadratic_to_cubic0 = modules.geometry.convert_quadratic_to_cubic0;
pub const convert_quadratic_to_cubic1 = modules.geometry.convert_quadratic_to_cubic1;
pub const point_in_triangle = modules.geometry.point_in_triangle;
pub const point_in_line = modules.geometry.point_in_line;
pub const point_in_vector = modules.geometry.point_in_vector;
pub const lines_intersect = modules.geometry.lines_intersect;
pub const point_line_distance = modules.geometry.point_line_distance;
pub const point_in_polygon = modules.geometry.point_in_polygon;
pub const center_point_in_polygon = modules.geometry.center_point_in_polygon;
pub const line_in_polygon = modules.geometry.line_in_polygon;
pub const nearest_point_between_point_line = modules.geometry.nearest_point_between_point_line;
pub const geometry_circle = modules.geometry.geometry_circle;
pub const compute_option = modules.geometry.compute_option;
pub const geometry_shapes = modules.geometry.geometry_shapes;
pub const geometry_line = modules.geometry.geometry_line;
pub const geometry_raw_shapes = modules.geometry.geometry_raw_shapes;
//?graphics
pub const indices16 = modules.graphics.indices16;
pub const indices32 = modules.graphics.indices32;
pub const indices = modules.graphics.indices;
pub const execute_and_wait_all_op = modules.graphics.execute_and_wait_all_op;
pub const execute_all_op = modules.graphics.execute_all_op;
pub const set_render_clear_color = modules.graphics.set_render_clear_color;
pub const graphic_resource_write_flag = modules.graphics.graphic_resource_write_flag;
pub const iobject = modules.graphics.iobject;
pub const projection = modules.graphics.projection;
pub const camera = modules.graphics.camera;
pub const color_transform = modules.graphics.color_transform;
pub const transform = modules.graphics.transform;
pub const texture = modules.graphics.texture;
pub const get_default_quad_image_vertices = modules.graphics.get_default_quad_image_vertices;
pub const get_default_linear_sampler = modules.graphics.get_default_linear_sampler;
pub const get_default_nearest_sampler = modules.graphics.get_default_nearest_sampler;
pub const texture_array = modules.graphics.texture_array;
pub const tile_texture_array = modules.graphics.tile_texture_array;
pub const shape = modules.graphics.shape;
pub const pixel_shape = modules.graphics.pixel_shape;
pub const shape_source = modules.graphics.shape_source;
pub const center_pt_pos = modules.graphics.center_pt_pos;
pub const image = modules.graphics.image;
pub const pixel_perfect_point = modules.graphics.pixel_perfect_point;
pub const animate_image = modules.graphics.animate_image;
pub const tile_image = modules.graphics.tile_image;
//?render_command
pub const render_command = @import("render_command.zig");
//?image_util
pub const image_util = @import("image_util.zig");
//?lua
pub const lua = @import("lua.zig");
//?math
pub const math = @import("math.zig");
pub const matrix = math.matrix;
pub const matrix64 = math.matrix64;
pub const matrix3x3 = math.matrix3x3;
///TODO matrix3x3_inverse
pub const matrix3x3_determinant = math.matrix3x3_determinant;
pub const rect = math.rect;
pub const recti = math.recti;
pub const rectu = math.rectu;
pub const pointu = math.pointu;
pub const pointu64 = math.pointu64;
pub const pointi = math.pointi;
pub const pointi64 = math.pointi64;
pub const point64 = math.point64;
pub const point = math.point;
pub const point3d = math.point3d;
pub const point3d64 = math.point3d64;
pub const point3du = math.point3du;
pub const point3du64 = math.point3du64;
pub const point3di = math.point3di;
pub const point3di64 = math.point3di64;
pub const vector = math.vector;
pub const vector64 = math.vector64;
pub const matrix_error = math.matrix_error;
pub const matrix_addition = math.matrix_addition;
pub const matrix_subtract = math.matrix_subtract;
pub const matrix_transpose = math.matrix_transpose;
pub const matrix_determinant = math.matrix_determinant;
pub const matrix_inverse = math.matrix_inverse;
pub const matrix_div_point = math.matrix_div_point;
pub const matrix_mul_point = math.matrix_mul_point;
pub const matrix_div_vector = math.matrix_div_vector;
pub const matrix_mul_vector = math.matrix_mul_vector;
pub const matrix_multiply = math.matrix_multiply;
pub const matrix_identity = math.matrix_identity;
pub const matrix_lookAtRh = math.matrix_lookAtRh;
pub const matrix_lookAtLh = math.matrix_lookAtLh;
pub const matrix_lookToRh = math.matrix_lookToRh;
pub const matrix_lookToLh = math.matrix_lookToLh;
pub const matrix_orthographicRh = math.matrix_orthographicRh;
pub const matrix_orthographicLh = math.matrix_orthographicLh;
pub const matrix_orthographicLhVulkan = math.matrix_orthographicLhVulkan;
pub const matrix_perspectiveFovRhGL = math.matrix_perspectiveFovRhGL;
pub const matrix_perspectiveFovRh = math.matrix_perspectiveFovRh;
pub const matrix_perspectiveFovLh = math.matrix_perspectiveFovLh;
pub const matrix_perspectiveFovLhVulkan = math.matrix_perspectiveFovLhVulkan;
pub const matrix_scaling_inverse = math.matrix_scaling_inverse;
pub const matrix_rotation2D_inverse = math.matrix_rotation2D_inverse;
pub const matrix_rocation2D_transpose = math.matrix_rocation2D_transpose;
pub const matrix_rocationZ_transpose = math.matrix_rocationZ_transpose;
pub const matrix_rocationY_transpose = math.matrix_rocationY_transpose;
pub const matrix_rocationX_transpose = math.matrix_rocationX_transpose;
pub const matrix_rotationZ_inverse = math.matrix_rotationZ_inverse;
pub const matrix_rotationY_inverse = math.matrix_rotationY_inverse;
pub const matrix_rotationX_inverse = math.matrix_rotationX_inverse;
pub const matrix_rotation2D = math.matrix_rotation2D;
pub const matrix_rotationZ = math.matrix_rotationZ;
pub const matrix_rotationY = math.matrix_rotationY;
pub const matrix_rotationX = math.matrix_rotationX;
pub const matrix_scalingXY = math.matrix_scalingXY;
pub const matrix_scaling = math.matrix_scaling;
pub const matrix_translation_transpose_inverse = math.matrix_translation_transpose_inverse;
pub const matrix_translation_inverse = math.matrix_translation_inverse;
pub const matrix_translation_transpose = math.matrix_translation_transpose;
pub const matrix_translationXY = math.matrix_translationXY;
pub const matrix_translation = math.matrix_translation;
pub const matrix_zero_init = math.matrix_zero_init;
pub const compare_n = math.compare_n;
pub const compare = math.compare;
pub const dot = math.dot;
pub const cross3 = math.cross3;
pub const cross2 = math.cross2;
pub const pow = math.pow;
//?raw_input
pub const raw_input = @import("raw_input.zig");
//?sound
pub const sound = @import("sound.zig");
pub const play_sound = sound.play_sound;
pub const sound_source = sound.sound_source;
//?timer_callback
pub const timer_callback = @import("timer_callback.zig");
//?webp
pub const webp = @import("webp.zig");
//?window
pub const window = @import("window.zig");
pub const screen_orientation = window.screen_orientation;
//?xbox_pad_input
pub const xbox_pad_input = @import("xbox_pad_input.zig");
//?input
pub const input = @import("input.zig");
//?mem
pub const mem = @import("mem.zig");
//?gui
pub const icomponent = modules.gui.icomponent;
pub const component = modules.gui.component;
//?json
pub const json = @import("json.zig");
//?svg
pub const svg = @import("svg.zig");

test {
    @setEvalBranchQuota(10000000);
    std.testing.refAllDeclsRecursive(math);
    std.testing.refAllDeclsRecursive(json);
    std.testing.refAllDeclsRecursive(svg);
    std.testing.refAllDeclsRecursive(modules);
    std.testing.refAllDeclsRecursive(mem);
    std.testing.refAllDeclsRecursive(input);
    std.testing.refAllDeclsRecursive(window);
    std.testing.refAllDeclsRecursive(webp);
    std.testing.refAllDeclsRecursive(timer_callback);
    std.testing.refAllDecls(sound);
    std.testing.refAllDecls(sound.sound_source);
    std.testing.refAllDecls(font);
    std.testing.refAllDeclsRecursive(image_util);
    std.testing.refAllDeclsRecursive(render_command);
    std.testing.refAllDeclsRecursive(timezones);
    std.testing.refAllDeclsRecursive(datetime);
    std.testing.refAllDeclsRecursive(gltf);
    std.testing.refAllDeclsRecursive(xml);
}

//system engine only headers
const __system = @import("__system.zig");
const __windows = if (!@import("builtin").is_test) @import("__windows.zig") else void;
const __android = if (!@import("builtin").is_test) @import("__android.zig") else void;
const __vulkan = @import("__vulkan.zig");
const __linux = @import("__linux.zig");

pub const __xfit_test: bool = !@hasDecl(root, "xfit_init");

pub const platform: XfitPlatform = if (__xfit_test) .linux else @enumFromInt(@intFromEnum(@import("build_options").platform));
pub const SubSystem = std.Target.SubSystem;
pub const subsystem: SubSystem = if (__xfit_test) .Posix else @enumFromInt(@intFromEnum(@import("build_options").subsystem));

pub const dbg = builtin.mode == .Debug;
pub const enable_log: bool = if (__xfit_test) true else @import("build_options").enable_log;
pub const is_mobile: bool = platform == .android;

pub const __android_entry = if (platform == .android) __android.android.ANativeActivity_createFunc else {};
//

pub fn xfit_main(_allocator: std.mem.Allocator, _init_setting: *const init_setting) void {
    __system.init(_allocator, _init_setting);

    //vulkan_start, root.xfit_init() are called in a separate work thread (rendering there)

    if (platform == .windows) {
        __windows.system_windows_start();

        if (subsystem == SubSystem.Console) {
            if (!__xfit_test) {
                root.xfit_init() catch |e| {
                    herr3("xfit_init", e);
                };

                root.xfit_destroy() catch |e| {
                    herr3("xfit_destroy", e);
                };
            }
        } else {
            __windows.windows_start();

            __windows.windows_loop();
        }

        __system.destroy();

        if (!__xfit_test) {
            root.xfit_clean() catch |e| {
                herr3("xfit_clean", e);
            };
        }

        __system.real_destroy();
    } else if (platform == .android) {} else if (platform == .linux) {
        __linux.system_linux_start();
        if (subsystem == SubSystem.Console) {
            if (!__xfit_test) {
                root.xfit_init() catch |e| {
                    herr3("xfit_init", e);
                };

                root.xfit_destroy() catch |e| {
                    herr3("xfit_destroy", e);
                };
            }
        } else {
            __linux.linux_start();

            __linux.linux_loop();
        }
        __linux.linux_destroy();
        __system.destroy();

        if (!__xfit_test) {
            root.xfit_clean() catch |e| {
                herr3("xfit_clean", e);
            };
        }

        __system.real_destroy();
    } else {
        @compileError("not support platform");
    }
}

pub inline fn herrm2(errtest: bool, msg: []const u8) void {
    if (!errtest) {
        print_error("ERR {s}\n", .{msg});
        @trap(); // ! unreachable is not working when release mode
    }
}
pub inline fn herrm(msg: []const u8) void {
    print_error("ERR {s}\n", .{msg});
    @trap(); // ! unreachable is not working when release mode
}

pub inline fn herr2(comptime fmt: []const u8, args: anytype) void {
    print_error("ERR " ++ fmt ++ "\n", args);
    @trap(); // ! unreachable is not working when release mode
}

pub inline fn herr(errtest: bool, comptime fmt: []const u8, args: anytype) void {
    if (!errtest) {
        print_error("ERR " ++ fmt ++ "\n", args);
        @trap(); // ! unreachable is not working when release mode
    }
}

pub inline fn herr3(funcion_name: []const u8, err: anyerror) void {
    print_error("ERR {s} {s}\n", .{ funcion_name, @errorName(err) });
    @trap(); // ! unreachable is not working when release mode
}

///!print_error and herr.. functions that call this function must be declared inline
pub inline fn print_error(comptime fmt: []const u8, args: anytype) void {
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
        const error_trace: ?*std.builtin.StackTrace = @errorReturnTrace(); // ! because of this, it must be declared inline
        if (error_trace != null and error_trace.?.*.instruction_addresses.len > 0 and error_trace.?.*.index > 0) {
            std.debug.writeStackTrace(error_trace.?.*, str2.writer(), debug_info, .no_color) catch {};
        } else {
            std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch {};
        }

        std.debug.print("{s}\n{s}", .{ str, str2.items });

        a_fn_call(__system.error_handling_func, .{ str, str2.items }) catch {};
        // fs.create("xfit_err.log", .{ .truncate = false }) catch fs.create("xfit_err.log", .{ .exclusive = true }) catch  return;
    } else {
        const str = std.fmt.allocPrint(std.heap.c_allocator, "{s} @ " ++ fmt ++ " ", .{now_str} ++ args) catch return;
        defer std.heap.c_allocator.free(str);

        // const path = std.fmt.allocPrint(std.heap.c_allocator, "{s}/xfit_err.log" ++ fmt, .{__android.get_file_dir()} ++ args) catch  return;
        // defer std.heap.c_allocator.free(path);

        // fs.create(path, .{ .truncate = false }) catch fs.create(path, .{ .exclusive = true }) catch  return;

        str[str.len - 1] = 0;
        _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_ERROR, "xfit", str.ptr);

        var str2 = std.ArrayList(u8).init(std.heap.c_allocator);
        defer str2.deinit();

        const error_trace: ?*std.builtin.StackTrace = @errorReturnTrace();
        if (error_trace != null) {
            std.debug.writeStackTrace(error_trace.?.*, str2.writer(), debug_info, .no_color) catch {};
        } else {
            std.debug.writeCurrentStackTrace(str2.writer(), debug_info, .no_color, @returnAddress()) catch {};
        }
        str2.append(0) catch return;
        _ = __android.android.__android_log_write(__android.android.ANDROID_LOG_ERROR, "xfit", str2.items.ptr);

        a_fn_call(__system.error_handling_func, .{ str, str2.items }) catch {};
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
        __system.exiting.store(true, .release);
    } else if (platform == .android) {
        __system.exiting.store(true, .release);
    } else if (platform == .linux) {
        __system.exiting.store(true, .release);
        __linux.linux_close();
    }
}

pub fn set_vsync(_vSync: vSync_mode) void {
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    __system.init_set.vSync = _vSync;
    __system.size_update.store(true, .release);
}

pub const screen_mode = enum { WINDOW, BORDERLESSSCREEN, FULLSCREEN };

pub const vSync_mode = enum { none, double, triple };

const CW_USEDEFAULT: i32 = if (platform == .windows) @intCast(__windows.CW_USEDEFAULT) else @bitCast(@as(u32, 0x80000000));

pub const init_setting = struct {
    pub const DEF_SIZE = @as(u32, @bitCast(CW_USEDEFAULT));
    pub const DEF_POS = CW_USEDEFAULT;
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

    window_show: window.show = window.show.DEFAULT,
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

    maxframe: f64 = 0,
    refleshrate: u32 = 0,
    vSync: vSync_mode = .double,
};

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
pub inline fn set_maxframe(_maxframe: f64) void {
    @atomicStore(f64, &__system.init_set.maxframe, _maxframe, .monotonic);
}

//_int * 1000000000 + _dec
pub inline fn sec_to_nano_sec(_int: anytype, _dec: anytype) u64 {
    return @intCast(_int * 1000000000 + _dec);
}

pub inline fn sec_to_nano_sec2(_sec: anytype, _milisec: anytype, _usec: anytype, _nsec: anytype) u64 {
    return @intCast(_sec * 1000000000 + _milisec * 1000000 + _usec * 1000 + _nsec);
}
