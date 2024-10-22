const std = @import("std");

const system = @import("system.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");

const dbg = system.dbg;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

const _allocator = __system.allocator;

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;

const math = @import("math.zig");
const geometry = @import("geometry.zig");
const render_command = @import("render_command.zig");
const mem = @import("mem.zig");
const point = math.point;
const vector = math.vector;
const matrix = math.matrix;
const matrix_error = math.matrix_error;

const vulkan_res_node = __vulkan_allocator.vulkan_res_node;

///use make_shape2d_data fn
pub const indices16 = indices_(.U16);
pub const indices32 = indices_(.U32);
pub const indices = indices_(DEF_IDX_TYPE_);

pub const dummy_vertices = [@sizeOf(vertices(u8))]u8;
pub const dummy_indices = [@sizeOf(indices)]u8;

pub inline fn execute_and_wait_all_op() void {
    __vulkan_allocator.execute_and_wait_all_op();
}
pub inline fn execute_all_op() void {
    __vulkan_allocator.execute_all_op();
}
pub inline fn lock_data() void {
    __vulkan_allocator.lock_data();
}
pub inline fn trylock_data() bool {
    return __vulkan_allocator.trylock_data();
}
pub inline fn unlock_data() void {
    __vulkan_allocator.unlock_data();
}

pub fn take_vertices(dest_type: type, src_ptrmempool: anytype) !dest_type {
    return @as(dest_type, @alignCast(@ptrCast(try src_ptrmempool.*.create())));
}
pub const take_indices = take_vertices;

pub const write_flag = __vulkan_allocator.res_usage;

pub const shape_color_vertex_2d = extern struct {
    pos: point align(1),
    uvw: [3]f32 align(1),
};

pub const tex_vertex_2d = extern struct {
    pos: point align(1),
    uv: point align(1),
};

pub var render_cmd: ?[]*render_command = null;

pub const index_type = enum { U16, U32 };
pub const DEF_IDX_TYPE_: index_type = .U32;
pub const DEF_IDX_TYPE = indices_(DEF_IDX_TYPE_).idxT;

const components = @import("components.zig");

const descriptor_pool_size = __vulkan_allocator.descriptor_pool_size;
const descriptor_set = __vulkan_allocator.descriptor_set;
const descriptor_pool_memory = __vulkan_allocator.descriptor_pool_memory;
const res_union = __vulkan_allocator.res_union;

pub const single_sampler_pool_sizes: [1]descriptor_pool_size = .{
    .{
        .typ = .sampler,
        .cnt = 1,
    },
};
pub const single_pool_binding: [1]c_uint = .{0};
pub const single_uniform_pool_sizes: [1]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 1,
    },
};
pub const transform_uniform_pool_sizes: [1]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 4,
    },
};
pub const image_uniform_pool_sizes: [2]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 4,
    },
    .{
        .typ = .uniform,
        .cnt = 1,
    },
};
pub const image_uniform_pool_binding: [2]c_uint = .{ 0, 4 };
pub const animate_image_uniform_pool_sizes: [2]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 4,
    },
    .{
        .typ = .uniform,
        .cnt = 2,
    },
};
pub const animate_image_uniform_pool_binding: [2]c_uint = .{ 0, 4 };

const iobject_type = enum {
    _shape,
    _image,
    _anim_image,
    _button,
};
pub const iobject = union(iobject_type) {
    const Self = @This();
    _shape: shape,
    _image: image,
    _anim_image: animate_image,
    _button: components.button,

    pub inline fn deinit(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.deinit(),
        }
    }
    pub inline fn build(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.build(),
        }
    }
    pub inline fn update(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.update(),
        }
    }
    pub inline fn __draw(self: *Self, cmd: vk.VkCommandBuffer) void {
        switch (self.*) {
            inline else => |*case| case.*.__draw(cmd),
        }
    }
};

