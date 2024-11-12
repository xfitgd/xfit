const std = @import("std");
const xfit = @import("xfit.zig");
const system = @import("system.zig");
const window = @import("window.zig");
const input = @import("input.zig");
const math = @import("math.zig");
const __system = @import("__system.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");
const root = @import("root");

pub const c = @cImport({
    @cDefine("XK_LATIN1", "1");
    @cDefine("XK_MISCELLANY", "1");
    @cInclude("X11/Xlib.h");
    @cInclude("X11/keysym.h");
    @cInclude("X11/extensions/Xrandr.h");
});

pub var display: ?*c.Display = null;
pub var def_screen_idx: usize = 0;
pub var wnd: c.Window = 0;
pub var del_window: c.Atom = undefined;
pub var window_extent: [4]c_long = undefined;

var input_thread: std.Thread = undefined;
var cur_fullscreen_monitor: system.monitor_info = undefined;

pub fn system_linux_start() void {
    display = c.XOpenDisplay(null);
    if (display == null) xfit.herrm("system_linux_start XOpenDisplay");
    def_screen_idx = @max(0, c.DefaultScreen(display));

    var i: usize = 0;

    const screens_res = c.XRRGetScreenResources(display, c.DefaultRootWindow(display));
    defer c.XRRFreeScreenResources(screens_res);

    i = 0;
    while (i < screens_res.*.noutput) : (i += 1) {
        const crtc_info = c.XRRGetCrtcInfo(display, screens_res, screens_res.*.crtcs[i]);
        const output = c.XRRGetOutputInfo(display, screens_res, screens_res.*.outputs[i]);
        defer c.XRRFreeCrtcInfo(crtc_info);
        defer c.XRRFreeOutputInfo(output);

        __system.monitors.append(system.monitor_info{
            .is_primary = i == def_screen_idx,
            .rect = math.recti.init(
                crtc_info.*.x,
                crtc_info.*.x + @as(c_int, @intCast(crtc_info.*.width)),
                crtc_info.*.y,
                crtc_info.*.y + @as(c_int, @intCast(crtc_info.*.height)),
            ),
        }) catch |e| xfit.herr3("MonitorEnumProc __system.monitors.append", e);
        const last = &__system.monitors.items[__system.monitors.items.len - 1];
        if (last.*.is_primary) __system.primary_monitor = last;

        last.*.name = std.heap.c_allocator.alloc(u8, std.mem.len(output.*.name)) catch unreachable;
        @memcpy(@constCast(last.*.name), output.*.name[0..last.*.name.len]);

        xfit.print_log("\nXFIT SYSLOG : {s}monitor {d} name: {s}, x:{d}, y:{d}, width:{d}, height:{d} [\n\n", .{
            if (last.*.is_primary) "primary " else "",
            i,
            last.*.name,
            crtc_info.*.x,
            crtc_info.*.y,
            crtc_info.*.width,
            crtc_info.*.height,
        });

        var k: c_uint = 0;
        var mode_: ?*c.XRRModeInfo = null;
        while (k < screens_res.*.nmode) : (k += 1) {
            if (output.*.modes[0] == screens_res.*.modes[k].id) {
                mode_ = &screens_res.*.modes[k];
                break;
            }
        }
        if (mode_ == null) unreachable;
        const hz = @as(f64, @floatFromInt(mode_.?.*.dotClock)) / @as(f64, @floatFromInt(mode_.?.*.hTotal * mode_.?.*.vTotal));
        xfit.print_log("monitor {d} resolution  : width {d}, height {d}, refleshrate {d}\n", .{
            i,
            mode_.?.*.width,
            mode_.?.*.height,
            hz,
        });
        last.*.resolution = .{
            .monitor = last,
            .refleshrate = hz,
            .size = .{ mode_.?.*.width, mode_.?.*.height },
        };
        xfit.write("]\n");
    }
}

fn render_func() void {
    //var ring = std.os.linux.IoUring.init(64, 0) catch |e| xfit.herr3("input_func IoUring.init", e);
    //var sqe = ring.get_sqe() catch |e| xfit.herr3("input_func ring.get_sqe", e);
    __vulkan.vulkan_start();

    root.xfit_init() catch |e| {
        xfit.herr3("xfit_init", e);
    };

    __vulkan_allocator.execute_and_wait_all_op();

    while (!xfit.exiting()) {
        __system.loop();
    }
    __vulkan_allocator.execute_and_wait_all_op();

    __vulkan.wait_device_idle();

    root.xfit_destroy() catch |e| {
        xfit.herr3("xfit_destroy", e);
    };

    __vulkan.vulkan_destroy();
}

