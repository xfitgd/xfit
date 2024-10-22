const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const MemoryPoolExtra = std.heap.MemoryPoolExtra;

const __windows = @import("__windows.zig");
const window = @import("window.zig");
const __android = @import("__android.zig");
const system = @import("system.zig");
const math = @import("math.zig");
const matrix = math.matrix;
const graphics = @import("graphics.zig");
const render_command = @import("render_command.zig");
const __render_command = @import("__render_command.zig");
const __system = @import("__system.zig");
const root = @import("root");

const __vulkan_allocator = @import("__vulkan_allocator.zig");

pub var mem_prop: vk.VkPhysicalDeviceMemoryProperties = undefined;

pub const vk = @import("include/vulkan.zig");

const shape_curve_vert = @embedFile("shaders/out/shape_curve_vert.spv");
const shape_curve_frag = @embedFile("shaders/out/shape_curve_frag.spv");
var shape_curve_vert_shader: vk.VkShaderModule = undefined;
var shape_curve_frag_shader: vk.VkShaderModule = undefined;

const quad_shape_vert = @embedFile("shaders/out/quad_shape_vert.spv");
const quad_shape_frag = @embedFile("shaders/out/quad_shape_frag.spv");
var quad_shape_vert_shader: vk.VkShaderModule = undefined;
var quad_shape_frag_shader: vk.VkShaderModule = undefined;

const tex_vert = @embedFile("shaders/out/tex_vert.spv");
const tex_frag = @embedFile("shaders/out/tex_frag.spv");
var tex_vert_shader: vk.VkShaderModule = undefined;
var tex_frag_shader: vk.VkShaderModule = undefined;

const animate_tex_vert = @embedFile("shaders/out/animate_tex_vert.spv");
const animate_tex_frag = @embedFile("shaders/out/animate_tex_frag.spv");
var animate_tex_vert_shader: vk.VkShaderModule = undefined;
var animate_tex_frag_shader: vk.VkShaderModule = undefined;

pub var __pre_mat_uniform: __vulkan_allocator.vulkan_res_node(.buffer) = .{};

pub var queue_mutex: std.Thread.Mutex = .{};

pub const pipeline_set = struct {
    pipeline: vk.VkPipeline = null,
    pipelineLayout: vk.VkPipelineLayout = null,
    descriptorSetLayout: vk.VkDescriptorSetLayout = null,
    descriptorSetLayout2: vk.VkDescriptorSetLayout = null,
};

//Predefined Pipelines
pub var shape_color_2d_pipeline_set: pipeline_set = .{};
//pub var color_2d_pipeline_set: pipeline_set = .{};
///tex_2d_pipeline_set의 descriptorSetLayout2는 animate_tex_2d_pipeline_set의 그것과 공유
pub var tex_2d_pipeline_set: pipeline_set = .{};
pub var quad_shape_2d_pipeline_set: pipeline_set = .{};
pub var animate_tex_2d_pipeline_set: pipeline_set = .{};
//pub var copy_screen_pipeline_set: pipeline_set = .{};
//

var shape_curve_shader_stages: [2]vk.VkPipelineShaderStageCreateInfo = undefined;
var quad_shape_shader_stages: [2]vk.VkPipelineShaderStageCreateInfo = undefined;
var tex_shader_stages: [2]vk.VkPipelineShaderStageCreateInfo = undefined;
var animate_tex_shader_stages: [2]vk.VkPipelineShaderStageCreateInfo = undefined;

pub var properties: vk.VkPhysicalDeviceProperties = undefined;
const inputAssembly: vk.VkPipelineInputAssemblyStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO,
    .topology = vk.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
    .primitiveRestartEnable = vk.VK_FALSE,
};

pub var is_fullscreen_ex: bool = false;

const dynamicStates = [_]vk.VkDynamicState{ vk.VK_DYNAMIC_STATE_VIEWPORT, vk.VK_DYNAMIC_STATE_SCISSOR };

const dynamicState: vk.VkPipelineDynamicStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO,
    .dynamicStateCount = dynamicStates.len,
    .pDynamicStates = &dynamicStates,
};

const viewportState: vk.VkPipelineViewportStateCreateInfo = .{
    .flags = 0,
    .viewportCount = 1,
    .pViewports = null,
    .scissorCount = 1,
    .pScissors = null,
};

const rasterizer: vk.VkPipelineRasterizationStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO,
    .depthClampEnable = vk.VK_FALSE,
    .rasterizerDiscardEnable = vk.VK_FALSE,
    .polygonMode = vk.VK_POLYGON_MODE_FILL,
    .lineWidth = 1,
    .cullMode = vk.VK_CULL_MODE_NONE,
    .frontFace = vk.VK_FRONT_FACE_CLOCKWISE,
    .depthBiasEnable = vk.VK_FALSE,
    .depthBiasConstantFactor = 0,
    .depthBiasClamp = 0,
    .depthBiasSlopeFactor = 0,
};

const multisampling: vk.VkPipelineMultisampleStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
    .sampleShadingEnable = vk.VK_FALSE,
    .rasterizationSamples = vk.VK_SAMPLE_COUNT_1_BIT,
    .minSampleShading = 1,
    .pSampleMask = null,
    .alphaToCoverageEnable = vk.VK_FALSE,
    .alphaToOneEnable = vk.VK_FALSE,
};

const multisampling4: vk.VkPipelineMultisampleStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO,
    .sampleShadingEnable = vk.VK_FALSE,
    .rasterizationSamples = vk.VK_SAMPLE_COUNT_4_BIT,
    .minSampleShading = 1,
    .pSampleMask = null,
    .alphaToCoverageEnable = vk.VK_FALSE,
    .alphaToOneEnable = vk.VK_FALSE,
};

const colorBlendAttachment: vk.VkPipelineColorBlendAttachmentState = .{
    .colorWriteMask = vk.VK_COLOR_COMPONENT_R_BIT | vk.VK_COLOR_COMPONENT_G_BIT | vk.VK_COLOR_COMPONENT_B_BIT | vk.VK_COLOR_COMPONENT_A_BIT,
    .blendEnable = vk.VK_FALSE,
    .srcColorBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstColorBlendFactor = vk.VK_BLEND_FACTOR_ZERO,
    .colorBlendOp = vk.VK_BLEND_OP_ADD,
    .srcAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstAlphaBlendFactor = vk.VK_BLEND_FACTOR_ZERO,
    .alphaBlendOp = vk.VK_BLEND_OP_ADD,
};

const colorAlphaBlendAttachment: vk.VkPipelineColorBlendAttachmentState = .{
    .colorWriteMask = vk.VK_COLOR_COMPONENT_R_BIT | vk.VK_COLOR_COMPONENT_G_BIT | vk.VK_COLOR_COMPONENT_B_BIT | vk.VK_COLOR_COMPONENT_A_BIT,
    .blendEnable = vk.VK_TRUE,
    .srcColorBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstColorBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .colorBlendOp = vk.VK_BLEND_OP_ADD,
    .srcAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .alphaBlendOp = vk.VK_BLEND_OP_ADD,
};

///https://stackoverflow.com/a/34963588
const colorAlphaBlendAttachmentExternal: vk.VkPipelineColorBlendAttachmentState = .{
    .colorWriteMask = vk.VK_COLOR_COMPONENT_R_BIT | vk.VK_COLOR_COMPONENT_G_BIT | vk.VK_COLOR_COMPONENT_B_BIT | vk.VK_COLOR_COMPONENT_A_BIT,
    .blendEnable = vk.VK_TRUE,
    .srcColorBlendFactor = vk.VK_BLEND_FACTOR_SRC_ALPHA,
    .dstColorBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .colorBlendOp = vk.VK_BLEND_OP_ADD,
    .srcAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .alphaBlendOp = vk.VK_BLEND_OP_ADD,
};
const colorAlphaBlendAttachmentCopy: vk.VkPipelineColorBlendAttachmentState = .{
    .colorWriteMask = vk.VK_COLOR_COMPONENT_R_BIT | vk.VK_COLOR_COMPONENT_G_BIT | vk.VK_COLOR_COMPONENT_B_BIT | vk.VK_COLOR_COMPONENT_A_BIT,
    .blendEnable = vk.VK_TRUE,
    .srcColorBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstColorBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .colorBlendOp = vk.VK_BLEND_OP_ADD,
    .srcAlphaBlendFactor = vk.VK_BLEND_FACTOR_ZERO,
    .dstAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .alphaBlendOp = vk.VK_BLEND_OP_ADD,
};

const noBlendAttachment: vk.VkPipelineColorBlendAttachmentState = .{
    .colorWriteMask = 0,
    .blendEnable = vk.VK_FALSE,
    .srcColorBlendFactor = vk.VK_BLEND_FACTOR_SRC_ALPHA,
    .dstColorBlendFactor = vk.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    .colorBlendOp = vk.VK_BLEND_OP_ADD,
    .srcAlphaBlendFactor = vk.VK_BLEND_FACTOR_ONE,
    .dstAlphaBlendFactor = vk.VK_BLEND_FACTOR_ZERO,
    .alphaBlendOp = vk.VK_BLEND_OP_ADD,
};

const colorBlending: vk.VkPipelineColorBlendStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    .logicOpEnable = vk.VK_FALSE,
    .logicOp = vk.VK_LOGIC_OP_COPY,
    .attachmentCount = 1,
    .pAttachments = @ptrCast(&colorBlendAttachment),
    .blendConstants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlending: vk.VkPipelineColorBlendStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    .logicOpEnable = vk.VK_FALSE,
    .logicOp = vk.VK_LOGIC_OP_COPY,
    .attachmentCount = 1,
    .pAttachments = @ptrCast(&colorAlphaBlendAttachment),
    .blendConstants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlendingExternal: vk.VkPipelineColorBlendStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    .logicOpEnable = vk.VK_FALSE,
    .logicOp = vk.VK_LOGIC_OP_COPY,
    .attachmentCount = 1,
    .pAttachments = @ptrCast(&colorAlphaBlendAttachmentExternal),
    .blendConstants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlendingCopy: vk.VkPipelineColorBlendStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    .logicOpEnable = vk.VK_FALSE,
    .logicOp = vk.VK_LOGIC_OP_COPY,
    .attachmentCount = 1,
    .pAttachments = @ptrCast(&colorAlphaBlendAttachmentCopy),
    .blendConstants = .{ 0, 0, 0, 0 },
};

const noBlending: vk.VkPipelineColorBlendStateCreateInfo = .{
    .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO,
    .logicOpEnable = vk.VK_FALSE,
    .logicOp = vk.VK_LOGIC_OP_COPY,
    .attachmentCount = 1,
    .pAttachments = &noBlendAttachment,
    .blendConstants = .{ 0, 0, 0, 0 },
};

