//!Incomplete
const std = @import("std");
const json = @import("json.zig");

pub const gltf_error = error{
    invalid_gltf_object,
};

const Scanner = std.json.Scanner;
const Token = std.json.Token;
const ArrayList = std.ArrayList;
const math = @import("math.zig");

pub fn gltf_(comptime float_T: type) type {
    if (float_T != f32 and float_T != f64) @compileError("float_T must be a float type");
    return struct {
        const Self = @This();

        const OBJECTS_BITS = struct {
            none: bool = false,
            asset: bool = false,
            scene: bool = false,
            scenes: bool = false,
            nodes: bool = false,
            meshes: bool = false,
            materials: bool = false,
            textures: bool = false,
            images: bool = false,
            buffer_views: bool = false,
            buffers: bool = false,
            accessors: bool = false,
            animations: bool = false,
            skins: bool = false,
        };

        pub const NODE = struct {
            rotation: ?math.vector_(float_T) = null,
            translation: ?math.point3d_(float_T) = null,
            scale: ?math.point3d_(float_T) = null,
            matrix: ?math.matrix_(float_T) = null,
            name: []const u8,
            mesh: ?u32 = null,
            children: ?[]u32 = null,
        };

        pub const SCENES = struct {
            name: []const u8,
            nodes: []u32,
        };

        pub const ASSET = struct {
            generator: []const u8,
            version: []const u8,
        };

        pub const BUFFERS = struct {
            byteLength: usize,
            uri: []const u8,
        };

        pub const BUFFERVIEWS = struct {
            buffer: u32,
            byteLength: usize,
            byteOffset: usize,
            target: u32,
        };
        pub const ACCESSORS = struct {
            componentType: u32,
            type: []const u8,
            count: usize,
            bufferView: usize,
            byteOffset: usize,
            min: ?math.point3d_(float_T) = null,
            max: ?math.point3d_(float_T) = null,
        };

        fn node_bits_true(bits: anytype) bool {
            return (bits.name and ((bits.rotation and bits.translation and bits.scale) or bits.matrix));
        }
        fn accessor_bits_true(bits: anytype) bool {
            return (bits.componentType and bits.type and bits.count and bits.bufferView and bits.byteOffset);
        }

        arena_allocator: std.heap.ArenaAllocator = undefined,
        error_diagnostics: std.json.Diagnostics = undefined,
        __cursor_pointer: usize = 0,
        scenes: []SCENES = undefined,
        nodes: []NODE = undefined,
        scene: u32 = undefined,
        asset: ASSET = undefined,
        buffers: []BUFFERS = undefined,
        buffer_views: []BUFFERVIEWS = undefined,
        accessors: []ACCESSORS = undefined,

        pub fn parse(self: *Self, allocator: std.mem.Allocator, data: []const u8) !void {
            if (self.*.__cursor_pointer != 0) deinit(self);
            self.*.arena_allocator = std.heap.ArenaAllocator.init(allocator);
            var scanner = std.json.Scanner.initCompleteInput(allocator, data);
            self.*.error_diagnostics = .{};
            scanner.enableDiagnostics(&self.*.error_diagnostics);

            errdefer {
                self.*.arena_allocator.deinit();
                self.*.__cursor_pointer = 0;
            }

            defer {
                self.*.__cursor_pointer = scanner.cursor;
                self.*.error_diagnostics.cursor_pointer = &self.*.__cursor_pointer;
                scanner.deinit();
            }

            var objsB: OBJECTS_BITS = .{};

            while (true) {
                const token = try scanner.next();
                switch (token) {
                    .string => {
                        if (!objsB.asset and std.mem.eql(u8, token.string, "asset")) {
                            objsB.asset = true;
                            self.*.asset = try json.parse_object(ASSET, self.*.arena_allocator.allocator(), &scanner, json.all_bits_true);
                        } else if (!objsB.scene and std.mem.eql(u8, token.string, "scene")) {
                            objsB.scene = true;
                            self.*.scene = try json.get_int(u32, &scanner);
                        } else if (!objsB.scenes and std.mem.eql(u8, token.string, "scenes")) {
                            objsB.scenes = true;
                            self.*.scenes = try json.parse_array(SCENES, self.*.arena_allocator.allocator(), &scanner, json.all_bits_true);
                        } else if (!objsB.nodes and std.mem.eql(u8, token.string, "nodes")) {
                            objsB.nodes = true;
                            self.*.nodes = try json.parse_array(NODE, self.*.arena_allocator.allocator(), &scanner, node_bits_true);
                        } else if (!objsB.buffers and std.mem.eql(u8, token.string, "buffers")) {
                            objsB.buffers = true;
                            self.*.buffers = try json.parse_array(BUFFERS, self.*.arena_allocator.allocator(), &scanner, json.all_bits_true);
                        } else if (!objsB.buffer_views and std.mem.eql(u8, token.string, "bufferViews")) {
                            objsB.buffer_views = true;
                            self.*.buffer_views = try json.parse_array(BUFFERVIEWS, self.*.arena_allocator.allocator(), &scanner, json.all_bits_true);
                        } else if (!objsB.accessors and std.mem.eql(u8, token.string, "accessors")) {
                            objsB.accessors = true;
                            self.*.accessors = try json.parse_array(ACCESSORS, self.*.arena_allocator.allocator(), &scanner, accessor_bits_true);
                        }
                    },
                    .end_of_document => break,
                    .object_begin => {},
                    .object_end => {},
                    else => {},
                }
            }
        }

        pub fn deinit(self: *Self) void {
            if (self.*.__cursor_pointer == 0) return;
            self.*.arena_allocator.deinit();
        }
    };
}