pub const _NET_WM_STATE_TOGGLE = 2;

fn toggle_borderless(comptime toggle: bool) void {
    if (toggle) {
        reset_size_hint();
    }
    var xev: c.XEvent = std.mem.zeroes(c.XEvent);
    const evmask = c.SubstructureRedirectMask | c.SubstructureNotifyMask;

    xev.type = c.ClientMessage;
    xev.xclient.window = wnd;
    xev.xclient.message_type = c.XInternAtom(display, "_NET_WM_STATE", c.True);
    xev.xclient.format = 32;
    xev.xclient.data.l[0] = @intFromBool(toggle);
    xev.xclient.data.l[1] = @intCast(c.XInternAtom(display, "_NET_WM_STATE_FULLSCREEN", c.True));
    xev.xclient.data.l[2] = 0;

    _ = c.XSendEvent(display, c.DefaultRootWindow(display), 0, evmask, &xev);
}
fn change_borderless() void {
    toggle_borderless(true);
}

fn change_fullscreen(monitor: *const system.monitor_info, _switch_from_window: bool) void {
    if (_switch_from_window) change_borderless();
    cur_fullscreen_monitor = monitor.*;
    if (__vulkan.VK_EXT_full_screen_exclusive_support and !__vulkan.is_fullscreen_ex) {
        __vulkan.is_fullscreen_ex = true;
    }
}

fn restore_fullscreen() void {}

pub fn set_window_mode() void {
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    const wm = window.get_screen_mode();
    if (wm != .WINDOW) {
        toggle_borderless(false);
        if (wm == .FULLSCREEN) restore_fullscreen();
        _ = c.XMoveResizeWindow(
            display,
            wnd,
            __system.prev_window.x,
            __system.prev_window.y,
            @intCast(__system.prev_window.width + window_extent[0] + window_extent[1]),
            @intCast(__system.prev_window.height + window_extent[2] + window_extent[3]),
        );
        set_size_hint(true);
        if (__vulkan.is_fullscreen_ex) {
            __vulkan.is_fullscreen_ex = false;
        }
    }
}

pub fn set_borderlessscreen_mode(monitor: *const system.monitor_info) void {
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    const wm = window.get_screen_mode();
    if (wm != .BORDERLESSSCREEN) {
        _ = c.XMoveResizeWindow(display, wnd, monitor.*.rect.left, monitor.*.rect.top, @intCast(monitor.*.rect.width()), @intCast(monitor.*.rect.height()));
        if (wm == .FULLSCREEN) {
            restore_fullscreen();
        } else {
            change_borderless();
        }

        if (__vulkan.is_fullscreen_ex) {
            __vulkan.is_fullscreen_ex = false;
        }
    }
}

pub fn get_monitor_from_window() *const system.monitor_info {
    const x = window.window_x();
    const y = window.window_y();
    for (__system.monitors.items) |*v| {
        if (v.*.rect.is_point_in_window_rect(.{ x, y })) return v;
    }
    return system.primary_monitor();
}

pub fn set_window_pos(x: i32, y: i32) void {
    _ = c.XMoveWindow(display, wnd, x, y);
    __system.prev_window.x = @intCast(x);
    __system.prev_window.y = @intCast(y);
}

pub fn set_window_size(w: u32, h: u32) void {
    _ = c.XResizeWindow(display, wnd, w + window_extent[0] + window_extent[1], h + window_extent[2] + window_extent[3]);
    __system.prev_window.width = w;
    __system.prev_window.height = h;
}

pub fn set_window_mode2(pos: math.point(i32), size: math.point(u32), state: window.window_state, can_maximize: bool, can_minimize: bool, can_resizewindow: bool) void {
    _ = can_maximize;
    _ = can_minimize;
    _ = can_resizewindow;
    _ = state;
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    const wm = window.get_screen_mode();
    if (wm != .WINDOW) {
        toggle_borderless(false);
        if (wm == .FULLSCREEN) restore_fullscreen();
        if (__vulkan.is_fullscreen_ex) {
            __vulkan.is_fullscreen_ex = false;
        }
    }
    _ = c.XMoveResizeWindow(
        display,
        wnd,
        pos[0],
        pos[1],
        @intCast(size[0] + window_extent[0] + window_extent[1]),
        @intCast(size[1] + window_extent[2] + window_extent[3]),
    );
}

pub fn set_fullscreen_mode(monitor: *const system.monitor_info) void {
    __vulkan.fullscreen_mutex.lock();
    defer __vulkan.fullscreen_mutex.unlock();
    const wm = window.get_screen_mode();
    change_fullscreen(monitor, wm == .WINDOW);
    _ = c.XMoveResizeWindow(display, wnd, monitor.*.rect.left, monitor.*.rect.top, monitor.*.resolution.size[0], monitor.*.resolution.size[1]);
}

