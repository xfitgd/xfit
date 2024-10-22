const std = @import("std");
const expect = std.testing.expect;

const root = @import("root");
const math = @import("math.zig");
const point = math.point;
const input = @import("input.zig");
const __vulkan = @import("__vulkan.zig");
const vk = __vulkan.vk;
const __vulkan_allocator = @import("__vulkan_allocator.zig");

const system = @import("system.zig");
const general_input = @import("general_input.zig");
const raw_input = @import("raw_input.zig");
const __system = @import("__system.zig");

pub const c_allocator = std.heap.c_allocator;

pub const android = @import("include/android.zig");

pub var orientationChanged: bool = false;

inline fn LOGI(fmt: [*c]const u8, args: anytype) c_int {
    return @call(.auto, android.__android_log_print, .{ android.ANDROID_LOG_INFO, "xfit", fmt } ++ args);
}
pub inline fn LOGE(fmt: [*c]const u8, args: anytype) c_int {
    return @call(.auto, android.__android_log_print, .{ android.ANDROID_LOG_ERROR, "xfit", fmt } ++ args);
}
inline fn LOGW(fmt: [*c]const u8, args: anytype) c_int {
    return @call(.auto, android.__android_log_print, .{ android.ANDROID_LOG_WARN, "xfit", fmt } ++ args);
}
pub inline fn LOGV(fmt: [*c]const u8, args: anytype) c_int {
    return @call(.auto, android.__android_log_print, .{ android.ANDROID_LOG_VERBOSE, "xfit", fmt } ++ args);
}
pub inline fn LOGD(fmt: [*c]const u8, args: anytype) c_int {
    return @call(.auto, android.__android_log_print, .{ android.ANDROID_LOG_DEBUG, "xfit", fmt } ++ args);
}

const LooperEvent = enum(i32) {
    LOOPER_ID_MAIN = 1,
    LOOPER_ID_INPUT = 2,
    LOOPER_ID_USER = 3,
};

const AppEvent = enum(i8) {
    APP_CMD_INPUT_CHANGED,
    APP_CMD_INIT_WINDOW,
    APP_CMD_TERM_WINDOW,
    APP_CMD_WINDOW_RESIZED,
    APP_CMD_WINDOW_REDRAW_NEEDED,
    APP_CMD_CONTENT_RECT_CHANGED,
    APP_CMD_GAINED_FOCUS,
    APP_CMD_LOST_FOCUS,
    APP_CMD_CONFIG_CHANGED,
    APP_CMD_LOW_MEMORY,
    APP_CMD_START,
    APP_CMD_RESUME,
    APP_CMD_SAVE_STATE,
    APP_CMD_PAUSE,
    APP_CMD_STOP,
    APP_CMD_DESTROY,
};

const android_poll_source = struct {
    id: i32,
    process: ?*const fn (?*android_poll_source) void,
};

const android_app = struct {
    userdata: ?*anyopaque = null,
    on_app_cmd: ?*const fn (AppEvent) void = null,
    on_input_event: ?*const fn (?*android.AInputEvent) i32 = null,
    activity: ?*android.ANativeActivity = null,
    config: ?*android.AConfiguration = null,
    //savedState: ?[]u8 = null,
    //savedStateSize: usize = 0,
    looper: ?*android.ALooper = null,
    input_queue: ?*android.AInputQueue = null,
    window: ?*android.ANativeWindow = null,
    contentRect: android.ARect = std.mem.zeroes(android.ARect),
    activityState: AppEvent = AppEvent.APP_CMD_INPUT_CHANGED,
    destroryRequested: bool = false,
    msgread: i32 = 0,
    msgwrite: i32 = 0,

    cache_dir: ?[]u8 = null,

    cmd_poll_source: android_poll_source = std.mem.zeroes(android_poll_source),
    input_poll_source: android_poll_source = std.mem.zeroes(android_poll_source),

    running: bool = false,
    stateSaved: bool = false,
    destroyed: bool = false,
    pendingInputQueue: ?*android.AInputQueue = null,
    pendingWindow: ?*android.ANativeWindow = null,
    pendingContentRect: android.ARect = std.mem.zeroes(android.ARect),

    thread: std.Thread = undefined,
    mutex: std.Thread.Mutex = .{},
    cond: std.Thread.Condition = .{},

    sensor_manager: ?*android.ASensorManager = null,
    accelerometer_sensor: ?*const android.ASensor = null,
    sensor_event_queue: ?*android.ASensorEventQueue = null,

    width: i32 = 0,
    height: i32 = 0,

    inited: bool = false,
    paused: bool = false,
};

pub var app: android_app = .{};

pub fn get_AssetManager() ?*android.AAssetManager {
    return app.activity.?.*.assetManager;
}

pub fn vulkan_android_start(vkInstance: __vulkan.vk.VkInstance, vkSurface: *__vulkan.vk.VkSurfaceKHR) void {
    if (vkSurface.* != null) {
        __vulkan.vk.vkDestroySurfaceKHR(@ptrCast(vkInstance), @as(*__vulkan.vk.VkSurfaceKHR, @ptrCast(vkSurface)).*, null);
    }
    const androidSurfaceCreateInfo: __vulkan.vk.VkAndroidSurfaceCreateInfoKHR = .{ .window = @ptrCast(app.window), .flags = 0 };
    const result = __vulkan.vk.vkCreateAndroidSurfaceKHR(@ptrCast(vkInstance), &androidSurfaceCreateInfo, null, @ptrCast(vkSurface));

    system.handle_error(result == __vulkan.vk.VK_SUCCESS, "vkCreateAndroidSurfaceKHR code : {d}", .{result});
}

