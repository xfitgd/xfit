const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const MemoryPoolExtra = std.heap.MemoryPoolExtra;
const DoublyLinkedList = std.DoublyLinkedList;
const HashMap = std.AutoHashMap;

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;
const __system = @import("__system.zig");
const system = @import("system.zig");
const math = @import("math.zig");
const mem = @import("mem.zig");
const graphics = @import("graphics.zig");

//16384*16384 = 256MB
pub var BLOCK_LEN: usize = 16384 * 16384;
pub var SPECIAL_BLOCK_LEN: usize = 16384 * 16384 / 8;
pub var FORMAT: texture_format = undefined;
pub var nonCoherentAtomSize: usize = 0;
pub var supported_cache_local: bool = false;
pub var supported_noncache_local: bool = false;

pub var execute_all_cmd_per_update: std.atomic.Value(bool) = std.atomic.Value(bool).init(true);

pub fn init_block_len() void {
    var i: u32 = 0;
    var change: bool = false;
    while (i < __vulkan.mem_prop.memoryHeapCount) : (i += 1) {
        if (__vulkan.mem_prop.memoryHeaps[i].flags & vk.VK_MEMORY_HEAP_DEVICE_LOCAL_BIT != 0) {
            if (__vulkan.mem_prop.memoryHeaps[i].size < 1024 * 1024 * 1024) {
                BLOCK_LEN /= 16;
            } else if (__vulkan.mem_prop.memoryHeaps[i].size < 2 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 8;
            } else if (__vulkan.mem_prop.memoryHeaps[i].size < 4 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 4;
            } else if (__vulkan.mem_prop.memoryHeaps[i].size < 8 * 1024 * 1024 * 1024) {
                BLOCK_LEN /= 2;
            }
            change = true;
            break;
        }
    }
    if (!change) { //글카 전용 메모리가 없을 경우
        if (__vulkan.mem_prop.memoryHeaps[0].size < 2 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 16;
        } else if (__vulkan.mem_prop.memoryHeaps[0].size < 2 * 2 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 8;
        } else if (__vulkan.mem_prop.memoryHeaps[0].size < 2 * 4 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 4;
        } else if (__vulkan.mem_prop.memoryHeaps[0].size < 2 * 8 * 1024 * 1024 * 1024) {
            BLOCK_LEN /= 2;
        }
    }
    var p: vk.VkPhysicalDeviceProperties = undefined;
    vk.vkGetPhysicalDeviceProperties(__vulkan.vk_physical_device, &p);
    nonCoherentAtomSize = @intCast(p.limits.nonCoherentAtomSize);
    i = 0;
    while (i < __vulkan.mem_prop.memoryTypeCount) : (i += 1) {
        if (__vulkan.mem_prop.memoryTypes[i].propertyFlags == vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT | vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) {
            supported_cache_local = true;
        } else if (__vulkan.mem_prop.memoryTypes[i].propertyFlags == vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT | vk.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT) {
            supported_noncache_local = true;
        }
    }
}

const MAX_IDX_COUNT = 4;
pub const ERROR = error{device_memory_limit};

var buffers: MemoryPoolExtra(vulkan_res, .{}) = undefined;
var buffer_ids: ArrayList(*vulkan_res) = undefined;
var memory_idx_counts: []u16 = undefined;
var g_thread: std.Thread = undefined;
var op_queue: ArrayList(?operation_node) = undefined;
var op_save_queue: ArrayList(?operation_node) = undefined;
var op_map_queue: ArrayList(?operation_node) = undefined;
var staging_buf_queue: MemoryPoolExtra(vulkan_res_node(.buffer), .{}) = undefined;
var mutex: std.Thread.Mutex = .{};
pub var submit_mutex: std.Thread.Mutex = .{};
var cond: std.Thread.Condition = .{};
var finish_cond: std.Thread.Condition = .{};
var finish_mutex: std.Thread.Mutex = .{};
var exited: bool = false;
var cmd: vk.VkCommandBuffer = undefined;
var cmd_pool: vk.VkCommandPool = undefined;
var descriptor_pools: HashMap([*]const descriptor_pool_size, ArrayList(descriptor_pool_memory)) = undefined;
var set_list: ArrayList(vk.VkWriteDescriptorSet) = undefined;
var set_list_res: ArrayList(struct { []vk.VkDescriptorBufferInfo, []vk.VkDescriptorImageInfo }) = undefined;
var dataMutex: std.Thread.Mutex = .{};

pub fn init() void {
    buffers = MemoryPoolExtra(vulkan_res, .{}).init(__system.allocator);
    buffer_ids = ArrayList(*vulkan_res).init(__system.allocator);
    memory_idx_counts = __system.allocator.alloc(u16, __vulkan.mem_prop.memoryTypeCount) catch |e| system.handle_error3("__vulkan_allocator init alloc memory_idx_counts", e);
    op_queue = ArrayList(?operation_node).init(__system.allocator);
    op_save_queue = ArrayList(?operation_node).init(__system.allocator);
    op_map_queue = ArrayList(?operation_node).init(__system.allocator);
    staging_buf_queue = MemoryPoolExtra(vulkan_res_node(.buffer), .{}).init(__system.allocator);
    descriptor_pools = HashMap([*]const descriptor_pool_size, ArrayList(descriptor_pool_memory)).init(__system.allocator);
    set_list = ArrayList(vk.VkWriteDescriptorSet).init(__system.allocator);
    set_list_res = @TypeOf(set_list_res).init(__system.allocator);

    @memset(memory_idx_counts, 0);

    // ! vk.VK_COMMAND_POOL_CREATE_TRANSIENT_BIT 쓰면 안드로이드 에서 팅김
    const poolInfo: vk.VkCommandPoolCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = 0,
        .queueFamilyIndex = __vulkan.graphicsFamilyIndex,
    };
    var result = vk.vkCreateCommandPool(__vulkan.vkDevice, &poolInfo, null, &cmd_pool);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan_allocator.vkCreateCommandPool : {d}", .{result});

    const alloc_info: vk.VkCommandBufferAllocateInfo = .{
        .commandBufferCount = 1,
        .level = vk.VK_COMMAND_BUFFER_LEVEL_PRIMARY,
        .commandPool = cmd_pool,
    };
    result = vk.vkAllocateCommandBuffers(__vulkan.vkDevice, &alloc_info, &cmd);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan_allocator.vkAllocateCommandBuffers : {d}", .{result});

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
        value.*.deinit2(); // ! 따로 vulkan_res.deinit를 호출하지 않는다.
    }
    buffers.deinit();
    buffer_ids.deinit();
    __system.allocator.free(memory_idx_counts);
    op_queue.deinit();
    op_save_queue.deinit();
    op_map_queue.deinit();
    staging_buf_queue.deinit();

    var it = descriptor_pools.valueIterator();
    while (it.next()) |v| {
        for (v.*.items) |i| {
            vk.vkDestroyDescriptorPool(__vulkan.vkDevice, i.pool, null);
        }
        v.*.deinit();
    }
    set_list.deinit();
    set_list_res.deinit();
    descriptor_pools.deinit();

    vk.vkDestroyCommandPool(__vulkan.vkDevice, cmd_pool, null);
}

