const std = @import("std");

const builtin = @import("builtin");
const ArrayList = std.ArrayList;

const system = @import("system.zig");
const input = @import("input.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");
const __vulkan = @import("__vulkan.zig");
const __vulkan_allocator = @import("__vulkan_allocator.zig");
const render_command = @import("render_command.zig");
const general_input = @import("general_input.zig");
const xbox_pad_input = @import("xbox_pad_input.zig");
const __raw_input = @import("__raw_input.zig");
const graphics = @import("graphics.zig");
const math = @import("math.zig");

const root = @import("root");

pub const win32 = @import("include/windows.zig");

const WINAPI = @import("std").os.windows.WINAPI;
const HINSTANCE = win32.HINSTANCE;

pub const CW_USEDEFAULT = win32.CW_USEDEFAULT;
pub const MSG = win32.MSG;
pub const HWND = win32.HWND;
pub const RECT = win32.RECT;
pub const DWORD = c_ulong;
pub const WORD = c_ushort;
pub const SHORT = c_short;
pub const INT = c_int;
pub const TRUE: c_int = 1;
pub const FALSE: c_int = 0;
pub const BOOL = win32.BOOL;

pub var hWnd: HWND = undefined;
pub var hInstance: HINSTANCE = undefined;
pub var screen_mode: system.screen_mode = system.screen_mode.WINDOW;

const xbox_guid = win32.GUID{
    .Data1 = 0xec87f1e3,
    .Data2 = 0xc13b,
    .Data3 = 0x4100,
    .Data4 = [8]u8{ 0xb5, 0xf7, 0x8b, 0x84, 0xd5, 0x42, 0x60, 0xcb },
};

var render_thread_id: DWORD = undefined;
var render_thread_sem: std.Thread.Semaphore = .{};

pub fn vulkan_windows_start(vkInstance: __vulkan.vk.VkInstance, vkSurface: *__vulkan.vk.VkSurfaceKHR) void {
    if (vkSurface.* != null) {
        __vulkan.vk.vkDestroySurfaceKHR(vkInstance, vkSurface.*, null);
    }
    const win32SurfaceCreateInfo: __vulkan.vk.VkWin32SurfaceCreateInfoKHR = .{
        .hwnd = hWnd,
        .hinstance = hInstance,
        .flags = 0,
    };
    const result = __vulkan.vk.vkCreateWin32SurfaceKHR(vkInstance, &win32SurfaceCreateInfo, null, vkSurface);
    system.handle_error(result == __vulkan.vk.VK_SUCCESS, "vulkan_windows_start.vkCreateWin32SurfaceKHR {d}", .{result});
}

pub fn system_windows_start() void {
    if (__system.init_set.use_console)
        _ = win32.AllocConsole();

    var system_info: win32.SYSTEM_INFO = undefined;
    win32.GetSystemInfo(&system_info);
    __system.processor_core_len = system_info.dwNumberOfProcessors;

    var osversioninfo: win32.OSVERSIONINFOEXW = undefined;
    osversioninfo.dwOSVersionInfoSize = @sizeOf(win32.OSVERSIONINFOEXW);
    _ = std.os.windows.ntdll.RtlGetVersion(@ptrCast(&osversioninfo));

    __system.platform_ver.platform = .windows;
    __system.platform_ver.version.windows.build_number = osversioninfo.dwBuildNumber;
    __system.platform_ver.version.windows.service_pack = osversioninfo.wServicePackMajor;

    const serverOS: bool = osversioninfo.wProductType != win32.VER_NT_WORKSTATION;
    if (!serverOS and __system.platform_ver.version.windows.build_number >= 22000) {
        __system.platform_ver.version.windows.version = system.platform_version.windows_version.Windows11;
    } else if (serverOS and __system.platform_ver.version.windows.build_number >= 20348) {
        __system.platform_ver.version.windows.version = system.platform_version.windows_version.WindowsServer2022;
    } else if (serverOS and __system.platform_ver.version.windows.build_number >= 17763) {
        __system.platform_ver.version.windows.version = system.platform_version.windows_version.WindowsServer2019;
    } else if (osversioninfo.dwMajorVersion == 6 and osversioninfo.dwMinorVersion == 1) {
        __system.platform_ver.version.windows.version = if (serverOS) system.platform_version.windows_version.WindowsServer2008R2 else system.platform_version.windows_version.Windows7;
    } else if (osversioninfo.dwMajorVersion == 6 and osversioninfo.dwMinorVersion == 2) {
        __system.platform_ver.version.windows.version = if (serverOS) system.platform_version.windows_version.WindowsServer2012 else system.platform_version.windows_version.Windows8;
    } else if (osversioninfo.dwMajorVersion == 6 and osversioninfo.dwMinorVersion == 3) {
        __system.platform_ver.version.windows.version = if (serverOS) system.platform_version.windows_version.WindowsServer2012R2 else system.platform_version.windows_version.Windows8Point1;
    } else if (osversioninfo.dwMajorVersion == 10 and osversioninfo.dwMinorVersion == 0) {
        __system.platform_ver.version.windows.version = if (serverOS) system.platform_version.windows_version.WindowsServer2016 else system.platform_version.windows_version.Windows10;
    } else {
        __system.platform_ver.version.windows.version = system.platform_version.windows_version.Unknown;
        system.print_debug("WARN system_windows_start UNKNOWN platform.", .{});
    }

    _ = win32.EnumDisplayMonitors(null, null, MonitorEnumProc, 0);

    hInstance = win32.GetModuleHandleA(null) orelse system.handle_error2("windows_start.GetModuleHandleA {d}", .{win32.GetLastError()});

    __raw_input.start();
    return;
}

