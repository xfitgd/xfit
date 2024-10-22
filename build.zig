const std = @import("std");
const builtin = @import("builtin");
const engine = @import("engine/engine.zig");
pub const XfitPlatform = engine.XfitPlatform;

//* User Setting
//크로스 플랫폼 빌드시 zig build -Dtarget=aarch64-windows(linux)
//x86_64-windows(linux)
const PLATFORM = XfitPlatform.windows;
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

fn callback(result: *std.Build.Step.Compile, target: std.Build.ResolvedTarget) void {
    //TODO 여기에 사용자 지정 라이브러리 등을 추가합니다.
    _ = result;
    _ = target;
}

pub fn build(b: *std.Build) void {
    const platform = b.option(XfitPlatform, "platform", "build platform") orelse PLATFORM;
    b.release_mode = .fast;
    engine.init(
        b,
        b.path(examples[@intFromEnum(EXAMPLE)]),
        "engine",
        platform,
        b.standardOptimizeOption(.{ .preferred_optimize_mode = OPTIMIZE }),
        callback,
        EXAMPLE == .CONSOLE,
    );
}
