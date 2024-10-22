const std = @import("std");
const ArrayList = std.ArrayList;
const math = @import("math.zig");
const system = @import("system.zig");
const graphics = @import("graphics.zig");

const point = math.point;
const vector = math.vector;

const dot3 = math.dot3;
const cross3 = math.cross3;
const sqrt = std.math.sqrt;
const pow = math.pow;

pub const curve_TYPE = enum {
    unknown,
    serpentine,
    loop,
    cusp,
    quadratic,
    line,
};

pub const line_error = error{
    is_point_not_line,
    is_not_curve,
    invaild_line,
    out_of_idx,
} || std.mem.Allocator.Error;

pub const polygon_error = error{
    is_not_polygon,
    invaild_polygon_line_counts,
    cant_polygon_match_holes,
} || line_error;

pub fn convert_quadratic_to_cubic0(_start: point, _control: point) point {
    return .{ _start[0] + (2.0 / 3.0) * (_control[0] - _start[0]), _start[1] + (2.0 / 3.0) * (_control[1] - _start[1]) };
}
pub fn convert_quadratic_to_cubic1(_end: point, _control: point) point {
    return .{ _end[0] + (2.0 / 3.0) * (_control[0] - _end[0]), _end[1] + (2.0 / 3.0) * (_control[1] - _end[1]) };
}

/// Algorithm from http://www.blackpawn.com/texts/pointinpoly/default.html
pub fn point_in_triangle(p: point, a: point, b: point, c: point) bool {
    const v0 = c - a;
    const v1 = b - a;
    const v2 = p - a;

    const dot00 = dot3(v0, v0);
    const dot01 = dot3(v0, v1);
    const dot02 = dot3(v0, v2);
    const dot11 = dot3(v1, v1);
    const dot12 = dot3(v1, v2);
    const denominator = dot00 * dot11 - dot01 * dot01;
    if (denominator == 0) {
        return false;
    }

    const inverseDenominator = 1.0 / denominator;
    const u = (dot11 * dot02 - dot01 * dot12) * inverseDenominator;
    const v = (dot00 * dot12 - dot01 * dot02) * inverseDenominator;

    return (u >= 0.0) and (v >= 0.0) and (u + v < 1.0);
}

pub fn point_in_line(p: point, l0: point, l1: point, result: ?*f32) bool {
    const a = l1[1] - l0[1];
    const b = l0[0] - l1[0];
    const c = l1[0] * l0[1] - l0[0] * l1[1];
    const _result = a * p[0] + b * p[1] + c;
    if (result != null) result.?.* = _result;
    return _result == 0 and p[0] >= @min(l0[0], l1[0]) and p[0] <= @max(l0[0], l1[0]) and p[1] >= @min(l0[1], l1[1]) and p[1] <= @max(l0[1], l1[1]);
}

pub fn point_in_vector(p: point, v0: point, v1: point, result: ?*f32) bool {
    const a = v1[1] - v0[1];
    const b = v0[0] - v1[0];
    const c = v1[0] * v0[1] - v0[0] * v1[1];
    const _result = a * p[0] + b * p[1] + c;
    if (result != null) result.?.* = _result;
    return _result == 0;
}

pub fn lines_intersect(a1: point, a2: point, b1: point, b2: point, result: ?*point) bool {
    const a = a2 - a1;
    const b = b2 - b1;
    const ab = a1 - b1;
    const aba = math.cross2(a, b);
    if (aba == 0.0) return false;
    const A = math.cross2(b, ab) / aba;
    const B = math.cross2(a, ab) / aba;
    if ((A <= 1.0) and (B <= 1.0) and (A >= 0.0) and (B >= 0.0)) {
        if (result != null) result.?.* = a1 + @as(point, @splat(A)) * (a2 - a1);
        return true;
    }
    return false;
}