fn render_thread(param: win32.LPVOID) callconv(std.os.windows.WINAPI) DWORD {
    _ = param;
    __vulkan.vulkan_start();

    root.xfit_init() catch |e| {
        system.handle_error3("xfit_init", e);
    };

    __vulkan_allocator.execute_and_wait_all_op();

    while (!__system.exiting.load(std.builtin.AtomicOrder.acquire)) {
        __system.loop();
    }

    __vulkan_allocator.execute_and_wait_all_op();

    __vulkan.wait_device_idle();
    root.xfit_destroy() catch |e| {
        system.handle_error3("xfit_destroy", e);
    };
    __vulkan.vulkan_destroy();

    render_thread_sem.post();

    return 0;
}

pub fn windows_start() void {
    const CLASS_NAME = "Xfit Window Class";

    var wc = win32.WNDCLASSA{
        .style = 0,
        .lpfnWndProc = WindowProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = hInstance,
        .hIcon = if (__system.init_set.icon == null) win32.LoadIconA(null, @ptrFromInt(win32.IDI_APPLICATION)) else win32.LoadIconA(hInstance, @ptrCast(__system.init_set.icon)),
        .hCursor = if (__system.init_set.cursor == null) win32.LoadCursorA(null, @ptrFromInt(win32.IDC_ARROW)) else win32.LoadCursorA(hInstance, @ptrCast(__system.init_set.cursor)),
        .hbrBackground = null,
        .lpszMenuName = null,
        .lpszClassName = CLASS_NAME,
    };

    _ = win32.RegisterClassA(&wc);

    const window_style: DWORD = if (__system.init_set.screen_mode == system.screen_mode.WINDOW) (((((win32.WS_OVERLAPPED |
        win32.WS_CAPTION) |
        win32.WS_SYSMENU) |
        if (__system.init_set.can_resizewindow) win32.WS_THICKFRAME else 0) |
        if (__system.init_set.can_minimize) win32.WS_MINIMIZEBOX else 0) |
        if (__system.init_set.can_maximize) win32.WS_MAXIMIZEBOX else 0) else win32.WS_POPUP;

    const ex_style: DWORD = if (__system.init_set.screen_mode != system.screen_mode.WINDOW) (win32.WS_EX_APPWINDOW | if (__system.init_set.screen_mode == system.screen_mode.FULLSCREEN) win32.WS_EX_TOPMOST else 0) else 0;

    var window_x: i32 = __system.init_set.window_x;
    var window_y: i32 = __system.init_set.window_y;
    var window_width: u32 = __system.init_set.window_width;
    var window_height: u32 = __system.init_set.window_height;

    if (__system.init_set.screen_mode != system.screen_mode.WINDOW) {
        if (__system.init_set.screen_index == system.init_setting.PRIMARY_SCREEN_INDEX) {
            window_x = __system.primary_monitor.*.rect.left;
            window_y = __system.primary_monitor.*.rect.top;
            window_width = @intCast(__system.primary_monitor.*.rect.width());
            window_height = @intCast(__system.primary_monitor.*.rect.height());
            if (__system.init_set.screen_mode == system.screen_mode.FULLSCREEN) {
                change_fullscreen(__system.primary_monitor, __system.primary_monitor.*.primary_resolution.?);
            }
        } else {
            if (__system.monitors.items.len <= __system.init_set.screen_index) __system.init_set.screen_index = @intCast(__system.monitors.items.len - 1);
            window_x = __system.monitors.items[__system.init_set.screen_index].rect.left;
            window_y = __system.monitors.items[__system.init_set.screen_index].rect.top;
            window_width = @intCast(__system.monitors.items[__system.init_set.screen_index].rect.width());
            window_height = @intCast(__system.monitors.items[__system.init_set.screen_index].rect.height());
            if (__system.init_set.screen_mode == system.screen_mode.FULLSCREEN) {
                change_fullscreen(&__system.monitors.items[__system.init_set.screen_index], __system.monitors.items[__system.init_set.screen_index].primary_resolution.?);
            }
        }
    }

    _ = win32.CreateThread(null, 0, render_thread, null, 0, &render_thread_id);

    hWnd = win32.CreateWindowExA(ex_style, CLASS_NAME, @ptrCast(__system.init_set.window_title), window_style, window_x, window_y, @bitCast(window_width), @bitCast(window_height), null, null, hInstance, null) orelse system.handle_error2("windows_start.CreateWindowExA {d}", .{win32.GetLastError()});

    const rid = [_]win32.RAWINPUTDEVICE{ .{
        .usUsagePage = 1,
        .usUsage = 5,
        .dwFlags = win32.RIDEV_INPUTSINK,
        .hwndTarget = hWnd,
    }, .{
        .usUsagePage = 1,
        .usUsage = 4,
        .dwFlags = win32.RIDEV_INPUTSINK,
        .hwndTarget = hWnd,
    } };
    if (FALSE == win32.RegisterRawInputDevices(&rid, 2, @sizeOf(win32.RAWINPUTDEVICE))) {
        system.print_error("WARN RegisterRawInputDevices code : {d}\n", .{win32.GetLastError()});
        return;
    }

    _ = win32.ShowWindow(hWnd, if (__system.init_set.screen_mode == system.screen_mode.WINDOW) @intFromEnum(__system.init_set.window_show) else win32.SW_MAXIMIZE);
}

