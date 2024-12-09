// !! android platform only do not change
comptime {
    _ = xfit.__android_entry;
}
// !!

const std = @import("std");
const xfit = @import("xfit");
const system = xfit.system;
const font = xfit.font;
const webp = xfit.webp;
const image_util = xfit.image_util;
const window = xfit.window;
const animator = xfit.animator;
const input = xfit.input;
const collision = xfit.collision;
const components = xfit.components;
const lua = xfit.lua;
const timer_callback = xfit.timer_callback;
const file_ = if (xfit.platform == .android) xfit.asset_file else xfit.file;
const file = xfit.file;
const math = xfit.math;
const mem = xfit.mem;
const graphics = xfit.graphics;
const render_command = xfit.render_command;
const geometry = xfit.geometry;
const svg = xfit.svg;

const ArrayList = std.ArrayList;
var gpa: std.heap.GeneralPurposeAllocator(.{}) = undefined;
var allocator: std.mem.Allocator = undefined;
var arena: std.heap.ArenaAllocator = undefined;
var arena_alloc: std.mem.Allocator = undefined;

const matrix = math.matrix;
const iarea = collision.iarea;

pub var objects: ArrayList(*graphics.iobject) = undefined;

pub var g_proj: graphics.projection = .{};
pub var g_camera: graphics.camera = undefined;

var font0: font = undefined;
var font0_data: []u8 = undefined;

var rect_button_src: graphics.shape_source = undefined;
var button_area_rect = math.rect{ .left = -100, .right = 100, .top = 50, .bottom = -50 };

var shape_src: *graphics.shape_source = undefined;
var github_shape_src: graphics.shape_source = undefined;
var image_src: graphics.texture = undefined;
var anim_image_src: graphics.texture_array = undefined;
var cmd: *render_command = undefined;
var cmds: [1]*render_command = .{undefined};

var color_trans: graphics.color_transform = undefined;

const player = animator.player;
const animate_object = animator.animate_object;

var anim: player = .{
    .target_fps = 10,
    .obj = .{ .obj = undefined },
};

pub const CANVAS_W: f32 = 1280;
pub const CANVAS_H: f32 = 720;

fn error_func(text: []u8, stack_trace: []u8) void {
    var fs: file = .{};
    fs.create("xfit_err.log", .{
        .truncate = false,
    }) catch return;
    defer fs.close();
    _ = fs.seekFromEnd(0) catch return;
    _ = fs.write(text) catch return;
    _ = fs.write(stack_trace) catch return;
}

var g_rect_button: *components.button = undefined;
var move_callback_thread: std.Thread = undefined;

var text_shape: *graphics.iobject = undefined;
var rect_button: *graphics.iobject = undefined;

var github_shape: *graphics.iobject = undefined;

var img: *graphics.iobject = undefined;
var anim_img: *graphics.iobject = undefined;

