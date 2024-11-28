const std = @import("std");

const system = @import("system.zig");
const window = @import("window.zig");
const input = @import("input.zig");

//https://github.com/zig-gamedev/zig-gamedev/blob/main/libs/zmath/src/zmath.zig

pub fn ceil_up(_num: anytype, _multiple: anytype) @TypeOf(_num) {
    if (_multiple == 0)
        return _num;

    const remainder: @TypeOf(_num) = @abs(_num) % _multiple;
    if (remainder == 0)
        return _num;

    if (_num < 0) {
        return -(@abs(_num) - remainder);
    } else {
        return _num + _multiple - remainder;
    }
}

pub fn floor_up(_num: anytype, _multiple: anytype) @TypeOf(_num) {
    if (_multiple == 0)
        return _num;

    const remainder: @TypeOf(_num) = @abs(_num) % _multiple;
    if (remainder == 0)
        return _num;

    if (_num < 0) {
        return -(@abs(_num) - remainder);
    } else {
        return _num - remainder;
    }
}

pub inline fn test_number_type(comptime T: type) void {
    switch (@typeInfo(T)) {
        .int, .float, .comptime_int, .comptime_float => {},
        else => {
            @compileError("not a number type");
        },
    }
}
pub inline fn test_float_type(comptime T: type) void {
    switch (@typeInfo(T)) {
        .float, .comptime_float => {},
        else => {
            @compileError("not a float number type");
        },
    }
}

pub inline fn pow(v0: anytype, p: anytype) @TypeOf(v0) {
    if (p == 2) return v0 * v0;
    if (p == 3) return v0 * v0 * v0;
    return std.math.pow(@TypeOf(v0), v0, @floatCast(p));
}

pub fn rect_(comptime T: type) type {
    const pointT = switch (T) {
        u32 => pointu,
        u64 => pointu8,
        f32 => point,
        f64 => point8,
        i32 => pointi,
        i64 => pointi8,
        else => @compileError("not a rect compatible type"),
    };
    return struct {
        const Self = @This();
        left: T,
        right: T,
        top: T,
        bottom: T,

        pub inline fn width(self: Self) T {
            return @intCast(@abs(self.right - self.left));
        }
        pub inline fn height(self: Self) T {
            return @intCast(@abs(self.top - self.bottom));
        }
        pub fn init(_left: T, _right: T, _top: T, _bottom: T) Self {
            return Self{
                .left = _left,
                .right = _right,
                .top = _top,
                .bottom = _bottom,
            };
        }
        pub fn flipY(self: Self) Self {
            return .{
                .left = self.left,
                .right = self.right,
                .top = self.bottom,
                .bottom = self.top,
            };
        }
        pub fn eql(self: Self, target: Self) bool {
            return self.left == target.left and
                self.right == target.right and
                self.top == target.top and
                self.bottom == target.bottom;
        }
        pub fn calc_with_canvas(self: Self, _CANVAS_W: T, _CANVAS_H: T) Self {
            if (@typeInfo(T) != .float) @compileError("rect T type must be float");

            const _width = @as(f32, @floatFromInt(window.window_width()));
            const _height = @as(f32, @floatFromInt(window.window_height()));
            const ratio = if (_width / _height > _CANVAS_W / _CANVAS_H) _height / _CANVAS_H else _width / _CANVAS_W;

            return .{
                .left = self.left * ratio,
                .right = self.right * ratio,
                .top = self.top * ratio,
                .bottom = self.bottom * ratio,
            };
        }
        pub fn get(_pos: pointT, _size: pointT) Self {
            if (@typeInfo(T) != .float) @compileError("rect T type must be float");
            return .{
                .left = _pos[0] - _size[0] / 2,
                .right = _pos[0] + _size[0] / 2,
                .top = _pos[1] + _size[1] / 2,
                .bottom = _pos[1] - _size[1] / 2,
            };
        }
        fn rect_matrix(_type: type) type {
            const info = @typeInfo(_type);
            if (info != .float) @compileError("rect T type must be float");
            if (info.float.bits == 32) return matrix;
            return matrix_(_type);
        }
        pub fn mul_matrix(self: Self, mat: rect_matrix(T)) Self {
            return .{
                .left = mat.mul_point(self.left),
                .right = mat.mul_point(self.right),
                .top = mat.mul_point(self.top),
                .bottom = mat.mul_point(self.bottom),
            };
        }
        pub fn div_matrix(self: Self, mat: rect_matrix(T)) !Self {
            return .{
                .left = try mat.div_point(self.left),
                .right = try mat.div_point(self.right),
                .top = try mat.div_point(self.top),
                .bottom = try mat.div_point(self.bottom),
            };
        }
        pub fn is_point_in(self: Self, pt: pointT) bool {
            return self.left <= pt[0] and self.right >= pt[0] and self.top >= pt[1] and self.bottom <= pt[1];
        }
        pub fn is_point_in_window_rect(self: Self, pt: pointT) bool {
            return self.left <= pt[0] and self.right >= pt[0] and self.top <= pt[1] and self.bottom >= pt[1];
        }
        pub fn is_mouse_in(self: Self) bool {
            return self.is_point_in(input.get_cursor_pos());
        }
        pub fn is_mouse_in_window_rect(self: Self) bool {
            return self.is_point_in_window_rect(input.get_cursor_pos());
        }
    };
}

pub const rect = rect_(f32);
pub const recti = rect_(i32);
pub const rectu = rect_(u32);

comptime {
    if (@sizeOf(point) != @sizeOf([2]f32)) @compileError("\'point\' type size not equal [2]f32!");
    if (@sizeOf(vector) != @sizeOf([4]f32)) @compileError("\'vector\' type size not equal [4]f32!");
}