pub fn vertices(comptime vertexT: type) type {
    return struct {
        const Self = @This();

        array: ?[]vertexT = null,
        node: vulkan_res_node(.buffer) = .{},

        allocator: std.mem.Allocator = undefined,
        __check_init: mem.check_init = .{},

        pub fn init() Self {
            const self: Self = .{};
            return self;
        }
        pub fn init_for_alloc(__allocator: std.mem.Allocator) Self {
            const self: Self = .{ .allocator = __allocator };
            return self;
        }
        pub inline fn deinit(self: *Self) void {
            self.*.__check_init.deinit();
            self.*.node.clean();
        }
        pub inline fn deinit_for_alloc(self: *Self) void {
            deinit(self);
            self.allocator.free(self.array.?);
        }
        pub fn build(self: *Self, _flag: write_flag) !void {
            self.*.__check_init.init();
            if (self.*.array == null or self.*.array.?.len == 0) {
                system.print_error("WARN vertice array 0 or null\n", .{});
                return error.is_not_polygon;
            }
            self.*.node.create_buffer(.{
                .len = @intCast(self.*.array.?.len * @sizeOf(vertexT)),
                .typ = .vertex,
                .use = _flag,
            }, mem.u8arrC(self.*.array.?));
        }
        ///write_flag가 cpu일때만 호출
        pub fn copy_update(self: *Self) void {
            self.*.node.copy_update(self.*.array.?.ptr);
        }
    };
}

pub fn indices_(comptime _type: index_type) type {
    return struct {
        const Self = @This();
        const idxT = switch (_type) {
            .U16 => u16,
            .U32 => u32,
        };

        node: vulkan_res_node(.buffer) = .{},
        idx_type: index_type = undefined,
        array: ?[]idxT = null,
        allocator: std.mem.Allocator = undefined,
        __check_init: mem.check_init = .{},

        pub fn init() Self {
            var self: Self = .{};
            self.idx_type = _type;
            return self;
        }
        pub fn init_for_alloc(__allocator: std.mem.Allocator) Self {
            var self: Self = .{};
            self.idx_type = _type;
            self.allocator = __allocator;
            return self;
        }
        pub inline fn deinit(self: *Self) void {
            self.*.__check_init.deinit();
            self.*.node.clean();
        }
        pub inline fn deinit_for_alloc(self: *Self) void {
            deinit(self);
            self.allocator.free(self.array.?);
        }
        pub fn build(self: *Self, _flag: write_flag) void {
            self.*.__check_init.init();
            self.*.node.create_buffer(.{
                .len = @intCast(self.*.array.?.len * @sizeOf(idxT)),
                .typ = .index,
                .use = _flag,
            }, mem.u8arrC(self.*.array.?));
        }
        ///write_flag가 cpu일때만 호출
        pub fn copy_update(self: *Self) void {
            self.*.node.copy_update(self.*.array.?.ptr);
        }
    };
}

pub const projection = struct {
    const Self = @This();
    proj: matrix = undefined,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},

    pub fn init_matrix_orthographic(self: *Self, _width: f32, _height: f32) matrix_error!void {
        const width = @as(f32, @floatFromInt(window.window_width()));
        const height = @as(f32, @floatFromInt(window.window_height()));
        const ratio = if (width / height > _width / _height) _height / height else _width / width;
        self.*.proj = try matrix.orthographicLhVulkan(
            width * ratio,
            height * ratio,
            0.1,
            100,
        );
    }
    pub fn init_matrix_orthographic2(self: *Self, _width: f32, _height: f32, near: f32, far: f32) matrix_error!void {
        const width = @as(f32, @floatFromInt(window.window_width()));
        const height = @as(f32, @floatFromInt(window.window_height()));
        const ratio = if (width / height > _width / _height) _height / height else _width / width;
        self.*.proj = try matrix.orthographicLhVulkan(
            width * ratio,
            height * ratio,
            near,
            far,
        );
    }
    pub fn init_matrix_perspective(self: *Self, fov: f32) matrix_error!void {
        self.*.proj = try matrix.perspectiveFovLhVulkan(
            fov,
            @as(f32, @floatFromInt(window.window_width())) / @as(f32, @floatFromInt(window.window_height())),
            0.1,
            100,
        );
    }
    pub fn init_matrix_perspective2(self: *Self, fov: f32, near: f32, far: f32) matrix_error!void {
        self.*.proj = try matrix.perspectiveFovLhVulkan(
            fov,
            @as(f32, @floatFromInt(window.window_width())) / @as(f32, @floatFromInt(window.window_height())),
            near,
            far,
        );
    }
    pub inline fn deinit(self: *Self) void {
        self.*.__check_alloc.deinit();
        self.*.__uniform.clean();
    }
    pub fn build(self: *Self, _flag: write_flag) void {
        self.*.__check_alloc.init(__system.allocator);
        self.*.__uniform.create_buffer(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = _flag,
        }, mem.obj_to_u8arrC(&self.*.proj));
    }
    ///write_flag가 cpu일때만 호출
    pub fn copy_update(self: *Self) void {
        self.*.__uniform.copy_update(&self.*.proj);
    }
};
pub const camera = struct {
    const Self = @This();
    view: matrix,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},

    /// w좌표는 신경 x, 시스템 초기화 후 호출
    pub fn init(eyepos: vector, focuspos: vector, updir: vector) Self {
        var res = Self{ .view = matrix.lookAtLh(eyepos, focuspos, updir) };
        res.__check_alloc.init(__system.allocator);
        return res;
    }
    pub inline fn deinit(self: *Self) void {
        self.*.__check_alloc.deinit();
        self.*.__uniform.clean();
    }
    pub fn build(self: *Self) void {
        self.*.__uniform.create_buffer(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = .cpu,
        }, mem.obj_to_u8arrC(&self.*.view));
    }
    ///write_flag가 cpu일때만 호출
    pub fn copy_update(self: *Self) void {
        self.*.__uniform.copy_update(&self.*.view);
    }
};
pub const color_transform = struct {
    const Self = @This();
    color_mat: matrix,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},

    pub fn get_no_default() *Self {
        return &__vulkan.no_color_tran;
    }

    /// w좌표는 신경 x, 시스템 초기화 후 호출
    pub fn init() Self {
        const res = Self{ .color_mat = matrix.identity() };
        return res;
    }
    pub inline fn deinit(self: *Self) void {
        self.*.__check_alloc.deinit();
        self.*.__uniform.clean();
    }
    pub fn build(self: *Self, _flag: write_flag) void {
        self.*.__check_alloc.init(__system.allocator);
        self.*.__uniform.create_buffer(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = _flag,
        }, mem.obj_to_u8arrC(&self.*.color_mat));
    }
    ///write_flag가 cpu일때만 호출
    pub fn copy_update(self: *Self) void {
        self.*.__check_alloc.check_inited();
        self.*.__uniform.copy_update(&self.*.color_mat);
    }
};