fn set_size_hint(comptime again: bool) void {
    const hint: [*c]c.XSizeHints = c.XAllocSizeHints();
    defer _ = c.XFree(@ptrCast(hint));
    if (!window.can_resizewindow()) {
        hint.*.flags |= c.PMinSize;
        hint.*.flags |= c.PMaxSize;
        if (again) {
            hint.*.min_width = @intCast(__system.prev_window.width);
            hint.*.min_height = @intCast(__system.prev_window.height);
            hint.*.max_width = @intCast(__system.prev_window.width);
            hint.*.max_height = @intCast(__system.prev_window.height);

            hint.*.width = @intCast(__system.prev_window.width);
            hint.*.height = @intCast(__system.prev_window.height);
            hint.*.flags |= c.PSize;
        } else {
            hint.*.min_width = @intCast(__system.init_set.window_width);
            hint.*.min_height = @intCast(__system.init_set.window_height);
            hint.*.max_width = @intCast(__system.init_set.window_width);
            hint.*.max_height = @intCast(__system.init_set.window_height);
        }
        _ = c.XSetNormalHints(display, wnd, hint);
    } else {
        var change: bool = false;
        if (__system.init_set.min_window_width != xfit.init_setting.DEF_SIZE and __system.init_set.min_window_width != 0) {
            hint.*.min_width = @intCast(__system.init_set.min_window_width);
            hint.*.min_height = 0;
            hint.*.flags |= c.PMinSize;
            change = true;
        }
        if (__system.init_set.max_window_width != xfit.init_setting.DEF_SIZE and __system.init_set.max_window_width != 0) {
            hint.*.max_width = @intCast(__system.init_set.max_window_width);
            hint.*.max_height = std.math.maxInt(c_int);
            hint.*.flags |= c.PMaxSize;
            change = true;
        }
        if (__system.init_set.min_window_height != xfit.init_setting.DEF_SIZE and __system.init_set.min_window_height != 0) {
            hint.*.min_height = @intCast(__system.init_set.min_window_height);
            hint.*.flags |= c.PMinSize;
            change = true;
        }
        if (__system.init_set.max_window_height != xfit.init_setting.DEF_SIZE and __system.init_set.max_window_height != 0) {
            hint.*.max_height = @intCast(__system.init_set.max_window_height);
            if (hint.*.max_height == 0) hint.*.max_height = std.math.maxInt(c_int);
            hint.*.flags |= c.PMaxSize;
            change = true;
        }
        if (change) {
            if (again) {
                hint.*.width = @intCast(__system.prev_window.width);
                hint.*.height = @intCast(__system.prev_window.height);
                hint.*.flags |= c.PSize;
            }
            _ = c.XSetNormalHints(display, wnd, hint);
        }
    }
}
fn reset_size_hint() void {
    const hint: [*c]c.XSizeHints = c.XAllocSizeHints();
    defer _ = c.XFree(@ptrCast(hint));
    hint.*.flags |= c.PMinSize;
    hint.*.flags |= c.PMaxSize;
    hint.*.min_width = 0;
    hint.*.min_height = 0;
    hint.*.max_width = std.math.maxInt(c_int);
    hint.*.max_height = std.math.maxInt(c_int);
    _ = c.XSetNormalHints(display, wnd, hint);
}