pub const point = @Vector(2, f32);
pub const point8 = @Vector(2, f64);
pub const pointu = @Vector(2, u32);
pub const pointu8 = @Vector(2, u64);
pub const pointi = @Vector(2, i32);
pub const pointi8 = @Vector(2, i64);
pub const vector = @Vector(4, f32);
pub const vector8 = @Vector(4, f64);

pub const point3d = @Vector(3, f32);
pub const point3d8 = @Vector(3, f64);

pub fn point_(comptime float_T: type) type {
    if (@typeInfo(float_T) != .float) @compileError("float_T must be a float type");
    return @Vector(2, float_T);
}
pub fn point3d_(comptime float_T: type) type {
    if (@typeInfo(float_T) != .float) @compileError("float_T must be a float type");
    return @Vector(3, float_T);
}
pub fn vector_(comptime float_T: type) type {
    if (@typeInfo(float_T) != .float) @compileError("float_T must be a float type");
    return @Vector(4, float_T);
}

pub fn length_pow(p1: anytype, p2: anytype) @TypeOf(p1[0], p2[0]) {
    if (@typeInfo(@TypeOf(p1, p2)) == .vector) {
        test_float_type(@typeInfo(@TypeOf(p1, p2)).vector.child);
        if (@typeInfo(@TypeOf(p1)).vector.len != @typeInfo(@TypeOf(p2)).vector.len) @compileError("p1, p2 different vector len");
        comptime var i = 0;
        var result: @TypeOf(p1[0]) = 0;
        inline while (i < @typeInfo(@TypeOf(p1, p2)).vector.len) : (i += 1) {
            result += pow(p1[i] - p2[i], 2);
        }
        return result;
    } else if (@typeInfo(@TypeOf(p1, p2)) == .array) {
        test_float_type(@typeInfo(@TypeOf(p1, p2)).array.child);
        comptime var i = 0;
        var result: @TypeOf(p1[0]) = 0;
        inline while (i < p1.len) : (i += 1) {
            result += pow(p1[i] - p2[i], 2);
        }
        return result;
    } else {
        @compileError("not a vector, float array type");
    }
}
pub fn length(p1: anytype, p2: anytype) @TypeOf(p1[0], p2[0]) {
    return std.math.sqrt(length_pow(p1, p2));
}
pub fn length_pow1(p1: anytype) @TypeOf(p1[0]) {
    if (@typeInfo(@TypeOf(p1)) == .vector) {
        test_float_type(@typeInfo(@TypeOf(p1)).vector.child);
        comptime var i = 0;
        var result: @TypeOf(p1[0]) = 0;
        inline while (i < @typeInfo(@TypeOf(p1)).vector.len) : (i += 1) {
            result += pow(p1[i], 2);
        }
        return result;
    } else if (@typeInfo(@TypeOf(p1)) == .array) {
        test_float_type(@typeInfo(@TypeOf(p1)).array.child);
        comptime var i = 0;
        var result: @TypeOf(p1[0]) = 0;
        inline while (i < p1.len) : (i += 1) {
            result += pow(p1[i], 2);
        }
        return result;
    } else {
        @compileError("not a vector, float array type");
    }
}
pub fn length1(p1: anytype) @TypeOf(p1[0]) {
    return std.math.sqrt(length_pow1(p1));
}

pub inline fn dot3(v0: anytype, v1: anytype) @TypeOf(v0[0], v1[0]) {
    if (@typeInfo(@TypeOf(v0, v1)) == .vector) {
        test_float_type(@typeInfo(@TypeOf(v0, v1)).vector.child);
        const dot = v0 * v1;

        comptime var i = 0;
        var res: f32 = 0;
        const len = if (@typeInfo(@TypeOf(v0, v1)).vector.len < 3) @typeInfo(@TypeOf(v0, v1)).vector.len else 3;
        inline while (i < len) : (i += 1) {
            res += dot[i];
        }
        return res;
    } else if (@typeInfo(@TypeOf(v0, v1)) == .array) {
        test_float_type(@typeInfo(@TypeOf(v0, v1)).array.child);
        comptime var i = 0;
        var res: f32 = 0;
        const len = if (@typeInfo(@TypeOf(v0, v1)).array.len < 3) @typeInfo(@TypeOf(v0, v1)).vector.len else 3;
        inline while (i < len) : (i += 1) {
            res += v0[i] * v1[i];
        }
        return res;
    } else {
        @compileError("not a vector, float array type");
    }
}
pub inline fn sub(a: anytype, b: anytype) @TypeOf(a, b) {
    return calc(a, b, calc_sub);
}
pub inline fn add(a: anytype, b: anytype) @TypeOf(a, b) {
    return calc(a, b, calc_add);
}
pub inline fn mul(a: anytype, b: anytype) @TypeOf(a, b) {
    return calc(a, b, calc_mul);
}
pub inline fn div(a: anytype, b: anytype) @TypeOf(a, b) {
    return calc(a, b, calc_div);
}

inline fn calc_add(a: anytype, b: anytype) @TypeOf(a, b) {
    return a + b;
}
inline fn calc_sub(a: anytype, b: anytype) @TypeOf(a, b) {
    return a - b;
}
inline fn calc_mul(a: anytype, b: anytype) @TypeOf(a, b) {
    return a * b;
}
inline fn calc_div(a: anytype, b: anytype) @TypeOf(a, b) {
    return a / b;
}
inline fn calc(a: anytype, b: anytype, calc_func: anytype) @TypeOf(a, b) {
    if (@typeInfo(@TypeOf(a, b)) == .vector) {
        return calc_func(a, b);
    } else if (@typeInfo(@TypeOf(a, b)) == .array) {
        test_number_type(@typeInfo(@TypeOf(a, b)).array.child);
        if (a.len != b.len) @compileError("a, b len must same");

        comptime var i = 0;
        var result: @TypeOf(a, b) = undefined;
        inline while (i < a.len) : (i += 1) {
            result[i] = calc_func(a[i], b[i]);
        }
        return result;
    } else {
        @compileError("not a vector, array type");
    }
}
pub inline fn normalize(v: anytype) @TypeOf(v) {
    if (@typeInfo(@TypeOf(v)) == .vector) {
        return v * (@as(@TypeOf(v), @splat(1)) / @as(@TypeOf(v), @splat(std.math.sqrt(dot3(v, v)))));
    } else if (@typeInfo(@TypeOf(v)) == .array) {
        test_float_type(@typeInfo(@TypeOf(v)).array.child);
        comptime var i = 0;
        const l = std.math.sqrt(dot3(v, v));
        var res = v;
        inline while (i < @typeInfo(@TypeOf(v)).array.len) : (i += 1) {
            res[i] *= 1.0 / l;
        }
        return res;
    } else {
        @compileError("not a vector, float array type");
    }
}
pub inline fn cross2(pt0: anytype, pt1: anytype) @TypeOf(pt0[0], pt1[0]) {
    return pt0[0] * pt1[1] - pt0[1] * pt1[0];
}