pub fn xfit_init() !void {
    //lua test
    var luaT = lua.luaL_newstate();
    defer luaT.lua_close();
    luaT.luaL_openlibs();

    try luaT.luaL_loadstring("function Printhello()\nprint(\"hello\")\nend\n");
    try luaT.lua_pcall(0, 0, 0);
    _ = luaT.lua_getglobal("Printhello");
    try luaT.lua_pcall(0, 0, 0);

    try luaT.luaL_dostring("print(\"hello\")\n");

    if (xfit.platform != .android) { //android can't use standard FILE
        try luaT.luaL_loadfile("test.lua");
        try luaT.lua_pcall(0, 0, 0);
        _ = luaT.lua_getglobal("Printhello");
        try luaT.lua_pcall(0, 0, 0);
    }
    //

    //make global g_proj and g_camera
    try g_proj.init_matrix_orthographic(CANVAS_W, CANVAS_H);
    g_proj.build(.cpu);

    g_camera = graphics.camera.init(.{ 0, 0, -1, 1 }, .{ 0, 0, 0, 1 }, .{ 0, 1, 0, 1 });
    g_camera.build();
    //

    //alloc and set iobjects
    objects = ArrayList(*graphics.iobject).init(arena_alloc);
    const iobjs = try arena_alloc.alloc(graphics.iobject, 5);

    text_shape = &iobjs[0];
    rect_button = &iobjs[1];
    img = &iobjs[2];
    anim_img = &iobjs[3];
    github_shape = &iobjs[4];
    //

    //graphics.set_render_clear_color(.{ 1, 1, 1, 0 });

    //load and decode test.webp
    const data = file_.read_file("test.webp", allocator) catch |e| xfit.herr3("test.webp read_file", e);
    defer allocator.free(data);
    var img_decoder: webp = .{};
    defer img_decoder.deinit();
    img_decoder.load_header(data, image_util.color_format.default()) catch |e| xfit.herr3("test.webp loadheader fail", e);

    image_src = graphics.texture.init();
    const image_pixels = try arena_alloc.alloc(u8, img_decoder.width() * img_decoder.height() * 4);
    img_decoder.decode(data, image_pixels) catch |e| xfit.herr3("test.webp decode", e);
    image_src.build(img_decoder.width(), img_decoder.height(), image_pixels);

    color_trans = graphics.color_transform.init();
    color_trans.color_mat = .{
        .{ -1, 0, 0, 0 },
        .{ 0, -1, 0, 0 },
        .{ 0, 0, -1, 0 },
        .{ 1, 1, 1, 1 },
    };
    color_trans.build(.gpu);

    img.* = .{ ._image = graphics.image.init(&image_src) };

    img.*._image.color_tran = &color_trans;
    img.*._image.transform.camera = &g_camera;
    img.*._image.transform.projection = &g_proj;
    img.*._image.transform.model = math.matrix_multiply(math.matrix_scaling(f32, 2, 2, 1.0), math.matrix_translation(f32, 0, 0, 0.7));
    img.*.build();
    //

    //load and decode wasp.webp
    const anim_data = file_.read_file("wasp.webp", allocator) catch |e| xfit.herr3("wasp.webp read_file", e);
    defer allocator.free(anim_data);
    img_decoder.load_anim_header(anim_data, image_util.color_format.default()) catch |e| xfit.herr3("wasp.webp load_anim_header fail", e);

    anim_image_src = graphics.texture_array.init();
    anim_image_src.sampler = graphics.get_default_nearest_sampler();
    const anim_pixels = try arena_alloc.alloc(u8, img_decoder.size(image_util.color_format.default()));
    img_decoder.decode(data, anim_pixels) catch |e| xfit.herr3("wasp.webp decode", e);
    anim_image_src.build(img_decoder.width(), img_decoder.height(), img_decoder.frame_count(), anim_pixels);

    anim_img.* = .{ ._anim_image = graphics.animate_image.init(&anim_image_src) };

    anim_img.*._anim_image.transform.camera = &g_camera;
    anim_img.*._anim_image.transform.projection = &g_proj;
    anim_img.*._anim_image.transform.model = math.matrix_translation(f32, 300, -200, 0);
    anim_img.*.build();

    anim.obj.obj = anim_img;
    anim.play();
    //

    //load and init font
    font0_data = file_.read_file("Spoqa Han Sans Regular.woff", arena_alloc) catch |e| xfit.herr3("read_file font0_data", e);
    font0 = font.init(font0_data, 0) catch |e| xfit.herr3("font0.init", e);
    //

    //build text
    const option2: font.render_option2 = .{
        .option = .{},
        .ranges = &[_]font.range{
            .{
                .font = &font0,
                .color = .{ 1, 1, 1, 1 },
                .len = 5,
                .scale = .{ 2, 2 },
            },
            .{
                .font = &font0,
                .color = .{ 0, 0, 1, 1 },
                .len = 0,
                .scale = .{ 1, 1 },
            },
        },
    };
    shape_src = try font.render_string2("Hello World!\n안녕하세요. break;", option2, arena_alloc);
    text_shape.* = .{ ._shape = graphics.shape.init(shape_src) };

    text_shape.*._shape.transform.camera = &g_camera;
    text_shape.*._shape.transform.projection = &g_proj;

    text_shape.*._shape.transform.model = math.matrix_multiply(math.matrix_scaling(f32, 5.0, 5.0, 1.0), math.matrix_translation(f32, -200.0, 0.0, 0.5));
    text_shape.*.build();
    //

    //build button
    var button_src = try components.button.make_square_button_raw(.{ 200, 100 }, 2, arena_alloc, allocator);
    defer button_src[1].deinit(allocator);

    const rect_text_src_raw = try font0.render_string_raw("버튼", .{ .pivot = .{ 0.5, 0.3 }, .scale = .{ 4.5, 4.5 }, .color = .{ 0, 0, 0, 1 } }, allocator);
    defer rect_text_src_raw.deinit(allocator);
    var concat_button_src = try button_src[1].concat(rect_text_src_raw, allocator);
    defer concat_button_src.deinit(allocator);

    rect_button_src = graphics.shape_source.init();
    try rect_button_src.build(arena_alloc, concat_button_src, .gpu, .cpu);

    rect_button.* = .{ ._button = try components.button.init(&rect_button_src, .{ .rect = math.rect.calc_with_canvas(button_area_rect, CANVAS_W, CANVAS_H) }, button_src[0]) };
    rect_button.*._button.shape.transform.camera = &g_camera;
    rect_button.*._button.shape.transform.projection = &g_proj;
    rect_button.*.build();

    g_rect_button = &rect_button.*._button;

    //

    //load svg and build
    const svg_data = file_.read_file("github-mark-white.svg", allocator) catch |e| xfit.herr3("github-mark-white.svg read_file", e);
    defer allocator.free(svg_data);
    var svg_parser: svg = try svg.init_parse(allocator, svg_data);
    defer svg_parser.deinit();

    var svg_datas = try svg_parser.calculate_shapes(allocator);
    defer svg_datas[1].deinit();

    var github_shape_raw = try svg_datas[0].compute_polygon(allocator);
    defer github_shape_raw.deinit(allocator);
    github_shape_src = graphics.shape_source.init();
    try github_shape_src.build(arena_alloc, github_shape_raw, .gpu, .cpu);

    github_shape.* = .{ ._shape = graphics.shape.init(&github_shape_src) };
    github_shape.*._shape.transform.camera = &g_camera;
    github_shape.*._shape.transform.projection = &g_proj;
    github_shape.*._shape.transform.model = math.matrix_multiply(
        math.matrix_scaling(f32, 2, 2, 1),
        math.matrix_translation(f32, -450, 0, 0),
    );
    github_shape.*.build();
    //

    //append objects
    try objects.append(img);
    try objects.append(text_shape);
    try objects.append(anim_img);
    try objects.append(rect_button);
    try objects.append(github_shape);
    //

    cmd = render_command.init();
    cmd.*.scene = objects.items[0..objects.items.len]; // set objects to render_command

    cmds[0] = cmd;
    graphics.render_cmd = cmds[0..cmds.len]; //set render_command to global

    //add input events
    input.set_key_down_func(key_down);
    input.set_mouse_move_func(mouse_move);
    input.set_touch_move_func(touch_move);
    input.set_Lmouse_down_func(mouse_down);
    input.set_Lmouse_up_func(mouse_up);
    input.set_touch_down_func(touch_down);
    input.set_touch_up_func(touch_up);
    //

    //add timer callback thread 1/100 sec
    move_callback_thread = try timer_callback.start(
        xfit.sec_to_nano_sec2(0, 10, 0, 0),
        0,
        move_callback,
        .{},
    );
    //

    // _ = try timer_callback.start(
    //     xfit.sec_to_nano_sec2(0, 1, 0, 0),
    //     0,
    //     multi_execute_and_wait,
    //     .{},
    // );
}

