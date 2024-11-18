const std = @import("std");

const __windows = @import("__windows.zig");
const __android = @import("__android.zig");
const __system = @import("__system.zig");
const system = @import("system.zig");

const win32 = __windows.win32;

pub const INPUT_BUTTONS = packed struct {
    A: bool,
    B: bool,
    X: bool,
    Y: bool,

    DPAD_UP: bool,
    DPAD_DOWN: bool,
    DPAD_LEFT: bool,
    DPAD_RIGHT: bool,

    START: bool,
    BACK: bool,

    LEFT_THUMB: bool,
    RIGHT_THUMB: bool,

    LEFT_SHOULDER: bool,
    RIGHT_SHOULDER: bool,

    VOLUME_UP: bool,
    VOLUME_DOWN: bool,
};

pub const INPUT_STATE = struct {
    handle: ?*anyopaque,
    left_trigger: f32,
    right_trigger: f32,
    left_thumb_x: f32,
    left_thumb_y: f32,
    right_thumb_x: f32,
    right_thumb_y: f32,
    buttons: INPUT_BUTTONS,
};

pub const CallbackFn = *const fn (state: INPUT_STATE) void;

var fn_: ?CallbackFn = null;

pub fn start() void {}

pub fn destroy() void {
    @atomicStore(?CallbackFn, &__system.general_input_callback, null, .monotonic);
}

pub fn set_callback(_fn: CallbackFn) void {
    fn_ = _fn;
    @atomicStore(?CallbackFn, &__system.general_input_callback, _fn, .monotonic);
}
