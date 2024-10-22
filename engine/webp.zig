const std = @import("std");

const Self = @This();

const cwebp = @cImport({
    @cInclude("webp/decode.h");
    @cInclude("webp/demux.h");
});

const image_util = @import("image_util.zig");

config: ?union(enum) {
    decode: cwebp.WebPDecoderConfig,
    decode_anim: cwebp.WebPAnimDecoderOptions,
} = null,

__anim_dec: *cwebp.WebPAnimDecoder = undefined,
anim_info: cwebp.WebPAnimInfo = undefined,

pub const webp_error = error{
    ///load_header
    WebPAnimDecoderNew_error,
    ///load_header
    WebPGetFeatures_error,
    ///load_header
    WebPInitDecoderConfig_error,
    ///decode
    WebPDecode_error,
    ///decode
    unsupport_decode_fmt_error,
    not_load_header,
};

pub fn width(self: *Self) u32 {
    if (self.*.config != null) {
        if (self.*.config.? == .decode) return @max(0, self.*.config.?.decode.input.width);
        if (self.*.config.? == .decode_anim) return self.*.anim_info.canvas_width;
    }
    return 0;
}
pub fn height(self: *Self) u32 {
    if (self.*.config != null) {
        if (self.*.config.? == .decode) return @max(0, self.*.config.?.decode.input.height);
        if (self.*.config.? == .decode_anim) return self.*.anim_info.canvas_height;
    }
    return 0;
}

pub fn size(self: *Self, out_fmt: image_util.color_format) usize {
    if (self.*.config != null) {
        const bit = @divExact(image_util.bit(out_fmt), 8);
        if (self.*.config.? == .decode) return @max(0, self.*.config.?.decode.input.height * self.*.config.?.decode.input.width) * bit;
        if (self.*.config.? == .decode_anim) return self.*.anim_info.canvas_width * self.*.anim_info.canvas_height * bit * self.*.anim_info.frame_count;
    }
    return 0;
}

pub fn frame_count(self: *Self) u32 {
    if (self.*.config == null or self.*.config.? != .decode_anim) return 0;
    return self.*.anim_info.frame_count;
}

pub fn deinit(self: *Self) void {
    if (self.*.config != null) {
        if (self.*.config.? == .decode) {
            cwebp.WebPFreeDecBuffer(&self.*.config.?.decode.output);
            self.*.config = null;
        } else if (self.*.config.? == .decode_anim) {
            cwebp.WebPAnimDecoderDelete(self.*.__anim_dec);
            self.*.config = null;
        }
    }
}

///for decoding
pub fn load_header(self: *Self, data: []const u8) webp_error!void {
    deinit(self);
    self.*.config = .{
        .decode = undefined,
    };
    if (cwebp.WebPInitDecoderConfig(&self.*.config.?.decode) == 0) return webp_error.WebPInitDecoderConfig_error;
    self.*.config.?.decode.options.no_fancy_upsampling = 1;
    if (cwebp.WebPGetFeatures(data.ptr, data.len, &self.*.config.?.decode.input) != cwebp.VP8_STATUS_OK) return webp_error.WebPGetFeatures_error;

    self.*.config.?.decode.options.scaled_width = self.*.config.?.decode.input.width;
    self.*.config.?.decode.options.scaled_height = self.*.config.?.decode.input.height;
}

///for anim decoding
pub fn load_anim_header(self: *Self, data: []const u8) webp_error!void {
    deinit(self);
    self.*.config = .{
        .decode_anim = undefined,
    };
    _ = cwebp.WebPAnimDecoderOptionsInit(&self.*.config.?.decode_anim);
    const wd = cwebp.WebPData{
        .bytes = data.ptr,
        .size = data.len,
    };
    self.*.__anim_dec = cwebp.WebPAnimDecoderNew(&wd, &self.*.config.?.decode_anim) orelse return webp_error.WebPAnimDecoderNew_error;
    _ = cwebp.WebPAnimDecoderGetInfo(self.*.__anim_dec, &self.*.anim_info);
}

pub fn decode(self: *Self, out_fmt: image_util.color_format, data: []const u8, out_data: []u8) webp_error!void {
    if (self.*.config == null) return webp_error.not_load_header;

    const bit = @divExact(image_util.bit(out_fmt), 8);
    if (self.*.config.? == .decode) {
        switch (out_fmt) {
            .RGBA => self.*.config.?.decode.output.colorspace = cwebp.MODE_RGBA,
            .ARGB => self.*.config.?.decode.output.colorspace = cwebp.MODE_ARGB,
            .BGRA => self.*.config.?.decode.output.colorspace = cwebp.MODE_BGRA,
            .RGB => self.*.config.?.decode.output.colorspace = cwebp.MODE_RGB,
            .BGR => self.*.config.?.decode.output.colorspace = cwebp.MODE_BGR,
            else => return webp_error.unsupport_decode_fmt_error,
        }
        self.*.config.?.decode.output.u.RGBA.rgba = out_data.ptr;
        self.*.config.?.decode.output.u.RGBA.stride = self.*.config.?.decode.input.width * @as(c_int, @intCast(bit));
        self.*.config.?.decode.output.u.RGBA.size = @max(0, self.*.config.?.decode.output.u.RGBA.stride * self.*.config.?.decode.input.height);
        self.*.config.?.decode.output.is_external_memory = 1;

        if (cwebp.WebPDecode(data.ptr, data.len, &self.*.config.?.decode) != cwebp.VP8_STATUS_OK) return webp_error.WebPDecode_error;
    } else {
        var idx: usize = 0;
        const frame_size: usize = self.*.anim_info.canvas_width * self.*.anim_info.canvas_height * bit;
        while (1 == cwebp.WebPAnimDecoderHasMoreFrames(self.*.__anim_dec)) : (idx += frame_size) {
            var timestamp: c_int = undefined;
            var buf: [*c]u8 = undefined;
            _ = cwebp.WebPAnimDecoderGetNext(self.*.__anim_dec, &buf, &timestamp);
            @memcpy(out_data[idx .. idx + frame_size], buf[0..frame_size]);
        }
    }

    self.*.deinit();
}
