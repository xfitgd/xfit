const std = @import("std");
const unicode = std.unicode;
const system = @import("system.zig");
const __system = @import("__system.zig");
pub const freetype = @import("include/freetype.zig");
const geometry = @import("geometry.zig");
const graphics = @import("graphics.zig");
const math = @import("math.zig");
const point = math.point;
const vector = math.vector;
const xfit = @import("xfit.zig");

const AutoHashMap = std.AutoHashMap;

const Self = @This();

var library: freetype.FT_Library = null;

pub const font_error = error{
    undefined_char_code,
    load_error,
} || std.mem.Allocator.Error;

pub const char_data = struct {
    raw_p: ?geometry.raw_shapes = null,
    advance: point,
    allocator: std.mem.Allocator,
};

__char_array: AutoHashMap(u21, char_data),
__face: freetype.FT_Face = null,
scale: f32 = scale_default,
mutex: std.Thread.Mutex = .{},
const scale_default: f32 = 256;

fn handle_error(code: freetype.FT_Error) void {
    if (code != freetype.FT_Err_Ok) {
        xfit.herr2("freetype err Code : {d}\n", .{code});
    }
}

fn start() void {
    handle_error(freetype.FT_Init_FreeType(&library));
}

pub fn __destroy() void {
    if (library == null) return;
    _ = freetype.FT_Done_FreeType(library);
    library = null;
}

pub fn init(_font_data: []const u8, _face_index: u32) !Self {
    if (library == null) {
        start();
    }
    var font: Self = .{
        .__char_array = AutoHashMap(u21, char_data).init(__system.allocator),
    };
    const err = freetype.FT_New_Memory_Face(library, _font_data.ptr, @intCast(_font_data.len), @intCast(_face_index), &font.__face);
    if (err != freetype.FT_Err_Ok) {
        return font_error.load_error;
    }
    _ = freetype.FT_Set_Char_Size(font.__face, 0, 16 * 256 * 64, 0, 0);
    return font;
}

pub fn deinit(self: *Self) void {
    self.*.mutex.lock();
    defer self.*.mutex.unlock();
    var it = self.*.__char_array.valueIterator();
    while (it.next()) |v| {
        if (v.*.raw_p != null) {
            v.*.raw_p.?.deinit(__system.allocator);
        }
    }
    self.*.__char_array.deinit();
}

pub fn clear_char_array(self: *Self) void {
    self.*.mutex.lock();
    defer self.*.mutex.unlock();
    const allocator = self.*.__char_array.allocator;
    deinit(self);
    self.*.__char_array = AutoHashMap(u21, char_data).init(allocator);
}

fn get_char_idx(self: *Self, _char: u21) font_error!u32 {
    const idx = freetype.FT_Get_Char_Index(self.*.__face, @intCast(_char));
    if (idx != 0) return idx;

    xfit.print_debug("undefined character code (charcode) : {d}, (char) : {u}", .{ @as(u32, @intCast(_char)), _char });
    return font_error.undefined_char_code;
}

fn load_glyph(self: *Self, _char: u21) u21 {
    const idx = get_char_idx(self, _char) catch {
        const idx2 = get_char_idx(self, '□') catch unreachable;
        handle_error(freetype.FT_Load_Glyph(self.*.__face, idx2, freetype.FT_LOAD_DEFAULT | freetype.FT_LOAD_NO_BITMAP));
        return '□';
    };
    handle_error(freetype.FT_Load_Glyph(self.*.__face, idx, freetype.FT_LOAD_DEFAULT | freetype.FT_LOAD_NO_BITMAP));
    return _char;
}

pub const render_option = struct {
    scale: point = .{ 1, 1 },
    _offset: point = .{ 0, 0 },
    pivot: point = .{ 0, 0 },
    area: ?point = null,
    color: vector = .{ 0, 0, 0, 1 },
    flag: graphics.write_flag = .gpu,
    color_flag: graphics.write_flag = .cpu,
};
pub const range = struct {
    font: *Self,
    color: vector,
    len: usize,
    scale: point,
};
pub const render_option2 = struct {
    option: render_option,
    ranges: []const range,
};

