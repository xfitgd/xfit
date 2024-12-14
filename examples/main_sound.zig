// !! android platform only do not change
comptime {
    _ = xfit.__android_entry;
}
// !!

const std = @import("std");
const xfit = @import("xfit");
const sound = xfit.sound;

var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
var allocator: std.mem.Allocator = undefined;

const file_ = if (xfit.platform == .android) xfit.asset_file else xfit.file;

var bg_source: *sound.sound_source = undefined;
var bg_snd: *sound = undefined;
var sfx_source: *sound.sound_source = undefined;

pub fn sfx_callback() !void {
    _ = sfx_source.play_sound_memory(0.5, false) catch |e| xfit.herr3("sfx.play_sound_memory", e);
}

pub fn pl_callback() !void {
    bg_snd.*.pause();
    //bg_snd.*.resume_();
}

pub fn xfit_init() !void {
    const snd = sound.play_sound("BG.opus", 0.2, true) catch |e| xfit.herr3("bg.play_sound", e) orelse xfit.herrm("bg.play_sound null");
    bg_source = snd.*.source.?;
    bg_snd = snd;
    xfit.print("playtime : {d}\n", .{bg_snd.*.get_length_in_sec()});

    const data = file_.read_file("SFX.ogg", allocator) catch |e| xfit.herr3("sfx.read_file", e);
    defer allocator.free(data);
    sfx_source = sound.decode_sound_memory(data) catch |e| xfit.herr3("sfx.decode_sound_memory", e);

    _ = try xfit.timer_callback.start(1000000000, 0, sfx_callback, .{});
    _ = try xfit.timer_callback.start(10000000000, 1, pl_callback, .{});
}

pub fn xfit_update() !void {}

pub fn xfit_size() !void {}

///before system clean
pub fn xfit_destroy() !void {
    bg_source.*.deinit();
    sfx_source.*.deinit();
}

///after system clean
pub fn xfit_clean() !void {
    if (xfit.dbg and gpa.deinit() != .ok) unreachable;
}

pub fn xfit_activate(is_activate: bool, is_pause: bool) !void {
    _ = is_activate;
    _ = is_pause;
}

pub fn xfit_closing() !bool {
    return true;
}

pub fn main() !void {
    const init_setting: xfit.init_setting = .{
        .window_width = 640,
        .window_height = 480,
    };
    gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    allocator = gpa.allocator(); //must init in main
    xfit.xfit_main(allocator, &init_setting);
}
