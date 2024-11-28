const std = @import("std");
const builtin = @import("builtin");

pub const XfitPlatform = enum(u32) {
    windows,
    android,
    linux,
};

const user_setting = @import("user_setting.zig");

inline fn get_lazypath(b: *std.Build, path: []const u8) std.Build.LazyPath {
    return if (std.fs.path.isAbsolute(path)) .{ .cwd_relative = path } else b.path(path);
}

inline fn get_arch_text(arch: std.Target.Cpu.Arch) []const u8 {
    return switch (arch) {
        .x86_64 => "x86_64",
        .aarch64 => "aarch64",
        .riscv64 => "riscv64",
        else => unreachable,
    };
}

var yaml: *std.Build.Dependency = undefined;
var xml: *std.Build.Dependency = undefined;
var gltf: *std.Build.Dependency = undefined;
var unit_tests: *std.Build.Step.Compile = undefined;

///? const src_path = b.dependency("xfit_build", .{}).*.path(".").getPath(b);
pub fn build(b: *std.Build) !void {
    yaml = b.dependency("zig-yaml", .{});
    xml = b.dependency("xml", .{});
    gltf = b.dependency("zgltf", .{});

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    unit_tests = b.addTest(.{
        .root_source_file = b.path("src/xfit.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.root_module.addImport("yaml", yaml.module("yaml"));
    unit_tests.root_module.addImport("xml", xml.module("xml"));
    unit_tests.root_module.addImport("gltf", gltf.module("zgltf"));

    unit_tests.addIncludePath(b.path("src/include"));
    unit_tests.addIncludePath(b.path("src/include/freetype"));
    unit_tests.addIncludePath(b.path("src/include/opus"));

    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
    b.default_step.dependOn(&run_unit_tests.step);

    const xfit_docs = b.addStaticLibrary(.{
        .name = "xfit",
        .root_source_file = b.path("src/xfit.zig"),
        .target = target,
        .optimize = optimize,
    });

    //? 빌드 시 문서 생성 zig build to emit docs
    const install_docs = b.addInstallDirectory(.{
        .source_dir = xfit_docs.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "xfit-docs",
    });

    const docs_step = b.step("docs", "Generate docs");
    docs_step.dependOn(&install_docs.step);
    b.default_step.dependOn(&install_docs.step);
}

pub const run_option = struct {
    ///same as manifest's android.app.lib_name
    name: []const u8,
    root_source_file: std.Build.LazyPath,
    PLATFORM: XfitPlatform,
    OPTIMIZE: std.builtin.OptimizeMode,
    callback: ?*const fn (*std.Build, *std.Build.Step.Compile, std.Build.ResolvedTarget) void = null,
    ///ignores for target mobile
    is_console: bool = false,
    ANDROID_KEYSTORE: ?[]const u8 = null,
    enable_log: bool = true,
    ///omit frame pointer always true when debug
    enable_trace: bool = true,
};

pub fn run(
    b: *std.Build,
    option: run_option,
) !void {
    var arena_allocator = std.heap.ArenaAllocator.init(b.allocator);
    defer arena_allocator.deinit();

    const src_path = b.dependency("xfit_build", .{}).*.path(".").getPath(b);
    const engine_path = try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/src", .{src_path});

    if (builtin.os.tag == .windows) {
        const path: []u8 = try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/shader_compile.bat", .{engine_path});

        const realpath: []u8 = try std.fs.cwd().realpathAlloc(arena_allocator.allocator(), path);

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, arena_allocator.allocator());
        _ = try pro.spawnAndWait();
    } else {
        const path: []u8 = try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/shader_compile.sh", .{engine_path});

        const realpath: []u8 = try std.fs.cwd().realpathAlloc(arena_allocator.allocator(), path);

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, arena_allocator.allocator());
        _ = try pro.spawnAndWait();
    }

    const build_options = b.addOptions();

    build_options.addOption(XfitPlatform, "platform", option.PLATFORM);
    build_options.addOption(std.Target.SubSystem, "subsystem", if (option.is_console) .Console else .Windows);
    build_options.addOption(bool, "enable_log", option.enable_log);

    const out_arch_text = comptime [_][]const u8{
        "../lib/arm64-v8a",
        "../lib/riscv64",
        "../lib/x86_64",
    };
    const targets = [_]std.Target.Query{
        .{ .os_tag = .linux, .cpu_arch = .aarch64, .abi = .android, .cpu_model = .baseline, .cpu_features_add = std.Target.aarch64.featureSet(&.{ .neon, .v8a, .reserve_x18 }) },
        .{ .os_tag = .linux, .cpu_arch = .riscv64, .abi = .android, .cpu_model = .baseline, .cpu_features_add = std.Target.riscv.featureSet(&.{.reserve_x18}) },
        .{ .os_tag = .linux, .cpu_arch = .x86_64, .abi = .android, .cpu_model = .baseline, .cpu_features_add = std.Target.x86.featureSet(&.{
            .ssse3,
            .sse4_1,
            .sse4_2,
            .popcnt,
        }) },
    };

    const install_step: *std.Build.Step = b.step("shared lib build", "shared lib build");

    const lib_names = comptime [_][]const u8{
        "libwebp.a",
        "libwebpdemux.a",
        "libfreetype.a",
        "libogg.a",
        "libopus.a", //required -fno-stack-protector option
        "libopusfile.a",
        "libvorbis.a",
        "libvorbisenc.a",
        "libvorbisfile.a",
        "libminiaudio.a",
        "liblua.a", //custom
    };

    const windows_extra_lib_names = comptime [_][]const u8{
        "libhid.a",
        "libhidclass.a",
        "libhidparse.a",
        "libsetupapi.a",
        "libgdi32.a",
    };
    const windows_aarch64_extra_lib_names = comptime [_][]const u8{
        "libhid.a",
        "libsetupapi.a",
        "libgdi32.a",
    };

    const linux_lib_names = comptime [_][]const u8{
        "libwebp.a",
        "libwebpdemux.a",
        "libfreetype.a",
        "libogg.a",
        "libopus.a",
        "libopusfile.a",
        "libvorbis.a",
        "libvorbisenc.a",
        "libvorbisfile.a",
        "liblua.a", //custom
        "libminiaudio.a",
        "libz.so",
        "libX11.so",
        "libXrandr.so",
    };

    var i: usize = 0;
    while (i < targets.len) : (i += 1) {
        var result: *std.Build.Step.Compile = undefined;

        const build_options_module = build_options.createModule();

        const xfit = b.addModule("xfit", .{ .root_source_file = get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/xfit.zig", .{engine_path})) });
        xfit.addImport("build_options", build_options_module);

        if (option.PLATFORM == XfitPlatform.android) {
            if (option.is_console) @panic("mobile do not support console");

            const target = b.resolveTargetQuery(targets[i]);
            result = b.addSharedLibrary(.{
                .target = target,
                .name = option.name,
                .root_source_file = option.root_source_file,
                .optimize = option.OPTIMIZE,
                .pic = true,
                .omit_frame_pointer = if (option.enable_trace) true else null,
            });
            var contents = std.ArrayList(u8).init(arena_allocator.allocator());
            var writer = contents.writer();
            const plat = if (builtin.os.tag == .windows) "windows" else if (builtin.os.tag == .linux) "linux" else if (builtin.os.tag == .macos) "darwin" else @compileError("not support android host platform.");
            try writer.print("include_dir={s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/include\n", .{ user_setting.ANDROID_NDK_PATH, plat });
            try writer.print("sys_include_dir={s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/include/{s}-linux-android\n", .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?) });
            try writer.print("crt_dir={s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/lib/{s}-linux-android/{d}\n", .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?), user_setting.ANDROID_VER });
            try writer.writeAll("msvc_lib_dir=\n");
            try writer.writeAll("kernel32_lib_dir=\n");
            try writer.writeAll("gcc_dir=\n");
            const android_libc_step = b.addWriteFile("android-libc.conf", contents.items);
            result.setLibCFile(try android_libc_step.getDirectory().join(arena_allocator.allocator(), "android-libc.conf"));
            install_step.dependOn(&android_libc_step.step);

            result.addLibraryPath(.{ .cwd_relative = try std.fmt.allocPrint(
                arena_allocator.allocator(),
                "{s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/lib/{s}-linux-android/{d}",
                .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?), user_setting.ANDROID_VER },
            ) });

            // result.addLibraryPath(try get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/android/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?) })));

            result.linkSystemLibrary("android");
            //result.linkSystemLibrary("vulkan");
            //result.linkSystemLibrary("VkLayer_khronos_validation");
            result.linkSystemLibrary("c");
            result.linkSystemLibrary("z");
            result.linkSystemLibrary("log");

            for (lib_names) |n| {
                result.addObjectFile(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/android/{s}/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?), n })));
            }

            if (option.callback != null) option.callback.?(b, result, target);

            install_step.dependOn(&b.addInstallArtifact(result, .{
                .dest_dir = .{ .override = .{ .custom = out_arch_text[i] } },
            }).step);
        } else if (option.PLATFORM == XfitPlatform.windows) {
            var target = b.standardTargetOptions(.{ .default_target = .{
                .os_tag = .windows,
                .abi = .gnu,
                .cpu_model = .baseline,
            } });
            if (target.result.cpu.arch == .x86_64) {
                target.result.cpu.features.addFeatureSet(std.Target.x86.featureSet(&.{
                    .ssse3,
                    .sse3,
                    .sse4_1,
                    .sse4_2,
                    .popcnt,
                }));
            } else if (target.result.cpu.arch == .aarch64) {
                target.result.cpu.features.addFeatureSet(std.Target.aarch64.featureSet(&.{ .neon, .v8_2a }));
            }
            target.query.cpu_features_add = target.result.cpu.features;
            target.query.abi = .gnu; //gnu required
            target.result.abi = .gnu; //gnu required

            result = b.addExecutable(.{
                .target = target,
                .name = option.name,
                .root_source_file = option.root_source_file,
                .optimize = option.OPTIMIZE,
                .pic = true,
                .omit_frame_pointer = if (option.enable_trace) true else null,
            });
            result.linkLibC();

            if (option.is_console) {
                result.subsystem = .Console;
            } else {
                result.subsystem = .Windows;
            }
            // result.linkSystemLibrary("setupapi");
            // result.linkSystemLibrary("hid");
            // result.linkSystemLibrary("Gdi32");

            for (lib_names) |n| {
                result.addObjectFile(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n })));
            }
            if (target.result.cpu.arch == .aarch64) {
                for (windows_aarch64_extra_lib_names) |n| {
                    result.addObjectFile(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n })));
                }
            } else {
                for (windows_extra_lib_names) |n| {
                    result.addObjectFile(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n })));
                }
            }

            if (option.callback != null) option.callback.?(b, result, target);

            b.installArtifact(result);
        } else if (option.PLATFORM == XfitPlatform.linux) {
            var target = b.standardTargetOptions(.{ .default_target = .{
                .os_tag = .linux,
                .abi = .gnu,
                .cpu_model = .baseline,
            } });
            if (target.result.cpu.arch == .x86_64) {
                target.result.cpu.features.addFeatureSet(std.Target.x86.featureSet(&.{
                    .ssse3,
                    .sse3,
                    .sse4_1,
                    .sse4_2,
                    .popcnt,
                }));
            } else if (target.result.cpu.arch == .aarch64) {
                target.result.cpu.features.addFeatureSet(std.Target.aarch64.featureSet(&.{.neon}));
            }
            target.query.cpu_features_add = target.result.cpu.features;
            target.query.abi = .gnu; //gnu required
            target.result.abi = .gnu; //gnu required

            result = b.addExecutable(.{
                .target = target,
                .name = option.name,
                .root_source_file = option.root_source_file,
                .optimize = option.OPTIMIZE,
                .pic = true,
                .omit_frame_pointer = if (option.enable_trace) true else null,
            });

            result.linkLibC();

            if (option.is_console) {
                result.subsystem = .Console;
            } else {
                result.subsystem = .Posix;
            }

            for (linux_lib_names) |n| {
                result.addObjectFile(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n })));
            }
            result.addCSourceFile(.{ .file = get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/conio.c", .{engine_path})) });
            // result.addCSourceFile(.{ .file = get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/xdg-shell-protocol.c", .{engine_path})) });

            if (option.callback != null) option.callback.?(b, result, target);

            b.installArtifact(result);
        } else unreachable;

        result.root_module.addImport("build_options", build_options_module);

        result.root_module.addImport("xfit", xfit);

        result.root_module.addImport("yaml", yaml.module("yaml"));
        result.root_module.addImport("xml", xml.module("xml"));
        xfit.addImport("yaml", yaml.module("yaml"));
        xfit.addImport("xml", xml.module("xml"));

        xfit.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include", .{engine_path})));
        xfit.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/freetype", .{engine_path})));
        xfit.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/opus", .{engine_path})));

        result.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include", .{engine_path})));
        result.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/freetype", .{engine_path})));
        result.addIncludePath(get_lazypath(b, try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/opus", .{engine_path})));

        if (option.PLATFORM != XfitPlatform.android) break;
    }

    var cmd: *std.Build.Step.Run = undefined;
    if (builtin.os.tag == .windows) {
        if (option.PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.bat", .{engine_path}), engine_path, b.install_path, "android", user_setting.ANDROID_PATH, std.fmt.comptimePrint("{d}", .{user_setting.ANDROID_VER}), user_setting.ANDROID_BUILD_TOOL_VER, option.ANDROID_KEYSTORE.?, b.build_root.path.?, get_arch_text(builtin.cpu.arch) });
        } else {
            cmd = b.addSystemCommand(&.{try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.bat", .{engine_path})});
        }
    } else {
        if (option.PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.sh", .{engine_path}), engine_path, b.install_path, "android", user_setting.ANDROID_PATH, std.fmt.comptimePrint("{d}", .{user_setting.ANDROID_VER}), user_setting.ANDROID_BUILD_TOOL_VER, option.ANDROID_KEYSTORE.?, b.build_root.path.?, get_arch_text(builtin.cpu.arch) });
        } else {
            cmd = b.addSystemCommand(&.{try std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.sh", .{engine_path})});
        }
    }
    cmd.step.dependOn(install_step);

    b.default_step.dependOn(&cmd.step);

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