fn chooseSwapExtent(capabilities: vk.VkSurfaceCapabilitiesKHR) vk.VkExtent2D {
    if (capabilities.currentExtent.width != std.math.maxInt(u32)) {
        return capabilities.currentExtent;
    } else {
        var swapchainExtent = if (system.platform == .android)
            vk.VkExtent2D{ .width = @max(0, __android.android.ANativeWindow_getWidth(__android.app.window)), .height = @max(0, __android.android.ANativeWindow_getHeight(__android.app.window)) }
        else
            vk.VkExtent2D{ .width = @max(0, window.window_width()), .height = @max(0, window.window_height()) };
        swapchainExtent.width = std.math.clamp(swapchainExtent.width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
        swapchainExtent.height = std.math.clamp(swapchainExtent.height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);
        return swapchainExtent;
    }
}

fn chooseSwapSurfaceFormat(availableFormats: []vk.VkSurfaceFormatKHR) vk.VkSurfaceFormatKHR {
    for (availableFormats) |value| {
        switch (value.format) {
            vk.VK_FORMAT_R8G8B8A8_UNORM, vk.VK_FORMAT_R8G8B8A8_SRGB => return value,
            else => {},
        }
    }
    system.handle_error2("unsupported device format {any}", .{availableFormats});
}

fn chooseSwapPresentMode(availablePresentModes: []vk.VkPresentModeKHR, _vSync: bool) vk.VkPresentModeKHR {
    if (_vSync) return vk.VK_PRESENT_MODE_FIFO_KHR;
    for (availablePresentModes) |value| {
        if (value == vk.VK_PRESENT_MODE_IMMEDIATE_KHR) { //VK_PRESENT_MODE_MAILBOX_KHR
            return value;
        }
    }
    return vk.VK_PRESENT_MODE_FIFO_KHR;
}
inline fn create_frag_shader_state(frag_module: vk.VkShaderModule) vk.VkPipelineShaderStageCreateInfo {
    return .{
        .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
        .module = frag_module,
        .pName = "main",
    };
}

inline fn create_shader_state(vert_module: vk.VkShaderModule, frag_module: vk.VkShaderModule) [2]vk.VkPipelineShaderStageCreateInfo {
    const stage_infov1: vk.VkPipelineShaderStageCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk.VK_SHADER_STAGE_VERTEX_BIT,
        .module = vert_module,
        .pName = "main",
    };
    const stage_infof1: vk.VkPipelineShaderStageCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO,
        .stage = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
        .module = frag_module,
        .pName = "main",
    };

    return [2]vk.VkPipelineShaderStageCreateInfo{ stage_infov1, stage_infof1 };
}

pub var vkInstance: vk.VkInstance = undefined;
pub var vkDevice: vk.VkDevice = null;
pub var vkSurface: vk.VkSurfaceKHR = null;
pub var vkRenderPass: vk.VkRenderPass = undefined;
pub var vkRenderPassSampleClear: vk.VkRenderPass = undefined;
pub var vkSwapchain: vk.VkSwapchainKHR = null;

pub var vkCommandPool: vk.VkCommandPool = undefined;
pub var vkCommandBuffer: vk.VkCommandBuffer = undefined;

var vkImageAvailableSemaphore: [render_command.MAX_FRAME]vk.VkSemaphore = .{null} ** render_command.MAX_FRAME;
var vkRenderFinishedSemaphore: [render_command.MAX_FRAME]vk.VkSemaphore = .{null} ** render_command.MAX_FRAME;

pub var vkInFlightFence: [render_command.MAX_FRAME]vk.VkFence = .{null} ** render_command.MAX_FRAME;

var vkDebugMessenger: vk.VkDebugUtilsMessengerEXT = null;

pub var vkGraphicsQueue: vk.VkQueue = undefined;
var vkPresentQueue: vk.VkQueue = undefined;

pub var vkExtent: vk.VkExtent2D = undefined;
var vkExtent_rotation: vk.VkExtent2D = undefined;
pub var vk_swapchain_frame_buffers: []__vulkan_allocator.frame_buffer = undefined;
pub var vk_swapchain_frame_buffer_clears: []__vulkan_allocator.frame_buffer = undefined;
var vk_swapchain_images: []__vulkan_allocator.vulkan_res_node(.texture) = undefined;

pub var vk_physical_device: vk.VkPhysicalDevice = undefined;

pub var graphicsFamilyIndex: u32 = std.math.maxInt(u32);
var presentFamilyIndex: u32 = std.math.maxInt(u32);
var queueFamiliesCount: u32 = 0;

pub var surfaceCap: vk.VkSurfaceCapabilitiesKHR = undefined;

var formats: []vk.VkSurfaceFormatKHR = undefined;
var format: vk.VkSurfaceFormatKHR = undefined;

pub var linear_sampler: vk.VkSampler = undefined;
pub var nearest_sampler: vk.VkSampler = undefined;
pub var quad_image_vertices: graphics.vertices(graphics.tex_vertex_2d) = undefined;
pub var quad_image_vertices_array: [6]graphics.tex_vertex_2d = .{
    graphics.tex_vertex_2d{
        .pos = .{ -0.5, 0.5 },
        .uv = .{ 0, 0 },
    },
    graphics.tex_vertex_2d{
        .pos = .{ 0.5, 0.5 },
        .uv = .{ 1, 0 },
    },
    graphics.tex_vertex_2d{
        .pos = .{ -0.5, -0.5 },
        .uv = .{ 0, 1 },
    },
    graphics.tex_vertex_2d{
        .pos = .{ 0.5, 0.5 },
        .uv = .{ 1, 0 },
    },
    graphics.tex_vertex_2d{
        .pos = .{ 0.5, -0.5 },
        .uv = .{ 1, 1 },
    },
    graphics.tex_vertex_2d{
        .pos = .{ -0.5, -0.5 },
        .uv = .{ 0, 1 },
    },
};
pub var no_color_tran: graphics.color_transform = undefined;

pub var depth_stencil_image_sample = __vulkan_allocator.vulkan_res_node(.texture){};
pub var color_image_sample = __vulkan_allocator.vulkan_res_node(.texture){};

fn createShaderModule(code: []const u8) vk.VkShaderModule {
    const createInfo: vk.VkShaderModuleCreateInfo = .{ .codeSize = code.len, .pCode = code.ptr };

    var shaderModule: vk.VkShaderModule = undefined;
    const result = vk.vkCreateShaderModule(vkDevice, &createInfo, null, &shaderModule);

    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.createShaderModule.vkCreateShaderModule : {d}", .{result});

    return shaderModule;
}

fn create_sync_object() void {
    var i: usize = 0;
    while (i < render_command.MAX_FRAME) : (i += 1) {
        const semaphoreInfo: vk.VkSemaphoreCreateInfo = .{ .sType = vk.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO };
        const fenceInfo: vk.VkFenceCreateInfo = .{ .flags = vk.VK_FENCE_CREATE_SIGNALED_BIT, .sType = vk.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO };

        var result = vk.vkCreateSemaphore(vkDevice, &semaphoreInfo, null, &vkImageAvailableSemaphore[i]);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateSemaphore vkImageAvailableSemaphore : {d}", .{result});
        result = vk.vkCreateSemaphore(vkDevice, &semaphoreInfo, null, &vkRenderFinishedSemaphore[i]);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateSemaphore vkRenderFinishedSemaphore : {d}", .{result});

        result = vk.vkCreateFence(vkDevice, &fenceInfo, null, &vkInFlightFence[i]);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateFence vkInFlightFence : {d}", .{result});
    }
}

fn cleanup_sync_object() void {
    var i: usize = 0;
    while (i < render_command.MAX_FRAME) : (i += 1) {
        vk.vkDestroySemaphore(vkDevice, vkImageAvailableSemaphore[i], null);
        vk.vkDestroySemaphore(vkDevice, vkRenderFinishedSemaphore[i], null);
        vk.vkDestroyFence(vkDevice, vkInFlightFence[i], null);
    }
}

fn recordCommandBuffer(commandBuffer: **render_command, fr: u32) void {
    if (commandBuffer.*.scene == null or commandBuffer.*.scene.?.len == 0) {
        return;
    }
    var i: usize = 0;
    if (commandBuffer.*.*.__command_buffers[fr].len < get_swapchain_image_length()) {
        commandBuffer.*.*.deinit();
        commandBuffer.* = render_command.init();
    }
    while (i < commandBuffer.*.*.__command_buffers[fr].len) : (i += 1) {
        const cmd = commandBuffer.*.*.__command_buffers[fr][i];
        const beginInfo: vk.VkCommandBufferBeginInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
            .flags = 0,
            .pInheritanceInfo = null,
        };
        var result = vk.vkBeginCommandBuffer(cmd, &beginInfo);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.recordCommandBuffer.vkBeginCommandBuffer : {d}", .{result});

        const clearColor: vk.VkClearValue = .{ .color = .{ .float32 = .{ 0, 0, 0, 0 } } };
        const clearDepthStencil: vk.VkClearValue = .{ .depthStencil = .{ .stencil = 0, .depth = 0 } };
        const renderPassInfo: vk.VkRenderPassBeginInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
            .renderPass = vkRenderPass,
            .framebuffer = vk_swapchain_frame_buffers[i].res,
            .renderArea = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
            .clearValueCount = 2,
            .pClearValues = &[_]vk.VkClearValue{ clearColor, clearDepthStencil },
        };

        vk.vkCmdBeginRenderPass(cmd, &renderPassInfo, vk.VK_SUBPASS_CONTENTS_INLINE);
        const viewport: vk.VkViewport = .{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(vkExtent_rotation.width),
            .height = @floatFromInt(vkExtent_rotation.height),
            .maxDepth = 1,
            .minDepth = 0,
        };
        const scissor: vk.VkRect2D = .{ .offset = vk.VkOffset2D{ .x = 0, .y = 0 }, .extent = vkExtent_rotation };

        vk.vkCmdSetViewport(cmd, 0, 1, @ptrCast(&viewport));
        vk.vkCmdSetScissor(cmd, 0, 1, @ptrCast(&scissor));

        for (commandBuffer.*.*.scene.?) |value| {
            value.*.__draw(cmd);
        }

        vk.vkCmdEndRenderPass(cmd);

        result = vk.vkEndCommandBuffer(cmd);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.recordCommandBuffer.vkEndCommandBuffer : {d}", .{result});
    }
}