fn destroy_android() void {
    __vulkan.wait_device_idle();
    __vulkan_allocator.execute_and_wait_all_op();

    root.xfit_destroy() catch |e| {
        system.handle_error3("xfit_destroy", e);
    };
    __vulkan.vulkan_destroy();

    __system.destroy();
}

fn android_app_write_cmd(cmd: AppEvent) void {
    const _cmd = [_]i8{@intFromEnum(cmd)};
    _ = std.posix.write(app.msgwrite, @ptrCast(&_cmd)) catch |e| system.print_error("android_app_write_cmd std.posix.write error:{}, cmd:{d}\n", .{ e, _cmd[0] });
}

fn onConfigurationChanged(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    if (system.dbg) _ = LOGV("ConfigurationChanged: %p", .{_activity});
    android_app_write_cmd(AppEvent.APP_CMD_CONFIG_CHANGED);
}
pub fn get_device_width() u32 {
    const width = android.ANativeWindow_getWidth(app.window);
    return @max(0, width);
}
pub fn get_device_height() u32 {
    const height = android.ANativeWindow_getHeight(app.window);
    return @max(0, height);
}
pub fn get_cache_dir() []const u8 {
    return app.cache_dir orelse blk: {
        system.print_error("WARN get_cache_dir null\n", .{});
        break :blk "";
    };
}
pub fn get_file_dir() []const u8 {
    if (app.activity.?.*.internalDataPath == null) system.handle_error_msg2("get_file_dir null");
    return app.activity.?.*.internalDataPath[0..std.mem.len(app.activity.?.*.internalDataPath)];
}

fn onSaveInstanceState(_activity: [*c]android.ANativeActivity, _out_len: [*c]usize) callconv(.C) ?*anyopaque {
    if (system.dbg) _ = LOGV("SaveInstanceState: %p", .{_activity});
    _ = _out_len;
    // var savedState: ?*anyopaque = null;

    // app.mutex.lock();
    // app.stateSaved = false;
    // android_app_write_cmd(AppEvent.APP_CMD_SAVE_STATE);
    // while (!app.stateSaved) {
    //     app.cond.wait(&app.mutex);
    // }
    // if (app.savedState != null) {
    //     savedState = @ptrCast(app.savedState);
    //     _out_len.* = app.savedStateSize;
    //     app.savedState = null;
    //     app.savedStateSize = 0;
    // }
    // app.mutex.unlock();

    return null;
}
fn onContentRectChanged(_activity: [*c]android.ANativeActivity, _rect: [*c]const android.ARect) callconv(.C) void {
    _ = _activity;
    if (system.dbg) _ = LOGV("ContentRectChanged: l=%d,t=%d,r=%d,b=%d", .{ _rect.*.left, _rect.*.top, _rect.*.right, _rect.*.bottom });

    app.mutex.lock();
    app.contentRect = _rect.*;
    app.mutex.unlock();

    android_app_write_cmd(AppEvent.APP_CMD_CONTENT_RECT_CHANGED);
}
fn android_app_free() void {
    app.mutex.lock();
    android_app_write_cmd(AppEvent.APP_CMD_DESTROY);
    while (!app.destroyed) {
        app.cond.wait(&app.mutex);
    }
    app.mutex.unlock();

    std.posix.close(app.msgread);
    std.posix.close(app.msgwrite);
}
fn android_app_set_activity_state(_cmd: AppEvent) void {
    app.mutex.lock();
    android_app_write_cmd(_cmd);
    while (app.activityState != _cmd) {
        app.cond.wait(&app.mutex);
    }
    app.mutex.unlock();
}
fn android_app_set_input(_queue: ?*android.AInputQueue) void {
    app.mutex.lock();
    app.pendingInputQueue = _queue;

    android_app_write_cmd(AppEvent.APP_CMD_INPUT_CHANGED);
    while (app.input_queue != app.pendingInputQueue) {
        app.cond.wait(&app.mutex);
    }
    app.mutex.unlock();
}
fn android_app_set_window(_window: ?*android.ANativeWindow) void {
    app.mutex.lock();
    if (app.pendingWindow != null) {
        android_app_write_cmd(AppEvent.APP_CMD_TERM_WINDOW);
    }
    app.pendingWindow = _window;
    if (_window != null) {
        android_app_write_cmd(AppEvent.APP_CMD_INIT_WINDOW);
    }
    while (app.window != app.pendingWindow) {
        app.cond.wait(&app.mutex);
    }
    app.mutex.unlock();
}
fn print_cur_config() void {
    var lang = [2]u8{ 0, 0 };
    var country = [2]u8{ 0, 0 };
    android.AConfiguration_getLanguage(app.config, @ptrCast(&lang));
    android.AConfiguration_getCountry(app.config, @ptrCast(&country));

    _ = LOGV("Config: mcc=%d mnc=%d lang=%c%c cnt=%c%c orien=%d touch=%d dens=%d keys=%d nav=%d keysHid=%d navHid=%d sdk=%d size=%d long=%d modetype=%d modenight=%d", .{
        android.AConfiguration_getMcc(app.config),
        android.AConfiguration_getMnc(app.config),
        lang[0],
        lang[1],
        country[0],
        country[1],
        android.AConfiguration_getOrientation(app.config),
        android.AConfiguration_getTouchscreen(app.config),
        android.AConfiguration_getDensity(app.config),
        android.AConfiguration_getKeyboard(app.config),
        android.AConfiguration_getNavigation(app.config),
        android.AConfiguration_getKeysHidden(app.config),
        android.AConfiguration_getNavHidden(app.config),
        android.AConfiguration_getSdkVersion(app.config),
        android.AConfiguration_getScreenSize(app.config),
        android.AConfiguration_getScreenLong(app.config),
        android.AConfiguration_getUiModeType(app.config),
        android.AConfiguration_getUiModeNight(app.config),
    });
}

