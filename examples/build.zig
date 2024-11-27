//user application build.zig example
const std = @import("std");
const xfit_build = @import("xfit_build");

//* User Setting
//크로스 플랫폼 빌드시 zig build -Dtarget=aarch64-windows(linux)
//x86_64-windows(linux)
// android platform need AndroidManifest.xml, keystore, (assets, res) folder in user project folder
const PLATFORM = xfit_build.XfitPlatform.linux;
const OPTIMIZE = std.builtin.OptimizeMode.Debug;

const EXAMPLE: EXAMPLES = EXAMPLES.GRAPHICS2D;
//*

const examples = [_][]const u8{
    "main.zig",
    "main_input.zig",
    "main_sound.zig",
    "main_console.zig",
};
const EXAMPLES = enum(usize) {
    GRAPHICS2D,
    INPUT,
    SOUND,
    CONSOLE,
};

fn callback(b: *std.Build, result: *std.Build.Step.Compile, target: std.Build.ResolvedTarget) void {
    //TODO 여기에 사용자 지정 라이브러리 등을 추가합니다.
    _ = b;
    _ = result;
    _ = target;
}

pub fn build(b: *std.Build) !void {
    const platform = b.option(xfit_build.XfitPlatform, "platform", "build platform") orelse PLATFORM;
    b.release_mode = .fast;

    const option = xfit_build.run_option{
        .name = "XfitTest",
        .root_source_file = b.*.path(examples[@intFromEnum(EXAMPLE)]),
        .PLATFORM = platform,
        .OPTIMIZE = b.standardOptimizeOption(.{ .preferred_optimize_mode = OPTIMIZE }),
        .callback = callback,
        .is_console = EXAMPLE == .CONSOLE,
        .ANDROID_KEYSTORE = "debug.keystore",
    };
    try xfit_build.run(b, option);
}