pub inline fn cross3(v0: anytype, v1: anytype) vector_(@TypeOf(v0[0], v1[0])) {
    var xmm0 = @shuffle(@TypeOf(v0[0], v1[0]), v0, undefined, [4]i32{ 1, 2, 0, 3 });
    var xmm1 = @shuffle(@TypeOf(v0[0], v1[0]), v1, undefined, [4]i32{ 2, 0, 1, 3 });
    var result = xmm0 * xmm1;
    xmm0 = @shuffle(@TypeOf(v0[0], v1[0]), xmm0, undefined, [4]i32{ 1, 2, 0, 3 });
    xmm1 = @shuffle(@TypeOf(v0[0], v1[0]), xmm1, undefined, [4]i32{ 2, 0, 1, 3 });
    result = result - xmm0 * xmm1;
    result[3] = 0;
    return result;
}

// pub const matrix3x3 = matrix_(f32);

pub const matrix_error = error{ not_exist_inverse_matrix, invaild_near_far, sfov_0, far_near_0, near_far_0, aspect_0, w_0, h_0 };

pub fn compare(n: anytype, i: anytype) bool {
    switch (@typeInfo(@TypeOf(n, i))) {
        .float, .comptime_float => {
            return n == i;
        },
        .int, .comptime_int => {
            return n == i;
        },
        .array => {
            comptime var e = 0;
            inline while (e < n.len) : (e += 1) {
                if (!compare(n[e], i[e])) return false;
            }
            return true;
        },
        .vector => {
            comptime var e = 0;
            inline while (e < @typeInfo(@TypeOf(n, i)).vector.len) : (e += 1) {
                if (!compare(n[e], i[e])) return false;
            }
            return true;
        },
        else => {
            @compileError("not a number type");
        },
    }
}

pub fn compare_n(n: anytype, i: anytype) bool {
    switch (@typeInfo(@TypeOf(n, i))) {
        .float, .comptime_float => {
            return std.math.approxEqAbs(@TypeOf(n, i), n, i, std.math.floatEps(f32));
        },
        .int, .comptime_int => {
            return n == i;
        },
        .array => {
            comptime var e = 0;
            inline while (e < n.len) : (e += 1) {
                if (!compare_n(n[e], i[e])) return false;
            }
            return true;
        },
        .vector => {
            comptime var e = 0;
            inline while (e < @typeInfo(@TypeOf(n, i)).vector.len) : (e += 1) {
                if (!compare_n(n[e], i[e])) return false;
            }
            return true;
        },
        else => {
            @compileError("not a number type");
        },
    }
}

pub inline fn max_vector(v0: anytype, v1: anytype) @TypeOf(v0, v1) {
    return @select(@TypeOf(v0[0], v1[0]), v0 > v1, v0, v1);
}
pub inline fn min_vector(v0: anytype, v1: anytype) @TypeOf(v0, v1) {
    return @select(@TypeOf(v0[0], v1[0]), v0 < v1, v0, v1);
}

///v0 * v1 + v2
inline fn mulAdd(v0: anytype, v1: anytype, v2: anytype) @TypeOf(v0, v1, v2) {
    switch (@typeInfo(@TypeOf(v0, v1, v2))) {
        .vector => |info| {
            if (@typeInfo(info.child) == .float or @typeInfo(info.child) == .comptime_float) {
                return @mulAdd(@TypeOf(v0, v1, v2), v0, v1, v2);
            } else {
                return v0 * v1 + v2;
            }
        },
        else => {
            @compileError("not a vector type");
        },
    }
}

pub const matrix = matrix_(f32);
pub const matrix8 = matrix_(f64);
pub fn matrix_(comptime float_T: type) type {
    if (@typeInfo(float_T) != .float) @compileError("not a float type");
    return [4]vector_(float_T);
}