fn onDestroy(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    // if (system.dbg) _ = LOGV("Destroy: %p", .{_activity});
    android_app_free();
}
fn onInputQueueCreated(_activity: [*c]android.ANativeActivity, _queue: ?*android.AInputQueue) callconv(.C) void {
    _ = _activity;
    // if (system.dbg) _ = LOGV("InputQueueCreated: %p -- %p", .{ _activity, _queue });
    android_app_set_input(_queue);
}
fn onInputQueueDestroyed(_activity: [*c]android.ANativeActivity, _queue: ?*android.AInputQueue) callconv(.C) void {
    _ = _activity;
    _ = _queue;
    //if (system.dbg) _ = LOGV("InputQueueDestroyed: %p -- %p", .{ _activity, _queue });
    android_app_set_input(null);
}
fn onLowMemory(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("LowMemory: %p", .{_activity});
    android_app_write_cmd(AppEvent.APP_CMD_LOW_MEMORY);
}
fn onNativeWindowCreated(_activity: [*c]android.ANativeActivity, _window: ?*android.ANativeWindow) callconv(.C) void {
    //if (system.dbg) _ = LOGV("NativeWindowCreated: %p -- %p", .{ _activity, _window });
    _ = _activity;
    android_app_set_window(_window);
}
fn onNativeWindowDestroyed(_activity: [*c]android.ANativeActivity, _window: ?*android.ANativeWindow) callconv(.C) void {
    _ = _activity;
    _ = _window;
    //if (system.dbg) _ = LOGV("NativeWindowDestroyed: %p -- %p", .{ _activity, _window });
    android_app_set_window(null);
}
fn onNativeWindowRedrawNeeded(_activity: [*c]android.ANativeActivity, _window: ?*android.ANativeWindow) callconv(.C) void {
    _ = _activity;
    _ = _window;
    // if (system.dbg) _ = LOGV("NativeWindowRedrawNeeded: %p -- %p", .{ _activity, _window });
    android_app_write_cmd(AppEvent.APP_CMD_WINDOW_REDRAW_NEEDED);
}
fn onNativeWindowResized(_activity: [*c]android.ANativeActivity, _window: ?*android.ANativeWindow) callconv(.C) void {
    _ = _activity;
    _ = _window;
    //if (system.dbg) _ = LOGV("NativeWindowRedrawNeeded: %p -- %p", .{ _activity, _window });
    android_app_write_cmd(AppEvent.APP_CMD_WINDOW_RESIZED);
}
fn onPause(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("Pause: %p", .{_activity});
    android_app_set_activity_state(AppEvent.APP_CMD_PAUSE);
}
fn onResume(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("Resume: %p", .{_activity});
    android_app_set_activity_state(AppEvent.APP_CMD_RESUME);
}
fn onStart(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("Start: %p", .{_activity});
    android_app_set_activity_state(AppEvent.APP_CMD_START);
}
fn onStop(_activity: [*c]android.ANativeActivity) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("Stop: %p", .{_activity});
    android_app_set_activity_state(AppEvent.APP_CMD_STOP);
}
fn onWindowFocusChanged(_activity: [*c]android.ANativeActivity, _focused: i32) callconv(.C) void {
    _ = _activity;
    //if (system.dbg) _ = LOGV("NativeWindowRedrawNeeded: %p -- %d", .{ _activity, _focused });
    android_app_write_cmd(if (_focused != 0) AppEvent.APP_CMD_GAINED_FOCUS else AppEvent.APP_CMD_LOST_FOCUS);
}

fn android_app_read_cmd() u8 {
    var cmd = [1]u8{0};
    cmd[0] = 0;
    if (std.posix.read(app.msgread, &cmd) catch unreachable != @sizeOf(u8)) {
        _ = LOGE("No data on command pipe!", .{});
        return 255;
    }
    if (cmd[0] == @intFromEnum(AppEvent.APP_CMD_SAVE_STATE)) {
        free_saved_state();
    }
    return cmd[0];
}

