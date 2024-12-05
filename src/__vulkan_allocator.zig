const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const MultiArrayList = std.MultiArrayList;
const MemoryPoolExtra = std.heap.MemoryPoolExtra;
const DoublyLinkedList = std.DoublyLinkedList;
const HashMap = std.AutoHashMap;

const __vulkan = @import("__vulkan.zig");
const xfit = @import("xfit.zig");
const vk = __vulkan.vk;
const __system = @import("__system.zig");
const system = @import("system.zig");
const math = @import("math.zig");
const mem = @import("mem.zig");
const graphics = @import("graphics.zig");

//16384*16384 = 256MB
pub var BLOCK_LEN: usize = 16384 * 16384;
pub var SPECIAL_BLOCK_LEN: usize = 16384 * 16384;
pub var FORMAT: texture_format = undefined;
pub var nonCoherentAtomSize: usize = 0;
pub var supported_cache_local: bool = false;
pub var supported_noncache_local: bool = false;

pub var execute_all_cmd_per_update: std.atomic.Value(bool) = std.atomic.Value(bool).init(true);
var arena_allocator: std.heap.ArenaAllocator = undefined;

pub fn init_block_len() void {
    var i: u32 = 0;
    var main_heap_idx: u32 = std.math.maxInt(u32);
    var change: bool = false;
    while (i < __vulkan.mem_prop.memory_heap_count) : (i += 1) {
        if (__vulkan.mem_prop.memory_heaps[i].flags.contains(.{ .device_local_bit = true })) {
            if (__vulkan.mem_prop.memory_heaps[i].size < 1024 * 1024 * 1024) {
                BLOCK_LEN /= 16;
                SPECIAL_BLOCK_LEN /= 16;
            } else if (__vulkan.mem_prop.memory_heaps[i].size < 2 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 8;
                SPECIAL_BLOCK_LEN /= 8;
            } else if (__vulkan.mem_prop.memory_heaps[i].size < 4 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 4;
                SPECIAL_BLOCK_LEN /= 4;
            } else if (__vulkan.mem_prop.memory_heaps[i].size < 8 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 2;
                SPECIAL_BLOCK_LEN /= 2;
            }
            change = true;
            xfit.print_log(
                "XFIT SYSLOG : vulkan Graphic Card Dedicated Memory Block {d}MB\n",
                .{BLOCK_LEN / 1024 / 1024},
            );
            main_heap_idx = i;
            break;
        }
    }
    if (!change) { //No Graphic Card Dedicated Memory
        if (__vulkan.mem_prop.memory_heaps[0].size < 2 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 16;
            SPECIAL_BLOCK_LEN /= 16;
        } else if (__vulkan.mem_prop.memory_heaps[0].size < 2 * 2 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 8;
            SPECIAL_BLOCK_LEN /= 8;
        } else if (__vulkan.mem_prop.memory_heaps[0].size < 2 * 4 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 4;
            SPECIAL_BLOCK_LEN /= 4;
        } else if (__vulkan.mem_prop.memory_heaps[0].size < 2 * 8 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 2;
            SPECIAL_BLOCK_LEN /= 2;
        }
        xfit.print_log(
            "XFIT SYSLOG : vulkan No Graphic Card Dedicated Memory Block {d}MB\n",
            .{BLOCK_LEN / 1024 / 1024},
        );
        main_heap_idx = 0;
    }
    const p: vk.PhysicalDeviceProperties = __vulkan.vki.?.getPhysicalDeviceProperties(__vulkan.vk_physical_device);
    nonCoherentAtomSize = @intCast(p.limits.non_coherent_atom_size);
    i = 0;
    while (i < __vulkan.mem_prop.memory_type_count) : (i += 1) {
        if (__vulkan.mem_prop.memory_types[i].property_flags.contains(.{
            .device_local_bit = true,
            .host_cached_bit = true,
            .host_visible_bit = true,
        })) {
            supported_cache_local = true;
            xfit.write_log("XFIT SYSLOG : vulkan supported_cache_local\n");
            if (main_heap_idx != __vulkan.mem_prop.memory_types[i].heap_index) { //if SPECIAL_BLOCK is not main memory (need test)
                SPECIAL_BLOCK_LEN /= @min(16, @max(1, (__vulkan.mem_prop.memory_heaps[main_heap_idx].size / __vulkan.mem_prop.memory_heaps[__vulkan.mem_prop.memory_types[i].heap_index].size)));
            }
        } else if (__vulkan.mem_prop.memory_types[i].property_flags.contains(.{
            .device_local_bit = true,
            .host_coherent_bit = true,
            .host_visible_bit = true,
        })) {
            supported_noncache_local = true;
            xfit.write_log("XFIT SYSLOG : vulkan supported_noncache_local\n");
            if (main_heap_idx != __vulkan.mem_prop.memory_types[i].heap_index) { //if SPECIAL_BLOCK is not main memory (need test)
                SPECIAL_BLOCK_LEN /= @min(16, @max(1, (__vulkan.mem_prop.memory_heaps[main_heap_idx].size / __vulkan.mem_prop.memory_heaps[__vulkan.mem_prop.memory_types[i].heap_index].size)));
            }
        }
    }
    if (!(supported_cache_local or supported_noncache_local)) {
        xfit.write_log("XFIT SYSLOG : vulkan not supported_(non)cache_local\n");
    }
}

const MAX_IDX_COUNT = 4;
pub const ERROR = error{device_memory_limit};

var buffers: MemoryPoolExtra(vulkan_res, .{}) = undefined;
var buffer_ids: ArrayList(*vulkan_res) = undefined;
var memory_idx_counts: []u16 = undefined;
var g_thread: std.Thread = undefined;
var op_queue: MultiArrayList(operation_node) = undefined;
var op_save_queue: MultiArrayList(operation_node) = undefined;
var op_map_queue: MultiArrayList(operation_node) = undefined;
var staging_buf_queue: MemoryPoolExtra(vulkan_res_node(.buffer), .{}) = undefined;
var mutex: std.Thread.Mutex = .{};
pub var submit_mutex: std.Thread.Mutex = .{};
var cond: std.Thread.Condition = .{};
var finish_cond: std.Thread.Condition = .{};
var finish_mutex: std.Thread.Mutex = .{};
var exited: bool = false;
var cmd: vk.CommandBuffer = undefined;
var cmd_pool: vk.CommandPool = undefined;
var descriptor_pools: HashMap([*]const descriptor_pool_size, ArrayList(descriptor_pool_memory)) = undefined;
var set_list: ArrayList(vk.WriteDescriptorSet) = undefined;

pub fn init() void {
    buffers = MemoryPoolExtra(vulkan_res, .{}).init(__system.allocator);
    buffer_ids = ArrayList(*vulkan_res).init(__system.allocator);
    memory_idx_counts = __system.allocator.alloc(u16, __vulkan.mem_prop.memory_type_count) catch |e| xfit.herr3("__vulkan_allocator init alloc memory_idx_counts", e);
    op_queue = MultiArrayList(operation_node){};
    op_save_queue = MultiArrayList(operation_node){};
    op_map_queue = MultiArrayList(operation_node){};
    staging_buf_queue = MemoryPoolExtra(vulkan_res_node(.buffer), .{}).init(__system.allocator);
    descriptor_pools = HashMap([*]const descriptor_pool_size, ArrayList(descriptor_pool_memory)).init(__system.allocator);
    set_list = ArrayList(vk.WriteDescriptorSet).init(__system.allocator);

    @memset(memory_idx_counts, 0);

    arena_allocator = std.heap.ArenaAllocator.init(__system.allocator);

    // ! use vk.VK_COMMAND_POOL_CREATE_TRANSIENT_BIT, android will crash(?)
    const poolInfo: vk.CommandPoolCreateInfo = .{
        .flags = .{},
        .queue_family_index = __vulkan.graphicsFamilyIndex,
    };
    cmd_pool = __vulkan.vkd.?.createCommandPool(&poolInfo, null) catch |e|
        xfit.herr3("__vulkan_allocator CreateCommandPool", e);

    const alloc_info: vk.CommandBufferAllocateInfo = .{
        .command_buffer_count = 1,
        .level = vk.CommandBufferLevel.primary,
        .command_pool = cmd_pool,
    };
    __vulkan.vkd.?.allocateCommandBuffers(&alloc_info, @ptrCast(&cmd)) catch |e|
        xfit.herr3("__vulkan_allocator allocateCommandBuffers", e);

    g_thread = std.Thread.spawn(.{}, thread_func, .{}) catch unreachable;
}

