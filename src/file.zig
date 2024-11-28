const std = @import("std");
const system = @import("system.zig");

const Self = @This();
const xfit = @import("xfit.zig");

pub const INVALID_FILE_HANDLE: std.fs.File.Handle = if (xfit.platform == .windows) @ptrCast(std.os.windows.INVALID_HANDLE_VALUE) else 0;

hFile: std.fs.File = .{ .handle = INVALID_FILE_HANDLE },

pub inline fn is_open(self: *Self) bool {
    return self.hFile.handle != INVALID_FILE_HANDLE;
}
pub inline fn open(self: *Self, path: []const u8, create_flags: std.fs.File.CreateFlags) !void {
    self.hFile = try std.fs.cwd().createFile(path, create_flags);
}
pub inline fn read(self: *Self, buffer: []u8) !usize {
    return try self.hFile.read(buffer);
}
pub inline fn write(self: *Self, buffer: []const u8) !usize {
    return try self.hFile.write(buffer);
}
pub inline fn writer(self: *Self) std.fs.File.Writer {
    return self.hFile.writer();
}
pub inline fn close(self: *Self) void {
    if (self.hFile.handle == INVALID_FILE_HANDLE) {
        xfit.print_error("WARN Can't close INVALID_FILE_HANDLE(not open file)\n", .{});
        return;
    }
    self.hFile.close();
    self.hFile.handle = INVALID_FILE_HANDLE;
}
pub inline fn seekTo(self: *Self, idx: i64) !void {
    try self.hFile.seekTo(idx);
}
pub inline fn seekBy(self: *Self, idx: i64) !void {
    try self.hFile.seekBy(idx);
}
pub inline fn seekFromEnd(self: *Self, idx: i64) !void {
    try self.hFile.seekFromEnd(idx);
}
pub inline fn writeCurrentStackTrace(self: *Self) void {
    const debug_info = std.debug.getSelfDebugInfo() catch @trap(); //recursive call is dangerous, so no error handling

    std.debug.writeCurrentStackTrace(self.*.writer(), debug_info, std.io.tty.detectConfig(self.*.hFile), @returnAddress()) catch @trap();
}
pub inline fn getPos(self: *Self) !u64 {
    return try self.hFile.getPos();
}
pub inline fn size(self: *Self) !u64 {
    return try self.hFile.getEndPos();
}
pub inline fn reader(self: *Self) std.fs.File.Reader {
    return self.hFile.reader();
}

pub fn read_file(path: []const u8, allocator: std.mem.Allocator) ![]u8 {
    var buffer: []u8 = undefined;

    const _file = try std.fs.cwd().createFile(path, .{ .read = true, .truncate = false });
    defer _file.close();
    const _size = (try _file.stat()).size;

    buffer = try allocator.alloc(u8, _size);

    _ = try _file.readAll(buffer);

    //xfit.print("size : {d}\n",.{size});

    return buffer;
}
