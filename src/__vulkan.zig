const std = @import("std");
const builtin = @import("builtin");
const ArrayList = std.ArrayList;
const MemoryPoolExtra = std.heap.MemoryPoolExtra;

const window = @import("window.zig");
const __windows = if (!builtin.is_test) @import("__windows.zig") else void;
const __android = if (!builtin.is_test) @import("__android.zig") else void;
const __linux = @import("__linux.zig");
const system = @import("system.zig");
const math = @import("math.zig");
const matrix = math.matrix;
const graphics = @import("graphics.zig");
const render_command = @import("render_command.zig");
const __render_command = @import("__render_command.zig");
const __system = @import("__system.zig");
const root = @import("root");
const xfit = @import("xfit.zig");

const __vulkan_allocator = @import("__vulkan_allocator.zig");

pub var mem_prop: vk.PhysicalDeviceMemoryProperties = undefined;

pub const vk = @import("include/vulkan.zig");

const shape_curve_vert align(@alignOf(u32)) = @embedFile("shaders/out/shape_curve_vert.spv").*;
const shape_curve_frag align(@alignOf(u32)) = @embedFile("shaders/out/shape_curve_frag.spv").*;
var shape_curve_vert_shader: vk.ShaderModule = undefined;
var shape_curve_frag_shader: vk.ShaderModule = undefined;

const quad_shape_vert align(@alignOf(u32)) = @embedFile("shaders/out/quad_shape_vert.spv").*;
const quad_shape_frag align(@alignOf(u32)) = @embedFile("shaders/out/quad_shape_frag.spv").*;
var quad_shape_vert_shader: vk.ShaderModule = undefined;
var quad_shape_frag_shader: vk.ShaderModule = undefined;

const tex_vert align(@alignOf(u32)) = @embedFile("shaders/out/tex_vert.spv").*;
const tex_frag align(@alignOf(u32)) = @embedFile("shaders/out/tex_frag.spv").*;
var tex_vert_shader: vk.ShaderModule = undefined;
var tex_frag_shader: vk.ShaderModule = undefined;

const animate_tex_vert align(@alignOf(u32)) = @embedFile("shaders/out/animate_tex_vert.spv").*;
const animate_tex_frag align(@alignOf(u32)) = @embedFile("shaders/out/animate_tex_frag.spv").*;
var animate_tex_vert_shader: vk.ShaderModule = undefined;
var animate_tex_frag_shader: vk.ShaderModule = undefined;

const copy_screen_frag align(@alignOf(u32)) = @embedFile("shaders/out/screen_copy_frag.spv").*;
var copy_screen_frag_shader: vk.ShaderModule = undefined;

pub var __pre_mat_uniform: __vulkan_allocator.vulkan_res_node(.buffer) = .{};

pub var queue_mutex: std.Thread.Mutex = .{};

const color_struct = packed struct { _0: f32, _1: f32, _2: f32, _3: f32 };
pub var clear_color: color_struct = std.mem.zeroes(color_struct);

pub const pipeline_set = struct {
    pipeline: vk.Pipeline = .null_handle,
    pipelineLayout: vk.PipelineLayout = .null_handle,
    descriptorSetLayout: vk.DescriptorSetLayout = .null_handle,
    descriptorSetLayout2: vk.DescriptorSetLayout = .null_handle,
};

//Predefined Pipelines
pub var shape_color_2d_pipeline_set: pipeline_set = .{};
pub var pixel_shape_color_2d_pipeline_set: pipeline_set = .{};
//pub var color_2d_pipeline_set: pipeline_set = .{};
///tex_2d_pipeline_set's descriptorSetLayout2 shares with animate_tex_2d_pipeline_set
pub var tex_2d_pipeline_set: pipeline_set = .{};
pub var quad_shape_2d_pipeline_set: pipeline_set = .{};
pub var pixel_quad_shape_2d_pipeline_set: pipeline_set = .{};
pub var animate_tex_2d_pipeline_set: pipeline_set = .{};
pub var copy_screen_pipeline_set: pipeline_set = .{};
//

var shape_curve_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;
var quad_shape_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;
var tex_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;
var animate_tex_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;
var tile_tex_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;
var copy_screen_shader_stages: [2]vk.PipelineShaderStageCreateInfo = undefined;

pub var properties: vk.PhysicalDeviceProperties = undefined;
const inputAssembly: vk.PipelineInputAssemblyStateCreateInfo = .{
    .topology = .triangle_list,
    .primitive_restart_enable = vk.FALSE,
};

pub var is_fullscreen_ex: bool = false;

var copy_image_pool: vk.DescriptorPool = undefined;
var copy_image_set: vk.DescriptorSet = undefined;

const dynamicStates = [_]vk.DynamicState{ vk.DynamicState.viewport, vk.DynamicState.scissor };

const dynamicState: vk.PipelineDynamicStateCreateInfo = .{
    .dynamic_state_count = dynamicStates.len,
    .p_dynamic_states = &dynamicStates,
};

const viewportState: vk.PipelineViewportStateCreateInfo = .{
    .flags = .{},
    .viewport_count = 1,
    .p_viewports = null,
    .scissor_count = 1,
    .p_scissors = null,
};

const rasterizer: vk.PipelineRasterizationStateCreateInfo = .{
    .depth_clamp_enable = vk.FALSE,
    .rasterizer_discard_enable = vk.FALSE,
    .polygon_mode = vk.PolygonMode.fill,
    .line_width = 1,
    .cull_mode = .{},
    .front_face = vk.FrontFace.clockwise,
    .depth_bias_enable = vk.FALSE,
    .depth_bias_constant_factor = 0,
    .depth_bias_clamp = 0,
    .depth_bias_slope_factor = 0,
};

const multisampling: vk.PipelineMultisampleStateCreateInfo = .{
    .sample_shading_enable = vk.FALSE,
    .rasterization_samples = .{ .@"1_bit" = true },
    .min_sample_shading = 1,
    .p_sample_mask = null,
    .alpha_to_coverage_enable = vk.FALSE,
    .alpha_to_one_enable = vk.FALSE,
};

const multisampling4: vk.PipelineMultisampleStateCreateInfo = .{
    .sample_shading_enable = vk.TRUE,
    .rasterization_samples = .{ .@"4_bit" = true },
    .min_sample_shading = 1,
    .p_sample_mask = null,
    .alpha_to_coverage_enable = vk.FALSE,
    .alpha_to_one_enable = vk.FALSE,
};

const colorBlendAttachment: vk.PipelineColorBlendAttachmentState = .{
    .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
    .blend_enable = vk.FALSE,
    .src_color_blend_factor = vk.BlendFactor.one,
    .dst_color_blend_factor = vk.BlendFactor.zero,
    .color_blend_op = vk.BlendOp.add,
    .src_alpha_blend_factor = vk.BlendFactor.one,
    .dst_alpha_blend_factor = vk.BlendFactor.zero,
    .alpha_blend_op = vk.BlendOp.add,
};

const colorAlphaBlendAttachment: vk.PipelineColorBlendAttachmentState = .{
    .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
    .blend_enable = vk.TRUE,
    .src_color_blend_factor = vk.BlendFactor.src_alpha,
    .dst_color_blend_factor = vk.BlendFactor.one_minus_src_alpha,
    .color_blend_op = vk.BlendOp.add,
    .src_alpha_blend_factor = vk.BlendFactor.one,
    .dst_alpha_blend_factor = vk.BlendFactor.zero,
    .alpha_blend_op = vk.BlendOp.add,
};

///https://stackoverflow.com/a/34963588
const colorAlphaBlendAttachmentExternal: vk.PipelineColorBlendAttachmentState = .{
    .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
    .blend_enable = vk.TRUE,
    .src_color_blend_factor = vk.BlendFactor.src_alpha,
    .dst_color_blend_factor = vk.BlendFactor.one_minus_src_alpha,
    .color_blend_op = vk.BlendOp.add,
    .src_alpha_blend_factor = vk.BlendFactor.one,
    .dst_alpha_blend_factor = vk.BlendFactor.one_minus_src_alpha,
    .alpha_blend_op = vk.BlendOp.add,
};
const colorAlphaBlendAttachmentCopy: vk.PipelineColorBlendAttachmentState = .{
    .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = true },
    .blend_enable = vk.TRUE,
    .src_color_blend_factor = vk.BlendFactor.one,
    .dst_color_blend_factor = vk.BlendFactor.one_minus_src_alpha,
    .color_blend_op = vk.BlendOp.add,
    .src_alpha_blend_factor = vk.BlendFactor.zero,
    .dst_alpha_blend_factor = vk.BlendFactor.one,
    .alpha_blend_op = vk.BlendOp.add,
};

const noBlendAttachment: vk.PipelineColorBlendAttachmentState = .{
    .color_write_mask = .{},
    .blend_enable = vk.FALSE,
    .src_color_blend_factor = vk.BlendFactor.one,
    .dst_color_blend_factor = vk.BlendFactor.zero,
    .color_blend_op = vk.BlendOp.add,
    .src_alpha_blend_factor = vk.BlendFactor.one,
    .dst_alpha_blend_factor = vk.BlendFactor.zero,
    .alpha_blend_op = vk.BlendOp.add,
};

const colorBlending: vk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = vk.FALSE,
    .logic_op = vk.LogicOp.copy,
    .attachment_count = 1,
    .p_attachments = @ptrCast(&colorBlendAttachment),
    .blend_constants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlending: vk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = vk.FALSE,
    .logic_op = vk.LogicOp.copy,
    .attachment_count = 1,
    .p_attachments = @ptrCast(&colorAlphaBlendAttachment),
    .blend_constants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlendingExternal: vk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = vk.FALSE,
    .logic_op = vk.LogicOp.copy,
    .attachment_count = 1,
    .p_attachments = @ptrCast(&colorAlphaBlendAttachmentExternal),
    .blend_constants = .{ 0, 0, 0, 0 },
};

const colorAlphaBlendingCopy: vk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = vk.FALSE,
    .logic_op = vk.LogicOp.copy,
    .attachment_count = 1,
    .p_attachments = @ptrCast(&colorAlphaBlendAttachmentCopy),
    .blend_constants = .{ 0, 0, 0, 0 },
};

const noBlending: vk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = vk.FALSE,
    .logic_op = vk.LogicOp.copy,
    .attachment_count = 1,
    .p_attachments = @ptrCast(&noBlendAttachment),
    .blend_constants = .{ 0, 0, 0, 0 },
};

fn chooseSwapExtent(capabilities: vk.SurfaceCapabilitiesKHR) vk.Extent2D {
    if (capabilities.current_extent.width != std.math.maxInt(u32)) {
        return capabilities.current_extent;
    } else {
        var swapchainExtent = vk.Extent2D{ .width = @max(0, window.width()), .height = @max(0, window.height()) };
        swapchainExtent.width = std.math.clamp(swapchainExtent.width, capabilities.min_image_extent.width, capabilities.max_image_extent.width);
        swapchainExtent.height = std.math.clamp(swapchainExtent.height, capabilities.min_image_extent.height, capabilities.max_image_extent.height);
        return swapchainExtent;
    }
}

fn chooseSwapSurfaceFormat(availableFormats: []vk.SurfaceFormatKHR, comptime program_start: bool) vk.SurfaceFormatKHR {
    for (availableFormats) |value| {
        if (value.format == .r8g8b8a8_unorm) {
            if (program_start) {
                xfit.print_log("XFIT SYSLOG : vulkan swapchain format : {}, colorspace : {}\n", .{ value.format, value.color_space });
            }
            return value;
        }
    }
    for (availableFormats) |value| {
        if (value.format == .b8g8r8a8_unorm) {
            if (program_start) {
                xfit.print_log("XFIT SYSLOG : vulkan swapchain format : {}, colorspace : {}\n", .{ value.format, value.color_space });
            }
            return value;
        }
    }
    xfit.herrm("chooseSwapSurfaceFormat unsupported");
}

fn chooseSwapPresentMode(availablePresentModes: []vk.PresentModeKHR, _vSync: xfit.vSync_mode, comptime program_start: bool) vk.PresentModeKHR {
    if (_vSync == .double) {
        if (program_start) xfit.write_log("XFIT SYSLOG : vulkan present mode fifo_khr vsync default\n");
        return vk.PresentModeKHR.fifo_khr;
    } else if (_vSync == .triple) {
        for (availablePresentModes) |value| {
            if (value == vk.PresentModeKHR.mailbox_khr) {
                if (program_start) xfit.write_log("XFIT SYSLOG : vulkan present mode mailbox_khr\n");
                return value;
            }
        }
        for (availablePresentModes) |value| {
            if (value == vk.PresentModeKHR.immediate_khr) {
                if (program_start) xfit.write_log("XFIT SYSLOG : vulkan present mode immediate_khr mailbox_khr instead\n");
                return value;
            }
        }
    } else {
        for (availablePresentModes) |value| {
            if (value == vk.PresentModeKHR.immediate_khr) {
                if (program_start) xfit.write_log("XFIT SYSLOG : vulkan present mode immediate_khr\n");
                return value;
            }
        }
    }
    if (program_start) xfit.write_log("XFIT SYSLOG : vulkan present mode fifo_khr other not supported so default\n");
    return vk.PresentModeKHR.fifo_khr;
}
inline fn create_frag_shader_state(frag_module: vk.ShaderModule) vk.PipelineShaderStageCreateInfo {
    return .{
        .stage = .{ .fragment_bit = true },
        .module = frag_module,
        .p_name = "main",
    };
}

