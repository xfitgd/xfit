//!Incomplete
const std = @import("std");
const generic_parse_json = @import("generic_parse_json.zig");

pub const gltf_error = error{
    invalid_gltf_object,
};

const Scanner = std.json.Scanner;
const Token = std.json.Token;
const ArrayList = std.ArrayList;
const math = @import("math.zig");

fn node_bits_true(bits: anytype) bool {
    const node_bits = bits;
    if (!node_bits.name) return false;
    if (!((node_bits.rotation and node_bits.translation and node_bits.scale) or node_bits.matrix)) return false;
    return true;
}

pub fn gltf_(comptime float_T: type) type {
    if (float_T != f32 and float_T != f64) @compileError("float_T must be a float type");
    return struct {
        const Self = @This();

        const objs_bit = struct {
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

        const NODE = struct {
            rotation: ?math.vector_(float_T) = null,
            translation: ?math.point3d_(float_T) = null,
            scale: ?math.point3d_(float_T) = null,
            matrix: ?math.matrix_(float_T) = null,
            name: []u8,
            mesh: ?u32 = null,
            children: ?[]u32 = null,
        };

        const SCENES = struct {
            name: []u8,
            nodes: []u32,
        };

        arena_allocator: std.heap.ArenaAllocator = undefined,
        error_diagnostics: std.json.Diagnostics = undefined,
        __cursor_pointer: usize = 0,
        scenes: []SCENES = undefined,
        nodes: []NODE = undefined,
        scene: u32 = undefined,

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

            var objsB: objs_bit = .{};

            while (true) {
                const token = try scanner.next();
                switch (token) {
                    .string => {
                        if (!objsB.asset and std.mem.eql(u8, token.string, "asset")) {
                            objsB.asset = true;
                        } else if (!objsB.scene and std.mem.eql(u8, token.string, "scene")) {
                            objsB.scene = true;
                            self.*.scene = try generic_parse_json.get_uint(&scanner);
                        } else if (!objsB.scenes and std.mem.eql(u8, token.string, "scenes")) {
                            objsB.scenes = true;

                            self.*.scenes = try generic_parse_json.parse_array(SCENES, self.*.arena_allocator.allocator(), &scanner, generic_parse_json.all_bits_true);
                        } else if (!objsB.nodes and std.mem.eql(u8, token.string, "nodes")) {
                            objsB.nodes = true;

                            self.*.nodes = try generic_parse_json.parse_array(NODE, self.*.arena_allocator.allocator(), &scanner, node_bits_true);
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