pub fn set_font_size(self: *Self, pt: f32) void {
    self.*.scale = scale_default / pt;
}

fn _render_string2_raw(
    _str: []const u8,
    _render_option: render_option2,
    allocator: std.mem.Allocator,
    vertlist: *std.ArrayList([]graphics.shape_vertex_2d),
    indlist: *std.ArrayList([]u32),
    colorlist: *std.ArrayList(vector),
) !void {
    var i: usize = 0;
    var idx: usize = 0;
    var option = _render_option.option;
    for (_render_option.ranges) |v| {
        option.scale = _render_option.option.scale * v.scale;
        var same: bool = false;
        for (colorlist.items, 0..) |e, ii| {
            if (math.compare(e, v.color)) {
                same = true;
                idx = ii;
                break;
            }
        }
        if (!same) {
            try vertlist.*.append(try allocator.alloc(graphics.shape_vertex_2d, 0));
            try indlist.*.append(try allocator.alloc(u32, 0));
            try colorlist.*.append(v.color);
            idx = colorlist.*.items.len - 1;
        }

        if (v.len == 0 or i + v.len >= _str.len) {
            _ = try v.font.*._render_string(_str[i..], option, &vertlist.*.items[idx], &indlist.*.items[idx], allocator);
            break;
        } else {
            option._offset = try v.font.*._render_string(_str[i..(i + v.len)], option, &vertlist.*.items[idx], &indlist.*.items[idx], allocator);
            i += v.len;
        }
    }
}

pub fn render_string2(_str: []const u8, _render_option: render_option2, allocator: std.mem.Allocator) !*graphics.shape_source {
    var vertlist = std.ArrayList([]graphics.shape_vertex_2d).init(allocator);
    var indlist = std.ArrayList([]u32).init(allocator);
    var colorlist = std.ArrayList(vector).init(allocator);
    defer {
        for (vertlist.items) |v| {
            allocator.free(v);
        }
        for (indlist.items) |i| {
            allocator.free(i);
        }
        vertlist.deinit();
        indlist.deinit();
        colorlist.deinit();
    }

    try _render_string2_raw(_str, _render_option, allocator, &vertlist, &indlist, &colorlist);
    var raw: geometry.raw_shapes = undefined;
    raw.vertices = vertlist.items;
    raw.indices = indlist.items;
    raw.colors = colorlist.items;
    const src = try allocator.create(graphics.shape_source);
    src.* = graphics.shape_source.init();
    try src.*.build(allocator, raw, _render_option.option.flag, _render_option.option.color_flag);
    return src;
}
pub fn render_string2_raw(_str: []const u8, _render_option: render_option2, allocator: std.mem.Allocator) !geometry.raw_shapes {
    var vertlist = std.ArrayList([]graphics.shape_vertex_2d).init(allocator);
    var indlist = std.ArrayList([]u32).init(allocator);
    var colorlist = std.ArrayList(vector).init(allocator);
    defer {
        vertlist.deinit();
        indlist.deinit();
        colorlist.deinit();
    }

    try _render_string2_raw(_str, _render_option, allocator, &vertlist, &indlist, &colorlist);
    var raw: geometry.raw_shapes = undefined;
    raw.vertices = try allocator.dupe([]graphics.shape_vertex_2d, vertlist.items);
    raw.indices = try allocator.dupe([]u32, indlist.items);
    raw.colors = try allocator.dupe(vector, colorlist.items);
    return raw;
}

