pub const c = @cImport({
    @cInclude("lua/luaconf.h");
    @cInclude("lua/lua.h");
    @cInclude("lua/lualib.h");
    @cInclude("lua/lauxlib.h");
});

pub const LUA_OK = @as(c_int, 0);
pub const LUA_YIELD = @as(c_int, 1);
pub const LUA_ERRRUN = @as(c_int, 2);
pub const LUA_ERRSYNTAX = @as(c_int, 3);
pub const LUA_ERRMEM = @as(c_int, 4);
pub const LUA_ERRERR = @as(c_int, 5);
pub const LUA_TNONE = -@as(c_int, 1);
pub const LUA_TNIL = @as(c_int, 0);
pub const LUA_TBOOLEAN = @as(c_int, 1);
pub const LUA_TLIGHTUSERDATA = @as(c_int, 2);
pub const LUA_TNUMBER = @as(c_int, 3);
pub const LUA_TSTRING = @as(c_int, 4);
pub const LUA_TTABLE = @as(c_int, 5);
pub const LUA_TFUNCTION = @as(c_int, 6);
pub const LUA_TUSERDATA = @as(c_int, 7);
pub const LUA_TTHREAD = @as(c_int, 8);
pub const LUA_NUMTYPES = @as(c_int, 9);
pub const LUA_MINSTACK = @as(c_int, 20);
pub const LUA_RIDX_MAINTHREAD = @as(c_int, 1);
pub const LUA_RIDX_GLOBALS = @as(c_int, 2);
pub const LUA_RIDX_LAST = LUA_RIDX_GLOBALS;
pub const LUA_OPADD = @as(c_int, 0);
pub const LUA_OPSUB = @as(c_int, 1);
pub const LUA_OPMUL = @as(c_int, 2);
pub const LUA_OPMOD = @as(c_int, 3);
pub const LUA_OPPOW = @as(c_int, 4);
pub const LUA_OPDIV = @as(c_int, 5);
pub const LUA_OPIDIV = @as(c_int, 6);
pub const LUA_OPBAND = @as(c_int, 7);
pub const LUA_OPBOR = @as(c_int, 8);
pub const LUA_OPBXOR = @as(c_int, 9);
pub const LUA_OPSHL = @as(c_int, 10);
pub const LUA_OPSHR = @as(c_int, 11);
pub const LUA_OPUNM = @as(c_int, 12);
pub const LUA_OPBNOT = @as(c_int, 13);
pub const LUA_OPEQ = @as(c_int, 0);
pub const LUA_OPLT = @as(c_int, 1);
pub const LUA_OPLE = @as(c_int, 2);

const Self = @This();
const std = @import("std");

luaT: ?*c.lua_State,

pub const luaL_Reg = c.luaL_Reg;
pub const lua_CFunction = c.lua_CFunction;

pub fn luaL_newstate() Self {
    return .{
        .luaT = c.luaL_newstate(),
    };
}

pub fn lua_close(self: *Self) void {
    c.lua_close(self.*.luaT);
}

pub fn luaL_openlibs(self: *Self) void {
    c.luaL_openlibs(self.*.luaT);
}