inline fn create_shader_state(vert_module: vk.ShaderModule, frag_module: vk.ShaderModule) [2]vk.PipelineShaderStageCreateInfo {
    const stage_infov1: vk.PipelineShaderStageCreateInfo = .{
        .stage = .{ .vertex_bit = true },
        .module = vert_module,
        .p_name = "main",
    };
    const stage_infof1: vk.PipelineShaderStageCreateInfo = .{
        .stage = .{ .fragment_bit = true },
        .module = frag_module,
        .p_name = "main",
    };

    return [2]vk.PipelineShaderStageCreateInfo{ stage_infov1, stage_infof1 };
}

pub var vkInstance: vk.Instance = undefined;
pub var vkDevice: vk.Device = .null_handle;
pub var vkSurface: vk.SurfaceKHR = .null_handle;
pub var vkRenderPass: vk.RenderPass = undefined;
pub var vkRenderPassClear: vk.RenderPass = undefined;
pub var vkRenderPassSample: vk.RenderPass = undefined;
pub var vkRenderPassSampleClear: vk.RenderPass = undefined;
pub var vkRenderPassCopy: vk.RenderPass = undefined;
pub var vkSwapchain: vk.SwapchainKHR = .null_handle;

pub var vkCommandPool: vk.CommandPool = undefined;
pub var vkCommandBuffer: [render_command.MAX_FRAME]vk.CommandBuffer = undefined;

pub var depth_optimal = false;
pub var depth_transfer_src_optimal = false;
pub var depth_transfer_dst_optimal = false;
pub var depth_sample_optimal = false;
pub var color_attach_optimal = false;
pub var color_sample_optimal = false;
pub var color_transfer_src_optimal = false;
pub var color_transfer_dst_optimal = false;

var vkImageAvailableSemaphore: [render_command.MAX_FRAME]vk.Semaphore = .{.null_handle} ** render_command.MAX_FRAME;
var vkRenderFinishedSemaphore: [render_command.MAX_FRAME]vk.Semaphore = .{.null_handle} ** render_command.MAX_FRAME;

pub var vkInFlightFence: [render_command.MAX_FRAME]vk.Fence = .{.null_handle} ** render_command.MAX_FRAME;

var vkDebugMessenger: vk.DebugUtilsMessengerEXT = .null_handle;

pub var vkGraphicsQueue: vk.Queue = undefined;
var vkPresentQueue: vk.Queue = undefined;

pub var vkExtent: vk.Extent2D = undefined;
var vkExtent_rotation: vk.Extent2D = undefined;

pub const FRAME_BUF = struct {
    normal: __vulkan_allocator.frame_buffer = .{},
    clear: __vulkan_allocator.frame_buffer = .{},
    sample: __vulkan_allocator.frame_buffer = .{},
    sample_clear: __vulkan_allocator.frame_buffer = .{},
    copy: __vulkan_allocator.frame_buffer = .{},
    pub fn deinit(self: *FRAME_BUF) void {
        self.*.normal.destroy_no_async();
        self.*.clear.destroy_no_async();
        self.*.sample.destroy_no_async();
        self.*.sample_clear.destroy_no_async();
        self.*.copy.destroy_no_async();
    }
};

pub var vk_swapchain_frame_buffers: []FRAME_BUF = undefined;
var vk_swapchain_images: []__vulkan_allocator.vulkan_res_node(.texture) = undefined;

pub var vk_physical_device: vk.PhysicalDevice = undefined;

pub var graphicsFamilyIndex: u32 = std.math.maxInt(u32);
var presentFamilyIndex: u32 = std.math.maxInt(u32);
var queueFamiliesCount: u32 = 0;

pub var surfaceCap: vk.SurfaceCapabilitiesKHR = undefined;

var formats: []vk.SurfaceFormatKHR = undefined;
pub var format: vk.SurfaceFormatKHR = undefined;
pub var depth_format: __vulkan_allocator.texture_format = .d24_unorm_s8_uint;
pub var presentMode: vk.PresentModeKHR = undefined;

pub var linear_sampler: vk.Sampler = undefined;
pub var nearest_sampler: vk.Sampler = undefined;
pub var no_color_tran: graphics.color_transform = undefined;

pub var depth_stencil_image_sample = __vulkan_allocator.vulkan_res_node(.texture){};
pub var color_image_sample = __vulkan_allocator.vulkan_res_node(.texture){};
pub var depth_stencil_image = __vulkan_allocator.vulkan_res_node(.texture){};
pub var color_image = __vulkan_allocator.vulkan_res_node(.texture){};

/// To construct base, instance and device wrappers for vulkan-zig, you need to pass a list of 'apis' to it.
const apis: []const vk.ApiInfo = &.{
    // Or you can add entire feature sets or extensions
    vk.features.version_1_0,
    //vk.features.version_1_1,
    vk.extensions.khr_surface,
    vk.extensions.khr_swapchain,
    if (xfit.dbg) vk.extensions.ext_debug_utils else .{},
    vk.extensions.ext_full_screen_exclusive,
    //vk.extensions.khr_get_surface_capabilities_2,
    vk.extensions.khr_swapchain,
    vk.extensions.khr_surface,
    if (xfit.platform == .linux) vk.extensions.khr_xlib_surface else if (xfit.platform == .windows) vk.extensions.khr_win_32_surface else if (xfit.platform == .android) vk.extensions.khr_android_surface else @compileError("not support platform."),
};

const BaseDispatch = vk.BaseWrapper(apis);
const InstanceDispatch = vk.InstanceWrapper(apis);
const DeviceDispatch = vk.DeviceWrapper(apis);

const Instance = vk.InstanceProxy(apis);
const Device = vk.DeviceProxy(apis);

pub var vkb: BaseDispatch = undefined;
pub threadlocal var vki: ?Instance = null;
pub var instance_wrap: InstanceDispatch = undefined;
pub var device_wrap: DeviceDispatch = undefined;
pub threadlocal var vkd: ?Device = null;

//instance
pub var VK_KHR_get_surface_capabilities2_support = false;
pub var VK_KHR_portability_enumeration_support = false;
pub var validation_layer_support = false;
//device
pub var VK_EXT_full_screen_exclusive_support = false;
pub var VK_KHR_portability_subset_support = false;