pub fn linux_start() void {
    if (__system.init_set.window_width == xfit.init_setting.DEF_SIZE or __system.init_set.window_width == 0) __system.init_set.window_width = 960;
    if (__system.init_set.window_height == xfit.init_setting.DEF_SIZE or __system.init_set.window_height == 0) __system.init_set.window_height = 540;
    if (__system.init_set.window_x == xfit.init_setting.DEF_POS) __system.init_set.window_x = 0;
    if (__system.init_set.window_y == xfit.init_setting.DEF_POS) __system.init_set.window_y = 0;

    if (__system.init_set.screen_index > __system.monitors.items.len - 1) __system.init_set.screen_index = @intCast(def_screen_idx);

    wnd = c.XCreateWindow(
        display,
        c.XDefaultRootWindow(display),
        __system.init_set.window_x,
        __system.init_set.window_y,
        __system.init_set.window_width,
        __system.init_set.window_height,
        0,
        c.CopyFromParent,
        c.InputOutput,
        c.CopyFromParent,
        0,
        null,
    );
    _ = c.XSelectInput(display, wnd, c.KeyPressMask | c.KeyReleaseMask | c.ButtonReleaseMask | c.ButtonPressMask | c.PointerMotionMask | c.StructureNotifyMask);
    _ = c.XMapWindow(display, wnd);

    var res_atom: c.Atom = undefined;
    var res_fmt: c_int = undefined;
    var res_num: c_ulong = undefined;
    var res_remain: c_ulong = undefined;
    var res_data: [*c]u8 = undefined;

    del_window = c.XInternAtom(display, "WM_DELETE_WINDOW", 0);
    _ = c.XSetWMProtocols(display, wnd, &del_window, 1);

    while (c.XGetWindowProperty(
        display,
        wnd,
        c.XInternAtom(display, "_NET_FRAME_EXTENTS", c.True),
        0,
        4,
        c.False,
        c.AnyPropertyType,
        &res_atom,
        &res_fmt,
        &res_num,
        &res_remain,
        &res_data,
    ) != c.Success or res_num != 4 or res_remain != 0) {
        var event: c.XEvent = undefined;
        //xfit.write_log("wait _NET_FRAME_EXTENTS\n");
        _ = c.XNextEvent(display, &event);
    }
    @memcpy(window_extent[0..window_extent.len], @as([*c]align(1) c_long, @ptrCast(res_data))[0..window_extent.len]);

    set_size_hint(false);

    //left %ld right %ld top %ld bottom %ld
    //xfit.print_log("{d},{d},{d},{d}\n", .{ window_extent[0], window_extent[1], window_extent[2], window_extent[3] });

    input_thread = std.Thread.spawn(.{}, render_func, .{}) catch unreachable;
}

pub fn vulkan_linux_start(vkSurface: *__vulkan.vk.SurfaceKHR) void {
    __vulkan.load_instance_and_device();
    if (vkSurface.* != .null_handle) {
        __vulkan.vki.?.destroySurfaceKHR(vkSurface.*, null);
    }
    const xlibSurfaceCreateInfo: __vulkan.vk.XlibSurfaceCreateInfoKHR = .{
        .window = wnd,
        .dpy = @ptrCast(display.?),
    };
    vkSurface.* = __vulkan.vki.?.createXlibSurfaceKHR(&xlibSurfaceCreateInfo, null) catch |e|
        xfit.herr3("createXlibSurfaceKHR", e);
}