pub fn deinit() void {
    mutex.lock();
    exited = true;
    cond_cnt = true;
    cond.signal();
    mutex.unlock();
    g_thread.join();

    for (buffer_ids.items) |value| {
        value.*.deinit2(); // ! don't call vulkan_res.deinit separately
    }
    buffers.deinit();
    buffer_ids.deinit();
    __system.allocator.free(memory_idx_counts);
    op_queue.deinit(__system.allocator);
    op_save_queue.deinit(__system.allocator);
    op_map_queue.deinit(__system.allocator);
    staging_buf_queue.deinit();

    var it = descriptor_pools.valueIterator();
    while (it.next()) |v| {
        for (v.*.items) |i| {
            __vulkan.vkd.?.destroyDescriptorPool(i.pool, null);
        }
        v.*.deinit();
    }
    set_list.deinit();
    descriptor_pools.deinit();
    //arena_allocator.deinit();
    arena_allocator.deinit();

    __vulkan.vkd.?.destroyCommandPool(cmd_pool, null);
}

pub var POOL_BLOCK: c_uint = 256;

pub const res_type = enum { buffer, texture };
pub const res_range = opaque {};

pub inline fn ivulkan_res(_res_type: res_type) type {
    return switch (_res_type) {
        .buffer => vk.Buffer,
        .texture => vk.Image,
    };
}

pub const buffer_type = enum { vertex, index, uniform, staging };
pub const texture_type = enum { tex2d };
pub const texture_usage = packed struct {
    image_resource: bool = true,
    frame_buffer: bool = false,
    __input_attachment: bool = false,
    __transient_attachment: bool = false,
};
pub const res_usage = enum { gpu, cpu };

pub const buffer_create_option = struct {
    len: c_uint,
    typ: buffer_type,
    use: res_usage,
    single: bool = false,
    use_gcpu_mem: bool = false,
};

pub const texture_format = enum(c_uint) {
    default = 0,
    r8g8b8a8_unorm = @intFromEnum(vk.Format.r8g8b8a8_unorm),
    b8g8r8a8_unorm = @intFromEnum(vk.Format.b8g8r8a8_unorm),
    b8g8r8a8_srgb = @intFromEnum(vk.Format.b8g8r8a8_srgb),
    r8g8b8a8_srgb = @intFromEnum(vk.Format.r8g8b8a8_srgb),
    d24_unorm_s8_uint = @intFromEnum(vk.Format.d24_unorm_s8_uint),
    d32_sfloat_s8_uint = @intFromEnum(vk.Format.d32_sfloat_s8_uint),
    d16_unorm_s8_uint = @intFromEnum(vk.Format.d16_unorm_s8_uint),
    pub inline fn is_depth_format(fmt: texture_format) bool {
        return switch (fmt) {
            .d24_unorm_s8_uint => true,
            .d32_sfloat_s8_uint => true,
            .d16_unorm_s8_uint => true,
            else => false,
        };
    }
    pub inline fn __has(raw: vk.Format) ?texture_format {
        return switch (raw) {
            .r8g8b8a8_unorm, .b8g8r8a8_unorm, .b8g8r8a8_srgb, .r8g8b8a8_srgb, .d24_unorm_s8_uint, .d32_sfloat_s8_uint, .d16_unorm_s8_uint => |e| @enumFromInt(@as(c_uint, @intCast(@intFromEnum(e)))),
            else => null,
        };
    }
    pub inline fn __has_depth(raw: vk.Format) ?texture_format {
        return switch (raw) {
            .d24_unorm_s8_uint, .d32_sfloat_s8_uint, .d16_unorm_s8_uint => |e| @enumFromInt(@as(c_uint, @intCast(@intFromEnum(e)))),
            else => null,
        };
    }
    pub inline fn __has_color(raw: vk.Format) ?texture_format {
        return switch (raw) {
            .r8g8b8a8_unorm, .b8g8r8a8_unorm, .b8g8r8a8_srgb, .r8g8b8a8_srgb => |e| @enumFromInt(@as(c_uint, @intCast(@intFromEnum(e)))),
            else => null,
        };
    }
    pub inline fn __get(fmt: texture_format) vk.Format {
        return switch (fmt) {
            .default => __vulkan.format.format,
            inline else => |e| @enumFromInt(@as(i32, @intCast(@intFromEnum(e)))),
        };
    }
};

pub const texture_create_option = struct {
    len: c_uint = 1,
    width: c_uint,
    height: c_uint,
    typ: texture_type = .tex2d,
    tex_use: texture_usage = .{},
    use: res_usage = .gpu,
    format: texture_format = .default,
    samples: u8 = 1,
    single: bool = false,
    use_gcpu_mem: bool = false,
};

const operation_node = union(enum) {
    map_copy: struct {
        res: *vulkan_res,
        address: []const u8,
        ires: res_union,
    },
    copy_buffer: struct {
        src: *vulkan_res_node(.buffer),
        target: *vulkan_res_node(.buffer),
    },
    copy_buffer_to_image: struct {
        src: *vulkan_res_node(.buffer),
        target: *vulkan_res_node(.texture),
    },
    create_buffer: struct {
        buf: *vulkan_res_node(.buffer),
        data: ?[]const u8,
    },
    create_texture: struct {
        buf: *vulkan_res_node(.texture),
        data: ?[]const u8,
    },
    destroy_buffer: struct {
        buf: *vulkan_res_node(.buffer),
        callback: ?*const fn (callback_data: *anyopaque) void = null,
        callback_data: *anyopaque = undefined,
    },
    destroy_image: struct {
        buf: *vulkan_res_node(.texture),
        callback: ?*const fn (callback_data: *anyopaque) void = null,
        callback_data: *anyopaque = undefined,
    },
    __update_descriptor_sets: struct {
        sets: []descriptor_set,
    },
    ///user doesn't need to call
    __register_descriptor_pool: struct {
        __size: []descriptor_pool_size,
    },
    void: void,
};

pub const descriptor_pool_memory = struct {
    pool: vk.DescriptorPool,
    cnt: c_uint = 0,
};

pub const descriptor_type = enum(c_uint) {
    sampler = @intFromEnum(vk.DescriptorType.combined_image_sampler),
    uniform = @intFromEnum(vk.DescriptorType.uniform_buffer),
};

pub const descriptor_pool_size = struct {
    typ: descriptor_type,
    cnt: c_uint,
};

pub const res_union = union(enum) {
    buf: *vulkan_res_node(.buffer),
    tex: *vulkan_res_node(.texture),
    pub fn get_idx(self: res_union) *res_range {
        switch (self) {
            inline else => |case| return case.idx,
        }
    }
};

pub const descriptor_set = struct {
    layout: vk.DescriptorSetLayout,
    ///created inside update_descriptor_sets call
    __set: vk.DescriptorSet = .null_handle,
    size: []const descriptor_pool_size,
    bindings: []const c_uint,
    __res: []const res_union = undefined,
};

pub fn update_descriptor_sets(sets: []descriptor_set) void {
    append_op(.{ .__update_descriptor_sets = .{ .sets = sets } });
}

pub const frame_buffer = struct {
    res: vk.Framebuffer = .null_handle,

    pub fn create_no_async(self: *frame_buffer, texs: []*vulkan_res_node(.texture), __renderPass: vk.RenderPass) void {
        const attachments = __system.allocator.alloc(vk.ImageView, texs.len) catch xfit.herrm("create_no_async vk.ImageView alloc");
        defer __system.allocator.free(attachments);
        for (attachments, texs) |*v, t| {
            v.* = t.*.__image_view;
        }

        var frameBufferInfo: vk.FramebufferCreateInfo = .{
            .render_pass = __renderPass,
            .attachment_count = @intCast(texs.len),
            .p_attachments = attachments.ptr,
            .width = texs[0].*.texture_option.width,
            .height = texs[0].*.texture_option.height,
            .layers = 1,
        };

        __vulkan.load_instance_and_device();

        self.*.res = __vulkan.vkd.?.createFramebuffer(&frameBufferInfo, null) catch |e|
            xfit.herr3("__vulkan_allocator create_no_async createFramebuffer", e);
    }
    pub fn destroy_no_async(self: *frame_buffer) void {
        __vulkan.load_instance_and_device();
        __vulkan.vkd.?.destroyFramebuffer(self.*.res, null);
        self.*.res = .null_handle;
    }
};

