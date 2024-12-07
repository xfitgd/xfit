const std = @import("std");
const graphics = @import("graphics.zig");
const system = @import("system.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");

const iobject = graphics.iobject;
const transform = graphics.transform;
const shape_source = graphics.shape_source;
const shape_node = geometry.shapes.shape_node;
const shapes = geometry.shapes;
const shape_ = graphics.shape_;
const font = @import("font.zig");

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;

const math = @import("math.zig");
const geometry = @import("geometry.zig");
const collision = @import("collision.zig");
const iarea = collision.iarea;
const iarea_type = collision.iarea_type;
const mem = @import("mem.zig");
const point = math.point;
const vector = math.vector;
const matrix = math.matrix;
const matrix_error = math.matrix_error;
const center_pt_pos = graphics.center_pt_pos;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

const descriptor_pool_size = __vulkan_allocator.descriptor_pool_size;
const descriptor_set = __vulkan_allocator.descriptor_set;
const descriptor_pool_memory = __vulkan_allocator.descriptor_pool_memory;
const res_union = __vulkan_allocator.res_union;

pub const button_state = enum(u32) {
    UP,
    OVER,
    DOWN,
    UNKNOWN,
};

pub const button = button_(true);
pub const pixel_button = button_(false);

pub const button_sets = struct {
    up_color: ?vector = null,
    over_color: ?vector = null,
    down_color: ?vector = null,
    __updated_state: std.atomic.Value(button_state) = std.atomic.Value(button_state).init(.UNKNOWN),
};