fn android_app_pre_exec_cmd(_cmd: u8) void {
    switch (@as(AppEvent, @enumFromInt(_cmd))) {
        AppEvent.APP_CMD_INPUT_CHANGED => {
            if (system.dbg) _ = LOGV("APP_CMD_INPUT_CHANGED", .{});
            app.mutex.lock();
            if (app.input_queue != null) {
                android.AInputQueue_detachLooper(app.input_queue);
            }
            app.input_queue = app.pendingInputQueue;
            if (app.input_queue != null) {
                if (system.dbg) _ = LOGV("Attaching input queue to looper", .{});
                android.AInputQueue_attachLooper(app.input_queue, app.looper, @intFromEnum(LooperEvent.LOOPER_ID_INPUT), null, &app.input_poll_source);
            }
            app.cond.broadcast();
            app.mutex.unlock();
        },
        AppEvent.APP_CMD_INIT_WINDOW => {
            if (system.dbg) _ = LOGV("APP_CMD_INIT_WINDOW", .{});
            app.mutex.lock();
            app.window = app.pendingWindow;
            app.cond.broadcast();
            app.mutex.unlock();
        },
        AppEvent.APP_CMD_TERM_WINDOW => {
            if (system.dbg) _ = LOGV("APP_CMD_TERM_WINDOW", .{});
            app.cond.broadcast();
        },
        AppEvent.APP_CMD_RESUME, AppEvent.APP_CMD_START, AppEvent.APP_CMD_PAUSE, AppEvent.APP_CMD_STOP => {
            if (system.dbg) _ = LOGV("activityState=%d", .{_cmd});
            app.mutex.lock();
            app.activityState = @enumFromInt(_cmd);
            app.cond.broadcast();
            app.mutex.unlock();
        },
        AppEvent.APP_CMD_CONFIG_CHANGED => {
            if (system.dbg) _ = LOGV("APP_CMD_CONFIG_CHANGED", .{});
            android.AConfiguration_fromAssetManager(app.config, app.activity.?.*.assetManager);
            print_cur_config();
        },
        AppEvent.APP_CMD_DESTROY => {
            if (system.dbg) _ = LOGV("APP_CMD_DESTROY", .{});
            @atomicStore(bool, &app.destroryRequested, true, .monotonic);
        },
        else => {},
    }
}

fn android_app_post_exec_cmd(_cmd: u8) void {
    switch (@as(AppEvent, @enumFromInt(_cmd))) {
        AppEvent.APP_CMD_TERM_WINDOW => {
            if (system.dbg) _ = LOGV("APP_CMD_TERM_WINDOW", .{});
            app.mutex.lock();
            app.window = null;
            app.cond.broadcast();
            app.mutex.unlock();
        },
        AppEvent.APP_CMD_SAVE_STATE => {
            if (system.dbg) _ = LOGV("APP_CMD_SAVE_STATE", .{});
            app.mutex.lock();
            app.stateSaved = true;
            app.cond.broadcast();
            app.mutex.unlock();
        },
        AppEvent.APP_CMD_RESUME => {
            free_saved_state();
        },
        else => {},
    }
}

fn free_saved_state() void {
    // app.mutex.lock();
    // if (app.savedState != null) {
    //     c_allocator.free(@as(?[]u8, @ptrCast(app.savedState)).?);
    //     app.savedState = null;
    //     app.savedStateSize = 0;
    // }
    // app.mutex.unlock();
}

fn process_cmd(_source: ?*android_poll_source) void {
    _ = _source;

    const cmd: u8 = android_app_read_cmd();
    android_app_pre_exec_cmd(cmd);
    if (app.on_app_cmd != null) app.on_app_cmd.?(@enumFromInt(cmd));
    android_app_post_exec_cmd(cmd);
}
fn process_input(_source: ?*android_poll_source) void {
    _ = _source;
    var event: ?*android.AInputEvent = null;
    while (android.AInputQueue_getEvent(app.input_queue, &event) >= 0) {
        if (android.AInputQueue_preDispatchEvent(app.input_queue, event) != 0) {
            continue;
        }
        var handled: c_int = 0;
        if (app.on_input_event != null) handled = app.on_input_event.?(event);
        android.AInputQueue_finishEvent(app.input_queue, event, handled);
    }
}

fn engine_handle_cmd(_cmd: AppEvent) void {
    switch (_cmd) {
        AppEvent.APP_CMD_SAVE_STATE => {
            // app.savedStateSize = @sizeOf(saved_state);
            // app.savedState = @as([*]u8, @ptrCast(c_allocator.alloc(u8, app.savedStateSize) catch |e| system.handle_error3("engine_handle_cmd c_allocator.alloc app.savedState", e)))[0..app.savedStateSize];
            // @memcpy(app.savedState.?, std.mem.asBytes(&app.savedata));
        },
        AppEvent.APP_CMD_INIT_WINDOW => {
            if (app.window != null) {
                if (!app.inited) {
                    //세로일 경우 원래대로?
                    root.main();

                    __vulkan_allocator.execute_and_wait_all_op();
                    app.inited = true;
                } else {
                    orientationChanged = true;
                }
            }
        },
        AppEvent.APP_CMD_TERM_WINDOW => {},
        AppEvent.APP_CMD_GAINED_FOCUS => {
            if (app.accelerometer_sensor != null) {
                _ = android.ASensorEventQueue_enableSensor(app.sensor_event_queue, app.accelerometer_sensor);
                _ = android.ASensorEventQueue_setEventRate(app.sensor_event_queue, app.accelerometer_sensor, (1000 / 60) * 1000);
            }
            app.paused = false;
            __system.pause.store(false, std.builtin.AtomicOrder.monotonic);
            __system.activated.store(false, std.builtin.AtomicOrder.monotonic);
            root.xfit_activate(false, false) catch |e| {
                system.handle_error3("xfit_activate", e);
            };
        },
        AppEvent.APP_CMD_LOST_FOCUS => {
            if (app.accelerometer_sensor != null) {
                _ = android.ASensorEventQueue_disableSensor(app.sensor_event_queue, app.accelerometer_sensor);
            }
            app.paused = true;
            __system.pause.store(true, std.builtin.AtomicOrder.monotonic);
            __system.activated.store(true, std.builtin.AtomicOrder.monotonic);
            root.xfit_activate(true, true) catch |e| {
                system.handle_error3("xfit_activate", e);
            };
        },
        AppEvent.APP_CMD_WINDOW_RESIZED => {
            var prop: vk.VkSurfaceCapabilitiesKHR = undefined;
            _ = vk.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(__vulkan.vk_physical_device, __vulkan.vkSurface, &prop);
            if (prop.currentExtent.width != __vulkan.vkExtent.width or prop.currentExtent.height != __vulkan.vkExtent.height) {
                orientationChanged = true;
            }
        },
        else => {},
    }
}