fn mouse_move(pos: math.point) void {
    g_rect_button.on_mouse_move(pos, {}, .{});
}
fn mouse_down(pos: math.point) void {
    g_rect_button.on_mouse_down(pos, {}, .{});
}
fn mouse_up(pos: math.point) void {
    g_rect_button.on_mouse_up(pos, {}, .{});
}

fn touch_down(touch_idx: u32, pos: math.point) void {
    g_rect_button.on_touch_down(touch_idx, pos, {}, .{});
}
fn touch_up(touch_idx: u32, pos: math.point) void {
    g_rect_button.on_touch_up(touch_idx, pos, {}, .{});
}
fn touch_move(touch_idx: u32, pos: math.point) void {
    g_rect_button.on_touch_move(touch_idx, pos, {}, .{});
}

var image_front: bool = false;
fn key_down(_key: input.key) void {
    if (_key == input.key.F4) {
        if (window.get_screen_mode() == .WINDOW) {
            const monitor = window.get_monitor_from_window();
            monitor.*.set_fullscreen_mode();
            //monitor.*.set_borderlessscreen_mode();
        } else {
            window.set_window_mode();
        }
    } else {
        switch (xfit.platform) {
            .android => {
                if (_key == input.key.Back) {
                    xfit.exit();
                }
            },
            else => {
                if (_key == input.key.Esc) {
                    xfit.exit();
                }
                //  else if (_key == input.key.Enter) {
                //     img.*._image.transform.model = matrix.scaling(2, 2, 1.0).multiply(&matrix.translation(0, 0, if (image_front) 0.7 else 0.3));
                //     image_front = !image_front;
                //     img.*._image.transform.copy_update();
                // } now, to align shape and image, need to make multiple renderCommand.
            },
        }
    }
}