pub var POOL_BLOCK: c_uint = 256;

pub const res_type = enum { buffer, texture };
pub const res_range = opaque {};

pub inline fn ivulkan_res(_res_type: res_type) type {
    return switch (_res_type) {
        .buffer => vk.VkBuffer,
        .texture => vk.VkImage,
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
};

pub const texture_format = enum(c_uint) {
    default = 0,
    R8G8B8A8_UNORM = vk.VK_FORMAT_R8G8B8A8_UNORM,
    R8G8B8A8_SRGB = vk.VK_FORMAT_R8G8B8A8_SRGB,
    D24_UNORM_S8_UINT = vk.VK_FORMAT_D24_UNORM_S8_UINT,
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
    },
    destroy_image: struct {
        buf: *vulkan_res_node(.texture),
    },
    __update_descriptor_sets: struct {
        sets: []descriptor_set,
    },
    ///사용자가 꼭 호출 할 필요 없게
    __register_descriptor_pool: struct {
        __size: []descriptor_pool_size,
    },
};

pub const descriptor_pool_memory = struct {
    pool: vk.VkDescriptorPool,
    cnt: c_uint = 0,
};

pub const descriptor_type = enum(c_uint) {
    sampler = vk.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
    uniform = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
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
    layout: vk.VkDescriptorSetLayout,
    ///내부에서 생성됨 update_descriptor_sets 호출시
    __set: vk.VkDescriptorSet = null,
    size: []const descriptor_pool_size,
    bindings: []const c_uint,
    res: []res_union = undefined,
};

pub fn update_descriptor_sets(sets: []descriptor_set) void {
    append_op(.{ .__update_descriptor_sets = .{ .sets = sets } });
}

pub const frame_buffer = struct {
    res: vk.VkFramebuffer = null,

    pub fn create_no_async(self: *frame_buffer, texs: []*vulkan_res_node(.texture), __renderPass: vk.VkRenderPass) void {
        const attachments = __system.allocator.alloc(vk.VkImageView, texs.len) catch system.handle_error_msg2("create_no_async vk.VkImageView alloc");
        defer __system.allocator.free(attachments);
        for (attachments, texs) |*v, t| {
            v.* = t.*.__image_view;
        }

        var frameBufferInfo: vk.VkFramebufferCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO,
            .renderPass = __renderPass,
            .attachmentCount = @intCast(texs.len),
            .pAttachments = attachments.ptr,
            .width = texs[0].*.texture_option.width,
            .height = texs[0].*.texture_option.height,
            .layers = 1,
        };

        const result = vk.vkCreateFramebuffer(__vulkan.vkDevice, &frameBufferInfo, null, &self.*.res);
        system.handle_error(result == vk.VK_SUCCESS, "execute_create_frame_buffer vkCreateFramebuffer : {d}", .{result});
    }
    pub fn destroy_no_async(self: *frame_buffer) void {
        vk.vkDestroyFramebuffer(__vulkan.vkDevice, self.*.res, null);
        self.*.res = null;
    }
};

fn execute_create_buffer(buf: *vulkan_res_node(.buffer), _data: ?[]const u8) void {
    var result: c_int = undefined;
    if (buf.*.buffer_option.typ == .staging) {
        buf.*.buffer_option.use = .cpu;
        buf.*.buffer_option.single = false;
    }

    const prop: c_uint = switch (buf.*.buffer_option.use) {
        .gpu => vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
        .cpu => vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
    };
    const usage_: c_uint = switch (buf.*.buffer_option.typ) {
        .vertex => vk.VK_BUFFER_USAGE_VERTEX_BUFFER_BIT,
        .index => vk.VK_BUFFER_USAGE_INDEX_BUFFER_BIT,
        .uniform => vk.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT,
        .staging => vk.VK_BUFFER_USAGE_TRANSFER_SRC_BIT,
    };
    var buf_info: vk.VkBufferCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO,
        .size = buf.*.buffer_option.len,
        .usage = usage_,
        .sharingMode = vk.VK_SHARING_MODE_EXCLUSIVE,
    };
    var last: *vulkan_res_node(.buffer) = undefined;
    if (_data != null and buf.*.buffer_option.use == .gpu) {
        buf_info.usage |= vk.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
        if (buf.*.buffer_option.len > _data.?.len) {
            system.handle_error2("create_buffer _data not enough size. {d} {d} {}", .{ buf.*.buffer_option.len, _data.?.len, buf.*.builded });
        }
        last = staging_buf_queue.create() catch unreachable;
        last.* = .{};
        last.*.__create_buffer(.{
            .len = buf.*.buffer_option.len,
            .use = .cpu,
            .typ = .staging,
            .single = false,
        }, _data);
    } else if (buf.*.buffer_option.typ == .staging) {
        if (_data == null) system.handle_error_msg2("staging buffer data can't null");
    }
    result = vk.vkCreateBuffer(__vulkan.vkDevice, &buf_info, null, &buf.*.res);
    system.handle_error(result == vk.VK_SUCCESS, "execute_create_buffer vkCreateBuffer {d}", .{result});

    var out_idx: *res_range = undefined;
    const res = if (buf.*.buffer_option.single) create_allocator_and_bind_single(buf.*.res) else create_allocator_and_bind(buf.*.res, prop, &out_idx, 0);
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
            //위에서 __create_buffer 호출되면서 staging 버퍼가 추가되고 map_copy명령이 추가된다.
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
fn execute_destroy_buffer(buf: *vulkan_res_node(.buffer)) void {
    buf.*.__destroy_buffer();
}

