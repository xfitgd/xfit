// !! android platform only do not change
comptime {
    _ = xfit.__android_entry;
}
// !!

const std = @import("std");
const xfit = @import("xfit");

var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
var allocator: std.mem.Allocator = undefined;

pub fn xfit_init() !void {}

pub fn xfit_update() !void {}

pub fn xfit_size() !void {}

///before system clean
pub fn xfit_destroy() !void {}

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
    const init_setting: xfit.init_setting = .{};
    gpa = .{};
    allocator = gpa.allocator(); //must init in main
    xfit.xfit_main(allocator, &init_setting);
}