fn _render_string(self: *Self, _str: []const u8, _render_option: render_option, _vertex_array: *[]graphics.shape_vertex_2d, _index_array: *[]u32, allocator: std.mem.Allocator) !point {
    var maxP: point = .{ std.math.floatMin(f32), std.math.floatMin(f32) };
    var minP: point = .{ std.math.floatMax(f32), std.math.floatMax(f32) };

    //https://gencmurat.com/en/posts/zig-strings/
    var utf8 = (try std.unicode.Utf8View.init(_str)).iterator();
    var offset: point = _render_option._offset;
    while (utf8.nextCodepoint()) |codepoint| {
        if (_render_option.area != null and offset[1] <= -_render_option.area.?[1]) break;
        if (codepoint == '\n') {
            offset[1] -= @as(f32, @floatFromInt(self.*.__face.*.size.*.metrics.height)) / (64.0 * self.*.scale);
            offset[0] = 0;
            continue;
        }
        minP = @min(minP, offset);
        try _render_char(self, codepoint, _vertex_array, _index_array, &offset, _render_option.area, _render_option.scale, allocator);
        maxP = @max(maxP, point{ offset[0], offset[1] + @as(f32, @floatFromInt(self.*.__face.*.size.*.metrics.height)) / (64.0 * self.*.scale) });
    }
    var i: usize = 0;
    const size: point = (if (_render_option.area != null) _render_option.area.? else (maxP - minP)) * point{ 1, 1 };
    while (i < _vertex_array.*.len) : (i += 1) {
        _vertex_array.*[i].pos -= _render_option.pivot * size * _render_option.scale;
    }
    return offset * _render_option.scale;
}

pub fn render_string(self: *Self, _str: []const u8, _render_option: render_option, allocator: std.mem.Allocator) !*graphics.shape_source {
    var vertex_array: []graphics.shape_vertex_2d = try allocator.alloc(graphics.shape_vertex_2d, 0);
    var index_array: []u32 = try allocator.alloc(u32, 0);
    defer {
        allocator.free(vertex_array);
        allocator.free(index_array);
    }
    _ = try _render_string(self, _str, _render_option, &vertex_array, &index_array, allocator);
    const shape_src = try allocator.create(graphics.shape_source);
    errdefer allocator.destroy(shape_src);
    shape_src.* = graphics.shape_source.init();
    var raw: geometry.raw_shapes = undefined;
    raw.vertices = @constCast(&[_][]graphics.shape_vertex_2d{vertex_array});
    raw.indices = @constCast(&[_][]u32{index_array});
    raw.colors = @constCast(&[_]vector{_render_option.color});
    try shape_src.*.build(allocator, raw, _render_option.flag, _render_option.color_flag);
    return shape_src;
}

pub fn render_string_raw(self: *Self, _str: []const u8, _render_option: render_option, allocator: std.mem.Allocator) !geometry.raw_shapes {
    var vertices: ?[][]graphics.shape_vertex_2d = null;
    var indices: ?[][]u32 = null;
    var colors: ?[]vector = null;
    errdefer {
        if (vertices != null) allocator.free(vertices.?);
        if (indices != null) allocator.free(indices.?);
        if (colors != null) allocator.free(colors.?);
    }

    var vertex_array: []graphics.shape_vertex_2d = try allocator.alloc(graphics.shape_vertex_2d, 0);
    var index_array: []u32 = try allocator.alloc(u32, 0);
    errdefer {
        allocator.free(vertex_array);
        allocator.free(index_array);
    }
    _ = try _render_string(self, _str, _render_option, &vertex_array, &index_array, allocator);

    vertices = try allocator.dupe([]graphics.shape_vertex_2d, &[_][]graphics.shape_vertex_2d{vertex_array});
    indices = try allocator.dupe([]u32, &[_][]u32{index_array});
    colors = try allocator.dupe(vector, &[_]vector{_render_option.color});
    return .{
        .vertices = vertices.?,
        .indices = indices.?,
        .colors = colors.?,
    };
}