var input_state: general_input.INPUT_STATE = std.mem.zeroes(general_input.INPUT_STATE);

fn handle_input_buttons(_event: ?*android.AInputEvent, keycode: u32, updown: bool) bool {
    if (system.a_fn(__system.general_input_callback) == null) return false;
    switch (keycode) {
        android.AKEYCODE_BUTTON_A => {
            if (input_state.buttons.A and updown) return false;
            input_state.buttons.A = updown;
        },
        android.AKEYCODE_BUTTON_B => {
            if (input_state.buttons.B and updown) return false;
            input_state.buttons.B = updown;
        },
        android.AKEYCODE_BUTTON_X => {
            if (input_state.buttons.X and updown) return false;
            input_state.buttons.X = updown;
        },
        android.AKEYCODE_BUTTON_Y => {
            if (input_state.buttons.Y and updown) return false;
            input_state.buttons.Y = updown;
        },
        android.AKEYCODE_BUTTON_START => {
            if (input_state.buttons.START and updown) return false;
            input_state.buttons.START = updown;
        },
        android.AKEYCODE_BUTTON_SELECT => {
            if (input_state.buttons.BACK and updown) return false;
            input_state.buttons.BACK = updown;
        },
        android.AKEYCODE_BUTTON_L1 => {
            if (input_state.buttons.LEFT_SHOULDER and updown) return false;
            input_state.buttons.LEFT_SHOULDER = updown;
        },
        android.AKEYCODE_BUTTON_R1 => {
            if (input_state.buttons.RIGHT_SHOULDER and updown) return false;
            input_state.buttons.RIGHT_SHOULDER = updown;
        },
        android.AKEYCODE_BUTTON_THUMBL => {
            if (input_state.buttons.LEFT_THUMB and updown) return false;
            input_state.buttons.LEFT_THUMB = updown;
        },
        android.AKEYCODE_BUTTON_THUMBR => {
            if (input_state.buttons.RIGHT_THUMB and updown) return false;
            input_state.buttons.RIGHT_THUMB = updown;
        },
        android.AKEYCODE_VOLUME_UP => {
            if (input_state.buttons.VOLUME_UP and updown) return false;
            input_state.buttons.VOLUME_UP = updown;
        },
        android.AKEYCODE_VOLUME_DOWN => {
            if (input_state.buttons.VOLUME_DOWN and updown) return false;
            input_state.buttons.VOLUME_DOWN = updown;
        },
        else => return false,
    }
    input_state.handle = @ptrFromInt(@as(usize, @intCast(android.AInputEvent_getDeviceId(_event))));
    system.a_fn(__system.general_input_callback).?(input_state);
    return true;
}

