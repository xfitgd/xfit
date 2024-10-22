//Windows Only https://gist.github.com/mmozeiko/b8ccc54037a5eaf35432396feabbe435
const std = @import("std");
const ArrayList = std.ArrayList;

const __windows = @import("__windows.zig");
const __system = @import("__system.zig");
const raw_input = @import("raw_input.zig");
const system = @import("system.zig");

comptime {
    if (system.platform != .windows) @compileError("__raw_input only can run windows");
}

const win32 = __windows.win32;

const device = struct {
    handle: ?*anyopaque = null,
    path: []u8,
};

pub var mutex: std.Thread.Mutex = .{};
pub var list: ArrayList(*Self) = undefined;

const Self = @This();

devices: []device,
guid: *const raw_input.GUID,
callback: ?raw_input.CallBackFn = null,
change_fn: raw_input.ChangeDeviceFn,
user_data: ?*anyopaque = null,

pub fn start() void {
    mutex.lock();
    list = ArrayList(*Self).init(__system.allocator);
    mutex.unlock();
}
pub fn destroy() void {
    mutex.lock();
    list.deinit();
    mutex.unlock();
}

pub fn connect(self: *Self, path: []const u8) u32 {
    var i: u32 = 0;
    while (i < self.*.devices.len) : (i += 1) {
        if (self.*.devices[i].handle != null) return i;
    }
    const path_t = __system.allocator.dupeZ(u8, path) catch system.handle_error_msg2("rawinput connect device path dupeZ");
    defer __system.allocator.free(path_t);

    const handle: win32.HANDLE = win32.CreateFileA(path_t.ptr, win32.GENERIC_READ | win32.GENERIC_WRITE, win32.FILE_SHARE_READ | win32.FILE_SHARE_WRITE, null, win32.OPEN_EXISTING, 0, null);
    if (handle == win32.INVALID_HANDLE_VALUE) return std.math.maxInt(u32);
    i = 0;
    while (i < self.*.devices.len) : (i += 1) {
        if (self.*.devices[i].handle == null) {
            self.*.devices[i].handle = handle;
            self.*.devices[i].path = __system.allocator.alloc(u8, path.len) catch system.handle_error_msg2("rawinput connect device path alloc");
            @memcpy(self.*.devices[i].path, path);
            self.*.change_fn(i, true, self.*.user_data);

            return i;
        }
    }
    return std.math.maxInt(u32);
}

pub fn init(_MAX_DEVICES: u32, _guid: *const raw_input.GUID, _change_fn: raw_input.ChangeDeviceFn, _user_data: ?*anyopaque) raw_input.ERROR!*Self {
    if (_MAX_DEVICES == 0) {
        system.print_error("WARN rawinput _MAX_DEVICES can't 0\n", .{});
        return raw_input.ERROR.ZERO_DEVICE;
    }
    const self = __system.allocator.create(Self) catch system.handle_error_msg2("rawinput create");
    self.* = .{
        .guid = _guid,
        .devices = __system.allocator.alloc(device, _MAX_DEVICES) catch system.handle_error_msg2("rawinput device alloc"),
        .change_fn = _change_fn,
        .user_data = _user_data,
    };
    @memset(self.*.devices, .{ .handle = null, .path = undefined });
    errdefer {
        __system.allocator.free(self.*.devices);
        __system.allocator.destroy(self);
    }
    var db = win32.DEV_BROADCAST_DEVICEINTERFACE_A{
        .dbcc_size = @sizeOf(win32.DEV_BROADCAST_DEVICEINTERFACE_A),
        .dbcc_devicetype = win32.DBT_DEVTYP_DEVICEINTERFACE,
        .dbcc_classguid = _guid.*,
    };
    if (null == win32.RegisterDeviceNotificationA(__windows.hWnd, @ptrCast(&db), win32.DEVICE_NOTIFY_WINDOW_HANDLE)) {
        system.print_error("WARN RegisterDeviceNotificationA code : {d}\n", .{win32.GetLastError()});
        return raw_input.ERROR.SYSTEM_ERROR;
    }
    const dev = win32.SetupDiGetClassDevsA(_guid, null, null, win32.DIGCF_DEVICEINTERFACE | win32.DIGCF_PRESENT);
    if (dev == win32.INVALID_HANDLE_VALUE) {
        system.print_error("WARN code {d} SetupDiGetClassDevsA\n", .{win32.GetLastError()});
        return raw_input.ERROR.SYSTEM_ERROR;
    }
    var idata: win32.SP_DEVICE_INTERFACE_DATA = .{};
    var index: u32 = 0;
    while (win32.SetupDiEnumDeviceInterfaces(dev, null, _guid, index, &idata) == 1) {
        var size: u32 = undefined;
        _ = win32.SetupDiGetDeviceInterfaceDetailA(dev, &idata, null, 0, &size, null);

        const detail = __system.allocator.alignedAlloc(u8, 4, size) catch system.handle_error_msg2("rawinput init detail alloc");
        const detailA: win32.PSP_DEVICE_INTERFACE_DETAIL_DATA_A = @ptrCast(detail.ptr);
        detailA.*.cbSize = @sizeOf(win32.SP_DEVICE_INTERFACE_DETAIL_DATA_A); // ! size변수가 아니다!

        var data: win32.SP_DEVINFO_DATA = .{};
        if (win32.SetupDiGetDeviceInterfaceDetailA(dev, &idata, detailA, size, &size, &data) == win32.FALSE) {
            system.print_error("WARN code {d} SetupDiGetDeviceInterfaceDetailA 2\n", .{win32.GetLastError()});
            self.*.deinit();
            __system.allocator.free(detail);
            return raw_input.ERROR.SYSTEM_ERROR;
        }

        const len = std.mem.len(@as([*c]const u8, @ptrCast(@alignCast(&detailA.*.DevicePath[0]))));
        _ = self.*.connect(@as([*]const u8, @ptrCast(&detailA.*.DevicePath[0]))[0..len]);
        __system.allocator.free(detail);
        index += 1;
    }

    if (win32.FALSE == win32.SetupDiDestroyDeviceInfoList(dev)) {
        system.print_error("WARN code {d} SetupDiDestroyDeviceInfoList\n", .{win32.GetLastError()});
    }

    mutex.lock();
    list.append(self) catch system.handle_error_msg2("rawinput list append");
    mutex.unlock();

    return self;
}