fn execute_create_buffer(buf: *vulkan_res_node(.buffer), _data: ?[]const u8) void {
    if (buf.*.buffer_option.typ == .staging) {
        buf.*.buffer_option.use = .cpu;
        buf.*.buffer_option.single = false;
    }

    const prop: vk.MemoryPropertyFlags = switch (buf.*.buffer_option.use) {
        .gpu => .{ .device_local_bit = true },
        .cpu => .{ .host_cached_bit = true, .host_visible_bit = true },
    };
    const usage_: vk.BufferUsageFlags = switch (buf.*.buffer_option.typ) {
        .vertex => .{ .vertex_buffer_bit = true },
        .index => .{ .index_buffer_bit = true },
        .uniform => .{ .uniform_buffer_bit = true },
        .staging => .{ .transfer_src_bit = true },
    };
    var buf_info: vk.BufferCreateInfo = .{
        .size = buf.*.buffer_option.len,
        .usage = usage_,
        .sharing_mode = .exclusive,
    };
    var last: *vulkan_res_node(.buffer) = undefined;
    if (_data != null and buf.*.buffer_option.use == .gpu) {
        buf_info.usage = buf_info.usage.merge(.{ .transfer_dst_bit = true });
        if (buf.*.buffer_option.len > _data.?.len) {
            xfit.herr2("create_buffer _data not enough size. {d} {d} {}", .{ buf.*.buffer_option.len, _data.?.len, buf.*.builded });
        }
        last = staging_buf_queue.create() catch unreachable;
        last.* = .{};
        last.*.__create_buffer(.{
            .len = buf.*.buffer_option.len,
            .use = .cpu,
            .typ = .staging,
            .single = false,
            .use_gcpu_mem = !buf.*.buffer_option.single,
        }, _data);
    } else if (buf.*.buffer_option.typ == .staging) {
        if (_data == null) xfit.herrm("staging buffer data can't null");
    }
    buf.*.res = __vulkan.vkd.?.createBuffer(&buf_info, null) catch |e|
        xfit.herr3("execute_create_buffer vkCreateBuffer", e);

    var out_idx: *res_range = undefined;
    const res = if (buf.*.buffer_option.single) create_allocator_and_bind_single(buf.*.res) else create_allocator_and_bind(buf.*.res, prop, &out_idx, 0, buf.*.buffer_option.use_gcpu_mem);
    buf.*.pvulkan_buffer = res;
    buf.*.idx = out_idx;

    if (_data != null) {
        if (buf.*.buffer_option.use != .gpu) {
            append_op_save(.{
                .map_copy = .{
                    .res = res,
                    .address = _data.?,
                    .ires = .{ .buf = buf },
                },
            });
        } else {
            //above __create_buffer call, staging buffer is added and map_copy command is added.
            append_op_save(.{
                .copy_buffer = .{
                    .src = last,
                    .target = buf,
                },
            });
            append_op_save(.{
                .destroy_buffer = .{
                    .buf = last,
                },
            });
        }
    }
}
fn execute_destroy_buffer(buf: *vulkan_res_node(.buffer), callback: ?*const fn (caller: *anyopaque) void, caller: *anyopaque) void {
    buf.*.__destroy_buffer();
    if (callback != null) callback.?(caller);
}

pub fn bit_size(fmt: texture_format) c_uint {
    return switch (fmt) {
        .default => blk: {
            break :blk bit_size(texture_format.__has(__vulkan.format.format).?);
        },
        .r8g8b8a8_unorm => 4,
        .b8g8r8a8_unorm => 4,
        .b8g8r8a8_srgb => 4,
        .r8g8b8a8_srgb => 4,
        .d24_unorm_s8_uint => 4,
        .d32_sfloat_s8_uint => 5,
        .d16_unorm_s8_uint => 3,
    };
}

inline fn get_samples(samples: u8) vk.SampleCountFlags {
    return switch (samples) {
        2 => .{ .@"2_bit" = true },
        4 => .{ .@"4_bit" = true },
        8 => .{ .@"4_bit" = true },
        16 => .{ .@"16_bit" = true },
        32 => .{ .@"32_bit" = true },
        64 => .{ .@"64_bit" = true },
        else => .{ .@"1_bit" = true },
    };
}

fn execute_copy_buffer(src: *vulkan_res_node(.buffer), target: *vulkan_res_node(.buffer)) void {
    const copyRegion: vk.BufferCopy = .{ .size = target.*.buffer_option.len, .src_offset = 0, .dst_offset = 0 };
    __vulkan.vkd.?.cmdCopyBuffer(cmd, src.*.res, target.*.res, 1, @ptrCast(&copyRegion));
}
fn execute_copy_buffer_to_image(src: *vulkan_res_node(.buffer), target: *vulkan_res_node(.texture)) void {
    __vulkan.transition_image_layout(cmd, target.*.res, 1, 0, target.*.texture_option.len, .undefined, .transfer_dst_optimal);
    const region: vk.BufferImageCopy = .{
        .buffer_offset = 0,
        .buffer_row_length = 0,
        .buffer_image_height = 0,
        .image_offset = .{ .x = 0, .y = 0, .z = 0 },
        .image_extent = .{ .width = target.*.texture_option.width, .height = target.*.texture_option.height, .depth = 1 },
        .image_subresource = .{
            .aspect_mask = .{ .color_bit = true },
            .base_array_layer = 0,
            .mip_level = 0,
            .layer_count = target.*.texture_option.len,
        },
    };
    __vulkan.vkd.?.cmdCopyBufferToImage(cmd, src.*.res, target.*.res, .transfer_dst_optimal, 1, @ptrCast(&region));
    __vulkan.transition_image_layout(cmd, target.*.res, 1, 0, target.*.texture_option.len, .transfer_dst_optimal, .shader_read_only_optimal);
}
fn execute_create_texture(buf: *vulkan_res_node(.texture), _data: ?[]const u8) void {
    const prop: vk.MemoryPropertyFlags = switch (buf.*.texture_option.use) {
        .gpu => .{ .device_local_bit = true },
        .cpu => .{ .host_cached_bit = true, .host_visible_bit = true },
    };
    var usage_: vk.ImageUsageFlags = .{};
    const is_depth = buf.*.texture_option.format.is_depth_format();
    if (buf.*.texture_option.tex_use.image_resource) usage_ = usage_.merge(.{ .sampled_bit = true });
    if (buf.*.texture_option.tex_use.frame_buffer) {
        if (is_depth) {
            usage_ = usage_.merge(.{ .depth_stencil_attachment_bit = true });
        } else {
            usage_ = usage_.merge(.{ .color_attachment_bit = true });
        }
    }
    if (buf.*.texture_option.tex_use.__input_attachment) usage_ = usage_.merge(.{ .input_attachment_bit = true });
    if (buf.*.texture_option.tex_use.__transient_attachment) usage_ = usage_.merge(.{ .transient_attachment_bit = true });

    var tiling: vk.ImageTiling = .optimal;
    if (is_depth) out: {
        if (usage_.contains(.{ .depth_stencil_attachment_bit = true }) and !__vulkan.depth_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .sampled_bit = true }) and !__vulkan.depth_sample_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .transfer_src_bit = true }) and !__vulkan.depth_transfer_src_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .transfer_dst_bit = true }) and !__vulkan.depth_transfer_dst_optimal) {
            tiling = .linear;
            break :out;
        }
    } else out: {
        if (usage_.contains(.{ .color_attachment_bit = true }) and !__vulkan.color_attach_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .sampled_bit = true }) and !__vulkan.color_sample_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .transfer_src_bit = true }) and !__vulkan.color_transfer_src_optimal) {
            tiling = .linear;
            break :out;
        }
        if (usage_.contains(.{ .transfer_dst_bit = true }) and !__vulkan.color_transfer_dst_optimal) {
            tiling = .linear;
            break :out;
        }
    }

    const bit = bit_size(buf.*.texture_option.format);
    var img_info: vk.ImageCreateInfo = .{
        .array_layers = buf.*.texture_option.len,
        .usage = usage_,
        .sharing_mode = .exclusive,
        .extent = .{ .width = buf.*.texture_option.width, .height = buf.*.texture_option.height, .depth = 1 },
        .samples = get_samples(buf.*.texture_option.samples),
        .tiling = tiling,
        .mip_levels = 1,
        .format = buf.*.texture_option.format.__get(),
        .image_type = .@"2d",
        .initial_layout = .undefined,
    };
    var last: *vulkan_res_node(.buffer) = undefined;
    if (_data != null and buf.*.texture_option.use == .gpu) {
        img_info.usage = img_info.usage.merge(.{ .transfer_dst_bit = true });
        if (img_info.extent.width * img_info.extent.height * img_info.extent.depth * img_info.array_layers * bit > _data.?.len) {
            xfit.herrm("create_texture _data not enough size.");
        }

        last = staging_buf_queue.create() catch unreachable;
        last.* = .{};
        last.*.__create_buffer(.{
            .len = img_info.extent.width * img_info.extent.height * img_info.extent.depth * img_info.array_layers * bit,
            .use = .cpu,
            .typ = .staging,
            .single = false,
            .use_gcpu_mem = !buf.*.texture_option.single,
        }, _data);
    }
    buf.*.res = __vulkan.vkd.?.createImage(&img_info, null) catch |e| xfit.herr3("execute_create_texture vkCreateImage", e);

    var out_idx: *res_range = undefined;
    const res = if (buf.*.texture_option.single) create_allocator_and_bind_single(buf.*.res) else create_allocator_and_bind(buf.*.res, prop, &out_idx, 0, if (buf.*.texture_option.use == .gpu) false else buf.*.texture_option.use_gcpu_mem);
    buf.*.pvulkan_buffer = res;
    buf.*.idx = out_idx;

    const image_view_create_info: vk.ImageViewCreateInfo = .{
        .view_type = if (img_info.array_layers > 1) .@"2d_array" else .@"2d",
        .format = img_info.format,
        .components = .{ .r = vk.ComponentSwizzle.identity, .g = vk.ComponentSwizzle.identity, .b = vk.ComponentSwizzle.identity, .a = vk.ComponentSwizzle.identity },
        .image = buf.*.res,
        .subresource_range = .{
            .aspect_mask = if (is_depth) .{ .depth_bit = true, .stencil_bit = true } else .{ .color_bit = true },
            .base_mip_level = 0,
            .level_count = 1,
            .base_array_layer = 0,
            .layer_count = img_info.array_layers,
        },
    };
    buf.*.__image_view = __vulkan.vkd.?.createImageView(&image_view_create_info, null) catch |e| xfit.herr3("execute_create_texture createImageView", e);

    if (_data != null) {
        if (buf.*.texture_option.use != .gpu) {
            append_op_save(.{
                .map_copy = .{
                    .res = res,
                    .address = _data.?,
                    .ires = .{ .tex = buf },
                },
            });
        } else {
            //above __create_buffer call, staging buffer is added and map_copy command is added.
            append_op_save(.{
                .copy_buffer_to_image = .{
                    .src = last,
                    .target = buf,
                },
            });
            append_op_save(.{
                .destroy_buffer = .{
                    .buf = last,
                },
            });
        }
    }
}
fn execute_destroy_image(buf: *vulkan_res_node(.texture), callback: ?*const fn (caller: *anyopaque) void, caller: *anyopaque) void {
    buf.*.__destroy_image();
    if (callback != null) callback.?(caller);
}