fn createShaderModule(code: []align(@alignOf(u32)) const u8) vk.ShaderModule {
    const createInfo: vk.ShaderModuleCreateInfo = .{ .code_size = code.len, .p_code = @ptrCast(code.ptr) };

    var shaderModule: vk.ShaderModule = undefined;
    shaderModule = vkd.?.createShaderModule(&createInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createShaderModule createShaderModule", e);

    return shaderModule;
}

fn create_sync_object() void {
    var i: usize = 0;
    while (i < render_command.MAX_FRAME) : (i += 1) {
        const semaphoreInfo: vk.SemaphoreCreateInfo = .{};
        const fenceInfo: vk.FenceCreateInfo = .{ .flags = .{ .signaled_bit = true } };

        vkImageAvailableSemaphore[i] = vkd.?.createSemaphore(&semaphoreInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start CreateSemaphore vkImageAvailableSemaphore", e);
        vkRenderFinishedSemaphore[i] = vkd.?.createSemaphore(&semaphoreInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start CreateSemaphore vkRenderFinishedSemaphore", e);

        vkInFlightFence[i] = vkd.?.createFence(&fenceInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start CreateFence vkInFlightFence", e);
    }
}

fn cleanup_sync_object() void {
    var i: usize = 0;
    while (i < render_command.MAX_FRAME) : (i += 1) {
        vkd.?.destroySemaphore(vkImageAvailableSemaphore[i], null);
        vkd.?.destroySemaphore(vkRenderFinishedSemaphore[i], null);
        vkd.?.destroyFence(vkInFlightFence[i], null);
    }
}

var shape_list: ArrayList(*graphics.iobject) = undefined;

fn recordCommandBuffer(commandBuffer: **render_command, fr: u32) void {
    if (commandBuffer.*.scene == null or commandBuffer.*.scene.?.len == 0) {
        return;
    }
    var i: usize = 0;
    while (i < commandBuffer.*.*.__command_buffers[fr].len) : (i += 1) {
        const cmd = commandBuffer.*.*.__command_buffers[fr][i];
        const beginInfo: vk.CommandBufferBeginInfo = .{
            .flags = .{},
            .p_inheritance_info = null,
        };
        vkd.?.beginCommandBuffer(cmd, &beginInfo) catch |e| xfit.herr3("__vulkan.recordCommandBuffer.beginCommandBuffer", e);

        const clearColor: vk.ClearValue = .{ .color = .{ .float_32 = .{ 0, 0, 0, 0 } } };
        const clearDepthStencil: vk.ClearValue = .{ .depth_stencil = .{ .stencil = 0, .depth = 1 } };
        const renderPassInfo: vk.RenderPassBeginInfo = .{
            .render_pass = vkRenderPass,
            .framebuffer = vk_swapchain_frame_buffers[i].normal.res,
            .render_area = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
            .clear_value_count = 2,
            .p_clear_values = &[_]vk.ClearValue{ clearColor, clearDepthStencil },
        };

        vkd.?.cmdBeginRenderPass(cmd, &renderPassInfo, .@"inline");
        const viewport: vk.Viewport = .{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(vkExtent_rotation.width),
            .height = @floatFromInt(vkExtent_rotation.height),
            .max_depth = 1,
            .min_depth = 0,
        };
        const scissor: vk.Rect2D = .{ .offset = vk.Offset2D{ .x = 0, .y = 0 }, .extent = vkExtent_rotation };

        vkd.?.cmdSetViewport(cmd, 0, 1, @ptrCast(&viewport));
        vkd.?.cmdSetScissor(cmd, 0, 1, @ptrCast(&scissor));

        shape_list.resize(0) catch unreachable;

        commandBuffer.*.*.objs_lock.lock();
        const objs = __system.allocator.dupe(graphics.iobject, commandBuffer.*.*.scene.?) catch unreachable;
        commandBuffer.*.*.objs_lock.unlock();
        defer __system.allocator.free(objs);

        for (objs) |*value| {
            if (!value.*.v.*.__xfit_is_shape_type) {
                value.*.v.*.draw(value.*.target, @intFromEnum(cmd));
            } else {
                shape_list.append(value) catch unreachable;
            }
        }

        vkd.?.cmdEndRenderPass(cmd);

        if (shape_list.items.len > 0) {
            var renderPassInfo2: vk.RenderPassBeginInfo = .{
                .render_pass = vkRenderPassSampleClear,
                .framebuffer = vk_swapchain_frame_buffers[i].sample_clear.res,
                .render_area = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
                .clear_value_count = 2,
                .p_clear_values = &[_]vk.ClearValue{ clearColor, clearDepthStencil },
            };
            vkd.?.cmdBeginRenderPass(cmd, &renderPassInfo2, .@"inline");
            vkd.?.cmdEndRenderPass(cmd);
            renderPassInfo2.framebuffer = vk_swapchain_frame_buffers[i].sample.res;
            renderPassInfo2.render_pass = vkRenderPassSample;
            vkd.?.cmdBeginRenderPass(cmd, &renderPassInfo2, .@"inline");
            for (shape_list.items) |value| {
                value.*.v.*.draw(value.target, @intFromEnum(cmd));
            }
            vkd.?.cmdEndRenderPass(cmd);

            renderPassInfo2.framebuffer = vk_swapchain_frame_buffers[i].copy.res;
            renderPassInfo2.render_pass = vkRenderPassCopy;
            vkd.?.cmdBeginRenderPass(cmd, &renderPassInfo2, .@"inline");
            vkd.?.cmdBindPipeline(cmd, .graphics, copy_screen_pipeline_set.pipeline);

            vkd.?.cmdBindDescriptorSets(
                cmd,
                .graphics,
                copy_screen_pipeline_set.pipelineLayout,
                0,
                1,
                @ptrCast(&copy_image_set),
                0,
                null,
            );
            vkd.?.cmdDraw(cmd, 6, 1, 0, 0);
            vkd.?.cmdEndRenderPass(cmd);
        }

        vkd.?.endCommandBuffer(cmd) catch |e| xfit.herr3("__vulkan.recordCommandBuffer.endCommandBuffer", e);
    }
}

fn debug_callback(messageSeverity: vk.DebugUtilsMessageSeverityFlagsEXT, messageType: vk.DebugUtilsMessageTypeFlagsEXT, pCallbackData: ?*const vk.DebugUtilsMessengerCallbackDataEXT, pUserData: ?*anyopaque) callconv(.C) vk.Bool32 {
    if (pCallbackData.?.*.message_id_number == 1284057537) return vk.FALSE; //https://vulkan.lunarg.com/doc/view/1.3.283.0/windows/1.3-extensions/vkspec.html#VUID-VkSwapchainCreateInfoKHR-pNext-07781
    if (pCallbackData.?.*.message_id_number == -1813885519) return vk.FALSE; //https://vulkan.lunarg.com/doc/view/1.3.296.0/linux/1.3-extensions/vkspec.html#VUID-vkDestroySemaphore-semaphore-05149
    _ = messageSeverity;
    _ = messageType;
    _ = pUserData;

    if (xfit.platform == .android) {
        _ = __android.LOGE(pCallbackData.?.*.p_message, .{});
    } else {
        const len = std.mem.len(pCallbackData.?.*.p_message.?);
        const msg = std.heap.c_allocator.alloc(u8, len) catch |e| xfit.herr3("debug_callback.alloc()", e);
        @memcpy(msg, pCallbackData.?.*.p_message.?[0..len]);
        defer std.heap.c_allocator.free(msg);

        xfit.print("{s}\n\n", .{msg});
    }

    return vk.FALSE;
}

fn cleanup_pipelines() void {
    vkd.?.destroyPipeline(quad_shape_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(shape_color_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(pixel_shape_color_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(pixel_quad_shape_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(tex_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(animate_tex_2d_pipeline_set.pipeline, null);
    vkd.?.destroyPipeline(copy_screen_pipeline_set.pipeline, null);
}

fn create_pipelines() void {
    const nullVertexInputInfo: vk.PipelineVertexInputStateCreateInfo = .{
        .vertex_binding_description_count = 0,
        .vertex_attribute_description_count = 0,
        .p_vertex_binding_descriptions = null,
        .p_vertex_attribute_descriptions = null,
    };
    const quad_stencilOp = vk.StencilOpState{
        .compare_mask = 0xff,
        .write_mask = 0xff,
        .compare_op = vk.CompareOp.equal,
        .depth_fail_op = vk.StencilOp.zero,
        .pass_op = vk.StencilOp.zero,
        .fail_op = vk.StencilOp.zero,
        .reference = 0xff,
    };
    const shape_stencilOp = vk.StencilOpState{
        .compare_mask = 0xff,
        .write_mask = 0xff,
        .compare_op = vk.CompareOp.always,
        .depth_fail_op = vk.StencilOp.zero,
        .pass_op = vk.StencilOp.invert,
        .fail_op = vk.StencilOp.zero,
        .reference = 0xff,
    };
    const defDepthStencilState = vk.PipelineDepthStencilStateCreateInfo{
        .stencil_test_enable = vk.FALSE,
        .depth_test_enable = vk.TRUE,
        .depth_write_enable = vk.TRUE,
        .depth_bounds_test_enable = vk.FALSE,
        .depth_compare_op = vk.CompareOp.less_or_equal,
        .front = quad_stencilOp, //no meaning value
        .back = quad_stencilOp,
        .max_depth_bounds = 0,
        .min_depth_bounds = 0,
    };
    const shapeDepthStencilState = vk.PipelineDepthStencilStateCreateInfo{
        .stencil_test_enable = vk.TRUE,
        .depth_test_enable = vk.TRUE,
        .depth_write_enable = vk.TRUE,
        .depth_bounds_test_enable = vk.FALSE,
        .depth_compare_op = vk.CompareOp.less_or_equal,
        .flags = .{},
        .max_depth_bounds = 0,
        .min_depth_bounds = 0,
        .back = shape_stencilOp,
        .front = shape_stencilOp,
    };
    const quadDepthStencilState = vk.PipelineDepthStencilStateCreateInfo{
        .stencil_test_enable = vk.TRUE,
        .depth_test_enable = vk.FALSE,
        .depth_write_enable = vk.FALSE,
        .depth_bounds_test_enable = vk.FALSE,
        .depth_compare_op = vk.CompareOp.never,
        .flags = .{},
        .max_depth_bounds = 0,
        .min_depth_bounds = 0,
        .back = quad_stencilOp,
        .front = quad_stencilOp,
    };

    {
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &quad_shape_shader_stages,
            .p_vertex_input_state = &nullVertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling4,
            .p_depth_stencil_state = &quadDepthStencilState,
            .p_color_blend_state = &colorAlphaBlendingExternal,
            .p_dynamic_state = &dynamicState,
            .layout = quad_shape_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPassSample,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&quad_shape_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines quad_shape_2d_pipeline_set.pipeline", e);
    }
    {
        const bindingDescription: vk.VertexInputBindingDescription = .{
            .binding = 0,
            .stride = @sizeOf(f32) * (2 + 3),
            .input_rate = .vertex,
        };
        const attributeDescriptions: [2]vk.VertexInputAttributeDescription = .{
            .{ .binding = 0, .location = 0, .format = vk.Format.r32g32_sfloat, .offset = 0 },
            .{ .binding = 0, .location = 1, .format = vk.Format.r32g32b32_sfloat, .offset = @sizeOf(f32) * (2) },
        };

        const vertexInputInfo: vk.PipelineVertexInputStateCreateInfo = .{
            .vertex_binding_description_count = 1,
            .vertex_attribute_description_count = attributeDescriptions.len,
            .p_vertex_binding_descriptions = @ptrCast(&bindingDescription),
            .p_vertex_attribute_descriptions = @ptrCast(&attributeDescriptions),
        };
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &shape_curve_shader_stages,
            .p_vertex_input_state = &vertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling4,
            .p_depth_stencil_state = &shapeDepthStencilState,
            .p_color_blend_state = &noBlending,
            .p_dynamic_state = &dynamicState,
            .layout = shape_color_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPassSample,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&shape_color_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines shape_curve_shader_stages.pipeline", e);
    }
    {
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &quad_shape_shader_stages,
            .p_vertex_input_state = &nullVertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling,
            .p_depth_stencil_state = &quadDepthStencilState,
            .p_color_blend_state = &colorAlphaBlending,
            .p_dynamic_state = &dynamicState,
            .layout = quad_shape_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPass,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&pixel_quad_shape_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines pixel_quad_shape_2d_pipeline_set.pipeline", e);
    }
    {
        const bindingDescription: vk.VertexInputBindingDescription = .{
            .binding = 0,
            .stride = @sizeOf(f32) * (2 + 3),
            .input_rate = .vertex,
        };
        const attributeDescriptions: [2]vk.VertexInputAttributeDescription = .{
            .{ .binding = 0, .location = 0, .format = vk.Format.r32g32_sfloat, .offset = 0 },
            .{ .binding = 0, .location = 1, .format = vk.Format.r32g32b32_sfloat, .offset = @sizeOf(f32) * (2) },
        };

        const vertexInputInfo: vk.PipelineVertexInputStateCreateInfo = .{
            .vertex_binding_description_count = 1,
            .vertex_attribute_description_count = attributeDescriptions.len,
            .p_vertex_binding_descriptions = @ptrCast(&bindingDescription),
            .p_vertex_attribute_descriptions = @ptrCast(&attributeDescriptions),
        };
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &shape_curve_shader_stages,
            .p_vertex_input_state = &vertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling,
            .p_depth_stencil_state = &shapeDepthStencilState,
            .p_color_blend_state = &noBlending,
            .p_dynamic_state = &dynamicState,
            .layout = shape_color_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPass,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&pixel_shape_color_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines pixel_shape_color_2d_pipeline_set.pipeline", e);
    }
    {
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &tex_shader_stages,
            .p_vertex_input_state = &nullVertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling,
            .p_depth_stencil_state = &defDepthStencilState,
            .p_color_blend_state = &colorAlphaBlending,
            .p_dynamic_state = &dynamicState,
            .layout = tex_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPass,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&tex_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines tex_2d_pipeline_set.pipeline", e);
    }
    {
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &animate_tex_shader_stages,
            .p_vertex_input_state = &nullVertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling,
            .p_depth_stencil_state = &defDepthStencilState,
            .p_color_blend_state = &colorAlphaBlending,
            .p_dynamic_state = &dynamicState,
            .layout = animate_tex_2d_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPass,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };
        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&animate_tex_2d_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines animate_tex_2d_pipeline_set.pipeline", e);
    }
    {
        const pipelineInfo: vk.GraphicsPipelineCreateInfo = .{
            .stage_count = 2,
            .p_stages = &copy_screen_shader_stages,
            .p_vertex_input_state = &nullVertexInputInfo,
            .p_input_assembly_state = &inputAssembly,
            .p_viewport_state = &viewportState,
            .p_rasterization_state = &rasterizer,
            .p_multisample_state = &multisampling,
            .p_depth_stencil_state = null,
            .p_color_blend_state = &colorAlphaBlendingCopy,
            .p_dynamic_state = &dynamicState,
            .layout = copy_screen_pipeline_set.pipelineLayout,
            .render_pass = vkRenderPassCopy,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };
        _ = vkd.?.createGraphicsPipelines(.null_handle, 1, @ptrCast(&pipelineInfo), null, @ptrCast(&copy_screen_pipeline_set.pipeline)) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateGraphicsPipelines copy_screen_pipeline_set.pipeline", e);
    }
}

const PFN_vkGetInstanceProcAddr = *const fn (vk.Instance, [*:0]const u8) callconv(.C) ?*align(@alignOf(?*const fn () void)) anyopaque;
pub var vkGetInstanceProcAddr: PFN_vkGetInstanceProcAddr = undefined;
pub var vkCreateDebugUtilsMessengerEXT: vk.PfnCreateDebugUtilsMessengerEXT = undefined;
pub var vkDestroyDebugUtilsMessengerEXT: vk.PfnDestroyDebugUtilsMessengerEXT = undefined;

pub fn load_instance_and_device() void {
    if (vki == null) {
        vki = Instance.init(vkInstance, &instance_wrap);
    }
    if (vkd == null) {
        vkd = Device.init(vkDevice, &device_wrap);
    }
}

var vulkanF: ?*anyopaque = undefined;

pub fn vulkan_start() void {
    if (xfit.platform == .windows) {
        vulkanF = __windows.win32.LoadLibraryA("vulkan-1.dll");
        if (vulkanF == null) xfit.herr2("vulkan lib open : {d}", .{std.os.windows.GetLastError()});
        vkGetInstanceProcAddr = @alignCast(@ptrCast(__windows.win32.GetProcAddress(vulkanF, "vkGetInstanceProcAddr") orelse xfit.herrm("vulkan load vkGetInstanceProcAddr")));
    } else {
        vulkanF = std.c.dlopen("libvulkan.so.1", .{ .NOW = true });
        if (vulkanF == null) {
            vulkanF = std.c.dlopen("libvulkan.so", .{ .NOW = true });
            if (vulkanF == null) xfit.herr2("vulkan lib open : {s}", .{std.c.dlerror().?});
        }
        vkGetInstanceProcAddr = @alignCast(@ptrCast(std.c.dlsym(vulkanF, "vkGetInstanceProcAddr") orelse xfit.herrm("vulkan load vkGetInstanceProcAddr")));
    }

    vkb = BaseDispatch.loadNoFail(vkGetInstanceProcAddr);

    var appInfo: vk.ApplicationInfo = .{
        .p_application_name = __system.title.ptr,
        .application_version = vk.makeApiVersion(1, 0, 0, 0),
        .p_engine_name = "Xfit",
        .engine_version = vk.makeApiVersion(1, 0, 0, 0),
        .api_version = vk.API_VERSION_1_3,
    };
    _ = vkGetInstanceProcAddr(.null_handle, "vkEnumerateInstanceVersion") orelse {
        xfit.write_log("XFIT SYSLOG : vulkan 1.0 device, set api version 1.0\n");
        appInfo.api_version = vk.API_VERSION_1_0;
    };

    {
        const ext = [_][:0]const u8{
            "VK_KHR_get_surface_capabilities2",
            "VK_KHR_portability_enumeration",
        };
        const checked: [ext.len]*bool = .{ &VK_KHR_get_surface_capabilities2_support, &VK_KHR_portability_enumeration_support };

        const layers = [_][:0]const u8{
            "VK_LAYER_KHRONOS_validation",
        };
        const checkedl: [layers.len]*bool = .{&validation_layer_support};

        var extension_names = ArrayList([*:0]const u8).init(std.heap.c_allocator);
        defer extension_names.deinit();
        var layers_names = ArrayList([*:0]const u8).init(std.heap.c_allocator);
        defer layers_names.deinit();

        extension_names.append(vk.extensions.khr_surface.name.ptr) catch |e| xfit.herr3("vulkan_start.extension_names.append(vk.VK_KHR_SURFACE_EXTENSION_NAME)", e);

        var count: u32 = undefined;
        _ = vkb.enumerateInstanceLayerProperties(&count, null) catch unreachable;

        const available_layers = std.heap.c_allocator.alloc(vk.LayerProperties, count) catch
            xfit.herrm("vulkan_start.allocator.alloc(vk.LayerProperties) OutOfMemory");
        defer std.heap.c_allocator.free(available_layers);

        _ = vkb.enumerateInstanceLayerProperties(&count, available_layers.ptr) catch unreachable;

        for (available_layers) |*value| {
            for (layers, checkedl) |t, b| {
                if (!b.* and std.mem.eql(u8, t, value.*.layer_name[0..t.len])) {
                    if (!xfit.dbg and b == &validation_layer_support) continue;
                    layers_names.append(t) catch xfit.herrm("__vulkan_start layer append");
                    b.* = true;
                    xfit.print_log("XFIT SYSLOG : vulkan {s} instance layer support\n", .{t});
                }
            }
        }

        _ = vkb.enumerateInstanceExtensionProperties(null, &count, null) catch unreachable;

        const available_ext = std.heap.c_allocator.alloc(vk.ExtensionProperties, count) catch
            xfit.herrm("vulkan_start.allocator.alloc(vk.LayerProperties) OutOfMemory");
        defer std.heap.c_allocator.free(available_ext);

        _ = vkb.enumerateInstanceExtensionProperties(null, &count, available_ext.ptr) catch unreachable;

        for (available_ext) |*value| {
            inline for (ext, checked) |t, b| {
                if (!b.* and std.mem.eql(u8, t, value.*.extension_name[0..t.len])) {
                    extension_names.append(t) catch xfit.herrm("__vulkan_start ext append");
                    b.* = true;
                    xfit.print_log("XFIT SYSLOG : vulkan {s} instance ext support\n", .{t});
                }
            }
        }

        if (validation_layer_support) {
            extension_names.append(vk.extensions.ext_debug_utils.name.ptr) catch |e| xfit.herr3("vulkan_start.extension_names.append(vk.VK_EXT_DEBUG_UTILS_EXTENSION_NAME)", e);

            xfit.write_log("XFIT SYSLOG : vulkan validation layer enable\n");
        } else {
            validation_layer_support = false;
        }

        if (xfit.platform == .windows) {
            extension_names.append(vk.extensions.khr_win_32_surface.name.ptr) catch |e| xfit.herr3("vulkan_start.extension_names.append(vk.VK_KHR_WIN32_SURFACE_EXTENSION_NAME)", e);
        } else if (xfit.platform == .android) {
            extension_names.append(vk.extensions.khr_android_surface.name.ptr) catch |e| xfit.herr3("vulkan_start.extension_names.append(vk.VK_KHR_ANDROID_SURFACE_EXTENSION_NAME)", e);
        } else if (xfit.platform == .linux) {
            extension_names.append(vk.extensions.khr_xlib_surface.name.ptr) catch |e| xfit.herr3("vulkan_start.extension_names.append(vk.VK_KHR_XLIB_SURFACE_EXTENSION_NAME)", e);
        } else {
            @compileError("not support platform");
        }

        // const enables = [_]vk.ValidationFeatureEnableEXT{vk.VK_VALIDATION_FEATURE_ENABLE_BEST_PRACTICES_EXT};
        // const features = if (validation_layer_support) vk.ValidationFeaturesEXT{
        //     .enabledValidationFeatureCount = 1,
        //     .pEnabledValidationFeatures = &enables,
        // } else null;
        const features = null;

        var createInfo: vk.InstanceCreateInfo = .{
            .p_application_info = &appInfo,
            .enabled_layer_count = @intCast(layers_names.items.len),
            .pp_enabled_layer_names = if (layers_names.items.len > 0) layers_names.items.ptr else null,
            .enabled_extension_count = @intCast(extension_names.items.len),
            .pp_enabled_extension_names = extension_names.items.ptr,
            .p_next = if (features == null) null else @ptrCast(&features),
            .flags = .{ .enumerate_portability_bit_khr = VK_KHR_portability_enumeration_support },
        };

        vkInstance = vkb.createInstance(&createInfo, null) catch |e|
            xfit.herr3("__vulkan.vulkan_startCreateInstance", e);

        instance_wrap = InstanceDispatch.loadNoFail(vkInstance, vkGetInstanceProcAddr);
        vki = Instance.init(vkInstance, &instance_wrap);
    }

    if (validation_layer_support and xfit.dbg) {
        const create_info = vk.DebugUtilsMessengerCreateInfoEXT{
            .message_severity = .{ .verbose_bit_ext = true, .warning_bit_ext = true, .error_bit_ext = true },
            .message_type = .{ .general_bit_ext = true, .validation_bit_ext = true, .performance_bit_ext = true },
            .pfn_user_callback = debug_callback,
            .p_user_data = null,
        };
        vkDebugMessenger = vki.?.createDebugUtilsMessengerEXT(&create_info, null) catch |e| xfit.herr3("createDebugUtilsMessengerEXT", e);
    }

    if (xfit.platform == .windows) {
        __windows.vulkan_windows_start(&vkSurface);
    } else if (xfit.platform == .android) {
        __android.vulkan_android_start(&vkSurface);
    } else if (xfit.platform == .linux) {
        __linux.vulkan_linux_start(&vkSurface);
    } else {
        @compileError("not support platform");
    }

    var deviceCount: u32 = 0;
    _ = vki.?.enumeratePhysicalDevices(&deviceCount, null) catch unreachable;

    //xfit.print_debug("deviceCount : {d}", .{deviceCount});
    xfit.herr(deviceCount != 0, "__vulkan.vulkan_start.deviceCount 0", .{});
    const vk_physical_devices = std.heap.c_allocator.alloc(vk.PhysicalDevice, deviceCount) catch
        xfit.herrm("vulkan_start.allocator.alloc(vk.PhysicalDevice) OutOfMemory");
    defer std.heap.c_allocator.free(vk_physical_devices);

    _ = vki.?.enumeratePhysicalDevices(&deviceCount, vk_physical_devices.ptr) catch unreachable;

    out: for (vk_physical_devices) |pd| {
        vki.?.getPhysicalDeviceQueueFamilyProperties(pd, &queueFamiliesCount, null);
        xfit.herr(queueFamiliesCount != 0, "__vulkan.vulkan_start.queueFamiliesCount 0", .{});

        const queueFamilies = std.heap.c_allocator.alloc(vk.QueueFamilyProperties, queueFamiliesCount) catch
            xfit.herrm("vulkan_start.allocator.alloc(vk.QueueFamilyProperties) OutOfMemory");
        defer std.heap.c_allocator.free(queueFamilies);

        vki.?.getPhysicalDeviceQueueFamilyProperties(pd, &queueFamiliesCount, queueFamilies.ptr);

        var i: u32 = 0;
        while (i < queueFamiliesCount) : (i += 1) {
            if (queueFamilies[i].queue_flags.contains(.{ .graphics_bit = true })) {
                graphicsFamilyIndex = i;
            }
            var presentSupport: vk.Bool32 = 0;
            presentSupport = vki.?.getPhysicalDeviceSurfaceSupportKHR(pd, i, vkSurface) catch unreachable;

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
    const qci = [_]vk.DeviceQueueCreateInfo{
        .{
            .queue_family_index = graphicsFamilyIndex,
            .queue_count = 1,
            .p_queue_priorities = &priority,
        },
        .{
            .queue_family_index = presentFamilyIndex,
            .queue_count = 1,
            .p_queue_priorities = &priority,
        },
    };

    const queue_count: u32 = if (graphicsFamilyIndex == presentFamilyIndex) 1 else 2;

    var deviceFeatures: vk.PhysicalDeviceFeatures = .{
        .sampler_anisotropy = vk.TRUE,
        .sample_rate_shading = vk.TRUE,
    };

    {
        var deviceExtensionCount: u32 = 0;
        _ = vki.?.enumerateDeviceExtensionProperties(vk_physical_device, null, &deviceExtensionCount, null) catch |e|
            xfit.herr3("__vulkan_start enumerateDeviceExtensionProperties", e);
        const extensions = std.heap.c_allocator.alloc(vk.ExtensionProperties, deviceExtensionCount) catch xfit.herrm("vulkan_start extensions alloc");
        defer std.heap.c_allocator.free(extensions);
        _ = vki.?.enumerateDeviceExtensionProperties(vk_physical_device, null, &deviceExtensionCount, extensions.ptr) catch |e|
            xfit.herr3("__vulkan_start enumerateDeviceExtensionProperties", e);

        var device_extension_names = ArrayList([*:0]const u8).init(std.heap.c_allocator);
        defer device_extension_names.deinit();
        device_extension_names.append(vk.extensions.khr_swapchain.name.ptr) catch xfit.herrm("vulkan_start dev ex append");
        var i: u32 = 0;

        const ext = [_][:0]const u8{
            "VK_EXT_full_screen_exclusive",
            //"VK_KHR_depth_stencil_resolve",
            //"VK_KHR_create_renderpass2",
            "VK_KHR_portability_subset",
        };
        const checked: [ext.len]*bool = .{
            &VK_EXT_full_screen_exclusive_support,
            //&VK_KHR_depth_stencil_resolve_support,
            // &VK_KHR_create_renderpass2_support,
            &VK_KHR_portability_subset_support,
        };

        while (i < deviceExtensionCount) : (i += 1) {
            inline for (ext, checked) |t, b| {
                if (!b.* and std.mem.eql(u8, t, extensions[i].extension_name[0..t.len])) {
                    if (!(xfit.is_mobile and b == &VK_EXT_full_screen_exclusive_support)) {
                        device_extension_names.append(t.ptr) catch xfit.herrm("vulkan_start dev ex append");
                        b.* = true;
                        xfit.print_log("XFIT SYSLOG : vulkan {s} device ext support\n", .{t});
                    }
                }
            }
        }

        var deviceCreateInfo: vk.DeviceCreateInfo = .{
            .p_queue_create_infos = &qci,
            .queue_create_info_count = queue_count,
            .p_enabled_features = &deviceFeatures,
            .pp_enabled_extension_names = device_extension_names.items.ptr,
            .enabled_extension_count = @intCast(device_extension_names.items.len),
        };

        vkDevice = vki.?.createDevice(vk_physical_device, &deviceCreateInfo, null) catch |e| xfit.herr3("__vulkan_start createDevice", e);
        device_wrap = DeviceDispatch.loadNoFail(vkDevice, instance_wrap.dispatch.vkGetDeviceProcAddr);
        vkd = Device.init(vkDevice, &device_wrap);
    }

    mem_prop = vki.?.getPhysicalDeviceMemoryProperties(vk_physical_device);
    properties = vki.?.getPhysicalDeviceProperties(vk_physical_device);

    if (graphicsFamilyIndex == presentFamilyIndex) {
        vkGraphicsQueue = vkd.?.getDeviceQueue(graphicsFamilyIndex, 0);
        vkPresentQueue = vkGraphicsQueue;
    } else {
        vkGraphicsQueue = vkd.?.getDeviceQueue(graphicsFamilyIndex, 0);
        vkPresentQueue = vkd.?.getDeviceQueue(presentFamilyIndex, 0);
    }

    __vulkan_allocator.init_block_len();

    __vulkan_allocator.init();

    create_swapchain_and_imageviews(true);

    var sampler_info: vk.SamplerCreateInfo = .{
        .address_mode_u = .repeat,
        .address_mode_v = .repeat,
        .address_mode_w = .repeat,
        .mipmap_mode = .linear,
        .mag_filter = .linear,
        .min_filter = .linear,
        .mip_lod_bias = 0,
        .compare_op = .always,
        .compare_enable = vk.FALSE,
        .unnormalized_coordinates = vk.FALSE,
        .min_lod = 0,
        .max_lod = 0,
        .anisotropy_enable = vk.FALSE,
        .max_anisotropy = properties.limits.max_sampler_anisotropy,
        .border_color = .int_opaque_white,
    };
    linear_sampler = vkd.?.createSampler(&sampler_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createSampler linear_sampler", e);

    sampler_info.mipmap_mode = .nearest;
    sampler_info.mag_filter = .nearest;
    sampler_info.min_filter = .nearest;
    nearest_sampler = vkd.?.createSampler(&sampler_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createSampler nearest_sampler", e);

    const depthAttachmentSample: vk.AttachmentDescription = .{
        .format = depth_format.__get(),
        .samples = .{ .@"4_bit" = true },
        .load_op = .load,
        .store_op = .store,
        .stencil_load_op = .clear,
        .stencil_store_op = .store,
        .initial_layout = .depth_stencil_attachment_optimal,
        .final_layout = .depth_stencil_attachment_optimal,
    };

    const depthAttachmentSampleClear: vk.AttachmentDescription = .{
        .format = depth_format.__get(),
        .samples = .{ .@"4_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .depth_stencil_attachment_optimal,
    };

    const colorAttachmentSampleClear: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"4_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .color_attachment_optimal,
    };

    const colorAttachmentSample: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"4_bit" = true },
        .load_op = .load,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .color_attachment_optimal,
        .final_layout = .color_attachment_optimal,
    };

    const colorAttachmentResolve: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .dont_care,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .color_attachment_optimal,
    };

    const colorAttachmentLoadResolve: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .load,
        .store_op = .dont_care,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .color_attachment_optimal,
        .final_layout = .color_attachment_optimal,
    };

    const colorAttachmentClear: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .present_src_khr,
    };

    const depthAttachmentClear: vk.AttachmentDescription = .{
        .format = depth_format.__get(),
        .samples = .{ .@"1_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .present_src_khr,
    };

    const colorAttachment: vk.AttachmentDescription = .{
        .format = format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .load,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .present_src_khr,
        .final_layout = .present_src_khr,
    };

    const depthAttachment: vk.AttachmentDescription = .{
        .format = depth_format.__get(),
        .samples = .{ .@"1_bit" = true },
        .load_op = .load,
        .store_op = .store,
        .stencil_load_op = .clear,
        .stencil_store_op = .store,
        .initial_layout = .present_src_khr,
        .final_layout = .present_src_khr,
    };

    const colorAttachmentRef: vk.AttachmentReference = .{ .attachment = 0, .layout = .color_attachment_optimal };
    const colorResolveAttachmentRef: vk.AttachmentReference = .{ .attachment = 2, .layout = .color_attachment_optimal };
    const depthAttachmentRef: vk.AttachmentReference = .{ .attachment = 1, .layout = .depth_stencil_attachment_optimal };
    const inputAttachmentRef: vk.AttachmentReference = .{ .attachment = 1, .layout = .shader_read_only_optimal };

    const subpass: vk.SubpassDescription = .{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .p_color_attachments = @ptrCast(&colorAttachmentRef),
        .p_depth_stencil_attachment = &depthAttachmentRef,
    };

    const subpass_resolve: vk.SubpassDescription = .{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .p_color_attachments = @ptrCast(&colorAttachmentRef),
        .p_depth_stencil_attachment = &depthAttachmentRef,
        .p_resolve_attachments = @ptrCast(&colorResolveAttachmentRef),
    };

    const subpass_copy: vk.SubpassDescription = .{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .input_attachment_count = 1,
        .p_input_attachments = @ptrCast(&inputAttachmentRef),
        .p_color_attachments = @ptrCast(&colorAttachmentRef),
    };

    const dependency: vk.SubpassDependency = .{
        .src_subpass = vk.SUBPASS_EXTERNAL,
        .dst_subpass = 0,
        .src_stage_mask = .{ .color_attachment_output_bit = true, .late_fragment_tests_bit = true },
        .src_access_mask = .{},
        .dst_stage_mask = .{ .color_attachment_output_bit = true, .early_fragment_tests_bit = true },
        .dst_access_mask = .{ .color_attachment_read_bit = true, .depth_stencil_attachment_read_bit = true },
    };

    var renderPassInfo: vk.RenderPassCreateInfo = .{
        .attachment_count = 3,
        .p_attachments = &[_]vk.AttachmentDescription{ colorAttachmentSample, depthAttachmentSample, colorAttachmentResolve },
        .subpass_count = 1,
        .p_subpasses = &[_]vk.SubpassDescription{subpass_resolve},
        .p_dependencies = @ptrCast(&dependency),
        .dependency_count = 1,
    };

    vkRenderPassSample = vkd.?.createRenderPass(&renderPassInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createRenderPass vkRenderPassSample", e);

    renderPassInfo.p_attachments = &[_]vk.AttachmentDescription{ colorAttachment, depthAttachment };
    renderPassInfo.attachment_count = 2;
    renderPassInfo.p_subpasses = @ptrCast(&subpass);

    vkRenderPass = vkd.?.createRenderPass(&renderPassInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createRenderPass vkRenderPass", e);

    renderPassInfo.p_attachments = &[_]vk.AttachmentDescription{ colorAttachmentSampleClear, depthAttachmentSampleClear, colorAttachmentResolve };
    renderPassInfo.attachment_count = 3;
    renderPassInfo.p_dependencies = null;
    renderPassInfo.dependency_count = 0;
    renderPassInfo.p_subpasses = @ptrCast(&subpass_resolve);

    vkRenderPassSampleClear = vkd.?.createRenderPass(&renderPassInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createRenderPass vkRenderPassSampleClear", e);

    renderPassInfo.p_attachments = &[_]vk.AttachmentDescription{ colorAttachmentClear, depthAttachmentClear };
    renderPassInfo.attachment_count = 2;
    renderPassInfo.p_subpasses = @ptrCast(&subpass);

    vkRenderPassClear = vkd.?.createRenderPass(&renderPassInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createRenderPass vkRenderPassClear", e);

    const dependency_copy: vk.SubpassDependency = .{
        .src_subpass = vk.SUBPASS_EXTERNAL,
        .dst_subpass = 0,
        .src_stage_mask = .{ .color_attachment_output_bit = true },
        .src_access_mask = .{},
        .dst_stage_mask = .{ .color_attachment_output_bit = true },
        .dst_access_mask = .{ .color_attachment_write_bit = true },
    };

    renderPassInfo.p_attachments = &[_]vk.AttachmentDescription{ colorAttachment, colorAttachmentLoadResolve };
    renderPassInfo.attachment_count = 2;
    renderPassInfo.p_dependencies = @ptrCast(&dependency_copy);
    renderPassInfo.dependency_count = 1;
    renderPassInfo.p_subpasses = @ptrCast(&subpass_copy);

    vkRenderPassCopy = vkd.?.createRenderPass(&renderPassInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createRenderPass vkRenderPassCopy", e);

    //create_shader_stages
    shape_curve_vert_shader = createShaderModule(&shape_curve_vert);
    shape_curve_frag_shader = createShaderModule(&shape_curve_frag);
    quad_shape_vert_shader = createShaderModule(&quad_shape_vert);
    quad_shape_frag_shader = createShaderModule(&quad_shape_frag);
    tex_vert_shader = createShaderModule(&tex_vert);
    tex_frag_shader = createShaderModule(&tex_frag);
    animate_tex_vert_shader = createShaderModule(&animate_tex_vert);
    animate_tex_frag_shader = createShaderModule(&animate_tex_frag);
    copy_screen_frag_shader = createShaderModule(&copy_screen_frag);

    shape_curve_shader_stages = create_shader_state(shape_curve_vert_shader, shape_curve_frag_shader);
    quad_shape_shader_stages = create_shader_state(quad_shape_vert_shader, quad_shape_frag_shader);
    tex_shader_stages = create_shader_state(tex_vert_shader, tex_frag_shader);
    animate_tex_shader_stages = create_shader_state(animate_tex_vert_shader, animate_tex_frag_shader);
    copy_screen_shader_stages = create_shader_state(quad_shape_vert_shader, copy_screen_frag_shader);

    //quad_shape_2d_pipeline
    {
        const uboLayoutBinding = [1]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .fragment_bit = true },
                .p_immutable_samplers = null,
            },
        };
        const set_layout_info: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding.len,
            .p_bindings = &uboLayoutBinding,
        };
        quad_shape_2d_pipeline_set.descriptorSetLayout = vkd.?.createDescriptorSetLayout(&set_layout_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout quad_shape_2d_pipeline_set.descriptorSetLayout", e);

        const pipelineLayoutInfo: vk.PipelineLayoutCreateInfo = .{
            .set_layout_count = 1,
            .p_set_layouts = @ptrCast(&quad_shape_2d_pipeline_set.descriptorSetLayout),
            .push_constant_range_count = 0,
            .p_push_constant_ranges = null,
        };

        quad_shape_2d_pipeline_set.pipelineLayout = vkd.?.createPipelineLayout(&pipelineLayoutInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createPipelineLayout quad_shape_2d_pipeline_set.pipelineLayout", e);
    }
    //create_shape_color_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 1,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 2,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
        };
        const set_layout_info: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding.len,
            .p_bindings = &uboLayoutBinding,
        };
        shape_color_2d_pipeline_set.descriptorSetLayout = vkd.?.createDescriptorSetLayout(&set_layout_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout shape_color_2d_pipeline_set.descriptorSetLayout", e);

        const pipelineLayoutInfo: vk.PipelineLayoutCreateInfo = .{
            .set_layout_count = 1,
            .p_set_layouts = @ptrCast(&shape_color_2d_pipeline_set.descriptorSetLayout),
            .push_constant_range_count = 0,
            .p_push_constant_ranges = null,
        };

        shape_color_2d_pipeline_set.pipelineLayout = vkd.?.createPipelineLayout(&pipelineLayoutInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createPipelineLayout shape_color_2d_pipeline_set.pipelineLayout", e);
    }
    //create_tex_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 1,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 2,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 3,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .fragment_bit = true },
            },
        };
        const set_layout_info: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding.len,
            .p_bindings = &uboLayoutBinding,
        };
        tex_2d_pipeline_set.descriptorSetLayout = vkd.?.createDescriptorSetLayout(&set_layout_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout tex_2d_pipeline_set.descriptorSetLayout", e);

        const uboLayoutBinding2 = [_]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .combined_image_sampler,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
                .p_immutable_samplers = null,
            },
        };
        const set_layout_info2: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding2.len,
            .p_bindings = &uboLayoutBinding2,
        };
        tex_2d_pipeline_set.descriptorSetLayout2 = vkd.?.createDescriptorSetLayout(&set_layout_info2, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout tex_2d_pipeline_set.descriptorSetLayout2", e);

        const pipelineLayoutInfo: vk.PipelineLayoutCreateInfo = .{
            .set_layout_count = 2,
            .p_set_layouts = &[_]vk.DescriptorSetLayout{ tex_2d_pipeline_set.descriptorSetLayout, tex_2d_pipeline_set.descriptorSetLayout2 },
            .push_constant_range_count = 0,
            .p_push_constant_ranges = null,
        };

        tex_2d_pipeline_set.pipelineLayout = vkd.?.createPipelineLayout(&pipelineLayoutInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createPipelineLayout tex_2d_pipeline_set.pipelineLayout", e);
    }
    //create_animate_tex_2d_pipeline
    {
        const uboLayoutBinding = [_]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 1,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 2,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .vertex_bit = true, .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 3,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .fragment_bit = true },
            },
            vk.DescriptorSetLayoutBinding{
                .binding = 4,
                .descriptor_count = 1,
                .descriptor_type = .uniform_buffer,
                .stage_flags = .{ .fragment_bit = true },
            },
        };

        const set_layout_info: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding.len,
            .p_bindings = &uboLayoutBinding,
        };
        animate_tex_2d_pipeline_set.descriptorSetLayout = vkd.?.createDescriptorSetLayout(&set_layout_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout animate_tex_2d_pipeline_set.descriptorSetLayout", e);

        const pipelineLayoutInfo: vk.PipelineLayoutCreateInfo = .{
            .set_layout_count = 2,
            .p_set_layouts = &[_]vk.DescriptorSetLayout{ animate_tex_2d_pipeline_set.descriptorSetLayout, tex_2d_pipeline_set.descriptorSetLayout2 },
            .push_constant_range_count = 0,
            .p_push_constant_ranges = null,
        };

        animate_tex_2d_pipeline_set.pipelineLayout = vkd.?.createPipelineLayout(&pipelineLayoutInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createPipelineLayout animate_tex_2d_pipeline_set.pipelineLayout", e);
    }
    //create_screen_copy
    {
        const uboLayoutBinding2 = [_]vk.DescriptorSetLayoutBinding{
            vk.DescriptorSetLayoutBinding{
                .binding = 0,
                .descriptor_count = 1,
                .descriptor_type = .input_attachment,
                .stage_flags = .{ .fragment_bit = true },
                .p_immutable_samplers = null,
            },
        };
        const set_layout_info2: vk.DescriptorSetLayoutCreateInfo = .{
            .binding_count = uboLayoutBinding2.len,
            .p_bindings = &uboLayoutBinding2,
        };
        copy_screen_pipeline_set.descriptorSetLayout = vkd.?.createDescriptorSetLayout(&set_layout_info2, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout copy_screen_pipeline_set.descriptorSetLayout", e);

        const pipelineLayoutInfo: vk.PipelineLayoutCreateInfo = .{
            .set_layout_count = 1,
            .p_set_layouts = @ptrCast(&copy_screen_pipeline_set.descriptorSetLayout),
            .push_constant_range_count = 0,
            .p_push_constant_ranges = null,
        };

        copy_screen_pipeline_set.pipelineLayout = vkd.?.createPipelineLayout(&pipelineLayoutInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorSetLayout copy_screen_pipeline_set.pipelineLayout", e);

        const pool_size = [1]vk.DescriptorPoolSize{.{
            .descriptor_count = 1,
            .type = .input_attachment,
        }};
        const pool_info: vk.DescriptorPoolCreateInfo = .{
            .pool_size_count = pool_size.len,
            .p_pool_sizes = @ptrCast(&pool_size),
            .max_sets = 1,
        };
        copy_image_pool = vkd.?.createDescriptorPool(&pool_info, null) catch |e| xfit.herr3("__vulkan.vulkan_start createDescriptorPool copy_image_pool", e);

        const alloc_info: vk.DescriptorSetAllocateInfo = .{
            .descriptor_pool = copy_image_pool,
            .descriptor_set_count = 1,
            .p_set_layouts = @ptrCast(&copy_screen_pipeline_set.descriptorSetLayout),
        };
        vkd.?.allocateDescriptorSets(&alloc_info, @ptrCast(&copy_image_set)) catch |e| xfit.herr3("__vulkan.vulkan_start allocateDescriptorSets copy_image_set", e);
    }
    create_pipelines();

    create_framebuffer();

    create_sync_object();

    const poolInfo: vk.CommandPoolCreateInfo = .{
        .flags = .{ .reset_command_buffer_bit = true },
        .queue_family_index = graphicsFamilyIndex,
    };

    vkCommandPool = vkd.?.createCommandPool(&poolInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createCommandPool vkCommandPool", e);
    const allocInfo: vk.CommandBufferAllocateInfo = .{
        .command_pool = vkCommandPool,
        .level = .primary,
        .command_buffer_count = render_command.MAX_FRAME,
    };

    vkd.?.allocateCommandBuffers(&allocInfo, @ptrCast(&vkCommandBuffer)) catch |e| xfit.herr3("__vulkan.vulkan_start allocateCommandBuffers vkCommandBuffer", e);

    __render_command.start();

    set_fullscreen_ex();

    shape_list = ArrayList(*graphics.iobject).init(__system.allocator);

    //graphics create
    no_color_tran = graphics.color_transform.init();
    no_color_tran.build(.gpu);
    //
}

pub fn vulkan_destroy() void {
    //graphics destroy
    no_color_tran.deinit();

    cleanup_swapchain();

    __vulkan_allocator.deinit();

    vkd.?.destroySampler(linear_sampler, null);
    vkd.?.destroySampler(nearest_sampler, null);
    //

    vkd.?.destroyCommandPool(vkCommandPool, null);

    vkd.?.destroyShaderModule(quad_shape_vert_shader, null);
    vkd.?.destroyShaderModule(quad_shape_frag_shader, null);
    vkd.?.destroyShaderModule(shape_curve_vert_shader, null);
    vkd.?.destroyShaderModule(shape_curve_frag_shader, null);
    vkd.?.destroyShaderModule(tex_vert_shader, null);
    vkd.?.destroyShaderModule(tex_frag_shader, null);
    vkd.?.destroyShaderModule(animate_tex_vert_shader, null);
    vkd.?.destroyShaderModule(animate_tex_frag_shader, null);
    vkd.?.destroyShaderModule(copy_screen_frag_shader, null);

    vkd.?.destroyPipelineLayout(quad_shape_2d_pipeline_set.pipelineLayout, null);
    vkd.?.destroyDescriptorSetLayout(quad_shape_2d_pipeline_set.descriptorSetLayout, null);

    vkd.?.destroyPipelineLayout(shape_color_2d_pipeline_set.pipelineLayout, null);
    vkd.?.destroyDescriptorSetLayout(shape_color_2d_pipeline_set.descriptorSetLayout, null);

    vkd.?.destroyPipelineLayout(tex_2d_pipeline_set.pipelineLayout, null);
    vkd.?.destroyDescriptorSetLayout(tex_2d_pipeline_set.descriptorSetLayout, null);
    vkd.?.destroyDescriptorSetLayout(tex_2d_pipeline_set.descriptorSetLayout2, null);

    vkd.?.destroyPipelineLayout(animate_tex_2d_pipeline_set.pipelineLayout, null);
    vkd.?.destroyDescriptorSetLayout(animate_tex_2d_pipeline_set.descriptorSetLayout, null);

    vkd.?.destroyPipelineLayout(copy_screen_pipeline_set.pipelineLayout, null);
    vkd.?.destroyDescriptorSetLayout(copy_screen_pipeline_set.descriptorSetLayout, null);

    cleanup_pipelines();

    vkd.?.destroyRenderPass(vkRenderPass, null);
    vkd.?.destroyRenderPass(vkRenderPassSampleClear, null);
    vkd.?.destroyRenderPass(vkRenderPassClear, null);
    vkd.?.destroyRenderPass(vkRenderPassCopy, null);
    vkd.?.destroyRenderPass(vkRenderPassSample, null);

    vkd.?.destroyDescriptorPool(copy_image_pool, null);

    vki.?.destroySurfaceKHR(vkSurface, null);

    cleanup_sync_object();

    vkd.?.destroyDevice(null);

    if (vkDebugMessenger != .null_handle and xfit.dbg) {
        vki.?.destroyDebugUtilsMessengerEXT(vkDebugMessenger, null);
    }
    vki.?.destroyInstance(null);

    shape_list.deinit();

    __render_command.destroy();

    if (xfit.platform == .windows) {
        _ = __windows.win32.FreeLibrary(vulkanF);
    } else {
        _ = std.c.dlclose(vulkanF.?);
    }
}

fn recreateSurface() void {
    if (xfit.platform == .windows) {
        __windows.vulkan_windows_start(&vkSurface);
    } else if (xfit.platform == .android) {
        //__android.vulkan_android_start(&vkSurface);
    } else if (xfit.platform == .linux) {
        // TODO recreateSurface linux
    } else {
        @compileError("not support platform");
    }
}

fn cleanup_swapchain() void {
    if (vkSwapchain != .null_handle) {
        var i: usize = 0;
        while (i < vk_swapchain_frame_buffers.len) : (i += 1) {
            vk_swapchain_frame_buffers[i].deinit();
        }

        depth_stencil_image_sample.clean(null, undefined);
        color_image_sample.clean(null, undefined);
        depth_stencil_image.clean(null, undefined);
        color_image.clean(null, undefined);

        __vulkan_allocator.op_execute(true);

        std.heap.c_allocator.free(vk_swapchain_frame_buffers);
        i = 0;
        while (i < vk_swapchain_images.len) : (i += 1) {
            vkd.?.destroyImageView(vk_swapchain_images[i].__image_view, null);
        }
        std.heap.c_allocator.free(vk_swapchain_images);
        vkd.?.destroySwapchainKHR(vkSwapchain, null);
        vkSwapchain = .null_handle;

        std.heap.c_allocator.free(formats);
    }
}

fn create_framebuffer() void {
    vk_swapchain_frame_buffers = std.heap.c_allocator.alloc(FRAME_BUF, vk_swapchain_images.len) catch
        xfit.herrm("__vulkan.create_framebuffer.allocator.alloc(__vulkan_allocator.frame_buffer)");

    depth_stencil_image_sample.create_texture(.{
        .width = vkExtent_rotation.width,
        .height = vkExtent_rotation.height,
        .format = depth_format,
        .samples = 4,
        .tex_use = .{
            .image_resource = false,
            .frame_buffer = true,
        },
        .single = true,
    }, .null_handle, null);
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
    }, .null_handle, null);
    depth_stencil_image.create_texture(.{
        .width = vkExtent_rotation.width,
        .height = vkExtent_rotation.height,
        .format = depth_format,
        .tex_use = .{
            .image_resource = false,
            .frame_buffer = true,
        },
        .single = true,
    }, .null_handle, null);
    color_image.create_texture(.{
        .width = vkExtent_rotation.width,
        .height = vkExtent_rotation.height,
        .format = .default,
        .tex_use = .{
            .image_resource = false,
            .frame_buffer = true,
            .__input_attachment = true,
        },
        .single = true,
    }, .null_handle, null);

    refresh_pre_matrix();

    __vulkan_allocator.op_execute(true);
    var i: usize = 0;
    while (i < vk_swapchain_images.len) : (i += 1) {
        vk_swapchain_frame_buffers[i] = .{};
        var texs = [_]*__vulkan_allocator.vulkan_res_node(.texture){
            &color_image_sample,
            &depth_stencil_image_sample,
            &color_image,
        };
        vk_swapchain_frame_buffers[i].sample.create_no_async(texs[0..3], vkRenderPassSample);
        vk_swapchain_frame_buffers[i].sample_clear.create_no_async(texs[0..3], vkRenderPassSampleClear);

        var texs2 = [_]*__vulkan_allocator.vulkan_res_node(.texture){
            &vk_swapchain_images[i],
            &depth_stencil_image,
        };

        vk_swapchain_frame_buffers[i].normal.create_no_async(texs2[0..2], vkRenderPass);
        vk_swapchain_frame_buffers[i].clear.create_no_async(texs2[0..2], vkRenderPassClear);

        var texs3 = [_]*__vulkan_allocator.vulkan_res_node(.texture){
            &vk_swapchain_images[i],
            &color_image,
        };

        vk_swapchain_frame_buffers[i].copy.create_no_async(texs3[0..2], vkRenderPassCopy);
    }
    const imageInfo: vk.DescriptorImageInfo = .{
        .image_layout = .shader_read_only_optimal,
        .image_view = color_image.__image_view,
        .sampler = .null_handle,
    };
    const descriptorWrite = [_]vk.WriteDescriptorSet{
        .{
            .dst_set = copy_image_set,
            .dst_binding = 0,
            .dst_array_element = 0,
            .descriptor_count = 1,
            .descriptor_type = .input_attachment,
            .p_buffer_info = null,
            .p_image_info = @ptrCast(&imageInfo),
            .p_texel_buffer_view = null,
        },
    };
    vkd.?.updateDescriptorSets(descriptorWrite.len, &descriptorWrite, 0, null);
}

pub var rotate_mat: matrix = math.matrix_identity(f32);

pub fn refresh_pre_matrix() void {
    if (xfit.is_mobile) {
        const orientation = window.get_screen_orientation();
        rotate_mat = switch (orientation) {
            .unknown => math.matrix_identity(f32),
            .landscape90 => math.matrix_rotation2D(f32, std.math.degreesToRadians(90.0)),
            .landscape270 => math.matrix_rotation2D(f32, std.math.degreesToRadians(270.0)),
            .vertical180 => math.matrix_rotation2D(f32, std.math.degreesToRadians(180.0)),
            .vertical360 => math.matrix_identity(f32),
        };
    }
}

fn create_swapchain_and_imageviews(comptime program_start: bool) void {
    var formatCount: u32 = 0;
    _ = vki.?.getPhysicalDeviceSurfaceFormatsKHR(vk_physical_device, vkSurface, &formatCount, null) catch unreachable;
    xfit.herrm2(formatCount != 0, "__vulkan.create_swapchain_and_imageviews.formatCount 0");

    formats = std.heap.c_allocator.alloc(vk.SurfaceFormatKHR, formatCount) catch
        xfit.herrm("create_swapchain_and_imageviews.allocator.alloc(vk.SurfaceFormatKHR) OutOfMemory");

    _ = vki.?.getPhysicalDeviceSurfaceFormatsKHR(vk_physical_device, vkSurface, &formatCount, formats.ptr) catch unreachable;
    xfit.herrm2(formatCount != 0, "__vulkan.create_swapchain_and_imageviews.formatCount 0(2)");

    var presentModeCount: u32 = 0;
    _ = vki.?.getPhysicalDeviceSurfacePresentModesKHR(vk_physical_device, vkSurface, &presentModeCount, null) catch unreachable;
    xfit.herrm2(presentModeCount != 0, "__vulkan.create_swapchain_and_imageviews.vkGetPhysicalDeviceSurfacePresentModesKHR presentModeCount 0");

    const presentModes = std.heap.c_allocator.alloc(vk.PresentModeKHR, presentModeCount) catch {
        xfit.herrm("create_swapchain_and_imageviews.allocator.alloc(vk.PresentModeKHR) OutOfMemory");
    };
    defer std.heap.c_allocator.free(presentModes);

    _ = vki.?.getPhysicalDeviceSurfacePresentModesKHR(vk_physical_device, vkSurface, &presentModeCount, presentModes.ptr) catch unreachable;

    surfaceCap = vki.?.getPhysicalDeviceSurfaceCapabilitiesKHR(vk_physical_device, vkSurface) catch unreachable;

    vkExtent = chooseSwapExtent(surfaceCap);
    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        std.heap.c_allocator.free(formats);
        return;
    }

    if (xfit.is_mobile) {
        if (surfaceCap.current_transform.contains(.{ .rotate_90_bit_khr = true })) {
            vkExtent_rotation.width = vkExtent.height;
            vkExtent_rotation.height = vkExtent.width;
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .landscape90, std.builtin.AtomicOrder.monotonic);
        } else if (surfaceCap.current_transform.contains(.{ .rotate_270_bit_khr = true })) {
            vkExtent_rotation.width = vkExtent.height;
            vkExtent_rotation.height = vkExtent.width;
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .landscape270, std.builtin.AtomicOrder.monotonic);
        } else if (surfaceCap.current_transform.contains(.{ .rotate_180_bit_khr = true })) {
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .vertical180, std.builtin.AtomicOrder.monotonic);
            vkExtent_rotation = vkExtent;
        } else {
            @atomicStore(@TypeOf(__system.__screen_orientation), &__system.__screen_orientation, .vertical360, std.builtin.AtomicOrder.monotonic);
            vkExtent_rotation = vkExtent;
        }
    } else {
        vkExtent_rotation = vkExtent;
    }
    if (xfit.is_mobile) { //if mobile
        @atomicStore(u32, &__system.init_set.window_width, @intCast(vkExtent.width), std.builtin.AtomicOrder.monotonic);
        @atomicStore(u32, &__system.init_set.window_height, @intCast(vkExtent.height), std.builtin.AtomicOrder.monotonic);
    }
    // pub var depth_optimal = false;
    // pub var depth_transfer_src_optimal = false;
    // pub var depth_transfer_dst_optimal = false;
    // pub var depth_sample_optimal = false;
    // pub var color_attach_optimal = false;
    // pub var color_sample_optimal = false;
    // pub var color_transfer_src_optimal = false;
    // pub var color_transfer_dst_optimal = false;

    format = chooseSwapSurfaceFormat(formats, program_start);
    presentMode = chooseSwapPresentMode(presentModes, __system.init_set.vSync, program_start);

    var depth_prop = vki.?.getPhysicalDeviceFormatProperties(vk_physical_device, .d24_unorm_s8_uint);
    depth_optimal = depth_prop.optimal_tiling_features.contains(.{ .depth_stencil_attachment_bit = true });
    if (!depth_optimal and !depth_prop.linear_tiling_features.contains(.{ .depth_stencil_attachment_bit = true })) {
        depth_prop = vki.?.getPhysicalDeviceFormatProperties(vk_physical_device, .d32_sfloat_s8_uint);
        depth_optimal = depth_prop.optimal_tiling_features.contains(.{ .depth_stencil_attachment_bit = true });
        if (!depth_optimal and !depth_prop.linear_tiling_features.contains(.{ .depth_stencil_attachment_bit = true })) {
            depth_prop = vki.?.getPhysicalDeviceFormatProperties(vk_physical_device, .d16_unorm_s8_uint);
            depth_optimal = depth_prop.optimal_tiling_features.contains(.{ .depth_stencil_attachment_bit = true });
            depth_transfer_src_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_src_bit = true });
            depth_transfer_dst_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_dst_bit = true });
            depth_sample_optimal = depth_prop.optimal_tiling_features.contains(.{ .sampled_image_bit = true });
            depth_format = .d16_unorm_s8_uint;
        } else {
            depth_transfer_src_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_src_bit = true });
            depth_transfer_dst_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_dst_bit = true });
            depth_sample_optimal = depth_prop.optimal_tiling_features.contains(.{ .sampled_image_bit = true });
            depth_format = .d32_sfloat_s8_uint;
        }
    } else {
        depth_transfer_src_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_src_bit = true });
        depth_transfer_dst_optimal = depth_prop.optimal_tiling_features.contains(.{ .transfer_dst_bit = true });
        depth_sample_optimal = depth_prop.optimal_tiling_features.contains(.{ .sampled_image_bit = true });
    }

    const color_prop = vki.?.getPhysicalDeviceFormatProperties(vk_physical_device, format.format);
    color_attach_optimal = color_prop.optimal_tiling_features.contains(.{ .color_attachment_bit = true });
    color_sample_optimal = color_prop.optimal_tiling_features.contains(.{ .sampled_image_bit = true });
    color_transfer_src_optimal = color_prop.optimal_tiling_features.contains(.{ .transfer_src_bit = true });
    color_transfer_dst_optimal = color_prop.optimal_tiling_features.contains(.{ .transfer_dst_bit = true });

    if (program_start) {
        xfit.print_log("XFIT SYSLOG : depth format : {}\n", .{depth_format});
        xfit.print_log("XFIT SYSLOG : optimal format supports : \n depth_optimal:{}, depth_transfer_src_optimal:{}, depth_transfer_dst_optimal:{}, depth_sample_optimal:{}\ncolor_attach_optimal:{}, color_sample_optimal:{}, color_transfer_src_optimal:{}, color_transfer_dst_optimal:{}\n", .{
            depth_optimal,
            depth_transfer_src_optimal,
            depth_transfer_dst_optimal,
            depth_sample_optimal,
            color_attach_optimal,
            color_sample_optimal,
            color_transfer_src_optimal,
            color_transfer_dst_optimal,
        });
    }

    var imageCount = surfaceCap.min_image_count + 1;
    if (surfaceCap.max_image_count > 0 and imageCount > surfaceCap.max_image_count) {
        imageCount = surfaceCap.max_image_count;
    }

    var fullS: vk.SurfaceFullScreenExclusiveInfoEXT = .{
        .full_screen_exclusive = .application_controlled_ext,
    };

    var fullWin: vk.SurfaceFullScreenExclusiveWin32InfoEXT = undefined;
    if (xfit.platform == .windows and system.current_monitor() != null) {
        fullWin = .{
            .hmonitor = @ptrCast(system.current_monitor().?.*.__hmonitor.?),
        };
        fullS.p_next = @ptrCast(&fullWin);
    }

    var swapChainCreateInfo: vk.SwapchainCreateInfoKHR = .{
        .surface = vkSurface,
        .min_image_count = imageCount,
        .image_format = format.format,
        .image_color_space = format.color_space,
        .image_extent = vkExtent_rotation,
        .image_array_layers = 1,
        .image_usage = .{ .color_attachment_bit = true },
        .present_mode = presentMode,
        .pre_transform = surfaceCap.current_transform,
        .composite_alpha = surfaceCap.supported_composite_alpha,
        .clipped = 1,
        .old_swapchain = .null_handle,
        .image_sharing_mode = .exclusive,
        .p_next = if (VK_EXT_full_screen_exclusive_support and is_fullscreen_ex) @ptrCast(&fullS) else null,
    };

    const queueFamiliesIndices = [_]u32{ graphicsFamilyIndex, presentFamilyIndex };

    if (graphicsFamilyIndex != presentFamilyIndex) {
        swapChainCreateInfo.image_sharing_mode = .concurrent;
        swapChainCreateInfo.queue_family_index_count = 2;
        swapChainCreateInfo.p_queue_family_indices = &queueFamiliesIndices;
    }

    vkSwapchain = vkd.?.createSwapchainKHR(&swapChainCreateInfo, null) catch |e|
        xfit.herr3("__vulkan.create_swapchain_and_imageviewsCreateSwapchainKHR : {d}", e);

    var swapchain_image_count: u32 = 0;

    _ = vkd.?.getSwapchainImagesKHR(vkSwapchain, &swapchain_image_count, null) catch unreachable;

    const swapchain_images = std.heap.c_allocator.alloc(vk.Image, swapchain_image_count) catch
        xfit.herrm("__vulkan.create_swapchain_and_imageviews.allocator.alloc(vk.Image) OutOfMemory");
    defer std.heap.c_allocator.free(swapchain_images);

    _ = vkd.?.getSwapchainImagesKHR(vkSwapchain, &swapchain_image_count, swapchain_images.ptr) catch unreachable;

    vk_swapchain_images = std.heap.c_allocator.alloc(__vulkan_allocator.vulkan_res_node(.texture), swapchain_image_count) catch |e| xfit.herr3("vulkan_start.vk_swapchain_images alloc", e);

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
        const image_view_createInfo: vk.ImageViewCreateInfo = .{
            .image = swapchain_images[i],
            .view_type = .@"2d",
            .format = format.format,
            .components = .{
                .r = vk.ComponentSwizzle.identity,
                .g = vk.ComponentSwizzle.identity,
                .b = vk.ComponentSwizzle.identity,
                .a = vk.ComponentSwizzle.identity,
            },
            .subresource_range = .{
                .aspect_mask = .{ .color_bit = true },
                .base_mip_level = 0,
                .level_count = 1,
                .base_array_layer = 0,
                .layer_count = 1,
            },
        };
        vk_swapchain_images[i].__image_view = vkd.?.createImageView(&image_view_createInfo, null) catch |e|
            xfit.herr2("__vulkan.create_swapchain_and_imageviews.CreateImageView({d}) : {}", .{ i, e });
    }
}

