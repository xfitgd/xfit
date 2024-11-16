const std = @import("std");

const system = @import("system.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");
const xfit = @import("xfit.zig");
const img_util = @import("image_util.zig");

const dbg = xfit.dbg;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

const _allocator = __system.allocator;

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;

const math = @import("math.zig");
const geometry = @import("geometry.zig");
const render_command = @import("render_command.zig");
const mem = @import("mem.zig");
const point = math.point;
const pointu = math.pointu;
const vector = math.vector;
const matrix = math.matrix;
const matrix_error = math.matrix_error;
const __render_command = @import("__render_command.zig");

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
pub inline fn set_render_clear_color(_color: vector) void {
    @atomicStore(f32, &__vulkan.clear_color._0, _color[0], .monotonic);
    @atomicStore(f32, &__vulkan.clear_color._1, _color[1], .monotonic);
    @atomicStore(f32, &__vulkan.clear_color._2, _color[2], .monotonic);
    @atomicStore(f32, &__vulkan.clear_color._3, _color[3], .monotonic);
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
pub const tile_image_uniform_pool_sizes: [3]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 4,
    },
    .{
        .typ = .uniform,
        .cnt = 1,
    },
    .{
        .typ = .uniform,
        .cnt = 1,
    },
};
pub const tile_image_uniform_pool_binding: [3]c_uint = .{ 0, 4, 5 };