//transform는 object와 한몸이라 따로 check_alloc 필요없음
pub const transform = struct {
    const Self = @This();

    parent_type: iobject_type,

    model: matrix = matrix.identity(),
    __model: matrix = undefined,
    ///이 값 자체가 변경되면 iobject.update 필요
    camera: ?*camera = null,
    ///이 값 자체가 변경되면 iobject.update 필요
    projection: ?*projection = null,
    __model_uniform: vulkan_res_node(.buffer) = .{},

    __check_init: mem.check_init = .{},

    pub inline fn __deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__model_uniform.clean();
    }
    inline fn get_mat_set_wh(self: *Self, _type: type) matrix {
        const e: *_type = @fieldParentPtr("transform", self);
        var mat = self.*.model;
        mat.e[0][0] *= @floatFromInt(e.*.src.*.width);
        mat.e[1][1] *= @floatFromInt(e.*.src.*.height);
        return mat;
    }
    inline fn get_mat(self: *Self) matrix {
        switch (self.*.parent_type) {
            inline ._image, ._anim_image => |e| {
                return get_mat_set_wh(self, std.meta.TagPayload(iobject, e));
            },
            else => return self.*.model,
        }
    }
    pub inline fn __build(self: *Self) void {
        self.*.__check_init.init();
        self.*.__model = get_mat(self);
        self.*.__model_uniform.create_buffer(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = .cpu,
        }, mem.obj_to_u8arrC(&self.*.__model));
    }
    ///write_flag가 readwrite_cpu일때만 호출
    pub fn copy_update(self: *Self) void {
        self.*.__check_init.check_inited();
        self.*.__model = get_mat(self);
        self.*.__model_uniform.copy_update(&self.*.__model);
    }
};

