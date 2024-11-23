const std = @import("std");
const ArrayList = std.ArrayList;

const render_command = @import("render_command.zig");
const __system = @import("__system.zig");

pub var render_cmd_list: ?ArrayList(*render_command) = null;
pub var mutex: std.Thread.Mutex = .{};

pub fn start() void {
    render_cmd_list = ArrayList(*render_command).init(__system.allocator);
}

pub fn __refresh_all() void {
    mutex.lock();
    defer mutex.unlock();
    if (render_cmd_list == null) return;
    for (render_cmd_list.?.items) |cmd| {
        cmd.*.__refresh_cmds();
        cmd.*.refresh();
    }
}

pub fn refresh_all() void {
    mutex.lock();
    defer mutex.unlock();
    if (render_cmd_list == null) return;
    for (render_cmd_list.?.items) |cmd| {
        cmd.*.refresh();
    }
    mutex.unlock();
}

pub fn destroy() void {
    render_cmd_list.?.deinit();
}