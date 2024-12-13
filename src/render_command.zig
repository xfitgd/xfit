const std = @import("std");
const ArrayList = std.ArrayList;

const system = @import("system.zig");
const __system = @import("__system.zig");
const xfit = @import("xfit.zig");

const dbg = xfit.dbg;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

const _allocator = __system.allocator;

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;

const graphics = @import("graphics.zig");
const __render_command = @import("__render_command.zig");

pub const MAX_FRAME: usize = 3;

pub var mutex: std.Thread.Mutex = .{};

__refesh: [MAX_FRAME]bool = .{true} ** MAX_FRAME,
__command_buffers: [MAX_FRAME][]vk.CommandBuffer = undefined,
scene: ?[]graphics.iobject = null,
offscreen_image: ?*graphics.image = null,
///!you have to lock this add or modify iobject 'scene'
objs_mutex: std.Thread.Mutex = .{},
const Self = @This();

pub fn init() *Self {
    const self = __system.allocator.create(Self) catch
        xfit.herrm("__system.allocator.create render_command");
    self.* = .{};
    __vulkan.load_instance_and_device();
    mutex.lock();
    defer mutex.unlock();

    for (&self.*.__command_buffers) |*cmd| {
        cmd.* = __system.allocator.alloc(vk.CommandBuffer, __vulkan.get_swapchain_image_length()) catch
            xfit.herrm("render_command.__command_buffers.alloc");

        const allocInfo: vk.CommandBufferAllocateInfo = .{
            .command_pool = __vulkan.vkCommandPool,
            .level = .primary,
            .command_buffer_count = @intCast(__vulkan.get_swapchain_image_length()),
        };

        __vulkan.vkd.?.allocateCommandBuffers(&allocInfo, cmd.*.ptr) catch |e|
            xfit.herr3("render_command vkAllocateCommandBuffers vkCommandPool", e);
    }

    __render_command.render_cmd_list.?.append(self) catch xfit.herrm(" render_cmd_list.append(&self)");
    return self;
}
// pub fn __refresh_cmds(self: *Self) void {
//     __vulkan.load_instance_and_device();
//     for (&self.__command_buffers) |*cmd| {
//         if (cmd.*.len == __vulkan.get_swapchain_image_length()) continue;
//         __vulkan.vkd.?.freeCommandBuffers(__vulkan.vkCommandPool, @intCast(cmd.*.len), cmd.*.ptr);
//         __system.allocator.free(cmd.*);

//         cmd.* = __system.allocator.alloc(vk.CommandBuffer, __vulkan.get_swapchain_image_length()) catch
//             xfit.herrm("render_command.__command_buffers.alloc");

//         const allocInfo: vk.CommandBufferAllocateInfo = .{
//             .command_pool = __vulkan.vkCommandPool,
//             .level = .primary,
//             .command_buffer_count = @intCast(__vulkan.get_swapchain_image_length()),
//         };

//         __vulkan.vkd.?.allocateCommandBuffers(&allocInfo, cmd.*.ptr) catch |e|
//             xfit.herr3("render_command vkAllocateCommandBuffers vkCommandPool", e);
//     }
// }
pub fn deinit(self: *Self) void {
    __vulkan.load_instance_and_device();
    for (&self.__command_buffers) |*cmd| {
        __vulkan.vkd.?.freeCommandBuffers(__vulkan.vkCommandPool, @intCast(self.__command_buffers.len), cmd.*.ptr);
        __system.allocator.free(cmd.*);
    }
    var i: usize = 0;
    mutex.lock();
    while (i < __render_command.render_cmd_list.?.items.len) : (i += 1) {
        if (__render_command.render_cmd_list.?.items[i] == self) {
            _ = __render_command.render_cmd_list.?.orderedRemove(i);
            break;
        }
    }
    mutex.unlock();
    __system.allocator.destroy(self);
}

///call when scene(composition) in render_command changes
///no need to call when iobject internal resource values change
pub fn refresh(self: *Self) void {
    for (&self.*.__refesh) |*v| {
        @atomicStore(bool, v, true, .monotonic);
    }
}

const ERROR = error{IsDestroying};