pub fn windows_loop() void {
    var msg: MSG = undefined;
    while (win32.GetMessageA(&msg, null, 0, 0) == TRUE) {
        if (msg.message == win32.WM_QUIT) break;
        _ = win32.TranslateMessage(&msg);
        _ = win32.DispatchMessageA(&msg);
    }
}

pub fn set_window_mode() void {
    const style: c_ulong = ((((win32.WS_OVERLAPPED |
        win32.WS_CAPTION) |
        win32.WS_SYSMENU) |
        if (window.can_resizewindow()) win32.WS_THICKFRAME else 0) |
        if (window.can_minimize()) win32.WS_MINIMIZEBOX else 0) |
        if (window.can_maximize()) win32.WS_MAXIMIZEBOX else 0;

    var rect: RECT = .{ .left = 0, .top = 0, .right = @intCast(__system.prev_window.width), .bottom = @intCast(__system.prev_window.height) };
    _ = win32.AdjustWindowRect(&rect, style, FALSE);

    __vulkan.fullscreen_mutex.lock();

    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_STYLE, @intCast(style));
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_EXSTYLE, 0);
    _ = win32.SetWindowPos(hWnd, null, __system.prev_window.x, __system.prev_window.y, rect.right - rect.left, rect.bottom - rect.top, win32.SWP_DRAWFRAME);

    _ = win32.ShowWindow(hWnd, switch (__system.prev_window.state) {
        .Restore => win32.SW_RESTORE,
        .Maximized => win32.SW_MAXIMIZE,
        .Minimized => win32.SW_MINIMIZE,
    });

    if (__vulkan.is_fullscreen_ex) {
        __vulkan.is_fullscreen_ex = false;
    }

    __vulkan.fullscreen_mutex.unlock();
}

pub fn set_window_size(w: u32, h: u32) void {
    var rect: RECT = .{ .left = 0, .top = 0, .right = @intCast(w), .bottom = @intCast(h) };
    const style: c_long = ((((win32.WS_OVERLAPPED |
        win32.WS_CAPTION) |
        win32.WS_SYSMENU) |
        if (window.can_resizewindow()) win32.WS_THICKFRAME else 0) |
        if (window.can_minimize()) win32.WS_MINIMIZEBOX else 0) |
        if (window.can_maximize()) win32.WS_MAXIMIZEBOX else 0;
    _ = win32.AdjustWindowRect(&rect, style, FALSE);

    _ = win32.SetWindowPos(hWnd, 0, __system.prev_window.x, __system.prev_window.y, rect.right - rect.left, rect.bottom - rect.top, win32.SWP_DRAWFRAME);
    __system.prev_window.width = @intCast(w);
    __system.prev_window.height = @intCast(h);
}

pub fn set_window_pos(x: i32, y: i32) void {
    const style: c_long = ((((win32.WS_OVERLAPPED |
        win32.WS_CAPTION) |
        win32.WS_SYSMENU) |
        if (window.can_resizewindow()) win32.WS_THICKFRAME else 0) |
        if (window.can_minimize()) win32.WS_MINIMIZEBOX else 0) |
        if (window.can_maximize()) win32.WS_MAXIMIZEBOX else 0;

    var rect: RECT = .{ .left = 0, .top = 0, .right = __system.prev_window.width, .bottom = __system.prev_window.height };
    _ = win32.AdjustWindowRect(&rect, style, FALSE);

    _ = win32.SetWindowPos(hWnd, 0, x, y, rect.right - rect.left, rect.bottom - rect.top, win32.SWP_DRAWFRAME);
    __system.prev_window.x = @intCast(x);
    __system.prev_window.y = @intCast(y);
}

pub fn get_monitor_from_window() *system.monitor_info {
    const hMonitor = win32.MonitorFromWindow(hWnd, win32.MONITOR_DEFAULTTONEAREST);
    if (hMonitor == null) return system.primary_monitor();

    for (__system.monitors.items) |*v| {
        if (v.*.__hmonitor == hMonitor) return v;
    }
    return system.primary_monitor();
}

