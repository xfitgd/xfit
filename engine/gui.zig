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
        if (!math.compare(self.com.scale_padding, .{ 0, 0 })) {
            if (!math.compare(self.com.scale, .{ 1, 1 })) {
                return matrix.translationXY(self.com.scale_padding * mul).multiply(&matrix.scalingXY(self.com.scale));
            } else {
                return matrix.translationXY(self.com.scale_padding * mul);
            }
        } else {
            if (!math.compare(self.com.scale, .{ 1, 1 })) {
                return matrix.scalingXY(self.com.scale);
            } else {
                return null;
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
                        const model = matrix.translationXY(.{ -proj.*.window_width() / 2 + self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = matrix.translationXY(.{ -proj.*.window_width() / 2 + self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = matrix.translationXY(.{ -proj.*.window_width() / 2 + self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                }
            },
            .center => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.base_mat(point{ 1, -1 });
                        const model = matrix.translationXY(.{ self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = matrix.translationXY(.{ self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ 1, 1 });
                        const model = matrix.translationXY(.{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                }
            },
            .right => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.base_mat(point{ -1, -1 });
                        const model = matrix.translationXY(.{ proj.*.window_width() / 2 - self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .middle => {
                        const base = self.base_mat(point{ -1, 1 });
                        const model = matrix.translationXY(.{ proj.*.window_width() / 2 - self.com.pos[0], self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
                    },
                    .bottom => {
                        const base = self.base_mat(point{ -1, 1 });
                        const model = matrix.translationXY(.{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] });
                        transform.*.model = if (base != null) base.?.multiply(&model) else model;
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
    pub fn get_rect(self: icomponent, _size: point) math.rect {
        const transform: *graphics.transform = self.obj.ptransform();
        const proj: *graphics.projection = transform.*.projection;
        switch (self.com.x_align) {
            .left => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.scale_padding * point{ 1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], proj.*.window_height() / 2 - self.com.pos[1] }, _size * self.com.scale);
                    },
                    .middle => {
                        const base = self.com.scale_padding * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], self.com.pos[1] }, _size * self.com.scale);
                    },
                    .bottom => {
                        const base = self.com.scale_padding * self.com.scale;
                        return math.rect.get(base + point{ -proj.*.window_width() / 2 + self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale);
                    },
                }
            },
            .center => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.scale_padding * point{ 1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale);
                    },
                    .middle => {
                        const base = self.com.scale_padding * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], self.com.pos[1] }, _size * self.com.scale);
                    },
                    .bottom => {
                        const base = self.com.scale_padding * self.com.scale;
                        return math.rect.get(base + point{ self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale);
                    },
                }
            },
            .right => {
                switch (self.com.y_align) {
                    .top => {
                        const base = self.com.scale_padding * point{ -1, -1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale);
                    },
                    .middle => {
                        const base = self.com.scale_padding * point{ -1, 1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], self.com.pos[1] }, _size * self.com.scale);
                    },
                    .bottom => {
                        const base = self.com.scale_padding * point{ -1, 1 } * self.com.scale;
                        return math.rect.get(base + point{ proj.*.window_width() / 2 - self.com.pos[0], -proj.*.window_height() / 2 + self.com.pos[1] }, _size * self.com.scale);
                    },
                }
            },
        }
    }
};

pub const component = struct {
    pos: point,
    scale_padding: point = .{ 0, 0 },
    scale: point = .{ 1, 1 },
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