pub const gltf = gltf_(f32);
pub const gltf64 = gltf_(f64);

test "gltf_parse_test" {
    var self = gltf{};

    const test_gltf =
        \\{
        \\    "asset": {
        \\        "generator": "test",
        \\        "version": "2.0"
        \\    },
        \\    "scene": 0,
        \\    "scenes": [
        \\        {
        \\            "name": "Root Scene",
        \\            "nodes": [
        \\                0
        \\            ]
        \\        }
        \\    ],
        \\    "nodes": [
        \\        {
        \\            "name": "RootNode",
        \\            "translation": [
        \\                0.0,
        \\                0.0,
        \\                0.0
        \\            ],
        \\            "rotation": [
        \\                0.0,
        \\                0.0,
        \\                0.0,
        \\                1.0
        \\            ],
        \\            "scale": [
        \\                1.0,
        \\                1.0,
        \\                1.0
        \\            ],
        \\            "mesh": 0,
        \\            "children": [
        \\                1
        \\            ]
        \\        }
        \\    ]
        \\}
    ;

    try self.parse(std.testing.allocator, test_gltf);

    try std.testing.expectEqualSlices(u8, "test", self.asset.generator);
    try std.testing.expectEqualSlices(u8, "2.0", self.asset.version);

    try std.testing.expectEqualSlices(u8, "Root Scene", self.scenes[0].name);
    try std.testing.expectEqualSlices(u32, &[_]u32{0}, self.scenes[0].nodes);

    try std.testing.expectEqualSlices(u8, "RootNode", self.nodes[0].name);
    try std.testing.expectEqualSlices(u32, &[_]u32{1}, self.nodes[0].children.?);
    try std.testing.expectEqual(@Vector(3, f32){ 0.0, 0.0, 0.0 }, self.nodes[0].translation.?);
    try std.testing.expectEqual(@Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 }, self.nodes[0].rotation.?);
    try std.testing.expectEqual(@Vector(3, f32){ 1.0, 1.0, 1.0 }, self.nodes[0].scale.?);
    try std.testing.expectEqual(@as(u32, 0), self.nodes[0].mesh.?);

    self.deinit();
}