fn debug_callback(messageSeverity: vk.VkDebugUtilsMessageSeverityFlagBitsEXT, messageType: vk.VkDebugUtilsMessageTypeFlagsEXT, pCallbackData: ?*const vk.VkDebugUtilsMessengerCallbackDataEXT, pUserData: ?*anyopaque) callconv(.C) vk.VkBool32 {
    if (pCallbackData.?.*.messageIdNumber == 1284057537) return vk.VK_FALSE; //https://vulkan.lunarg.com/doc/view/1.3.283.0/windows/1.3-extensions/vkspec.html#VUID-VkSwapchainCreateInfoKHR-pNext-07781
    _ = messageSeverity;
    _ = messageType;
    _ = pUserData;

    if (system.platform == .android) {
        _ = __android.LOGE(pCallbackData.?.*.pMessage, .{});
    } else {
        const len = std.mem.len(pCallbackData.?.*.pMessage);
        const msg = __system.allocator.alloc(u8, len) catch |e| system.handle_error3("debug_callback.alloc()", e);
        @memcpy(msg, pCallbackData.?.*.pMessage[0..len]);
        defer __system.allocator.free(msg);

        system.print("{s}\n\n", .{msg});
    }

    return vk.VK_FALSE;
}

fn cleanup_pipelines() void {
    vk.vkDestroyPipeline(vkDevice, quad_shape_2d_pipeline_set.pipeline, null);
    vk.vkDestroyPipeline(vkDevice, shape_color_2d_pipeline_set.pipeline, null);
    vk.vkDestroyPipeline(vkDevice, tex_2d_pipeline_set.pipeline, null);
    vk.vkDestroyPipeline(vkDevice, animate_tex_2d_pipeline_set.pipeline, null);
    //vk.vkDestroyPipeline(vkDevice, copy_screen_pipeline_set.pipeline, null);
}

fn create_pipelines() void {
    const defDepthStencilState = vk.VkPipelineDepthStencilStateCreateInfo{
        .stencilTestEnable = vk.VK_FALSE,
        .depthTestEnable = vk.VK_TRUE,
        .depthWriteEnable = vk.VK_TRUE,
        .depthBoundsTestEnable = vk.VK_FALSE,
        .depthCompareOp = vk.VK_COMPARE_OP_LESS_OR_EQUAL,
    };
    {
        const vertexInputInfo: vk.VkPipelineVertexInputStateCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
            .vertexBindingDescriptionCount = 0,
            .vertexAttributeDescriptionCount = 0,
            .pVertexBindingDescriptions = null,
            .pVertexAttributeDescriptions = null,
        };

        const stencilOp = vk.VkStencilOpState{
            .compareMask = 0xff,
            .writeMask = 0xff,
            .compareOp = vk.VK_COMPARE_OP_EQUAL,
            .depthFailOp = vk.VK_STENCIL_OP_ZERO,
            .passOp = vk.VK_STENCIL_OP_ZERO,
            .failOp = vk.VK_STENCIL_OP_ZERO,
            .reference = 0xff,
        };

        const depthStencilState = vk.VkPipelineDepthStencilStateCreateInfo{
            .stencilTestEnable = vk.VK_TRUE,
            .depthTestEnable = vk.VK_FALSE,
            .depthWriteEnable = vk.VK_FALSE,
            .depthBoundsTestEnable = vk.VK_FALSE,
            .depthCompareOp = vk.VK_COMPARE_OP_NEVER,
            .flags = 0,
            .maxDepthBounds = 0,
            .minDepthBounds = 0,
            .back = stencilOp,
            .front = stencilOp,
        };

        const pipelineInfo: vk.VkGraphicsPipelineCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
            .stageCount = 2,
            .pStages = &quad_shape_shader_stages,
            .pVertexInputState = &vertexInputInfo,
            .pInputAssemblyState = &inputAssembly,
            .pViewportState = &viewportState,
            .pRasterizationState = &rasterizer,
            .pMultisampleState = &multisampling4,
            .pDepthStencilState = &depthStencilState,
            .pColorBlendState = &colorAlphaBlendingExternal,
            .pDynamicState = &dynamicState,
            .layout = quad_shape_2d_pipeline_set.pipelineLayout,
            .renderPass = vkRenderPass,
            .subpass = 0,
            .basePipelineHandle = null,
            .basePipelineIndex = -1,
        };

        const result = vk.vkCreateGraphicsPipelines(vkDevice, std.mem.zeroes(vk.VkPipelineCache), 1, &pipelineInfo, null, &quad_shape_2d_pipeline_set.pipeline);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateGraphicsPipelines quad_shape_2d_pipeline_set.pipeline : {d}", .{result});
    }
    {
        const bindingDescription: vk.VkVertexInputBindingDescription = .{
            .binding = 0,
            .stride = @sizeOf(f32) * (2 + 3),
            .inputRate = vk.VK_VERTEX_INPUT_RATE_VERTEX,
        };
        const attributeDescriptions: [2]vk.VkVertexInputAttributeDescription = .{
            .{ .binding = 0, .location = 0, .format = vk.VK_FORMAT_R32G32_SFLOAT, .offset = 0 },
            .{ .binding = 0, .location = 1, .format = vk.VK_FORMAT_R32G32B32_SFLOAT, .offset = @sizeOf(f32) * (2) },
        };

        const vertexInputInfo: vk.VkPipelineVertexInputStateCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
            .vertexBindingDescriptionCount = 1,
            .vertexAttributeDescriptionCount = attributeDescriptions.len,
            .pVertexBindingDescriptions = &bindingDescription,
            .pVertexAttributeDescriptions = &attributeDescriptions,
        };

        const stencilOp = vk.VkStencilOpState{
            .compareMask = 0xff,
            .writeMask = 0xff,
            .compareOp = vk.VK_COMPARE_OP_ALWAYS,
            .depthFailOp = vk.VK_STENCIL_OP_ZERO,
            .passOp = vk.VK_STENCIL_OP_INVERT,
            .failOp = vk.VK_STENCIL_OP_ZERO,
            .reference = 0xff,
        };
        const depthStencilState = vk.VkPipelineDepthStencilStateCreateInfo{
            .stencilTestEnable = vk.VK_TRUE,
            .depthTestEnable = vk.VK_TRUE,
            .depthWriteEnable = vk.VK_TRUE,
            .depthBoundsTestEnable = vk.VK_FALSE,
            .depthCompareOp = vk.VK_COMPARE_OP_LESS_OR_EQUAL,
            .flags = 0,
            .maxDepthBounds = 0,
            .minDepthBounds = 0,
            .back = stencilOp,
            .front = stencilOp,
        };

        const pipelineInfo: vk.VkGraphicsPipelineCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
            .stageCount = 2,
            .pStages = &shape_curve_shader_stages,
            .pVertexInputState = &vertexInputInfo,
            .pInputAssemblyState = &inputAssembly,
            .pViewportState = &viewportState,
            .pRasterizationState = &rasterizer,
            .pMultisampleState = &multisampling4,
            .pDepthStencilState = &depthStencilState,
            .pColorBlendState = &noBlending,
            .pDynamicState = &dynamicState,
            .layout = shape_color_2d_pipeline_set.pipelineLayout,
            .renderPass = vkRenderPass,
            .subpass = 0,
            .basePipelineHandle = null,
            .basePipelineIndex = -1,
        };

        const result = vk.vkCreateGraphicsPipelines(vkDevice, std.mem.zeroes(vk.VkPipelineCache), 1, &pipelineInfo, null, &shape_color_2d_pipeline_set.pipeline);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateGraphicsPipelines shape_color_2d_pipeline_set.pipeline : {d}", .{result});
    }
    {
        const bindingDescription: vk.VkVertexInputBindingDescription = .{
            .binding = 0,
            .stride = @sizeOf(f32) * (2 + 2),
            .inputRate = vk.VK_VERTEX_INPUT_RATE_VERTEX,
        };
        const attributeDescriptions: [2]vk.VkVertexInputAttributeDescription = .{
            .{ .binding = 0, .location = 0, .format = vk.VK_FORMAT_R32G32_SFLOAT, .offset = 0 },
            .{ .binding = 0, .location = 1, .format = vk.VK_FORMAT_R32G32_SFLOAT, .offset = @sizeOf(f32) * 2 },
        };

        const vertexInputInfo: vk.VkPipelineVertexInputStateCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
            .vertexBindingDescriptionCount = 1,
            .vertexAttributeDescriptionCount = 2,
            .pVertexBindingDescriptions = &bindingDescription,
            .pVertexAttributeDescriptions = &attributeDescriptions,
        };

        const pipelineInfo: vk.VkGraphicsPipelineCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
            .stageCount = 2,
            .pStages = &tex_shader_stages,
            .pVertexInputState = &vertexInputInfo,
            .pInputAssemblyState = &inputAssembly,
            .pViewportState = &viewportState,
            .pRasterizationState = &rasterizer,
            .pMultisampleState = &multisampling4,
            .pDepthStencilState = &defDepthStencilState,
            .pColorBlendState = &colorAlphaBlending,
            .pDynamicState = &dynamicState,
            .layout = tex_2d_pipeline_set.pipelineLayout,
            .renderPass = vkRenderPass,
            .subpass = 0,
            .basePipelineHandle = null,
            .basePipelineIndex = -1,
        };

        const result = vk.vkCreateGraphicsPipelines(vkDevice, null, 1, &pipelineInfo, null, &tex_2d_pipeline_set.pipeline);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateGraphicsPipelines tex_2d_pipeline_set.pipeline : {d}", .{result});
    }
    {
        const bindingDescription: vk.VkVertexInputBindingDescription = .{
            .binding = 0,
            .stride = @sizeOf(f32) * (2 + 2),
            .inputRate = vk.VK_VERTEX_INPUT_RATE_VERTEX,
        };
        const attributeDescriptions: [2]vk.VkVertexInputAttributeDescription = .{
            .{ .binding = 0, .location = 0, .format = vk.VK_FORMAT_R32G32_SFLOAT, .offset = 0 },
            .{ .binding = 0, .location = 1, .format = vk.VK_FORMAT_R32G32_SFLOAT, .offset = @sizeOf(f32) * 2 },
        };

        const vertexInputInfo: vk.VkPipelineVertexInputStateCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO,
            .vertexBindingDescriptionCount = 1,
            .vertexAttributeDescriptionCount = 2,
            .pVertexBindingDescriptions = &bindingDescription,
            .pVertexAttributeDescriptions = &attributeDescriptions,
        };

        const pipelineInfo: vk.VkGraphicsPipelineCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO,
            .stageCount = 2,
            .pStages = &animate_tex_shader_stages,
            .pVertexInputState = &vertexInputInfo,
            .pInputAssemblyState = &inputAssembly,
            .pViewportState = &viewportState,
            .pRasterizationState = &rasterizer,
            .pMultisampleState = &multisampling4,
            .pDepthStencilState = &defDepthStencilState,
            .pColorBlendState = &colorAlphaBlending,
            .pDynamicState = &dynamicState,
            .layout = animate_tex_2d_pipeline_set.pipelineLayout,
            .renderPass = vkRenderPass,
            .subpass = 0,
            .basePipelineHandle = null,
            .basePipelineIndex = -1,
        };

        const result = vk.vkCreateGraphicsPipelines(vkDevice, null, 1, &pipelineInfo, null, &animate_tex_2d_pipeline_set.pipeline);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateGraphicsPipelines animate_tex_2d_pipeline_set.pipeline : {d}", .{result});
    }
}
//instance
pub var VK_KHR_get_surface_capabilities2_support = false;
pub var validation_layer_support = false;
//device
pub var VK_EXT_full_screen_exclusive_support = false;
pub var VK_KHR_depth_stencil_resolve_support = false;
pub var VK_KHR_create_renderpass2_support = false;

