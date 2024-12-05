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

pub const shapes_error = error{
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
/// check point in polygon
pub fn point_in_polygon(p: point, pts: []const point) bool {
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
pub fn center_point_in_polygon(pts: []const point) point {
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
pub fn line_in_polygon(a: point, b: point, pts: []const point, check_inside_line: bool) bool {
    if (check_inside_line and point_in_polygon(a, pts)) return true; //Points a, b must all be inside the polygon so that line a, b and polygon line segments do not intersect, so b does not need to be checked.
    var i: usize = 0;
    var result: point = undefined;
    while (i < pts.len - 1) : (i += 1) {
        if (lines_intersect(pts[i], pts[i + 1], a, b, &result)) {
            if (math.compare_n(a, result, std.math.floatEps(f32)) or math.compare_n(b, result, std.math.floatEps(f32))) continue;
            return true;
        }
    }
    if (lines_intersect(pts[pts.len - 1], pts[0], a, b, &result)) {
        if (math.compare_n(a, result) or math.compare_n(b, result, std.math.floatEps(f32))) return false;
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

pub const shapes = struct {
    pub const shape_node = struct {
        lines: []line,
        color: ?vector = .{ 0, 0, 0, 1 },
        stroke_color: ?vector = null,
        n_polygons: []u32,
        thickness: f32 = 0,
    };
    nodes: []shape_node,

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

    pub fn apply_option(self: shapes, option: compute_option, _out_lines: [][]line) shapes_error!void {
        if (_out_lines.len != self.lines.len) return shapes_error.invaild_line;

        for (_out_lines, self.lines) |v, l| {
            if (v.len != l.len) return shapes_error.invaild_line;
            for (v, l) |*v2, l2| {
                v2.* = l2.mul_mat(option.mat);
            }
        }
    }

    fn _compute_polygon_sub(
        _out: *raw_shapes,
        _allocator: std.mem.Allocator,
        _lines: []line,
        _n_polygons: []const u32,
        _vertices_list: *ArrayList([]graphics.shape_vertex_2d),
        _indices_list: *ArrayList([]u32),
    ) shapes_error!void {
        _ = _out;
        var vertices_sub_list: ArrayList(graphics.shape_vertex_2d) = ArrayList(graphics.shape_vertex_2d).init(_allocator);
        var indices_sub_list: ArrayList(u32) = ArrayList(u32).init(_allocator);
        defer {
            vertices_sub_list.deinit();
            indices_sub_list.deinit();
        }
        errdefer {
            for (_vertices_list.*.items) |v| {
                _allocator.free(v);
            }
            for (_indices_list.*.items) |i| {
                _allocator.free(i);
            }
        }
        var vertex_len: u32 = 0;
        var first_vertex_idx: u32 = 0;

        for (_n_polygons) |n| {
            vertex_len += n;
            var i: u32 = first_vertex_idx;

            try vertices_sub_list.append(.{ .pos = .{ std.math.floatMax(f32), std.math.floatMin(f32) }, .uvw = .{ 1, 0, 0 } });
            const first_vertex_idx2: u32 = @intCast(vertices_sub_list.items.len - 1); // we need first {std.math.floatMax(f32), std.math.floatMin(f32) } point, so save idx2 separate

            var maxX: f32 = std.math.floatMin(f32);
            var minY: f32 = std.math.floatMax(f32);
            while (i < vertex_len) : (i += 1) {
                try vertices_sub_list.append(.{ .pos = _lines[i].start, .uvw = .{ 1, 0, 0 } });
                const last_vertex = &vertices_sub_list.items[vertices_sub_list.items.len - 1];
                if (vertices_sub_list.items[first_vertex_idx2].pos[0] > last_vertex.*.pos[0]) vertices_sub_list.items[first_vertex_idx2].pos[0] = last_vertex.*.pos[0];
                if (vertices_sub_list.items[first_vertex_idx2].pos[1] < last_vertex.*.pos[1]) vertices_sub_list.items[first_vertex_idx2].pos[1] = last_vertex.*.pos[1];
                if (maxX < last_vertex.*.pos[0]) maxX = last_vertex.*.pos[0];
                if (minY > last_vertex.*.pos[1]) minY = last_vertex.*.pos[1];

                try indices_sub_list.append(first_vertex_idx2);
                try indices_sub_list.append(@intCast(vertices_sub_list.items.len - 1));
                try indices_sub_list.append(if (i < vertex_len - 1) @intCast(vertices_sub_list.items.len - 1 + 1) else first_vertex_idx2 + 1);
            }
            vertices_sub_list.items[first_vertex_idx2].pos[0] -= (maxX - vertices_sub_list.items[first_vertex_idx2].pos[0]) / 2;
            vertices_sub_list.items[first_vertex_idx2].pos[1] += (vertices_sub_list.items[first_vertex_idx2].pos[1] - minY) / 2;

            for (_lines[first_vertex_idx..vertex_len]) |*l| {
                try l.*.compute_curve(&vertices_sub_list, &indices_sub_list);
            }
            first_vertex_idx = vertex_len;
        }

        try _vertices_list.*.append(try _allocator.dupe(graphics.shape_vertex_2d, vertices_sub_list.items));
        try _indices_list.*.append(try _allocator.dupe(u32, indices_sub_list.items));
    }

    fn _compute_polygon_sub_outline(
        _out: *raw_shapes,
        _allocator: std.mem.Allocator,
        _lines: []line,
        _n_polygons: []const u32,
        _vertices_list: *ArrayList([]graphics.shape_vertex_2d),
        _indices_list: *ArrayList([]u32),
        thickness: f32,
    ) shapes_error!void {
        _ = _out;
        var vertices_sub_list: ArrayList(graphics.shape_vertex_2d) = ArrayList(graphics.shape_vertex_2d).init(_allocator);
        var indices_sub_list: ArrayList(u32) = ArrayList(u32).init(_allocator);
        defer {
            vertices_sub_list.deinit();
            indices_sub_list.deinit();
        }
        errdefer {
            for (_vertices_list.*.items) |v| {
                _allocator.free(v);
            }
            for (_indices_list.*.items) |i| {
                _allocator.free(i);
            }
        }

        var lines_ = try _allocator.dupe(line, _lines);
        defer _allocator.free(lines_);

        for (&[_]f32{ thickness, -thickness }) |t| {
            var vertex_len: u32 = 0;
            var first_vertex_idx: u32 = 0;
            for (_n_polygons) |n| {
                vertex_len += n;
                var i: u32 = first_vertex_idx;
                const ccw: f32 = if (math.cross2(lines_[first_vertex_idx].start, if (lines_[first_vertex_idx].curve_type == .line) lines_[first_vertex_idx].end else lines_[first_vertex_idx].control0) > 0) -1 else 1;

                try vertices_sub_list.append(.{ .pos = .{ std.math.floatMax(f32), std.math.floatMin(f32) }, .uvw = .{ 1, 0, 0 } });
                const first_vertex_idx2: u32 = @intCast(vertices_sub_list.items.len - 1); // we need first {std.math.floatMax(f32), std.math.floatMin(f32) } point, so save idx2 separate

                var maxX: f32 = std.math.floatMin(f32);
                var minY: f32 = std.math.floatMax(f32);
                while (i < vertex_len) : (i += 1) {
                    const next = if (i + 1 < vertex_len) i + 1 else first_vertex_idx;
                    const prev = if (i == first_vertex_idx) vertex_len - 1 else (i - 1);

                    if (lines_[i].curve_type == .line) { //if type is line, no need to change lines_ value
                        try vertices_sub_list.append(.{ .pos = extend_point(
                            if (lines_[prev].curve_type == .line) lines_[prev].start else lines_[prev].control1,
                            lines_[i].start,
                            lines_[i].end,
                            t,
                            ccw,
                        ), .uvw = .{ 1, 0, 0 } });
                    } else {
                        lines_[i].start = extend_point(
                            if (lines_[prev].curve_type == .line) lines_[prev].start else lines_[prev].control1,
                            lines_[i].start,
                            lines_[i].control0,
                            t,
                            ccw,
                        );
                        try vertices_sub_list.append(.{ .pos = lines_[i].start, .uvw = .{ 1, 0, 0 } });

                        lines_[i].control0 = extend_point(
                            lines_[i].start,
                            lines_[i].control0,
                            lines_[i].control1,
                            t,
                            ccw,
                        );
                        lines_[i].control1 = extend_point(
                            lines_[i].control0,
                            lines_[i].control1,
                            lines_[i].end,
                            t,
                            ccw,
                        );
                        lines_[i].end = extend_point(
                            lines_[i].control1,
                            lines_[i].end,
                            if (lines_[next].curve_type == .line) lines_[next].end else lines_[next].control0,
                            t,
                            ccw,
                        );
                    }
                    const last_vertex = &vertices_sub_list.items[vertices_sub_list.items.len - 1];
                    if (vertices_sub_list.items[first_vertex_idx2].pos[0] > last_vertex.*.pos[0]) vertices_sub_list.items[first_vertex_idx2].pos[0] = last_vertex.*.pos[0];
                    if (vertices_sub_list.items[first_vertex_idx2].pos[1] < last_vertex.*.pos[1]) vertices_sub_list.items[first_vertex_idx2].pos[1] = last_vertex.*.pos[1];
                    if (maxX < last_vertex.*.pos[0]) maxX = last_vertex.*.pos[0];
                    if (minY > last_vertex.*.pos[1]) minY = last_vertex.*.pos[1];

                    try indices_sub_list.append(first_vertex_idx2);
                    try indices_sub_list.append(@intCast(vertices_sub_list.items.len - 1));
                    try indices_sub_list.append(if (i < vertex_len - 1) @intCast(vertices_sub_list.items.len - 1 + 1) else first_vertex_idx2 + 1);
                }
                vertices_sub_list.items[first_vertex_idx2].pos[0] -= (maxX - vertices_sub_list.items[first_vertex_idx2].pos[0]) / 2;
                vertices_sub_list.items[first_vertex_idx2].pos[1] += (vertices_sub_list.items[first_vertex_idx2].pos[1] - minY) / 2;

                for (lines_[first_vertex_idx..vertex_len]) |*l| {
                    try l.*.compute_curve(&vertices_sub_list, &indices_sub_list);
                }
                first_vertex_idx = vertex_len;
            }
        }
        for (lines_, 0..) |l, i| {
            _lines[i].curve_type = l.curve_type;
        }
        try _vertices_list.*.append(try _allocator.dupe(graphics.shape_vertex_2d, vertices_sub_list.items));
        try _indices_list.*.append(try _allocator.dupe(u32, indices_sub_list.items));
    }

    pub fn compute_polygon(self: *shapes, allocator: std.mem.Allocator) shapes_error!raw_shapes {
        var count: usize = 0;
        var _out: raw_shapes = undefined;
        var vertices_list: ArrayList([]graphics.shape_vertex_2d) = ArrayList([]graphics.shape_vertex_2d).init(allocator);
        var indices_list: ArrayList([]u32) = ArrayList([]u32).init(allocator);
        var color_list: ArrayList(vector) = ArrayList(vector).init(allocator);
        defer vertices_list.deinit();
        defer indices_list.deinit();
        defer color_list.deinit();

        count = 0;
        while (count < self.nodes.len) : (count += 1) {
            if (self.nodes[count].color != null) {
                try _compute_polygon_sub(
                    &_out,
                    allocator,
                    self.nodes[count].lines,
                    self.nodes[count].n_polygons,
                    &vertices_list,
                    &indices_list,
                );
                try color_list.append(self.nodes[count].color.?);
            }
            if (self.nodes[count].stroke_color != null and self.nodes[count].thickness > 0) {
                try _compute_polygon_sub_outline(
                    &_out,
                    allocator,
                    self.nodes[count].lines,
                    self.nodes[count].n_polygons,
                    &vertices_list,
                    &indices_list,
                    self.nodes[count].thickness,
                );
                try color_list.append(self.nodes[count].stroke_color.?);
            }
        }
        _out.vertices = try allocator.dupe([]graphics.shape_vertex_2d, vertices_list.items);
        errdefer allocator.free(_out.vertices);
        _out.indices = try allocator.dupe([]u32, indices_list.items);
        errdefer allocator.free(_out.indices);
        _out.colors = try allocator.dupe(vector, color_list.items);
        return _out;
    }
};

pub const line = struct {
    const Self = @This();
    start: point,
    control0: point,
    control1: point,
    end: point,
    /// default value 'unknown' recongnises curve type 'cubic' 기본값 'unknown'은 커브 유형 'cubic'으로 인식합니다.
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
    pub fn compute_curve(self: *Self, out_vertices: anytype, out_indices: anytype) line_error!void {
        return try __compute_curve(self, self.start, self.control0, self.control1, self.end, out_vertices, out_indices, -1);
    }

    /// TODO need test and improvement https://github.com/azer89/GPU_Curve_Rendering/blob/master/QtTestShader/CurveRenderer.cpp
    fn __compute_curve(self: *Self, _start: point, _control0: point, _control1: point, _end: point, out_vertices: *ArrayList(graphics.shape_vertex_2d), out_indices: *ArrayList(u32), repeat: i32) line_error!void {
        var d1: f32 = undefined;
        var d2: f32 = undefined;
        var d3: f32 = undefined;
        if (self.curve_type == .line) {
            //xfit.print_debug("line", .{});
            return;
        }

        const cur_type = if (self.curve_type == .quadratic) .quadratic else try __get_curve_type(_start, _control0, _control1, _end, &d1, &d2, &d3);
        self.curve_type = cur_type;

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

                mat[0][0] = @floatCast(ls * ms);
                mat[0][1] = @floatCast(ls * ls * ls);
                mat[0][2] = @floatCast(ms * ms * ms);

                mat[1][0] = @floatCast((1.0 / 3.0) * (3.0 * ls * ms - ls * mt - lt * ms));
                mat[1][1] = @floatCast(ls * ls * (ls - lt));
                mat[1][2] = @floatCast(ms * ms * (ms - mt));

                mat[2][0] = @floatCast((1.0 / 3.0) * (lt * (mt - 2.0 * ms) + ls * (3.0 * ms - 2.0 * mt)));
                mat[2][1] = @floatCast(ltMinusLs * ltMinusLs * ls);
                mat[2][2] = @floatCast(mtMinusMs * mtMinusMs * ms);

                mat[3][0] = @floatCast(ltMinusLs * mtMinusMs);
                mat[3][1] = @floatCast(-(ltMinusLs * ltMinusLs * ltMinusLs));
                mat[3][2] = @floatCast(-(mtMinusMs * mtMinusMs * mtMinusMs));

                if (mat[0][0] > 0) flip = true;
                //xfit.print_debug("serpentine {} {d}", .{ flip, mat[0][0] });
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
                    //xfit.print_debug("loop(1)", .{});
                } else if (repeat == -1 and 0.0 < qm and qm < 1.0) {
                    artifact = 2;
                    subdiv = @floatCast(qm);
                    //xfit.print_debug("loop(2)", .{});
                } else {
                    const ltMinusLs = lt - ls;
                    const mtMinusMs = mt - ms;

                    mat[0][0] = @floatCast(ls * ms);
                    mat[0][1] = @floatCast(ls * ls * ms);
                    mat[0][2] = @floatCast(ls * ms * ms);

                    mat[1][0] = @floatCast((1.0 / 3.0) * (-ls * mt - lt * ms + 3.0 * ls * ms));
                    mat[1][1] = @floatCast(-(1.0 / 3.0) * ls * (ls * (mt - 3.0 * ms) + 2.0 * lt * ms));
                    mat[1][2] = @floatCast(-(1.0 / 3.0) * ms * (ls * (2.0 * mt - 3.0 * ms) + lt * ms));

                    mat[2][0] = @floatCast((1.0 / 3.0) * (lt * (mt - 2.0 * ms) + ls * (3.0 * ms - 2.0 * mt)));
                    mat[2][1] = @floatCast((1.0 / 3.0) * ltMinusLs * (ls * (2.0 * mt - 3.0 * ms) + lt * ms));
                    mat[2][2] = @floatCast((1.0 / 3.0) * mtMinusMs * (ls * (mt - 3.0 * ms) + 2.0 * lt * ms));

                    mat[3][0] = @floatCast(ltMinusLs * mtMinusMs);
                    mat[3][1] = @floatCast(-(ltMinusLs * ltMinusLs) * mtMinusMs);
                    mat[3][2] = @floatCast(-ltMinusLs * mtMinusMs * mtMinusMs);

                    if ((mat[1][0] > 0)) flip = true;
                    //xfit.print_debug("loop flip {}", .{flip});
                }
            },
            .cusp => {
                const ls = d3;
                const lt = 3.0 * d2;
                const lsMinusLt = ls - lt;

                mat[0][0] = @floatCast(ls);
                mat[0][1] = @floatCast(ls * ls * ls);
                mat[0][2] = 1;

                mat[1][0] = @floatCast((ls - (1.0 / 3.0) * lt));
                mat[1][1] = @floatCast(ls * ls * lsMinusLt);
                mat[1][2] = 1;

                mat[2][0] = @floatCast((ls - (2.0 / 3.0) * lt));
                mat[2][1] = @floatCast(lsMinusLt * lsMinusLt * ls);
                mat[2][2] = 1;

                mat[3][0] = @floatCast(lsMinusLt);
                mat[3][1] = @floatCast(lsMinusLt * lsMinusLt * lsMinusLt);
                mat[3][2] = 1;

                flip = true;

                //xfit.print_debug("cusp {}", .{flip});
            },
            .quadratic => {
                mat[0][0] = 0;
                mat[0][1] = 0;
                mat[0][2] = 0;

                mat[1][0] = -(1.0 / 3.0);
                mat[1][1] = 0;
                mat[1][2] = (1.0 / 3.0);

                mat[2][0] = -(2.0 / 3.0);
                mat[2][1] = -(1.0 / 3.0);
                mat[2][2] = (2.0 / 3.0);

                mat[3][0] = -1;
                mat[3][1] = -1;
                mat[3][2] = 1;

                //if (math.cross2(_control0 - _start, _control1 - _control0) < 0) flip = true;
                //xfit.print_debug("quadratic {}", .{flip});
            },
            .line => {
                //std.debug.print("line\n", .{});
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

            try out_indices.*.append(@intCast(out_vertices.*.items.len));
            try out_indices.*.append(@intCast(out_vertices.*.items.len + 1));
            try out_indices.*.append(@intCast(out_vertices.*.items.len + 2));

            try out_vertices.*.append(.{ .pos = _start, .uvw = .{ 1, 0, 0 } });
            try out_vertices.*.append(.{ .pos = .{ x0123, y0123 }, .uvw = .{ 1, 0, 0 } });
            try out_vertices.*.append(.{ .pos = _end, .uvw = .{ 1, 0, 0 } });

            _ = try __compute_curve(self, _start, .{ x01, y01 }, .{ x012, y012 }, .{ x0123, y0123 }, out_vertices, out_indices, if (artifact == 1) 0 else 1);
            _ = try __compute_curve(self, .{ x0123, y0123 }, .{ x123, y123 }, .{ x23, y23 }, _end, out_vertices, out_indices, if (artifact == 1) 1 else 0);

            return;
        }
        //if (repeat == 1) flip = !flip;

        if (flip) {
            mat[0][0] *= -1;
            mat[0][1] *= -1;
            mat[1][0] *= -1;
            mat[1][1] *= -1;
            mat[2][0] *= -1;
            mat[2][1] *= -1;
            mat[3][0] *= -1;
            mat[3][1] *= -1;
        }
        const vertex_len = out_vertices.*.items.len;
        try out_vertices.*.append(.{ .pos = _start, .uvw = .{ mat[0][0], mat[0][1], mat[0][2] } });
        try out_vertices.*.append(.{ .pos = _control0, .uvw = .{ mat[1][0], mat[1][1], mat[1][2] } });
        try out_vertices.*.append(.{ .pos = _control1, .uvw = .{ mat[2][0], mat[2][1], mat[2][2] } });
        try out_vertices.*.append(.{ .pos = _end, .uvw = .{ mat[3][0], mat[3][1], mat[3][2] } });

        {
            var i: u32 = 0;
            while (i < 4) : (i += 1) {
                var j: u32 = i + 1;
                while (j < 4) : (j += 1) {
                    if (math.compare(out_vertices.*.items[vertex_len + i].pos, out_vertices.*.items[vertex_len + j].pos)) {
                        var indices: [3]usize = .{ vertex_len, vertex_len, vertex_len };
                        var index: u32 = 0;
                        var k: u32 = 0;
                        while (k < 4) : (k += 1) {
                            if (k != j) {
                                indices[index] += @intCast(k);
                                index += 1;
                            }
                        }
                        try out_indices.*.append(@intCast(indices[0]));
                        try out_indices.*.append(@intCast(indices[1]));
                        try out_indices.*.append(@intCast(indices[2]));
                        return;
                    }
                }
            }
        }
        {
            var i: usize = 0;
            while (i < 4) : (i += 1) {
                var indices: [3]usize = .{ vertex_len, vertex_len, vertex_len };
                var index: usize = 0;
                var j: usize = 0;
                while (j < 4) : (j += 1) {
                    if (i != j) {
                        indices[index] += @intCast(j);
                        index += 1;
                    }
                }
                if (point_in_triangle(out_vertices.*.items[vertex_len + i].pos, out_vertices.*.items[indices[0]].pos, out_vertices.*.items[indices[1]].pos, out_vertices.*.items[indices[2]].pos)) {
                    var k: usize = 0;
                    while (k < 3) : (k += 1) {
                        try out_indices.*.append(@intCast(indices[k]));
                        try out_indices.*.append(@intCast(indices[(k + 1) % 3]));
                        try out_indices.*.append(@intCast(vertex_len + i));
                    }
                    return;
                }
            }
        }

        if (lines_intersect(_start, _control1, _control0, _end, null)) {
            if (math.length_pow(_control1, _start) < math.length_pow(_end, _control0)) {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 3));
            } else {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 3));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 3));
            }
        } else if (lines_intersect(_start, _end, _control0, _control1, null)) {
            if (math.length_pow(_end, _start) < math.length_pow(_control1, _control0)) {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 3));
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 3));
                try out_indices.*.append(@intCast(vertex_len + 2));
            } else {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 3));
            }
        } else {
            if (math.length_pow(_control0, _start) < math.length_pow(_end, _control1)) {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 1));
                try out_indices.*.append(@intCast(vertex_len + 3));
            } else {
                try out_indices.*.append(@intCast(vertex_len));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 3));
                try out_indices.*.append(@intCast(vertex_len + 3));
                try out_indices.*.append(@intCast(vertex_len + 2));
                try out_indices.*.append(@intCast(vertex_len + 1));
            }
        }
    }
    pub fn get_curve_type(self: Self) line_error!curve_TYPE {
        var d1: f32 = undefined;
        var d2: f32 = undefined;
        var d3: f32 = undefined;
        return try __get_curve_type(self.start, self.control0, self.control1, self.end, &d1, &d2, &d3);
    }
    fn __get_curve_type(_start: point, _control0: point, _control1: point, _end: point, out_d1: *f32, out_d2: *f32, out_d3: *f32) line_error!curve_TYPE {
        const start_x: f32 = @floatCast(_start[0]);
        const start_y: f32 = @floatCast(_start[1]);
        const control0_x: f32 = @floatCast(_control0[0]);
        const control0_y: f32 = @floatCast(_control0[1]);
        const control1_x: f32 = @floatCast(_control1[0]);
        const control1_y: f32 = @floatCast(_control1[1]);
        const end_x: f32 = @floatCast(_end[0]);
        const end_y: f32 = @floatCast(_end[1]);

        const cross_1: [3]f32 = .{ end_y - control1_y, control1_x - end_x, end_x * control1_y - end_y * control1_x };
        const cross_2: [3]f32 = .{ start_y - end_y, end_x - start_x, start_x * end_y - start_y * end_x };
        const cross_3: [3]f32 = .{ control0_y - start_y, start_x - control0_x, control0_x * start_y - control0_y * start_x };

        const a1 = start_x * cross_1[0] + start_y * cross_1[1] + cross_1[2];
        const a2 = control0_x * cross_2[0] + control0_y * cross_2[1] + cross_2[2];
        const a3 = control1_x * cross_3[0] + control1_y * cross_3[1] + cross_3[2];

        out_d1.* = a1 - 2 * a2 + 3 * a3;
        out_d2.* = -a2 + 3 * a3;
        out_d3.* = 3 * a3;

        const D = (3 * (out_d2.* * out_d2.*) - 4 * out_d3.* * out_d1.*);
        const discr = out_d1.* * out_d1.* * D; //check type of curve, Discriminant

        if (math.compare(_start, _control0) and math.compare(_control0, _control1) and math.compare(_control1, _end)) {
            return line_error.is_point_not_line;
        }
        if (discr > std.math.floatEps(f32)) return curve_TYPE.serpentine;
        if (discr < -std.math.floatEps(f32)) return curve_TYPE.loop;
        if (std.math.approxEqAbs(f32, discr, 0, std.math.floatEps(f32))) {
            if (std.math.approxEqAbs(f32, out_d1.*, 0, std.math.floatEps(f32))) {
                if (std.math.approxEqAbs(f32, out_d2.*, 0, std.math.floatEps(f32))) {
                    if (std.math.approxEqAbs(f32, out_d3.*, 0, std.math.floatEps(f32))) return curve_TYPE.line;
                    return curve_TYPE.quadratic;
                }
            }
            return curve_TYPE.cusp;
        }
        return curve_TYPE.loop;
    }
};

