const std = @import("std");
const system = @import("system.zig");
const xfit = @import("xfit.zig");

//TODO 검증되지 않음

//// pub inline fn align_ptr_cast(dest_type: type, src: anytype) dest_type {
////     return @as(dest_type, @ptrCast(@alignCast(src)));
//// }
///src 타입 배열(Slice)을 u8 배열(Slice)로 변환한다.
pub inline fn u8arr(src: anytype) []u8 {
    return @as([*]u8, @ptrCast(src.ptr))[0..(@sizeOf(@TypeOf(src[0])) * src.len)];
}
///src 타입 배열(Slice)을 u8 배열(Slice)로 변환한다.
pub inline fn u8arrC(src: anytype) []const u8 {
    return @as([*]const u8, @ptrCast(src.ptr))[0..(@sizeOf(@TypeOf(src[0])) * src.len)];
}
///src 객체 포인터를 u8 배열(Slice)로 변환한다.
pub inline fn obj_to_u8arr(src: anytype) []u8 {
    return @as([*]u8, @ptrCast(src))[0..@sizeOf(@TypeOf(src.*))];
}
///src 객체 포인터를 u8 배열(Slice)로 변환한다.
pub inline fn obj_to_u8arrC(src: anytype) []const u8 {
    return @as([*]const u8, @ptrCast(src))[0..@sizeOf(@TypeOf(src.*))];
}
///src 타입 배열(Slice)을 dest_type 타입 배열(Slice)로 변환한다.
pub inline fn cvtarr(comptime dest_type: type, src: anytype) []dest_type {
    return @as([*]dest_type, src.ptr)[0..@divFloor((@sizeOf(@TypeOf(src[0])) * src.len), @sizeOf(dest_type))];
}
///src 타입 배열(Slice)을 dest_type 타입 배열(Slice)로 변환한다.
pub inline fn cvtarrC(comptime dest_type: type, src: anytype) []const dest_type {
    return @as([*]const dest_type, src.ptr)[0..@divFloor((@sizeOf(@TypeOf(src[0])) * src.len), @sizeOf(dest_type))];
}

pub const check_alloc = struct {
    const Self = @This();
    __check_alloc: if (xfit.dbg) ?[]bool else void = if (xfit.dbg) null,
    allocator: if (xfit.dbg) std.mem.Allocator else void = if (xfit.dbg) undefined,

    pub fn init(self: *Self, _allocator: std.mem.Allocator) void {
        if (xfit.dbg) {
            self.*.allocator = _allocator;
            if (self.*.__check_alloc != null) xfit.herrm("alloc __check_alloc already alloc");
            self.*.__check_alloc = self.*.allocator.alloc(bool, 1) catch |e| xfit.herr3("alloc __check_alloc", e);
        }
    }
    pub fn check_inited(self: *Self) void {
        if (xfit.dbg) {
            if (self.*.__check_alloc == null) {
                xfit.herrm("check_inited __check_alloc is null");
            }
        }
    }
    pub fn deinit(self: *Self) void {
        if (xfit.dbg) {
            if (self.*.__check_alloc == null) xfit.herrm("free __check_alloc is null");
            self.*.allocator.free(self.*.__check_alloc.?);
        }
    }
};

pub const check_init = struct {
    const Self = @This();
    __check_init: if (xfit.dbg) bool else void = if (xfit.dbg) false,

    pub fn check_inited(self: *Self) void {
        if (xfit.dbg) {
            if (!self.*.__check_init) {
                xfit.herrm("check_inited __check_alloc is null");
            }
        }
    }
    pub fn init(self: *Self) void {
        if (xfit.dbg) {
            if (self.*.__check_init) xfit.herrm("__check_init already init");
            self.*.__check_init = true;
        }
    }
    pub fn deinit(self: *Self) void {
        if (xfit.dbg) {
            if (!self.*.__check_init) xfit.herrm("__check_init not init");
            self.*.__check_init = false;
        }
    }
};
