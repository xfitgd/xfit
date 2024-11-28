//? (비트 필드 항목들 + 확인할 파일 항목 이름) ->
//? 비트 필드 항목들을 순회해서 false인경우 ->
//? 확인할 항목 이름과 비교, 같으면 true로 만듬. ->
//? 비트 필드에 해당하는 실제 값 찾기->
//? true에 해당하는 실제 값 설정
//? bit fields + check field names
//? if false when traversing bit fields
//? compare with check field names, if same, set true
//? find actual value corresponding to true bit field
//? set actual value
//! Union and nested struct not supported

const std = @import("std");
const meta = @import("meta.zig");

pub const json_error = error{
    invalid_json_object,
};

const Scanner = std.json.Scanner;
const Token = std.json.Token;
const ArrayList = std.ArrayList;

pub inline fn get_string(allocator: std.mem.Allocator, scanner: *Scanner) ![]u8 {
    const next_token = try scanner.next();
    if (next_token != .string) {
        return json_error.invalid_json_object;
    }
    return try allocator.dupe(u8, next_token.string);
}
pub fn get_int(comptime T: type, scanner: *Scanner) !T {
    const next_token = try scanner.next();
    if (next_token != .number) return json_error.invalid_json_object;

    if (@typeInfo(T).int.signedness == .signed) return try std.fmt.parseInt(T, next_token.number, 10);
    return try std.fmt.parseUnsigned(T, next_token.number, 10);
}
pub fn get_float(comptime T: type, scanner: *Scanner) !T {
    const next_token = try scanner.next();
    if (next_token != .number) return json_error.invalid_json_object;
    return try std.fmt.parseFloat(T, next_token.number);
}

