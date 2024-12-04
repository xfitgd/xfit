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

pub const button_state = enum {
    UP,
    OVER,
    DOWN,
};

pub const button = button_(true);
pub const pixel_button = button_(false);

pub const button_source = struct {
    src: shape_source,
    up_color: ?vector = null,
    over_color: ?vector = null,
    down_color: ?vector = null,
    __updated: std.atomic.Value(bool) = std.atomic.Value(bool).init(false),

    pub fn init() button_source {
        return .{
            .src = shape_source.init(),
        };
    }
};

pub fn button_(_msaa: bool) type {
    return struct {
        const Self = @This();

        transform: transform = .{ .parent_type = if (_msaa) ._button else ._pixel_button },
        srcs: []*button_source,
        area: iarea,
        state: button_state = .UP,
        __set: descriptor_set,
        on_over: ?*const fn (user_data: *anyopaque, _mouse_pos: point) void = null,
        on_down: ?*const fn (user_data: *anyopaque, _mouse_pos: point) void = null,
        on_up: ?*const fn (user_data: *anyopaque, _mouse_pos: ?point) void = null,
        user_data: *anyopaque = undefined,
        _touch_idx: ?u32 = null,

        pub fn init(_srcs: []*button_source, _area: iarea) Self {
            return .{
                .__set = .{
                    .bindings = graphics.single_pool_binding[0..1],
                    .size = graphics.transform_uniform_pool_sizes[0..1],
                    .layout = __vulkan.shape_color_2d_pipeline_set.descriptorSetLayout,
                },
                .area = _area,
                .srcs = _srcs,
            };
        }

        fn update_color(self: *Self) void {
            for (self.*.srcs) |v| {
                if (v.*.up_color == null or v.*.src.vertices.node.res == .null_handle or v.*.src.indices.node.res == .null_handle) continue;
                if (self.*.state == .UP and !v.*.__updated.load(.acquire)) {
                    v.*.src.color = v.*.up_color.?;
                    v.*.__updated.store(true, .release);
                } else if (self.*.state == .OVER and !v.*.__updated.load(.acquire)) {
                    if (v.*.over_color == null) {
                        v.*.src.color = v.*.up_color.?;
                    } else {
                        v.*.src.color = v.*.over_color.?;
                    }
                    v.*.__updated.store(true, .release);
                } else if (self.*.state == .DOWN and v.*.down_color != null and !v.*.__updated.load(.acquire)) {
                    v.*.src.color = v.*.down_color.?;
                    v.*.__updated.store(true, .release);
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
        pub fn make_square_button(_out: []*button_source, scale: point, thickness: f32, _allocator: std.mem.Allocator) !void {
            _out[0].* = button_source.init();
            _out[1].* = button_source.init();
            _out[0].*.down_color = .{ 0.5, 0.5, 0.5, 0.8 };
            _out[0].*.over_color = .{ 0.5, 0.7, 0.7, 1 };
            _out[0].*.src.color = .{ 0.7, 0.7, 0.7, 1 };
            _out[1].*.down_color = .{ 0.5, 0.5, 1, 1 };
            _out[1].*.over_color = .{ 0.5, 0.5, 1, 1 };
            _out[1].*.src.color = .{ 0.5, 0.5, 0.5, 1 };
            _out[0].*.up_color = _out[0].*.src.color;
            _out[1].*.up_color = _out[1].*.src.color;

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
                .stroke_color = .{ 0, 0, 0, 1 },
                .n_polygons = rect_npoly[0..rect_npoly.len],
            }};
            var rect_poly: shapes = .{
                .nodes = rl[0..1],
            };
            var raw_polygon = try rect_poly.compute_polygon(_allocator);
            defer raw_polygon.deinit();

            _out[0].*.src.build(raw_polygon.vertices[0], raw_polygon.indices[0], .gpu, .cpu);
            _out[1].*.src.build(raw_polygon.vertices[1], raw_polygon.indices[1], .gpu, .cpu);
        }
        pub fn update(self: *Self) void {
            for (self.*.srcs) |v| {
                if (v.*.__updated.load(.acquire)) {
                    v.*.src.copy_color_update();
                    v.*.__updated.store(false, .release);
                }
            }
        }
        pub fn update_uniforms(self: *Self) void {
            var __set_res: [3]res_union = .{
                .{ .buf = &self.*.transform.__model_uniform },
                .{ .buf = &self.*.transform.camera.*.__uniform },
                .{ .buf = &self.*.transform.projection.*.__uniform },
            };
            self.*.__set.__res = __set_res[0..3];
            __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
        }
        pub fn build(self: *Self) void {
            self.*.transform.__build();
            self.*.update_uniforms();
        }
        pub fn deinit(self: *Self) void {
            self.*.transform.__deinit(null);
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            self.*.transform.__deinit(callback);
        }
        pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
            __vulkan.load_instance_and_device();
            for (self.*.srcs) |_src| {
                const src = &_src.*.src;
                if (src.*.vertices.node.res == .null_handle or src.*.indices.node.res == .null_handle) continue;
                __vulkan.vkd.?.cmdBindPipeline(cmd, .graphics, if (_msaa) __vulkan.shape_color_2d_pipeline_set.pipeline else __vulkan.pixel_shape_color_2d_pipeline_set.pipeline);

                __vulkan.vkd.?.cmdBindDescriptorSets(
                    cmd,
                    .graphics,
                    __vulkan.shape_color_2d_pipeline_set.pipelineLayout,
                    0,
                    1,
                    @ptrCast(&self.*.__set.__set),
                    0,
                    null,
                );

                const offsets: vk.DeviceSize = 0;
                __vulkan.vkd.?.cmdBindVertexBuffers(cmd, 0, 1, @ptrCast(&src.*.vertices.node.res), @ptrCast(&offsets));

                __vulkan.vkd.?.cmdBindIndexBuffer(cmd, src.*.indices.node.res, 0, .uint32);
                __vulkan.vkd.?.cmdDrawIndexed(cmd, src.*.indices.node.buffer_option.len / graphics.get_idx_type_size(src.*.indices.idx_type), 1, 0, 0, 0);

                __vulkan.vkd.?.cmdBindPipeline(cmd, .graphics, if (_msaa) __vulkan.quad_shape_2d_pipeline_set.pipeline else __vulkan.pixel_quad_shape_2d_pipeline_set.pipeline);

                __vulkan.vkd.?.cmdBindDescriptorSets(
                    cmd,
                    .graphics,
                    __vulkan.quad_shape_2d_pipeline_set.pipelineLayout,
                    0,
                    1,
                    @ptrCast(&src.*.__set.__set),
                    0,
                    null,
                );
                __vulkan.vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
            }
        }
    };
}
