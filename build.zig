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

///for : const src_path = b.dependency("xfit_build", .{}).*.path(".").getPath(b);
pub fn build(b: *std.Build) void {
    yaml = b.dependency("zig-yaml", .{});
    xml = b.dependency("xml", .{});
    //?xfit 엔진 내에서 외부 라이브러리 인식하기 위해
    const result = b.addTest(.{
        .name = "xfit",
        .root_source_file = b.path("engine/xfit.zig"),
    });
    result.root_module.addImport("yaml", yaml.module("yaml"));
    result.root_module.addImport("xml", xml.module("xml"));

    b.default_step.dependOn(&result.step);
    //?
}

pub const run_option = struct {
    name: []const u8, //manefest의 android.app.lib_name 와 같게
    root_source_file: std.Build.LazyPath,
    PLATFORM: XfitPlatform,
    OPTIMIZE: std.builtin.OptimizeMode,
    callback: ?*const fn (*std.Build, *std.Build.Step.Compile, std.Build.ResolvedTarget) void = null,
    is_console: bool = false, //ignores for target mobile
    ANDROID_KEYSTORE: ?[]const u8 = null,
    enable_log: bool = true,
};

pub fn run(
    b: *std.Build,
    option: run_option,
) void {
    var arena_allocator = std.heap.ArenaAllocator.init(b.allocator);
    defer arena_allocator.deinit();

    const src_path = b.dependency("xfit_build", .{}).*.path(".").getPath(b);
    const engine_path = std.fmt.allocPrint(arena_allocator.allocator(), "{s}/engine", .{src_path}) catch unreachable;
    if (builtin.os.tag == .windows) {
        const path: []u8 = std.fmt.allocPrint(arena_allocator.allocator(), "{s}/shader_compile.bat", .{engine_path}) catch unreachable;
        const realpath: []u8 = std.fs.cwd().realpathAlloc(arena_allocator.allocator(), path) catch unreachable;

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, arena_allocator.allocator());
        _ = pro.spawnAndWait() catch unreachable;
    } else {
        const path: []u8 = std.fmt.allocPrint(arena_allocator.allocator(), "{s}/shader_compile.sh", .{engine_path}) catch unreachable;
        defer arena_allocator.allocator().free(path);
        const realpath: []u8 = std.fs.cwd().realpathAlloc(arena_allocator.allocator(), path) catch unreachable;
        defer arena_allocator.allocator().free(realpath);

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, arena_allocator.allocator());
        _ = pro.spawnAndWait() catch unreachable;
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
        "libopus.a", //-fno-stack-protector 옵션으로 빌드 필요
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

        const xfit = b.addModule("xfit", .{ .root_source_file = get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/xfit.zig", .{engine_path}) catch unreachable) });
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
            });
            var contents = std.ArrayList(u8).init(arena_allocator.allocator());
            var writer = contents.writer();
            const plat = if (builtin.os.tag == .windows) "windows" else if (builtin.os.tag == .linux) "linux" else if (builtin.os.tag == .macos) "darwin" else @compileError("not support android host platform.");
            writer.print("include_dir={s}\n", .{std.fmt.allocPrint(
                arena_allocator.allocator(),
                "{s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/include",
                .{ user_setting.ANDROID_NDK_PATH, plat },
            ) catch unreachable}) catch unreachable;
            writer.print("sys_include_dir={s}\n", .{std.fmt.allocPrint(
                arena_allocator.allocator(),
                "{s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/include/{s}-linux-android",
                .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?) },
            ) catch unreachable}) catch unreachable;
            writer.print("crt_dir={s}\n", .{std.fmt.allocPrint(
                arena_allocator.allocator(),
                "{s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/lib/{s}-linux-android/{d}",
                .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?), user_setting.ANDROID_VER },
            ) catch unreachable}) catch unreachable;
            writer.writeAll("msvc_lib_dir=\n") catch unreachable;
            writer.writeAll("kernel32_lib_dir=\n") catch unreachable;
            writer.writeAll("gcc_dir=\n") catch unreachable;
            const android_libc_step = b.addWriteFile("android-libc.conf", contents.items);
            result.setLibCFile(android_libc_step.getDirectory().join(arena_allocator.allocator(), "android-libc.conf") catch unreachable);
            install_step.dependOn(&android_libc_step.step);

            result.addLibraryPath(.{ .cwd_relative = std.fmt.allocPrint(
                arena_allocator.allocator(),
                "{s}/toolchains/llvm/prebuilt/{s}-x86_64/sysroot/usr/lib/{s}-linux-android/{d}",
                .{ user_setting.ANDROID_NDK_PATH, plat, get_arch_text(targets[i].cpu_arch.?), user_setting.ANDROID_VER },
            ) catch unreachable });

            // result.addLibraryPath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/android/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?) }) catch unreachable));

            result.linkSystemLibrary("android");
            //result.linkSystemLibrary("vulkan");
            //result.linkSystemLibrary("VkLayer_khronos_validation");
            result.linkSystemLibrary("c");
            result.linkSystemLibrary("z");
            result.linkSystemLibrary("log");

            for (lib_names) |n| {
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/android/{s}/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?), n }) catch unreachable));
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
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
            }
            if (target.result.cpu.arch == .aarch64) {
                for (windows_aarch64_extra_lib_names) |n| {
                    result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
                }
            } else {
                for (windows_extra_lib_names) |n| {
                    result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
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
            });

            result.linkLibC();

            if (option.is_console) {
                result.subsystem = .Console;
            } else {
                result.subsystem = .Posix;
            }

            for (linux_lib_names) |n| {
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
            }
            result.addCSourceFile(.{ .file = get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/conio.c", .{engine_path}) catch unreachable) });
            // result.addCSourceFile(.{ .file = get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/lib/linux/xdg-shell-protocol.c", .{engine_path}) catch unreachable) });

            if (option.callback != null) option.callback.?(b, result, target);

            b.installArtifact(result);
        } else unreachable;

        result.root_module.addImport("build_options", build_options_module);

        result.root_module.addImport("xfit", xfit);

        result.root_module.addImport("yaml", yaml.module("yaml"));
        result.root_module.addImport("xml", xml.module("xml"));
        xfit.addImport("yaml", yaml.module("yaml"));
        xfit.addImport("xml", xml.module("xml"));

        xfit.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include", .{engine_path}) catch unreachable));
        xfit.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/freetype", .{engine_path}) catch unreachable));
        xfit.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/opus", .{engine_path}) catch unreachable));

        result.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include", .{engine_path}) catch unreachable));
        result.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/freetype", .{engine_path}) catch unreachable));
        result.addIncludePath(get_lazypath(b, std.fmt.allocPrint(arena_allocator.allocator(), "{s}/include/opus", .{engine_path}) catch unreachable));

        if (option.PLATFORM != XfitPlatform.android) break;
    }

    var cmd: *std.Build.Step.Run = undefined;
    if (builtin.os.tag == .windows) {
        if (option.PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.bat", .{engine_path}) catch unreachable, engine_path, b.install_path, "android", user_setting.ANDROID_PATH, std.fmt.comptimePrint("{d}", .{user_setting.ANDROID_VER}), user_setting.ANDROID_BUILD_TOOL_VER, option.ANDROID_KEYSTORE.?, b.build_root.path.?, get_arch_text(builtin.cpu.arch) });
        } else {
            cmd = b.addSystemCommand(&.{std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.bat", .{engine_path}) catch unreachable});
        }
    } else {
        if (option.PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.sh", .{engine_path}) catch unreachable, engine_path, b.install_path, "android", user_setting.ANDROID_PATH, std.fmt.comptimePrint("{d}", .{user_setting.ANDROID_VER}), user_setting.ANDROID_BUILD_TOOL_VER, option.ANDROID_KEYSTORE.?, b.build_root.path.?, get_arch_text(builtin.cpu.arch) });
        } else {
            cmd = b.addSystemCommand(&.{std.fmt.allocPrint(arena_allocator.allocator(), "{s}/compile.sh", .{engine_path}) catch unreachable});
        }
    }
    cmd.step.dependOn(install_step);

    b.default_step.dependOn(&cmd.step);
}