pub const texture = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    width: u32 = 0,
    height: u32 = 0,
    pixels: ?[]u8 = null,
    vertices: *vertices(tex_vertex_2d),
    indices: ?*indices32,
    sampler: vk.VkSampler,
    __set: descriptor_set,
    __set_res: [1]res_union = .{undefined},
    __check_init: mem.check_init = .{},

    pub fn get_default_quad_image_vertices() *vertices(tex_vertex_2d) {
        return &__vulkan.quad_image_vertices;
    }
    pub fn get_default_linear_sampler() vk.VkSampler {
        return __vulkan.linear_sampler;
    }
    pub fn get_default_nearest_sampler() vk.VkSampler {
        return __vulkan.nearest_sampler;
    }

    pub fn init() Self {
        return .{
            .vertices = get_default_quad_image_vertices(),
            .indices = null,
            .sampler = get_default_linear_sampler(),
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = single_sampler_pool_sizes[0..1],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout2,
            },
        };
    }

    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean();
    }
    pub fn build(self: *Self) void {
        self.*.__check_init.init();
        if (self.*.width == 0 or self.*.height == 0) {
            system.print_error("WARN can't build texture\n", .{});
            return;
        }
        self.*.__image.create_texture(.{
            .width = self.*.width,
            .height = self.*.height,
        }, self.*.sampler, self.*.pixels.?);
        self.*.__set_res[0] = .{ .tex = &self.*.__image };
        self.*.__set.res = self.*.__set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    // pub fn copy(self: *Self, _data: []const u8, rect: ?math.recti) void {
    //     __vulkan_allocator.copy_texture(self, _data, rect);
    // }
};

pub const texture_array = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    width: u32 = 0,
    height: u32 = 0,
    frames: u32 = 0,
    ///1차원 배열에 순차적으로 이미지 프레임 데이터들을 배치
    pixels: ?[]u8 = null,
    vertices: *vertices(tex_vertex_2d),
    indices: ?*indices32,
    sampler: vk.VkSampler,
    __set: descriptor_set,
    __set_res: [1]res_union = .{undefined},
    __check_init: mem.check_init = .{},

    pub fn get_default_quad_image_vertices() *vertices(tex_vertex_2d) {
        return &__vulkan.quad_image_vertices;
    }
    pub fn get_default_linear_sampler() vk.VkSampler {
        return __vulkan.linear_sampler;
    }
    pub fn get_default_nearest_sampler() vk.VkSampler {
        return __vulkan.nearest_sampler;
    }
    pub fn get_frame_count_build(self: *Self) u32 {
        return self.*.__image.texture_option.len;
    }

    pub fn init() Self {
        return .{
            .vertices = get_default_quad_image_vertices(),
            .indices = null,
            .sampler = get_default_linear_sampler(),
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = single_sampler_pool_sizes[0..1],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout2,
            },
        };
    }

    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean();
    }
    pub fn build(self: *Self) void {
        self.*.__check_init.init();
        if (self.*.width == 0 or self.*.height == 0 or self.*.frames == 0) {
            system.print_error("WARN can't build texture array\n", .{});
            return;
        }
        self.*.__image.create_texture(.{
            .width = self.*.width,
            .height = self.*.height,
            .len = self.*.frames,
        }, self.*.sampler, self.*.pixels.?);
        self.*.__set_res[0] = .{ .tex = &self.*.__image };
        self.*.__set.res = self.*.__set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
};

