const std = @import("std");
const xfit = @import("xfit.zig");

const graphics = @import("graphics.zig");

///for using non xfit dependency
const CHECK_EXIT = true;
const PRINT_ERROR = true;

inline fn loop(wait_nanosec: u64, comptime function: anytype, args: anytype) bool {
    std.time.sleep(wait_nanosec);
    if (CHECK_EXIT and xfit.exiting()) return false;
    return callback_(function, args);
}

fn callback_(comptime function: anytype, args: anytype) bool {
    const res = @typeInfo(@typeInfo(@TypeOf(function)).@"fn".return_type.?);
    if (res == .error_union) { // ? code from standard library Thread.zig
        if (res.error_union.payload == bool) {
            return @call(.auto, function, args) catch |err| {
                if (PRINT_ERROR) xfit.herr3("timer_callback callback_", err);
            };
        } else {
            _ = @call(.auto, function, args) catch |err| {
                if (PRINT_ERROR) xfit.herr3("timer_callback callback_", err);
            };
        }
    } else if (res == .bool) {
        return @call(.auto, function, args);
    } else {
        _ = @call(.auto, function, args);
    }
    return true;
}

fn callback(wait_nanosec: u64, repeat: u64, comptime function: anytype, args: anytype) void {
    var re = repeat;
    if (re == 0) {
        while (loop(wait_nanosec, function, args) and (!CHECK_EXIT or !xfit.exiting())) {}
    } else {
        while (re > 0 and loop(wait_nanosec, function, args) and (!CHECK_EXIT or !xfit.exiting())) : (re -= 1) {}
    }
}

fn callback2(
    wait_nanosec: u64,
    repeat: u64,
    comptime function: anytype,
    comptime start_func: anytype,
    comptime end_func: anytype,
    args: anytype,
    start_args: anytype,
    end_args: anytype,
) void {
    var re = repeat;
    if (@TypeOf(start_func) != @TypeOf(null)) {
        if (!callback_(start_func, start_args)) return;
    }
    if (re == 0) {
        while (loop(wait_nanosec, function, args) and (!CHECK_EXIT or !xfit.exiting())) {}
    } else {
        while (re > 0 and loop(wait_nanosec, function, args) and (!CHECK_EXIT or !xfit.exiting())) : (re -= 1) {}
    }
    if (@TypeOf(end_func) != @TypeOf(null)) {
        _ = callback_(end_func, end_args);
    }
}

///no spawn thread each callback function bool callback function return false or cause error -> exit timer
pub fn start(wait_nanosec: u64, repeat: u64, comptime function: anytype, args: anytype) std.Thread.SpawnError!std.Thread {
    return try std.Thread.spawn(.{}, callback, .{ wait_nanosec, repeat, function, args });
}

///no spawn thread each callback function bool callback function return false or cause error -> exit timer
pub fn start2(
    wait_nanosec: u64,
    repeat: u64,
    comptime function: anytype,
    args: anytype,
    comptime start_func: anytype,
    comptime end_func: anytype,
    start_args: anytype,
    end_args: anytype,
) std.Thread.SpawnError!std.Thread {
    return try std.Thread.spawn(.{}, callback2, .{ wait_nanosec, repeat, function, start_func, end_func, args, start_args, end_args });
}