fn execute_register_descriptor_pool(__size: []descriptor_pool_size) void {
    _ = __size;
    //TODO execute_register_descriptor_pool
}
fn __create_descriptor_pool(size: []const descriptor_pool_size, out: *descriptor_pool_memory) void {
    const pool_size = __system.allocator.alloc(vk.DescriptorPoolSize, size.len) catch xfit.herrm("execute_update_descriptor_sets vk.DescriptorPoolSize alloc");
    defer __system.allocator.free(pool_size);
    for (size, pool_size) |e, *p| {
        p.*.descriptor_count = e.cnt * POOL_BLOCK;
        p.*.type = @enumFromInt(@as(std.meta.Tag(@TypeOf(p.*.type)), @intCast(@intFromEnum(e.typ))));
    }
    const pool_info: vk.DescriptorPoolCreateInfo = .{
        .pool_size_count = @intCast(pool_size.len),
        .p_pool_sizes = pool_size.ptr,
        .max_sets = POOL_BLOCK,
    };
    out.*.pool = __vulkan.vkd.?.createDescriptorPool(&pool_info, null) catch |e| xfit.herr3("__create_descriptor_pool createDescriptorPool", e);
}
fn execute_update_descriptor_sets(sets: []descriptor_set) void {
    for (sets) |*v| {
        if (v.*.__set == .null_handle) {
            const pool = descriptor_pools.getPtr(v.*.size.ptr) orelse blk: {
                const res = descriptor_pools.getOrPut(v.*.size.ptr) catch unreachable;
                res.value_ptr.* = ArrayList(descriptor_pool_memory).init(__system.allocator);
                res.value_ptr.*.append(.{ .pool = undefined, .cnt = 0 }) catch unreachable;
                const last = &res.value_ptr.*.items[0];
                __create_descriptor_pool(v.*.size, last);

                break :blk res.value_ptr;
            };
            var last = &pool.*.items[pool.*.items.len - 1];
            if (last.*.cnt >= POOL_BLOCK) {
                pool.*.append(.{ .pool = undefined, .cnt = 0 }) catch unreachable;
                last = &pool.*.items[pool.*.items.len - 1];
                __create_descriptor_pool(v.*.size, last);
            }
            last.*.cnt += 1;
            const alloc_info: vk.DescriptorSetAllocateInfo = .{
                .descriptor_pool = last.*.pool,
                .descriptor_set_count = 1,
                .p_set_layouts = @ptrCast(&v.*.layout),
            };
            __vulkan.vkd.?.allocateDescriptorSets(&alloc_info, @ptrCast(&v.*.__set)) catch |e| xfit.herr3("execute_update_descriptor_sets allocateDescriptorSets", e);
        }

        var buf_cnt: usize = 0;
        var img_cnt: usize = 0;
        //v.res array must match v.size configuration.
        for (v.__res) |r| {
            if (r == .buf) {
                buf_cnt += 1;
            } else if (r == .tex) {
                img_cnt += 1;
            }
        }
        const bufs = arena_allocator.allocator().alloc(vk.DescriptorBufferInfo, buf_cnt) catch unreachable;
        const imgs = arena_allocator.allocator().alloc(vk.DescriptorImageInfo, img_cnt) catch unreachable;
        buf_cnt = 0;
        img_cnt = 0;
        for (v.__res) |r| {
            if (r == .buf) {
                bufs[buf_cnt] = .{
                    .buffer = r.buf.*.res,
                    .offset = 0,
                    .range = r.buf.*.buffer_option.len,
                };
                buf_cnt += 1;
            } else if (r == .tex) {
                imgs[img_cnt] = .{
                    .image_layout = .shader_read_only_optimal,
                    .image_view = r.tex.*.__image_view,
                    .sampler = r.tex.*.sampler,
                };
                img_cnt += 1;
            }
        }
        buf_cnt = 0;
        img_cnt = 0;
        for (v.size, v.bindings) |s, b| {
            switch (s.typ) {
                .sampler => |e| {
                    set_list.append(.{
                        .dst_set = v.__set,
                        .dst_binding = b,
                        .dst_array_element = 0,
                        .descriptor_count = s.cnt,
                        .descriptor_type = @enumFromInt(@as(std.meta.Tag(vk.DescriptorType), @intCast(@intFromEnum(e)))),
                        .p_buffer_info = null,
                        .p_image_info = imgs[(img_cnt)..(img_cnt + s.cnt)].ptr,
                        .p_texel_buffer_view = null,
                    }) catch unreachable;
                    img_cnt += s.cnt;
                },
                .uniform => |e| {
                    set_list.append(.{
                        .dst_set = v.__set,
                        .dst_binding = b,
                        .dst_array_element = 0,
                        .descriptor_count = s.cnt,
                        .descriptor_type = @enumFromInt(@as(std.meta.Tag(vk.DescriptorType), @intCast(@intFromEnum(e)))),
                        .p_buffer_info = bufs[(buf_cnt)..(buf_cnt + s.cnt)].ptr,
                        .p_image_info = null,
                        .p_texel_buffer_view = null,
                    }) catch unreachable;
                    buf_cnt += s.cnt;
                },
            }
        }
    }
}