pub fn vulkan_start() void {
    const appInfo: vk.VkApplicationInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Hello Triangle",
        .applicationVersion = vk.VK_MAKE_API_VERSION(1, 0, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = vk.VK_MAKE_API_VERSION(1, 0, 0, 0),
        .apiVersion = vk.VK_API_VERSION_1_1,
    };

    var result: c_int = undefined;
    {
        const ext = [_][:0]const u8{
            "VK_KHR_get_surface_capabilities2",
        };
        const checked: [ext.len]*bool = .{&VK_KHR_get_surface_capabilities2_support};

        const layers = [_][:0]const u8{
            "VK_LAYER_KHRONOS_validation",
        };
        const checkedl: [layers.len]*bool = .{&validation_layer_support};

        var extension_names = ArrayList([*:0]const u8).init(__system.allocator);
        defer extension_names.deinit();
        var layers_names = ArrayList([*:0]const u8).init(__system.allocator);
        defer layers_names.deinit();

        extension_names.append(vk.VK_KHR_SURFACE_EXTENSION_NAME) catch |e| system.handle_error3("vulkan_start.extension_names.append(vk.VK_KHR_SURFACE_EXTENSION_NAME)", e);

        var count: u32 = undefined;
        _ = vk.vkEnumerateInstanceLayerProperties(&count, null);

        const available_layers = __system.allocator.alloc(vk.VkLayerProperties, count) catch
            system.handle_error_msg2("vulkan_start.allocator.alloc(vk.VkLayerProperties) OutOfMemory");
        defer __system.allocator.free(available_layers);

        _ = vk.vkEnumerateInstanceLayerProperties(&count, available_layers.ptr);

        for (available_layers) |*value| {
            inline for (layers, checkedl) |t, b| {
                if (!b.* and std.mem.eql(u8, t, value.*.layerName[0..t.len])) {
                    layers_names.append(t) catch system.handle_error_msg2("__vulkan_start layer append");
                    b.* = true;
                }
            }
        }

        _ = vk.vkEnumerateInstanceExtensionProperties(null, &count, null);

        const available_ext = __system.allocator.alloc(vk.VkExtensionProperties, count) catch
            system.handle_error_msg2("vulkan_start.allocator.alloc(vk.VkLayerProperties) OutOfMemory");
        defer __system.allocator.free(available_ext);

        _ = vk.vkEnumerateInstanceExtensionProperties(null, &count, available_ext.ptr);

        for (available_ext) |*value| {
            inline for (ext, checked) |t, b| {
                if (!b.* and std.mem.eql(u8, t, value.*.extensionName[0..t.len])) {
                    extension_names.append(t) catch system.handle_error_msg2("__vulkan_start ext append");
                    b.* = true;
                }
            }
        }

        if (validation_layer_support and system.dbg) {
            extension_names.append(vk.VK_EXT_DEBUG_UTILS_EXTENSION_NAME) catch |e| system.handle_error3("vulkan_start.extension_names.append(vk.VK_EXT_DEBUG_UTILS_EXTENSION_NAME)", e);
        } else {
            validation_layer_support = false;
        }

        if (system.platform == .windows) {
            extension_names.append(vk.VK_KHR_WIN32_SURFACE_EXTENSION_NAME) catch |e| system.handle_error3("vulkan_start.extension_names.append(vk.VK_KHR_WIN32_SURFACE_EXTENSION_NAME)", e);
        } else if (system.platform == .android) {
            extension_names.append(vk.VK_KHR_ANDROID_SURFACE_EXTENSION_NAME) catch |e| system.handle_error3("vulkan_start.extension_names.append(vk.VK_KHR_ANDROID_SURFACE_EXTENSION_NAME)", e);
        } else {
            @compileError("not support platform");
        }

        // const enables = [_]vk.VkValidationFeatureEnableEXT{vk.VK_VALIDATION_FEATURE_ENABLE_BEST_PRACTICES_EXT};
        // const features = if (validation_layer_support) vk.VkValidationFeaturesEXT{
        //     .enabledValidationFeatureCount = 1,
        //     .pEnabledValidationFeatures = &enables,
        // } else null;
        const features = null;

        var createInfo: vk.VkInstanceCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
            .pApplicationInfo = &appInfo,
            .enabledLayerCount = @intCast(layers_names.items.len),
            .ppEnabledLayerNames = if (layers_names.items.len > 0) layers_names.items.ptr else null,
            .enabledExtensionCount = @intCast(extension_names.items.len),
            .ppEnabledExtensionNames = extension_names.items.ptr,
            .pNext = if (features == null) null else @ptrCast(&features),
        };

        result = vk.vkCreateInstance(&createInfo, null, &vkInstance);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateInstance : {d}", .{result});
    }

    if (validation_layer_support) {
        const create_info = vk.VkDebugUtilsMessengerCreateInfoEXT{
            .sType = vk.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
            .messageSeverity = vk.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | vk.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | vk.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT,
            .messageType = vk.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | vk.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | vk.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT,
            .pfnUserCallback = debug_callback,
            .pUserData = null,
        };
        result = vk.vkCreateDebugUtilsMessengerEXT(vkInstance, &create_info, null, &vkDebugMessenger);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDebugUtilsMessengerEXT : {d}", .{result});
    }

    if (system.platform == .windows) {
        __windows.vulkan_windows_start(vkInstance, &vkSurface);
    } else if (system.platform == .android) {
        __android.vulkan_android_start(vkInstance, &vkSurface);
    } else {
        @compileError("not support platform");
    }

    var deviceCount: u32 = 0;
    result = vk.vkEnumeratePhysicalDevices(vkInstance, &deviceCount, null);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkEnumeratePhysicalDevices : {d}", .{result});

    //system.print_debug("deviceCount : {d}", .{deviceCount});
    system.handle_error(deviceCount != 0, "__vulkan.vulkan_start.deviceCount 0", .{});
    const vk_physical_devices = __system.allocator.alloc(vk.VkPhysicalDevice, deviceCount) catch
        system.handle_error_msg2("vulkan_start.allocator.alloc(vk.VkPhysicalDevice) OutOfMemory");
    defer __system.allocator.free(vk_physical_devices);

    result = vk.vkEnumeratePhysicalDevices(vkInstance, &deviceCount, vk_physical_devices.ptr);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkEnumeratePhysicalDevices vk_physical_devices.ptr : {d}", .{result});

    out: for (vk_physical_devices) |pd| {
        vk.vkGetPhysicalDeviceQueueFamilyProperties(pd, &queueFamiliesCount, null);
        system.handle_error(queueFamiliesCount != 0, "__vulkan.vulkan_start.queueFamiliesCount 0", .{});

        const queueFamilies = __system.allocator.alloc(vk.VkQueueFamilyProperties, queueFamiliesCount) catch
            system.handle_error_msg2("vulkan_start.allocator.alloc(vk.VkQueueFamilyProperties) OutOfMemory");
        defer __system.allocator.free(queueFamilies);

        vk.vkGetPhysicalDeviceQueueFamilyProperties(pd, &queueFamiliesCount, queueFamilies.ptr);

        var i: u32 = 0;
        while (i < queueFamiliesCount) : (i += 1) {
            if ((queueFamilies[i].queueFlags & vk.VK_QUEUE_GRAPHICS_BIT) != 0) {
                graphicsFamilyIndex = i;
            }
            var presentSupport: vk.VkBool32 = 0;
            result = vk.vkGetPhysicalDeviceSurfaceSupportKHR(pd, i, vkSurface, &presentSupport);
            system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkGetPhysicalDeviceSurfaceSupportKHR : {d}", .{result});

            if (presentSupport != 0) {
                presentFamilyIndex = i;
            }
            if (graphicsFamilyIndex != std.math.maxInt(u32) and presentFamilyIndex != std.math.maxInt(u32)) {
                vk_physical_device = pd;
                break :out;
            }
        }
    }
    const priority = [_]f32{1};
    const qci = [_]vk.VkDeviceQueueCreateInfo{
        .{
            .sType = vk.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
            .queueFamilyIndex = graphicsFamilyIndex,
            .queueCount = 1,
            .pQueuePriorities = &priority,
        },
        .{
            .sType = vk.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
            .queueFamilyIndex = presentFamilyIndex,
            .queueCount = 1,
            .pQueuePriorities = &priority,
        },
    };

    const queue_count: u32 = if (graphicsFamilyIndex == presentFamilyIndex) 1 else 2;

    var deviceFeatures: vk.VkPhysicalDeviceFeatures = .{
        .samplerAnisotropy = vk.VK_TRUE,
    };

    {
        var deviceExtensionCount: u32 = 0;
        _ = vk.vkEnumerateDeviceExtensionProperties(vk_physical_device, null, &deviceExtensionCount, null);
        const extensions = __system.allocator.alloc(vk.VkExtensionProperties, deviceExtensionCount) catch system.handle_error_msg2("vulkan_start extensions alloc");
        defer __system.allocator.free(extensions);
        _ = vk.vkEnumerateDeviceExtensionProperties(vk_physical_device, null, &deviceExtensionCount, extensions.ptr);

        var device_extension_names = ArrayList([*:0]const u8).init(__system.allocator);
        defer device_extension_names.deinit();
        device_extension_names.append(vk.VK_KHR_SWAPCHAIN_EXTENSION_NAME) catch system.handle_error_msg2("vulkan_start dev ex append");
        var i: u32 = 0;

        const ext = [_][:0]const u8{
            "VK_EXT_full_screen_exclusive",
            //"VK_KHR_depth_stencil_resolve",
            //"VK_KHR_create_renderpass2",
        };
        const checked: [ext.len]*bool = .{
            &VK_EXT_full_screen_exclusive_support,
            //&VK_KHR_depth_stencil_resolve_support,
            // &VK_KHR_create_renderpass2_support,
        };

        while (i < deviceExtensionCount) : (i += 1) {
            inline for (ext, checked) |t, b| {
                if (!b.* and std.mem.eql(u8, t, extensions[i].extensionName[0..t.len])) {
                    device_extension_names.append(t.ptr) catch system.handle_error_msg2("vulkan_start dev ex append");
                    b.* = true;
                }
            }
        }

        var deviceCreateInfo: vk.VkDeviceCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
            .pQueueCreateInfos = &qci,
            .queueCreateInfoCount = queue_count,
            .pEnabledFeatures = &deviceFeatures,
            .ppEnabledExtensionNames = device_extension_names.items.ptr,
            .enabledExtensionCount = @intCast(device_extension_names.items.len),
        };

        result = vk.vkCreateDevice(vk_physical_device, &deviceCreateInfo, null, &vkDevice);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDevice : {d}", .{result});
    }
    if (system.platform == .android) VK_EXT_full_screen_exclusive_support = false;

    if (graphicsFamilyIndex == presentFamilyIndex) {
        vk.vkGetDeviceQueue(vkDevice, graphicsFamilyIndex, 0, &vkGraphicsQueue);
        vkPresentQueue = vkGraphicsQueue;
    } else {
        vk.vkGetDeviceQueue(vkDevice, graphicsFamilyIndex, 0, &vkGraphicsQueue);
        vk.vkGetDeviceQueue(vkDevice, presentFamilyIndex, 0, &vkPresentQueue);
    }

    vk.vkGetPhysicalDeviceMemoryProperties(vk_physical_device, &mem_prop);
    vk.vkGetPhysicalDeviceProperties(vk_physical_device, &properties);

    __vulkan_allocator.init_block_len();

    __vulkan_allocator.init();

    create_swapchain_and_imageviews();

    var sampler_info: vk.VkSamplerCreateInfo = .{
        .addressModeU = vk.VK_SAMPLER_ADDRESS_MODE_REPEAT,
        .addressModeV = vk.VK_SAMPLER_ADDRESS_MODE_REPEAT,
        .addressModeW = vk.VK_SAMPLER_ADDRESS_MODE_REPEAT,
        .mipmapMode = vk.VK_SAMPLER_MIPMAP_MODE_LINEAR,
        .magFilter = vk.VK_FILTER_LINEAR,
        .minFilter = vk.VK_FILTER_LINEAR,
        .mipLodBias = 0,
        .compareOp = vk.VK_COMPARE_OP_ALWAYS,
        .compareEnable = vk.VK_FALSE,
        .unnormalizedCoordinates = vk.VK_FALSE,
        .minLod = 0,
        .maxLod = 0,
        .anisotropyEnable = vk.VK_FALSE,
        .maxAnisotropy = properties.limits.maxSamplerAnisotropy,
        .borderColor = vk.VK_BORDER_COLOR_INT_OPAQUE_WHITE,
    };
    result = vk.vkCreateSampler(vkDevice, &sampler_info, null, &linear_sampler);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateSampler linear_sampler : {d}", .{result});

    sampler_info.mipmapMode = vk.VK_SAMPLER_MIPMAP_MODE_NEAREST;
    sampler_info.magFilter = vk.VK_FILTER_NEAREST;
    sampler_info.minFilter = vk.VK_FILTER_NEAREST;
    result = vk.vkCreateSampler(vkDevice, &sampler_info, null, &nearest_sampler);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateSampler nearest_sampler : {d}", .{result});

    const depthAttachmentSample: vk.VkAttachmentDescription = .{
        .format = vk.VK_FORMAT_D24_UNORM_S8_UINT,
        .samples = vk.VK_SAMPLE_COUNT_4_BIT,
        .loadOp = vk.VK_ATTACHMENT_LOAD_OP_LOAD,
        .storeOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = vk.VK_ATTACHMENT_LOAD_OP_CLEAR,
        .stencilStoreOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .initialLayout = vk.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
        .finalLayout = vk.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    };

    const depthAttachmentSampleClear: vk.VkAttachmentDescription = .{
        .format = vk.VK_FORMAT_D24_UNORM_S8_UINT,
        .samples = vk.VK_SAMPLE_COUNT_4_BIT,
        .loadOp = vk.VK_ATTACHMENT_LOAD_OP_CLEAR,
        .storeOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = vk.VK_ATTACHMENT_LOAD_OP_DONT_CARE,
        .stencilStoreOp = vk.VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .initialLayout = vk.VK_IMAGE_LAYOUT_UNDEFINED,
        .finalLayout = vk.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    };

    const colorAttachmentSampleClear: vk.VkAttachmentDescription = .{
        .format = format.format,
        .samples = vk.VK_SAMPLE_COUNT_4_BIT,
        .loadOp = vk.VK_ATTACHMENT_LOAD_OP_CLEAR,
        .storeOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = vk.VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .stencilStoreOp = vk.VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .initialLayout = vk.VK_IMAGE_LAYOUT_UNDEFINED,
        .finalLayout = vk.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
    };

    const colorAttachmentSample: vk.VkAttachmentDescription = .{
        .format = format.format,
        .samples = vk.VK_SAMPLE_COUNT_4_BIT,
        .loadOp = vk.VK_ATTACHMENT_LOAD_OP_LOAD,
        .storeOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = vk.VK_ATTACHMENT_LOAD_OP_DONT_CARE,
        .stencilStoreOp = vk.VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .initialLayout = vk.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
        .finalLayout = vk.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
    };

    const colorAttachmentResolve: vk.VkAttachmentDescription = .{
        .format = format.format,
        .samples = vk.VK_SAMPLE_COUNT_1_BIT,
        .loadOp = vk.VK_ATTACHMENT_LOAD_OP_DONT_CARE,
        .storeOp = vk.VK_ATTACHMENT_STORE_OP_STORE,
        .stencilLoadOp = vk.VK_ATTACHMENT_LOAD_OP_DONT_CARE,
        .stencilStoreOp = vk.VK_ATTACHMENT_STORE_OP_DONT_CARE,
        .initialLayout = vk.VK_IMAGE_LAYOUT_UNDEFINED,
        .finalLayout = vk.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
    };

    const colorAttachmentRef: vk.VkAttachmentReference = .{ .attachment = 0, .layout = vk.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL };
    const colorResolveAttachmentRef: vk.VkAttachmentReference = .{ .attachment = 2, .layout = vk.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL };
    const depthAttachmentRef: vk.VkAttachmentReference = .{ .attachment = 1, .layout = vk.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL };

    const subpass_resolve: vk.VkSubpassDescription = .{
        .pipelineBindPoint = vk.VK_PIPELINE_BIND_POINT_GRAPHICS,
        .colorAttachmentCount = 1,
        .pColorAttachments = @ptrCast(&colorAttachmentRef),
        .pDepthStencilAttachment = @ptrCast(&depthAttachmentRef),
        .pResolveAttachments = @ptrCast(&colorResolveAttachmentRef),
    };

    const dependency: vk.VkSubpassDependency = .{
        .srcSubpass = vk.VK_SUBPASS_EXTERNAL,
        .dstSubpass = 0,
        .srcStageMask = vk.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | vk.VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT,
        .srcAccessMask = 0,
        .dstStageMask = vk.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | vk.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT,
        .dstAccessMask = vk.VK_ACCESS_COLOR_ATTACHMENT_READ_BIT | vk.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT,
    };

    var renderPassInfo: vk.VkRenderPassCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO,
        .attachmentCount = 3,
        .pAttachments = &[_]vk.VkAttachmentDescription{ colorAttachmentSample, depthAttachmentSample, colorAttachmentResolve },
        .subpassCount = 1,
        .pSubpasses = &[_]vk.VkSubpassDescription{subpass_resolve},
        .pDependencies = &dependency,
        .dependencyCount = 1,
    };

    result = vk.vkCreateRenderPass(vkDevice, &renderPassInfo, null, &vkRenderPass);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateRenderPass vkRenderPass : {d}", .{result});

    renderPassInfo.pAttachments = &[_]vk.VkAttachmentDescription{ colorAttachmentSampleClear, depthAttachmentSampleClear, colorAttachmentResolve };
    renderPassInfo.pDependencies = null;
    renderPassInfo.dependencyCount = 0;

    result = vk.vkCreateRenderPass(vkDevice, &renderPassInfo, null, &vkRenderPassSampleClear);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateRenderPass vkRenderPassSampleClear : {d}", .{result});

    //create_shader_stages
    shape_curve_vert_shader = createShaderModule(shape_curve_vert);
    shape_curve_frag_shader = createShaderModule(shape_curve_frag);
    quad_shape_vert_shader = createShaderModule(quad_shape_vert);
    quad_shape_frag_shader = createShaderModule(quad_shape_frag);
    tex_vert_shader = createShaderModule(tex_vert);
    tex_frag_shader = createShaderModule(tex_frag);
    animate_tex_vert_shader = createShaderModule(animate_tex_vert);
    animate_tex_frag_shader = createShaderModule(animate_tex_frag);

    shape_curve_shader_stages = create_shader_state(shape_curve_vert_shader, shape_curve_frag_shader);
    quad_shape_shader_stages = create_shader_state(quad_shape_vert_shader, quad_shape_frag_shader);
    tex_shader_stages = create_shader_state(tex_vert_shader, tex_frag_shader);
    animate_tex_shader_stages = create_shader_state(animate_tex_vert_shader, animate_tex_frag_shader);

    //quad_shape_2d_pipeline
    {
        const uboLayoutBinding = [1]vk.VkDescriptorSetLayoutBinding{
            vk.VkDescriptorSetLayoutBinding{
                .binding = 0,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
        };
        const set_layout_info: vk.VkDescriptorSetLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
            .bindingCount = uboLayoutBinding.len,
            .pBindings = &uboLayoutBinding,
        };
        result = vk.vkCreateDescriptorSetLayout(vkDevice, &set_layout_info, null, &quad_shape_2d_pipeline_set.descriptorSetLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDescriptorSetLayout quad_shape_shader_stages.descriptorSetLayout : {d}", .{result});

        const pipelineLayoutInfo: vk.VkPipelineLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .setLayoutCount = 1,
            .pSetLayouts = &quad_shape_2d_pipeline_set.descriptorSetLayout,
            .pushConstantRangeCount = 0,
            .pPushConstantRanges = null,
        };

        result = vk.vkCreatePipelineLayout(vkDevice, &pipelineLayoutInfo, null, &quad_shape_2d_pipeline_set.pipelineLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreatePipelineLayout quad_shape_shader_stages.pipelineLayout : {d}", .{result});
    }
    //create_shape_color_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.VkDescriptorSetLayoutBinding{
            vk.VkDescriptorSetLayoutBinding{
                .binding = 0,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 1,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 2,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 3,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
            },
        };
        const set_layout_info: vk.VkDescriptorSetLayoutCreateInfo = .{
            .bindingCount = uboLayoutBinding.len,
            .pBindings = &uboLayoutBinding,
        };
        result = vk.vkCreateDescriptorSetLayout(vkDevice, &set_layout_info, null, &shape_color_2d_pipeline_set.descriptorSetLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDescriptorSetLayout color_2d_pipeline_set.descriptorSetLayout : {d}", .{result});

        const pipelineLayoutInfo: vk.VkPipelineLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .setLayoutCount = 1,
            .pSetLayouts = &shape_color_2d_pipeline_set.descriptorSetLayout,
            .pushConstantRangeCount = 0,
            .pPushConstantRanges = null,
        };

        result = vk.vkCreatePipelineLayout(vkDevice, &pipelineLayoutInfo, null, &shape_color_2d_pipeline_set.pipelineLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreatePipelineLayout color_2d_pipeline_set.pipelineLayout : {d}", .{result});
    }
    //create_tex_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.VkDescriptorSetLayoutBinding{
            vk.VkDescriptorSetLayoutBinding{
                .binding = 0,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 1,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 2,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 3,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 4,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
        };
        const set_layout_info: vk.VkDescriptorSetLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
            .bindingCount = uboLayoutBinding.len,
            .pBindings = &uboLayoutBinding,
        };
        result = vk.vkCreateDescriptorSetLayout(vkDevice, &set_layout_info, null, &tex_2d_pipeline_set.descriptorSetLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDescriptorSetLayout tex_2d_pipeline_set.descriptorSetLayout : {d}", .{result});

        const uboLayoutBinding2 = [_]vk.VkDescriptorSetLayoutBinding{
            vk.VkDescriptorSetLayoutBinding{
                .binding = 0,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER,
                .stageFlags = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
        };
        const set_layout_info2: vk.VkDescriptorSetLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
            .bindingCount = uboLayoutBinding2.len,
            .pBindings = &uboLayoutBinding2,
        };
        result = vk.vkCreateDescriptorSetLayout(vkDevice, &set_layout_info2, null, &tex_2d_pipeline_set.descriptorSetLayout2);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDescriptorSetLayout tex_2d_pipeline_set.descriptorSetLayout2 : {d}", .{result});

        const pipelineLayoutInfo: vk.VkPipelineLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .setLayoutCount = 2,
            .pSetLayouts = &[_]vk.VkDescriptorSetLayout{ tex_2d_pipeline_set.descriptorSetLayout, tex_2d_pipeline_set.descriptorSetLayout2 },
            .pushConstantRangeCount = 0,
            .pPushConstantRanges = null,
        };

        result = vk.vkCreatePipelineLayout(vkDevice, &pipelineLayoutInfo, null, &tex_2d_pipeline_set.pipelineLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreatePipelineLayout tex_2d_pipeline_set.pipelineLayout : {d}", .{result});
    }
    //create_tex_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.VkDescriptorSetLayoutBinding{
            vk.VkDescriptorSetLayoutBinding{
                .binding = 0,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 1,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 2,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 3,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_VERTEX_BIT | vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 4,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
            vk.VkDescriptorSetLayoutBinding{
                .binding = 5,
                .descriptorCount = 1,
                .descriptorType = vk.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER,
                .stageFlags = vk.VK_SHADER_STAGE_FRAGMENT_BIT,
                .pImmutableSamplers = null,
            },
        };
        const set_layout_info: vk.VkDescriptorSetLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO,
            .bindingCount = uboLayoutBinding.len,
            .pBindings = &uboLayoutBinding,
        };
        result = vk.vkCreateDescriptorSetLayout(vkDevice, &set_layout_info, null, &animate_tex_2d_pipeline_set.descriptorSetLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateDescriptorSetLayout animate_tex_2d_pipeline_set.descriptorSetLayout : {d}", .{result});

        const pipelineLayoutInfo: vk.VkPipelineLayoutCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO,
            .setLayoutCount = 2,
            .pSetLayouts = &[_]vk.VkDescriptorSetLayout{ animate_tex_2d_pipeline_set.descriptorSetLayout, tex_2d_pipeline_set.descriptorSetLayout2 },
            .pushConstantRangeCount = 0,
            .pPushConstantRanges = null,
        };

        result = vk.vkCreatePipelineLayout(vkDevice, &pipelineLayoutInfo, null, &animate_tex_2d_pipeline_set.pipelineLayout);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreatePipelineLayout animate_tex_2d_pipeline_set.pipelineLayout : {d}", .{result});
    }
    create_pipelines();

    create_framebuffer();

    const poolInfo: vk.VkCommandPoolCreateInfo = .{
        .sType = vk.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
        .flags = vk.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
        .queueFamilyIndex = graphicsFamilyIndex,
    };

    create_sync_object();

    result = vk.vkCreateCommandPool(vkDevice, &poolInfo, null, &vkCommandPool);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.vulkan_start.vkCreateCommandPool vkCommandPool : {d}", .{result});

    const allocInfo: vk.VkCommandBufferAllocateInfo = .{
        .commandPool = vkCommandPool,
        .level = vk.VK_COMMAND_BUFFER_LEVEL_PRIMARY,
        .commandBufferCount = 1,
        .sType = vk.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
    };

    result = vk.vkAllocateCommandBuffers(vkDevice, &allocInfo, &vkCommandBuffer);
    system.handle_error(result == vk.VK_SUCCESS, "vulkan_start vkAllocateCommandBuffers vkCommandPool : {d}", .{result});

    __render_command.start();

    set_fullscreen_ex();

    //graphics create
    quad_image_vertices = graphics.vertices(graphics.tex_vertex_2d).init();
    quad_image_vertices.array = quad_image_vertices_array[0..quad_image_vertices_array.len];
    quad_image_vertices.build(.gpu) catch unreachable;

    no_color_tran = graphics.color_transform.init();
    no_color_tran.build(.gpu);
    //
}