pub fn button_(_msaa: bool) type {
    return struct {
        const Self = @This();

        shape: shape_(_msaa),
        area: iarea,
        state: button_state = .UP,
        on_over: ?*const fn (user_data: *anyopaque, _mouse_pos: point) void = null,
        on_down: ?*const fn (user_data: *anyopaque, _mouse_pos: point) void = null,
        on_up: ?*const fn (user_data: *anyopaque, _mouse_pos: ?point) void = null,
        user_data: *anyopaque = undefined,
        _touch_idx: ?u32 = null,
        sets: []button_sets,

        pub fn init(_src: *shape_source, _area: iarea, _sets: []button_sets) !Self {
            return .{
                .area = _area,
                .shape = shape_(_msaa).init(_src),
                .sets = _sets,
            };
        }

        fn update_color(self: *Self) void {
            for (self.*.sets) |*s| {
                if (s.*.up_color == null) continue;
                if (self.*.state == .UP and s.*.__updated_state.cmpxchgStrong(.UNKNOWN, .UP, .monotonic, .monotonic) == null) continue;
                if (self.*.state == .OVER) {
                    if (s.*.over_color == null) {
                        if (s.*.__updated_state.cmpxchgStrong(.UNKNOWN, .UP, .monotonic, .monotonic) == null) continue;
                    } else {
                        if (s.*.__updated_state.cmpxchgStrong(.UNKNOWN, .OVER, .monotonic, .monotonic) == null) continue;
                    }
                }
                if (self.*.state == .DOWN and s.*.down_color != null) {
                    _ = s.*.__updated_state.cmpxchgStrong(.UNKNOWN, .DOWN, .monotonic, .monotonic);
                }
            }
        }
        pub fn on_mouse_move(self: *Self, _mouse_pos: point) void {
            if (self.area.rect.is_point_in(_mouse_pos)) {
                if (self.state == .UP) {
                    self.state = .OVER;
                    self.update_color();
                    if (self.on_over != null) self.on_over.?(self.*.user_data, _mouse_pos);
                }
            } else {
                if (self.state != .UP) {
                    self.state = .UP;
                    self.update_color();
                }
            }
        }
        pub fn on_mouse_down(self: *Self, _mouse_pos: point) void {
            if (self.state == .UP) {
                if (self.area.rect.is_point_in(_mouse_pos)) {
                    self.state = .DOWN;
                    self.update_color();
                    if (self.on_down != null) self.on_down.?(self.*.user_data, _mouse_pos);
                }
            } else if (self.state == .OVER) {
                self.state = .DOWN;
                self.update_color();
                if (self.on_down != null) self.on_down.?(self.*.user_data, _mouse_pos);
            }
        }
        pub fn on_mouse_up(self: *Self, _mouse_pos: point) void {
            if (self.state == .DOWN) {
                if (self.area.rect.is_point_in(_mouse_pos)) {
                    self.state = .OVER;
                } else {
                    self.state = .UP;
                }
                self.update_color();
                if (self.on_up != null) self.on_up.?(self.*.user_data, _mouse_pos);
            }
        }
        pub fn on_touch_down(self: *Self, touch_idx: u32, _touch_pos: point) void {
            if (self.state == .UP) {
                if (self.area.rect.is_point_in(_touch_pos)) {
                    self.state = .DOWN;
                    self.update_color();
                    self._touch_idx = touch_idx;
                    if (self.on_down != null) self.on_down.?(self.*.user_data, _touch_pos);
                }
            } else if (self._touch_idx != null and self._touch_idx.? == touch_idx) {
                self.state = .UP;
                self._touch_idx = null;
                self.update_color();
                if (self.on_up != null) self.on_up.?(self.*.user_data, _touch_pos);
            }
        }
        pub fn on_touch_up(self: *Self, touch_idx: u32, _touch_pos: point) void {
            if (self.state == .DOWN and self._touch_idx.? == touch_idx) {
                self.state = .UP;
                self._touch_idx = null;
                self.update_color();
                if (self.on_up != null) self.on_up.?(self.*.user_data, _touch_pos);
            }
        }
        pub fn on_touch_move(self: *Self, touch_idx: u32, _touch_pos: point) void {
            if (self.area.rect.is_point_in(_touch_pos)) {
                if (self._touch_idx == null and self.state == .UP) {
                    self._touch_idx = touch_idx;
                    self.state = .OVER;
                    self.update_color();
                    if (self.on_over != null) self.on_over.?(self.*.user_data, _touch_pos);
                }
            } else if (self._touch_idx != null and self._touch_idx.? == touch_idx) {
                self._touch_idx = null;
                if (self.state != .UP) {
                    self.state = .UP;
                    self.update_color();
                }
            }
        }
        pub fn make_square_button_raw(scale: point, thickness: f32, _allocator: std.mem.Allocator) !std.meta.Tuple(&[_]type{ []button_sets, geometry.raw_shapes }) {
            var sets: []button_sets = try _allocator.alloc(button_sets, 2);
            errdefer _allocator.free(sets);

            sets[0] = .{};
            sets[1] = .{};
            sets[0].down_color = .{ 0.5, 0.5, 0.5, 0.8 };
            sets[0].over_color = .{ 0.5, 0.7, 0.7, 1 };
            sets[0].up_color = .{ 0.7, 0.7, 0.7, 1 };
            sets[1].down_color = .{ 0.5, 0.5, 1, 1 };
            sets[1].over_color = .{ 0.5, 0.5, 1, 1 };
            sets[1].up_color = .{ 0.5, 0.5, 0.5, 1 };

            var rect_line: [4]geometry.line = .{
                geometry.line.line_init(.{ -scale[0] / 2, scale[1] / 2 }, .{ scale[0] / 2, scale[1] / 2 }),
                geometry.line.line_init(.{ scale[0] / 2, scale[1] / 2 }, .{ scale[0] / 2, -scale[1] / 2 }),
                geometry.line.line_init(.{ scale[0] / 2, -scale[1] / 2 }, .{ -scale[0] / 2, -scale[1] / 2 }),
                geometry.line.line_init(.{ -scale[0] / 2, -scale[1] / 2 }, .{ -scale[0] / 2, scale[1] / 2 }),
            };
            var rect_npoly: [1]u32 = .{rect_line.len};

            var rl = [1]shape_node{.{
                .lines = rect_line[0..rect_line.len],
                .thickness = thickness,
                .stroke_color = sets[1].up_color,
                .color = sets[0].up_color,
                .n_polygons = rect_npoly[0..rect_npoly.len],
            }};
            var rect_poly: shapes = .{
                .nodes = rl[0..1],
            };

            return .{ sets, try rect_poly.compute_polygon(_allocator) };
        }
        pub fn make_square_button(scale: point, thickness: f32, _allocator: std.mem.Allocator) !std.meta.Tuple(&[_]type{ []button_sets, *shape_source }) {
            var raw_polygons = try make_square_button_raw(scale, thickness, _allocator);
            defer raw_polygons[1].deinit(_allocator);

            const out: *shape_source = try _allocator.create(shape_source);
            errdefer _allocator.destroy(out);

            out.* = shape_source.init();
            try out.*.build(_allocator, raw_polygons[1], .gpu, .cpu);

            return .{ raw_polygons[0], out };
        }
        pub fn update(self: *Self) void {
            for (self.*.sets, 0..) |*s, i| {
                const state = s.*.__updated_state.load(.monotonic);
                if (state != .UNKNOWN) {
                    self.*.shape.src.copy_color_update(i, &[_]vector{switch (state) {
                        .UP => s.*.up_color.?,
                        .OVER => s.*.over_color.?,
                        .DOWN => s.*.down_color.?,
                        else => unreachable,
                    }});
                    s.__updated_state.store(.UNKNOWN, .monotonic);
                }
            }
        }
        pub fn update_uniforms(self: *Self) void {
            self.*.shape.update_uniforms();
        }
        pub fn build(self: *Self) void {
            self.*.shape.build();
        }
        pub fn deinit(self: *Self) void {
            self.*.shape.deinit();
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
            self.*.shape.deinit_callback(callback, data);
        }
        pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
            self.*.shape.__draw(cmd);
        }
    };
}