pub fn set_fullscreen_ex() void {
    if (VK_EXT_full_screen_exclusive_support and is_fullscreen_ex) {
        if (xfit.platform == .windows) {
            __windows.__change_fullscreen_mode();
        }
        vkd.?.acquireFullScreenExclusiveModeEXT(vkSwapchain) catch {
            VK_EXT_full_screen_exclusive_support = false;
            return;
        };
        released_fullscreen_ex = false;
    }
}

///rect Y is smaller, higher
// pub fn copy_buffer_to_image2(src_buf: vk.Buffer, dst_img: vk.Image, rect: math.recti, depth: c_uint) void {
//     if (rect.left >= rect.right or rect.top >= rect.bottom) xfit.herrm("copy_buffer_to_image2 invaild rect");
//     const buf = begin_single_time_commands();

//     const region: vk.BufferImageCopy = .{
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
//     vkCmdCopyBufferToImage(buf, src_buf, dst_img, vk.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region);

//     end_single_time_commands(buf);
// }

pub fn get_swapchain_image_length() usize {
    return vk_swapchain_images.len;
}

pub var released_fullscreen_ex: bool = true;
pub var fullscreen_mutex: std.Thread.Mutex = .{};

pub fn recreate_swapchain() void {
    if (vkDevice == .null_handle) return;
    first_draw = true;
    fullscreen_mutex.lock();

    if (!released_fullscreen_ex and VK_EXT_full_screen_exclusive_support) {
        vkd.?.releaseFullScreenExclusiveModeEXT(vkSwapchain) catch {
            VK_EXT_full_screen_exclusive_support = false;
        };
        released_fullscreen_ex = true;
    }

    wait_device_idle();

    if (xfit.platform == .android) {
        __android.vulkan_android_start(&vkSurface);
    } else if (xfit.platform == .windows) {
        //__windows.vulkan_windows_start(&vkSurface);
    }

    cleanup_sync_object();
    cleanup_swapchain();
    create_swapchain_and_imageviews(false);
    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        fullscreen_mutex.unlock();
        return;
    }
    create_framebuffer();
    create_sync_object();

    set_fullscreen_ex();

    __system.size_update.store(false, .release);

    fullscreen_mutex.unlock();

    __render_command.__refresh_all();

    if (!xfit.__xfit_test) {
        root.xfit_size() catch |e| {
            xfit.herr3("xfit_size", e);
        };
    }
}

