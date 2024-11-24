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

        const DATA = struct {
            asset: ASSET,
            scene: u32,
            scenes: []SCENES,
            nodes: []NODE,
            meshes: []MESHS,
            accessors: []ACCESSORS,
            buffer_views: []BUFFERVIEWS,
            buffers: []BUFFERS,
            //pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };

        pub const NODE = struct {
            rotation: ?math.vector_(float_T) = null,
            translation: ?math.point3d_(float_T) = null,
            scale: ?math.point3d_(float_T) = null,
            matrix: ?math.matrix_(float_T) = null,
            name: []const u8,
            mesh: ?u32 = null,
            children: ?[]u32 = null,
            pub fn bit_check(bits: anytype) bool { //이름은 중복되지 않게 아무거나 형식으로 감지한다.
                return (bits.name and ((bits.rotation and bits.translation and bits.scale) or bits.matrix));
            }
        };

        pub const SCENES = struct {
            name: []const u8,
            nodes: []u32,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };

        pub const ASSET = struct {
            generator: []const u8,
            version: []const u8,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };

        pub const BUFFERS = struct {
            byteLength: usize,
            uri: []const u8,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };

        pub const BUFFERVIEWS = struct {
            buffer: u32,
            byteLength: usize,
            byteOffset: usize,
            target: u32,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };
        pub const ACCESSORS = struct {
            componentType: u32,
            type: []const u8,
            count: usize,
            bufferView: usize,
            byteOffset: usize,
            min: ?math.point3d_(float_T) = null,
            max: ?math.point3d_(float_T) = null,
            pub fn bit_check(bits: anytype) bool {
                return (bits.componentType and bits.type and bits.count and bits.bufferView and bits.byteOffset);
            }
        };
        pub const MESHS = struct {
            name: []const u8,
            primitives: []PRIMITIVES,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };
        pub const PRIMITIVES = struct {
            material: u32,
            mode: u32,
            attributes: ATTRIBUTES,
            indices: u32,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };
        pub const ATTRIBUTES = struct {
            NORMAL: u32,
            POSITION: u32,
            TEXCOORD_0: u32,
            pub const bit_check: fn (anytype) bool = json.all_bits_true;
        };

        arena_allocator: ?std.heap.ArenaAllocator = null,
        error_diagnostics: std.json.Diagnostics = undefined,
        __cursor_pointer: usize = 0,
        data: DATA = undefined,

        pub fn parse(self: *Self, allocator: std.mem.Allocator, data: []const u8) !void {
            if (self.*.arena_allocator != null) deinit(self);
            self.*.arena_allocator = std.heap.ArenaAllocator.init(allocator);
            var scanner = std.json.Scanner.initCompleteInput(allocator, data);
            self.*.error_diagnostics = .{};
            scanner.enableDiagnostics(&self.*.error_diagnostics);

            errdefer {
                self.*.arena_allocator.?.deinit();
                self.*.arena_allocator = null;
            }

            defer {
                self.*.__cursor_pointer = scanner.cursor;
                self.*.error_diagnostics.cursor_pointer = &self.*.__cursor_pointer;
                scanner.deinit();
            }

            self.*.data = try json.parse_object(DATA, self.*.arena_allocator.?.allocator(), &scanner);
        }

        pub fn deinit(self: *Self) void {
            if (self.*.arena_allocator == null) return;
            self.*.arena_allocator.?.deinit();
            self.*.arena_allocator = null;
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
        \\   "meshes": [
        \\        {
        \\            "name": "Building2",
        \\            "primitives": [
        \\                {
        \\                    "material": 0,
        \\                    "mode": 4,
        \\                    "attributes": {
        \\                        "NORMAL": 2,
        \\                        "POSITION": 1,
        \\                        "TEXCOORD_0": 3
        \\                    },
        \\                    "indices": 0
        \\                }
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

    self.parse(std.testing.allocator, test_gltf) catch |e| {
        std.debug.print("line: {}\n", .{self.error_diagnostics.getLine()});
        std.debug.print("column: {}\n", .{self.error_diagnostics.getColumn()});
        return e;
    };
    defer self.deinit();

    try std.testing.expectEqualSlices(u8, "test", self.data.asset.generator);
    try std.testing.expectEqualSlices(u8, "2.0", self.data.asset.version);

    try std.testing.expectEqualSlices(u8, "Root Scene", self.data.scenes[0].name);
    try std.testing.expectEqualSlices(u32, &[_]u32{0}, self.data.scenes[0].nodes);

    try std.testing.expectEqualSlices(u8, "RootNode", self.data.nodes[0].name);
    try std.testing.expectEqualSlices(u32, &[_]u32{1}, self.data.nodes[0].children.?);
    try std.testing.expectEqual(@Vector(3, f32){ 0.0, 0.0, 0.0 }, self.data.nodes[0].translation.?);
    try std.testing.expectEqual(@Vector(4, f32){ 0.0, 0.0, 0.0, 1.0 }, self.data.nodes[0].rotation.?);
    try std.testing.expectEqual(@Vector(3, f32){ 1.0, 1.0, 1.0 }, self.data.nodes[0].scale.?);
    try std.testing.expectEqual(@as(u32, 0), self.data.nodes[0].mesh.?);

    try std.testing.expectEqualSlices(u8, "Building2", self.data.meshes[0].name);
    try std.testing.expectEqual(@as(u32, 0), self.data.meshes[0].primitives[0].material);
    try std.testing.expectEqual(@as(u32, 4), self.data.meshes[0].primitives[0].mode);
    try std.testing.expectEqual(@as(u32, 2), self.data.meshes[0].primitives[0].attributes.NORMAL);
    try std.testing.expectEqual(@as(u32, 1), self.data.meshes[0].primitives[0].attributes.POSITION);
    try std.testing.expectEqual(@as(u32, 3), self.data.meshes[0].primitives[0].attributes.TEXCOORD_0);
    try std.testing.expectEqual(@as(u32, 0), self.data.meshes[0].primitives[0].indices);
}