pub fn matrix_init(comptime float_T: type) matrix_(float_T) {
    return .{.{0} ** 4} ** 4;
}
pub inline fn matrix_translation(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return .{
        .{ 1, 0, 0, 0 },
        .{ 0, 1, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ x, y, z, 1 },
    };
}
pub inline fn matrix_translationXY(comptime float_T: type, p: point_(float_T)) matrix_(float_T) {
    return .{
        .{ 1, 0, 0, 0 },
        .{ 0, 1, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ p[0], p[1], 0, 1 },
    };
}
pub inline fn matrix_translation_transpose(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return .{
        .{ 1, 0, 0, x },
        .{ 0, 1, 0, y },
        .{ 0, 0, 1, z },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_translation_inverse(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return matrix_translation(-x, -y, -z);
}
pub inline fn matrix_translation_transpose_inverse(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return matrix_translation_transpose(-x, -y, -z);
}
pub inline fn matrix_scaling(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return .{
        .{ x, 0, 0, 0 },
        .{ 0, y, 0, 0 },
        .{ 0, 0, z, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_scalingXY(comptime float_T: type, p: point_(float_T)) matrix_(float_T) {
    return .{
        .{ p[0], 0, 0, 0 },
        .{ 0, p[1], 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_rotationX(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ 1, 0, 0, 0 },
        .{ 0, c, s, 0 },
        .{ 0, -s, c, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_rotationY(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ c, 0, -s, 0 },
        .{ 0, 1, 0, 0 },
        .{ s, 0, c, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_rotationZ(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ c, s, 0, 0 },
        .{ -s, c, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub const matrix_rotation2D = matrix_rotationZ;
pub inline fn matrix_rotationX_inverse(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ 1, 0, 0, 0 },
        .{ 0, c, -s, 0 },
        .{ 0, s, c, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_rotationY_inverse(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ c, 0, s, 0 },
        .{ 0, 1, 0, 0 },
        .{ -s, 0, c, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub inline fn matrix_rotationZ_inverse(comptime float_T: type, angle: float_T) matrix_(float_T) {
    const c = @cos(angle);
    const s = @sin(angle);
    return .{
        .{ c, -s, 0, 0 },
        .{ s, c, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    };
}
pub const matrix_rocationX_transpose = matrix_rotationX_inverse;
pub const matrix_rocationY_transpose = matrix_rotationY_inverse;
pub const matrix_rocationZ_transpose = matrix_rotationZ_inverse;
pub const matrix_rocation2D_transpose = matrix_rotationZ_inverse;
pub const matrix_rotation2D_inverse = matrix_rotationZ_inverse;
pub fn matrix_scaling_inverse(comptime float_T: type, x: float_T, y: float_T, z: float_T) matrix_(float_T) {
    return matrix_translation(1 / x, 1 / y, 1 / z);
}
///Vulkan test completed
pub fn matrix_perspectiveFovLhVulkan(comptime float_T: type, fovy: float_T, aspect: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    var res = try matrix_perspectiveFovLh(fovy, aspect, near, far);
    res[1][1] *= -1;
    return res;
}
pub fn matrix_perspectiveFovLh(comptime float_T: type, fovy: float_T, aspect: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    const sfov = std.math.sin(0.5 * fovy);
    const cfov = std.math.cos(0.5 * fovy);

    if (!(near > 0.0 and far > 0.0 and far > near)) return matrix_error.invaild_near_far;
    if (compare_n(sfov, 0)) return matrix_error.sfov_0;
    if (compare_n((far - near), 0)) return matrix_error.far_near_0;
    if (compare_n(aspect, 0)) return matrix_error.aspect_0;
    // assert(!approxEqAbs(f32, scfov[0], 0.0, 0.001));
    // assert(!approxEqAbs(f32, far, near, 0.001));
    // assert(!approxEqAbs(f32, aspect, 0.0, 0.01));

    const h = cfov / sfov;
    const w = h / aspect;
    const r = far / (far - near);
    return .{
        .{ w, 0, 0, 0 },
        .{ 0, h, 0, 0 },
        .{ 0, 0, r, 1 },
        .{ 0, 0, -r * near, 0 },
    };
}
pub fn matrix_perspectiveFovRh(comptime float_T: type, fovy: float_T, aspect: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    const sfov = std.math.sin(0.5 * fovy);
    const cfov = std.math.cos(0.5 * fovy);

    if (!(near > 0.0 and far > 0.0 and far > near)) return matrix_error.invaild_near_far;
    if (compare_n(sfov, 0)) return matrix_error.sfov_0;
    if (compare_n((near - far), 0)) return matrix_error.near_far_0;
    if (compare_n(aspect, 0)) return matrix_error.aspect_0;
    // assert(!approxEqAbs(f32, scfov[0], 0.0, 0.001));
    // assert(!approxEqAbs(f32, far, near, 0.001));
    // assert(!approxEqAbs(f32, aspect, 0.0, 0.01));

    const h = cfov / sfov;
    const w = h / aspect;
    const r = far / (near - far);
    return .{
        .{ w, 0, 0, 0 },
        .{ 0, h, 0, 0 },
        .{ 0, 0, r, -1 },
        .{ 0, 0, r * near, 0 },
    };
}
/// Produces Z values in [-1.0, 1.0] range (OpenGL defaults)
pub fn matrix_perspectiveFovRhGL(comptime float_T: type, fovy: float_T, aspect: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    const sfov = @sin(0.5 * fovy);
    const cfov = @cos(0.5 * fovy);

    if (!(near > 0.0 and far > 0.0 and far > near)) return matrix_error.invaild_near_far;
    if (compare_n(sfov, 0)) return matrix_error.sfov_0;
    if (compare_n((near - far), 0)) return matrix_error.near_far_0;
    if (compare_n(aspect, 0)) return matrix_error.aspect_0;
    // assert(!approxEqAbs(f32, scfov[0], 0.0, 0.001));
    // assert(!approxEqAbs(f32, far, near, 0.001));
    // assert(!approxEqAbs(f32, aspect, 0.0, 0.01));

    const h = cfov / sfov;
    const w = h / aspect;
    const r = near - far;
    return .{
        .{ w, 0, 0, 0 },
        .{ 0, h, 0, 0 },
        .{ 0, 0, (near + far) / r, -1 },
        .{ 0, 0, 2 * near * far / r, 0 },
    };
}
///Vulkan 으로 테스트 완료
pub fn matrix_orthographicLhVulkan(comptime float_T: type, w: float_T, h: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    var res = try matrix_orthographicLh(float_T, w, h, near, far);
    res[1][1] *= -1;
    return res;
}
pub fn matrix_orthographicLh(comptime float_T: type, w: float_T, h: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {
    // assert(!approxEqAbs(f32, w, 0.0, 0.001));
    // assert(!approxEqAbs(f32, h, 0.0, 0.001));
    // assert(!approxEqAbs(f32, far, near, 0.001));
    if (compare_n((far - near), 0)) return matrix_error.far_near_0;
    if (compare_n(w, 0)) return matrix_error.w_0;
    if (compare_n(h, 0)) return matrix_error.h_0;

    const r = 1 / (far - near);
    return .{
        .{ 2 / w, 0, 0, 0 },
        .{ 0, 2 / h, 0, 0 },
        .{ 0, 0, r, 0 },
        .{ 0, 0, -r * near, 1 },
    };
}
pub fn matrix_orthographicRh(comptime float_T: type, w: float_T, h: float_T, near: float_T, far: float_T) matrix_error!matrix_(float_T) {

    // assert(!approxEqAbs(f32, w, 0.0, 0.001));
    // assert(!approxEqAbs(f32, h, 0.0, 0.001));
    // assert(!approxEqAbs(f32, far, near, 0.001));
    if (compare_n((near - far), 0)) return matrix_error.near_far_0;
    if (compare_n(w, 0)) return matrix_error.w_0;
    if (compare_n(h, 0)) return matrix_error.h_0;

    const r = 1 / (near - far);
    return .{
        .{ 2 / w, 0, 0, 0 },
        .{ 0, 2 / h, 0, 0 },
        .{ 0, 0, r, 0 },
        .{ 0, 0, r * near, 1 },
    };
}
///w coordinate no need to care
pub fn matrix_lookToLh(comptime float_T: type, eyepos_vector: vector_(float_T), eyedir_vector: vector_(float_T), updir_vector: vector_(float_T)) matrix_(float_T) {
    const az = normalize(eyedir_vector);
    const ax = normalize(cross3(updir_vector, az));
    const ay = normalize(cross3(az, ax));
    return .{
        .{ ax[0], ay[0], az[0], 0 },
        .{ ax[1], ay[1], az[1], 0 },
        .{ ax[2], ay[2], az[2], 0 },
        .{ -dot3(ax, eyepos_vector), -dot3(ay, eyepos_vector), -dot3(az, eyepos_vector), 1 },
    };
}
///w coordinate no need to care
pub fn matrix_lookToRh(comptime float_T: type, eyepos_vector: vector_(float_T), eyedir_vector: vector_(float_T), updir_vector: vector_(float_T)) matrix_(float_T) {
    return matrix_lookToLh(float_T, eyepos_vector, -eyedir_vector, updir_vector);
}
///Vulkan test completed, w coordinate no need to care
pub fn matrix_lookAtLh(comptime float_T: type, eyepos_vector: vector_(float_T), focuspos_vector: vector_(float_T), updir_vector: vector_(float_T)) matrix_(float_T) {
    return matrix_lookToLh(float_T, eyepos_vector, focuspos_vector - eyepos_vector, updir_vector);
}
///w coordinate no need to care
pub fn matrix_lookAtRh(comptime float_T: type, eyepos_vector: vector_(float_T), focuspos_vector: vector_(float_T), updir_vector: vector_(float_T)) matrix_(float_T) {
    return matrix_lookToLh(float_T, eyepos_vector, eyepos_vector - focuspos_vector, updir_vector);
}

pub fn matrix_identity(comptime T: type) matrix_(T) {
    return .{
        .{ 1, 0, 0, 0 },
        .{ 0, 1, 0, 0 },
        .{ 0, 0, 1, 0 },
        .{ 0, 0, 0, 1 },
    };
}
inline fn dot4(v0: anytype, v1: anytype) @TypeOf(v0[0], v1[0]) {
    const xmm0 = v0 * v1; // | x0*x1 | y0*y1 | z0*z1 | w0*w1 |
    return xmm0[0] + xmm0[1] + xmm0[2] + xmm0[3];
}

pub fn matrix_multiply(_matrix: anytype, _target_matrix: anytype) @TypeOf(_matrix, _target_matrix) {
    var result: @TypeOf(_matrix) = undefined;
    comptime var row = 0;
    const float_T = @TypeOf(_matrix[0][0], _target_matrix[0][0]);
    inline while (row < 4) : (row += 1) {
        const vx = @shuffle(float_T, _matrix[row], undefined, [4]i32{ 0, 0, 0, 0 });
        const vy = @shuffle(float_T, _matrix[row], undefined, [4]i32{ 1, 1, 1, 1 });
        const vz = @shuffle(float_T, _matrix[row], undefined, [4]i32{ 2, 2, 2, 2 });
        const vw = @shuffle(float_T, _matrix[row], undefined, [4]i32{ 3, 3, 3, 3 });
        result[row] = mulAdd(vx, _target_matrix[0], vz * _target_matrix[2]) + mulAdd(vy, _target_matrix[1], vw * _target_matrix[3]);
    }
    return result;
}
pub fn matrix_mul_vector(_matrix: anytype, _target_vector: anytype) vector_(@TypeOf(_matrix[0][0])) {
    const vx = @shuffle(@TypeOf(_matrix[0][0], _target_vector[0]), _target_vector, undefined, [4]i32{ 0, 0, 0, 0 });
    const vy = @shuffle(@TypeOf(_matrix[0][0], _target_vector[0]), _target_vector, undefined, [4]i32{ 1, 1, 1, 1 });
    const vz = @shuffle(@TypeOf(_matrix[0][0], _target_vector[0]), _target_vector, undefined, [4]i32{ 2, 2, 2, 2 });
    const vw = @shuffle(@TypeOf(_matrix[0][0], _target_vector[0]), _target_vector, undefined, [4]i32{ 3, 3, 3, 3 });
    const matT = matrix_transpose(_matrix);
    return mulAdd(vx, matT[0], vz * matT[2]) + mulAdd(vy, matT[1], vw * matT[3]);
}
pub inline fn matrix_div_vector(_matrix: anytype, _target_vector: anytype) !vector_(@TypeOf(_matrix[0][0])) {
    return matrix_mul_vector(try matrix_inverse(_matrix), _target_vector);
}
pub inline fn matrix_mul_point(_matrix: anytype, pt: anytype) !point_(@TypeOf(_matrix[0][0])) {
    const xx = point{ _matrix[0][0], _matrix[0][1] };
    const yy = point{ _matrix[1][0], _matrix[1][1] };
    return .{ dot3(pt, xx) + _matrix[0][3], dot3(pt, yy) + _matrix[1][3] };
}
pub inline fn matrix_div_point(_matrix: anytype, pt: anytype) !point_(@TypeOf(_matrix[0][0])) {
    return matrix_mul_point(try matrix_inverse(_matrix), pt);
}
pub fn matrix_addition(_matrix: anytype, _target_matrix: anytype) @TypeOf(_matrix, _target_matrix) {
    var result: @TypeOf(_matrix, _target_matrix) = undefined;
    comptime var row = 0;
    inline while (row < 4) : (row += 1) {
        result[row] = _matrix[row] + _target_matrix[row];
    }
    return result;
}
pub fn matrix_subtract(_matrix: anytype, _target_matrix: anytype) @TypeOf(_matrix, _target_matrix) {
    var result: @TypeOf(_matrix, _target_matrix) = undefined;
    comptime var row = 0;
    inline while (row < 4) : (row += 1) {
        result[row] = _matrix[row] - _target_matrix[row];
    }
    return result;
}
pub fn matrix_transpose(_matrix: anytype) @TypeOf(_matrix) {
    const float_T = @TypeOf(_matrix[0][0]);
    const temp1 = @shuffle(float_T, _matrix[0], _matrix[1], [4]i32{ 0, 1, ~@as(i32, 0), ~@as(i32, 1) });
    const temp3 = @shuffle(float_T, _matrix[0], _matrix[1], [4]i32{ 2, 3, ~@as(i32, 2), ~@as(i32, 3) });
    const temp2 = @shuffle(float_T, _matrix[2], _matrix[3], [4]i32{ 0, 1, ~@as(i32, 0), ~@as(i32, 1) });
    const temp4 = @shuffle(float_T, _matrix[2], _matrix[3], [4]i32{ 2, 3, ~@as(i32, 2), ~@as(i32, 3) });
    return .{
        @shuffle(float_T, temp1, temp2, [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) }),
        @shuffle(float_T, temp1, temp2, [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) }),
        @shuffle(float_T, temp3, temp4, [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) }),
        @shuffle(float_T, temp3, temp4, [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) }),
    };
}

pub fn matrix_determinant(_matrix: anytype) @TypeOf(_matrix[0][0]) {
    const float_T = @TypeOf(_matrix[0][0]);
    var v0 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 1, 0, 0, 0 });
    var v1 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 2, 2, 1, 1 });
    var v2 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 1, 0, 0, 0 });
    var v3 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 3, 3, 3, 2 });
    var v4 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 2, 2, 1, 1 });
    var v5 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 3, 3, 3, 2 });

    var p0 = v0 * v1;
    var p1 = v2 * v3;
    var p2 = v4 * v5;

    v0 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 2, 2, 1, 1 });
    v1 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 1, 0, 0, 0 });
    v2 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 3, 3, 3, 2 });
    v3 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 1, 0, 0, 0 });
    v4 = @shuffle(float_T, _matrix[2], undefined, [4]i32{ 3, 3, 3, 2 });
    v5 = @shuffle(float_T, _matrix[3], undefined, [4]i32{ 2, 2, 1, 1 });

    p0 = mulAdd(-v0, v1, p0);
    p1 = mulAdd(-v2, v3, p1);
    p2 = mulAdd(-v4, v5, p2);

    v0 = @shuffle(float_T, _matrix[1], undefined, [4]i32{ 3, 3, 3, 2 });
    v1 = @shuffle(float_T, _matrix[1], undefined, [4]i32{ 2, 2, 1, 1 });
    v2 = @shuffle(float_T, _matrix[1], undefined, [4]i32{ 1, 0, 0, 0 });

    const s = _matrix[0] * @TypeOf(_matrix[0]){ 1, -1, 1, -1 };
    var r = v0 * p0;
    r = mulAdd(-v1, p1, r);
    r = mulAdd(v2, p2, r);
    return dot4(s, r);
}
pub fn matrix_inverse(_matrix: anytype) !@TypeOf(_matrix) {
    const mt = matrix_transpose(_matrix);
    const float_T = @TypeOf(_matrix[0][0]);
    var v0: [4]@TypeOf(_matrix[0]) = undefined;
    var v1: [4]@TypeOf(_matrix[0]) = undefined;

    v0[0] = @shuffle(float_T, mt[2], undefined, [4]i32{ 0, 0, 1, 1 });
    v1[0] = @shuffle(float_T, mt[3], undefined, [4]i32{ 2, 3, 2, 3 });
    v0[1] = @shuffle(float_T, mt[0], undefined, [4]i32{ 0, 0, 1, 1 });
    v1[1] = @shuffle(float_T, mt[1], undefined, [4]i32{ 2, 3, 2, 3 });
    v0[2] = @shuffle(float_T, mt[2], mt[0], [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) });
    v1[2] = @shuffle(float_T, mt[3], mt[1], [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) });

    var d0 = v0[0] * v1[0];
    var d1 = v0[1] * v1[1];
    var d2 = v0[2] * v1[2];

    v0[0] = @shuffle(float_T, mt[2], undefined, [4]i32{ 2, 3, 2, 3 });
    v1[0] = @shuffle(float_T, mt[3], undefined, [4]i32{ 0, 0, 1, 1 });
    v0[1] = @shuffle(float_T, mt[0], undefined, [4]i32{ 2, 3, 2, 3 });
    v1[1] = @shuffle(float_T, mt[1], undefined, [4]i32{ 0, 0, 1, 1 });
    v0[2] = @shuffle(float_T, mt[2], mt[0], [4]i32{ 1, 3, ~@as(i32, 1), ~@as(i32, 3) });
    v1[2] = @shuffle(float_T, mt[3], mt[1], [4]i32{ 0, 2, ~@as(i32, 0), ~@as(i32, 2) });

    d0 = mulAdd(-v0[0], v1[0], d0);
    d1 = mulAdd(-v0[1], v1[1], d1);
    d2 = mulAdd(-v0[2], v1[2], d2);

    v0[0] = @shuffle(float_T, mt[1], undefined, [4]i32{ 1, 2, 0, 1 });
    v1[0] = @shuffle(float_T, d0, d2, [4]i32{ ~@as(i32, 1), 1, 3, 0 });
    v0[1] = @shuffle(float_T, mt[0], undefined, [4]i32{ 2, 0, 1, 0 });
    v1[1] = @shuffle(float_T, d0, d2, [4]i32{ 3, ~@as(i32, 1), 1, 2 });
    v0[2] = @shuffle(float_T, mt[3], mt[0], [4]i32{ 1, 2, 0, 1 });
    v1[2] = @shuffle(float_T, d1, d2, [4]i32{ ~@as(i32, 3), 1, 3, 0 });
    v0[3] = @shuffle(float_T, mt[2], mt[1], [4]i32{ 2, 0, 1, 0 });
    v1[3] = @shuffle(float_T, d1, d2, [4]i32{ 3, ~@as(i32, 3), 1, 2 });

    var c0 = v0[0] * v1[0];
    var c2 = v0[1] * v1[1];
    var c4 = v0[2] * v1[2];
    var c6 = v0[3] * v1[3];

    v0[0] = @shuffle(float_T, mt[1], undefined, [4]i32{ 2, 3, 1, 2 });
    v1[0] = @shuffle(float_T, d0, d2, [4]i32{ 3, 0, 1, ~@as(i32, 0) });
    v0[1] = @shuffle(float_T, mt[0], undefined, [4]i32{ 3, 2, 3, 1 });
    v1[1] = @shuffle(float_T, d0, d2, [4]i32{ 2, 1, ~@as(i32, 0), 0 });
    v0[2] = @shuffle(float_T, mt[3], undefined, [4]i32{ 2, 3, 1, 2 });
    v1[2] = @shuffle(float_T, d1, d2, [4]i32{ 3, 0, 1, ~@as(i32, 2) });
    v0[3] = @shuffle(float_T, mt[2], undefined, [4]i32{ 3, 2, 3, 1 });
    v1[3] = @shuffle(float_T, d1, d2, [4]i32{ 2, 1, ~@as(i32, 2), 0 });

    c0 = mulAdd(-v0[0], v1[0], c0);
    c2 = mulAdd(-v0[1], v1[1], c2);
    c4 = mulAdd(-v0[2], v1[2], c4);
    c6 = mulAdd(-v0[3], v1[3], c6);

    v0[0] = @shuffle(float_T, mt[1], undefined, [4]i32{ 3, 0, 3, 0 });
    v1[0] = @shuffle(float_T, d0, d2, [4]i32{ 2, ~@as(i32, 1), ~@as(i32, 0), 2 });
    v0[1] = @shuffle(float_T, mt[0], undefined, [4]i32{ 1, 3, 0, 2 });
    v1[1] = @shuffle(float_T, d0, d2, [4]i32{ ~@as(i32, 1), 0, 3, ~@as(i32, 0) });
    v0[2] = @shuffle(float_T, mt[3], undefined, [4]i32{ 3, 0, 3, 0 });
    v1[2] = @shuffle(float_T, d1, d2, [4]i32{ 2, ~@as(i32, 3), ~@as(i32, 2), 2 });
    v0[3] = @shuffle(float_T, mt[2], undefined, [4]i32{ 1, 3, 0, 2 });
    v1[3] = @shuffle(float_T, d1, d2, [4]i32{ ~@as(i32, 3), 0, 3, ~@as(i32, 2) });

    const c1 = mulAdd(-v0[0], v1[0], c0);
    const c3 = mulAdd(v0[1], v1[1], c2);
    const c5 = mulAdd(-v0[2], v1[2], c4);
    const c7 = mulAdd(v0[3], v1[3], c6);

    c0 = mulAdd(v0[0], v1[0], c0);
    c2 = mulAdd(-v0[1], v1[1], c2);
    c4 = mulAdd(v0[2], v1[2], c4);
    c6 = mulAdd(-v0[3], v1[3], c6);

    var mr = @TypeOf(_matrix){
        .{ c0[0], c1[1], c0[2], c1[3] },
        .{ c2[0], c3[1], c2[2], c3[3] },
        .{ c4[0], c5[1], c4[2], c5[3] },
        .{ c6[0], c7[1], c6[2], c7[3] },
    };

    const det = dot4(mr[0], mt[0]);

    if (compare_n(det, 0)) {
        return matrix_error.not_exist_inverse_matrix;
    }

    const scale = @as(@TypeOf(_matrix[0]), @splat(det));
    mr[0] /= scale;
    mr[1] /= scale;
    mr[2] /= scale;
    mr[3] /= scale;

    return mr;
}

