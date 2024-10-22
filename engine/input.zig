const std = @import("std");

const __android = @import("__android.zig");
const __windows = @import("__windows.zig");
const window = @import("window.zig");
const __system = @import("__system.zig");
const system = @import("system.zig");
const math = @import("math.zig");

pub const general_input = @import("general_input.zig");
pub const xbox_pad_input = @import("xbox_pad_input.zig");

pub const key =
    if (system.platform == .windows)
    enum(u16) {
        A = 'A',
        B = 'B',
        C = 'C',
        D = 'D',
        E = 'E',
        F = 'F',
        G = 'G',
        H = 'H',
        I = 'I',
        J = 'J',
        K = 'K',
        L = 'L',
        M = 'M',
        N = 'N',
        O = 'O',
        P = 'P',
        Q = 'Q',
        R = 'R',
        S = 'S',
        T = 'T',
        U = 'U',
        V = 'V',
        W = 'W',
        X = 'X',
        Y = 'Y',
        Z = 'Z',
        One = '1',
        Two = '2',
        Three = '3',
        Four = '4',
        Five = '5',
        Six = '6',
        Seven = '7',
        Eight = '8',
        Nine = '9',
        Zero = '0',
        Numpad1 = __windows.win32.VK_NUMPAD1,
        Numpad2 = __windows.win32.VK_NUMPAD2,
        Numpad3 = __windows.win32.VK_NUMPAD3,
        Numpad4 = __windows.win32.VK_NUMPAD4,
        Numpad5 = __windows.win32.VK_NUMPAD5,
        Numpad6 = __windows.win32.VK_NUMPAD6,
        Numpad7 = __windows.win32.VK_NUMPAD7,
        Numpad8 = __windows.win32.VK_NUMPAD8,
        Numpad9 = __windows.win32.VK_NUMPAD9,
        Numpad0 = __windows.win32.VK_NUMPAD0,
        NumLock = __windows.win32.VK_NUMLOCK,
        ScrollLock = __windows.win32.VK_SCROLL,
        CapsLock = __windows.win32.VK_CAPITAL,
        NumpadAdd = __windows.win32.VK_ADD,
        NumpadSubtract = __windows.win32.VK_SUBTRACT,
        NumpadMultiply = __windows.win32.VK_MULTIPLY,
        NumpadDivide = __windows.win32.VK_DIVIDE,
        Numpad_Dot = __windows.win32.VK_DECIMAL,
        Enter = __windows.win32.VK_RETURN, // Numpad and Standard
        LShift = __windows.win32.VK_LSHIFT,
        RShift = __windows.win32.VK_RSHIFT,
        Shift = __windows.win32.VK_SHIFT,
        Control = __windows.win32.VK_CONTROL,
        LControl = __windows.win32.VK_LCONTROL,
        RControl = __windows.win32.VK_RCONTROL,
        Tap = __windows.win32.VK_TAB,
        Esc = __windows.win32.VK_ESCAPE,
        IMEProcess = __windows.win32.VK_PROCESSKEY,
        Apps = __windows.win32.VK_APPS,
        SpaceBar = __windows.win32.VK_SPACE,
        F1 = __windows.win32.VK_F1,
        F2 = __windows.win32.VK_F2,
        F3 = __windows.win32.VK_F3,
        F4 = __windows.win32.VK_F4,
        F5 = __windows.win32.VK_F5,
        F6 = __windows.win32.VK_F6,
        F7 = __windows.win32.VK_F7,
        F8 = __windows.win32.VK_F8,
        F9 = __windows.win32.VK_F9,
        F10 = __windows.win32.VK_F10,
        F11 = __windows.win32.VK_F11,
        F12 = __windows.win32.VK_F12,
        Dot = __windows.win32.VK_OEM_PERIOD,
        Comma = __windows.win32.VK_OEM_COMMA,
        Plus = __windows.win32.VK_OEM_PLUS,
        Minus = __windows.win32.VK_OEM_MINUS,
        ///\
        BackSlash = __windows.win32.VK_OEM_5,
        Slash = __windows.win32.VK_OEM_2,
        ///[
        LSquareBracket = __windows.win32.VK_OEM_4,
        ///]
        RSquareBracket = __windows.win32.VK_OEM_6,
        ///`
        SwungDash = __windows.win32.VK_OEM_3,
        Insert = __windows.win32.VK_INSERT,
        Home = __windows.win32.VK_HOME,
        PageUp = __windows.win32.VK_PRIOR,
        PageDown = __windows.win32.VK_NEXT,
        Delete = __windows.win32.VK_DELETE,
        End = __windows.win32.VK_END,
        Pause = __windows.win32.VK_PAUSE,
        ///;
        Semicolon = __windows.win32.VK_OEM_1,
        ///'
        Apostrophe = __windows.win32.VK_OEM_7,
        Up = __windows.win32.VK_UP,
        Down = __windows.win32.VK_DOWN,
        Left = __windows.win32.VK_LEFT,
        Right = __windows.win32.VK_RIGHT,
        BackSpace = __windows.win32.VK_BACK,
        Alt = __windows.win32.VK_MENU,
        _,
    }