inline fn bit_size(fmt: texture_format) c_uint {
    return switch (fmt) {
        .default => 4,
        .R8G8B8A8_UNORM => 4,
        .R8G8B8A8_SRGB => 4,
        .D24_UNORM_S8_UINT => 4,
    };
}

inline fn get_samples(samples: u8) c_uint {
    return switch (samples) {
        2 => vk.VK_SAMPLE_COUNT_2_BIT,
        4 => vk.VK_SAMPLE_COUNT_4_BIT,
        8 => vk.VK_SAMPLE_COUNT_8_BIT,
        16 => vk.VK_SAMPLE_COUNT_16_BIT,
        32 => vk.VK_SAMPLE_COUNT_32_BIT,
        64 => vk.VK_SAMPLE_COUNT_64_BIT,
        else => vk.VK_SAMPLE_COUNT_1_BIT,
    };
}
inline fn is_depth_format(fmt: texture_format) bool {
    return switch (fmt) {
        .D24_UNORM_S8_UINT => true,
        else => false,
    };
}

fn execute_copy_buffer(src: *vulkan_res_node(.buffer), target: *vulkan_res_node(.buffer)) void {
    const copyRegion: vk.VkBufferCopy = .{ .size = target.*.buffer_option.len, .srcOffset = 0, .dstOffset = 0 };
    vk.vkCmdCopyBuffer(cmd, src.*.res, target.*.res, 1, &copyRegion);
}
fn execute_copy_buffer_to_image(src: *vulkan_res_node(.buffer), target: *vulkan_res_node(.texture)) void {
    __vulkan.transition_image_layout(cmd, target.*.res, 1, 0, target.*.texture_option.len, vk.VK_IMAGE_LAYOUT_UNDEFINED, vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);
    const region: vk.VkBufferImageCopy = .{
        .bufferOffset = 0,
        .bufferRowLength = 0,
        .bufferImageHeight = 0,
        .imageOffset = .{ .x = 0, .y = 0, .z = 0 },
        .imageExtent = .{ .width = target.*.texture_option.width, .height = target.*.texture_option.height, .depth = 1 },
        .imageSubresource = .{
            .aspectMask = vk.VK_IMAGE_ASPECT_COLOR_BIT,
            .baseArrayLayer = 0,
            .mipLevel = 0,
            .layerCount = target.*.texture_option.len,
        },
    };
    vk.vkCmdCopyBufferToImage(cmd, src.*.res, target.*.res, vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region);
    __vulkan.transition_image_layout(cmd, target.*.res, 1, 0, target.*.texture_option.len, vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, vk.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);
}
fn execute_create_texture(buf: *vulkan_res_node(.texture), _data: ?[]const u8) void {
    var result: c_int = undefined;

    const prop: c_uint = switch (buf.*.texture_option.use) {
        .gpu => vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
        .cpu => vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
    };
    var usage_: c_uint = 0;
    const is_depth = is_depth_format(buf.*.texture_option.format);
    if (buf.*.texture_option.tex_use.image_resource) usage_ |= vk.VK_IMAGE_USAGE_SAMPLED_BIT;
    if (buf.*.texture_option.tex_use.frame_buffer) {
        if (is_depth) {
            usage_ |= vk.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;
        } else {
            usage_ |= vk.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
        }
    }
    if (buf.*.texture_option.tex_use.__input_attachment) usage_ |= vk.VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT;
    if (buf.*.texture_option.tex_use.__transient_attachment) usage_ |= vk.VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT;

    if (buf.*.texture_option.format == .default) {
        buf.*.texture_option.format = .R8G8B8A8_UNORM;
    }
    const bit = bit_size(buf.*.texture_option.format);
    var img_info: vk.VkImageCreateInfo = .{
        .arrayLayers = buf.*.texture_option.len,
        .usage = usage_,
        .sharingMode = vk.VK_SHARING_MODE_EXCLUSIVE,
        .extent = .{ .width = buf.*.texture_option.width, .height = buf.*.texture_option.height, .depth = 1 },
        .samples = get_samples(buf.*.texture_option.samples),
        .tiling = vk.VK_IMAGE_TILING_OPTIMAL,
        .mipLevels = 1,
        .format = @intFromEnum(buf.*.texture_option.format),
        .imageType = vk.VK_IMAGE_TYPE_2D,
        .initialLayout = vk.VK_IMAGE_LAYOUT_UNDEFINED,
    };
    var last: *vulkan_res_node(.buffer) = undefined;
    if (_data != null and buf.*.texture_option.use == .gpu) {
        img_info.usage |= vk.VK_IMAGE_USAGE_TRANSFER_DST_BIT;
        if (img_info.extent.width * img_info.extent.width * img_info.extent.depth * img_info.arrayLayers * bit > _data.?.len) {
            system.handle_error_msg2("create_texture _data not enough size.");
        }

        last = staging_buf_queue.create() catch unreachable;
        last.* = .{};
        last.*.__create_buffer(.{
            .len = img_info.extent.width * img_info.extent.width * img_info.extent.depth * img_info.arrayLayers * bit,
            .use = .cpu,
            .typ = .staging,
            .single = false,
        }, _data);
    }
    result = vk.vkCreateImage(__vulkan.vkDevice, &img_info, null, &buf.*.res);
    system.handle_error(result == vk.VK_SUCCESS, "execute_create_texture vkCreateImage {d}", .{result});

    var out_idx: *res_range = undefined;
    const res = if (buf.*.texture_option.single) create_allocator_and_bind_single(buf.*.res) else create_allocator_and_bind(buf.*.res, prop, &out_idx, 0);
    buf.*.pvulkan_buffer = res;
    buf.*.idx = out_idx;

    const image_view_create_info: vk.VkImageViewCreateInfo = .{
        .viewType = if (img_info.arrayLayers > 1) vk.VK_IMAGE_VIEW_TYPE_2D_ARRAY else vk.VK_IMAGE_VIEW_TYPE_2D,
        .format = img_info.format,
        .components = .{ .r = vk.VK_COMPONENT_SWIZZLE_IDENTITY, .g = vk.VK_COMPONENT_SWIZZLE_IDENTITY, .b = vk.VK_COMPONENT_SWIZZLE_IDENTITY, .a = vk.VK_COMPONENT_SWIZZLE_IDENTITY },
        .image = buf.*.res,
        .subresourceRange = .{
            .aspectMask = if (is_depth) vk.VK_IMAGE_ASPECT_DEPTH_BIT | vk.VK_IMAGE_ASPECT_STENCIL_BIT else vk.VK_IMAGE_ASPECT_COLOR_BIT,
            .baseMipLevel = 0,
            .levelCount = 1,
            .baseArrayLayer = 0,
            .layerCount = img_info.arrayLayers,
        },
    };
    result = vk.vkCreateImageView(__vulkan.vkDevice, &image_view_create_info, null, &buf.*.__image_view);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan_allocator.execute_create_texture.vkCreateImageView : {d}", .{result});

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
            //위에서 __create_buffer 호출되면서 staging 버퍼가 추가되고 map_copy명령이 추가된다.
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
fn execute_destroy_image(buf: *vulkan_res_node(.texture)) void {
    buf.*.__destroy_image();
}

fn execute_register_descriptor_pool(__size: []descriptor_pool_size) void {
    _ = __size;
    //TODO execute_register_descriptor_pool
}
fn __create_descriptor_pool(size: []const descriptor_pool_size, out: *descriptor_pool_memory) void {
    const pool_size = __system.allocator.alloc(vk.VkDescriptorPoolSize, size.len) catch system.handle_error_msg2("execute_update_descriptor_sets vk.VkDescriptorPoolSize alloc");
    defer __system.allocator.free(pool_size);
    for (size, pool_size) |e, *p| {
        p.*.descriptorCount = e.cnt * POOL_BLOCK;
        p.*.type = @intFromEnum(e.typ);
    }
    const pool_info: vk.VkDescriptorPoolCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO,
        .poolSizeCount = @intCast(pool_size.len),
        .pPoolSizes = pool_size.ptr,
        .maxSets = POOL_BLOCK,
    };
    const result = vk.vkCreateDescriptorPool(__vulkan.vkDevice, &pool_info, null, &out.*.pool);
    system.handle_error(result == vk.VK_SUCCESS, "execute_update_descriptor_sets.vkCreateDescriptorPool : {d}", .{result});
}
fn execute_update_descriptor_sets(sets: []descriptor_set) void {
    var result: c_int = undefined;

    for (sets) |*v| {
        if (v.*.__set == null) {
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
            const alloc_info: vk.VkDescriptorSetAllocateInfo = .{
                .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO,
                .descriptorPool = last.*.pool,
                .descriptorSetCount = 1,
                .pSetLayouts = &v.*.layout,
            };
            result = vk.vkAllocateDescriptorSets(__vulkan.vkDevice, &alloc_info, &v.*.__set);
            system.handle_error(result == vk.VK_SUCCESS, "execute_update_descriptor_sets.vkAllocateDescriptorSets : {d}", .{result});
        }

        var buf_cnt: usize = 0;
        var img_cnt: usize = 0;
        //v.res 배열이 v.size 구성에 맞아야 한다.
        for (v.res) |r| {
            if (r == .buf) {
                buf_cnt += 1;
            } else if (r == .tex) {
                img_cnt += 1;
            }
        }
        const bufs = __system.allocator.alloc(vk.VkDescriptorBufferInfo, buf_cnt) catch unreachable;
        const imgs = __system.allocator.alloc(vk.VkDescriptorImageInfo, img_cnt) catch unreachable;
        buf_cnt = 0;
        img_cnt = 0;
        for (v.res) |r| {
            if (r == .buf) {
                bufs[buf_cnt] = .{
                    .buffer = r.buf.*.res,
                    .offset = 0,
                    .range = r.buf.*.buffer_option.len,
                };
                buf_cnt += 1;
            } else if (r == .tex) {
                imgs[img_cnt] = .{
                    .imageLayout = vk.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
                    .imageView = r.tex.*.__image_view,
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
                        .dstSet = v.__set,
                        .dstBinding = b,
                        .dstArrayElement = 0,
                        .descriptorCount = s.cnt,
                        .descriptorType = @intFromEnum(e),
                        .pBufferInfo = null,
                        .pImageInfo = imgs[(img_cnt)..(img_cnt + s.cnt)].ptr,
                        .pTexelBufferView = null,
                    }) catch unreachable;
                    img_cnt += s.cnt;
                },
                .uniform => |e| {
                    set_list.append(.{
                        .dstSet = v.__set,
                        .dstBinding = b,
                        .dstArrayElement = 0,
                        .descriptorCount = s.cnt,
                        .descriptorType = @intFromEnum(e),
                        .pBufferInfo = bufs[(buf_cnt)..(buf_cnt + s.cnt)].ptr,
                        .pImageInfo = null,
                        .pTexelBufferView = null,
                    }) catch unreachable;
                    buf_cnt += s.cnt;
                },
            }
        }
        set_list_res.append(.{ bufs, imgs }) catch unreachable;
    }
}

