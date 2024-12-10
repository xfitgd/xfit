const std = @import("std");

const system = @import("system.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");
const xfit = @import("xfit.zig");
const img_util = @import("image_util.zig");

const dbg = xfit.dbg;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

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

pub const shape_vertex_2d = extern struct {
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
        .cnt = 3,
    },
};
pub const image_uniform_pool_sizes: [2]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 3,
    },
    .{
        .typ = .uniform,
        .cnt = 1,
    },
};
pub const image_uniform_pool_binding: [2]c_uint = .{ 0, 3 };
pub const animate_image_uniform_pool_sizes: [2]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 3,
    },
    .{
        .typ = .uniform,
        .cnt = 2,
    },
};
pub const animate_image_uniform_pool_binding: [2]c_uint = .{ 0, 3 };
pub const tile_image_uniform_pool_sizes: [3]descriptor_pool_size = .{
    .{
        .typ = .uniform,
        .cnt = 3,
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
//pub const tile_image_uniform_pool_binding: [3]c_uint = .{ 0, 3, 4 };

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
    pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        switch (self.*) {
            inline else => |*case| case.*.deinit_callback(callback, data),
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
            inline ._button, ._pixel_button => |*case| &case.*.shape.transform,
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

        node: vulkan_res_node(.buffer) = .{},
        __check_init: mem.check_init = .{},

        pub fn init() Self {
            const self: Self = .{};
            return self;
        }
        pub inline fn deinit(self: *Self) void {
            self.*.__check_init.deinit();
            self.*.node.clean(null, {});
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
            self.*.__check_init.deinit();
            self.*.node.clean(callback, data);
        }
        pub inline fn build_gcpu(self: *Self, _array: []vertexT, _flag: write_flag) void {
            self.*.__build(_array, _flag, true);
        }
        pub inline fn build(self: *Self, _array: []vertexT, _flag: write_flag) void {
            self.*.__build(_array, _flag, false);
        }
        fn __build(self: *Self, _array: []vertexT, _flag: write_flag, comptime use_gcpu_mem: bool) void {
            self.*.__check_init.init();
            if (_array.len == 0) {
                xfit.herrm("empty vertices array!");
            }
            self.*.node.create_buffer_copy(.{
                .len = @intCast(_array.len * @sizeOf(vertexT)),
                .typ = .vertex,
                .use = _flag,
                .use_gcpu_mem = use_gcpu_mem,
            }, std.mem.sliceAsBytes(_array));
        }
        ///!call when write_flag is cpu
        pub fn copy_update(self: *Self, _array: []vertexT) void {
            self.*.node.copy_update(_array);
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
        __check_init: mem.check_init = .{},

        pub fn init() Self {
            var self: Self = .{};
            self.idx_type = _type;
            return self;
        }
        pub inline fn deinit(self: *Self) void {
            self.*.__check_init.deinit();
            self.*.node.clean(null, {});
        }
        pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
            self.*.__check_init.deinit();
            self.*.node.clean(callback, data);
        }
        pub inline fn build_gcpu(self: *Self, _array: []idxT, _flag: write_flag) void {
            self.*.__build(_array, _flag, true);
        }
        pub inline fn build(self: *Self, _array: []idxT, _flag: write_flag) void {
            self.*.__build(_array, _flag, false);
        }
        pub fn __build(self: *Self, _array: []idxT, _flag: write_flag, comptime use_gcpu_mem: bool) void {
            self.*.__check_init.init();
            self.*.node.create_buffer_copy(.{
                .len = @intCast(_array.len * @sizeOf(idxT)),
                .typ = .index,
                .use = _flag,
                .use_gcpu_mem = use_gcpu_mem,
            }, std.mem.sliceAsBytes(_array));
        }

        ///!call when write_flag is cpu
        pub fn copy_update(self: *Self, _array: []idxT) void {
            self.*.node.copy_update(_array);
        }
    };
}
//? uniform object is all small, so use_gcpu_mem is true by default
pub const projection = struct {
    const Self = @This();
    proj: matrix = undefined,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},
    __window_width: std.atomic.Value(f32) = undefined,
    __window_height: std.atomic.Value(f32) = undefined,

    pub inline fn refresh_window_width(self: *Self) void {
        self.*.__window_width.store(2.0 / self.*.proj[0][0], .monotonic);
    }
    pub inline fn refresh_window_height(self: *Self) void {
        self.*.__window_height.store(2.0 / self.*.proj[1][1], .monotonic);
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
        self.*.proj = try math.matrix_orthographicLhVulkan(
            f32,
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
        self.*.proj = try math.matrix_perspectiveFovLhVulkan(
            f32,
            fov,
            ratio,
            0.1,
            100,
        );
    }
    pub fn init_matrix_perspective2(self: *Self, fov: f32, near: f32, far: f32) matrix_error!void {
        self.*.proj = try math.matrix_perspectiveFovLhVulkan(
            f32,
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
        const mat = if (xfit.is_mobile) math.matrix_multiply(self.*.proj, __vulkan.rotate_mat) else self.*.proj;
        self.*.__uniform.create_buffer_copy(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = _flag,
        }, @as([*]const u8, @ptrCast(&mat))[0..@sizeOf(@TypeOf(mat))]);
    }
    ///!call when write_flag is cpu
    pub fn copy_update(self: *Self) void {
        const mat = if (xfit.is_mobile) math.matrix_multiply(self.*.proj, __vulkan.rotate_mat) else self.*.proj;
        self.*.__uniform.copy_update(&mat);
    }
};
pub const camera = struct {
    const Self = @This();
    view: matrix,
    __uniform: vulkan_res_node(.buffer) = .{},
    __check_alloc: mem.check_alloc = .{},

    /// w coordinate no need to care, call after system init
    pub fn init(eyepos: vector, focuspos: vector, updir: vector) Self {
        var res = Self{ .view = math.matrix_lookAtLh(f32, eyepos, focuspos, updir) };
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
        }, @as([*]const u8, @ptrCast(&self.*.view))[0..@sizeOf(@TypeOf(self.*.view))]);
    }
    ///!call when write_flag is cpu
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

    /// w coordinate no need to care, call after system init
    pub fn init() Self {
        const res = Self{ .color_mat = math.matrix_identity(f32) };
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
        }, @as([*]const u8, @ptrCast(&self.*.color_mat))[0..@sizeOf(@TypeOf(self.*.color_mat))]);
    }
    ///!call when write_flag is cpu
    pub fn copy_update(self: *Self) void {
        self.*.__check_alloc.check_inited();
        self.*.__uniform.copy_update(&self.*.color_mat);
    }
};

