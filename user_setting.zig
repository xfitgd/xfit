//* User Setting
//크로스 플랫폼 빌드시 zig build -Dtarget=aarch64-windows(linux)
//x86_64-windows(linux)
const std = @import("std");

pub const ANDROID_PATH = "/usr/local/android";
pub const ANDROID_NDK_PATH = std.fmt.comptimePrint("{s}/ndk/27.2.12479018", .{ANDROID_PATH});
pub const ANDROID_VER = 35;
pub const ANDROID_BUILD_TOOL_VER = "35.0.0";
pub const legacy = false;

//keystore 없으면 생성
//keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000
//*