var first_draw: bool = true;

pub fn drawFrame() void {
    var imageIndex: u32 = 0;
    const state = struct {
        var frame: usize = 0;
        var wait_th: ?std.Thread = null;
        var fence_wait_mutex: std.Thread.Mutex = .{};
        pub fn wait_and_op_destory(wait_idx: usize) void {
            load_instance_and_device();
            fence_wait_mutex.lock();
            const waitForFences_result = vkd.?.waitForFences(1, @ptrCast(&vkInFlightFence[wait_idx]), vk.TRUE, std.math.maxInt(u64)) catch |e| {
                xfit.herr3("__vulkan.wait_for_fences.vkWaitForFences", e);
            };
            xfit.herr(waitForFences_result == .success, "__vulkan.wait_for_fences.vkWaitForFences : {}", .{waitForFences_result});
            fence_wait_mutex.unlock();
            __vulkan_allocator.op_execute_destroy();
        }
    };
    __vulkan_allocator.op_execute(false);

    if (vkExtent.width <= 0 or vkExtent.height <= 0) {
        recreate_swapchain();
        return;
    } else if (__system.size_update.load(.acquire)) {
        recreate_swapchain();
    }

    if (xfit.render_cmd != null) {
        if (first_draw) {
            first_draw = false;
        } else {
            state.fence_wait_mutex.lock();
            const waitForFences_result = vkd.?.waitForFences(1, @ptrCast(&vkInFlightFence[state.frame]), vk.TRUE, std.math.maxInt(u64)) catch |e| {
                xfit.herr3("__vulkan.wait_for_fences.vkWaitForFences", e);
            };
            xfit.herr(waitForFences_result == .success, "__vulkan.wait_for_fences.vkWaitForFences : {}", .{waitForFences_result});
            state.fence_wait_mutex.unlock();
        }

        const acquireNextImageKHR_result = vkd.?.acquireNextImageKHR(vkSwapchain, std.math.maxInt(u64), vkImageAvailableSemaphore[state.frame], .null_handle) catch |e| {
            if (e == error.OutOfDateKHR) {
                recreate_swapchain();
                return;
            } else if (e == error.SurfaceLostKHR) {
                recreateSurface();
                recreate_swapchain();
                return;
            } else {
                xfit.herr3("__vulkan.drawFrame.acquireNextImageKHR", e);
            }
        };
        if (acquireNextImageKHR_result.result == .error_out_of_date_khr or acquireNextImageKHR_result.result == .suboptimal_khr) {
            recreate_swapchain();
            return;
        } else if (acquireNextImageKHR_result.result == .error_surface_lost_khr) {
            recreateSurface();
            recreate_swapchain();
            return;
        } else if (acquireNextImageKHR_result.result != .success) {
            xfit.herr2("__vulkan.drawFrame.acquireNextImageKHR : {}", .{acquireNextImageKHR_result.result});
        }
        imageIndex = acquireNextImageKHR_result.image_index;

        const cmds = __system.allocator.alloc(vk.CommandBuffer, xfit.render_cmd.?.len + 1) catch xfit.herrm("drawframe cmds alloc");

        cmds[0] = vkCommandBuffer[state.frame];
        var cmdidx: usize = 1;

        defer __system.allocator.free(cmds);

        const waitStages: vk.PipelineStageFlags = .{ .color_attachment_output_bit = true };

        const cls_color0 = @atomicLoad(f32, &clear_color._0, .monotonic);
        const cls_color1 = @atomicLoad(f32, &clear_color._1, .monotonic);
        const cls_color2 = @atomicLoad(f32, &clear_color._2, .monotonic);
        const cls_color3 = @atomicLoad(f32, &clear_color._3, .monotonic);
        const clearColor: vk.ClearValue = .{ .color = .{ .float_32 = .{ cls_color0, cls_color1, cls_color2, cls_color3 } } };

        const clearDepthStencil: vk.ClearValue = .{ .depth_stencil = .{ .stencil = 0, .depth = 1 } };
        var renderPassInfo: vk.RenderPassBeginInfo = .{
            .render_pass = vkRenderPassClear,
            .framebuffer = vk_swapchain_frame_buffers[imageIndex].clear.res,
            .render_area = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
            .clear_value_count = 2,
            .p_clear_values = &[_]vk.ClearValue{ clearColor, clearDepthStencil },
        };
        const beginInfo: vk.CommandBufferBeginInfo = .{
            .flags = .{ .one_time_submit_bit = true },
            .p_inheritance_info = null,
        };
        vkd.?.beginCommandBuffer(vkCommandBuffer[state.frame], &beginInfo) catch |e| xfit.herr3("__vulkan.drawFrame.beginCommandBuffer", e);
        vkd.?.cmdBeginRenderPass(vkCommandBuffer[state.frame], &renderPassInfo, .@"inline");
        vkd.?.cmdEndRenderPass(vkCommandBuffer[state.frame]);
        vkd.?.endCommandBuffer(vkCommandBuffer[state.frame]) catch |e| xfit.herr3("__vulkan.drawFrame.endCommandBuffer", e);

        render_command.mutex.lock();
        for (xfit.render_cmd.?) |*cmd| {
            if (@cmpxchgStrong(bool, &cmd.*.*.__refesh[state.frame], true, false, .monotonic, .monotonic) == null) {
                recordCommandBuffer(cmd, @intCast(state.frame));
            }
            if (cmd.*.*.scene != null and cmd.*.*.scene.?.len > 0) {
                cmds[cmdidx] = cmd.*.*.__command_buffers[state.frame][imageIndex];
                cmdidx += 1;
            }
        }
        render_command.mutex.unlock();

        var submitInfo: vk.SubmitInfo = .{
            .wait_semaphore_count = 1,
            .command_buffer_count = @intCast(cmdidx),
            .signal_semaphore_count = 1,
            .p_wait_semaphores = @ptrCast(&vkImageAvailableSemaphore[state.frame]),
            .p_wait_dst_stage_mask = @ptrCast(&waitStages),
            .p_command_buffers = cmds.ptr,
            .p_signal_semaphores = @ptrCast(&vkRenderFinishedSemaphore[state.frame]),
        };

        state.fence_wait_mutex.lock();
        vkd.?.resetFences(1, @ptrCast(&vkInFlightFence[state.frame])) catch |e| xfit.herr3("__vulkan.drawFrame.resetFences", e);

        vkd.?.queueSubmit(vkGraphicsQueue, 1, @ptrCast(&submitInfo), vkInFlightFence[state.frame]) catch |e| xfit.herr3("__vulkan.drawFrame.queueSubmit", e);
        state.fence_wait_mutex.unlock();

        __vulkan_allocator.wait_fence();
        if (state.wait_th != null) state.wait_th.?.join();
        state.wait_th = std.Thread.spawn(.{}, state.wait_and_op_destory, .{state.frame}) catch unreachable;

        const swapChains = [_]vk.SwapchainKHR{vkSwapchain};

        const presentInfo: vk.PresentInfoKHR = .{
            .wait_semaphore_count = 1,
            .swapchain_count = 1,
            .p_wait_semaphores = @ptrCast(&vkRenderFinishedSemaphore[state.frame]),
            .p_swapchains = @ptrCast(&swapChains),
            .p_image_indices = @ptrCast(&imageIndex),
        };
        const queuePresentKHR_result = vkd.?.queuePresentKHR(vkPresentQueue, &presentInfo) catch |e| {
            if (e == error.OutOfDateKHR) {
                recreate_swapchain();
                return;
            } else if (e == error.SurfaceLostKHR) {
                recreateSurface();
                recreate_swapchain();
                return;
            } else {
                xfit.herr3("__vulkan.drawFrame.queuePresentKHR", e);
            }
        };

        if (queuePresentKHR_result == .error_out_of_date_khr) {
            recreate_swapchain();
            return;
        } else if (queuePresentKHR_result == .suboptimal_khr) {
            var prop: vk.SurfaceCapabilitiesKHR = undefined;
            prop = vki.?.getPhysicalDeviceSurfaceCapabilitiesKHR(vk_physical_device, vkSurface) catch |e| xfit.herr3("__vulkan.drawFrame.getPhysicalDeviceSurfaceCapabilitiesKHR", e);
            if (prop.current_extent.width != vkExtent.width or prop.current_extent.height != vkExtent.height) {
                recreate_swapchain();
                return;
            }
        } else if (queuePresentKHR_result == .error_surface_lost_khr) {
            recreateSurface();
            recreate_swapchain();
            return;
        } else {
            xfit.herr(queuePresentKHR_result == .success, "__vulkan.drawFrame.vkQueuePresentKHR : {}", .{queuePresentKHR_result});
        }
        state.frame = (state.frame + 1) % render_command.MAX_FRAME;
    }
}