//transform is same as object, so no need to check_alloc separately
pub const transform = struct {
    const Self = @This();

    model: matrix = math.matrix_identity(f32),
    ///if this value itself changes, iobject.update_uniforms is needed
    camera: *camera = undefined,
    ///if this value itself changes, iobject.update_uniforms is needed
    projection: *projection = undefined,
    __model_uniform: vulkan_res_node(.buffer) = .{},

    __check_init: mem.check_init = .{},

    pub inline fn __deinit(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.__check_init.deinit();
        self.*.__model_uniform.clean(callback, data);
    }
    pub inline fn __build(self: *Self) void {
        self.*.__check_init.init();
        self.*.__model_uniform.create_buffer_copy(.{
            .len = @sizeOf(matrix),
            .typ = .uniform,
            .use = .cpu,
        }, @as([*]const u8, @ptrCast(&self.*.model))[0..@sizeOf(@TypeOf(self.*.model))]);
    }
    ///!call when write_flag is readwrite_cpu
    pub fn copy_update(self: *Self) void {
        self.*.__check_init.check_inited();
        self.*.__model_uniform.copy_update(&self.*.model);
    }
};

pub const texture = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    pixels: ?[]u8 = null,
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
    pub fn build(self: *Self, _width: u32, _height: u32, _pixels: ?[]u8) void {
        self.__check_init.init();
        self.pixels = _pixels;
        self.__image.create_texture(.{
            .width = _width,
            .height = _height,
            .use_gcpu_mem = false,
        }, self.sampler, self.pixels.?);
        var __set_res: [1]res_union = .{.{ .tex = &self.__image }};
        self.__set.__res = __set_res[0..1];
        __vulkan_allocator.update_descriptor_sets((&self.__set)[0..1]);
    }
    pub inline fn deinit(self: *Self) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, data);
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
    ///arrange image frame data in a one-dimensional array sequentially
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
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, data);
    }
};

