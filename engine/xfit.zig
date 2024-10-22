const std = @import("std");
const root = @import("root");
const builtin = @import("builtin");

const system = @import("system.zig");
const __system = @import("__system.zig");
const __windows = @import("__windows.zig");
const __android = @import("__android.zig");
const __vulkan = @import("__vulkan.zig");

pub fn xfit_main(_allocator: std.mem.Allocator, init_setting: *const system.init_setting) void {
    __system.init(_allocator, init_setting);

    if (system.platform == .windows) {
        __windows.system_windows_start();

        if (system.subsystem == system.SubSystem.Console) {
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
    } else if (system.platform == .android) {
        __vulkan.vulkan_start();

        root.xfit_init() catch |e| {
            system.handle_error3("xfit_init", e);
        };
    } else if (system.platform == .linux) {
        __vulkan.vulkan_start();

        root.xfit_init() catch |e| {
            system.handle_error3("xfit_init", e);
        };
    } else {
        @compileError("not support platform");
    }
}
