///! incomplete
const std = @import("std");
const xml = @import("xfit.zig").xml;
const meta = @import("meta.zig");
const math = @import("math.zig");
const geometry = @import("geometry.zig");

const Self = @This();
const ArrayList = std.ArrayList;

const point = math.point;
const vector = math.vector;
const shapes = geometry.shapes;

pub const SVG = struct {
    width: ?[]const u8 = null,
    height: ?[]const u8 = null,
};
///! css not supported yet
pub const FILL_AND_STROKE = struct {
    fill: ?[]const u8 = null,
    stroke: ?[]const u8 = null,
    stroke_width: ?f32 = null,
    ///! Not supported yet
    stroke_linecap: ?[]const u8 = null,
    ///! Not supported yet
    stroke_dasharray: ?[]const u8 = null,
    fill_opacity: ?f32 = null,
    stroke_opacity: ?f32 = null,
};
pub const PATH = struct {
    d: ?[]const u8 = null,
    @"fill-rule": ?[]const u8 = null,
    @"clip-rule": ?[]const u8 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const RECT = struct {
    x: ?f32 = null,
    y: ?f32 = null,
    width: ?f32 = null,
    height: ?f32 = null,
    rx: ?f32 = null,
    ry: ?f32 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const CIRCLE = struct {
    cx: ?f32 = null,
    cy: ?f32 = null,
    r: ?f32 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const ELLIPSE = struct {
    cx: ?f32 = null,
    cy: ?f32 = null,
    rx: ?f32 = null,
    ry: ?f32 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const LINE = struct {
    x1: ?f32 = null,
    y1: ?f32 = null,
    x2: ?f32 = null,
    y2: ?f32 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const POLYLINE = struct {
    points: ?[]point = null,
    _0: FILL_AND_STROKE = .{},
};
pub const POLYGON = struct {
    points: ?[]point = null,
    _0: FILL_AND_STROKE = .{},
};

pub const SVG_ERROR = error{
    NOT_INITIALIZED,
    OVERLAPPING_NODE,
    INVALID_NODE,
    UNSUPPORTED_FEATURE,
};

const svg_tags = [_][:0]const u8{ "svg", "path", "rect", "circle", "ellipse", "line", "polyline", "polygon" };
const svg_tags2 = [_]type{ SVG, PATH, RECT, CIRCLE, ELLIPSE, LINE, POLYLINE, POLYGON };
pub const svg_shape_ptr = union(enum) {
    path: *PATH,
    rect: *RECT,
    circle: *CIRCLE,
    ellipse: *ELLIPSE,
    line: *LINE,
    polyline: *POLYLINE,
    polygon: *POLYGON,
};

arena_allocator: ?std.heap.ArenaAllocator = null,
xml_error_code: xml.Reader.ErrorCode = undefined,
svg: SVG = .{},
path: []PATH = undefined,
rect: []RECT = undefined,
circle: []CIRCLE = undefined,
ellipse: []ELLIPSE = undefined,
line: []LINE = undefined,
polyline: []POLYLINE = undefined,
polygon: []POLYGON = undefined,
shape_ptrs: []svg_shape_ptr = undefined,

fn _parse_point(_str: []const u8, i: *usize) !point {
    i.* = std.mem.indexOfAnyPos(u8, _str, i.*, "0123456789.-") orelse return SVG_ERROR.INVALID_NODE;
    // - 문자가 발견되면 별개의 숫자로 인식 '-' Recognises characters as separate numbers when found
    var nonidx = std.mem.indexOfNonePos(u8, _str, i.* + 1, "0123456789.") orelse return SVG_ERROR.INVALID_NODE;
    var found_dot = false;
    for (i.*..nonidx) |idx| {
        if (_str[idx] == '.') {
            if (!found_dot) {
                found_dot = true;
            } else {
                nonidx = idx; //find and check two more dots.
                break;
            }
        }
    }
    const x = try std.fmt.parseFloat(f32, _str[i.*..nonidx]);
    i.* = std.mem.indexOfAnyPos(u8, _str, nonidx, "0123456789.-") orelse return SVG_ERROR.INVALID_NODE;
    nonidx = std.mem.indexOfNonePos(u8, _str, i.* + 1, "0123456789.") orelse _str.len;
    found_dot = false;
    for (i.*..nonidx) |idx| {
        if (_str[idx] == '.') {
            if (!found_dot) {
                found_dot = true;
            } else {
                nonidx = idx; //find and check two more dots.
                break;
            }
        }
    }

    const y = try std.fmt.parseFloat(f32, _str[i.*..nonidx]);
    i.* = nonidx;
    return .{ x, y };
}
fn _parse_number(comptime T: type, _str: []const u8, i: *usize) !T {
    i.* = std.mem.indexOfAnyPos(u8, _str, i.*, "0123456789.-") orelse return SVG_ERROR.INVALID_NODE;
    // - 문자가 발견되면 별개의 숫자로 인식 '-' Recognises characters as separate numbers when found
    var nonidx = std.mem.indexOfNonePos(u8, _str, i.* + 1, "0123456789.") orelse _str.len;
    var found_dot = false;
    for (i.*..nonidx) |idx| {
        if (_str[idx] == '.') {
            if (!found_dot) {
                found_dot = true;
            } else {
                nonidx = idx; //find and check two more dots.
                break;
            }
        }
    }
    const x = try meta.parse_value(T, _str[i.*..nonidx]);
    i.* = nonidx;
    return x;
}
fn _parse_bool(_str: []const u8, i: *usize) !bool {
    i.* = std.mem.indexOfAnyPos(u8, _str, i.*, "01") orelse return SVG_ERROR.INVALID_NODE;
    const x = _str[i.*] == '1';
    i.* += 1;
    return x;
}

fn _parse_points(_str: []const u8, _allocator: *std.heap.ArenaAllocator) ![]point {
    const allocator = _allocator.*.allocator();
    var points = ArrayList(point).init(allocator);

    var i: usize = 0;
    while (i < _str.len) {
        try points.append(try _parse_point(_str, &i));
    }
    return points.items;
}

fn _parse_xml_element(out: anytype, allocator: *std.heap.ArenaAllocator, local: []const u8, value: []const u8) !void {
    inline for (std.meta.fields(@TypeOf(out.*))) |field| {
        if (@typeInfo(field.type) == .@"struct") {
            try _parse_xml_element(&@field(out.*, field.name), allocator, local, value);
        } else {
            if (@field(out.*, field.name) == null and std.mem.eql(u8, local, field.name)) {
                if (@typeInfo(field.type).optional.child == []point) {
                    @field(out.*, field.name) = try _parse_points(value, allocator);
                } else {
                    @field(out.*, field.name) = try meta.parse_value(@typeInfo(field.type).optional.child, value);
                }
            }
        }
    }
}

pub fn deinit(self: *Self) void {
    if (self.arena_allocator != null) {
        self.arena_allocator.?.deinit();
        self.arena_allocator = null;
    }
}

pub fn init_parse(allocator: std.mem.Allocator, _svg_data: []const u8) !Self {
    var self: Self = undefined;
    self.arena_allocator = std.heap.ArenaAllocator.init(allocator);
    errdefer self.deinit();

    var fixed_buffer_stream = std.io.fixedBufferStream(_svg_data);
    var doc = xml.streamingDocument(self.arena_allocator.?.allocator(), fixed_buffer_stream.reader());
    //defer doc.deinit();

    var reader = doc.reader(self.arena_allocator.?.allocator(), .{});
    //defer reader.deinit();

    var shapes_list = ArrayList(svg_shape_ptr).init(self.arena_allocator.?.allocator());

    comptime var output_fields: [svg_tags.len]std.builtin.Type.StructField = undefined;
    inline for (svg_tags, svg_tags2, 0..) |tag, tag2, i| {
        output_fields[i] = .{
            .name = tag,
            .type = if (meta.is_slice(@TypeOf(@field(self, tag)))) ArrayList(tag2) else ?tag2,
            .default_value = null,
            .is_comptime = false,
            .alignment = 0,
        };
    }
    const svg_tags_struct = @Type(.{
        .@"struct" = .{
            .is_tuple = false,
            .layout = .auto,
            .decls = &.{},
            .fields = &output_fields,
        },
    });
    var svg_tags_list: svg_tags_struct = undefined;
    inline for (svg_tags) |tag| {
        if (meta.is_slice(@TypeOf(@field(self, tag)))) {
            @field(svg_tags_list, tag) = @TypeOf(@field(svg_tags_list, tag)).init(self.arena_allocator.?.allocator());
        } else {
            @field(svg_tags_list, tag) = null;
        }
    }

    while (true) {
        const node = reader.read() catch |err| {
            self.xml_error_code = reader.reader.error_code;
            return err;
        };
        switch (node) {
            .element_start => {
                const element_name = reader.elementNameNs();

                inline for (svg_tags) |tag| {
                    if (std.mem.eql(u8, element_name.local, tag)) {
                        if (meta.is_slice(@TypeOf(@field(self, tag)))) {
                            const list = &@field(svg_tags_list, tag);
                            try list.*.append(.{});
                            for (0..reader.reader.attributeCount()) |i| {
                                try _parse_xml_element(&list.*.items[list.*.items.len - 1], &self.arena_allocator.?, reader.attributeNameNs(i).local, try reader.attributeValueAlloc(self.arena_allocator.?.allocator(), i));
                            }
                            try shapes_list.append(@unionInit(svg_shape_ptr, tag, &list.*.items[list.*.items.len - 1]));
                        } else {
                            const list = &@field(svg_tags_list, tag);
                            if (list.* != null) return SVG_ERROR.OVERLAPPING_NODE;
                            list.* = .{};
                            for (0..reader.reader.attributeCount()) |i| {
                                try _parse_xml_element(&list.*.?, &self.arena_allocator.?, reader.attributeNameNs(i).local, try reader.attributeValueAlloc(self.arena_allocator.?.allocator(), i));
                            }
                        }
                        break;
                    }
                }
            },
            .eof => {
                break;
            },
            else => {},
        }
    }
    inline for (svg_tags) |tag| {
        if (meta.is_slice(@TypeOf(@field(self, tag)))) {
            @field(self, tag) = @field(svg_tags_list, tag).items;
        } else {
            if (@field(svg_tags_list, tag) != null) {
                @field(self, tag) = @field(svg_tags_list, tag).?;
            }
        }
    }
    self.shape_ptrs = shapes_list.items;
    return self; //?arraylists will not be deallocated when you leave this function.
}

const css_color = enum(u32) {
    pub const cyan = css_color.aqua;
    pub const magenta = css_color.fuchsia;
    pub const darkgray = css_color.darkgrey;
    pub const dimgray = css_color.dimgrey;
    pub const gray = css_color.grey;
    pub const lightgray = css_color.lightgrey;
    pub const lightslategray = css_color.lightslategrey;
    pub const slategray = css_color.slategrey;
    black = 0x000000,
    silver = 0xc0c0c0,
    white = 0xffffff,
    maroon = 0x800000,
    red = 0xff0000,
    purple = 0x800080,
    fuchsia = 0xff00ff,
    green = 0x008000,
    lime = 0x00ff00,
    olive = 0x808000,
    yellow = 0xffff00,
    navy = 0x000080,
    blue = 0x0000ff,
    teal = 0x008080,
    aqua = 0x00ffff,
    orange = 0xffa500,
    aliceblue = 0xf0f8ff,
    antiquewhite = 0xfaebd7,
    aquamarine = 0x7fffd4,
    azure = 0xf0ffff,
    beige = 0xf5f5dc,
    bisque = 0xffe4c4,
    blanchedalmond = 0xffebcd,
    blueviolet = 0x8a2be2,
    brown = 0xa52a2a,
    burlywood = 0xdeb887,
    cadetblue = 0x5f9ea0,
    chartreuse = 0x7fff00,
    chocolate = 0xd2691e,
    coral = 0xff7f50,
    cornflowerblue = 0x6495ed,
    cornsilk = 0xfff8dc,
    crimson = 0xdc143c,
    darkblue = 0x00008b,
    darkcyan = 0x008b8b,
    darkgoldenrod = 0xb8860b,
    darkgreen = 0x006400,
    darkgrey = 0xa9a9a9,
    darkkhaki = 0xbdb76b,
    darkmagenta = 0x8b008b,
    darkolivegreen = 0x556b2f,
    darkorange = 0xff8c00,
    darkorchid = 0x9932cc,
    darkred = 0x8b0000,
    darksalmon = 0xe9967a,
    darkseagreen = 0x8fbc8f,
    darkslateblue = 0x483d8b,
    darkslategrey = 0x2f4f4f,
    darkturquoise = 0x00ced1,
    darkviolet = 0x9400d3,
    deeppink = 0xff1493,
    deepskyblue = 0x00bfff,
    dimgrey = 0x696969,
    dodgerblue = 0x1e90ff,
    firebrick = 0xb22222,
    floralwhite = 0xfffaf0,
    forestgreen = 0x228b22,
    gainsboro = 0xdcdcdc,
    ghostwhite = 0xf8f8ff,
    gold = 0xffd700,
    goldenrod = 0xdaa520,
    greenyellow = 0xadff2f,
    grey = 0x808080,
    honeydew = 0xf0fff0,
    hotpink = 0xff69b4,
    indianred = 0xcd5c5c,
    indigo = 0x4b0082,
    ivory = 0xfffff0,
    khaki = 0xf0e68c,
    lavender = 0xe6e6fa,
    lavenderblush = 0xfff0f5,
    lawngreen = 0x7cfc00,
    lemonchiffon = 0xfffacd,
    lightblue = 0xadd8e6,
    lightcoral = 0xf08080,
    lightcyan = 0xe0ffff,
    lightgoldenrodyellow = 0xfafad2,
    lightgreen = 0x90ee90,
    lightgrey = 0xd3d3d3,
    lightpink = 0xffb6c1,
    lightsalmon = 0xffa07a,
    lightseagreen = 0x20b2aa,
    lightskyblue = 0x87cefa,
    lightslategrey = 0x778899,
    lightsteelblue = 0xb0c4de,
    lightyellow = 0xffffe0,
    limegreen = 0x32cd32,
    linen = 0xfaf0e6,
    mediumaquamarine = 0x66cdaa,
    mediumblue = 0x0000cd,
    mediumorchid = 0xba55d3,
    mediumpurple = 0x9370db,
    mediumseagreen = 0x3cb371,
    mediumslateblue = 0x7b68ee,
    mediumspringgreen = 0x00fa9a,
    mediumturquoise = 0x48d1cc,
    mediumvioletred = 0xc71585,
    midnightblue = 0x191970,
    mintcream = 0xf5fffa,
    mistyrose = 0xffe4e1,
    moccasin = 0xffe4b5,
    navajowhite = 0xffdead,
    oldlace = 0xfdf5e6,
    olivedrab = 0x6b8e23,
    orangered = 0xff4500,
    orchid = 0xda70d6,
    palegoldenrod = 0xeee8aa,
    palegreen = 0x98fb98,
    paleturquoise = 0xafeeee,
    palevioletred = 0xdb7093,
    papayawhip = 0xffefd5,
    peachpuff = 0xffdab9,
    peru = 0xcd853f,
    pink = 0xffc0cb,
    plum = 0xdda0dd,
    powderblue = 0xb0e0e6,
    rosybrown = 0xbc8f8f,
    royalblue = 0x4169e1,
    saddlebrown = 0x8b4513,
    salmon = 0xfa8072,
    sandybrown = 0xf4a460,
    seagreen = 0x2e8b57,
    seashell = 0xfff5ee,
    sienna = 0xa0522d,
    skyblue = 0x87ceeb,
    slateblue = 0x6a5acd,
    slategrey = 0x708090,
    snow = 0xfffafa,
    springgreen = 0x00ff7f,
    steelblue = 0x4682b4,
    tan = 0xd2b48c,
    thistle = 0xd8bfd8,
    tomato = 0xff6347,
    turquoise = 0x40e0d0,
    violet = 0xee82ee,
    wheat = 0xf5deb3,
    whitesmoke = 0xf5f5f5,
    yellowgreen = 0x9acd32,
    rebeccapurple = 0x663399,
};

fn _parse_color(color: []const u8) !?vector {
    if (std.mem.eql(u8, color, "none")) return null;
    var res: ?u32 = null;
    if (color[0] == '#') {
        res = try std.fmt.parseUnsigned(u32, color[1..], 16);
        if (color.len == 4) { //#fff format
            return vector{ @floatFromInt((res.? >> 8) & 0xf), @floatFromInt((res.? >> 4) & 0xf), @floatFromInt(res.? & 0xf), 0xf } / @as(vector, @splat(0xf));
        }
    } else if (std.mem.eql(u8, color[0..3], "rgb")) { //TODO
        if (color[3] == 'a') {} else {}
        return SVG_ERROR.UNSUPPORTED_FEATURE;
    } else if (std.mem.eql(u8, color[0..3], "hsl")) { //TODO
        if (color[3] == 'a') {} else {}
        return SVG_ERROR.UNSUPPORTED_FEATURE;
    }
    if (res == null) {
        inline for (comptime std.meta.fieldNames(css_color)) |name| {
            if (std.mem.eql(u8, color, name)) {
                res = @intFromEnum(@field(css_color, name));
                break;
            }
        }
    }
    if (res == null) {
        inline for (comptime std.meta.declarations(css_color)) |decl| {
            if (std.mem.eql(u8, color, decl.name)) {
                res = @intFromEnum(@field(css_color, decl.name));
            }
        }
    }
    if (res != null) {
        return vector{ @floatFromInt((res.? >> 16) & 0xff), @floatFromInt((res.? >> 8) & 0xff), @floatFromInt(res.? & 0xff), 0xff } / @as(vector, @splat(0xff));
    }
    return SVG_ERROR.INVALID_NODE;
}

fn _parse_path(nodes: *ArrayList(shapes.shape_node), path: PATH, _allocator: *std.heap.ArenaAllocator) !void {
    const F = struct {
        pub fn _read_path_p(_str: []const u8, i: *usize, op_: u8, cur: point) !point {
            var p = _parse_point(_str, i) catch |e| {
                std.debug.print("\n{s}\n{s}\n", .{ _str, _str[i.*..] });
                return e;
            };
            p[1] *= -1;
            if (std.ascii.isLower(op_)) {
                p += cur;
            }
            return p;
        }
        pub fn _read_path_fx(_str: []const u8, i: *usize, op_: u8, cur_x: f32) !f32 {
            var f = _parse_number(f32, _str, i) catch |e| {
                //std.debug.print("\n{s}\n{s}\n", .{ path.d.?, path.d.?[i.*..] });
                return e;
            };
            if (std.ascii.isLower(op_)) {
                f += cur_x;
            }
            return f;
        }
        pub fn _read_path_fy(_str: []const u8, i: *usize, op_: u8, cur_y: f32) !f32 {
            var f = _parse_number(f32, _str, i) catch |e| {
                //std.debug.print("\n{s}\n{s}\n", .{ path.d.?, path.d.?[i.*..] });
                return e;
            };
            f *= -1;
            if (std.ascii.isLower(op_)) {
                f += cur_y;
            }
            return f;
        }
        ///arc first point parameter is rx,ry
        pub fn _read_path_r(_str: []const u8, i: *usize) !point {
            const r = _parse_point(_str, i) catch |e| {
                //std.debug.print("\n{s}\n{s}\n", .{ path.d.?, path.d.?[i.*..] });
                return e;
            };
            return r;
        }
    };

    const has_stroke = path._0.stroke != null and path._0.stroke_width != null and path._0.stroke_width.? > 0;
    const has_fill = path._0.fill != null;
    if (!(path.d != null and (has_fill or has_stroke))) return;
    const allocator = _allocator.*.allocator();

    var node = shapes.shape_node{
        .color = if (has_fill) try _parse_color(path._0.fill.?) else null,
        .stroke_color = if (has_stroke) try _parse_color(path._0.stroke.?) else null,
        .lines = undefined,
        .n_polygons = undefined,
        .thickness = if (has_stroke) path._0.stroke_width.? / 2 else 0,
    };
    var lines = ArrayList(geometry.line).init(allocator);
    var n_polygons = ArrayList(u32).init(allocator);
    var line: geometry.line = undefined;
    var cur: point = .{ 0, 0 };
    var start: bool = false;

    var i: usize = 0;
    var starti: usize = 0;
    var npoly: u32 = 0;
    var op_: ?u8 = null;
    while (i < path.d.?.len) {
        if (path.d.?[i] == 'Z' or path.d.?[i] == 'z') {
            if (lines.items.len == 0) return SVG_ERROR.INVALID_NODE;
            if (start) {
                line = geometry.line.line_init(line.start, lines.items[starti].start);
                start = false;
            } else {
                line = geometry.line.line_init(lines.items[lines.items.len - 1].end, lines.items[starti].start);
            }
            if (!math.compare_n(line.start, line.end, 0.00001)) {
                try lines.append(line);
                npoly += 1;
            }
            cur = line.end;
            i += 1;
            op_ = null;
            continue;
        }
        i = std.mem.indexOfNonePos(u8, path.d.?, i, " \r\n") orelse break;
        if (std.ascii.isAlphabetic(path.d.?[i])) {
            op_ = path.d.?[i];
            i += 1;
        }
        if (i >= path.d.?.len) {
            break;
        }
        var prevS: ?point = null;
        var prevT: ?point = null;

        switch (op_.?) {
            'M', 'm' => {
                const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                line.start = p;
                cur = p;
                starti = lines.items.len;
                if (npoly > 0) {
                    try n_polygons.append(npoly);
                    npoly = 0;
                }
                start = true;
                prevS = null;
                prevT = null;
                continue;
            },
            'L', 'l' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                line = geometry.line.line_init(line.start, p);
                cur = p;
                prevS = null;
                prevT = null;
            },
            'V', 'v' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const y = try F._read_path_fy(path.d.?, &i, op_.?, cur[1]);
                line = geometry.line.line_init(line.start, .{ line.start[0], y });
                cur[1] = y;
                prevS = null;
                prevT = null;
            },
            'H', 'h' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const x = try F._read_path_fx(path.d.?, &i, op_.?, cur[0]);
                line = geometry.line.line_init(line.start, .{ x, line.start[1] });
                cur[0] = x;
                prevS = null;
                prevT = null;
            },
            'Q', 'q' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                const p2 = try F._read_path_p(path.d.?, &i, op_.?, cur);

                line = geometry.line.quadratic_init(line.start, p, p2);
                cur = p2;
                prevS = null;
                prevT = p;
            },
            'C', 'c' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                const p2 = try F._read_path_p(path.d.?, &i, op_.?, cur);
                const p3 = try F._read_path_p(path.d.?, &i, op_.?, cur);
                if (math.compare(p, line.start)) {
                    line = geometry.line.quadratic_init(line.start, p2, p3);
                } else {
                    line = geometry.line{
                        .start = line.start,
                        .control0 = p,
                        .control1 = p2,
                        .end = p3,
                    };
                }

                cur = p3;
                prevS = p2;
                prevT = null;
            },
            'S', 's' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                if (prevS == null) {
                    const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                    const p2 = try F._read_path_p(path.d.?, &i, op_.?, cur);
                    line = geometry.line.quadratic_init(line.start, p, p2);
                    cur = p2;
                    prevS = p;
                } else {
                    const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                    const p0 = math.xy_mirror_point(cur, prevS.?);
                    const p2 = try F._read_path_p(path.d.?, &i, op_.?, cur);
                    line = geometry.line{
                        .start = line.start,
                        .control0 = p0,
                        .control1 = p,
                        .end = p2,
                    };
                    cur = p2;
                    prevS = p;
                }
                prevT = null;
            },
            'T', 't' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                const p = try F._read_path_p(path.d.?, &i, op_.?, cur);
                if (prevT == null) {
                    line = geometry.line.line_init(line.start, p);
                } else {
                    const p0 = math.xy_mirror_point(cur, prevT.?);
                    line = geometry.line.quadratic_init(line.start, p0, p);
                    cur = p;
                    prevT = p0;
                }
                prevS = null;
            },
            //원호 Arc
            //https://www.npmjs.com/package/svg-arc-to-cubic-bezier?activeTab=code
            'A', 'a' => {
                if (!start) return SVG_ERROR.INVALID_NODE;
                prevS = null;
                prevT = null;

                const doublePI: comptime_float = std.math.pi * 2;

                var r = try F._read_path_r(path.d.?, &i);
                const x_angle: f32 = try _parse_number(f32, path.d.?, &i) * doublePI / 360;
                const large_arc: bool = try _parse_bool(path.d.?, &i);
                const sweep: bool = try _parse_bool(path.d.?, &i);
                var end = try F._read_path_p(path.d.?, &i, op_.?, cur);

                end[1] *= -1;
                cur[1] *= -1;

                const sin = @sin(x_angle);
                const cos = @cos(x_angle);

                const pp = point{ cos * (cur[0] - end[0]) / 2 + sin * (cur[1] - end[1]) / 2, -sin * (cur[0] - end[0]) / 2 + cos * (cur[1] - end[1]) / 2 };

                prevS = null;
                prevT = null;
                if ((pp[0] == 0 and pp[1] == 0) or (r[0] == 0 or r[1] == 0)) {
                    end[1] *= -1;
                    line = geometry.line.line_init(line.start, end);
                    cur = end;
                } else {
                    r = @abs(r);

                    const lambda = (pp[0] * pp[0]) / (r[0] * r[0]) + (pp[1] * pp[1]) / (r[1] * r[1]);

                    if (lambda > 1) {
                        r *= @splat(std.math.sqrt(lambda));
                    }
                    const r_sq = r * r;
                    const pp_sq = pp * pp;

                    var radicant: f32 = r_sq[0] * r_sq[1] - r_sq[0] * pp_sq[1] - r_sq[1] * pp_sq[0];
                    if (radicant < 0) radicant = 0;
                    radicant /= (r_sq[0] * pp_sq[1]) + (r_sq[1] * pp_sq[0]);
                    if (large_arc == sweep) {
                        radicant = -std.math.sqrt(radicant);
                    } else {
                        radicant = std.math.sqrt(radicant);
                    }

                    const centerp = point{ radicant * r[0] / r[1] * pp[1], radicant * -r[1] / r[0] * pp[0] };
                    const center = point{
                        cos * centerp[0] - sin * centerp[1] + (cur[0] + end[0]) / 2,
                        sin * centerp[0] + cos * centerp[1] + (cur[1] + end[1]) / 2,
                    };

                    const v1: point = (pp - centerp) / r;
                    const v2: point = (-pp - centerp) / r;

                    const D = struct {
                        pub fn vector_angle(u: point, v: point) f32 {
                            const sign: f32 = if (0 > math.cross2(u, v)) -1 else 1;
                            var dot = math.dot3(u, v);
                            dot = std.math.clamp(dot, -1, 1);

                            return sign * std.math.acos(dot);
                        }
                        pub fn map_to_ellipse(_in: point, _r: point, _cos: f32, _sin: f32, _center: point) point {
                            var in = _in;
                            in *= _r;
                            return point{ _cos * in[0] - _sin * in[1], _sin * in[0] + _cos * in[1] } + _center;
                        }
                    };

                    var ang1 = D.vector_angle(.{ 1, 0 }, v1);
                    var ang2 = D.vector_angle(v1, v2);

                    if (!sweep and ang2 > 0) {
                        ang2 -= doublePI;
                    } else if (sweep and ang2 < 0) {
                        ang2 += doublePI;
                    }
                    var ratio: f32 = @abs(ang2) / (doublePI / 4.0);
                    if (@abs(1 - ratio) < std.math.floatEps(f32)) ratio = 1;
                    const nseg: usize = @max(1, @as(usize, @intFromFloat(@ceil(ratio))));

                    ang2 /= @floatFromInt(nseg);

                    for (0..nseg) |j| {
                        _ = j;
                        const a = if (ang2 == 1.57079625) 0.551915024494 else (if (ang2 == -1.57079625) -0.551915024494 else 4 / 3 * @tan(ang2 / 4));
                        const xy1 = point{ @cos(ang1), @sin(ang1) };
                        const xy2 = point{ @cos(ang1 + ang2), @sin(ang1 + ang2) };
                        line = .{
                            .start = line.start,
                            .control0 = point{ 1, -1 } * D.map_to_ellipse(.{ xy1[0] - xy1[1] * a, xy1[1] + xy1[0] * a }, r, cos, sin, center),
                            .control1 = point{ 1, -1 } * D.map_to_ellipse(.{ xy2[0] + xy2[1] * a, xy2[1] - xy2[0] * a }, r, cos, sin, center),
                            .end = point{ 1, -1 } * D.map_to_ellipse(.{ xy2[0], xy2[1] }, r, cos, sin, center),
                        };
                        try lines.append(line);
                        npoly += 1;
                        line.start = line.end;

                        ang1 += ang2;
                    }

                    cur = line.end;
                    continue;
                }
            },
            else => {
                //std.debug.print("\n{d}\n{s}\n{s}\n", .{ c, path.d.?, path.d.?[i..] });
                return SVG_ERROR.INVALID_NODE;
            },
        }
        if (start) {
            try lines.append(line);
            line.start = line.end;
            npoly += 1;
        }
    }
    if (lines.items.len == 0) return SVG_ERROR.INVALID_NODE;
    node.lines = lines.items;
    if (npoly > 0) {
        try n_polygons.append(npoly);
    }
    node.n_polygons = n_polygons.items;
    try nodes.*.append(node);
}

pub fn calculate_shapes(self: *Self, _allocator: std.mem.Allocator) !std.meta.Tuple(&.{ shapes, std.heap.ArenaAllocator }) {
    if (self.*.arena_allocator == null) {
        return SVG_ERROR.NOT_INITIALIZED;
    }
    var shps = shapes{
        .nodes = undefined,
    };
    var arena = std.heap.ArenaAllocator.init(_allocator);
    var nodes = ArrayList(shapes.shape_node).init(arena.allocator());
    errdefer arena.deinit();

    for (self.*.shape_ptrs) |shape_ptr| {
        switch (shape_ptr) {
            .path => |path| {
                try _parse_path(&nodes, path.*, &arena);
            },
            else => {},
        }
    }

    shps.nodes = nodes.items;
    return .{ shps, arena };
}

test "parse" {
    // const svg = try init_parse(std.testing.allocator, @embedFile("test.svg"));
    // defer svg.deinit();
}