const iobject_type = enum {
    _shape,
    _image,
    _anim_image,
    _button,
    _tile_image,
    _pixel_shape,
    _pixel_button,
    //_sprite_image,
};
pub const iobject = union(iobject_type) {
    const Self = @This();
    _shape: shape,
    _image: image,
    _anim_image: animate_image,
    _button: components.button,
    _tile_image: tile_image,
    _pixel_shape: pixel_shape,
    _pixel_button: components.pixel_button,

    pub inline fn deinit(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.deinit(),
        }
    }
    pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        switch (self.*) {
            inline else => |*case| case.*.deinit_callback(callback),
        }
    }
    pub inline fn build(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.build(),
        }
    }
    pub inline fn update_uniforms(self: *Self) void {
        switch (self.*) {
            inline else => |*case| case.*.update_uniforms(),
        }
    }
    pub inline fn update(self: *Self) void {
        switch (self.*) {
            inline ._button, ._pixel_button => |*case| case.*.update(),
            else => {},
        }
    }
    pub inline fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
        switch (self.*) {
            inline else => |*case| case.*.__draw(cmd),
        }
    }
    pub inline fn ptransform(self: *Self) *transform {
        return switch (self.*) {
            inline else => |*case| &case.*.transform,
        };
    }
    pub inline fn is_shape_type(self: *Self) bool {
        return switch (self.*) {
            ._shape, ._button => true,
            else => false,
        };
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
            self.*.node.clean(null, {});
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            self.*.__check_init.deinit();
            self.*.node.clean(callback, self);
        }
        pub inline fn deinit_for_alloc(self: *Self) void {
            deinit(self);
            self.allocator.free(self.array.?);
        }
        pub inline fn deinit_for_alloc_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            deinit_callback(self, callback);
            self.allocator.free(self.array.?);
        }
        pub inline fn build_gcpu(self: *Self, _flag: write_flag) geometry.polygon_error!void {
            try self.*.__build(_flag, true);
        }
        pub inline fn build(self: *Self, _flag: write_flag) geometry.polygon_error!void {
            try self.*.__build(_flag, false);
        }
        pub fn __build(self: *Self, _flag: write_flag, comptime use_gcpu_mem: bool) geometry.polygon_error!void {
            self.*.__check_init.init();
            if (self.*.array == null or self.*.array.?.len == 0) {
                xfit.print_error("WARN vertice array 0 or null\n", .{});
                return error.is_not_polygon;
            }
            self.*.node.create_buffer(.{
                .len = @intCast(self.*.array.?.len * @sizeOf(vertexT)),
                .typ = .vertex,
                .use = _flag,
                .use_gcpu_mem = use_gcpu_mem,
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
            self.*.node.clean(null, {});
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            self.*.__check_init.deinit();
            self.*.node.clean(callback, self);
        }
        pub inline fn deinit_for_alloc(self: *Self) void {
            deinit(self);
            self.allocator.free(self.array.?);
        }
        pub inline fn deinit_for_alloc_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            deinit_callback(self, callback);
            self.allocator.free(self.array.?);
        }
        pub inline fn build_gcpu(self: *Self, _flag: write_flag) void {
            self.*.__build(_flag, true);
        }
        pub inline fn build(self: *Self, _flag: write_flag) void {
            self.*.__build(_flag, false);
        }
        pub fn __build(self: *Self, _flag: write_flag, comptime use_gcpu_mem: bool) void {
            self.*.__check_init.init();
            self.*.node.create_buffer(.{
                .len = @intCast(self.*.array.?.len * @sizeOf(idxT)),
                .typ = .index,
                .use = _flag,
                .use_gcpu_mem = use_gcpu_mem,
            }, mem.u8arrC(self.*.array.?));
        }

        ///write_flag가 cpu일때만 호출
        pub fn copy_update(self: *Self) void {
            self.*.node.copy_update(self.*.array.?.ptr);
        }
    };
}
//? uniform 속성 개체는 모두 크기가 작아서 use_gcpu_mem true 이다 기본으로
pub const projection = struct {
    const Self = @This();
    proj: matrix = undefined,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},
    __window_width: std.atomic.Value(f32) = undefined,
    __window_height: std.atomic.Value(f32) = undefined,

    pub inline fn refresh_window_width(self: *Self) void {
        self.*.__window_width.store(2.0 / self.*.proj.e[0][0], .monotonic);
    }
    pub inline fn refresh_window_height(self: *Self) void {
        self.*.__window_height.store(2.0 / self.*.proj.e[1][1], .monotonic);
    }
    pub inline fn window_width(self: Self) f32 {
        return self.__window_width.load(.monotonic);
    }
    pub inline fn window_height(self: Self) f32 {
        return self.__window_height.load(.monotonic);
    }
    pub inline fn init_matrix_orthographic(self: *Self, _width: f32, _height: f32) matrix_error!void {
        return init_matrix_orthographic2(self, _width, _height, 0.1, 100);
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
        self.*.__window_width.store(width * ratio, .monotonic);
        self.*.__window_height.store(height * ratio, .monotonic);
    }
    pub fn init_matrix_perspective(self: *Self, fov: f32) matrix_error!void {
        const ratio = @as(f32, @floatFromInt(window.window_width())) / @as(f32, @floatFromInt(window.window_height()));
        self.*.proj = try matrix.perspectiveFovLhVulkan(
            fov,
            ratio,
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
        self.*.__uniform.clean(null, {});
    }
    pub fn build(self: *Self, _flag: write_flag) void {
        self.*.__check_alloc.init(__system.allocator);
        self.*.__uniform.create_buffer_copy(.{
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
        self.*.__uniform.clean(null, {});
    }
    pub fn build(self: *Self) void {
        self.*.__uniform.create_buffer_copy(.{
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
        self.*.__uniform.clean(null, {});
    }
    pub fn build(self: *Self, _flag: write_flag) void {
        self.*.__check_alloc.init(__system.allocator);
        self.*.__uniform.create_buffer_copy(.{
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
    ///이 값 자체가 변경되면 iobject.update_uniforms 필요
    camera: *camera = undefined,
    ///이 값 자체가 변경되면 iobject.update_uniforms 필요
    projection: *projection = undefined,
    __model_uniform: vulkan_res_node(.buffer) = .{},

    __check_init: mem.check_init = .{},

    pub inline fn __deinit(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.__check_init.deinit();
        self.*.__model_uniform.clean(callback, self);
    }
    // inline fn get_mat_set_wh(self: *Self, _type: type) matrix {
    //     const e: *_type = @fieldParentPtr("transform", self);
    //     var mat = self.*.model;
    //     mat.e[0][0] *= @floatFromInt(e.*.src.*.width);
    //     mat.e[1][1] *= @floatFromInt(e.*.src.*.height);
    //     return mat;
    // }
    pub inline fn __build(self: *Self) void {
        self.*.__check_init.init();
        self.*.__model_uniform.create_buffer_copy(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = .cpu,
        }, mem.obj_to_u8arrC(&self.*.model));
    }
    ///write_flag가 readwrite_cpu일때만 호출
    pub fn copy_update(self: *Self) void {
        self.*.__check_init.check_inited();
        self.*.__model_uniform.copy_update(&self.*.model);
    }
};

pub const texture = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    pixels: ?[]u8 = undefined,
    sampler: vk.Sampler,
    __set: descriptor_set,
    __check_init: mem.check_init = .{},

    pub fn width(self: Self) u32 {
        return self.__image.texture_option.width;
    }
    pub fn height(self: Self) u32 {
        return self.__image.texture_option.height;
    }

    pub fn init() Self {
        return Self{
            .sampler = get_default_linear_sampler(),
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = single_sampler_pool_sizes[0..1],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout2,
            },
        };
    }
    pub inline fn build_gcpu(self: *Self, _width: u32, _height: u32, _pixels: ?[]u8) void {
        self.*.__build(_width, _height, _pixels, true);
    }
    pub inline fn build(self: *Self, _width: u32, _height: u32, _pixels: ?[]u8) void {
        self.*.__build(_width, _height, _pixels, false);
    }
    fn __build(self: *Self, _width: u32, _height: u32, _pixels: ?[]u8, comptime use_gcpu_mem: bool) void {
        self.__check_init.init();
        self.pixels = _pixels;
        self.__image.create_texture(.{
            .width = _width,
            .height = _height,
            .use_gcpu_mem = use_gcpu_mem,
        }, self.sampler, self.pixels.?);
        var __set_res: [1]res_union = .{.{ .tex = &self.__image }};
        self.__set.__res = __set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.__set)[0..1]);
    }

    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, self);
    }
    // pub fn copy(self: *Self, _data: []const u8, rect: ?math.recti) void {
    //     __vulkan_allocator.copy_texture(self, _data, rect);
    // }
};