pub fn vulkan_destroy() void {
    //graphics destroy
    quad_image_vertices.deinit();
    no_color_tran.deinit();
    __pre_mat_uniform.clean();

    cleanup_swapchain();

    __vulkan_allocator.deinit();

    vk.vkDestroySampler(vkDevice, linear_sampler, null);
    vk.vkDestroySampler(vkDevice, nearest_sampler, null);
    //

    vk.vkDestroyCommandPool(vkDevice, vkCommandPool, null);

    vk.vkDestroyShaderModule(vkDevice, quad_shape_vert_shader, null);
    vk.vkDestroyShaderModule(vkDevice, quad_shape_frag_shader, null);
    vk.vkDestroyShaderModule(vkDevice, shape_curve_vert_shader, null);
    vk.vkDestroyShaderModule(vkDevice, shape_curve_frag_shader, null);
    vk.vkDestroyShaderModule(vkDevice, tex_vert_shader, null);
    vk.vkDestroyShaderModule(vkDevice, tex_frag_shader, null);
    vk.vkDestroyShaderModule(vkDevice, animate_tex_vert_shader, null);
    vk.vkDestroyShaderModule(vkDevice, animate_tex_frag_shader, null);

    vk.vkDestroyPipelineLayout(vkDevice, quad_shape_2d_pipeline_set.pipelineLayout, null);
    vk.vkDestroyDescriptorSetLayout(vkDevice, quad_shape_2d_pipeline_set.descriptorSetLayout, null);

    vk.vkDestroyPipelineLayout(vkDevice, shape_color_2d_pipeline_set.pipelineLayout, null);
    vk.vkDestroyDescriptorSetLayout(vkDevice, shape_color_2d_pipeline_set.descriptorSetLayout, null);

    vk.vkDestroyPipelineLayout(vkDevice, tex_2d_pipeline_set.pipelineLayout, null);
    vk.vkDestroyDescriptorSetLayout(vkDevice, tex_2d_pipeline_set.descriptorSetLayout, null);
    vk.vkDestroyDescriptorSetLayout(vkDevice, tex_2d_pipeline_set.descriptorSetLayout2, null);

    vk.vkDestroyPipelineLayout(vkDevice, animate_tex_2d_pipeline_set.pipelineLayout, null);
    vk.vkDestroyDescriptorSetLayout(vkDevice, animate_tex_2d_pipeline_set.descriptorSetLayout, null);

    //vk.vkDestroyPipelineLayout(vkDevice, copy_screen_pipeline_set.pipelineLayout, null);
    //vk.vkDestroyDescriptorSetLayout(vkDevice, copy_screen_pipeline_set.descriptorSetLayout, null);

    cleanup_pipelines();
    cleanup_sync_object();

    vk.vkDestroyRenderPass(vkDevice, vkRenderPass, null);
    vk.vkDestroyRenderPass(vkDevice, vkRenderPassSampleClear, null);

    vk.vkDestroySurfaceKHR(vkInstance, vkSurface, null);

    vk.vkDestroyDevice(vkDevice, null);

    if (vkDebugMessenger != null) vk.vkDestroyDebugUtilsMessengerEXT(vkInstance, vkDebugMessenger, null);
    vk.vkDestroyInstance(vkInstance, null);

    __render_command.destroy();
}