pub fn linux_loop() void {
    var event: c.XEvent = undefined;
    while (!xfit.exiting()) {
        _ = c.XNextEvent(display, &event);
        switch (event.type) {
            c.ConfigureNotify => {
                const w = window.window_width();
                const h = window.window_height();
                if (w != event.xconfigure.width or h != event.xconfigure.height) {
                    @atomicStore(u32, &__system.init_set.window_width, @abs(event.xconfigure.width), .monotonic);
                    @atomicStore(u32, &__system.init_set.window_height, @abs(event.xconfigure.height), .monotonic);

                    if (__system.loop_start.load(.monotonic)) {
                        root.xfit_size() catch |e| {
                            xfit.herr3("xfit_size", e);
                        };
                        __system.size_update.store(true, .monotonic);
                    }
                    //xfit.print_log("w{d}, h{d}\n", .{ event.xconfigure.width, event.xconfigure.height });
                }
                const x = window.window_x();
                const y = window.window_y();
                if (event.xconfigure.send_event == c.False and event.xconfigure.override_redirect == c.False) {
                    var unused: c.Window = undefined;
                    _ = c.XTranslateCoordinates(display, wnd, c.XDefaultRootWindow(display), 0, 0, &event.xconfigure.x, &event.xconfigure.y, &unused);
                }
                if (x != event.xconfigure.x or y != event.xconfigure.y) {
                    @atomicStore(i32, &__system.init_set.window_x, event.xconfigure.x, .monotonic);
                    @atomicStore(i32, &__system.init_set.window_y, event.xconfigure.y, .monotonic);

                    system.a_fn_call(__system.window_move_func, .{}) catch {};
                    //xfit.print_log("x{d}, y{d}\n", .{ event.xconfigure.x, event.xconfigure.y });
                }
            },
            c.ClientMessage => {
                if (event.xclient.data.l[0] == del_window) {
                    __system.exiting.store(true, std.builtin.AtomicOrder.release);
                    return;
                }
            },
            c.KeyPress => {
                const keyr = c.XLookupKeysym(&event.xkey, 0);
                if (keyr > 0xffff) continue;
                var keyv: u16 = @intCast(keyr);
                const key: input.key = @enumFromInt(keyv);
                if (keyv > 0xff and keyv < 0xff00) {
                    @branchHint(.cold);
                    xfit.print("WARN linux_loop KeyPress out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keyv });
                    continue;
                } else if (keyv >= 0xff00) {
                    keyv = keyv - 0xff00 + 0xff;
                }
                //다른 스레드에서 __system.keys[keyv]를 수정하지 않고 읽기만하니 weak로도 충분하다.
                if (__system.keys[keyv].cmpxchgWeak(false, true, .monotonic, .monotonic) == null) {
                    system.a_fn_call(__system.key_down_func, .{key}) catch {};
                }
            },
            c.KeyRelease => {
                const keyr = c.XLookupKeysym(&event.xkey, 0);
                if (keyr > 0xffff) continue;
                var keyv: u16 = @intCast(keyr);
                const key: input.key = @enumFromInt(keyv);
                if (keyv > 0xff and keyv < 0xff00) {
                    @branchHint(.cold);
                    xfit.print("WARN linux_loop KeyRelease out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keyv });
                    continue;
                } else if (keyv >= 0xff00) {
                    keyv = keyv - 0xff00 + 0xff;
                }
                __system.keys[keyv].store(false, std.builtin.AtomicOrder.monotonic);
                system.a_fn_call(__system.key_up_func, .{key}) catch {};
            },
            c.ButtonPress, c.ButtonRelease => |e| {
                switch (event.xbutton.button) {
                    1 => {
                        __system.Lmouse_click.store(e == c.ButtonPress, std.builtin.AtomicOrder.monotonic);
                        const mm = input.convert_set_mouse_pos(.{ @floatFromInt(event.xbutton.x), @floatFromInt(event.xbutton.y) });
                        system.a_fn_call(if (e == c.ButtonPress) __system.Lmouse_down_func else __system.Lmouse_up_func, .{mm}) catch {};
                    },
                    2 => {
                        __system.Mmouse_click.store(e == c.ButtonPress, std.builtin.AtomicOrder.monotonic);
                        const mm = input.convert_set_mouse_pos(.{ @floatFromInt(event.xbutton.x), @floatFromInt(event.xbutton.y) });
                        system.a_fn_call(if (e == c.ButtonPress) __system.Mmouse_down_func else __system.Mmouse_up_func, .{mm}) catch {};
                    },
                    3 => {
                        __system.Rmouse_click.store(e == c.ButtonPress, std.builtin.AtomicOrder.monotonic);
                        const mm = input.convert_set_mouse_pos(.{ @floatFromInt(event.xbutton.x), @floatFromInt(event.xbutton.y) });
                        system.a_fn_call(if (e == c.ButtonPress) __system.Rmouse_down_func else __system.Rmouse_up_func, .{mm}) catch {};
                    },
                    //8 => {}, Back
                    //9 => {}, Front
                    else => {},
                }
            },
            c.MotionNotify => {
                const w = window.window_width();
                const h = window.window_height();
                const mm = input.convert_set_mouse_pos(.{ @floatFromInt(event.xmotion.x), @floatFromInt(event.xmotion.y) });
                @atomicStore(f64, @as(*f64, @ptrCast(&__system.cursor_pos)), @bitCast(mm), .monotonic);
                if (input.is_mouse_out()) {
                    if (event.xmotion.x >= 0 and event.xmotion.y >= 0 and event.xmotion.x <= w and event.xmotion.y <= h) {
                        __system.mouse_out.store(false, .monotonic);
                        system.a_fn_call(__system.mouse_hover_func, .{}) catch {};
                    }
                } else {
                    if (event.xmotion.x < 0 or event.xmotion.y < 0 or event.xmotion.x > w or event.xmotion.y > h) {
                        __system.mouse_out.store(true, .monotonic);
                        system.a_fn_call(__system.mouse_leave_func, .{}) catch {};
                    }
                }
                system.a_fn_call(__system.mouse_move_func, .{mm}) catch {};
            },
            else => {},
        }
    }
}

pub fn linux_close() void {
    var event: c.XEvent = undefined;
    event.xclient.type = c.ClientMessage;
    event.xclient.window = wnd;
    event.xclient.message_type = c.XInternAtom(display, "WM_PROTOCOLS", 1);
    event.xclient.format = 32;
    event.xclient.data.l[0] = @intCast(c.XInternAtom(display, "WM_DELETE_WINDOW", 0));
    event.xclient.data.l[1] = c.CurrentTime;
    _ = c.XSendEvent(display, wnd, c.False, c.NoEventMask, &event);
}

pub fn linux_destroy() void {
    input_thread.join();
    _ = c.XDestroyWindow(display, wnd);
    _ = c.XCloseDisplay(display);
}