pub const raw_shapes = struct {
    vertices: [][]graphics.shape_vertex_2d,
    indices: [][]u32,
    colors: []vector,
    pub fn deinit(self: raw_shapes, _allocator: std.mem.Allocator) void {
        for (self.vertices, self.indices) |v, i| {
            _allocator.free(v);
            _allocator.free(i);
        }
        _allocator.free(self.vertices);
        _allocator.free(self.indices);
        _allocator.free(self.colors);
    }
    pub fn concat(self: raw_shapes, src: raw_shapes, _allocator: std.mem.Allocator) !raw_shapes {
        var vertices = try _allocator.alloc([]graphics.shape_vertex_2d, self.vertices.len + src.vertices.len);
        errdefer _allocator.free(vertices);
        var indices = try _allocator.alloc([]u32, self.indices.len + src.indices.len);
        errdefer _allocator.free(indices);
        var colors = try _allocator.alloc(vector, self.colors.len + src.colors.len);
        errdefer _allocator.free(colors);

        for (
            vertices[0..self.vertices.len],
            indices[0..self.indices.len],
            self.vertices,
            self.indices,
            0..,
        ) |*v, *i, vv, ii, j| {
            errdefer {
                for (0..j) |jj| {
                    _allocator.free(vertices[jj]);
                    _allocator.free(indices[jj]);
                }
            }
            v.* = try _allocator.dupe(graphics.shape_vertex_2d, vv);
            errdefer _allocator.free(v.*);
            i.* = try _allocator.dupe(u32, ii);
        }

        for (
            vertices[self.vertices.len..],
            indices[self.indices.len..],
            src.vertices,
            src.indices,
            self.indices.len..,
        ) |*v, *i, vv, ii, j| {
            errdefer {
                for (0..j) |jj| {
                    _allocator.free(vertices[jj]);
                    _allocator.free(indices[jj]);
                }
            }
            v.* = try _allocator.dupe(graphics.shape_vertex_2d, vv);
            errdefer _allocator.free(v.*);
            i.* = try _allocator.dupe(u32, ii);
        }
        @memcpy(colors[0..self.colors.len], self.colors);
        @memcpy(colors[self.colors.len..], src.colors);

        return .{
            .vertices = vertices,
            .indices = indices,
            .colors = colors,
        };
    }
};