pub fn set_window_mode2(pos: math.point(i32), size: math.point(u32), state: window.window_state, can_maximize: bool, can_minimize: bool, can_resizewindow: bool) void {
    const style: c_long = ((((win32.WS_OVERLAPPED |
        win32.WS_CAPTION) |
        win32.WS_SYSMENU) |
        if (can_resizewindow) win32.WS_THICKFRAME else 0) |
        if (can_minimize) win32.WS_MINIMIZEBOX else 0) |
        if (can_maximize) win32.WS_MAXIMIZEBOX else 0;

    var rect: RECT = .{ .left = 0, .top = 0, .right = @intCast(size.x), .bottom = @intCast(size.y) };
    _ = win32.AdjustWindowRect(&rect, style, FALSE);

    __vulkan.fullscreen_mutex.lock();

    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_STYLE, style);
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_EXSTYLE, 0);
    _ = win32.SetWindowPos(hWnd, 0, pos.x, pos.y, rect.right - rect.left, rect.bottom - rect.top, win32.SWP_DRAWFRAME);

    _ = win32.ShowWindow(hWnd, switch (state) {
        .Restore => win32.SW_RESTORE,
        .Maximized => win32.SW_MAXIMIZE,
        .Minimized => win32.SW_MINIMIZE,
    });

    __vulkan.fullscreen_mutex.unlock();
}

pub fn set_window_title() void {
    //?window.set_window_title 참고
    if (FALSE == win32.SetWindowTextA(hWnd, __system.title)) {
        system.print_error("WARN set_window_title.SetWindowTextA Failed Code : {d}\n", .{win32.GetLastError()});
    }
}

pub fn set_borderlessscreen_mode(monitor: *system.monitor_info) void {
    __vulkan.fullscreen_mutex.lock();
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_STYLE, win32.WS_POPUP);
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_EXSTYLE, win32.WS_EX_APPWINDOW);

    _ = win32.SetWindowPos(hWnd, null, monitor.*.rect.left, monitor.*.rect.top, monitor.*.rect.right - monitor.*.rect.left, monitor.*.rect.bottom - monitor.*.rect.top, win32.SWP_DRAWFRAME);

    _ = win32.ShowWindow(hWnd, win32.SW_MAXIMIZE);

    if (__vulkan.is_fullscreen_ex) {
        __vulkan.is_fullscreen_ex = false;
    }
    __vulkan.fullscreen_mutex.unlock();
}

pub fn get_window_state() window.window_state {
    var pwn: win32.WINDOWPLACEMENT = undefined;
    pwn.length = @sizeOf(win32.WINDOWPLACEMENT);
    if (win32.GetWindowPlacement(hWnd, &pwn) == FALSE) system.handle_error2("get_window_state.GetWindowPlacement {d}", .{win32.GetLastError()});
    if (pwn.showCmd == win32.SW_MAXIMIZE) {
        return .Maximized;
    }
    if (pwn.showCmd == win32.SW_MINIMIZE) {
        return .Minimized;
    }
    return .Restore;
}

var fullscreen_mode: win32.DEVMODEA = std.mem.zeroes(win32.DEVMODEA);
var fullscreen_name: [32]u8 = std.mem.zeroes([32]u8);

pub fn __change_fullscreen_mode() void {
    const res = win32.ChangeDisplaySettingsExA(@ptrCast(&fullscreen_name), &fullscreen_mode, null, win32.CDS_FULLSCREEN | win32.CDS_RESET, null);
    if (res != win32.DISP_CHANGE_SUCCESSFUL) {
        system.print("WARN change_fullscreen.ChangeDisplaySettingsExA FAILED Code {d}\n", .{res});
        return;
    }
}

fn change_fullscreen(monitor: *system.monitor_info, resolution: *system.screen_info) void {
    fullscreen_mode.dmSize = @sizeOf(win32.DEVMODEA);
    fullscreen_mode.dmFields = win32.DM_PELSWIDTH | win32.DM_PELSHEIGHT | win32.DM_DISPLAYFREQUENCY;
    fullscreen_mode.dmPelsWidth = resolution.size[0];
    fullscreen_mode.dmPelsHeight = resolution.size[1];
    fullscreen_mode.dmDisplayFrequency = resolution.refleshrate;

    @memcpy(fullscreen_name[0..fullscreen_name.len], monitor.name[0..monitor.name.len]);

    __system.current_monitor = monitor;
    __system.current_resolution = resolution;

    if (__vulkan.VK_EXT_full_screen_exclusive_support and !__vulkan.is_fullscreen_ex) {
        __vulkan.is_fullscreen_ex = true;
    }
}

pub fn set_fullscreen_mode(monitor: *system.monitor_info, resolution: *system.screen_info) void {
    screen_mode = system.screen_mode.FULLSCREEN;
    __vulkan.fullscreen_mutex.lock();
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_STYLE, win32.WS_POPUP);
    _ = win32.SetWindowLongPtrA(hWnd, win32.GWL_EXSTYLE, win32.WS_EX_APPWINDOW | win32.WS_EX_TOPMOST);

    _ = win32.SetWindowPos(hWnd, win32.HWND_TOPMOST, monitor.*.rect.left, monitor.*.rect.top, @intCast(resolution.*.size[0]), @intCast(resolution.*.size[1]), 0);
    _ = win32.ShowWindow(hWnd, win32.SW_MAXIMIZE);

    change_fullscreen(monitor, resolution);
    __vulkan.fullscreen_mutex.unlock();
}