pub inline fn point_line_side(p: point, l0: point, l1: point) f32 {
    return (l1[0] - l0[0]) * (p[1] - l0[1]) - (p[0] - l0[0]) * (l1[1] - l0[1]);
}
///https://bowbowbow.tistory.com/24
pub fn point_in_polygon(p: point, pts: []point) bool {
    var i: usize = 0;
    //crosses는 점p와 오른쪽 반직선과 다각형과의 교점의 개수
    var crosses: usize = 0;
    while (i < pts.len) : (i += 1) {
        const j = (i + 1) % pts.len;
        //점 p가 선분 (pts[i], pts[j])의 y좌표 사이에 있음
        if ((pts[i][1] > p[1]) != (pts[j][1] > p[1])) {
            //atX는 점 p를 지나는 수평선과 선분 (pts[i], pts[j])의 교점
            const atx = (pts[j][0] - pts[i][0]) * (p[1] - pts[i][1]) / (pts[j][1] - pts[i][1]) + pts[i][0];
            //atX가 오른쪽 반직선과의 교점이 맞으면 교점의 개수를 증가시킨다.
            if (p[0] < atx) crosses += 1;
        }
    }
    return (crosses % 2) > 0;
}
pub fn center_point_in_polygon(pts: []point) point {
    var i: usize = 0;
    var area: f32 = 0;
    var p: point = .{ 0, 0 };
    while (i < pts.len) : (i += 1) {
        const j = (i + 1) % pts.len;
        const factor = math.cross2(pts[i], pts[j]);
        area += factor;
        p = @mulAdd(point, pts[i] + pts[j], @splat(factor), p);
    }
    area = area / 2.0 * 6.0;
    p *= @splat(1.0 / area);
    return p;
}
pub fn line_in_polygon(a: point, b: point, pts: []point, check_inside_line: bool) bool {
    if (check_inside_line and point_in_polygon(a, pts)) return true; //반드시 점 ab가 다각형 내에 모두 있어야 선 ab와 다각형 선분이 교차하지 않는다. 따라서 b는 확인할 필요 없다.
    var i: usize = 0;
    var result: point = undefined;
    while (i < pts.len - 1) : (i += 1) {
        if (lines_intersect(pts[i], pts[i + 1], a, b, &result)) {
            if (math.compare_n(a, result) or math.compare_n(b, result)) continue;
            return true;
        }
    }
    if (lines_intersect(pts[pts.len - 1], pts[0], a, b, &result)) {
        if (math.compare_n(a, result) or math.compare_n(b, result)) return false;
        return true;
    }
    return false;
}

pub fn nearest_point_between_point_line(p: point, l0: point, l1: point) point {
    const a = (l0[1] - l1[1]) / (l0[0] - l1[0]);
    const c = (l1[0] - l0[0]) / (l0[1] - l1[1]);

    const x = (p[1] - l0[1] + l0[0] * a - p[0] * c) / (a - c);
    return .{ x, a * p[0] + l0[1] - l0[0] * a };
}

pub const circle = struct {
    p: point,
    radius: f32,
    pub fn circle_in_circle(a: @This(), b: circle) bool {
        return math.length_pow(a.p, b.p) <= math.pow(a.radius + b.radius, 2);
    }
    pub fn circle_in_point(c: @This(), p: point) bool {
        return math.length_pow(c.p, p.p) <= c.radius * c.radius;
    }
};

pub const compute_option = struct {
    mat: math.matrix,
};

