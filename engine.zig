const std = @import("std");
const builtin = @import("builtin");

pub const XfitPlatform = enum(u32) { windows, android, linux, mac, end };

// set(CMAKE_C_COMPILER zig cc -target aarch64-linux-android)
// set(CMAKE_CXX_COMPILER zig c++ -target aarch64-linux-android)
// # include_directories(SYSTEM "C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include" -isystem "C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include/x86_64-linux-android")
// # add_link_options(-L"C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/x86_64-linux-android/libc.a")

// include_directories(SYSTEM "C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include" -isystem "C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include/aarch64-linux-android")
// add_link_options(-L"C:/Android/ndk/27.0.12077973/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/aarch64-linux-android/libc.a")

//* User Setting
//크로스 플랫폼 빌드시 zig build -Dtarget=aarch64-windows(linux)
//x86_64-windows(linux)
// Android 쪽은 한번 테스트하고 안해서(Windows쪽 완성되면 할 예정) 버그 있을 겁니다.
const ANDROID_PATH = "C:/Android";
const ANDROID_NDK_PATH = std.fmt.comptimePrint("{s}/ndk/27.0.12077973", .{ANDROID_PATH});
const ANDROID_VER = 35;
const ANDROID_BUILD_TOOL_VER = "35.0.0";
///(기본값)상대 경로 또는 절대 경로로 설정하기

//keystore 없으면 생성
//keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000
const ANDROID_KEYSTORE = "debug.keystore";
//*

inline fn get_lazypath(b: *std.Build, path: []const u8) std.Build.LazyPath {
    return if (std.fs.path.isAbsolute(path)) .{ .cwd_relative = path } else b.path(path);
}

inline fn get_arch_text(arch: std.Target.Cpu.Arch) []const u8 {
    return switch (arch) {
        .x86_64 => "x86_64",
        .aarch64 => "aarch64",
        .arm => "arm",
        else => unreachable,
    };
}