fn recreateSurface() void {
    if (system.platform == .windows) {
        __windows.vulkan_windows_start(vkInstance, &vkSurface);
    } else if (system.platform == .android) {
        //__android.vulkan_android_start(vkInstance, &vkSurface);
    } else {
        @compileError("not support platform");
    }
}

fn cleanup_swapchain() void {
    if (vkSwapchain != null) {
        __vulkan_allocator.execute_and_wait_all_op();

        var i: usize = 0;
        while (i < vk_swapchain_frame_buffers.len) : (i += 1) {
            vk_swapchain_frame_buffers[i].destroy_no_async();
            vk_swapchain_frame_buffer_clears[i].destroy_no_async();
        }

        depth_stencil_image_sample.clean();
        color_image_sample.clean();

        __vulkan_allocator.execute_and_wait_all_op();

        //if (depth_stencil_image_sample.pvulkan_buffer != null and depth_stencil_image_sample.pvulkan_buffer.?.*.is_empty()) depth_stencil_image_sample.pvulkan_buffer.?.*.deinit();
        __system.allocator.free(vk_swapchain_frame_buffers);
        __system.allocator.free(vk_swapchain_frame_buffer_clears);
        i = 0;
        while (i < vk_swapchain_images.len) : (i += 1) {
            vk.vkDestroyImageView(vkDevice, vk_swapchain_images[i].__image_view, null);
        }
        __system.allocator.free(vk_swapchain_images);
        vk.vkDestroySwapchainKHR(vkDevice, vkSwapchain, null);
        vkSwapchain = null;

        __system.allocator.free(formats);
    }
}