pub const shape = struct {
    const Self = @This();

    pub const source = struct {
        vertices: vertices(shape_color_vertex_2d),
        indices: indices32,
        color: vector = .{ 1, 1, 1, 1 },
        __uniform: vulkan_res_node(.buffer) = .{},
        __set: descriptor_set,
        __set_res: [1]res_union = .{undefined},

        pub fn init() source {
            return .{
                .vertices = vertices(shape_color_vertex_2d).init(),
                .indices = indices32.init(),
                .__set = .{
                    .bindings = single_pool_binding[0..1],
                    .size = single_uniform_pool_sizes[0..1],
                    .layout = __vulkan.quad_shape_2d_pipeline_set.descriptorSetLayout,
                },
            };
        }
        pub fn init_for_alloc(__allocator: std.mem.Allocator) source {
            return .{
                .vertices = vertices(shape_color_vertex_2d).init_for_alloc(__allocator),
                .indices = indices32.init_for_alloc(__allocator),
                .__set = .{
                    .bindings = single_pool_binding[0..1],
                    .size = single_uniform_pool_sizes[0..1],
                    .layout = __vulkan.quad_shape_2d_pipeline_set.descriptorSetLayout,
                },
            };
        }
        pub fn build(self: *source, _flag: write_flag, _color_flag: write_flag) void {
            if (self.*.vertices.array == null or self.*.vertices.array.?.len == 0) return;
            self.*.vertices.build(_flag) catch return;
            self.*.indices.build(_flag);

            self.*.__uniform.create_buffer(.{
                .len = @sizeOf(vector),
                .typ = .uniform,
                .use = _color_flag,
            }, mem.obj_to_u8arrC(&self.*.color));
            self.*.__set_res[0] = .{ .buf = &self.*.__uniform };
            self.*.__set.res = self.*.__set_res[0..1];
            __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
        }
        pub fn deinit(self: *source) void {
            self.*.vertices.deinit();
            self.*.indices.deinit();
            self.*.__uniform.clean();
        }
        pub fn deinit_for_alloc(self: *source) void {
            self.*.vertices.deinit_for_alloc();
            self.*.indices.deinit_for_alloc();
            self.*.__uniform.clean();
        }
        ///write_flag가 cpu일때만 호출
        pub fn copy_color_update(self: *source) void {
            self.*.__uniform.copy_update(&self.*.color);
        }
    };

    transform: transform = .{ .parent_type = ._shape },
    src: *source = undefined,
    extra_src: ?[]*source = null,
    __set: descriptor_set,
    __set_res: [4]res_union = .{undefined} ** 4,

    pub fn init() Self {
        return .{
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = transform_uniform_pool_sizes[0..1],
                .layout = __vulkan.shape_color_2d_pipeline_set.descriptorSetLayout,
            },
        };
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
        vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipeline);

        vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipelineLayout, 0, 1, &self.*.__set.__set, 0, null);

        const offsets: vk.VkDeviceSize = 0;
        vk.vkCmdBindVertexBuffers(cmd, 0, 1, &self.*.src.*.vertices.node.res, &offsets);

        vk.vkCmdBindIndexBuffer(cmd, self.*.src.*.indices.node.res, 0, vk.VK_INDEX_TYPE_UINT32);
        vk.vkCmdDrawIndexed(cmd, self.*.src.*.indices.node.buffer_option.len / get_idx_type_size(self.*.src.*.indices.idx_type), 1, 0, 0, 0);

        vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipeline);

        vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipelineLayout, 0, 1, &self.*.src.*.__set.__set, 0, null);
        vk.vkCmdDraw(cmd, 6, 1, 0, 0);

        if (self.*.extra_src != null and self.*.extra_src.?.len > 0) {
            for (self.*.extra_src.?) |src| {
                vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipeline);
                vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.shape_color_2d_pipeline_set.pipelineLayout, 0, 1, &self.*.__set.__set, 0, null);
                vk.vkCmdBindVertexBuffers(cmd, 0, 1, &src.*.vertices.node.res, &offsets);

                vk.vkCmdBindIndexBuffer(cmd, src.*.indices.node.res, 0, vk.VK_INDEX_TYPE_UINT32);
                vk.vkCmdDrawIndexed(cmd, src.*.indices.node.buffer_option.len / get_idx_type_size(src.*.indices.idx_type), 1, 0, 0, 0);

                vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipeline);
                vk.vkCmdBindDescriptorSets(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.quad_shape_2d_pipeline_set.pipelineLayout, 0, 1, &src.*.__set.__set, 0, null);

                vk.vkCmdDraw(cmd, 6, 1, 0, 0);
            }
        }
    }
};

pub const center_pt_pos = enum {
    center,
    left,
    right,
    top_left,
    top,
    top_right,
    bottom_left,
    bottom,
    bottom_right,
};

pub fn get_idx_type_size(typ: index_type) c_uint {
    return switch (typ) {
        .U32 => 4,
        .U16 => 2,
    };
}