fn engine_handle_input(_event: ?*android.AInputEvent) i32 {
    const evt = android.AInputEvent_getType(_event);
    const src = android.AInputEvent_getSource(_event);

    if (evt == android.AINPUT_EVENT_TYPE_MOTION) {
        const tool_type = android.AMotionEvent_getToolType(_event, 0);
        //https://github.com/gameplay3d/GamePlay/blob/master/gameplay/src/PlatformAndroid.cpp
        if ((src & android.AINPUT_SOURCE_JOYSTICK) != 0) {
            if (system.a_fn(__system.general_input_callback) != null) {
                const xaxis = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_HAT_X, 0);
                const yaxis = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_HAT_Y, 0);

                const left_trigger = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_BRAKE, 0);
                const right_trigger = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_GAS, 0);

                const x = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_X, 0);
                const y = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_Y, 0);

                const z = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_Z, 0);
                const rz = android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_RZ, 0);

                if (xaxis == -1.0) {
                    input_state.buttons.DPAD_LEFT = true;
                    input_state.buttons.DPAD_RIGHT = false;
                } else if (xaxis == 1.0) {
                    input_state.buttons.DPAD_LEFT = false;
                    input_state.buttons.DPAD_RIGHT = true;
                } else {
                    input_state.buttons.DPAD_LEFT = false;
                    input_state.buttons.DPAD_RIGHT = false;
                }

                if (yaxis == -1.0) {
                    input_state.buttons.DPAD_UP = true;
                    input_state.buttons.DPAD_DOWN = false;
                } else if (yaxis == 1.0) {
                    input_state.buttons.DPAD_UP = false;
                    input_state.buttons.DPAD_DOWN = true;
                } else {
                    input_state.buttons.DPAD_UP = false;
                    input_state.buttons.DPAD_DOWN = false;
                }

                input_state.left_trigger = left_trigger;
                input_state.right_trigger = right_trigger;

                input_state.left_thumb_x = x;
                input_state.left_thumb_y = y;

                input_state.right_thumb_x = z;
                input_state.right_thumb_y = rz;

                input_state.handle = @ptrFromInt(@as(usize, @intCast(android.AInputEvent_getDeviceId(_event))));

                system.a_fn(__system.general_input_callback).?(input_state);
            }
        } else {
            var count: u32 = undefined;
            if (tool_type == android.AMOTION_EVENT_TOOL_TYPE_MOUSE) {
                count = 1;
                const act = android.AMotionEvent_getAction(_event);
                var mm = point{ android.AMotionEvent_getX(_event, 0), android.AMotionEvent_getY(_event, 0) };
                mm = input.convert_set_mouse_pos(mm);

                if (system.a_fn(__system.mouse_move_func) != null) system.a_fn(__system.mouse_move_func).?(mm);
                switch (act & android.AMOTION_EVENT_ACTION_MASK) {
                    android.AMOTION_EVENT_ACTION_DOWN => {
                        if (system.a_fn(__system.Lmouse_down_func) != null) system.a_fn(__system.Lmouse_down_func).?(mm);
                    },
                    android.AMOTION_EVENT_ACTION_UP => {
                        if (system.a_fn(__system.Lmouse_up_func) != null) system.a_fn(__system.Lmouse_up_func).?(mm);
                    },
                    android.AMOTION_EVENT_ACTION_SCROLL => {
                        const dt: i32 = @intFromFloat(android.AMotionEvent_getAxisValue(_event, android.AMOTION_EVENT_AXIS_VSCROLL, 0) * 100);
                        __system.mouse_scroll_dt.store(dt, std.builtin.AtomicOrder.monotonic);
                        if (system.a_fn(__system.mouse_scroll_func) != null) system.a_fn(__system.mouse_scroll_func).?(dt);
                    },
                    else => {},
                }
                return 1;
            } else if (tool_type == android.AMOTION_EVENT_TOOL_TYPE_FINGER) {
                count = @min(100, android.AMotionEvent_getPointerCount(_event));
            } else return 0;
            const poses = __system.allocator.alloc(point, count) catch system.handle_error_msg2("engine_handle_input alloc poses");
            defer __system.allocator.free(poses);
            var i: u32 = 0;
            while (i < poses.len) : (i += 1) {
                poses[i][0] = android.AMotionEvent_getX(_event, i);
                poses[i][1] = android.AMotionEvent_getY(_event, i);

                poses[i] = input.convert_mouse_pos(poses[i]);
            }
            @atomicStore(f32, &__system.cursor_pos[0], poses[0][0], std.builtin.AtomicOrder.monotonic);
            @atomicStore(f32, &__system.cursor_pos[1], poses[0][1], std.builtin.AtomicOrder.monotonic);

            const act = android.AMotionEvent_getAction(_event);
            switch (act & android.AMOTION_EVENT_ACTION_MASK) {
                android.AMOTION_EVENT_ACTION_DOWN => {
                    //if (system.a_fn(__system.Lmouse_down_func) != null) system.a_fn(__system.Lmouse_down_func).?(poses[0]);
                    if (system.a_fn(__system.touch_down_func) != null) system.a_fn(__system.touch_down_func).?(0, poses[0]);
                },
                android.AMOTION_EVENT_ACTION_UP => {
                    //if (system.a_fn(__system.Lmouse_up_func) != null) system.a_fn(__system.Lmouse_up_func).?(poses[0]);
                    if (system.a_fn(__system.touch_up_func) != null) system.a_fn(__system.touch_up_func).?(0, poses[0]);
                },
                android.AMOTION_EVENT_ACTION_POINTER_DOWN => {
                    const pointer_id: u32 = @max(0, @min(9, (act & android.AMOTION_EVENT_ACTION_POINTER_INDEX_MASK) >> android.AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT));
                    if (pointer_id < count) {
                        if (system.a_fn(__system.touch_down_func) != null) system.a_fn(__system.touch_down_func).?(pointer_id, poses[pointer_id]);
                    } else {
                        @branchHint(.unlikely);
                        system.print("WARN engine_handle_input AMOTION_EVENT_ACTION_POINTER_DOWN out of range poses[{d}] value : {d}\n", .{ count, pointer_id });
                        return 0;
                    }
                },
                android.AMOTION_EVENT_ACTION_POINTER_UP => {
                    const pointer_id: u32 = @max(0, @min(9, (act & android.AMOTION_EVENT_ACTION_POINTER_INDEX_MASK) >> android.AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT));
                    if (system.a_fn(__system.touch_up_func) != null) system.a_fn(__system.touch_up_func).?(pointer_id, poses[pointer_id]);
                },
                else => {},
            }
        }
        return 1;
    } else if (evt == android.AINPUT_EVENT_TYPE_KEY) {
        const act = android.AKeyEvent_getAction(_event);
        const keycode: u32 = @max(0, android.AKeyEvent_getKeyCode(_event));
        if (act == android.AKEY_EVENT_ACTION_DOWN) {
            if ((src & android.AINPUT_SOURCE_JOYSTICK) != 0 or (src & android.AINPUT_SOURCE_GAMEPAD) != 0) {
                if (handle_input_buttons(_event, keycode, true)) return 1;
            }
            if (keycode < __system.KEY_SIZE) {
                if (!__system.keys[keycode].load(std.builtin.AtomicOrder.monotonic)) {
                    __system.keys[keycode].store(true, std.builtin.AtomicOrder.monotonic);
                    //system.print_debug("input key_down {d}", .{keycode});
                    if (system.a_fn(__system.key_down_func) != null) system.a_fn(__system.key_down_func).?(@enumFromInt(keycode));
                }
            } else {
                @branchHint(.unlikely);
                system.print("WARN engine_handle_input AKEY_EVENT_ACTION_DOWN out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keycode });
                return 0;
            }
        } else if (act == android.AKEY_EVENT_ACTION_UP) {
            if ((src & android.AINPUT_SOURCE_CLASS_JOYSTICK) != 0 or (src & android.AINPUT_SOURCE_GAMEPAD) != 0) {
                if (handle_input_buttons(_event, keycode, true)) return 1;
            }
            if (keycode < __system.KEY_SIZE) {
                __system.keys[keycode].store(false, std.builtin.AtomicOrder.monotonic);
                //system.print_debug("input key_up {d}", .{keycode});
                if (system.a_fn(__system.key_up_func) != null) system.a_fn(__system.key_up_func).?(@enumFromInt(keycode));
            } else {
                @branchHint(.unlikely);
                system.print("WARN engine_handle_input AKEY_EVENT_ACTION_UP out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keycode });
                return 0;
            }
        } else {
            if (keycode < __system.KEY_SIZE) {
                const cnt = android.AKeyEvent_getRepeatCount(_event);
                var i: i32 = 0;
                while (i < cnt) : (i += 1) {
                    //system.print_debug("input key_multiple({d}) {d}", .{ i, keycode });
                    if (system.a_fn(__system.key_down_func) != null) system.a_fn(__system.key_down_func).?(@enumFromInt(keycode));
                    if (system.a_fn(__system.key_up_func) != null) system.a_fn(__system.key_up_func).?(@enumFromInt(keycode));
                }
            } else {
                @branchHint(.unlikely);
                system.print("WARN engine_handle_input AKEY_EVENT_ACTION_MULTIPLE out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, keycode });
                return 0;
            }
        }
        return 1;
    }
    return 0;
}

fn AcquireASensorManagerInstance() ?*android.ASensorManager {
    var env: [*c]android.JNIEnv = null;
    _ = app.activity.?.*.vm.*.*.AttachCurrentThread.?(app.activity.?.*.vm, &env, null);

    const android_content_context = env.*.*.GetObjectClass.?(env, app.activity.?.*.clazz);
    const mid_get_package_name = env.*.*.GetMethodID.?(env, android_content_context, "getPackageName", "()Ljava/lang/String;");
    const package_name: android.jstring = env.*.*.CallObjectMethod.?(env, app.activity.?.*.clazz, mid_get_package_name);

    const native_package_name = env.*.*.GetStringUTFChars.?(env, package_name, null);
    const mgr = android.ASensorManager_getInstanceForPackage(native_package_name);

    env.*.*.ReleaseStringUTFChars.?(env, package_name, native_package_name);
    _ = app.activity.?.*.vm.*.*.DetachCurrentThread.?(app.activity.?.*.vm);

    if (mgr != null) return mgr;
    return android.ASensorManager_getInstance();
}

fn OnSensorEvent(fd: c_int, events: c_int, data: ?*anyopaque) callconv(.C) c_int {
    _ = fd;
    _ = events;
    _ = data;

    var event: android.ASensorEvent = undefined;
    while (android.ASensorEventQueue_getEvents(app.sensor_event_queue, &event, 1) > 0) {
        // _ = LOGI("accelerometer: x=%f y=%f z=%f", .{ event.unnamed_0.unnamed_0.acceleration.unnamed_0.unnamed_0.x, event.unnamed_0.unnamed_0.acceleration.unnamed_0.unnamed_0.y, event.unnamed_0.unnamed_0.acceleration.unnamed_0.unnamed_0.z });
    }

    // From the docs:
    //
    // Implementations should return 1 to continue receiving callbacks, or 0 to
    // have this file descriptor and callback unregistered from the looper.
    return 1;
}

fn set_cache_path() void {
    var env: [*c]android.JNIEnv = null;
    _ = app.activity.?.*.vm.*.*.AttachCurrentThread.?(app.activity.?.*.vm, &env, null);

    const android_content_context = env.*.*.GetObjectClass.?(env, app.activity.?.*.clazz);
    const getCacheDir = env.*.*.GetMethodID.?(env, android_content_context, "getCacheDir", "()Ljava/io/File;");
    const cache_dir = env.*.*.CallObjectMethod.?(env, app.activity.?.*.clazz, getCacheDir);

    const fileClass = env.*.*.FindClass.?(env, "java/io/File");
    const getPath = env.*.*.GetMethodID.?(env, fileClass, "getPath", "()Ljava/lang/String;");
    const cache_path_string: android.jstring = env.*.*.CallObjectMethod.?(env, cache_dir, getPath);

    const cache_path_chars = env.*.*.GetStringUTFChars.?(env, cache_path_string, null);
    app.cache_dir = c_allocator.alloc(u8, std.mem.len(cache_path_chars)) catch |e| system.handle_error3("anrdoid_app_entry c_allocator.alloc app.cache_dir", e);
    @memcpy(app.cache_dir.?, cache_path_chars[0..app.cache_dir.?.len]);
    env.*.*.ReleaseStringUTFChars.?(env, cache_path_string, cache_path_chars);

    _ = app.activity.?.*.vm.*.*.DetachCurrentThread.?(app.activity.?.*.vm);
}

fn anrdoid_app_entry() void {
    app.config = android.AConfiguration_new();

    android.AConfiguration_fromAssetManager(app.config, app.activity.?.*.assetManager);

    //print_cur_config();

    app.cmd_poll_source.id = @intFromEnum(LooperEvent.LOOPER_ID_MAIN);
    app.cmd_poll_source.process = process_cmd;
    app.input_poll_source.id = @intFromEnum(LooperEvent.LOOPER_ID_INPUT);
    app.input_poll_source.process = process_input;

    app.looper = android.ALooper_prepare(android.ALOOPER_PREPARE_ALLOW_NON_CALLBACKS);
    _ = android.ALooper_addFd(app.looper, app.msgread, @intFromEnum(LooperEvent.LOOPER_ID_MAIN), android.ALOOPER_EVENT_INPUT, null, &app.cmd_poll_source);

    app.mutex.lock();
    app.running = true;
    app.cond.broadcast();
    app.mutex.unlock();

    app.on_app_cmd = engine_handle_cmd;
    app.on_input_event = engine_handle_input;

    set_cache_path();

    app.sensor_manager = AcquireASensorManagerInstance();
    app.accelerometer_sensor = android.ASensorManager_getDefaultSensor(app.sensor_manager, android.ASENSOR_TYPE_ACCELEROMETER);

    app.sensor_event_queue = android.ASensorManager_createEventQueue(app.sensor_manager, app.looper, @intFromEnum(LooperEvent.LOOPER_ID_USER), OnSensorEvent, null);

    // if (app.savedState != null) {
    //     @memcpy(std.mem.asBytes(&app.savedata), app.savedState.?);
    // }

    while (true) {
        var ident: i32 = undefined;
        var source: ?*android_poll_source = null;
        ident = android.ALooper_pollOnce(if (app.paused) -1 else 0, null, null, @ptrCast(&source));
        if (ident == android.ALOOPER_POLL_ERROR) system.handle_error_msg2("ALooper_pollOnce");

        if (source != null) {
            source.?.*.process.?(source);
        }

        if (app.inited) {
            __system.loop();
        }
        if (system.a_fn(app.destroryRequested)) {
            destroy_android();
            break;
        }
    }

    root.xfit_clean() catch |e| {
        system.handle_error3("xfit_clean", e);
    };
    __system.real_destroy();

    free_saved_state();
    app.mutex.lock();
    if (app.input_queue != null) {
        android.AInputQueue_detachLooper(app.input_queue);
    }
    c_allocator.free(app.cache_dir.?);
    android.AConfiguration_delete(app.config);
    app.destroyed = true;
    app.cond.broadcast();
    app.mutex.unlock();
    // Can't touch android_app(app) object after this.

    std.c.exit(0);
}

/// Actual application entry point
export fn ANativeActivity_onCreate(_activity: [*c]android.ANativeActivity, _savedState: ?*anyopaque, _savedStateSize: usize) callconv(.C) void {
    _ = _savedState;
    _ = _savedStateSize;
    _activity.*.callbacks.*.onConfigurationChanged = onConfigurationChanged;
    _activity.*.callbacks.*.onContentRectChanged = onContentRectChanged;
    _activity.*.callbacks.*.onDestroy = onDestroy;
    _activity.*.callbacks.*.onInputQueueCreated = onInputQueueCreated;
    _activity.*.callbacks.*.onInputQueueDestroyed = onInputQueueDestroyed;
    _activity.*.callbacks.*.onLowMemory = onLowMemory;
    _activity.*.callbacks.*.onNativeWindowCreated = onNativeWindowCreated;
    _activity.*.callbacks.*.onNativeWindowDestroyed = onNativeWindowDestroyed;
    _activity.*.callbacks.*.onNativeWindowRedrawNeeded = onNativeWindowRedrawNeeded;
    _activity.*.callbacks.*.onNativeWindowResized = onNativeWindowResized;
    _activity.*.callbacks.*.onPause = onPause;
    _activity.*.callbacks.*.onResume = onResume;
    _activity.*.callbacks.*.onSaveInstanceState = onSaveInstanceState;
    _activity.*.callbacks.*.onStart = onStart;
    _activity.*.callbacks.*.onStop = onStop;
    _activity.*.callbacks.*.onWindowFocusChanged = onWindowFocusChanged;

    _activity.*.instance = @ptrCast(@constCast(&app));

    app.activity = _activity;

    // if (_savedState != null and _savedStateSize != 0) {
    //     app.savedStateSize = _savedStateSize;

    //     app.savedState = @as([*]u8, @ptrCast(c_allocator.alloc(u8, app.savedStateSize) catch |e| system.handle_error3("ANativeActivity_onCreate c_allocator.alloc app.savedState", e)))[0..app.savedStateSize];

    //     @memcpy(app.savedState.?, @as(?[*]u8, @ptrCast(_savedState)).?);
    // }

    const pipe = std.posix.pipe() catch |e| system.handle_error3("ANativeActivity_onCreate std.posix.pipe", e);
    app.msgread = pipe[0];
    app.msgwrite = pipe[1];

    app.thread = std.Thread.spawn(.{}, anrdoid_app_entry, .{}) catch |e| system.handle_error3("ANativeActivity_onCreate std.Thread.spawn", e);

    app.mutex.lock();
    while (!app.running) {
        app.cond.wait(&app.mutex);
    }
    app.mutex.unlock();
}
