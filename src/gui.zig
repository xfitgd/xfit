const std = @import("std");
const graphics = @import("graphics.zig");
const xfit = @import("xfit.zig");
const math = @import("math.zig");
const window = @import("window.zig");
const point = math.point;
const matrix = math.matrix;

const iobject = graphics.iobject;

pub const icomponent = struct {
    com: component,
    obj: *iobject,

    fn base_mat(self: icomponent, mul: point) ?matrix {
        if (!math.compare(self.com.center_pt, .{ 0, 0 })) {
            if (!math.compare(self.com.scale, .{ 1, 1 })) {
                if (self.com.rotation != 0) {
                    return math.matrix_multiply(math.matrix_translationXY(f32, self.com.center_pt * mul), math.matrix_multiply(math.matrix_scalingXY(f32, self.com.scale), math.matrix_rotation2D(f32, self.com.rotation)));
                } else {
                    return math.matrix_multiply(math.matrix_translationXY(f32, self.com.center_pt * mul), math.matrix_scalingXY(f32, self.com.scale));
                }
            } else {
                if (self.com.rotation != 0) {
                    return math.matrix_multiply(math.matrix_translationXY(f32, self.com.center_pt * mul), math.matrix_rotation2D(f32, self.com.rotation));
                } else {
                    return math.matrix_translationXY(f32, self.com.center_pt * mul);
                }
            }
        } else {
            if (!math.compare(self.com.scale, .{ 1, 1 })) {
                if (self.com.rotation != 0) {
                    return math.matrix_multiply(math.matrix_scalingXY(f32, self.com.scale), math.matrix_rotation2D(f32, self.com.rotation));
                } else {
                    return math.matrix_scalingXY(f32, self.com.scale);
                }
            } else {
                if (self.com.rotation != 0) {
                    return math.matrix_rotationZ(f32, self.com.rotation);
                } else {
                    return null;
                }
            }
        }
    }

    pub fn init(self: icomponent) void {
        const transform: *graphics.transform = self.obj.ptransform();
        const proj: *graphics.projection = transform.*.projection;

        switch (self.com.x_align) {
            .left => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.base_mat(point{ 1, -1 });
                        const model = math.matrix_translationXY(f32, .{ -proj.*.window_width() / 2 + self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = math.matrix_translationXY(f32, .{ -proj.*.window_width() / 2 + self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = math.matrix_translationXY(f32, .{ -proj.*.window_width() / 2 + self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                }
            },
            .center => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.base_mat(point{ 1, -1 });
                        const model = math.matrix_translationXY(f32, .{ self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = math.matrix_translationXY(f32, .{ self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = math.matrix_translationXY(f32, .{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                }
            },
            .right => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.base_mat(point{ -1, -1 });
                        const model = math.matrix_translationXY(f32, .{ proj.*.window_width() / 2 - self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ -1, 1 });
                        const model = math.matrix_translationXY(f32, .{ proj.*.window_width() / 2 - self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ -1, 1 });
                        const model = math.matrix_translationXY(f32, .{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) math.matrix_multiply(base.?, model) else model;
                    },
                }
            },
        }
    }

    pub inline fn size(self: icomponent) void {
        init(self);
        switch (self.obj.*) {
            inline else => |*case| {
                case.*.transform.copy_update();
            },
        }
    }
    pub fn get_rect(self: icomponent, _size: point, _CANVAS_W: f32, _CANVAS_H: f32) math.rect {
        const transform: *graphics.transform = self.obj.ptransform();
        const proj: *graphics.projection = transform.*.projection;
        switch (self.com.x_align) {
            .left => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.center_pt * point{ 1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .middle => {
                        const base = self.com.center_pt * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .bottom => {
                        const base = self.com.center_pt * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                }
            },
            .center => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.center_pt * point{ 1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .middle => {
                        const base = self.com.center_pt * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .bottom => {
                        const base = self.com.center_pt * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                }
            },
            .right => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.center_pt * point{ -1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .middle => {
                        const base = self.com.center_pt * point{ -1, 1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                    .bottom => {
                        const base = self.com.center_pt * point{ -1, 1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale).calc_with_canvas(_CANVAS_W, _CANVAS_H);
                    },
                }
            },
        }
    }
};

pub const component = struct {
    pos: point,
    center_pt: point = .{ 0, 0 },
    scale: point = .{ 1, 1 },
    rotation: f32 = 0,
    x_align: pos_x = .center,
    y_align: pos_y = .middle,
    pub const pos_x = enum {
        left,
        center,
        right,
    };
    pub const pos_y = enum {
        top,
        middle,
        bottom,
    };
};
