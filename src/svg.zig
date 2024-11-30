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
    width: ?u32 = null,
    height: ?u32 = null,
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
    points: ?[]const u8 = null,
    _0: FILL_AND_STROKE = .{},
};
pub const POLYGON = struct {
    points: ?[]const u8 = null,
    _0: FILL_AND_STROKE = .{},
};

pub const SVG_ERROR = error{
    NOT_INITIALIZED,
};

const svg_tags = [_][:0]const u8{ "svg", "path", "rect", "circle", "ellipse", "line", "polyline", "polygon" };
const svg_tags2 = [_]type{ SVG, PATH, RECT, CIRCLE, ELLIPSE, LINE, POLYLINE, POLYGON };

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

fn _parse_xml_element(out: anytype, local: []const u8, value: []const u8) !void {
    inline for (std.meta.fields(@TypeOf(out.*))) |field| {
        if (@typeInfo(field.type) == .@"struct") {
            try _parse_xml_element(&@field(out.*, field.name), local, value);
        } else {
            if (@field(out.*, field.name) == null and std.mem.eql(u8, local, field.name)) {
                @field(out.*, field.name) = try meta.parse_value(@typeInfo(field.type).optional.child, value);
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

pub fn parse(allocator: std.mem.Allocator, _svg_data: []const u8) !Self {
    var self: Self = undefined;
    self.arena_allocator = std.heap.ArenaAllocator.init(allocator);
    errdefer self.deinit();

    var fixed_buffer_stream = std.io.fixedBufferStream(_svg_data);
    var doc = xml.streamingDocument(self.arena_allocator.?.allocator(), fixed_buffer_stream.reader());
    defer doc.deinit();

    var reader = doc.reader(self.arena_allocator.?.allocator(), .{});
    defer reader.deinit();

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
                                try _parse_xml_element(&list.*.items[list.*.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                            }
                        } else {
                            const list = &@field(svg_tags_list, tag);
                            if (list.* != null) break;
                            list.*.? = .{};
                            for (0..reader.reader.attributeCount()) |i| {
                                try _parse_xml_element(&list.*.?, reader.attributeNameNs(i).local, try reader.attributeValue(i));
                            }
                        }
                        break;
                    }
                }
            },
            .eof => break,
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
    return self; //?arraylists will not be deallocated when you leave this function.
}

pub fn calculate_polygon(self: Self) !shapes {
    if (self.arena_allocator == null) {
        return SVG_ERROR.NOT_INITIALIZED;
    }
    // var shps = shapes{
    //     .lines = undefined,
    //     .colors = undefined,
    //     .tickness = undefined,
    // };
    //_ = shps;
    return undefined;
}

test "parse" {
    // const svg = try parse(std.testing.allocator, @embedFile("test.svg"));
    // defer svg.deinit();
}
