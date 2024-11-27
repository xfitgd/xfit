//! Union is not supported

const std = @import("std");

fn _init_default_value_and_undefined(in_field: anytype) void {
    inline for (std.meta.fields(@TypeOf(in_field))) |field| {
        @setEvalBranchQuota(10_000);
        if (field.default_value != null) {
            if (@typeInfo(field.type) == .@"struct") {
                _init_default_value_and_undefined(@field(in_field, field.name));
            } else {
                @field(in_field, field.name) = @as(*const field.type, @alignCast(@ptrCast(field.default_value.?))).*;
            }
        }
    }
}

pub inline fn parse_value(comptime T: type, _str: []const u8) !T {
    switch (@typeInfo(T)) {
        .int => |info| {
            if (info.signedness == .signed) {
                return try std.fmt.parseInt(T, _str, 10);
            } else {
                return try std.fmt.parseUnsigned(T, _str, 10);
            }
        },
        .float => {
            return try std.fmt.parseFloat(T, _str);
        },
        .bool => {
            const i = std.fmt.parseUnsigned(u32, _str, 10) catch {
                if (std.mem.eql(u8, _str, "true")) {
                    return true;
                } else {
                    return false;
                }
            };
            return i != 0;
        },
        .pointer => |info| {
            if (info.size == .Slice and info.child == u8) {
                return _str;
            }
            @compileError("Unsupported pointer type");
        },
        else => @compileError("Unsupported type"),
    }
}

pub fn init_default_value_and_undefined(T: type) T {
    if (@typeInfo(T) != .@"struct") {
        return undefined;
    }
    var value: T = undefined;
    const fields = std.meta.fields(T);
    inline for (fields) |field| {
        @setEvalBranchQuota(10_000);
        if (field.default_value != null) {
            if (@typeInfo(field.type) == .@"struct") {
                _init_default_value_and_undefined(@field(value, field.name));
            } else if (@typeInfo(field.type) == .@"union") {
                @compileError("Union is not supported");
            } else {
                @field(value, field.name) = @as(*const field.type, @alignCast(@ptrCast(field.default_value.?))).*;
            }
        }
    }
    return value;
}

pub fn set_value(field: anytype, value: anytype) void {
    if (@typeInfo(@TypeOf(field)) == .array) {
        inline for (field, value) |*v, v2| {
            @setEvalBranchQuota(10_000);
            v.* = v2;
        }
    } else {
        field = value;
    }
}

pub fn create_bit_field(comptime struct_T: type) type {
    const func = struct {
        pub fn add_field(comptime fields: []const std.builtin.Type.StructField, comptime output_fields: []std.builtin.Type.StructField) void {
            inline for (fields, 0..) |T, i| {
                @setEvalBranchQuota(10_000);

                output_fields[i] = .{
                    .name = T.name,
                    .type = bool,
                    .default_value = @ptrCast(&false),
                    .is_comptime = false,
                    .alignment = 0,
                };
            }
        }
    };
    const fields = std.meta.fields(struct_T);
    var output_fields: [fields.len]std.builtin.Type.StructField = undefined;
    comptime func.add_field(fields, output_fields[0..]);

    return @Type(.{
        .@"struct" = .{
            .is_tuple = false,
            .layout = .auto,
            .decls = &.{},
            .fields = &output_fields,
        },
    });
}