pub fn init(
    b: *std.Build,
    comptime name: []const u8, //manefest의 android.app.lib_name 와 같게
    root_source_file: std.Build.LazyPath,
    comptime engine_path: []const u8,
    PLATFORM: XfitPlatform,
    OPTIMIZE: std.builtin.OptimizeMode,
    callback: fn (*std.Build.Step.Compile, std.Build.ResolvedTarget) void,
    is_console: bool, //ignores for target mobile
) void {
    if (builtin.os.tag == .windows) {
        const path: []u8 = std.fmt.allocPrint(b.allocator, "{s}/shader_compile.bat", .{engine_path}) catch unreachable;
        defer b.allocator.free(path);
        const realpath: []u8 = std.fs.cwd().realpathAlloc(b.allocator, path) catch unreachable;
        defer b.allocator.free(realpath);

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, b.allocator);
        _ = pro.spawnAndWait() catch unreachable;
    } else {
        const path: []u8 = std.fmt.allocPrint(b.allocator, "{s}/shader_compile.sh", .{engine_path}) catch unreachable;
        defer b.allocator.free(path);
        const realpath: []u8 = std.fs.cwd().realpathAlloc(b.allocator, path) catch unreachable;
        defer b.allocator.free(realpath);

        var pro = std.process.Child.init(&[_][]const u8{ realpath, engine_path }, b.allocator);
        _ = pro.spawnAndWait() catch unreachable;
    }

    const build_options = b.addOptions();

    build_options.addOption(XfitPlatform, "platform", PLATFORM);
    build_options.addOption(std.Target.SubSystem, "subsystem", if (is_console) .Console else .Windows);

    const arch_text = comptime [_][]const u8{
        "aarch64-linux-android",
        "x86_64-linux-android",
    };
    const out_arch_text = comptime [_][]const u8{
        "../lib/arm64-v8a",
        "../lib/x86_64",
    };
    const targets = [_]std.Target.Query{
        .{ .os_tag = .linux, .cpu_arch = .aarch64, .abi = .android, .cpu_features_add = std.Target.aarch64.featureSet(&.{.v8a}) },
        .{ .os_tag = .linux, .cpu_arch = .x86_64, .abi = .android },
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
        "liblua.a",
    };

    const linux_system_lib_names = comptime [_][]const u8{
        "libwebp.a",
        "libwebpdemux.a",
        "libfreetype.a",
        "libogg.a",
        "libopus.a",
        "libopusfile.a",
        "libvorbis.a",
        "libvorbisenc.a",
        "libvorbisfile.a",
        "libvulkan.so",
        "libwayland-client.so",
        "libwayland-server.so",
        "libwayland-cursor.so",
    };
    const linux_local_lib_names = comptime [_][]const u8{
        "liblua.a",
        "miniaudio.o",
    };

    var i: usize = 0;
    while (i < targets.len) : (i += 1) {
        var result: *std.Build.Step.Compile = undefined;

        const build_options_module = build_options.createModule();

        if (PLATFORM == XfitPlatform.android) {
            if (is_console) @panic("mobile do not support console");

            const target = b.resolveTargetQuery(targets[i]);
            result = b.addSharedLibrary(.{
                .target = target,
                .name = name,
                .root_source_file = root_source_file,
                .optimize = OPTIMIZE,
                .pic = true,
            });
            var contents = std.ArrayList(u8).init(b.allocator);
            var writer = contents.writer();
            writer.print("include_dir={s}\n", .{std.fmt.allocPrint(b.allocator, "{s}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include", .{ANDROID_NDK_PATH}) catch unreachable}) catch unreachable;
            writer.print("sys_include_dir={s}\n", .{std.fmt.allocPrint(b.allocator, "{s}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/include/{s}", .{ ANDROID_NDK_PATH, arch_text[i] }) catch unreachable}) catch unreachable;
            writer.print("crt_dir={s}\n", .{std.fmt.allocPrint(b.allocator, "{s}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/{s}/{d}", .{ ANDROID_NDK_PATH, arch_text[i], ANDROID_VER }) catch unreachable}) catch unreachable;
            writer.writeAll("msvc_lib_dir=\n") catch unreachable;
            writer.writeAll("kernel32_lib_dir=\n") catch unreachable;
            writer.writeAll("gcc_dir=\n") catch unreachable;
            const android_libc_step = b.addWriteFile("android-libc.conf", contents.items);
            result.setLibCFile(android_libc_step.getDirectory().join(b.allocator, "android-libc.conf") catch unreachable);
            install_step.dependOn(&android_libc_step.step);

            result.addLibraryPath(.{ .cwd_relative = std.fmt.allocPrint(b.allocator, "{s}/toolchains/llvm/prebuilt/windows-x86_64/sysroot/usr/lib/{s}/{d}", .{ ANDROID_NDK_PATH, arch_text[i], ANDROID_VER }) catch unreachable });

            // result.addLibraryPath(get_lazypath(b, std.fmt.allocPrint(b.allocator, "{s}/lib/android/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?) }) catch unreachable));

            result.linkSystemLibrary("android");
            result.linkSystemLibrary("vulkan");
            //result.linkSystemLibrary("VkLayer_khronos_validation");
            result.linkSystemLibrary("c");
            result.linkSystemLibrary("log");

            for (lib_names) |n| {
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(b.allocator, "{s}/lib/android/{s}/{s}", .{ engine_path, get_arch_text(targets[i].cpu_arch.?), n }) catch unreachable));
            }

            callback(result, target);

            install_step.dependOn(&b.addInstallArtifact(result, .{
                .dest_dir = .{ .override = .{ .custom = out_arch_text[i] } },
            }).step);
        } else if (PLATFORM == XfitPlatform.windows) {
            const target = b.standardTargetOptions(.{ .default_target = .{
                .os_tag = .windows,
            } });

            result = b.addExecutable(.{
                .target = target,
                .name = name,
                .root_source_file = root_source_file,
                .optimize = OPTIMIZE,
            });
            result.linkLibC();

            if (is_console) {
                result.subsystem = .Console;
            } else {
                result.subsystem = .Windows;
            }
            result.linkSystemLibrary("setupapi");
            result.linkSystemLibrary("hid");
            //result.linkSystemLibrary("Gdi32");

            result.addObjectFile(get_lazypath(b, engine_path ++ "/lib/windows/vulkan.lib"));
            for (lib_names) |n| {
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(b.allocator, "{s}/lib/windows/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
            }

            callback(result, target);

            b.installArtifact(result);
        } else if (PLATFORM == XfitPlatform.linux) {
            const target = b.standardTargetOptions(.{ .default_target = .{
                .os_tag = .linux,
            } });

            result = b.addExecutable(.{
                .target = target,
                .name = name,
                .root_source_file = root_source_file,
                .optimize = OPTIMIZE,
            });
            result.linkLibC();
            if (is_console) {
                result.subsystem = .Console;
            } else {
                result.subsystem = .Posix;
            }

            for (linux_system_lib_names) |n| {
                result.addObjectFile(.{ .cwd_relative = std.fmt.allocPrint(b.allocator, "/usr/lib/{s}-linux-gnu/{s}", .{ get_arch_text(target.result.cpu.arch), n }) catch unreachable });
            }
            for (linux_local_lib_names) |n| {
                result.addObjectFile(get_lazypath(b, std.fmt.allocPrint(b.allocator, "{s}/lib/linux/{s}/{s}", .{ engine_path, get_arch_text(target.result.cpu.arch), n }) catch unreachable));
            }

            callback(result, target);

            b.installArtifact(result);
        } else unreachable;

        result.root_module.addImport("build_options", build_options_module);

        const xfit = b.addModule("xfit", .{ .root_source_file = get_lazypath(b, engine_path ++ "/xfit.zig") });
        xfit.addImport("build_options", build_options_module);
        result.root_module.addImport("xfit", xfit);

        xfit.addIncludePath(get_lazypath(b, engine_path ++ "/include"));
        xfit.addIncludePath(get_lazypath(b, engine_path ++ "/include/freetype"));
        xfit.addIncludePath(get_lazypath(b, engine_path ++ "/include/opus"));
        xfit.addIncludePath(get_lazypath(b, engine_path ++ "/include/opusfile"));

        result.addIncludePath(get_lazypath(b, engine_path ++ "/include"));
        result.addIncludePath(get_lazypath(b, engine_path ++ "/include/freetype"));
        result.addIncludePath(get_lazypath(b, engine_path ++ "/include/opus"));
        result.addIncludePath(get_lazypath(b, engine_path ++ "/include/opusfile"));

        if (PLATFORM != XfitPlatform.android) break;
    }

    var cmd: *std.Build.Step.Run = undefined;
    if (builtin.os.tag == .windows) {
        if (PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ engine_path ++ "/compile.bat", engine_path, b.install_path, "android", ANDROID_PATH, std.fmt.comptimePrint("{d}", .{ANDROID_VER}), ANDROID_BUILD_TOOL_VER, b.build_root.path.? });
        } else {
            cmd = b.addSystemCommand(&.{engine_path ++ "/compile.bat"});
        }
    } else {
        if (PLATFORM == XfitPlatform.android) {
            cmd = b.addSystemCommand(&.{ engine_path ++ "/compile.sh", engine_path, b.install_path, "android", ANDROID_PATH, std.fmt.comptimePrint("{d}", .{ANDROID_VER}), ANDROID_BUILD_TOOL_VER, b.build_root.path.? });
        } else {
            cmd = b.addSystemCommand(&.{engine_path ++ "/compile.sh"});
        }
    }
    cmd.step.dependOn(install_step);

    b.default_step.dependOn(&cmd.step);
}
