pub const BOOL = c_int;
pub const CHAR = u8;
pub const SHORT = c_short;
pub const INT = c_int;
pub const LONG = c_long;
pub const UCHAR = u8;
pub const USHORT = c_ushort;
pub const PUSHORT = [*c]USHORT;
pub const UINT = c_uint;
pub const UINT16 = c_ushort;
pub const UINT32 = UINT;
pub const UINT64 = u64;
pub const ULONG = c_ulong;
pub const BYTE = u8;
pub const WORD = c_ushort;
pub const FLOAT = f32;
pub const DWORD = c_ulong;
pub const wchar_t = c_ushort;
pub const WCHAR = wchar_t;
pub const PWCHAR = [*c]wchar_t;
pub const ATOM = WORD;
pub const ULONG32 = c_uint;
pub const DWORD64 = u64;
pub const ULONG64 = u64;
pub const LPINT = [*c]c_int;
pub const INT32 = c_int;
pub const INT64 = c_longlong;
pub const DWORDLONG = u64;
pub const PCHAR = [*c]CHAR;
pub const PULONG = [*c]ULONG;
pub const PULONG64 = [*c]ULONG64;
pub const PDWORD64 = [*c]DWORD64;
pub const LONGLONG = i64;
pub const ULONGLONG = u64;
pub const VOID = anyopaque;
pub const PVOID = ?*anyopaque;
pub const LPVOID = ?*anyopaque;
pub const PBOOL = [*c]BOOL;
pub const LPBOOL = [*c]BOOL;
pub const PWORD = [*c]WORD;
pub const PLONG = [*c]LONG;
pub const LPLONG = [*c]LONG;
pub const PDWORD = [*c]DWORD;
pub const HANDLE = LPVOID;
pub const HINSTANCE = HANDLE;
pub const HWND = HANDLE;
pub const HMODULE = HINSTANCE;
pub const HDC = HANDLE;
pub const HGLRC = HANDLE;
pub const HMENU = HANDLE;
pub const PHANDLE = [*c]HANDLE;
pub const LPHANDLE = [*c]HANDLE;
pub const PWSTR = [*c]WCHAR;
pub const LPBYTE = [*c]BYTE;
pub const LPDWORD = [*c]DWORD;
pub const LPCVOID = ?*const anyopaque;
pub const INT_PTR = isize;
pub const LONG_PTR = isize;
pub const UINT_PTR = usize;
pub const ULONG_PTR = usize;
pub const DWORD_PTR = ULONG_PTR;
pub const PDWORD_PTR = [*c]DWORD_PTR;
pub const SIZE_T = ULONG_PTR;
pub const SSIZE_T = LONG_PTR;
pub const LPSTR = [*c]CHAR;
pub const LPWSTR = [*c]WCHAR;
pub const LPCSTR = [*c]const CHAR;
pub const LPCWSTR = [*c]const WCHAR;
pub const TCHAR = u8;
pub const TBYTE = u8;
pub const LPCTSTR = LPCSTR;
pub const LPTSTR = LPSTR;
pub const FARPROC = ?*const fn () callconv(@import("std").os.windows.WINAPI) INT_PTR;
pub const NEARPROC = ?*const fn () callconv(@import("std").os.windows.WINAPI) INT_PTR;
pub const PROC = ?*const fn () callconv(@import("std").os.windows.WINAPI) INT_PTR;
pub const ACCESS_MASK = DWORD;
pub const PACCESS_MASK = [*c]ACCESS_MASK;
pub const HICON = HANDLE;
pub const HBRUSH = HANDLE;
pub const HCURSOR = HICON;
pub const HRESULT = LONG;
pub const LRESULT = LONG_PTR;
pub const LPARAM = LONG_PTR;
pub const WPARAM = UINT_PTR;
pub const HGDIOBJ = ?*anyopaque;
pub const HKEY = HANDLE;
pub const PHKEY = [*c]HKEY;
pub const REGSAM = ACCESS_MASK;
pub const struct__SECURITY_ATTRIBUTES = extern struct {
    nLength: DWORD = @import("std").mem.zeroes(DWORD),
    lpSecurityDescriptor: LPVOID = @import("std").mem.zeroes(LPVOID),
    bInheritHandle: BOOL = @import("std").mem.zeroes(BOOL),
};
pub const SECURITY_ATTRIBUTES = struct__SECURITY_ATTRIBUTES;
pub const PSECURITY_ATTRIBUTES = [*c]struct__SECURITY_ATTRIBUTES;
pub const LPSECURITY_ATTRIBUTES = [*c]struct__SECURITY_ATTRIBUTES;
const struct_unnamed_1 = extern struct {
    LowPart: DWORD = @import("std").mem.zeroes(DWORD),
    HighPart: LONG = @import("std").mem.zeroes(LONG),
};
const struct_unnamed_2 = extern struct {
    LowPart: DWORD = @import("std").mem.zeroes(DWORD),
    HighPart: LONG = @import("std").mem.zeroes(LONG),
};
pub const union__LARGE_INTEGER = extern union {
    unnamed_0: struct_unnamed_1,
    u: struct_unnamed_2,
    QuadPart: LONGLONG,
};
pub const LARGE_INTEGER = union__LARGE_INTEGER;
pub const PLARGE_INTEGER = [*c]union__LARGE_INTEGER;
const struct_unnamed_3 = extern struct {
    LowPart: DWORD = @import("std").mem.zeroes(DWORD),
    HighPart: DWORD = @import("std").mem.zeroes(DWORD),
};
const struct_unnamed_4 = extern struct {
    LowPart: DWORD = @import("std").mem.zeroes(DWORD),
    HighPart: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const union__ULARGE_INTEGER = extern union {
    unnamed_0: struct_unnamed_3,
    u: struct_unnamed_4,
    QuadPart: ULONGLONG,
};
pub const ULARGE_INTEGER = union__ULARGE_INTEGER;
pub const PULARGE_INTEGER = [*c]union__ULARGE_INTEGER;
pub const struct__FILETIME = extern struct {
    dwLowDateTime: DWORD = @import("std").mem.zeroes(DWORD),
    dwHighDateTime: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const FILETIME = struct__FILETIME;
pub const PFILETIME = [*c]struct__FILETIME;
pub const LPFILETIME = [*c]struct__FILETIME;
pub extern fn _mm_pause() callconv(@import("std").os.windows.WINAPI) void;
pub extern fn _ReadWriteBarrier() callconv(@import("std").os.windows.WINAPI) void;
pub extern fn _InterlockedExchange8(Target: [*c]volatile u8, Value: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedExchangeAdd8(Addend: [*c]volatile u8, Value: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedExchangeAnd8(Destination: [*c]volatile u8, Value: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedExchangeOr8(Destination: [*c]volatile u8, Value: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedExchangeXor8(Destination: [*c]volatile u8, Value: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedDecrement8(Addend: [*c]volatile u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedIncrement8(Addend: [*c]volatile u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedCompareExchange8(Destination: [*c]volatile u8, Exchange: u8, Comparand: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedCompareExchange8_HLEAcquire(Destination: [*c]volatile u8, Exchange: u8, Comparand: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedCompareExchange8_HLERelease(Destination: [*c]volatile u8, Exchange: u8, Comparand: u8) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _InterlockedExchange16(Target: [*c]volatile c_short, Value: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedExchangeAdd16(Addend: [*c]volatile c_short, Value: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedExchangeAnd16(Destination: [*c]volatile c_short, Value: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedExchangeOr16(Destination: [*c]volatile c_short, Value: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedExchangeXor16(Destination: [*c]volatile c_short, Value: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedDecrement16(Addend: [*c]volatile c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedIncrement16(Addend: [*c]volatile c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedCompareExchange16(Destination: [*c]volatile c_short, Exchange: c_short, Comparand: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedCompareExchange16_HLEAcquire(Destination: [*c]volatile c_short, Exchange: c_short, Comparand: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedCompareExchange16_HLERelease(Destination: [*c]volatile c_short, Exchange: c_short, Comparand: c_short) callconv(@import("std").os.windows.WINAPI) c_short;
pub extern fn _InterlockedExchange(Target: [*c]volatile c_long, Value: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedExchangeAdd(Addend: [*c]volatile c_long, Value: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedExchangeAnd(Destination: [*c]volatile c_long, Value: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedExchangeOr(Destination: [*c]volatile c_long, Value: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedExchangeXor(Destination: [*c]volatile c_long, Value: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedDecrement(Addend: [*c]volatile c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedIncrement(Addend: [*c]volatile c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedCompareExchange(Destination: [*c]volatile c_long, Exchange: c_long, Comparand: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedCompareExchange_HLEAcquire(Destination: [*c]volatile c_long, Exchange: c_long, Comparand: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub extern fn _InterlockedCompareExchange_HLERelease(Destination: [*c]volatile c_long, Exchange: c_long, Comparand: c_long) callconv(@import("std").os.windows.WINAPI) c_long;
pub const SymTagNull: c_int = 0;
pub const SymTagExe: c_int = 1;
pub const SymTagCompiland: c_int = 2;
pub const SymTagCompilandDetails: c_int = 3;
pub const SymTagCompilandEnv: c_int = 4;
pub const SymTagFunction: c_int = 5;
pub const SymTagBlock: c_int = 6;
pub const SymTagData: c_int = 7;
pub const SymTagAnnotation: c_int = 8;
pub const SymTagLabel: c_int = 9;
pub const SymTagPublicSymbol: c_int = 10;
pub const SymTagUDT: c_int = 11;
pub const SymTagEnum: c_int = 12;
pub const SymTagFunctionType: c_int = 13;
pub const SymTagPointerType: c_int = 14;
pub const SymTagArrayType: c_int = 15;
pub const SymTagBaseType: c_int = 16;
pub const SymTagTypedef: c_int = 17;
pub const SymTagBaseClass: c_int = 18;
pub const SymTagFriend: c_int = 19;
pub const SymTagFunctionArgType: c_int = 20;
pub const SymTagFuncDebugStart: c_int = 21;
pub const SymTagFuncDebugEnd: c_int = 22;
pub const SymTagUsingNamespace: c_int = 23;
pub const SymTagVTableShape: c_int = 24;
pub const SymTagVTable: c_int = 25;
pub const SymTagCustom: c_int = 26;
pub const SymTagThunk: c_int = 27;
pub const SymTagCustomType: c_int = 28;
pub const SymTagManagedType: c_int = 29;
pub const SymTagDimension: c_int = 30;
pub const SymTagCallSite: c_int = 31;
pub const SymTagInlineSite: c_int = 32;
pub const SymTagBaseInterface: c_int = 33;
pub const SymTagVectorType: c_int = 34;
pub const SymTagMatrixType: c_int = 35;
pub const SymTagHLSLType: c_int = 36;
pub const enum_SymTagEnum = c_uint;
const union_unnamed_5 = extern union {
    FiberData: ?*anyopaque,
    Version: DWORD,
};
pub const struct__NT_TIB = extern struct {
    ExceptionList: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    StackBase: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    StackLimit: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    SubSystemTib: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    unnamed_0: union_unnamed_5 = @import("std").mem.zeroes(union_unnamed_5),
    ArbitraryUserPointer: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    Self: [*c]struct__NT_TIB = @import("std").mem.zeroes([*c]struct__NT_TIB),
};
pub const NT_TIB = struct__NT_TIB;
pub const LPNT_TIB = [*c]struct__NT_TIB;
pub const PNT_TIB = [*c]struct__NT_TIB;
pub const struct__M128A = extern struct {
    Low: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    High: LONGLONG = @import("std").mem.zeroes(LONGLONG),
};
pub const M128A = struct__M128A;
pub const PM128A = [*c]struct__M128A;
pub const struct__XSAVE_FORMAT = extern struct {
    ControlWord: WORD = @import("std").mem.zeroes(WORD),
    StatusWord: WORD = @import("std").mem.zeroes(WORD),
    TagWord: BYTE = @import("std").mem.zeroes(BYTE),
    Reserved1: BYTE = @import("std").mem.zeroes(BYTE),
    ErrorOpcode: WORD = @import("std").mem.zeroes(WORD),
    ErrorOffset: DWORD = @import("std").mem.zeroes(DWORD),
    ErrorSelector: WORD = @import("std").mem.zeroes(WORD),
    Reserved2: WORD = @import("std").mem.zeroes(WORD),
    DataOffset: DWORD = @import("std").mem.zeroes(DWORD),
    DataSelector: WORD = @import("std").mem.zeroes(WORD),
    Reserved3: WORD = @import("std").mem.zeroes(WORD),
    MxCsr: DWORD = @import("std").mem.zeroes(DWORD),
    MxCsr_Mask: DWORD = @import("std").mem.zeroes(DWORD),
    FloatRegisters: [8]M128A = @import("std").mem.zeroes([8]M128A),
    XmmRegisters: [16]M128A = @import("std").mem.zeroes([16]M128A),
    Reserved4: [96]BYTE = @import("std").mem.zeroes([96]BYTE),
};
pub const XSAVE_FORMAT = struct__XSAVE_FORMAT;
pub const PXSAVE_FORMAT = [*c]struct__XSAVE_FORMAT;
pub const XMM_SAVE_AREA32 = XSAVE_FORMAT;
pub const PXMM_SAVE_AREA32 = [*c]XSAVE_FORMAT;
const struct_unnamed_7 = extern struct {
    Header: [2]M128A = @import("std").mem.zeroes([2]M128A),
    Legacy: [8]M128A = @import("std").mem.zeroes([8]M128A),
    Xmm0: M128A = @import("std").mem.zeroes(M128A),
    Xmm1: M128A = @import("std").mem.zeroes(M128A),
    Xmm2: M128A = @import("std").mem.zeroes(M128A),
    Xmm3: M128A = @import("std").mem.zeroes(M128A),
    Xmm4: M128A = @import("std").mem.zeroes(M128A),
    Xmm5: M128A = @import("std").mem.zeroes(M128A),
    Xmm6: M128A = @import("std").mem.zeroes(M128A),
    Xmm7: M128A = @import("std").mem.zeroes(M128A),
    Xmm8: M128A = @import("std").mem.zeroes(M128A),
    Xmm9: M128A = @import("std").mem.zeroes(M128A),
    Xmm10: M128A = @import("std").mem.zeroes(M128A),
    Xmm11: M128A = @import("std").mem.zeroes(M128A),
    Xmm12: M128A = @import("std").mem.zeroes(M128A),
    Xmm13: M128A = @import("std").mem.zeroes(M128A),
    Xmm14: M128A = @import("std").mem.zeroes(M128A),
    Xmm15: M128A = @import("std").mem.zeroes(M128A),
};
const union_unnamed_6 = extern union {
    FltSave: XMM_SAVE_AREA32,
    DUMMYSTRUCTNAME: struct_unnamed_7,
};
pub const struct__CONTEXT = extern struct {
    P1Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    P2Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    P3Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    P4Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    P5Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    P6Home: DWORD64 = @import("std").mem.zeroes(DWORD64),
    ContextFlags: DWORD = @import("std").mem.zeroes(DWORD),
    MxCsr: DWORD = @import("std").mem.zeroes(DWORD),
    SegCs: WORD = @import("std").mem.zeroes(WORD),
    SegDs: WORD = @import("std").mem.zeroes(WORD),
    SegEs: WORD = @import("std").mem.zeroes(WORD),
    SegFs: WORD = @import("std").mem.zeroes(WORD),
    SegGs: WORD = @import("std").mem.zeroes(WORD),
    SegSs: WORD = @import("std").mem.zeroes(WORD),
    EFlags: DWORD = @import("std").mem.zeroes(DWORD),
    Dr0: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Dr1: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Dr2: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Dr3: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Dr6: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Dr7: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rax: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rcx: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rdx: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rbx: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rsp: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rbp: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rsi: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rdi: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R8: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R9: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R10: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R11: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R12: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R13: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R14: DWORD64 = @import("std").mem.zeroes(DWORD64),
    R15: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Rip: DWORD64 = @import("std").mem.zeroes(DWORD64),
    DUMMYUNIONNAME: union_unnamed_6 = @import("std").mem.zeroes(union_unnamed_6),
    VectorRegister: [26]M128A = @import("std").mem.zeroes([26]M128A),
    VectorControl: DWORD64 = @import("std").mem.zeroes(DWORD64),
    DebugControl: DWORD64 = @import("std").mem.zeroes(DWORD64),
    LastBranchToRip: DWORD64 = @import("std").mem.zeroes(DWORD64),
    LastBranchFromRip: DWORD64 = @import("std").mem.zeroes(DWORD64),
    LastExceptionToRip: DWORD64 = @import("std").mem.zeroes(DWORD64),
    LastExceptionFromRip: DWORD64 = @import("std").mem.zeroes(DWORD64),
};
pub const CONTEXT = struct__CONTEXT;
pub const PCONTEXT = [*c]struct__CONTEXT;
pub const LPCONTEXT = PCONTEXT;
pub const struct__EXCEPTION_RECORD = extern struct {
    ExceptionCode: DWORD = @import("std").mem.zeroes(DWORD),
    ExceptionFlags: DWORD = @import("std").mem.zeroes(DWORD),
    ExceptionRecord: [*c]struct__EXCEPTION_RECORD = @import("std").mem.zeroes([*c]struct__EXCEPTION_RECORD),
    ExceptionAddress: PVOID = @import("std").mem.zeroes(PVOID),
    NumberParameters: DWORD = @import("std").mem.zeroes(DWORD),
    ExceptionInformation: [15]ULONG_PTR = @import("std").mem.zeroes([15]ULONG_PTR),
};
pub const EXCEPTION_RECORD = struct__EXCEPTION_RECORD;
pub const PEXCEPTION_RECORD = [*c]struct__EXCEPTION_RECORD;
pub const struct__EXCEPTION_POINTERS = extern struct {
    ExceptionRecord: PEXCEPTION_RECORD = @import("std").mem.zeroes(PEXCEPTION_RECORD),
    ContextRecord: PCONTEXT = @import("std").mem.zeroes(PCONTEXT),
};
pub const EXCEPTION_POINTERS = struct__EXCEPTION_POINTERS;
pub const PEXCEPTION_POINTERS = [*c]struct__EXCEPTION_POINTERS;
pub const LPEXCEPTION_POINTERS = PEXCEPTION_POINTERS;
pub const PTOP_LEVEL_EXCEPTION_FILTER = ?*const fn ([*c]struct__EXCEPTION_POINTERS) callconv(@import("std").os.windows.WINAPI) LONG;
pub const LPTOP_LEVEL_EXCEPTION_FILTER = PTOP_LEVEL_EXCEPTION_FILTER;
pub const PVECTORED_EXCEPTION_HANDLER = ?*const fn ([*c]struct__EXCEPTION_POINTERS) callconv(@import("std").os.windows.WINAPI) LONG;
pub const struct__SYMBOL_INFO = extern struct {
    SizeOfStruct: ULONG = @import("std").mem.zeroes(ULONG),
    TypeIndex: ULONG = @import("std").mem.zeroes(ULONG),
    Reserved: [2]ULONG64 = @import("std").mem.zeroes([2]ULONG64),
    Index: ULONG = @import("std").mem.zeroes(ULONG),
    Size: ULONG = @import("std").mem.zeroes(ULONG),
    ModBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Flags: ULONG = @import("std").mem.zeroes(ULONG),
    Value: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Address: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Register: ULONG = @import("std").mem.zeroes(ULONG),
    Scope: ULONG = @import("std").mem.zeroes(ULONG),
    Tag: ULONG = @import("std").mem.zeroes(ULONG),
    NameLen: ULONG = @import("std").mem.zeroes(ULONG),
    MaxNameLen: ULONG = @import("std").mem.zeroes(ULONG),
    Name: [1]CHAR = @import("std").mem.zeroes([1]CHAR),
};
pub const SYMBOL_INFO = struct__SYMBOL_INFO;
pub const PSYMBOL_INFO = [*c]struct__SYMBOL_INFO;
pub const struct__SYMBOL_INFOW = extern struct {
    SizeOfStruct: ULONG = @import("std").mem.zeroes(ULONG),
    TypeIndex: ULONG = @import("std").mem.zeroes(ULONG),
    Reserved: [2]ULONG64 = @import("std").mem.zeroes([2]ULONG64),
    Index: ULONG = @import("std").mem.zeroes(ULONG),
    Size: ULONG = @import("std").mem.zeroes(ULONG),
    ModBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Flags: ULONG = @import("std").mem.zeroes(ULONG),
    Value: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Address: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Register: ULONG = @import("std").mem.zeroes(ULONG),
    Scope: ULONG = @import("std").mem.zeroes(ULONG),
    Tag: ULONG = @import("std").mem.zeroes(ULONG),
    NameLen: ULONG = @import("std").mem.zeroes(ULONG),
    MaxNameLen: ULONG = @import("std").mem.zeroes(ULONG),
    Name: [1]WCHAR = @import("std").mem.zeroes([1]WCHAR),
};
pub const SYMBOL_INFOW = struct__SYMBOL_INFOW;
pub const PSYMBOL_INFOW = [*c]struct__SYMBOL_INFOW;
pub const struct__IMAGEHLP_LINE64 = extern struct {
    SizeOfStruct: DWORD = @import("std").mem.zeroes(DWORD),
    Key: PVOID = @import("std").mem.zeroes(PVOID),
    LineNumber: DWORD = @import("std").mem.zeroes(DWORD),
    FileName: PCHAR = @import("std").mem.zeroes(PCHAR),
    Address: DWORD64 = @import("std").mem.zeroes(DWORD64),
};
pub const IMAGEHLP_LINE64 = struct__IMAGEHLP_LINE64;
pub const PIMAGEHLP_LINE64 = [*c]struct__IMAGEHLP_LINE64;
pub const struct__IMAGEHLP_LINEW64 = extern struct {
    SizeOfStruct: DWORD = @import("std").mem.zeroes(DWORD),
    Key: PVOID = @import("std").mem.zeroes(PVOID),
    LineNumber: DWORD = @import("std").mem.zeroes(DWORD),
    FileName: PWSTR = @import("std").mem.zeroes(PWSTR),
    Address: DWORD64 = @import("std").mem.zeroes(DWORD64),
};
pub const IMAGEHLP_LINEW64 = struct__IMAGEHLP_LINEW64;
pub const PIMAGEHLP_LINEW64 = [*c]struct__IMAGEHLP_LINEW64;
pub const struct_tagTHREADENTRY32 = extern struct {
    dwSize: DWORD = @import("std").mem.zeroes(DWORD),
    cntUsage: DWORD = @import("std").mem.zeroes(DWORD),
    th32ThreadID: DWORD = @import("std").mem.zeroes(DWORD),
    th32OwnerProcessID: DWORD = @import("std").mem.zeroes(DWORD),
    tpBasePri: LONG = @import("std").mem.zeroes(LONG),
    tpDeltaPri: LONG = @import("std").mem.zeroes(LONG),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const THREADENTRY32 = struct_tagTHREADENTRY32;
pub const PTHREADENTRY32 = [*c]struct_tagTHREADENTRY32;
pub const LPTHREADENTRY32 = PTHREADENTRY32;
pub const AddrMode1616: c_int = 0;
pub const AddrMode1632: c_int = 1;
pub const AddrModeReal: c_int = 2;
pub const AddrModeFlat: c_int = 3;
pub const ADDRESS_MODE = c_uint;
pub const struct__tagADDRESS64 = extern struct {
    Offset: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Segment: WORD = @import("std").mem.zeroes(WORD),
    Mode: ADDRESS_MODE = @import("std").mem.zeroes(ADDRESS_MODE),
};
pub const ADDRESS64 = struct__tagADDRESS64;
pub const LPADDRESS64 = [*c]struct__tagADDRESS64;
pub const struct__KDHELP64 = extern struct {
    Thread: DWORD64 = @import("std").mem.zeroes(DWORD64),
    ThCallbackStack: DWORD = @import("std").mem.zeroes(DWORD),
    ThCallbackBStore: DWORD = @import("std").mem.zeroes(DWORD),
    NextCallback: DWORD = @import("std").mem.zeroes(DWORD),
    FramePointer: DWORD = @import("std").mem.zeroes(DWORD),
    KiCallUserMode: DWORD64 = @import("std").mem.zeroes(DWORD64),
    KeUserCallbackDispatcher: DWORD64 = @import("std").mem.zeroes(DWORD64),
    SystemRangeStart: DWORD64 = @import("std").mem.zeroes(DWORD64),
    KiUserExceptionDispatcher: DWORD64 = @import("std").mem.zeroes(DWORD64),
    StackBase: DWORD64 = @import("std").mem.zeroes(DWORD64),
    StackLimit: DWORD64 = @import("std").mem.zeroes(DWORD64),
    Reserved: [5]DWORD64 = @import("std").mem.zeroes([5]DWORD64),
};
pub const KDHELP64 = struct__KDHELP64;
pub const PKDHELP64 = [*c]struct__KDHELP64;
pub const struct__tagSTACKFRAME64 = extern struct {
    AddrPC: ADDRESS64 = @import("std").mem.zeroes(ADDRESS64),
    AddrReturn: ADDRESS64 = @import("std").mem.zeroes(ADDRESS64),
    AddrFrame: ADDRESS64 = @import("std").mem.zeroes(ADDRESS64),
    AddrStack: ADDRESS64 = @import("std").mem.zeroes(ADDRESS64),
    AddrBStore: ADDRESS64 = @import("std").mem.zeroes(ADDRESS64),
    FuncTableEntry: PVOID = @import("std").mem.zeroes(PVOID),
    Params: [4]DWORD64 = @import("std").mem.zeroes([4]DWORD64),
    Far: BOOL = @import("std").mem.zeroes(BOOL),
    Virtual: BOOL = @import("std").mem.zeroes(BOOL),
    Reserved: [3]DWORD64 = @import("std").mem.zeroes([3]DWORD64),
    KdHelp: KDHELP64 = @import("std").mem.zeroes(KDHELP64),
};
pub const STACKFRAME64 = struct__tagSTACKFRAME64;
pub const LPSTACKFRAME64 = [*c]struct__tagSTACKFRAME64;
pub const struct__LUID = extern struct {
    LowPart: DWORD = @import("std").mem.zeroes(DWORD),
    HighPart: LONG = @import("std").mem.zeroes(LONG),
};
pub const LUID = struct__LUID;
pub const PLUID = [*c]struct__LUID;
pub const struct__LUID_AND_ATTRIBUTES = extern struct {
    Luid: LUID = @import("std").mem.zeroes(LUID),
    Attributes: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const LUID_AND_ATTRIBUTES = struct__LUID_AND_ATTRIBUTES;
pub const PLUID_AND_ATTRIBUTES = [*c]struct__LUID_AND_ATTRIBUTES;
pub const struct__TOKEN_PRIVILEGES = extern struct {
    PrivilegeCount: DWORD = @import("std").mem.zeroes(DWORD),
    Privileges: [1]LUID_AND_ATTRIBUTES = @import("std").mem.zeroes([1]LUID_AND_ATTRIBUTES),
};
pub const TOKEN_PRIVILEGES = struct__TOKEN_PRIVILEGES;
pub const PTOKEN_PRIVILEGES = [*c]struct__TOKEN_PRIVILEGES;
pub extern fn DebugBreak() callconv(@import("std").os.windows.WINAPI) void;
pub extern fn IsDebuggerPresent() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CheckRemoteDebuggerPresent(hProcess: HANDLE, hbDebuggerPresent: PBOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn OutputDebugStringA(lpOutputString: LPCSTR) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn OutputDebugStringW(lpOutputString: LPCWSTR) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn GetThreadContext(hThread: HANDLE, lpContext: LPCONTEXT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DebugActiveProcess(dwProcessId: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DebugActiveProcessStop(dwProcessId: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymSetOptions(SymOptions: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SymInitialize(hProcess: HANDLE, UserSearchPath: LPCSTR, fInvadeProcess: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymInitializeW(hProcess: HANDLE, UserSearchPath: LPCWSTR, fInvadeProcess: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymFromAddr(hProcess: HANDLE, Address: DWORD64, Displacement: PDWORD64, Symbol: PSYMBOL_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymFromAddrW(hProcess: HANDLE, Address: DWORD64, Displacement: PDWORD64, Symbol: PSYMBOL_INFOW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymFunctionTableAccess64(hProcess: HANDLE, AddrBase: DWORD64) callconv(@import("std").os.windows.WINAPI) PVOID;
pub extern fn SymGetModuleBase64(hProcess: HANDLE, dwAddr: DWORD64) callconv(@import("std").os.windows.WINAPI) DWORD64;
pub const PSYM_ENUMERATESYMBOLS_CALLBACK = ?*const fn (PSYMBOL_INFO, ULONG, PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PSYM_ENUMERATESYMBOLS_CALLBACKW = ?*const fn (PSYMBOL_INFOW, ULONG, PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymSearch(hProcess: HANDLE, BaseOfDll: ULONG64, Index: DWORD, SymTag: DWORD, Mask: LPCSTR, Address: DWORD64, EnumSymbolsCallback: PSYM_ENUMERATESYMBOLS_CALLBACK, UserContext: PVOID, Options: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymSearchW(hProcess: HANDLE, BaseOfDll: ULONG64, Index: DWORD, SymTag: DWORD, Mask: LPCWSTR, Address: DWORD64, EnumSymbolsCallback: PSYM_ENUMERATESYMBOLS_CALLBACKW, UserContext: PVOID, Options: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymRefreshModuleList(hProcess: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PSYM_ENUMMODULES_CALLBACK64 = ?*const fn (LPCSTR, DWORD64, PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PSYM_ENUMMODULES_CALLBACKW64 = ?*const fn (LPCWSTR, DWORD64, PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymEnumerateModules64(hProcess: HANDLE, EnumModulesCallback: PSYM_ENUMMODULES_CALLBACK64, UserContext: PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymEnumerateModulesW64(hProcess: HANDLE, EnumModulesCallback: PSYM_ENUMMODULES_CALLBACKW64, UserContext: PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymSetSearchPath(hProcess: HANDLE, SearchPath: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymSetSearchPathW(hProcess: HANDLE, SearchPath: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymGetSearchPath(hProcess: HANDLE, SearchPath: LPSTR, SearchPathLength: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymGetSearchPathW(hProcess: HANDLE, SearchPath: LPWSTR, SearchPathLength: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymCleanup(hProcess: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymGetLineFromAddr64(hProcess: HANDLE, dwAddr: DWORD64, pdwDisplacement: PDWORD, Line: PIMAGEHLP_LINE64) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SymGetLineFromAddrW64(hProcess: HANDLE, dwAddr: DWORD64, pdwDisplacement: PDWORD, Line: PIMAGEHLP_LINEW64) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetUnhandledExceptionFilter(lpTopLevelExceptionFilter: LPTOP_LEVEL_EXCEPTION_FILTER) callconv(@import("std").os.windows.WINAPI) LPTOP_LEVEL_EXCEPTION_FILTER;
pub extern fn UnhandledExceptionFilter(ExceptionInfo: [*c]struct__EXCEPTION_POINTERS) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn AddVectoredExceptionHandler(FirstHandler: ULONG, VectoredHandler: PVECTORED_EXCEPTION_HANDLER) callconv(@import("std").os.windows.WINAPI) PVOID;
pub extern fn RemoveVectoredExceptionHandler(Handler: PVOID) callconv(@import("std").os.windows.WINAPI) ULONG;
pub extern fn RtlCaptureStackBackTrace(FramesToSkip: ULONG, FramesToCapture: ULONG, BackTrace: [*c]PVOID, BackTraceHash: PULONG) callconv(@import("std").os.windows.WINAPI) USHORT;
pub extern fn RtlCaptureContext(ContextRecord: PCONTEXT) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn RaiseException(dwExceptionCode: DWORD, dwExceptionFlags: DWORD, nNumberOfArguments: DWORD, lpArguments: [*c]const ULONG_PTR) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn CreateToolhelp32Snapshot(dwFlags: DWORD, th32ProcessID: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn Thread32First(hSnapshot: HANDLE, lpte: LPTHREADENTRY32) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn Thread32Next(hSnapshot: HANDLE, lpte: LPTHREADENTRY32) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PREAD_PROCESS_MEMORY_ROUTINE64 = ?*const fn (HANDLE, DWORD64, PVOID, DWORD, LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PFUNCTION_TABLE_ACCESS_ROUTINE64 = ?*const fn (HANDLE, DWORD64) callconv(@import("std").os.windows.WINAPI) PVOID;
pub const PGET_MODULE_BASE_ROUTINE64 = ?*const fn (HANDLE, DWORD64) callconv(@import("std").os.windows.WINAPI) DWORD64;
pub const PTRANSLATE_ADDRESS_ROUTINE64 = ?*const fn (HANDLE, HANDLE, LPADDRESS64) callconv(@import("std").os.windows.WINAPI) DWORD64;
pub extern fn StackWalk64(MachineType: DWORD, hProcess: HANDLE, hThread: HANDLE, StackFrame: LPSTACKFRAME64, ContextRecord: PVOID, ReadMemoryRoutine: PREAD_PROCESS_MEMORY_ROUTINE64, FunctionTableAccessRoutine: PFUNCTION_TABLE_ACCESS_ROUTINE64, GetModuleBaseRoutine: PGET_MODULE_BASE_ROUTINE64, TranslateAddress: PTRANSLATE_ADDRESS_ROUTINE64) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagVS_FIXEDFILEINFO = extern struct {
    dwSignature: DWORD = @import("std").mem.zeroes(DWORD),
    dwStrucVersion: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileVersionMS: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileVersionLS: DWORD = @import("std").mem.zeroes(DWORD),
    dwProductVersionMS: DWORD = @import("std").mem.zeroes(DWORD),
    dwProductVersionLS: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileFlagsMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileOS: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileType: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileSubtype: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileDateMS: DWORD = @import("std").mem.zeroes(DWORD),
    dwFileDateLS: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const VS_FIXEDFILEINFO = struct_tagVS_FIXEDFILEINFO;
pub const MiniDumpNormal: c_int = 0;
pub const MiniDumpWithDataSegs: c_int = 1;
pub const MiniDumpWithFullMemory: c_int = 2;
pub const MiniDumpWithHandleData: c_int = 4;
pub const MiniDumpFilterMemory: c_int = 8;
pub const MiniDumpScanMemory: c_int = 16;
pub const MiniDumpWithUnloadedModules: c_int = 32;
pub const MiniDumpWithIndirectlyReferencedMemory: c_int = 64;
pub const MiniDumpFilterModulePaths: c_int = 128;
pub const MiniDumpWithProcessThreadData: c_int = 256;
pub const MiniDumpWithPrivateReadWriteMemory: c_int = 512;
pub const MiniDumpWithoutOptionalData: c_int = 1024;
pub const MiniDumpWithFullMemoryInfo: c_int = 2048;
pub const MiniDumpWithThreadInfo: c_int = 4096;
pub const MiniDumpWithCodeSegs: c_int = 8192;
pub const MiniDumpWithoutAuxiliaryState: c_int = 16384;
pub const MiniDumpWithFullAuxiliaryState: c_int = 32768;
pub const MiniDumpWithPrivateWriteCopyMemory: c_int = 65536;
pub const MiniDumpIgnoreInaccessibleMemory: c_int = 131072;
pub const MiniDumpWithTokenInformation: c_int = 262144;
pub const MiniDumpValidTypeFlags: c_int = 524287;
pub const enum__MINIDUMP_TYPE = c_uint;
pub const MINIDUMP_TYPE = enum__MINIDUMP_TYPE;
pub const struct__MINIDUMP_EXCEPTION_INFORMATION = extern struct {
    ThreadId: DWORD = @import("std").mem.zeroes(DWORD),
    ExceptionPointers: PEXCEPTION_POINTERS = @import("std").mem.zeroes(PEXCEPTION_POINTERS),
    ClientPointers: BOOL = @import("std").mem.zeroes(BOOL),
};
pub const MINIDUMP_EXCEPTION_INFORMATION = struct__MINIDUMP_EXCEPTION_INFORMATION;
pub const PMINIDUMP_EXCEPTION_INFORMATION = [*c]struct__MINIDUMP_EXCEPTION_INFORMATION;
pub const struct__MINIDUMP_EXCEPTION_INFORMATION64 = extern struct {
    ThreadId: DWORD = @import("std").mem.zeroes(DWORD),
    ExceptionRecord: ULONG64 = @import("std").mem.zeroes(ULONG64),
    ContextRecord: ULONG64 = @import("std").mem.zeroes(ULONG64),
    ClientPointers: BOOL = @import("std").mem.zeroes(BOOL),
};
pub const MINIDUMP_EXCEPTION_INFORMATION64 = struct__MINIDUMP_EXCEPTION_INFORMATION64;
pub const PMINIDUMP_EXCEPTION_INFORMATION64 = [*c]struct__MINIDUMP_EXCEPTION_INFORMATION64;
pub const struct__MINIDUMP_THREAD_CALLBACK = extern struct {
    ThreadId: ULONG = @import("std").mem.zeroes(ULONG),
    ThreadHandle: HANDLE = @import("std").mem.zeroes(HANDLE),
    Context: CONTEXT = @import("std").mem.zeroes(CONTEXT),
    SizeOfContext: ULONG = @import("std").mem.zeroes(ULONG),
    StackBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    StackEnd: ULONG64 = @import("std").mem.zeroes(ULONG64),
};
pub const MINIDUMP_THREAD_CALLBACK = struct__MINIDUMP_THREAD_CALLBACK;
pub const PMINIDUMP_THREAD_CALLBACK = [*c]struct__MINIDUMP_THREAD_CALLBACK;
pub const struct__MINIDUMP_THREAD_EX_CALLBACK = extern struct {
    ThreadId: ULONG = @import("std").mem.zeroes(ULONG),
    ThreadHandle: HANDLE = @import("std").mem.zeroes(HANDLE),
    Context: CONTEXT = @import("std").mem.zeroes(CONTEXT),
    SizeOfContext: ULONG = @import("std").mem.zeroes(ULONG),
    StackBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    StackEnd: ULONG64 = @import("std").mem.zeroes(ULONG64),
    BackingStoreBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    BackingStoreEnd: ULONG64 = @import("std").mem.zeroes(ULONG64),
};
pub const MINIDUMP_THREAD_EX_CALLBACK = struct__MINIDUMP_THREAD_EX_CALLBACK;
pub const PMINIDUMP_THREAD_EX_CALLBACK = [*c]struct__MINIDUMP_THREAD_EX_CALLBACK;
pub const struct__MINIDUMP_MODULE_CALLBACK = extern struct {
    FullPath: PWCHAR = @import("std").mem.zeroes(PWCHAR),
    BaseOfImage: ULONG64 = @import("std").mem.zeroes(ULONG64),
    SizeOfImage: ULONG = @import("std").mem.zeroes(ULONG),
    CheckSum: ULONG = @import("std").mem.zeroes(ULONG),
    TimeDateStamp: ULONG = @import("std").mem.zeroes(ULONG),
    VersionInfo: VS_FIXEDFILEINFO = @import("std").mem.zeroes(VS_FIXEDFILEINFO),
    CvRecord: PVOID = @import("std").mem.zeroes(PVOID),
    SizeOfCvRecord: ULONG = @import("std").mem.zeroes(ULONG),
    MiscRecord: PVOID = @import("std").mem.zeroes(PVOID),
    SizeOfMiscRecord: ULONG = @import("std").mem.zeroes(ULONG),
};
pub const MINIDUMP_MODULE_CALLBACK = struct__MINIDUMP_MODULE_CALLBACK;
pub const PMINIDUMP_MODULE_CALLBACK = [*c]struct__MINIDUMP_MODULE_CALLBACK;
pub const struct__MINIDUMP_INCLUDE_THREAD_CALLBACK = extern struct {
    ThreadId: ULONG = @import("std").mem.zeroes(ULONG),
};
pub const MINIDUMP_INCLUDE_THREAD_CALLBACK = struct__MINIDUMP_INCLUDE_THREAD_CALLBACK;
pub const PMINIDUMP_INCLUDE_THREAD_CALLBACK = [*c]struct__MINIDUMP_INCLUDE_THREAD_CALLBACK;
pub const struct__MINIDUMP_INCLUDE_MODULE_CALLBACK = extern struct {
    BaseOfImage: ULONG64 = @import("std").mem.zeroes(ULONG64),
};
pub const MINIDUMP_INCLUDE_MODULE_CALLBACK = struct__MINIDUMP_INCLUDE_MODULE_CALLBACK;
pub const PMINIDUMP_INCLUDE_MODULE_CALLBACK = [*c]struct__MINIDUMP_INCLUDE_MODULE_CALLBACK;
pub const struct__MINIDUMP_IO_CALLBACK = extern struct {
    Handle: HANDLE = @import("std").mem.zeroes(HANDLE),
    Offset: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Buffer: PVOID = @import("std").mem.zeroes(PVOID),
    BufferBytes: ULONG = @import("std").mem.zeroes(ULONG),
};
pub const MINIDUMP_IO_CALLBACK = struct__MINIDUMP_IO_CALLBACK;
pub const PMINIDUMP_IO_CALLBACK = [*c]struct__MINIDUMP_IO_CALLBACK;
pub const struct__MINIDUMP_READ_MEMORY_FAILURE_CALLBACK = extern struct {
    Offset: ULONG64 = @import("std").mem.zeroes(ULONG64),
    Bytes: ULONG = @import("std").mem.zeroes(ULONG),
    FailureStatus: HRESULT = @import("std").mem.zeroes(HRESULT),
};
pub const MINIDUMP_READ_MEMORY_FAILURE_CALLBACK = struct__MINIDUMP_READ_MEMORY_FAILURE_CALLBACK;
pub const PMINIDUMP_READ_MEMORY_FAILURE_CALLBACK = [*c]struct__MINIDUMP_READ_MEMORY_FAILURE_CALLBACK;
const union_unnamed_8 = extern union {
    Status: HRESULT,
    Thread: MINIDUMP_THREAD_CALLBACK,
    ThreadEx: MINIDUMP_THREAD_EX_CALLBACK,
    Module: MINIDUMP_MODULE_CALLBACK,
    IncludeThread: MINIDUMP_INCLUDE_THREAD_CALLBACK,
    IncludeModule: MINIDUMP_INCLUDE_MODULE_CALLBACK,
    Io: MINIDUMP_IO_CALLBACK,
    ReadMemoryFailure: MINIDUMP_READ_MEMORY_FAILURE_CALLBACK,
    SecondaryFlags: ULONG,
};
pub const struct__MINIDUMP_CALLBACK_INPUT = extern struct {
    ProcessId: ULONG = @import("std").mem.zeroes(ULONG),
    ProcessHandle: HANDLE = @import("std").mem.zeroes(HANDLE),
    CallbackType: ULONG = @import("std").mem.zeroes(ULONG),
    unnamed_0: union_unnamed_8 = @import("std").mem.zeroes(union_unnamed_8),
};
pub const MINIDUMP_CALLBACK_INPUT = struct__MINIDUMP_CALLBACK_INPUT;
pub const PMINIDUMP_CALLBACK_INPUT = [*c]struct__MINIDUMP_CALLBACK_INPUT;
pub const struct__MINIDUMP_MEMORY_INFO = extern struct {
    BaseAddress: ULONG64 = @import("std").mem.zeroes(ULONG64),
    AllocationBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    AllocationProtect: ULONG32 = @import("std").mem.zeroes(ULONG32),
    __alignment1: ULONG32 = @import("std").mem.zeroes(ULONG32),
    RegionSize: ULONG64 = @import("std").mem.zeroes(ULONG64),
    State: ULONG32 = @import("std").mem.zeroes(ULONG32),
    Protect: ULONG32 = @import("std").mem.zeroes(ULONG32),
    Type: ULONG32 = @import("std").mem.zeroes(ULONG32),
    __alignment2: ULONG32 = @import("std").mem.zeroes(ULONG32),
};
pub const MINIDUMP_MEMORY_INFO = struct__MINIDUMP_MEMORY_INFO;
pub const PMINIDUMP_MEMORY_INFO = [*c]struct__MINIDUMP_MEMORY_INFO;
const struct_unnamed_10 = extern struct {
    MemoryBase: ULONG64 = @import("std").mem.zeroes(ULONG64),
    MemorySize: ULONG = @import("std").mem.zeroes(ULONG),
};
const struct_unnamed_11 = extern struct {
    CheckCancel: BOOL = @import("std").mem.zeroes(BOOL),
    Cancel: BOOL = @import("std").mem.zeroes(BOOL),
};
const struct_unnamed_12 = extern struct {
    VmRegion: MINIDUMP_MEMORY_INFO = @import("std").mem.zeroes(MINIDUMP_MEMORY_INFO),
    Continue: BOOL = @import("std").mem.zeroes(BOOL),
};
const union_unnamed_9 = extern union {
    ModuleWriteFlags: ULONG,
    ThreadWriteFlags: ULONG,
    SecondaryFlags: ULONG,
    unnamed_0: struct_unnamed_10,
    unnamed_1: struct_unnamed_11,
    Handle: HANDLE,
    unnamed_2: struct_unnamed_12,
    Status: HRESULT,
};
pub const struct__MINIDUMP_CALLBACK_OUTPUT = extern struct {
    unnamed_0: union_unnamed_9 = @import("std").mem.zeroes(union_unnamed_9),
};
pub const MINIDUMP_CALLBACK_OUTPUT = struct__MINIDUMP_CALLBACK_OUTPUT;
pub const PMINIDUMP_CALLBACK_OUTPUT = [*c]struct__MINIDUMP_CALLBACK_OUTPUT;
pub const MINIDUMP_CALLBACK_ROUTINE = ?*const fn (PVOID, PMINIDUMP_CALLBACK_INPUT, PMINIDUMP_CALLBACK_OUTPUT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct__MINIDUMP_CALLBACK_INFORMATION = extern struct {
    CallbackRoutine: MINIDUMP_CALLBACK_ROUTINE = @import("std").mem.zeroes(MINIDUMP_CALLBACK_ROUTINE),
    CallbackParam: PVOID = @import("std").mem.zeroes(PVOID),
};
pub const MINIDUMP_CALLBACK_INFORMATION = struct__MINIDUMP_CALLBACK_INFORMATION;
pub const PMINIDUMP_CALLBACK_INFORMATION = [*c]struct__MINIDUMP_CALLBACK_INFORMATION;
pub const struct__MINIDUMP_USER_STREAM = extern struct {
    Type: ULONG32 = @import("std").mem.zeroes(ULONG32),
    BufferSize: ULONG = @import("std").mem.zeroes(ULONG),
    Buffer: PVOID = @import("std").mem.zeroes(PVOID),
};
pub const MINIDUMP_USER_STREAM = struct__MINIDUMP_USER_STREAM;
pub const PMINIDUMP_USER_STREAM = [*c]struct__MINIDUMP_USER_STREAM;
pub const struct__MINIDUMP_USER_STREAM_INFORMATION = extern struct {
    UserStreamCount: ULONG = @import("std").mem.zeroes(ULONG),
    UserStreamArray: PMINIDUMP_USER_STREAM = @import("std").mem.zeroes(PMINIDUMP_USER_STREAM),
};
pub const MINIDUMP_USER_STREAM_INFORMATION = struct__MINIDUMP_USER_STREAM_INFORMATION;
pub const PMINIDUMP_USER_STREAM_INFORMATION = [*c]struct__MINIDUMP_USER_STREAM_INFORMATION;
pub extern fn MiniDumpWriteDump(hProcess: HANDLE, ProcessId: DWORD, hFile: HANDLE, DumpType: MINIDUMP_TYPE, ExceptionParam: PMINIDUMP_EXCEPTION_INFORMATION, UserStreamParam: PMINIDUMP_USER_STREAM_INFORMATION, CallbackParam: PMINIDUMP_CALLBACK_INFORMATION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn OpenProcessToken(ProcessHandle: HANDLE, DesiredAccess: DWORD, TokenHandle: PHANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LookupPrivilegeValueA(lpSystemName: LPCSTR, lpName: LPCSTR, lpLuid: PLUID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LookupPrivilegeValueW(lpSystemName: LPCWSTR, lpName: LPCWSTR, lpLuid: PLUID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AdjustTokenPrivileges(TokenHandle: HANDLE, DisableAllPrivileges: BOOL, NewState: PTOKEN_PRIVILEGES, BufferLength: DWORD, PreviousState: PTOKEN_PRIVILEGES, ReturnLength: PDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const DXGI_FORMAT_UNKNOWN: c_int = 0;
pub const DXGI_FORMAT_R32G32B32A32_TYPELESS: c_int = 1;
pub const DXGI_FORMAT_R32G32B32A32_FLOAT: c_int = 2;
pub const DXGI_FORMAT_R32G32B32A32_UINT: c_int = 3;
pub const DXGI_FORMAT_R32G32B32A32_SINT: c_int = 4;
pub const DXGI_FORMAT_R32G32B32_TYPELESS: c_int = 5;
pub const DXGI_FORMAT_R32G32B32_FLOAT: c_int = 6;
pub const DXGI_FORMAT_R32G32B32_UINT: c_int = 7;
pub const DXGI_FORMAT_R32G32B32_SINT: c_int = 8;
pub const DXGI_FORMAT_R16G16B16A16_TYPELESS: c_int = 9;
pub const DXGI_FORMAT_R16G16B16A16_FLOAT: c_int = 10;
pub const DXGI_FORMAT_R16G16B16A16_UNORM: c_int = 11;
pub const DXGI_FORMAT_R16G16B16A16_UINT: c_int = 12;
pub const DXGI_FORMAT_R16G16B16A16_SNORM: c_int = 13;
pub const DXGI_FORMAT_R16G16B16A16_SINT: c_int = 14;
pub const DXGI_FORMAT_R32G32_TYPELESS: c_int = 15;
pub const DXGI_FORMAT_R32G32_FLOAT: c_int = 16;
pub const DXGI_FORMAT_R32G32_UINT: c_int = 17;
pub const DXGI_FORMAT_R32G32_SINT: c_int = 18;
pub const DXGI_FORMAT_R32G8X24_TYPELESS: c_int = 19;
pub const DXGI_FORMAT_D32_FLOAT_S8X24_UINT: c_int = 20;
pub const DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS: c_int = 21;
pub const DXGI_FORMAT_X32_TYPELESS_G8X24_UINT: c_int = 22;
pub const DXGI_FORMAT_R10G10B10A2_TYPELESS: c_int = 23;
pub const DXGI_FORMAT_R10G10B10A2_UNORM: c_int = 24;
pub const DXGI_FORMAT_R10G10B10A2_UINT: c_int = 25;
pub const DXGI_FORMAT_R11G11B10_FLOAT: c_int = 26;
pub const DXGI_FORMAT_R8G8B8A8_TYPELESS: c_int = 27;
pub const DXGI_FORMAT_R8G8B8A8_UNORM: c_int = 28;
pub const DXGI_FORMAT_R8G8B8A8_UNORM_SRGB: c_int = 29;
pub const DXGI_FORMAT_R8G8B8A8_UINT: c_int = 30;
pub const DXGI_FORMAT_R8G8B8A8_SNORM: c_int = 31;
pub const DXGI_FORMAT_R8G8B8A8_SINT: c_int = 32;
pub const DXGI_FORMAT_R16G16_TYPELESS: c_int = 33;
pub const DXGI_FORMAT_R16G16_FLOAT: c_int = 34;
pub const DXGI_FORMAT_R16G16_UNORM: c_int = 35;
pub const DXGI_FORMAT_R16G16_UINT: c_int = 36;
pub const DXGI_FORMAT_R16G16_SNORM: c_int = 37;
pub const DXGI_FORMAT_R16G16_SINT: c_int = 38;
pub const DXGI_FORMAT_R32_TYPELESS: c_int = 39;
pub const DXGI_FORMAT_D32_FLOAT: c_int = 40;
pub const DXGI_FORMAT_R32_FLOAT: c_int = 41;
pub const DXGI_FORMAT_R32_UINT: c_int = 42;
pub const DXGI_FORMAT_R32_SINT: c_int = 43;
pub const DXGI_FORMAT_R24G8_TYPELESS: c_int = 44;
pub const DXGI_FORMAT_D24_UNORM_S8_UINT: c_int = 45;
pub const DXGI_FORMAT_R24_UNORM_X8_TYPELESS: c_int = 46;
pub const DXGI_FORMAT_X24_TYPELESS_G8_UINT: c_int = 47;
pub const DXGI_FORMAT_R8G8_TYPELESS: c_int = 48;
pub const DXGI_FORMAT_R8G8_UNORM: c_int = 49;
pub const DXGI_FORMAT_R8G8_UINT: c_int = 50;
pub const DXGI_FORMAT_R8G8_SNORM: c_int = 51;
pub const DXGI_FORMAT_R8G8_SINT: c_int = 52;
pub const DXGI_FORMAT_R16_TYPELESS: c_int = 53;
pub const DXGI_FORMAT_R16_FLOAT: c_int = 54;
pub const DXGI_FORMAT_D16_UNORM: c_int = 55;
pub const DXGI_FORMAT_R16_UNORM: c_int = 56;
pub const DXGI_FORMAT_R16_UINT: c_int = 57;
pub const DXGI_FORMAT_R16_SNORM: c_int = 58;
pub const DXGI_FORMAT_R16_SINT: c_int = 59;
pub const DXGI_FORMAT_R8_TYPELESS: c_int = 60;
pub const DXGI_FORMAT_R8_UNORM: c_int = 61;
pub const DXGI_FORMAT_R8_UINT: c_int = 62;
pub const DXGI_FORMAT_R8_SNORM: c_int = 63;
pub const DXGI_FORMAT_R8_SINT: c_int = 64;
pub const DXGI_FORMAT_A8_UNORM: c_int = 65;
pub const DXGI_FORMAT_R1_UNORM: c_int = 66;
pub const DXGI_FORMAT_R9G9B9E5_SHAREDEXP: c_int = 67;
pub const DXGI_FORMAT_R8G8_B8G8_UNORM: c_int = 68;
pub const DXGI_FORMAT_G8R8_G8B8_UNORM: c_int = 69;
pub const DXGI_FORMAT_BC1_TYPELESS: c_int = 70;
pub const DXGI_FORMAT_BC1_UNORM: c_int = 71;
pub const DXGI_FORMAT_BC1_UNORM_SRGB: c_int = 72;
pub const DXGI_FORMAT_BC2_TYPELESS: c_int = 73;
pub const DXGI_FORMAT_BC2_UNORM: c_int = 74;
pub const DXGI_FORMAT_BC2_UNORM_SRGB: c_int = 75;
pub const DXGI_FORMAT_BC3_TYPELESS: c_int = 76;
pub const DXGI_FORMAT_BC3_UNORM: c_int = 77;
pub const DXGI_FORMAT_BC3_UNORM_SRGB: c_int = 78;
pub const DXGI_FORMAT_BC4_TYPELESS: c_int = 79;
pub const DXGI_FORMAT_BC4_UNORM: c_int = 80;
pub const DXGI_FORMAT_BC4_SNORM: c_int = 81;
pub const DXGI_FORMAT_BC5_TYPELESS: c_int = 82;
pub const DXGI_FORMAT_BC5_UNORM: c_int = 83;
pub const DXGI_FORMAT_BC5_SNORM: c_int = 84;
pub const DXGI_FORMAT_B5G6R5_UNORM: c_int = 85;
pub const DXGI_FORMAT_B5G5R5A1_UNORM: c_int = 86;
pub const DXGI_FORMAT_B8G8R8A8_UNORM: c_int = 87;
pub const DXGI_FORMAT_B8G8R8X8_UNORM: c_int = 88;
pub const DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM: c_int = 89;
pub const DXGI_FORMAT_B8G8R8A8_TYPELESS: c_int = 90;
pub const DXGI_FORMAT_B8G8R8A8_UNORM_SRGB: c_int = 91;
pub const DXGI_FORMAT_B8G8R8X8_TYPELESS: c_int = 92;
pub const DXGI_FORMAT_B8G8R8X8_UNORM_SRGB: c_int = 93;
pub const DXGI_FORMAT_BC6H_TYPELESS: c_int = 94;
pub const DXGI_FORMAT_BC6H_UF16: c_int = 95;
pub const DXGI_FORMAT_BC6H_SF16: c_int = 96;
pub const DXGI_FORMAT_BC7_TYPELESS: c_int = 97;
pub const DXGI_FORMAT_BC7_UNORM: c_int = 98;
pub const DXGI_FORMAT_BC7_UNORM_SRGB: c_int = 99;
pub const DXGI_FORMAT_FORCE_UINT: c_uint = 4294967295;
pub const enum_DXGI_FORMAT = c_uint;
pub const DXGI_FORMAT = enum_DXGI_FORMAT;
pub const DDS_PIXELFORMAT = extern struct {
    dwSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwFourCC: DWORD = @import("std").mem.zeroes(DWORD),
    dwRGBBitCount: DWORD = @import("std").mem.zeroes(DWORD),
    dwRBitMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwGBitMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwBBitMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwABitMask: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const DDS_HEADER = extern struct {
    dwSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwHeaderFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwHeight: DWORD = @import("std").mem.zeroes(DWORD),
    dwWidth: DWORD = @import("std").mem.zeroes(DWORD),
    dwPitchOrLinearSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwDepth: DWORD = @import("std").mem.zeroes(DWORD),
    dwMipMapCount: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved1: [11]DWORD = @import("std").mem.zeroes([11]DWORD),
    ddspf: DDS_PIXELFORMAT = @import("std").mem.zeroes(DDS_PIXELFORMAT),
    dwSurfaceFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwCubemapFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved2: [3]DWORD = @import("std").mem.zeroes([3]DWORD),
};
pub const DDS_HEADER_DXT10 = extern struct {
    dxgiFormat: DXGI_FORMAT = @import("std").mem.zeroes(DXGI_FORMAT),
    resourceDimension: UINT = @import("std").mem.zeroes(UINT),
    miscFlag: UINT = @import("std").mem.zeroes(UINT),
    arraySize: UINT = @import("std").mem.zeroes(UINT),
    reserved: UINT = @import("std").mem.zeroes(UINT),
};
pub const SECURITY_INFORMATION = DWORD;
pub const PSECURITY_INFORMATION = [*c]DWORD;
pub const PSECURITY_DESCRIPTOR = HANDLE;
const struct_unnamed_14 = extern struct {
    Offset: DWORD = @import("std").mem.zeroes(DWORD),
    OffsetHigh: DWORD = @import("std").mem.zeroes(DWORD),
};
const union_unnamed_13 = extern union {
    unnamed_0: struct_unnamed_14,
    Pointer: PVOID,
};
pub const struct__OVERLAPPED = extern struct {
    Internal: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    InternalHigh: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    unnamed_0: union_unnamed_13 = @import("std").mem.zeroes(union_unnamed_13),
    hEvent: HANDLE = @import("std").mem.zeroes(HANDLE),
};
pub const OVERLAPPED = struct__OVERLAPPED;
pub const LPOVERLAPPED = [*c]struct__OVERLAPPED;
pub const struct__WIN32_FIND_DATAA = extern struct {
    dwFileAttributes: DWORD = @import("std").mem.zeroes(DWORD),
    ftCreationTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastAccessTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastWriteTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    nFileSizeHigh: DWORD = @import("std").mem.zeroes(DWORD),
    nFileSizeLow: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved0: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved1: DWORD = @import("std").mem.zeroes(DWORD),
    cFileName: [260]CHAR = @import("std").mem.zeroes([260]CHAR),
    cAlternateFileName: [14]CHAR = @import("std").mem.zeroes([14]CHAR),
};
pub const WIN32_FIND_DATAA = struct__WIN32_FIND_DATAA;
pub const PWIN32_FIND_DATAA = [*c]struct__WIN32_FIND_DATAA;
pub const LPWIN32_FIND_DATAA = [*c]struct__WIN32_FIND_DATAA;
pub const struct__WIN32_FIND_DATAW = extern struct {
    dwFileAttributes: DWORD = @import("std").mem.zeroes(DWORD),
    ftCreationTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastAccessTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastWriteTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    nFileSizeHigh: DWORD = @import("std").mem.zeroes(DWORD),
    nFileSizeLow: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved0: DWORD = @import("std").mem.zeroes(DWORD),
    dwReserved1: DWORD = @import("std").mem.zeroes(DWORD),
    cFileName: [260]WCHAR = @import("std").mem.zeroes([260]WCHAR),
    cAlternateFileName: [14]WCHAR = @import("std").mem.zeroes([14]WCHAR),
};
pub const WIN32_FIND_DATAW = struct__WIN32_FIND_DATAW;
pub const PWIN32_FIND_DATAW = [*c]struct__WIN32_FIND_DATAW;
pub const LPWIN32_FIND_DATAW = [*c]struct__WIN32_FIND_DATAW;
pub extern fn CreateFileA(lpFileName: LPCSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateFileW(lpFileName: LPCWSTR, dwDesiredAccess: DWORD, dwShareMode: DWORD, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, dwCreationDisposition: DWORD, dwFlagsAndAttributes: DWORD, hTemplateFile: HANDLE) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn WriteFile(hFile: HANDLE, lpBuffer: LPCVOID, nNumberOfBytesToWrite: DWORD, lpNumberOfBytesWritten: LPDWORD, lpOverlapped: LPOVERLAPPED) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ReadFile(hFile: HANDLE, lpBuffer: LPVOID, nNumberOfBytesToRead: DWORD, lpNumberOfBytesRead: LPDWORD, lpOverlapped: LPOVERLAPPED) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetFilePointer(hFile: HANDLE, lDistanceToMove: LONG, lpDistanceToMoveHigh: PLONG, dwMoveMethod: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetFilePointerEx(hFile: HANDLE, liDistanceToMove: LARGE_INTEGER, lpNewFilePointer: PLARGE_INTEGER, dwMoveMethod: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlushFileBuffers(hFile: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetModuleFileNameA(hModule: HMODULE, lpFileName: LPSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetModuleFileNameW(hModule: HMODULE, lpFileName: LPWSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetModuleFileNameExA(hProcess: HANDLE, hModule: HMODULE, lpFileName: LPSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetModuleFileNameExW(hProcess: HANDLE, hModule: HMODULE, lpFileName: LPWSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn OpenFileMappingA(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn OpenFileMappingW(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn MapViewOfFile(hFileMappingObject: HANDLE, dwDesiredAccess: DWORD, dwFileOffsetHigh: DWORD, dwFileOffsetLow: DWORD, dwNumberOfBytesToMap: SIZE_T) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn MapViewOfFileEx(hFileMappingObject: HANDLE, dwDesiredAccess: DWORD, dwFileOffsetHigh: DWORD, dwFileOffsetLow: DWORD, dwNumberOfBytesToMap: SIZE_T, lpBaseAddress: LPVOID) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn CreateFileMappingA(hFile: HANDLE, lpAttributes: LPSECURITY_ATTRIBUTES, flProtect: DWORD, dwMaximumSizeHigh: DWORD, dwMaximumSizeLow: DWORD, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateFileMappingW(hFile: HANDLE, lpAttributes: LPSECURITY_ATTRIBUTES, flProtect: DWORD, dwMaximumSizeHigh: DWORD, dwMaximumSizeLow: DWORD, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn UnmapViewOfFile(lpBaseAddress: LPCVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileAttributesA(lpFileName: LPCSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetFileAttributesW(lpFileName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const GetFileExInfoStandard: c_int = 0;
pub const GetFileExMaxInfoLevel: c_int = 1;
pub const enum__GET_FILEEX_INFO_LEVELS = c_uint;
pub const GET_FILEEX_INFO_LEVELS = enum__GET_FILEEX_INFO_LEVELS;
pub const struct__WIN32_FILE_ATTRIBUTE_DATA = extern struct {
    dwFileAttributes: DWORD = @import("std").mem.zeroes(DWORD),
    ftCreationTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastAccessTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    ftLastWriteTime: FILETIME = @import("std").mem.zeroes(FILETIME),
    nFileSizeHigh: DWORD = @import("std").mem.zeroes(DWORD),
    nFileSizeLow: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const WIN32_FILE_ATTRIBUTE_DATA = struct__WIN32_FILE_ATTRIBUTE_DATA;
pub const LPWIN32_FILE_ATTRIBUTE_DATA = [*c]struct__WIN32_FILE_ATTRIBUTE_DATA;
pub extern fn GetFileAttributesExA(lpFileName: LPCSTR, fInfoLevelId: GET_FILEEX_INFO_LEVELS, lpFileInformation: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileAttributesExW(lpFileName: LPCWSTR, fInfoLevelId: GET_FILEEX_INFO_LEVELS, lpFileInformation: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileTime(hFile: HANDLE, lpCreationTime: LPFILETIME, lpLastAccessTime: LPFILETIME, lpLastWriteTime: LPFILETIME) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetEndOfFile(hFile: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateDirectoryA(lpPathName: LPCSTR, lpSecurityAttributes: LPSECURITY_ATTRIBUTES) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateDirectoryW(lpPathName: LPCWSTR, lpSecurityAttributes: LPSECURITY_ATTRIBUTES) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CopyFileA(lpExistingFileName: LPCSTR, lpNewFileName: LPCSTR, bFailIfExists: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CopyFileW(lpExistingFileName: LPCWSTR, lpNewFileName: LPCWSTR, bFailIfExists: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DeleteFileA(lpFileName: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DeleteFileW(lpFileName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MoveFileA(lpExistingFileName: LPCSTR, lpNewFileName: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MoveFileW(lpExistingFileName: LPCWSTR, lpNewFileName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MoveFileExA(lpExistingFileName: LPCSTR, lpNewFileName: LPCSTR, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MoveFileExW(lpExistingFileName: LPCWSTR, lpNewFileName: LPCWSTR, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RemoveDirectoryA(lpPathName: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RemoveDirectoryW(lpPathName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileSizeEx(hFile: HANDLE, lpFileSize: PLARGE_INTEGER) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlushViewOfFile(lpBaseAddress: LPCVOID, dwNumberOfBytesToFlush: SIZE_T) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindFirstFileA(lpFileName: LPCSTR, lpFindFileData: LPWIN32_FIND_DATAA) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn FindFirstFileW(lpFileName: LPCWSTR, lpFindFileData: LPWIN32_FIND_DATAW) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn FindNextFileA(hFindFile: HANDLE, lpFindFileData: LPWIN32_FIND_DATAA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindNextFileW(hFindFile: HANDLE, lpFindFileData: LPWIN32_FIND_DATAW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindClose(hFindFile: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindFirstChangeNotificationA(lpPathName: LPCSTR, bWatchSubtree: BOOL, dwNotifyFilter: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn FindFirstChangeNotificationW(lpPathName: LPCWSTR, bWatchSubtree: BOOL, dwNotifyFilter: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn FindNextChangeNotification(hChangeHandle: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindCloseChangeNotification(hChangeHandle: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileType(hFile: HANDLE) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetTempFileNameW(lpPathName: LPCWSTR, lpPrefixString: LPCWSTR, uUnique: UINT, lpTempFileName: LPWSTR) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn GetTempPathW(nBufferLength: DWORD, lpBuffer: LPWSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetFileSecurityA(lpFileName: LPCSTR, RequestedInformation: SECURITY_INFORMATION, pSecurityDescriptor: PSECURITY_DESCRIPTOR, nLength: DWORD, lpnLengthNeeded: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFileSecurityW(lpFileName: LPCWSTR, RequestedInformation: SECURITY_INFORMATION, pSecurityDescriptor: PSECURITY_DESCRIPTOR, nLength: DWORD, lpnLengthNeeded: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LoadCursorA(hInstance: HINSTANCE, lpCursorName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HCURSOR;
pub extern fn LoadCursorW(hInstance: HINSTANCE, lpCursorName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HCURSOR;
pub extern fn LoadIconA(hInstance: HINSTANCE, lpIconName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HICON;
pub extern fn LoadIconW(hInstance: HINSTANCE, lpIconName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HICON;
pub extern fn GetStockObject(fnObject: c_int) callconv(@import("std").os.windows.WINAPI) HGDIOBJ;
pub extern fn SetCursor(hCursor: HCURSOR) callconv(@import("std").os.windows.WINAPI) HCURSOR;
pub const HeapCompatibilityInformation: c_int = 0;
pub const HeapEneableTerminationOnCorruption: c_int = 1;
pub const HeapOptimizeResources: c_int = 3;
pub const enum__HEAP_INFORMATION_CLASS = c_uint;
pub const HEAP_INFORMATION_CLASS = enum__HEAP_INFORMATION_CLASS;
pub const struct__COORD = extern struct {
    X: SHORT = @import("std").mem.zeroes(SHORT),
    Y: SHORT = @import("std").mem.zeroes(SHORT),
};
pub const COORD = struct__COORD;
pub const PCOORD = [*c]struct__COORD;
pub const struct__SMALL_RECT = extern struct {
    Left: SHORT = @import("std").mem.zeroes(SHORT),
    Top: SHORT = @import("std").mem.zeroes(SHORT),
    Right: SHORT = @import("std").mem.zeroes(SHORT),
    Bottom: SHORT = @import("std").mem.zeroes(SHORT),
};
pub const SMALL_RECT = struct__SMALL_RECT;
pub const struct__CONSOLE_SCREEN_BUFFER_INFO = extern struct {
    dwSize: COORD = @import("std").mem.zeroes(COORD),
    dwCursorPosition: COORD = @import("std").mem.zeroes(COORD),
    wAttributes: WORD = @import("std").mem.zeroes(WORD),
    srWindow: SMALL_RECT = @import("std").mem.zeroes(SMALL_RECT),
    dwMaximumWindowSize: COORD = @import("std").mem.zeroes(COORD),
};
pub const CONSOLE_SCREEN_BUFFER_INFO = struct__CONSOLE_SCREEN_BUFFER_INFO;
pub const PCONSOLE_SCREEN_BUFFER_INFO = [*c]struct__CONSOLE_SCREEN_BUFFER_INFO;
pub const PHANDLER_ROUTINE = ?*const fn (DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct__MEMORY_BASIC_INFORMATION32 = extern struct {
    BaseAddress: DWORD = @import("std").mem.zeroes(DWORD),
    AllocationBase: DWORD = @import("std").mem.zeroes(DWORD),
    AllocationProtect: DWORD = @import("std").mem.zeroes(DWORD),
    RegionSize: DWORD = @import("std").mem.zeroes(DWORD),
    State: DWORD = @import("std").mem.zeroes(DWORD),
    Protect: DWORD = @import("std").mem.zeroes(DWORD),
    Type: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const MEMORY_BASIC_INFORMATION32 = struct__MEMORY_BASIC_INFORMATION32;
pub const PMEMORY_BASIC_INFORMATION32 = [*c]struct__MEMORY_BASIC_INFORMATION32;
pub const struct__MEMORY_BASIC_INFORMATION64 = extern struct {
    BaseAddress: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    AllocationBase: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    AllocationProtect: DWORD = @import("std").mem.zeroes(DWORD),
    __alignment1: DWORD = @import("std").mem.zeroes(DWORD),
    RegionSize: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    State: DWORD = @import("std").mem.zeroes(DWORD),
    Protect: DWORD = @import("std").mem.zeroes(DWORD),
    Type: DWORD = @import("std").mem.zeroes(DWORD),
    __alignment2: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const MEMORY_BASIC_INFORMATION64 = struct__MEMORY_BASIC_INFORMATION64;
pub const PMEMORY_BASIC_INFORMATION64 = [*c]struct__MEMORY_BASIC_INFORMATION64;
pub const MEMORY_BASIC_INFORMATION = MEMORY_BASIC_INFORMATION64;
pub const PMEMORY_BASIC_INFORMATION = PMEMORY_BASIC_INFORMATION64;
pub extern fn GetStdHandle(nStdHandle: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetConsoleScreenBufferInfo(hConsoleOutput: HANDLE, lpConsoleScreenBufferInfo: PCONSOLE_SCREEN_BUFFER_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetConsoleTextAttribute(hConsoleOutput: HANDLE, wAttributes: WORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CloseHandle(hObject: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetHandleInformation(hObject: HANDLE, dwMask: DWORD, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DuplicateHandle(hSourceProcessHandle: HANDLE, hSourceHandle: HANDLE, hTargetProcessHandle: HANDLE, lpTargetHandle: LPHANDLE, dwDesiredAccess: DWORD, bInheritHandle: BOOL, dwOptions: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCommandLineA() callconv(@import("std").os.windows.WINAPI) LPSTR;
pub extern fn GetCommandLineW() callconv(@import("std").os.windows.WINAPI) LPWSTR;
pub extern fn AllocConsole() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FreeConsole() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AttachConsole(dwProcessId: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WriteConsoleA(hConsoleOutput: HANDLE, lpBuffer: ?*const anyopaque, nNumberOfCharsToWrite: DWORD, lpNumberOfCHarsWritten: LPDWORD, lpReserved: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WriteConsoleW(hConsoleOutput: HANDLE, lpBuffer: ?*const anyopaque, nNumberOfCharsToWrite: DWORD, lpNumberOfCHarsWritten: LPDWORD, lpReserved: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetConsoleCtrlHandler(HandlerRoutine: PHANDLER_ROUTINE, Add: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetConsoleWindow() callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn SetConsoleOutputCP(wCodePageID: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetConsoleOutputCP() callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn GetProcessHeap() callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn HeapAlloc(hHeap: HANDLE, dwFlags: DWORD, dwBytes: SIZE_T) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn HeapReAlloc(hHeap: HANDLE, dwFlags: DWORD, lpMem: LPVOID, dwBytes: SIZE_T) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn HeapFree(hHeap: HANDLE, dwFlags: DWORD, lpMem: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn HeapsetInformation(HeapHandle: HANDLE, HeapInformationClass: HEAP_INFORMATION_CLASS, HeapInformation: PVOID, HeapInformationLength: SIZE_T) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn VirtualAlloc(lpAddress: LPVOID, dwSize: SIZE_T, flAllocationType: DWORD, flProtect: DWORD) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn VirtualQuery(lpAddress: LPCVOID, lpBuffer: PMEMORY_BASIC_INFORMATION, dwLength: SIZE_T) callconv(@import("std").os.windows.WINAPI) SIZE_T;
pub extern fn VirtualFree(lpAddress: LPVOID, dwSize: SIZE_T, dwFreeType: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn VirtualProtect(lpAddress: LPVOID, dwSize: SIZE_T, flNewProtect: DWORD, lpflOldProtect: PDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlushInstructionCache(hProcess: HANDLE, lpBaseAddress: LPCVOID, dwSize: SIZE_T) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreatePipe(hReadPipe: PHANDLE, hWritePipe: PHANDLE, lpPipeAttributes: LPSECURITY_ATTRIBUTES, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PeekNamedPipe(hNamedPipe: HANDLE, lpBuffer: LPVOID, nBufferSize: DWORD, lpBytesRead: LPDWORD, lpTotalBytesAvail: LPDWORD, lpBytesLeftThisMessage: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetFullPathNameA(lpFileName: LPCSTR, nBufferLength: DWORD, lpBuffer: LPSTR, lpFilePart: [*c]LPSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetFullPathNameW(lpFileName: LPCWSTR, nBufferLength: DWORD, lpBuffer: LPWSTR, lpFilePart: [*c]LPWSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetCurrentDirectoryA(lpPathName: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetCurrentDirectoryW(lpPathName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCurrentDirectoryA(nBufferLength: DWORD, lpBuffer: LPSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetCurrentDirectoryW(nBufferLength: DWORD, lpBuffer: LPWSTR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const __builtin_va_list = [*c]u8;
pub const __gnuc_va_list = __builtin_va_list;
pub const va_list = __builtin_va_list;
pub const MMRESULT = UINT;
pub const struct__SYSTEMTIME = extern struct {
    wYear: WORD = @import("std").mem.zeroes(WORD),
    wMonth: WORD = @import("std").mem.zeroes(WORD),
    wDayOfWeek: WORD = @import("std").mem.zeroes(WORD),
    wDay: WORD = @import("std").mem.zeroes(WORD),
    wHour: WORD = @import("std").mem.zeroes(WORD),
    wMinute: WORD = @import("std").mem.zeroes(WORD),
    wSecond: WORD = @import("std").mem.zeroes(WORD),
    wMilliseconds: WORD = @import("std").mem.zeroes(WORD),
};
pub const SYSTEMTIME = struct__SYSTEMTIME;
pub const PSYSTEMTIME = [*c]struct__SYSTEMTIME;
pub const LPSYSTEMTIME = PSYSTEMTIME;
pub const struct__TIME_ZONE_INFORMATION = extern struct {
    Bias: LONG = @import("std").mem.zeroes(LONG),
    StandardName: [32]WCHAR = @import("std").mem.zeroes([32]WCHAR),
    StandardDate: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    StandardBias: LONG = @import("std").mem.zeroes(LONG),
    DaylightName: [32]WCHAR = @import("std").mem.zeroes([32]WCHAR),
    DaylightDate: SYSTEMTIME = @import("std").mem.zeroes(SYSTEMTIME),
    DaylightBias: LONG = @import("std").mem.zeroes(LONG),
};
pub const TIME_ZONE_INFORMATION = struct__TIME_ZONE_INFORMATION;
pub const PTIME_ZONE_INFORMATION = [*c]struct__TIME_ZONE_INFORMATION;
pub const LPTIME_ZONE_INFORMATION = PTIME_ZONE_INFORMATION;
pub extern fn _byteswap_ushort(Number: c_ushort) callconv(@import("std").os.windows.WINAPI) c_ushort;
pub extern fn _byteswap_ulong(Number: c_ulong) callconv(@import("std").os.windows.WINAPI) c_ulong;
pub extern fn _byteswap_uint64(Number: c_ulonglong) callconv(@import("std").os.windows.WINAPI) c_ulonglong;
pub extern fn _rotl(value: c_uint, shift: c_int) callconv(@import("std").os.windows.WINAPI) c_uint;
pub extern fn _rotl64(value: c_ulonglong, shift: c_int) callconv(@import("std").os.windows.WINAPI) c_ulonglong;
pub extern fn _BitScanForward(Index: [*c]c_ulong, Mask: c_ulong) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn _BitScanForward64(Index: [*c]c_ulong, Mask: c_ulonglong) callconv(@import("std").os.windows.WINAPI) u8;
pub extern fn WideCharToMultiByte(CodePage: UINT, dwFlags: DWORD, lpWideCharStr: LPCWSTR, cchWideChar: c_int, lpMultiByteStr: LPSTR, cbMultiByte: c_int, lpDefaultChar: LPCSTR, lpUsedDefaultChar: LPBOOL) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn MultiByteToWideChar(CodePage: UINT, dwFlags: DWORD, lpMultiByteStr: LPCSTR, cbMultiByte: c_int, lpWideCharStr: LPWSTR, cchWideChar: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn lstrlenA(lpString: LPCSTR) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn lstrlenW(lpString: LPCWSTR) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn lstrcpyA(lpString1: LPCSTR, lpString2: LPCSTR) callconv(@import("std").os.windows.WINAPI) LPCSTR;
pub extern fn lstrcpyW(lpString1: LPCWSTR, lpString2: LPCWSTR) callconv(@import("std").os.windows.WINAPI) LPCWSTR;
pub extern fn GetSystemTime(lpSystemTime: LPSYSTEMTIME) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn GetLocalTime(lpSystemTime: LPSYSTEMTIME) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn QueryProcessCycleTime(hProcess: HANDLE, CycleTime: PULONG64) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SystemTimeToFileTime(lpSystemTime: [*c]const SYSTEMTIME, lpFileTime: LPFILETIME) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FileTimeToSystemTime(lpFileTime: [*c]const FILETIME, lpSystemTime: LPSYSTEMTIME) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CompareFileTime(lpFileTime1: [*c]const FILETIME, lpFileTime2: [*c]const FILETIME) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn GetSystemTimeAsFileTime(lpSystemTimeAsFileTime: LPFILETIME) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn SystemTimeToTzSpecificLocalTime(lpTimeZone: LPTIME_ZONE_INFORMATION, lpUniversalTime: LPSYSTEMTIME, lpLocalTime: LPSYSTEMTIME) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn timeGetTime() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetEnvironmentVariableA(lpName: LPCSTR, lpValue: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetEnvironmentVariableW(lpName: LPCWSTR, lpValue: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetEnvironmentVariableA(lpName: LPCSTR, lpBuffer: LPCSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetEnvironmentVariableW(lpName: LPCWSTR, lpBuffer: LPCWSTR, nSize: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn DisableThreadLibraryCalls(hModule: HMODULE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetLastError() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn Sleep(dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn SleepEx(dwMilliseconds: DWORD, bAlertable: BOOL) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetModuleHandleA(lpModuleName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn GetModuleHandleW(lpModuleName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn FormatMessageA(dwFlags: DWORD, lpSource: LPCVOID, dwMessageId: DWORD, dwLanguageId: DWORD, lpBuffer: LPSTR, nSize: DWORD, Arguments: [*c]va_list) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn FormatMessageW(dwFlags: DWORD, lpSource: LPCVOID, dwMessageId: DWORD, dwLanguageId: DWORD, lpBuffer: LPWSTR, nSize: DWORD, Arguments: [*c]va_list) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetTickCount() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetTickCount64() callconv(@import("std").os.windows.WINAPI) ULONGLONG;
pub extern fn QueryPerformanceFrequency(lpFrequency: [*c]LARGE_INTEGER) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn QueryPerformanceCounter(lpPerformanceCount: [*c]LARGE_INTEGER) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_timecaps_tag = extern struct {
    wPeriodMin: UINT = @import("std").mem.zeroes(UINT),
    wPeriodMax: UINT = @import("std").mem.zeroes(UINT),
};
pub const TIMECAPS = struct_timecaps_tag;
pub const PTIMECAPS = [*c]struct_timecaps_tag;
pub const NPTIMECAPS = [*c]struct_timecaps_tag;
pub const LPTIMECAPS = [*c]struct_timecaps_tag;
pub extern fn timeGetDevCaps(ptc: LPTIMECAPS, cbtc: UINT) callconv(@import("std").os.windows.WINAPI) MMRESULT;
pub extern fn timeBeginPeriod(uPeriod: UINT) callconv(@import("std").os.windows.WINAPI) MMRESULT;
pub extern fn timeEndPeriod(uPeriod: UINT) callconv(@import("std").os.windows.WINAPI) MMRESULT;
pub extern fn LoadLibraryA(lpFileName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn LoadLibraryW(lpFileName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn LoadLibraryExA(lpLibFileName: LPCSTR, hFile: HANDLE, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn LoadLibraryExW(lpLibFileName: LPCWSTR, hFile: HANDLE, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) HMODULE;
pub extern fn GetProcAddress(hModule: HMODULE, lProcName: LPCSTR) callconv(@import("std").os.windows.WINAPI) FARPROC;
pub extern fn wglGetProcAddress(lpszProc: LPCSTR) callconv(@import("std").os.windows.WINAPI) PROC;
pub extern fn FreeLibrary(hModule: HMODULE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SecureZeroMemory(ptr: PVOID, cnt: SIZE_T) callconv(@import("std").os.windows.WINAPI) PVOID;
pub const JobObjectBasicAccountingInformation: c_int = 1;
pub const JobObjectBasicLimitInformation: c_int = 2;
pub const JobObjectBasicProcessIdList: c_int = 3;
pub const JobObjectBasicUIRestrictions: c_int = 4;
pub const JobObjectSecurityLimitInformation: c_int = 5;
pub const JobObjectEndOfJobTimeInformation: c_int = 6;
pub const JobObjectAssociateCompletionPortInformation: c_int = 7;
pub const JobObjectBasicAndIoAccountingInformation: c_int = 8;
pub const JobObjectExtendedLimitInformation: c_int = 9;
pub const JobObjectJobSetInformation: c_int = 10;
pub const JobObjectGroupInformation: c_int = 11;
pub const JobObjectNotificationLimitInformation: c_int = 12;
pub const JobObjectLimitViolationInformation: c_int = 13;
pub const JobObjectGroupInformationEx: c_int = 14;
pub const JobObjectCpuRateControlInformation: c_int = 15;
pub const JobObjectCompletionFilter: c_int = 16;
pub const JobObjectCompletionCounter: c_int = 17;
pub const JobObjectReserved1Information: c_int = 18;
pub const JobObjectReserved2Information: c_int = 19;
pub const JobObjectReserved3Information: c_int = 20;
pub const JobObjectReserved4Information: c_int = 21;
pub const JobObjectReserved5Information: c_int = 22;
pub const JobObjectReserved6Information: c_int = 23;
pub const JobObjectReserved7Information: c_int = 24;
pub const JobObjectReserved8Information: c_int = 25;
pub const JobObjectReserved9Information: c_int = 26;
pub const MaxJobObjectInfoClass: c_int = 27;
pub const enum__JOBOBJECTINFOCLASS = c_uint;
pub const JOBOBJECTINFOCLASS = enum__JOBOBJECTINFOCLASS;
pub const struct__STARTUPINFOA = extern struct {
    cb: DWORD = @import("std").mem.zeroes(DWORD),
    lpReserved: LPSTR = @import("std").mem.zeroes(LPSTR),
    lpDesktop: LPSTR = @import("std").mem.zeroes(LPSTR),
    lpTitle: LPSTR = @import("std").mem.zeroes(LPSTR),
    dwX: DWORD = @import("std").mem.zeroes(DWORD),
    dwY: DWORD = @import("std").mem.zeroes(DWORD),
    dwXSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwYSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwXCountChars: DWORD = @import("std").mem.zeroes(DWORD),
    dwYCountChars: DWORD = @import("std").mem.zeroes(DWORD),
    dwFillAttribute: DWORD = @import("std").mem.zeroes(DWORD),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    wShowWindow: WORD = @import("std").mem.zeroes(WORD),
    cbReserved2: WORD = @import("std").mem.zeroes(WORD),
    lpReserved2: LPBYTE = @import("std").mem.zeroes(LPBYTE),
    hStdInput: HANDLE = @import("std").mem.zeroes(HANDLE),
    hStdOutput: HANDLE = @import("std").mem.zeroes(HANDLE),
    hStdError: HANDLE = @import("std").mem.zeroes(HANDLE),
};
pub const STARTUPINFOA = struct__STARTUPINFOA;
pub const LPSTARTUPINFOA = [*c]struct__STARTUPINFOA;
pub const struct__STARTUPINFOW = extern struct {
    cb: DWORD = @import("std").mem.zeroes(DWORD),
    lpReserved: LPWSTR = @import("std").mem.zeroes(LPWSTR),
    lpDesktop: LPWSTR = @import("std").mem.zeroes(LPWSTR),
    lpTitle: LPWSTR = @import("std").mem.zeroes(LPWSTR),
    dwX: DWORD = @import("std").mem.zeroes(DWORD),
    dwY: DWORD = @import("std").mem.zeroes(DWORD),
    dwXSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwYSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwXCountChars: DWORD = @import("std").mem.zeroes(DWORD),
    dwYCountChars: DWORD = @import("std").mem.zeroes(DWORD),
    dwFillAttribute: DWORD = @import("std").mem.zeroes(DWORD),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    wShowWindow: WORD = @import("std").mem.zeroes(WORD),
    cbReserved2: WORD = @import("std").mem.zeroes(WORD),
    lpReserved2: LPBYTE = @import("std").mem.zeroes(LPBYTE),
    hStdInput: HANDLE = @import("std").mem.zeroes(HANDLE),
    hStdOutput: HANDLE = @import("std").mem.zeroes(HANDLE),
    hStdError: HANDLE = @import("std").mem.zeroes(HANDLE),
};
pub const STARTUPINFOW = struct__STARTUPINFOW;
pub const LPSTARTUPINFOW = [*c]struct__STARTUPINFOW;
pub const struct__PROC_THREAD_ATTRIBUTE_LIST = opaque {};
pub const PPROC_THREAD_ATTRIBUTE_LIST = ?*struct__PROC_THREAD_ATTRIBUTE_LIST;
pub const LPPROC_THREAD_ATTRIBUTE_LIST = ?*struct__PROC_THREAD_ATTRIBUTE_LIST;
pub const struct__STARTUPINFOEXA = extern struct {
    StartupInfo: STARTUPINFOA = @import("std").mem.zeroes(STARTUPINFOA),
    lpAttributeList: PPROC_THREAD_ATTRIBUTE_LIST = @import("std").mem.zeroes(PPROC_THREAD_ATTRIBUTE_LIST),
};
pub const STARTUPINFOEXA = struct__STARTUPINFOEXA;
pub const LPSTARTUPINFOEXA = [*c]struct__STARTUPINFOEXA;
pub const struct__STARTUPINFOEXW = extern struct {
    StartupInfo: STARTUPINFOW = @import("std").mem.zeroes(STARTUPINFOW),
    lpAttributeList: PPROC_THREAD_ATTRIBUTE_LIST = @import("std").mem.zeroes(PPROC_THREAD_ATTRIBUTE_LIST),
};
pub const STARTUPINFOEXW = struct__STARTUPINFOEXW;
pub const LPSTARTUPINFOEXW = [*c]struct__STARTUPINFOEXW;
pub const struct__PROCESS_INFORMATION = extern struct {
    hProcess: HANDLE = @import("std").mem.zeroes(HANDLE),
    hThread: HANDLE = @import("std").mem.zeroes(HANDLE),
    dwProcessId: DWORD = @import("std").mem.zeroes(DWORD),
    dwThreadId: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const PROCESS_INFORMATION = struct__PROCESS_INFORMATION;
pub const LPPROCESS_INFORMATION = [*c]struct__PROCESS_INFORMATION;
pub const struct__JOBOBJECT_BASIC_LIMIT_INFORMATION = extern struct {
    PerProcessUserTimeLimit: LARGE_INTEGER = @import("std").mem.zeroes(LARGE_INTEGER),
    PerJobUserTimeLimit: LARGE_INTEGER = @import("std").mem.zeroes(LARGE_INTEGER),
    LimitFlags: DWORD = @import("std").mem.zeroes(DWORD),
    MinimumWorkingSetSize: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    MaximumWorkingSetSize: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    ActiveProcessLimit: DWORD = @import("std").mem.zeroes(DWORD),
    Affinity: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    PriorityClass: DWORD = @import("std").mem.zeroes(DWORD),
    SchedulingClass: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const JOBOBJECT_BASIC_LIMIT_INFORMATION = struct__JOBOBJECT_BASIC_LIMIT_INFORMATION;
pub const PJOBOBJECT_BASIC_LIMIT_INFORMATION = [*c]struct__JOBOBJECT_BASIC_LIMIT_INFORMATION;
pub const struct__IO_COUNTERS = extern struct {
    ReadOperationCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    WriteOperationCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    OtherOperationCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    ReadTransferCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    WriteTransferCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    OtherTransferCount: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
};
pub const IO_COUNTERS = struct__IO_COUNTERS;
pub const PIO_COUNTERS = [*c]struct__IO_COUNTERS;
pub const struct__JOBOBJECT_EXTENDED_LIMIT_INFORMATION = extern struct {
    BasicLimitInformation: JOBOBJECT_BASIC_LIMIT_INFORMATION = @import("std").mem.zeroes(JOBOBJECT_BASIC_LIMIT_INFORMATION),
    IoInfo: IO_COUNTERS = @import("std").mem.zeroes(IO_COUNTERS),
    ProcessMemoryLimit: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    JobMemoryLimit: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    PeakProcessMemoryUsed: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    PeakJobMemoryUsed: SIZE_T = @import("std").mem.zeroes(SIZE_T),
};
pub const JOBOBJECT_EXTENDED_LIMIT_INFORMATION = struct__JOBOBJECT_EXTENDED_LIMIT_INFORMATION;
pub const PJOBOBJECT_EXTENDED_LIMIT_INFORMATION = [*c]struct__JOBOBJECT_EXTENDED_LIMIT_INFORMATION;
pub extern fn GetCurrentProcess() callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetCurrentProcessId() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn ExitProcess(uExitCode: UINT) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn OpenProcess(dwDesiredAccess: DWORD, bInheritHandle: BOOL, dwProcessId: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateProcessA(lpApplicationName: LPCSTR, lpCommandLine: LPSTR, lpProcessAttributes: LPSECURITY_ATTRIBUTES, lpThreadAttributes: LPSECURITY_ATTRIBUTES, bInheritHandles: BOOL, dwCreationFlags: DWORD, lpEnvironment: LPVOID, lpCurrentDirectory: LPCSTR, lpStartupInfo: LPSTARTUPINFOA, lpProcessInformation: LPPROCESS_INFORMATION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateProcessW(lpApplicationName: LPCWSTR, lpCommandLine: LPWSTR, lpProcessAttributes: LPSECURITY_ATTRIBUTES, lpThreadAttributes: LPSECURITY_ATTRIBUTES, bInheritHandles: BOOL, dwCreationFlags: DWORD, lpEnvironment: LPVOID, lpCurrentDirectory: LPCWSTR, lpStartupInfo: LPSTARTUPINFOW, lpProcessInformation: LPPROCESS_INFORMATION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn TerminateProcess(hProcess: HANDLE, uExitCode: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnumProcessModules(hProcess: HANDLE, lphModule: [*c]HMODULE, cb: DWORD, lpcbNeeded: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WaitForInputIdle(hProcess: HANDLE, dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetExitCodeProcess(hProcess: HANDLE, lpExitCode: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateJobObjectA(lpJobAttributes: LPSECURITY_ATTRIBUTES, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateJobObjectW(lpJobAttributes: LPSECURITY_ATTRIBUTES, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn SetInformationJobObject(hJob: HANDLE, JobObjectInfoClass: JOBOBJECTINFOCLASS, lpJobObjectInfo: LPVOID, cbJobObjectInfoLength: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AssignProcessToJobObject(hJob: HANDLE, hProcess: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
const struct_unnamed_16 = extern struct {
    wProcessorArchitecture: WORD = @import("std").mem.zeroes(WORD),
    wReserved: WORD = @import("std").mem.zeroes(WORD),
};
const union_unnamed_15 = extern union {
    dwOemId: DWORD,
    unnamed_0: struct_unnamed_16,
};
pub const struct__SYSTEM_INFO = extern struct {
    unnamed_0: union_unnamed_15 = @import("std").mem.zeroes(union_unnamed_15),
    dwPageSize: DWORD = @import("std").mem.zeroes(DWORD),
    lpMinimumApplicationAddress: LPVOID = @import("std").mem.zeroes(LPVOID),
    lpMaximumApplicationAddress: LPVOID = @import("std").mem.zeroes(LPVOID),
    dwActiveProcessorMask: DWORD_PTR = @import("std").mem.zeroes(DWORD_PTR),
    dwNumberOfProcessors: DWORD = @import("std").mem.zeroes(DWORD),
    dwProcessorType: DWORD = @import("std").mem.zeroes(DWORD),
    dwAllocationGranularity: DWORD = @import("std").mem.zeroes(DWORD),
    wProcessorLevel: WORD = @import("std").mem.zeroes(WORD),
    wProcessorRevision: WORD = @import("std").mem.zeroes(WORD),
};
pub const SYSTEM_INFO = struct__SYSTEM_INFO;
pub const LPSYSTEM_INFO = [*c]struct__SYSTEM_INFO;
pub const struct__DISPLAY_DEVICEA = extern struct {
    cb: DWORD = @import("std").mem.zeroes(DWORD),
    DeviceName: [32]CHAR = @import("std").mem.zeroes([32]CHAR),
    DeviceString: [128]CHAR = @import("std").mem.zeroes([128]CHAR),
    StateFlags: DWORD = @import("std").mem.zeroes(DWORD),
    DeviceID: [128]CHAR = @import("std").mem.zeroes([128]CHAR),
    DeviceKey: [128]CHAR = @import("std").mem.zeroes([128]CHAR),
};
pub const DISPLAY_DEVICEA = struct__DISPLAY_DEVICEA;
pub const PDISPLAY_DEVICEA = [*c]struct__DISPLAY_DEVICEA;
pub const struct__DISPLAY_DEVICEW = extern struct {
    cb: DWORD = @import("std").mem.zeroes(DWORD),
    DeviceName: [32]WCHAR = @import("std").mem.zeroes([32]WCHAR),
    DeviceString: [128]WCHAR = @import("std").mem.zeroes([128]WCHAR),
    StateFlags: DWORD = @import("std").mem.zeroes(DWORD),
    DeviceID: [128]WCHAR = @import("std").mem.zeroes([128]WCHAR),
    DeviceKey: [128]WCHAR = @import("std").mem.zeroes([128]WCHAR),
};
pub const DISPLAY_DEVICEW = struct__DISPLAY_DEVICEW;
pub const PDISPLAY_DEVICEW = [*c]struct__DISPLAY_DEVICEW;
pub const struct__OSVERSIONINFOEXA = extern struct {
    dwOSVersionInfoSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwMajorVersion: DWORD = @import("std").mem.zeroes(DWORD),
    dwMinorVersion: DWORD = @import("std").mem.zeroes(DWORD),
    dwBuildNumber: DWORD = @import("std").mem.zeroes(DWORD),
    dwPlatformId: DWORD = @import("std").mem.zeroes(DWORD),
    szCSDVersion: [128]CHAR = @import("std").mem.zeroes([128]CHAR),
    wServicePackMajor: WORD = @import("std").mem.zeroes(WORD),
    wServicePackMinor: WORD = @import("std").mem.zeroes(WORD),
    wSuiteMask: WORD = @import("std").mem.zeroes(WORD),
    wProductType: BYTE = @import("std").mem.zeroes(BYTE),
    wReserved: BYTE = @import("std").mem.zeroes(BYTE),
};
pub const OSVERSIONINFOEXA = struct__OSVERSIONINFOEXA;
pub const POSVERSIONINFOEXA = [*c]struct__OSVERSIONINFOEXA;
pub const LPOSVERSIONINFOEXA = [*c]struct__OSVERSIONINFOEXA;
pub const struct__OSVERSIONINFOEXW = extern struct {
    dwOSVersionInfoSize: DWORD = @import("std").mem.zeroes(DWORD),
    dwMajorVersion: DWORD = @import("std").mem.zeroes(DWORD),
    dwMinorVersion: DWORD = @import("std").mem.zeroes(DWORD),
    dwBuildNumber: DWORD = @import("std").mem.zeroes(DWORD),
    dwPlatformId: DWORD = @import("std").mem.zeroes(DWORD),
    szCSDVersion: [128]WCHAR = @import("std").mem.zeroes([128]WCHAR),
    wServicePackMajor: WORD = @import("std").mem.zeroes(WORD),
    wServicePackMinor: WORD = @import("std").mem.zeroes(WORD),
    wSuiteMask: WORD = @import("std").mem.zeroes(WORD),
    wProductType: BYTE = @import("std").mem.zeroes(BYTE),
    wReserved: BYTE = @import("std").mem.zeroes(BYTE),
};
pub const OSVERSIONINFOEXW = struct__OSVERSIONINFOEXW;
pub const POSVERSIONINFOEXW = [*c]struct__OSVERSIONINFOEXW;
pub const LPOSVERSIONINFOEXW = [*c]struct__OSVERSIONINFOEXW;
pub const RelationProcessorCore: c_int = 0;
pub const RelationNumaNode: c_int = 1;
pub const RelationCache: c_int = 2;
pub const RelationProcessorPackage: c_int = 3;
pub const RelationGroup: c_int = 4;
pub const RelationAll: c_int = 65535;
pub const enum__LOGICAL_PROCESSOR_RELATIONSHIP = c_uint;
pub const LOGICAL_PROCESSOR_RELATIONSHIP = enum__LOGICAL_PROCESSOR_RELATIONSHIP;
pub const CacheUnified: c_int = 0;
pub const CacheInstruction: c_int = 1;
pub const CacheData: c_int = 2;
pub const CacheTrace: c_int = 3;
pub const enum__PROCESSOR_CACHE_TYPE = c_uint;
pub const PROCESSOR_CACHE_TYPE = enum__PROCESSOR_CACHE_TYPE;
pub const struct__CACHE_DESCRIPTOR = extern struct {
    Level: BYTE = @import("std").mem.zeroes(BYTE),
    Associativity: BYTE = @import("std").mem.zeroes(BYTE),
    LineSize: WORD = @import("std").mem.zeroes(WORD),
    Size: DWORD = @import("std").mem.zeroes(DWORD),
    Type: PROCESSOR_CACHE_TYPE = @import("std").mem.zeroes(PROCESSOR_CACHE_TYPE),
};
pub const CACHE_DESCRIPTOR = struct__CACHE_DESCRIPTOR;
pub const PCACHE_DESCRIPTOR = [*c]struct__CACHE_DESCRIPTOR;
const struct_unnamed_18 = extern struct {
    Flags: BYTE = @import("std").mem.zeroes(BYTE),
};
const struct_unnamed_19 = extern struct {
    NodeNumber: DWORD = @import("std").mem.zeroes(DWORD),
};
const union_unnamed_17 = extern union {
    ProcessorCore: struct_unnamed_18,
    NumaNode: struct_unnamed_19,
    Cache: CACHE_DESCRIPTOR,
    Reserved: [2]ULONGLONG,
};
pub const struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION = extern struct {
    ProcessorMask: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    Relationship: LOGICAL_PROCESSOR_RELATIONSHIP = @import("std").mem.zeroes(LOGICAL_PROCESSOR_RELATIONSHIP),
    unnamed_0: union_unnamed_17 = @import("std").mem.zeroes(union_unnamed_17),
};
pub const SYSTEM_LOGICAL_PROCESSOR_INFORMATION = struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION;
pub const PSYSTEM_LOGICAL_PROCESSOR_INFORMATION = [*c]struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION;
pub const KAFFINITY = ULONG_PTR;
pub const struct__GROUP_AFFINITY = extern struct {
    Mask: KAFFINITY = @import("std").mem.zeroes(KAFFINITY),
    Group: WORD = @import("std").mem.zeroes(WORD),
    Reserved: [3]WORD = @import("std").mem.zeroes([3]WORD),
};
pub const GROUP_AFFINITY = struct__GROUP_AFFINITY;
pub const PGROUP_AFFINITY = [*c]struct__GROUP_AFFINITY;
pub const struct__NUMA_NODE_RELATIONSHIP = extern struct {
    NodeNumber: DWORD = @import("std").mem.zeroes(DWORD),
    Reserved: [20]BYTE = @import("std").mem.zeroes([20]BYTE),
    GroupMask: GROUP_AFFINITY = @import("std").mem.zeroes(GROUP_AFFINITY),
};
pub const NUMA_NODE_RELATIONSHIP = struct__NUMA_NODE_RELATIONSHIP;
pub const PNUMA_NODE_RELATIONSHIP = [*c]struct__NUMA_NODE_RELATIONSHIP;
pub const struct__PROCESSOR_GROUP_INFO = extern struct {
    MaximumProcessorCount: BYTE = @import("std").mem.zeroes(BYTE),
    ActiveProcessorCount: BYTE = @import("std").mem.zeroes(BYTE),
    Reserved: [38]BYTE = @import("std").mem.zeroes([38]BYTE),
    ActiveProcessorMask: KAFFINITY = @import("std").mem.zeroes(KAFFINITY),
};
pub const PROCESSOR_GROUP_INFO = struct__PROCESSOR_GROUP_INFO;
pub const PPROCESSOR_GROUP_INFO = [*c]struct__PROCESSOR_GROUP_INFO;
pub const struct__GROUP_RELATIONSHIP = extern struct {
    MaximumGroupCount: WORD = @import("std").mem.zeroes(WORD),
    ActiveGroupCount: WORD = @import("std").mem.zeroes(WORD),
    Reserved: [20]BYTE = @import("std").mem.zeroes([20]BYTE),
    GroupInfo: [1]PROCESSOR_GROUP_INFO = @import("std").mem.zeroes([1]PROCESSOR_GROUP_INFO),
};
pub const GROUP_RELATIONSHIP = struct__GROUP_RELATIONSHIP;
pub const PGROUP_RELATIONSHIP = [*c]struct__GROUP_RELATIONSHIP;
pub const struct__CACHE_RELATIONSHIP = extern struct {
    Level: BYTE = @import("std").mem.zeroes(BYTE),
    Associativity: BYTE = @import("std").mem.zeroes(BYTE),
    LineSize: WORD = @import("std").mem.zeroes(WORD),
    CacheSize: DWORD = @import("std").mem.zeroes(DWORD),
    Type: PROCESSOR_CACHE_TYPE = @import("std").mem.zeroes(PROCESSOR_CACHE_TYPE),
    Reserved: [20]BYTE = @import("std").mem.zeroes([20]BYTE),
    GroupMask: GROUP_AFFINITY = @import("std").mem.zeroes(GROUP_AFFINITY),
};
pub const CACHE_RELATIONSHIP = struct__CACHE_RELATIONSHIP;
pub const PCACHE_RELATIONSHIP = [*c]struct__CACHE_RELATIONSHIP;
pub const struct__PROCESSOR_RELATIONSHIP = extern struct {
    Flags: BYTE = @import("std").mem.zeroes(BYTE),
    EfficiencyClass: BYTE = @import("std").mem.zeroes(BYTE),
    Reserved: [21]BYTE = @import("std").mem.zeroes([21]BYTE),
    GroupCount: WORD = @import("std").mem.zeroes(WORD),
    GroupMask: [1]GROUP_AFFINITY = @import("std").mem.zeroes([1]GROUP_AFFINITY),
};
pub const PROCESSOR_RELATIONSHIP = struct__PROCESSOR_RELATIONSHIP;
pub const PPROCESSOR_RELATIONSHIP = [*c]struct__PROCESSOR_RELATIONSHIP;
const union_unnamed_20 = extern union {
    Processor: PROCESSOR_RELATIONSHIP,
    NumaNode: NUMA_NODE_RELATIONSHIP,
    Cache: CACHE_RELATIONSHIP,
    Group: GROUP_RELATIONSHIP,
};
pub const struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX = extern struct {
    Relationship: LOGICAL_PROCESSOR_RELATIONSHIP = @import("std").mem.zeroes(LOGICAL_PROCESSOR_RELATIONSHIP),
    Size: DWORD = @import("std").mem.zeroes(DWORD),
    unnamed_0: union_unnamed_20 = @import("std").mem.zeroes(union_unnamed_20),
};
pub const SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX = struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX;
pub const PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX = [*c]struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX;
pub const struct__PROCESS_MEMORY_COUNTERS = extern struct {
    cb: DWORD = @import("std").mem.zeroes(DWORD),
    PageFaultCount: DWORD = @import("std").mem.zeroes(DWORD),
    PeakWorkingSetSize: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    WorkingSetSize: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    QuotaPeakPagedPoolUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    QuotaPagedPoolUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    QuotaPeakNonPagedPoolUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    QuotaNonPagedPoolUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    PagefileUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
    PeakPagefileUsage: SIZE_T = @import("std").mem.zeroes(SIZE_T),
};
pub const PROCESS_MEMORY_COUNTERS = struct__PROCESS_MEMORY_COUNTERS;
pub const PPROCESS_MEMORY_COUNTERS = [*c]struct__PROCESS_MEMORY_COUNTERS;
pub const struct__MEMORYSTATUSEX = extern struct {
    dwLength: DWORD = @import("std").mem.zeroes(DWORD),
    dwMemoryLoad: DWORD = @import("std").mem.zeroes(DWORD),
    ullTotalPhys: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullAvailPhys: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullTotalPageFile: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullAvailPageFile: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullTotalVirtual: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullAvailVirtual: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
    ullAvailExtendedVirtual: DWORDLONG = @import("std").mem.zeroes(DWORDLONG),
};
pub const MEMORYSTATUSEX = struct__MEMORYSTATUSEX;
pub const LPMEMORYSTATUSEX = [*c]struct__MEMORYSTATUSEX;
pub const struct__PROCESSOR_NUMBER = extern struct {
    Group: WORD = @import("std").mem.zeroes(WORD),
    Number: BYTE = @import("std").mem.zeroes(BYTE),
    Reserved: BYTE = @import("std").mem.zeroes(BYTE),
};
pub const PROCESSOR_NUMBER = struct__PROCESSOR_NUMBER;
pub const PPROCESSOR_NUMBER = [*c]struct__PROCESSOR_NUMBER;
pub extern fn GetSystemInfo(lpSystemInfo: LPSYSTEM_INFO) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn GlobalMemoryStatusEx(lpBuffer: LPMEMORYSTATUSEX) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetLogicalProcessorInformation(Buffer: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION, ReturnedLength: PDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetLogicalProcessorInformationEx(RelationshipType: LOGICAL_PROCESSOR_RELATIONSHIP, Buffer: PSYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX, ReturnedLength: PDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetProcessMemoryInfo(hProcess: HANDLE, ppsmemCounters: PPROCESS_MEMORY_COUNTERS, cb: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetProcessTimes(hProcess: HANDLE, lpCreationTime: LPFILETIME, lpExitTime: LPFILETIME, lpKernelTime: LPFILETIME, lpUserTime: LPFILETIME) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCurrentProcessorNumber() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetCurrentProcessorNumberEx(ProcNumber: PPROCESSOR_NUMBER) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn GetActiveProcessorCount(GroupNumber: WORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetComputerNameA(lpBuffer: LPSTR, lpnSize: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetComputerNameW(lpBuffer: LPWSTR, lpnSize: LPDWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn VerifyVersionInfoA(lpVersionInfo: LPOSVERSIONINFOEXA, dwTypeMask: DWORD, dwlConditionMask: DWORDLONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn VerifyVersionInfoW(lpVersionInfo: LPOSVERSIONINFOEXW, dwTypeMask: DWORD, dwlConditionMask: DWORDLONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn VerSetConditionMask(ConditionMask: ULONGLONG, TypeMask: DWORD, Condition: BYTE) callconv(@import("std").os.windows.WINAPI) ULONGLONG;
pub fn IsWindowsVersionOrGreater(arg_major: WORD, arg_minor: WORD, arg_servpack: WORD) callconv(@import("std").os.windows.WINAPI) BOOL {
    var major = arg_major;
    _ = &major;
    var minor = arg_minor;
    _ = &minor;
    var servpack = arg_servpack;
    _ = &servpack;
    var vi: OSVERSIONINFOEXW = OSVERSIONINFOEXW{
        .dwOSVersionInfoSize = @as(DWORD, @bitCast(@as(c_ulong, @truncate(@sizeOf(OSVERSIONINFOEXW))))),
        .dwMajorVersion = @as(DWORD, @bitCast(@as(c_ulong, major))),
        .dwMinorVersion = @as(DWORD, @bitCast(@as(c_ulong, minor))),
        .dwBuildNumber = @as(DWORD, @bitCast(@as(c_long, @as(c_int, 0)))),
        .dwPlatformId = @as(DWORD, @bitCast(@as(c_long, @as(c_int, 0)))),
        .szCSDVersion = [1]WCHAR{
            0,
        } ++ [1]WCHAR{@import("std").mem.zeroes(WCHAR)} ** 127,
        .wServicePackMajor = servpack,
        .wServicePackMinor = @import("std").mem.zeroes(WORD),
        .wSuiteMask = @import("std").mem.zeroes(WORD),
        .wProductType = @import("std").mem.zeroes(BYTE),
        .wReserved = @import("std").mem.zeroes(BYTE),
    };
    _ = &vi;
    return VerifyVersionInfoW(&vi, @as(DWORD, @bitCast(@as(c_long, (@as(c_int, 2) | @as(c_int, 1)) | @as(c_int, 32)))), VerSetConditionMask(VerSetConditionMask(VerSetConditionMask(@as(ULONGLONG, @bitCast(@as(c_longlong, @as(c_int, 0)))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 2)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 3)))))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 1)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 3)))))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 32)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 3)))))));
}
pub fn IsWindowsVersionOrLess(arg_major: WORD, arg_minor: WORD, arg_servpack: WORD) callconv(@import("std").os.windows.WINAPI) BOOL {
    var major = arg_major;
    _ = &major;
    var minor = arg_minor;
    _ = &minor;
    var servpack = arg_servpack;
    _ = &servpack;
    var vi: OSVERSIONINFOEXW = OSVERSIONINFOEXW{
        .dwOSVersionInfoSize = @as(DWORD, @bitCast(@as(c_ulong, @truncate(@sizeOf(OSVERSIONINFOEXW))))),
        .dwMajorVersion = @as(DWORD, @bitCast(@as(c_ulong, major))),
        .dwMinorVersion = @as(DWORD, @bitCast(@as(c_ulong, minor))),
        .dwBuildNumber = @as(DWORD, @bitCast(@as(c_long, @as(c_int, 0)))),
        .dwPlatformId = @as(DWORD, @bitCast(@as(c_long, @as(c_int, 0)))),
        .szCSDVersion = [1]WCHAR{
            0,
        } ++ [1]WCHAR{@import("std").mem.zeroes(WCHAR)} ** 127,
        .wServicePackMajor = servpack,
        .wServicePackMinor = @import("std").mem.zeroes(WORD),
        .wSuiteMask = @import("std").mem.zeroes(WORD),
        .wProductType = @import("std").mem.zeroes(BYTE),
        .wReserved = @import("std").mem.zeroes(BYTE),
    };
    _ = &vi;
    return VerifyVersionInfoW(&vi, @as(DWORD, @bitCast(@as(c_long, (@as(c_int, 2) | @as(c_int, 1)) | @as(c_int, 32)))), VerSetConditionMask(VerSetConditionMask(VerSetConditionMask(@as(ULONGLONG, @bitCast(@as(c_longlong, @as(c_int, 0)))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 2)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 5)))))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 1)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 5)))))), @as(DWORD, @bitCast(@as(c_long, @as(c_int, 32)))), @as(BYTE, @bitCast(@as(i8, @truncate(@as(c_int, 5)))))));
}
pub extern fn __cpuid(cpuInfo: [*c]c_int, function_id: c_int) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn __cpuidex(cpuInfo: [*c]c_int, function_id: c_int, subfunction_id: c_int) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn EnumDisplayDevicesA(lpDevice: LPCSTR, iDevNum: DWORD, lpDisplayDevice: PDISPLAY_DEVICEA, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnumDisplayDevicesW(lpDevice: LPCWSTR, iDevNum: DWORD, lpDisplayDevice: PDISPLAY_DEVICEW, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RegOpenKeyExA(hKey: HKEY, lpSubKey: LPCSTR, ulOptions: DWORD, samDesired: REGSAM, phkResult: PHKEY) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegOpenKeyExW(hKey: HKEY, lpSubKey: LPCWSTR, ulOptions: DWORD, samDesired: REGSAM, phkResult: PHKEY) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegQueryValueExA(hKey: HKEY, lpValueName: LPCSTR, lpReserved: LPDWORD, lpType: LPDWORD, lpData: LPBYTE, lpcbData: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegQueryValueExW(hKey: HKEY, lpValueName: LPCWSTR, lpReserved: LPDWORD, lpType: LPDWORD, lpData: LPBYTE, lpcbData: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegCreateKeyExA(hKey: HKEY, lpSubKey: LPCSTR, Reserved: DWORD, lpClass: LPSTR, dwOptions: DWORD, samDesired: REGSAM, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, phkResult: PHKEY, lpdwDisposition: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegCreateKeyExW(hKey: HKEY, lpSubKey: LPCWSTR, Reserved: DWORD, lpClass: LPWSTR, dwOptions: DWORD, samDesired: REGSAM, lpSecurityAttributes: LPSECURITY_ATTRIBUTES, phkResult: PHKEY, lpdwDisposition: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegEnumValueA(hKey: HKEY, dwIndex: DWORD, lpValueName: LPSTR, lpcchValueName: LPDWORD, lpReserved: LPDWORD, lpType: LPDWORD, lpData: LPBYTE, lpcbData: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegEnumValueW(hKey: HKEY, dwIndex: DWORD, lpValueName: LPWSTR, lpcchValueName: LPDWORD, lpReserved: LPDWORD, lpType: LPDWORD, lpData: LPBYTE, lpcbData: LPDWORD) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegQueryInfoKeyA(hKey: HKEY, lpClass: LPSTR, lpcClass: LPDWORD, lpReserved: LPDWORD, lpcSubKeys: LPDWORD, lpcMaxSubKeyLen: LPDWORD, lpcMaxClassLen: LPDWORD, lpcValues: LPDWORD, lpcMaxValueNameLen: LPDWORD, lpcMaxValueLen: LPDWORD, lpcbSecurityDescriptor: LPDWORD, lpftLastWriteTime: PFILETIME) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegQueryInfoKeyW(hKey: HKEY, lpClass: LPWSTR, lpcClass: LPDWORD, lpReserved: LPDWORD, lpcSubKeys: LPDWORD, lpcMaxSubKeyLen: LPDWORD, lpcMaxClassLen: LPDWORD, lpcValues: LPDWORD, lpcMaxValueNameLen: LPDWORD, lpcMaxValueLen: LPDWORD, lpcbSecurityDescriptor: LPDWORD, lpftLastWriteTime: PFILETIME) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegEnumKeyExA(hKey: HKEY, dwIndex: DWORD, lpName: LPSTR, lpcName: LPDWORD, lpReserved: LPDWORD, lpClass: LPSTR, lpcClass: LPDWORD, lpftLastWriteTime: PFILETIME) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegEnumKeyExW(hKey: HKEY, dwIndex: DWORD, lpName: LPWSTR, lpcName: LPDWORD, lpReserved: LPDWORD, lpClass: LPWSTR, lpcClass: LPDWORD, lpftLastWriteTime: PFILETIME) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegCloseKey(hKey: HKEY) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn RegFlushKey(hKey: HKEY) callconv(@import("std").os.windows.WINAPI) LONG;
pub const PIMAGE_TLS_CALLBACK = ?*const fn (PVOID, DWORD, PVOID) callconv(@import("std").os.windows.WINAPI) void;
pub const struct__IMAGE_TLS_DIRECTORY32 = extern struct {
    StartAddressOfRawData: DWORD = @import("std").mem.zeroes(DWORD),
    EndAddressOfRawData: DWORD = @import("std").mem.zeroes(DWORD),
    AddressOfIndex: DWORD = @import("std").mem.zeroes(DWORD),
    AddressOfCallbacks: DWORD = @import("std").mem.zeroes(DWORD),
    SizeOfZeroFill: DWORD = @import("std").mem.zeroes(DWORD),
    Characteristics: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const IMAGE_TLS_DIRECTORY32 = struct__IMAGE_TLS_DIRECTORY32;
pub const PIMAGE_TLS_DIRECTORY32 = [*c]struct__IMAGE_TLS_DIRECTORY32;
pub const struct__IMAGE_TLS_DIRECTORY64 = extern struct {
    StartAddressOfRawData: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    EndAddressOfRawData: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    AddressOfIndex: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    AddressOfCallbacks: ULONGLONG = @import("std").mem.zeroes(ULONGLONG),
    SizeOfZeroFill: DWORD = @import("std").mem.zeroes(DWORD),
    Characteristics: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const IMAGE_TLS_DIRECTORY64 = struct__IMAGE_TLS_DIRECTORY64;
pub const PIMAGE_TLS_DIRECTORY64 = [*c]struct__IMAGE_TLS_DIRECTORY64;
pub const IMAGE_TLS_DIRECTORY = IMAGE_TLS_DIRECTORY64;
pub const PIMAGE_TLS_DIRECTORY = PIMAGE_TLS_DIRECTORY64;
pub const struct__LIST_ENTRY = extern struct {
    Flink: [*c]struct__LIST_ENTRY = @import("std").mem.zeroes([*c]struct__LIST_ENTRY),
    Blink: [*c]struct__LIST_ENTRY = @import("std").mem.zeroes([*c]struct__LIST_ENTRY),
};
pub const LIST_ENTRY = struct__LIST_ENTRY;
pub const PLIST_ENTRY = [*c]struct__LIST_ENTRY;
pub const PRTL_CRITICAL_SECTION_DEBUG = [*c]struct__RTL_CRITICAL_SECTION_DEBUG;
pub const struct__RTL_CRITICAL_SECTION = extern struct {
    DebugInfo: PRTL_CRITICAL_SECTION_DEBUG = @import("std").mem.zeroes(PRTL_CRITICAL_SECTION_DEBUG),
    LockCount: LONG = @import("std").mem.zeroes(LONG),
    RecursionCount: LONG = @import("std").mem.zeroes(LONG),
    OwningThread: HANDLE = @import("std").mem.zeroes(HANDLE),
    LockSemaphore: HANDLE = @import("std").mem.zeroes(HANDLE),
    SpinCount: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
};
pub const struct__RTL_CRITICAL_SECTION_DEBUG = extern struct {
    Type: WORD = @import("std").mem.zeroes(WORD),
    CreatorBackTraceIndex: WORD = @import("std").mem.zeroes(WORD),
    CriticalSection: [*c]struct__RTL_CRITICAL_SECTION = @import("std").mem.zeroes([*c]struct__RTL_CRITICAL_SECTION),
    ProcessLocksList: LIST_ENTRY = @import("std").mem.zeroes(LIST_ENTRY),
    EntryCount: DWORD = @import("std").mem.zeroes(DWORD),
    ContentionCount: DWORD = @import("std").mem.zeroes(DWORD),
    Flags: DWORD = @import("std").mem.zeroes(DWORD),
    CreatorBackTraceIndexHigh: WORD = @import("std").mem.zeroes(WORD),
    SpareWORD: WORD = @import("std").mem.zeroes(WORD),
};
pub const RTL_CRITICAL_SECTION_DEBUG = struct__RTL_CRITICAL_SECTION_DEBUG;
pub const RTL_CRITICAL_SECTION = struct__RTL_CRITICAL_SECTION;
pub const PRTL_CRITICAL_SECTION = [*c]struct__RTL_CRITICAL_SECTION;
pub const CRITICAL_SECTION = RTL_CRITICAL_SECTION;
pub const PCRITICAL_SECTION = PRTL_CRITICAL_SECTION;
pub const LPCRITICAL_SECTION = PRTL_CRITICAL_SECTION;
pub const struct__RTL_CONDITION_VARIABLE = extern struct {
    Ptr: PVOID = @import("std").mem.zeroes(PVOID),
};
pub const RTL_CONDITION_VARIABLE = struct__RTL_CONDITION_VARIABLE;
pub const PRTL_CONDITION_VARIABLE = [*c]struct__RTL_CONDITION_VARIABLE;
pub const CONDITION_VARIABLE = RTL_CONDITION_VARIABLE;
pub const PCONDITION_VARIABLE = PRTL_CONDITION_VARIABLE;
pub const struct__RTL_SRWLOCK = extern struct {
    Ptr: PVOID = @import("std").mem.zeroes(PVOID),
};
pub const RTL_SRWLOCK = struct__RTL_SRWLOCK;
pub const PRTL_SRWLOCK = [*c]struct__RTL_SRWLOCK;
pub const SRWLOCK = RTL_SRWLOCK;
pub const PSRWLOCK = [*c]RTL_SRWLOCK;
pub extern fn WaitForSingleObject(hHandle: HANDLE, dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn WaitForMultipleObjects(nCount: DWORD, lpHandles: [*c]const HANDLE, bWaitAll: BOOL, dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn WaitForSingleObjectEx(hHandle: HANDLE, dwMilliseconds: DWORD, bAlertable: BOOL) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn WaitForMultipleObjectsEx(nCount: DWORD, lpHandles: [*c]const HANDLE, bWaitAll: BOOL, dwMilliseconds: DWORD, bAlertable: BOOL) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const PTHREAD_START_ROUTINE = ?*const fn (LPVOID) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const LPTHREAD_START_ROUTINE = PTHREAD_START_ROUTINE;
pub extern fn CreateThread(lpThreadAttributes: LPSECURITY_ATTRIBUTES, dwStackSize: SIZE_T, lpStartAddress: LPTHREAD_START_ROUTINE, lpParameter: LPVOID, dwCreationFlags: DWORD, lpThreadId: LPDWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetCurrentThread() callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetCurrentThreadId() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetThreadAffinityMask(hThread: HANDLE, dwThreadAffinityMask: DWORD_PTR) callconv(@import("std").os.windows.WINAPI) DWORD_PTR;
pub extern fn OpenThread(dwDesiredAccess: DWORD, bInheritHandle: BOOL, dwThreadId: DWORD) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn SuspendThread(hThread: HANDLE) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn ResumeThread(hThread: HANDLE) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn ExitThread(dwExitCode: DWORD) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn GetProcessAffinityMask(hProcess: HANDLE, lpProcessAffinityMask: PDWORD_PTR, lpSystemAffinityMask: PDWORD_PTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetProcessAffinityMask(hProcess: HANDLE, dwProcessAffinityMask: DWORD_PTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SwitchToThread() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InitializeCriticalSection(lpCriticalSection: LPCRITICAL_SECTION) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn InitializeCriticalSectionAndSpinCount(lpCriticalSection: LPCRITICAL_SECTION, dwSpinCount: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetCriticalSectionSpinCount(lpCriticalSection: LPCRITICAL_SECTION, dwSpinCount: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn EnterCriticalSection(lpCriticalSection: LPCRITICAL_SECTION) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn TryEnterCriticalSection(lpCriticalSection: LPCRITICAL_SECTION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LeaveCriticalSection(lpCriticalSection: LPCRITICAL_SECTION) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn DeleteCriticalSection(lpCriticalSection: LPCRITICAL_SECTION) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn InitializeConditionVariable(ConditionVariable: PCONDITION_VARIABLE) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn SleepConditionVariableCS(ConditionVariable: PCONDITION_VARIABLE, CriticalSection: PCRITICAL_SECTION, dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WakeAllConditionVariable(ConditionVariable: PCONDITION_VARIABLE) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn WakeConditionVariable(ConditionVariable: PCONDITION_VARIABLE) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn CreateMutexA(lpMutexAttributes: LPSECURITY_ATTRIBUTES, bInitialOwner: BOOL, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateMutexW(lpMutexAttributes: LPSECURITY_ATTRIBUTES, bInitialOwner: BOOL, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn ReleaseMutex(hMutex: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateSemaphoreA(lpSemaphoreAttributes: LPSECURITY_ATTRIBUTES, lInitialCount: LONG, lMaximumCount: LONG, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateSemaphoreW(lpSemaphoreAttributes: LPSECURITY_ATTRIBUTES, lInitialCount: LONG, lMaximumCount: LONG, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn ReleaseSemaphore(hSemaphore: HANDLE, lReleaseCount: LONG, lpPreviousCount: LPLONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn OpenSemaphoreA(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn OpenSemaphoreW(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn TlsAlloc() callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn TlsSetValue(dwTlsIndex: DWORD, lpTlsValue: LPVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn TlsGetValue(dwTlsIndex: DWORD) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn TlsFree(dwTlsIndex: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const PFLS_CALLBACK_FUNCTION = ?*const fn (PVOID) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn FlsAlloc(lpCallback: PFLS_CALLBACK_FUNCTION) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn FlsFree(dwFlsIndex: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlsSetValue(dwFlsIndex: DWORD, lpFlsData: PVOID) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlsGetValue(dwFlsIndex: DWORD) callconv(@import("std").os.windows.WINAPI) PVOID;
pub extern fn InitializeSRWLock(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn AcquireSRWLockExclusive(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn AcquireSRWLockShared(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn ReleaseSRWLockExclusive(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn ReleaseSRWLockShared(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn TryAcquireSRWLockExclusive(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn TryAcquireSRWLockShared(SRWLock: PSRWLOCK) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SleepConditionVariableSRW(ConditionVariable: PCONDITION_VARIABLE, SRWLock: PSRWLOCK, dwMilliseconds: DWORD, Flags: ULONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WaitOnAddress(Address: ?*volatile anyopaque, CompareAddress: PVOID, AddressSize: SIZE_T, dwMilliseconds: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WakeByAddressSingle(Address: PVOID) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn WakeByAddressAll(Address: PVOID) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn CreateEvent(lpEventAttributes: LPSECURITY_ATTRIBUTES, bManualReset: BOOL, bInitialState: BOOL, lpName: LPCTSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn OpenEvent(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCTSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn SetEvent(hEvent: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ResetEvent(hEvent: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct__RECT = extern struct {
    left: LONG = @import("std").mem.zeroes(LONG),
    top: LONG = @import("std").mem.zeroes(LONG),
    right: LONG = @import("std").mem.zeroes(LONG),
    bottom: LONG = @import("std").mem.zeroes(LONG),
};

pub const RDW_INVALIDATE: DWORD = 0x0001;
pub const RDW_INTERNALPAINT: DWORD = 0x0002;
pub const RDW_ERASE: DWORD = 0x0004;

pub const RDW_VALIDATE: DWORD = 0x0008;
pub const RDW_NOINTERNALPAINT: DWORD = 0x0010;
pub const RDW_NOERASE: DWORD = 0x0020;

pub const RDW_NOCHILDREN: DWORD = 0x0040;
pub const RDW_ALLCHILDREN: DWORD = 0x0080;

pub const RDW_UPDATENOW: DWORD = 0x0100;
pub const RDW_ERASENOW: DWORD = 0x0200;

pub const RDW_FRAME: DWORD = 0x0400;
pub const RDW_NOFRAME: DWORD = 0x0800;

pub const RECT = struct__RECT;
pub const PRECT = [*c]struct__RECT;
pub const LPRECT = [*c]struct__RECT;
pub const WNDPROC = ?*const fn (HWND, UINT, WPARAM, LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub const struct_tagWNDCLASS = extern struct {
    style: UINT = @import("std").mem.zeroes(UINT),
    lpfnWndProc: WNDPROC = @import("std").mem.zeroes(WNDPROC),
    cbClsExtra: c_int = @import("std").mem.zeroes(c_int),
    cbWndExtra: c_int = @import("std").mem.zeroes(c_int),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    hIcon: HICON = @import("std").mem.zeroes(HICON),
    hCursor: HCURSOR = @import("std").mem.zeroes(HCURSOR),
    hbrBackground: HBRUSH = @import("std").mem.zeroes(HBRUSH),
    lpszMenuName: LPCTSTR = @import("std").mem.zeroes(LPCTSTR),
    lpszClassName: LPCTSTR = @import("std").mem.zeroes(LPCTSTR),
};
pub const WNDCLASS = struct_tagWNDCLASS;
pub const WNDCLASSA = WNDCLASS;
pub const PWNDCLASS = [*c]struct_tagWNDCLASS;
pub const PWNDCLASSA = [*c]struct_tagWNDCLASS;
pub const POINT = extern struct {
    x: LONG = @import("std").mem.zeroes(LONG),
    y: LONG = @import("std").mem.zeroes(LONG),
};
pub const PPOINT = [*c]POINT;
pub const LPPOINT = [*c]POINT;
pub const MSG = extern struct {
    hwnd: HWND = @import("std").mem.zeroes(HWND),
    message: UINT = @import("std").mem.zeroes(UINT),
    wParam: WPARAM = @import("std").mem.zeroes(WPARAM),
    lParam: LPARAM = @import("std").mem.zeroes(LPARAM),
    time: DWORD = @import("std").mem.zeroes(DWORD),
    pt: POINT = @import("std").mem.zeroes(POINT),
};
pub const PMSG = [*c]MSG;
pub const LPMSG = [*c]MSG;
pub extern fn MessageBoxA(hWND: HWND, lpText: LPCSTR, lpCaption: LPCSTR, uType: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn MessageBoxW(hWND: HWND, lpText: LPCWSTR, lpCaption: LPCWSTR, uType: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn RegisterClassA(lpWndClass: ?*WNDCLASS) callconv(@import("std").os.windows.WINAPI) ATOM;
pub extern fn RegisterClassW(lpWndClass: ?*WNDCLASS) callconv(@import("std").os.windows.WINAPI) ATOM;
pub extern fn UnregisterClassA(lpClassName: LPCSTR, hInstance: HINSTANCE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn UnregisterClassW(lpClassName: LPCWSTR, hInstance: HINSTANCE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateWindowExA(dwExStyle: DWORD, lpClassName: LPCSTR, lpWindowName: LPCSTR, dwStyle: DWORD, x: c_int, y: c_int, nWidth: c_int, nHeight: c_int, hWndParent: HWND, hMenu: HMENU, hInstance: HINSTANCE, lpParam: LPVOID) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn CreateWindowExW(dwExStyle: DWORD, lpClassName: LPCWSTR, lpWindowName: LPCWSTR, dwStyle: DWORD, x: c_int, y: c_int, nWidth: c_int, nHeight: c_int, hWndParent: HWND, hMenu: HMENU, hInstance: HINSTANCE, lpParam: LPVOID) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn ShowWindow(hWnd: HWND, nCmdShow: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn UpdateWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DefWindowProcA(hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn DefWindowProcW(hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn DestroyWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AdjustWindowRectEx(lpRect: LPRECT, dwStyle: DWORD, bMenu: BOOL, dwExStyle: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClientRect(hWnd: HWND, lpRect: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetSystemMetrics(nIndex: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn PeekMessageA(lpMsg: LPMSG, hWnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT, wRemoveMsg: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PeekMessageW(lpMsg: LPMSG, hWnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT, wRemoveMsg: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn TranslateMessage(lpMsg: [*c]const MSG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DispatchMessageA(lpMsg: [*c]const MSG) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn DispatchMessageW(lpMsg: [*c]const MSG) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn PostQuitMessage(nExitCode: c_int) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn CreateEventA(lpEventAttributes: LPSECURITY_ATTRIBUTES, bManualReset: BOOL, bInitialState: BOOL, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn CreateEventW(lpEventAttributes: LPSECURITY_ATTRIBUTES, bManualReset: BOOL, bInitialState: BOOL, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn OpenEventA(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn OpenEventW(dwDesiredAccess: DWORD, bInheritHandle: BOOL, lpName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetKeyState(nVirtKey: c_int) callconv(@import("std").os.windows.WINAPI) SHORT;
pub const PFIBER_START_ROUTINE = ?*const fn (LPVOID) callconv(@import("std").os.windows.WINAPI) void;
pub const LPFIBER_START_ROUTINE = PFIBER_START_ROUTINE;
pub extern fn IsThreadAFiber() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SwitchToFiber(lpFiber: LPVOID) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn DeleteFiber(lpFiber: LPVOID) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn ConvertFiberToThread() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateFiber(dwStackSize: SIZE_T, lpStartAddress: LPFIBER_START_ROUTINE, lpParameter: LPVOID) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn CreateFiberEx(dwStackCommitSize: SIZE_T, dwStackReserveSize: SIZE_T, dwFlags: DWORD, lpStartAddress: LPFIBER_START_ROUTINE, lpParameter: LPVOID) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn ConvertThreadToFiber(lpParameter: LPVOID) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub extern fn ConvertThreadToFiberEx(lpParameter: LPVOID, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) LPVOID;
pub const _INC_WINDOWS = "";
pub const WINDOWS_H = "";
pub const __int64 = c_longlong;
pub const WINDOWS_BASE_H = "";
pub const _WIN32_WINNT = @as(c_int, 0x0600);
pub const TRUE = @as(c_int, 1);
pub const FALSE = @as(c_int, 0);
pub inline fn TEXT(x: anytype) @TypeOf(x) {
    _ = &x;
    return x;
}
pub const PATH_MAX = @as(c_int, 260);
pub const MAX_PATH = @as(c_int, 260);
pub inline fn MAKEWORD(a: anytype, b: anytype) WORD {
    return @as(WORD, @intCast((a & 0xff) | ((b & 0xff) << 8)));
}
pub inline fn MAKELONG(a: anytype, b: anytype) LONG {
    return @as(LONG, @intCast((a & 0xffff) | ((b & 0xffff) << 16)));
}
pub inline fn HIWORD(l: anytype) WORD {
    return @as(WORD, @intCast((l >> 16) & 0xffff));
}
pub inline fn LOWORD(l: anytype) WORD {
    return @as(WORD, @intCast(l & 0xffff));
}
pub inline fn HIBYTE(l: anytype) BYTE {
    return @as(BYTE, @intCast((l >> 8) & 0xff));
}
pub inline fn LOBYTE(l: anytype) BYTE {
    return @as(BYTE, @intCast(l & 0xff));
}

pub inline fn GET_WHEEL_DELTA_WPARAM(l: anytype) SHORT {
    return @bitCast(HIWORD(l));
}
pub inline fn GET_X_LPARAM(l: anytype) INT {
    return @intCast(LOWORD(l));
}
pub inline fn GET_Y_LPARAM(l: anytype) INT {
    return @intCast(HIWORD(l));
}

pub const MINCHAR = @as(c_int, 0x80);
pub const MAXCHAR = @as(c_int, 0x7f);
pub const MINSHORT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8000, .hex);
pub const MAXSHORT = @as(c_int, 0x7fff);
pub const MINLONG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex);
pub const MAXLONG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x7fffffff, .hex);
pub const MAXBYTE = @as(c_int, 0xff);
pub const MAXWORD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffff, .hex);
pub const MAXDWORD = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hex);
pub const ERROR_SUCCESS = @as(c_long, 0);
pub const ERROR_FILE_NOT_FOUND = @as(c_long, 2);
pub const ERROR_PATH_NOT_FOUND = @as(c_long, 3);
pub const ERROR_TOO_MANY_OPEN_FILES = @as(c_long, 4);
pub const ERROR_ACCESS_DENIED = @as(c_long, 5);
pub const ERROR_NO_MORE_FILES = @as(c_long, 18);
pub const ERROR_SHARING_VIOLATION = @as(c_long, 32);
pub const ERROR_FILE_EXISTS = @as(c_long, 80);
pub const ERROR_INSUFFICIENT_BUFFER = @as(c_long, 122);
pub const ERROR_ALREADY_EXISTS = @as(c_long, 183);
pub const ERROR_MORE_DATA = @as(c_long, 234);
pub const DLL_PROCESS_ATTACH = @as(c_int, 1);
pub const DLL_PROCESS_DETACH = @as(c_int, 0);
pub const DLL_THREAD_ATTACH = @as(c_int, 2);
pub const DLL_THREAD_DETACH = @as(c_int, 3);
pub const WINDOWS_ATOMIC_H = "";
pub const WINDOWS_INTRIN_H = "";
pub const InterlockedExchange8 = _InterlockedExchange8;
pub const InterlockedExchangeAdd8 = _InterlockedExchangeAdd8;
pub const InterlockedExchangeAnd8 = _InterlockedExchangeAnd8;
pub const InterlockedExchangeOr8 = _InterlockedExchangeOr8;
pub const InterlockedExchangeXor8 = _InterlockedExchangeXor8;
pub const InterlockedDecrement8 = _InterlockedDecrement8;
pub const InterlockedIncrement8 = _InterlockedIncrement8;
pub const InterlockedCompareExchange8 = _InterlockedCompareExchange8;
pub const InterlockedExchange16 = _InterlockedExchange16;
pub const InterlockedExchangeAdd16 = _InterlockedExchangeAdd16;
pub const InterlockedExchangeAnd16 = _InterlockedExchangeAnd16;
pub const InterlockedExchangeOr16 = _InterlockedExchangeOr16;
pub const InterlockedExchangeXor16 = _InterlockedExchangeXor16;
pub const InterlockedDecrement16 = _InterlockedDecrement16;
pub const InterlockedIncrement16 = _InterlockedIncrement16;
pub const InterlockedCompareExchange16 = _InterlockedCompareExchange16;
pub const InterlockedExchange = _InterlockedExchange;
pub const InterlockedExchangeAdd = _InterlockedExchangeAdd;
pub const InterlockedExchangeAnd = _InterlockedExchangeAnd;
pub const InterlockedExchangeOr = _InterlockedExchangeOr;
pub const InterlockedExchangeXor = _InterlockedExchangeXor;
pub const InterlockedDecrement = _InterlockedDecrement;
pub const InterlockedIncrement = _InterlockedIncrement;
pub const InterlockedCompareExchange = _InterlockedCompareExchange;
pub const WINDOWS_DBGHELP_H = "";
pub const EXCEPTION_MAXIMUM_PARAMETERS = @as(c_int, 15);
pub const EXCEPTION_EXECUTE_HANDLER = @as(c_int, 0x1);
pub const EXCEPTION_CONTINUE_EXECUTION = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex);
pub const EXCEPTION_CONTINUE_SEARCH = @as(c_int, 0x0);
pub const EXCEPTION_ACCESS_VIOLATION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000005, .hex));
pub const EXCEPTION_DATATYPE_MISALIGNMENT = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000002, .hex));
pub const EXCEPTION_BREAKPOINT = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000003, .hex));
pub const EXCEPTION_SINGLE_STEP = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000004, .hex));
pub const EXCEPTION_ARRAY_BOUNDS_EXCEEDED = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000008C, .hex));
pub const EXCEPTION_FLT_DENORMAL_OPERAND = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000008D, .hex));
pub const EXCEPTION_FLT_DIVIDE_BY_ZERO = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000008E, .hex));
pub const EXCEPTION_FLT_INEXACT_RESULT = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000008F, .hex));
pub const EXCEPTION_FLT_INVALID_OPERATION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000090, .hex));
pub const EXCEPTION_FLT_OVERFLOW = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000091, .hex));
pub const EXCEPTION_FLT_STACK_CHECK = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000092, .hex));
pub const EXCEPTION_FLT_UNDERFLOW = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000093, .hex));
pub const EXCEPTION_INT_DIVIDE_BY_ZERO = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000094, .hex));
pub const EXCEPTION_INT_OVERFLOW = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000095, .hex));
pub const EXCEPTION_PRIV_INSTRUCTION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000096, .hex));
pub const EXCEPTION_IN_PAGE_ERROR = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000006, .hex));
pub const EXCEPTION_STACK_OVERFLOW = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC00000FD, .hex));
pub const EXCEPTION_ILLEGAL_INSTRUCTION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000001D, .hex));
pub const EXCEPTION_NONCONTINUABLE_EXCEPTION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000025, .hex));
pub const EXCEPTION_INVALID_DISPOSITION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000026, .hex));
pub const EXCEPTION_GUARD_PAGE = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000001, .hex));
pub const EXCEPTION_INVALID_HANDLE = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000008, .hex));
pub const EXCEPTION_POSSIBLE_DEADLOCK = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC0000194, .hex));
pub const CONTROL_C_EXIT = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xC000013A, .hex));
pub const EXCEPTION_ASSERTION = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_long, 0xEF000001, .hex));
pub const TH32CS_SNAPTHREAD = @as(c_int, 0x00000004);
pub const IMAGE_FILE_MACHINE_I386 = @as(c_int, 0x014c);
pub const IMAGE_FILE_MACHINE_AMD64 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8664, .hex);
pub const CONTEXT_AMD64 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x100000, .hex);
pub const CONTEXT_CONTROL = CONTEXT_AMD64 | @as(c_long, 0x1);
pub const CONTEXT_INTEGER = CONTEXT_AMD64 | @as(c_long, 0x2);
pub const CONTEXT_SEGMENTS = CONTEXT_AMD64 | @as(c_long, 0x4);
pub const CONTEXT_FLOATING_POINT = CONTEXT_AMD64 | @as(c_long, 0x8);
pub const CONTEXT_DEBUG_REGISTERS = CONTEXT_AMD64 | @as(c_long, 0x10);
pub const CONTEXT_FULL = (CONTEXT_CONTROL | CONTEXT_INTEGER) | CONTEXT_FLOATING_POINT;
pub const CONTEXT_ALL = (((CONTEXT_CONTROL | CONTEXT_INTEGER) | CONTEXT_SEGMENTS) | CONTEXT_FLOATING_POINT) | CONTEXT_DEBUG_REGISTERS;
pub const SYMOPT_CASE_INSENSITIVE = @as(c_int, 0x00000001);
pub const SYMOPT_UNDNAME = @as(c_int, 0x00000002);
pub const SYMOPT_DEFERRED_LOADS = @as(c_int, 0x00000004);
pub const SYMOPT_NO_CPP = @as(c_int, 0x00000008);
pub const SYMOPT_LOAD_LINES = @as(c_int, 0x00000010);
pub const SYMOPT_OMAP_FIND_NEAREST = @as(c_int, 0x00000020);
pub const SYMOPT_LOAD_ANYTHING = @as(c_int, 0x00000040);
pub const SYMOPT_IGNORE_CVREC = @as(c_int, 0x00000080);
pub const SYMOPT_NO_UNQUALIFIED_LOADS = @as(c_int, 0x00000100);
pub const SYMOPT_FAIL_CRITICAL_ERRORS = @as(c_int, 0x00000200);
pub const SYMOPT_EXACT_SYMBOLS = @as(c_int, 0x00000400);
pub const SYMOPT_ALLOW_ABSOLUTE_SYMBOLS = @as(c_int, 0x00000800);
pub const SYMOPT_IGNORE_NT_SYMPATH = @as(c_int, 0x00001000);
pub const SYMOPT_INCLUDE_32BIT_MODULES = @as(c_int, 0x00002000);
pub const SYMOPT_PUBLICS_ONLY = @as(c_int, 0x00004000);
pub const SYMOPT_NO_PUBLICS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00008000, .hex);
pub const SYMOPT_AUTO_PUBLICS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00010000, .hex);
pub const SYMOPT_NO_IMAGE_SEARCH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020000, .hex);
pub const SYMOPT_SECURE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00040000, .hex);
pub const SYMOPT_NO_PROMPTS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00080000, .hex);
pub const SYMOPT_OVERWRITE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00100000, .hex);
pub const SYMOPT_IGNORE_IMAGEDIR = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00200000, .hex);
pub const SYMOPT_FLAT_DIRECTORY = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00400000, .hex);
pub const SYMOPT_FAVOR_COMPRESSED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00800000, .hex);
pub const SYMOPT_ALLOW_ZERO_ADDRESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x01000000, .hex);
pub const SYMOPT_DISABLE_SYMSRV_AUTODETECT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x02000000, .hex);
pub const SYMOPT_DEBUG = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex);
pub const CaptureStackBackTrace = RtlCaptureStackBackTrace;
pub const WINDOWS_DDS_H = "";
pub const DXGI_FORMAT_DEFINED = @as(c_int, 1);
pub const FOURCC_DDS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x20534444, .hex);
pub const DDPF_FOURCC = @as(c_int, 0x00000004);
pub const FMT_DX10 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x30315844, .hex);
pub const FMT_DXT1 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x31545844, .hex);
pub const FMT_DXT3 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x33545844, .hex);
pub const FMT_DXT5 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x35545844, .hex);
pub const DDSD_CAPS = @as(c_int, 0x00000001);
pub const DDSD_HEIGHT = @as(c_int, 0x00000002);
pub const DDSD_WIDTH = @as(c_int, 0x00000004);
pub const DDSD_PITCH = @as(c_int, 0x00000008);
pub const DDSD_PIXELFORMAT = @as(c_int, 0x00001000);
pub const DDSD_MIPMAPCOUNT = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00020000, .hex);
pub const DDSD_LINEARSIZE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00080000, .hex);
pub const DDSD_DEPTH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00800000, .hex);
pub const DDSCAPS_COMPLEX = @as(c_int, 0x00000008);
pub const DDSCAPS_MIPMAP = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x04000000, .hex);
pub const DDSCAPS_TEXTURE = @as(c_int, 0x00001000);
pub const BLOCKSIZE_DXT1 = @as(c_int, 0x8);
pub const BLOCKSIZE_DXT3 = @as(c_int, 0x10);
pub const BLOCKSIZE_DXT5 = @as(c_int, 0x10);
pub const WINDOWS_FILE_H = "";
pub const FILE_SHARE_DELETE = @as(c_int, 0x00000004);
pub const FILE_SHARE_READ = @as(c_int, 0x00000001);
pub const FILE_SHARE_WRITE = @as(c_int, 0x00000002);
pub const GENERIC_READ = @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000000, .hex);
pub const GENERIC_WRITE = @as(c_long, 0x40000000);
pub const GENERIC_EXECUTE = @as(c_long, 0x20000000);
pub const GENERIC_ALL = @as(c_long, 0x10000000);
pub const DELETE = @as(c_long, 0x00010000);
pub const READ_CONTROL = @as(c_long, 0x00020000);
pub const WRITE_DAC = @as(c_long, 0x00040000);
pub const WRITE_OWNER = @as(c_long, 0x00080000);
pub const SYNCHRONIZE = @as(c_long, 0x00100000);
pub const STANDARD_RIGHTS_REQUIRED = @as(c_long, 0x000F0000);
pub const STANDARD_RIGHTS_READ = READ_CONTROL;
pub const STANDARD_RIGHTS_WRITE = READ_CONTROL;
pub const STANDARD_RIGHTS_EXECUTE = READ_CONTROL;
pub const STANDARD_RIGHTS_ALL = @as(c_long, 0x001F0000);
pub const SPECIFIC_RIGHTS_ALL = @as(c_long, 0x0000FFFF);
pub const FILE_READ_DATA = @as(c_int, 0x0001);
pub const FILE_LIST_DIRECTORY = @as(c_int, 0x0001);
pub const FILE_WRITE_DATA = @as(c_int, 0x0002);
pub const FILE_ADD_FILE = @as(c_int, 0x0002);
pub const FILE_APPEND_DATA = @as(c_int, 0x0004);
pub const FILE_ADD_SUBDIRECTORY = @as(c_int, 0x0004);
pub const FILE_CREATE_PIPE_INSTANCE = @as(c_int, 0x0004);
pub const FILE_READ_EA = @as(c_int, 0x0008);
pub const FILE_WRITE_EA = @as(c_int, 0x0010);
pub const FILE_EXECUTE = @as(c_int, 0x0020);
pub const FILE_TRAVERSE = @as(c_int, 0x0020);
pub const FILE_DELETE_CHILD = @as(c_int, 0x0040);
pub const FILE_READ_ATTRIBUTES = @as(c_int, 0x0080);
pub const FILE_WRITE_ATTRIBUTES = @as(c_int, 0x0100);
pub const FILE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE) | @as(c_int, 0x1FF);
pub const FILE_GENERIC_READ = (((STANDARD_RIGHTS_READ | FILE_READ_DATA) | FILE_READ_ATTRIBUTES) | FILE_READ_EA) | SYNCHRONIZE;
pub const FILE_GENERIC_WRITE = ((((STANDARD_RIGHTS_WRITE | FILE_WRITE_DATA) | FILE_WRITE_ATTRIBUTES) | FILE_WRITE_EA) | FILE_APPEND_DATA) | SYNCHRONIZE;
pub const FILE_GENERIC_EXECUTE = ((STANDARD_RIGHTS_EXECUTE | FILE_READ_ATTRIBUTES) | FILE_EXECUTE) | SYNCHRONIZE;
pub const CREATE_ALWAYS = @as(c_int, 2);
pub const CREATE_NEW = @as(c_int, 1);
pub const OPEN_ALWAYS = @as(c_int, 4);
pub const OPEN_EXISTING = @as(c_int, 3);
pub const TRUNCATE_EXISTING = @as(c_int, 5);
pub const INVALID_FILE_ATTRIBUTES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hex);
pub const FILE_ATTRIBUTE_HIDDEN = @as(c_int, 0x2);
pub const FILE_ATTRIBUTE_NORMAL = @as(c_int, 0x80);
pub const FILE_ATTRIBUTE_DIRECTORY = @as(c_int, 0x10);
pub const FILE_ATTRIBUTE_TEMPORARY = @as(c_int, 0x100);
pub const FILE_ATTRIBUTE_REPARSE_POINT = @as(c_int, 0x400);
pub const FILE_BEGIN = @as(c_int, 0);
pub const FILE_CURRENT = @as(c_int, 1);
pub const FILE_END = @as(c_int, 2);
pub const SECTION_QUERY = @as(c_int, 0x0001);
pub const SECTION_MAP_WRITE = @as(c_int, 0x0002);
pub const SECTION_MAP_READ = @as(c_int, 0x0004);
pub const SECTION_MAP_EXECUTE = @as(c_int, 0x0008);
pub const SECTION_EXTEND_SIZE = @as(c_int, 0x0010);
pub const SECTION_MAP_EXECUTE_EXPLICIT = @as(c_int, 0x0020);
pub const SECTION_ALL_ACCESS = ((((STANDARD_RIGHTS_REQUIRED | SECTION_QUERY) | SECTION_MAP_WRITE) | SECTION_MAP_READ) | SECTION_MAP_EXECUTE) | SECTION_EXTEND_SIZE;
pub const FILE_MAP_COPY = SECTION_QUERY;
pub const FILE_MAP_WRITE = SECTION_MAP_WRITE;
pub const FILE_MAP_READ = SECTION_MAP_READ;
pub const FILE_MAP_ALL_ACCESS = SECTION_ALL_ACCESS;
pub const FILE_MAP_EXECUTE = SECTION_MAP_EXECUTE_EXPLICIT;
pub const PAGE_EXECUTE_READ = @as(c_int, 0x20);
pub const PAGE_EXECUTE_READWRITE = @as(c_int, 0x40);
pub const PAGE_EXECUTE_WRITECOPY = @as(c_int, 0x80);
pub const PAGE_READONLY = @as(c_int, 0x02);
pub const PAGE_READWRITE = @as(c_int, 0x04);
pub const PAGE_WRITECOPY = @as(c_int, 0x08);
pub const FILE_NOTIFY_CHANGE_FILE_NAME = @as(c_int, 0x00000001);
pub const FILE_NOTIFY_CHANGE_DIR_NAME = @as(c_int, 0x00000002);
pub const FILE_NOTIFY_CHANGE_ATTRIBUTES = @as(c_int, 0x00000004);
pub const FILE_NOTIFY_CHANGE_SIZE = @as(c_int, 0x00000008);
pub const FILE_NOTIFY_CHANGE_LAST_WRITE = @as(c_int, 0x00000010);
pub const FILE_NOTIFY_CHANGE_SECURITY = @as(c_int, 0x00000100);
pub const FILE_TYPE_UNKNOWN = @as(c_int, 0x0000);
pub const FILE_TYPE_DISK = @as(c_int, 0x0001);
pub const FILE_TYPE_CHAR = @as(c_int, 0x0002);
pub const FILE_TYPE_PIPE = @as(c_int, 0x0003);
pub const FILE_TYPE_REMOTE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8000, .hex);
pub const MOVEFILE_COPY_ALLOWED = @as(c_int, 0x2);
pub const MOVEFILE_REPLACE_EXISTING = @as(c_int, 0x1);
pub const WINDOWS_GDI_H = "";
pub const BLACK_BRUSH = @as(c_int, 4);
pub inline fn MAKEINTRESOURCE(res: anytype) ULONG_PTR {
    _ = &res;
    return @import("std").zig.c_translation.cast(ULONG_PTR, @import("std").zig.c_translation.cast(USHORT, res));
}
pub const IDI_APPLICATION = MAKEINTRESOURCE(@as(c_int, 32512));
pub const IDC_ARROW = MAKEINTRESOURCE(@as(c_int, 32512));
pub const WINDOWS_IO_H = "";
pub const STD_INPUT_HANDLE = @import("std").zig.c_translation.cast(DWORD, -@as(c_int, 10));
pub const STD_OUTPUT_HANDLE = @import("std").zig.c_translation.cast(DWORD, -@as(c_int, 11));
pub const STD_ERROR_HANDLE = @import("std").zig.c_translation.cast(DWORD, -@as(c_int, 12));
pub const INVALID_HANDLE_VALUE = @import("std").zig.c_translation.cast(HANDLE, @import("std").zig.c_translation.cast(LONG_PTR, -@as(c_int, 1)));
pub const ATTACH_PARENT_PROCESS = @import("std").zig.c_translation.cast(DWORD, -@as(c_int, 1));
pub const HANDLE_FLAG_INHERIT = @as(c_int, 0x00000001);
pub const HANDLE_FLAG_PROTECT_FROM_CLOSE = @as(c_int, 0x00000002);
pub const FOREGROUND_BLUE = @as(c_int, 0x0001);
pub const FOREGROUND_GREEN = @as(c_int, 0x0002);
pub const FOREGROUND_RED = @as(c_int, 0x0004);
pub const FOREGROUND_INTENSITY = @as(c_int, 0x0008);
pub const BACKGROUND_BLUE = @as(c_int, 0x0010);
pub const BACKGROUND_GREEN = @as(c_int, 0x0020);
pub const BACKGROUND_RED = @as(c_int, 0x0040);
pub const BACKGROUND_INTENSITY = @as(c_int, 0x0080);
pub const CTRL_C_EVENT = @as(c_int, 0x0);
pub const CTRL_BREAK_EVENT = @as(c_int, 0x1);
pub const CTRL_CLOSE_EVENT = @as(c_int, 0x2);
pub const CTRL_LOGOFF_EVENT = @as(c_int, 0x5);
pub const CTRL_SHUTDOWN_EVENT = @as(c_int, 0x6);
pub const HEAP_NO_SERIALIZE = @as(c_int, 0x00000001);
pub const HEAP_ZERO_MEMORY = @as(c_int, 0x00000008);
pub const HEAP_REALLOC_IN_PLACE_ONLY = @as(c_int, 0x00000010);
pub const MEM_COMMIT = @as(c_int, 0x00001000);
pub const MEM_RESERVE = @as(c_int, 0x00002000);
pub const MEM_RESET = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00080000, .hex);
pub const MEM_RESET_UNDO = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x01000000, .hex);
pub const MEM_LARGE_PAGES = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x20000000, .hex);
pub const MEM_PHYSICAL = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00400000, .hex);
pub const MEM_TOP_DOWN = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00100000, .hex);
pub const MEM_WRITE_WATCH = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x00200000, .hex);
pub const PAGE_EXECUTE = @as(c_int, 0x10);
pub const PAGE_NOACCESS = @as(c_int, 0x01);
pub const PAGE_TARGETS_INVALID = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x40000000, .hex);
pub const PAGE_TARGETS_NO_UPDATE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x40000000, .hex);
pub const PAGE_GUARD = @as(c_int, 0x100);
pub const PAGE_NOCACHE = @as(c_int, 0x200);
pub const PAGE_WRITECOMBINE = @as(c_int, 0x400);
pub const MEM_DECOMMIT = @as(c_int, 0x4000);
pub const MEM_RELEASE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x8000, .hex);
pub const MEM_FREE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x10000, .hex);
pub const MEM_IMAGE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1000000, .hex);
pub const MEM_MAPPED = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x40000, .hex);
pub const MEM_PRIVATE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x20000, .hex);
pub const GetCommandLine = GetCommandLineA;
pub const TIMERR_BASE = @as(c_int, 96);
pub const TIMERR_NOERROR = @as(c_int, 0);
pub const TIMERR_NOCANDO = TIMERR_BASE + @as(c_int, 1);
pub const TIMERR_STRUCT = TIMERR_BASE + @as(c_int, 33);
pub const CP_INSTALLED = @as(c_int, 0x00000001);
pub const CP_SUPPORTED = @as(c_int, 0x00000002);
pub const CP_ACP = @as(c_int, 0);
pub const CP_OEMCP = @as(c_int, 1);
pub const CP_MACCP = @as(c_int, 2);
pub const CP_THREAD_ACP = @as(c_int, 3);
pub const CP_SYMBOL = @as(c_int, 42);
pub const CP_UTF7 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65000, .decimal);
pub const CP_UTF8 = @import("std").zig.c_translation.promoteIntLiteral(c_int, 65001, .decimal);
pub const FORMAT_MESSAGE_ALLOCATE_BUFFER = @as(c_int, 0x00000100);
pub const FORMAT_MESSAGE_ARGUMENT_ARRAY = @as(c_int, 0x00002000);
pub const FORMAT_MESSAGE_FROM_SYSTEM = @as(c_int, 0x00001000);
pub const FORMAT_MESSAGE_IGNORE_INSERTS = @as(c_int, 0x00000200);
pub const FORMAT_MESSAGE_FROM_HMODULE = @as(c_int, 0x00000800);
pub const FORMAT_MESSAGE_FROM_STRING = @as(c_int, 0x00000400);
pub inline fn MAKELANGID(p: anytype, s: anytype) @TypeOf((@import("std").zig.c_translation.cast(WORD, s) << @as(c_int, 10)) | @import("std").zig.c_translation.cast(WORD, p)) {
    _ = &p;
    _ = &s;
    return (@import("std").zig.c_translation.cast(WORD, s) << @as(c_int, 10)) | @import("std").zig.c_translation.cast(WORD, p);
}
pub inline fn PRIMARYLANGID(lgid: anytype) @TypeOf(@import("std").zig.c_translation.cast(WORD, lgid) & @as(c_int, 0x3ff)) {
    _ = &lgid;
    return @import("std").zig.c_translation.cast(WORD, lgid) & @as(c_int, 0x3ff);
}
pub inline fn SUBLANGID(lgid: anytype) @TypeOf(@import("std").zig.c_translation.cast(WORD, lgid) >> @as(c_int, 10)) {
    _ = &lgid;
    return @import("std").zig.c_translation.cast(WORD, lgid) >> @as(c_int, 10);
}
pub const LANG_NEUTRAL = @as(c_int, 0x00);
pub const LANG_INVARIANT = @as(c_int, 0x7f);
pub const LANG_ENGLISH = @as(c_int, 0x09);
pub const LANG_GERMAN = @as(c_int, 0x07);
pub const SUBLANG_NEUTRAL = @as(c_int, 0x00);
pub const SUBLANG_DEFAULT = @as(c_int, 0x01);
pub const SUBLANG_SYS_DEFAULT = @as(c_int, 0x02);
pub const SUBLANG_CUSTOM_DEFAULT = @as(c_int, 0x03);
pub const SUBLANG_CUSTOM_UNSPECIFIED = @as(c_int, 0x04);
pub const SUBLANG_UI_CUSTOM_DEFAULT = @as(c_int, 0x05);
pub const SUBLANG_ENGLISH_US = @as(c_int, 0x01);
pub const SUBLANG_ENGLISH_UK = @as(c_int, 0x02);
pub const SUBLANG_GERMAN = @as(c_int, 0x01);
pub const WINDOWS_PROCESS_H = "";
pub const INFINITE = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hex);
pub const PROCESS_DUP_HANDLE = @as(c_int, 0x0040);
pub const PROCESS_QUERY_INFORMATION = @as(c_int, 0x0400);
pub const PROCESS_SUSPEND_RESUME = @as(c_int, 0x0800);
pub const PROCESS_TERMINATE = @as(c_int, 0x0001);
pub const PROCESS_VM_READ = @as(c_int, 0x0010);
pub const PROCESS_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE) | @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFF, .hex);
pub const TOKEN_ASSIGN_PRIMARY = @as(c_int, 0x0001);
pub const TOKEN_DUPLICATE = @as(c_int, 0x0002);
pub const TOKEN_IMPERSONATE = @as(c_int, 0x0004);
pub const TOKEN_QUERY = @as(c_int, 0x0008);
pub const TOKEN_QUERY_SOURCE = @as(c_int, 0x0010);
pub const TOKEN_ADJUST_PRIVILEGES = @as(c_int, 0x0020);
pub const TOKEN_ADJUST_GROUPS = @as(c_int, 0x0040);
pub const TOKEN_ADJUST_DEFAULT = @as(c_int, 0x0080);
pub const TOKEN_ADJUST_SESSIONID = @as(c_int, 0x0100);
pub const TOKEN_ALL_ACCESS_P = (((((((STANDARD_RIGHTS_REQUIRED | TOKEN_ASSIGN_PRIMARY) | TOKEN_DUPLICATE) | TOKEN_IMPERSONATE) | TOKEN_QUERY) | TOKEN_QUERY_SOURCE) | TOKEN_ADJUST_PRIVILEGES) | TOKEN_ADJUST_GROUPS) | TOKEN_ADJUST_DEFAULT;
pub const SE_PRIVILEGE_ENABLED_BY_DEFAULT = @as(c_long, 0x00000001);
pub const SE_PRIVILEGE_ENABLED = @as(c_long, 0x00000002);
pub const SE_PRIVILEGE_REMOVED = @as(c_long, 0x00000004);
pub const SE_PRIVILEGE_USED_FOR_ACCESS = @import("std").zig.c_translation.promoteIntLiteral(c_long, 0x80000000, .hex);
pub const STATUS_WAIT_0 = @import("std").zig.c_translation.cast(DWORD, @as(c_long, 0x00000000));
pub const STATUS_TIMEOUT = @import("std").zig.c_translation.cast(DWORD, @as(c_long, 0x00000102));
pub const STATUS_PENDING = @import("std").zig.c_translation.cast(DWORD, @as(c_long, 0x00000103));
pub const STILL_ACTIVE = STATUS_PENDING;
pub const STARTF_USESHOWWINDOW = @as(c_int, 0x00000001);
pub const STARTF_USESIZE = @as(c_int, 0x00000002);
pub const STARTF_USEPOSITION = @as(c_int, 0x00000004);
pub const STARTF_USECOUNTCHARS = @as(c_int, 0x00000008);
pub const STARTF_USEFILLATTRIBUTE = @as(c_int, 0x00000010);
pub const STARTF_RUNFULLSCREEN = @as(c_int, 0x00000020);
pub const STARTF_FORCEONFEEDBACK = @as(c_int, 0x00000040);
pub const STARTF_FORCEOFFFEEDBACK = @as(c_int, 0x00000080);
pub const STARTF_USESTDHANDLES = @as(c_int, 0x00000100);
pub const NORMAL_PRIORITY_CLASS = @as(c_int, 0x00000020);
pub const JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE = @as(c_int, 0x00002000);
pub const WINDOWS_SYSINFO_H = "";
pub const DISPLAY_DEVICE_ACTIVE = @as(c_int, 0x00000001);
pub const DISPLAY_DEVICE_ATTACHED = @as(c_int, 0x00000002);
pub const DISPLAY_DEVICE_PRIMARY_DEVICE = @as(c_int, 0x00000004);
pub const SM_CXSCREEN = @as(c_int, 0);
pub const SM_CYSCREEN = @as(c_int, 1);
pub const SM_CMONITORS = @as(c_int, 80);
pub const VER_EQUAL = @as(c_int, 1);
pub const VER_GREATER = @as(c_int, 2);
pub const VER_GREATER_EQUAL = @as(c_int, 3);
pub const VER_LESS = @as(c_int, 4);
pub const VER_LESS_EQUAL = @as(c_int, 5);
pub const VER_AND = @as(c_int, 6);
pub const VER_OR = @as(c_int, 7);
pub const _WIN32_WINNT_WINXP = @as(c_int, 0x0501);
pub const _WIN32_WINNT_WS03 = @as(c_int, 0x0502);
pub const _WIN32_WINNT_VISTA = @as(c_int, 0x0600);
pub const _WIN32_WINNT_WS08 = @as(c_int, 0x0600);
pub const _WIN32_WINNT_WIN7 = @as(c_int, 0x0601);
pub const _WIN32_WINNT_WIN8 = @as(c_int, 0x0602);
pub const _WIN32_WINNT_WIN81 = @as(c_int, 0x0603);
pub const _WIN32_WINNT_WIN10 = @as(c_int, 0x0A00);
pub const VER_MINORVERSION = @as(c_int, 0x0000001);
pub const VER_MAJORVERSION = @as(c_int, 0x0000002);
pub const VER_BUILDNUMBER = @as(c_int, 0x0000004);
pub const VER_PLATFORMID = @as(c_int, 0x0000008);
pub const VER_SERVICEPACKMINOR = @as(c_int, 0x0000010);
pub const VER_SERVICEPACKMAJOR = @as(c_int, 0x0000020);
pub const HKEY_CLASSES_ROOT = @import("std").zig.c_translation.cast(HKEY, @import("std").zig.c_translation.cast(ULONG_PTR, @import("std").zig.c_translation.cast(LONG, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex))));
pub const HKEY_CURRENT_USER = @import("std").zig.c_translation.cast(HKEY, @import("std").zig.c_translation.cast(ULONG_PTR, @import("std").zig.c_translation.cast(LONG, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000001, .hex))));
pub const HKEY_LOCAL_MACHINE = @import("std").zig.c_translation.cast(HKEY, @import("std").zig.c_translation.cast(ULONG_PTR, @import("std").zig.c_translation.cast(LONG, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000002, .hex))));
pub const HKEY_USERS = @import("std").zig.c_translation.cast(HKEY, @import("std").zig.c_translation.cast(ULONG_PTR, @import("std").zig.c_translation.cast(LONG, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000003, .hex))));
pub const REG_NONE = @as(c_int, 0);
pub const REG_SZ = @as(c_int, 1);
pub const REG_EXPAND_SZ = @as(c_int, 2);
pub const REG_BINARY = @as(c_int, 3);
pub const REG_DWORD = @as(c_int, 4);
pub const REG_DWORD_LITTLE_ENDIAN = @as(c_int, 4);
pub const REG_DWORD_BIG_ENDIAN = @as(c_int, 5);
pub const REG_LINK = @as(c_int, 6);
pub const REG_MULTI_SZ = @as(c_int, 7);
pub const REG_RESOURCE_LIST = @as(c_int, 8);
pub const REG_FULL_RESOURCE_DESCRIPTOR = @as(c_int, 9);
pub const REG_RESOURCE_REQUIREMENTS_LIST = @as(c_int, 10);
pub const REG_QWORD = @as(c_int, 11);
pub const REG_QWORD_LITTLE_ENDIAN = @as(c_int, 11);
pub const KEY_QUERY_VALUE = @as(c_int, 0x0001);
pub const KEY_SET_VALUE = @as(c_int, 0x0002);
pub const KEY_CREATE_SUB_KEY = @as(c_int, 0x0004);
pub const KEY_ENUMERATE_SUB_KEYS = @as(c_int, 0x0008);
pub const KEY_NOTIFY = @as(c_int, 0x0010);
pub const KEY_CREATE_LINK = @as(c_int, 0x0020);
pub const KEY_WOW64_32KEY = @as(c_int, 0x0200);
pub const KEY_WOW64_64KEY = @as(c_int, 0x0100);
pub const KEY_WOW64_RES = @as(c_int, 0x0300);
pub const KEY_READ = (((STANDARD_RIGHTS_READ | KEY_QUERY_VALUE) | KEY_ENUMERATE_SUB_KEYS) | KEY_NOTIFY) & ~SYNCHRONIZE;
pub const KEY_WRITE = ((STANDARD_RIGHTS_WRITE | KEY_SET_VALUE) | KEY_CREATE_SUB_KEY) & ~SYNCHRONIZE;
pub const KEY_EXECUTE = KEY_READ & ~SYNCHRONIZE;
pub const KEY_ALL_ACCESS = ((((((STANDARD_RIGHTS_ALL | KEY_QUERY_VALUE) | KEY_SET_VALUE) | KEY_CREATE_SUB_KEY) | KEY_ENUMERATE_SUB_KEYS) | KEY_NOTIFY) | KEY_CREATE_LINK) & ~SYNCHRONIZE;
pub const ALL_PROCESSOR_GROUPS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffff, .hex);
pub const MAX_COMPUTERNAME_LENGTH = @as(c_int, 31);
pub const GREATER = IsWindowsVersionOrGreater;
pub const WINDOWS_THREADS_H = "";
pub const STATUS_ABANDONED_WAIT_0 = @import("std").zig.c_translation.cast(DWORD, @as(c_long, 0x00000080));
pub const WAIT_FAILED = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xffffffff, .hex));
pub const WAIT_OBJECT_0 = STATUS_WAIT_0 + @as(c_int, 0);
pub const WAIT_ABANDONED = STATUS_ABANDONED_WAIT_0 + @as(c_int, 0);
pub const WAIT_TIMEOUT = @as(c_long, 258);
pub const TLS_OUT_OF_INDEXES = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex));
pub const FLS_OUT_OF_INDEXES = @import("std").zig.c_translation.cast(DWORD, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFFFFFF, .hex));
pub const CREATE_NEW_CONSOLE = @as(c_int, 0x00000010);
pub const CREATE_NO_WINDOW = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x08000000, .hex);
pub const CREATE_SUSPENDED = @as(c_int, 0x00000004);
pub const DETACHED_PROCESS = @as(c_int, 0x00000008);
pub const THREAD_GET_CONTEXT = @as(c_int, 0x0008);
pub const THREAD_QUERY_INFORMATION = @as(c_int, 0x0040);
pub const THREAD_SUSPEND_RESUME = @as(c_int, 0x0002);
pub const THREAD_TERMINATE = @as(c_int, 0x0001);
pub const THREAD_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE) | @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xFFFF, .hex);
pub const SEMAPHORE_ALL_ACCESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1F0003, .hex);
pub const SEMAPHORE_MODIFY_STATE = @as(c_int, 0x0002);
pub const EVENT_ALL_ACCESS = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x1F0003, .hex);
pub const EVENT_MODIFY_STATE = @as(c_int, 0x0002);
pub const RTL_CONDITION_VARIABLE_LOCKMODE_SHARED = @as(c_int, 0x1);
pub const WINDOWS_WINDOW_H = "";
pub const MB_ABORTRETRYIGNORE = @as(c_long, 0x00000002);
pub const MB_CANCELTRYCONTINUE = @as(c_long, 0x00000006);
pub const MB_HELP = @as(c_long, 0x00004000);
pub const MB_OK = @as(c_long, 0x00000000);
pub const MB_OKCANCEL = @as(c_long, 0x00000001);
pub const MB_RETRYCANCEL = @as(c_long, 0x00000005);
pub const MB_YESNO = @as(c_long, 0x00000004);
pub const MB_YESNOCANCEL = @as(c_long, 0x00000003);
pub const MB_ICONEXCLAMATION = @as(c_long, 0x00000030);
pub const MB_ICONWARNING = @as(c_long, 0x00000030);
pub const MB_ICONINFORMATION = @as(c_long, 0x00000040);
pub const MB_ICONASTERISK = @as(c_long, 0x00000040);
pub const MB_ICONQUESTION = @as(c_long, 0x00000020);
pub const MB_ICONSTOP = @as(c_long, 0x00000010);
pub const MB_ICONERROR = @as(c_long, 0x00000010);
pub const MB_ICONHAND = @as(c_long, 0x00000010);
pub const MB_DEFBUTTON1 = @as(c_long, 0x00000000);
pub const MB_DEFBUTTON2 = @as(c_long, 0x00000100);
pub const MB_DEFBUTTON3 = @as(c_long, 0x00000200);
pub const MB_DEFBUTTON4 = @as(c_long, 0x00000300);
pub const MB_APPLMODAL = @as(c_long, 0x00000000);
pub const MB_SYSTEMMODAL = @as(c_long, 0x00001000);
pub const MB_TASKMODAL = @as(c_long, 0x00002000);
pub const MB_DEFAULT_DESKTOP_ONLY = @as(c_long, 0x00020000);
pub const MB_RIGHT = @as(c_long, 0x00080000);
pub const MB_RTLREADING = @as(c_long, 0x00100000);
pub const MB_SETFOREGROUND = @as(c_long, 0x00010000);
pub const MB_TOPMOST = @as(c_long, 0x00040000);
pub const MB_SERVICE_NOTIFICATION = @as(c_long, 0x00200000);
pub const IDABORT = @as(c_int, 3);
pub const IDCANCEL = @as(c_int, 2);
pub const IDCONTINUE = @as(c_int, 11);
pub const IDIGNORE = @as(c_int, 5);
pub const IDNO = @as(c_int, 7);
pub const IDOK = @as(c_int, 1);
pub const IDRETRY = @as(c_int, 4);
pub const IDTRYAGAIN = @as(c_int, 10);
pub const IDYES = @as(c_int, 6);
pub const WS_OVERLAPPED = @as(DWORD, 0x00000000);
pub const WS_POPUP = @import("std").zig.c_translation.promoteIntLiteral(DWORD, 0x80000000, .hex);
pub const WS_CHILD = @as(DWORD, 0x40000000);
pub const WS_MINIMIZE = @as(DWORD, 0x20000000);
pub const WS_VISIBLE = @as(DWORD, 0x10000000);
pub const WS_DISABLED = @as(DWORD, 0x08000000);
pub const WS_CLIPSIBLINGS = @as(DWORD, 0x04000000);
pub const WS_CLIPCHILDREN = @as(DWORD, 0x02000000);
pub const WS_MAXIMIZE = @as(DWORD, 0x01000000);
pub const WS_CAPTION = @as(DWORD, 0x00C00000);
pub const WS_BORDER = @as(DWORD, 0x00800000);
pub const WS_DLGFRAME = @as(DWORD, 0x00400000);
pub const WS_VSCROLL = @as(DWORD, 0x00200000);
pub const WS_HSCROLL = @as(DWORD, 0x00100000);
pub const WS_SYSMENU = @as(DWORD, 0x00080000);
pub const WS_THICKFRAME = @as(DWORD, 0x00040000);
pub const WS_GROUP = @as(DWORD, 0x00020000);
pub const WS_TABSTOP = @as(DWORD, 0x00010000);
pub const WS_MINIMIZEBOX = @as(DWORD, 0x00020000);
pub const WS_MAXIMIZEBOX = @as(DWORD, 0x00010000);
pub const WS_TILED = WS_OVERLAPPED;
pub const WS_ICONIC = WS_MINIMIZE;
pub const WS_SIZEBOX = WS_THICKFRAME;
pub const WS_TILEDWINDOW = WS_OVERLAPPEDWINDOW;
pub const WS_OVERLAPPEDWINDOW = ((((WS_OVERLAPPED | WS_CAPTION) | WS_SYSMENU) | WS_THICKFRAME) | WS_MINIMIZEBOX) | WS_MAXIMIZEBOX;
pub const WS_POPUPWINDOW = (WS_POPUP | WS_BORDER) | WS_SYSMENU;
pub const WS_CHILDWINDOW = WS_CHILD;
pub const CW_USEDEFAULT = @import("std").zig.c_translation.cast(c_int, @import("std").zig.c_translation.promoteIntLiteral(c_int, 0x80000000, .hex));
pub const CS_OWNDC = @as(c_int, 0x0020);
pub const CS_VREDRAW = @as(c_int, 0x0001);
pub const CS_HREDRAW = @as(c_int, 0x0002);
pub const PM_NOREMOVE = @as(c_int, 0x0000);
pub const PM_REMOVE = @as(c_int, 0x0001);
pub const PM_NOYIELD = @as(c_int, 0x0002);
pub const WM_NULL = @as(c_int, 0x0000);
pub const WM_CREATE = @as(c_int, 0x0001);
pub const WM_DESTROY = @as(c_int, 0x0002);
pub const WM_MOVE = @as(c_int, 0x0003);
pub const WM_SIZE = @as(c_int, 0x0005);
pub const WM_SETFOCUS = @as(c_int, 0x0007);
pub const WM_KILLFOCUS = @as(c_int, 0x0008);
pub const WM_ENABLE = @as(c_int, 0x000A);
pub const WM_SETREDRAW = @as(c_int, 0x000B);
pub const WM_SETTEXT = @as(c_int, 0x000C);
pub const WM_GETTEXT = @as(c_int, 0x000D);
pub const WM_GETTEXTLENGTH = @as(c_int, 0x000E);
pub const WM_PAINT = @as(c_int, 0x000F);
pub const WM_CLOSE = @as(c_int, 0x0010);
pub const WM_QUIT = @as(c_int, 0x0012);
pub const WM_ERASEBKGND = @as(c_int, 0x0014);
pub const WM_SYSCOLORCHANGE = @as(c_int, 0x0015);
pub const WM_SHOWWINDOW = @as(c_int, 0x0018);
pub const WM_WININICHANGE = @as(c_int, 0x001A);
pub const WM_NCDESTROY = @as(c_int, 0x0082);
pub const WM_KEYDOWN = @as(c_int, 0x0100);
pub const WM_KEYUP = @as(c_int, 0x0101);
pub const WM_SYSKEYDOWN = @as(c_int, 0x0104);
pub const WM_SYSKEYUP = @as(c_int, 0x0105);
pub const WM_SYSCOMMAND = @as(c_int, 0x0112);
pub const WM_ENTERSIZEMOVE = @as(c_int, 0x0231);
pub const WM_EXITSIZEMOVE = @as(c_int, 0x0232);
pub const WM_ACTIVATE = @as(c_int, 0x0006);
pub const WA_INACTIVE = @as(c_int, 0);
pub const WA_ACTIVE = @as(c_int, 1);
pub const WA_CLICKACTIVE = @as(c_int, 2);
pub const SC_KEYMENU = @import("std").zig.c_translation.promoteIntLiteral(c_int, 0xF100, .hex);
pub const WINDOWS_FIBER_H = "";
pub const _WINDOWS_ = "";
pub const _SECURITY_ATTRIBUTES = struct__SECURITY_ATTRIBUTES;
pub const _LARGE_INTEGER = union__LARGE_INTEGER;
pub const _ULARGE_INTEGER = union__ULARGE_INTEGER;
pub const _FILETIME = struct__FILETIME;
pub const _NT_TIB = struct__NT_TIB;
pub const _M128A = struct__M128A;
pub const _XSAVE_FORMAT = struct__XSAVE_FORMAT;
pub const _CONTEXT = struct__CONTEXT;
pub const _EXCEPTION_RECORD = struct__EXCEPTION_RECORD;
pub const _EXCEPTION_POINTERS = struct__EXCEPTION_POINTERS;
pub const _SYMBOL_INFO = struct__SYMBOL_INFO;
pub const _SYMBOL_INFOW = struct__SYMBOL_INFOW;
pub const _IMAGEHLP_LINE64 = struct__IMAGEHLP_LINE64;
pub const _IMAGEHLP_LINEW64 = struct__IMAGEHLP_LINEW64;
pub const _KDHELP64 = struct__KDHELP64;
pub const _LUID = struct__LUID;
pub const _LUID_AND_ATTRIBUTES = struct__LUID_AND_ATTRIBUTES;
pub const _TOKEN_PRIVILEGES = struct__TOKEN_PRIVILEGES;
pub const _MINIDUMP_TYPE = enum__MINIDUMP_TYPE;
pub const _MINIDUMP_EXCEPTION_INFORMATION = struct__MINIDUMP_EXCEPTION_INFORMATION;
pub const _MINIDUMP_EXCEPTION_INFORMATION64 = struct__MINIDUMP_EXCEPTION_INFORMATION64;
pub const _MINIDUMP_THREAD_CALLBACK = struct__MINIDUMP_THREAD_CALLBACK;
pub const _MINIDUMP_THREAD_EX_CALLBACK = struct__MINIDUMP_THREAD_EX_CALLBACK;
pub const _MINIDUMP_MODULE_CALLBACK = struct__MINIDUMP_MODULE_CALLBACK;
pub const _MINIDUMP_INCLUDE_THREAD_CALLBACK = struct__MINIDUMP_INCLUDE_THREAD_CALLBACK;
pub const _MINIDUMP_INCLUDE_MODULE_CALLBACK = struct__MINIDUMP_INCLUDE_MODULE_CALLBACK;
pub const _MINIDUMP_IO_CALLBACK = struct__MINIDUMP_IO_CALLBACK;
pub const _MINIDUMP_READ_MEMORY_FAILURE_CALLBACK = struct__MINIDUMP_READ_MEMORY_FAILURE_CALLBACK;
pub const _MINIDUMP_CALLBACK_INPUT = struct__MINIDUMP_CALLBACK_INPUT;
pub const _MINIDUMP_MEMORY_INFO = struct__MINIDUMP_MEMORY_INFO;
pub const _MINIDUMP_CALLBACK_OUTPUT = struct__MINIDUMP_CALLBACK_OUTPUT;
pub const _MINIDUMP_CALLBACK_INFORMATION = struct__MINIDUMP_CALLBACK_INFORMATION;
pub const _MINIDUMP_USER_STREAM = struct__MINIDUMP_USER_STREAM;
pub const _MINIDUMP_USER_STREAM_INFORMATION = struct__MINIDUMP_USER_STREAM_INFORMATION;
pub const _OVERLAPPED = struct__OVERLAPPED;
pub const _WIN32_FIND_DATAA = struct__WIN32_FIND_DATAA;
pub const _WIN32_FIND_DATAW = struct__WIN32_FIND_DATAW;
pub const _GET_FILEEX_INFO_LEVELS = enum__GET_FILEEX_INFO_LEVELS;
pub const _WIN32_FILE_ATTRIBUTE_DATA = struct__WIN32_FILE_ATTRIBUTE_DATA;
pub const _HEAP_INFORMATION_CLASS = enum__HEAP_INFORMATION_CLASS;
pub const _COORD = struct__COORD;
pub const _SMALL_RECT = struct__SMALL_RECT;
pub const _CONSOLE_SCREEN_BUFFER_INFO = struct__CONSOLE_SCREEN_BUFFER_INFO;
pub const _MEMORY_BASIC_INFORMATION32 = struct__MEMORY_BASIC_INFORMATION32;
pub const _MEMORY_BASIC_INFORMATION64 = struct__MEMORY_BASIC_INFORMATION64;
pub const _SYSTEMTIME = struct__SYSTEMTIME;
pub const _TIME_ZONE_INFORMATION = struct__TIME_ZONE_INFORMATION;
pub const timecaps_tag = struct_timecaps_tag;
pub const _JOBOBJECTINFOCLASS = enum__JOBOBJECTINFOCLASS;
pub const _STARTUPINFOA = struct__STARTUPINFOA;
pub const _STARTUPINFOW = struct__STARTUPINFOW;
pub const _PROC_THREAD_ATTRIBUTE_LIST = struct__PROC_THREAD_ATTRIBUTE_LIST;
pub const _STARTUPINFOEXA = struct__STARTUPINFOEXA;
pub const _STARTUPINFOEXW = struct__STARTUPINFOEXW;
pub const _PROCESS_INFORMATION = struct__PROCESS_INFORMATION;
pub const _JOBOBJECT_BASIC_LIMIT_INFORMATION = struct__JOBOBJECT_BASIC_LIMIT_INFORMATION;
pub const _IO_COUNTERS = struct__IO_COUNTERS;
pub const _JOBOBJECT_EXTENDED_LIMIT_INFORMATION = struct__JOBOBJECT_EXTENDED_LIMIT_INFORMATION;
pub const _SYSTEM_INFO = struct__SYSTEM_INFO;
pub const _DISPLAY_DEVICEA = struct__DISPLAY_DEVICEA;
pub const _DISPLAY_DEVICEW = struct__DISPLAY_DEVICEW;
pub const _OSVERSIONINFOEXA = struct__OSVERSIONINFOEXA;
pub const _OSVERSIONINFOEXW = struct__OSVERSIONINFOEXW;
pub const _LOGICAL_PROCESSOR_RELATIONSHIP = enum__LOGICAL_PROCESSOR_RELATIONSHIP;
pub const _PROCESSOR_CACHE_TYPE = enum__PROCESSOR_CACHE_TYPE;
pub const _CACHE_DESCRIPTOR = struct__CACHE_DESCRIPTOR;
pub const _SYSTEM_LOGICAL_PROCESSOR_INFORMATION = struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION;
pub const _GROUP_AFFINITY = struct__GROUP_AFFINITY;
pub const _NUMA_NODE_RELATIONSHIP = struct__NUMA_NODE_RELATIONSHIP;
pub const _PROCESSOR_GROUP_INFO = struct__PROCESSOR_GROUP_INFO;
pub const _GROUP_RELATIONSHIP = struct__GROUP_RELATIONSHIP;
pub const _CACHE_RELATIONSHIP = struct__CACHE_RELATIONSHIP;
pub const _PROCESSOR_RELATIONSHIP = struct__PROCESSOR_RELATIONSHIP;
pub const _SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX = struct__SYSTEM_LOGICAL_PROCESSOR_INFORMATION_EX;
pub const _PROCESS_MEMORY_COUNTERS = struct__PROCESS_MEMORY_COUNTERS;
pub const _MEMORYSTATUSEX = struct__MEMORYSTATUSEX;
pub const _PROCESSOR_NUMBER = struct__PROCESSOR_NUMBER;
pub const _IMAGE_TLS_DIRECTORY32 = struct__IMAGE_TLS_DIRECTORY32;
pub const _IMAGE_TLS_DIRECTORY64 = struct__IMAGE_TLS_DIRECTORY64;
pub const _LIST_ENTRY = struct__LIST_ENTRY;
pub const _RTL_CRITICAL_SECTION = struct__RTL_CRITICAL_SECTION;
pub const _RTL_CRITICAL_SECTION_DEBUG = struct__RTL_CRITICAL_SECTION_DEBUG;
pub const _RTL_CONDITION_VARIABLE = struct__RTL_CONDITION_VARIABLE;
pub const _RTL_SRWLOCK = struct__RTL_SRWLOCK;
pub const _RECT = struct__RECT;
pub const SW_HIDE: c_int = 0;
pub const SW_SHOWNORMAL: c_int = 1;
pub const SW_NORMAL: c_int = 1;
pub const SW_SHOWMINIMIZED: c_int = 2;
pub const SW_SHOWMAXIMIZED: c_int = 3;
pub const SW_MAXIMIZE: c_int = 3;
pub const SW_SHOWNOACTIVATE: c_int = 4;
pub const SW_SHOW: c_int = 5;
pub const SW_MINIMIZE: c_int = 6;
pub const SW_SHOWMINNOACTIVE: c_int = 7;
pub const SW_SHOWNA: c_int = 8;
pub const SW_RESTORE: c_int = 9;
pub const SW_SHOWDEFAULT: c_int = 10;
pub const SW_FORCEMINIMIZE: c_int = 11;

pub const VER_NT_WORKSTATION: BYTE = 0x1;
pub const VER_NT_SERVER: BYTE = 0x3;
pub const VER_NT_DOMAIN_CONTROLLER: BYTE = 0x2;

pub const LPCRECT = [*c]const RECT;
pub const POINTL = POINT;
pub const HMONITOR = HANDLE;
pub const LPMONITORINFO = [*c]MONITORINFO;
pub const MONITORENUMPROC = ?*const fn (HMONITOR, HDC, LPRECT, LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn GetMessageA(lpMsg: LPMSG, hWnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMessageW(lpMsg: LPMSG, hWnd: HWND, wMsgFilterMin: UINT, wMsgFilterMax: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn EnumDisplayMonitors(lpMsg: HDC, hWnd: LPCRECT, wMsgFilterMin: MONITORENUMPROC, wMsgFilterMax: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const MONITORINFO = extern struct {
    cbSize: DWORD,
    rcMonitor: RECT,
    rcWork: RECT,
    dwFlags: DWORD,
};

pub const CCHDEVICENAME = 32;
pub const MONITORINFOEXA = extern struct {
    monitorInfo: MONITORINFO,
    szDevice: [CCHDEVICENAME]CHAR,
};

pub extern fn GetMonitorInfoA(hMonitor: HMONITOR, lpmi: LPMONITORINFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CreateWaitableTimerA(lpTimerAttributes: LPSECURITY_ATTRIBUTES, bManualReset: BOOL, lpTimerName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;

pub const WS_EX_APPWINDOW = @as(DWORD, 0x00040000);
pub const WS_EX_TOPMOST = @as(DWORD, 0x00000008);
pub const MONITORINFOF_PRIMARY = @as(DWORD, 0x1);

pub const DEVMODEA = extern struct {
    dmDeviceName: [32]u8,
    dmSpecVersion: u16,
    dmDriverVersion: u16,
    dmSize: u16,
    dmDriverExtra: u16,
    dmFields: u32,
    u: extern union {
        u1: extern struct {
            dmOrientation: i16,
            dmPaperSize: i16,
            dmPaperLength: i16,
            dmPaperWidth: i16,
            dmScale: i16,
            dmCopies: i16,
            dmDefaultSource: i16,
            dmPrintQuality: i16,
        },
        u2: extern struct {
            dmPosition: POINTL,
            dmDisplayOrientation: u32,
            dmDisplayFixedOutput: u32,
        },
    },
    dmColor: i16,
    dmDuplex: i16,
    dmYResolution: i16,
    dmTTOption: i16,
    dmCollate: i16,
    dmFormName: [32]u8,
    dmLogPixels: u16,
    dmBitsPerPel: u32,
    dmPelsWidth: u32,
    dmPelsHeight: u32,
    u3: extern union {
        dmDisplayFlags: u32,
        dmNup: u32,
    },
    dmDisplayFrequency: u32,
    dmICMMethod: u32,
    dmICMIntent: u32,
    dmMediaType: u32,
    dmDitherType: u32,
    dmReserved1: u32,
    dmReserved2: u32,
    dmPanningWidth: u32,
    dmPanningHeight: u32,
};

pub const DEVMODEW = extern struct {
    dmDeviceName: [32]u16,
    dmSpecVersion: u16,
    dmDriverVersion: u16,
    dmSize: u16,
    dmDriverExtra: u16,
    dmFields: u32,
    u: extern union {
        u1: extern struct {
            dmOrientation: i16,
            dmPaperSize: i16,
            dmPaperLength: i16,
            dmPaperWidth: i16,
            dmScale: i16,
            dmCopies: i16,
            dmDefaultSource: i16,
            dmPrintQuality: i16,
        },
        u2: extern struct {
            dmPosition: POINTL,
            dmDisplayOrientation: u32,
            dmDisplayFixedOutput: u32,
        },
    },
    dmColor: i16,
    dmDuplex: i16,
    dmYResolution: i16,
    dmTTOption: i16,
    dmCollate: i16,
    dmFormName: [32]u16,
    dmLogPixels: u16,
    dmBitsPerPel: u32,
    dmPelsWidth: u32,
    dmPelsHeight: u32,
    u3: extern union {
        dmDisplayFlags: u32,
        dmNup: u32,
    },
    dmDisplayFrequency: u32,
    dmICMMethod: u32,
    dmICMIntent: u32,
    dmMediaType: u32,
    dmDitherType: u32,
    dmReserved1: u32,
    dmReserved2: u32,
    dmPanningWidth: u32,
    dmPanningHeight: u32,
};

pub const DM_SPECVERSION = @as(u32, 1025);
pub const DM_ORIENTATION = @as(i32, 1);
pub const DM_PAPERSIZE = @as(i32, 2);
pub const DM_PAPERLENGTH = @as(i32, 4);
pub const DM_PAPERWIDTH = @as(i32, 8);
pub const DM_SCALE = @as(i32, 16);
pub const DM_POSITION = @as(i32, 32);
pub const DM_NUP = @as(i32, 64);
pub const DM_DISPLAYORIENTATION = @as(i32, 128);
pub const DM_COPIES = @as(i32, 256);
pub const DM_DEFAULTSOURCE = @as(i32, 512);
pub const DM_PRINTQUALITY = @as(i32, 1024);
pub const DM_COLOR = @as(i32, 2048);
pub const DM_DUPLEX = @as(i32, 4096);
pub const DM_YRESOLUTION = @as(i32, 8192);
pub const DM_TTOPTION = @as(i32, 16384);
pub const DM_COLLATE = @as(i32, 32768);
pub const DM_FORMNAME = @as(i32, 65536);
pub const DM_LOGPIXELS = @as(i32, 131072);
pub const DM_BITSPERPEL = @as(i32, 262144);
pub const DM_PELSWIDTH = @as(i32, 524288);
pub const DM_PELSHEIGHT = @as(i32, 1048576);
pub const DM_DISPLAYFLAGS = @as(i32, 2097152);
pub const DM_DISPLAYFREQUENCY = @as(i32, 4194304);
pub const DM_ICMMETHOD = @as(i32, 8388608);
pub const DM_ICMINTENT = @as(i32, 16777216);
pub const DM_MEDIATYPE = @as(i32, 33554432);
pub const DM_DITHERTYPE = @as(i32, 67108864);
pub const DM_PANNINGWIDTH = @as(i32, 134217728);
pub const DM_PANNINGHEIGHT = @as(i32, 268435456);
pub const DM_DISPLAYFIXEDOUTPUT = @as(i32, 536870912);

pub const DISP_CHANGE_SUCCESSFUL: c_int = 0;
pub const DISP_CHANGE_RESTART: c_int = 1;
pub const DISP_CHANGE_FAILED: c_int = -1;
pub const DISP_CHANGE_BADMODE: c_int = -2;
pub const DISP_CHANGE_NOTUPDATED: c_int = -3;
pub const DISP_CHANGE_BADFLAGS: c_int = -4;
pub const DISP_CHANGE_BADPARAM: c_int = -5;
pub const DISP_CHANGE_BADDUALVIEW: c_int = -6;

pub const CDS_FULLSCREEN: DWORD = 0x00000004;
pub const CDS_GLOBAL: DWORD = 0x00000008;
pub const CDS_NORESET: DWORD = 0x10000000;
pub const CDS_RESET: DWORD = 0x40000000;
pub const CDS_SET_PRIMARY: DWORD = 0x00000010;
pub const CDS_TEST: DWORD = 0x00000002;
pub const CDS_UPDATEREGISTRY: DWORD = 0x00000001;
pub const CDS_VIDEOPARAMETERS: DWORD = 0x00000020;
pub const CDS_ENABLE_UNSAFE_MODES: DWORD = 0x00000100;
pub const CDS_DISABLE_UNSAFE_MODES: DWORD = 0x00000200;

pub extern fn ChangeDisplaySettingsExA(lpszDeviceName: ?[*:0]const u8, lpDevMode: ?*DEVMODEA, hwnd: HWND, dwflags: DWORD, lParam: ?*anyopaque) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn ChangeDisplaySettingsExW(lpszDeviceName: ?[*:0]const u16, lpDevMode: ?*DEVMODEW, hwnd: HWND, dwflags: DWORD, lParam: ?*anyopaque) callconv(@import("std").os.windows.WINAPI) LONG;

pub const ENUM_DISPLAY_SETTINGS_MODE = UINT;
pub const ENUM_CURRENT_SETTINGS: UINT = 4294967295;
pub const ENUM_REGISTRY_SETTINGS: UINT = 4294967294;
pub extern fn EnumDisplaySettingsA(lpszDeviceName: ?[*:0]const u8, iModeNum: ENUM_DISPLAY_SETTINGS_MODE, lpDevMode: ?*DEVMODEA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnumDisplaySettingsW(lpszDeviceName: ?[*:0]const u16, iModeNum: ENUM_DISPLAY_SETTINGS_MODE, lpDevMode: ?*DEVMODEW) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const WM_QUERYENDSESSION = @as(u32, 17);
pub const WM_QUERYOPEN = @as(u32, 19);
pub const WM_ENDSESSION = @as(u32, 22);
pub const WM_SETTINGCHANGE = @as(u32, 26);
pub const WM_DEVMODECHANGE = @as(u32, 27);
pub const WM_ACTIVATEAPP = @as(u32, 28);
pub const WM_FONTCHANGE = @as(u32, 29);
pub const WM_TIMECHANGE = @as(u32, 30);
pub const WM_CANCELMODE = @as(u32, 31);
pub const WM_SETCURSOR = @as(u32, 32);
pub const WM_MOUSEACTIVATE = @as(u32, 33);
pub const WM_CHILDACTIVATE = @as(u32, 34);
pub const WM_QUEUESYNC = @as(u32, 35);
pub const WM_GETMINMAXINFO = @as(u32, 36);
pub const WM_PAINTICON = @as(u32, 38);
pub const WM_ICONERASEBKGND = @as(u32, 39);
pub const WM_NEXTDLGCTL = @as(u32, 40);
pub const WM_SPOOLERSTATUS = @as(u32, 42);
pub const WM_DRAWITEM = @as(u32, 43);
pub const WM_MEASUREITEM = @as(u32, 44);
pub const WM_DELETEITEM = @as(u32, 45);
pub const WM_VKEYTOITEM = @as(u32, 46);
pub const WM_CHARTOITEM = @as(u32, 47);
pub const WM_SETFONT = @as(u32, 48);
pub const WM_GETFONT = @as(u32, 49);
pub const WM_SETHOTKEY = @as(u32, 50);
pub const WM_GETHOTKEY = @as(u32, 51);
pub const WM_QUERYDRAGICON = @as(u32, 55);
pub const WM_COMPAREITEM = @as(u32, 57);
pub const WM_GETOBJECT = @as(u32, 61);
pub const WM_COMPACTING = @as(u32, 65);
pub const WM_COMMNOTIFY = @as(u32, 68);
pub const WM_WINDOWPOSCHANGING = @as(u32, 70);
pub const WM_WINDOWPOSCHANGED = @as(u32, 71);
pub const WM_POWER = @as(u32, 72);
pub const PWR_OK = @as(u32, 1);
pub const PWR_FAIL = @as(i32, -1);
pub const PWR_SUSPENDREQUEST = @as(u32, 1);
pub const PWR_SUSPENDRESUME = @as(u32, 2);
pub const PWR_CRITICALRESUME = @as(u32, 3);
pub const WM_COPYDATA = @as(u32, 74);
pub const WM_CANCELJOURNAL = @as(u32, 75);
pub const WM_INPUTLANGCHANGEREQUEST = @as(u32, 80);
pub const WM_INPUTLANGCHANGE = @as(u32, 81);
pub const WM_TCARD = @as(u32, 82);
pub const WM_HELP = @as(u32, 83);
pub const WM_USERCHANGED = @as(u32, 84);
pub const WM_NOTIFYFORMAT = @as(u32, 85);
pub const NFR_ANSI = @as(u32, 1);
pub const NFR_UNICODE = @as(u32, 2);
pub const NF_QUERY = @as(u32, 3);
pub const NF_REQUERY = @as(u32, 4);
pub const WM_STYLECHANGING = @as(u32, 124);
pub const WM_STYLECHANGED = @as(u32, 125);
pub const WM_DISPLAYCHANGE = @as(u32, 126);
pub const WM_GETICON = @as(u32, 127);
pub const WM_SETICON = @as(u32, 128);
pub const WM_NCCREATE = @as(u32, 129);
pub const WM_NCCALCSIZE = @as(u32, 131);
pub const WM_NCHITTEST = @as(u32, 132);
pub const WM_NCPAINT = @as(u32, 133);
pub const WM_NCACTIVATE = @as(u32, 134);
pub const WM_GETDLGCODE = @as(u32, 135);
pub const WM_SYNCPAINT = @as(u32, 136);
pub const WM_NCMOUSEMOVE = @as(u32, 160);
pub const WM_NCLBUTTONDOWN = @as(u32, 161);
pub const WM_NCLBUTTONUP = @as(u32, 162);
pub const WM_NCLBUTTONDBLCLK = @as(u32, 163);
pub const WM_NCRBUTTONDOWN = @as(u32, 164);
pub const WM_NCRBUTTONUP = @as(u32, 165);
pub const WM_NCRBUTTONDBLCLK = @as(u32, 166);
pub const WM_NCMBUTTONDOWN = @as(u32, 167);
pub const WM_NCMBUTTONUP = @as(u32, 168);
pub const WM_NCMBUTTONDBLCLK = @as(u32, 169);
pub const WM_NCXBUTTONDOWN = @as(u32, 171);
pub const WM_NCXBUTTONUP = @as(u32, 172);
pub const WM_NCXBUTTONDBLCLK = @as(u32, 173);
pub const WM_INPUT_DEVICE_CHANGE = @as(u32, 254);
pub const WM_INPUT = @as(u32, 255);
pub const WM_DEVICECHANGE = @as(u32, 0x0219);
pub const WM_KEYFIRST = @as(u32, 256);
pub const WM_CHAR = @as(u32, 258);
pub const WM_DEADCHAR = @as(u32, 259);
pub const WM_SYSCHAR = @as(u32, 262);
pub const WM_SYSDEADCHAR = @as(u32, 263);
pub const WM_KEYLAST = @as(u32, 265);
pub const UNICODE_NOCHAR = @as(u32, 65535);
pub const WM_IME_STARTCOMPOSITION = @as(u32, 269);
pub const WM_IME_ENDCOMPOSITION = @as(u32, 270);
pub const WM_IME_COMPOSITION = @as(u32, 271);
pub const WM_IME_KEYLAST = @as(u32, 271);
pub const WM_INITDIALOG = @as(u32, 272);
pub const WM_COMMAND = @as(u32, 273);
pub const WM_TIMER = @as(u32, 275);
pub const WM_HSCROLL = @as(u32, 276);
pub const WM_VSCROLL = @as(u32, 277);
pub const WM_INITMENU = @as(u32, 278);
pub const WM_INITMENUPOPUP = @as(u32, 279);
pub const WM_GESTURE = @as(u32, 281);
pub const WM_GESTURENOTIFY = @as(u32, 282);
pub const WM_MENUSELECT = @as(u32, 287);
pub const WM_MENUCHAR = @as(u32, 288);
pub const WM_ENTERIDLE = @as(u32, 289);
pub const WM_MENURBUTTONUP = @as(u32, 290);
pub const WM_MENUDRAG = @as(u32, 291);
pub const WM_MENUGETOBJECT = @as(u32, 292);
pub const WM_UNINITMENUPOPUP = @as(u32, 293);
pub const WM_MENUCOMMAND = @as(u32, 294);
pub const WM_CHANGEUISTATE = @as(u32, 295);
pub const WM_UPDATEUISTATE = @as(u32, 296);
pub const WM_QUERYUISTATE = @as(u32, 297);
pub const UIS_SET = @as(u32, 1);
pub const UIS_CLEAR = @as(u32, 2);
pub const UIS_INITIALIZE = @as(u32, 3);
pub const UISF_HIDEFOCUS = @as(u32, 1);
pub const UISF_HIDEACCEL = @as(u32, 2);
pub const UISF_ACTIVE = @as(u32, 4);
pub const WM_CTLCOLORMSGBOX = @as(u32, 306);
pub const WM_CTLCOLOREDIT = @as(u32, 307);
pub const WM_CTLCOLORLISTBOX = @as(u32, 308);
pub const WM_CTLCOLORBTN = @as(u32, 309);
pub const WM_CTLCOLORDLG = @as(u32, 310);
pub const WM_CTLCOLORSCROLLBAR = @as(u32, 311);
pub const WM_CTLCOLORSTATIC = @as(u32, 312);
pub const MN_GETHMENU = @as(u32, 481);
pub const WM_MOUSEFIRST = @as(u32, 512);
pub const WM_MOUSEMOVE = @as(u32, 512);
pub const WM_LBUTTONDOWN = @as(u32, 513);
pub const WM_LBUTTONUP = @as(u32, 514);
pub const WM_LBUTTONDBLCLK = @as(u32, 515);
pub const WM_RBUTTONDOWN = @as(u32, 516);
pub const WM_RBUTTONUP = @as(u32, 517);
pub const WM_RBUTTONDBLCLK = @as(u32, 518);
pub const WM_MBUTTONDOWN = @as(u32, 519);
pub const WM_MBUTTONUP = @as(u32, 520);
pub const WM_MBUTTONDBLCLK = @as(u32, 521);
pub const WM_MOUSEWHEEL = @as(u32, 522);
pub const WM_XBUTTONDOWN = @as(u32, 523);
pub const WM_XBUTTONUP = @as(u32, 524);
pub const WM_XBUTTONDBLCLK = @as(u32, 525);
pub const WM_MOUSEHWHEEL = @as(u32, 526);
pub const WM_MOUSELAST = @as(u32, 526);
pub const WHEEL_DELTA = @as(u32, 120);
pub const WM_PARENTNOTIFY = @as(u32, 528);
pub const WM_ENTERMENULOOP = @as(u32, 529);
pub const WM_EXITMENULOOP = @as(u32, 530);
pub const WM_NEXTMENU = @as(u32, 531);
pub const WM_SIZING = @as(u32, 532);
pub const WM_CAPTURECHANGED = @as(u32, 533);
pub const WM_MOVING = @as(u32, 534);
pub const WM_POWERBROADCAST = @as(u32, 536);
pub const PBT_APMQUERYSUSPEND = @as(u32, 0);
pub const PBT_APMQUERYSTANDBY = @as(u32, 1);
pub const PBT_APMQUERYSUSPENDFAILED = @as(u32, 2);
pub const PBT_APMQUERYSTANDBYFAILED = @as(u32, 3);
pub const PBT_APMSUSPEND = @as(u32, 4);
pub const PBT_APMSTANDBY = @as(u32, 5);
pub const PBT_APMRESUMECRITICAL = @as(u32, 6);
pub const PBT_APMRESUMESUSPEND = @as(u32, 7);
pub const PBT_APMRESUMESTANDBY = @as(u32, 8);
pub const PBTF_APMRESUMEFROMFAILURE = @as(u32, 1);
pub const PBT_APMBATTERYLOW = @as(u32, 9);
pub const PBT_APMPOWERSTATUSCHANGE = @as(u32, 10);
pub const PBT_APMOEMEVENT = @as(u32, 11);
pub const PBT_APMRESUMEAUTOMATIC = @as(u32, 18);
pub const PBT_POWERSETTINGCHANGE = @as(u32, 32787);
pub const WM_MDICREATE = @as(u32, 544);
pub const WM_MDIDESTROY = @as(u32, 545);
pub const WM_MDIACTIVATE = @as(u32, 546);
pub const WM_MDIRESTORE = @as(u32, 547);
pub const WM_MDINEXT = @as(u32, 548);
pub const WM_MDIMAXIMIZE = @as(u32, 549);
pub const WM_MDITILE = @as(u32, 550);
pub const WM_MDICASCADE = @as(u32, 551);
pub const WM_MDIICONARRANGE = @as(u32, 552);
pub const WM_MDIGETACTIVE = @as(u32, 553);
pub const WM_MDISETMENU = @as(u32, 560);
pub const WM_DROPFILES = @as(u32, 563);
pub const WM_MDIREFRESHMENU = @as(u32, 564);
pub const WM_POINTERDEVICECHANGE = @as(u32, 568);
pub const WM_POINTERDEVICEINRANGE = @as(u32, 569);
pub const WM_POINTERDEVICEOUTOFRANGE = @as(u32, 570);
pub const WM_TOUCH = @as(u32, 576);
pub const WM_NCPOINTERUPDATE = @as(u32, 577);
pub const WM_NCPOINTERDOWN = @as(u32, 578);
pub const WM_NCPOINTERUP = @as(u32, 579);
pub const WM_POINTERUPDATE = @as(u32, 581);
pub const WM_POINTERDOWN = @as(u32, 582);
pub const WM_POINTERUP = @as(u32, 583);
pub const WM_POINTERENTER = @as(u32, 585);
pub const WM_POINTERLEAVE = @as(u32, 586);
pub const WM_POINTERACTIVATE = @as(u32, 587);
pub const WM_POINTERCAPTURECHANGED = @as(u32, 588);
pub const WM_TOUCHHITTESTING = @as(u32, 589);
pub const WM_POINTERWHEEL = @as(u32, 590);
pub const WM_POINTERHWHEEL = @as(u32, 591);
pub const DM_POINTERHITTEST = @as(u32, 592);
pub const WM_POINTERROUTEDTO = @as(u32, 593);
pub const WM_POINTERROUTEDAWAY = @as(u32, 594);
pub const WM_POINTERROUTEDRELEASED = @as(u32, 595);
pub const WM_IME_SETCONTEXT = @as(u32, 641);
pub const WM_IME_NOTIFY = @as(u32, 642);
pub const WM_IME_CONTROL = @as(u32, 643);
pub const WM_IME_COMPOSITIONFULL = @as(u32, 644);
pub const WM_IME_SELECT = @as(u32, 645);
pub const WM_IME_CHAR = @as(u32, 646);
pub const WM_IME_REQUEST = @as(u32, 648);
pub const WM_IME_KEYDOWN = @as(u32, 656);
pub const WM_IME_KEYUP = @as(u32, 657);
pub const WM_NCMOUSEHOVER = @as(u32, 672);
pub const WM_NCMOUSELEAVE = @as(u32, 674);
pub const WM_WTSSESSION_CHANGE = @as(u32, 689);
pub const WM_TABLET_FIRST = @as(u32, 704);
pub const WM_TABLET_LAST = @as(u32, 735);
pub const WM_DPICHANGED = @as(u32, 736);
pub const WM_DPICHANGED_BEFOREPARENT = @as(u32, 738);
pub const WM_DPICHANGED_AFTERPARENT = @as(u32, 739);
pub const WM_GETDPISCALEDSIZE = @as(u32, 740);
pub const WM_CUT = @as(u32, 768);
pub const WM_COPY = @as(u32, 769);
pub const WM_PASTE = @as(u32, 770);
pub const WM_CLEAR = @as(u32, 771);
pub const WM_UNDO = @as(u32, 772);
pub const WM_RENDERFORMAT = @as(u32, 773);
pub const WM_RENDERALLFORMATS = @as(u32, 774);
pub const WM_DESTROYCLIPBOARD = @as(u32, 775);
pub const WM_DRAWCLIPBOARD = @as(u32, 776);
pub const WM_PAINTCLIPBOARD = @as(u32, 777);
pub const WM_VSCROLLCLIPBOARD = @as(u32, 778);
pub const WM_SIZECLIPBOARD = @as(u32, 779);
pub const WM_ASKCBFORMATNAME = @as(u32, 780);
pub const WM_CHANGECBCHAIN = @as(u32, 781);
pub const WM_HSCROLLCLIPBOARD = @as(u32, 782);
pub const WM_QUERYNEWPALETTE = @as(u32, 783);
pub const WM_PALETTEISCHANGING = @as(u32, 784);
pub const WM_PALETTECHANGED = @as(u32, 785);
pub const WM_HOTKEY = @as(u32, 786);
pub const WM_PRINT = @as(u32, 791);
pub const WM_APPCOMMAND = @as(u32, 793);
pub const WM_THEMECHANGED = @as(u32, 794);
pub const WM_CLIPBOARDUPDATE = @as(u32, 797);
pub const WM_DWMCOMPOSITIONCHANGED = @as(u32, 798);
pub const WM_DWMNCRENDERINGCHANGED = @as(u32, 799);
pub const WM_DWMCOLORIZATIONCOLORCHANGED = @as(u32, 800);
pub const WM_DWMWINDOWMAXIMIZEDCHANGE = @as(u32, 801);
pub const WM_DWMSENDICONICTHUMBNAIL = @as(u32, 803);
pub const WM_DWMSENDICONICLIVEPREVIEWBITMAP = @as(u32, 806);
pub const WM_GETTITLEBARINFOEX = @as(u32, 831);
pub const WM_HANDHELDFIRST = @as(u32, 856);
pub const WM_HANDHELDLAST = @as(u32, 863);
pub const WM_AFXFIRST = @as(u32, 864);
pub const WM_AFXLAST = @as(u32, 895);
pub const WM_PENWINFIRST = @as(u32, 896);
pub const WM_PENWINLAST = @as(u32, 911);
pub const WM_APP = @as(u32, 32768);
pub const WM_USER = @as(u32, 1024);
pub const WMSZ_LEFT = @as(u32, 1);
pub const WMSZ_RIGHT = @as(u32, 2);
pub const WMSZ_TOP = @as(u32, 3);
pub const WMSZ_TOPLEFT = @as(u32, 4);
pub const WMSZ_TOPRIGHT = @as(u32, 5);
pub const WMSZ_BOTTOM = @as(u32, 6);
pub const WMSZ_BOTTOMLEFT = @as(u32, 7);
pub const WMSZ_BOTTOMRIGHT = @as(u32, 8);
pub const HTERROR = @as(i32, -2);
pub const HTTRANSPARENT = @as(i32, -1);
pub const HTNOWHERE = @as(u32, 0);
pub const HTCLIENT = @as(u32, 1);
pub const HTCAPTION = @as(u32, 2);
pub const HTSYSMENU = @as(u32, 3);
pub const HTGROWBOX = @as(u32, 4);
pub const HTSIZE = @as(u32, 4);
pub const HTMENU = @as(u32, 5);
pub const HTHSCROLL = @as(u32, 6);
pub const HTVSCROLL = @as(u32, 7);
pub const HTMINBUTTON = @as(u32, 8);
pub const HTMAXBUTTON = @as(u32, 9);
pub const HTLEFT = @as(u32, 10);
pub const HTRIGHT = @as(u32, 11);
pub const HTTOP = @as(u32, 12);
pub const HTTOPLEFT = @as(u32, 13);
pub const HTTOPRIGHT = @as(u32, 14);
pub const HTBOTTOM = @as(u32, 15);
pub const HTBOTTOMLEFT = @as(u32, 16);
pub const HTBOTTOMRIGHT = @as(u32, 17);
pub const HTBORDER = @as(u32, 18);
pub const HTREDUCE = @as(u32, 8);
pub const HTZOOM = @as(u32, 9);
pub const HTSIZEFIRST = @as(u32, 10);
pub const HTSIZELAST = @as(u32, 17);
pub const HTOBJECT = @as(u32, 19);
pub const HTCLOSE = @as(u32, 20);
pub const HTHELP = @as(u32, 21);
pub const MA_ACTIVATE = @as(u32, 1);
pub const MA_ACTIVATEANDEAT = @as(u32, 2);
pub const MA_NOACTIVATE = @as(u32, 3);
pub const MA_NOACTIVATEANDEAT = @as(u32, 4);
pub const ICON_SMALL = @as(u32, 0);
pub const ICON_BIG = @as(u32, 1);
pub const ICON_SMALL2 = @as(u32, 2);
pub const SIZE_RESTORED = @as(u32, 0);
pub const SIZE_MINIMIZED = @as(u32, 1);
pub const SIZE_MAXIMIZED = @as(u32, 2);
pub const SIZE_MAXSHOW = @as(u32, 3);
pub const SIZE_MAXHIDE = @as(u32, 4);
pub const SIZENORMAL = @as(u32, 0);
pub const SIZEICONIC = @as(u32, 1);
pub const SIZEFULLSCREEN = @as(u32, 2);
pub const SIZEZOOMSHOW = @as(u32, 3);
pub const SIZEZOOMHIDE = @as(u32, 4);
pub const MK_LBUTTON = @as(u32, 1);
pub const MK_RBUTTON = @as(u32, 2);
pub const MK_SHIFT = @as(u32, 4);
pub const MK_CONTROL = @as(u32, 8);
pub const MK_MBUTTON = @as(u32, 16);
pub const MK_XBUTTON1 = @as(u32, 32);
pub const MK_XBUTTON2 = @as(u32, 64);
pub const WM_MOUSEHOVER = @as(u32, 673);
pub const WM_MOUSELEAVE = @as(u32, 675);
pub const HOVER_DEFAULT = @as(u32, 4294967295);
pub const VK_LBUTTON = @as(c_int, 0x01);
pub const VK_RBUTTON = @as(c_int, 0x02);
pub const VK_CANCEL = @as(c_int, 0x03);
pub const VK_MBUTTON = @as(c_int, 0x04);
pub const VK_XBUTTON1 = @as(c_int, 0x05);
pub const VK_XBUTTON2 = @as(c_int, 0x06);
pub const VK_BACK = @as(c_int, 0x08);
pub const VK_TAB = @as(c_int, 0x09);
pub const VK_CLEAR = @as(c_int, 0x0C);
pub const VK_RETURN = @as(c_int, 0x0D);
pub const VK_SHIFT = @as(c_int, 0x10);
pub const VK_CONTROL = @as(c_int, 0x11);
pub const VK_MENU = @as(c_int, 0x12);
pub const VK_PAUSE = @as(c_int, 0x13);
pub const VK_CAPITAL = @as(c_int, 0x14);
pub const VK_KANA = @as(c_int, 0x15);
pub const VK_HANGUEL = @as(c_int, 0x15);
pub const VK_HANGUL = @as(c_int, 0x15);
pub const VK_JUNJA = @as(c_int, 0x17);
pub const VK_FINAL = @as(c_int, 0x18);
pub const VK_HANJA = @as(c_int, 0x19);
pub const VK_KANJI = @as(c_int, 0x19);
pub const VK_ESCAPE = @as(c_int, 0x1B);
pub const VK_CONVERT = @as(c_int, 0x1C);
pub const VK_NONCONVERT = @as(c_int, 0x1D);
pub const VK_ACCEPT = @as(c_int, 0x1E);
pub const VK_MODECHANGE = @as(c_int, 0x1F);
pub const VK_SPACE = @as(c_int, 0x20);
pub const VK_PRIOR = @as(c_int, 0x21);
pub const VK_NEXT = @as(c_int, 0x22);
pub const VK_END = @as(c_int, 0x23);
pub const VK_HOME = @as(c_int, 0x24);
pub const VK_LEFT = @as(c_int, 0x25);
pub const VK_UP = @as(c_int, 0x26);
pub const VK_RIGHT = @as(c_int, 0x27);
pub const VK_DOWN = @as(c_int, 0x28);
pub const VK_SELECT = @as(c_int, 0x29);
pub const VK_PRINT = @as(c_int, 0x2A);
pub const VK_EXECUTE = @as(c_int, 0x2B);
pub const VK_SNAPSHOT = @as(c_int, 0x2C);
pub const VK_INSERT = @as(c_int, 0x2D);
pub const VK_DELETE = @as(c_int, 0x2E);
pub const VK_HELP = @as(c_int, 0x2F);
pub const VK_KEY_0 = @as(c_int, 0x30);
pub const VK_KEY_1 = @as(c_int, 0x31);
pub const VK_KEY_2 = @as(c_int, 0x32);
pub const VK_KEY_3 = @as(c_int, 0x33);
pub const VK_KEY_4 = @as(c_int, 0x34);
pub const VK_KEY_5 = @as(c_int, 0x35);
pub const VK_KEY_6 = @as(c_int, 0x36);
pub const VK_KEY_7 = @as(c_int, 0x37);
pub const VK_KEY_8 = @as(c_int, 0x38);
pub const VK_KEY_9 = @as(c_int, 0x39);
pub const VK_KEY_A = @as(c_int, 0x41);
pub const VK_KEY_B = @as(c_int, 0x42);
pub const VK_KEY_C = @as(c_int, 0x43);
pub const VK_KEY_D = @as(c_int, 0x44);
pub const VK_KEY_E = @as(c_int, 0x45);
pub const VK_KEY_F = @as(c_int, 0x46);
pub const VK_KEY_G = @as(c_int, 0x47);
pub const VK_KEY_H = @as(c_int, 0x48);
pub const VK_KEY_I = @as(c_int, 0x49);
pub const VK_KEY_J = @as(c_int, 0x4A);
pub const VK_KEY_K = @as(c_int, 0x4B);
pub const VK_KEY_L = @as(c_int, 0x4C);
pub const VK_KEY_M = @as(c_int, 0x4D);
pub const VK_KEY_N = @as(c_int, 0x4E);
pub const VK_KEY_O = @as(c_int, 0x4F);
pub const VK_KEY_P = @as(c_int, 0x50);
pub const VK_KEY_Q = @as(c_int, 0x51);
pub const VK_KEY_R = @as(c_int, 0x52);
pub const VK_KEY_S = @as(c_int, 0x53);
pub const VK_KEY_T = @as(c_int, 0x54);
pub const VK_KEY_U = @as(c_int, 0x55);
pub const VK_KEY_V = @as(c_int, 0x56);
pub const VK_KEY_W = @as(c_int, 0x57);
pub const VK_KEY_X = @as(c_int, 0x58);
pub const VK_KEY_Y = @as(c_int, 0x59);
pub const VK_KEY_Z = @as(c_int, 0x5A);
pub const VK_LWIN = @as(c_int, 0x5B);
pub const VK_RWIN = @as(c_int, 0x5C);
pub const VK_APPS = @as(c_int, 0x5D);
pub const VK_SLEEP = @as(c_int, 0x5F);
pub const VK_NUMPAD0 = @as(c_int, 0x60);
pub const VK_NUMPAD1 = @as(c_int, 0x61);
pub const VK_NUMPAD2 = @as(c_int, 0x62);
pub const VK_NUMPAD3 = @as(c_int, 0x63);
pub const VK_NUMPAD4 = @as(c_int, 0x64);
pub const VK_NUMPAD5 = @as(c_int, 0x65);
pub const VK_NUMPAD6 = @as(c_int, 0x66);
pub const VK_NUMPAD7 = @as(c_int, 0x67);
pub const VK_NUMPAD8 = @as(c_int, 0x68);
pub const VK_NUMPAD9 = @as(c_int, 0x69);
pub const VK_MULTIPLY = @as(c_int, 0x6A);
pub const VK_ADD = @as(c_int, 0x6B);
pub const VK_SEPARATOR = @as(c_int, 0x6C);
pub const VK_SUBTRACT = @as(c_int, 0x6D);
pub const VK_DECIMAL = @as(c_int, 0x6E);
pub const VK_DIVIDE = @as(c_int, 0x6F);
pub const VK_F1 = @as(c_int, 0x70);
pub const VK_F2 = @as(c_int, 0x71);
pub const VK_F3 = @as(c_int, 0x72);
pub const VK_F4 = @as(c_int, 0x73);
pub const VK_F5 = @as(c_int, 0x74);
pub const VK_F6 = @as(c_int, 0x75);
pub const VK_F7 = @as(c_int, 0x76);
pub const VK_F8 = @as(c_int, 0x77);
pub const VK_F9 = @as(c_int, 0x78);
pub const VK_F10 = @as(c_int, 0x79);
pub const VK_F11 = @as(c_int, 0x7A);
pub const VK_F12 = @as(c_int, 0x7B);
pub const VK_F13 = @as(c_int, 0x7C);
pub const VK_F14 = @as(c_int, 0x7D);
pub const VK_F15 = @as(c_int, 0x7E);
pub const VK_F16 = @as(c_int, 0x7F);
pub const VK_F17 = @as(c_int, 0x80);
pub const VK_F18 = @as(c_int, 0x81);
pub const VK_F19 = @as(c_int, 0x82);
pub const VK_F20 = @as(c_int, 0x83);
pub const VK_F21 = @as(c_int, 0x84);
pub const VK_F22 = @as(c_int, 0x85);
pub const VK_F23 = @as(c_int, 0x86);
pub const VK_F24 = @as(c_int, 0x87);
pub const VK_NUMLOCK = @as(c_int, 0x90);
pub const VK_SCROLL = @as(c_int, 0x91);
pub const VK_LSHIFT = @as(c_int, 0xA0);
pub const VK_RSHIFT = @as(c_int, 0xA1);
pub const VK_LCONTROL = @as(c_int, 0xA2);
pub const VK_RCONTROL = @as(c_int, 0xA3);
pub const VK_LMENU = @as(c_int, 0xA4);
pub const VK_RMENU = @as(c_int, 0xA5);
pub const VK_BROWSER_BACK = @as(c_int, 0xA6);
pub const VK_BROWSER_FORWARD = @as(c_int, 0xA7);
pub const VK_BROWSER_REFRESH = @as(c_int, 0xA8);
pub const VK_BROWSER_STOP = @as(c_int, 0xA9);
pub const VK_BROWSER_SEARCH = @as(c_int, 0xAA);
pub const VK_BROWSER_FAVORITES = @as(c_int, 0xAB);
pub const VK_BROWSER_HOME = @as(c_int, 0xAC);
pub const VK_VOLUME_MUTE = @as(c_int, 0xAD);
pub const VK_VOLUME_DOWN = @as(c_int, 0xAE);
pub const VK_VOLUME_UP = @as(c_int, 0xAF);
pub const VK_MEDIA_NEXT_TRACK = @as(c_int, 0xB0);
pub const VK_MEDIA_PREV_TRACK = @as(c_int, 0xB1);
pub const VK_MEDIA_STOP = @as(c_int, 0xB2);
pub const VK_MEDIA_PLAY_PAUSE = @as(c_int, 0xB3);
pub const VK_LAUNCH_MAIL = @as(c_int, 0xB4);
pub const VK_MEDIA_SELECT = @as(c_int, 0xB5);
pub const VK_LAUNCH_APP1 = @as(c_int, 0xB6);
pub const VK_LAUNCH_APP2 = @as(c_int, 0xB7);
pub const VK_OEM_1 = @as(c_int, 0xBA);
pub const VK_OEM_PLUS = @as(c_int, 0xBB);
pub const VK_OEM_COMMA = @as(c_int, 0xBC);
pub const VK_OEM_MINUS = @as(c_int, 0xBD);
pub const VK_OEM_PERIOD = @as(c_int, 0xBE);
pub const VK_OEM_2 = @as(c_int, 0xBF);
pub const VK_OEM_3 = @as(c_int, 0xC0);
pub const VK_ABNT_C1 = @as(c_int, 0xC1);
pub const VK_ABNT_C2 = @as(c_int, 0xC2);
pub const VK_OEM_4 = @as(c_int, 0xDB);
pub const VK_OEM_5 = @as(c_int, 0xDC);
pub const VK_OEM_6 = @as(c_int, 0xDD);
pub const VK_OEM_7 = @as(c_int, 0xDE);
pub const VK_OEM_8 = @as(c_int, 0xDF);
pub const VK_OEM_102 = @as(c_int, 0xE2);
pub const VK_PROCESSKEY = @as(c_int, 0xE5);
pub const VK_PACKET = @as(c_int, 0xE7);
pub const VK_ATTN = @as(c_int, 0xF6);
pub const VK_CRSEL = @as(c_int, 0xF7);
pub const VK_EXSEL = @as(c_int, 0xF8);
pub const VK_EREOF = @as(c_int, 0xF9);
pub const VK_PLAY = @as(c_int, 0xFA);
pub const VK_ZOOM = @as(c_int, 0xFB);
pub const VK_NONAME = @as(c_int, 0xFC);
pub const VK_PA1 = @as(c_int, 0xFD);
pub const VK_OEM_CLEAR = @as(c_int, 0xFE);

pub const PTIMERAPCROUTINE = ?*const fn (LPVOID, DWORD, DWORD, LPARAM) callconv(@import("std").os.windows.WINAPI) void;

pub const POWER_REQUEST_CONTEXT_FLAGS = enum(c_uint) {
    DETAILED_STRING = 2,
    SIMPLE_STRING = 1,
};

pub const REASON_CONTEXT = extern struct {
    Version: u32,
    Flags: POWER_REQUEST_CONTEXT_FLAGS,
    Reason: extern union {
        Detailed: extern struct {
            LocalizedReasonModule: HINSTANCE,
            LocalizedReasonId: u32,
            ReasonStringCount: u32,
            ReasonStrings: ?*PWSTR,
        },
        SimpleReasonString: PWSTR,
    },
};

pub extern fn SetWaitableTimerEx(hTimer: HANDLE, lpDueTime: ?*const LARGE_INTEGER, lPeriod: i32, pfnCompletionRoutine: PTIMERAPCROUTINE, lpArgToCompletionRoutine: ?*anyopaque, WakeContext: ?*REASON_CONTEXT, TolerableDelay: u32) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn SetWaitableTimer(hTimer: HANDLE, lpDueTime: ?*const LARGE_INTEGER, lPeriod: i32, pfnCompletionRoutine: PTIMERAPCROUTINE, lpArgToCompletionRoutine: ?*anyopaque, fResume: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const HRAWINPUT = HANDLE;

pub const RAWINPUTHEADER = extern struct {
    dwType: u32,
    dwSize: u32,
    hDevice: HANDLE,
    wParam: WPARAM,
};

pub const RAWMOUSE = extern struct {
    usFlags: u16,
    u: extern union {
        ulButtons: u32,
        u: extern struct {
            usButtonFlags: u16,
            usButtonData: u16,
        },
    },
    ulRawButtons: u32,
    lLastX: i32,
    lLastY: i32,
    ulExtraInformation: u32,
};

pub const RAWKEYBOARD = extern struct {
    MakeCode: u16,
    Flags: u16,
    Reserved: u16,
    VKey: u16,
    Message: u32,
    ExtraInformation: u32,
};

pub const RAWHID = extern struct {
    dwSizeHid: u32,
    dwCount: u32,
    bRawData: [1]u8,
};

pub const RAWINPUT = extern struct {
    header: RAWINPUTHEADER,
    data: extern union {
        mouse: RAWMOUSE,
        keyboard: RAWKEYBOARD,
        hid: RAWHID,
    },
};

pub const RID_HEADER: UINT = 0x10000005;
pub const RID_INPUT: UINT = 0x10000003;
pub extern fn GetRawInputData(hRawInput: HRAWINPUT, uiCommand: UINT, pData: ?*anyopaque, pcbSize: ?*UINT, cbSizeHeader: UINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub const TME_CANCEL: DWORD = 0x80000000;
pub const TME_HOVER: DWORD = 0x00000001;
pub const TME_LEAVE: DWORD = 0x00000002;
pub const TME_NONCLIENT: DWORD = 0x00000010;
pub const TME_QUERY: DWORD = 0x40000000;

pub const TRACKMOUSEEVENT = extern struct {
    cbSize: DWORD,
    dwFlags: DWORD,
    hwndTrack: HWND,
    dwHoverTime: DWORD,
};

pub const TOUCHINPUT = extern struct {
    x: LONG = @import("std").mem.zeroes(LONG),
    y: LONG = @import("std").mem.zeroes(LONG),
    hSource: HANDLE = @import("std").mem.zeroes(HANDLE),
    dwID: DWORD = @import("std").mem.zeroes(DWORD),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    dwMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwTime: DWORD = @import("std").mem.zeroes(DWORD),
    dwExtraInfo: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    cxContact: DWORD = @import("std").mem.zeroes(DWORD),
    cyContact: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const HTOUCHINPUT = [*c]TOUCHINPUT;
pub const PTOUCHINPUT = [*c]TOUCHINPUT;
pub const PCTOUCHINPUT = [*c]const TOUCHINPUT;
pub const POINTER_BUTTON_CHANGE_TYPE = enum(c_uint) {
    POINTER_CHANGE_NONE,
    POINTER_CHANGE_FIRSTBUTTON_DOWN,
    POINTER_CHANGE_FIRSTBUTTON_UP,
    POINTER_CHANGE_SECONDBUTTON_DOWN,
    POINTER_CHANGE_SECONDBUTTON_UP,
    POINTER_CHANGE_THIRDBUTTON_DOWN,
    POINTER_CHANGE_THIRDBUTTON_UP,
    POINTER_CHANGE_FOURTHBUTTON_DOWN,
    POINTER_CHANGE_FOURTHBUTTON_UP,
    POINTER_CHANGE_FIFTHBUTTON_DOWN,
    POINTER_CHANGE_FIFTHBUTTON_UP,
};

pub const POINTER_INPUT_TYPE = enum(c_uint) { PT_POINTER = 1, PT_TOUCH = 2, PT_PEN = 3, PT_MOUSE = 4, PT_TOUCHPAD = 5 };
pub const POINTER_FLAGS = INT;

pub const POINTER_FLAG_NONE: c_int = 0x00000000;
pub const POINTER_FLAG_NEW: c_int = 0x00000001;
pub const POINTER_FLAG_INRANGE: c_int = 0x00000002;
pub const POINTER_FLAG_INCONTACT: c_int = 0x00000004;
pub const POINTER_FLAG_FIRSTBUTTON: c_int = 0x00000010;
pub const POINTER_FLAG_SECONDBUTTON: c_int = 0x00000020;
pub const POINTER_FLAG_THIRDBUTTON: c_int = 0x00000040;
pub const POINTER_FLAG_OTHERBUTTON: c_int = 0x00000080;
pub const POINTER_FLAG_PRIMARY: c_int = 0x00000100;
pub const POINTER_FLAG_CONFIDENCE: c_int = 0x00000200;
pub const POINTER_FLAG_CANCELLED: c_int = 0x00000400;
pub const POINTER_FLAG_DOWN: c_int = 0x00010000;
pub const POINTER_FLAG_UPDATE: c_int = 0x00020000;
pub const POINTER_FLAG_UP: c_int = 0x00040000;
pub const POINTER_FLAG_WHEEL: c_int = 0x00080000;
pub const POINTER_FLAG_HWHEEL: c_int = 0x00100000;

pub const POINTER_INFO = extern struct {
    pointerType: POINTER_INPUT_TYPE,
    pointerId: UINT32 = @import("std").mem.zeroes(UINT32),
    frameId: UINT32 = @import("std").mem.zeroes(UINT32),
    pointerFlags: POINTER_FLAGS = @import("std").mem.zeroes(POINTER_FLAGS),
    sourceDevice: HANDLE = @import("std").mem.zeroes(HANDLE),
    hwndTarget: HWND = @import("std").mem.zeroes(HWND),
    ptPixelLocation: POINT = @import("std").mem.zeroes(POINT),
    ptHimetricLocation: POINT = @import("std").mem.zeroes(POINT),
    ptPixelLocationRaw: POINT = @import("std").mem.zeroes(POINT),
    ptHimetricLocationRaw: POINT = @import("std").mem.zeroes(POINT),
    dwTime: DWORD = @import("std").mem.zeroes(DWORD),
    historyCount: UINT32 = @import("std").mem.zeroes(UINT32),
    InputData: INT32 = @import("std").mem.zeroes(INT32),
    dwKeyStates: DWORD = @import("std").mem.zeroes(DWORD),
    PerformanceCount: UINT64 = @import("std").mem.zeroes(UINT64),
    ButtonChangeType: POINTER_BUTTON_CHANGE_TYPE = @import("std").mem.zeroes(POINTER_BUTTON_CHANGE_TYPE),
};

pub extern fn TrackMouseEvent(lpEventTrack: ?*TRACKMOUSEEVENT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetTouchInputInfo(hTouchInput: HTOUCHINPUT, cInputs: UINT, pInputs: PTOUCHINPUT, cbSize: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CloseTouchInputHandle(hTouchInput: HTOUCHINPUT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RegisterTouchWindow(hwnd: HWND, ulFlags: ULONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn UnregisterTouchWindow(hwnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsTouchWindow(hwnd: HWND, pulFlags: PULONG) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const TOUCH_FLAGS = UINT32;
pub const TOUCH_MASK = UINT32;

pub const TOUCH_FLAG_NONE: UINT32 = 0x00000000;
pub const TOUCH_MASK_NONE: UINT32 = 0x00000000;
pub const TOUCH_MASK_CONTACTAREA: UINT32 = 0x00000001;
pub const TOUCH_MASK_ORIENTATION: UINT32 = 0x00000002;
pub const TOUCH_MASK_PRESSURE: UINT32 = 0x00000004;

pub const POINTER_TOUCH_INFO = extern struct {
    pointerInfo: POINTER_INFO = @import("std").mem.zeroes(POINTER_INFO),
    touchFlags: TOUCH_FLAGS = @import("std").mem.zeroes(TOUCH_FLAGS),
    touchMask: TOUCH_MASK = @import("std").mem.zeroes(TOUCH_MASK),
    rcContact: RECT = @import("std").mem.zeroes(RECT),
    rcContactRaw: RECT = @import("std").mem.zeroes(RECT),
    orientation: UINT32 = @import("std").mem.zeroes(UINT32),
    pressure: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const PEN_FLAGS = UINT32;
pub const PEN_MASK = UINT32;

pub const PEN_FLAG_NONE: UINT32 = 0x00000000;
pub const PEN_FLAG_BARREL: UINT32 = 0x00000001;
pub const PEN_FLAG_INVERTED: UINT32 = 0x00000002;
pub const PEN_FLAG_ERASER: UINT32 = 0x00000004;

pub const PEN_MASK_NONE: UINT32 = 0x00000000;
pub const PEN_MASK_PRESSURE: UINT32 = 0x00000001;
pub const PEN_MASK_ROTATION: UINT32 = 0x00000002;
pub const PEN_MASK_TILT_X: UINT32 = 0x00000004;
pub const PEN_MASK_TILT_Y: UINT32 = 0x00000008;

pub const GWL_STYLE = -16;
pub const GWL_EXSTYLE = -20;
pub const GWL_HINSTANCE = -6;
pub const GWL_WNDPROC = -4;
pub const GWL_USERDATA = -21;
pub const GWL_ID = -12;

pub const SWP_DRAWFRAME: DWORD = 0x0020;
pub const SWP_FRAMECHANGED: DWORD = 0x0020;
pub const SWP_HIDEWINDOW: DWORD = 0x0080;
pub const SWP_NOACTIVATE: DWORD = 0x0010;
pub const SWP_NOCOPYBITS: DWORD = 0x0100;
pub const SWP_NOMOVE: DWORD = 0x0002;
pub const SWP_NOOWNERZORDER: DWORD = 0x0200;
pub const SWP_NOREDRAW: DWORD = 0x0008;
pub const SWP_NOREPOSITION: DWORD = 0x0200;
pub const SWP_NOSENDCHANGING: DWORD = 0x0400;
pub const SWP_NOSIZE: DWORD = 0x0001;
pub const SWP_NOZORDER: DWORD = 0x0004;
pub const SWP_SHOWWINDOW: DWORD = 0x0040;

pub const HWND_BOTTOM: HWND = @ptrFromInt(1);
pub const HWND_NOTOPMOST: HWND = @ptrFromInt(@import("std").math.maxInt(usize) - 1);
pub const HWND_TOP: HWND = null;
pub const HWND_TOPMOST: HWND = @ptrFromInt(@import("std").math.maxInt(usize));

pub const POINTER_PEN_INFO = extern struct {
    pointerInfo: POINTER_INFO = @import("std").mem.zeroes(POINTER_INFO),
    penFlags: PEN_FLAGS = @import("std").mem.zeroes(PEN_FLAGS),
    penMask: PEN_MASK = @import("std").mem.zeroes(PEN_MASK),
    pressure: UINT32 = @import("std").mem.zeroes(UINT32),
    rotation: UINT32 = @import("std").mem.zeroes(UINT32),
    tiltX: INT32 = @import("std").mem.zeroes(INT32),
    tiltY: INT32 = @import("std").mem.zeroes(INT32),
};
pub extern fn InitializeTouchInjection(maxCount: UINT32, dwMode: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InjectTouchInput(count: UINT32, contacts: [*c]const POINTER_TOUCH_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagUSAGE_PROPERTIES = extern struct {
    level: USHORT = @import("std").mem.zeroes(USHORT),
    page: USHORT = @import("std").mem.zeroes(USHORT),
    usage: USHORT = @import("std").mem.zeroes(USHORT),
    logicalMinimum: INT32 = @import("std").mem.zeroes(INT32),
    logicalMaximum: INT32 = @import("std").mem.zeroes(INT32),
    unit: USHORT = @import("std").mem.zeroes(USHORT),
    exponent: USHORT = @import("std").mem.zeroes(USHORT),
    count: BYTE = @import("std").mem.zeroes(BYTE),
    physicalMinimum: INT32 = @import("std").mem.zeroes(INT32),
    physicalMaximum: INT32 = @import("std").mem.zeroes(INT32),
};
pub const USAGE_PROPERTIES = struct_tagUSAGE_PROPERTIES;
pub const PUSAGE_PROPERTIES = [*c]struct_tagUSAGE_PROPERTIES;
pub const struct_tagPOINTER_TYPE_INFO = extern struct {
    type: POINTER_INPUT_TYPE,
    u: extern union {
        touchInfo: POINTER_TOUCH_INFO,
        penInfo: POINTER_PEN_INFO,
    },
};
pub const POINTER_TYPE_INFO = struct_tagPOINTER_TYPE_INFO;
pub const PPOINTER_TYPE_INFO = [*c]struct_tagPOINTER_TYPE_INFO;
pub const struct_tagINPUT_INJECTION_VALUE = extern struct {
    page: USHORT = @import("std").mem.zeroes(USHORT),
    usage: USHORT = @import("std").mem.zeroes(USHORT),
    value: INT32 = @import("std").mem.zeroes(INT32),
    index: USHORT = @import("std").mem.zeroes(USHORT),
};
pub const INPUT_INJECTION_VALUE = struct_tagINPUT_INJECTION_VALUE;
pub const PINPUT_INJECTION_VALUE = [*c]struct_tagINPUT_INJECTION_VALUE;
pub extern fn GetPointerType(pointerId: UINT32, pointerType: [*c]POINTER_INPUT_TYPE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerCursorId(pointerId: UINT32, cursorId: [*c]UINT32) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerInfo(pointerId: UINT32, pointerInfo: [*c]POINTER_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, pointerInfo: [*c]POINTER_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFrameInfo(pointerId: UINT32, pointerCount: [*c]UINT32, pointerInfo: [*c]POINTER_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFrameInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, pointerCount: [*c]UINT32, pointerInfo: [*c]POINTER_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerTouchInfo(pointerId: UINT32, touchInfo: [*c]POINTER_TOUCH_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerTouchInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, touchInfo: [*c]POINTER_TOUCH_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFrameTouchInfo(pointerId: UINT32, pointerCount: [*c]UINT32, touchInfo: [*c]POINTER_TOUCH_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFrameTouchInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, pointerCount: [*c]UINT32, touchInfo: [*c]POINTER_TOUCH_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerPenInfo(pointerId: UINT32, penInfo: [*c]POINTER_PEN_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerPenInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, penInfo: [*c]POINTER_PEN_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFramePenInfo(pointerId: UINT32, pointerCount: [*c]UINT32, penInfo: [*c]POINTER_PEN_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPointerFramePenInfoHistory(pointerId: UINT32, entriesCount: [*c]UINT32, pointerCount: [*c]UINT32, penInfo: [*c]POINTER_PEN_INFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SkipPointerFrameMessages(pointerId: UINT32) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RegisterPointerInputTarget(hwnd: HWND, pointerType: POINTER_INPUT_TYPE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn UnregisterPointerInputTarget(hwnd: HWND, pointerType: POINTER_INPUT_TYPE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnableMouseInPointer(fEnable: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsMouseInPointerEnabled() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RegisterTouchHitTestingWindow(hwnd: HWND, value: ULONG) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagTOUCH_HIT_TESTING_PROXIMITY_EVALUATION = extern struct {
    score: UINT16 = @import("std").mem.zeroes(UINT16),
    adjustedPoint: POINT = @import("std").mem.zeroes(POINT),
};

pub extern fn MonitorFromWindow(hwnd: HWND, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) HMONITOR;

pub const MONITOR_DEFAULTTONEAREST: DWORD = 2;
pub const MONITOR_DEFAULTTONULL: DWORD = 0;
pub const MONITOR_DEFAULTTOPRIMARY: DWORD = 1;

pub const TOUCH_HIT_TESTING_PROXIMITY_EVALUATION = struct_tagTOUCH_HIT_TESTING_PROXIMITY_EVALUATION;
pub const PTOUCH_HIT_TESTING_PROXIMITY_EVALUATION = [*c]struct_tagTOUCH_HIT_TESTING_PROXIMITY_EVALUATION;
pub const struct_tagTOUCH_HIT_TESTING_INPUT = extern struct {
    pointerId: UINT32 = @import("std").mem.zeroes(UINT32),
    point: POINT = @import("std").mem.zeroes(POINT),
    boundingBox: RECT = @import("std").mem.zeroes(RECT),
    nonOccludedBoundingBox: RECT = @import("std").mem.zeroes(RECT),
    orientation: UINT32 = @import("std").mem.zeroes(UINT32),
};
pub const TOUCH_HIT_TESTING_INPUT = struct_tagTOUCH_HIT_TESTING_INPUT;
pub const PTOUCH_HIT_TESTING_INPUT = [*c]struct_tagTOUCH_HIT_TESTING_INPUT;
pub extern fn EvaluateProximityToRect(controlBoundingBox: [*c]const RECT, pHitTestingInput: [*c]const TOUCH_HIT_TESTING_INPUT, pProximityEval: [*c]TOUCH_HIT_TESTING_PROXIMITY_EVALUATION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EvaluateProximityToPolygon(numVertices: UINT32, controlPolygon: [*c]const POINT, pHitTestingInput: [*c]const TOUCH_HIT_TESTING_INPUT, pProximityEval: [*c]TOUCH_HIT_TESTING_PROXIMITY_EVALUATION) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PackTouchHitTestingProximityEvaluation(pHitTestingInput: [*c]const TOUCH_HIT_TESTING_INPUT, pProximityEval: [*c]const TOUCH_HIT_TESTING_PROXIMITY_EVALUATION) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub const FEEDBACK_TYPE = enum(c_uint) {
    FEEDBACK_TOUCH_CONTACTVISUALIZATION = 1,
    FEEDBACK_PEN_BARRELVISUALIZATION = 2,
    FEEDBACK_PEN_TAP = 3,
    FEEDBACK_PEN_DOUBLETAP = 4,
    FEEDBACK_PEN_PRESSANDHOLD = 5,
    FEEDBACK_PEN_RIGHTTAP = 6,
    FEEDBACK_TOUCH_TAP = 7,
    FEEDBACK_TOUCH_DOUBLETAP = 8,
    FEEDBACK_TOUCH_PRESSANDHOLD = 9,
    FEEDBACK_TOUCH_RIGHTTAP = 10,
    FEEDBACK_GESTURE_PRESSANDTAP = 11,
    FEEDBACK_MAX = 0xFFFFFFFF,
};
pub extern fn GetWindowFeedbackSetting(hwnd: HWND, feedback: FEEDBACK_TYPE, dwFlags: DWORD, pSize: [*c]UINT32, config: ?*anyopaque) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowFeedbackSetting(hwnd: HWND, feedback: FEEDBACK_TYPE, dwFlags: DWORD, size: UINT32, configuration: ?*const anyopaque) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const INPUT_TRANSFORM = extern struct {
    u: extern union {
        s: extern struct {
            _11: f32 = @import("std").mem.zeroes(f32),
            _12: f32 = @import("std").mem.zeroes(f32),
            _13: f32 = @import("std").mem.zeroes(f32),
            _14: f32 = @import("std").mem.zeroes(f32),
            _21: f32 = @import("std").mem.zeroes(f32),
            _22: f32 = @import("std").mem.zeroes(f32),
            _23: f32 = @import("std").mem.zeroes(f32),
            _24: f32 = @import("std").mem.zeroes(f32),
            _31: f32 = @import("std").mem.zeroes(f32),
            _32: f32 = @import("std").mem.zeroes(f32),
            _33: f32 = @import("std").mem.zeroes(f32),
            _34: f32 = @import("std").mem.zeroes(f32),
            _41: f32 = @import("std").mem.zeroes(f32),
            _42: f32 = @import("std").mem.zeroes(f32),
            _43: f32 = @import("std").mem.zeroes(f32),
            _44: f32 = @import("std").mem.zeroes(f32),
        },
        m: [4][4]f32,
    },
};
pub extern fn GetPointerInputTransform(pointerId: UINT32, historyCount: UINT32, inputTransform: [*c]INPUT_TRANSFORM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const LASTINPUTINFO = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    dwTime: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const PLASTINPUTINFO = [*c]LASTINPUTINFO;
pub extern fn GetLastInputInfo(plii: PLASTINPUTINFO) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const struct_HKL__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HKL = [*c]struct_HKL__;
pub const TIMERPROC = ?*const fn (HWND, UINT, UINT_PTR, DWORD) callconv(@import("std").os.windows.WINAPI) void;
pub const struct_HACCEL__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HACCEL = [*c]struct_HACCEL__;
pub const struct_HBITMAP__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HBITMAP = [*c]struct_HBITMAP__;
pub const ACCEL = extern struct {
    fVirt: BYTE = @import("std").mem.zeroes(BYTE),
    key: WORD = @import("std").mem.zeroes(WORD),
    cmd: WORD = @import("std").mem.zeroes(WORD),
};
pub const SIZE = extern struct {
    cx: LONG = @import("std").mem.zeroes(LONG),
    cy: LONG = @import("std").mem.zeroes(LONG),
};
pub const PSIZE = [*c]SIZE;
pub const LPSIZE = [*c]SIZE;
pub const SIZEL = SIZE;
pub const PSIZEL = [*c]SIZE;
pub const LPSIZEL = [*c]SIZE;
pub const LPACCEL = [*c]ACCEL;
pub const MENUTEMPLATEA = anyopaque;
pub const MENUTEMPLATEW = anyopaque;
pub const GRAYSTRINGPROC = ?*const fn (HDC, LPARAM, c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const WNDENUMPROC = ?*const fn (HWND, LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const DRAWSTATEPROC = ?*const fn (HDC, LPARAM, WPARAM, c_int, c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const HOOKPROC = ?*const fn (c_int, WPARAM, LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub const struct_HRGN__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HRGN = [*c]struct_HRGN__;
pub const struct_HRSRC__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HRSRC = [*c]struct_HRSRC__;

pub extern fn PostThreadMessageA(idThread: DWORD, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PostThreadMessageW(idThread: DWORD, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn MapVirtualKeyA(uCode: UINT, uMapType: UINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn MapVirtualKeyW(uCode: UINT, uMapType: UINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn MapVirtualKeyExA(uCode: UINT, uMapType: UINT, dwhkl: HKL) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn MapVirtualKeyExW(uCode: UINT, uMapType: UINT, dwhkl: HKL) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn GetInputState() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetQueueStatus(flags: UINT) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetCapture() callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn SetCapture(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn ReleaseCapture() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MsgWaitForMultipleObjects(nCount: DWORD, pHandles: [*c]const HANDLE, fWaitAll: BOOL, dwMilliseconds: DWORD, dwWakeMask: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn MsgWaitForMultipleObjectsEx(nCount: DWORD, pHandles: [*c]const HANDLE, dwMilliseconds: DWORD, dwWakeMask: DWORD, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetTimer(hWnd: HWND, nIDEvent: UINT_PTR, uElapse: UINT, lpTimerFunc: TIMERPROC) callconv(@import("std").os.windows.WINAPI) UINT_PTR;
pub extern fn SetCoalescableTimer(hWnd: HWND, nIDEvent: UINT_PTR, uElapse: UINT, lpTimerFunc: TIMERPROC, uToleranceDelay: ULONG) callconv(@import("std").os.windows.WINAPI) UINT_PTR;
pub extern fn KillTimer(hWnd: HWND, uIDEvent: UINT_PTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsWindowUnicode(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnableWindow(hWnd: HWND, bEnable: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsWindowEnabled(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LoadAcceleratorsA(hInstance: HINSTANCE, lpTableName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HACCEL;
pub extern fn LoadAcceleratorsW(hInstance: HINSTANCE, lpTableName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HACCEL;
pub extern fn CreateAcceleratorTableA(paccel: LPACCEL, cAccel: c_int) callconv(@import("std").os.windows.WINAPI) HACCEL;
pub extern fn CreateAcceleratorTableW(paccel: LPACCEL, cAccel: c_int) callconv(@import("std").os.windows.WINAPI) HACCEL;
pub extern fn DestroyAcceleratorTable(hAccel: HACCEL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CopyAcceleratorTableA(hAccelSrc: HACCEL, lpAccelDst: LPACCEL, cAccelEntries: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn CopyAcceleratorTableW(hAccelSrc: HACCEL, lpAccelDst: LPACCEL, cAccelEntries: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn TranslateAcceleratorA(hWnd: HWND, hAccTable: HACCEL, lpMsg: LPMSG) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn TranslateAcceleratorW(hWnd: HWND, hAccTable: HACCEL, lpMsg: LPMSG) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn LoadMenuA(hInstance: HINSTANCE, lpMenuName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn LoadMenuW(hInstance: HINSTANCE, lpMenuName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn LoadMenuIndirectA(lpMenuTemplate: ?*const MENUTEMPLATEA) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn LoadMenuIndirectW(lpMenuTemplate: ?*const MENUTEMPLATEW) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn GetMenu(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn SetMenu(hWnd: HWND, hMenu: HMENU) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ChangeMenuA(hMenu: HMENU, cmd: UINT, lpszNewItem: LPCSTR, cmdInsert: UINT, flags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ChangeMenuW(hMenu: HMENU, cmd: UINT, lpszNewItem: LPCWSTR, cmdInsert: UINT, flags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn HiliteMenuItem(hWnd: HWND, hMenu: HMENU, uIDHiliteItem: UINT, uHilite: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuStringA(hMenu: HMENU, uIDItem: UINT, lpString: LPSTR, cchMax: c_int, flags: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetMenuStringW(hMenu: HMENU, uIDItem: UINT, lpString: LPWSTR, cchMax: c_int, flags: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetMenuState(hMenu: HMENU, uId: UINT, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn DrawMenuBar(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetSystemMenu(hWnd: HWND, bRevert: BOOL) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn CreateMenu() callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn CreatePopupMenu() callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn DestroyMenu(hMenu: HMENU) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CheckMenuItem(hMenu: HMENU, uIDCheckItem: UINT, uCheck: UINT) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn EnableMenuItem(hMenu: HMENU, uIDEnableItem: UINT, uEnable: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetSubMenu(hMenu: HMENU, nPos: c_int) callconv(@import("std").os.windows.WINAPI) HMENU;
pub extern fn GetMenuItemID(hMenu: HMENU, nPos: c_int) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn GetMenuItemCount(hMenu: HMENU) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn InsertMenuA(hMenu: HMENU, uPosition: UINT, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InsertMenuW(hMenu: HMENU, uPosition: UINT, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AppendMenuA(hMenu: HMENU, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AppendMenuW(hMenu: HMENU, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ModifyMenuA(hMnu: HMENU, uPosition: UINT, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ModifyMenuW(hMnu: HMENU, uPosition: UINT, uFlags: UINT, uIDNewItem: UINT_PTR, lpNewItem: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RemoveMenu(hMenu: HMENU, uPosition: UINT, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DeleteMenu(hMenu: HMENU, uPosition: UINT, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetMenuItemBitmaps(hMenu: HMENU, uPosition: UINT, uFlags: UINT, hBitmapUnchecked: HBITMAP, hBitmapChecked: HBITMAP) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuCheckMarkDimensions() callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn TrackPopupMenu(hMenu: HMENU, uFlags: UINT, x: c_int, y: c_int, nReserved: c_int, hWnd: HWND, prcRect: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagTPMPARAMS = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    rcExclude: RECT = @import("std").mem.zeroes(RECT),
};
pub const TPMPARAMS = struct_tagTPMPARAMS;
pub const LPTPMPARAMS = [*c]TPMPARAMS;
pub extern fn TrackPopupMenuEx(hMenu: HMENU, uFlags: UINT, x: c_int, y: c_int, hwnd: HWND, lptpm: LPTPMPARAMS) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CalculatePopupWindowPosition(anchorPoint: [*c]const POINT, windowSize: [*c]const SIZE, flags: UINT, excludeRect: [*c]RECT, popupWindowPosition: [*c]RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagMENUINFO = extern struct {
    cbSize: DWORD = @import("std").mem.zeroes(DWORD),
    fMask: DWORD = @import("std").mem.zeroes(DWORD),
    dwStyle: DWORD = @import("std").mem.zeroes(DWORD),
    cyMax: UINT = @import("std").mem.zeroes(UINT),
    hbrBack: HBRUSH = @import("std").mem.zeroes(HBRUSH),
    dwContextHelpID: DWORD = @import("std").mem.zeroes(DWORD),
    dwMenuData: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
};
pub const MENUINFO = struct_tagMENUINFO;
pub const LPMENUINFO = [*c]struct_tagMENUINFO;
pub const LPCMENUINFO = [*c]const MENUINFO;
pub extern fn GetMenuInfo(HMENU, LPMENUINFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetMenuInfo(HMENU, LPCMENUINFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EndMenu() callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagMENUGETOBJECTINFO = extern struct {
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    uPos: UINT = @import("std").mem.zeroes(UINT),
    hmenu: HMENU = @import("std").mem.zeroes(HMENU),
    riid: PVOID = @import("std").mem.zeroes(PVOID),
    pvObj: PVOID = @import("std").mem.zeroes(PVOID),
};
pub const MENUGETOBJECTINFO = struct_tagMENUGETOBJECTINFO;
pub const PMENUGETOBJECTINFO = [*c]struct_tagMENUGETOBJECTINFO;
pub const struct_tagMENUITEMINFOA = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    fMask: UINT = @import("std").mem.zeroes(UINT),
    fType: UINT = @import("std").mem.zeroes(UINT),
    fState: UINT = @import("std").mem.zeroes(UINT),
    wID: UINT = @import("std").mem.zeroes(UINT),
    hSubMenu: HMENU = @import("std").mem.zeroes(HMENU),
    hbmpChecked: HBITMAP = @import("std").mem.zeroes(HBITMAP),
    hbmpUnchecked: HBITMAP = @import("std").mem.zeroes(HBITMAP),
    dwItemData: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    dwTypeData: LPSTR = @import("std").mem.zeroes(LPSTR),
    cch: UINT = @import("std").mem.zeroes(UINT),
    hbmpItem: HBITMAP = @import("std").mem.zeroes(HBITMAP),
};
pub const MENUITEMINFOA = struct_tagMENUITEMINFOA;
pub const LPMENUITEMINFOA = [*c]struct_tagMENUITEMINFOA;
pub const struct_tagMENUITEMINFOW = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    fMask: UINT = @import("std").mem.zeroes(UINT),
    fType: UINT = @import("std").mem.zeroes(UINT),
    fState: UINT = @import("std").mem.zeroes(UINT),
    wID: UINT = @import("std").mem.zeroes(UINT),
    hSubMenu: HMENU = @import("std").mem.zeroes(HMENU),
    hbmpChecked: HBITMAP = @import("std").mem.zeroes(HBITMAP),
    hbmpUnchecked: HBITMAP = @import("std").mem.zeroes(HBITMAP),
    dwItemData: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    dwTypeData: LPWSTR = @import("std").mem.zeroes(LPWSTR),
    cch: UINT = @import("std").mem.zeroes(UINT),
    hbmpItem: HBITMAP = @import("std").mem.zeroes(HBITMAP),
};
pub const MENUITEMINFOW = struct_tagMENUITEMINFOW;
pub const LPMENUITEMINFOW = [*c]struct_tagMENUITEMINFOW;
pub const MENUITEMINFO = MENUITEMINFOA;
pub const LPMENUITEMINFO = LPMENUITEMINFOA;
pub const LPCMENUITEMINFOA = [*c]const MENUITEMINFOA;
pub const LPCMENUITEMINFOW = [*c]const MENUITEMINFOW;
pub const LPCMENUITEMINFO = LPCMENUITEMINFOA;
pub extern fn InsertMenuItemA(hmenu: HMENU, item: UINT, fByPosition: BOOL, lpmi: LPCMENUITEMINFOA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InsertMenuItemW(hmenu: HMENU, item: UINT, fByPosition: BOOL, lpmi: LPCMENUITEMINFOW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuItemInfoA(hmenu: HMENU, item: UINT, fByPosition: BOOL, lpmii: LPMENUITEMINFOA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuItemInfoW(hmenu: HMENU, item: UINT, fByPosition: BOOL, lpmii: LPMENUITEMINFOW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetMenuItemInfoA(hmenu: HMENU, item: UINT, fByPositon: BOOL, lpmii: LPCMENUITEMINFOA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetMenuItemInfoW(hmenu: HMENU, item: UINT, fByPositon: BOOL, lpmii: LPCMENUITEMINFOW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuDefaultItem(hMenu: HMENU, fByPos: UINT, gmdiFlags: UINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn SetMenuDefaultItem(hMenu: HMENU, uItem: UINT, fByPos: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuItemRect(hWnd: HWND, hMenu: HMENU, uItem: UINT, lprcItem: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MenuItemFromPoint(hWnd: HWND, hMenu: HMENU, ptScreen: POINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub const struct_tagDROPSTRUCT = extern struct {
    hwndSource: HWND = @import("std").mem.zeroes(HWND),
    hwndSink: HWND = @import("std").mem.zeroes(HWND),
    wFmt: DWORD = @import("std").mem.zeroes(DWORD),
    dwData: ULONG_PTR = @import("std").mem.zeroes(ULONG_PTR),
    ptDrop: POINT = @import("std").mem.zeroes(POINT),
    dwControlData: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const DROPSTRUCT = struct_tagDROPSTRUCT;
pub const PDROPSTRUCT = [*c]struct_tagDROPSTRUCT;
pub const LPDROPSTRUCT = [*c]struct_tagDROPSTRUCT;
pub extern fn DragObject(hwndParent: HWND, hwndFrom: HWND, fmt: UINT, data: ULONG_PTR, hcur: HCURSOR) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn DragDetect(hwnd: HWND, pt: POINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DrawIcon(hDC: HDC, X: c_int, Y: c_int, hIcon: HICON) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const DRAWTEXTPARAMS = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    iTabLength: c_int = @import("std").mem.zeroes(c_int),
    iLeftMargin: c_int = @import("std").mem.zeroes(c_int),
    iRightMargin: c_int = @import("std").mem.zeroes(c_int),
    uiLengthDrawn: UINT = @import("std").mem.zeroes(UINT),
};
pub const LPDRAWTEXTPARAMS = [*c]DRAWTEXTPARAMS;
pub const PAINTSTRUCT = extern struct {
    hdc: HDC = @import("std").mem.zeroes(HDC),
    fErase: BOOL = @import("std").mem.zeroes(BOOL),
    rcPaint: RECT = @import("std").mem.zeroes(RECT),
    fRestore: BOOL = @import("std").mem.zeroes(BOOL),
    fIncUpdate: BOOL = @import("std").mem.zeroes(BOOL),
    rgbReserved: [32]BYTE = @import("std").mem.zeroes([32]BYTE),
};
pub const PPAINTSTRUCT = [*c]PAINTSTRUCT;
pub const NPPAINTSTRUCT = [*c]PAINTSTRUCT;
pub const LPPAINTSTRUCT = [*c]PAINTSTRUCT;

pub extern fn DrawTextA(hdc: HDC, lpchText: LPCSTR, cchText: c_int, lprc: LPRECT, format: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn DrawTextW(hdc: HDC, lpchText: LPCWSTR, cchText: c_int, lprc: LPRECT, format: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn DrawTextExA(hdc: HDC, lpchText: LPSTR, cchText: c_int, lprc: LPRECT, format: UINT, lpdtp: LPDRAWTEXTPARAMS) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn DrawTextExW(hdc: HDC, lpchText: LPWSTR, cchText: c_int, lprc: LPRECT, format: UINT, lpdtp: LPDRAWTEXTPARAMS) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GrayStringA(hDC: HDC, hBrush: HBRUSH, lpOutputFunc: GRAYSTRINGPROC, lpData: LPARAM, nCount: c_int, X: c_int, Y: c_int, nWidth: c_int, nHeight: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GrayStringW(hDC: HDC, hBrush: HBRUSH, lpOutputFunc: GRAYSTRINGPROC, lpData: LPARAM, nCount: c_int, X: c_int, Y: c_int, nWidth: c_int, nHeight: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DrawStateA(hdc: HDC, hbrFore: HBRUSH, qfnCallBack: DRAWSTATEPROC, lData: LPARAM, wData: WPARAM, x: c_int, y: c_int, cx: c_int, cy: c_int, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DrawStateW(hdc: HDC, hbrFore: HBRUSH, qfnCallBack: DRAWSTATEPROC, lData: LPARAM, wData: WPARAM, x: c_int, y: c_int, cx: c_int, cy: c_int, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn TabbedTextOutA(hdc: HDC, x: c_int, y: c_int, lpString: LPCSTR, chCount: c_int, nTabPositions: c_int, lpnTabStopPositions: [*c]const INT, nTabOrigin: c_int) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn TabbedTextOutW(hdc: HDC, x: c_int, y: c_int, lpString: LPCWSTR, chCount: c_int, nTabPositions: c_int, lpnTabStopPositions: [*c]const INT, nTabOrigin: c_int) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn GetTabbedTextExtentA(hdc: HDC, lpString: LPCSTR, chCount: c_int, nTabPositions: c_int, lpnTabStopPositions: [*c]const INT) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetTabbedTextExtentW(hdc: HDC, lpString: LPCWSTR, chCount: c_int, nTabPositions: c_int, lpnTabStopPositions: [*c]const INT) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetActiveWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetForegroundWindow() callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn PaintDesktop(hdc: HDC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SwitchToThisWindow(hwnd: HWND, fUnknown: BOOL) callconv(@import("std").os.windows.WINAPI) void;
pub extern fn SetForegroundWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AllowSetForegroundWindow(dwProcessId: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LockSetForegroundWindow(uLockCode: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn WindowFromDC(hDC: HDC) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetDC(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HDC;
pub extern fn GetDCEx(hWnd: HWND, hrgnClip: HRGN, flags: DWORD) callconv(@import("std").os.windows.WINAPI) HDC;
pub extern fn GetWindowDC(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HDC;
pub extern fn ReleaseDC(hWnd: HWND, hDC: HDC) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn BeginPaint(hWnd: HWND, lpPaint: LPPAINTSTRUCT) callconv(@import("std").os.windows.WINAPI) HDC;
pub extern fn EndPaint(hWnd: HWND, lpPaint: [*c]const PAINTSTRUCT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetUpdateRect(hWnd: HWND, lpRect: LPRECT, bErase: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetUpdateRgn(hWnd: HWND, hRgn: HRGN, bErase: BOOL) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn SetWindowRgn(hWnd: HWND, hRgn: HRGN, bRedraw: BOOL) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowRgn(hWnd: HWND, hRgn: HRGN) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowRgnBox(hWnd: HWND, lprc: LPRECT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn ExcludeUpdateRgn(hDC: HDC, hWnd: HWND) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn InvalidateRect(hWnd: HWND, lpRect: [*c]const RECT, bErase: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ValidateRect(hWnd: HWND, lpRect: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InvalidateRgn(hWnd: HWND, hRgn: HRGN, bErase: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ValidateRgn(hWnd: HWND, hRgn: HRGN) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RedrawWindow(hWnd: HWND, lprcUpdate: [*c]const RECT, hrgnUpdate: HRGN, flags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LockWindowUpdate(hWndLock: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ScrollWindow(hWnd: HWND, XAmount: c_int, YAmount: c_int, lpRect: [*c]const RECT, lpClipRect: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ScrollDC(hDC: HDC, dx: c_int, dy: c_int, lprcScroll: [*c]const RECT, lprcClip: [*c]const RECT, hrgnUpdate: HRGN, lprcUpdate: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ScrollWindowEx(hWnd: HWND, dx: c_int, dy: c_int, prcScroll: [*c]const RECT, prcClip: [*c]const RECT, hrgnUpdate: HRGN, prcUpdate: LPRECT, flags: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn SetScrollPos(hWnd: HWND, nBar: c_int, nPos: c_int, bRedraw: BOOL) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetScrollPos(hWnd: HWND, nBar: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn SetScrollRange(hWnd: HWND, nBar: c_int, nMinPos: c_int, nMaxPos: c_int, bRedraw: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetScrollRange(hWnd: HWND, nBar: c_int, lpMinPos: LPINT, lpMaxPos: LPINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ShowScrollBar(hWnd: HWND, wBar: c_int, bShow: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnableScrollBar(hWnd: HWND, wSBflags: UINT, wArrows: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetPropA(hWnd: HWND, lpString: LPCSTR, hData: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetPropW(hWnd: HWND, lpString: LPCWSTR, hData: HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPropA(hWnd: HWND, lpString: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn GetPropW(hWnd: HWND, lpString: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn RemovePropA(hWnd: HWND, lpString: LPCSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;
pub extern fn RemovePropW(hWnd: HWND, lpString: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HANDLE;

pub extern fn WaitMessage() callconv(@import("std").os.windows.WINAPI) BOOL;

pub const PROPENUMPROCEXA = ?*const fn (HWND, LPSTR, HANDLE, ULONG_PTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PROPENUMPROCEXW = ?*const fn (HWND, LPWSTR, HANDLE, ULONG_PTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PROPENUMPROCA = ?*const fn (HWND, LPCSTR, HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PROPENUMPROCW = ?*const fn (HWND, LPCWSTR, HANDLE) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn EnumPropsExA(hWnd: HWND, lpEnumFunc: PROPENUMPROCEXA, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn EnumPropsExW(hWnd: HWND, lpEnumFunc: PROPENUMPROCEXW, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn EnumPropsA(hWnd: HWND, lpEnumFunc: PROPENUMPROCA) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn EnumPropsW(hWnd: HWND, lpEnumFunc: PROPENUMPROCW) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn SetWindowTextA(hWnd: HWND, lpString: LPCSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowTextW(hWnd: HWND, lpString: LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetWindowTextA(hWnd: HWND, lpString: LPSTR, nMaxCount: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowTextW(hWnd: HWND, lpString: LPWSTR, nMaxCount: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowTextLengthA(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowTextLengthW(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetWindowRect(hWnd: HWND, lpRect: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AdjustWindowRect(lpRect: LPRECT, dwStyle: DWORD, bMenu: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const HELPINFO = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    iContextType: c_int = @import("std").mem.zeroes(c_int),
    iCtrlId: c_int = @import("std").mem.zeroes(c_int),
    hItemHandle: HANDLE = @import("std").mem.zeroes(HANDLE),
    dwContextId: DWORD_PTR = @import("std").mem.zeroes(DWORD_PTR),
    MousePos: POINT = @import("std").mem.zeroes(POINT),
};
pub const LPHELPINFO = [*c]HELPINFO;
pub extern fn SetWindowContextHelpId(HWND, DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetWindowContextHelpId(HWND) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetMenuContextHelpId(HMENU, DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetMenuContextHelpId(HMENU) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn MessageBoxExA(hWnd: HWND, lpText: LPCSTR, lpCaption: LPCSTR, uType: UINT, wLanguageId: WORD) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn MessageBoxExW(hWnd: HWND, lpText: LPCWSTR, lpCaption: LPCWSTR, uType: UINT, wLanguageId: WORD) callconv(@import("std").os.windows.WINAPI) c_int;
pub const MSGBOXCALLBACK = ?*const fn (LPHELPINFO) callconv(@import("std").os.windows.WINAPI) void;
pub const MSGBOXPARAMSA = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    hwndOwner: HWND = @import("std").mem.zeroes(HWND),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    lpszText: LPCSTR = @import("std").mem.zeroes(LPCSTR),
    lpszCaption: LPCSTR = @import("std").mem.zeroes(LPCSTR),
    dwStyle: DWORD = @import("std").mem.zeroes(DWORD),
    lpszIcon: LPCSTR = @import("std").mem.zeroes(LPCSTR),
    dwContextHelpId: DWORD_PTR = @import("std").mem.zeroes(DWORD_PTR),
    lpfnMsgBoxCallback: MSGBOXCALLBACK = @import("std").mem.zeroes(MSGBOXCALLBACK),
    dwLanguageId: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const PMSGBOXPARAMSA = [*c]MSGBOXPARAMSA;
pub const LPMSGBOXPARAMSA = [*c]MSGBOXPARAMSA;
pub const MSGBOXPARAMSW = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    hwndOwner: HWND = @import("std").mem.zeroes(HWND),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    lpszText: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    lpszCaption: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    dwStyle: DWORD = @import("std").mem.zeroes(DWORD),
    lpszIcon: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    dwContextHelpId: DWORD_PTR = @import("std").mem.zeroes(DWORD_PTR),
    lpfnMsgBoxCallback: MSGBOXCALLBACK = @import("std").mem.zeroes(MSGBOXCALLBACK),
    dwLanguageId: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const PMSGBOXPARAMSW = [*c]MSGBOXPARAMSW;
pub const LPMSGBOXPARAMSW = [*c]MSGBOXPARAMSW;
pub const MSGBOXPARAMS = MSGBOXPARAMSA;
pub const PMSGBOXPARAMS = PMSGBOXPARAMSA;
pub const LPMSGBOXPARAMS = LPMSGBOXPARAMSA;
pub extern fn MessageBoxIndirectA(lpmbp: [*c]const MSGBOXPARAMSA) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn MessageBoxIndirectW(lpmbp: [*c]const MSGBOXPARAMSW) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn MessageBeep(uType: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ShowCursor(bShow: BOOL) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn SetCursorPos(X: c_int, Y: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetPhysicalCursorPos(X: c_int, Y: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCursorPos(lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetPhysicalCursorPos(lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ClipCursor(lpRect: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClipCursor(lpRect: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCursor() callconv(@import("std").os.windows.WINAPI) HCURSOR;
pub extern fn CreateCaret(hWnd: HWND, hBitmap: HBITMAP, nWidth: c_int, nHeight: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCaretBlinkTime() callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn SetCaretBlinkTime(uMSeconds: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DestroyCaret() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn HideCaret(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ShowCaret(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetCaretPos(X: c_int, Y: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetCaretPos(lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ClientToScreen(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ScreenToClient(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LogicalToPhysicalPoint(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PhysicalToLogicalPoint(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn LogicalToPhysicalPointForPerMonitorDPI(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PhysicalToLogicalPointForPerMonitorDPI(hWnd: HWND, lpPoint: LPPOINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MapWindowPoints(hWndFrom: HWND, hWndTo: HWND, lpPoints: LPPOINT, cPoints: UINT) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn WindowFromPoint(Point: POINT) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn WindowFromPhysicalPoint(Point: POINT) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn ChildWindowFromPoint(hWndParent: HWND, Point: POINT) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn ChildWindowFromPointEx(hwnd: HWND, pt: POINT, flags: UINT) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetSysColor(nIndex: c_int) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetSysColorBrush(nIndex: c_int) callconv(@import("std").os.windows.WINAPI) HBRUSH;
pub const COLORREF = DWORD;
pub const LPCOLORREF = [*c]DWORD;
pub extern fn SetSysColors(cElements: c_int, lpaElements: [*c]const INT, lpaRgbValues: [*c]const COLORREF) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DrawFocusRect(hDC: HDC, lprc: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FillRect(hDC: HDC, lprc: [*c]const RECT, hbr: HBRUSH) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn FrameRect(hDC: HDC, lprc: [*c]const RECT, hbr: HBRUSH) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn InvertRect(hDC: HDC, lprc: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetRect(lprc: LPRECT, xLeft: c_int, yTop: c_int, xRight: c_int, yBottom: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetRectEmpty(lprc: LPRECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CopyRect(lprcDst: LPRECT, lprcSrc: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InflateRect(lprc: LPRECT, dx: c_int, dy: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IntersectRect(lprcDst: LPRECT, lprcSrc1: [*c]const RECT, lprcSrc2: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn UnionRect(lprcDst: LPRECT, lprcSrc1: [*c]const RECT, lprcSrc2: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SubtractRect(lprcDst: LPRECT, lprcSrc1: [*c]const RECT, lprcSrc2: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn OffsetRect(lprc: LPRECT, dx: c_int, dy: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsRectEmpty(lprc: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EqualRect(lprc1: [*c]const RECT, lprc2: [*c]const RECT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PtInRect(lprc: [*c]const RECT, pt: POINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetWindowWord(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) WORD;
pub extern fn SetWindowWord(hWnd: HWND, nIndex: c_int, wNewWord: WORD) callconv(@import("std").os.windows.WINAPI) WORD;
pub extern fn GetWindowLongA(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn GetWindowLongW(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn SetWindowLongA(hWnd: HWND, nIndex: c_int, dwNewLong: LONG) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn SetWindowLongW(hWnd: HWND, nIndex: c_int, dwNewLong: LONG) callconv(@import("std").os.windows.WINAPI) LONG;
pub extern fn GetWindowLongPtrA(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) LONG_PTR;
pub extern fn GetWindowLongPtrW(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) LONG_PTR;
pub extern fn SetWindowLongPtrA(hWnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) callconv(@import("std").os.windows.WINAPI) LONG_PTR;
pub extern fn SetWindowLongPtrW(hWnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) callconv(@import("std").os.windows.WINAPI) LONG_PTR;
pub extern fn GetClassWord(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) WORD;
pub extern fn SetClassWord(hWnd: HWND, nIndex: c_int, wNewWord: WORD) callconv(@import("std").os.windows.WINAPI) WORD;
pub extern fn GetClassLongA(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetClassLongW(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetClassLongA(hWnd: HWND, nIndex: c_int, dwNewLong: LONG) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn SetClassLongW(hWnd: HWND, nIndex: c_int, dwNewLong: LONG) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetClassLongPtrA(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) ULONG_PTR;
pub extern fn GetClassLongPtrW(hWnd: HWND, nIndex: c_int) callconv(@import("std").os.windows.WINAPI) ULONG_PTR;
pub extern fn SetClassLongPtrA(hWnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) callconv(@import("std").os.windows.WINAPI) ULONG_PTR;
pub extern fn SetClassLongPtrW(hWnd: HWND, nIndex: c_int, dwNewLong: LONG_PTR) callconv(@import("std").os.windows.WINAPI) ULONG_PTR;
pub extern fn GetProcessDefaultLayout(pdwDefaultLayout: [*c]DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetProcessDefaultLayout(dwDefaultLayout: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetDesktopWindow() callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetParent(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn SetParent(hWndChild: HWND, hWndNewParent: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn EnumChildWindows(hWndParent: HWND, lpEnumFunc: WNDENUMPROC, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FindWindowA(lpClassName: LPCSTR, lpWindowName: LPCSTR) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn FindWindowW(lpClassName: LPCWSTR, lpWindowName: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn FindWindowExA(hWndParent: HWND, hWndChildAfter: HWND, lpszClass: LPCSTR, lpszWindow: LPCSTR) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn FindWindowExW(hWndParent: HWND, hWndChildAfter: HWND, lpszClass: LPCWSTR, lpszWindow: LPCWSTR) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetShellWindow() callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn RegisterShellHookWindow(hwnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn DeregisterShellHookWindow(hwnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnumWindows(lpEnumFunc: WNDENUMPROC, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn EnumThreadWindows(dwThreadId: DWORD, lpfn: WNDENUMPROC, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClassNameA(hWnd: HWND, lpClassName: LPSTR, nMaxCount: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetClassNameW(hWnd: HWND, lpClassName: LPWSTR, nMaxCount: c_int) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn GetTopWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetWindowThreadProcessId(hWnd: HWND, lpdwProcessId: LPDWORD) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn IsGUIThread(bConvert: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetLastActivePopup(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) HWND;
pub extern fn GetWindow(hWnd: HWND, uCmd: UINT) callconv(@import("std").os.windows.WINAPI) HWND;

pub const struct_HHOOK__ = extern struct {
    unused: c_int = @import("std").mem.zeroes(c_int),
};
pub const HHOOK = [*c]struct_HHOOK__;
pub extern fn SetWindowsHookA(nFilterType: c_int, pfnFilterProc: HOOKPROC) callconv(@import("std").os.windows.WINAPI) HHOOK;
pub extern fn SetWindowsHookW(nFilterType: c_int, pfnFilterProc: HOOKPROC) callconv(@import("std").os.windows.WINAPI) HHOOK;
pub extern fn UnhookWindowsHook(nCode: c_int, pfnFilterProc: HOOKPROC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowsHookExA(idHook: c_int, lpfn: HOOKPROC, hmod: HINSTANCE, dwThreadId: DWORD) callconv(@import("std").os.windows.WINAPI) HHOOK;
pub extern fn SetWindowsHookExW(idHook: c_int, lpfn: HOOKPROC, hmod: HINSTANCE, dwThreadId: DWORD) callconv(@import("std").os.windows.WINAPI) HHOOK;
pub extern fn UnhookWindowsHookEx(hhk: HHOOK) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CallNextHookEx(hhk: HHOOK, nCode: c_int, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn CheckMenuRadioItem(hmenu: HMENU, first: UINT, last: UINT, check: UINT, flags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const RECTL = extern struct {
    left: LONG = @import("std").mem.zeroes(LONG),
    top: LONG = @import("std").mem.zeroes(LONG),
    right: LONG = @import("std").mem.zeroes(LONG),
    bottom: LONG = @import("std").mem.zeroes(LONG),
};

pub extern fn wglCopyContext(HGLRC, HGLRC, UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglCreateContext(HDC) callconv(@import("std").os.windows.WINAPI) HGLRC;
pub extern fn wglCreateLayerContext(HDC, c_int) callconv(@import("std").os.windows.WINAPI) HGLRC;
pub extern fn wglDeleteContext(HGLRC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglGetCurrentContext() callconv(@import("std").os.windows.WINAPI) HGLRC;
pub extern fn wglGetCurrentDC() callconv(@import("std").os.windows.WINAPI) HDC;
pub extern fn wglMakeCurrent(HDC, HGLRC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglShareLists(HGLRC, HGLRC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglUseFontBitmapsA(HDC, DWORD, DWORD, DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglUseFontBitmapsW(HDC, DWORD, DWORD, DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SwapBuffers(HDC) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct__POINTFLOAT = extern struct {
    x: FLOAT = @import("std").mem.zeroes(FLOAT),
    y: FLOAT = @import("std").mem.zeroes(FLOAT),
};
pub const POINTFLOAT = struct__POINTFLOAT;
pub const PPOINTFLOAT = [*c]struct__POINTFLOAT;
pub const struct__GLYPHMETRICSFLOAT = extern struct {
    gmfBlackBoxX: FLOAT = @import("std").mem.zeroes(FLOAT),
    gmfBlackBoxY: FLOAT = @import("std").mem.zeroes(FLOAT),
    gmfptGlyphOrigin: POINTFLOAT = @import("std").mem.zeroes(POINTFLOAT),
    gmfCellIncX: FLOAT = @import("std").mem.zeroes(FLOAT),
    gmfCellIncY: FLOAT = @import("std").mem.zeroes(FLOAT),
};
pub const GLYPHMETRICSFLOAT = struct__GLYPHMETRICSFLOAT;
pub const PGLYPHMETRICSFLOAT = [*c]struct__GLYPHMETRICSFLOAT;
pub const LPGLYPHMETRICSFLOAT = [*c]struct__GLYPHMETRICSFLOAT;
pub extern fn wglUseFontOutlinesA(HDC, DWORD, DWORD, DWORD, FLOAT, FLOAT, c_int, LPGLYPHMETRICSFLOAT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglUseFontOutlinesW(HDC, DWORD, DWORD, DWORD, FLOAT, FLOAT, c_int, LPGLYPHMETRICSFLOAT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct_tagLAYERPLANEDESCRIPTOR = extern struct {
    nSize: WORD = @import("std").mem.zeroes(WORD),
    nVersion: WORD = @import("std").mem.zeroes(WORD),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    iPixelType: BYTE = @import("std").mem.zeroes(BYTE),
    cColorBits: BYTE = @import("std").mem.zeroes(BYTE),
    cRedBits: BYTE = @import("std").mem.zeroes(BYTE),
    cRedShift: BYTE = @import("std").mem.zeroes(BYTE),
    cGreenBits: BYTE = @import("std").mem.zeroes(BYTE),
    cGreenShift: BYTE = @import("std").mem.zeroes(BYTE),
    cBlueBits: BYTE = @import("std").mem.zeroes(BYTE),
    cBlueShift: BYTE = @import("std").mem.zeroes(BYTE),
    cAlphaBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAlphaShift: BYTE = @import("std").mem.zeroes(BYTE),
    cAccumBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAccumRedBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAccumGreenBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAccumBlueBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAccumAlphaBits: BYTE = @import("std").mem.zeroes(BYTE),
    cDepthBits: BYTE = @import("std").mem.zeroes(BYTE),
    cStencilBits: BYTE = @import("std").mem.zeroes(BYTE),
    cAuxBuffers: BYTE = @import("std").mem.zeroes(BYTE),
    iLayerPlane: BYTE = @import("std").mem.zeroes(BYTE),
    bReserved: BYTE = @import("std").mem.zeroes(BYTE),
    crTransparent: COLORREF = @import("std").mem.zeroes(COLORREF),
};
pub const LAYERPLANEDESCRIPTOR = struct_tagLAYERPLANEDESCRIPTOR;
pub const PLAYERPLANEDESCRIPTOR = [*c]struct_tagLAYERPLANEDESCRIPTOR;
pub const LPLAYERPLANEDESCRIPTOR = [*c]struct_tagLAYERPLANEDESCRIPTOR;
pub extern fn wglDescribeLayerPlane(HDC, c_int, c_int, UINT, LPLAYERPLANEDESCRIPTOR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglSetLayerPaletteEntries(HDC, c_int, c_int, c_int, [*c]const COLORREF) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn wglGetLayerPaletteEntries(HDC, c_int, c_int, c_int, [*c]COLORREF) callconv(@import("std").os.windows.WINAPI) c_int;
pub extern fn wglRealizeLayerPalette(HDC, c_int, BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn wglSwapLayerBuffers(HDC, UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const struct__WGLSWAP = extern struct {
    hdc: HDC = @import("std").mem.zeroes(HDC),
    uiFlags: UINT = @import("std").mem.zeroes(UINT),
};
pub const WGLSWAP = struct__WGLSWAP;
pub const PWGLSWAP = [*c]struct__WGLSWAP;
pub const LPWGLSWAP = [*c]struct__WGLSWAP;
pub extern fn wglSwapMultipleBuffers(UINT, [*c]const WGLSWAP) callconv(@import("std").os.windows.WINAPI) DWORD;
pub const PALETTEENTRY = extern struct {
    peRed: BYTE = @import("std").mem.zeroes(BYTE),
    peGreen: BYTE = @import("std").mem.zeroes(BYTE),
    peBlue: BYTE = @import("std").mem.zeroes(BYTE),
    peFlags: BYTE = @import("std").mem.zeroes(BYTE),
};
pub const PPALETTEENTRY = [*c]PALETTEENTRY;
pub const LPPALETTEENTRY = [*c]PALETTEENTRY;
pub const COLORADJUSTMENT = extern struct {
    caSize: WORD = @import("std").mem.zeroes(WORD),
    caFlags: WORD = @import("std").mem.zeroes(WORD),
    caIlluminantIndex: WORD = @import("std").mem.zeroes(WORD),
    caRedGamma: WORD = @import("std").mem.zeroes(WORD),
    caGreenGamma: WORD = @import("std").mem.zeroes(WORD),
    caBlueGamma: WORD = @import("std").mem.zeroes(WORD),
    caReferenceBlack: WORD = @import("std").mem.zeroes(WORD),
    caReferenceWhite: WORD = @import("std").mem.zeroes(WORD),
    caContrast: SHORT = @import("std").mem.zeroes(SHORT),
    caBrightness: SHORT = @import("std").mem.zeroes(SHORT),
    caColorfulness: SHORT = @import("std").mem.zeroes(SHORT),
    caRedGreenTint: SHORT = @import("std").mem.zeroes(SHORT),
};
pub const PCOLORADJUSTMENT = [*c]COLORADJUSTMENT;
pub const LPCOLORADJUSTMENT = [*c]COLORADJUSTMENT;

pub const struct_tagWINDOWPLACEMENT = extern struct {
    length: UINT = @import("std").mem.zeroes(UINT),
    flags: UINT = @import("std").mem.zeroes(UINT),
    showCmd: UINT = @import("std").mem.zeroes(UINT),
    ptMinPosition: POINT = @import("std").mem.zeroes(POINT),
    ptMaxPosition: POINT = @import("std").mem.zeroes(POINT),
    rcNormalPosition: RECT = @import("std").mem.zeroes(RECT),
};
pub const WINDOWPLACEMENT = struct_tagWINDOWPLACEMENT;
pub const PWINDOWPLACEMENT = [*c]WINDOWPLACEMENT;
pub const LPWINDOWPLACEMENT = [*c]WINDOWPLACEMENT;

pub const NPWNDCLASSA = [*c]WNDCLASSA;
pub const LPWNDCLASSA = [*c]WNDCLASSA;
pub const WNDCLASSW = extern struct {
    style: UINT = @import("std").mem.zeroes(UINT),
    lpfnWndProc: WNDPROC = @import("std").mem.zeroes(WNDPROC),
    cbClsExtra: c_int = @import("std").mem.zeroes(c_int),
    cbWndExtra: c_int = @import("std").mem.zeroes(c_int),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    hIcon: HICON = @import("std").mem.zeroes(HICON),
    hCursor: HCURSOR = @import("std").mem.zeroes(HCURSOR),
    hbrBackground: HBRUSH = @import("std").mem.zeroes(HBRUSH),
    lpszMenuName: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    lpszClassName: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
};
pub const NPWNDCLASSW = [*c]WNDCLASSW;
pub const LPWNDCLASSW = [*c]WNDCLASSW;
pub const PWNDCLASSW = [*c]WNDCLASSW;

pub const WNDCLASSEXA = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    style: UINT = @import("std").mem.zeroes(UINT),
    lpfnWndProc: WNDPROC = @import("std").mem.zeroes(WNDPROC),
    cbClsExtra: c_int = @import("std").mem.zeroes(c_int),
    cbWndExtra: c_int = @import("std").mem.zeroes(c_int),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    hIcon: HICON = @import("std").mem.zeroes(HICON),
    hCursor: HCURSOR = @import("std").mem.zeroes(HCURSOR),
    hbrBackground: HBRUSH = @import("std").mem.zeroes(HBRUSH),
    lpszMenuName: LPCSTR = @import("std").mem.zeroes(LPCSTR),
    lpszClassName: LPCSTR = @import("std").mem.zeroes(LPCSTR),
    hIconSm: HICON = @import("std").mem.zeroes(HICON),
};
pub const PWNDCLASSEXA = [*c]WNDCLASSEXA;
pub const NPWNDCLASSEXA = [*c]WNDCLASSEXA;
pub const LPWNDCLASSEXA = [*c]WNDCLASSEXA;
pub const WNDCLASSEXW = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    style: UINT = @import("std").mem.zeroes(UINT),
    lpfnWndProc: WNDPROC = @import("std").mem.zeroes(WNDPROC),
    cbClsExtra: c_int = @import("std").mem.zeroes(c_int),
    cbWndExtra: c_int = @import("std").mem.zeroes(c_int),
    hInstance: HINSTANCE = @import("std").mem.zeroes(HINSTANCE),
    hIcon: HICON = @import("std").mem.zeroes(HICON),
    hCursor: HCURSOR = @import("std").mem.zeroes(HCURSOR),
    hbrBackground: HBRUSH = @import("std").mem.zeroes(HBRUSH),
    lpszMenuName: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    lpszClassName: LPCWSTR = @import("std").mem.zeroes(LPCWSTR),
    hIconSm: HICON = @import("std").mem.zeroes(HICON),
};
pub const PWNDCLASSEXW = [*c]WNDCLASSEXW;
pub const NPWNDCLASSEXW = [*c]WNDCLASSEXW;
pub const LPWNDCLASSEXW = [*c]WNDCLASSEXW;
pub const HDWP = HANDLE;

pub const AW_HOR_POSITIVE = @as(DWORD, 0x00000001);
pub const AW_HOR_NEGATIVE = @as(DWORD, 0x00000002);
pub const AW_VER_POSITIVE = @as(DWORD, 0x00000004);
pub const AW_VER_NEGATIVE = @as(DWORD, 0x00000008);
pub const AW_CENTER = @as(DWORD, 0x00000010);
pub const AW_HIDE = @import("std").zig.c_translation.promoteIntLiteral(DWORD, 0x00010000, .hex);
pub const AW_ACTIVATE = @import("std").zig.c_translation.promoteIntLiteral(DWORD, 0x00020000, .hex);
pub const AW_SLIDE = @import("std").zig.c_translation.promoteIntLiteral(DWORD, 0x00040000, .hex);
pub const AW_BLEND = @import("std").zig.c_translation.promoteIntLiteral(DWORD, 0x00080000, .hex);

pub extern fn CallWindowProcA(lpPrevWndFunc: WNDPROC, hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn CallWindowProcW(lpPrevWndFunc: WNDPROC, hWnd: HWND, Msg: UINT, wParam: WPARAM, lParam: LPARAM) callconv(@import("std").os.windows.WINAPI) LRESULT;
pub extern fn InSendMessage() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn InSendMessageEx(lpReserved: LPVOID) callconv(@import("std").os.windows.WINAPI) DWORD;
pub extern fn GetDoubleClickTime() callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn SetDoubleClickTime(UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClassInfoA(hInstance: HINSTANCE, lpClassName: LPCSTR, lpWndClass: LPWNDCLASSA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClassInfoW(hInstance: HINSTANCE, lpClassName: LPCWSTR, lpWndClass: LPWNDCLASSW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn RegisterClassExA([*c]const WNDCLASSEXA) callconv(@import("std").os.windows.WINAPI) ATOM;
pub extern fn RegisterClassExW([*c]const WNDCLASSEXW) callconv(@import("std").os.windows.WINAPI) ATOM;
pub extern fn GetClassInfoExA(hInstance: HINSTANCE, lpszClass: LPCSTR, lpwcx: LPWNDCLASSEXA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetClassInfoExW(hInstance: HINSTANCE, lpszClass: LPCWSTR, lpwcx: LPWNDCLASSEXW) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const PREGISTERCLASSNAMEW = ?*const fn (LPCWSTR) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsMenu(hMenu: HMENU) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsChild(hWndParent: HWND, hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AnimateWindow(hWnd: HWND, dwTime: DWORD, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetLayeredWindowAttributes(hwnd: HWND, pcrKey: [*c]COLORREF, pbAlpha: [*c]BYTE, pdwFlags: [*c]DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn PrintWindow(hwnd: HWND, hdcBlt: HDC, nFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetLayeredWindowAttributes(hwnd: HWND, crKey: COLORREF, bAlpha: BYTE, dwFlags: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ShowWindowAsync(hWnd: HWND, nCmdShow: c_int) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn FlashWindow(hWnd: HWND, bInvert: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const FLASHWINFO = extern struct {
    cbSize: UINT = @import("std").mem.zeroes(UINT),
    hwnd: HWND = @import("std").mem.zeroes(HWND),
    dwFlags: DWORD = @import("std").mem.zeroes(DWORD),
    uCount: UINT = @import("std").mem.zeroes(UINT),
    dwTimeout: DWORD = @import("std").mem.zeroes(DWORD),
};
pub const PFLASHWINFO = [*c]FLASHWINFO;
pub extern fn FlashWindowEx(pfwi: PFLASHWINFO) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn ShowOwnedPopups(hWnd: HWND, fShow: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn OpenIcon(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn CloseWindow(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn MoveWindow(hWnd: HWND, X: c_int, Y: c_int, nWidth: c_int, nHeight: c_int, bRepaint: BOOL) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowPos(hWnd: HWND, hWndInsertAfter: HWND, X: c_int, Y: c_int, cx: c_int, cy: c_int, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetWindowPlacement(hWnd: HWND, lpwndpl: [*c]WINDOWPLACEMENT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowPlacement(hWnd: HWND, lpwndpl: [*c]const WINDOWPLACEMENT) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn GetWindowDisplayAffinity(hWnd: HWND, pdwAffinity: [*c]DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetWindowDisplayAffinity(hWnd: HWND, dwAffinity: DWORD) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn BeginDeferWindowPos(nNumWindows: c_int) callconv(@import("std").os.windows.WINAPI) HDWP;
pub extern fn DeferWindowPos(hWinPosInfo: HDWP, hWnd: HWND, hWndInsertAfter: HWND, x: c_int, y: c_int, cx: c_int, cy: c_int, uFlags: UINT) callconv(@import("std").os.windows.WINAPI) HDWP;
pub extern fn EndDeferWindowPos(hWinPosInfo: HDWP) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsWindowVisible(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsIconic(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn AnyPopup() callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn BringWindowToTop(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn IsZoomed(hWnd: HWND) callconv(@import("std").os.windows.WINAPI) BOOL;
pub const HDEVNOTIFY = PVOID;
pub const HDEVINFO = PVOID;
pub extern fn RegisterDeviceNotificationA(hRecipient: HANDLE, NotificationFilter: LPVOID, Flags: DWORD) callconv(@import("std").os.windows.WINAPI) HDEVNOTIFY;
pub extern fn RegisterDeviceNotificationW(hRecipient: HANDLE, NotificationFilter: LPVOID, Flags: DWORD) callconv(@import("std").os.windows.WINAPI) HDEVNOTIFY;

pub const GUID = extern struct {
    Data1: c_ulong = 0,
    Data2: c_ushort = 0,
    Data3: c_ushort = 0,
    Data4: [8]UCHAR = @import("std").mem.zeroes([8]UCHAR),
};
pub const DEVICE_NOTIFY_WINDOW_HANDLE: DWORD = 0;
pub const DEVICE_NOTIFY_SERVICE_HANDLE: DWORD = 1;
pub const DEVICE_NOTIFY_ALL_INTERFACE_CLASSES: DWORD = 4;

pub const DBT_DEVTYP_DEVICEINTERFACE: DWORD = 5;
pub const DBT_DEVTYP_HANDLE: DWORD = 6;

pub const DEV_BROADCAST_DEVICEINTERFACE_W = extern struct {
    dbcc_size: DWORD = @sizeOf(DEV_BROADCAST_DEVICEINTERFACE_W),
    dbcc_devicetype: DWORD = DBT_DEVTYP_DEVICEINTERFACE,
    dbcc_reserved: DWORD = 0,
    dbcc_classguid: GUID = .{},
    dbcc_name: [1]wchar_t = @import("std").mem.zeroes([1]wchar_t),
};
pub const DEV_BROADCAST_DEVICEINTERFACE_A = extern struct {
    dbcc_size: DWORD = @sizeOf(DEV_BROADCAST_DEVICEINTERFACE_A),
    dbcc_devicetype: DWORD = DBT_DEVTYP_DEVICEINTERFACE,
    dbcc_reserved: DWORD = 0,
    dbcc_classguid: GUID = .{},
    dbcc_name: [1]CHAR = @import("std").mem.zeroes([1]CHAR),
};

pub const PCWSTR = [*c]const wchar_t;
pub const PCSTR = [*c]const CHAR;

pub extern fn SetupDiGetClassDevsW(ClassGuid: *const GUID, Enumerator: PCWSTR, hwndParent: HWND, Flags: DWORD) callconv(@import("std").os.windows.WINAPI) HDEVINFO;
pub extern fn SetupDiGetClassDevsA(ClassGuid: *const GUID, Enumerator: PCSTR, hwndParent: HWND, Flags: DWORD) callconv(@import("std").os.windows.WINAPI) HDEVINFO;

pub const DIGCF_DEVICEINTERFACE: DWORD = 0x10;
pub const DIGCF_PRESENT: DWORD = 0x2;

pub const SP_DEVICE_INTERFACE_DATA = extern struct {
    cbSize: DWORD = @sizeOf(SP_DEVICE_INTERFACE_DATA),
    InterfaceClassGuid: GUID = .{},
    Flags: DWORD = 0,
    Reserved: ULONG_PTR = 0,
};

pub const SP_DEVINFO_DATA = extern struct {
    cbSize: DWORD = @sizeOf(SP_DEVINFO_DATA),
    ClassGuid: GUID = .{},
    DevInst: DWORD = 0,
    Reserved: ULONG_PTR = 0,
};

pub const SP_DEVICE_INTERFACE_DETAIL_DATA_W = extern struct {
    cbSize: DWORD,
    DevicePath: [1]WCHAR,
};
pub const SP_DEVICE_INTERFACE_DETAIL_DATA_A = extern struct {
    cbSize: DWORD,
    DevicePath: [1]CHAR,
};

pub const PSP_DEVICE_INTERFACE_DATA = [*c]SP_DEVICE_INTERFACE_DATA;
pub const PSP_DEVICE_INTERFACE_DETAIL_DATA_W = [*c]SP_DEVICE_INTERFACE_DETAIL_DATA_W;
pub const PSP_DEVICE_INTERFACE_DETAIL_DATA_A = [*c]SP_DEVICE_INTERFACE_DETAIL_DATA_A;
pub const PSP_DEVINFO_DATA = [*c]SP_DEVINFO_DATA;

pub extern fn SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet: HDEVINFO, DeviceInterfaceData: PSP_DEVICE_INTERFACE_DATA, DeviceInterfaceDetailData: PSP_DEVICE_INTERFACE_DETAIL_DATA_W, DeviceInterfaceDetailDataSize: DWORD, RequiredSize: PDWORD, DeviceInfoData: PSP_DEVINFO_DATA) callconv(@import("std").os.windows.WINAPI) BOOL;
pub extern fn SetupDiGetDeviceInterfaceDetailA(DeviceInfoSet: HDEVINFO, DeviceInterfaceData: PSP_DEVICE_INTERFACE_DATA, DeviceInterfaceDetailData: PSP_DEVICE_INTERFACE_DETAIL_DATA_A, DeviceInterfaceDetailDataSize: DWORD, RequiredSize: PDWORD, DeviceInfoData: PSP_DEVINFO_DATA) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn SetupDiEnumDeviceInterfaces(DeviceInfoSet: HDEVINFO, DeviceInfoData: PSP_DEVINFO_DATA, InterfaceClassGuid: *const GUID, MemberIndex: DWORD, DeviceInterfaceData: PSP_DEVICE_INTERFACE_DATA) callconv(@import("std").os.windows.WINAPI) BOOL;

pub extern fn SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const RAWINPUTDEVICE = extern struct {
    usUsagePage: USHORT = 0,
    usUsage: USHORT = 0,
    dwFlags: DWORD = 0,
    hwndTarget: HWND = null,
};
pub const PCRAWINPUTDEVICE = [*c]const RAWINPUTDEVICE;
pub const PRAWINPUTDEVICE = [*c]RAWINPUTDEVICE;

pub extern fn RegisterRawInputDevices(pRawInputDevices: PCRAWINPUTDEVICE, uiNumDevices: UINT, cbSize: UINT) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const RIDEV_REMOVE: DWORD = 0x00000001;
pub const RIDEV_EXCLUDE: DWORD = 0x00000010;
pub const RIDEV_PAGEONLY: DWORD = 0x00000020;
pub const RIDEV_NOLEGACY: DWORD = 0x00000030;
pub const RIDEV_INPUTSINK: DWORD = 0x00000100;
pub const RIDEV_CAPTUREMOUSE: DWORD = 0x00000200; // ;effective when mouse nolegacy is specified, otherwise it would be an error
pub const RIDEV_NOHOTKEYS: DWORD = 0x00000200; // effective for keyboard.
pub const RIDEV_APPKEYS: DWORD = 0x00000400; //; effective for keyboard.
pub const RIDEV_EXINPUTSINK: DWORD = 0x00001000;
pub const RIDEV_DEVNOTIFY: DWORD = 0x00002000;
pub const RIDEV_EXMODEMASK: DWORD = 0x000000F0;

pub const ERROR_DEVICE_NOT_CONNECTED: DWORD = 1167;
pub const ERROR_DEVICE_REINITIALIZATION_NEEDED: DWORD = 1164; // dderror
pub const ERROR_DEVICE_REQUIRES_CLEANING: DWORD = 1165;
pub const ERROR_DEVICE_DOOR_OPEN: DWORD = 1166;

pub extern fn DeviceIoControl(
    hDevice: HANDLE,
    dwIoControlCode: DWORD,
    lpInBuffer: LPVOID,
    nInBufferSize: DWORD,
    lpOutBuffer: LPVOID,
    nOutBufferSize: DWORD,
    lpBytesReturned: LPDWORD,
    lpOverlapped: LPOVERLAPPED,
) callconv(@import("std").os.windows.WINAPI) BOOL;

pub const DEV_BROADCAST_HDR = extern struct {
    dbch_size: DWORD,
    dbch_devicetype: DWORD,
    dbch_reserved: DWORD,
};

pub const BOOLEAN = UCHAR;

pub const HID_COLLECTION_INFORMATION = struct {
    DescriptorSize: ULONG,
    Polled: BOOLEAN,
    Reserved1: [1]UCHAR,
    VendorID: USHORT,
    ProductID: USHORT,
    VersionNumber: USHORT,
};

pub const DBT_DEVICEARRIVAL: DWORD = 0x8000; // system detected a new device
pub const DBT_DEVICEQUERYREMOVE: DWORD = 0x8001; // wants to remove, may fail
pub const DBT_DEVICEQUERYREMOVEFAILED: DWORD = 0x8002; // removal aborted
pub const DBT_DEVICEREMOVEPENDING: DWORD = 0x8003; // about to remove, still avail.
pub const DBT_DEVICEREMOVECOMPLETE: DWORD = 0x8004; // device is gone
pub const DBT_DEVICETYPESPECIFIC: DWORD = 0x8005; // type specific event

pub const PUINT = [*c]UINT;

pub const RIDI_PREPARSEDDATA: UINT = 0x20000005;
pub const RIDI_DEVICENAME: UINT = 0x20000007;
pub const RIDI_DEVICEINFO: UINT = 0x2000000b;

pub extern fn GetRawInputDeviceInfoA(hDevice: HANDLE, uiCommand: UINT, pData: LPVOID, pcbSize: PUINT) callconv(@import("std").os.windows.WINAPI) UINT;
pub extern fn GetRawInputDeviceInfoW(hDevice: HANDLE, uiCommand: UINT, pData: LPVOID, pcbSize: PUINT) callconv(@import("std").os.windows.WINAPI) UINT;

pub const USAGE = USHORT;
pub const PUSAGE = [*c]USAGE;

pub const NTSTATUS = LONG;
pub const PHIDP_PREPARSED_DATA = LPVOID;
pub const PHIDP_CAPS = [*c]HIDP_CAPS;
pub const HIDP_CAPS = extern struct {
    Usage: USAGE,
    UsagePage: USAGE,
    InputReportByteLength: USHORT,
    OutputReportByteLength: USHORT,
    FeatureReportByteLength: USHORT,
    Reserved: [17]USHORT,

    NumberLinkCollectionNodes: USHORT,

    NumberInputButtonCaps: USHORT,
    NumberInputValueCaps: USHORT,
    NumberInputDataIndices: USHORT,

    NumberOutputButtonCaps: USHORT,
    NumberOutputValueCaps: USHORT,
    NumberOutputDataIndices: USHORT,

    NumberFeatureButtonCaps: USHORT,
    NumberFeatureValueCaps: USHORT,
    NumberFeatureDataIndices: USHORT,
};

pub const HIDP_BUTTON_CAPS = extern struct {
    UsagePage: USAGE,
    ReportID: UCHAR,
    IsAlias: BOOLEAN,

    BitField: USHORT,
    LinkCollection: USHORT, // A unique internal index pointer

    LinkUsage: USAGE,
    LinkUsagePage: USAGE,

    IsRange: BOOLEAN,
    IsStringRange: BOOLEAN,
    IsDesignatorRange: BOOLEAN,
    IsAbsolute: BOOLEAN,

    Reserved: [10]ULONG,

    R: extern union {
        Range: extern struct {
            UsageMin: USAGE,
            UsageMax: USAGE,
            StringMin: USHORT,
            StringMax: USHORT,
            DesignatorMin: USHORT,
            DesignatorMax: USHORT,
            DataIndexMin: USHORT,
            DataIndexMax: USHORT,
        },
        NotRange: extern struct {
            Usage: USAGE,
            Reserved1: USAGE,
            StringIndex: USHORT,
            Reserved2: USHORT,
            DesignatorIndex: USHORT,
            Reserved3: USHORT,
            DataIndex: USHORT,
            Reserved4: USHORT,
        },
    },
};
pub const PHIDP_BUTTON_CAPS = [*c]HIDP_BUTTON_CAPS;

pub const HIDP_VALUE_CAPS = extern struct {
    UsagePage: USAGE,
    ReportID: UCHAR,
    IsAlias: BOOLEAN,

    BitField: USHORT,
    LinkCollection: USHORT, // A unique internal index pointer

    LinkUsage: USAGE,
    LinkUsagePage: USAGE,

    IsRange: BOOLEAN,
    IsStringRange: BOOLEAN,
    IsDesignatorRange: BOOLEAN,
    IsAbsolute: BOOLEAN,

    HasNull: BOOLEAN, // Does this channel have a null report   union
    Reserved: UCHAR,
    BitSize: USHORT, // How many bits are devoted to this value?

    ReportCount: USHORT, // See Note below.  Usually set to 1.
    Reserved2: [5]USHORT,

    UnitsExp: ULONG,
    Units: ULONG,

    LogicalMin: LONG,
    LogicalMax: LONG,
    PhysicalMin: LONG,
    PhysicalMax: LONG,

    R: extern union {
        Range: extern struct {
            UsageMin: USAGE,
            UsageMax: USAGE,
            StringMin: USHORT,
            StringMax: USHORT,
            DesignatorMin: USHORT,
            DesignatorMax: USHORT,
            DataIndexMin: USHORT,
            DataIndexMax: USHORT,
        },
        NotRange: extern struct {
            Usage: USAGE,
            Reserved1: USAGE,
            StringIndex: USHORT,
            Reserved2: USHORT,
            DesignatorIndex: USHORT,
            Reserved3: USHORT,
            DataIndex: USHORT,
            Reserved4: USHORT,
        },
    },
};
pub const PHIDP_VALUE_CAPS = [*c]HIDP_VALUE_CAPS;

pub const HIDP_REPORT_TYPE = enum(c_uint) { HidP_Input, HidP_Output, HidP_Feature };

pub extern fn HidP_GetCaps(PreparsedData: PHIDP_PREPARSED_DATA, Capabilities: PHIDP_CAPS) callconv(@import("std").os.windows.WINAPI) NTSTATUS;
pub extern fn HidP_GetButtonCaps(ReportType: HIDP_REPORT_TYPE, Capabilities: PHIDP_BUTTON_CAPS, ButtonCapsLength: PUSHORT, PreparsedData: PHIDP_PREPARSED_DATA) callconv(@import("std").os.windows.WINAPI) NTSTATUS;
pub extern fn HidP_GetValueCaps(ReportType: HIDP_REPORT_TYPE, Capabilities: PHIDP_VALUE_CAPS, ValueCapsLength: PUSHORT, PreparsedData: PHIDP_PREPARSED_DATA) callconv(@import("std").os.windows.WINAPI) NTSTATUS;
pub extern fn HidP_GetUsages(ReportType: HIDP_REPORT_TYPE, UsagePage: USAGE, LinkCollection: USHORT, UsageList: PUSAGE, UsageLength: PULONG, PreparsedData: PHIDP_PREPARSED_DATA, Report: PCHAR, ReportLength: ULONG) callconv(@import("std").os.windows.WINAPI) NTSTATUS;
pub extern fn HidP_GetUsageValue(ReportType: HIDP_REPORT_TYPE, UsagePage: USAGE, LinkCollection: USHORT, Usage: USAGE, UsageValue: PUSAGE, PreparsedData: PHIDP_PREPARSED_DATA, Report: PCHAR, ReportLength: ULONG) callconv(@import("std").os.windows.WINAPI) NTSTATUS;

pub const FACILITY_HID_ERROR_CODE = 0x11;

pub inline fn HIDP_ERROR_CODES(SEV: anytype, CODE: anytype) NTSTATUS {
    return @intCast((SEV << 28) | (FACILITY_HID_ERROR_CODE << 16) | CODE);
}

pub const HIDP_STATUS_SUCCESS = HIDP_ERROR_CODES(0x0, 0);
pub const HIDP_STATUS_NULL = (HIDP_ERROR_CODES(0x8, 1));
pub const HIDP_STATUS_INVALID_PREPARSED_DATA = (HIDP_ERROR_CODES(0xC, 1));
pub const HIDP_STATUS_INVALID_REPORT_TYPE = (HIDP_ERROR_CODES(0xC, 2));
pub const HIDP_STATUS_INVALID_REPORT_LENGTH = (HIDP_ERROR_CODES(0xC, 3));
pub const HIDP_STATUS_USAGE_NOT_FOUND = (HIDP_ERROR_CODES(0xC, 4));
pub const HIDP_STATUS_VALUE_OUT_OF_RANGE = (HIDP_ERROR_CODES(0xC, 5));
pub const HIDP_STATUS_BAD_LOG_PHY_VALUES = (HIDP_ERROR_CODES(0xC, 6));
pub const HIDP_STATUS_BUFFER_TOO_SMALL = (HIDP_ERROR_CODES(0xC, 7));
pub const HIDP_STATUS_INTERNAL_ERROR = (HIDP_ERROR_CODES(0xC, 8));
pub const HIDP_STATUS_I8042_TRANS_UNKNOWN = (HIDP_ERROR_CODES(0xC, 9));
pub const HIDP_STATUS_INCOMPATIBLE_REPORT_ID = (HIDP_ERROR_CODES(0xC, 0xA));
pub const HIDP_STATUS_NOT_VALUE_ARRAY = (HIDP_ERROR_CODES(0xC, 0xB));
pub const HIDP_STATUS_IS_VALUE_ARRAY = (HIDP_ERROR_CODES(0xC, 0xC));
pub const HIDP_STATUS_DATA_INDEX_NOT_FOUND = (HIDP_ERROR_CODES(0xC, 0xD));
pub const HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE = (HIDP_ERROR_CODES(0xC, 0xE));
pub const HIDP_STATUS_BUTTON_NOT_PRESSED = (HIDP_ERROR_CODES(0xC, 0xF));
pub const HIDP_STATUS_REPORT_DOES_NOT_EXIST = (HIDP_ERROR_CODES(0xC, 0x10));
pub const HIDP_STATUS_NOT_IMPLEMENTED = (HIDP_ERROR_CODES(0xC, 0x20));

pub const RID_DEVICE_INFO_KEYBOARD = extern struct {
    dwType: DWORD,
    dwSubType: DWORD,
    dwKeyboardMode: DWORD,
    dwNumberOfFunctionKeys: DWORD,
    dwNumberOfIndicators: DWORD,
    dwNumberOfKeysTotal: DWORD,
};
pub const RID_DEVICE_INFO_MOUSE = extern struct {
    dwId: DWORD,
    dwNumberOfButtons: DWORD,
    dwSampleRate: DWORD,
    fHasHorizontalWheel: BOOL,
};
pub const RID_DEVICE_INFO_HID = extern struct {
    dwVendorId: DWORD,
    dwProductId: DWORD,
    dwVersionNumber: DWORD,
    usUsagePage: USHORT,
    usUsage: USHORT,
};
pub const RID_DEVICE_INFO = extern struct {
    cbSize: DWORD,
    dwType: DWORD,
    D: extern union {
        mouse: RID_DEVICE_INFO_MOUSE,
        keyboard: RID_DEVICE_INFO_KEYBOARD,
        hid: RID_DEVICE_INFO_HID,
    },
};