fn create_framebuffer() void {
    vk_swapchain_frame_buffers = __system.allocator.alloc(__vulkan_allocator.frame_buffer, vk_swapchain_images.len) catch
        system.handle_error_msg2("__vulkan.create_framebuffer.allocator.alloc(__vulkan_allocator.frame_buffer)");
    vk_swapchain_frame_buffer_clears = __system.allocator.alloc(__vulkan_allocator.frame_buffer, vk_swapchain_images.len) catch
        system.handle_error_msg2("__vulkan.create_framebuffer.allocator.alloc(__vulkan_allocator.frame_buffer)");

    depth_stencil_image_sample.create_texture(.{
        .width = vkExtent_rotation.width,
        .height = vkExtent_rotation.height,
        .format = .D24_UNORM_S8_UINT,
        .samples = 4,
        .tex_use = .{
            .image_resource = false,
            .frame_buffer = true,
        },
        .single = true,
    }, null, null);
    color_image_sample.create_texture(.{
        .width = vkExtent_rotation.width,
        .height = vkExtent_rotation.height,
        .format = .default,
        .samples = 4,
        .tex_use = .{
            .image_resource = false,
            .frame_buffer = true,
            .__transient_attachment = true,
        },
        .single = true,
    }, null, null);

    refresh_pre_matrix();

    __vulkan_allocator.execute_and_wait_all_op();
    var i: usize = 0;
    while (i < vk_swapchain_images.len) : (i += 1) {
        vk_swapchain_frame_buffers[i] = .{};
        var texs = [_]*__vulkan_allocator.vulkan_res_node(.texture){
            &color_image_sample,
            &depth_stencil_image_sample,
            &vk_swapchain_images[i],
        };
        vk_swapchain_frame_buffers[i].create_no_async(texs[0..3], vkRenderPass);
        vk_swapchain_frame_buffer_clears[i] = .{};
        vk_swapchain_frame_buffer_clears[i].create_no_async(texs[0..3], vkRenderPassSampleClear);
    }
}

var rotate_mat: matrix = undefined;

pub fn refresh_pre_matrix() void {
    if (system.platform == .android) {
        const orientation = window.get_screen_orientation();
        rotate_mat = switch (orientation) {
            .unknown => matrix.identity(),
            .landscape90 => matrix.rotation2D(std.math.degreesToRadians(90.0)),
            .landscape270 => matrix.rotation2D(std.math.degreesToRadians(270.0)),
            .vertical180 => matrix.rotation2D(std.math.degreesToRadians(180.0)),
            .vertical360 => matrix.identity(),
        };
        if (__pre_mat_uniform.res == null) {
            __pre_mat_uniform.create_buffer(
                .{
                    .len = @sizeOf(matrix),
                    .typ = .uniform,
                    .use = .cpu,
                },
                std.mem.sliceAsBytes(@as([*]const matrix, @ptrCast(&rotate_mat))[0..1]),
            );
        } else {
            __pre_mat_uniform.copy_update(&rotate_mat);
        }
    } else {
        if (__pre_mat_uniform.res == null) {
            rotate_mat = matrix.identity();
            __pre_mat_uniform.create_buffer(
                .{
                    .len = @sizeOf(matrix),
                    .typ = .uniform,
                    .use = .cpu,
                },
                std.mem.sliceAsBytes(@as([*]const matrix, @ptrCast(&rotate_mat))[0..1]),
            );
        }
    }
}

fn create_swapchain_and_imageviews() void {
    var result: c_int = undefined;
    var formatCount: u32 = 0;
    result = vk.vkGetPhysicalDeviceSurfaceFormatsKHR(vk_physical_device, vkSurface, &formatCount, null);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfaceFormatsKHR : {d}", .{result});
    system.handle_error_msg(formatCount != 0, "__vulkan.create_swapchain_and_imageviews.formatCount 0");

    formats = __system.allocator.alloc(vk.VkSurfaceFormatKHR, formatCount) catch
        system.handle_error_msg2("create_swapchain_and_imageviews.allocator.alloc(vk.VkSurfaceFormatKHR) OutOfMemory");

    result = vk.vkGetPhysicalDeviceSurfaceFormatsKHR(vk_physical_device, vkSurface, &formatCount, formats.ptr);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfaceFormatsKHR formats.ptr : {d}", .{result});
    system.handle_error_msg(formatCount != 0, "__vulkan.create_swapchain_and_imageviews.formatCount 0(2)");

    var presentModeCount: u32 = 0;
    result = vk.vkGetPhysicalDeviceSurfacePresentModesKHR(vk_physical_device, vkSurface, &presentModeCount, null);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfacePresentModesKHR : {d}", .{result});
    system.handle_error_msg(presentModeCount != 0, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfacePresentModesKHR presentModeCount 0");

    const presentModes = __system.allocator.alloc(vk.VkPresentModeKHR, presentModeCount) catch {
        system.handle_error_msg2("create_swapchain_and_imageviews.allocator.alloc(vk.VkPresentModeKHR) OutOfMemory");
    };
    defer __system.allocator.free(presentModes);

    result = vk.vkGetPhysicalDeviceSurfacePresentModesKHR(vk_physical_device, vkSurface, &presentModeCount, presentModes.ptr);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfacePresentModesKHR presentModes.ptr : {d}", .{result});

    result = vk.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(vk_physical_device, vkSurface, @ptrCast(&surfaceCap));
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfaceCapabilitiesKHR : {d}", .{result});

    vkExtent = chooseSwapExtent(surfaceCap);
    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        __system.allocator.free(formats);
        return;
    }

    if (system.platform == .android) {
        if (surfaceCap.currentTransform & vk.VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR != 0) {
            vkExtent_rotation.width = vkExtent.height;
            vkExtent_rotation.height = vkExtent.width;
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .landscape90, std.builtin.AtomicOrder.monotonic);
        } else if (surfaceCap.currentTransform & vk.VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR != 0) {
            vkExtent_rotation.width = vkExtent.height;
            vkExtent_rotation.height = vkExtent.width;
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .landscape270, std.builtin.AtomicOrder.monotonic);
        } else if (surfaceCap.currentTransform & vk.VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR != 0) {
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .vertical180, std.builtin.AtomicOrder.monotonic);
            vkExtent_rotation = vkExtent;
        } else {
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .vertical360, std.builtin.AtomicOrder.monotonic);
            vkExtent_rotation = vkExtent;
        }
    } else {
        vkExtent_rotation = vkExtent;
    }
    @atomicStore(u32, &__system.init_set.window_width, @intCast(vkExtent.width), std.builtin.AtomicOrder.monotonic);
    @atomicStore(u32, &__system.init_set.window_height, @intCast(vkExtent.height), std.builtin.AtomicOrder.monotonic);

    format = chooseSwapSurfaceFormat(formats);
    const presentMode = chooseSwapPresentMode(presentModes, __system.init_set.vSync);

    var imageCount = surfaceCap.minImageCount + 1;
    if (surfaceCap.maxImageCount > 0 and imageCount > surfaceCap.maxImageCount) {
        imageCount = surfaceCap.maxImageCount;
    }

    var fullS: vk.VkSurfaceFullScreenExclusiveInfoEXT = .{
        .fullScreenExclusive = vk.VK_FULL_SCREEN_EXCLUSIVE_APPLICATION_CONTROLLED_EXT,
    };

    var fullWin: vk.VkSurfaceFullScreenExclusiveWin32InfoEXT = undefined;
    if (system.platform == .windows and system.current_monitor() != null) {
        fullWin = .{
            .hmonitor = system.current_monitor().?.*.__hmonitor,
        };
        fullS.pNext = @ptrCast(&fullWin);
    }

    var swapChainCreateInfo: vk.VkSwapchainCreateInfoKHR = .{
        .sType = vk.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
        .surface = vkSurface,
        .minImageCount = imageCount,
        .imageFormat = format.format,
        .imageColorSpace = format.colorSpace,
        .imageExtent = vkExtent_rotation,
        .imageArrayLayers = 1,
        .imageUsage = vk.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT,
        .presentMode = presentMode,
        .preTransform = surfaceCap.currentTransform,
        .compositeAlpha = surfaceCap.supportedCompositeAlpha,
        .clipped = 1,
        .oldSwapchain = null,
        .imageSharingMode = vk.VK_SHARING_MODE_EXCLUSIVE,
        .pNext = if (is_fullscreen_ex) @ptrCast(&fullS) else null,
    };

    const queueFamiliesIndices = [_]u32{ graphicsFamilyIndex, presentFamilyIndex };

    if (graphicsFamilyIndex != presentFamilyIndex) {
        swapChainCreateInfo.imageSharingMode = vk.VK_SHARING_MODE_CONCURRENT;
        swapChainCreateInfo.queueFamilyIndexCount = 2;
        swapChainCreateInfo.pQueueFamilyIndices = &queueFamiliesIndices;
    }

    result = vk.vkCreateSwapchainKHR(vkDevice, &swapChainCreateInfo, null, &vkSwapchain);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkCreateSwapchainKHR : {d}", .{result});

    var swapchain_image_count: u32 = 0;

    result = vk.vkGetSwapchainImagesKHR(vkDevice, vkSwapchain, &swapchain_image_count, null);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetSwapchainImagesKHR : {d}", .{result});

    const swapchain_images = __system.allocator.alloc(vk.VkImage, swapchain_image_count) catch
        system.handle_error_msg2("__vulkan.create_swapchain_and_imageviews.allocator.alloc(vk.VkImage) OutOfMemory");
    defer __system.allocator.free(swapchain_images);

    result = vk.vkGetSwapchainImagesKHR(vkDevice, vkSwapchain, &swapchain_image_count, swapchain_images.ptr);
    system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkGetSwapchainImagesKHR swapchain_images.ptr : {d}", .{result});

    vk_swapchain_images = __system.allocator.alloc(__vulkan_allocator.vulkan_res_node(.texture), swapchain_image_count) catch |e| system.handle_error3("vulkan_start.vk_swapchain_images alloc", e);

    var i: usize = 0;
    while (i < swapchain_image_count) : (i += 1) {
        vk_swapchain_images[i].texture_option = .{
            .format = .default,
            .width = vkExtent_rotation.width,
            .height = vkExtent_rotation.height,
            .single = true,
            .tex_use = .{ .image_resource = false },
        };
        vk_swapchain_images[i].builded = true;
        const image_view_createInfo: vk.VkImageViewCreateInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO,
            .image = swapchain_images[i],
            .viewType = vk.VK_IMAGE_VIEW_TYPE_2D,
            .format = format.format,
            .components = .{
                .r = vk.VK_COMPONENT_SWIZZLE_IDENTITY,
                .g = vk.VK_COMPONENT_SWIZZLE_IDENTITY,
                .b = vk.VK_COMPONENT_SWIZZLE_IDENTITY,
                .a = vk.VK_COMPONENT_SWIZZLE_IDENTITY,
            },
            .subresourceRange = .{
                .aspectMask = vk.VK_IMAGE_ASPECT_COLOR_BIT,
                .baseMipLevel = 0,
                .levelCount = 1,
                .baseArrayLayer = 0,
                .layerCount = 1,
            },
        };
        result = vk.vkCreateImageView(vkDevice, &image_view_createInfo, null, &vk_swapchain_images[i].__image_view);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.create_swapchain_and_imageviews.vkCreateImageView({d}) : {d}", .{ i, result });
    }
}