pub const polygon = struct {
    lines: [][]line,
    colors: ?[]vector = null,
    tickness: f32 = 3,

    ///https://stackoverflow.com/a/73061541
    fn extend_point(prev: point, cur: point, next: point, tickness: f32, ccw: f32) point {
        const vn: point = next - cur;
        const vnn: point = math.normalize(vn);
        const nnnX = vnn[1];
        const nnnY = -vnn[0];

        const vp: point = cur - prev;
        const vpn: point = math.normalize(vp);
        const npnX = vpn[1] * ccw;
        const npnY = -vpn[0] * ccw;

        const bisX = (nnnX + npnX) * ccw;
        const bisY = (nnnY + npnY) * ccw;

        const bisn: point = math.normalize(point{ bisX, bisY });
        const bislen = tickness / sqrt((1 + nnnX * npnX + nnnY * npnY) / 2);

        return point{ cur[0] + bislen * bisn[0], cur[1] + bislen * bisn[1] };
    }

    ///raw_polygon elements need alloc
    pub fn compute_outline(self: polygon, allocator: std.mem.Allocator, _inout: *raw_polygon) polygon_error!void {
        const lines_ = try allocator.alloc([]line, self.lines.len * 2);
        defer allocator.free(lines_);
        var i: usize = 0;
        while (i < self.lines.len) : (i += 1) {
            lines_[i * 2] = allocator.alloc(line, self.lines[i].len) catch |e| {
                var j: usize = 0;
                while (j < i * 2) : (j += 1) {
                    allocator.free(lines_[j]);
                }
                return e;
            };
            lines_[i * 2 + 1] = allocator.alloc(line, self.lines[i].len) catch |e| {
                var j: usize = 0;
                while (j < i * 2 + 1) : (j += 1) {
                    allocator.free(lines_[j]);
                }
                return e;
            };
            var j: usize = 0;
            const ccw: f32 = if (math.cross2(self.lines[i][0].start, if (self.lines[i][0].curve_type == .line) self.lines[i][0].end else self.lines[i][0].control0) > 0) -1 else 1;

            while (j < self.lines[i].len) : (j += 1) {
                const next = (j + 1) % self.lines[i].len;
                const prev = if (j == 0) self.lines[i].len - 1 else (j - 1);

                if (self.lines[i][j].curve_type == .line) {
                    lines_[i * 2][j].start = extend_point(
                        if (self.lines[i][prev].curve_type == .line) self.lines[i][prev].start else self.lines[i][prev].control1,
                        self.lines[i][j].start,
                        self.lines[i][j].end,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].end = extend_point(
                        self.lines[i][j].start,
                        self.lines[i][j].end,
                        if (self.lines[i][next].curve_type == .line) self.lines[i][next].end else self.lines[i][next].control0,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].start = extend_point(
                        if (self.lines[i][prev].curve_type == .line) self.lines[i][prev].start else self.lines[i][prev].control1,
                        self.lines[i][j].start,
                        self.lines[i][j].end,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].end = extend_point(
                        self.lines[i][j].start,
                        self.lines[i][j].end,
                        if (self.lines[i][next].curve_type == .line) self.lines[i][next].end else self.lines[i][next].control0,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].curve_type = .line;
                    lines_[i * 2 + 1][j].curve_type = .line;
                } else {
                    lines_[i * 2][j].start = extend_point(
                        if (self.lines[i][prev].curve_type == .line) self.lines[i][prev].start else self.lines[i][prev].control1,
                        self.lines[i][j].start,
                        self.lines[i][j].control0,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].control0 = extend_point(
                        self.lines[i][j].start,
                        self.lines[i][j].control0,
                        self.lines[i][j].control1,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].control1 = extend_point(
                        self.lines[i][j].control0,
                        self.lines[i][j].control1,
                        self.lines[i][j].end,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].end = extend_point(
                        self.lines[i][j].control1,
                        self.lines[i][j].end,
                        if (self.lines[i][next].curve_type == .line) self.lines[i][next].end else self.lines[i][next].control0,
                        self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].start = extend_point(
                        if (self.lines[i][prev].curve_type == .line) self.lines[i][prev].start else self.lines[i][prev].control1,
                        self.lines[i][j].start,
                        self.lines[i][j].control0,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].control0 = extend_point(
                        self.lines[i][j].start,
                        self.lines[i][j].control0,
                        self.lines[i][j].control1,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].control1 = extend_point(
                        self.lines[i][j].control0,
                        self.lines[i][j].control1,
                        self.lines[i][j].end,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2 + 1][j].end = extend_point(
                        self.lines[i][j].control1,
                        self.lines[i][j].end,
                        if (self.lines[i][next].curve_type == .line) self.lines[i][next].end else self.lines[i][next].control0,
                        -self.tickness,
                        ccw,
                    );
                    lines_[i * 2][j].curve_type = self.lines[i][j].curve_type;
                    lines_[i * 2 + 1][j].curve_type = self.lines[i][j].curve_type;
                }
            }
        }
        defer {
            for (lines_) |l| allocator.free(l);
        }

        try _compute_polygon(self, allocator, _inout, lines_);
    }

    pub fn apply_option(self: polygon, option: compute_option, _out_lines: [][]line) polygon_error!void {
        if (_out_lines.len != self.lines.len) return polygon_error.invaild_line;

        for (_out_lines, self.lines) |v, l| {
            if (v.len != l.len) return polygon_error.invaild_line;
            for (v, l) |*v2, l2| {
                v2.* = l2.mul_mat(option.mat);
            }
        }
    }

    fn _compute_polygon(self: polygon, allocator: std.mem.Allocator, _inout: *raw_polygon, _lines: [][]line) polygon_error!void {
        var i: usize = 0;
        var count: usize = 0;
        var curve_vertice_len: usize = 0;
        var vertice_len: usize = 0;
        var indices_len: usize = 0;
        _ = self;

        while (count < _lines.len) : (count += 1) {
            if (_lines[count].len < 3) return polygon_error.is_not_polygon;
            i = 0;
            vertice_len += 1;
            while (i < _lines[count].len) : (i += 1) {
                if (_lines[count][i].curve_type != .line) {
                    curve_vertice_len += 8;
                }
                vertice_len += 1;
            }
        }
        _inout.*.vertices = try allocator.realloc(_inout.*.vertices, _inout.*.vertices.len + vertice_len + curve_vertice_len);
        //인덱스 갯수는 대충 최대값
        _inout.*.indices = try allocator.realloc(_inout.*.indices, _inout.*.vertices.len * 3);
        vertice_len = 0;
        count = 0;
        while (count < _lines.len) : (count += 1) {}

        count = 0;
        while (count < _lines.len) : (count += 1) {
            i = 0;
            const first_vertex = vertice_len;
            _inout.*.vertices[first_vertex].pos = .{ std.math.floatMax(f32), std.math.floatMin(f32) };
            _inout.*.vertices[first_vertex].uvw = .{ 1, 0, 0 };
            vertice_len += 1;
            while (i < _lines[count].len) : (i += 1) {
                _inout.*.vertices[vertice_len].pos = _lines[count][i].start;
                vertice_len += 1;
            }
            i = first_vertex + 1;
            var maxX: f32 = std.math.floatMin(f32);
            var minY: f32 = std.math.floatMax(f32);
            while (i < vertice_len) : (i += 1) {
                if (_inout.*.vertices[first_vertex].pos[0] > _inout.*.vertices[i].pos[0]) _inout.*.vertices[first_vertex].pos[0] = _inout.*.vertices[i].pos[0];
                if (_inout.*.vertices[first_vertex].pos[1] < _inout.*.vertices[i].pos[1]) _inout.*.vertices[first_vertex].pos[1] = _inout.*.vertices[i].pos[1];
                if (maxX < _inout.*.vertices[i].pos[0]) maxX = _inout.*.vertices[i].pos[0];
                if (minY > _inout.*.vertices[i].pos[1]) minY = _inout.*.vertices[i].pos[1];

                _inout.*.vertices[i].uvw = .{ 1, 0, 0 };

                _inout.*.indices[indices_len] = @intCast(first_vertex);
                _inout.*.indices[indices_len + 1] = @intCast(i);
                _inout.*.indices[indices_len + 2] = if (i < vertice_len - 1) @intCast(i + 1) else @intCast(first_vertex + 1);
                indices_len += 3;
            }
            _inout.*.vertices[first_vertex].pos[0] -= (maxX - _inout.*.vertices[first_vertex].pos[0]) / 2;
            _inout.*.vertices[first_vertex].pos[1] += (_inout.*.vertices[first_vertex].pos[1] - minY) / 2;
        }
        count = 0;
        while (count < _lines.len) : (count += 1) {
            i = 0;
            while (i < _lines[count].len) : (i += 1) {
                try _lines[count][i].compute_curve(_inout.*.vertices, _inout.*.indices, &vertice_len, &indices_len);
            }
        }
        _inout.*.vertices = try allocator.realloc(_inout.*.vertices, vertice_len);
        _inout.*.indices = try allocator.realloc(_inout.*.indices, indices_len);
    }

    ///raw_polygon elements need alloc
    pub fn compute_polygon(self: polygon, allocator: std.mem.Allocator, _inout: *raw_polygon) polygon_error!void {
        try _compute_polygon(self, allocator, _inout, self.lines);
    }
};

