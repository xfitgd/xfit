// !! windows platform only do not change
pub const UNICODE = false;
// !! android platform only do not change
comptime {
    if (@import("engine/system.zig").platform == .android)
        _ = @import("engine/__android.zig").android.ANativeActivity_createFunc;
}
// !!

const std = @import("std");
const xfit = @import("engine/xfit.zig");
const system = @import("engine/system.zig");
const window = @import("engine/window.zig");
const input = @import("engine/input.zig");
const xbox_pad_input = input.xbox_pad_input;
const general_input = input.general_input;

const timer_callback = @import("engine/timer_callback.zig");

const ArrayList = std.ArrayList;
const MemoryPoolExtra = std.heap.MemoryPoolExtra;
var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
var allocator: std.mem.Allocator = undefined;

const math = @import("engine/math.zig");
const mem = @import("engine/mem.zig");

fn xinput_callback(state: xbox_pad_input.XBOX_STATE) void {
    system.print("XBOX PAD [{d}]\n", .{state.device_idx});
    system.print("Buttons={s}{s}{s}{s} {s} {s} {s}\n", .{
        if (state.buttons.A) "A" else " ",
        if (state.buttons.B) "B" else " ",
        if (state.buttons.X) "X" else " ",
        if (state.buttons.Y) "Y" else " ",
        if (state.buttons.BACK) "BACK" else " ",
        if (state.buttons.START) "START" else " ",
        if (state.buttons.GUIDE) "GUIDE" else " ",
    });
    system.print("Dpad={s}{s}{s}{s} Shoulders={s}{s}\n", .{
        if (state.buttons.DPAD_UP) "U" else " ",
        if (state.buttons.DPAD_DOWN) "D" else " ",
        if (state.buttons.DPAD_LEFT) "L" else " ",
        if (state.buttons.DPAD_RIGHT) "R" else " ",
        if (state.buttons.LEFT_SHOULDER) "L" else " ",
        if (state.buttons.RIGHT_SHOULDER) "R" else " ",
    });
    system.print("Thumb={s}{s} LeftThumb=({d},{d}) RightThumb=({d},{d})\n", .{
        if (state.buttons.LEFT_THUMB) "L" else " ",
        if (state.buttons.RIGHT_THUMB) "R" else " ",
        state.left_thumb_x,
        state.left_thumb_y,
        state.right_thumb_x,
        state.right_thumb_y,
    });
    system.print("Trigger=({d},{d})\n", .{
        state.left_trigger,
        state.right_trigger,
    });
}
fn general_input_callback(state: general_input.INPUT_STATE) void {
    system.print("GENERAL [{}]\n", .{state.handle.?});
    system.print("Buttons={s}{s}{s}{s} {s} {s}\n", .{
        if (state.buttons.A) "A" else " ",
        if (state.buttons.B) "B" else " ",
        if (state.buttons.X) "X" else " ",
        if (state.buttons.Y) "Y" else " ",
        if (state.buttons.BACK) "BACK" else " ",
        if (state.buttons.START) "START" else " ",
    });
    system.print("Dpad={s}{s}{s}{s} Shoulders={s}{s} {s}{s}\n", .{
        if (state.buttons.DPAD_UP) "U" else " ",
        if (state.buttons.DPAD_DOWN) "D" else " ",
        if (state.buttons.DPAD_LEFT) "L" else " ",
        if (state.buttons.DPAD_RIGHT) "R" else " ",
        if (state.buttons.LEFT_SHOULDER) "L" else " ",
        if (state.buttons.RIGHT_SHOULDER) "R" else " ",
        if (state.buttons.VOLUME_UP) "+" else " ",
        if (state.buttons.VOLUME_DOWN) "-" else " ",
    });
    system.print("Thumb={s}{s} LeftThumb=({d},{d}) RightThumb=({d},{d})\n", .{
        if (state.buttons.LEFT_THUMB) "L" else " ",
        if (state.buttons.RIGHT_THUMB) "R" else " ",
        state.left_thumb_x,
        state.left_thumb_y,
        state.right_thumb_x,
        state.right_thumb_y,
    });
    system.print("Trigger=({d},{d})\n", .{
        state.left_trigger,
        state.right_trigger,
    });
}

fn change_xbox(_device_idx: u32, add_or_remove: bool) void {
    if (add_or_remove) {
        system.print("---------------------------------\nXBOX ADDED ({d})\n---------------------------------\n", .{_device_idx});
    } else {
        system.print("---------------------------------\nXBOX REMOVED ({d})\n---------------------------------\n", .{_device_idx});
    }
}

pub fn xfit_init() !void {
    try xbox_pad_input.start(change_xbox);
    general_input.start();
    general_input.set_callback(general_input_callback);
    xbox_pad_input.set_callback(xinput_callback);

    _ = try timer_callback.start(system.sec_to_nano_sec2(1, 0, 0, 0), 0, vib_callback, .{});
}

fn vib_callback() !void {
    _ = xbox_pad_input.set_vibration(
        0,
        .{
            .left_rumble = 128,
            .right_rumble = 128,
            .on_time = 10,
        },
    ) catch {};
}

pub fn xfit_update() !void {}

pub fn xfit_size() !void {}

///before system clean
pub fn xfit_destroy() !void {
    xbox_pad_input.destroy();
    general_input.destroy();
}

///after system clean
pub fn xfit_clean() !void {
    if (system.dbg and gpa.deinit() != .ok) unreachable;
}

pub fn xfit_activate(is_activate: bool, is_pause: bool) !void {
    _ = is_activate;
    _ = is_pause;
}

pub fn xfit_closing() !bool {
    return true;
}

pub fn main() void {
    const init_setting: system.init_setting = .{
        .window_width = 640,
        .window_height = 480,
        .use_console = true,
    };
    gpa = .{};
    allocator = gpa.allocator(); //반드시 할당자는 main에서 초기화
    xfit.xfit_main(allocator, &init_setting);
}