fn save_to_map_queue(nres: *?*vulkan_res) void {
    var i: usize = 0;
    const slice = op_save_queue.slice();
    const tags = slice.items(.tags);
    const data = slice.items(.data);
    while (i < op_save_queue.len) : (i += 1) {
        switch (tags[i]) {
            .map_copy => {
                if (nres.* == null) {
                    op_map_queue.append(__system.allocator, .{ .map_copy = data[i].map_copy }) catch unreachable;
                    nres.* = data[i].map_copy.res;
                    tags[i] = .void;
                } else {
                    if (data[i].map_copy.res == nres.*.?) {
                        op_map_queue.append(__system.allocator, .{ .map_copy = data[i].map_copy }) catch unreachable;
                        tags[i] = .void;
                    }
                }
            },
            else => {},
        }
    }
}

fn thread_func() void {
    __vulkan.load_instance_and_device();
    while (true) {
        mutex.lock();

        while (cond_cnt == false) cond.wait(&mutex);
        cond_cnt = false;
        if (exited and op_queue.len == 0) {
            finish_cond.broadcast();
            mutex.unlock();
            break;
        }
        if (op_queue.len > 0) {
            op_save_queue.deinit(__system.allocator);
            op_save_queue = op_queue;
            op_queue = .{};
        } else {
            mutex.unlock();
            continue;
        }
        mutex.unlock();

        op_map_queue.resize(__system.allocator, 0) catch unreachable;
        var nres: ?*vulkan_res = null;
        {
            var i: usize = 0;
            var slice = op_save_queue.slice();
            while (i < op_save_queue.len) : (i += 1) {
                const tags = slice.items(.tags);
                const data = slice.items(.data);
                switch (tags[i]) {
                    //create.. execution, map_copy command can be added.
                    .create_buffer => execute_create_buffer(data[i].create_buffer.buf, data[i].create_buffer.data),
                    .create_texture => execute_create_texture(data[i].create_texture.buf, data[i].create_texture.data),
                    .__register_descriptor_pool => execute_register_descriptor_pool(data[i].__register_descriptor_pool.__size),
                    else => {
                        continue;
                    },
                }
                slice = op_save_queue.slice(); //if elements are added during execution, the memory may change
                slice.set(i, .{ .void = {} });
            }
        }
        save_to_map_queue(&nres);

        while (op_map_queue.len > 0) {
            nres.?.*.map_copy_execute(op_map_queue.items(.data));

            op_map_queue.resize(__system.allocator, 0) catch unreachable;
            nres = null;
            save_to_map_queue(&nres);
        }

        var have_cmd: bool = false;
        {
            var i: usize = 0;
            const slice = op_save_queue.slice();
            const tags = slice.items(.tags);
            //const data = slice.items(.data);
            while (i < op_save_queue.len) : (i += 1) {
                switch (tags[i]) {
                    .copy_buffer, .copy_buffer_to_image, .__update_descriptor_sets => {
                        have_cmd = true;
                        break;
                    },
                    else => continue,
                }
            }
        }
        if (have_cmd) {
            submit_mutex.lock();
            __vulkan.vkd.?.resetCommandPool(cmd_pool, .{}) catch |e| xfit.herr3("__vulkan_allocator thread_func.resetCommandPool", e);

            const begin: vk.CommandBufferBeginInfo = .{ .flags = .{ .one_time_submit_bit = true } };
            __vulkan.vkd.?.beginCommandBuffer(cmd, &begin) catch |e| xfit.herr3("__vulkan_allocator thread_func.beginCommandBuffer", e);

            var i: usize = 0;
            const slice = op_save_queue.slice();
            const tags = slice.items(.tags);
            const data = slice.items(.data);
            while (i < op_save_queue.len) : (i += 1) {
                switch (tags[i]) {
                    .copy_buffer => execute_copy_buffer(data[i].copy_buffer.src, data[i].copy_buffer.target),
                    .copy_buffer_to_image => execute_copy_buffer_to_image(data[i].copy_buffer_to_image.src, data[i].copy_buffer_to_image.target),
                    .__update_descriptor_sets => {
                        execute_update_descriptor_sets(data[i].__update_descriptor_sets.sets);
                        continue;
                    },
                    else => continue,
                }
                tags[i] = .void;
            }
            if (set_list.items.len > 0) {
                __vulkan.vkd.?.updateDescriptorSets(@intCast(set_list.items.len), set_list.items.ptr, 0, null);
                set_list.resize(0) catch unreachable;
            }
            __vulkan.vkd.?.endCommandBuffer(cmd) catch |e| xfit.herr3("__vulkan_allocator thread_func.endCommandBuffer", e);
            const submitInfo: vk.SubmitInfo = .{
                .command_buffer_count = 1,
                .p_command_buffers = @ptrCast(&cmd),
            };

            __vulkan.vkd.?.queueSubmit(__vulkan.vkGraphicsQueue, 1, @ptrCast(&submitInfo), .null_handle) catch |e| xfit.herr3("__vulkan_allocator thread_func.queueSubmit", e);
            submit_mutex.unlock();

            __vulkan.vkd.?.queueWaitIdle(__vulkan.vkGraphicsQueue) catch |e| xfit.herr3("__vulkan_allocator thread_func.queueWaitIdle", e);
        }

        if (!arena_allocator.reset(.retain_capacity)) unreachable;

        {
            var i: usize = 0;
            const slice = op_save_queue.slice();
            const tags = slice.items(.tags);
            const data = slice.items(.data);
            while (i < op_save_queue.len) : (i += 1) {
                switch (tags[i]) {
                    //destroy.. call later
                    .destroy_buffer => execute_destroy_buffer(data[i].destroy_buffer.buf, data[i].destroy_buffer.callback, data[i].destroy_buffer.callback_data),
                    .destroy_image => execute_destroy_image(data[i].destroy_image.buf, data[i].destroy_image.callback, data[i].destroy_image.callback_data),
                    else => continue,
                }
            }
        }

        mutex.lock();
        if (exited) {
            finish_cond.broadcast();
            mutex.unlock();
            break;
        }
        finish_cond.broadcast();
        mutex.unlock();

        if (!staging_buf_queue.reset(.retain_capacity)) unreachable;
        op_save_queue.resize(__system.allocator, 0) catch unreachable;
    }
}

var cond_cnt: bool = false;
//var finishcond_cnt: bool = false;

pub fn execute_and_wait_all_op() void {
    mutex.lock();
    if (op_queue.len > 0) {
        cond.signal();
        cond_cnt = true;
        finish_cond.wait(&mutex);
    }
    mutex.unlock();
}
pub fn execute_all_op() void {
    mutex.lock();
    if (op_queue.len > 0) {
        cond.signal();
        cond_cnt = true;
    }
    mutex.unlock();
}

// fn broadcast_op_finish() void {
//     mutex.lock();
//     finish_cond.broadcast();
//     mutex.unlock();
// }

fn find_memory_type(_type_filter: u32, _prop: vk.MemoryPropertyFlags) ?u32 {
    var i: u32 = 0;
    while (i < __vulkan.mem_prop.memory_type_count) : (i += 1) {
        if ((_type_filter & (@as(u32, 1) << @intCast(i)) != 0) and (__vulkan.mem_prop.memory_types[i].property_flags.contains(_prop))) {
            return i;
        }
    }
    return null;
}

fn append_op(node: operation_node) void {
    mutex.lock();
    defer mutex.unlock();

    if (node == .__update_descriptor_sets) {
        for (node.__update_descriptor_sets.sets) |*v| {
            v.*.__res = @constCast(arena_allocator.allocator().dupe(res_union, v.*.__res) catch unreachable);
        }
    }
    op_queue.append(__system.allocator, node) catch xfit.herrm("self.op_queue.append");
    // if (self.op_queue.items.len == 12) {
    //     unreachable;
    // }
}
fn append_op_save(node: operation_node) void {
    op_save_queue.append(__system.allocator, node) catch xfit.herrm("self.op_save_queue.append");
}

