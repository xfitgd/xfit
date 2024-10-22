const std = @import("std");
const system = @import("system.zig");
const __system = @import("__system.zig");

const c = @cImport({
    @cInclude("wayland-client.h");
    @cInclude("wayland-server.h");
    @cInclude("wayland-client-protocol.h");
    @cInclude("wayland-cursor.h");
    @cInclude("linux/input.h");
});

fn handle_global(data: ?*anyopaque, _registry: [*c]c.wl_registry, name: c_uint, interface: *const u8, version: c_uint) callconv(.C) void {
    _ = data;
    _ = _registry;
    _ = name;
    _ = interface;
    _ = version;
}
fn handle_global_remove(data: ?*anyopaque, _registry: [*c]c.wl_registry, name: c_uint) callconv(.C) void {
    _ = data;
    _ = _registry;
    _ = name;
}

pub var screens: [][*c]c.Screen = undefined;
pub var display: [*c]c.wl_display = undefined;
pub var registry_listener: c.struct_wl_registry_listener = .{
    .global = handle_global,
    .global_remove = handle_global_remove,
};

pub fn system_linux_start() void {
    display = c.wl_display_connect(null) orelse system.handle_error_msg2("wl_display_connect");
    const registry = c.wl_display_get_registry(display);
    c.wl_registry_add_listener(registry, &registry_listener, null);
    if (c.wl_display_roundtrip(display) == -1) system.handle_error_msg2("wl_display_roundtrip");

    screens = std.heap.c_allocator.alloc([*c]c.Screen, @max(0, c.ScreenCount(display))) catch unreachable;
    var i: usize = 0;
    while (i < screens.len) : (i += 1) {
        screens[i] = c.ScreenOfDisplay(display, i);
    }
}

pub fn linux_start() void {}

pub fn linux_destroy() void {
    std.heap.c_allocator.free(screens);
}
