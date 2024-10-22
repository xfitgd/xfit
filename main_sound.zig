// !! windows platform only do not change
pub const UNICODE = false;
// !! android platform only do not change
comptime {
    if (@import("engine/system.zig").platform == .android)
        _ = @import("engine/__android.zig").android.ANativeActivity_createFunc;
}
// !!

const std = @import("std");
const xfit = @import("engine/xfit.zig");
const system = @import("engine/system.zig");
const sound = @import("engine/sound.zig");

var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
var allocator: std.mem.Allocator = undefined;

const file = @import("engine/file.zig");
const asset_file = @import("engine/asset_file.zig");
const timer_callback = @import("engine/timer_callback.zig");

const file_ = if (system.platform == .android) asset_file else file;

var bg_source: *sound.sound_source = undefined;
var bg_snd: *sound = undefined;
var sfx_source: *sound.sound_source = undefined;

pub fn sfx_callback() !void {
    _ = sfx_source.play_sound_memory(0.5, false) catch |e| system.handle_error3("sfx.play_sound_memory", e);
}

pub fn pl_callback() !void {
    bg_snd.*.pause();
    //bg_snd.*.resume_();
}

pub fn xfit_init() !void {
    sound.start();

    const snd = sound.play_sound("BG.opus", 0.2, true) catch |e| system.handle_error3("bg.play_sound", e) orelse system.handle_error_msg2("bg.play_sound null");
    bg_source = snd.*.source.?;
    bg_snd = snd;
    system.print("playtime : {d}\n", .{bg_snd.*.get_length_in_sec()});

    const data = file_.read_file("SFX.ogg", allocator) catch |e| system.handle_error3("sfx.read_file", e);
    defer allocator.free(data);
    sfx_source = sound.decode_sound_memory(data) catch |e| system.handle_error3("sfx.decode_sound_memory", e);

    _ = try timer_callback.start(1000000000, 0, sfx_callback, .{});
    _ = try timer_callback.start(10000000000, 1, pl_callback, .{});
}

pub fn xfit_update() !void {}

pub fn xfit_size() !void {}

///before system clean
pub fn xfit_destroy() !void {
    sound.destroy();
    bg_source.*.deinit();
    sfx_source.*.deinit();
}

///after system clean
pub fn xfit_clean() !void {
    if (system.dbg and gpa.deinit() != .ok) unreachable;
}

pub fn xfit_activate(is_activate: bool, is_pause: bool) !void {
    _ = is_activate;
    _ = is_pause;
}

pub fn xfit_closing() !bool {
    return true;
}

pub fn main() void {
    const init_setting: system.init_setting = .{
        .window_width = 640,
        .window_height = 480,
    };
    gpa = .{};
    allocator = gpa.allocator(); //반드시 할당자는 main에서 초기화
    xfit.xfit_main(allocator, &init_setting);
}
