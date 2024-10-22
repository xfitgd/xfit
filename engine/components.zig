const std = @import("std");
const graphics = @import("graphics.zig");
const system = @import("system.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");

const iobject = graphics.iobject;
const transform = graphics.transform;
const shape = graphics.shape;

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

pub const button = struct {
    pub const source = struct {
        src: shape.source,
        up_color: ?vector = null,
        over_color: ?vector = null,
        down_color: ?vector = null,

        pub fn init() source {
            return .{
                .src = shape.source.init(),
            };
        }
        pub fn init_for_alloc(__allocator: std.mem.Allocator) source {
            return .{
                .src = shape.source.init_for_alloc(__allocator),
            };
        }
    };
    const Self = @This();

    transform: transform = .{ .parent_type = ._button },
    src: []*source = undefined,
    area: iarea,
    state: button_state = .UP,
    __set: descriptor_set,
    __set_res: [4]res_union = .{undefined} ** 4,
    on_over: ?*const fn (self: *Self, _mouse_pos: point) void = null,
    on_down: ?*const fn (self: *Self, _mouse_pos: point) void = null,
    on_up: ?*const fn (self: *Self, _mouse_pos: ?point) void = null,
    _touch_idx: ?u32 = null,

    pub fn init(_area: iarea) Self {
        return .{
            .__set = .{
                .bindings = graphics.single_pool_binding[0..1],
                .size = graphics.transform_uniform_pool_sizes[0..1],
                .layout = __vulkan.shape_color_2d_pipeline_set.descriptorSetLayout,
            },
            .area = _area,
        };
    }

    fn update_color(self: *Self) void {
        for (self.*.src) |v| {
            if (v.*.up_color == null) continue;
            if (self.*.state == .UP) {
                v.*.src.color = v.*.up_color.?;
                v.*.src.copy_color_update();
            } else if (self.*.state == .OVER) {
                if (v.*.over_color == null) {
                    v.*.src.color = v.*.up_color.?;
                    v.*.src.copy_color_update();
                } else {
                    v.*.src.color = v.*.over_color.?;
                    v.*.src.copy_color_update();
                }
            } else if (self.*.state == .DOWN) {
                if (v.*.down_color != null) {
                    v.*.src.color = v.*.down_color.?;
                    v.*.src.copy_color_update();
                }
            }
        }
    }
    pub fn on_mouse_move(self: *Self, _mouse_pos: point) void {
        if (self.state == .UP) {
            if (self.area.rect.is_point_in(_mouse_pos)) {
                self.state = .OVER;
                self.update_color();
                if (self.on_over != null) self.on_over.?(self, _mouse_pos);
            }
        } else if (self.state == .OVER) {
            if (!self.area.rect.is_point_in(_mouse_pos)) {
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
                if (self.on_down != null) self.on_down.?(self, _mouse_pos);
            }
        } else if (self.state == .OVER) {
            self.state = .DOWN;
            self.update_color();
            if (self.on_down != null) self.on_down.?(self, _mouse_pos);
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
            if (self.on_up != null) self.on_up.?(self, _mouse_pos);
        }
    }
    pub fn on_touch_down(self: *Self, touch_idx: u32, _mouse_pos: point) void {
        if (self.state == .UP) {
            if (self.area.rect.is_point_in(_mouse_pos)) {
                self.state = .DOWN;
                self.update_color();
                self._touch_idx = touch_idx;
                if (self.on_down != null) self.on_down.?(self, _mouse_pos);
            }
        } else if (self._touch_idx != null and self._touch_idx.? == touch_idx) {
            self.state = .UP;
            self._touch_idx = null;
            self.update_color();
            if (self.on_up != null) self.on_up.?(self, _mouse_pos);
        }
    }
    pub fn on_touch_up(self: *Self, touch_idx: u32, _mouse_pos: point) void {
        if (self.state == .DOWN and self._touch_idx.? == touch_idx) {
            self.state = .UP;
            self._touch_idx = null;
            self.update_color();
            if (self.on_up != null) self.on_up.?(self, _mouse_pos);
        }
    }
    pub fn on_mouse_out(self: *Self) void {
        if (self.state == .DOWN or self.state == .OVER) {
            self.state = .UP;
            self.update_color();
            if (self.state == .DOWN) {
                if (self.on_up != null) self.on_up.?(self, null);
            }
        }
    }

    pub fn make_square_button(_out: []*source, scale: point, _allocator: std.mem.Allocator) !void {
        _out[0].* = source.init_for_alloc(_allocator);
        _out[1].* = source.init_for_alloc(_allocator);
        _out[0].*.down_color = .{ 0.5, 0.5, 0.5, 0.8 };
        _out[0].*.over_color = .{ 0.5, 0.7, 0.7, 1 };
        _out[0].*.src.color = .{ 0.7, 0.7, 0.7, 1 };
        _out[1].*.down_color = .{ 0.5, 0.5, 1, 1 };
        _out[1].*.over_color = .{ 0.5, 0.5, 1, 1 };
        _out[1].*.src.color = .{ 0.5, 0.5, 0.5, 1 };
        _out[0].*.up_color = _out[0].*.src.color;
        _out[1].*.up_color = _out[1].*.src.color;

        var rect_line: [4]geometry.line = .{
            geometry.line.line_init(.{ -scale[0], scale[1] }, .{ scale[0], scale[1] }),
            geometry.line.line_init(.{ scale[0], scale[1] }, .{ scale[0], -scale[1] }),
            geometry.line.line_init(.{ scale[0], -scale[1] }, .{ -scale[0], -scale[1] }),
            geometry.line.line_init(.{ -scale[0], -scale[1] }, .{ -scale[0], scale[1] }),
        };

        var rl = [1][]geometry.line{rect_line[0..rect_line.len]};
        var rect_poly: geometry.polygon = .{
            .tickness = 2,
            .lines = rl[0..1],
        };
        var raw_polygon_outline = geometry.raw_polygon{
            .vertices = try _allocator.alloc(graphics.shape_color_vertex_2d, 0),
            .indices = try _allocator.alloc(u32, 0),
        };
        var raw_polygon = geometry.raw_polygon{
            .vertices = try _allocator.alloc(graphics.shape_color_vertex_2d, 0),
            .indices = try _allocator.alloc(u32, 0),
        };
        try rect_poly.compute_outline(_allocator, &raw_polygon_outline);
        try rect_poly.compute_polygon(_allocator, &raw_polygon);

        _out[0].*.src.vertices.array = raw_polygon.vertices;
        _out[0].*.src.indices.array = raw_polygon.indices;
        _out[0].*.src.build(.gpu, .cpu);

        _out[1].*.src.vertices.array = raw_polygon_outline.vertices;
        _out[1].*.src.indices.array = raw_polygon_outline.indices;
        _out[1].*.src.build(.gpu, .cpu);
    }

    pub fn update(self: *Self) void {
        self.*.__set_res[0] = .{ .buf = &self.*.transform.__model_uniform };
        self.*.__set_res[1] = .{ .buf = &self.*.transform.camera.?.*.__uniform };
        self.*.__set_res[2] = .{ .buf = &self.*.transform.projection.?.*.__uniform };
        self.*.__set_res[3] = .{ .buf = &__vulkan.__pre_mat_uniform };
        self.*.__set.res = self.*.__set_res[0..4];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();
        self.*.update();
    }
    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit();
    }
    pub fn __draw(self: *Self, cmd: vk.VkCommandBuffer) void {
        for (self.*.src) |_src| {
            const src = &_src.*.src;
            vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipeline);

            vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipelineLayout, 0, 1, &self.*.__set.__set, 0, null);

            const offsets: vk.VkDeviceSize = 0;
            vk.vkCmdBindVertexBuffers(cmd, 0, 1, &src.*.vertices.node.res, &offsets);

            vk.vkCmdBindIndexBuffer(cmd, src.*.indices.node.res, 0, vk.VK_INDEX_TYPE_UINT32);
            vk.vkCmdDrawIndexed(cmd, src.*.indices.node.buffer_option.len / graphics.get_idx_type_size(src.*.indices.idx_type), 1, 0, 0, 0);

            vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipeline);

            vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipelineLayout, 0, 1, &src.*.__set.__set, 0, null);
            vk.vkCmdDraw(cmd, 6, 1, 0, 0);
        }
    }
};