test "matrix_inverse" {
    const m = matrix_identity(f32);
    const inv = try matrix_inverse(m);
    try std.testing.expect(compare(m, inv));
}

//  row ↕, col ↔
// pub fn matrix_(comptime T: type, row: comptime_int, col: comptime_int) type {
//     test_number_type(T);

//     if (T == f32 and row == 4 and col == 4) return matrix;

// return struct {
//     const Self = @This();
//     e: [row][col]T,

//     pub fn init() Self {
//         return Self{
//             .e = .{.{0} ** col} ** row,
//         };
//     }
//     pub fn identity() Self {
//         if (col == row) { //identity matrix
//             var result: Self = undefined;
//             comptime var i = 0;
//             inline while (i < row) : (i += 1) {
//                 comptime var j = 0;
//                 inline while (j < col) : (j += 1) {
//                     if (i == j) {
//                         result.e[i][j] = 1;
//                     } else {
//                         result.e[i][j] = 0;
//                     }
//                 }
//             }
//             return result;
//         } else {
//             @compileError("identity : not a identity matrix");
//         }
//     }
//     pub fn addition(self: *const Self, _matrix: *const Self) Self {
//         var result: Self = self;
//         comptime var r = 0;
//         comptime var c = 0;
//         inline while (r < row) : (r += 1) {
//             c = 0;
//             inline while (c < col) : (c += 1) {
//                 result.e[r][c] += _matrix.e[r][c];
//             }
//         }
//         return result;
//     }
//     pub fn subtract(self: *const Self, _matrix: *const Self) Self {
//         var result: Self = self;
//         comptime var r = 0;
//         comptime var c = 0;
//         inline while (r < row) : (r += 1) {
//             c = 0;
//             inline while (c < col) : (c += 1) {
//                 result.e[r][c] -= _matrix.e[r][c];
//             }
//         }
//         return result;
//     }
//     ///[row x COL] = [row x col][col x COL] COL 은 _matrix 행렬의 열(column) 갯수입니다.
//     pub fn multiply(self: *const Self, COL: comptime_int, _matrix: *const matrix(T, col, COL)) matrix(T, row, COL) {
//         var result: matrix(T, row, COL) = matrix(T, row, COL).init();
//         comptime var r = 0;
//         comptime var c = 0;
//         comptime var n = 0;
//         inline while (r < row) : (r += 1) {
//             c = 0;
//             inline while (c < COL) : (c += 1) {
//                 n = 0;
//                 inline while (n < COL) : (n += 1) {
//                     result.e[r][c] += self.*.e[r][n] * _matrix.e[n][c];
//                 }
//             }
//         }
//         return result;
//     }
//     fn swap_row(self: *Self, i: isize, j: isize) void {
//         if (i == j) return;
//         var k: usize = 0;
//         while (k < row) : (k += 1) {
//             std.mem.swap(T, &self.e[@intCast(i)][k], &self.e[@intCast(j)][k]);
//         }
//     }
//     pub fn transpose(self: *Self) matrix(T, col, row) {
//         var result: matrix(T, col, row) = undefined;
//         var r: i32 = 0;
//         while (r < row) : (r += 1) {
//             var c: i32 = 0;
//             while (c < col) : (c += 1) {
//                 result.e[c][r] = self.*.e[r][c];
//             }
//         }
//         return result;
//     }
//     fn det(n: comptime_int, _matrix: [n][n]T) T {
//         if (n == 1) return _matrix[0][0];

