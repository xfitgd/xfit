const std = @import("std");
const xml = @import("xfit.zig").xml;
const meta = @import("meta.zig");
const math = @import("math.zig");
const geometry = @import("geometry.zig");

const Self = @This();
const ArrayList = std.ArrayList;

const point = math.point;
const vector = math.vector;

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
    points: ?[]point = null,
    _0: FILL_AND_STROKE = .{},
};
pub const POLYGON = struct {
    points: ?[]point = null,
    _0: FILL_AND_STROKE = .{},
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

fn _parse_xml_element(out: anytype, local: []const u8, value: []const u8) !void {
    inline for (std.meta.fields(out.*)) |field| {
        if (@typeInfo(field.type) != .@"struct") {
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

    var doc = xml.streamingDocument(self.arena_allocator.?.allocator(), std.io.fixedBufferStream(_svg_data).reader());
    defer doc.deinit();

    var reader = doc.reader(self.arena_allocator.?.allocator(), .{});
    defer reader.deinit();

    var path = ArrayList(PATH).init(self.arena_allocator.?.allocator());
    var circle = ArrayList(CIRCLE).init(self.arena_allocator.?.allocator());
    var rect = ArrayList(RECT).init(self.arena_allocator.?.allocator());
    var ellipse = ArrayList(ELLIPSE).init(self.arena_allocator.?.allocator());
    var polyline = ArrayList(POLYLINE).init(self.arena_allocator.?.allocator());
    var polygon = ArrayList(POLYGON).init(self.arena_allocator.?.allocator());
    var line = ArrayList(LINE).init(self.arena_allocator.?.allocator());

    while (true) {
        const node = reader.read() catch |err| {
            self.xml_error_code = reader.reader.error_code;
            return err;
        };
        switch (node) {
            .element_start => {
                const element_name = reader.elementNameNs();

                if (std.mem.eql(u8, element_name.local, "svg")) {
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&self.svg, reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "path")) {
                    try path.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&path.items[path.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "rect")) {
                    try rect.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&rect.items[rect.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "circle")) {
                    try circle.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&circle.items[circle.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "ellipse")) {
                    try ellipse.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&ellipse.items[ellipse.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "line")) {
                    try line.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&line.items[line.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "polyline")) {
                    try polyline.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&polyline.items[polyline.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                } else if (std.mem.eql(u8, element_name.local, "polygon")) {
                    try polygon.append(.{});
                    for (0..reader.reader.attributeCount()) |i| {
                        try _parse_xml_element(&polygon.items[polygon.items.len - 1], reader.attributeNameNs(i).local, try reader.attributeValue(i));
                    }
                }
            },
            .eof => break,
            else => {},
        }
    }
    self.path = path.items;
    self.circle = circle.items;
    self.rect = rect.items;
    self.ellipse = ellipse.items;
    self.polyline = polyline.items;
    self.polygon = polygon.items;
    self.line = line.items;
    return self; //?arraylists will not be deallocated when you leave this function.
}

test "parse" {
    const svg = try parse(std.testing.allocator, @embedFile("test.svg"));
    defer svg.deinit();
}
