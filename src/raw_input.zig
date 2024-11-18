//Windows Only
const std = @import("std");

const __windows = @import("__windows.zig");
const system = @import("system.zig");
const __raw_input = @import("__raw_input.zig");

pub const GUID = __windows.win32.GUID;

pub const ERROR = error{
    SYSTEM_ERROR,
    ZERO_DEVICE,
    WRITE_FAIL,
    NO_IDX,
};

pub const CallBackFn = *const fn (handle: ?*anyopaque, _device_idx: u32, _user_data: ?*anyopaque) void;
pub const ChangeDeviceFn = *const fn (_device_idx: u32, add_or_remove: bool, _user_data: ?*anyopaque) void;

handle: *anyopaque,

const Self = @This();

pub fn init(self: *Self, _MAX_DEVICES: u32, _guid: *const GUID, _change_fn: ChangeDeviceFn, _user_data: ?*anyopaque) ERROR!void {
    self.*.handle = @ptrCast(try __raw_input.init(_MAX_DEVICES, _guid, _change_fn, _user_data));
}

pub fn deinit(self: *Self) void {
    @as(*__raw_input, @alignCast(@ptrCast(self.*.handle))).*.deinit();
}

pub fn set_callback(self: *Self, _fn: CallBackFn) void {
    @as(*__raw_input, @alignCast(@ptrCast(self.*.handle))).*.set_callback(_fn);
}

pub fn set(self: *Self, device_idx: u32, data: []const u8) !u32 {
    return try @as(*__raw_input, @alignCast(@ptrCast(self.*.handle))).*.set(device_idx, data);
}

pub fn get(self: *Self, idx: u32, ctl_code: u32, in: []const u8, out: []u8) bool {
    return try @as(*__raw_input, @alignCast(@ptrCast(self.*.handle))).*.get(idx, ctl_code, in, out);
}