pub const line = struct {
    const Self = @This();
    start: point,
    control0: point,
    control1: point,
    end: point,
    curve_type: curve_TYPE = curve_TYPE.unknown,

    pub fn reverse(self: Self) Self {
        return .{
            .start = self.end,
            .control0 = self.control1,
            .control1 = self.control0,
            .end = self.start,
            .curve_type = self.curve_type,
        };
    }
    pub fn mul_mat(self: Self, _mat: math.matrix) Self {
        if (self.curve_type == .line) {
            const start_ = _mat.mul_point(self.start);
            const end_ = _mat.mul_point(self.end);
            return .{
                .start = start_,
                .control0 = start_,
                .control1 = end_,
                .end = end_,
                .curve_type = .line,
            };
        }
        return .{
            .start = _mat.mul_point(self.start),
            .control0 = _mat.mul_point(self.control0),
            .control1 = _mat.mul_point(self.control1),
            .end = _mat.mul_point(self.end),
            .curve_type = self.curve_type,
        };
    }
    pub fn quadratic_init(_start: point, _control01: point, _end: point) Self {
        return .{
            .start = _start,
            .control0 = convert_quadratic_to_cubic0(_start, _control01),
            .control1 = convert_quadratic_to_cubic1(_end, _control01),
            .end = _end,
            .curve_type = .quadratic,
        };
    }
    pub fn line_init(_start: point, _end: point) Self {
        return .{
            .start = _start,
            .control0 = _start,
            .control1 = _end,
            .end = _end,
            .curve_type = .line,
        };
    }
    //cubic curve default
    pub fn init(_start: point, _control0: point, _control1: point, _end: point) Self {
        return .{
            .start = _start,
            .control0 = _control0,
            .control1 = _control1,
            .end = _end,
        };
    }

    /// out_vertices type is []shape_vertex_type, out_indices type is []idx_type
    pub fn compute_curve(self: *Self, out_vertices: anytype, out_indices: anytype, in_out_vertice_len: *usize, in_out_indices_len: *usize) line_error!void {
        return try __compute_curve(self, self.start, self.control0, self.control1, self.end, out_vertices, out_indices, in_out_vertice_len, in_out_indices_len, -1);
    }

    /// TODO 테스트 해보면서 개선 필요 https://github.com/azer89/GPU_Curve_Rendering/blob/master/QtTestShader/CurveRenderer.cpp
    fn __compute_curve(self: *Self, _start: point, _control0: point, _control1: point, _end: point, out_vertices: anytype, out_indices: anytype, in_out_vertice_len: *usize, in_out_indices_len: *usize, repeat: i32) line_error!void {
        var d1: f64 = undefined;
        var d2: f64 = undefined;
        var d3: f64 = undefined;
        if (self.*.curve_type == .line) {
            //system.print_debug("line", .{});
            return;
        }
        const cur_type = if (self.*.curve_type == .quadratic) .quadratic else try __get_curve_type(_start, _control0, _control1, _end, &d1, &d2, &d3);
        self.*.curve_type = cur_type;

        var mat: math.matrix = undefined;
        var flip: bool = false;
        var artifact: i32 = 0;
        var subdiv: f32 = undefined;

        switch (cur_type) {
            .serpentine => {
                const t1 = sqrt(9.0 * d2 * d2 - 12 * d1 * d3);
                const ls = 3.0 * d2 - t1;
                const lt = 6.0 * d1;
                const ms = 3.0 * d2 + t1;
                const mt = lt;
                const ltMinusLs = lt - ls;
                const mtMinusMs = mt - ms;

                mat.e[0][0] = @floatCast(ls * ms);
                mat.e[0][1] = @floatCast(ls * ls * ls);
                mat.e[0][2] = @floatCast(ms * ms * ms);

                mat.e[1][0] = @floatCast((1.0 / 3.0) * (3.0 * ls * ms - ls * mt - lt * ms));
                mat.e[1][1] = @floatCast(ls * ls * (ls - lt));
                mat.e[1][2] = @floatCast(ms * ms * (ms - mt));

                mat.e[2][0] = @floatCast((1.0 / 3.0) * (lt * (mt - 2.0 * ms) + ls * (3.0 * ms - 2.0 * mt)));
                mat.e[2][1] = @floatCast(ltMinusLs * ltMinusLs * ls);
                mat.e[2][2] = @floatCast(mtMinusMs * mtMinusMs * ms);

                mat.e[3][0] = @floatCast(ltMinusLs * mtMinusMs);
                mat.e[3][1] = @floatCast(-(ltMinusLs * ltMinusLs * ltMinusLs));
                mat.e[3][2] = @floatCast(-(mtMinusMs * mtMinusMs * mtMinusMs));

                if (mat.e[0][0] > 0) flip = true;
                //system.print_debug("serpentine {} {d}", .{ flip, mat.e[0][0] });
            },
            .loop => {
                const t1 = sqrt(4.0 * d1 * d3 - 3.0 * d2 * d2);
                const ls = d2 - t1;
                const lt = 2.0 * d1;
                const ms = d2 + t1;
                const mt = lt;

                const ql = ls / lt;
                const qm = ms / mt;
                if (repeat == -1 and 0.0 < ql and ql < 1.0) {
                    artifact = 1;
                    subdiv = @floatCast(ql);
                    //system.print_debug("loop(1)", .{});
                } else if (repeat == -1 and 0.0 < qm and qm < 1.0) {
                    artifact = 2;
                    subdiv = @floatCast(ql);
                    //system.print_debug("loop(2)", .{});
                } else {
                    const ltMinusLs = lt - ls;
                    const mtMinusMs = mt - ms;

                    mat.e[0][0] = @floatCast(ls * ms);
                    mat.e[0][1] = @floatCast(ls * ls * ms);
                    mat.e[0][2] = @floatCast(ls * ms * ms);

                    mat.e[1][0] = @floatCast((1.0 / 3.0) * (-ls * mt - lt * ms + 3.0 * ls * ms));
                    mat.e[1][1] = @floatCast(-(1.0 / 3.0) * ls * (ls * (mt - 3.0 * ms) + 2.0 * lt * ms));
                    mat.e[1][2] = @floatCast(-(1.0 / 3.0) * ms * (ls * (2.0 * mt - 3.0 * ms) + lt * ms));

                    mat.e[2][0] = @floatCast((1.0 / 3.0) * (lt * (mt - 2.0 * ms) + ls * (3.0 * ms - 2.0 * mt)));
                    mat.e[2][1] = @floatCast((1.0 / 3.0) * ltMinusLs * (ls * (2.0 * mt - 3.0 * ms) + lt * ms));
                    mat.e[2][2] = @floatCast((1.0 / 3.0) * mtMinusMs * (ls * (mt - 3.0 * ms) + 2.0 * lt * ms));

                    mat.e[3][0] = @floatCast(ltMinusLs * mtMinusMs);
                    mat.e[3][1] = @floatCast(-(ltMinusLs * ltMinusLs) * mtMinusMs);
                    mat.e[3][2] = @floatCast(-ltMinusLs * mtMinusMs * mtMinusMs);

                    //if (repeat == -1) flip = ((d1 > 0 and mat.e[0][0] < 0) or (d1 < 0 and mat.e[0][0] > 0));
                    //system.print_debug("loop flip {}", .{flip});
                }
            },
            .cusp => {
                const ls = d3;
                const lt = 3.0 * d2;
                const lsMinusLt = ls - lt;

                mat.e[0][0] = @floatCast(ls);
                mat.e[0][1] = @floatCast(ls * ls * ls);
                mat.e[0][2] = 1;

                mat.e[1][0] = @floatCast((ls - (1.0 / 3.0) * lt));
                mat.e[1][1] = @floatCast(ls * ls * lsMinusLt);
                mat.e[1][2] = 1;

                mat.e[2][0] = @floatCast((ls - (2.0 / 3.0) * lt));
                mat.e[2][1] = @floatCast(lsMinusLt * lsMinusLt * ls);
                mat.e[2][2] = 1;

                mat.e[3][0] = @floatCast(lsMinusLt);
                mat.e[3][1] = @floatCast(lsMinusLt * lsMinusLt * lsMinusLt);
                mat.e[3][2] = 1;

                //system.print_debug("cusp {}", .{flip});
            },
            .quadratic => {
                mat.e[0][0] = 0;
                mat.e[0][1] = 0;
                mat.e[0][2] = 0;

                mat.e[1][0] = -(1.0 / 3.0);
                mat.e[1][1] = 0;
                mat.e[1][2] = (1.0 / 3.0);

                mat.e[2][0] = -(2.0 / 3.0);
                mat.e[2][1] = -(1.0 / 3.0);
                mat.e[2][2] = (2.0 / 3.0);

                mat.e[3][0] = -1;
                mat.e[3][1] = -1;
                mat.e[3][2] = 1;

                //if (math.cross2(_control0 - _start, _control1 - _control0) < 0) flip = true;
                //system.print_debug("quadratic {}", .{flip});
            },
            .line => {
                //system.print_debug("line", .{});
                return;
            },
            else => return line_error.is_not_curve,
        }

        if (artifact != 0) {
            const x01 = (_control0[0] - _start[0]) * subdiv + _start[0];
            const y01 = (_control0[1] - _start[1]) * subdiv + _start[1];

            const x12 = (_control1[0] - _control0[0]) * subdiv + _control0[0];
            const y12 = (_control1[1] - _control0[1]) * subdiv + _control0[1];

            const x23 = (_end[0] - _control1[0]) * subdiv + _control1[0];
            const y23 = (_end[1] - _control1[1]) * subdiv + _control1[1];

            const x012 = (x12 - x01) * subdiv + x01;
            const y012 = (y12 - y01) * subdiv + y01;

            const x123 = (x23 - x12) * subdiv + x12;
            const y123 = (y23 - y12) * subdiv + y12;

            const x0123 = (x123 - x012) * subdiv + x012;
            const y0123 = (y123 - y012) * subdiv + y012;

            out_vertices[in_out_vertice_len.*].pos = _start;
            out_vertices[in_out_vertice_len.* + 1].pos = .{ x0123, y0123 };
            out_vertices[in_out_vertice_len.* + 2].pos = _end;

            out_vertices[in_out_vertice_len.*].uvw = .{ 1, 0, 0 };
            out_vertices[in_out_vertice_len.* + 1].uvw = .{ 1, 0, 0 };
            out_vertices[in_out_vertice_len.* + 2].uvw = .{ 1, 0, 0 };

            out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
            out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 1);
            out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 2);

            in_out_vertice_len.* += 3;
            in_out_indices_len.* += 3;

            _ = try __compute_curve(self, _start, .{ x01, y01 }, .{ x012, y012 }, .{ x0123, y0123 }, out_vertices, out_indices, in_out_vertice_len, in_out_indices_len, if (artifact == 1) 0 else 1);
            _ = try __compute_curve(self, .{ x0123, y0123 }, .{ x123, y123 }, .{ x23, y23 }, _end, out_vertices, out_indices, in_out_vertice_len, in_out_indices_len, if (artifact == 1) 1 else 0);

            return;
        }
        //if (repeat == 1) flip = !flip;

        if (flip) {
            mat.e[0][0] *= -1;
            mat.e[0][1] *= -1;
            mat.e[1][0] *= -1;
            mat.e[1][1] *= -1;
            mat.e[2][0] *= -1;
            mat.e[2][1] *= -1;
            mat.e[3][0] *= -1;
            mat.e[3][1] *= -1;
        }
        out_vertices[in_out_vertice_len.*].pos = _start;
        out_vertices[in_out_vertice_len.* + 1].pos = _control0;
        out_vertices[in_out_vertice_len.* + 2].pos = _control1;
        out_vertices[in_out_vertice_len.* + 3].pos = _end;

        out_vertices[in_out_vertice_len.*].uvw = .{ mat.e[0][0], mat.e[0][1], mat.e[0][2] };
        out_vertices[in_out_vertice_len.* + 1].uvw = .{ mat.e[1][0], mat.e[1][1], mat.e[1][2] };
        out_vertices[in_out_vertice_len.* + 2].uvw = .{ mat.e[2][0], mat.e[2][1], mat.e[2][2] };
        out_vertices[in_out_vertice_len.* + 3].uvw = .{ mat.e[3][0], mat.e[3][1], mat.e[3][2] };

        {
            var i: u32 = 0;
            while (i < 4) : (i += 1) {
                var j: u32 = i + 1;
                while (j < 4) : (j += 1) {
                    if (math.compare(out_vertices[in_out_vertice_len.* + i].pos, out_vertices[in_out_vertice_len.* + j].pos)) {
                        var indices: [3]usize = .{ in_out_vertice_len.*, in_out_vertice_len.*, in_out_vertice_len.* };
                        var index: u32 = 0;
                        var k: u32 = 0;
                        while (k < 4) : (k += 1) {
                            if (k != j) {
                                indices[index] += @intCast(k);
                                index += 1;
                            }
                        }
                        out_indices[in_out_indices_len.*] = @intCast(indices[0]);
                        out_indices[in_out_indices_len.* + 1] = @intCast(indices[1]);
                        out_indices[in_out_indices_len.* + 2] = @intCast(indices[2]);
                        in_out_vertice_len.* += 4;
                        in_out_indices_len.* += 3;
                        return;
                    }
                }
            }
        }
        {
            var i: usize = 0;
            while (i < 4) : (i += 1) {
                var indices: [3]usize = .{ in_out_vertice_len.*, in_out_vertice_len.*, in_out_vertice_len.* };
                var index: usize = 0;
                var j: usize = 0;
                while (j < 4) : (j += 1) {
                    if (i != j) {
                        indices[index] += @intCast(j);
                        index += 1;
                    }
                }
                if (point_in_triangle(out_vertices[in_out_vertice_len.* + i].pos, out_vertices[indices[0]].pos, out_vertices[indices[1]].pos, out_vertices[indices[2]].pos)) {
                    var k: usize = 0;
                    while (k < 3) : (k += 1) {
                        out_indices[in_out_indices_len.*] = @intCast(indices[k]);
                        out_indices[in_out_indices_len.* + 1] = @intCast(indices[(k + 1) % 3]);
                        out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + i);
                        in_out_indices_len.* += 3;
                    }
                    in_out_vertice_len.* += 4;
                    return;
                }
            }
        }

        if (lines_intersect(_start, _control1, _control0, _end, null)) {
            if (math.length_pow(_control1, _start) < math.length_pow(_end, _control0)) {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 3);
            } else {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 3);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 3);
            }
        } else if (lines_intersect(_start, _end, _control0, _control1, null)) {
            if (math.length_pow(_end, _start) < math.length_pow(_control1, _control0)) {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 3);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 3);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 2);
            } else {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 3);
            }
        } else {
            if (math.length_pow(_control0, _start) < math.length_pow(_end, _control1)) {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 1);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 3);
            } else {
                out_indices[in_out_indices_len.*] = @intCast(in_out_vertice_len.*);
                out_indices[in_out_indices_len.* + 1] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 2] = @intCast(in_out_vertice_len.* + 3);
                out_indices[in_out_indices_len.* + 3] = @intCast(in_out_vertice_len.* + 3);
                out_indices[in_out_indices_len.* + 4] = @intCast(in_out_vertice_len.* + 2);
                out_indices[in_out_indices_len.* + 5] = @intCast(in_out_vertice_len.* + 1);
            }
        }
        in_out_indices_len.* += 6;
        in_out_vertice_len.* += 4;
    }
    pub fn get_curve_type(self: Self) line_error!curve_TYPE {
        var d1: f64 = undefined;
        var d2: f64 = undefined;
        var d3: f64 = undefined;
        return try __get_curve_type(self.start, self.control0, self.control1, self.end, &d1, &d2, &d3);
    }
    fn __get_curve_type(_start: point, _control0: point, _control1: point, _end: point, out_d1: *f64, out_d2: *f64, out_d3: *f64) line_error!curve_TYPE {
        const start_x: f64 = @floatCast(_start[0]);
        const start_y: f64 = @floatCast(_start[1]);
        const control0_x: f64 = @floatCast(_control0[0]);
        const control0_y: f64 = @floatCast(_control0[1]);
        const control1_x: f64 = @floatCast(_control1[0]);
        const control1_y: f64 = @floatCast(_control1[1]);
        const end_x: f64 = @floatCast(_end[0]);
        const end_y: f64 = @floatCast(_end[1]);

        const cross_1: [3]f64 = .{ end_y - control1_y, control1_x - end_x, end_x * control1_y - end_y * control1_x };
        const cross_2: [3]f64 = .{ start_y - end_y, end_x - start_x, start_x * end_y - start_y * end_x };
        const cross_3: [3]f64 = .{ control0_y - start_y, start_x - control0_x, control0_x * start_y - control0_y * start_x };

        const a1 = start_x * cross_1[0] + start_y * cross_1[1] + cross_1[2];
        const a2 = control0_x * cross_2[0] + control0_y * cross_2[1] + cross_2[2];
        const a3 = control1_x * cross_3[0] + control1_y * cross_3[1] + cross_3[2];

        out_d1.* = a1 - 2 * a2 + 3 * a3;
        out_d2.* = -a2 + 3 * a3;
        out_d3.* = 3 * a3;

        const D = (3 * (out_d2.* * out_d2.*) - 4 * out_d3.* * out_d1.*);
        const discr = out_d1.* * out_d1.* * D; //어떤 타입의 곡선인지 판별하는 값

        if (math.compare(_start, _control0) and math.compare(_control0, _control1) and math.compare(_control1, _end)) {
            return line_error.is_point_not_line;
        }

        if (std.math.approxEqAbs(f64, discr, 0, std.math.floatEps(f32))) {
            if (std.math.approxEqAbs(f64, out_d1.*, 0, std.math.floatEps(f32))) {
                if (std.math.approxEqAbs(f64, out_d2.*, 0, std.math.floatEps(f32))) {
                    if (std.math.approxEqAbs(f64, out_d3.*, 0, std.math.floatEps(f32))) return curve_TYPE.line;
                    return curve_TYPE.quadratic;
                }
            }
            return curve_TYPE.cusp;
        } else {
            if (std.math.approxEqAbs(f64, out_d1.*, 0, std.math.floatEps(f32))) return curve_TYPE.cusp;
        }
        if (discr > 0) return curve_TYPE.serpentine;
        return curve_TYPE.loop;
    }
};

pub const raw_polygon = struct {
    vertices: []graphics.shape_color_vertex_2d,
    indices: []u32,
};