fn save_to_map_queue(nres: *?*vulkan_res) void {
    for (op_save_queue.items) |*v| {
        if (v.* != null) {
            switch (v.*.?) {
                .map_copy => |e| {
                    if (nres.* == null) {
                        op_map_queue.append(v.*) catch unreachable;
                        nres.* = e.res;
                        v.* = null;
                    } else {
                        if (e.res == nres.*.?) {
                            op_map_queue.append(v.*) catch unreachable;
                            v.* = null;
                        }
                    }
                },
                else => {},
            }
        }
    }
}

fn thread_func() void {
    while (true) {
        mutex.lock();

        while (cond_cnt == false) cond.wait(&mutex);
        cond_cnt = false;
        if (exited and op_queue.items.len == 0) {
            finish_cond.broadcast();
            mutex.unlock();
            break;
        }
        if (op_queue.items.len > 0) {
            op_save_queue.appendSlice(op_queue.items) catch unreachable;
            op_queue.resize(0) catch unreachable;
        } else {
            mutex.unlock();
            continue;
        }
        mutex.unlock();

        op_map_queue.resize(0) catch unreachable;
        var nres: ?*vulkan_res = null;
        {
            var i: usize = 0;
            const len = op_save_queue.items.len;
            while (i < len) : (i += 1) {
                if (op_save_queue.items[i] != null) {
                    switch (op_save_queue.items[i].?) {
                        //create.. 과정에서 map_copy 명령이 추가될 수 있음
                        .create_buffer => execute_create_buffer(op_save_queue.items[i].?.create_buffer.buf, op_save_queue.items[i].?.create_buffer.data),
                        .create_texture => execute_create_texture(op_save_queue.items[i].?.create_texture.buf, op_save_queue.items[i].?.create_texture.data),
                        .__register_descriptor_pool => execute_register_descriptor_pool(op_save_queue.items[i].?.__register_descriptor_pool.__size),
                        else => continue,
                    }
                    op_save_queue.items[i] = null;
                }
            }
        }
        save_to_map_queue(&nres);

        dataMutex.lock();
        while (op_map_queue.items.len > 0) {
            nres.?.*.map_copy_execute(op_map_queue.items);

            op_map_queue.resize(0) catch unreachable;
            nres = null;
            save_to_map_queue(&nres);
        }
        dataMutex.unlock();

        var have_cmd: bool = false;
        for (op_save_queue.items) |*v| {
            if (v.* != null) {
                switch (v.*.?) {
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
            _ = vk.vkResetCommandPool(__vulkan.vkDevice, cmd_pool, 0);

            const begin: vk.VkCommandBufferBeginInfo = .{ .flags = vk.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT };
            var result = vk.vkBeginCommandBuffer(cmd, &begin);
            system.handle_error(result == vk.VK_SUCCESS, "begin_single_time_commands.vkBeginCommandBuffer : {d}", .{result});

            for (op_save_queue.items) |*v| {
                if (v.* != null) {
                    switch (v.*.?) {
                        .copy_buffer => execute_copy_buffer(v.*.?.copy_buffer.src, v.*.?.copy_buffer.target),
                        .copy_buffer_to_image => execute_copy_buffer_to_image(v.*.?.copy_buffer_to_image.src, v.*.?.copy_buffer_to_image.target),
                        .__update_descriptor_sets => execute_update_descriptor_sets(v.*.?.__update_descriptor_sets.sets),
                        else => continue,
                    }
                    v.* = null;
                }
            }
            if (set_list.items.len > 0) {
                vk.vkUpdateDescriptorSets(__vulkan.vkDevice, @intCast(set_list.items.len), set_list.items.ptr, 0, null);
                for (set_list_res.items) |v| {
                    __system.allocator.free(v[0]);
                    __system.allocator.free(v[1]);
                }
                set_list.resize(0) catch unreachable;
                set_list_res.resize(0) catch unreachable;
            }
            result = vk.vkEndCommandBuffer(cmd);
            system.handle_error(result == vk.VK_SUCCESS, "end_single_time_commands.vkEndCommandBuffer : {d}", .{result});
            const submitInfo: vk.VkSubmitInfo = .{
                .sType = vk.VK_STRUCTURE_TYPE_SUBMIT_INFO,
                .commandBufferCount = 1,
                .pCommandBuffers = &cmd,
            };

            result = vk.vkQueueSubmit(__vulkan.vkGraphicsQueue, 1, &submitInfo, null);
            system.handle_error(result == vk.VK_SUCCESS, "__vulkan.queue_submit_and_wait.vkQueueSubmit : {d}", .{result});
            submit_mutex.unlock();
            result = vk.vkQueueWaitIdle(__vulkan.vkGraphicsQueue);
            system.handle_error(result == vk.VK_SUCCESS, "__vulkan.queue_submit_and_wait.vkQueueWaitIdle : {d}", .{result});
        }

        for (op_save_queue.items) |*v| {
            if (v.* != null) {
                switch (v.*.?) {
                    //destroy.. 나중에
                    .destroy_buffer => execute_destroy_buffer(v.*.?.destroy_buffer.buf),
                    .destroy_image => execute_destroy_image(v.*.?.destroy_image.buf),
                    else => continue,
                }
                v.* = null;
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

        _ = staging_buf_queue.reset(.free_all);
        op_save_queue.resize(0) catch unreachable;
    }
}

var cond_cnt: bool = false;
//var finishcond_cnt: bool = false;

pub fn execute_and_wait_all_op() void {
    mutex.lock();
    if (op_queue.items.len > 0) {
        cond.signal();
        cond_cnt = true;
        finish_cond.wait(&mutex);
    }
    mutex.unlock();
}
pub fn execute_all_op() void {
    mutex.lock();
    if (op_queue.items.len > 0) {
        cond.signal();
        cond_cnt = true;
    }
    mutex.unlock();
}

pub fn lock_data() void {
    dataMutex.lock();
}
pub fn trylock_data() bool {
    return dataMutex.tryLock();
}
pub fn unlock_data() void {
    dataMutex.unlock();
}

// fn broadcast_op_finish() void {
//     mutex.lock();
//     finish_cond.broadcast();
//     mutex.unlock();
// }

fn find_memory_type(_type_filter: u32, _prop: vk.VkMemoryPropertyFlags) ?u32 {
    var i: u32 = 0;
    while (i < __vulkan.mem_prop.memoryTypeCount) : (i += 1) {
        if ((_type_filter & (@as(u32, 1) << @intCast(i)) != 0) and (__vulkan.mem_prop.memoryTypes[i].propertyFlags & _prop == _prop)) {
            return i;
        }
    }
    return null;
}

fn append_op(node: operation_node) void {
    mutex.lock();
    defer mutex.unlock();
    op_queue.append(node) catch system.handle_error_msg2("self.op_queue.append");
    // if (self.op_queue.items.len == 12) {
    //     unreachable;
    // }
}
fn append_op_save(node: operation_node) void {
    op_save_queue.append(node) catch system.handle_error_msg2("self.op_save_queue.append");
}

pub fn vulkan_res_node(_res_type: res_type) type {
    return struct {
        const vulkan_res_node_Self = @This();

        builded: bool = false,
        res: ivulkan_res(_res_type) = null,
        idx: *res_range = undefined,
        pvulkan_buffer: ?*vulkan_res = null,
        __image_view: if (_res_type == .texture) vk.VkImageView else void = if (_res_type == .texture) undefined,
        sampler: if (_res_type == .texture) vk.VkSampler else void = if (_res_type == .texture) null,
        texture_option: if (_res_type == .texture) texture_create_option else void = if (_res_type == .texture) undefined,
        buffer_option: if (_res_type == .buffer) buffer_create_option else void = if (_res_type == .buffer) undefined,
        map_data: ?[]u8 = null,

        pub inline fn is_build(self: *vulkan_res_node_Self) bool {
            return self.*.res != null;
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
                self.*.alloc_map();
                @memcpy(self.*.map_data.?[0.._data.len], _data);
                append_op(.{ .create_buffer = .{ .buf = self, .data = self.*.map_data.? } });
            } else {
                @compileError("_res_type need buffer");
            }
        }
        pub fn create_texture(self: *vulkan_res_node_Self, option: texture_create_option, _sampler: vk.VkSampler, _data: ?[]const u8) void {
            if (_res_type == .texture) {
                self.*.sampler = _sampler;
                self.*.texture_option = option;
                self.*.builded = true;
                append_op(.{ .create_texture = .{ .buf = self, .data = _data } });
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
                if (self.*.map_data != null) {
                    __system.allocator.free(self.*.map_data.?);
                    self.*.map_data = null;
                }
                if (self.*.pvulkan_buffer != null) self.*.pvulkan_buffer.?.*.unbind_res(self.*.res, self.*.idx);
                self.*.res = null;
            } else {
                @compileError("_res_type need buffer");
            }
        }
        fn __destroy_image(self: *vulkan_res_node_Self) void {
            if (_res_type == .texture) {
                if (self.*.map_data != null) {
                    __system.allocator.free(self.*.map_data.?);
                    self.*.map_data = null;
                }
                vk.vkDestroyImageView(__vulkan.vkDevice, self.*.__image_view, null);
                if (self.*.pvulkan_buffer != null) self.*.pvulkan_buffer.?.*.unbind_res(self.*.res, self.*.idx);
                self.*.res = null;
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
        ///copy_update와 달리 _data는 임시변수이면 안됩니다.
        fn alloc_map(self: *vulkan_res_node_Self) void {
            if (self.*.map_data == null) {
                if (_res_type == .buffer) {
                    self.*.map_data = __system.allocator.alloc(u8, self.*.buffer_option.len) catch unreachable;
                } else {
                    self.*.map_data = __system.allocator.alloc(u8, self.*.texture_option.width * self.*.texture_option.height * bit_size(self.*.texture_option.format)) catch unreachable;
                }
            }
        }
        pub fn map_update(self: *vulkan_res_node_Self, _data: anytype) void {
            const u8data = mem.obj_to_u8arrC(_data);
            self.*.map_copy(u8data);
        }
        pub fn copy_update(self: *vulkan_res_node_Self, _data: anytype) void {
            const u8data = mem.obj_to_u8arrC(_data);

            dataMutex.lock();
            self.*.alloc_map();
            @memcpy(self.*.map_data.?[0..u8data.len], u8data);
            self.*.map_copy(self.*.map_data.?[0..u8data.len]);
            dataMutex.unlock();
        }
        pub fn clean(self: *vulkan_res_node_Self) void {
            self.*.builded = false;

            switch (_res_type) {
                .texture => {
                    self.*.texture_option.len = 0;
                    if (self.*.pvulkan_buffer == null) {
                        vk.vkDestroyImageView(__vulkan.vkDevice, self.*.__image_view, null);
                    } else {
                        append_op(.{ .destroy_image = .{ .buf = self } });
                    }
                },
                .buffer => {
                    self.*.buffer_option.len = 0;
                    append_op(.{ .destroy_buffer = .{ .buf = self } });
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
    mem: vk.VkDeviceMemory,
    info: vk.VkMemoryAllocateInfo,
    single: bool = false, //single이 true면 무조건 디바이스 메모리에
    cached: bool = false,
    pool: MemoryPoolExtra(DoublyLinkedList(node).Node, .{}) = undefined,
    list: DoublyLinkedList(node) = undefined,

    ///! 따로 vulkan_res.deinit2를 호출하지 않는다.
    fn deinit2(self: *vulkan_res) void {
        vk.vkFreeMemory(__vulkan.vkDevice, self.*.mem, null);
        if (!self.*.single) {
            self.*.pool.deinit();
        }
    }
    fn map_copy_execute(self: *vulkan_res, nodes: []?operation_node) void {
        var start: usize = std.math.maxInt(usize);
        var end: usize = std.math.minInt(usize);
        var ranges: []vk.VkMappedMemoryRange = undefined;
        if (self.*.cached) {
            ranges = __system.allocator.alignedAlloc(vk.VkMappedMemoryRange, @alignOf(vk.VkMappedMemoryRange), nodes.len) catch unreachable;

            for (nodes, ranges) |v, *r| {
                const copy = v.?.map_copy;
                const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.ires.get_idx()));
                start = @min(start, nd.*.data.idx);
                end = @max(end, nd.*.data.idx + nd.*.data.size);
                r.memory = self.*.mem;
                r.size = nd.*.data.size * self.*.cell_size;
                r.offset = nd.*.data.idx * self.*.cell_size;
                r.offset = math.floor_up(r.offset, nonCoherentAtomSize);
                r.size = math.ceil_up(r.size, nonCoherentAtomSize);
                r.pNext = null;
                r.sType = vk.VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            }
        } else {
            for (nodes) |v| {
                const copy = v.?.map_copy;
                const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.ires.get_idx()));
                start = @min(start, nd.*.data.idx);
                end = @max(end, nd.*.data.idx + nd.*.data.size);
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
                _ = vk.vkInvalidateMappedMemoryRanges(__vulkan.vkDevice, @intCast(ranges.len), ranges.ptr);
            }
        }
        for (nodes) |v| {
            const copy = v.?.map_copy;
            const nd: *DoublyLinkedList(node).Node = @alignCast(@ptrCast(copy.ires.get_idx()));
            const st = (nd.*.data.idx - self.*.map_start) * self.*.cell_size;
            //const en = (nd.*.data.idx + nd.*.data.size - start) * self.*.cell_size;
            @memcpy(self.*.map_data[st..(st + copy.address.len)], copy.address[0..copy.address.len]);
        }
        if (self.*.cached) {
            _ = vk.vkFlushMappedMemoryRanges(__vulkan.vkDevice, @intCast(ranges.len), ranges.ptr);
            __system.allocator.free(ranges);
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
        if (!self.*.single) memory_idx_counts[self.*.info.memoryTypeIndex] -= 1;
        self.*.deinit2();
        buffers.destroy(self);
    }
    fn allocate_memory(_info: *const vk.VkMemoryAllocateInfo, _mem: *vk.VkDeviceMemory) bool {
        const result = vk.vkAllocateMemory(__vulkan.vkDevice, _info, null, _mem);

        return result == vk.VK_SUCCESS;
    }
    /// ! 따로 vulkan_res.init를 호출하지 않는다.
    fn init(_cell_size: usize, _len: usize, type_filter: u32, _prop: vk.VkMemoryPropertyFlags) ?vulkan_res {
        var res = vulkan_res{
            .cell_size = _cell_size,
            .len = _len,
            .mem = undefined,
            .info = .{
                .sType = vk.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
                .allocationSize = _len * _cell_size,
                .memoryTypeIndex = find_memory_type(type_filter, _prop) orelse return null,
            },
            .list = .{},
            .pool = MemoryPoolExtra(DoublyLinkedList(node).Node, .{}).init(__system.allocator),
            .cached = (_prop & vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT != 0) and (_prop & vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT != 0),
        };
        if (!allocate_memory(&res.info, &res.mem)) {
            return null;
        }

        res.list.append(res.pool.create() catch system.handle_error_msg2("vulkan_res.init.res.pool.create"));
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
                .sType = vk.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO,
                .allocationSize = _cell_size,
                .memoryTypeIndex = find_memory_type(type_filter, vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT) orelse unreachable,
            },
            .single = true,
        };
        if (!allocate_memory(&res.info, &res.mem)) unreachable;

        return res;
    }
    fn __bind_any(self: *vulkan_res, _mem: vk.VkDeviceMemory, _buf: anytype, _idx: u64) void {
        switch (@TypeOf(_buf)) {
            vk.VkBuffer => {
                const result = vk.vkBindBufferMemory(__vulkan.vkDevice, _buf, _mem, self.*.cell_size * _idx);
                system.handle_error(result == vk.VK_SUCCESS, "vulkan_res.__bind_any.vkBindBufferMemory code : {d}", .{result});
            },
            vk.VkImage => {
                const result = vk.vkBindImageMemory(__vulkan.vkDevice, _buf, _mem, self.*.cell_size * _idx);
                system.handle_error(result == vk.VK_SUCCESS, "vulkan_res.__bind_any.vkBindImageMemory code : {d}", .{result});
            },
            else => @compileError("__bind_any invaild res type."),
        }
    }
    fn map(self: *vulkan_res, _start: usize, _size: usize, _out_data: *?*anyopaque) void {
        const result = vk.vkMapMemory(
            __vulkan.vkDevice,
            self.*.mem,
            _start * self.*.cell_size,
            _size * self.*.cell_size,
            0,
            _out_data,
        );
        system.handle_error(result == vk.VK_SUCCESS, "vulkan_res.map.vkMapMemory code : {d}", .{result});
    }
    pub fn unmap(self: *vulkan_res) void {
        self.*.map_size = 0;
        vk.vkUnmapMemory(__vulkan.vkDevice, self.*.mem);
    }
    fn bind_any(self: *vulkan_res, _buf: anytype, _cell_count: usize) ERROR!?*res_range {
        if (_cell_count == 0) unreachable;
        if (self.*.single) {
            __bind_any(self, self.*.mem, _buf, 0);
            return null;
        }
        //system.print("start:{d}, size:{d}, free:{}\n", .{ self.*.cur.*.data.idx, self.*.cur.*.data.size, self.*.cur.*.data.free });
        var cur = self.*.cur;
        while (true) {
            if (cur.*.data.free and _cell_count <= cur.*.data.size) break;
            cur = cur.*.next orelse self.*.list.first.?;
            if (cur == self.*.cur) {
                return ERROR.device_memory_limit;
            }
        }
        //system.print("end:{d}, size:{d}, count:{d}\n", .{ cur.*.data.idx, cur.*.data.size, _cell_count });
        __bind_any(self, self.*.mem, _buf, cur.*.data.idx);
        cur.*.data.free = false;
        const remain = cur.*.data.size - _cell_count;
        self.*.cur = cur;
        const res: *res_range = @alignCast(@ptrCast(cur));
        const cur2 = cur.*.next orelse self.*.list.first.?;
        if (cur == cur2) {
            if (remain > 0) {
                self.*.list.append(self.*.pool.create() catch system.handle_error_msg2("vulkan_res.bind_any.pool.create"));
                self.*.list.last.?.*.data.free = true;
                self.*.list.last.?.*.data.size = remain;
                self.*.list.last.?.*.data.idx = _cell_count;
            }
        } else {
            if (remain > 0) {
                if (cur2.*.data.free) {
                    if (cur2.*.data.idx < cur.*.data.idx) {
                        self.*.list.insertAfter(cur, self.*.pool.create() catch system.handle_error_msg2("vulkan_res.bind_any.pool.create"));
                        cur.*.next.?.*.data.free = true;
                        cur.*.next.?.*.data.idx = cur.*.data.idx + _cell_count;
                        cur.*.next.?.*.data.size = remain;
                    } else {
                        cur2.*.data.idx -= remain;
                        cur2.*.data.size += remain;
                    }
                } else {
                    self.*.list.insertAfter(cur, self.*.pool.create() catch system.handle_error_msg2("vulkan_res.bind_any.pool.create"));
                    cur.*.next.?.*.data.free = true;
                    cur.*.next.?.*.data.idx = cur.*.data.idx + _cell_count;
                    cur.*.next.?.*.data.size = remain;
                }
            }
        }
        cur.*.data.size = _cell_count;
        return res;
    }
    ///bind_buffer에서 반환된 _res를 사용.
    fn unbind_res(self: *vulkan_res, _buf: anytype, _res: *res_range) void {
        if (self.*.single) {
            switch (@TypeOf(_buf)) {
                vk.VkBuffer => vk.vkDestroyBuffer(__vulkan.vkDevice, _buf, null),
                vk.VkImage => vk.vkDestroyImage(__vulkan.vkDevice, _buf, null),
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
            vk.VkBuffer => vk.vkDestroyBuffer(__vulkan.vkDevice, _buf, null),
            vk.VkImage => vk.vkDestroyImage(__vulkan.vkDevice, _buf, null),
            else => @compileError("invaild buf type"),
        }
        if (self.*.len == 1 or memory_idx_counts[self.*.info.memoryTypeIndex] > MAX_IDX_COUNT) {
            for (buffer_ids.items) |v| {
                if (self != v and self.*.info.memoryTypeIndex == v.*.info.memoryTypeIndex) {
                    if (v.*.is_empty()) {
                        memory_idx_counts[v.*.info.memoryTypeIndex] -= 1;
                        v.*.deinit();
                    }
                }
            }
            if (self.*.is_empty()) {
                memory_idx_counts[self.*.info.memoryTypeIndex] -= 1;
                self.*.deinit();
            }
        }
    }
};

fn create_allocator_and_bind(_res: anytype, _prop: vk.VkMemoryPropertyFlags, _out_idx: **res_range, _max_size: usize) *vulkan_res {
    var res: ?*vulkan_res = null;
    var mem_require: vk.VkMemoryRequirements = undefined;
    if (@TypeOf(_res) == vk.VkBuffer) {
        vk.vkGetBufferMemoryRequirements(__vulkan.vkDevice, _res, &mem_require);
    } else if (@TypeOf(_res) == vk.VkImage) {
        vk.vkGetImageMemoryRequirements(__vulkan.vkDevice, _res, &mem_require);
    } else {
        unreachable;
    }
    var max_size = _max_size;
    if (max_size < @as(usize, @intCast(mem_require.size))) {
        max_size = @intCast(mem_require.size);
    }
    var prop = _prop;
    if (@TypeOf(_res) == vk.VkBuffer and max_size <= 256 and prop & vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT != 0) {
        if (supported_cache_local) {
            prop = vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT | vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
        } else if (supported_noncache_local) {
            prop = vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT | vk.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
        }
    }
    const cnt = std.math.divCeil(usize, max_size, @intCast(mem_require.alignment)) catch 1;
    for (buffer_ids.items) |value| {
        if (value.*.cell_size != mem_require.alignment) continue;
        const tt = find_memory_type(mem_require.memoryTypeBits, prop) orelse blk: {
            prop = _prop;
            break :blk find_memory_type(mem_require.memoryTypeBits, prop) orelse unreachable;
        };
        if (value.*.info.memoryTypeIndex != tt) continue;
        _out_idx.* = value.*.bind_any(_res, cnt) catch continue orelse unreachable;
        //system.print_debug("(1) {d} {d} {d} {d}", .{ max_size, value.*.cell_size, value.*.len, mem_require.alignment });
        res = value;
        break;
    }
    if (res == null) {
        res = buffers.create() catch |err| {
            system.print_error("ERR {s} __vulkan_allocator.create_allocator_and_bind.self.*.buffers.create\n", .{@errorName(err)});
            unreachable;
        };

        // system.print_debug("(2) {d} {d} {d}", .{
        //     max_size,
        //     std.math.divCeil(usize, BLOCK_LEN, std.math.divCeil(usize, cell, NODE_SIZE) catch 1) catch 1,
        //     _mem_require.*.alignment,
        // });
        const flag = (vk.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT);
        var BLK = if (prop & flag == flag) SPECIAL_BLOCK_LEN else BLOCK_LEN;
        if (prop & vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT != 0) {
            max_size = math.ceil_up(max_size, nonCoherentAtomSize);
            BLK = math.ceil_up(BLK, nonCoherentAtomSize);
        }
        const R = vulkan_res.init(
            @intCast(mem_require.alignment),
            std.math.divCeil(usize, @max(BLK, max_size), @intCast(mem_require.alignment)) catch 1,
            mem_require.memoryTypeBits,
            prop,
        );
        if (R == null) {
            buffers.destroy(res.?);
            res = null;
            prop = vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT | vk.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
            for (buffer_ids.items) |value| {
                if (value.*.cell_size != mem_require.alignment) continue;
                const tt = find_memory_type(mem_require.memoryTypeBits, prop) orelse unreachable;
                if (value.*.info.memoryTypeIndex != tt) continue;
                _out_idx.* = value.*.bind_any(_res, cnt) catch continue orelse unreachable;
                res = value;
                break;
            }
            if (res == null) {
                BLK = BLOCK_LEN;
                if (prop & vk.VK_MEMORY_PROPERTY_HOST_CACHED_BIT != 0) {
                    max_size = math.ceil_up(max_size, nonCoherentAtomSize);
                    BLK = math.ceil_up(BLK, nonCoherentAtomSize);
                }
                res.?.* = vulkan_res.init(
                    @intCast(mem_require.alignment),
                    std.math.divCeil(usize, @max(BLOCK_LEN, max_size), @intCast(mem_require.alignment)) catch 1,
                    mem_require.memoryTypeBits,
                    prop,
                ) orelse unreachable;
            }
        } else {
            res.?.* = R.?;
        }

        _out_idx.* = res.?.*.bind_any(_res, cnt) catch unreachable orelse unreachable; //발생할수 없는 오류
        buffer_ids.append(res.?) catch |err| {
            system.print_error("ERR {s} __vulkan_allocator.create_allocator_and_bind.self.*.buffer_ids.append\n", .{@errorName(err)});
            unreachable;
        };
    }
    memory_idx_counts[res.?.*.info.memoryTypeIndex] += 1;
    return res.?;
}

fn create_allocator_and_bind_single(_res: anytype) *vulkan_res {
    var res: ?*vulkan_res = null;
    var mem_require: vk.VkMemoryRequirements = undefined;
    if (@TypeOf(_res) == vk.VkBuffer) {
        vk.vkGetBufferMemoryRequirements(__vulkan.vkDevice, _res, &mem_require);
    } else if (@TypeOf(_res) == vk.VkImage) {
        vk.vkGetImageMemoryRequirements(__vulkan.vkDevice, _res, &mem_require);
    } else {
        unreachable;
    }

    const max_size: usize = @intCast(mem_require.size);
    res = buffers.create() catch |err| {
        system.handle_error3("__vulkan_allocator.create_allocator_and_bind.self.*.buffers.create", err);
    };

    res.?.* = vulkan_res.init_single(max_size, mem_require.memoryTypeBits);

    _ = res.?.*.bind_any(_res, 1) catch unreachable; //발생할수 없는 오류
    buffer_ids.append(res.?) catch |err| {
        system.handle_error3("__vulkan_allocator.create_allocator_and_bind.buffer_ids.append", err);
    };
    return res.?;
}