//         var minor_matrix: [n][n - 1][n - 1]T = undefined;
//         var k: usize = 0;
//         while (k < n) : (k += 1) {
//             var i: usize = 0;
//             while (i < (n - 1)) : (i += 1) {
//                 var j: usize = 0;
//                 while (j < n) : (j += 1) {
//                     if (j < k) {
//                         minor_matrix[k][i][j] = _matrix[i + 1][j];
//                     } else if (j > k) {
//                         minor_matrix[k][i][j - 1] = _matrix[i + 1][j];
//                     }
//                 }
//             }
//         }
//         var sum: T = 0;
//         var test_: T = 1;
//         k = 0;
//         while (k < n) : (k += 1) {
//             sum += test_ * _matrix[0][k] * det(n - 1, minor_matrix[k]);
//             test_ *= -1;
//         }
//         return sum;
//     }
//     ///https://nate9389.tistory.com/63
//     pub fn determinant(self: *const Self) T {
//         if (col != row) @compileError("determinant : not a identity matrix");
//         return det(row, self.e);
//     }
//     ///https://blog.naver.com/lovebuthate/221153359469
//     pub fn inverse(self: *Self) !Self {
//         if (col != row) @compileError("inverse : not a identity matrix");

//         const nn = col; // 행 열이 어짜피 같으므로 nn 변수로 통일
//         var a: Self = self.*;
//         var b: Self = identity();
//         var k: isize = 0;
//         while (k < nn) : (k += 1) {
//             var t = k - 1;
//             while (t + 1 < nn and self.e[@intCast(t + 1)][@intCast(k)] == 0) : (t += 1) {}
//             if (t == k - 1) t += 1;
//             if (t == nn - 1 and compare_n(self.e[@intCast(t)][@intCast(k)], 0)) return matrix_error.not_exist_inverse_matrix;
//             a.swap_row(k, t);
//             b.swap_row(k, t);
//             const d = a.e[@intCast(k)][@intCast(k)];
//             var j: usize = 0;
//             //k행 k열에 해당하는 수로 k행의 각 숫자를 나눔
//             while (j < nn) : (j += 1) {
//                 a.e[@intCast(k)][j] /= d;
//                 b.e[@intCast(k)][j] /= d;
//             }
//             //k행을 제외한 다른 행에 숫자를 곱하고 더하는 과정
//             var i: usize = 0;
//             while (i < nn) : (i += 1) {
//                 if (i != k) {
//                     const m = a.e[i][@intCast(k)];
//                     var ii: usize = 0;
//                     while (ii < nn) : (ii += 1) {
//                         if (ii >= k) a.e[i][ii] -= a.e[@intCast(k)][ii] * m;
//                         b.e[i][ii] -= b.e[@intCast(k)][ii] * m;
//                     }
//                 }
//             }
//         }
//         return b;
//     }
//     pub fn format(self: *const Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
//         _ = fmt;
//         _ = options;

//         try writer.print("{s}\n", .{@typeName(Self)});

//         comptime var i = 0;
//         inline while (i < row) : (i += 1) {
//             comptime var j = 0;
//             try writer.print("{{", .{});
//             inline while (j < col - 1) : (j += 1) {
//                 try writer.print("{d}, ", .{self.e[i][j]});
//             }
//             try writer.print("{d}}}\n", .{self.e[i][j]});
//         }
//     }
// };
//}