pub fn set_fullscreen_ex() void {
    if (VK_EXT_full_screen_exclusive_support and is_fullscreen_ex) {
        if (system.platform == .windows) {
            __windows.__change_fullscreen_mode();
        }
        _ = vk.vkAcquireFullScreenExclusiveModeEXT(vkInstance, vkDevice, vkSwapchain);
    }
}

///rect는 Y가 작을수록 위
// pub fn copy_buffer_to_image2(src_buf: vk.VkBuffer, dst_img: vk.VkImage, rect: math.recti, depth: c_uint) void {
//     if (rect.left >= rect.right or rect.top >= rect.bottom) system.handle_error_msg2("copy_buffer_to_image2 invaild rect");
//     const buf = begin_single_time_commands();

//     const region: vk.VkBufferImageCopy = .{
//         .bufferOffset = 0,
//         .bufferRowLength = 0,
//         .bufferImageHeight = 0,
//         .imageOffset = .{ .x = rect.left, .y = rect.top, .z = 0 },
//         .imageExtent = .{ .width = rect.width(), .height = rect.height(), .depth = depth },
//         .imageSubresource = .{
//             .aspectMask = vk.VK_IMAGE_ASPECT_COLOR_BIT,
//             .baseArrayLayer = 0,
//             .mipLevel = 0,
//             .layerCount = 1,
//         },
//     };
//     vk.vkCmdCopyBufferToImage(buf, src_buf, dst_img, vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region);

//     end_single_time_commands(buf);
// }

pub fn get_swapchain_image_length() usize {
    return vk_swapchain_images.len;
}

pub var windowed: bool = true;
pub var fullscreen_mutex: std.Thread.Mutex = .{};

pub fn recreate_swapchain() void {
    if (vkDevice == null) return;
    fullscreen_mutex.lock();

    if (!windowed and VK_EXT_full_screen_exclusive_support and !is_fullscreen_ex) {
        _ = vk.vkReleaseFullScreenExclusiveModeEXT(vkInstance, vkDevice, vkSwapchain);
        windowed = true;
    }

    __vulkan_allocator.execute_and_wait_all_op();
    wait_device_idle();

    if (system.platform == .android) {
        __android.vulkan_android_start(vkInstance, &vkSurface);
    } else if (system.platform == .windows) {
        //__windows.vulkan_windows_start(vkInstance, &vkSurface);
    }

    cleanup_swapchain();
    create_swapchain_and_imageviews();
    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        fullscreen_mutex.unlock();

        __vulkan_allocator.execute_and_wait_all_op();
        return;
    }
    create_framebuffer();

    set_fullscreen_ex();

    fullscreen_mutex.unlock();

    __render_command.refresh_all();
    root.xfit_size() catch |e| {
        system.handle_error3("xfit_size", e);
    };

    __vulkan_allocator.execute_and_wait_all_op();
}

pub fn drawFrame() void {
    var imageIndex: u32 = 0;
    const state = struct {
        var frame: usize = 0;
    };

    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        recreate_swapchain();
        return;
    } else if (system.platform == .android) {
        if (__android.orientationChanged) {
            recreate_swapchain();
            __android.orientationChanged = false;
        }
    }

    if (graphics.render_cmd != null) {
        var result = vk.vkAcquireNextImageKHR(vkDevice, vkSwapchain, std.math.maxInt(u64), vkImageAvailableSemaphore[state.frame], null, &imageIndex);
        if (result == vk.VK_ERROR_OUT_OF_DATE_KHR) {
            recreate_swapchain();
            return;
        } else if (result == vk.VK_SUBOPTIMAL_KHR) {} else if (result == vk.VK_ERROR_SURFACE_LOST_KHR) {
            recreateSurface();
            recreate_swapchain();
            return;
        }

        const cmds = __system.allocator.alloc(vk.VkCommandBuffer, graphics.render_cmd.?.len + 1) catch system.handle_error_msg2("drawframe cmds alloc");
        defer __system.allocator.free(cmds);

        cmds[0] = vkCommandBuffer;

        for (graphics.render_cmd.?, cmds[1..cmds.len]) |*cmd, *v| {
            if (@atomicLoad(bool, &cmd.*.*.__refesh[state.frame], .monotonic)) {
                @atomicStore(bool, &cmd.*.*.__refesh[state.frame], false, .monotonic);
                recordCommandBuffer(cmd, @intCast(state.frame));
            }
            v.* = cmd.*.__command_buffers[state.frame][imageIndex];
        }

        const waitStages: u32 = vk.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
        var submitInfo: vk.VkSubmitInfo = .{
            .waitSemaphoreCount = 1,
            .commandBufferCount = @intCast(cmds.len),
            .signalSemaphoreCount = 1,
            .pWaitSemaphores = &vkImageAvailableSemaphore[state.frame],
            .pWaitDstStageMask = &waitStages,
            .pCommandBuffers = cmds.ptr,
            .pSignalSemaphores = &vkRenderFinishedSemaphore[state.frame],
        };

        const clearColor: vk.VkClearValue = .{ .color = .{ .float32 = .{ 0, 0, 0, 0 } } };
        const clearDepthStencil: vk.VkClearValue = .{ .depthStencil = .{ .stencil = 0, .depth = 1 } };
        var renderPassInfo: vk.VkRenderPassBeginInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO,
            .renderPass = vkRenderPassSampleClear,
            .framebuffer = vk_swapchain_frame_buffer_clears[imageIndex].res,
            .renderArea = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
            .clearValueCount = 2,
            .pClearValues = &[_]vk.VkClearValue{ clearColor, clearDepthStencil },
        };
        const beginInfo: vk.VkCommandBufferBeginInfo = .{
            .sType = vk.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO,
            .flags = vk.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT,
            .pInheritanceInfo = null,
        };
        result = vk.vkBeginCommandBuffer(vkCommandBuffer, &beginInfo);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.drawFrame.vkBeginCommandBuffer : {d}", .{result});
        vk.vkCmdBeginRenderPass(vkCommandBuffer, &renderPassInfo, vk.VK_SUBPASS_CONTENTS_INLINE);
        vk.vkCmdEndRenderPass(vkCommandBuffer);
        result = vk.vkEndCommandBuffer(vkCommandBuffer);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.drawFrame.vkEndCommandBuffer : {d}", .{result});

        result = vk.vkResetFences(vkDevice, 1, &vkInFlightFence[state.frame]);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.drawFrame.vkResetFences : {d}", .{result});

        __vulkan_allocator.submit_mutex.lock();
        result = vk.vkQueueSubmit(vkGraphicsQueue, 1, &submitInfo, vkInFlightFence[state.frame]);
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.drawFrame.vkQueueSubmit : {d}", .{result});
        __vulkan_allocator.submit_mutex.unlock();
        result = vk.vkWaitForFences(vkDevice, 1, &vkInFlightFence[state.frame], vk.VK_TRUE, std.math.maxInt(u64));
        system.handle_error(result == vk.VK_SUCCESS, "__vulkan.wait_for_fences.vkWaitForFences : {d}", .{result});

        const swapChains = [_]vk.VkSwapchainKHR{vkSwapchain};

        const presentInfo: vk.VkPresentInfoKHR = .{
            .sType = vk.VK_STRUCTURE_TYPE_PRESENT_INFO_KHR,
            .waitSemaphoreCount = 1,
            .swapchainCount = 1,
            .pWaitSemaphores = &vkRenderFinishedSemaphore[state.frame],
            .pSwapchains = &swapChains,
            .pImageIndices = &imageIndex,
        };
        __vulkan_allocator.submit_mutex.lock();
        result = vk.vkQueuePresentKHR(vkPresentQueue, &presentInfo);
        __vulkan_allocator.submit_mutex.unlock();

        if (result == vk.VK_ERROR_OUT_OF_DATE_KHR) {
            recreate_swapchain();
        } else if (result == vk.VK_SUBOPTIMAL_KHR) {
            var prop: vk.VkSurfaceCapabilitiesKHR = undefined;
            _ = vk.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(vk_physical_device, vkSurface, &prop);
            if (prop.currentExtent.width != vkExtent.width or prop.currentExtent.height != vkExtent.height) {
                recreate_swapchain();
            }
        } else if (result == vk.VK_ERROR_SURFACE_LOST_KHR) {
            recreateSurface();
            recreate_swapchain();
        } else {
            system.handle_error(result == vk.VK_SUCCESS, "__vulkan.drawFrame.vkQueuePresentKHR : {d}", .{result});
        }

        state.frame = (state.frame + 1) % render_command.MAX_FRAME;
    }
}

pub fn wait_device_idle() void {
    const result = vk.vkDeviceWaitIdle(vkDevice);
    if (result != vk.VK_SUCCESS) system.print_error("__vulkan.vkDeviceWaitIdle : {d}", .{result});
}

pub fn transition_image_layout(cmd: vk.VkCommandBuffer, image: vk.VkImage, mipLevels: u32, arrayStart: u32, arrayLayers: u32, old_layout: vk.VkImageLayout, new_layout: vk.VkImageLayout) void {
    var barrier: vk.VkImageMemoryBarrier = .{
        .oldLayout = old_layout,
        .newLayout = new_layout,
        .srcQueueFamilyIndex = vk.VK_QUEUE_FAMILY_IGNORED,
        .dstQueueFamilyIndex = vk.VK_QUEUE_FAMILY_IGNORED,
        .image = image,
        .subresourceRange = .{
            .aspectMask = vk.VK_IMAGE_ASPECT_COLOR_BIT,
            .baseMipLevel = 0,
            .levelCount = mipLevels,
            .baseArrayLayer = arrayStart,
            .layerCount = arrayLayers,
        },
    };

    var source_stage: vk.VkPipelineStageFlags = undefined;
    var destination_stage: vk.VkPipelineStageFlags = undefined;

    if (old_layout == vk.VK_IMAGE_LAYOUT_UNDEFINED and new_layout == vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) {
        barrier.srcAccessMask = 0;
        barrier.dstAccessMask = vk.VK_ACCESS_TRANSFER_WRITE_BIT;

        source_stage = vk.VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
        destination_stage = vk.VK_PIPELINE_STAGE_TRANSFER_BIT;
    } else if (old_layout == vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL and new_layout == vk.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) {
        barrier.srcAccessMask = vk.VK_ACCESS_TRANSFER_WRITE_BIT;
        barrier.dstAccessMask = vk.VK_ACCESS_SHADER_READ_BIT;

        source_stage = vk.VK_PIPELINE_STAGE_TRANSFER_BIT;
        destination_stage = vk.VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;
    } else {
        system.handle_error_msg2("__vulkan.transition_image_layout unsupported layout transition!");
    }

    vk.vkCmdPipelineBarrier(cmd, source_stage, destination_stage, 0, 0, null, 0, null, 1, &barrier);
}