pub const image = struct {
    const Self = @This();

    transform: transform = .{ .parent_type = ._image },
    src: *texture = undefined,
    color_tran: *color_transform,
    __set: descriptor_set,
    __set_res: [5]res_union = .{undefined} ** 5,

    ///회전 했을때 고려안함, img scale은 기본(이미지 크기) 비율일때 기준
    pub fn pixel_perfect_point(img: Self, _p: point, _canvas_w: f32, _canvas_h: f32, center: center_pt_pos) point {
        const width = @as(f32, @floatFromInt(window.window_width()));
        const height = @as(f32, @floatFromInt(window.window_height()));
        if (width / height > _canvas_w / _canvas_h) { //1배 비율이 아니면 적용할수 없다.
            if (_canvas_h != height) return _p;
        } else {
            if (_canvas_w != width) return _p;
        }
        _p = @floor(_p);
        if (window.window_width() % 2 != 0) _p.x -= 0.5;
        if (window.window_height() % 2 != 0) _p.y += 0.5;

        switch (center) {
            .center => {
                if (img.src.*.texture.width % 2 != 0) _p.x += 0.5;
                if (img.src.*.texture.height % 2 != 0) _p.y -= 0.5;
            },
            .right, .left => {
                if (img.src.*.texture.height % 2 != 0) _p.y -= 0.5;
            },
            .top, .bottom => {
                if (img.src.*.texture.width % 2 != 0) _p.x += 0.5;
            },
            else => {},
        }
        return _p;
    }
    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit();
    }
    pub fn update(self: *Self) void {
        self.*.__set_res[0] = .{ .buf = &self.*.transform.__model_uniform };
        self.*.__set_res[1] = .{ .buf = &self.*.transform.camera.?.*.__uniform };
        self.*.__set_res[2] = .{ .buf = &self.*.transform.projection.?.*.__uniform };
        self.*.__set_res[3] = .{ .buf = &__vulkan.__pre_mat_uniform };
        self.*.__set_res[4] = .{ .buf = &self.*.color_tran.*.__uniform };
        self.*.__set.res = self.*.__set_res[0..5];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        self.*.update();
    }
    pub fn __draw(self: *Self, cmd: vk.VkCommandBuffer) void {
        vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.tex_2d_pipeline_set.pipeline);

        vk.vkCmdBindDescriptorSets(
            cmd,
            vk.VK_PIPELINE_BIND_POINT_GRAPHICS,
            __vulkan.tex_2d_pipeline_set.pipelineLayout,
            0,
            2,
            &[_]vk.VkDescriptorSet{ self.*.__set.__set, self.*.src.*.__set.__set },
            0,
            null,
        );

        const offsets: vk.VkDeviceSize = 0;
        vk.vkCmdBindVertexBuffers(cmd, 0, 1, &self.*.src.vertices.*.node.res, &offsets);

        if (self.*.src.indices != null) {
            vk.vkCmdBindIndexBuffer(cmd, self.*.src.indices.?.*.node.res, 0, switch (self.*.src.indices.?.*.idx_type) {
                .U16 => vk.VK_INDEX_TYPE_UINT16,
                .U32 => vk.VK_INDEX_TYPE_UINT32,
            });

            vk.vkCmdDrawIndexed(cmd, self.*.src.indices.?.*.node.buffer_option.len / get_idx_type_size(self.*.src.indices.?.*.idx_type), 1, 0, 0, 0);
        } else {
            vk.vkCmdDraw(cmd, self.*.src.vertices.*.node.buffer_option.len / @sizeOf(tex_vertex_2d), 1, 0, 0);
        }
    }
    pub fn init() Self {
        const self = Self{
            .color_tran = color_transform.get_no_default(),
            .__set = .{
                .bindings = image_uniform_pool_binding[0..2],
                .size = image_uniform_pool_sizes[0..2],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout,
            },
        };
        return self;
    }
};
pub const animate_image = struct {
    const Self = @This();

    transform: transform = .{ .parent_type = ._anim_image },

    src: *texture_array = undefined,
    color_tran: *color_transform,
    __frame_uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,
    __set_res: [6]res_union = .{undefined} ** 6,
    frame: u32 = 0,

    ///회전 했을때 고려안함, img scale은 기본(이미지 크기) 비율일때 기준
    pub fn pixel_perfect_point(img: Self, _p: point, _canvas_w: f32, _canvas_h: f32, center: center_pt_pos) point {
        const width = @as(f32, @floatFromInt(window.window_width()));
        const height = @as(f32, @floatFromInt(window.window_height()));
        if (width / height > _canvas_w / _canvas_h) { //1배 비율이 아니면 적용할수 없다.
            if (_canvas_h != height) return _p;
        } else {
            if (_canvas_w != width) return _p;
        }
        _p = @floor(_p);
        if (window.window_width() % 2 != 0) _p.x -= 0.5;
        if (window.window_height() % 2 != 0) _p.y += 0.5;

        switch (center) {
            .center => {
                if (img.src.*.texture.width % 2 != 0) _p.x += 0.5;
                if (img.src.*.texture.height % 2 != 0) _p.y -= 0.5;
            },
            .right, .left => {
                if (img.src.*.texture.height % 2 != 0) _p.y -= 0.5;
            },
            .top, .bottom => {
                if (img.src.*.texture.width % 2 != 0) _p.x += 0.5;
            },
            else => {},
        }
        return _p;
    }
    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit();
        self.*.__frame_uniform.clean();
    }
    pub fn next_frame(self: *Self) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_frame_count_build() == 0) return;
        if (self.*.src.*.__image.texture_option.len - 1 < self.*.frame) {
            self.*.frame = 0;
            return;
        }
        self.*.frame = (self.*.frame + 1) % self.*.src.*.get_frame_count_build();
        copy_update_frame(self);
    }
    pub fn prev_frame(self: *Self) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_frame_count_build() == 0) return;
        if (self.*.src.*.__image.__resource_len - 1 < self.*.frame) {
            self.*.frame = 0;
            return;
        }
        self.*.frame = if (self.*.frame > 0) (self.*.frame - 1) else (self.*.src.*.get_frame_count_build() - 1);
        copy_update_frame(self);
    }
    pub fn set_frame(self: *Self, _frame: u32) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_frame_count_build() == 0) return;
        if (self.*.src.*.__image.__resource_len - 1 < _frame) {
            return;
        }
        self.*.frame = _frame;
        copy_update_frame(self);
    }

    pub fn copy_update_frame(self: *Self) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.__image.texture_option.len == 0 or self.*.src.*.__image.texture_option.len - 1 < self.*.frame) return;
        const __frame_cpy: f32 = @floatFromInt(self.*.frame);
        self.*.__frame_uniform.copy_update(&__frame_cpy);
    }
    pub fn update(self: *Self) void {
        self.*.__set_res[0] = .{ .buf = &self.*.transform.__model_uniform };
        self.*.__set_res[1] = .{ .buf = &self.*.transform.camera.?.*.__uniform };
        self.*.__set_res[2] = .{ .buf = &self.*.transform.projection.?.*.__uniform };
        self.*.__set_res[3] = .{ .buf = &__vulkan.__pre_mat_uniform };
        self.*.__set_res[4] = .{ .buf = &self.*.color_tran.*.__uniform };
        self.*.__set_res[5] = .{ .buf = &self.*.__frame_uniform };
        self.*.__set.res = self.*.__set_res[0..6];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        const __frame_cpy: f32 = @floatFromInt(self.*.frame);
        self.*.__frame_uniform.create_buffer_copy(.{
            .len = @sizeOf(f32),
            .typ = .uniform,
            .use = .cpu,
        }, mem.obj_to_u8arrC(&__frame_cpy));

        self.*.update();
    }
    pub fn __draw(self: *Self, cmd: vk.VkCommandBuffer) void {
        vk.vkCmdBindPipeline(cmd, vk.VK_PIPELINE_BIND_POINT_GRAPHICS, __vulkan.animate_tex_2d_pipeline_set.pipeline);

        vk.vkCmdBindDescriptorSets(
            cmd,
            vk.VK_PIPELINE_BIND_POINT_GRAPHICS,
            __vulkan.animate_tex_2d_pipeline_set.pipelineLayout,
            0,
            2,
            &[_]vk.VkDescriptorSet{ self.*.__set.__set, self.*.src.*.__set.__set },
            0,
            null,
        );

        const offsets: vk.VkDeviceSize = 0;
        vk.vkCmdBindVertexBuffers(cmd, 0, 1, &self.*.src.vertices.*.node.res, &offsets);

        if (self.*.src.indices != null) {
            vk.vkCmdBindIndexBuffer(cmd, self.*.src.indices.?.*.node.res, 0, switch (self.*.src.indices.?.*.idx_type) {
                .U16 => vk.VK_INDEX_TYPE_UINT16,
                .U32 => vk.VK_INDEX_TYPE_UINT32,
            });
            vk.vkCmdDrawIndexed(cmd, self.*.src.indices.?.*.node.buffer_option.len / get_idx_type_size(self.*.src.indices.?.*.idx_type), 1, 0, 0, 0);
        } else {
            vk.vkCmdDraw(cmd, self.*.src.vertices.*.node.buffer_option.len / @sizeOf(tex_vertex_2d), 1, 0, 0);
        }
    }
    pub fn init() Self {
        const self = Self{
            .color_tran = color_transform.get_no_default(),
            .__set = .{
                .bindings = animate_image_uniform_pool_binding[0..2],
                .size = animate_image_uniform_pool_sizes[0..2],
                .layout = __vulkan.animate_tex_2d_pipeline_set.descriptorSetLayout,
            },
        };
        return self;
    }
};