fn parse_node_check(scanner: *Scanner, allocator: std.mem.Allocator, node: anytype, typeinfo: std.builtin.Type) !bool {
    switch (typeinfo) {
        .pointer => |info| {
            switch (info.size) {
                .Slice => {
                    switch (info.child) {
                        u8 => node.* = @constCast(try get_string(allocator, scanner)),
                        inline usize, u32, i32, f32, f64 => |t| {
                            if (try scanner.next() != .array_begin) return json_error.invalid_json_object;
                            var arrayT = ArrayList(t).init(allocator);
                            while (true) {
                                const token3 = try scanner.next();
                                switch (token3) {
                                    .number => |number| {
                                        switch (t) {
                                            i32 => try arrayT.append(try std.fmt.parseInt(i32, number, 10)),
                                            f32 => try arrayT.append(try std.fmt.parseFloat(f32, number)),
                                            f64 => try arrayT.append(try std.fmt.parseFloat(f64, number)),
                                            inline u32, usize => |t2| try arrayT.append(try std.fmt.parseUnsigned(t2, number, 10)),
                                            else => @compileError("Unsupported type"),
                                        }
                                    },
                                    .array_end => break,
                                    else => return json_error.invalid_json_object,
                                }
                            }
                            node.* = arrayT.items;
                        },
                        else => @compileError("Unsupported pointer child type"),
                    }
                },
                else => @compileError("Unsupported pointer size"),
            }
        },
        .array => |info| {
            if (@typeInfo(info.child) == .vector) {
                const info2 = @typeInfo(info.child).vector;
                switch (info2.child) {
                    inline usize, u32, i32, f32, f64 => |t| {
                        if (try scanner.next() != .array_begin) return json_error.invalid_json_object;

                        comptime var i = 0;
                        inline while (i < info.len) : (i += 1) {
                            @setEvalBranchQuota(10_000);
                            comptime var j = 0;
                            inline while (j < info2.len) : (j += 1) {
                                const token3 = try scanner.next();
                                switch (token3) {
                                    .number => |number| {
                                        switch (t) {
                                            i32 => node.*[i][j] = try std.fmt.parseInt(i32, number, 10),
                                            f32 => node.*[i][j] = try std.fmt.parseFloat(f32, number),
                                            f64 => node.*[i][j] = try std.fmt.parseFloat(f64, number),
                                            inline u32, usize => |t2| node.*[i][j] = try std.fmt.parseUnsigned(t2, number, 10),
                                            else => @compileError("Unsupported type"),
                                        }
                                    },
                                    else => return json_error.invalid_json_object,
                                }
                            }
                        }
                        if (try scanner.next() != .array_end) return json_error.invalid_json_object;
                    },
                    else => @compileError("Unsupported pointer child type"),
                }
            } else {
                switch (info.child) {
                    inline usize, u32, i32, f32, f64 => |t| {
                        if (try scanner.next() != .array_begin) return json_error.invalid_json_object;
                        comptime var i = 0;
                        inline while (i < info.len) : (i += 1) {
                            const token3 = try scanner.next();
                            switch (token3) {
                                .number => |number| {
                                    switch (t) {
                                        i32 => node.*[i] = try std.fmt.parseInt(i32, number, 10),
                                        f32 => node.*[i] = try std.fmt.parseFloat(f32, number),
                                        f64 => node.*[i] = try std.fmt.parseFloat(f64, number),
                                        inline u32, usize => |t2| node.*[i] = try std.fmt.parseUnsigned(t2, number, 10),
                                        else => @compileError("Unsupported type"),
                                    }
                                },
                                else => return json_error.invalid_json_object,
                            }
                        }
                        if (try scanner.next() != .array_end) return json_error.invalid_json_object;
                    },
                    else => @compileError("Unsupported array child type"),
                }
            }
        },
        .int => |info| {
            const next_token = try scanner.next();
            if (next_token != .number) return json_error.invalid_json_object;
            const IntT = std.meta.Int(info.signedness, info.bits);
            node.* = if (info.signedness == .signed)
                try std.fmt.parseInt(IntT, next_token.number, 10)
            else
                try std.fmt.parseUnsigned(IntT, next_token.number, 10);
        },
        .float => |info| {
            const next_token = try scanner.next();
            if (next_token != .number) return json_error.invalid_json_object;
            const FloatT = std.meta.Float(info.bits);
            node.* = try std.fmt.parseFloat(FloatT, next_token.number);
        },
        .vector => |info| {
            switch (info.child) {
                inline usize, u32, i32, f32, f64 => |t| {
                    if (try scanner.next() != .array_begin) return json_error.invalid_json_object;

                    comptime var i = 0;
                    inline while (i < info.len) : (i += 1) {
                        const token3 = try scanner.next();
                        switch (token3) {
                            .number => |number| {
                                switch (t) {
                                    i32 => node.*[i] = try std.fmt.parseInt(i32, number, 10),
                                    f32 => node.*[i] = try std.fmt.parseFloat(f32, number),
                                    f64 => node.*[i] = try std.fmt.parseFloat(f64, number),
                                    inline u32, usize => |t2| node.*[i] = try std.fmt.parseUnsigned(t2, number, 10),
                                    else => @compileError("Unsupported type"),
                                }
                            },
                            else => return json_error.invalid_json_object,
                        }
                    }
                    if (try scanner.next() != .array_end) return json_error.invalid_json_object;
                },
                else => @compileError("Unsupported pointer child type"),
            }
        },
        else => {
            @compileLog(typeinfo);
            @compileError("Unsupported type");
        },
    }
    return true;
}