pub inline fn get_default_quad_image_vertices() *vertices(tex_vertex_2d) {
    return &__vulkan.quad_image_vertices;
}
pub inline fn get_default_linear_sampler() vk.Sampler {
    return __vulkan.linear_sampler;
}
pub inline fn get_default_nearest_sampler() vk.Sampler {
    return __vulkan.nearest_sampler;
}

pub const texture_array = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    ///1차원 배열에 순차적으로 이미지 프레임 데이터들을 배치
    pixels: ?[]u8 = undefined,
    sampler: vk.Sampler,
    __set: descriptor_set,
    __check_init: mem.check_init = .{},

    pub fn get_tex_count_build(self: *Self) u32 {
        return self.*.__image.texture_option.len;
    }
    pub fn width(self: Self) u32 {
        return self.__image.texture_option.width;
    }
    pub fn height(self: Self) u32 {
        return self.__image.texture_option.height;
    }
    pub fn init() Self {
        return Self{
            .sampler = get_default_linear_sampler(),
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = single_sampler_pool_sizes[0..1],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout2,
            },
        };
    }
    pub inline fn build_gcpu(self: *Self, _width: u32, _height: u32, _frames: u32, _pixels: ?[]u8) void {
        self.*.__build(_width, _height, _frames, _pixels, true);
    }
    pub inline fn build(self: *Self, _width: u32, _height: u32, _frames: u32, _pixels: ?[]u8) void {
        self.*.__build(_width, _height, _frames, _pixels, false);
    }
    fn __build(self: *Self, _width: u32, _height: u32, _frames: u32, _pixels: ?[]u8, comptime use_gcpu_mem: bool) void {
        self.__check_init.init();
        self.pixels = _pixels;
        self.__image.create_texture(.{
            .width = _width,
            .height = _height,
            .len = _frames,
            .use_gcpu_mem = use_gcpu_mem,
        }, self.sampler, self.pixels.?);
        var __set_res: [1]res_union = .{.{ .tex = &self.__image }};
        self.__set.__res = __set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.__set)[0..1]);
    }

    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, self);
    }
};