pub fn vulkan_res_node(_res_type: res_type) type {
    return struct {
        const vulkan_res_node_Self = @This();

        builded: bool = false,
        res: ivulkan_res(_res_type) = .null_handle,
        idx: *res_range = undefined,
        pvulkan_buffer: ?*vulkan_res = null,
        __image_view: if (_res_type == .texture) vk.ImageView else void = if (_res_type == .texture) undefined,
        sampler: if (_res_type == .texture) vk.Sampler else void = if (_res_type == .texture) .null_handle,
        texture_option: if (_res_type == .texture) texture_create_option else void = if (_res_type == .texture) undefined,
        buffer_option: if (_res_type == .buffer) buffer_create_option else void = if (_res_type == .buffer) undefined,

        pub inline fn is_build(self: *vulkan_res_node_Self) bool {
            return self.*.res != .null_handle;
        }
        pub fn create_buffer(self: *vulkan_res_node_Self, option: buffer_create_option, _data: ?[]const u8) void {
            if (_res_type == .buffer) {
                self.*.buffer_option = option;
                self.*.builded = true;
                append_op(.{ .create_buffer = .{ .buf = self, .data = _data } });
            } else {
                @compileError("_res_type need buffer");
            }
        }
        pub fn create_buffer_copy(self: *vulkan_res_node_Self, option: buffer_create_option, _data: []const u8) void {
            if (_res_type == .buffer) {
                self.*.buffer_option = option;
                self.*.builded = true;
                const map_data = arena_allocator.allocator().dupe(u8, _data) catch unreachable;
                append_op(.{ .create_buffer = .{ .buf = self, .data = map_data } });
            } else {
                @compileError("_res_type need buffer");
            }
        }
        pub fn create_texture(self: *vulkan_res_node_Self, option: texture_create_option, _sampler: vk.Sampler, _data: ?[]const u8) void {
            if (_res_type == .texture) {
                self.*.sampler = _sampler;
                self.*.texture_option = option;
                self.*.builded = true;
                append_op(.{ .create_texture = .{ .buf = self, .data = _data } });
            } else {
                @compileError("_res_type need image");
            }
        }
        pub fn create_texture_copy(self: *vulkan_res_node_Self, option: texture_create_option, _sampler: vk.Sampler, _data: []const u8) void {
            if (_res_type == .texture) {
                self.*.sampler = _sampler;
                self.*.texture_option = option;
                self.*.builded = true;
                const map_data = arena_allocator.allocator().dupe(u8, _data) catch unreachable;
                append_op(.{ .create_texture = .{ .buf = self, .data = map_data, .allocated = true } });
            } else {
                @compileError("_res_type need image");
            }
        }
        fn __create_buffer(self: *vulkan_res_node_Self, option: buffer_create_option, _data: ?[]const u8) void {
            if (_res_type == .buffer) {
                self.*.buffer_option = option;
                self.*.builded = true;
                execute_create_buffer(self, _data);
            } else {
                @compileError("_res_type need buffer");
            }
        }
        fn __destroy_buffer(self: *vulkan_res_node_Self) void {
            if (_res_type == .buffer) {
                if (self.*.pvulkan_buffer != null) self.*.pvulkan_buffer.?.*.unbind_res(self.*.res, self.*.idx);
                self.*.res = .null_handle;
            } else {
                @compileError("_res_type need buffer");
            }
        }
        fn __destroy_image(self: *vulkan_res_node_Self) void {
            if (_res_type == .texture) {
                __vulkan.vkd.?.destroyImageView(self.*.__image_view, null);
                if (self.*.pvulkan_buffer != null) self.*.pvulkan_buffer.?.*.unbind_res(self.*.res, self.*.idx);
                self.*.res = .null_handle;
            } else {
                @compileError("_res_type need image");
            }
        }
        fn map_copy(self: *vulkan_res_node_Self, _out_data: []const u8) void {
            if (self.*.pvulkan_buffer == null) return;
            if (_res_type == .buffer) {
                append_op(.{
                    .map_copy = .{
                        .res = self.*.pvulkan_buffer.?,
                        .ires = .{ .buf = self },
                        .address = _out_data,
                    },
                });
            } else if (_res_type == .texture) {
                append_op(.{
                    .map_copy = .{
                        .res = self.*.pvulkan_buffer.?,
                        .ires = .{ .tex = self },
                        .address = _out_data,
                    },
                });
            } else {
                @compileError("_res_type invaild");
            }
        }
        // pub inline fn unmap(self: *vulkan_res_node_Self) void {
        //     self.*.pvulkan_buffer.?.*.unmap();
        // }
        // pub inline fn map_update(self: *vulkan_res_node_Self, _data: anytype) void {
        //     var data: ?*anyopaque = undefined;
        //     self.*.pvulkan_buffer.?.*.map(self.*.idx, &data);
        //     const u8data = mem.obj_to_u8arrC(_data);
        //     @memcpy(@as([*]u8, @ptrCast(data.?))[0..u8data.len], u8data);
        //     self.*.pvulkan_buffer.?.*.unmap();
        // }
        ///! unlike copy_update, _data cannot be a temporary variable.
        pub fn map_update(self: *vulkan_res_node_Self, _data: anytype) void {
            const u8data = mem.obj_to_u8arrC(_data);
            self.*.map_copy(u8data);
        }
        pub fn copy_update(self: *vulkan_res_node_Self, _data: anytype) void {
            const u8data = mem.obj_to_u8arrC(_data);

            const map_data = arena_allocator.allocator().dupe(u8, u8data) catch unreachable;

            self.*.map_copy(map_data);
        }
        pub fn clean(self: *vulkan_res_node_Self, callback: ?*const fn (caller: *anyopaque) void, data: anytype) void {
            self.*.builded = false;

            switch (_res_type) {
                .texture => {
                    self.*.texture_option.len = 0;
                    if (self.*.pvulkan_buffer == null) {
                        __vulkan.vkd.?.destroyImageView(self.*.__image_view, null);
                    } else {
                        append_op(.{ .destroy_image = .{
                            .buf = self,
                            .callback = callback,
                            .callback_data = if (@TypeOf(data) != void) @ptrCast(data) else undefined,
                        } });
                    }
                },
                .buffer => {
                    self.*.buffer_option.len = 0;
                    append_op(.{ .destroy_buffer = .{
                        .buf = self,
                        .callback = callback,
                        .callback_data = if (@TypeOf(data) != void) @ptrCast(data) else undefined,
                    } });
                },
            }
        }
    };
}