pub fn lua_pushlightuserdata(self: *Self, p: ?*anyopaque) void {
    c.lua_pushlightuserdata(self.*.luaT, p);
}
pub fn lua_settop(self: *Self, index: c_int) void {
    c.lua_settop(self.*.luaT, index);
}
pub fn lua_yield(self: *Self, nresults: c_int) c_int {
    return c.lua_yieldk(self.*.luaT, nresults, 0, null);
}
pub fn lua_newtable(self: *Self) !void {
    c.lua_createtable(self, 0, 0);
}
pub fn luaL_dostring(self: *Self, _buf: [*c]const u8) !void {
    try luaL_loadstring(self, _buf);
    try lua_pcall(self, 0, c.LUA_MULTRET, 0);
}
pub fn lua_toboolean(self: *Self, idx: c_int) c_int {
    return c.lua_toboolean(self.*.luaT, idx);
}
pub fn lua_tocfunction(self: *Self, idx: c_int) lua_CFunction {
    return c.lua_tocfunction(self.*.luaT, idx);
}
pub fn lua_tonumber(self: *Self, idx: c_int) c.lua_Integer {
    return c.lua_tonumber(self.*.luaT, idx);
}
pub fn lua_typename(self: *Self, tp: c_int) [*c]const u8 {
    return c.lua_typename(self.*.luaT, tp);
}
pub fn lua_type(self: *Self, tp: c_int) c_int {
    return c.lua_type(self.*.luaT, tp);
}
pub fn lua_tostring(self: *Self, idx: c_int) [*c]const u8 {
    return c.lua_tostring(self.*.luaT, idx);
}
pub fn lua_topointer(self: *Self, idx: c_int) ?*const anyopaque {
    return c.lua_topointer(self.*.luaT, idx);
}
pub fn lua_rotate(self: *Self, idx: c_int, n: c_int) void {
    c.lua_rotate(self.*.luaT, idx, n);
}
pub fn luaL_checkinteger(self: *Self, arg: c_int) c.lua_Integer {
    return c.luaL_checkinteger(self.*.luaT, arg);
}
pub fn lua_touserdata(self: *Self, idx: c_int) ?*anyopaque {
    return c.lua_touserdata(self.*.luaT, idx, null);
}
pub fn luaL_checkstring(self: *Self, arg: c_int) [*c]const u8 {
    return c.luaL_checklstring(self.*.luaT, arg, null);
}
pub fn luaL_checklstring(self: *Self, arg: c_int, l: [*c]usize) [*c]const u8 {
    return c.luaL_checklstring(self.*.luaT, arg, l);
}
pub fn lua_pushnumber(self: *Self, n: f64) void {
    c.lua_pushnumber(self.*.luaT, n);
}
pub fn lua_pushboolean(self: *Self, _bool: c_int) void {
    c.lua_pushboolean(self.*.luaT, _bool);
}
pub fn lua_concat(self: *Self, n: c_int) void {
    c.lua_concat(self.*.luaT, n);
}
pub fn lua_pop(self: *Self, n: c_int) void {
    c.lua_pop(self.*.luaT, n);
}
pub fn lua_pushnil(self: *Self) void {
    c.lua_pushnil(self.*.luaT);
}
pub fn lua_pushliteral(self: *Self, s: [*c]const u8) [*c]const u8 {
    return c.lua_pushliteral(self.*.luaT, s);
}
pub fn lua_pushstring(self: *Self, s: [*c]const u8) [*c]const u8 {
    return c.lua_pushstring(self.*.luaT, s);
}
pub fn lua_pushlstring(self: *Self, s: [*c]const u8, len: usize) [*c]const u8 {
    return c.lua_pushlstring(self.*.luaT, s, len);
}
pub fn lua_pushcfunction(self: *Self, f: lua_CFunction) void {
    c.lua_pushcfunction(self.*.luaT, f);
}
pub fn lua_pushvalue(self: *Self, index: c_int) void {
    c.lua_pushvalue(self.*.luaT, index);
}
pub fn lua_pushcclosure(self: *Self, @"fn": lua_CFunction, n: c_int) void {
    c.lua_pushcclosure(self.*.luaT, @"fn", n);
}
pub fn luaL_loadfile(self: *Self, _path: [*c]const u8) !void {
    if (0 != c.luaL_loadfilex(self.*.luaT, _path, null)) {
        return std.posix.UnexpectedError.Unexpected;
    }
}
pub fn luaL_loadstring(self: *Self, _buf: [*c]const u8) !void {
    if (0 != c.luaL_loadstring(self.*.luaT, _buf)) {
        return std.posix.UnexpectedError.Unexpected;
    }
}
pub fn lua_settable(self: *Self, idx: c_int) void {
    c.lua_settable(self.*.luaT, idx);
}
pub fn lua_setmetatable(self: *Self, idx: c_int) void {
    c.lua_setmetatable(self.*.luaT, idx);
}
pub fn lua_seti(self: *Self, index: c_int, n: c.lua_Integer) void {
    c.lua_seti(self.*.luaT, index, n);
}
pub fn lua_setglobal(self: *Self, name: [*c]const u8) void {
    c.lua_setglobal(self.*.luaT, name);
}
pub fn lua_setfield(self: *Self, index: c_int, k: [*c]const u8) void {
    c.lua_setfield(self.*.luaT, index, k);
}

pub fn lua_pcall(self: *Self, nargs: c_int, nresults: c_int, errfunc: c_int) !void {
    if (0 != c.lua_pcallk(self.*.luaT, nargs, nresults, errfunc, 0, null)) return std.posix.UnexpectedError.Unexpected;
}

pub fn lua_getglobal(self: *Self, name: [*c]const u8) c_int {
    return c.lua_getglobal(self.*.luaT, name);
}