fn _render_char(self: *Self, char: u21, _vertex_array: *[]graphics.shape_vertex_2d, _index_array: *[]u32, offset: *point, area: ?math.point, scale: point, allocator: std.mem.Allocator) !void {
    self.*.mutex.lock(); //access __char_array and glyph

    var char_d: ?*char_data = self.*.__char_array.getPtr(char);

    if (char_d != null) {} else blk: {
        const res = load_glyph(self, char);
        if (res != char) {
            if (self.*.__char_array.getPtr(res) != null) {
                break :blk;
            }
        }

        var char_d2: char_data = undefined;

        var poly: geometry.shapes = .{ .nodes = allocator.alloc(geometry.shapes.shape_node, 1) catch |e| {
            self.*.mutex.unlock();
            return e;
        } };
        defer {
            for (poly.nodes) |v| {
                allocator.free(v.lines);
                allocator.free(v.n_polygons);
            }
            allocator.free(poly.nodes);
        }
        poly.nodes[0].lines = allocator.alloc(geometry.line, self.*.__face.*.glyph.*.outline.n_points) catch |e| {
            self.*.mutex.unlock();
            return e;
        };
        poly.nodes[0].n_polygons = allocator.alloc(u32, self.*.__face.*.glyph.*.outline.n_points) catch |e| {
            self.*.mutex.unlock();
            return e;
        };

        const funcs: freetype.FT_Outline_Funcs = .{
            .line_to = line_to,
            .conic_to = conic_to,
            .move_to = move_to,
            .cubic_to = cubic_to,
        };

        var data: font_user_data = .{
            .pen = .{ 0, 0 },
            .polygon = &poly,
            .idx2 = 0,
            .npoly = 0,
            .npoly_len = 0,
            .scale = self.*.scale,
        };

        if (freetype.FT_Outline_Get_Orientation(&self.*.__face.*.glyph.*.outline) == freetype.FT_ORIENTATION_FILL_RIGHT) {
            freetype.FT_Outline_Reverse(&self.*.__face.*.glyph.*.outline);
        }

        if (freetype.FT_Outline_Decompose(&self.*.__face.*.glyph.*.outline, &funcs, &data) != freetype.FT_Err_Ok) {
            self.*.mutex.unlock();
            return font_error.OutOfMemory;
        }
        self.*.mutex.unlock();
        if (data.idx2 == 0) {
            char_d2.raw_p = null;
        } else {
            if (data.npoly > 0) {
                data.polygon.*.nodes[0].n_polygons[data.npoly_len] = data.npoly;
                data.npoly_len += 1;
            }
            poly.nodes[0].lines = try allocator.realloc(poly.nodes[0].lines, data.idx2);
            poly.nodes[0].n_polygons = try allocator.realloc(poly.nodes[0].n_polygons, data.npoly_len);
            poly.nodes[0].color = .{ 0, 0, 0, 1 };
            poly.nodes[0].stroke_color = null;
            poly.nodes[0].thickness = 0;

            char_d2.raw_p = try poly.compute_polygon(__system.allocator); //높은 부하 작업 High load operations
        }
        self.*.mutex.lock();
        char_d2.advance[0] = @as(f32, @floatFromInt(self.*.__face.*.glyph.*.advance.x)) / (64.0 * self.*.scale);
        char_d2.advance[1] = @as(f32, @floatFromInt(self.*.__face.*.glyph.*.advance.y)) / (64.0 * self.*.scale);

        self.*.__char_array.put(res, char_d2) catch |e| {
            self.*.mutex.unlock();
            char_d2.raw_p.?.deinit(__system.allocator);
            return e;
        };
        char_d = &char_d2;
    }
    defer self.*.mutex.unlock();

    if (area != null and offset.*[0] + char_d.?.*.advance[0] >= area.?[0]) {
        offset.*[1] -= @as(f32, @floatFromInt(self.*.__face.*.size.*.metrics.height)) / (64.0 * self.*.scale);
        offset.*[0] = 0;
        if (offset.*[1] <= -area.?[1]) return;
    }
    if (char_d.?.raw_p == null) {} else {
        const len = _vertex_array.len;
        _vertex_array.* = try allocator.realloc(_vertex_array.*, len + char_d.?.raw_p.?.vertices[0].len);
        @memcpy(_vertex_array.*[len..], char_d.?.raw_p.?.vertices[0]);
        var i: usize = len;
        while (i < _vertex_array.*.len) : (i += 1) {
            _vertex_array.*[i].pos += offset.*;
            _vertex_array.*[i].pos *= scale;
        }
        const ilen = _index_array.len;
        _index_array.* = try allocator.realloc(_index_array.*, ilen + char_d.?.raw_p.?.indices[0].len);
        @memcpy(_index_array.*[ilen..], char_d.?.raw_p.?.indices[0]);
        i = ilen;
        while (i < _index_array.*.len) : (i += 1) {
            _index_array.*[i] += @intCast(len);
        }
    }
    offset.*[0] += char_d.?.*.advance[0];
    //offset.*[1] -= char_d.?.*.advance[1];

}