else if (system.platform == .android)
    enum(u16) {
        Unknown = __android.android.AKEYCODE_UNKNOWN,

        SoftLeft = __android.android.AKEYCODE_SOFT_LEFT,
        SoftRight = __android.android.AKEYCODE_SOFT_RIGHT,

        Home = __android.android.AKEYCODE_HOME,
        Back = __android.android.AKEYCODE_BACK,
        Call = __android.android.AKEYCODE_CALL,
        EndCall = __android.android.AKEYCODE_ENDCALL,

        Zero = __android.android.AKEYCODE_0,
        One = __android.android.AKEYCODE_1,
        Two = __android.android.AKEYCODE_2,
        Three = __android.android.AKEYCODE_3,
        Four = __android.android.AKEYCODE_4,
        Five = __android.android.AKEYCODE_5,
        Six = __android.android.AKEYCODE_6,
        Seven = __android.android.AKEYCODE_7,
        Eight = __android.android.AKEYCODE_8,
        Nine = __android.android.AKEYCODE_9,

        Multiply = __android.android.AKEYCODE_STAR,
        Sharp = __android.android.AKEYCODE_POUND,

        Up = __android.android.AKEYCODE_DPAD_UP,
        Down = __android.android.AKEYCODE_DPAD_DOWN,
        Left = __android.android.AKEYCODE_DPAD_LEFT,
        Right = __android.android.AKEYCODE_DPAD_RIGHT,
        Center = __android.android.AKEYCODE_DPAD_CENTER,
        UpLeft = __android.android.AKEYCODE_DPAD_UP_LEFT,
        DownLeft = __android.android.AKEYCODE_DPAD_DOWN_LEFT,
        UpRight = __android.android.AKEYCODE_DPAD_UP_RIGHT,
        DownRight = __android.android.AKEYCODE_DPAD_DOWN_RIGHT,

        VolumeUp = __android.android.AKEYCODE_VOLUME_UP,
        VoulmeDown = __android.android.AKEYCODE_VOLUME_DOWN,

        Power = __android.android.AKEYCODE_POWER,
        Camera = __android.android.AKEYCODE_CAMERA,
        Clear = __android.android.AKEYCODE_CLEAR,

        A = __android.android.AKEYCODE_A,
        B = __android.android.AKEYCODE_B,
        C = __android.android.AKEYCODE_C,
        D = __android.android.AKEYCODE_D,
        E = __android.android.AKEYCODE_E,
        F = __android.android.AKEYCODE_F,
        G = __android.android.AKEYCODE_G,
        H = __android.android.AKEYCODE_H,
        I = __android.android.AKEYCODE_I,
        J = __android.android.AKEYCODE_J,
        K = __android.android.AKEYCODE_K,
        L = __android.android.AKEYCODE_L,
        M = __android.android.AKEYCODE_M,
        N = __android.android.AKEYCODE_N,
        O = __android.android.AKEYCODE_O,
        P = __android.android.AKEYCODE_P,
        Q = __android.android.AKEYCODE_Q,
        R = __android.android.AKEYCODE_R,
        S = __android.android.AKEYCODE_S,
        T = __android.android.AKEYCODE_T,
        U = __android.android.AKEYCODE_U,
        V = __android.android.AKEYCODE_V,
        W = __android.android.AKEYCODE_W,
        X = __android.android.AKEYCODE_X,
        Y = __android.android.AKEYCODE_Y,
        Z = __android.android.AKEYCODE_Z,

        Comma = __android.android.AKEYCODE_COMMA,
        Dot = __android.android.AKEYCODE_PERIOD,
        LAlt = __android.android.AKEYCODE_ALT_LEFT,
        RAlt = __android.android.AKEYCODE_ALT_RIGHT,
        LShift = __android.android.AKEYCODE_SHIFT_LEFT,
        RShift = __android.android.AKEYCODE_SHIFT_RIGHT,
        Tap = __android.android.AKEYCODE_TAB,
        SpaceBar = __android.android.AKEYCODE_SPACE,
        /// Used to enter alternate symbols.
        Sym = __android.android.AKEYCODE_SYM,
        /// Used to launch a browser application.
        Browser = __android.android.AKEYCODE_EXPLORER,
        Mail = __android.android.AKEYCODE_ENVELOPE,
        Enter = __android.android.AKEYCODE_ENTER,
        BackSpace = __android.android.AKEYCODE_DEL,
        ///`
        SwungDash = __android.android.AKEYCODE_GRAVE,
        Minus = __android.android.AKEYCODE_MINUS,
        Equal = __android.android.AKEYCODE_EQUALS,
        ///[
        LSquareBracket = __android.android.AKEYCODE_LEFT_BRACKET,
        ///]
        RSquareBracket = __android.android.AKEYCODE_RIGHT_BRACKET,
        ///\
        BackSlash = __android.android.AKEYCODE_BACKSLASH,
        ///;
        Semicolon = __android.android.AKEYCODE_SEMICOLON,
        ///'
        Apostrophe = __android.android.AKEYCODE_APOSTROPHE,
        /// /
        Slash = __android.android.AKEYCODE_SLASH,
        ///@
        At = __android.android.AKEYCODE_AT,
        Num = __android.android.AKEYCODE_NUM,
        HeadsetHook = __android.android.AKEYCODE_HEADSETHOOK,
        Focus = __android.android.AKEYCODE_FOCUS,
        Plus = __android.android.AKEYCODE_PLUS,
        Menu = __android.android.AKEYCODE_MENU,
        Notification = __android.android.AKEYCODE_NOTIFICATION,
        Search = __android.android.AKEYCODE_SEARCH,

        Play = __android.android.AKEYCODE_MEDIA_PLAY,
        Pause = __android.android.AKEYCODE_MEDIA_PAUSE,
        PlayPause = __android.android.AKEYCODE_MEDIA_PLAY_PAUSE,
        Stop = __android.android.AKEYCODE_MEDIA_STOP,
        Next = __android.android.AKEYCODE_MEDIA_NEXT,
        Prev = __android.android.AKEYCODE_MEDIA_PREVIOUS,
        Rewind = __android.android.AKEYCODE_MEDIA_REWIND,
        FastForward = __android.android.AKEYCODE_MEDIA_FAST_FORWARD,
        MediaClose = __android.android.AKEYCODE_MEDIA_CLOSE,
        MediaEject = __android.android.AKEYCODE_MEDIA_EJECT,
        Record = __android.android.AKEYCODE_MEDIA_RECORD,
        AudioTrack = __android.android.AKEYCODE_MEDIA_AUDIO_TRACK,
        MediaTopMenu = __android.android.AKEYCODE_MEDIA_TOP_MENU,
        SkipForward = __android.android.AKEYCODE_MEDIA_SKIP_FORWARD,
        SkipBackward = __android.android.AKEYCODE_MEDIA_SKIP_BACKWARD,
        StepForward = __android.android.AKEYCODE_MEDIA_STEP_FORWARD,
        StepBackward = __android.android.AKEYCODE_MEDIA_STEP_BACKWARD,

        Mute = __android.android.AKEYCODE_MUTE,
        PageUp = __android.android.AKEYCODE_PAGE_UP,
        PageDown = __android.android.AKEYCODE_PAGE_DOWN,
        PictureSymbols = __android.android.AKEYCODE_PICTSYMBOLS,
        SwitchCharset = __android.android.AKEYCODE_SWITCH_CHARSET,

        ButtonA = __android.android.AKEYCODE_BUTTON_A,
        ButtonB = __android.android.AKEYCODE_BUTTON_B,
        ButtonC = __android.android.AKEYCODE_BUTTON_C,
        ButtonX = __android.android.AKEYCODE_BUTTON_X,
        ButtonY = __android.android.AKEYCODE_BUTTON_Y,
        ButtonZ = __android.android.AKEYCODE_BUTTON_Z,
        ButtonL1 = __android.android.AKEYCODE_BUTTON_L1,
        ButtonR1 = __android.android.AKEYCODE_BUTTON_R1,
        ButtonL2 = __android.android.AKEYCODE_BUTTON_L2,
        ButtonR2 = __android.android.AKEYCODE_BUTTON_R2,
        ButtonLT = __android.android.AKEYCODE_BUTTON_THUMBL,
        ButtonRT = __android.android.AKEYCODE_BUTTON_THUMBR,
        ButtonStart = __android.android.AKEYCODE_BUTTON_START,
        ButtonSelect = __android.android.AKEYCODE_BUTTON_SELECT,
        ButtonMode = __android.android.AKEYCODE_BUTTON_MODE,

        Esc = __android.android.AKEYCODE_ESCAPE,
        ForwardDel = __android.android.AKEYCODE_FORWARD_DEL,
        LCtrl = __android.android.AKEYCODE_CTRL_LEFT,
        RCtrl = __android.android.AKEYCODE_CTRL_RIGHT,
        CapsLock = __android.android.AKEYCODE_CAPS_LOCK,
        ScrollLock = __android.android.AKEYCODE_SCROLL_LOCK,
        MetaLeft = __android.android.AKEYCODE_META_LEFT,
        MetaRight = __android.android.AKEYCODE_META_RIGHT,
        Func = __android.android.AKEYCODE_FUNCTION,
        SysReq = __android.android.AKEYCODE_SYSRQ,
        Break = __android.android.AKEYCODE_BREAK,
        MoveHome = __android.android.AKEYCODE_MOVE_HOME,
        MoveEnd = __android.android.AKEYCODE_MOVE_END,
        Insert = __android.android.AKEYCODE_INSERT,
        Foward = __android.android.AKEYCODE_FORWARD,
        F1 = __android.android.AKEYCODE_F1,
        F2 = __android.android.AKEYCODE_F2,
        F3 = __android.android.AKEYCODE_F3,
        F4 = __android.android.AKEYCODE_F4,
        F5 = __android.android.AKEYCODE_F5,
        F6 = __android.android.AKEYCODE_F6,
        F7 = __android.android.AKEYCODE_F7,
        F8 = __android.android.AKEYCODE_F8,
        F9 = __android.android.AKEYCODE_F9,
        F10 = __android.android.AKEYCODE_F10,
        F11 = __android.android.AKEYCODE_F11,
        F12 = __android.android.AKEYCODE_F12,
        NumLock = __android.android.AKEYCODE_NUM_LOCK,
        Numpad0 = __android.android.AKEYCODE_NUMPAD_0,
        Numpad1 = __android.android.AKEYCODE_NUMPAD_1,
        Numpad2 = __android.android.AKEYCODE_NUMPAD_2,
        Numpad3 = __android.android.AKEYCODE_NUMPAD_3,
        Numpad4 = __android.android.AKEYCODE_NUMPAD_4,
        Numpad5 = __android.android.AKEYCODE_NUMPAD_5,
        Numpad6 = __android.android.AKEYCODE_NUMPAD_6,
        Numpad7 = __android.android.AKEYCODE_NUMPAD_7,
        Numpad8 = __android.android.AKEYCODE_NUMPAD_8,
        Numpad9 = __android.android.AKEYCODE_NUMPAD_9,
        NumpadDivide = __android.android.AKEYCODE_NUMPAD_DIVIDE,
        NumpadMultiply = __android.android.AKEYCODE_NUMPAD_MULTIPLY,
        NumpadSubtract = __android.android.AKEYCODE_NUMPAD_SUBTRACT,
        NumpadAdd = __android.android.AKEYCODE_NUMPAD_ADD,
        NumpadDot = __android.android.AKEYCODE_NUMPAD_DOT,
        NumpadComma = __android.android.AKEYCODE_NUMPAD_COMMA,
        NumpadEnter = __android.android.AKEYCODE_NUMPAD_ENTER,
        NumpadEqual = __android.android.AKEYCODE_NUMPAD_EQUALS,
        NumpadLParen = __android.android.AKEYCODE_NUMPAD_LEFT_PAREN,
        NumpadRParen = __android.android.AKEYCODE_NUMPAD_RIGHT_PAREN,
        VolumeMute = __android.android.AKEYCODE_VOLUME_MUTE,
        ChannelUp = __android.android.AKEYCODE_CHANNEL_UP,
        ChannelDown = __android.android.AKEYCODE_CHANNEL_DOWN,
        ZoomIn = __android.android.AKEYCODE_ZOOM_IN,
        ZoomOut = __android.android.AKEYCODE_ZOOM_OUT,
        TV = __android.android.AKEYCODE_TV,
        Window = __android.android.AKEYCODE_WINDOW,
        Guide = __android.android.AKEYCODE_GUIDE,
        DVR = __android.android.AKEYCODE_DVR,
        Bookmark = __android.android.AKEYCODE_BOOKMARK,
        Captions = __android.android.AKEYCODE_CAPTIONS,
        Settings = __android.android.AKEYCODE_SETTINGS,

        SetTopBoxPower = __android.android.AKEYCODE_STB_POWER,
        SetTopBoxInput = __android.android.AKEYCODE_STB_INPUT,
        AVRPower = __android.android.AKEYCODE_AVR_POWER,
        AVRInput = __android.android.AKEYCODE_AVR_INPUT,

        AppSwitch = __android.android.AKEYCODE_APP_SWITCH,
        Button1 = __android.android.AKEYCODE_BUTTON_1,
        Button2 = __android.android.AKEYCODE_BUTTON_2,
        Button3 = __android.android.AKEYCODE_BUTTON_3,
        Button4 = __android.android.AKEYCODE_BUTTON_4,
        Button5 = __android.android.AKEYCODE_BUTTON_5,
        Button6 = __android.android.AKEYCODE_BUTTON_6,
        Button7 = __android.android.AKEYCODE_BUTTON_7,
        Button8 = __android.android.AKEYCODE_BUTTON_8,
        Button9 = __android.android.AKEYCODE_BUTTON_9,
        Button10 = __android.android.AKEYCODE_BUTTON_10,
        Button11 = __android.android.AKEYCODE_BUTTON_11,
        Button12 = __android.android.AKEYCODE_BUTTON_12,
        Button13 = __android.android.AKEYCODE_BUTTON_13,
        Button14 = __android.android.AKEYCODE_BUTTON_14,
        Button15 = __android.android.AKEYCODE_BUTTON_15,
        Button16 = __android.android.AKEYCODE_BUTTON_16,
        LanguageSwitch = __android.android.AKEYCODE_LANGUAGE_SWITCH,
        MannerMode = __android.android.AKEYCODE_MANNER_MODE,
        Mode3D = __android.android.AKEYCODE_3D_MODE,
        Contacts = __android.android.AKEYCODE_CONTACTS,
        Calendar = __android.android.AKEYCODE_CALENDAR,
        Music = __android.android.AKEYCODE_MUSIC,
        Calc = __android.android.AKEYCODE_CALCULATOR,

        JapaneseZenkakuHankaku = __android.android.AKEYCODE_ZENKAKU_HANKAKU,
        JapaneseEisu = __android.android.AKEYCODE_EISU,
        JapaneseMuhenkan = __android.android.AKEYCODE_MUHENKAN,
        JapaneseHenkan = __android.android.AKEYCODE_HENKAN,
        JapaneseKatakanaHiragana = __android.android.AKEYCODE_KATAKANA_HIRAGANA,
        JapaneseYen = __android.android.AKEYCODE_YEN,
        JapaneseRo = __android.android.AKEYCODE_RO,
        JapaneseKana = __android.android.AKEYCODE_KANA,

        Assist = __android.android.AKEYCODE_ASSIST,
        VoiceAssist = __android.android.AKEYCODE_VOICE_ASSIST,

        BrightnessDown = __android.android.AKEYCODE_BRIGHTNESS_DOWN,
        BrightnessUp = __android.android.AKEYCODE_BRIGHTNESS_UP,
        Sleep = __android.android.AKEYCODE_SLEEP,
        WakeUp = __android.android.AKEYCODE_WAKEUP,
        Pairing = __android.android.AKEYCODE_PAIRING,

        Eleven = __android.android.AKEYCODE_11,
        Twelve = __android.android.AKEYCODE_12,

        LastChannel = __android.android.AKEYCODE_LAST_CHANNEL,

        TVPower = __android.android.AKEYCODE_TV_POWER,
        TVInput = __android.android.AKEYCODE_TV_INPUT,
        TVRed = __android.android.AKEYCODE_PROG_RED,
        TVGreen = __android.android.AKEYCODE_PROG_GREEN,
        TVYellow = __android.android.AKEYCODE_PROG_YELLOW,
        TVBlue = __android.android.AKEYCODE_PROG_BLUE,
        TVDataService = __android.android.AKEYCODE_TV_DATA_SERVICE,
        ToggleTVRadioService = __android.android.AKEYCODE_TV_RADIO_SERVICE,
        TVTeletext = __android.android.AKEYCODE_TV_TELETEXT,
        TVNumberEntry = __android.android.AKEYCODE_TV_NUMBER_ENTRY,
        TVAnologTerrestrial = __android.android.AKEYCODE_TV_TERRESTRIAL_ANALOG,
        TVDigitalTerrestrial = __android.android.AKEYCODE_TV_TERRESTRIAL_DIGITAL,
        TVSatellite = __android.android.AKEYCODE_TV_SATELLITE,
        TVSatelliteBS = __android.android.AKEYCODE_TV_SATELLITE_BS,
        TVSatelliteCS = __android.android.AKEYCODE_TV_SATELLITE_CS,
        TVToggleSatelliteBSOrCS = __android.android.AKEYCODE_TV_SATELLITE_SERVICE,
        TVNetwork = __android.android.AKEYCODE_TV_NETWORK,
        TVToggleAntennaOrCable = __android.android.AKEYCODE_TV_ANTENNA_CABLE,
        TVHDMI1 = __android.android.AKEYCODE_TV_INPUT_HDMI_1,
        TVHDMI2 = __android.android.AKEYCODE_TV_INPUT_HDMI_2,
        TVHDMI3 = __android.android.AKEYCODE_TV_INPUT_HDMI_3,
        TVHDMI4 = __android.android.AKEYCODE_TV_INPUT_HDMI_4,
        TVComposite1 = __android.android.AKEYCODE_TV_INPUT_COMPOSITE_1,
        TVComposite2 = __android.android.AKEYCODE_TV_INPUT_COMPOSITE_2,
        TVComponent1 = __android.android.AKEYCODE_TV_INPUT_COMPONENT_1,
        TVComponent2 = __android.android.AKEYCODE_TV_INPUT_COMPONENT_2,
        TVVGA = __android.android.AKEYCODE_TV_INPUT_VGA_1,
        TVToggleAudioDescription = __android.android.AKEYCODE_TV_AUDIO_DESCRIPTION,
        TVAudioDescriptionMixUp = __android.android.AKEYCODE_TV_AUDIO_DESCRIPTION_MIX_UP,
        TVAudioDescriptionMixDown = __android.android.AKEYCODE_TV_AUDIO_DESCRIPTION_MIX_DOWN,
        TVZoomMode = __android.android.AKEYCODE_TV_ZOOM_MODE,
        TVContentsMenu = __android.android.AKEYCODE_TV_CONTENTS_MENU,
        TVMediaContextMenu = __android.android.AKEYCODE_TV_MEDIA_CONTEXT_MENU,
        TVTimerProgramming = __android.android.AKEYCODE_TV_TIMER_PROGRAMMING,

        Help = __android.android.AKEYCODE_HELP,

        NavigatePrev = __android.android.AKEYCODE_NAVIGATE_PREVIOUS,
        NavigateNext = __android.android.AKEYCODE_NAVIGATE_NEXT,
        NavigateIn = __android.android.AKEYCODE_NAVIGATE_IN,
        NavigateOut = __android.android.AKEYCODE_NAVIGATE_OUT,

        StemPrimary = __android.android.AKEYCODE_STEM_PRIMARY,
        Stem1 = __android.android.AKEYCODE_STEM_1,
        Stem2 = __android.android.AKEYCODE_STEM_2,
        Stem3 = __android.android.AKEYCODE_STEM_3,

        SoftSleep = __android.android.AKEYCODE_SOFT_SLEEP,

        Cut = __android.android.AKEYCODE_CUT,
        Copy = __android.android.AKEYCODE_COPY,
        Paste = __android.android.AKEYCODE_PASTE,

        FingerprintNavigationUp = __android.android.AKEYCODE_SYSTEM_NAVIGATION_UP,
        FingerprintNavigationDown = __android.android.AKEYCODE_SYSTEM_NAVIGATION_DOWN,
        FingerprintNavigationLeft = __android.android.AKEYCODE_SYSTEM_NAVIGATION_LEFT,
        FingerprintNavigationRight = __android.android.AKEYCODE_SYSTEM_NAVIGATION_RIGHT,

        AllApps = __android.android.AKEYCODE_ALL_APPS,
        Refresh = __android.android.AKEYCODE_REFRESH,

        ThumbsUp = __android.android.AKEYCODE_THUMBS_UP,
        ThumbsDown = __android.android.AKEYCODE_THUMBS_DOWN,

        ProfileSwitch = __android.android.AKEYCODE_PROFILE_SWITCH,
        _,
    }
