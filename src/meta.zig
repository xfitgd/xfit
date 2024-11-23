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
    const fields = std.meta.fields(struct_T);
    if (@TypeOf(fields) != []const std.builtin.Type.StructField) @compileError("Expected struct type");
    var output_fields: [fields.len]std.builtin.Type.StructField = undefined;
    inline for (fields, 0..) |T, i| {
        @setEvalBranchQuota(10_000);
        const default_value = false;
        output_fields[i] = .{
            .name = T.name,
            .type = bool,
            .default_value = @ptrCast(&default_value),
            .is_comptime = false,
            .alignment = 0,
        };
    }

    return @Type(.{
        .@"struct" = .{
            .is_tuple = false,
            .layout = .auto,
            .decls = &.{},
            .fields = &output_fields,
        },
    });
}
