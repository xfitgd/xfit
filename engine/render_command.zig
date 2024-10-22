const std = @import("std");
const ArrayList = std.ArrayList;

const system = @import("system.zig");
const __system = @import("__system.zig");

const dbg = system.dbg;

const __vulkan_allocator = @import("__vulkan_allocator.zig");

const _allocator = __system.allocator;

const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;

const graphics = @import("graphics.zig");
const __render_command = @import("__render_command.zig");

pub const MAX_FRAME: usize = 3;

__refesh: [MAX_FRAME]bool = .{true} ** MAX_FRAME,
__command_buffers: [MAX_FRAME][]vk.VkCommandBuffer = undefined,
scene: ?[]*graphics.iobject = null,
const Self = @This();

pub fn init() *Self {
    const self = __system.allocator.create(Self) catch
        system.handle_error_msg2("__system.allocator.create render_command");
    self.* = .{};
    for (&self.*.__command_buffers) |*cmd| {
        cmd.* = __system.allocator.alloc(vk.VkCommandBuffer, __vulkan.get_swapchain_image_length()) catch
            system.handle_error_msg2("render_command.__command_buffers.alloc");

        const allocInfo: vk.VkCommandBufferAllocateInfo = .{
            .commandPool = __vulkan.vkCommandPool,
            .level = vk.VK_COMMAND_BUFFER_LEVEL_PRIMARY,
            .commandBufferCount = @intCast(__vulkan.get_swapchain_image_length()),
            .sType = vk.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
        };

        const result = vk.vkAllocateCommandBuffers(
            __vulkan.vkDevice,
            &allocInfo,
            cmd.*.ptr,
        );
        system.handle_error(result == vk.VK_SUCCESS, "render_command vkAllocateCommandBuffers vkCommandPool : {d}", .{result});
    }
    __render_command.mutex.lock();
    __render_command.render_cmd_list.append(self) catch system.handle_error_msg2(" render_cmd_list.append(&self)");
    __render_command.mutex.unlock();
    return self;
}
pub fn deinit(self: *Self) void {
    for (&self.__command_buffers) |*cmd| {
        vk.vkFreeCommandBuffers(__vulkan.vkDevice, __vulkan.vkCommandPool, @intCast(__vulkan.get_swapchain_image_length()), cmd.*.ptr);
        __system.allocator.free(cmd.*);
    }
    var i: usize = 0;
    __render_command.mutex.lock();
    while (i < __render_command.render_cmd_list.items.len) : (i += 1) {
        if (__render_command.render_cmd_list.items[i] == self) {
            _ = __render_command.render_cmd_list.orderedRemove(i);
            break;
        }
    }
    __render_command.mutex.unlock();
    __system.allocator.destroy(self);
}

///render_command안의 scene(구성)이 바뀔때 마다 호출(scene 내의 iobject 내부 리소스 값이 바뀔경우는 해당없음)
pub fn refresh(self: *Self) void {
    for (&self.*.__refesh) |*v| {
        @atomicStore(bool, v, true, .monotonic);
    }
}

const ERROR = error{IsDestroying};