else
    @compileError("not support platform");

pub inline fn set_Lmouse_down_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Lmouse_down_func), &__system.Lmouse_down_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_Rmouse_down_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Rmouse_down_func), &__system.Rmouse_down_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_Mmouse_down_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Mmouse_down_func), &__system.Mmouse_down_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_Lmouse_up_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Lmouse_up_func), &__system.Lmouse_up_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_Rmouse_up_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Rmouse_up_func), &__system.Rmouse_up_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_Mmouse_up_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.Mmouse_up_func), &__system.Mmouse_up_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_key_down_func(_func: *const fn (key) void) void {
    @atomicStore(@TypeOf(__system.key_down_func), &__system.key_down_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_key_up_func(_func: *const fn (key) void) void {
    @atomicStore(@TypeOf(__system.key_up_func), &__system.key_up_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_mouse_move_func(_func: *const fn (pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.mouse_move_func), &__system.mouse_move_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_touch_down_func(_func: *const fn (touch_idx: u32, pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.touch_down_func), &__system.touch_down_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_touch_up_func(_func: *const fn (touch_idx: u32, pos: math.point) void) void {
    @atomicStore(@TypeOf(__system.touch_up_func), &__system.touch_up_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_mouse_hover_func(_func: *const fn () void) void {
    @atomicStore(@TypeOf(__system.mouse_hover_func), &__system.mouse_hover_func, _func, std.builtin.AtomicOrder.monotonic);
}
pub inline fn set_mouse_out_func(_func: *const fn () void) void {
    @atomicStore(@TypeOf(__system.mouse_leave_func), &__system.mouse_leave_func, _func, std.builtin.AtomicOrder.monotonic);
}

pub inline fn Lmouse_down() bool {
    return __system.Lmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn Mmouse_down() bool {
    return __system.Mmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn Rmouse_down() bool {
    return __system.Rmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn Lmouse_up() bool {
    return !__system.Lmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn Mmouse_up() bool {
    return !__system.Mmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn Rmouse_up() bool {
    return !__system.Rmouse_click.load(std.builtin.AtomicOrder.monotonic);
}
///false -> up, true -> down
pub inline fn key_down_or_up(_key: key) bool {
    if (@intFromEnum(_key) >= __system.KEY_SIZE) {
        system.print("WARN key_down_or_up out of range __system.keys[{d}] value : {d}\n", .{ __system.KEY_SIZE, @intFromEnum(_key) });
        return false;
    }
    return __system.keys[@intFromEnum(_key)].load(std.builtin.AtomicOrder.monotonic);
}
pub inline fn get_cursor_pos() math.point {
    const p: math.point = .{
        @atomicLoad(f32, &__system.cursor_pos[0], std.builtin.AtomicOrder.monotonic),
        @atomicLoad(f32, &__system.cursor_pos[1], std.builtin.AtomicOrder.monotonic),
    };
    return p;
}
pub inline fn get_mouse_scroll_dt() i32 {
    return __system.mouse_scroll_dt.load(std.builtin.AtomicOrder.monotonic);
}
pub fn convert_set_mouse_pos(mouse_pos: math.point) math.point {
    const mx: f32 = mouse_pos[0];
    const my: f32 = mouse_pos[1];
    const w = @as(f32, @floatFromInt(window.window_width())) / 2.0;
    const h = @as(f32, @floatFromInt(window.window_height())) / 2.0;
    const mm = math.point{ mx - w, -my + h };
    @atomicStore(f32, &__system.cursor_pos[0], mm[0], std.builtin.AtomicOrder.monotonic);
    @atomicStore(f32, &__system.cursor_pos[1], mm[1], std.builtin.AtomicOrder.monotonic);
    return mm;
}
pub fn convert_mouse_pos(mouse_pos: math.point) math.point {
    const mx: f32 = mouse_pos[0];
    const my: f32 = mouse_pos[1];
    const w = @as(f32, @floatFromInt(window.window_width())) / 2.0;
    const h = @as(f32, @floatFromInt(window.window_height())) / 2.0;
    const mm = math.point{ mx - w, -my + h };
    return mm;
}
