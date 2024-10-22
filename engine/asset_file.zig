const std = @import("std");
const system = @import("system.zig");

const __android = @import("__android.zig");

const AAsset = __android.android.AAsset;

comptime {
    if (system.platform != .android) @compileError("asset_file only can use android.");
}

const Self = @This();

pub const INVALID_FILE_HANDLE: ?*AAsset = null;

handle: ?*AAsset = INVALID_FILE_HANDLE,

pub inline fn is_open(self: *Self) bool {
    return self.handle != INVALID_FILE_HANDLE;
}
pub inline fn open(self: *Self, path: []const u8) !void {
    const pathc = try std.heap.c_allocator.dupeZ(u8, path);
    defer std.heap.c_allocator.free(pathc);
    self.*.handle = __android.android.AAssetManager_open(__android.get_AssetManager(), pathc.ptr, __android.android.AASSET_MODE_BUFFER);
    if (self.*.handle == INVALID_FILE_HANDLE) return std.posix.UnexpectedError.Unexpected;
}
pub inline fn read(self: *Self, buffer: []u8) !usize {
    var _read: usize = 0;
    while (_read < buffer.len) {
        const i = __android.android.AAsset_read(self.handle, &buffer[_read], buffer.len - _read);
        if (i < 0) {
            return std.posix.UnexpectedError.Unexpected;
        } else if (i == 0) {
            break;
        }
        _read += @intCast(i);
    }
    return _read;
}
pub inline fn close(self: *Self) void {
    if (self.handle == INVALID_FILE_HANDLE) {
        system.print_error("WARN Can't close INVALID_FILE_HANDLE(not open asset_file)\n", .{});
        return;
    }
    __android.android.AAsset_close(self.handle);
    self.handle = INVALID_FILE_HANDLE;
}
pub inline fn seekTo(self: *Self, idx: i64) !void {
    if (-1 == __android.android.AAsset_seek64(self.handle, idx, std.posix.SEEK.SET)) {
        return std.posix.SeekError.Unexpected;
    }
}
pub inline fn seekBy(self: *Self, idx: i64) !void {
    if (-1 == __android.android.AAsset_seek64(self.handle, idx, std.posix.SEEK.CUR)) {
        return std.posix.SeekError.Unexpected;
    }
}
pub inline fn seekFromEnd(self: *Self, idx: i64) !void {
    if (-1 == __android.android.AAsset_seek64(self.handle, idx, std.posix.SEEK.END)) {
        return std.posix.SeekError.Unexpected;
    }
}
pub inline fn getPos(self: *Self) !u64 {
    return self.*.size() - @as(u64, @intCast(__android.android.AAsset_getRemainingLength64(self.handle)));
}
pub inline fn size(self: *Self) u64 {
    return @intCast(__android.android.AAsset_getLength64(self.handle));
}

pub fn read_file(path: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var __size: usize = 0;
    var buffer: []u8 = undefined;

    const pathc = try std.heap.c_allocator.dupeZ(u8, path);
    defer std.heap.c_allocator.free(pathc);

    const asset = __android.android.AAssetManager_open(__android.get_AssetManager(), pathc.ptr, __android.android.AASSET_MODE_BUFFER);

    __size = @intCast(__android.android.AAsset_getLength64(asset));

    buffer = try allocator.alloc(u8, __size);
    errdefer allocator.free(buffer);

    var _read: usize = 0;
    while (_read < __size) {
        const i = __android.android.AAsset_read(asset, &buffer[_read], __size - _read);
        if (i < 0) {
            return std.posix.UnexpectedError.Unexpected;
        } else if (i == 0) {
            break;
        }
        _read += @intCast(i);
    }

    __android.android.AAsset_close(asset);

    return buffer;
}