pub fn disconnect(self: *Self, path: []const u8) u32 {
    var i: u32 = 0;
    while (i < self.*.devices.len) : (i += 1) {
        //대문자 소문자 상관없이 비교 std.ascii.eqlIgnoreCase
        if (self.*.devices[i].handle != null and self.*.devices[i].path.len == path.len and std.ascii.eqlIgnoreCase(path, self.*.devices[i].path)) {
            self.*.change_fn(i, false, self.*.user_data);
            destroy_device(&self.*.devices[i]);
            return i;
        }
    }
    return std.math.maxInt(u32);
}

fn destroy_device(dev: *device) void {
    _ = win32.CloseHandle(dev.*.handle);

    dev.*.handle = null;
    __system.allocator.free(dev.*.path);
}

pub fn deinit(self: *Self) void {
    var i: u32 = 0;
    mutex.lock();
    defer mutex.unlock();

    while (i < self.*.devices.len) : (i += 1) {
        if (self.*.devices[i].handle != null) {
            destroy_device(&self.*.devices[i]);
        }
    }
    __system.allocator.free(self.*.devices);

    i = 0;
    while (i < list.items.len) : (i += 1) {
        if (list.items[i] == self) {
            _ = list.orderedRemove(i);
            break;
        }
    }

    __system.allocator.destroy(self);
}

pub fn get(self: *Self, idx: u32, ctl_code: u32, in: []const u8, out: []u8) bool {
    if (idx >= self.*.devices.len) {
        system.print_error("WARN rawinput get idx outofrange\n", .{});
        return false;
    }
    if (self.*.devices[idx].handle == null) return false;

    const in_ = __system.allocator.alloc(u8, in.len) catch system.handle_error_msg2("rawinput get in_ alloc");
    defer __system.allocator.free(in_);
    @memcpy(in_, in);

    var size: u32 = undefined;
    const res = win32.DeviceIoControl(
        self.*.devices[idx].handle,
        ctl_code,
        @ptrCast(in_.ptr),
        @intCast(in.len),
        @ptrCast(out.ptr),
        @intCast(out.len),
        &size,
        null,
    );
    if (res == 0 or size != out.len) {
        const err = win32.GetLastError();
        if (err == win32.ERROR_DEVICE_NOT_CONNECTED) {
            _ = self.*.disconnect(self.*.devices[idx].path);
            return false;
        }
        system.print("WARN DeviceIoControl ctrlCode: {d}, errorCode : {d}\nguid: {}\n", .{ ctl_code, win32.GetLastError(), self.*.guid.* });
        return false;
    }
    return true;
}

pub fn handle_event(self: *Self) void {
    if (self.*.callback != null) {
        var i: u32 = 0;
        while (i < self.*.devices.len) : (i += 1) {
            self.*.callback.?(@ptrCast(self), i, self.*.user_data);
        }
    }
}

pub fn set_callback(self: *Self, _fn: raw_input.CallBackFn) void {
    self.*.callback = _fn;
}

pub fn set(self: *Self, device_idx: u32, data: []const u8) raw_input.ERROR!u32 {
    mutex.lock();
    defer mutex.unlock();
    if (self.*.devices[device_idx].handle == null) return raw_input.ERROR.NO_IDX;
    var read: win32.DWORD = undefined;
    if (0 == win32.WriteFile(self.*.devices[device_idx].handle, data.ptr, @intCast(data.len), &read, null)) {
        return raw_input.ERROR.WRITE_FAIL;
    }
    return read;
}