const vulkan_res = struct {
    const node = packed struct {
        size: usize,
        idx: usize,
        free: bool,
    };

    cell_size: usize,
    map_start: usize = 0,
    map_size: usize = 0,
    map_data: [*]u8 = undefined,
    len: usize,
    cur: *DoublyLinkedList(node).Node = undefined,
    mem: vk.DeviceMemory,
    info: vk.MemoryAllocateInfo,
    single: bool = false, //single is true, always device memory
    cached: bool = false,
    pool: MemoryPoolExtra(DoublyLinkedList(node).Node, .{}) = undefined,
    list: DoublyLinkedList(node) = undefined,

    ///! don't call vulkan_res.deinit2 separately
    fn deinit2(self: *vulkan_res) void {
        __vulkan.load_instance_and_device();
        __vulkan.vkd.?.freeMemory(self.*.mem, null);
        if (!self.*.single) {
            self.*.pool.deinit();
        }
    }
    fn map_copy_execute(self: *vulkan_res, nodes: anytype) void {
        var start: usize = std.math.maxInt(usize);
        var end: usize = std.math.minInt(usize);

        var off_idx: usize = 0;
        var ranges: []vk.MappedMemoryRange = undefined;
        if (self.*.cached) {
            ranges = arena_allocator.allocator().alignedAlloc(vk.MappedMemoryRange, @alignOf(vk.MappedMemoryRange), nodes.len) catch unreachable;

            for (nodes, ranges) |copy, *r| {
                const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.map_copy.ires.get_idx()));
                r.memory = self.*.mem;
                r.size = nd.*.data.size * self.*.cell_size;
                r.offset = nd.*.data.idx * self.*.cell_size;
                const temp = r.offset;
                r.offset = math.floor_up(r.offset, nonCoherentAtomSize);
                r.size += temp - r.offset;
                r.size = math.ceil_up(r.size, nonCoherentAtomSize);
                start = @min(start, r.offset);
                end = @max(end, r.offset + r.size);
                //when range overlaps, merge them.
                for (ranges[0..off_idx]) |*t| {
                    if (t.offset < r.offset + r.size and t.offset + t.size > r.offset) {
                        const end_ = @max(r.offset + r.size, t.offset + t.size);
                        t.offset = @min(r.offset, t.offset);
                        t.size = end_ - t.offset;
                        for (ranges[0..off_idx]) |*t2| {
                            if (t.offset != t2.offset) {
                                if (t2.offset < t.offset + t.size and t2.offset + t2.size > t.offset) { //both sides overlap
                                    const end_2 = @max(t2.offset + t2.size, t.offset + t.size);
                                    t.offset = @min(t2.offset, t.offset);
                                    t.size = end_2 - t.offset;
                                    if (t2.offset != ranges[off_idx - 1].offset) {
                                        std.mem.swap(u64, &ranges[off_idx - 1].offset, &t2.offset);
                                        std.mem.swap(u64, &ranges[off_idx - 1].size, &t2.size);
                                    }
                                    off_idx -= 1;
                                    break;
                                }
                            }
                        }
                        off_idx -= 1;
                        break;
                    }
                }

                r.p_next = null;
                r.s_type = .mapped_memory_range;
                off_idx += 1;
            }
        } else {
            for (nodes) |copy| {
                const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.map_copy.ires.get_idx()));
                start = @min(start, nd.*.data.idx * self.*.cell_size);
                end = @max(end, (nd.*.data.idx + nd.*.data.size) * self.*.cell_size);
            }
        }

        const size = end - start;
        if (self.*.map_start > start or self.*.map_size + self.*.map_start < end or self.*.map_size < end - start) {
            if (self.*.map_size > 0) {
                self.*.unmap();
            }
            var out_data: ?*anyopaque = undefined;
            self.*.map(start, size, &out_data);
            self.*.map_data = @alignCast(@ptrCast(out_data.?));
            self.*.map_size = size;
            self.*.map_start = start;
        } else {
            if (self.*.cached) {
                __vulkan.vkd.?.invalidateMappedMemoryRanges(@intCast(off_idx), ranges.ptr) catch unreachable;
            }
        }
        for (nodes) |v| {
            const copy = v.map_copy;
            const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.ires.get_idx()));
            const st = (nd.*.data.idx) * self.*.cell_size - self.*.map_start;
            //const en = (nd.*.data.idx + nd.*.data.size - start) * self.*.cell_size;
            @memcpy(self.*.map_data[st..(st + copy.address.len)], copy.address[0..copy.address.len]);
        }
        if (self.*.cached) {
            __vulkan.vkd.?.flushMappedMemoryRanges(@intCast(ranges.len), ranges.ptr) catch unreachable;
        }
    }
    pub fn is_empty(self: *vulkan_res) bool {
        return self.*.list.len == 1 and self.*.list.first.?.*.data.free;
    }
    pub fn deinit(self: *vulkan_res) void {
        var i: usize = 0;
        while (i < buffer_ids.items.len) : (i += 1) {
            if (buffer_ids.items[i] == self) {
                _ = buffer_ids.orderedRemove(i);
                break;
            }
        }
        if (!self.*.single) memory_idx_counts[self.*.info.memory_type_index] -= 1;
        self.*.deinit2();
        buffers.destroy(self);
    }
    fn allocate_memory(_info: *const vk.MemoryAllocateInfo, _mem: *vk.DeviceMemory) bool {
        _mem.* = __vulkan.vkd.?.allocateMemory(_info, null) catch return false;
        return true;
    }
    /// ! don't call vulkan_res.init separately
    fn init(_cell_size: usize, _len: usize, type_filter: u32, _prop: vk.MemoryPropertyFlags) ?vulkan_res {
        var res = vulkan_res{
            .cell_size = _cell_size,
            .len = _len,
            .mem = undefined,
            .info = .{
                .allocation_size = _len * _cell_size,
                .memory_type_index = find_memory_type(type_filter, _prop) orelse return null,
            },
            .list = .{},
            .pool = MemoryPoolExtra(DoublyLinkedList(node).Node, .{}).init(__system.allocator),
            .cached = _prop.contains(.{ .host_visible_bit = true, .host_cached_bit = true }),
        };
        if (res.cached) {
            res.info.allocation_size = math.ceil_up(_len * _cell_size, nonCoherentAtomSize);
            res.len = @divFloor(res.info.allocation_size, res.cell_size);
        }
        if (!allocate_memory(&res.info, &res.mem)) {
            return null;
        }

        res.list.append(res.pool.create() catch xfit.herrm("vulkan_res.init.res.pool.create"));
        res.list.first.?.*.data.free = true;
        res.list.first.?.*.data.size = res.len;
        res.list.first.?.*.data.idx = 0;
        res.cur = res.list.first.?;

        return res;
    }
    fn init_single(_cell_size: usize, type_filter: u32) vulkan_res {
        var res = vulkan_res{
            .cell_size = _cell_size,
            .len = 1,
            .mem = undefined,
            .info = .{
                .allocation_size = _cell_size,
                .memory_type_index = find_memory_type(type_filter, .{ .device_local_bit = true }) orelse unreachable,
            },
            .single = true,
        };
        if (!allocate_memory(&res.info, &res.mem)) unreachable;

        return res;
    }
    fn __bind_any(self: *vulkan_res, _mem: vk.DeviceMemory, _buf: anytype, _idx: u64) void {
        switch (@TypeOf(_buf)) {
            vk.Buffer => {
                __vulkan.vkd.?.bindBufferMemory(_buf, _mem, self.*.cell_size * _idx) catch |e| xfit.herr3("__vulkan_allocator __bind_any bindBufferMemory", e);
            },
            vk.Image => {
                __vulkan.vkd.?.bindImageMemory(_buf, _mem, self.*.cell_size * _idx) catch |e| xfit.herr3("__vulkan_allocator __bind_any bindImageMemory", e);
            },
            else => @compileError("__bind_any invaild res type."),
        }
    }
    ///not mul cellsize
    fn map(self: *vulkan_res, _start: usize, _size: usize, _out_data: *?*anyopaque) void {
        _out_data.* = __vulkan.vkd.?.mapMemory(
            self.*.mem,
            _start,
            _size,
            .{},
        ) catch |e| xfit.herr3("__vulkan_allocator map mapMemory", e);
    }
    pub fn unmap(self: *vulkan_res) void {
        self.*.map_size = 0;
        __vulkan.vkd.?.unmapMemory(self.*.mem);
    }
    fn bind_any(self: *vulkan_res, _buf: anytype, _cell_count: usize) ERROR!?*res_range {
        if (_cell_count == 0) unreachable;
        if (self.*.single) {
            __bind_any(self, self.*.mem, _buf, 0);
            return null;
        }
        //xfit.print("start:{d}, size:{d}, free:{}\n", .{ self.*.cur.*.data.idx, self.*.cur.*.data.size, self.*.cur.*.data.free });
        var cur = self.*.cur;
        while (true) {
            if (cur.*.data.free and _cell_count <= cur.*.data.size) break;
            cur = cur.*.next orelse self.*.list.first.?;
            if (cur == self.*.cur) {
                return ERROR.device_memory_limit;
            }
        }
        //xfit.print("end:{d}, size:{d}, count:{d}\n", .{ cur.*.data.idx, cur.*.data.size, _cell_count });
        __bind_any(self, self.*.mem, _buf, cur.*.data.idx);
        cur.*.data.free = false;
        const remain = cur.*.data.size - _cell_count;
        self.*.cur = cur;
        const res: *res_range = @alignCast(@ptrCast(cur));
        const cur2 = cur.*.next orelse self.*.list.first.?;
        if (cur == cur2) {
            if (remain > 0) {
                self.*.list.append(self.*.pool.create() catch xfit.herrm("vulkan_res.bind_any.pool.create"));
                self.*.list.last.?.*.data.free = true;
                self.*.list.last.?.*.data.size = remain;
                self.*.list.last.?.*.data.idx = _cell_count;
            }
        } else {
            if (remain > 0) {
                if (cur2.*.data.free) {
                    if (cur2.*.data.idx < cur.*.data.idx) {
                        self.*.list.insertAfter(cur, self.*.pool.create() catch xfit.herrm("vulkan_res.bind_any.pool.create"));
                        cur.*.next.?.*.data.free = true;
                        cur.*.next.?.*.data.idx = cur.*.data.idx + _cell_count;
                        cur.*.next.?.*.data.size = remain;
                    } else {
                        cur2.*.data.idx -= remain;
                        cur2.*.data.size += remain;
                    }
                } else {
                    self.*.list.insertAfter(cur, self.*.pool.create() catch xfit.herrm("vulkan_res.bind_any.pool.create"));
                    cur.*.next.?.*.data.free = true;
                    cur.*.next.?.*.data.idx = cur.*.data.idx + _cell_count;
                    cur.*.next.?.*.data.size = remain;
                }
            }
        }
        cur.*.data.size = _cell_count;
        return res;
    }
    /// use _res returned from bind_buffer
    fn unbind_res(self: *vulkan_res, _buf: anytype, _res: *res_range) void {
        if (self.*.single) {
            switch (@TypeOf(_buf)) {
                vk.Buffer => __vulkan.vkd.?.destroyBuffer(_buf, null),
                vk.Image => __vulkan.vkd.?.destroyImage(_buf, null),
                else => @compileError("invaild buf type"),
            }
            self.*.deinit();
            return;
        }
        const res: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(_res));
        res.*.data.free = true;
        const next = res.*.next orelse self.*.list.first.?;

        if (next.*.data.free and res != next and res.*.data.idx < next.*.data.idx) {
            res.*.data.size += next.*.data.size;
            self.*.list.remove(next);
            self.*.pool.destroy(next);
        }
        const prev = res.*.prev orelse self.*.list.last.?;
        if (prev.*.data.free and res != prev and res.*.data.idx > prev.*.data.idx) {
            res.*.data.size += prev.*.data.size;
            res.*.data.idx -= prev.*.data.size;
            self.*.list.remove(prev);
            self.*.pool.destroy(prev);
        }
        switch (@TypeOf(_buf)) {
            vk.Buffer => __vulkan.vkd.?.destroyBuffer(_buf, null),
            vk.Image => __vulkan.vkd.?.destroyImage(_buf, null),
            else => @compileError("invaild buf type"),
        }
        if (self.*.len == 1 or memory_idx_counts[self.*.info.memory_type_index] > MAX_IDX_COUNT) {
            for (buffer_ids.items) |v| {
                if (self != v and self.*.info.memory_type_index == v.*.info.memory_type_index) {
                    if (v.*.is_empty()) {
                        memory_idx_counts[v.*.info.memory_type_index] -= 1;
                        v.*.deinit();
                    }
                }
            }
            if (self.*.is_empty()) {
                memory_idx_counts[self.*.info.memory_type_index] -= 1;
                self.*.deinit();
            }
        }
    }
};

