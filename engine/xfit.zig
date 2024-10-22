const std = @import("std");
const root = @import("root");
const builtin = @import("builtin");

pub const system = @import("system.zig");
pub const animator = @import("animator.zig");
pub const asset_file = @import("asset_file.zig");
pub const collision = @import("collision.zig");
pub const components = @import("components.zig");
pub const datetime = @import("datetime.zig");
pub const file = @import("file.zig");
pub const font = @import("font.zig");
pub const general_input = @import("general_input.zig");
pub const geometry = @import("geometry.zig");
pub const graphics = @import("graphics.zig");
pub const image_util = @import("image_util.zig");
pub const lua = @import("lua.zig");
pub const math = @import("math.zig");
pub const raw_input = @import("raw_input.zig");
pub const render_command = @import("render_command.zig");
pub const sound = @import("sound.zig");
pub const timer_callback = @import("timer_callback.zig");
pub const timezones = @import("timezones.zig");
pub const webp = @import("webp.zig");
pub const window = @import("window.zig");
pub const xbox_pad_input = @import("xbox_pad_input.zig");
pub const input = @import("input.zig");
pub const mem = @import("mem.zig");
pub const engine = @import("engine.zig");

//system engine only headers
const __system = @import("__system.zig");
const __windows = @import("__windows.zig");
const __android = @import("__android.zig");
const __vulkan = @import("__vulkan.zig");
const __linux = @import("__linux.zig");

pub const platform = @import("build_options").platform;
pub const subsystem = @import("build_options").subsystem;
pub const XfitPlatform = @TypeOf(platform);
pub const SubSystem = @TypeOf(subsystem);

pub const __android_entry = if (platform == .android) __android.android.ANativeActivity_createFunc else {};
//

pub fn xfit_main(_allocator: std.mem.Allocator, init_setting: *const system.init_setting) void {
    __system.init(_allocator, init_setting);

    if (platform == .windows) {
        __windows.system_windows_start();

        if (subsystem == SubSystem.Console) {
            root.xfit_init() catch |e| {
                system.handle_error3("xfit_init", e);
            };

            root.xfit_destroy() catch |e| {
                system.handle_error3("xfit_destroy", e);
            };
        } else {
            __windows.windows_start();
            //vulkan_start, root.xfit_init()는 별도의 작업 스레드에서 호출(거기서 렌더링)

            __windows.windows_loop();
        }

        __system.destroy();

        root.xfit_clean() catch |e| {
            system.handle_error3("xfit_clean", e);
        };

        __system.real_destroy();
    } else if (platform == .android) {
        __vulkan.vulkan_start();

        root.xfit_init() catch |e| {
            system.handle_error3("xfit_init", e);
        };
    } else if (platform == .linux) {
        __vulkan.vulkan_start();

        root.xfit_init() catch |e| {
            system.handle_error3("xfit_init", e);
        };
    } else {
        @compileError("not support platform");
    }
}
