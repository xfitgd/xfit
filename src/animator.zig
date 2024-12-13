const std = @import("std");
const graphics = @import("graphics.zig");
const xfit = @import("xfit.zig");

const animate_image = graphics.animate_image;
const iobject = graphics.iobject;

pub const ianimate_object = struct {
    target: *anyopaque,
    v: *const vtable,

    pub const vtable = struct {
        v: iobject.vtable,
        prev_frame: *const fn (self: *anyopaque) void,
        next_frame: *const fn (self: *anyopaque) void,
        set_frame: *const fn (self: *anyopaque, _frame: u32) void,
        cur_frame: *const fn (self: *anyopaque) u32,
        get_frame_count_build: *const fn (self: *anyopaque) u32,

        pub fn make(comptime T: type) vtable {
            return .{
                .prev_frame = @ptrCast(&T.prev_frame),
                .next_frame = @ptrCast(&T.next_frame),
                .set_frame = @ptrCast(&T.set_frame),
                .cur_frame = @ptrCast(&T.cur_frame),
                .get_frame_count_build = @ptrCast(&T.get_frame_count_build),
                .v = iobject.vtable.make(T),
            };
        }
        pub const find = graphics.iobject.vtable.find;
    };

    pub fn deinit(self: ianimate_object) void {
        self.v.*.v.deinit(self.target);
    }
    pub fn prev_frame(self: ianimate_object) void {
        self.v.*.prev_frame(self.target);
    }
    pub fn next_frame(self: ianimate_object) void {
        self.v.*.next_frame(self.target);
    }
    pub fn set_frame(self: ianimate_object, _frame: u32) void {
        self.v.*.set_frame(self.target, _frame);
    }
    pub fn cur_frame(self: ianimate_object) u32 {
        return self.v.*.cur_frame(self.target);
    }
    pub fn get_frame_count_build(self: ianimate_object) u32 {
        return self.v.*.get_frame_count_build(self.target);
    }
    pub fn init(_obj_ptr: anytype) ianimate_object {
        return iobject.__init(_obj_ptr, ianimate_object);
    }
};

pub const multi_player = struct {
    objs: []ianimate_object,
    playing: bool = false,
    target_fps: f32 = 30,
    __playing_dt: f32 = 0,
    loop: bool = true,

    pub fn update(self: *multi_player, _dt: f64) void {
        if (self.*.playing) {
            const dt: f32 = @floatCast(_dt);
            self.*.__playing_dt += dt;
            while (self.*.__playing_dt >= 1 / self.*.target_fps) : (self.*.__playing_dt -= 1 / self.*.target_fps) {
                var isp: bool = false;
                for (self.*.objs) |*v| {
                    if (self.*.loop or v.*.cur_frame() < v.*.get_frame_count_build() - 1) {
                        v.*.next_frame();
                        isp = true;
                    }
                }
                if (!isp) {
                    self.*.stop();
                    return;
                }
            }
        }
    }
    pub fn play(self: *multi_player) void {
        self.*.playing = true;
        self.*.__playing_dt = 0.0;
    }
    pub fn stop(self: *multi_player) void {
        self.*.playing = false;
    }
    pub fn set_frame(self: *multi_player, _frame: u32) void {
        for (self.*.objs) |*v| {
            v.*.set_frame(_frame);
        }
    }
    pub fn prev_frame(self: *multi_player) void {
        for (self.*.objs) |*v| {
            v.*.prev_frame();
        }
    }
    pub fn next_frame(self: *multi_player) void {
        for (self.*.objs) |*v| {
            v.*.next_frame();
        }
    }
};

pub const player = struct {
    obj: ianimate_object,
    playing: bool = false,
    target_fps: f64 = 30,
    __playing_dt: f64 = 0,
    loop: bool = true,

    pub fn update(self: *player, _dt: f64) void {
        if (self.*.playing) {
            const dt: f64 = _dt;
            self.*.__playing_dt += dt;
            while (self.*.__playing_dt >= 1 / self.*.target_fps) : (self.*.__playing_dt -= 1 / self.*.target_fps) {
                if (self.*.loop or self.*.obj.cur_frame() < self.*.obj.get_frame_count_build() - 1) {
                    self.*.obj.next_frame();
                } else {
                    self.*.stop();
                    return;
                }
            }
        }
    }
    pub fn play(self: *player) void {
        self.*.playing = true;
        self.*.__playing_dt = 0.0;
    }
    pub fn stop(self: *player) void {
        self.*.playing = false;
    }
    pub fn set_frame(self: *player, _frame: u32) void {
        self.*.obj.set_frame(_frame);
    }
    pub fn prev_frame(self: *player) void {
        self.*.obj.prev_frame();
    }
    pub fn next_frame(self: *player) void {
        self.*.obj.next_frame();
    }
};
