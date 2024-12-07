const std = @import("std");
const system = @import("system.zig");
const xfit = @import("xfit.zig");

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