pub fn draw_offscreen(allocator: std.mem.Allocator, size: ?math.pointu, render_commands: []*render_command) !*graphics.image {
    _ = allocator;
    _ = size;
    if (render_commands.len == 0) xfit.herrm("draw_offscreen render_commands empty");
    @trap();

    //TODO 함수 나머지 내용은 __vulkan_allocator의 스레드 내에서 실행되어야 함. 왜냐하면 먼저 필요한 이미지 생성이 비동기로 실행되어야 하기 때문이고 전체 비동기 함수로 만든다.
    // const cmds = std.heap.c_allocator.alloc(vk.CommandBuffer, render_commands.len + 1) catch xfit.herrm("draw_offscreen cmds alloc");
    // defer std.heap.c_allocator.free(cmds);

    // const poolInfo: vk.CommandPoolCreateInfo = .{
    //     .flags = .{ .reset_command_buffer_bit = true },
    //     .queue_family_index = graphicsFamilyIndex,
    // };

    // const local_command_pool = vkd.?.createCommandPool(&poolInfo, null) catch |e| xfit.herr3("__vulkan.vulkan_start createCommandPool vkCommandPool", e);
    // defer vkd.?.destroyCommandPool(local_command_pool, null);

    // const allocInfo: vk.CommandBufferAllocateInfo = .{
    //     .command_pool = local_command_pool,
    //     .level = .primary,
    //     .command_buffer_count = 1 + render_commands.len,
    // };
    // vkd.?.allocateCommandBuffers(&allocInfo, cmds.ptr) catch |e| xfit.herr3("draw_offscreen allocateCommandBuffers cmds", e);

    // var cmdidx: usize = 1;

    // for (render_commands) |*cmd| {
    //     if (@cmpxchgStrong(bool, &cmd.*.*.__refesh, true, false, .monotonic, .monotonic) == null) {
    //         // recordCommandBuffer(cmd, @intCast(state.frame));
    //     }
    //     if (cmd.*.*.scene != null and cmd.*.*.scene.?.len > 0) {
    //         cmdidx += 1;
    //     }
    // }

    // const waitStages: vk.PipelineStageFlags = .{ .color_attachment_output_bit = true };
    // var submitInfo: vk.SubmitInfo = .{
    //     .wait_semaphore_count = 0,
    //     .command_buffer_count = @intCast(cmdidx),
    //     .signal_semaphore_count = 0,
    //     .p_wait_semaphores = null,
    //     .p_wait_dst_stage_mask = @ptrCast(&waitStages),
    //     .p_command_buffers = cmds.ptr,
    //     .p_signal_semaphores = null,
    // };

    // const cls_color0 = @atomicLoad(f32, &clear_color._0, .monotonic);
    // const cls_color1 = @atomicLoad(f32, &clear_color._1, .monotonic);
    // const cls_color2 = @atomicLoad(f32, &clear_color._2, .monotonic);
    // const cls_color3 = @atomicLoad(f32, &clear_color._3, .monotonic);
    // const clearColor: vk.ClearValue = .{ .color = .{ .float_32 = .{ cls_color0, cls_color1, cls_color2, cls_color3 } } };

    // const clearDepthStencil: vk.ClearValue = .{ .depth_stencil = .{ .stencil = 0, .depth = 1 } };
    // var renderPassInfo: vk.RenderPassBeginInfo = .{
    //     .render_pass = vkRenderPassClear,
    //     .framebuffer = vk_swapchain_frame_buffers[imageIndex].clear.res,
    //     .render_area = .{ .offset = .{ .x = 0, .y = 0 }, .extent = vkExtent_rotation },
    //     .clear_value_count = 2,
    //     .p_clear_values = &[_]vk.ClearValue{ clearColor, clearDepthStencil },
    // };
    // const beginInfo: vk.CommandBufferBeginInfo = .{
    //     .flags = .{ .one_time_submit_bit = true },
    //     .p_inheritance_info = null,
    // };
    // vkd.?.beginCommandBuffer(vkCommandBuffer[state.frame], &beginInfo) catch |e| xfit.herr3("__vulkan.drawFrame.beginCommandBuffer", e);
    // vkd.?.cmdBeginRenderPass(vkCommandBuffer[state.frame], &renderPassInfo, .@"inline");
    // vkd.?.cmdEndRenderPass(vkCommandBuffer[state.frame]);
    // vkd.?.endCommandBuffer(vkCommandBuffer[state.frame]) catch |e| xfit.herr3("__vulkan.drawFrame.endCommandBuffer", e);

    // vkd.?.resetFences(1, @ptrCast(&vkInFlightFence[state.frame])) catch |e| xfit.herr3("__vulkan.drawFrame.resetFences", e);

    // __vulkan_allocator.submit_mutex.lock();
    // vkd.?.queueSubmit(vkGraphicsQueue, 1, @ptrCast(&submitInfo), vkInFlightFence[state.frame]) catch |e| xfit.herr3("__vulkan.drawFrame.queueSubmit", e);
    // __vulkan_allocator.submit_mutex.unlock();

    // const swapChains = [_]vk.SwapchainKHR{vkSwapchain};

    // const presentInfo: vk.PresentInfoKHR = .{
    //     .wait_semaphore_count = 1,
    //     .swapchain_count = 1,
    //     .p_wait_semaphores = @ptrCast(&vkRenderFinishedSemaphore[state.frame]),
    //     .p_swapchains = @ptrCast(&swapChains),
    //     .p_image_indices = @ptrCast(&imageIndex),
    // };
    // __vulkan_allocator.submit_mutex.lock();
    // const queuePresentKHR_result = vkd.?.queuePresentKHR(vkPresentQueue, &presentInfo) catch |e| {
    //     if (e == error.OutOfDateKHR) {
    //         __vulkan_allocator.submit_mutex.unlock();
    //         recreate_swapchain();
    //         return;
    //     } else if (e == error.SurfaceLostKHR) {
    //         __vulkan_allocator.submit_mutex.unlock();
    //         recreateSurface();
    //         recreate_swapchain();
    //         return;
    //     } else {
    //         xfit.herr3("__vulkan.drawFrame.queuePresentKHR", e);
    //     }
    // };
    // __vulkan_allocator.submit_mutex.unlock();

    // if (queuePresentKHR_result == .error_out_of_date_khr) {
    //     recreate_swapchain();
    //     return;
    // } else if (queuePresentKHR_result == .suboptimal_khr) {
    //     var prop: vk.SurfaceCapabilitiesKHR = undefined;
    //     prop = vki.?.getPhysicalDeviceSurfaceCapabilitiesKHR(vk_physical_device, vkSurface) catch |e| xfit.herr3("__vulkan.drawFrame.getPhysicalDeviceSurfaceCapabilitiesKHR", e);
    //     if (prop.current_extent.width != vkExtent.width or prop.current_extent.height != vkExtent.height) {
    //         recreate_swapchain();
    //         return;
    //     }
    // } else if (queuePresentKHR_result == .error_surface_lost_khr) {
    //     recreateSurface();
    //     recreate_swapchain();
    //     return;
    // } else {
    //     xfit.herr(queuePresentKHR_result == .success, "__vulkan.drawFrame.vkQueuePresentKHR : {}", .{queuePresentKHR_result});
    // }
    // state.frame = (state.frame + 1) % render_command.MAX_FRAME;
}