pub const tile_texture_array = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    ///1차원 배열에 순차적으로 이미지 프레임 데이터들을 배치
    alloc_pixels: []u8 = undefined,
    sampler: vk.Sampler,
    __set: descriptor_set,
    __check_init: mem.check_init = .{},

    pub fn get_tex_count_build(self: Self) u32 {
        return self.__image.texture_option.len;
    }
    pub fn width(self: Self) u32 {
        return self.__image.texture_option.width;
    }
    pub fn height(self: Self) u32 {
        return self.__image.texture_option.height;
    }

    pub fn init() Self {
        return Self{
            .sampler = get_default_linear_sampler(),
            .__set = .{
                .bindings = single_pool_binding[0..1],
                .size = single_sampler_pool_sizes[0..1],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout2,
            },
        };
    }
    pub inline fn build_gcpu(self: *Self, tile_width: u32, tile_height: u32, tile_count: u32, _width: u32, pixels: []const u8, inout_alloc_pixels: []u8) void {
        self.*.__build(tile_width, tile_height, tile_count, _width, pixels, inout_alloc_pixels, true);
    }
    pub inline fn build(self: *Self, tile_width: u32, tile_height: u32, tile_count: u32, _width: u32, pixels: []const u8, inout_alloc_pixels: []u8) void {
        self.*.__build(tile_width, tile_height, tile_count, _width, pixels, inout_alloc_pixels, false);
    }
    pub fn __build(self: *Self, tile_width: u32, tile_height: u32, tile_count: u32, _width: u32, pixels: []const u8, inout_alloc_pixels: []u8, comptime use_gcpu_mem: bool) void {
        self.__check_init.init();
        self.alloc_pixels = inout_alloc_pixels;
        //tilemap pixel 형식 데이터를 tile image 들이 연속적으로 배치된 형식 데이터로 변환한다.
        var x: u32 = undefined;
        var y: u32 = 0;
        var h: u32 = undefined;
        var cnt: u32 = 0;
        const row: u32 = @divFloor(_width, tile_width);
        const col: u32 = @divFloor(tile_count, row);
        const bit = img_util.bit(.RGBA) >> 3;
        while (y < col) : (y += 1) {
            x = 0;
            while (x < row) : (x += 1) {
                h = 0;
                while (h < tile_height) : (h += 1) {
                    const start = cnt * (tile_width * tile_height * bit) + h * tile_width * bit;
                    const startp = (y * tile_height + h) * (_width * bit) + x * tile_width * bit;
                    @memcpy(self.alloc_pixels[start .. start + tile_width * bit], pixels[startp .. startp + tile_width * bit]);
                }
                cnt += 1;
            }
        }
        //
        self.__image.create_texture(.{
            .width = tile_width,
            .height = tile_height,
            .len = tile_count,
            .use_gcpu_mem = use_gcpu_mem,
        }, self.sampler, self.alloc_pixels);
        var __set_res: [1]res_union = .{.{ .tex = &self.__image }};
        self.__set.__res = __set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.__set)[0..1]);
    }

    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(null, {});
    }
    pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, self);
    }
};

pub const shape = shape_(true);
pub const pixel_shape = shape_(false);