pub fn nanosleep(ns: u64) void {
    const timer = win32.CreateWaitableTimerA(null, TRUE, null) orelse {
        system.print("WARN nanosleep.CreateWaitableTimerA FAILED Code {d}\n", .{win32.GetLastError()});
        std.time.sleep(ns);
        return;
    };

    if (win32.SetWaitableTimer(timer, &win32.LARGE_INTEGER{ .QuadPart = -@as(i64, @intCast(@divTrunc(ns, 100))) }, 0, null, null, FALSE) == FALSE) {
        system.print("WARN nanosleep.SetWaitableTimer FAILED Code {d}\n", .{win32.GetLastError()});
        std.time.sleep(ns);
        return;
    }
    if (win32.WAIT_FAILED == win32.WaitForSingleObject(timer, win32.INFINITE)) {
        system.print("WARN nanosleep.WaitForSingleObject FAILED Code {d}\n", .{win32.GetLastError()});
        std.time.sleep(ns);
        return;
    }
    _ = win32.CloseHandle(timer);
}

//TODO IME 입력 이벤트는 에디트 박스 구현할때 같이 하기
//TODO 터치 이벤트
fn WindowProc(hwnd: HWND, uMsg: u32, wParam: win32.WPARAM, lParam: win32.LPARAM) callconv(WINAPI) win32.LRESULT {
    const S = struct {
        var caps: win32.HIDP_CAPS = undefined;
        var usage: [128]win32.USAGE = undefined;
        var general_state: general_input.INPUT_STATE = undefined;
    };
    switch (uMsg) {
        win32.WM_LBUTTONDOWN => {
            __system.Lmouse_click.store(true, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Lmouse_down_func) != null) system.a_fn(__system.Lmouse_down_func).?(mm);
        },
        win32.WM_MBUTTONDOWN => {
            __system.Mmouse_click.store(true, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Mmouse_down_func) != null) system.a_fn(__system.Mmouse_down_func).?(mm);
        },
        win32.WM_RBUTTONDOWN => {
            __system.Rmouse_click.store(true, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Rmouse_down_func) != null) system.a_fn(__system.Rmouse_down_func).?(mm);
        },
        win32.WM_LBUTTONUP => {
            __system.Lmouse_click.store(false, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Lmouse_up_func) != null) system.a_fn(__system.Lmouse_up_func).?(mm);
        },
        win32.WM_MBUTTONUP => {
            __system.Mmouse_click.store(false, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Mmouse_up_func) != null) system.a_fn(__system.Mmouse_up_func).?(mm);
        },
        win32.WM_RBUTTONUP => {
            __system.Rmouse_click.store(false, std.builtin.AtomicOrder.monotonic);
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.Rmouse_up_func) != null) system.a_fn(__system.Rmouse_up_func).?(mm);
        },
        win32.WM_KEYDOWN => {
            if (wParam < __system.KEY_SIZE) {
                if (!__system.keys[wParam].load(std.builtin.AtomicOrder.monotonic)) {
                    __system.keys[wParam].store(true, std.builtin.AtomicOrder.monotonic);
                    //system.print_debug("input key_down {d}", .{wParam});
                    if (system.a_fn(__system.key_down_func) != null) system.a_fn(__system.key_down_func).?(@enumFromInt(wParam));
                }
            } else {
                system.print("WARN WindowProc WM_KEYDOWN out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, wParam });
            }
        },
        win32.WM_KEYUP => {
            if (wParam < __system.KEY_SIZE) {
                __system.keys[wParam].store(false, std.builtin.AtomicOrder.monotonic);
                //system.print_debug("input key_up {d}", .{wParam});
                if (system.a_fn(__system.key_up_func) != null) system.a_fn(__system.key_up_func).?(@enumFromInt(wParam));
            } else {
                system.print("WARN WindowProc WM_KEYUP out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, wParam });
            }
        },
        win32.WM_KILLFOCUS => {
            for (&__system.keys) |*value| {
                value.*.store(false, std.builtin.AtomicOrder.monotonic);
            }
        },
        win32.WM_INPUT => {
            // var rawinput: win32.RAWINPUT = std.mem.zeroes(win32.RAWINPUT);
            // var unsize: u32 = @sizeOf(win32.RAWINPUT);
            // _ = win32.GetRawInputData(@ptrFromInt(@as(usize, @intCast(lParam))), win32.RID_INPUT, &rawinput, &unsize, @sizeOf(win32.RAWINPUTHEADER));
            // switch (rawinput.header.dwType) {
            //     else => {},
            // }
            {
                var i: usize = 0;
                __raw_input.mutex.lock();
                while (i < __raw_input.list.items.len) : (i += 1) {
                    __raw_input.list.items[i].*.handle_event();
                }
                __raw_input.mutex.unlock();
            }

            if (system.a_fn(__system.general_input_callback) != null) end: {
                var size: u32 = undefined;
                _ = win32.GetRawInputData(@ptrFromInt(@as(usize, @intCast(lParam))), win32.RID_INPUT, null, &size, @sizeOf(win32.RAWINPUTHEADER));
                const inputT: []align(@alignOf(*win32.RAWINPUT)) u8 = __system.allocator.alignedAlloc(u8, @alignOf(*win32.RAWINPUT), size) catch |e| system.handle_error3("alignedAlloc RAWINPUT", e);
                defer __system.allocator.free(inputT);
                const input_: *win32.RAWINPUT = @ptrCast(inputT.ptr);

                if (0 < win32.GetRawInputData(@ptrFromInt(@as(usize, @intCast(lParam))), win32.RID_INPUT, @ptrCast(input_), &size, @sizeOf(win32.RAWINPUTHEADER))) {
                    size = @sizeOf(win32.RID_DEVICE_INFO);
                    var info: win32.RID_DEVICE_INFO = std.mem.zeroes(win32.RID_DEVICE_INFO);
                    info.cbSize = size;
                    if (0 >= win32.GetRawInputDeviceInfoA(input_.*.header.hDevice, win32.RIDI_DEVICEINFO, &info, &size)) break :end;
                    if (info.dwType != 2 or xbox_pad_input.check_vpid(info.D.hid.dwVendorId, info.D.hid.dwProductId)) break :end;

                    _ = win32.GetRawInputDeviceInfoA(input_.*.header.hDevice, win32.RIDI_PREPARSEDDATA, null, &size);
                    const processHeap = win32.GetProcessHeap();
                    const pPreparsedData = win32.HeapAlloc(processHeap, 0, size) orelse break :end;
                    defer _ = win32.HeapFree(processHeap, 0, pPreparsedData);

                    const res = win32.GetRawInputDeviceInfoA(input_.*.header.hDevice, win32.RIDI_PREPARSEDDATA, pPreparsedData, &size);
                    if (res == 0 or res == std.math.maxInt(u32)) break :end;

                    if (win32.HIDP_STATUS_SUCCESS != win32.HidP_GetCaps(pPreparsedData, &S.caps)) break :end;
                    const pButtonCaps: win32.PHIDP_BUTTON_CAPS = @alignCast(@ptrCast(win32.HeapAlloc(
                        processHeap,
                        0,
                        @sizeOf(win32.HIDP_BUTTON_CAPS) * S.caps.NumberInputButtonCaps,
                    ) orelse break :end));
                    defer _ = win32.HeapFree(processHeap, 0, pButtonCaps);

                    var caps_len: win32.USHORT = S.caps.NumberInputButtonCaps;
                    if (win32.HIDP_STATUS_SUCCESS != win32.HidP_GetButtonCaps(
                        win32.HIDP_REPORT_TYPE.HidP_Input,
                        pButtonCaps,
                        &caps_len,
                        pPreparsedData,
                    )) break :end;

                    const pValueCaps: win32.PHIDP_VALUE_CAPS = @alignCast(@ptrCast(win32.HeapAlloc(
                        processHeap,
                        0,
                        @sizeOf(win32.HIDP_VALUE_CAPS) * S.caps.NumberInputValueCaps,
                    ) orelse break :end));
                    defer _ = win32.HeapFree(processHeap, 0, pValueCaps);

                    caps_len = S.caps.NumberInputValueCaps;
                    if (win32.HIDP_STATUS_SUCCESS != win32.HidP_GetValueCaps(
                        win32.HIDP_REPORT_TYPE.HidP_Input,
                        pValueCaps,
                        &caps_len,
                        pPreparsedData,
                    )) break :end;

                    var usage_len: win32.ULONG = pButtonCaps.*.R.Range.UsageMax - pButtonCaps.*.R.Range.UsageMin + 1;
                    if (win32.HIDP_STATUS_SUCCESS != win32.HidP_GetUsages(
                        win32.HIDP_REPORT_TYPE.HidP_Input,
                        pButtonCaps.*.UsagePage,
                        0,
                        &S.usage,
                        &usage_len,
                        pPreparsedData,
                        &input_.*.data.hid.bRawData,
                        input_.*.data.hid.dwSizeHid,
                    )) break :end;

                    S.general_state = std.mem.zeroes(general_input.INPUT_STATE);

                    var i: u32 = 0;
                    while (i < usage_len) : (i += 1) {
                        switch (S.usage[i] - pButtonCaps.*.R.Range.UsageMin) {
                            0 => S.general_state.buttons.Y = true,
                            1 => S.general_state.buttons.B = true,
                            2 => S.general_state.buttons.A = true,
                            3 => S.general_state.buttons.X = true,
                            4 => S.general_state.buttons.LEFT_SHOULDER = true,
                            5 => S.general_state.buttons.RIGHT_SHOULDER = true,
                            6 => S.general_state.left_trigger = 1,
                            7 => S.general_state.right_trigger = 1,
                            8 => S.general_state.buttons.VOLUME_DOWN = true,
                            9 => S.general_state.buttons.VOLUME_UP = true,
                            10 => S.general_state.buttons.LEFT_THUMB = true,
                            11 => S.general_state.buttons.RIGHT_THUMB = true,
                            12 => S.general_state.buttons.START = true,
                            13 => S.general_state.buttons.BACK = true,
                            else => {},
                        }
                    }

                    i = 0;
                    var value: win32.USAGE = undefined;
                    while (i < S.caps.NumberInputValueCaps) : (i += 1) {
                        if (win32.HIDP_STATUS_SUCCESS != win32.HidP_GetUsageValue(
                            win32.HIDP_REPORT_TYPE.HidP_Input,
                            pValueCaps[i].UsagePage,
                            0,
                            pValueCaps[i].R.Range.UsageMin,
                            &value,
                            pPreparsedData,
                            &input_.*.data.hid.bRawData,
                            input_.*.data.hid.dwSizeHid,
                        )) break :end;
                        switch (pValueCaps[i].R.Range.UsageMin) {
                            0x30 => S.general_state.left_thumb_x = (@as(f32, @floatFromInt(value)) / 255 - 0.5) * 2, //x
                            0x31 => S.general_state.left_thumb_y = (@as(f32, @floatFromInt(value)) / 255 - 0.5) * 2, //y
                            0x32 => S.general_state.right_thumb_x = (@as(f32, @floatFromInt(value)) / 255 - 0.5) * 2, //rx
                            0x35 => S.general_state.right_thumb_y = (@as(f32, @floatFromInt(value)) / 255 - 0.5) * 2, //ry
                            //0x36=>,z
                            0x39 => {
                                switch (value) {
                                    0 => S.general_state.buttons.DPAD_UP = true,
                                    1 => {
                                        S.general_state.buttons.DPAD_UP = true;
                                        S.general_state.buttons.DPAD_RIGHT = true;
                                    },
                                    2 => S.general_state.buttons.DPAD_RIGHT = true,
                                    3 => {
                                        S.general_state.buttons.DPAD_RIGHT = true;
                                        S.general_state.buttons.DPAD_DOWN = true;
                                    },
                                    4 => S.general_state.buttons.DPAD_DOWN = true,
                                    5 => {
                                        S.general_state.buttons.DPAD_DOWN = true;
                                        S.general_state.buttons.DPAD_LEFT = true;
                                    },
                                    6 => S.general_state.buttons.DPAD_LEFT = true,
                                    7 => {
                                        S.general_state.buttons.DPAD_LEFT = true;
                                        S.general_state.buttons.DPAD_UP = true;
                                    },
                                    else => {},
                                }
                            }, //dpad
                            else => {},
                        }
                    }
                    S.general_state.handle = input_.*.header.hDevice;
                    __system.general_input_callback.?(S.general_state);
                }
            }
        },
        win32.WM_DEVICECHANGE => {
            var i: usize = 0;
            if (lParam != 0 and (wParam == win32.DBT_DEVICEARRIVAL or wParam == win32.DBT_DEVICEREMOVECOMPLETE)) {
                const hdr: *win32.DEV_BROADCAST_HDR = @as(*win32.DEV_BROADCAST_HDR, @ptrFromInt(@as(usize, @intCast(lParam))));
                if (hdr.*.dbch_devicetype == win32.DBT_DEVTYP_DEVICEINTERFACE) {
                    const dif: *win32.DEV_BROADCAST_DEVICEINTERFACE_A = @ptrCast(hdr);
                    __raw_input.mutex.lock();
                    while (i < __raw_input.list.items.len) : (i += 1) {
                        if (std.mem.eql(
                            u8,
                            @as([*]const u8, @ptrCast(__raw_input.list.items[i].*.guid))[0..@sizeOf(win32.GUID)],
                            @as([*]u8, @ptrCast(&dif.*.dbcc_classguid))[0..@sizeOf(win32.GUID)],
                        )) {
                            const pathT: []const u8 = std.mem.span(@as([*:0]const u8, @ptrCast(&dif.*.dbcc_name)));
                            if (wParam == win32.DBT_DEVICEARRIVAL) {
                                _ = __raw_input.list.items[i].*.connect(pathT);
                            } else if (wParam == win32.DBT_DEVICEREMOVECOMPLETE) {
                                _ = __raw_input.list.items[i].*.disconnect(pathT);
                            }
                        }
                    }
                    __raw_input.mutex.unlock();
                }
            }
        },
        win32.WM_ACTIVATE => {
            const pause = (win32.HIWORD(wParam) != 0);
            const activated = (win32.LOWORD(wParam) != win32.WA_INACTIVE);
            __system.pause.store(pause, std.builtin.AtomicOrder.monotonic);
            __system.activated.store(activated, std.builtin.AtomicOrder.monotonic);

            root.xfit_activate(activated, pause) catch |e| {
                system.handle_error3("xfit_activate", e);
            };
        },
        win32.WM_MOVE => {
            const x: SHORT = @bitCast(win32.LOWORD(lParam));
            const y: SHORT = @bitCast(win32.HIWORD(lParam));
            @atomicStore(i32, &__system.init_set.window_x, x, std.builtin.AtomicOrder.monotonic);
            @atomicStore(i32, &__system.init_set.window_y, y, std.builtin.AtomicOrder.monotonic);

            if (system.a_fn(__system.window_move_func) != null) system.a_fn(__system.window_move_func).?();
        },
        win32.WM_MOUSEMOVE => {
            var mouse_event: win32.TRACKMOUSEEVENT = .{ .cbSize = @sizeOf(win32.TRACKMOUSEEVENT), .dwFlags = win32.TME_HOVER | win32.TME_LEAVE, .hwndTrack = hWnd, .dwHoverTime = 10 };
            if (win32.TrackMouseEvent(&mouse_event) == FALSE) {
                system.print_error("WARN WindowProc.TrackMouseEvent Failed Code : {}\n", .{win32.GetLastError()});
            }
            const mm = input.convert_set_mouse_pos(.{ @floatFromInt(win32.GET_X_LPARAM(lParam)), @floatFromInt(win32.GET_Y_LPARAM(lParam)) });
            if (system.a_fn(__system.mouse_move_func) != null) system.a_fn(__system.mouse_move_func).?(mm);
        },
        // MOUSEMOVE 메시지에서 TrackMouseEvent를 호출하면 호출되는 메시지
        win32.WM_MOUSELEAVE => {
            __system.mouse_out.store(true, std.builtin.AtomicOrder.monotonic);
            if (system.a_fn(__system.mouse_leave_func) != null) system.a_fn(__system.mouse_leave_func).?();
        },
        win32.WM_MOUSEHOVER => {
            __system.mouse_out.store(false, std.builtin.AtomicOrder.monotonic);
            if (system.a_fn(__system.mouse_hover_func) != null) system.a_fn(__system.mouse_hover_func).?();
        },
        win32.WM_MOUSEWHEEL => {
            const dt: i32 = win32.GET_WHEEL_DELTA_WPARAM(wParam);
            __system.mouse_scroll_dt.store(dt, std.builtin.AtomicOrder.monotonic);
            if (system.a_fn(__system.mouse_scroll_func) != null) system.a_fn(__system.mouse_scroll_func).?(dt);
        },
        win32.WM_CLOSE => {
            if (root.xfit_closing() catch |e| {
                system.handle_error3("xfit_closing", e);
            } == false) return 0;
        },
        win32.WM_ERASEBKGND => return 1,
        win32.WM_DESTROY => {
            win32.PostQuitMessage(0);
            __system.exiting.store(true, std.builtin.AtomicOrder.release);
            render_thread_sem.wait();

            __raw_input.destroy();
            return 0;
        },
        else => {},
    }

    return win32.DefWindowProcA(hwnd, uMsg, wParam, lParam);
}

