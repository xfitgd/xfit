pub const FT_Int16 = c_short;
pub const FT_UInt16 = c_ushort;
pub const FT_Int32 = c_int;
pub const FT_UInt32 = c_uint;
pub const FT_Fast = c_int;
pub const FT_UFast = c_uint;
pub const FT_Int64 = c_longlong;
pub const FT_UInt64 = c_ulonglong;
pub const FT_Memory = [*c]struct_FT_MemoryRec_;
pub const FT_Alloc_Func = ?*const fn (FT_Memory, c_long) callconv(.C) ?*anyopaque;
pub const FT_Free_Func = ?*const fn (FT_Memory, ?*anyopaque) callconv(.C) void;
pub const FT_Realloc_Func = ?*const fn (FT_Memory, c_long, c_long, ?*anyopaque) callconv(.C) ?*anyopaque;
pub const struct_FT_MemoryRec_ = extern struct {
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    alloc: FT_Alloc_Func = @import("std").mem.zeroes(FT_Alloc_Func),
    free: FT_Free_Func = @import("std").mem.zeroes(FT_Free_Func),
    realloc: FT_Realloc_Func = @import("std").mem.zeroes(FT_Realloc_Func),
};
pub const union_FT_StreamDesc_ = extern union {
    value: c_long,
    pointer: ?*anyopaque,
};
pub const FT_StreamDesc = union_FT_StreamDesc_;
pub const FT_Stream = [*c]struct_FT_StreamRec_;
pub const FT_Stream_IoFunc = ?*const fn (FT_Stream, c_ulong, [*c]u8, c_ulong) callconv(.C) c_ulong;
pub const FT_Stream_CloseFunc = ?*const fn (FT_Stream) callconv(.C) void;
pub const struct_FT_StreamRec_ = extern struct {
    base: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    size: c_ulong = @import("std").mem.zeroes(c_ulong),
    pos: c_ulong = @import("std").mem.zeroes(c_ulong),
    descriptor: FT_StreamDesc = @import("std").mem.zeroes(FT_StreamDesc),
    pathname: FT_StreamDesc = @import("std").mem.zeroes(FT_StreamDesc),
    read: FT_Stream_IoFunc = @import("std").mem.zeroes(FT_Stream_IoFunc),
    close: FT_Stream_CloseFunc = @import("std").mem.zeroes(FT_Stream_CloseFunc),
    memory: FT_Memory = @import("std").mem.zeroes(FT_Memory),
    cursor: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    limit: [*c]u8 = @import("std").mem.zeroes([*c]u8),
};
pub const FT_StreamRec = struct_FT_StreamRec_;
pub const FT_Pos = c_long;
pub const struct_FT_Vector_ = extern struct {
    x: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    y: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_Vector = struct_FT_Vector_;
pub const struct_FT_BBox_ = extern struct {
    xMin: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    yMin: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    xMax: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    yMax: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_BBox = struct_FT_BBox_;
pub const FT_PIXEL_MODE_NONE: c_int = 0;
pub const FT_PIXEL_MODE_MONO: c_int = 1;
pub const FT_PIXEL_MODE_GRAY: c_int = 2;
pub const FT_PIXEL_MODE_GRAY2: c_int = 3;
pub const FT_PIXEL_MODE_GRAY4: c_int = 4;
pub const FT_PIXEL_MODE_LCD: c_int = 5;
pub const FT_PIXEL_MODE_LCD_V: c_int = 6;
pub const FT_PIXEL_MODE_BGRA: c_int = 7;
pub const FT_PIXEL_MODE_MAX: c_int = 8;
pub const enum_FT_Pixel_Mode_ = c_uint;
pub const FT_Pixel_Mode = enum_FT_Pixel_Mode_;
pub const struct_FT_Bitmap_ = extern struct {
    rows: c_uint = @import("std").mem.zeroes(c_uint),
    width: c_uint = @import("std").mem.zeroes(c_uint),
    pitch: c_int = @import("std").mem.zeroes(c_int),
    buffer: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    num_grays: c_ushort = @import("std").mem.zeroes(c_ushort),
    pixel_mode: u8 = @import("std").mem.zeroes(u8),
    palette_mode: u8 = @import("std").mem.zeroes(u8),
    palette: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const FT_Bitmap = struct_FT_Bitmap_;
pub const struct_FT_Outline_ = extern struct {
    n_contours: c_ushort = @import("std").mem.zeroes(c_ushort),
    n_points: c_ushort = @import("std").mem.zeroes(c_ushort),
    points: [*c]FT_Vector = @import("std").mem.zeroes([*c]FT_Vector),
    tags: [*c]u8 = @import("std").mem.zeroes([*c]u8),
    contours: [*c]c_ushort = @import("std").mem.zeroes([*c]c_ushort),
    flags: c_int = @import("std").mem.zeroes(c_int),
};
pub const FT_Outline = struct_FT_Outline_;
pub const FT_Outline_MoveToFunc = ?*const fn ([*c]const FT_Vector, ?*anyopaque) callconv(.C) c_int;
pub const FT_Outline_LineToFunc = ?*const fn ([*c]const FT_Vector, ?*anyopaque) callconv(.C) c_int;
pub const FT_Outline_ConicToFunc = ?*const fn ([*c]const FT_Vector, [*c]const FT_Vector, ?*anyopaque) callconv(.C) c_int;
pub const FT_Outline_CubicToFunc = ?*const fn ([*c]const FT_Vector, [*c]const FT_Vector, [*c]const FT_Vector, ?*anyopaque) callconv(.C) c_int;
pub const struct_FT_Outline_Funcs_ = extern struct {
    move_to: FT_Outline_MoveToFunc = @import("std").mem.zeroes(FT_Outline_MoveToFunc),
    line_to: FT_Outline_LineToFunc = @import("std").mem.zeroes(FT_Outline_LineToFunc),
    conic_to: FT_Outline_ConicToFunc = @import("std").mem.zeroes(FT_Outline_ConicToFunc),
    cubic_to: FT_Outline_CubicToFunc = @import("std").mem.zeroes(FT_Outline_CubicToFunc),
    shift: c_int = @import("std").mem.zeroes(c_int),
    delta: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_Outline_Funcs = struct_FT_Outline_Funcs_;
pub const FT_GLYPH_FORMAT_NONE: c_int = 0;
pub const FT_GLYPH_FORMAT_COMPOSITE: c_int = 1668246896;
pub const FT_GLYPH_FORMAT_BITMAP: c_int = 1651078259;
pub const FT_GLYPH_FORMAT_OUTLINE: c_int = 1869968492;
pub const FT_GLYPH_FORMAT_PLOTTER: c_int = 1886154612;
pub const FT_GLYPH_FORMAT_SVG: c_int = 1398163232;
pub const enum_FT_Glyph_Format_ = c_uint;
pub const FT_Glyph_Format = enum_FT_Glyph_Format_;
pub const struct_FT_Span_ = extern struct {
    x: c_short = @import("std").mem.zeroes(c_short),
    len: c_ushort = @import("std").mem.zeroes(c_ushort),
    coverage: u8 = @import("std").mem.zeroes(u8),
};
pub const FT_Span = struct_FT_Span_;
pub const FT_SpanFunc = ?*const fn (c_int, c_int, [*c]const FT_Span, ?*anyopaque) callconv(.C) void;
pub const FT_Raster_BitTest_Func = ?*const fn (c_int, c_int, ?*anyopaque) callconv(.C) c_int;
pub const FT_Raster_BitSet_Func = ?*const fn (c_int, c_int, ?*anyopaque) callconv(.C) void;
pub const struct_FT_Raster_Params_ = extern struct {
    target: [*c]const FT_Bitmap = @import("std").mem.zeroes([*c]const FT_Bitmap),
    source: ?*const anyopaque = @import("std").mem.zeroes(?*const anyopaque),
    flags: c_int = @import("std").mem.zeroes(c_int),
    gray_spans: FT_SpanFunc = @import("std").mem.zeroes(FT_SpanFunc),
    black_spans: FT_SpanFunc = @import("std").mem.zeroes(FT_SpanFunc),
    bit_test: FT_Raster_BitTest_Func = @import("std").mem.zeroes(FT_Raster_BitTest_Func),
    bit_set: FT_Raster_BitSet_Func = @import("std").mem.zeroes(FT_Raster_BitSet_Func),
    user: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    clip_box: FT_BBox = @import("std").mem.zeroes(FT_BBox),
};
pub const FT_Raster_Params = struct_FT_Raster_Params_;
pub const struct_FT_RasterRec_ = opaque {};
pub const FT_Raster = ?*struct_FT_RasterRec_;
pub const FT_Raster_NewFunc = ?*const fn (?*anyopaque, [*c]FT_Raster) callconv(.C) c_int;
pub const FT_Raster_DoneFunc = ?*const fn (FT_Raster) callconv(.C) void;
pub const FT_Raster_ResetFunc = ?*const fn (FT_Raster, [*c]u8, c_ulong) callconv(.C) void;
pub const FT_Raster_SetModeFunc = ?*const fn (FT_Raster, c_ulong, ?*anyopaque) callconv(.C) c_int;
pub const FT_Raster_RenderFunc = ?*const fn (FT_Raster, [*c]const FT_Raster_Params) callconv(.C) c_int;
pub const struct_FT_Raster_Funcs_ = extern struct {
    glyph_format: FT_Glyph_Format = @import("std").mem.zeroes(FT_Glyph_Format),
    raster_new: FT_Raster_NewFunc = @import("std").mem.zeroes(FT_Raster_NewFunc),
    raster_reset: FT_Raster_ResetFunc = @import("std").mem.zeroes(FT_Raster_ResetFunc),
    raster_set_mode: FT_Raster_SetModeFunc = @import("std").mem.zeroes(FT_Raster_SetModeFunc),
    raster_render: FT_Raster_RenderFunc = @import("std").mem.zeroes(FT_Raster_RenderFunc),
    raster_done: FT_Raster_DoneFunc = @import("std").mem.zeroes(FT_Raster_DoneFunc),
};
pub const FT_Raster_Funcs = struct_FT_Raster_Funcs_;
pub const FT_Bool = u8;
pub const FT_FWord = c_short;
pub const FT_UFWord = c_ushort;
pub const FT_Char = i8;
pub const FT_Byte = u8;
pub const FT_Bytes = [*c]const FT_Byte;
pub const FT_Tag = FT_UInt32;
pub const FT_String = u8;
pub const FT_Short = c_short;
pub const FT_UShort = c_ushort;
pub const FT_Int = c_int;
pub const FT_UInt = c_uint;
pub const FT_Long = c_long;
pub const FT_ULong = c_ulong;
pub const FT_F2Dot14 = c_short;
pub const FT_F26Dot6 = c_long;
pub const FT_Fixed = c_long;
pub const FT_Error = c_int;
pub const FT_Pointer = ?*anyopaque;
pub const FT_Offset = usize;
pub const struct_FT_UnitVector_ = extern struct {
    x: FT_F2Dot14 = @import("std").mem.zeroes(FT_F2Dot14),
    y: FT_F2Dot14 = @import("std").mem.zeroes(FT_F2Dot14),
};
pub const FT_UnitVector = struct_FT_UnitVector_;
pub const struct_FT_Matrix_ = extern struct {
    xx: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    xy: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    yx: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    yy: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
};
pub const FT_Matrix = struct_FT_Matrix_;
pub const struct_FT_Data_ = extern struct {
    pointer: [*c]const FT_Byte = @import("std").mem.zeroes([*c]const FT_Byte),
    length: FT_UInt = @import("std").mem.zeroes(FT_UInt),
};
pub const FT_Data = struct_FT_Data_;
pub const FT_Generic_Finalizer = ?*const fn (?*anyopaque) callconv(.C) void;
pub const struct_FT_Generic_ = extern struct {
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    finalizer: FT_Generic_Finalizer = @import("std").mem.zeroes(FT_Generic_Finalizer),
};
pub const FT_Generic = struct_FT_Generic_;
pub const FT_ListNode = [*c]struct_FT_ListNodeRec_;
pub const struct_FT_ListNodeRec_ = extern struct {
    prev: FT_ListNode = @import("std").mem.zeroes(FT_ListNode),
    next: FT_ListNode = @import("std").mem.zeroes(FT_ListNode),
    data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
};
pub const struct_FT_ListRec_ = extern struct {
    head: FT_ListNode = @import("std").mem.zeroes(FT_ListNode),
    tail: FT_ListNode = @import("std").mem.zeroes(FT_ListNode),
};
pub const FT_List = [*c]struct_FT_ListRec_;
pub const FT_ListNodeRec = struct_FT_ListNodeRec_;
pub const FT_ListRec = struct_FT_ListRec_;
pub const FT_Mod_Err_Base: c_int = 0;
pub const FT_Mod_Err_Autofit: c_int = 0;
pub const FT_Mod_Err_BDF: c_int = 0;
pub const FT_Mod_Err_Bzip2: c_int = 0;
pub const FT_Mod_Err_Cache: c_int = 0;
pub const FT_Mod_Err_CFF: c_int = 0;
pub const FT_Mod_Err_CID: c_int = 0;
pub const FT_Mod_Err_Gzip: c_int = 0;
pub const FT_Mod_Err_LZW: c_int = 0;
pub const FT_Mod_Err_OTvalid: c_int = 0;
pub const FT_Mod_Err_PCF: c_int = 0;
pub const FT_Mod_Err_PFR: c_int = 0;
pub const FT_Mod_Err_PSaux: c_int = 0;
pub const FT_Mod_Err_PShinter: c_int = 0;
pub const FT_Mod_Err_PSnames: c_int = 0;
pub const FT_Mod_Err_Raster: c_int = 0;
pub const FT_Mod_Err_SFNT: c_int = 0;
pub const FT_Mod_Err_Smooth: c_int = 0;
pub const FT_Mod_Err_TrueType: c_int = 0;
pub const FT_Mod_Err_Type1: c_int = 0;
pub const FT_Mod_Err_Type42: c_int = 0;
pub const FT_Mod_Err_Winfonts: c_int = 0;
pub const FT_Mod_Err_GXvalid: c_int = 0;
pub const FT_Mod_Err_Sdf: c_int = 0;
pub const FT_Mod_Err_Max: c_int = 1;
const enum_unnamed_1 = c_uint;
pub const FT_Err_Ok: c_int = 0;
pub const FT_Err_Cannot_Open_Resource: c_int = 1;
pub const FT_Err_Unknown_File_Format: c_int = 2;
pub const FT_Err_Invalid_File_Format: c_int = 3;
pub const FT_Err_Invalid_Version: c_int = 4;
pub const FT_Err_Lower_Module_Version: c_int = 5;
pub const FT_Err_Invalid_Argument: c_int = 6;
pub const FT_Err_Unimplemented_Feature: c_int = 7;
pub const FT_Err_Invalid_Table: c_int = 8;
pub const FT_Err_Invalid_Offset: c_int = 9;
pub const FT_Err_Array_Too_Large: c_int = 10;
pub const FT_Err_Missing_Module: c_int = 11;
pub const FT_Err_Missing_Property: c_int = 12;
pub const FT_Err_Invalid_Glyph_Index: c_int = 16;
pub const FT_Err_Invalid_Character_Code: c_int = 17;
pub const FT_Err_Invalid_Glyph_Format: c_int = 18;
pub const FT_Err_Cannot_Render_Glyph: c_int = 19;
pub const FT_Err_Invalid_Outline: c_int = 20;
pub const FT_Err_Invalid_Composite: c_int = 21;
pub const FT_Err_Too_Many_Hints: c_int = 22;
pub const FT_Err_Invalid_Pixel_Size: c_int = 23;
pub const FT_Err_Invalid_SVG_Document: c_int = 24;
pub const FT_Err_Invalid_Handle: c_int = 32;
pub const FT_Err_Invalid_Library_Handle: c_int = 33;
pub const FT_Err_Invalid_Driver_Handle: c_int = 34;
pub const FT_Err_Invalid_Face_Handle: c_int = 35;
pub const FT_Err_Invalid_Size_Handle: c_int = 36;
pub const FT_Err_Invalid_Slot_Handle: c_int = 37;
pub const FT_Err_Invalid_CharMap_Handle: c_int = 38;
pub const FT_Err_Invalid_Cache_Handle: c_int = 39;
pub const FT_Err_Invalid_Stream_Handle: c_int = 40;
pub const FT_Err_Too_Many_Drivers: c_int = 48;
pub const FT_Err_Too_Many_Extensions: c_int = 49;
pub const FT_Err_Out_Of_Memory: c_int = 64;
pub const FT_Err_Unlisted_Object: c_int = 65;
pub const FT_Err_Cannot_Open_Stream: c_int = 81;
pub const FT_Err_Invalid_Stream_Seek: c_int = 82;
pub const FT_Err_Invalid_Stream_Skip: c_int = 83;
pub const FT_Err_Invalid_Stream_Read: c_int = 84;
pub const FT_Err_Invalid_Stream_Operation: c_int = 85;
pub const FT_Err_Invalid_Frame_Operation: c_int = 86;
pub const FT_Err_Nested_Frame_Access: c_int = 87;
pub const FT_Err_Invalid_Frame_Read: c_int = 88;
pub const FT_Err_Raster_Uninitialized: c_int = 96;
pub const FT_Err_Raster_Corrupted: c_int = 97;
pub const FT_Err_Raster_Overflow: c_int = 98;
pub const FT_Err_Raster_Negative_Height: c_int = 99;
pub const FT_Err_Too_Many_Caches: c_int = 112;
pub const FT_Err_Invalid_Opcode: c_int = 128;
pub const FT_Err_Too_Few_Arguments: c_int = 129;
pub const FT_Err_Stack_Overflow: c_int = 130;
pub const FT_Err_Code_Overflow: c_int = 131;
pub const FT_Err_Bad_Argument: c_int = 132;
pub const FT_Err_Divide_By_Zero: c_int = 133;
pub const FT_Err_Invalid_Reference: c_int = 134;
pub const FT_Err_Debug_OpCode: c_int = 135;
pub const FT_Err_ENDF_In_Exec_Stream: c_int = 136;
pub const FT_Err_Nested_DEFS: c_int = 137;
pub const FT_Err_Invalid_CodeRange: c_int = 138;
pub const FT_Err_Execution_Too_Long: c_int = 139;
pub const FT_Err_Too_Many_Function_Defs: c_int = 140;
pub const FT_Err_Too_Many_Instruction_Defs: c_int = 141;
pub const FT_Err_Table_Missing: c_int = 142;
pub const FT_Err_Horiz_Header_Missing: c_int = 143;
pub const FT_Err_Locations_Missing: c_int = 144;
pub const FT_Err_Name_Table_Missing: c_int = 145;
pub const FT_Err_CMap_Table_Missing: c_int = 146;
pub const FT_Err_Hmtx_Table_Missing: c_int = 147;
pub const FT_Err_Post_Table_Missing: c_int = 148;
pub const FT_Err_Invalid_Horiz_Metrics: c_int = 149;
pub const FT_Err_Invalid_CharMap_Format: c_int = 150;
pub const FT_Err_Invalid_PPem: c_int = 151;
pub const FT_Err_Invalid_Vert_Metrics: c_int = 152;
pub const FT_Err_Could_Not_Find_Context: c_int = 153;
pub const FT_Err_Invalid_Post_Table_Format: c_int = 154;
pub const FT_Err_Invalid_Post_Table: c_int = 155;
pub const FT_Err_DEF_In_Glyf_Bytecode: c_int = 156;
pub const FT_Err_Missing_Bitmap: c_int = 157;
pub const FT_Err_Missing_SVG_Hooks: c_int = 158;
pub const FT_Err_Syntax_Error: c_int = 160;
pub const FT_Err_Stack_Underflow: c_int = 161;
pub const FT_Err_Ignore: c_int = 162;
pub const FT_Err_No_Unicode_Glyph_Name: c_int = 163;
pub const FT_Err_Glyph_Too_Big: c_int = 164;
pub const FT_Err_Missing_Startfont_Field: c_int = 176;
pub const FT_Err_Missing_Font_Field: c_int = 177;
pub const FT_Err_Missing_Size_Field: c_int = 178;
pub const FT_Err_Missing_Fontboundingbox_Field: c_int = 179;
pub const FT_Err_Missing_Chars_Field: c_int = 180;
pub const FT_Err_Missing_Startchar_Field: c_int = 181;
pub const FT_Err_Missing_Encoding_Field: c_int = 182;
pub const FT_Err_Missing_Bbx_Field: c_int = 183;
pub const FT_Err_Bbx_Too_Big: c_int = 184;
pub const FT_Err_Corrupted_Font_Header: c_int = 185;
pub const FT_Err_Corrupted_Font_Glyphs: c_int = 186;
pub const FT_Err_Max: c_int = 187;
const enum_unnamed_2 = c_uint;
pub extern fn FT_Error_String(error_code: FT_Error) [*c]const u8;
pub const struct_FT_Glyph_Metrics_ = extern struct {
    width: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    height: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    horiBearingX: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    horiBearingY: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    horiAdvance: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    vertBearingX: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    vertBearingY: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    vertAdvance: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_Glyph_Metrics = struct_FT_Glyph_Metrics_;
pub const struct_FT_Bitmap_Size_ = extern struct {
    height: FT_Short = @import("std").mem.zeroes(FT_Short),
    width: FT_Short = @import("std").mem.zeroes(FT_Short),
    size: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    x_ppem: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    y_ppem: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_Bitmap_Size = struct_FT_Bitmap_Size_;
pub const struct_FT_LibraryRec_ = opaque {};
pub const FT_Library = ?*struct_FT_LibraryRec_;
pub const struct_FT_ModuleRec_ = opaque {};
pub const FT_Module = ?*struct_FT_ModuleRec_;
pub const struct_FT_DriverRec_ = opaque {};
pub const FT_Driver = ?*struct_FT_DriverRec_;
pub const struct_FT_RendererRec_ = opaque {};
pub const FT_Renderer = ?*struct_FT_RendererRec_;
pub const FT_Face = [*c]struct_FT_FaceRec_;
pub const FT_ENCODING_NONE: c_int = 0;
pub const FT_ENCODING_MS_SYMBOL: c_int = 1937337698;
pub const FT_ENCODING_UNICODE: c_int = 1970170211;
pub const FT_ENCODING_SJIS: c_int = 1936353651;
pub const FT_ENCODING_PRC: c_int = 1734484000;
pub const FT_ENCODING_BIG5: c_int = 1651074869;
pub const FT_ENCODING_WANSUNG: c_int = 2002873971;
pub const FT_ENCODING_JOHAB: c_int = 1785686113;
pub const FT_ENCODING_GB2312: c_int = 1734484000;
pub const FT_ENCODING_MS_SJIS: c_int = 1936353651;
pub const FT_ENCODING_MS_GB2312: c_int = 1734484000;
pub const FT_ENCODING_MS_BIG5: c_int = 1651074869;
pub const FT_ENCODING_MS_WANSUNG: c_int = 2002873971;
pub const FT_ENCODING_MS_JOHAB: c_int = 1785686113;
pub const FT_ENCODING_ADOBE_STANDARD: c_int = 1094995778;
pub const FT_ENCODING_ADOBE_EXPERT: c_int = 1094992453;
pub const FT_ENCODING_ADOBE_CUSTOM: c_int = 1094992451;
pub const FT_ENCODING_ADOBE_LATIN_1: c_int = 1818326065;
pub const FT_ENCODING_OLD_LATIN_2: c_int = 1818326066;
pub const FT_ENCODING_APPLE_ROMAN: c_int = 1634889070;
pub const enum_FT_Encoding_ = c_uint;
pub const FT_Encoding = enum_FT_Encoding_;
pub const struct_FT_CharMapRec_ = extern struct {
    face: FT_Face = @import("std").mem.zeroes(FT_Face),
    encoding: FT_Encoding = @import("std").mem.zeroes(FT_Encoding),
    platform_id: FT_UShort = @import("std").mem.zeroes(FT_UShort),
    encoding_id: FT_UShort = @import("std").mem.zeroes(FT_UShort),
};
pub const FT_CharMap = [*c]struct_FT_CharMapRec_;
pub const struct_FT_SubGlyphRec_ = opaque {};
pub const FT_SubGlyph = ?*struct_FT_SubGlyphRec_;
pub const struct_FT_Slot_InternalRec_ = opaque {};
pub const FT_Slot_Internal = ?*struct_FT_Slot_InternalRec_;
pub const struct_FT_GlyphSlotRec_ = extern struct {
    library: FT_Library = @import("std").mem.zeroes(FT_Library),
    face: FT_Face = @import("std").mem.zeroes(FT_Face),
    next: FT_GlyphSlot = @import("std").mem.zeroes(FT_GlyphSlot),
    glyph_index: FT_UInt = @import("std").mem.zeroes(FT_UInt),
    generic: FT_Generic = @import("std").mem.zeroes(FT_Generic),
    metrics: FT_Glyph_Metrics = @import("std").mem.zeroes(FT_Glyph_Metrics),
    linearHoriAdvance: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    linearVertAdvance: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    advance: FT_Vector = @import("std").mem.zeroes(FT_Vector),
    format: FT_Glyph_Format = @import("std").mem.zeroes(FT_Glyph_Format),
    bitmap: FT_Bitmap = @import("std").mem.zeroes(FT_Bitmap),
    bitmap_left: FT_Int = @import("std").mem.zeroes(FT_Int),
    bitmap_top: FT_Int = @import("std").mem.zeroes(FT_Int),
    outline: FT_Outline = @import("std").mem.zeroes(FT_Outline),
    num_subglyphs: FT_UInt = @import("std").mem.zeroes(FT_UInt),
    subglyphs: FT_SubGlyph = @import("std").mem.zeroes(FT_SubGlyph),
    control_data: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    control_len: c_long = @import("std").mem.zeroes(c_long),
    lsb_delta: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    rsb_delta: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    other: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    internal: FT_Slot_Internal = @import("std").mem.zeroes(FT_Slot_Internal),
};
pub const FT_GlyphSlot = [*c]struct_FT_GlyphSlotRec_;
pub const struct_FT_Size_Metrics_ = extern struct {
    x_ppem: FT_UShort = @import("std").mem.zeroes(FT_UShort),
    y_ppem: FT_UShort = @import("std").mem.zeroes(FT_UShort),
    x_scale: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    y_scale: FT_Fixed = @import("std").mem.zeroes(FT_Fixed),
    ascender: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    descender: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    height: FT_Pos = @import("std").mem.zeroes(FT_Pos),
    max_advance: FT_Pos = @import("std").mem.zeroes(FT_Pos),
};
pub const FT_Size_Metrics = struct_FT_Size_Metrics_;
pub const struct_FT_Size_InternalRec_ = opaque {};
pub const FT_Size_Internal = ?*struct_FT_Size_InternalRec_;
pub const struct_FT_SizeRec_ = extern struct {
    face: FT_Face = @import("std").mem.zeroes(FT_Face),
    generic: FT_Generic = @import("std").mem.zeroes(FT_Generic),
    metrics: FT_Size_Metrics = @import("std").mem.zeroes(FT_Size_Metrics),
    internal: FT_Size_Internal = @import("std").mem.zeroes(FT_Size_Internal),
};
pub const FT_Size = [*c]struct_FT_SizeRec_;
pub const struct_FT_Face_InternalRec_ = opaque {};
pub const FT_Face_Internal = ?*struct_FT_Face_InternalRec_;
pub const struct_FT_FaceRec_ = extern struct {
    num_faces: FT_Long = @import("std").mem.zeroes(FT_Long),
    face_index: FT_Long = @import("std").mem.zeroes(FT_Long),
    face_flags: FT_Long = @import("std").mem.zeroes(FT_Long),
    style_flags: FT_Long = @import("std").mem.zeroes(FT_Long),
    num_glyphs: FT_Long = @import("std").mem.zeroes(FT_Long),
    family_name: [*c]FT_String = @import("std").mem.zeroes([*c]FT_String),
    style_name: [*c]FT_String = @import("std").mem.zeroes([*c]FT_String),
    num_fixed_sizes: FT_Int = @import("std").mem.zeroes(FT_Int),
    available_sizes: [*c]FT_Bitmap_Size = @import("std").mem.zeroes([*c]FT_Bitmap_Size),
    num_charmaps: FT_Int = @import("std").mem.zeroes(FT_Int),
    charmaps: [*c]FT_CharMap = @import("std").mem.zeroes([*c]FT_CharMap),
    generic: FT_Generic = @import("std").mem.zeroes(FT_Generic),
    bbox: FT_BBox = @import("std").mem.zeroes(FT_BBox),
    units_per_EM: FT_UShort = @import("std").mem.zeroes(FT_UShort),
    ascender: FT_Short = @import("std").mem.zeroes(FT_Short),
    descender: FT_Short = @import("std").mem.zeroes(FT_Short),
    height: FT_Short = @import("std").mem.zeroes(FT_Short),
    max_advance_width: FT_Short = @import("std").mem.zeroes(FT_Short),
    max_advance_height: FT_Short = @import("std").mem.zeroes(FT_Short),
    underline_position: FT_Short = @import("std").mem.zeroes(FT_Short),
    underline_thickness: FT_Short = @import("std").mem.zeroes(FT_Short),
    glyph: FT_GlyphSlot = @import("std").mem.zeroes(FT_GlyphSlot),
    size: FT_Size = @import("std").mem.zeroes(FT_Size),
    charmap: FT_CharMap = @import("std").mem.zeroes(FT_CharMap),
    driver: FT_Driver = @import("std").mem.zeroes(FT_Driver),
    memory: FT_Memory = @import("std").mem.zeroes(FT_Memory),
    stream: FT_Stream = @import("std").mem.zeroes(FT_Stream),
    sizes_list: FT_ListRec = @import("std").mem.zeroes(FT_ListRec),
    autohint: FT_Generic = @import("std").mem.zeroes(FT_Generic),
    extensions: ?*anyopaque = @import("std").mem.zeroes(?*anyopaque),
    internal: FT_Face_Internal = @import("std").mem.zeroes(FT_Face_Internal),
};
pub const FT_CharMapRec = struct_FT_CharMapRec_;
pub const FT_FaceRec = struct_FT_FaceRec_;
pub const FT_SizeRec = struct_FT_SizeRec_;
pub const FT_GlyphSlotRec = struct_FT_GlyphSlotRec_;
pub extern fn FT_Init_FreeType(alibrary: [*c]FT_Library) FT_Error;
pub extern fn FT_Done_FreeType(library: FT_Library) FT_Error;
pub const struct_FT_Parameter_ = extern struct {
    tag: FT_ULong = @import("std").mem.zeroes(FT_ULong),
    data: FT_Pointer = @import("std").mem.zeroes(FT_Pointer),
};
pub const FT_Parameter = struct_FT_Parameter_;
pub const struct_FT_Open_Args_ = extern struct {
    flags: FT_UInt = @import("std").mem.zeroes(FT_UInt),
    memory_base: [*c]const FT_Byte = @import("std").mem.zeroes([*c]const FT_Byte),
    memory_size: FT_Long = @import("std").mem.zeroes(FT_Long),
    pathname: [*c]FT_String = @import("std").mem.zeroes([*c]FT_String),
    stream: FT_Stream = @import("std").mem.zeroes(FT_Stream),
    driver: FT_Module = @import("std").mem.zeroes(FT_Module),
    num_params: FT_Int = @import("std").mem.zeroes(FT_Int),
    params: [*c]FT_Parameter = @import("std").mem.zeroes([*c]FT_Parameter),
};
pub const FT_Open_Args = struct_FT_Open_Args_;
pub extern fn FT_New_Face(library: FT_Library, filepathname: [*c]const u8, face_index: FT_Long, aface: [*c]FT_Face) FT_Error;
pub extern fn FT_New_Memory_Face(library: FT_Library, file_base: [*c]const FT_Byte, file_size: FT_Long, face_index: FT_Long, aface: [*c]FT_Face) FT_Error;
pub extern fn FT_Open_Face(library: FT_Library, args: [*c]const FT_Open_Args, face_index: FT_Long, aface: [*c]FT_Face) FT_Error;
pub extern fn FT_Attach_File(face: FT_Face, filepathname: [*c]const u8) FT_Error;
pub extern fn FT_Attach_Stream(face: FT_Face, parameters: [*c]const FT_Open_Args) FT_Error;
pub extern fn FT_Reference_Face(face: FT_Face) FT_Error;
pub extern fn FT_Done_Face(face: FT_Face) FT_Error;
pub extern fn FT_Select_Size(face: FT_Face, strike_index: FT_Int) FT_Error;
pub const FT_SIZE_REQUEST_TYPE_NOMINAL: c_int = 0;
pub const FT_SIZE_REQUEST_TYPE_REAL_DIM: c_int = 1;
pub const FT_SIZE_REQUEST_TYPE_BBOX: c_int = 2;
pub const FT_SIZE_REQUEST_TYPE_CELL: c_int = 3;
pub const FT_SIZE_REQUEST_TYPE_SCALES: c_int = 4;
pub const FT_SIZE_REQUEST_TYPE_MAX: c_int = 5;
pub const enum_FT_Size_Request_Type_ = c_uint;
pub const FT_Size_Request_Type = enum_FT_Size_Request_Type_;
pub const struct_FT_Size_RequestRec_ = extern struct {
    type: FT_Size_Request_Type = @import("std").mem.zeroes(FT_Size_Request_Type),
    width: FT_Long = @import("std").mem.zeroes(FT_Long),
    height: FT_Long = @import("std").mem.zeroes(FT_Long),
    horiResolution: FT_UInt = @import("std").mem.zeroes(FT_UInt),
    vertResolution: FT_UInt = @import("std").mem.zeroes(FT_UInt),
};
pub const FT_Size_RequestRec = struct_FT_Size_RequestRec_;
pub const FT_Size_Request = [*c]struct_FT_Size_RequestRec_;
pub extern fn FT_Request_Size(face: FT_Face, req: FT_Size_Request) FT_Error;
pub extern fn FT_Set_Char_Size(face: FT_Face, char_width: FT_F26Dot6, char_height: FT_F26Dot6, horz_resolution: FT_UInt, vert_resolution: FT_UInt) FT_Error;
pub extern fn FT_Set_Pixel_Sizes(face: FT_Face, pixel_width: FT_UInt, pixel_height: FT_UInt) FT_Error;
pub extern fn FT_Load_Glyph(face: FT_Face, glyph_index: FT_UInt, load_flags: FT_Int32) FT_Error;
pub extern fn FT_Load_Char(face: FT_Face, char_code: FT_ULong, load_flags: FT_Int32) FT_Error;
pub extern fn FT_Set_Transform(face: FT_Face, matrix: [*c]FT_Matrix, delta: [*c]FT_Vector) void;
pub extern fn FT_Get_Transform(face: FT_Face, matrix: [*c]FT_Matrix, delta: [*c]FT_Vector) void;
pub const FT_RENDER_MODE_NORMAL: c_int = 0;
pub const FT_RENDER_MODE_LIGHT: c_int = 1;
pub const FT_RENDER_MODE_MONO: c_int = 2;
pub const FT_RENDER_MODE_LCD: c_int = 3;
pub const FT_RENDER_MODE_LCD_V: c_int = 4;
pub const FT_RENDER_MODE_SDF: c_int = 5;
pub const FT_RENDER_MODE_MAX: c_int = 6;
pub const enum_FT_Render_Mode_ = c_uint;
pub const FT_Render_Mode = enum_FT_Render_Mode_;
pub extern fn FT_Render_Glyph(slot: FT_GlyphSlot, render_mode: FT_Render_Mode) FT_Error;
pub const FT_KERNING_DEFAULT: c_int = 0;
pub const FT_KERNING_UNFITTED: c_int = 1;
pub const FT_KERNING_UNSCALED: c_int = 2;
pub const enum_FT_Kerning_Mode_ = c_uint;
pub const FT_Kerning_Mode = enum_FT_Kerning_Mode_;
pub extern fn FT_Get_Kerning(face: FT_Face, left_glyph: FT_UInt, right_glyph: FT_UInt, kern_mode: FT_UInt, akerning: [*c]FT_Vector) FT_Error;
pub extern fn FT_Get_Track_Kerning(face: FT_Face, point_size: FT_Fixed, degree: FT_Int, akerning: [*c]FT_Fixed) FT_Error;
pub extern fn FT_Select_Charmap(face: FT_Face, encoding: FT_Encoding) FT_Error;
pub extern fn FT_Set_Charmap(face: FT_Face, charmap: FT_CharMap) FT_Error;
pub extern fn FT_Get_Charmap_Index(charmap: FT_CharMap) FT_Int;
pub extern fn FT_Get_Char_Index(face: FT_Face, charcode: FT_ULong) FT_UInt;
pub extern fn FT_Get_First_Char(face: FT_Face, agindex: [*c]FT_UInt) FT_ULong;
pub extern fn FT_Get_Next_Char(face: FT_Face, char_code: FT_ULong, agindex: [*c]FT_UInt) FT_ULong;
pub extern fn FT_Face_Properties(face: FT_Face, num_properties: FT_UInt, properties: [*c]FT_Parameter) FT_Error;
pub extern fn FT_Get_Name_Index(face: FT_Face, glyph_name: [*c]const FT_String) FT_UInt;
pub extern fn FT_Get_Glyph_Name(face: FT_Face, glyph_index: FT_UInt, buffer: FT_Pointer, buffer_max: FT_UInt) FT_Error;
pub extern fn FT_Get_Postscript_Name(face: FT_Face) [*c]const u8;
pub extern fn FT_Get_SubGlyph_Info(glyph: FT_GlyphSlot, sub_index: FT_UInt, p_index: [*c]FT_Int, p_flags: [*c]FT_UInt, p_arg1: [*c]FT_Int, p_arg2: [*c]FT_Int, p_transform: [*c]FT_Matrix) FT_Error;
pub extern fn FT_Get_FSType_Flags(face: FT_Face) FT_UShort;
pub extern fn FT_Face_GetCharVariantIndex(face: FT_Face, charcode: FT_ULong, variantSelector: FT_ULong) FT_UInt;
pub extern fn FT_Face_GetCharVariantIsDefault(face: FT_Face, charcode: FT_ULong, variantSelector: FT_ULong) FT_Int;
pub extern fn FT_Face_GetVariantSelectors(face: FT_Face) [*c]FT_UInt32;
pub extern fn FT_Face_GetVariantsOfChar(face: FT_Face, charcode: FT_ULong) [*c]FT_UInt32;
pub extern fn FT_Face_GetCharsOfVariant(face: FT_Face, variantSelector: FT_ULong) [*c]FT_UInt32;
pub extern fn FT_MulDiv(a: FT_Long, b: FT_Long, c: FT_Long) FT_Long;
pub extern fn FT_MulFix(a: FT_Long, b: FT_Long) FT_Long;
pub extern fn FT_DivFix(a: FT_Long, b: FT_Long) FT_Long;
pub extern fn FT_RoundFix(a: FT_Fixed) FT_Fixed;
pub extern fn FT_CeilFix(a: FT_Fixed) FT_Fixed;
pub extern fn FT_FloorFix(a: FT_Fixed) FT_Fixed;
pub extern fn FT_Vector_Transform(vector: [*c]FT_Vector, matrix: [*c]const FT_Matrix) void;
pub extern fn FT_Library_Version(library: FT_Library, amajor: [*c]FT_Int, aminor: [*c]FT_Int, apatch: [*c]FT_Int) void;
pub extern fn FT_Face_CheckTrueTypePatents(face: FT_Face) FT_Bool;
pub extern fn FT_Face_SetUnpatentedHinting(face: FT_Face, value: FT_Bool) FT_Bool;
pub extern fn FT_Outline_Decompose(outline: [*c]FT_Outline, func_interface: [*c]const FT_Outline_Funcs, user: ?*anyopaque) FT_Error;
pub extern fn FT_Outline_New(library: FT_Library, numPoints: FT_UInt, numContours: FT_Int, anoutline: [*c]FT_Outline) FT_Error;
pub extern fn FT_Outline_Done(library: FT_Library, outline: [*c]FT_Outline) FT_Error;
pub extern fn FT_Outline_Check(outline: [*c]FT_Outline) FT_Error;
pub extern fn FT_Outline_Get_CBox(outline: [*c]const FT_Outline, acbox: [*c]FT_BBox) void;
pub extern fn FT_Outline_Translate(outline: [*c]const FT_Outline, xOffset: FT_Pos, yOffset: FT_Pos) void;
pub extern fn FT_Outline_Copy(source: [*c]const FT_Outline, target: [*c]FT_Outline) FT_Error;
pub extern fn FT_Outline_Transform(outline: [*c]const FT_Outline, matrix: [*c]const FT_Matrix) void;
pub extern fn FT_Outline_Embolden(outline: [*c]FT_Outline, strength: FT_Pos) FT_Error;
pub extern fn FT_Outline_EmboldenXY(outline: [*c]FT_Outline, xstrength: FT_Pos, ystrength: FT_Pos) FT_Error;
pub extern fn FT_Outline_Reverse(outline: [*c]FT_Outline) void;
pub extern fn FT_Outline_Get_Bitmap(library: FT_Library, outline: [*c]FT_Outline, abitmap: [*c]const FT_Bitmap) FT_Error;
pub extern fn FT_Outline_Render(library: FT_Library, outline: [*c]FT_Outline, params: [*c]FT_Raster_Params) FT_Error;
pub const FT_ORIENTATION_TRUETYPE: c_int = 0;
pub const FT_ORIENTATION_POSTSCRIPT: c_int = 1;
pub const FT_ORIENTATION_FILL_RIGHT: c_int = 0;
pub const FT_ORIENTATION_FILL_LEFT: c_int = 1;
pub const FT_ORIENTATION_NONE: c_int = 2;
pub const enum_FT_Orientation_ = c_uint;
pub const FT_Orientation = enum_FT_Orientation_;
pub extern fn FT_Outline_Get_Orientation(outline: [*c]FT_Outline) FT_Orientation;
pub const FT2BUILD_H_ = "";
pub const FTHEADER_H_ = "";
pub const FT_BEGIN_HEADER = "";
pub const FT_END_HEADER = "";
pub const FREETYPE_H_ = "";
pub const FTCONFIG_H_ = "";
pub const FTOPTION_H_ = "";
pub const FT_CONFIG_OPTION_ENVIRONMENT_PROPERTIES = "";
pub const FT_CONFIG_OPTION_INLINE_MULFIX = "";
pub const FT_CONFIG_OPTION_USE_LZW = "";
pub const FT_CONFIG_OPTION_USE_ZLIB = "";
pub const FT_CONFIG_OPTION_POSTSCRIPT_NAMES = "";
pub const FT_CONFIG_OPTION_ADOBE_GLYPH_LIST = "";
pub const FT_CONFIG_OPTION_MAC_FONTS = "";
pub const FT_CONFIG_OPTION_GUESSING_EMBEDDED_RFORK = "";
pub const FT_CONFIG_OPTION_INCREMENTAL = "";
pub const FT_RENDER_POOL_SIZE = @as(c_long, 16384);
pub const FT_MAX_MODULES = @as(c_int, 32);
pub const FT_CONFIG_OPTION_SVG = "";
pub const TT_CONFIG_OPTION_EMBEDDED_BITMAPS = "";
pub const TT_CONFIG_OPTION_COLOR_LAYERS = "";
pub const TT_CONFIG_OPTION_POSTSCRIPT_NAMES = "";
pub const TT_CONFIG_OPTION_SFNT_NAMES = "";
pub const TT_CONFIG_CMAP_FORMAT_0 = "";
pub const TT_CONFIG_CMAP_FORMAT_2 = "";
pub const TT_CONFIG_CMAP_FORMAT_4 = "";
pub const TT_CONFIG_CMAP_FORMAT_6 = "";
pub const TT_CONFIG_CMAP_FORMAT_8 = "";
pub const TT_CONFIG_CMAP_FORMAT_10 = "";
pub const TT_CONFIG_CMAP_FORMAT_12 = "";
pub const TT_CONFIG_CMAP_FORMAT_13 = "";
pub const TT_CONFIG_CMAP_FORMAT_14 = "";
pub const TT_CONFIG_OPTION_BYTECODE_INTERPRETER = "";
pub const TT_CONFIG_OPTION_SUBPIXEL_HINTING = "";
pub const TT_CONFIG_OPTION_GX_VAR_SUPPORT = "";
pub const TT_CONFIG_OPTION_BDF = "";
pub const TT_CONFIG_OPTION_MAX_RUNNABLE_OPCODES = @as(c_long, 1000000);
pub const T1_MAX_DICT_DEPTH = @as(c_int, 5);
pub const T1_MAX_SUBRS_CALLS = @as(c_int, 16);
pub const T1_MAX_CHARSTRINGS_OPERANDS = @as(c_int, 256);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_X1 = @as(c_int, 500);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y1 = @as(c_int, 400);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_X2 = @as(c_int, 1000);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y2 = @as(c_int, 275);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_X3 = @as(c_int, 1667);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y3 = @as(c_int, 275);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_X4 = @as(c_int, 2333);
pub const CFF_CONFIG_OPTION_DARKENING_PARAMETER_Y4 = @as(c_int, 0);
pub const AF_CONFIG_OPTION_CJK = "";
pub const AF_CONFIG_OPTION_INDIC = "";
pub const TT_USE_BYTECODE_INTERPRETER = "";
pub const TT_SUPPORT_SUBPIXEL_HINTING_MINIMAL = "";
pub const TT_SUPPORT_COLRV1 = "";
pub const FTSTDLIB_H_ = "";
pub const FREETYPE_CONFIG_INTEGER_TYPES_H_ = "";
pub const FT_INT64 = c_longlong;
pub const FT_UINT64 = c_ulonglong;
pub const FREETYPE_CONFIG_PUBLIC_MACROS_H_ = "";
pub const FT_PUBLIC_FUNCTION_ATTRIBUTE = "";
pub const FT_STATIC_CAST = @import("std").zig.c_translation.Macros.CAST_OR_CALL;
pub const FT_REINTERPRET_CAST = @import("std").zig.c_translation.Macros.CAST_OR_CALL;
pub inline fn FT_STATIC_BYTE_CAST(@"type": anytype, @"var": anytype) @TypeOf(@"type"(u8)(@"var")) {
    _ = &@"type";
    _ = &@"var";
    return @"type"(u8)(@"var");
}
pub const FREETYPE_CONFIG_MAC_SUPPORT_H_ = "";
pub const FTTYPES_H_ = "";
pub const FTSYSTEM_H_ = "";
pub const FTIMAGE_H_ = "";
pub const ft_pixel_mode_none = FT_PIXEL_MODE_NONE;
pub const ft_pixel_mode_mono = FT_PIXEL_MODE_MONO;
pub const ft_pixel_mode_grays = FT_PIXEL_MODE_GRAY;
pub const ft_pixel_mode_pal2 = FT_PIXEL_MODE_GRAY2;
pub const ft_pixel_mode_pal4 = FT_PIXEL_MODE_GRAY4;
pub const FT_OUTLINE_CONTOURS_MAX = @import("std").math.maxInt(c_ushort);
pub const FT_OUTLINE_POINTS_MAX = @import("std").math.maxInt(c_ushort);
pub const FT_OUTLINE_NONE = @as(c_int, 0x0);
pub const FT_OUTLINE_OWNER = @as(c_int, 0x1);
pub const FT_OUTLINE_EVEN_ODD_FILL = @as(c_int, 0x2);
pub const FT_OUTLINE_REVERSE_FILL = @as(c_int, 0x4);
pub const FT_OUTLINE_IGNORE_DROPOUTS = @as(c_int, 0x8);
pub const FT_OUTLINE_SMART_DROPOUTS = @as(c_int, 0x10);
pub const FT_OUTLINE_INCLUDE_STUBS = @as(c_int, 0x20);
pub const FT_OUTLINE_OVERLAP = @as(c_int, 0x40);
pub const FT_OUTLINE_HIGH_PRECISION = @as(c_int, 0x100);
pub const FT_OUTLINE_SINGLE_PASS = @as(c_int, 0x200);
pub const ft_outline_none = FT_OUTLINE_NONE;
pub const ft_outline_owner = FT_OUTLINE_OWNER;
pub const ft_outline_even_odd_fill = FT_OUTLINE_EVEN_ODD_FILL;
pub const ft_outline_reverse_fill = FT_OUTLINE_REVERSE_FILL;
pub const ft_outline_ignore_dropouts = FT_OUTLINE_IGNORE_DROPOUTS;
pub const ft_outline_high_precision = FT_OUTLINE_HIGH_PRECISION;
pub const ft_outline_single_pass = FT_OUTLINE_SINGLE_PASS;
pub inline fn FT_CURVE_TAG(flag: anytype) @TypeOf(flag & @as(c_int, 0x03)) {
    _ = &flag;
    return flag & @as(c_int, 0x03);
}
pub const FT_CURVE_TAG_ON = @as(c_int, 0x01);
pub const FT_CURVE_TAG_CONIC = @as(c_int, 0x00);
pub const FT_CURVE_TAG_CUBIC = @as(c_int, 0x02);
pub const FT_CURVE_TAG_HAS_SCANMODE = @as(c_int, 0x04);
pub const FT_CURVE_TAG_TOUCH_X = @as(c_int, 0x08);
pub const FT_CURVE_TAG_TOUCH_Y = @as(c_int, 0x10);
pub const FT_CURVE_TAG_TOUCH_BOTH = FT_CURVE_TAG_TOUCH_X | FT_CURVE_TAG_TOUCH_Y;
pub const FT_Curve_Tag_On = FT_CURVE_TAG_ON;
pub const FT_Curve_Tag_Conic = FT_CURVE_TAG_CONIC;
pub const FT_Curve_Tag_Cubic = FT_CURVE_TAG_CUBIC;
pub const FT_Curve_Tag_Touch_X = FT_CURVE_TAG_TOUCH_X;
pub const FT_Curve_Tag_Touch_Y = FT_CURVE_TAG_TOUCH_Y;
pub const FT_Outline_MoveTo_Func = FT_Outline_MoveToFunc;
pub const FT_Outline_LineTo_Func = FT_Outline_LineToFunc;
pub const FT_Outline_ConicTo_Func = FT_Outline_ConicToFunc;
pub const FT_Outline_CubicTo_Func = FT_Outline_CubicToFunc;
pub const ft_glyph_format_none = FT_GLYPH_FORMAT_NONE;
pub const ft_glyph_format_composite = FT_GLYPH_FORMAT_COMPOSITE;
pub const ft_glyph_format_bitmap = FT_GLYPH_FORMAT_BITMAP;
pub const ft_glyph_format_outline = FT_GLYPH_FORMAT_OUTLINE;
pub const ft_glyph_format_plotter = FT_GLYPH_FORMAT_PLOTTER;
pub const FT_Raster_Span_Func = FT_SpanFunc;
pub const FT_RASTER_FLAG_DEFAULT = @as(c_int, 0x0);
pub const FT_RASTER_FLAG_AA = @as(c_int, 0x1);
pub const FT_RASTER_FLAG_DIRECT = @as(c_int, 0x2);
pub const FT_RASTER_FLAG_CLIP = @as(c_int, 0x4);
pub const FT_RASTER_FLAG_SDF = @as(c_int, 0x8);
pub const ft_raster_flag_default = FT_RASTER_FLAG_DEFAULT;
pub const ft_raster_flag_aa = FT_RASTER_FLAG_AA;
pub const ft_raster_flag_direct = FT_RASTER_FLAG_DIRECT;
pub const ft_raster_flag_clip = FT_RASTER_FLAG_CLIP;
pub const FT_Raster_New_Func = FT_Raster_NewFunc;
pub const FT_Raster_Done_Func = FT_Raster_DoneFunc;
pub const FT_Raster_Reset_Func = FT_Raster_ResetFunc;
pub const FT_Raster_Set_Mode_Func = FT_Raster_SetModeFunc;
pub const FT_Raster_Render_Func = FT_Raster_RenderFunc;
pub inline fn FT_MAKE_TAG(_x1: anytype, _x2: anytype, _x3: anytype, _x4: anytype) @TypeOf((((FT_STATIC_BYTE_CAST(FT_Tag, _x1) << @as(c_int, 24)) | (FT_STATIC_BYTE_CAST(FT_Tag, _x2) << @as(c_int, 16))) | (FT_STATIC_BYTE_CAST(FT_Tag, _x3) << @as(c_int, 8))) | FT_STATIC_BYTE_CAST(FT_Tag, _x4)) {
    _ = &_x1;
    _ = &_x2;
    _ = &_x3;
    _ = &_x4;
    return (((FT_STATIC_BYTE_CAST(FT_Tag, _x1) << @as(c_int, 24)) | (FT_STATIC_BYTE_CAST(FT_Tag, _x2) << @as(c_int, 16))) | (FT_STATIC_BYTE_CAST(FT_Tag, _x3) << @as(c_int, 8))) | FT_STATIC_BYTE_CAST(FT_Tag, _x4);
}
pub inline fn FT_IS_EMPTY(list: anytype) @TypeOf(list.head == @as(c_int, 0)) {
    _ = &list;
    return list.head == @as(c_int, 0);
}
pub inline fn FT_BOOL(x: anytype) @TypeOf(FT_STATIC_CAST(FT_Bool, x != @as(c_int, 0))) {
    _ = &x;
    return FT_STATIC_CAST(FT_Bool, x != @as(c_int, 0));
}
pub const ft_encoding_none = FT_ENCODING_NONE;
pub const ft_encoding_unicode = FT_ENCODING_UNICODE;
pub const ft_encoding_symbol = FT_ENCODING_MS_SYMBOL;
pub const ft_encoding_latin_1 = FT_ENCODING_ADOBE_LATIN_1;
pub const ft_encoding_latin_2 = FT_ENCODING_OLD_LATIN_2;
pub const ft_encoding_sjis = FT_ENCODING_SJIS;
pub const ft_encoding_gb2312 = FT_ENCODING_PRC;
pub const ft_encoding_big5 = FT_ENCODING_BIG5;
pub const ft_encoding_wansung = FT_ENCODING_WANSUNG;
pub const ft_encoding_johab = FT_ENCODING_JOHAB;
pub const ft_encoding_adobe_standard = FT_ENCODING_ADOBE_STANDARD;
pub const ft_encoding_adobe_expert = FT_ENCODING_ADOBE_EXPERT;
pub const ft_encoding_adobe_custom = FT_ENCODING_ADOBE_CUSTOM;
pub const ft_encoding_apple_roman = FT_ENCODING_APPLE_ROMAN;
pub const FT_FACE_FLAG_SCALABLE = @as(c_long, 1) << @as(c_int, 0);
pub const FT_FACE_FLAG_FIXED_SIZES = @as(c_long, 1) << @as(c_int, 1);
pub const FT_FACE_FLAG_FIXED_WIDTH = @as(c_long, 1) << @as(c_int, 2);
pub const FT_FACE_FLAG_SFNT = @as(c_long, 1) << @as(c_int, 3);
pub const FT_FACE_FLAG_HORIZONTAL = @as(c_long, 1) << @as(c_int, 4);
pub const FT_FACE_FLAG_VERTICAL = @as(c_long, 1) << @as(c_int, 5);
pub const FT_FACE_FLAG_KERNING = @as(c_long, 1) << @as(c_int, 6);
pub const FT_FACE_FLAG_FAST_GLYPHS = @as(c_long, 1) << @as(c_int, 7);
pub const FT_FACE_FLAG_MULTIPLE_MASTERS = @as(c_long, 1) << @as(c_int, 8);
pub const FT_FACE_FLAG_GLYPH_NAMES = @as(c_long, 1) << @as(c_int, 9);
pub const FT_FACE_FLAG_EXTERNAL_STREAM = @as(c_long, 1) << @as(c_int, 10);
pub const FT_FACE_FLAG_HINTER = @as(c_long, 1) << @as(c_int, 11);
pub const FT_FACE_FLAG_CID_KEYED = @as(c_long, 1) << @as(c_int, 12);
pub const FT_FACE_FLAG_TRICKY = @as(c_long, 1) << @as(c_int, 13);
pub const FT_FACE_FLAG_COLOR = @as(c_long, 1) << @as(c_int, 14);
pub const FT_FACE_FLAG_VARIATION = @as(c_long, 1) << @as(c_int, 15);
pub const FT_FACE_FLAG_SVG = @as(c_long, 1) << @as(c_int, 16);
pub const FT_FACE_FLAG_SBIX = @as(c_long, 1) << @as(c_int, 17);
pub const FT_FACE_FLAG_SBIX_OVERLAY = @as(c_long, 1) << @as(c_int, 18);
pub inline fn FT_HAS_HORIZONTAL(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_HORIZONTAL) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_HORIZONTAL) != 0);
}
pub inline fn FT_HAS_VERTICAL(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_VERTICAL) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_VERTICAL) != 0);
}
pub inline fn FT_HAS_KERNING(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_KERNING) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_KERNING) != 0);
}
pub inline fn FT_IS_SCALABLE(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_SCALABLE) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_SCALABLE) != 0);
}
pub inline fn FT_IS_SFNT(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_SFNT) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_SFNT) != 0);
}
pub inline fn FT_IS_FIXED_WIDTH(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_FIXED_WIDTH) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_FIXED_WIDTH) != 0);
}
pub inline fn FT_HAS_FIXED_SIZES(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_FIXED_SIZES) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_FIXED_SIZES) != 0);
}
pub inline fn FT_HAS_FAST_GLYPHS(face: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &face;
    return @as(c_int, 0);
}
pub inline fn FT_HAS_GLYPH_NAMES(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_GLYPH_NAMES) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_GLYPH_NAMES) != 0);
}
pub inline fn FT_HAS_MULTIPLE_MASTERS(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_MULTIPLE_MASTERS) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_MULTIPLE_MASTERS) != 0);
}
pub inline fn FT_IS_NAMED_INSTANCE(face: anytype) @TypeOf(!!((face.*.face_index & @as(c_long, 0x7FFF0000)) != 0)) {
    _ = &face;
    return !!((face.*.face_index & @as(c_long, 0x7FFF0000)) != 0);
}
pub inline fn FT_IS_VARIATION(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_VARIATION) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_VARIATION) != 0);
}
pub inline fn FT_IS_CID_KEYED(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_CID_KEYED) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_CID_KEYED) != 0);
}
pub inline fn FT_IS_TRICKY(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_TRICKY) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_TRICKY) != 0);
}
pub inline fn FT_HAS_COLOR(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_COLOR) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_COLOR) != 0);
}
pub inline fn FT_HAS_SVG(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_SVG) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_SVG) != 0);
}
pub inline fn FT_HAS_SBIX(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_SBIX) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_SBIX) != 0);
}
pub inline fn FT_HAS_SBIX_OVERLAY(face: anytype) @TypeOf(!!((face.*.face_flags & FT_FACE_FLAG_SBIX_OVERLAY) != 0)) {
    _ = &face;
    return !!((face.*.face_flags & FT_FACE_FLAG_SBIX_OVERLAY) != 0);
}
pub const FT_STYLE_FLAG_ITALIC = @as(c_int, 1) << @as(c_int, 0);
pub const FT_STYLE_FLAG_BOLD = @as(c_int, 1) << @as(c_int, 1);
pub const FT_OPEN_MEMORY = @as(c_int, 0x1);
pub const FT_OPEN_STREAM = @as(c_int, 0x2);
pub const FT_OPEN_PATHNAME = @as(c_int, 0x4);
pub const FT_OPEN_DRIVER = @as(c_int, 0x8);
pub const FT_OPEN_PARAMS = @as(c_int, 0x10);
pub const ft_open_memory = FT_OPEN_MEMORY;
pub const ft_open_stream = FT_OPEN_STREAM;
pub const ft_open_pathname = FT_OPEN_PATHNAME;
pub const ft_open_driver = FT_OPEN_DRIVER;
pub const ft_open_params = FT_OPEN_PARAMS;
pub const FT_LOAD_DEFAULT = @as(c_int, 0x0);
pub const FT_LOAD_NO_SCALE = @as(c_long, 1) << @as(c_int, 0);
pub const FT_LOAD_NO_HINTING = @as(c_long, 1) << @as(c_int, 1);
pub const FT_LOAD_RENDER = @as(c_long, 1) << @as(c_int, 2);
pub const FT_LOAD_NO_BITMAP = @as(c_long, 1) << @as(c_int, 3);
pub const FT_LOAD_VERTICAL_LAYOUT = @as(c_long, 1) << @as(c_int, 4);
pub const FT_LOAD_FORCE_AUTOHINT = @as(c_long, 1) << @as(c_int, 5);
pub const FT_LOAD_CROP_BITMAP = @as(c_long, 1) << @as(c_int, 6);
pub const FT_LOAD_PEDANTIC = @as(c_long, 1) << @as(c_int, 7);
pub const FT_LOAD_IGNORE_GLOBAL_ADVANCE_WIDTH = @as(c_long, 1) << @as(c_int, 9);
pub const FT_LOAD_NO_RECURSE = @as(c_long, 1) << @as(c_int, 10);
pub const FT_LOAD_IGNORE_TRANSFORM = @as(c_long, 1) << @as(c_int, 11);
pub const FT_LOAD_MONOCHROME = @as(c_long, 1) << @as(c_int, 12);
pub const FT_LOAD_LINEAR_DESIGN = @as(c_long, 1) << @as(c_int, 13);
pub const FT_LOAD_SBITS_ONLY = @as(c_long, 1) << @as(c_int, 14);
pub const FT_LOAD_NO_AUTOHINT = @as(c_long, 1) << @as(c_int, 15);
pub const FT_LOAD_COLOR = @as(c_long, 1) << @as(c_int, 20);
pub const FT_LOAD_COMPUTE_METRICS = @as(c_long, 1) << @as(c_int, 21);
pub const FT_LOAD_BITMAP_METRICS_ONLY = @as(c_long, 1) << @as(c_int, 22);
pub const FT_LOAD_NO_SVG = @as(c_long, 1) << @as(c_int, 24);
pub const FT_LOAD_ADVANCE_ONLY = @as(c_long, 1) << @as(c_int, 8);
pub const FT_LOAD_SVG_ONLY = @as(c_long, 1) << @as(c_int, 23);
pub inline fn FT_LOAD_TARGET_(x: anytype) @TypeOf(FT_STATIC_CAST(FT_Int32, x & @as(c_int, 15)) << @as(c_int, 16)) {
    _ = &x;
    return FT_STATIC_CAST(FT_Int32, x & @as(c_int, 15)) << @as(c_int, 16);
}
pub const FT_LOAD_TARGET_NORMAL = FT_LOAD_TARGET_(FT_RENDER_MODE_NORMAL);
pub const FT_LOAD_TARGET_LIGHT = FT_LOAD_TARGET_(FT_RENDER_MODE_LIGHT);
pub const FT_LOAD_TARGET_MONO = FT_LOAD_TARGET_(FT_RENDER_MODE_MONO);
pub const FT_LOAD_TARGET_LCD = FT_LOAD_TARGET_(FT_RENDER_MODE_LCD);
pub const FT_LOAD_TARGET_LCD_V = FT_LOAD_TARGET_(FT_RENDER_MODE_LCD_V);
pub inline fn FT_LOAD_TARGET_MODE(x: anytype) @TypeOf(FT_STATIC_CAST(FT_Render_Mode, (x >> @as(c_int, 16)) & @as(c_int, 15))) {
    _ = &x;
    return FT_STATIC_CAST(FT_Render_Mode, (x >> @as(c_int, 16)) & @as(c_int, 15));
}
pub const ft_render_mode_normal = FT_RENDER_MODE_NORMAL;
pub const ft_render_mode_mono = FT_RENDER_MODE_MONO;
pub const ft_kerning_default = FT_KERNING_DEFAULT;
pub const ft_kerning_unfitted = FT_KERNING_UNFITTED;
pub const ft_kerning_unscaled = FT_KERNING_UNSCALED;
pub const FT_SUBGLYPH_FLAG_ARGS_ARE_WORDS = @as(c_int, 1);
pub const FT_SUBGLYPH_FLAG_ARGS_ARE_XY_VALUES = @as(c_int, 2);
pub const FT_SUBGLYPH_FLAG_ROUND_XY_TO_GRID = @as(c_int, 4);
pub const FT_SUBGLYPH_FLAG_SCALE = @as(c_int, 8);
pub const FT_SUBGLYPH_FLAG_XY_SCALE = @as(c_int, 0x40);
pub const FT_SUBGLYPH_FLAG_2X2 = @as(c_int, 0x80);
pub const FT_SUBGLYPH_FLAG_USE_MY_METRICS = @as(c_int, 0x200);
pub const FT_FSTYPE_INSTALLABLE_EMBEDDING = @as(c_int, 0x0000);
pub const FT_FSTYPE_RESTRICTED_LICENSE_EMBEDDING = @as(c_int, 0x0002);
pub const FT_FSTYPE_PREVIEW_AND_PRINT_EMBEDDING = @as(c_int, 0x0004);
pub const FT_FSTYPE_EDITABLE_EMBEDDING = @as(c_int, 0x0008);
pub const FT_FSTYPE_NO_SUBSETTING = @as(c_int, 0x0100);
pub const FT_FSTYPE_BITMAP_EMBEDDING_ONLY = @as(c_int, 0x0200);
pub const FREETYPE_MAJOR = @as(c_int, 2);
pub const FREETYPE_MINOR = @as(c_int, 13);
pub const FREETYPE_PATCH = @as(c_int, 3);
pub const FTOUTLN_H_ = "";
pub const FT_MemoryRec_ = struct_FT_MemoryRec_;
pub const FT_StreamDesc_ = union_FT_StreamDesc_;
pub const FT_StreamRec_ = struct_FT_StreamRec_;
pub const FT_Vector_ = struct_FT_Vector_;
pub const FT_BBox_ = struct_FT_BBox_;
pub const FT_Pixel_Mode_ = enum_FT_Pixel_Mode_;
pub const FT_Bitmap_ = struct_FT_Bitmap_;
pub const FT_Outline_ = struct_FT_Outline_;
pub const FT_Outline_Funcs_ = struct_FT_Outline_Funcs_;
pub const FT_Glyph_Format_ = enum_FT_Glyph_Format_;
pub const FT_Span_ = struct_FT_Span_;
pub const FT_Raster_Params_ = struct_FT_Raster_Params_;
pub const FT_RasterRec_ = struct_FT_RasterRec_;
pub const FT_Raster_Funcs_ = struct_FT_Raster_Funcs_;
pub const FT_UnitVector_ = struct_FT_UnitVector_;
pub const FT_Matrix_ = struct_FT_Matrix_;
pub const FT_Data_ = struct_FT_Data_;
pub const FT_Generic_ = struct_FT_Generic_;
pub const FT_ListNodeRec_ = struct_FT_ListNodeRec_;
pub const FT_ListRec_ = struct_FT_ListRec_;
pub const FT_Glyph_Metrics_ = struct_FT_Glyph_Metrics_;
pub const FT_Bitmap_Size_ = struct_FT_Bitmap_Size_;
pub const FT_LibraryRec_ = struct_FT_LibraryRec_;
pub const FT_ModuleRec_ = struct_FT_ModuleRec_;
pub const FT_DriverRec_ = struct_FT_DriverRec_;
pub const FT_RendererRec_ = struct_FT_RendererRec_;
pub const FT_Encoding_ = enum_FT_Encoding_;
pub const FT_CharMapRec_ = struct_FT_CharMapRec_;
pub const FT_SubGlyphRec_ = struct_FT_SubGlyphRec_;
pub const FT_Slot_InternalRec_ = struct_FT_Slot_InternalRec_;
pub const FT_GlyphSlotRec_ = struct_FT_GlyphSlotRec_;
pub const FT_Size_Metrics_ = struct_FT_Size_Metrics_;
pub const FT_Size_InternalRec_ = struct_FT_Size_InternalRec_;
pub const FT_SizeRec_ = struct_FT_SizeRec_;
pub const FT_Face_InternalRec_ = struct_FT_Face_InternalRec_;
pub const FT_FaceRec_ = struct_FT_FaceRec_;
pub const FT_Parameter_ = struct_FT_Parameter_;
pub const FT_Open_Args_ = struct_FT_Open_Args_;
pub const FT_Size_Request_Type_ = enum_FT_Size_Request_Type_;
pub const FT_Size_RequestRec_ = struct_FT_Size_RequestRec_;
pub const FT_Render_Mode_ = enum_FT_Render_Mode_;
pub const FT_Kerning_Mode_ = enum_FT_Kerning_Mode_;
pub const FT_Orientation_ = enum_FT_Orientation_;