const font_user_data = struct {
    pen: point,
    polygon: *geometry.shapes,
    idx2: u32,
    npoly_len: u32,
    npoly: u32,
    scale: f32,
};

fn line_to(vec: [*c]const freetype.FT_Vector, user: ?*anyopaque) callconv(.C) c_int {
    const data: *font_user_data = @alignCast(@ptrCast(user.?));
    const end = point{
        @as(f32, @floatFromInt(vec.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec.*.y)) / (64.0 * data.*.scale),
    };

    data.*.polygon.*.nodes[0].lines[data.*.idx2] = geometry.line.line_init(
        data.*.pen,
        end,
    );
    data.*.pen = end;

    data.*.idx2 += 1;
    data.*.npoly += 1;
    return 0;
}
fn conic_to(vec: [*c]const freetype.FT_Vector, vec2: [*c]const freetype.FT_Vector, user: ?*anyopaque) callconv(.C) c_int {
    const data: *font_user_data = @alignCast(@ptrCast(user.?));
    const control0 = point{
        @as(f32, @floatFromInt(vec.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec.*.y)) / (64.0 * data.*.scale),
    };
    const end = point{
        @as(f32, @floatFromInt(vec2.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec2.*.y)) / (64.0 * data.*.scale),
    };

    data.*.polygon.*.nodes[0].lines[data.*.idx2] = geometry.line.quadratic_init(
        data.*.pen,
        control0,
        end,
    );
    data.*.pen = end;

    data.*.idx2 += 1;
    data.*.npoly += 1;
    return 0;
}
fn cubic_to(vec: [*c]const freetype.FT_Vector, vec2: [*c]const freetype.FT_Vector, vec3: [*c]const freetype.FT_Vector, user: ?*anyopaque) callconv(.C) c_int {
    const data: *font_user_data = @alignCast(@ptrCast(user.?));
    const control0 = point{
        @as(f32, @floatFromInt(vec.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec.*.y)) / (64.0 * data.*.scale),
    };
    const control1 = point{
        @as(f32, @floatFromInt(vec2.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec2.*.y)) / (64.0 * data.*.scale),
    };
    const end = point{
        @as(f32, @floatFromInt(vec3.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec3.*.y)) / (64.0 * data.*.scale),
    };

    data.*.polygon.*.nodes[0].lines[data.*.idx2] = .{
        .start = data.*.pen,
        .control0 = control0,
        .control1 = control1,
        .end = end,
    };
    data.*.pen = end;

    data.*.idx2 += 1;
    data.*.npoly += 1;
    return 0;
}
fn move_to(vec: [*c]const freetype.FT_Vector, user: ?*anyopaque) callconv(.C) c_int {
    const data: *font_user_data = @alignCast(@ptrCast(user.?));

    data.*.pen = point{
        @as(f32, @floatFromInt(vec.*.x)) / (64.0 * data.*.scale),
        @as(f32, @floatFromInt(vec.*.y)) / (64.0 * data.*.scale),
    };
    if (data.*.npoly > 0) {
        data.*.polygon.*.nodes[0].n_polygons[data.*.npoly_len] = data.*.npoly;
        data.*.npoly_len += 1;
        data.*.npoly = 0;
    }
    return 0;
}