pub const tile_texture_array = struct {
    const Self = @This();
    __image: vulkan_res_node(.texture) = .{},
    ///arrange image frame data in a one-dimensional array sequentially
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
        //convert tilemap pixel data format to tile image data format arranged sequentially
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
    pub inline fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.__check_init.deinit();
        self.*.__image.clean(callback, self, data);
    }
};

pub const shape = shape_(true);
pub const pixel_shape = shape_(false);

pub const shape_source = struct {
    pub const raw = struct {
        vertices: []vertices(shape_vertex_2d),
        indices: []indices32,
        __color_uniforms: []vulkan_res_node(.buffer),
        __color_sets: []descriptor_set,
    };
    __raw: ?raw,

    pub fn init() shape_source {
        return .{
            .__raw = null,
        };
    }
    pub fn build(self: *shape_source, _allocator: std.mem.Allocator, _raw: geometry.raw_shapes, _flag: write_flag, _color_flag: write_flag) !void {
        if (self.*.__raw != null) xfit.herrm("shape_source can't build twice!");
        if (!((_raw.vertices.len == _raw.indices.len) and (_raw.colors.len == _raw.indices.len))) xfit.herrm("shape_source build _raw.vertices.len != _raw.indices.len != _raw.colors.len!");

        var vert: ?[]vertices(shape_vertex_2d) = null;
        var ind: ?[]indices32 = null;
        var col_uniforms: ?[]vulkan_res_node(.buffer) = null;
        var col_sets: ?[]descriptor_set = null;
        errdefer {
            if (vert != null) _allocator.free(vert.?);
            if (ind != null) _allocator.free(ind.?);
            if (col_uniforms != null) _allocator.free(col_uniforms.?);
            if (col_sets != null) _allocator.free(col_sets.?);
        }
        vert = try _allocator.alloc(vertices(shape_vertex_2d), _raw.vertices.len);
        ind = try _allocator.alloc(indices32, _raw.indices.len);
        col_uniforms = try _allocator.alloc(vulkan_res_node(.buffer), _raw.colors.len);
        col_sets = try _allocator.alloc(descriptor_set, _raw.colors.len);

        self.*.__raw = .{
            .vertices = vert.?,
            .indices = ind.?,
            .__color_uniforms = col_uniforms.?,
            .__color_sets = col_sets.?,
        };
        @memset(self.*.__raw.?.__color_uniforms, .{});
        @memset(self.*.__raw.?.__color_sets, .{
            .bindings = single_pool_binding[0..1],
            .size = single_uniform_pool_sizes[0..1],
            .layout = __vulkan.quad_shape_2d_pipeline_set.descriptorSetLayout,
        });
        const ress = try _allocator.alloc([1]res_union, self.*.__raw.?.__color_sets.len);
        defer _allocator.free(ress);

        for (
            self.*.__raw.?.vertices,
            self.*.__raw.?.indices,
            self.*.__raw.?.__color_uniforms,
            self.*.__raw.?.__color_sets,
            _raw.vertices,
            _raw.indices,
            _raw.colors,
            ress,
        ) |*v, *i, *u, *s, vv, ii, cc, *r| {
            r.* = .{res_union{ .buf = u }};
            s.*.__res = r.*[0..r.*.len];
            v.* = vertices(shape_vertex_2d).init();
            i.* = indices32.init();
            v.*.build(vv, _flag);
            i.*.build(ii, _flag);
            u.*.create_buffer_copy(.{
                .len = @sizeOf(vector),
                .typ = .uniform,
                .use = _color_flag,
            }, @as([*]const u8, @ptrCast(&cc))[0..@sizeOf(@TypeOf(cc))]);
        }
        __vulkan_allocator.update_descriptor_sets(self.*.__raw.?.__color_sets);
    }
    const dealloc_struct = struct {
        self: *shape_source,
        allocator: std.mem.Allocator,
    };
    fn dealloc_callback(caller: *anyopaque) void {
        const ar: *dealloc_struct = @alignCast(@ptrCast(caller));
        const _allocator: std.mem.Allocator = ar.*.allocator;
        const self: *shape_source = ar.*.self;
        _allocator.free(self.*.__raw.?.vertices);
        _allocator.free(self.*.__raw.?.indices);

        _allocator.free(self.*.__raw.?.__color_uniforms);
        _allocator.free(self.*.__raw.?.__color_sets);

        __system.allocator.destroy(ar);
    }
    ///recommend using std.heap.ArenaAllocator instead.
    pub fn deinit_dealloc(self: *shape_source, _allocator: std.mem.Allocator) void {
        const s = __system.allocator.create(dealloc_struct) catch unreachable;
        s.*.self = self;
        s.*.allocator = _allocator;
        deinit_callback(
            self,
            dealloc_callback,
            s,
        );
    }
    pub fn deinit_callback(self: *shape_source, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        for (self.*.__raw.?.vertices, self.*.__raw.?.indices, self.*.__raw.?.__color_uniforms, 0..) |*v, *i, *u, idx| {
            v.*.deinit();
            i.*.deinit();
            if (idx < self.*.__raw.?.__color_uniforms.len - 1) {
                u.*.clean(null, {});
            } else {
                u.*.clean(callback, data);
            }
        }
    }
    pub fn deinit(self: *shape_source) void {
        for (self.*.__raw.?.vertices, self.*.__raw.?.indices, self.*.__raw.?.__color_uniforms) |*v, *i, *u| {
            v.*.deinit();
            i.*.deinit();
            u.*.clean(null, {});
        }
    }
    ///!call when write_flag is cpu
    pub fn copy_color_update(self: *shape_source, _start_idx: usize, colors: []const vector) void {
        for (self.*.__raw.?.__color_uniforms[_start_idx .. _start_idx + colors.len], colors) |*u, c| {
            u.*.copy_update(&c);
        }
    }
};