//multi execute and wait test
fn multi_execute_and_wait() !void {
    graphics.execute_all_op();
    graphics.execute_and_wait_all_op();
}

var update_mutex: std.Thread.Mutex = .{};

var dx: f32 = 0;
var shape_alpha: f32 = 0.0;

//other thread test, can use in xfit_update.
fn move_callback() !bool {
    if (xfit.exiting()) return false;

    update_mutex.lock();
    shape_alpha += 0.005;
    if (shape_alpha >= 1.0) shape_alpha = 0;
    dx += 1;
    if (dx >= 200) {
        dx = 0;
        update_mutex.unlock();
        xfit.print_log("{d}\n", .{xfit.dt()});
    } else update_mutex.unlock();

    return true;
}

pub fn xfit_update() !void {
    update_mutex.lock();

    shape_src.*.copy_color_update(0, &[_]math.vector{.{ 1, 1, 1, shape_alpha }});
    text_shape.*._shape.transform.model = math.matrix_multiply(math.matrix_scaling(f32, 5, 5, 1.0), math.matrix_translation(f32, -200 + dx, 0, 0.5));
    update_mutex.unlock();

    text_shape.*._shape.transform.copy_update();
    rect_button.*.update();

    anim.update(xfit.dt());
}

pub fn xfit_size() !void {
    try g_proj.init_matrix_orthographic(CANVAS_W, CANVAS_H);

    g_proj.copy_update();

    g_rect_button.*.area.rect = math.rect.calc_with_canvas(button_area_rect, CANVAS_W, CANVAS_H);
}

///before system clean
pub fn xfit_destroy() !void {
    move_callback_thread.join();

    shape_src.*.deinit();
    rect_button_src.deinit();
    github_shape_src.deinit();

    image_src.deinit();
    anim_image_src.deinit();

    g_camera.deinit();
    g_proj.deinit();

    for (objects.items) |value| {
        value.*.deinit();
    }

    font0.deinit();

    cmd.deinit();
    color_trans.deinit();
}

///after system clean
pub fn xfit_clean() !void {
    arena.deinit();
    if (xfit.dbg and gpa.deinit() != .ok) unreachable;
}

pub fn xfit_activate(is_activate: bool, is_pause: bool) !void {
    _ = is_activate;
    _ = is_pause;
}

pub fn xfit_closing() !bool {
    return true;
}

pub fn main() !void {
    const init_setting: xfit.init_setting = .{
        .window_width = 640,
        .window_height = 480,
        .use_console = true,
        //.vSync = .none,
        //.maxframe = 62, +2 is rough error correction value
    };
    gpa = std.heap.GeneralPurposeAllocator(.{}).init;
    allocator = gpa.allocator(); //must init in main
    arena = std.heap.ArenaAllocator.init(allocator);
    arena_alloc = arena.allocator();

    xfit.set_error_handling_func(error_func);
    xfit.xfit_main(allocator, &init_setting);
}