fn MonitorEnumProc(hMonitor: win32.HMONITOR, hdcMonitor: win32.HDC, lprcMonitor: win32.LPRECT, dwData: win32.LPARAM) callconv(WINAPI) BOOL {
    _ = hdcMonitor;
    _ = lprcMonitor;
    _ = dwData;

    var monitor_info: win32.MONITORINFOEXA = undefined;
    monitor_info.monitorInfo.cbSize = @sizeOf(win32.MONITORINFOEXA);

    _ = win32.GetMonitorInfoA(hMonitor, @ptrCast(&monitor_info));

    __system.monitors.append(system.monitor_info{
        .is_primary = false,
        .rect = math.recti.init(0, 0, 0, 0),
        .resolutions = ArrayList(system.screen_info).init(__system.allocator),
        .__hmonitor = hMonitor,
    }) catch |e| system.handle_error3("MonitorEnumProc __system.monitors.append", e);
    var last = &__system.monitors.items[__system.monitors.items.len - 1];
    last.*.is_primary = (monitor_info.monitorInfo.dwFlags & win32.MONITORINFOF_PRIMARY) != 0;
    if (last.*.is_primary) __system.primary_monitor = last;
    last.*.rect = math.recti.init(monitor_info.monitorInfo.rcMonitor.left, monitor_info.monitorInfo.rcMonitor.right, monitor_info.monitorInfo.rcMonitor.top, monitor_info.monitorInfo.rcMonitor.bottom);

    var i: u32 = 0;
    var dm: win32.DEVMODEA = std.mem.zeroes(win32.DEVMODEA);
    dm.dmSize = @sizeOf(win32.DEVMODEA);
    while (win32.EnumDisplaySettingsA(@ptrCast(&monitor_info.szDevice), i, &dm) != FALSE) : (i += 1) {
        last.*.resolutions.append(.{
            .monitor = last,
            .refleshrate = dm.dmDisplayFrequency,
            .size = .{ dm.dmPelsWidth, dm.dmPelsHeight },
        }) catch |e| system.handle_error3("MonitorEnumProc last.*.resolutions.append", e);
    }
    _ = win32.EnumDisplaySettingsA(@ptrCast(&monitor_info.szDevice), win32.ENUM_CURRENT_SETTINGS, &dm);
    last.primary_resolution = null;

    var j: usize = 0;
    while (j < last.resolutions.items.len) : (j += 1) {
        if (dm.dmPelsWidth == last.*.resolutions.items[j].size[0] and dm.dmPelsHeight == last.resolutions.items[j].size[1] and dm.dmDisplayFrequency == last.resolutions.items[j].refleshrate) {
            last.*.primary_resolution = &last.*.resolutions.items[j];
            break;
        }
    }
    if (last.*.primary_resolution == null) {
        system.print("WARN can't find primary_resolution.\n", .{});
        last.*.primary_resolution = &last.*.resolutions.items[last.resolutions.items.len - 1];
    }
    std.mem.copyForwards(u8, &last.*.name, &monitor_info.szDevice);

    return TRUE;
}