pub fn shape_(_msaa: bool) type {
    return struct {
        const Self = @This();

        transform: transform = .{},
        src: *shape_source,
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
            self.*.transform.__deinit(null, {});
        }
        pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
            self.*.transform.__deinit(callback, data);
        }
        pub fn __draw(self: *Self, cmd: vk.CommandBuffer) void {
            self.*.transform.__check_init.check_inited();
            __vulkan.load_instance_and_device();
            const raw = self.*.src.*.__raw.?;
            for (raw.vertices, raw.indices, raw.__color_sets) |v, i, s| {
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
                __vulkan.vkd.?.cmdBindVertexBuffers(cmd, 0, 1, @ptrCast(&v.node.res), @ptrCast(&offsets));

                __vulkan.vkd.?.cmdBindIndexBuffer(cmd, i.node.res, 0, .uint32);
                __vulkan.vkd.?.cmdDrawIndexed(
                    cmd,
                    i.node.buffer_option.len / get_idx_type_size(i.idx_type),
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
                    @ptrCast(&s.__set),
                    0,
                    null,
                );
                __vulkan.vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
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

    transform: transform = .{},
    src: *texture,
    color_tran: *color_transform,
    __set: descriptor_set,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.transform.__deinit(callback, data);
    }
    pub fn update_uniforms(self: *Self) void {
        var __set_res: [4]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
        };
        self.*.__set.__res = __set_res[0..4];
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
///!not consider rotation, img scale is based on default (image size) ratio
pub fn pixel_perfect_point(img: anytype, _p: point, _canvas_w: f32, _canvas_h: f32, center: center_pt_pos) point {
    const width = @as(f32, @floatFromInt(window.window_width()));
    const height = @as(f32, @floatFromInt(window.window_height()));
    if (width / height > _canvas_w / _canvas_h) { //not 1:1 ratio, can't apply
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

    transform: transform = .{},

    src: *texture_array,
    color_tran: *color_transform,
    __frame_uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,
    frame: u32 = 0,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null, {});
        self.*.__frame_uniform.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.transform.__deinit(null, {});
        self.*.__frame_uniform.clean(callback, data);
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
        if (self.*.src.*.__image.texture_option.len - 1 < self.*.frame) {
            self.*.frame = 0;
            return;
        }
        self.*.frame = if (self.*.frame > 0) (self.*.frame - 1) else (self.*.src.*.get_tex_count_build() - 1);
        copy_update_frame(self);
    }
    pub fn set_frame(self: *Self, _frame: u32) void {
        if (!self.*.__frame_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
        if (self.*.src.*.__image.texture_option.len - 1 < _frame) {
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
        var __set_res: [5]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
            .{ .buf = &self.*.__frame_uniform },
        };
        self.*.__set.__res = __set_res[0..5];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        const __frame_cpy: f32 = @floatFromInt(self.*.frame);
        self.*.__frame_uniform.create_buffer_copy(.{
            .len = @sizeOf(f32),
            .typ = .uniform,
            .use = .cpu,
        }, @as([*]const u8, @ptrCast(&__frame_cpy))[0..@sizeOf(@TypeOf(__frame_cpy))]);

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

    transform: transform = .{},

    src: *tile_texture_array,
    color_tran: *color_transform,
    __tile_uniform: vulkan_res_node(.buffer) = .{},
    __set: descriptor_set,
    tile_idx: u32 = undefined,

    pub fn deinit(self: *Self) void {
        self.*.transform.__deinit(null, {});
        self.*.__tile_uniform.clean(null, {});
    }
    pub fn deinit_callback(self: *Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
        self.*.transform.__deinit(null, {});
        self.*.__tile_uniform.clean(callback, data);
    }
    pub fn set_frame(self: *Self, _frame: u32) void {
        if (!self.*.__tile_uniform.is_build() or self.*.src.*.get_tex_count_build() == 0) return;
        if (self.*.src.*.__image.texture_option.len - 1 < _frame) {
            return;
        }
        self.*.tile_idx = _frame;
        copy_update_tile_idx(self);
    }
    pub fn copy_update_tile_idx(self: *Self) void {
        if (!self.*.__tile_uniform.is_build() or self.*.src.*.__image.texture_option.len == 0 or self.*.src.*.__image.texture_option.len - 1 < self.*.tile_idx) return;
        const __idx_cpy: f32 = @floatFromInt(self.*.tile_idx);
        self.*.__tile_uniform.copy_update(&__idx_cpy);
    }
    pub fn update_uniforms(self: *Self) void {
        var __set_res: [5]res_union = .{
            .{ .buf = &self.*.transform.__model_uniform },
            .{ .buf = &self.*.transform.camera.*.__uniform },
            .{ .buf = &self.*.transform.projection.*.__uniform },
            .{ .buf = &self.*.color_tran.*.__uniform },
            .{ .buf = &self.*.__tile_uniform },
        };
        self.*.__set.__res = __set_res[0..5];
        __vulkan_allocator.update_descriptor_sets((&self.*.__set)[0..1]);
    }
    pub fn build(self: *Self) void {
        self.*.transform.__build();

        const __idx_cpy: f32 = @floatFromInt(self.*.tile_idx);
        self.*.__tile_uniform.create_buffer_copy(.{
            .len = @sizeOf(f32),
            .typ = .uniform,
            .use = .cpu,
        }, @as([*]const u8, @ptrCast(&__idx_cpy))[0..@sizeOf(@TypeOf(__idx_cpy))]);

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
