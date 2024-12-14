const std = @import("std");
const xfit = @import("xfit.zig");

const __windows = if (!@import("builtin").is_test) @import("__windows.zig") else void;
const __android = if (!@import("builtin").is_test) @import("__android.zig") else void;
const __system = @import("__system.zig");
const system = @import("system.zig");

const win32 = __windows.win32;

pub const GENERAL_INPUT_BUTTONS = packed struct {
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

pub const GENERAL_INPUT_STATE = struct {
    handle: ?*anyopaque,
    left_trigger: f32,
    right_trigger: f32,
    left_thumb_x: f32,
    left_thumb_y: f32,
    right_thumb_x: f32,
    right_thumb_y: f32,
    buttons: GENERAL_INPUT_BUTTONS,
};

pub const CallbackFn = *const fn (state: GENERAL_INPUT_STATE) void;

var fn_: ?CallbackFn = null;

pub fn start_general_input() void {}

pub fn destroy_general_input() void {
    @atomicStore(?CallbackFn, &__system.general_input_callback, null, .monotonic);
}

pub fn set_general_input_callback(_fn: CallbackFn) void {
    fn_ = _fn;
    @atomicStore(?CallbackFn, &__system.general_input_callback, _fn, .monotonic);
}