pub const shape_source = struct {
    vertices: vertices(shape_color_vertex_2d),
    indices: indices32,
    color: vector = .{ 1, 1, 1, 1 },
    __uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,

    pub fn init() shape_source {
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
    pub fn init_for_alloc(__allocator: std.mem.Allocator) shape_source {
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
    pub fn build(self: *shape_source, _flag: write_flag, _color_flag: write_flag) void {
        if (self.*.vertices.array == null or self.*.vertices.array.?.len == 0) return;
        self.*.vertices.build(_flag) catch return;
        self.*.indices.build(_flag);

        self.*.__uniform.create_buffer(.{
            .len = @sizeOf(vector),
            .typ = .uniform,
            .use = _color_flag,
        }, mem.obj_to_u8arrC(&self.*.color));

        var __set_res: [1]res_union = .{
            .{ .buf = &self.*.__uniform },
        };
        self.*.__set.__res = __set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn deinit_callback(self: *shape_source, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.vertices.deinit();
        self.*.indices.deinit();
        self.*.__uniform.clean(callback, self);
    }
    pub fn deinit(self: *shape_source) void {
        self.*.vertices.deinit();
        self.*.indices.deinit();
        self.*.__uniform.clean(null, {});
    }
    pub fn deinit_for_alloc(self: *shape_source) void {
        self.*.vertices.deinit_for_alloc();
        self.*.indices.deinit_for_alloc();
        self.*.__uniform.clean(null, {});
    }
    pub fn deinit_for_alloc_callback(self: *shape_source, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.vertices.deinit_for_alloc();
        self.*.indices.deinit_for_alloc();
        self.*.__uniform.clean(callback, self);
    }
    ///write_flag가 cpu일때만 호출
    pub fn copy_color_update(self: *shape_source) void {
        self.*.__uniform.copy_update(&self.*.color);
    }
};

pub fn shape_(_msaa: bool) type {
    return struct {
        const Self = @This();

        transform: transform = .{ .parent_type = if (_msaa) ._shape else ._pixel_shape },
        src: *shape_source,
        extra_src: ?[]*shape_source = null,
        __set: descriptor_set,

        pub fn init(_src: *shape_source) Self {
            return .{
                .__set = .{
                    .bindings = single_pool_binding[0..1],
                    .size = transform_uniform_pool_sizes[0..1],
                    .layout = __vulkan.shape_color_2d_pipeline_set.descriptorSetLayout,
                },
                .src = _src,
            };
        }
        pub fn update_uniforms(self: *Self) void {
            var __set_res: [4]res_union = .{
                .{ .buf = &self.*.transform.__model_uniform },
                .{ .buf = &self.*.transform.camera.*.__uniform },
                .{ .buf = &self.*.transform.projection.*.__uniform },
                .{ .buf = &__vulkan.__pre_mat_uniform },
            };
            self.*.__set.__res = __set_res[0..4];
            __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
        }
        pub fn build(self: *Self) void {
            self.*.transform.__build();
            self.*.update_uniforms();
        }
        pub fn deinit(self: *Self) void {
            self.*.transform.__deinit(null);
        }
        pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
            self.*.transform.__deinit(callback);
        }
        pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
            self.*.transform.__check_init.check_inited();
            __vulkan.load_instance_and_device();
            for (&[_][]const *shape_source{ &[_]*shape_source{self.*.src}, self.*.extra_src orelse &[_]*shape_source{} }) |srcs| {
                for (srcs) |src| {
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
                    __vulkan.vkd.?.cmdDrawIndexed(
                        cmd,
                        src.*.indices.node.buffer_option.len / get_idx_type_size(self.*.src.*.indices.idx_type),
                        1,
                        0,
                        0,
                        0,
                    );

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
        }
    };
}

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
    src: *texture,
    color_tran: *color_transform,
    __set: descriptor_set,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null);
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.transform.__deinit(callback);
    }
    pub fn update_uniforms(self: *Self) void {
        var __set_res: [5]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &__vulkan.__pre_mat_uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
        };
        self.*.__set.__res = __set_res[0..5];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        self.*.update_uniforms();
    }
    pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
        self.*.transform.__check_init.check_inited();
        self.*.src.*.__check_init.check_inited();
        __vulkan.load_instance_and_device();
        __vulkan.vkd.?.cmdBindPipeline(cmd, .graphics, __vulkan.tex_2d_pipeline_set.pipeline);

        __vulkan.vkd.?.cmdBindDescriptorSets(
            cmd,
            .graphics,
            __vulkan.tex_2d_pipeline_set.pipelineLayout,
            0,
            2,
            &[_]vk.DescriptorSet{ self.*.__set.__set, self.*.src.*.__set.__set },
            0,
            null,
        );

        __vulkan.vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
    }
    pub fn init(_src: *texture) Self {
        const self = Self{
            .color_tran = color_transform.get_no_default(),
            .__set = .{
                .bindings = image_uniform_pool_binding[0..2],
                .size = image_uniform_pool_sizes[0..2],
                .layout = __vulkan.tex_2d_pipeline_set.descriptorSetLayout,
            },
            .src = _src,
        };
        return self;
    }
};
///회전 했을때 고려안함, img scale은 기본(이미지 크기) 비율일때 기준
pub fn pixel_perfect_point(img: anytype, _p: point, _canvas_w: f32, _canvas_h: f32, center: center_pt_pos) point {
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
pub const animate_image = struct {
    const Self = @This();

    transform: transform = .{ .parent_type = ._anim_image },

    src: *texture_array,
    color_tran: *color_transform,
    __frame_uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,
    frame: u32 = 0,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null);
        self.*.__frame_uniform.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.transform.__deinit(null);
        self.*.__frame_uniform.clean(callback, self);
    }
    pub fn next_frame(self: *Self) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
        if (self.*.src.*.__image.texture_option.len - 1 < self.*.frame) {
            self.*.frame = 0;
            return;
        }
        self.*.frame = (self.*.frame + 1) % self.*.src.*.get_tex_count_build();
        copy_update_frame(self);
    }
    pub fn prev_frame(self: *Self) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
        if (self.*.src.*.__image.__resource_len - 1 < self.*.frame) {
            self.*.frame = 0;
            return;
        }
        self.*.frame = if (self.*.frame > 0) (self.*.frame - 1) else (self.*.src.*.get_tex_count_build() - 1);
        copy_update_frame(self);
    }
    pub fn set_frame(self: *Self, _frame: u32) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
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
    pub fn update_uniforms(self: *Self) void {
        var __set_res: [6]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &__vulkan.__pre_mat_uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
            .{ .buf = &self.*.__frame_uniform },
        };
        self.*.__set.__res = __set_res[0..6];
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

        self.*.update_uniforms();
    }
    pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
        self.*.transform.__check_init.check_inited();
        self.*.src.*.__check_init.check_inited();
        __vulkan.load_instance_and_device();
        __vulkan.vkd.?.cmdBindPipeline(cmd, .graphics, __vulkan.animate_tex_2d_pipeline_set.pipeline);

        __vulkan.vkd.?.cmdBindDescriptorSets(
            cmd,
            .graphics,
            __vulkan.animate_tex_2d_pipeline_set.pipelineLayout,
            0,
            2,
            &[_]vk.DescriptorSet{ self.*.__set.__set, self.*.src.*.__set.__set },
            0,
            null,
        );

        __vulkan.vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
    }
    pub fn init(_src: *texture_array) Self {
        const self = Self{
            .color_tran = color_transform.get_no_default(),
            .__set = .{
                .bindings = animate_image_uniform_pool_binding[0..2],
                .size = animate_image_uniform_pool_sizes[0..2],
                .layout = __vulkan.animate_tex_2d_pipeline_set.descriptorSetLayout,
            },
            .src = _src,
        };
        return self;
    }
};
pub const tile_image = struct {
    const Self = @This();

    transform: transform = .{ .parent_type = ._tile_image },

    src: *tile_texture_array,
    color_tran: *color_transform,
    __tile_uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,
    tile_idx: u32 = undefined,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null);
        self.*.__tile_uniform.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void) void {
        self.*.transform.__deinit(null);
        self.*.__tile_uniform.clean(callback, self);
    }
    pub fn set_frame(self: *Self, _frame: u32) void {
        if (!self.*.__tile_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
        if (self.*.src.*.__image.__resource_len - 1 < _frame) {
            return;
        }
        self.*.tile_idx = _frame;
        copy_update_tile_idx(self);
    }
    pub fn copy_update_tile_idx(self: *Self) void {
        if (!self.*.__tile_uniform.is_build() or self.*.src.*.__image.texture_option.len == 0 or self.*.src.*.__image.texture_option.len - 1 < self.*.frame) return;
        const __idx_cpy: f32 = @floatFromInt(self.*.tile_idx);
        self.*.__tile_uniform.copy_update(&__idx_cpy);
    }
    pub fn update_uniforms(self: *Self) void {
        var __set_res: [6]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &__vulkan.__pre_mat_uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
            .{ .buf = &self.*.__tile_uniform },
        };
        self.*.__set.__res = __set_res[0..6];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        const __idx_cpy: f32 = @floatFromInt(self.*.tile_idx);
        self.*.__tile_uniform.create_buffer_copy(.{
            .len = @sizeOf(f32),
            .typ = .uniform,
            .use = .cpu,
        }, mem.obj_to_u8arrC(&__idx_cpy));

        self.*.update_uniforms();
    }
    pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
        self.*.transform.__check_init.check_inited();
        self.*.src.*.__check_init.check_inited();
        __vulkan.load_instance_and_device();
        __vulkan.vkd.?.cmdBindPipeline(cmd, .graphics, __vulkan.animate_tex_2d_pipeline_set.pipeline);

        __vulkan.vkd.?.cmdBindDescriptorSets(
            cmd,
            .graphics,
            __vulkan.animate_tex_2d_pipeline_set.pipelineLayout,
            0,
            2,
            &[_]vk.DescriptorSet{ self.*.__set.__set, self.*.src.*.__set.__set },
            0,
            null,
        );

        __vulkan.vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
    }
    pub fn init(_tile_idx: u32, _src: *tile_texture_array) Self {
        const self = Self{
            .color_tran = color_transform.get_no_default(),
            .__set = .{
                .bindings = animate_image_uniform_pool_binding[0..2],
                .size = animate_image_uniform_pool_sizes[0..2],
                .layout = __vulkan.animate_tex_2d_pipeline_set.descriptorSetLayout,
            },
            .tile_idx = _tile_idx,
            .src = _src,
        };
        return self;
    }
};