fn create_allocator_and_bind(_res: anytype, _prop: vk.MemoryPropertyFlags, _out_idx: **res_range, _max_size: usize, use_gcpu_mem: bool) *vulkan_res {
    var res: ?*vulkan_res = null;
    var mem_require: vk.MemoryRequirements = undefined;
    if (@TypeOf(_res) == vk.Buffer) {
        mem_require = __vulkan.vkd.?.getBufferMemoryRequirements(_res);
    } else if (@TypeOf(_res) == vk.Image) {
        mem_require = __vulkan.vkd.?.getImageMemoryRequirements(_res);
    } else {
        @compileError("invaild _res type");
    }
    var max_size = _max_size;
    if (max_size < @as(usize, @intCast(mem_require.size))) {
        max_size = @intCast(mem_require.size);
    }
    var prop = _prop;
    if ((BLOCK_LEN == SPECIAL_BLOCK_LEN or (@TypeOf(_res) == vk.Buffer and max_size <= 256) or use_gcpu_mem) and prop.contains(.{ .host_visible_bit = true })) {
        if (supported_cache_local) {
            prop = .{ .host_visible_bit = true, .device_local_bit = true, .host_cached_bit = true };
        } else if (supported_noncache_local) {
            prop = .{ .host_visible_bit = true, .device_local_bit = true, .host_coherent_bit = true };
        }
    }
    const cnt = std.math.divCeil(usize, max_size, @intCast(mem_require.alignment)) catch 1;
    for (buffer_ids.items) |value| {
        if (value.*.cell_size != mem_require.alignment) continue;
        const tt = find_memory_type(mem_require.memory_type_bits, prop) orelse blk: {
            prop = _prop;
            break :blk find_memory_type(mem_require.memory_type_bits, prop) orelse unreachable;
        };
        if (value.*.info.memory_type_index != tt) continue;
        _out_idx.* = value.*.bind_any(_res, cnt) catch continue orelse unreachable;
        //xfit.print_debug("(1) {d} {d} {d} {d}", .{ max_size, value.*.cell_size, value.*.len, mem_require.alignment });
        res = value;
        break;
    }
    if (res == null) {
        res = buffers.create() catch |err| {
            xfit.print_error("ERR {s} __vulkan_allocator.create_allocator_and_bind.self.*.buffers.create\n", .{@errorName(err)});
            unreachable;
        };

        // xfit.print_debug("(2) {d} {d} {d}", .{
        //     max_size,
        //     std.math.divCeil(usize, BLOCK_LEN, std.math.divCeil(usize, cell, NODE_SIZE) catch 1) catch 1,
        //     _mem_require.*.alignment,
        // });
        const flag = vk.MemoryPropertyFlags{ .host_visible_bit = true, .device_local_bit = true };
        var BLK = if (prop.contains(flag)) SPECIAL_BLOCK_LEN else BLOCK_LEN;
        const R = vulkan_res.init(
            @intCast(mem_require.alignment),
            std.math.divCeil(usize, @max(BLK, max_size), @intCast(mem_require.alignment)) catch 1,
            mem_require.memory_type_bits,
            prop,
        );
        if (R == null) {
            buffers.destroy(res.?);
            res = null;
            prop = .{ .host_visible_bit = true, .host_cached_bit = true };
            for (buffer_ids.items) |value| {
                if (value.*.cell_size != mem_require.alignment) continue;
                const tt = find_memory_type(mem_require.memory_type_bits, prop) orelse unreachable;
                if (value.*.info.memory_type_index != tt) continue;
                _out_idx.* = value.*.bind_any(_res, cnt) catch continue orelse unreachable;
                res = value;
                break;
            }
            if (res == null) {
                BLK = BLOCK_LEN;
                res.?.* = vulkan_res.init(
                    @intCast(mem_require.alignment),
                    std.math.divCeil(usize, @max(BLOCK_LEN, max_size), @intCast(mem_require.alignment)) catch 1,
                    mem_require.memory_type_bits,
                    prop,
                ) orelse unreachable;
            }
        } else {
            res.?.* = R.?;
        }

        _out_idx.* = res.?.*.bind_any(_res, cnt) catch unreachable orelse unreachable; //Error that should not occur
        buffer_ids.append(res.?) catch |err| {
            xfit.print_error("ERR {s} __vulkan_allocator.create_allocator_and_bind.self.*.buffer_ids.append\n", .{@errorName(err)});
            unreachable;
        };
    }
    memory_idx_counts[res.?.*.info.memory_type_index] += 1;
    return res.?;
}

fn create_allocator_and_bind_single(_res: anytype) *vulkan_res {
    var res: ?*vulkan_res = null;
    var mem_require: vk.MemoryRequirements = undefined;
    if (@TypeOf(_res) == vk.Buffer) {
        mem_require = __vulkan.vkd.?.getBufferMemoryRequirements(_res);
    } else if (@TypeOf(_res) == vk.Image) {
        mem_require = __vulkan.vkd.?.getImageMemoryRequirements(_res);
    } else {
        @compileError("invaild _res type");
    }

    const max_size: usize = @intCast(mem_require.size);
    res = buffers.create() catch |err| {
        xfit.herr3("__vulkan_allocator.create_allocator_and_bind.self.*.buffers.create", err);
    };

    res.?.* = vulkan_res.init_single(max_size, mem_require.memory_type_bits);

    _ = res.?.*.bind_any(_res, 1) catch unreachable; //Error that should not occur
    buffer_ids.append(res.?) catch |err| {
        xfit.herr3("__vulkan_allocator.create_allocator_and_bind.buffer_ids.append", err);
    };
    return res.?;
}