fn parse_node(scanner: *Scanner, allocator: std.mem.Allocator, string: []const u8, comptime field_name: [:0]const u8, out_bits: anytype, node: anytype) !bool {
    const typeinfo = @typeInfo(@TypeOf(node.*));
    if (typeinfo == .pointer and @typeInfo(typeinfo.pointer.child) == .@"struct") {
        if (typeinfo.pointer.size != .Slice) @compileError("Unsupported pointer size");
        if (!out_bits.* and std.mem.eql(u8, field_name[0..field_name.len], string)) {
            out_bits.* = true;
            node.* = try parse_array(typeinfo.pointer.child, allocator, scanner); //set value here
            return true;
        }
        return false;
    } else if (typeinfo != .@"struct") {
        if (!out_bits.* and std.mem.eql(u8, field_name[0..field_name.len], string)) {
            out_bits.* = true;
        } else {
            return false; //already set or name doesn't match, exit
        }
    } else {
        if (!out_bits.* and std.mem.eql(u8, field_name[0..field_name.len], string)) {
            out_bits.* = true;
            node.* = try parse_object(@TypeOf(node.*), allocator, scanner); //set value here
            return true;
        }
        return false;
    }
    //above compared field name, so if no error, value must be set
    switch (typeinfo) {
        .optional => |info| {
            node.* = undefined;
            return try parse_node_check(scanner, allocator, &node.*.?, @typeInfo(info.child));
        },
        else => {
            return try parse_node_check(scanner, allocator, node, typeinfo);
        },
    }
}

pub fn parse_object(NODE_T: type, allocator: std.mem.Allocator, scanner: *Scanner) !NODE_T {
    const node_bits_T = meta.create_bit_field(NODE_T);
    var node_bits: node_bits_T = .{};

    if (try scanner.next() != .object_begin) return json_error.invalid_json_object;

    var node: NODE_T = meta.init_default_value_and_undefined(NODE_T);

    while (true) {
        const token2 = try scanner.next();
        switch (token2) {
            .string => |string| {
                inline for (std.meta.fields(NODE_T)) |field| {
                    _ = try parse_node(
                        scanner,
                        allocator,
                        string,
                        field.name,
                        &@field(node_bits, field.name),
                        &@field(node, field.name),
                    );
                }
            },
            .object_end => {
                const declList = std.meta.declList(NODE_T, fn (anytype) bool);
                if (declList.len > 0 and !declList[0].*(node_bits)) return json_error.invalid_json_object;
                node_bits = .{};
                break;
            },
            else => return json_error.invalid_json_object,
        }
    }
    return node; // node is not deallocated when leaving the function
}

pub fn parse_array(NODE_T: type, allocator: std.mem.Allocator, scanner: *Scanner) ![]NODE_T {
    const node_bits_T = meta.create_bit_field(NODE_T);

    if (try scanner.next() != .array_begin) return json_error.invalid_json_object;
    //std.debug.print("token: begin\n", .{});

    var array = ArrayList(NODE_T).init(allocator);
    while (true) {
        const token = try scanner.next();
        switch (token) {
            .object_begin => {
                try array.append(meta.init_default_value_and_undefined(NODE_T));
                const last = &array.items[array.items.len - 1];
                var node_bits: node_bits_T = .{};

                while (true) {
                    const token2 = try scanner.next();
                    //std.debug.print("token: {}\n", .{token2});
                    switch (token2) {
                        .string => |string| {
                            inline for (std.meta.fields(NODE_T)) |field| {
                                _ = try parse_node(
                                    scanner,
                                    allocator,
                                    string,
                                    field.name,
                                    &@field(node_bits, field.name),
                                    &@field(last.*, field.name),
                                );
                            }
                        },
                        .object_end => {
                            const declList = std.meta.declList(NODE_T, fn (anytype) bool);
                            if (declList.len > 0 and !declList[0].*(node_bits)) return json_error.invalid_json_object;
                            break;
                        },
                        else => {
                            return json_error.invalid_json_object;
                        },
                    }
                }
            },
            .array_end => break,
            else => {},
        }
    }
    return array.items; // array is not deallocated when leaving the function
}

pub fn all_bits_true(bits: anytype) bool {
    inline for (std.meta.fields(@TypeOf(bits))) |field| {
        if (!@field(bits, field.name)) return false;
    }
    return true;
}
pub fn always_true(_: anytype) bool {
    return true;
}