pub fn wait_device_idle() void {
    vkd.?.deviceWaitIdle() catch |e| xfit.herr3("__vulkan.deviceWaitIdle", e);
}
pub fn wait_graphics_idle() void {
    __vulkan_allocator.submit_mutex.lock();
    defer __vulkan_allocator.submit_mutex.unlock();
    vkd.?.queueWaitIdle(vkGraphicsQueue) catch |e| xfit.herr3("__vulkan.queueWaitIdle vkGraphicsQueue", e);
}
pub fn wait_present_idle() void {
    __vulkan_allocator.submit_mutex.lock();
    defer __vulkan_allocator.submit_mutex.unlock();
    vkd.?.queueWaitIdle(vkPresentQueue) catch |e| xfit.herr3("__vulkan.queueWaitIdle vkPresentQueue", e);
}

pub fn transition_image_layout(cmd: vk.CommandBuffer, image: vk.Image, mipLevels: u32, arrayStart: u32, arrayLayers: u32, old_layout: vk.ImageLayout, new_layout: vk.ImageLayout) void {
    var barrier: vk.ImageMemoryBarrier = .{
        .old_layout = old_layout,
        .new_layout = new_layout,
        .src_queue_family_index = vk.QUEUE_FAMILY_IGNORED,
        .dst_queue_family_index = vk.QUEUE_FAMILY_IGNORED,
        .image = image,
        .subresource_range = .{
            .aspect_mask = .{ .color_bit = true },
            .base_mip_level = 0,
            .level_count = mipLevels,
            .base_array_layer = arrayStart,
            .layer_count = arrayLayers,
        },
        .src_access_mask = undefined,
        .dst_access_mask = undefined,
    };

    var source_stage: vk.PipelineStageFlags = undefined;
    var destination_stage: vk.PipelineStageFlags = undefined;

    if (old_layout == .undefined and new_layout == .transfer_dst_optimal) {
        barrier.src_access_mask = .{};
        barrier.dst_access_mask = .{ .transfer_write_bit = true };

        source_stage = .{ .top_of_pipe_bit = true };
        destination_stage = .{ .transfer_bit = true };
    } else if (old_layout == .transfer_dst_optimal and new_layout == .shader_read_only_optimal) {
        barrier.src_access_mask = .{ .transfer_write_bit = true };
        barrier.dst_access_mask = .{ .shader_read_bit = true };

        source_stage = .{ .transfer_bit = true };
        destination_stage = .{ .fragment_shader_bit = true };
    } else {
        xfit.herrm("__vulkan.transition_image_layout unsupported layout transition!");
    }

    vkd.?.cmdPipelineBarrier(
        cmd,
        source_stage,
        destination_stage,
        .{},
        0,
        null,
        0,
        null,
        1,
        @ptrCast(&barrier),
    );
}
