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
    const func = struct {
        pub fn add_field(comptime fields: []const std.builtin.Type.StructField, comptime output_fields: []std.builtin.Type.StructField) void {
            inline for (fields, 0..) |T, i| {
                @setEvalBranchQuota(10_000);

                comptime var in_fields: []const std.builtin.Type.StructField = undefined;

                if (@typeInfo(T.type) == .optional and @typeInfo(@typeInfo(T.type).optional.child) == .@"struct") {
                    in_fields = std.meta.fields(@typeInfo(T.type).optional.child);
                } else if (@typeInfo(T.type) == .@"struct") {
                    in_fields = std.meta.fields(T.type);
                } else {
                    output_fields[i] = .{
                        .name = T.name,
                        .type = bool,
                        .default_value = @ptrCast(&false),
                        .is_comptime = false,
                        .alignment = 0,
                    };
                    continue;
                }
                var _output_fields: [in_fields.len]std.builtin.Type.StructField = undefined;

                add_field(in_fields, _output_fields[0..]);

                const _struct_T = @Type(.{
                    .@"struct" = .{
                        .is_tuple = false,
                        .layout = .auto,
                        .decls = &.{},
                        .fields = &_output_fields,
                    },
                });
                output_fields[i] = .{
                    .name = T.name,
                    .type = _struct_T,
                    .default_value = @ptrCast(&_struct_T{}),
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
