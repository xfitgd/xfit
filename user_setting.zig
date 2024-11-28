//* User Setting
const std = @import("std");

pub const ANDROID_PATH = "/usr/local/Android/Sdk";
pub const ANDROID_NDK_PATH = std.fmt.comptimePrint("{s}/ndk/27.2.12479018", .{ANDROID_PATH});
pub const ANDROID_VER = 35;
pub const ANDROID_BUILD_TOOL_VER = "35.0.0";

//if need keystore : keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000
//*
