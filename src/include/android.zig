pub extern fn android_get_application_target_sdk_version(...) c_int;
pub extern fn android_get_device_api_level(...) c_int;
pub const ptrdiff_t = c_longlong;
pub const wchar_t = c_ushort;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_longlong;
pub const __uint64_t = c_ulonglong;
pub const __intptr_t = c_int;
pub const __uintptr_t = c_uint;
pub const int_least8_t = i8;
pub const uint_least8_t = u8;
pub const int_least16_t = i16;
pub const uint_least16_t = u16;
pub const int_least32_t = i32;
pub const uint_least32_t = u32;
pub const int_least64_t = i64;
pub const uint_least64_t = u64;
pub const int_fast8_t = i8;
pub const uint_fast8_t = u8;
pub const int_fast64_t = i64;
pub const uint_fast64_t = u64;
pub const int_fast16_t = i32;
pub const uint_fast16_t = u32;
pub const int_fast32_t = i32;
pub const uint_fast32_t = u32;
pub const uintmax_t = u64;
pub const intmax_t = i64;
pub const __s8 = i8;
pub const __u8 = u8;
pub const __s16 = c_short;
pub const __u16 = c_ushort;
pub const __s32 = c_int;
pub const __u32 = c_uint;
pub const __s64 = c_longlong;
pub const __u64 = c_ulonglong;
pub const __kernel_sighandler_t = ?*const fn (c_int) callconv(.C) void;
pub const __kernel_key_t = c_int;
pub const __kernel_mqd_t = c_int;
pub const __kernel_old_uid_t = c_ushort;
pub const __kernel_old_gid_t = c_ushort;
pub const __kernel_old_dev_t = c_ulong;
pub const __kernel_long_t = c_long;
pub const __kernel_ulong_t = c_ulong;
pub const __kernel_ino_t = __kernel_ulong_t;
pub const __kernel_mode_t = c_uint;
pub const __kernel_pid_t = c_int;
pub const __kernel_ipc_pid_t = c_int;
pub const __kernel_uid_t = c_uint;
pub const __kernel_gid_t = c_uint;
pub const __kernel_suseconds_t = __kernel_long_t;
pub const __kernel_daddr_t = c_int;
pub const __kernel_uid32_t = c_uint;
pub const __kernel_gid32_t = c_uint;
pub const __kernel_size_t = __kernel_ulong_t;
pub const __kernel_ssize_t = __kernel_long_t;
pub const __kernel_ptrdiff_t = __kernel_long_t;
pub const __kernel_off_t = __kernel_long_t;
pub const __kernel_loff_t = c_longlong;
pub const __kernel_old_time_t = __kernel_long_t;
pub const __kernel_time_t = __kernel_long_t;
pub const __kernel_time64_t = c_longlong;
pub const __kernel_clock_t = __kernel_long_t;
pub const __kernel_timer_t = c_int;
pub const __kernel_clockid_t = c_int;
pub const __kernel_caddr_t = [*c]u8;
pub const __kernel_uid16_t = c_ushort;
pub const __kernel_gid16_t = c_ushort;
pub const __gid_t = __kernel_gid32_t;
pub const gid_t = __gid_t;
pub const __uid_t = __kernel_uid32_t;
pub const uid_t = __uid_t;
pub const __pid_t = __kernel_pid_t;
pub const pid_t = __pid_t;
pub const __id_t = u32;
pub const id_t = __id_t;
pub const blkcnt_t = c_ulong;
pub const blksize_t = c_ulong;
pub const caddr_t = __kernel_caddr_t;
pub const clock_t = __kernel_clock_t;
pub const __clockid_t = __kernel_clockid_t;
pub const clockid_t = __clockid_t;
pub const daddr_t = __kernel_daddr_t;
pub const fsblkcnt_t = c_ulong;
pub const fsfilcnt_t = c_ulong;
pub const __mode_t = __kernel_mode_t;
pub const mode_t = __mode_t;
pub const __key_t = __kernel_key_t;
pub const key_t = __key_t;
pub const __ino_t = __kernel_ino_t;
pub const ino_t = __ino_t;
pub const ino64_t = u64;
pub const __nlink_t = u32;
pub const nlink_t = __nlink_t;
pub const __timer_t = ?*anyopaque;
pub const timer_t = __timer_t;
pub const __suseconds_t = __kernel_suseconds_t;
pub const suseconds_t = __suseconds_t;
pub const __useconds_t = u32;
pub const useconds_t = __useconds_t;
pub const dev_t = u32;
pub const __time_t = __kernel_time_t;
pub const time_t = __time_t;
pub const off_t = __kernel_off_t;
pub const loff_t = __kernel_loff_t;
pub const off64_t = loff_t;
pub const __socklen_t = i32;
pub const socklen_t = __socklen_t;
pub const __builtin_va_list = [*c]u8;
pub const __va_list = __builtin_va_list;
pub const uint_t = c_uint;
pub const uint = c_uint;
pub const struct_AAssetManager = opaque {};
pub const AAssetManager = struct_AAssetManager;
pub const struct_AAssetDir = opaque {};
pub const AAssetDir = struct_AAssetDir;
pub const struct_AAsset = opaque {};
pub const AAsset = struct_AAsset;
pub const AASSET_MODE_UNKNOWN: c_int = 0;
pub const AASSET_MODE_RANDOM: c_int = 1;
pub const AASSET_MODE_STREAMING: c_int = 2;
pub const AASSET_MODE_BUFFER: c_int = 3;
const enum_unnamed_1 = c_uint;
pub extern fn AAssetManager_openDir(mgr: ?*AAssetManager, dirName: [*c]const u8) ?*AAssetDir;
pub extern fn AAssetManager_open(mgr: ?*AAssetManager, filename: [*c]const u8, mode: c_int) ?*AAsset;
pub extern fn AAssetDir_getNextFileName(assetDir: ?*AAssetDir) [*c]const u8;
pub extern fn AAssetDir_rewind(assetDir: ?*AAssetDir) void;
pub extern fn AAssetDir_close(assetDir: ?*AAssetDir) void;
pub extern fn AAsset_read(asset: ?*AAsset, buf: ?*anyopaque, count: usize) c_int;
pub extern fn AAsset_seek(asset: ?*AAsset, offset: off_t, whence: c_int) off_t;
pub extern fn AAsset_seek64(asset: ?*AAsset, offset: off64_t, whence: c_int) off64_t;
pub extern fn AAsset_close(asset: ?*AAsset) void;
pub extern fn AAsset_getBuffer(asset: ?*AAsset) ?*const anyopaque;
pub extern fn AAsset_getLength(asset: ?*AAsset) off_t;
pub extern fn AAsset_getLength64(asset: ?*AAsset) off64_t;
pub extern fn AAsset_getRemainingLength(asset: ?*AAsset) off_t;
pub extern fn AAsset_getRemainingLength64(asset: ?*AAsset) off64_t;
pub extern fn AAsset_openFileDescriptor(asset: ?*AAsset, outStart: [*c]off_t, outLength: [*c]off_t) c_int;
pub extern fn AAsset_openFileDescriptor64(asset: ?*AAsset, outStart: [*c]off64_t, outLength: [*c]off64_t) c_int;
pub extern fn AAsset_isAllocated(asset: ?*AAsset) c_int;
pub const struct_AConfiguration = opaque {};
pub const AConfiguration = struct_AConfiguration;
pub const ACONFIGURATION_ORIENTATION_ANY: c_int = 0;
pub const ACONFIGURATION_ORIENTATION_PORT: c_int = 1;
pub const ACONFIGURATION_ORIENTATION_LAND: c_int = 2;
pub const ACONFIGURATION_ORIENTATION_SQUARE: c_int = 3;
pub const ACONFIGURATION_TOUCHSCREEN_ANY: c_int = 0;
pub const ACONFIGURATION_TOUCHSCREEN_NOTOUCH: c_int = 1;
pub const ACONFIGURATION_TOUCHSCREEN_STYLUS: c_int = 2;
pub const ACONFIGURATION_TOUCHSCREEN_FINGER: c_int = 3;
pub const ACONFIGURATION_DENSITY_DEFAULT: c_int = 0;
pub const ACONFIGURATION_DENSITY_LOW: c_int = 120;
pub const ACONFIGURATION_DENSITY_MEDIUM: c_int = 160;
pub const ACONFIGURATION_DENSITY_TV: c_int = 213;
pub const ACONFIGURATION_DENSITY_HIGH: c_int = 240;
pub const ACONFIGURATION_DENSITY_XHIGH: c_int = 320;
pub const ACONFIGURATION_DENSITY_XXHIGH: c_int = 480;
pub const ACONFIGURATION_DENSITY_XXXHIGH: c_int = 640;
pub const ACONFIGURATION_DENSITY_ANY: c_int = 65534;
pub const ACONFIGURATION_DENSITY_NONE: c_int = 65535;
pub const ACONFIGURATION_KEYBOARD_ANY: c_int = 0;
pub const ACONFIGURATION_KEYBOARD_NOKEYS: c_int = 1;
pub const ACONFIGURATION_KEYBOARD_QWERTY: c_int = 2;
pub const ACONFIGURATION_KEYBOARD_12KEY: c_int = 3;
pub const ACONFIGURATION_NAVIGATION_ANY: c_int = 0;
pub const ACONFIGURATION_NAVIGATION_NONAV: c_int = 1;
pub const ACONFIGURATION_NAVIGATION_DPAD: c_int = 2;
pub const ACONFIGURATION_NAVIGATION_TRACKBALL: c_int = 3;
pub const ACONFIGURATION_NAVIGATION_WHEEL: c_int = 4;
pub const ACONFIGURATION_KEYSHIDDEN_ANY: c_int = 0;
pub const ACONFIGURATION_KEYSHIDDEN_NO: c_int = 1;
pub const ACONFIGURATION_KEYSHIDDEN_YES: c_int = 2;
pub const ACONFIGURATION_KEYSHIDDEN_SOFT: c_int = 3;
pub const ACONFIGURATION_NAVHIDDEN_ANY: c_int = 0;
pub const ACONFIGURATION_NAVHIDDEN_NO: c_int = 1;
pub const ACONFIGURATION_NAVHIDDEN_YES: c_int = 2;
pub const ACONFIGURATION_SCREENSIZE_ANY: c_int = 0;
pub const ACONFIGURATION_SCREENSIZE_SMALL: c_int = 1;
pub const ACONFIGURATION_SCREENSIZE_NORMAL: c_int = 2;
pub const ACONFIGURATION_SCREENSIZE_LARGE: c_int = 3;
pub const ACONFIGURATION_SCREENSIZE_XLARGE: c_int = 4;
pub const ACONFIGURATION_SCREENLONG_ANY: c_int = 0;
pub const ACONFIGURATION_SCREENLONG_NO: c_int = 1;
pub const ACONFIGURATION_SCREENLONG_YES: c_int = 2;
pub const ACONFIGURATION_SCREENROUND_ANY: c_int = 0;
pub const ACONFIGURATION_SCREENROUND_NO: c_int = 1;
pub const ACONFIGURATION_SCREENROUND_YES: c_int = 2;
pub const ACONFIGURATION_WIDE_COLOR_GAMUT_ANY: c_int = 0;
pub const ACONFIGURATION_WIDE_COLOR_GAMUT_NO: c_int = 1;
pub const ACONFIGURATION_WIDE_COLOR_GAMUT_YES: c_int = 2;
pub const ACONFIGURATION_HDR_ANY: c_int = 0;
pub const ACONFIGURATION_HDR_NO: c_int = 1;
pub const ACONFIGURATION_HDR_YES: c_int = 2;
pub const ACONFIGURATION_UI_MODE_TYPE_ANY: c_int = 0;
pub const ACONFIGURATION_UI_MODE_TYPE_NORMAL: c_int = 1;
pub const ACONFIGURATION_UI_MODE_TYPE_DESK: c_int = 2;
pub const ACONFIGURATION_UI_MODE_TYPE_CAR: c_int = 3;
pub const ACONFIGURATION_UI_MODE_TYPE_TELEVISION: c_int = 4;
pub const ACONFIGURATION_UI_MODE_TYPE_APPLIANCE: c_int = 5;
pub const ACONFIGURATION_UI_MODE_TYPE_WATCH: c_int = 6;
pub const ACONFIGURATION_UI_MODE_TYPE_VR_HEADSET: c_int = 7;
pub const ACONFIGURATION_UI_MODE_NIGHT_ANY: c_int = 0;
pub const ACONFIGURATION_UI_MODE_NIGHT_NO: c_int = 1;
pub const ACONFIGURATION_UI_MODE_NIGHT_YES: c_int = 2;
pub const ACONFIGURATION_SCREEN_WIDTH_DP_ANY: c_int = 0;
pub const ACONFIGURATION_SCREEN_HEIGHT_DP_ANY: c_int = 0;
pub const ACONFIGURATION_SMALLEST_SCREEN_WIDTH_DP_ANY: c_int = 0;
pub const ACONFIGURATION_LAYOUTDIR_ANY: c_int = 0;
pub const ACONFIGURATION_LAYOUTDIR_LTR: c_int = 1;
pub const ACONFIGURATION_LAYOUTDIR_RTL: c_int = 2;
pub const ACONFIGURATION_MCC: c_int = 1;
pub const ACONFIGURATION_MNC: c_int = 2;
pub const ACONFIGURATION_LOCALE: c_int = 4;
pub const ACONFIGURATION_TOUCHSCREEN: c_int = 8;
pub const ACONFIGURATION_KEYBOARD: c_int = 16;
pub const ACONFIGURATION_KEYBOARD_HIDDEN: c_int = 32;
pub const ACONFIGURATION_NAVIGATION: c_int = 64;
pub const ACONFIGURATION_ORIENTATION: c_int = 128;
pub const ACONFIGURATION_DENSITY: c_int = 256;
pub const ACONFIGURATION_SCREEN_SIZE: c_int = 512;
pub const ACONFIGURATION_VERSION: c_int = 1024;
pub const ACONFIGURATION_SCREEN_LAYOUT: c_int = 2048;
pub const ACONFIGURATION_UI_MODE: c_int = 4096;
pub const ACONFIGURATION_SMALLEST_SCREEN_SIZE: c_int = 8192;
pub const ACONFIGURATION_LAYOUTDIR: c_int = 16384;
pub const ACONFIGURATION_SCREEN_ROUND: c_int = 32768;
pub const ACONFIGURATION_COLOR_MODE: c_int = 65536;
pub const ACONFIGURATION_GRAMMATICAL_GENDER: c_int = 131072;
pub const ACONFIGURATION_MNC_ZERO: c_int = 65535;
pub const ACONFIGURATION_GRAMMATICAL_GENDER_ANY: c_int = 0;
pub const ACONFIGURATION_GRAMMATICAL_GENDER_NEUTER: c_int = 1;
pub const ACONFIGURATION_GRAMMATICAL_GENDER_FEMININE: c_int = 2;
pub const ACONFIGURATION_GRAMMATICAL_GENDER_MASCULINE: c_int = 3;
const enum_unnamed_2 = c_uint;
pub extern fn AConfiguration_new(...) ?*AConfiguration;
pub extern fn AConfiguration_delete(config: ?*AConfiguration) void;
pub extern fn AConfiguration_fromAssetManager(out: ?*AConfiguration, am: ?*AAssetManager) void;
pub extern fn AConfiguration_copy(dest: ?*AConfiguration, src: ?*AConfiguration) void;
pub extern fn AConfiguration_getMcc(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setMcc(config: ?*AConfiguration, mcc: i32) void;
pub extern fn AConfiguration_getMnc(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setMnc(config: ?*AConfiguration, mnc: i32) void;
pub extern fn AConfiguration_getLanguage(config: ?*AConfiguration, outLanguage: [*c]u8) void;
pub extern fn AConfiguration_setLanguage(config: ?*AConfiguration, language: [*c]const u8) void;
pub extern fn AConfiguration_getCountry(config: ?*AConfiguration, outCountry: [*c]u8) void;
pub extern fn AConfiguration_setCountry(config: ?*AConfiguration, country: [*c]const u8) void;
pub extern fn AConfiguration_getOrientation(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setOrientation(config: ?*AConfiguration, orientation: i32) void;
pub extern fn AConfiguration_getTouchscreen(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setTouchscreen(config: ?*AConfiguration, touchscreen: i32) void;
pub extern fn AConfiguration_getDensity(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setDensity(config: ?*AConfiguration, density: i32) void;
pub extern fn AConfiguration_getKeyboard(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setKeyboard(config: ?*AConfiguration, keyboard: i32) void;
pub extern fn AConfiguration_getNavigation(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setNavigation(config: ?*AConfiguration, navigation: i32) void;
pub extern fn AConfiguration_getKeysHidden(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setKeysHidden(config: ?*AConfiguration, keysHidden: i32) void;
pub extern fn AConfiguration_getNavHidden(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setNavHidden(config: ?*AConfiguration, navHidden: i32) void;
pub extern fn AConfiguration_getSdkVersion(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setSdkVersion(config: ?*AConfiguration, sdkVersion: i32) void;
pub extern fn AConfiguration_getScreenSize(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setScreenSize(config: ?*AConfiguration, screenSize: i32) void;
pub extern fn AConfiguration_getScreenLong(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setScreenLong(config: ?*AConfiguration, screenLong: i32) void;
pub extern fn AConfiguration_getScreenRound(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setScreenRound(config: ?*AConfiguration, screenRound: i32) void;
pub extern fn AConfiguration_getUiModeType(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setUiModeType(config: ?*AConfiguration, uiModeType: i32) void;
pub extern fn AConfiguration_getUiModeNight(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setUiModeNight(config: ?*AConfiguration, uiModeNight: i32) void;
pub extern fn AConfiguration_getScreenWidthDp(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setScreenWidthDp(config: ?*AConfiguration, value: i32) void;
pub extern fn AConfiguration_getScreenHeightDp(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setScreenHeightDp(config: ?*AConfiguration, value: i32) void;
pub extern fn AConfiguration_getSmallestScreenWidthDp(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setSmallestScreenWidthDp(config: ?*AConfiguration, value: i32) void;
pub extern fn AConfiguration_getLayoutDirection(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setLayoutDirection(config: ?*AConfiguration, value: i32) void;
pub extern fn AConfiguration_getGrammaticalGender(config: ?*AConfiguration) i32;
pub extern fn AConfiguration_setGrammaticalGender(config: ?*AConfiguration, value: i32) void;
pub extern fn AConfiguration_diff(config1: ?*AConfiguration, config2: ?*AConfiguration) i32;
pub extern fn AConfiguration_match(base: ?*AConfiguration, requested: ?*AConfiguration) i32;
pub extern fn AConfiguration_isBetterThan(base: ?*AConfiguration, @"test": ?*AConfiguration, requested: ?*AConfiguration) i32;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __builtin_va_list;
pub const ANDROID_LOG_UNKNOWN: c_int = 0;
pub const ANDROID_LOG_DEFAULT: c_int = 1;
pub const ANDROID_LOG_VERBOSE: c_int = 2;
pub const ANDROID_LOG_DEBUG: c_int = 3;
pub const ANDROID_LOG_INFO: c_int = 4;
pub const ANDROID_LOG_WARN: c_int = 5;
pub const ANDROID_LOG_ERROR: c_int = 6;
pub const ANDROID_LOG_FATAL: c_int = 7;
pub const ANDROID_LOG_SILENT: c_int = 8;
pub const enum_android_LogPriority = c_uint;
pub const android_LogPriority = enum_android_LogPriority;
pub extern fn __android_log_write(prio: c_int, tag: [*c]const u8, text: [*c]const u8) c_int;
pub extern fn __android_log_print(prio: c_int, tag: [*c]const u8, fmt: [*c]const u8, ...) c_int;
pub extern fn __android_log_vprint(prio: c_int, tag: [*c]const u8, fmt: [*c]const u8, ap: va_list) c_int;
pub extern fn __android_log_assert(cond: [*c]const u8, tag: [*c]const u8, fmt: [*c]const u8, ...) noreturn;
pub const LOG_ID_MIN: c_int = 0;
pub const LOG_ID_MAIN: c_int = 0;
pub const LOG_ID_RADIO: c_int = 1;
pub const LOG_ID_EVENTS: c_int = 2;
pub const LOG_ID_SYSTEM: c_int = 3;
pub const LOG_ID_CRASH: c_int = 4;
pub const LOG_ID_STATS: c_int = 5;
pub const LOG_ID_SECURITY: c_int = 6;
pub const LOG_ID_KERNEL: c_int = 7;
pub const LOG_ID_MAX: c_int = 8;
pub const LOG_ID_DEFAULT: c_int = 2147483647;
pub const enum_log_id = c_uint;
pub const log_id_t = enum_log_id;
pub extern fn __android_log_buf_write(bufID: c_int, prio: c_int, tag: [*c]const u8, text: [*c]const u8) c_int;
pub extern fn __android_log_buf_print(bufID: c_int, prio: c_int, tag: [*c]const u8, fmt: [*c]const u8, ...) c_int;
pub const struct___android_log_message = extern struct {
    struct_size: usize = @import("std").mem.zeroes(usize),
    buffer_id: i32 = @import("std").mem.zeroes(i32),
    priority: i32 = @import("std").mem.zeroes(i32),
    tag: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    file: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    line: u32 = @import("std").mem.zeroes(u32),
    message: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
};
pub const __android_logger_function = ?*const fn ([*c]const struct___android_log_message) callconv(.C) void;
pub const __android_aborter_function = ?*const fn ([*c]const u8) callconv(.C) void;
pub extern fn __android_log_write_log_message(log_message: [*c]struct___android_log_message) void;
pub extern fn __android_log_set_logger(logger: __android_logger_function) void;
pub extern fn __android_log_logd_logger(log_message: [*c]const struct___android_log_message) void;
pub extern fn __android_log_stderr_logger(log_message: [*c]const struct___android_log_message) void;
pub extern fn __android_log_set_aborter(aborter: __android_aborter_function) void;
pub extern fn __android_log_call_aborter(abort_message: [*c]const u8) void;
pub extern fn __android_log_default_aborter(abort_message: [*c]const u8) noreturn;
pub extern fn __android_log_is_loggable(prio: c_int, tag: [*c]const u8, default_prio: c_int) c_int;
pub extern fn __android_log_is_loggable_len(prio: c_int, tag: [*c]const u8, len: usize, default_prio: c_int) c_int;
pub extern fn __android_log_set_minimum_priority(priority: i32) i32;
pub extern fn __android_log_get_minimum_priority() i32;
pub extern fn __android_log_set_default_tag(tag: [*c]const u8) void;
pub const struct_ALooper = opaque {};
pub const ALooper = struct_ALooper;
pub extern fn ALooper_forThread(...) ?*ALooper;
pub const ALOOPER_PREPARE_ALLOW_NON_CALLBACKS: c_int = 1;
const enum_unnamed_3 = c_uint;
pub extern fn ALooper_prepare(opts: c_int) ?*ALooper;
pub const ALOOPER_POLL_WAKE: c_int = -1;
pub const ALOOPER_POLL_CALLBACK: c_int = -2;
pub const ALOOPER_POLL_TIMEOUT: c_int = -3;
pub const ALOOPER_POLL_ERROR: c_int = -4;
const enum_unnamed_4 = c_int;
pub extern fn ALooper_acquire(looper: ?*ALooper) void;
pub extern fn ALooper_release(looper: ?*ALooper) void;
pub const ALOOPER_EVENT_INPUT: c_int = 1;
pub const ALOOPER_EVENT_OUTPUT: c_int = 2;
pub const ALOOPER_EVENT_ERROR: c_int = 4;
pub const ALOOPER_EVENT_HANGUP: c_int = 8;
pub const ALOOPER_EVENT_INVALID: c_int = 16;
const enum_unnamed_5 = c_uint;
pub const ALooper_callbackFunc = ?*const fn (c_int, c_int, ?*anyopaque) callconv(.C) c_int;
pub extern fn ALooper_pollOnce(timeoutMillis: c_int, outFd: [*c]c_int, outEvents: [*c]c_int, outData: [*c]?*anyopaque) c_int;
pub extern fn ALooper_pollAll(timeoutMillis: c_int, outFd: [*c]c_int, outEvents: [*c]c_int, outData: [*c]?*anyopaque) c_int;
pub extern fn ALooper_wake(looper: ?*ALooper) void;
pub extern fn ALooper_addFd(looper: ?*ALooper, fd: c_int, ident: c_int, events: c_int, callback: ALooper_callbackFunc, data: ?*anyopaque) c_int;
pub extern fn ALooper_removeFd(looper: ?*ALooper, fd: c_int) c_int;
pub const jboolean = u8;
pub const jbyte = i8;
pub const jchar = u16;
pub const jshort = i16;
pub const jint = i32;
pub const jlong = i64;
pub const jfloat = f32;
pub const jdouble = f64;
pub const jsize = jint;
pub const jobject = ?*anyopaque;
pub const jclass = jobject;
pub const jstring = jobject;
pub const jarray = jobject;
pub const jobjectArray = jarray;
pub const jbooleanArray = jarray;
pub const jbyteArray = jarray;
pub const jcharArray = jarray;
pub const jshortArray = jarray;
pub const jintArray = jarray;
pub const jlongArray = jarray;
pub const jfloatArray = jarray;
pub const jdoubleArray = jarray;
pub const jthrowable = jobject;
pub const jweak = jobject;
pub const struct__jfieldID = opaque {};
pub const jfieldID = ?*struct__jfieldID;
pub const struct__jmethodID = opaque {};
pub const jmethodID = ?*struct__jmethodID;
pub const JavaVM = [*c]const struct_JNIInvokeInterface;
pub const union_jvalue = extern union {
    z: jboolean,
    b: jbyte,
    c: jchar,
    s: jshort,
    i: jint,
    j: jlong,
    f: jfloat,
    d: jdouble,
    l: jobject,
};
pub const jvalue = union_jvalue;
pub const JNIInvalidRefType: c_int = 0;
pub const JNILocalRefType: c_int = 1;
pub const JNIGlobalRefType: c_int = 2;
pub const JNIWeakGlobalRefType: c_int = 3;
pub const enum_jobjectRefType = c_uint;
pub const jobjectRefType = enum_jobjectRefType;
pub const struct_JNINativeInterface = extern struct {
    reserved0: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved3: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    GetVersion: ?*const fn ([*c]JNIEnv) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jint),
    DefineClass: ?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8, jobject, [*c]const jbyte, jsize) callconv(.C) jclass),
    FindClass: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jclass),
    FromReflectedMethod: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jmethodID),
    FromReflectedField: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jfieldID),
    ToReflectedMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, jboolean) callconv(.C) jobject),
    GetSuperclass: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jclass),
    IsAssignableFrom: ?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jclass) callconv(.C) jboolean),
    ToReflectedField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) jobject),
    Throw: ?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jthrowable) callconv(.C) jint),
    ThrowNew: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8) callconv(.C) jint),
    ExceptionOccurred: ?*const fn ([*c]JNIEnv) callconv(.C) jthrowable = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jthrowable),
    ExceptionDescribe: ?*const fn ([*c]JNIEnv) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    ExceptionClear: ?*const fn ([*c]JNIEnv) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) void),
    FatalError: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) void),
    PushLocalFrame: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    PopLocalFrame: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    NewGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    DeleteGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    DeleteLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) void),
    IsSameObject: ?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jobject) callconv(.C) jboolean),
    NewLocalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobject),
    EnsureLocalCapacity: ?*const fn ([*c]JNIEnv, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jint) callconv(.C) jint),
    AllocObject: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jobject),
    NewObject: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    NewObjectV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject),
    NewObjectA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    GetObjectClass: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jclass),
    IsInstanceOf: ?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass) callconv(.C) jboolean),
    GetMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jobject),
    CallObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jobject),
    CallObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jboolean),
    CallBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jboolean),
    CallBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallByteMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jbyte),
    CallByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jbyte),
    CallByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallCharMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jchar),
    CallCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jchar),
    CallCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallShortMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jshort),
    CallShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jshort),
    CallShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallIntMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jint),
    CallIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jint),
    CallIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallLongMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jlong),
    CallLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jlong),
    CallLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jfloat),
    CallFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jfloat),
    CallFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) jdouble),
    CallDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) jdouble),
    CallDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, ...) callconv(.C) void),
    CallVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, va_list) callconv(.C) void),
    CallVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jmethodID, [*c]const jvalue) callconv(.C) void),
    CallNonvirtualObjectMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jobject),
    CallNonvirtualObjectMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jobject),
    CallNonvirtualObjectMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallNonvirtualBooleanMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jboolean),
    CallNonvirtualBooleanMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallNonvirtualByteMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallNonvirtualByteMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jbyte),
    CallNonvirtualByteMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallNonvirtualCharMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jchar),
    CallNonvirtualCharMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jchar),
    CallNonvirtualCharMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallNonvirtualShortMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jshort),
    CallNonvirtualShortMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jshort),
    CallNonvirtualShortMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallNonvirtualIntMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jint),
    CallNonvirtualIntMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jint),
    CallNonvirtualIntMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallNonvirtualLongMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jlong),
    CallNonvirtualLongMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jlong),
    CallNonvirtualLongMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallNonvirtualFloatMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallNonvirtualFloatMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jfloat),
    CallNonvirtualFloatMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallNonvirtualDoubleMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) jdouble),
    CallNonvirtualDoubleMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallNonvirtualVoidMethod: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, ...) callconv(.C) void),
    CallNonvirtualVoidMethodV: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, va_list) callconv(.C) void),
    CallNonvirtualVoidMethodA: ?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jobject),
    GetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jboolean),
    GetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jbyte),
    GetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jchar),
    GetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jshort),
    GetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jint),
    GetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jlong),
    GetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jfloat),
    GetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID) callconv(.C) jdouble),
    SetObjectField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jobject) callconv(.C) void),
    SetBooleanField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jboolean) callconv(.C) void),
    SetByteField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jbyte) callconv(.C) void),
    SetCharField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jchar) callconv(.C) void),
    SetShortField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jshort) callconv(.C) void),
    SetIntField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jint) callconv(.C) void),
    SetLongField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jlong) callconv(.C) void),
    SetFloatField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jfloat) callconv(.C) void),
    SetDoubleField: ?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject, jfieldID, jdouble) callconv(.C) void),
    GetStaticMethodID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jmethodID),
    CallStaticObjectMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jobject),
    CallStaticObjectMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jobject),
    CallStaticObjectMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jobject),
    CallStaticBooleanMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jboolean),
    CallStaticBooleanMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jboolean),
    CallStaticBooleanMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jboolean),
    CallStaticByteMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jbyte),
    CallStaticByteMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jbyte),
    CallStaticByteMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jbyte),
    CallStaticCharMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jchar),
    CallStaticCharMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jchar),
    CallStaticCharMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jchar),
    CallStaticShortMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jshort),
    CallStaticShortMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jshort),
    CallStaticShortMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jshort),
    CallStaticIntMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jint),
    CallStaticIntMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jint),
    CallStaticIntMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jint),
    CallStaticLongMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jlong),
    CallStaticLongMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jlong),
    CallStaticLongMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jlong),
    CallStaticFloatMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jfloat),
    CallStaticFloatMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jfloat),
    CallStaticFloatMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jfloat),
    CallStaticDoubleMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) jdouble),
    CallStaticDoubleMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) jdouble),
    CallStaticDoubleMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) jdouble),
    CallStaticVoidMethod: ?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, ...) callconv(.C) void),
    CallStaticVoidMethodV: ?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, va_list) callconv(.C) void),
    CallStaticVoidMethodA: ?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jmethodID, [*c]const jvalue) callconv(.C) void),
    GetStaticFieldID: ?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const u8, [*c]const u8) callconv(.C) jfieldID),
    GetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jobject),
    GetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jboolean),
    GetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jbyte),
    GetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jchar),
    GetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jshort),
    GetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jint),
    GetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jlong),
    GetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jfloat),
    GetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID) callconv(.C) jdouble),
    SetStaticObjectField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jobject) callconv(.C) void),
    SetStaticBooleanField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jboolean) callconv(.C) void),
    SetStaticByteField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jbyte) callconv(.C) void),
    SetStaticCharField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jchar) callconv(.C) void),
    SetStaticShortField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jshort) callconv(.C) void),
    SetStaticIntField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jint) callconv(.C) void),
    SetStaticLongField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jlong) callconv(.C) void),
    SetStaticFloatField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jfloat) callconv(.C) void),
    SetStaticDoubleField: ?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, jfieldID, jdouble) callconv(.C) void),
    NewString: ?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const jchar, jsize) callconv(.C) jstring),
    GetStringLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewStringUTF: ?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c]const u8) callconv(.C) jstring),
    GetStringUTFLength: ?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring) callconv(.C) jsize),
    GetStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8 = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const u8),
    ReleaseStringUTFChars: ?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const u8) callconv(.C) void),
    GetArrayLength: ?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray) callconv(.C) jsize),
    NewObjectArray: ?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize, jclass, jobject) callconv(.C) jobjectArray),
    GetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize) callconv(.C) jobject),
    SetObjectArrayElement: ?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobjectArray, jsize, jobject) callconv(.C) void),
    NewBooleanArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbooleanArray),
    NewByteArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jbyteArray),
    NewCharArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jcharArray),
    NewShortArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jshortArray),
    NewIntArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jintArray),
    NewLongArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jlongArray),
    NewFloatArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jfloatArray),
    NewDoubleArray: ?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jsize) callconv(.C) jdoubleArray),
    GetBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean) callconv(.C) [*c]jboolean),
    GetByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jboolean) callconv(.C) [*c]jbyte),
    GetCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jboolean) callconv(.C) [*c]jchar),
    GetShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jboolean) callconv(.C) [*c]jshort),
    GetIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jboolean) callconv(.C) [*c]jint),
    GetLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jboolean) callconv(.C) [*c]jlong),
    GetFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jboolean) callconv(.C) [*c]jfloat),
    GetDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jboolean) callconv(.C) [*c]jdouble),
    ReleaseBooleanArrayElements: ?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, [*c]jboolean, jint) callconv(.C) void),
    ReleaseByteArrayElements: ?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, [*c]jbyte, jint) callconv(.C) void),
    ReleaseCharArrayElements: ?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, [*c]jchar, jint) callconv(.C) void),
    ReleaseShortArrayElements: ?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, [*c]jshort, jint) callconv(.C) void),
    ReleaseIntArrayElements: ?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, [*c]jint, jint) callconv(.C) void),
    ReleaseLongArrayElements: ?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, [*c]jlong, jint) callconv(.C) void),
    ReleaseFloatArrayElements: ?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, [*c]jfloat, jint) callconv(.C) void),
    ReleaseDoubleArrayElements: ?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, [*c]jdouble, jint) callconv(.C) void),
    GetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]jboolean) callconv(.C) void),
    GetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]jbyte) callconv(.C) void),
    GetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]jshort) callconv(.C) void),
    GetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]jint) callconv(.C) void),
    GetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]jlong) callconv(.C) void),
    GetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]jfloat) callconv(.C) void),
    GetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]jdouble) callconv(.C) void),
    SetBooleanArrayRegion: ?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbooleanArray, jsize, jsize, [*c]const jboolean) callconv(.C) void),
    SetByteArrayRegion: ?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jbyteArray, jsize, jsize, [*c]const jbyte) callconv(.C) void),
    SetCharArrayRegion: ?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jcharArray, jsize, jsize, [*c]const jchar) callconv(.C) void),
    SetShortArrayRegion: ?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jshortArray, jsize, jsize, [*c]const jshort) callconv(.C) void),
    SetIntArrayRegion: ?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jintArray, jsize, jsize, [*c]const jint) callconv(.C) void),
    SetLongArrayRegion: ?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jlongArray, jsize, jsize, [*c]const jlong) callconv(.C) void),
    SetFloatArrayRegion: ?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jfloatArray, jsize, jsize, [*c]const jfloat) callconv(.C) void),
    SetDoubleArrayRegion: ?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jdoubleArray, jsize, jsize, [*c]const jdouble) callconv(.C) void),
    RegisterNatives: ?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass, [*c]const JNINativeMethod, jint) callconv(.C) jint),
    UnregisterNatives: ?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jclass) callconv(.C) jint),
    MonitorEnter: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    MonitorExit: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jint),
    GetJavaVM: ?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, [*c][*c]JavaVM) callconv(.C) jint),
    GetStringRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]jchar) callconv(.C) void),
    GetStringUTFRegion: ?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, jsize, jsize, [*c]u8) callconv(.C) void),
    GetPrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray, [*c]jboolean) callconv(.C) ?*anyopaque),
    ReleasePrimitiveArrayCritical: ?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jarray, ?*anyopaque, jint) callconv(.C) void),
    GetStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]jboolean) callconv(.C) [*c]const jchar),
    ReleaseStringCritical: ?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jstring, [*c]const jchar) callconv(.C) void),
    NewWeakGlobalRef: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jweak),
    DeleteWeakGlobalRef: ?*const fn ([*c]JNIEnv, jweak) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jweak) callconv(.C) void),
    ExceptionCheck: ?*const fn ([*c]JNIEnv) callconv(.C) jboolean = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv) callconv(.C) jboolean),
    NewDirectByteBuffer: ?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, ?*anyopaque, jlong) callconv(.C) jobject),
    GetDirectBufferAddress: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) ?*anyopaque),
    GetDirectBufferCapacity: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jlong),
    GetObjectRefType: ?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType = @import("std").mem.zeroes(?*const fn ([*c]JNIEnv, jobject) callconv(.C) jobjectRefType),
};
pub const JNIEnv = [*c]const struct_JNINativeInterface;
pub const struct_JNIInvokeInterface = extern struct {
    reserved0: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved1: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved2: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    DestroyJavaVM: ?*const fn ([*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    AttachCurrentThread: ?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint),
    DetachCurrentThread: ?*const fn ([*c]JavaVM) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM) callconv(.C) jint),
    GetEnv: ?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c]?*anyopaque, jint) callconv(.C) jint),
    AttachCurrentThreadAsDaemon: ?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint = @import("std").mem.zeroes(?*const fn ([*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) callconv(.C) jint),
};
pub const JNINativeMethod = extern struct {
    name: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    signature: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    fnPtr: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const struct__JNIEnv = extern struct {
    functions: [*c]const struct_JNINativeInterface = @import("std").mem.zeroes([*c]const struct_JNINativeInterface),
};
pub const struct__JavaVM = extern struct {
    functions: [*c]const struct_JNIInvokeInterface = @import("std").mem.zeroes([*c]const struct_JNIInvokeInterface),
};
pub const C_JNIEnv = [*c]const struct_JNINativeInterface;
pub const struct_JavaVMAttachArgs = extern struct {
    version: jint = @import("std").mem.zeroes(jint),
    name: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    group: jobject = @import("std").mem.zeroes(jobject),
};
pub const JavaVMAttachArgs = struct_JavaVMAttachArgs;
pub const struct_JavaVMOption = extern struct {
    optionString: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    extraInfo: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const JavaVMOption = struct_JavaVMOption;
pub const struct_JavaVMInitArgs = extern struct {
    version: jint = @import("std").mem.zeroes(jint),
    nOptions: jint = @import("std").mem.zeroes(jint),
    options: [*c]JavaVMOption = @import("std").mem.zeroes([*c]JavaVMOption),
    ignoreUnrecognized: jboolean = @import("std").mem.zeroes(jboolean),
};
pub const JavaVMInitArgs = struct_JavaVMInitArgs;
pub extern fn JNI_GetDefaultJavaVMInitArgs(?*anyopaque) jint;
pub extern fn JNI_CreateJavaVM([*c][*c]JavaVM, [*c][*c]JNIEnv, ?*anyopaque) jint;
pub extern fn JNI_GetCreatedJavaVMs([*c][*c]JavaVM, jsize, [*c]jsize) jint;
pub extern fn JNI_OnLoad(vm: [*c]JavaVM, reserved: ?*anyopaque) jint;
pub extern fn JNI_OnUnload(vm: [*c]JavaVM, reserved: ?*anyopaque) void;
pub const AKEYCODE_UNKNOWN: c_int = 0;
pub const AKEYCODE_SOFT_LEFT: c_int = 1;
pub const AKEYCODE_SOFT_RIGHT: c_int = 2;
pub const AKEYCODE_HOME: c_int = 3;
pub const AKEYCODE_BACK: c_int = 4;
pub const AKEYCODE_CALL: c_int = 5;
pub const AKEYCODE_ENDCALL: c_int = 6;
pub const AKEYCODE_0: c_int = 7;
pub const AKEYCODE_1: c_int = 8;
pub const AKEYCODE_2: c_int = 9;
pub const AKEYCODE_3: c_int = 10;
pub const AKEYCODE_4: c_int = 11;
pub const AKEYCODE_5: c_int = 12;
pub const AKEYCODE_6: c_int = 13;
pub const AKEYCODE_7: c_int = 14;
pub const AKEYCODE_8: c_int = 15;
pub const AKEYCODE_9: c_int = 16;
pub const AKEYCODE_STAR: c_int = 17;
pub const AKEYCODE_POUND: c_int = 18;
pub const AKEYCODE_DPAD_UP: c_int = 19;
pub const AKEYCODE_DPAD_DOWN: c_int = 20;
pub const AKEYCODE_DPAD_LEFT: c_int = 21;
pub const AKEYCODE_DPAD_RIGHT: c_int = 22;
pub const AKEYCODE_DPAD_CENTER: c_int = 23;
pub const AKEYCODE_VOLUME_UP: c_int = 24;
pub const AKEYCODE_VOLUME_DOWN: c_int = 25;
pub const AKEYCODE_POWER: c_int = 26;
pub const AKEYCODE_CAMERA: c_int = 27;
pub const AKEYCODE_CLEAR: c_int = 28;
pub const AKEYCODE_A: c_int = 29;
pub const AKEYCODE_B: c_int = 30;
pub const AKEYCODE_C: c_int = 31;
pub const AKEYCODE_D: c_int = 32;
pub const AKEYCODE_E: c_int = 33;
pub const AKEYCODE_F: c_int = 34;
pub const AKEYCODE_G: c_int = 35;
pub const AKEYCODE_H: c_int = 36;
pub const AKEYCODE_I: c_int = 37;
pub const AKEYCODE_J: c_int = 38;
pub const AKEYCODE_K: c_int = 39;
pub const AKEYCODE_L: c_int = 40;
pub const AKEYCODE_M: c_int = 41;
pub const AKEYCODE_N: c_int = 42;
pub const AKEYCODE_O: c_int = 43;
pub const AKEYCODE_P: c_int = 44;
pub const AKEYCODE_Q: c_int = 45;
pub const AKEYCODE_R: c_int = 46;
pub const AKEYCODE_S: c_int = 47;
pub const AKEYCODE_T: c_int = 48;
pub const AKEYCODE_U: c_int = 49;
pub const AKEYCODE_V: c_int = 50;
pub const AKEYCODE_W: c_int = 51;
pub const AKEYCODE_X: c_int = 52;
pub const AKEYCODE_Y: c_int = 53;
pub const AKEYCODE_Z: c_int = 54;
pub const AKEYCODE_COMMA: c_int = 55;
pub const AKEYCODE_PERIOD: c_int = 56;
pub const AKEYCODE_ALT_LEFT: c_int = 57;
pub const AKEYCODE_ALT_RIGHT: c_int = 58;
pub const AKEYCODE_SHIFT_LEFT: c_int = 59;
pub const AKEYCODE_SHIFT_RIGHT: c_int = 60;
pub const AKEYCODE_TAB: c_int = 61;
pub const AKEYCODE_SPACE: c_int = 62;
pub const AKEYCODE_SYM: c_int = 63;
pub const AKEYCODE_EXPLORER: c_int = 64;
pub const AKEYCODE_ENVELOPE: c_int = 65;
pub const AKEYCODE_ENTER: c_int = 66;
pub const AKEYCODE_DEL: c_int = 67;
pub const AKEYCODE_GRAVE: c_int = 68;
pub const AKEYCODE_MINUS: c_int = 69;
pub const AKEYCODE_EQUALS: c_int = 70;
pub const AKEYCODE_LEFT_BRACKET: c_int = 71;
pub const AKEYCODE_RIGHT_BRACKET: c_int = 72;
pub const AKEYCODE_BACKSLASH: c_int = 73;
pub const AKEYCODE_SEMICOLON: c_int = 74;
pub const AKEYCODE_APOSTROPHE: c_int = 75;
pub const AKEYCODE_SLASH: c_int = 76;
pub const AKEYCODE_AT: c_int = 77;
pub const AKEYCODE_NUM: c_int = 78;
pub const AKEYCODE_HEADSETHOOK: c_int = 79;
pub const AKEYCODE_FOCUS: c_int = 80;
pub const AKEYCODE_PLUS: c_int = 81;
pub const AKEYCODE_MENU: c_int = 82;
pub const AKEYCODE_NOTIFICATION: c_int = 83;
pub const AKEYCODE_SEARCH: c_int = 84;
pub const AKEYCODE_MEDIA_PLAY_PAUSE: c_int = 85;
pub const AKEYCODE_MEDIA_STOP: c_int = 86;
pub const AKEYCODE_MEDIA_NEXT: c_int = 87;
pub const AKEYCODE_MEDIA_PREVIOUS: c_int = 88;
pub const AKEYCODE_MEDIA_REWIND: c_int = 89;
pub const AKEYCODE_MEDIA_FAST_FORWARD: c_int = 90;
pub const AKEYCODE_MUTE: c_int = 91;
pub const AKEYCODE_PAGE_UP: c_int = 92;
pub const AKEYCODE_PAGE_DOWN: c_int = 93;
pub const AKEYCODE_PICTSYMBOLS: c_int = 94;
pub const AKEYCODE_SWITCH_CHARSET: c_int = 95;
pub const AKEYCODE_BUTTON_A: c_int = 96;
pub const AKEYCODE_BUTTON_B: c_int = 97;
pub const AKEYCODE_BUTTON_C: c_int = 98;
pub const AKEYCODE_BUTTON_X: c_int = 99;
pub const AKEYCODE_BUTTON_Y: c_int = 100;
pub const AKEYCODE_BUTTON_Z: c_int = 101;
pub const AKEYCODE_BUTTON_L1: c_int = 102;
pub const AKEYCODE_BUTTON_R1: c_int = 103;
pub const AKEYCODE_BUTTON_L2: c_int = 104;
pub const AKEYCODE_BUTTON_R2: c_int = 105;
pub const AKEYCODE_BUTTON_THUMBL: c_int = 106;
pub const AKEYCODE_BUTTON_THUMBR: c_int = 107;
pub const AKEYCODE_BUTTON_START: c_int = 108;
pub const AKEYCODE_BUTTON_SELECT: c_int = 109;
pub const AKEYCODE_BUTTON_MODE: c_int = 110;
pub const AKEYCODE_ESCAPE: c_int = 111;
pub const AKEYCODE_FORWARD_DEL: c_int = 112;
pub const AKEYCODE_CTRL_LEFT: c_int = 113;
pub const AKEYCODE_CTRL_RIGHT: c_int = 114;
pub const AKEYCODE_CAPS_LOCK: c_int = 115;
pub const AKEYCODE_SCROLL_LOCK: c_int = 116;
pub const AKEYCODE_META_LEFT: c_int = 117;
pub const AKEYCODE_META_RIGHT: c_int = 118;
pub const AKEYCODE_FUNCTION: c_int = 119;
pub const AKEYCODE_SYSRQ: c_int = 120;
pub const AKEYCODE_BREAK: c_int = 121;
pub const AKEYCODE_MOVE_HOME: c_int = 122;
pub const AKEYCODE_MOVE_END: c_int = 123;
pub const AKEYCODE_INSERT: c_int = 124;
pub const AKEYCODE_FORWARD: c_int = 125;
pub const AKEYCODE_MEDIA_PLAY: c_int = 126;
pub const AKEYCODE_MEDIA_PAUSE: c_int = 127;
pub const AKEYCODE_MEDIA_CLOSE: c_int = 128;
pub const AKEYCODE_MEDIA_EJECT: c_int = 129;
pub const AKEYCODE_MEDIA_RECORD: c_int = 130;
pub const AKEYCODE_F1: c_int = 131;
pub const AKEYCODE_F2: c_int = 132;
pub const AKEYCODE_F3: c_int = 133;
pub const AKEYCODE_F4: c_int = 134;
pub const AKEYCODE_F5: c_int = 135;
pub const AKEYCODE_F6: c_int = 136;
pub const AKEYCODE_F7: c_int = 137;
pub const AKEYCODE_F8: c_int = 138;
pub const AKEYCODE_F9: c_int = 139;
pub const AKEYCODE_F10: c_int = 140;
pub const AKEYCODE_F11: c_int = 141;
pub const AKEYCODE_F12: c_int = 142;
pub const AKEYCODE_NUM_LOCK: c_int = 143;
pub const AKEYCODE_NUMPAD_0: c_int = 144;
pub const AKEYCODE_NUMPAD_1: c_int = 145;
pub const AKEYCODE_NUMPAD_2: c_int = 146;
pub const AKEYCODE_NUMPAD_3: c_int = 147;
pub const AKEYCODE_NUMPAD_4: c_int = 148;
pub const AKEYCODE_NUMPAD_5: c_int = 149;
pub const AKEYCODE_NUMPAD_6: c_int = 150;
pub const AKEYCODE_NUMPAD_7: c_int = 151;
pub const AKEYCODE_NUMPAD_8: c_int = 152;
pub const AKEYCODE_NUMPAD_9: c_int = 153;
pub const AKEYCODE_NUMPAD_DIVIDE: c_int = 154;
pub const AKEYCODE_NUMPAD_MULTIPLY: c_int = 155;
pub const AKEYCODE_NUMPAD_SUBTRACT: c_int = 156;
pub const AKEYCODE_NUMPAD_ADD: c_int = 157;
pub const AKEYCODE_NUMPAD_DOT: c_int = 158;
pub const AKEYCODE_NUMPAD_COMMA: c_int = 159;
pub const AKEYCODE_NUMPAD_ENTER: c_int = 160;
pub const AKEYCODE_NUMPAD_EQUALS: c_int = 161;
pub const AKEYCODE_NUMPAD_LEFT_PAREN: c_int = 162;
pub const AKEYCODE_NUMPAD_RIGHT_PAREN: c_int = 163;
pub const AKEYCODE_VOLUME_MUTE: c_int = 164;
pub const AKEYCODE_INFO: c_int = 165;
pub const AKEYCODE_CHANNEL_UP: c_int = 166;
pub const AKEYCODE_CHANNEL_DOWN: c_int = 167;
pub const AKEYCODE_ZOOM_IN: c_int = 168;
pub const AKEYCODE_ZOOM_OUT: c_int = 169;
pub const AKEYCODE_TV: c_int = 170;
pub const AKEYCODE_WINDOW: c_int = 171;
pub const AKEYCODE_GUIDE: c_int = 172;
pub const AKEYCODE_DVR: c_int = 173;
pub const AKEYCODE_BOOKMARK: c_int = 174;
pub const AKEYCODE_CAPTIONS: c_int = 175;
pub const AKEYCODE_SETTINGS: c_int = 176;
pub const AKEYCODE_TV_POWER: c_int = 177;
pub const AKEYCODE_TV_INPUT: c_int = 178;
pub const AKEYCODE_STB_POWER: c_int = 179;
pub const AKEYCODE_STB_INPUT: c_int = 180;
pub const AKEYCODE_AVR_POWER: c_int = 181;
pub const AKEYCODE_AVR_INPUT: c_int = 182;
pub const AKEYCODE_PROG_RED: c_int = 183;
pub const AKEYCODE_PROG_GREEN: c_int = 184;
pub const AKEYCODE_PROG_YELLOW: c_int = 185;
pub const AKEYCODE_PROG_BLUE: c_int = 186;
pub const AKEYCODE_APP_SWITCH: c_int = 187;
pub const AKEYCODE_BUTTON_1: c_int = 188;
pub const AKEYCODE_BUTTON_2: c_int = 189;
pub const AKEYCODE_BUTTON_3: c_int = 190;
pub const AKEYCODE_BUTTON_4: c_int = 191;
pub const AKEYCODE_BUTTON_5: c_int = 192;
pub const AKEYCODE_BUTTON_6: c_int = 193;
pub const AKEYCODE_BUTTON_7: c_int = 194;
pub const AKEYCODE_BUTTON_8: c_int = 195;
pub const AKEYCODE_BUTTON_9: c_int = 196;
pub const AKEYCODE_BUTTON_10: c_int = 197;
pub const AKEYCODE_BUTTON_11: c_int = 198;
pub const AKEYCODE_BUTTON_12: c_int = 199;
pub const AKEYCODE_BUTTON_13: c_int = 200;
pub const AKEYCODE_BUTTON_14: c_int = 201;
pub const AKEYCODE_BUTTON_15: c_int = 202;
pub const AKEYCODE_BUTTON_16: c_int = 203;
pub const AKEYCODE_LANGUAGE_SWITCH: c_int = 204;
pub const AKEYCODE_MANNER_MODE: c_int = 205;
pub const AKEYCODE_3D_MODE: c_int = 206;
pub const AKEYCODE_CONTACTS: c_int = 207;
pub const AKEYCODE_CALENDAR: c_int = 208;
pub const AKEYCODE_MUSIC: c_int = 209;
pub const AKEYCODE_CALCULATOR: c_int = 210;
pub const AKEYCODE_ZENKAKU_HANKAKU: c_int = 211;
pub const AKEYCODE_EISU: c_int = 212;
pub const AKEYCODE_MUHENKAN: c_int = 213;
pub const AKEYCODE_HENKAN: c_int = 214;
pub const AKEYCODE_KATAKANA_HIRAGANA: c_int = 215;
pub const AKEYCODE_YEN: c_int = 216;
pub const AKEYCODE_RO: c_int = 217;
pub const AKEYCODE_KANA: c_int = 218;
pub const AKEYCODE_ASSIST: c_int = 219;
pub const AKEYCODE_BRIGHTNESS_DOWN: c_int = 220;
pub const AKEYCODE_BRIGHTNESS_UP: c_int = 221;
pub const AKEYCODE_MEDIA_AUDIO_TRACK: c_int = 222;
pub const AKEYCODE_SLEEP: c_int = 223;
pub const AKEYCODE_WAKEUP: c_int = 224;
pub const AKEYCODE_PAIRING: c_int = 225;
pub const AKEYCODE_MEDIA_TOP_MENU: c_int = 226;
pub const AKEYCODE_11: c_int = 227;
pub const AKEYCODE_12: c_int = 228;
pub const AKEYCODE_LAST_CHANNEL: c_int = 229;
pub const AKEYCODE_TV_DATA_SERVICE: c_int = 230;
pub const AKEYCODE_VOICE_ASSIST: c_int = 231;
pub const AKEYCODE_TV_RADIO_SERVICE: c_int = 232;
pub const AKEYCODE_TV_TELETEXT: c_int = 233;
pub const AKEYCODE_TV_NUMBER_ENTRY: c_int = 234;
pub const AKEYCODE_TV_TERRESTRIAL_ANALOG: c_int = 235;
pub const AKEYCODE_TV_TERRESTRIAL_DIGITAL: c_int = 236;
pub const AKEYCODE_TV_SATELLITE: c_int = 237;
pub const AKEYCODE_TV_SATELLITE_BS: c_int = 238;
pub const AKEYCODE_TV_SATELLITE_CS: c_int = 239;
pub const AKEYCODE_TV_SATELLITE_SERVICE: c_int = 240;
pub const AKEYCODE_TV_NETWORK: c_int = 241;
pub const AKEYCODE_TV_ANTENNA_CABLE: c_int = 242;
pub const AKEYCODE_TV_INPUT_HDMI_1: c_int = 243;
pub const AKEYCODE_TV_INPUT_HDMI_2: c_int = 244;
pub const AKEYCODE_TV_INPUT_HDMI_3: c_int = 245;
pub const AKEYCODE_TV_INPUT_HDMI_4: c_int = 246;
pub const AKEYCODE_TV_INPUT_COMPOSITE_1: c_int = 247;
pub const AKEYCODE_TV_INPUT_COMPOSITE_2: c_int = 248;
pub const AKEYCODE_TV_INPUT_COMPONENT_1: c_int = 249;
pub const AKEYCODE_TV_INPUT_COMPONENT_2: c_int = 250;
pub const AKEYCODE_TV_INPUT_VGA_1: c_int = 251;
pub const AKEYCODE_TV_AUDIO_DESCRIPTION: c_int = 252;
pub const AKEYCODE_TV_AUDIO_DESCRIPTION_MIX_UP: c_int = 253;
pub const AKEYCODE_TV_AUDIO_DESCRIPTION_MIX_DOWN: c_int = 254;
pub const AKEYCODE_TV_ZOOM_MODE: c_int = 255;
pub const AKEYCODE_TV_CONTENTS_MENU: c_int = 256;
pub const AKEYCODE_TV_MEDIA_CONTEXT_MENU: c_int = 257;
pub const AKEYCODE_TV_TIMER_PROGRAMMING: c_int = 258;
pub const AKEYCODE_HELP: c_int = 259;
pub const AKEYCODE_NAVIGATE_PREVIOUS: c_int = 260;
pub const AKEYCODE_NAVIGATE_NEXT: c_int = 261;
pub const AKEYCODE_NAVIGATE_IN: c_int = 262;
pub const AKEYCODE_NAVIGATE_OUT: c_int = 263;
pub const AKEYCODE_STEM_PRIMARY: c_int = 264;
pub const AKEYCODE_STEM_1: c_int = 265;
pub const AKEYCODE_STEM_2: c_int = 266;
pub const AKEYCODE_STEM_3: c_int = 267;
pub const AKEYCODE_DPAD_UP_LEFT: c_int = 268;
pub const AKEYCODE_DPAD_DOWN_LEFT: c_int = 269;
pub const AKEYCODE_DPAD_UP_RIGHT: c_int = 270;
pub const AKEYCODE_DPAD_DOWN_RIGHT: c_int = 271;
pub const AKEYCODE_MEDIA_SKIP_FORWARD: c_int = 272;
pub const AKEYCODE_MEDIA_SKIP_BACKWARD: c_int = 273;
pub const AKEYCODE_MEDIA_STEP_FORWARD: c_int = 274;
pub const AKEYCODE_MEDIA_STEP_BACKWARD: c_int = 275;
pub const AKEYCODE_SOFT_SLEEP: c_int = 276;
pub const AKEYCODE_CUT: c_int = 277;
pub const AKEYCODE_COPY: c_int = 278;
pub const AKEYCODE_PASTE: c_int = 279;
pub const AKEYCODE_SYSTEM_NAVIGATION_UP: c_int = 280;
pub const AKEYCODE_SYSTEM_NAVIGATION_DOWN: c_int = 281;
pub const AKEYCODE_SYSTEM_NAVIGATION_LEFT: c_int = 282;
pub const AKEYCODE_SYSTEM_NAVIGATION_RIGHT: c_int = 283;
pub const AKEYCODE_ALL_APPS: c_int = 284;
pub const AKEYCODE_REFRESH: c_int = 285;
pub const AKEYCODE_THUMBS_UP: c_int = 286;
pub const AKEYCODE_THUMBS_DOWN: c_int = 287;
pub const AKEYCODE_PROFILE_SWITCH: c_int = 288;
pub const AKEYCODE_VIDEO_APP_1: c_int = 289;
pub const AKEYCODE_VIDEO_APP_2: c_int = 290;
pub const AKEYCODE_VIDEO_APP_3: c_int = 291;
pub const AKEYCODE_VIDEO_APP_4: c_int = 292;
pub const AKEYCODE_VIDEO_APP_5: c_int = 293;
pub const AKEYCODE_VIDEO_APP_6: c_int = 294;
pub const AKEYCODE_VIDEO_APP_7: c_int = 295;
pub const AKEYCODE_VIDEO_APP_8: c_int = 296;
pub const AKEYCODE_FEATURED_APP_1: c_int = 297;
pub const AKEYCODE_FEATURED_APP_2: c_int = 298;
pub const AKEYCODE_FEATURED_APP_3: c_int = 299;
pub const AKEYCODE_FEATURED_APP_4: c_int = 300;
pub const AKEYCODE_DEMO_APP_1: c_int = 301;
pub const AKEYCODE_DEMO_APP_2: c_int = 302;
pub const AKEYCODE_DEMO_APP_3: c_int = 303;
pub const AKEYCODE_DEMO_APP_4: c_int = 304;
pub const AKEYCODE_KEYBOARD_BACKLIGHT_DOWN: c_int = 305;
pub const AKEYCODE_KEYBOARD_BACKLIGHT_UP: c_int = 306;
pub const AKEYCODE_KEYBOARD_BACKLIGHT_TOGGLE: c_int = 307;
pub const AKEYCODE_STYLUS_BUTTON_PRIMARY: c_int = 308;
pub const AKEYCODE_STYLUS_BUTTON_SECONDARY: c_int = 309;
pub const AKEYCODE_STYLUS_BUTTON_TERTIARY: c_int = 310;
pub const AKEYCODE_STYLUS_BUTTON_TAIL: c_int = 311;
pub const AKEYCODE_RECENT_APPS: c_int = 312;
pub const AKEYCODE_MACRO_1: c_int = 313;
pub const AKEYCODE_MACRO_2: c_int = 314;
pub const AKEYCODE_MACRO_3: c_int = 315;
pub const AKEYCODE_MACRO_4: c_int = 316;
const enum_unnamed_6 = c_uint;
pub const AKEY_STATE_UNKNOWN: c_int = -1;
pub const AKEY_STATE_UP: c_int = 0;
pub const AKEY_STATE_DOWN: c_int = 1;
pub const AKEY_STATE_VIRTUAL: c_int = 2;
const enum_unnamed_7 = c_int;
pub const AMETA_NONE: c_int = 0;
pub const AMETA_ALT_ON: c_int = 2;
pub const AMETA_ALT_LEFT_ON: c_int = 16;
pub const AMETA_ALT_RIGHT_ON: c_int = 32;
pub const AMETA_SHIFT_ON: c_int = 1;
pub const AMETA_SHIFT_LEFT_ON: c_int = 64;
pub const AMETA_SHIFT_RIGHT_ON: c_int = 128;
pub const AMETA_SYM_ON: c_int = 4;
pub const AMETA_FUNCTION_ON: c_int = 8;
pub const AMETA_CTRL_ON: c_int = 4096;
pub const AMETA_CTRL_LEFT_ON: c_int = 8192;
pub const AMETA_CTRL_RIGHT_ON: c_int = 16384;
pub const AMETA_META_ON: c_int = 65536;
pub const AMETA_META_LEFT_ON: c_int = 131072;
pub const AMETA_META_RIGHT_ON: c_int = 262144;
pub const AMETA_CAPS_LOCK_ON: c_int = 1048576;
pub const AMETA_NUM_LOCK_ON: c_int = 2097152;
pub const AMETA_SCROLL_LOCK_ON: c_int = 4194304;
const enum_unnamed_8 = c_uint;
pub const struct_AInputEvent = opaque {};
pub const AInputEvent = struct_AInputEvent;
pub const AINPUT_EVENT_TYPE_KEY: c_int = 1;
pub const AINPUT_EVENT_TYPE_MOTION: c_int = 2;
pub const AINPUT_EVENT_TYPE_FOCUS: c_int = 3;
pub const AINPUT_EVENT_TYPE_CAPTURE: c_int = 4;
pub const AINPUT_EVENT_TYPE_DRAG: c_int = 5;
pub const AINPUT_EVENT_TYPE_TOUCH_MODE: c_int = 6;
const enum_unnamed_9 = c_uint;
pub const AKEY_EVENT_ACTION_DOWN: c_int = 0;
pub const AKEY_EVENT_ACTION_UP: c_int = 1;
pub const AKEY_EVENT_ACTION_MULTIPLE: c_int = 2;
const enum_unnamed_10 = c_uint;
pub const AKEY_EVENT_FLAG_WOKE_HERE: c_int = 1;
pub const AKEY_EVENT_FLAG_SOFT_KEYBOARD: c_int = 2;
pub const AKEY_EVENT_FLAG_KEEP_TOUCH_MODE: c_int = 4;
pub const AKEY_EVENT_FLAG_FROM_SYSTEM: c_int = 8;
pub const AKEY_EVENT_FLAG_EDITOR_ACTION: c_int = 16;
pub const AKEY_EVENT_FLAG_CANCELED: c_int = 32;
pub const AKEY_EVENT_FLAG_VIRTUAL_HARD_KEY: c_int = 64;
pub const AKEY_EVENT_FLAG_LONG_PRESS: c_int = 128;
pub const AKEY_EVENT_FLAG_CANCELED_LONG_PRESS: c_int = 256;
pub const AKEY_EVENT_FLAG_TRACKING: c_int = 512;
pub const AKEY_EVENT_FLAG_FALLBACK: c_int = 1024;
const enum_unnamed_11 = c_uint;
pub const AMOTION_EVENT_ACTION_MASK: c_int = 255;
pub const AMOTION_EVENT_ACTION_POINTER_INDEX_MASK: c_int = 65280;
pub const AMOTION_EVENT_ACTION_DOWN: c_int = 0;
pub const AMOTION_EVENT_ACTION_UP: c_int = 1;
pub const AMOTION_EVENT_ACTION_MOVE: c_int = 2;
pub const AMOTION_EVENT_ACTION_CANCEL: c_int = 3;
pub const AMOTION_EVENT_ACTION_OUTSIDE: c_int = 4;
pub const AMOTION_EVENT_ACTION_POINTER_DOWN: c_int = 5;
pub const AMOTION_EVENT_ACTION_POINTER_UP: c_int = 6;
pub const AMOTION_EVENT_ACTION_HOVER_MOVE: c_int = 7;
pub const AMOTION_EVENT_ACTION_SCROLL: c_int = 8;
pub const AMOTION_EVENT_ACTION_HOVER_ENTER: c_int = 9;
pub const AMOTION_EVENT_ACTION_HOVER_EXIT: c_int = 10;
pub const AMOTION_EVENT_ACTION_BUTTON_PRESS: c_int = 11;
pub const AMOTION_EVENT_ACTION_BUTTON_RELEASE: c_int = 12;
const enum_unnamed_12 = c_uint;
pub const AMOTION_EVENT_FLAG_WINDOW_IS_OBSCURED: c_int = 1;
const enum_unnamed_13 = c_uint;
pub const AMOTION_EVENT_EDGE_FLAG_NONE: c_int = 0;
pub const AMOTION_EVENT_EDGE_FLAG_TOP: c_int = 1;
pub const AMOTION_EVENT_EDGE_FLAG_BOTTOM: c_int = 2;
pub const AMOTION_EVENT_EDGE_FLAG_LEFT: c_int = 4;
pub const AMOTION_EVENT_EDGE_FLAG_RIGHT: c_int = 8;
const enum_unnamed_14 = c_uint;
pub const AMOTION_EVENT_AXIS_X: c_int = 0;
pub const AMOTION_EVENT_AXIS_Y: c_int = 1;
pub const AMOTION_EVENT_AXIS_PRESSURE: c_int = 2;
pub const AMOTION_EVENT_AXIS_SIZE: c_int = 3;
pub const AMOTION_EVENT_AXIS_TOUCH_MAJOR: c_int = 4;
pub const AMOTION_EVENT_AXIS_TOUCH_MINOR: c_int = 5;
pub const AMOTION_EVENT_AXIS_TOOL_MAJOR: c_int = 6;
pub const AMOTION_EVENT_AXIS_TOOL_MINOR: c_int = 7;
pub const AMOTION_EVENT_AXIS_ORIENTATION: c_int = 8;
pub const AMOTION_EVENT_AXIS_VSCROLL: c_int = 9;
pub const AMOTION_EVENT_AXIS_HSCROLL: c_int = 10;
pub const AMOTION_EVENT_AXIS_Z: c_int = 11;
pub const AMOTION_EVENT_AXIS_RX: c_int = 12;
pub const AMOTION_EVENT_AXIS_RY: c_int = 13;
pub const AMOTION_EVENT_AXIS_RZ: c_int = 14;
pub const AMOTION_EVENT_AXIS_HAT_X: c_int = 15;
pub const AMOTION_EVENT_AXIS_HAT_Y: c_int = 16;
pub const AMOTION_EVENT_AXIS_LTRIGGER: c_int = 17;
pub const AMOTION_EVENT_AXIS_RTRIGGER: c_int = 18;
pub const AMOTION_EVENT_AXIS_THROTTLE: c_int = 19;
pub const AMOTION_EVENT_AXIS_RUDDER: c_int = 20;
pub const AMOTION_EVENT_AXIS_WHEEL: c_int = 21;
pub const AMOTION_EVENT_AXIS_GAS: c_int = 22;
pub const AMOTION_EVENT_AXIS_BRAKE: c_int = 23;
pub const AMOTION_EVENT_AXIS_DISTANCE: c_int = 24;
pub const AMOTION_EVENT_AXIS_TILT: c_int = 25;
pub const AMOTION_EVENT_AXIS_SCROLL: c_int = 26;
pub const AMOTION_EVENT_AXIS_RELATIVE_X: c_int = 27;
pub const AMOTION_EVENT_AXIS_RELATIVE_Y: c_int = 28;
pub const AMOTION_EVENT_AXIS_GENERIC_1: c_int = 32;
pub const AMOTION_EVENT_AXIS_GENERIC_2: c_int = 33;
pub const AMOTION_EVENT_AXIS_GENERIC_3: c_int = 34;
pub const AMOTION_EVENT_AXIS_GENERIC_4: c_int = 35;
pub const AMOTION_EVENT_AXIS_GENERIC_5: c_int = 36;
pub const AMOTION_EVENT_AXIS_GENERIC_6: c_int = 37;
pub const AMOTION_EVENT_AXIS_GENERIC_7: c_int = 38;
pub const AMOTION_EVENT_AXIS_GENERIC_8: c_int = 39;
pub const AMOTION_EVENT_AXIS_GENERIC_9: c_int = 40;
pub const AMOTION_EVENT_AXIS_GENERIC_10: c_int = 41;
pub const AMOTION_EVENT_AXIS_GENERIC_11: c_int = 42;
pub const AMOTION_EVENT_AXIS_GENERIC_12: c_int = 43;
pub const AMOTION_EVENT_AXIS_GENERIC_13: c_int = 44;
pub const AMOTION_EVENT_AXIS_GENERIC_14: c_int = 45;
pub const AMOTION_EVENT_AXIS_GENERIC_15: c_int = 46;
pub const AMOTION_EVENT_AXIS_GENERIC_16: c_int = 47;
pub const AMOTION_EVENT_AXIS_GESTURE_X_OFFSET: c_int = 48;
pub const AMOTION_EVENT_AXIS_GESTURE_Y_OFFSET: c_int = 49;
pub const AMOTION_EVENT_AXIS_GESTURE_SCROLL_X_DISTANCE: c_int = 50;
pub const AMOTION_EVENT_AXIS_GESTURE_SCROLL_Y_DISTANCE: c_int = 51;
pub const AMOTION_EVENT_AXIS_GESTURE_PINCH_SCALE_FACTOR: c_int = 52;
pub const AMOTION_EVENT_AXIS_GESTURE_SWIPE_FINGER_COUNT: c_int = 53;
pub const AMOTION_EVENT_MAXIMUM_VALID_AXIS_VALUE: c_int = 53;
const enum_unnamed_15 = c_uint;
pub const AMOTION_EVENT_BUTTON_PRIMARY: c_int = 1;
pub const AMOTION_EVENT_BUTTON_SECONDARY: c_int = 2;
pub const AMOTION_EVENT_BUTTON_TERTIARY: c_int = 4;
pub const AMOTION_EVENT_BUTTON_BACK: c_int = 8;
pub const AMOTION_EVENT_BUTTON_FORWARD: c_int = 16;
pub const AMOTION_EVENT_BUTTON_STYLUS_PRIMARY: c_int = 32;
pub const AMOTION_EVENT_BUTTON_STYLUS_SECONDARY: c_int = 64;
const enum_unnamed_16 = c_uint;
pub const AMOTION_EVENT_TOOL_TYPE_UNKNOWN: c_int = 0;
pub const AMOTION_EVENT_TOOL_TYPE_FINGER: c_int = 1;
pub const AMOTION_EVENT_TOOL_TYPE_STYLUS: c_int = 2;
pub const AMOTION_EVENT_TOOL_TYPE_MOUSE: c_int = 3;
pub const AMOTION_EVENT_TOOL_TYPE_ERASER: c_int = 4;
pub const AMOTION_EVENT_TOOL_TYPE_PALM: c_int = 5;
const enum_unnamed_17 = c_uint;
pub const AMOTION_EVENT_CLASSIFICATION_NONE: u32 = 0;
pub const AMOTION_EVENT_CLASSIFICATION_AMBIGUOUS_GESTURE: u32 = 1;
pub const AMOTION_EVENT_CLASSIFICATION_DEEP_PRESS: u32 = 2;
pub const AMOTION_EVENT_CLASSIFICATION_TWO_FINGER_SWIPE: u32 = 3;
pub const AMOTION_EVENT_CLASSIFICATION_MULTI_FINGER_SWIPE: u32 = 4;
pub const AMOTION_EVENT_CLASSIFICATION_PINCH: u32 = 5;
pub const enum_AMotionClassification = u32;
pub const AINPUT_SOURCE_CLASS_MASK: c_int = 255;
pub const AINPUT_SOURCE_CLASS_NONE: c_int = 0;
pub const AINPUT_SOURCE_CLASS_BUTTON: c_int = 1;
pub const AINPUT_SOURCE_CLASS_POINTER: c_int = 2;
pub const AINPUT_SOURCE_CLASS_NAVIGATION: c_int = 4;
pub const AINPUT_SOURCE_CLASS_POSITION: c_int = 8;
pub const AINPUT_SOURCE_CLASS_JOYSTICK: c_int = 16;
const enum_unnamed_18 = c_uint;
pub const AINPUT_SOURCE_UNKNOWN: c_int = 0;
pub const AINPUT_SOURCE_KEYBOARD: c_int = 257;
pub const AINPUT_SOURCE_DPAD: c_int = 513;
pub const AINPUT_SOURCE_GAMEPAD: c_int = 1025;
pub const AINPUT_SOURCE_TOUCHSCREEN: c_int = 4098;
pub const AINPUT_SOURCE_MOUSE: c_int = 8194;
pub const AINPUT_SOURCE_STYLUS: c_int = 16386;
pub const AINPUT_SOURCE_BLUETOOTH_STYLUS: c_int = 49154;
pub const AINPUT_SOURCE_TRACKBALL: c_int = 65540;
pub const AINPUT_SOURCE_MOUSE_RELATIVE: c_int = 131076;
pub const AINPUT_SOURCE_TOUCHPAD: c_int = 1048584;
pub const AINPUT_SOURCE_TOUCH_NAVIGATION: c_int = 2097152;
pub const AINPUT_SOURCE_JOYSTICK: c_int = 16777232;
pub const AINPUT_SOURCE_HDMI: c_int = 33554433;
pub const AINPUT_SOURCE_SENSOR: c_int = 67108864;
pub const AINPUT_SOURCE_ROTARY_ENCODER: c_int = 4194304;
pub const AINPUT_SOURCE_ANY: c_uint = 4294967040;
const enum_unnamed_19 = c_uint;
pub const AINPUT_KEYBOARD_TYPE_NONE: c_int = 0;
pub const AINPUT_KEYBOARD_TYPE_NON_ALPHABETIC: c_int = 1;
pub const AINPUT_KEYBOARD_TYPE_ALPHABETIC: c_int = 2;
const enum_unnamed_20 = c_uint;
pub const AINPUT_MOTION_RANGE_X: c_int = 0;
pub const AINPUT_MOTION_RANGE_Y: c_int = 1;
pub const AINPUT_MOTION_RANGE_PRESSURE: c_int = 2;
pub const AINPUT_MOTION_RANGE_SIZE: c_int = 3;
pub const AINPUT_MOTION_RANGE_TOUCH_MAJOR: c_int = 4;
pub const AINPUT_MOTION_RANGE_TOUCH_MINOR: c_int = 5;
pub const AINPUT_MOTION_RANGE_TOOL_MAJOR: c_int = 6;
pub const AINPUT_MOTION_RANGE_TOOL_MINOR: c_int = 7;
pub const AINPUT_MOTION_RANGE_ORIENTATION: c_int = 8;
const enum_unnamed_21 = c_uint;
pub extern fn AInputEvent_getType(event: ?*const AInputEvent) i32;
pub extern fn AInputEvent_getDeviceId(event: ?*const AInputEvent) i32;
pub extern fn AInputEvent_getSource(event: ?*const AInputEvent) i32;
pub extern fn AInputEvent_release(event: ?*const AInputEvent) void;
pub extern fn AKeyEvent_getAction(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getFlags(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getKeyCode(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getScanCode(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getMetaState(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getRepeatCount(key_event: ?*const AInputEvent) i32;
pub extern fn AKeyEvent_getDownTime(key_event: ?*const AInputEvent) i64;
pub extern fn AKeyEvent_getEventTime(key_event: ?*const AInputEvent) i64;
pub extern fn AKeyEvent_fromJava(env: [*c]JNIEnv, keyEvent: jobject) ?*const AInputEvent;
pub extern fn AMotionEvent_getAction(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getFlags(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getMetaState(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getButtonState(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getEdgeFlags(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getDownTime(motion_event: ?*const AInputEvent) i64;
pub extern fn AMotionEvent_getEventTime(motion_event: ?*const AInputEvent) i64;
pub extern fn AMotionEvent_getXOffset(motion_event: ?*const AInputEvent) f32;
pub extern fn AMotionEvent_getYOffset(motion_event: ?*const AInputEvent) f32;
pub extern fn AMotionEvent_getXPrecision(motion_event: ?*const AInputEvent) f32;
pub extern fn AMotionEvent_getYPrecision(motion_event: ?*const AInputEvent) f32;
pub extern fn AMotionEvent_getPointerCount(motion_event: ?*const AInputEvent) usize;
pub extern fn AMotionEvent_getPointerId(motion_event: ?*const AInputEvent, pointer_index: usize) i32;
pub extern fn AMotionEvent_getToolType(motion_event: ?*const AInputEvent, pointer_index: usize) i32;
pub extern fn AMotionEvent_getRawX(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getRawY(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getX(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getY(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getPressure(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getSize(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getTouchMajor(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getTouchMinor(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getToolMajor(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getToolMinor(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getOrientation(motion_event: ?*const AInputEvent, pointer_index: usize) f32;
pub extern fn AMotionEvent_getAxisValue(motion_event: ?*const AInputEvent, axis: i32, pointer_index: usize) f32;
pub extern fn AMotionEvent_getHistorySize(motion_event: ?*const AInputEvent) usize;
pub extern fn AMotionEvent_getHistoricalEventTime(motion_event: ?*const AInputEvent, history_index: usize) i64;
pub extern fn AMotionEvent_getHistoricalRawX(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalRawY(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalX(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalY(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalPressure(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalSize(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalTouchMajor(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalTouchMinor(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalToolMajor(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalToolMinor(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalOrientation(motion_event: ?*const AInputEvent, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getHistoricalAxisValue(motion_event: ?*const AInputEvent, axis: i32, pointer_index: usize, history_index: usize) f32;
pub extern fn AMotionEvent_getActionButton(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_getClassification(motion_event: ?*const AInputEvent) i32;
pub extern fn AMotionEvent_fromJava(env: [*c]JNIEnv, motionEvent: jobject) ?*const AInputEvent;
pub const struct_AInputQueue = opaque {};
pub const AInputQueue = struct_AInputQueue;
pub extern fn AInputQueue_attachLooper(queue: ?*AInputQueue, looper: ?*ALooper, ident: c_int, callback: ALooper_callbackFunc, data: ?*anyopaque) void;
pub extern fn AInputQueue_detachLooper(queue: ?*AInputQueue) void;
pub extern fn AInputQueue_hasEvents(queue: ?*AInputQueue) i32;
pub extern fn AInputQueue_getEvent(queue: ?*AInputQueue, outEvent: [*c]?*AInputEvent) i32;
pub extern fn AInputQueue_preDispatchEvent(queue: ?*AInputQueue, event: ?*AInputEvent) i32;
pub extern fn AInputQueue_finishEvent(queue: ?*AInputQueue, event: ?*AInputEvent, handled: c_int) void;
pub extern fn AInputQueue_fromJava(env: [*c]JNIEnv, inputQueue: jobject) ?*AInputQueue;
pub const imaxdiv_t = extern struct {
    quot: intmax_t = @import("std").mem.zeroes(intmax_t),
    rem: intmax_t = @import("std").mem.zeroes(intmax_t),
};
pub extern fn imaxabs(__i: intmax_t) intmax_t;
pub extern fn imaxdiv(__numerator: intmax_t, __denominator: intmax_t) imaxdiv_t;
pub extern fn strtoimax(__s: [*c]const u8, __end_ptr: [*c][*c]u8, __base: c_int) intmax_t;
pub extern fn strtoumax(__s: [*c]const u8, __end_ptr: [*c][*c]u8, __base: c_int) uintmax_t;
pub extern fn wcstoimax(__s: [*c]const wchar_t, __end_ptr: [*c][*c]wchar_t, __base: c_int) intmax_t;
pub extern fn wcstoumax(__s: [*c]const wchar_t, __end_ptr: [*c][*c]wchar_t, __base: c_int) uintmax_t;
pub const ADATASPACE_UNKNOWN: i32 = 0;
pub const STANDARD_MASK: i32 = 4128768;
pub const STANDARD_UNSPECIFIED: i32 = 0;
pub const STANDARD_BT709: i32 = 65536;
pub const STANDARD_BT601_625: i32 = 131072;
pub const STANDARD_BT601_625_UNADJUSTED: i32 = 196608;
pub const STANDARD_BT601_525: i32 = 262144;
pub const STANDARD_BT601_525_UNADJUSTED: i32 = 327680;
pub const STANDARD_BT2020: i32 = 393216;
pub const STANDARD_BT2020_CONSTANT_LUMINANCE: i32 = 458752;
pub const STANDARD_BT470M: i32 = 524288;
pub const STANDARD_FILM: i32 = 589824;
pub const STANDARD_DCI_P3: i32 = 655360;
pub const STANDARD_ADOBE_RGB: i32 = 720896;
pub const TRANSFER_MASK: i32 = 130023424;
pub const TRANSFER_UNSPECIFIED: i32 = 0;
pub const TRANSFER_LINEAR: i32 = 4194304;
pub const TRANSFER_SRGB: i32 = 8388608;
pub const TRANSFER_SMPTE_170M: i32 = 12582912;
pub const TRANSFER_GAMMA2_2: i32 = 16777216;
pub const TRANSFER_GAMMA2_6: i32 = 20971520;
pub const TRANSFER_GAMMA2_8: i32 = 25165824;
pub const TRANSFER_ST2084: i32 = 29360128;
pub const TRANSFER_HLG: i32 = 33554432;
pub const RANGE_MASK: i32 = 939524096;
pub const RANGE_UNSPECIFIED: i32 = 0;
pub const RANGE_FULL: i32 = 134217728;
pub const RANGE_LIMITED: i32 = 268435456;
pub const RANGE_EXTENDED: i32 = 402653184;
pub const ADATASPACE_SCRGB_LINEAR: i32 = 406913024;
pub const ADATASPACE_SRGB: i32 = 142671872;
pub const ADATASPACE_SCRGB: i32 = 411107328;
pub const ADATASPACE_DISPLAY_P3: i32 = 143261696;
pub const ADATASPACE_BT2020_PQ: i32 = 163971072;
pub const ADATASPACE_BT2020_ITU_PQ: i32 = 298188800;
pub const ADATASPACE_ADOBE_RGB: i32 = 151715840;
pub const ADATASPACE_JFIF: i32 = 146931712;
pub const ADATASPACE_BT601_625: i32 = 281149440;
pub const ADATASPACE_BT601_525: i32 = 281280512;
pub const ADATASPACE_BT2020: i32 = 147193856;
pub const ADATASPACE_BT709: i32 = 281083904;
pub const ADATASPACE_DCI_P3: i32 = 155844608;
pub const ADATASPACE_SRGB_LINEAR: i32 = 138477568;
pub const ADATASPACE_BT2020_HLG: i32 = 168165376;
pub const ADATASPACE_BT2020_ITU_HLG: i32 = 302383104;
pub const ADATASPACE_DEPTH: i32 = 4096;
pub const ADATASPACE_DYNAMIC_DEPTH: i32 = 4098;
pub const enum_ADataSpace = i32;
pub const struct_ARect = extern struct {
    left: i32 = @import("std").mem.zeroes(i32),
    top: i32 = @import("std").mem.zeroes(i32),
    right: i32 = @import("std").mem.zeroes(i32),
    bottom: i32 = @import("std").mem.zeroes(i32),
};
pub const ARect = struct_ARect;
pub const AHARDWAREBUFFER_FORMAT_R8G8B8A8_UNORM: c_int = 1;
pub const AHARDWAREBUFFER_FORMAT_R8G8B8X8_UNORM: c_int = 2;
pub const AHARDWAREBUFFER_FORMAT_R8G8B8_UNORM: c_int = 3;
pub const AHARDWAREBUFFER_FORMAT_R5G6B5_UNORM: c_int = 4;
pub const AHARDWAREBUFFER_FORMAT_R16G16B16A16_FLOAT: c_int = 22;
pub const AHARDWAREBUFFER_FORMAT_R10G10B10A2_UNORM: c_int = 43;
pub const AHARDWAREBUFFER_FORMAT_BLOB: c_int = 33;
pub const AHARDWAREBUFFER_FORMAT_D16_UNORM: c_int = 48;
pub const AHARDWAREBUFFER_FORMAT_D24_UNORM: c_int = 49;
pub const AHARDWAREBUFFER_FORMAT_D24_UNORM_S8_UINT: c_int = 50;
pub const AHARDWAREBUFFER_FORMAT_D32_FLOAT: c_int = 51;
pub const AHARDWAREBUFFER_FORMAT_D32_FLOAT_S8_UINT: c_int = 52;
pub const AHARDWAREBUFFER_FORMAT_S8_UINT: c_int = 53;
pub const AHARDWAREBUFFER_FORMAT_Y8Cb8Cr8_420: c_int = 35;
pub const AHARDWAREBUFFER_FORMAT_YCbCr_P010: c_int = 54;
pub const AHARDWAREBUFFER_FORMAT_R8_UNORM: c_int = 56;
pub const AHARDWAREBUFFER_FORMAT_R16_UINT: c_int = 57;
pub const AHARDWAREBUFFER_FORMAT_R16G16_UINT: c_int = 58;
pub const AHARDWAREBUFFER_FORMAT_R10G10B10A10_UNORM: c_int = 59;
pub const enum_AHardwareBuffer_Format = c_uint;
pub const AHARDWAREBUFFER_USAGE_CPU_READ_NEVER: c_int = 0;
pub const AHARDWAREBUFFER_USAGE_CPU_READ_RARELY: c_int = 2;
pub const AHARDWAREBUFFER_USAGE_CPU_READ_OFTEN: c_int = 3;
pub const AHARDWAREBUFFER_USAGE_CPU_READ_MASK: c_int = 15;
pub const AHARDWAREBUFFER_USAGE_CPU_WRITE_NEVER: c_int = 0;
pub const AHARDWAREBUFFER_USAGE_CPU_WRITE_RARELY: c_int = 32;
pub const AHARDWAREBUFFER_USAGE_CPU_WRITE_OFTEN: c_int = 48;
pub const AHARDWAREBUFFER_USAGE_CPU_WRITE_MASK: c_int = 240;
pub const AHARDWAREBUFFER_USAGE_GPU_SAMPLED_IMAGE: c_int = 256;
pub const AHARDWAREBUFFER_USAGE_GPU_FRAMEBUFFER: c_int = 512;
pub const AHARDWAREBUFFER_USAGE_GPU_COLOR_OUTPUT: c_int = 512;
pub const AHARDWAREBUFFER_USAGE_COMPOSER_OVERLAY: c_int = 2048;
pub const AHARDWAREBUFFER_USAGE_PROTECTED_CONTENT: c_int = 16384;
pub const AHARDWAREBUFFER_USAGE_VIDEO_ENCODE: c_int = 65536;
pub const AHARDWAREBUFFER_USAGE_SENSOR_DIRECT_DATA: c_int = 8388608;
pub const AHARDWAREBUFFER_USAGE_GPU_DATA_BUFFER: c_int = 16777216;
pub const AHARDWAREBUFFER_USAGE_GPU_CUBE_MAP: c_int = 33554432;
pub const AHARDWAREBUFFER_USAGE_GPU_MIPMAP_COMPLETE: c_int = 67108864;
pub const AHARDWAREBUFFER_USAGE_FRONT_BUFFER: c_ulonglong = 2147483648;
pub const AHARDWAREBUFFER_USAGE_VENDOR_0: c_int = 268435456;
pub const AHARDWAREBUFFER_USAGE_VENDOR_1: c_int = 536870912;
pub const AHARDWAREBUFFER_USAGE_VENDOR_2: c_int = 1073741824;
pub const AHARDWAREBUFFER_USAGE_VENDOR_3: c_ulonglong = 2147483648;
pub const AHARDWAREBUFFER_USAGE_VENDOR_4: c_ulonglong = 281474976710656;
pub const AHARDWAREBUFFER_USAGE_VENDOR_5: c_ulonglong = 562949953421312;
pub const AHARDWAREBUFFER_USAGE_VENDOR_6: c_ulonglong = 1125899906842624;
pub const AHARDWAREBUFFER_USAGE_VENDOR_7: c_ulonglong = 2251799813685248;
pub const AHARDWAREBUFFER_USAGE_VENDOR_8: c_ulonglong = 4503599627370496;
pub const AHARDWAREBUFFER_USAGE_VENDOR_9: c_ulonglong = 9007199254740992;
pub const AHARDWAREBUFFER_USAGE_VENDOR_10: c_ulonglong = 18014398509481984;
pub const AHARDWAREBUFFER_USAGE_VENDOR_11: c_ulonglong = 36028797018963968;
pub const AHARDWAREBUFFER_USAGE_VENDOR_12: c_ulonglong = 72057594037927936;
pub const AHARDWAREBUFFER_USAGE_VENDOR_13: c_ulonglong = 144115188075855872;
pub const AHARDWAREBUFFER_USAGE_VENDOR_14: c_ulonglong = 288230376151711744;
pub const AHARDWAREBUFFER_USAGE_VENDOR_15: c_ulonglong = 576460752303423488;
pub const AHARDWAREBUFFER_USAGE_VENDOR_16: c_ulonglong = 1152921504606846976;
pub const AHARDWAREBUFFER_USAGE_VENDOR_17: c_ulonglong = 2305843009213693952;
pub const AHARDWAREBUFFER_USAGE_VENDOR_18: c_ulonglong = 4611686018427387904;
pub const AHARDWAREBUFFER_USAGE_VENDOR_19: c_ulonglong = 9223372036854775808;
pub const enum_AHardwareBuffer_UsageFlags = c_ulonglong;
pub const struct_AHardwareBuffer_Desc = extern struct {
    width: u32 = @import("std").mem.zeroes(u32),
    height: u32 = @import("std").mem.zeroes(u32),
    layers: u32 = @import("std").mem.zeroes(u32),
    format: u32 = @import("std").mem.zeroes(u32),
    usage: u64 = @import("std").mem.zeroes(u64),
    stride: u32 = @import("std").mem.zeroes(u32),
    rfu0: u32 = @import("std").mem.zeroes(u32),
    rfu1: u64 = @import("std").mem.zeroes(u64),
};
pub const AHardwareBuffer_Desc = struct_AHardwareBuffer_Desc;
pub const struct_AHardwareBuffer_Plane = extern struct {
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    pixelStride: u32 = @import("std").mem.zeroes(u32),
    rowStride: u32 = @import("std").mem.zeroes(u32),
};
pub const AHardwareBuffer_Plane = struct_AHardwareBuffer_Plane;
pub const struct_AHardwareBuffer_Planes = extern struct {
    planeCount: u32 = @import("std").mem.zeroes(u32),
    planes: [4]AHardwareBuffer_Plane = @import("std").mem.zeroes([4]AHardwareBuffer_Plane),
};
pub const AHardwareBuffer_Planes = struct_AHardwareBuffer_Planes;
pub const struct_AHardwareBuffer = opaque {};
pub const AHardwareBuffer = struct_AHardwareBuffer;
pub extern fn AHardwareBuffer_allocate(desc: [*c]const AHardwareBuffer_Desc, outBuffer: [*c]?*AHardwareBuffer) c_int;
pub extern fn AHardwareBuffer_acquire(buffer: ?*AHardwareBuffer) void;
pub extern fn AHardwareBuffer_release(buffer: ?*AHardwareBuffer) void;
pub extern fn AHardwareBuffer_describe(buffer: ?*const AHardwareBuffer, outDesc: [*c]AHardwareBuffer_Desc) void;
pub extern fn AHardwareBuffer_lock(buffer: ?*AHardwareBuffer, usage: u64, fence: i32, rect: [*c]const ARect, outVirtualAddress: [*c]?*anyopaque) c_int;
pub extern fn AHardwareBuffer_unlock(buffer: ?*AHardwareBuffer, fence: [*c]i32) c_int;
pub extern fn AHardwareBuffer_sendHandleToUnixSocket(buffer: ?*const AHardwareBuffer, socketFd: c_int) c_int;
pub extern fn AHardwareBuffer_recvHandleFromUnixSocket(socketFd: c_int, outBuffer: [*c]?*AHardwareBuffer) c_int;
pub extern fn AHardwareBuffer_lockPlanes(buffer: ?*AHardwareBuffer, usage: u64, fence: i32, rect: [*c]const ARect, outPlanes: [*c]AHardwareBuffer_Planes) c_int;
pub extern fn AHardwareBuffer_isSupported(desc: [*c]const AHardwareBuffer_Desc) c_int;
pub extern fn AHardwareBuffer_lockAndGetInfo(buffer: ?*AHardwareBuffer, usage: u64, fence: i32, rect: [*c]const ARect, outVirtualAddress: [*c]?*anyopaque, outBytesPerPixel: [*c]i32, outBytesPerStride: [*c]i32) c_int;
pub extern fn AHardwareBuffer_getId(buffer: ?*const AHardwareBuffer, outId: [*c]u64) c_int;
pub const WINDOW_FORMAT_RGBA_8888: c_int = 1;
pub const WINDOW_FORMAT_RGBX_8888: c_int = 2;
pub const WINDOW_FORMAT_RGB_565: c_int = 4;
pub const enum_ANativeWindow_LegacyFormat = c_uint;
pub const ANATIVEWINDOW_TRANSFORM_IDENTITY: c_int = 0;
pub const ANATIVEWINDOW_TRANSFORM_MIRROR_HORIZONTAL: c_int = 1;
pub const ANATIVEWINDOW_TRANSFORM_MIRROR_VERTICAL: c_int = 2;
pub const ANATIVEWINDOW_TRANSFORM_ROTATE_90: c_int = 4;
pub const ANATIVEWINDOW_TRANSFORM_ROTATE_180: c_int = 3;
pub const ANATIVEWINDOW_TRANSFORM_ROTATE_270: c_int = 7;
pub const enum_ANativeWindowTransform = c_uint;
pub const struct_ANativeWindow = opaque {};
pub const ANativeWindow = struct_ANativeWindow;
pub const struct_ANativeWindow_Buffer = extern struct {
    width: i32 = @import("std").mem.zeroes(i32),
    height: i32 = @import("std").mem.zeroes(i32),
    stride: i32 = @import("std").mem.zeroes(i32),
    format: i32 = @import("std").mem.zeroes(i32),
    bits: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    reserved: [6]u32 = @import("std").mem.zeroes([6]u32),
};
pub const ANativeWindow_Buffer = struct_ANativeWindow_Buffer;
pub extern fn ANativeWindow_acquire(window: ?*ANativeWindow) void;
pub extern fn ANativeWindow_release(window: ?*ANativeWindow) void;
pub extern fn ANativeWindow_getWidth(window: ?*ANativeWindow) i32;
pub extern fn ANativeWindow_getHeight(window: ?*ANativeWindow) i32;
pub extern fn ANativeWindow_getFormat(window: ?*ANativeWindow) i32;
pub extern fn ANativeWindow_setBuffersGeometry(window: ?*ANativeWindow, width: i32, height: i32, format: i32) i32;
pub extern fn ANativeWindow_lock(window: ?*ANativeWindow, outBuffer: [*c]ANativeWindow_Buffer, inOutDirtyBounds: [*c]ARect) i32;
pub extern fn ANativeWindow_unlockAndPost(window: ?*ANativeWindow) i32;
pub extern fn ANativeWindow_setBuffersTransform(window: ?*ANativeWindow, transform: i32) i32;
pub extern fn ANativeWindow_setBuffersDataSpace(window: ?*ANativeWindow, dataSpace: i32) i32;
pub extern fn ANativeWindow_getBuffersDataSpace(window: ?*ANativeWindow) i32;
pub extern fn ANativeWindow_getBuffersDefaultDataSpace(window: ?*ANativeWindow) i32;
pub const ANATIVEWINDOW_FRAME_RATE_COMPATIBILITY_DEFAULT: c_int = 0;
pub const ANATIVEWINDOW_FRAME_RATE_COMPATIBILITY_FIXED_SOURCE: c_int = 1;
pub const enum_ANativeWindow_FrameRateCompatibility = c_uint;
pub extern fn ANativeWindow_setFrameRate(window: ?*ANativeWindow, frameRate: f32, compatibility: i8) i32;
pub extern fn ANativeWindow_tryAllocateBuffers(window: ?*ANativeWindow) void;
pub const ANATIVEWINDOW_CHANGE_FRAME_RATE_ONLY_IF_SEAMLESS: c_int = 0;
pub const ANATIVEWINDOW_CHANGE_FRAME_RATE_ALWAYS: c_int = 1;
pub const enum_ANativeWindow_ChangeFrameRateStrategy = c_uint;
pub extern fn ANativeWindow_setFrameRateWithChangeStrategy(window: ?*ANativeWindow, frameRate: f32, compatibility: i8, changeFrameRateStrategy: i8) i32;
pub fn ANativeWindow_clearFrameRate(arg_window: ?*ANativeWindow) callconv(.C) i32 {
    var window = arg_window;
    _ = &window;
    return ANativeWindow_setFrameRateWithChangeStrategy(window, @as(f32, @floatFromInt(@as(c_int, 0))), @as(i8, @bitCast(@as(i8, @truncate(ANATIVEWINDOW_FRAME_RATE_COMPATIBILITY_DEFAULT)))), @as(i8, @bitCast(@as(i8, @truncate(ANATIVEWINDOW_CHANGE_FRAME_RATE_ONLY_IF_SEAMLESS)))));
}
pub const struct_ANativeActivity = extern struct {
    callbacks: [*c]struct_ANativeActivityCallbacks = @import("std").mem.zeroes([*c]struct_ANativeActivityCallbacks),
    vm: [*c]JavaVM = @import("std").mem.zeroes([*c]JavaVM),
    env: [*c]JNIEnv = @import("std").mem.zeroes([*c]JNIEnv),
    clazz: jobject = @import("std").mem.zeroes(jobject),
    internalDataPath: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    externalDataPath: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
    sdkVersion: i32 = @import("std").mem.zeroes(i32),
    instance: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    assetManager: ?*AAssetManager = @import("std").mem.zeroes(?*AAssetManager),
    obbPath: [*c]const u8 = @import("std").mem.zeroes([*c]const u8),
};
pub const ANativeActivity = struct_ANativeActivity;
pub const struct_ANativeActivityCallbacks = extern struct {
    onStart: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onResume: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onSaveInstanceState: ?*const fn ([*c]ANativeActivity, [*c]usize) callconv(.C) ?*anyopaque = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, [*c]usize) callconv(.C) ?*anyopaque),
    onPause: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onStop: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onDestroy: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onWindowFocusChanged: ?*const fn ([*c]ANativeActivity, c_int) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, c_int) callconv(.C) void),
    onNativeWindowCreated: ?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void),
    onNativeWindowResized: ?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void),
    onNativeWindowRedrawNeeded: ?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void),
    onNativeWindowDestroyed: ?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*ANativeWindow) callconv(.C) void),
    onInputQueueCreated: ?*const fn ([*c]ANativeActivity, ?*AInputQueue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*AInputQueue) callconv(.C) void),
    onInputQueueDestroyed: ?*const fn ([*c]ANativeActivity, ?*AInputQueue) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, ?*AInputQueue) callconv(.C) void),
    onContentRectChanged: ?*const fn ([*c]ANativeActivity, [*c]const ARect) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity, [*c]const ARect) callconv(.C) void),
    onConfigurationChanged: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
    onLowMemory: ?*const fn ([*c]ANativeActivity) callconv(.C) void = @import("std").mem.zeroes(?*const fn ([*c]ANativeActivity) callconv(.C) void),
};
pub const ANativeActivityCallbacks = struct_ANativeActivityCallbacks;
pub const ANativeActivity_createFunc = fn ([*c]ANativeActivity, ?*anyopaque, usize) callconv(.C) void;
pub extern fn ANativeActivity_finish(activity: [*c]ANativeActivity) void;
pub extern fn ANativeActivity_setWindowFormat(activity: [*c]ANativeActivity, format: i32) void;
pub extern fn ANativeActivity_setWindowFlags(activity: [*c]ANativeActivity, addFlags: u32, removeFlags: u32) void;
pub const ANATIVEACTIVITY_SHOW_SOFT_INPUT_IMPLICIT: c_int = 1;
pub const ANATIVEACTIVITY_SHOW_SOFT_INPUT_FORCED: c_int = 2;
const enum_unnamed_22 = c_uint;
pub extern fn ANativeActivity_showSoftInput(activity: [*c]ANativeActivity, flags: u32) void;
pub const ANATIVEACTIVITY_HIDE_SOFT_INPUT_IMPLICIT_ONLY: c_int = 1;
pub const ANATIVEACTIVITY_HIDE_SOFT_INPUT_NOT_ALWAYS: c_int = 2;
const enum_unnamed_23 = c_uint;
pub extern fn ANativeActivity_hideSoftInput(activity: [*c]ANativeActivity, flags: u32) void;
pub const __double_t = f64;
pub const double_t = __double_t;
pub const __float_t = f32;
pub const float_t = __float_t;
pub extern fn acos(__x: f64) f64;
pub extern fn acosf(__x: f32) f32;
pub extern fn acosl(__x: c_longdouble) c_longdouble;
pub extern fn asin(__x: f64) f64;
pub extern fn asinf(__x: f32) f32;
pub extern fn asinl(__x: c_longdouble) c_longdouble;
pub extern fn atan(__x: f64) f64;
pub extern fn atanf(__x: f32) f32;
pub extern fn atanl(__x: c_longdouble) c_longdouble;
pub extern fn atan2(__y: f64, __x: f64) f64;
pub extern fn atan2f(__y: f32, __x: f32) f32;
pub extern fn atan2l(__y: c_longdouble, __x: c_longdouble) c_longdouble;
pub extern fn cos(__x: f64) f64;
pub extern fn cosf(__x: f32) f32;
pub extern fn cosl(__x: c_longdouble) c_longdouble;
pub extern fn sin(__x: f64) f64;
pub extern fn sinf(__x: f32) f32;
pub extern fn sinl(__x: c_longdouble) c_longdouble;
pub extern fn tan(__x: f64) f64;
pub extern fn tanf(__x: f32) f32;
pub extern fn tanl(__x: c_longdouble) c_longdouble;
pub extern fn acosh(__x: f64) f64;
pub extern fn acoshf(__x: f32) f32;
pub extern fn acoshl(__x: c_longdouble) c_longdouble;
pub extern fn asinh(__x: f64) f64;
pub extern fn asinhf(__x: f32) f32;
pub extern fn asinhl(__x: c_longdouble) c_longdouble;
pub extern fn atanh(__x: f64) f64;
pub extern fn atanhf(__x: f32) f32;
pub extern fn atanhl(__x: c_longdouble) c_longdouble;
pub extern fn cosh(__x: f64) f64;
pub extern fn coshf(__x: f32) f32;
pub extern fn coshl(__x: c_longdouble) c_longdouble;
pub extern fn sinh(__x: f64) f64;
pub extern fn sinhf(__x: f32) f32;
pub extern fn sinhl(__x: c_longdouble) c_longdouble;
pub extern fn tanh(__x: f64) f64;
pub extern fn tanhf(__x: f32) f32;
pub extern fn tanhl(__x: c_longdouble) c_longdouble;
pub extern fn exp(__x: f64) f64;
pub extern fn expf(__x: f32) f32;
pub extern fn expl(__x: c_longdouble) c_longdouble;
pub extern fn exp2(__x: f64) f64;
pub extern fn exp2f(__x: f32) f32;
pub extern fn exp2l(__x: c_longdouble) c_longdouble;
pub extern fn expm1(__x: f64) f64;
pub extern fn expm1f(__x: f32) f32;
pub extern fn expm1l(__x: c_longdouble) c_longdouble;
pub extern fn frexp(__x: f64, __exponent: [*c]c_int) f64;
pub extern fn frexpf(__x: f32, __exponent: [*c]c_int) f32;
pub extern fn frexpl(__x: c_longdouble, __exponent: [*c]c_int) c_longdouble;
pub extern fn ilogb(__x: f64) c_int;
pub extern fn ilogbf(__x: f32) c_int;
pub extern fn ilogbl(__x: c_longdouble) c_int;
pub extern fn ldexp(__x: f64, __exponent: c_int) f64;
pub extern fn ldexpf(__x: f32, __exponent: c_int) f32;
pub extern fn ldexpl(__x: c_longdouble, __exponent: c_int) c_longdouble;
pub extern fn log(__x: f64) f64;
pub extern fn logf(__x: f32) f32;
pub extern fn logl(__x: c_longdouble) c_longdouble;
pub extern fn log10(__x: f64) f64;
pub extern fn log10f(__x: f32) f32;
pub extern fn log10l(__x: c_longdouble) c_longdouble;
pub extern fn log1p(__x: f64) f64;
pub extern fn log1pf(__x: f32) f32;
pub extern fn log1pl(__x: c_longdouble) c_longdouble;
pub extern fn log2(__x: f64) f64;
pub extern fn log2f(__x: f32) f32;
pub extern fn log2l(__x: c_longdouble) c_longdouble;
pub extern fn logb(__x: f64) f64;
pub extern fn logbf(__x: f32) f32;
pub extern fn logbl(__x: c_longdouble) c_longdouble;
pub extern fn modf(__x: f64, __integral_part: [*c]f64) f64;
pub extern fn modff(__x: f32, __integral_part: [*c]f32) f32;
pub extern fn modfl(__x: c_longdouble, __integral_part: [*c]c_longdouble) c_longdouble;
pub extern fn scalbn(__x: f64, __exponent: c_int) f64;
pub extern fn scalbnf(__x: f32, __exponent: c_int) f32;
pub extern fn scalbnl(__x: c_longdouble, __exponent: c_int) c_longdouble;
pub extern fn scalbln(__x: f64, __exponent: c_long) f64;
pub extern fn scalblnf(__x: f32, __exponent: c_long) f32;
pub extern fn scalblnl(__x: c_longdouble, __exponent: c_long) c_longdouble;
pub extern fn cbrt(__x: f64) f64;
pub extern fn cbrtf(__x: f32) f32;
pub extern fn cbrtl(__x: c_longdouble) c_longdouble;
pub extern fn fabs(__x: f64) f64;
pub extern fn fabsf(__x: f32) f32;
pub extern fn fabsl(__x: c_longdouble) c_longdouble;
pub extern fn hypot(__x: f64, __y: f64) f64;
pub extern fn hypotf(__x: f32, __y: f32) f32;
pub extern fn hypotl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn pow(__x: f64, __y: f64) f64;
pub extern fn powf(__x: f32, __y: f32) f32;
pub extern fn powl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn sqrt(__x: f64) f64;
pub extern fn sqrtf(__x: f32) f32;
pub extern fn sqrtl(__x: c_longdouble) c_longdouble;
pub extern fn erf(__x: f64) f64;
pub extern fn erff(__x: f32) f32;
pub extern fn erfl(__x: c_longdouble) c_longdouble;
pub extern fn erfc(__x: f64) f64;
pub extern fn erfcf(__x: f32) f32;
pub extern fn erfcl(__x: c_longdouble) c_longdouble;
pub extern fn lgamma(__x: f64) f64;
pub extern fn lgammaf(__x: f32) f32;
pub extern fn lgammal(__x: c_longdouble) c_longdouble;
pub extern fn tgamma(__x: f64) f64;
pub extern fn tgammaf(__x: f32) f32;
pub extern fn tgammal(__x: c_longdouble) c_longdouble;
pub extern fn ceil(__x: f64) f64;
pub extern fn ceilf(__x: f32) f32;
pub extern fn ceill(__x: c_longdouble) c_longdouble;
pub extern fn floor(__x: f64) f64;
pub extern fn floorf(__x: f32) f32;
pub extern fn floorl(__x: c_longdouble) c_longdouble;
pub extern fn nearbyint(__x: f64) f64;
pub extern fn nearbyintf(__x: f32) f32;
pub extern fn nearbyintl(__x: c_longdouble) c_longdouble;
pub extern fn rint(__x: f64) f64;
pub extern fn rintf(__x: f32) f32;
pub extern fn rintl(__x: c_longdouble) c_longdouble;
pub extern fn lrint(__x: f64) c_long;
pub extern fn lrintf(__x: f32) c_long;
pub extern fn lrintl(__x: c_longdouble) c_long;
pub extern fn llrint(__x: f64) c_longlong;
pub extern fn llrintf(__x: f32) c_longlong;
pub extern fn llrintl(__x: c_longdouble) c_longlong;
pub extern fn round(__x: f64) f64;
pub extern fn roundf(__x: f32) f32;
pub extern fn roundl(__x: c_longdouble) c_longdouble;
pub extern fn lround(__x: f64) c_long;
pub extern fn lroundf(__x: f32) c_long;
pub extern fn lroundl(__x: c_longdouble) c_long;
pub extern fn llround(__x: f64) c_longlong;
pub extern fn llroundf(__x: f32) c_longlong;
pub extern fn llroundl(__x: c_longdouble) c_longlong;
pub extern fn trunc(__x: f64) f64;
pub extern fn truncf(__x: f32) f32;
pub extern fn truncl(__x: c_longdouble) c_longdouble;
pub extern fn fmod(__x: f64, __y: f64) f64;
pub extern fn fmodf(__x: f32, __y: f32) f32;
pub extern fn fmodl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn remainder(__x: f64, __y: f64) f64;
pub extern fn remainderf(__x: f32, __y: f32) f32;
pub extern fn remainderl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn remquo(__x: f64, __y: f64, __quotient_bits: [*c]c_int) f64;
pub extern fn remquof(__x: f32, __y: f32, __quotient_bits: [*c]c_int) f32;
pub extern fn remquol(__x: c_longdouble, __y: c_longdouble, __quotient_bits: [*c]c_int) c_longdouble;
pub extern fn copysign(__value: f64, __sign: f64) f64;
pub extern fn copysignf(__value: f32, __sign: f32) f32;
pub extern fn copysignl(__value: c_longdouble, __sign: c_longdouble) c_longdouble;
pub extern fn nan(__kind: [*c]const u8) f64;
pub extern fn nanf(__kind: [*c]const u8) f32;
pub extern fn nanl(__kind: [*c]const u8) c_longdouble;
pub extern fn nextafter(__x: f64, __y: f64) f64;
pub extern fn nextafterf(__x: f32, __y: f32) f32;
pub extern fn nextafterl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn nexttoward(__x: f64, __y: c_longdouble) f64;
pub extern fn nexttowardf(__x: f32, __y: c_longdouble) f32;
pub extern fn nexttowardl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn fdim(__x: f64, __y: f64) f64;
pub extern fn fdimf(__x: f32, __y: f32) f32;
pub extern fn fdiml(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn fmax(__x: f64, __y: f64) f64;
pub extern fn fmaxf(__x: f32, __y: f32) f32;
pub extern fn fmaxl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn fmin(__x: f64, __y: f64) f64;
pub extern fn fminf(__x: f32, __y: f32) f32;
pub extern fn fminl(__x: c_longdouble, __y: c_longdouble) c_longdouble;
pub extern fn fma(__x: f64, __y: f64, __z: f64) f64;
pub extern fn fmaf(__x: f32, __y: f32, __z: f32) f32;
pub extern fn fmal(__x: c_longdouble, __y: c_longdouble, __z: c_longdouble) c_longdouble;
pub extern fn isinf(__x: f64) c_int;
pub extern fn isnan(__x: f64) c_int;
pub extern var signgam: c_int;
pub extern fn j0(__x: f64) f64;
pub extern fn j1(__x: f64) f64;
pub extern fn jn(__n: c_int, __x: f64) f64;
pub extern fn y0(__x: f64) f64;
pub extern fn y1(__x: f64) f64;
pub extern fn yn(__n: c_int, __x: f64) f64;
pub const ASENSOR_TYPE_INVALID: c_int = -1;
pub const ASENSOR_TYPE_ACCELEROMETER: c_int = 1;
pub const ASENSOR_TYPE_MAGNETIC_FIELD: c_int = 2;
pub const ASENSOR_TYPE_GYROSCOPE: c_int = 4;
pub const ASENSOR_TYPE_LIGHT: c_int = 5;
pub const ASENSOR_TYPE_PRESSURE: c_int = 6;
pub const ASENSOR_TYPE_PROXIMITY: c_int = 8;
pub const ASENSOR_TYPE_GRAVITY: c_int = 9;
pub const ASENSOR_TYPE_LINEAR_ACCELERATION: c_int = 10;
pub const ASENSOR_TYPE_ROTATION_VECTOR: c_int = 11;
pub const ASENSOR_TYPE_RELATIVE_HUMIDITY: c_int = 12;
pub const ASENSOR_TYPE_AMBIENT_TEMPERATURE: c_int = 13;
pub const ASENSOR_TYPE_MAGNETIC_FIELD_UNCALIBRATED: c_int = 14;
pub const ASENSOR_TYPE_GAME_ROTATION_VECTOR: c_int = 15;
pub const ASENSOR_TYPE_GYROSCOPE_UNCALIBRATED: c_int = 16;
pub const ASENSOR_TYPE_SIGNIFICANT_MOTION: c_int = 17;
pub const ASENSOR_TYPE_STEP_DETECTOR: c_int = 18;
pub const ASENSOR_TYPE_STEP_COUNTER: c_int = 19;
pub const ASENSOR_TYPE_GEOMAGNETIC_ROTATION_VECTOR: c_int = 20;
pub const ASENSOR_TYPE_HEART_RATE: c_int = 21;
pub const ASENSOR_TYPE_POSE_6DOF: c_int = 28;
pub const ASENSOR_TYPE_STATIONARY_DETECT: c_int = 29;
pub const ASENSOR_TYPE_MOTION_DETECT: c_int = 30;
pub const ASENSOR_TYPE_HEART_BEAT: c_int = 31;
pub const ASENSOR_TYPE_DYNAMIC_SENSOR_META: c_int = 32;
pub const ASENSOR_TYPE_ADDITIONAL_INFO: c_int = 33;
pub const ASENSOR_TYPE_LOW_LATENCY_OFFBODY_DETECT: c_int = 34;
pub const ASENSOR_TYPE_ACCELEROMETER_UNCALIBRATED: c_int = 35;
pub const ASENSOR_TYPE_HINGE_ANGLE: c_int = 36;
pub const ASENSOR_TYPE_HEAD_TRACKER: c_int = 37;
pub const ASENSOR_TYPE_ACCELEROMETER_LIMITED_AXES: c_int = 38;
pub const ASENSOR_TYPE_GYROSCOPE_LIMITED_AXES: c_int = 39;
pub const ASENSOR_TYPE_ACCELEROMETER_LIMITED_AXES_UNCALIBRATED: c_int = 40;
pub const ASENSOR_TYPE_GYROSCOPE_LIMITED_AXES_UNCALIBRATED: c_int = 41;
pub const ASENSOR_TYPE_HEADING: c_int = 42;
const enum_unnamed_24 = c_int;
pub const ASENSOR_STATUS_NO_CONTACT: c_int = -1;
pub const ASENSOR_STATUS_UNRELIABLE: c_int = 0;
pub const ASENSOR_STATUS_ACCURACY_LOW: c_int = 1;
pub const ASENSOR_STATUS_ACCURACY_MEDIUM: c_int = 2;
pub const ASENSOR_STATUS_ACCURACY_HIGH: c_int = 3;
const enum_unnamed_25 = c_int;
pub const AREPORTING_MODE_INVALID: c_int = -1;
pub const AREPORTING_MODE_CONTINUOUS: c_int = 0;
pub const AREPORTING_MODE_ON_CHANGE: c_int = 1;
pub const AREPORTING_MODE_ONE_SHOT: c_int = 2;
pub const AREPORTING_MODE_SPECIAL_TRIGGER: c_int = 3;
const enum_unnamed_26 = c_int;
pub const ASENSOR_DIRECT_RATE_STOP: c_int = 0;
pub const ASENSOR_DIRECT_RATE_NORMAL: c_int = 1;
pub const ASENSOR_DIRECT_RATE_FAST: c_int = 2;
pub const ASENSOR_DIRECT_RATE_VERY_FAST: c_int = 3;
const enum_unnamed_27 = c_uint;
pub const ASENSOR_DIRECT_CHANNEL_TYPE_SHARED_MEMORY: c_int = 1;
pub const ASENSOR_DIRECT_CHANNEL_TYPE_HARDWARE_BUFFER: c_int = 2;
const enum_unnamed_28 = c_uint;
pub const ASENSOR_ADDITIONAL_INFO_BEGIN: c_int = 0;
pub const ASENSOR_ADDITIONAL_INFO_END: c_int = 1;
pub const ASENSOR_ADDITIONAL_INFO_UNTRACKED_DELAY: c_int = 65536;
pub const ASENSOR_ADDITIONAL_INFO_INTERNAL_TEMPERATURE: c_int = 65537;
pub const ASENSOR_ADDITIONAL_INFO_VEC3_CALIBRATION: c_int = 65538;
pub const ASENSOR_ADDITIONAL_INFO_SENSOR_PLACEMENT: c_int = 65539;
pub const ASENSOR_ADDITIONAL_INFO_SAMPLING: c_int = 65540;
const enum_unnamed_29 = c_uint;
const struct_unnamed_31 = extern struct {
    x: f32 = @import("std").mem.zeroes(f32),
    y: f32 = @import("std").mem.zeroes(f32),
    z: f32 = @import("std").mem.zeroes(f32),
};
const struct_unnamed_32 = extern struct {
    azimuth: f32 = @import("std").mem.zeroes(f32),
    pitch: f32 = @import("std").mem.zeroes(f32),
    roll: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_30 = extern union {
    v: [3]f32,
    unnamed_0: struct_unnamed_31,
    unnamed_1: struct_unnamed_32,
};
pub const struct_ASensorVector = extern struct {
    unnamed_0: union_unnamed_30 = @import("std").mem.zeroes(union_unnamed_30),
    status: i8 = @import("std").mem.zeroes(i8),
    reserved: [3]u8 = @import("std").mem.zeroes([3]u8),
};
pub const ASensorVector = struct_ASensorVector;
pub const struct_AMetaDataEvent = extern struct {
    what: i32 = @import("std").mem.zeroes(i32),
    sensor: i32 = @import("std").mem.zeroes(i32),
};
pub const AMetaDataEvent = struct_AMetaDataEvent;
const struct_unnamed_34 = extern struct {
    x_uncalib: f32 = @import("std").mem.zeroes(f32),
    y_uncalib: f32 = @import("std").mem.zeroes(f32),
    z_uncalib: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_33 = extern union {
    uncalib: [3]f32,
    unnamed_0: struct_unnamed_34,
};
const struct_unnamed_36 = extern struct {
    x_bias: f32 = @import("std").mem.zeroes(f32),
    y_bias: f32 = @import("std").mem.zeroes(f32),
    z_bias: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_35 = extern union {
    bias: [3]f32,
    unnamed_0: struct_unnamed_36,
};
pub const struct_AUncalibratedEvent = extern struct {
    unnamed_0: union_unnamed_33 = @import("std").mem.zeroes(union_unnamed_33),
    unnamed_1: union_unnamed_35 = @import("std").mem.zeroes(union_unnamed_35),
};
pub const AUncalibratedEvent = struct_AUncalibratedEvent;
pub const struct_AHeartRateEvent = extern struct {
    bpm: f32 = @import("std").mem.zeroes(f32),
    status: i8 = @import("std").mem.zeroes(i8),
};
pub const AHeartRateEvent = struct_AHeartRateEvent;
pub const struct_ADynamicSensorEvent = extern struct {
    connected: i32 = @import("std").mem.zeroes(i32),
    handle: i32 = @import("std").mem.zeroes(i32),
};
pub const ADynamicSensorEvent = struct_ADynamicSensorEvent;
const union_unnamed_37 = extern union {
    data_int32: [14]i32,
    data_float: [14]f32,
};
pub const struct_AAdditionalInfoEvent = extern struct {
    type: i32 = @import("std").mem.zeroes(i32),
    serial: i32 = @import("std").mem.zeroes(i32),
    unnamed_0: union_unnamed_37 = @import("std").mem.zeroes(union_unnamed_37),
};
pub const AAdditionalInfoEvent = struct_AAdditionalInfoEvent;
pub const struct_AHeadTrackerEvent = extern struct {
    rx: f32 = @import("std").mem.zeroes(f32),
    ry: f32 = @import("std").mem.zeroes(f32),
    rz: f32 = @import("std").mem.zeroes(f32),
    vx: f32 = @import("std").mem.zeroes(f32),
    vy: f32 = @import("std").mem.zeroes(f32),
    vz: f32 = @import("std").mem.zeroes(f32),
    discontinuity_count: i32 = @import("std").mem.zeroes(i32),
};
pub const AHeadTrackerEvent = struct_AHeadTrackerEvent;
const struct_unnamed_39 = extern struct {
    x: f32 = @import("std").mem.zeroes(f32),
    y: f32 = @import("std").mem.zeroes(f32),
    z: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_38 = extern union {
    calib: [3]f32,
    unnamed_0: struct_unnamed_39,
};
const struct_unnamed_41 = extern struct {
    x_supported: f32 = @import("std").mem.zeroes(f32),
    y_supported: f32 = @import("std").mem.zeroes(f32),
    z_supported: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_40 = extern union {
    supported: [3]f32,
    unnamed_0: struct_unnamed_41,
};
pub const struct_ALimitedAxesImuEvent = extern struct {
    unnamed_0: union_unnamed_38 = @import("std").mem.zeroes(union_unnamed_38),
    unnamed_1: union_unnamed_40 = @import("std").mem.zeroes(union_unnamed_40),
};
pub const ALimitedAxesImuEvent = struct_ALimitedAxesImuEvent;
const struct_unnamed_43 = extern struct {
    x_uncalib: f32 = @import("std").mem.zeroes(f32),
    y_uncalib: f32 = @import("std").mem.zeroes(f32),
    z_uncalib: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_42 = extern union {
    uncalib: [3]f32,
    unnamed_0: struct_unnamed_43,
};
const struct_unnamed_45 = extern struct {
    x_bias: f32 = @import("std").mem.zeroes(f32),
    y_bias: f32 = @import("std").mem.zeroes(f32),
    z_bias: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_44 = extern union {
    bias: [3]f32,
    unnamed_0: struct_unnamed_45,
};
const struct_unnamed_47 = extern struct {
    x_supported: f32 = @import("std").mem.zeroes(f32),
    y_supported: f32 = @import("std").mem.zeroes(f32),
    z_supported: f32 = @import("std").mem.zeroes(f32),
};
const union_unnamed_46 = extern union {
    supported: [3]f32,
    unnamed_0: struct_unnamed_47,
};
pub const struct_ALimitedAxesImuUncalibratedEvent = extern struct {
    unnamed_0: union_unnamed_42 = @import("std").mem.zeroes(union_unnamed_42),
    unnamed_1: union_unnamed_44 = @import("std").mem.zeroes(union_unnamed_44),
    unnamed_2: union_unnamed_46 = @import("std").mem.zeroes(union_unnamed_46),
};
pub const ALimitedAxesImuUncalibratedEvent = struct_ALimitedAxesImuUncalibratedEvent;
pub const struct_AHeadingEvent = extern struct {
    heading: f32 = @import("std").mem.zeroes(f32),
    accuracy: f32 = @import("std").mem.zeroes(f32),
};
pub const AHeadingEvent = struct_AHeadingEvent;
const union_unnamed_49 = extern union {
    data: [16]f32,
    vector: ASensorVector,
    acceleration: ASensorVector,
    gyro: ASensorVector,
    magnetic: ASensorVector,
    temperature: f32,
    distance: f32,
    light: f32,
    pressure: f32,
    relative_humidity: f32,
    uncalibrated_acceleration: AUncalibratedEvent,
    uncalibrated_gyro: AUncalibratedEvent,
    uncalibrated_magnetic: AUncalibratedEvent,
    meta_data: AMetaDataEvent,
    heart_rate: AHeartRateEvent,
    dynamic_sensor_meta: ADynamicSensorEvent,
    additional_info: AAdditionalInfoEvent,
    head_tracker: AHeadTrackerEvent,
    limited_axes_imu: ALimitedAxesImuEvent,
    limited_axes_imu_uncalibrated: ALimitedAxesImuUncalibratedEvent,
    heading: AHeadingEvent,
};
const union_unnamed_50 = extern union {
    data: [8]u64,
    step_counter: u64,
};
const union_unnamed_48 = extern union {
    unnamed_0: union_unnamed_49,
    u64: union_unnamed_50,
};
pub const struct_ASensorEvent = extern struct {
    version: i32 = @import("std").mem.zeroes(i32),
    sensor: i32 = @import("std").mem.zeroes(i32),
    type: i32 = @import("std").mem.zeroes(i32),
    reserved0: i32 = @import("std").mem.zeroes(i32),
    timestamp: i64 = @import("std").mem.zeroes(i64),
    unnamed_0: union_unnamed_48 = @import("std").mem.zeroes(union_unnamed_48),
    flags: u32 = @import("std").mem.zeroes(u32),
    reserved1: [3]i32 = @import("std").mem.zeroes([3]i32),
};
pub const ASensorEvent = struct_ASensorEvent;
pub const struct_ASensorManager = opaque {};
pub const ASensorManager = struct_ASensorManager;
pub const struct_ASensorEventQueue = opaque {};
pub const ASensorEventQueue = struct_ASensorEventQueue;
pub const struct_ASensor = opaque {};
pub const ASensor = struct_ASensor;
pub const ASensorRef = ?*const ASensor;
pub const ASensorList = [*c]const ASensorRef;
pub extern fn ASensorManager_getInstance(...) ?*ASensorManager;
pub extern fn ASensorManager_getInstanceForPackage(packageName: [*c]const u8) ?*ASensorManager;
pub extern fn ASensorManager_getSensorList(manager: ?*ASensorManager, list: [*c]ASensorList) c_int;
pub extern fn ASensorManager_getDynamicSensorList(manager: ?*ASensorManager, list: [*c]ASensorList) isize;
pub extern fn ASensorManager_getDefaultSensor(manager: ?*ASensorManager, @"type": c_int) ?*const ASensor;
pub extern fn ASensorManager_getDefaultSensorEx(manager: ?*ASensorManager, @"type": c_int, wakeUp: bool) ?*const ASensor;
pub extern fn ASensorManager_createEventQueue(manager: ?*ASensorManager, looper: ?*ALooper, ident: c_int, callback: ALooper_callbackFunc, data: ?*anyopaque) ?*ASensorEventQueue;
pub extern fn ASensorManager_destroyEventQueue(manager: ?*ASensorManager, queue: ?*ASensorEventQueue) c_int;
pub extern fn ASensorManager_createSharedMemoryDirectChannel(manager: ?*ASensorManager, fd: c_int, size: usize) c_int;
pub extern fn ASensorManager_createHardwareBufferDirectChannel(manager: ?*ASensorManager, buffer: ?*const AHardwareBuffer, size: usize) c_int;
pub extern fn ASensorManager_destroyDirectChannel(manager: ?*ASensorManager, channelId: c_int) void;
pub extern fn ASensorManager_configureDirectReport(manager: ?*ASensorManager, sensor: ?*const ASensor, channelId: c_int, rate: c_int) c_int;
pub extern fn ASensorEventQueue_registerSensor(queue: ?*ASensorEventQueue, sensor: ?*const ASensor, samplingPeriodUs: i32, maxBatchReportLatencyUs: i64) c_int;
pub extern fn ASensorEventQueue_enableSensor(queue: ?*ASensorEventQueue, sensor: ?*const ASensor) c_int;
pub extern fn ASensorEventQueue_disableSensor(queue: ?*ASensorEventQueue, sensor: ?*const ASensor) c_int;
pub extern fn ASensorEventQueue_setEventRate(queue: ?*ASensorEventQueue, sensor: ?*const ASensor, usec: i32) c_int;
pub extern fn ASensorEventQueue_hasEvents(queue: ?*ASensorEventQueue) c_int;
pub extern fn ASensorEventQueue_getEvents(queue: ?*ASensorEventQueue, events: [*c]ASensorEvent, count: usize) isize;
pub extern fn ASensorEventQueue_requestAdditionalInfoEvents(queue: ?*ASensorEventQueue, enable: bool) c_int;
pub extern fn ASensor_getName(sensor: ?*const ASensor) [*c]const u8;
pub extern fn ASensor_getVendor(sensor: ?*const ASensor) [*c]const u8;
pub extern fn ASensor_getType(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_getResolution(sensor: ?*const ASensor) f32;
pub extern fn ASensor_getMinDelay(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_getFifoMaxEventCount(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_getFifoReservedEventCount(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_getStringType(sensor: ?*const ASensor) [*c]const u8;
pub extern fn ASensor_getReportingMode(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_isWakeUpSensor(sensor: ?*const ASensor) bool;
pub extern fn ASensor_isDirectChannelTypeSupported(sensor: ?*const ASensor, channelType: c_int) bool;
pub extern fn ASensor_getHighestDirectReportRateLevel(sensor: ?*const ASensor) c_int;
pub extern fn ASensor_getHandle(sensor: ?*const ASensor) c_int;
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const __VERSIONER_NO_GUARD = "";
pub const __VERSIONER_FORTIFY_INLINE = "";
pub const __ANDROID_NDK__ = @as(c_int, 1);
pub const __NDK_MAJOR__ = @as(c_int, 27);
pub const __NDK_MINOR__ = @as(c_int, 0);
pub const __NDK_BETA__ = @as(c_int, 1);
pub const __NDK_BUILD__ = @import("std").zig.c_translation.promoteIntLiteral(c_int, 11718014, .decimal);
pub const __NDK_CANARY__ = @as(c_int, 0);
pub const __ANDROID_API_FUTURE__ = @as(c_int, 10000);
pub const __ANDROID_API__ = __ANDROID_API_FUTURE__;
pub const __ANDROID_API_G__ = @as(c_int, 9);
pub const __ANDROID_API_I__ = @as(c_int, 14);
pub const __ANDROID_API_J__ = @as(c_int, 16);
pub const __ANDROID_API_J_MR1__ = @as(c_int, 17);
pub const __ANDROID_API_J_MR2__ = @as(c_int, 18);
pub const __ANDROID_API_K__ = @as(c_int, 19);
pub const __ANDROID_API_L__ = @as(c_int, 21);
pub const __ANDROID_API_L_MR1__ = @as(c_int, 22);
pub const __ANDROID_API_M__ = @as(c_int, 23);
pub const __ANDROID_API_N__ = @as(c_int, 24);
pub const __ANDROID_API_N_MR1__ = @as(c_int, 25);
pub const __ANDROID_API_O__ = @as(c_int, 26);
pub const __ANDROID_API_O_MR1__ = @as(c_int, 27);
pub const __ANDROID_API_P__ = @as(c_int, 28);
pub const __ANDROID_API_Q__ = @as(c_int, 29);
pub const __ANDROID_API_R__ = @as(c_int, 30);
pub const __ANDROID_API_S__ = @as(c_int, 31);
pub const __ANDROID_API_T__ = @as(c_int, 33);
pub const __ANDROID_API_U__ = @as(c_int, 34);
pub const __ANDROID_API_V__ = @as(c_int, 35);
pub const ANDROID_ASSET_MANAGER_H = "";
pub const _SYS_TYPES_H_ = "";
pub const __STDDEF_H = "";
pub const __need_ptrdiff_t = "";
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const __need_max_align_t = "";
pub const __need_offsetof = "";
pub const _PTRDIFF_T = "";
pub const _SIZE_T = "";
pub const _WCHAR_T = "";
pub const NULL = @import("std").zig.c_translation.cast(?*anyopaque, @as(c_int, 0));
pub const JNI_FALSE = @as(c_int, 0);
pub const JNI_TRUE = @as(c_int, 1);
pub const JNI_VERSION_1_1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010001, .hex);
pub const JNI_VERSION_1_2 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010002, .hex);
pub const JNI_VERSION_1_4 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010004, .hex);
pub const JNI_VERSION_1_6 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010006, .hex);
pub const JNI_OK = @as(c_int, 0);
pub const JNI_ERR = -@as(c_int, 1);
pub const JNI_EDETACHED = -@as(c_int, 2);
pub const JNI_EVERSION = -@as(c_int, 3);
pub const JNI_ENOMEM = -@as(c_int, 4);
pub const JNI_EEXIST = -@as(c_int, 5);
pub const JNI_EINVAL = -@as(c_int, 6);
pub const JNI_COMMIT = @as(c_int, 1);
pub const JNI_ABORT = @as(c_int, 2);
pub const _ANDROID_INPUT_H = "";
pub const _ANDROID_KEYCODES_H = "";
pub const AMOTION_EVENT_ACTION_POINTER_INDEX_SHIFT = @as(c_int, 8);
pub const ANDROID_NATIVE_WINDOW_H = "";
pub const __STDBOOL_H = "";
pub const __bool_true_false_are_defined = @as(c_int, 1);
pub const @"bool" = bool;
pub const @"true" = @as(c_int, 1);
pub const @"false" = @as(c_int, 0);
pub const NR_OPEN = @as(c_int, 1024);
pub const NGROUPS_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const ARG_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 131072, .decimal);
pub const LINK_MAX = @as(c_int, 127);
pub const MAX_CANON = @as(c_int, 255);
pub const MAX_INPUT = @as(c_int, 255);
pub const NAME_MAX = @as(c_int, 255);
pub const PATH_MAX = @as(c_int, 4096);
pub const PIPE_BUF = @as(c_int, 4096);
pub const XATTR_NAME_MAX = @as(c_int, 255);
pub const XATTR_SIZE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const XATTR_LIST_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65536, .decimal);
pub const RTSIG_MAX = @as(c_int, 32);
pub const PASS_MAX = @as(c_int, 128);
pub const NL_ARGMAX = @as(c_int, 9);
pub const NL_LANGMAX = @as(c_int, 14);
pub const NL_MSGMAX = @as(c_int, 32767);
pub const NL_NMAX = @as(c_int, 1);
pub const NL_SETMAX = @as(c_int, 255);
pub const NL_TEXTMAX = @as(c_int, 255);
pub const TMP_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 308915776, .decimal);
pub const CHAR_BIT = @as(c_int, 8);
pub const LONG_BIT = @as(c_int, 32);
pub const WORD_BIT = @as(c_int, 32);
pub const SCHAR_MAX = @as(c_int, 0x7f);
pub const SCHAR_MIN = -@as(c_int, 0x7f) - @as(c_int, 1);
pub const UCHAR_MAX = @as(c_uint, 0xff);
pub const CHAR_MAX = @as(c_int, 0x7f);
pub const CHAR_MIN = -@as(c_int, 0x7f) - @as(c_int, 1);
pub const USHRT_MAX = @as(c_uint, 0xffff);
pub const SHRT_MAX = @as(c_int, 0x7fff);
pub const SHRT_MIN = -@as(c_int, 0x7fff) - @as(c_int, 1);
pub const UINT_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_uint, 0xffffffff, .hex);
pub const INT_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x7fffffff, .hex);
pub const INT_MIN = -@import("std").zig.c_translation.promoteIntLiteral(c_int, 0x7fffffff, .hex) - @as(c_int, 1);
pub const ULONG_MAX = @as(c_ulong, 0xffffffff);
pub const LONG_MAX = @as(c_long, 0x7fffffff);
pub const LONG_MIN = -@as(c_long, 0x7fffffff) - @as(c_int, 1);
pub const ULLONG_MAX = @as(c_ulonglong, 0xffffffffffffffff);
pub const LLONG_MAX = @as(c_longlong, 0x7fffffffffffffff);
pub const LLONG_MIN = -@as(c_longlong, 0x7fffffffffffffff) - @as(c_int, 1);
pub const LONG_LONG_MIN = LLONG_MIN;
pub const LONG_LONG_MAX = LLONG_MAX;
pub const ULONG_LONG_MAX = ULLONG_MAX;
pub const UID_MAX = UINT_MAX;
pub const GID_MAX = UINT_MAX;
pub const SIZE_T_MAX = UINT_MAX;
pub const SSIZE_MAX = INT_MAX;
pub const MB_LEN_MAX = @as(c_int, 4);
pub const NZERO = @as(c_int, 20);
pub const IOV_MAX = @as(c_int, 1024);
pub const SEM_VALUE_MAX = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x3fffffff, .hex);
pub const _BITS_POSIX_LIMITS_H_ = "";
pub const _POSIX_VERSION = @as(c_long, 200809);
pub const _POSIX2_VERSION = _POSIX_VERSION;
pub const _XOPEN_VERSION = @as(c_int, 700);
pub const __BIONIC_POSIX_FEATURE_MISSING = -@as(c_int, 1);
pub inline fn __BIONIC_POSIX_FEATURE_SINCE(level: anytype) @TypeOf(if (__ANDROID_API__ >= level) _POSIX_VERSION else __BIONIC_POSIX_FEATURE_MISSING) {
    _ = &level;
    return if (__ANDROID_API__ >= level) _POSIX_VERSION else __BIONIC_POSIX_FEATURE_MISSING;
}
pub const _POSIX_ADVISORY_INFO = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 23));
pub const _POSIX_ASYNCHRONOUS_IO = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_BARRIERS = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 24));
pub const _POSIX_CHOWN_RESTRICTED = @as(c_int, 1);
pub const _POSIX_CLOCK_SELECTION = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 21));
pub const _POSIX_CPUTIME = _POSIX_VERSION;
pub const _POSIX_FSYNC = _POSIX_VERSION;
pub const _POSIX_IPV6 = _POSIX_VERSION;
pub const _POSIX_JOB_CONTROL = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 21));
pub const _POSIX_MAPPED_FILES = _POSIX_VERSION;
pub const _POSIX_MEMLOCK = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 17));
pub const _POSIX_MEMLOCK_RANGE = _POSIX_VERSION;
pub const _POSIX_MEMORY_PROTECTION = _POSIX_VERSION;
pub const _POSIX_MESSAGE_PASSING = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_MONOTONIC_CLOCK = _POSIX_VERSION;
pub const _POSIX_NO_TRUNC = @as(c_int, 1);
pub const _POSIX_PRIORITIZED_IO = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_PRIORITY_SCHEDULING = _POSIX_VERSION;
pub const _POSIX_RAW_SOCKETS = _POSIX_VERSION;
pub const _POSIX_READER_WRITER_LOCKS = _POSIX_VERSION;
pub const _POSIX_REALTIME_SIGNALS = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 23));
pub const _POSIX_REGEXP = @as(c_int, 1);
pub const _POSIX_SAVED_IDS = @as(c_int, 1);
pub const _POSIX_SEMAPHORES = _POSIX_VERSION;
pub const _POSIX_SHARED_MEMORY_OBJECTS = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_SHELL = @as(c_int, 1);
pub const _POSIX_SPAWN = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 28));
pub const _POSIX_SPIN_LOCKS = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 24));
pub const _POSIX_SPORADIC_SERVER = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_SYNCHRONIZED_IO = _POSIX_VERSION;
pub const _POSIX_THREAD_ATTR_STACKADDR = _POSIX_VERSION;
pub const _POSIX_THREAD_ATTR_STACKSIZE = _POSIX_VERSION;
pub const _POSIX_THREAD_CPUTIME = _POSIX_VERSION;
pub const _POSIX_THREAD_PRIO_INHERIT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_THREAD_PRIO_PROTECT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_THREAD_PRIORITY_SCHEDULING = _POSIX_VERSION;
pub const _POSIX_THREAD_PROCESS_SHARED = _POSIX_VERSION;
pub const _POSIX_THREAD_ROBUST_PRIO_INHERIT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_THREAD_ROBUST_PRIO_PROTECT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_THREAD_SAFE_FUNCTIONS = _POSIX_VERSION;
pub const _POSIX_THREAD_SPORADIC_SERVER = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_THREADS = _POSIX_VERSION;
pub const _POSIX_TIMEOUTS = __BIONIC_POSIX_FEATURE_SINCE(@as(c_int, 21));
pub const _POSIX_TIMERS = _POSIX_VERSION;
pub const _POSIX_TRACE = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_TRACE_EVENT_FILTER = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_TRACE_INHERIT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_TRACE_LOG = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_TYPED_MEMORY_OBJECTS = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_VDISABLE = '\x00';
pub const _POSIX2_C_BIND = _POSIX_VERSION;
pub const _POSIX2_C_DEV = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX2_CHAR_TERM = _POSIX_VERSION;
pub const _POSIX2_FORT_DEV = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX2_FORT_RUN = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX2_LOCALEDEF = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX2_SW_DEV = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX2_UPE = __BIONIC_POSIX_FEATURE_MISSING;
pub const _POSIX_V7_ILP32_OFF32 = @as(c_int, 1);
pub const _POSIX_V7_ILP32_OFFBIG = -@as(c_int, 1);
pub const _POSIX_V7_LP64_OFF64 = -@as(c_int, 1);
pub const _POSIX_V7_LPBIG_OFFBIG = -@as(c_int, 1);
pub const _XOPEN_CRYPT = __BIONIC_POSIX_FEATURE_MISSING;
pub const _XOPEN_ENH_I18N = @as(c_int, 1);
pub const _XOPEN_LEGACY = __BIONIC_POSIX_FEATURE_MISSING;
pub const _XOPEN_REALTIME = @as(c_int, 1);
pub const _XOPEN_REALTIME_THREADS = @as(c_int, 1);
pub const _XOPEN_SHM = @as(c_int, 1);
pub const _XOPEN_STREAMS = __BIONIC_POSIX_FEATURE_MISSING;
pub const _XOPEN_UNIX = @as(c_int, 1);
pub const _POSIX_AIO_LISTIO_MAX = @as(c_int, 2);
pub const _POSIX_AIO_MAX = @as(c_int, 1);
pub const _POSIX_ARG_MAX = @as(c_int, 4096);
pub const _POSIX_CHILD_MAX = @as(c_int, 25);
pub const _POSIX_CLOCKRES_MIN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 20000000, .decimal);
pub const _POSIX_DELAYTIMER_MAX = @as(c_int, 32);
pub const _POSIX_HOST_NAME_MAX = @as(c_int, 255);
pub const _POSIX_LINK_MAX = @as(c_int, 8);
pub const _POSIX_LOGIN_NAME_MAX = @as(c_int, 9);
pub const _POSIX_MAX_CANON = @as(c_int, 255);
pub const _POSIX_MAX_INPUT = @as(c_int, 255);
pub const _POSIX_MQ_OPEN_MAX = @as(c_int, 8);
pub const _POSIX_MQ_PRIO_MAX = @as(c_int, 32);
pub const _POSIX_NAME_MAX = @as(c_int, 14);
pub const _POSIX_NGROUPS_MAX = @as(c_int, 8);
pub const _POSIX_OPEN_MAX = @as(c_int, 20);
pub const _POSIX_PATH_MAX = @as(c_int, 256);
pub const _POSIX_PIPE_BUF = @as(c_int, 512);
pub const _POSIX_RE_DUP_MAX = @as(c_int, 255);
pub const _POSIX_RTSIG_MAX = @as(c_int, 8);
pub const _POSIX_SEM_NSEMS_MAX = @as(c_int, 256);
pub const _POSIX_SEM_VALUE_MAX = @as(c_int, 32767);
pub const _POSIX_SIGQUEUE_MAX = @as(c_int, 32);
pub const _POSIX_SSIZE_MAX = @as(c_int, 32767);
pub const _POSIX_STREAM_MAX = @as(c_int, 8);
pub const _POSIX_SS_REPL_MAX = @as(c_int, 4);
pub const _POSIX_SYMLINK_MAX = @as(c_int, 255);
pub const _POSIX_SYMLOOP_MAX = @as(c_int, 8);
pub const _POSIX_THREAD_DESTRUCTOR_ITERATIONS = @as(c_int, 4);
pub const _POSIX_THREAD_KEYS_MAX = @as(c_int, 128);
pub const _POSIX_THREAD_THREADS_MAX = @as(c_int, 64);
pub const _POSIX_TIMER_MAX = @as(c_int, 32);
pub const _POSIX_TRACE_EVENT_NAME_MAX = @as(c_int, 30);
pub const _POSIX_TRACE_NAME_MAX = @as(c_int, 8);
pub const _POSIX_TRACE_SYS_MAX = @as(c_int, 8);
pub const _POSIX_TRACE_USER_EVENT_MAX = @as(c_int, 32);
pub const _POSIX_TTY_NAME_MAX = @as(c_int, 9);
pub const _POSIX_TZNAME_MAX = @as(c_int, 6);
pub const _POSIX2_BC_BASE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_DIM_MAX = @as(c_int, 2048);
pub const _POSIX2_BC_SCALE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_STRING_MAX = @as(c_int, 1000);
pub const _POSIX2_CHARCLASS_NAME_MAX = @as(c_int, 14);
pub const _POSIX2_COLL_WEIGHTS_MAX = @as(c_int, 2);
pub const _POSIX2_EXPR_NEST_MAX = @as(c_int, 32);
pub const _POSIX2_LINE_MAX = @as(c_int, 2048);
pub const _POSIX2_RE_DUP_MAX = @as(c_int, 255);
pub const _XOPEN_IOV_MAX = @as(c_int, 16);
pub const _XOPEN_NAME_MAX = @as(c_int, 255);
pub const _XOPEN_PATH_MAX = @as(c_int, 1024);
pub const HOST_NAME_MAX = _POSIX_HOST_NAME_MAX;
pub const LOGIN_NAME_MAX = @as(c_int, 256);
pub const TTY_NAME_MAX = @as(c_int, 32);
pub const PTHREAD_DESTRUCTOR_ITERATIONS = @as(c_int, 4);
pub const PTHREAD_KEYS_MAX = @as(c_int, 128);
pub const FP_INFINITE = @as(c_int, 0x01);
pub const FP_NAN = @as(c_int, 0x02);
pub const FP_NORMAL = @as(c_int, 0x04);
pub const FP_SUBNORMAL = @as(c_int, 0x08);
pub const FP_ZERO = @as(c_int, 0x10);
pub const FP_ILOGB0 = -INT_MAX;
pub const FP_ILOGBNAN = INT_MAX;
pub const MATH_ERRNO = @as(c_int, 1);
pub const MATH_ERREXCEPT = @as(c_int, 2);
pub const math_errhandling = MATH_ERREXCEPT;
pub const M_E = @as(f64, 2.7182818284590452354);
pub const M_LOG2E = @as(f64, 1.4426950408889634074);
pub const M_LOG10E = @as(f64, 0.43429448190325182765);
pub const M_LN2 = @as(f64, 0.69314718055994530942);
pub const M_LN10 = @as(f64, 2.30258509299404568402);
pub const M_PI = @as(f64, 3.14159265358979323846);
pub const M_PI_2 = @as(f64, 1.57079632679489661923);
pub const M_PI_4 = @as(f64, 0.78539816339744830962);
pub const M_1_PI = @as(f64, 0.31830988618379067154);
pub const M_2_PI = @as(f64, 0.63661977236758134308);
pub const M_2_SQRTPI = @as(f64, 1.12837916709551257390);
pub const M_SQRT2 = @as(f64, 1.41421356237309504880);
pub const M_SQRT1_2 = @as(f64, 0.70710678118654752440);
pub const MAXFLOAT = @import("std").zig.c_translation.cast(f32, @as(f64, 3.40282346638528860e+38));
pub const ASENSOR_RESOLUTION_INVALID = nanf("");
pub const ASENSOR_FIFO_COUNT_INVALID = -@as(c_int, 1);
pub const ASENSOR_DELAY_INVALID = @as(c_int, @import("std").math.minInt(c_int));
pub const ASENSOR_INVALID = -@as(c_int, 1);
pub const ASENSOR_STANDARD_GRAVITY = @as(f32, 9.80665);
pub const ASENSOR_MAGNETIC_FIELD_EARTH_MAX = @as(f32, 60.0);
pub const ASENSOR_MAGNETIC_FIELD_EARTH_MIN = @as(f32, 30.0);
pub const log_id = enum_log_id;
pub const __android_log_message = struct___android_log_message;
pub const _jfieldID = struct__jfieldID;
pub const _jmethodID = struct__jmethodID;
pub const JNINativeInterface = struct_JNINativeInterface;
pub const JNIInvokeInterface = struct_JNIInvokeInterface;
pub const _JNIEnv = struct__JNIEnv;
pub const _JavaVM = struct__JavaVM;
pub const AMotionClassification = enum_AMotionClassification;
pub const ADataSpace = enum_ADataSpace;
pub const AHardwareBuffer_Format = enum_AHardwareBuffer_Format;
pub const AHardwareBuffer_UsageFlags = enum_AHardwareBuffer_UsageFlags;
pub const ANativeWindow_LegacyFormat = enum_ANativeWindow_LegacyFormat;
pub const ANativeWindowTransform = enum_ANativeWindowTransform;
pub const ANativeWindow_FrameRateCompatibility = enum_ANativeWindow_FrameRateCompatibility;
pub const ANativeWindow_ChangeFrameRateStrategy = enum_ANativeWindow_ChangeFrameRateStrategy;
