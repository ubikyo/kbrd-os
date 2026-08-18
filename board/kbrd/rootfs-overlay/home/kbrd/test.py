#!/usr/bin/env python3

import ctypes
import os
import signal
import struct


# ============================================================
# Configuration KBRD
# ============================================================

os.environ["SDL_VIDEODRIVER"] = "KMSDRM"
os.environ["SDL_KMSDRM_DEVICE_INDEX"] = "1"

LOGICAL_W = 1280
LOGICAL_H = 800

ROTATION = -90.0

BOX = 100
MARGIN = 20

FONT_PATH = b"/usr/share/fonts/Jaro.ttf"
FONT_SIZE = 48

IMAGE_PATH = b"/usr/share/media/image1.png"

TOUCH_DEVICE = "/dev/input/event4"


# ============================================================
# Bibliothèques
# ============================================================

SDL = ctypes.CDLL("libSDL2.so")
TTF = ctypes.CDLL("libSDL2_ttf.so")
IMG = ctypes.CDLL("libSDL2_image.so")


# ============================================================
# Constantes SDL
# ============================================================

SDL_INIT_VIDEO = 0x00000020

SDL_WINDOW_FULLSCREEN = 0x00000001
SDL_WINDOW_SHOWN = 0x00000004

SDL_RENDERER_ACCELERATED = 0x00000002
SDL_RENDERER_PRESENTVSYNC = 0x00000004

SDL_TEXTUREACCESS_TARGET = 2
SDL_PIXELFORMAT_ARGB8888 = 372645892

SDL_BLENDMODE_BLEND = 1

SDL_FLIP_NONE = 0
SDL_QUIT = 0x100

IMG_INIT_PNG = 0x00000002


# ============================================================
# Linux input
# ============================================================

EV_SYN = 0x00
EV_KEY = 0x01
EV_ABS = 0x03

SYN_REPORT = 0x00

BTN_TOUCH = 0x14A

ABS_X = 0x00
ABS_Y = 0x01

EVENT_FORMAT = "llHHi"
EVENT_SIZE = struct.calcsize(EVENT_FORMAT)


# ============================================================
# Structures SDL
# ============================================================

class SDL_Rect(ctypes.Structure):
    _fields_ = [
        ("x", ctypes.c_int),
        ("y", ctypes.c_int),
        ("w", ctypes.c_int),
        ("h", ctypes.c_int),
    ]


class SDL_Point(ctypes.Structure):
    _fields_ = [
        ("x", ctypes.c_int),
        ("y", ctypes.c_int),
    ]


class SDL_Color(ctypes.Structure):
    _fields_ = [
        ("r", ctypes.c_uint8),
        ("g", ctypes.c_uint8),
        ("b", ctypes.c_uint8),
        ("a", ctypes.c_uint8),
    ]


class SDL_DisplayMode(ctypes.Structure):
    _fields_ = [
        ("format", ctypes.c_uint32),
        ("w", ctypes.c_int),
        ("h", ctypes.c_int),
        ("refresh_rate", ctypes.c_int),
        ("driverdata", ctypes.c_void_p),
    ]


class SDL_RendererInfo(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char_p),
        ("flags", ctypes.c_uint32),
        ("num_texture_formats", ctypes.c_uint32),
        ("texture_formats", ctypes.c_uint32 * 16),
        ("max_texture_width", ctypes.c_int),
        ("max_texture_height", ctypes.c_int),
    ]


class SDL_Surface(ctypes.Structure):
    _fields_ = [
        ("flags", ctypes.c_uint32),
        ("format", ctypes.c_void_p),
        ("w", ctypes.c_int),
        ("h", ctypes.c_int),
    ]


# ============================================================
# Prototypes SDL
# ============================================================

SDL.SDL_Init.argtypes = [ctypes.c_uint32]
SDL.SDL_Init.restype = ctypes.c_int

SDL.SDL_Quit.argtypes = []
SDL.SDL_Quit.restype = None

SDL.SDL_GetError.argtypes = []
SDL.SDL_GetError.restype = ctypes.c_char_p

SDL.SDL_GetCurrentVideoDriver.restype = ctypes.c_char_p

SDL.SDL_GetCurrentDisplayMode.argtypes = [
    ctypes.c_int,
    ctypes.POINTER(SDL_DisplayMode),
]
SDL.SDL_GetCurrentDisplayMode.restype = ctypes.c_int

SDL.SDL_CreateWindow.argtypes = [
    ctypes.c_char_p,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_uint32,
]
SDL.SDL_CreateWindow.restype = ctypes.c_void_p

SDL.SDL_DestroyWindow.argtypes = [ctypes.c_void_p]

SDL.SDL_CreateRenderer.argtypes = [
    ctypes.c_void_p,
    ctypes.c_int,
    ctypes.c_uint32,
]
SDL.SDL_CreateRenderer.restype = ctypes.c_void_p

SDL.SDL_DestroyRenderer.argtypes = [ctypes.c_void_p]

SDL.SDL_GetRendererInfo.argtypes = [
    ctypes.c_void_p,
    ctypes.POINTER(SDL_RendererInfo),
]
SDL.SDL_GetRendererInfo.restype = ctypes.c_int

SDL.SDL_CreateTexture.argtypes = [
    ctypes.c_void_p,
    ctypes.c_uint32,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_int,
]
SDL.SDL_CreateTexture.restype = ctypes.c_void_p

SDL.SDL_CreateTextureFromSurface.argtypes = [
    ctypes.c_void_p,
    ctypes.POINTER(SDL_Surface),
]
SDL.SDL_CreateTextureFromSurface.restype = ctypes.c_void_p

SDL.SDL_DestroyTexture.argtypes = [ctypes.c_void_p]

SDL.SDL_FreeSurface.argtypes = [
    ctypes.POINTER(SDL_Surface),
]

SDL.SDL_SetRenderTarget.argtypes = [
    ctypes.c_void_p,
    ctypes.c_void_p,
]
SDL.SDL_SetRenderTarget.restype = ctypes.c_int

SDL.SDL_SetRenderDrawColor.argtypes = [
    ctypes.c_void_p,
    ctypes.c_uint8,
    ctypes.c_uint8,
    ctypes.c_uint8,
    ctypes.c_uint8,
]
SDL.SDL_SetRenderDrawColor.restype = ctypes.c_int

SDL.SDL_SetRenderDrawBlendMode.argtypes = [
    ctypes.c_void_p,
    ctypes.c_int,
]
SDL.SDL_SetRenderDrawBlendMode.restype = ctypes.c_int

SDL.SDL_RenderClear.argtypes = [ctypes.c_void_p]
SDL.SDL_RenderClear.restype = ctypes.c_int

SDL.SDL_RenderFillRect.argtypes = [
    ctypes.c_void_p,
    ctypes.POINTER(SDL_Rect),
]
SDL.SDL_RenderFillRect.restype = ctypes.c_int

SDL.SDL_RenderCopy.argtypes = [
    ctypes.c_void_p,
    ctypes.c_void_p,
    ctypes.POINTER(SDL_Rect),
    ctypes.POINTER(SDL_Rect),
]
SDL.SDL_RenderCopy.restype = ctypes.c_int

SDL.SDL_RenderCopyEx.argtypes = [
    ctypes.c_void_p,
    ctypes.c_void_p,
    ctypes.POINTER(SDL_Rect),
    ctypes.POINTER(SDL_Rect),
    ctypes.c_double,
    ctypes.POINTER(SDL_Point),
    ctypes.c_int,
]
SDL.SDL_RenderCopyEx.restype = ctypes.c_int

SDL.SDL_RenderPresent.argtypes = [ctypes.c_void_p]

SDL.SDL_ShowCursor.argtypes = [ctypes.c_int]

SDL.SDL_PollEvent.argtypes = [ctypes.c_void_p]
SDL.SDL_PollEvent.restype = ctypes.c_int


# ============================================================
# SDL_ttf
# ============================================================

TTF.TTF_Init.argtypes = []
TTF.TTF_Init.restype = ctypes.c_int

TTF.TTF_Quit.argtypes = []

TTF.TTF_OpenFont.argtypes = [
    ctypes.c_char_p,
    ctypes.c_int,
]
TTF.TTF_OpenFont.restype = ctypes.c_void_p

TTF.TTF_CloseFont.argtypes = [ctypes.c_void_p]

TTF.TTF_RenderUTF8_Blended.argtypes = [
    ctypes.c_void_p,
    ctypes.c_char_p,
    SDL_Color,
]
TTF.TTF_RenderUTF8_Blended.restype = ctypes.POINTER(SDL_Surface)


# ============================================================
# SDL_image
# ============================================================

IMG.IMG_Init.argtypes = [ctypes.c_int]
IMG.IMG_Init.restype = ctypes.c_int

IMG.IMG_Quit.argtypes = []

IMG.IMG_Load.argtypes = [ctypes.c_char_p]
IMG.IMG_Load.restype = ctypes.POINTER(SDL_Surface)

IMG.IMG_GetError.argtypes = []
IMG.IMG_GetError.restype = ctypes.c_char_p


# ============================================================
# Helpers
# ============================================================

def sdl_error():
    e = SDL.SDL_GetError()
    return e.decode(errors="replace") if e else "unknown SDL error"


def img_error():
    e = IMG.IMG_GetError()
    return e.decode(errors="replace") if e else "unknown SDL_image error"


def check(result, name):
    if result != 0:
        raise RuntimeError(f"{name}: {sdl_error()}")


def fill(x, y, w, h, r, g, b, a=255):

    check(
        SDL.SDL_SetRenderDrawColor(
            renderer,
            r, g, b, a,
        ),
        "SDL_SetRenderDrawColor",
    )

    rect = SDL_Rect(x, y, w, h)

    check(
        SDL.SDL_RenderFillRect(
            renderer,
            ctypes.byref(rect),
        ),
        "SDL_RenderFillRect",
    )


# ============================================================
# Initialisation
# ============================================================

print("=== KBRD image + touch test ===")
print()

check(
    SDL.SDL_Init(SDL_INIT_VIDEO),
    "SDL_Init",
)

if TTF.TTF_Init() != 0:
    raise RuntimeError("TTF_Init failed")

if (IMG.IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG) == 0:
    raise RuntimeError(
        "IMG_Init PNG: " + img_error()
    )


# ============================================================
# Écran
# ============================================================

mode = SDL_DisplayMode()

check(
    SDL.SDL_GetCurrentDisplayMode(
        0,
        ctypes.byref(mode),
    ),
    "SDL_GetCurrentDisplayMode",
)

driver = SDL.SDL_GetCurrentVideoDriver()

print(
    "SDL driver :",
    driver.decode() if driver else "?",
)

print(
    f"Physical   : {mode.w}x{mode.h} "
    f"@ {mode.refresh_rate} Hz"
)

print(
    f"Logical    : {LOGICAL_W}x{LOGICAL_H}"
)


# ============================================================
# Fenêtre
# ============================================================

SDL.SDL_ShowCursor(0)

window = SDL.SDL_CreateWindow(
    b"KBRD",
    0,
    0,
    mode.w,
    mode.h,
    SDL_WINDOW_FULLSCREEN |
    SDL_WINDOW_SHOWN,
)

if not window:
    raise RuntimeError(
        "SDL_CreateWindow: " + sdl_error()
    )


# ============================================================
# Renderer
# ============================================================

renderer = SDL.SDL_CreateRenderer(
    window,
    -1,
    SDL_RENDERER_ACCELERATED |
    SDL_RENDERER_PRESENTVSYNC,
)

if not renderer:
    raise RuntimeError(
        "SDL_CreateRenderer: " + sdl_error()
    )

info = SDL_RendererInfo()

check(
    SDL.SDL_GetRendererInfo(
        renderer,
        ctypes.byref(info),
    ),
    "SDL_GetRendererInfo",
)

print(
    "Renderer   :",
    info.name.decode() if info.name else "?",
)

print(
    "Max texture:",
    f"{info.max_texture_width}x"
    f"{info.max_texture_height}",
)


# ============================================================
# Blending
# ============================================================

check(
    SDL.SDL_SetRenderDrawBlendMode(
        renderer,
        SDL_BLENDMODE_BLEND,
    ),
    "SDL_SetRenderDrawBlendMode",
)


# ============================================================
# Texture logique
# ============================================================

logical = SDL.SDL_CreateTexture(
    renderer,
    SDL_PIXELFORMAT_ARGB8888,
    SDL_TEXTUREACCESS_TARGET,
    LOGICAL_W,
    LOGICAL_H,
)

if not logical:
    raise RuntimeError(
        "SDL_CreateTexture: " + sdl_error()
    )


# ============================================================
# Police
# ============================================================

font = TTF.TTF_OpenFont(
    FONT_PATH,
    FONT_SIZE,
)

if not font:
    raise RuntimeError(
        "Unable to open /usr/share/fonts/Jaro.ttf"
    )


# ============================================================
# Chargement image
# ============================================================

image_surface = IMG.IMG_Load(
    IMAGE_PATH,
)

if not image_surface:
    raise RuntimeError(
        "Unable to load "
        + IMAGE_PATH.decode()
        + ": "
        + img_error()
    )

IMAGE_W = image_surface.contents.w
IMAGE_H = image_surface.contents.h

print(
    f"Image      : {IMAGE_PATH.decode()}"
)

print(
    f"Image size : {IMAGE_W}x{IMAGE_H}"
)


image_texture = SDL.SDL_CreateTextureFromSurface(
    renderer,
    image_surface,
)

SDL.SDL_FreeSurface(
    image_surface,
)

if not image_texture:
    raise RuntimeError(
        "SDL_CreateTextureFromSurface(image): "
        + sdl_error()
    )


# ============================================================
# Textes
# ============================================================

def create_text_texture(text):

    color = SDL_Color(
        0, 0, 0, 255,
    )

    surface = TTF.TTF_RenderUTF8_Blended(
        font,
        text.encode("utf-8"),
        color,
    )

    if not surface:
        raise RuntimeError(
            f"Unable to render text: {text}"
        )

    width = surface.contents.w
    height = surface.contents.h

    texture = SDL.SDL_CreateTextureFromSurface(
        renderer,
        surface,
    )

    SDL.SDL_FreeSurface(surface)

    if not texture:
        raise RuntimeError(
            f"Unable to create text texture: {text}"
        )

    return texture, width, height


text_TL = create_text_texture("TL")
text_TR = create_text_texture("TR")
text_BL = create_text_texture("BL")
text_BR = create_text_texture("BR")


# ============================================================
# Boutons
# ============================================================

buttons = {

    "TL": {
        "x": MARGIN,
        "y": MARGIN,
        "pressed": False,
        "text": text_TL,
    },

    "TR": {
        "x": LOGICAL_W - BOX - MARGIN,
        "y": MARGIN,
        "pressed": False,
        "text": text_TR,
    },

    "BL": {
        "x": MARGIN,
        "y": LOGICAL_H - BOX - MARGIN,
        "pressed": False,
        "text": text_BL,
    },

    "BR": {
        "x": LOGICAL_W - BOX - MARGIN,
        "y": LOGICAL_H - BOX - MARGIN,
        "pressed": False,
        "text": text_BR,
    },
}


# ============================================================
# Texte centré
# ============================================================

def draw_text_centered(text_data, x, y, w, h):

    texture, text_w, text_h = text_data

    dst = SDL_Rect(
        x + (w - text_w) // 2,
        y + (h - text_h) // 2,
        text_w,
        text_h,
    )

    check(
        SDL.SDL_RenderCopy(
            renderer,
            texture,
            None,
            ctypes.byref(dst),
        ),
        "SDL_RenderCopy(text)",
    )


# ============================================================
# Affichage de l'image
#
# Mode COVER :
#
# - conserve le ratio ;
# - remplit tout l'écran logique 1280x800 ;
# - recadre ce qui dépasse.
#
# Le scaling est effectué par le GPU.
# ============================================================

def draw_background():

    image_ratio = IMAGE_W / IMAGE_H
    screen_ratio = LOGICAL_W / LOGICAL_H

    if image_ratio > screen_ratio:

        # Image plus large que l'écran.
        # Hauteur = 800, largeur > 1280.

        dst_h = LOGICAL_H
        dst_w = int(
            IMAGE_W * LOGICAL_H / IMAGE_H
        )

    else:

        # Image plus haute que l'écran.
        # Largeur = 1280, hauteur > 800.

        dst_w = LOGICAL_W
        dst_h = int(
            IMAGE_H * LOGICAL_W / IMAGE_W
        )

    dst_x = (
        LOGICAL_W - dst_w
    ) // 2

    dst_y = (
        LOGICAL_H - dst_h
    ) // 2

    dst = SDL_Rect(
        dst_x,
        dst_y,
        dst_w,
        dst_h,
    )

    check(
        SDL.SDL_RenderCopy(
            renderer,
            image_texture,
            None,
            ctypes.byref(dst),
        ),
        "SDL_RenderCopy(background)",
    )


# ============================================================
# Goodix
# ============================================================

touch_fd = os.open(
    TOUCH_DEVICE,
    os.O_RDONLY |
    os.O_NONBLOCK,
)

touch_x = 0
touch_y = 0
touch_down = False


# ============================================================
# Transformation tactile VALIDÉE
#
# Goodix physique :
#     800x1280
#
# Interface :
#     1280x800
#
# Cette transformation correspond aux essais :
#
# TL -> TL
# TR -> TR
# BL -> BL
# BR -> BR
# ============================================================

def physical_to_logical(x, y):

    logical_x = (
        LOGICAL_W - 1 - y
    )

    logical_y = x

    logical_x = max(
        0,
        min(
            LOGICAL_W - 1,
            logical_x,
        ),
    )

    logical_y = max(
        0,
        min(
            LOGICAL_H - 1,
            logical_y,
        ),
    )

    return logical_x, logical_y


# ============================================================
# Boutons
# ============================================================

def update_buttons():

    if not touch_down:

        for button in buttons.values():
            button["pressed"] = False

        return

    logical_x, logical_y = physical_to_logical(
        touch_x,
        touch_y,
    )

    for button in buttons.values():

        button["pressed"] = (
            logical_x >= button["x"]
            and
            logical_x < button["x"] + BOX
            and
            logical_y >= button["y"]
            and
            logical_y < button["y"] + BOX
        )


# ============================================================
# Lecture Goodix
# ============================================================

def read_touch():

    global touch_x
    global touch_y
    global touch_down

    changed = False

    while True:

        try:

            data = os.read(
                touch_fd,
                EVENT_SIZE,
            )

        except BlockingIOError:
            break

        if len(data) != EVENT_SIZE:
            break

        (
            sec,
            usec,
            event_type,
            code,
            value,
        ) = struct.unpack(
            EVENT_FORMAT,
            data,
        )

        if (
            event_type == EV_ABS
            and
            code == ABS_X
        ):

            touch_x = value
            changed = True

        elif (
            event_type == EV_ABS
            and
            code == ABS_Y
        ):

            touch_y = value
            changed = True

        elif (
            event_type == EV_KEY
            and
            code == BTN_TOUCH
        ):

            touch_down = value != 0
            changed = True

        elif (
            event_type == EV_SYN
            and
            code == SYN_REPORT
        ):

            if changed:
                update_buttons()
                changed = False


# ============================================================
# Composition logique
# ============================================================

def draw_logical():

    check(
        SDL.SDL_SetRenderTarget(
            renderer,
            logical,
        ),
        "SDL_SetRenderTarget(logical)",
    )

    # --------------------------------------------------------
    # Fond noir
    # --------------------------------------------------------

    check(
        SDL.SDL_SetRenderDrawColor(
            renderer,
            0, 0, 0, 255,
        ),
        "SDL_SetRenderDrawColor",
    )

    check(
        SDL.SDL_RenderClear(renderer),
        "SDL_RenderClear",
    )

    # --------------------------------------------------------
    # Image
    # --------------------------------------------------------

    draw_background()

    # --------------------------------------------------------
    # Boutons par-dessus l'image
    # --------------------------------------------------------

    for button in buttons.values():

        x = button["x"]
        y = button["y"]

        if button["pressed"]:

            # Vert à 100 % pendant l'appui
            fill(
                x,
                y,
                BOX,
                BOX,
                0,
                255,
                0,
                255,
            )

        else:

            # Blanc à ~50 %
            fill(
                x,
                y,
                BOX,
                BOX,
                255,
                255,
                255,
                128,
            )

        draw_text_centered(
            button["text"],
            x,
            y,
            BOX,
            BOX,
        )


# ============================================================
# Présentation physique
# ============================================================

def draw():

    # Toute l'interface est construite normalement
    # dans le repère 1280x800.

    draw_logical()

    # Retour vers le framebuffer physique.

    check(
        SDL.SDL_SetRenderTarget(
            renderer,
            None,
        ),
        "SDL_SetRenderTarget(screen)",
    )

    check(
        SDL.SDL_SetRenderDrawColor(
            renderer,
            0, 0, 0, 255,
        ),
        "SDL_SetRenderDrawColor(screen)",
    )

    check(
        SDL.SDL_RenderClear(renderer),
        "SDL_RenderClear(screen)",
    )

    # Texture 1280x800 centrée avant rotation.

    dst = SDL_Rect(
        (mode.w - LOGICAL_W) // 2,
        (mode.h - LOGICAL_H) // 2,
        LOGICAL_W,
        LOGICAL_H,
    )

    # Une seule rotation GPU pour toute l'interface.

    check(
        SDL.SDL_RenderCopyEx(
            renderer,
            logical,
            None,
            ctypes.byref(dst),
            ROTATION,
            None,
            SDL_FLIP_NONE,
        ),
        "SDL_RenderCopyEx",
    )

    SDL.SDL_RenderPresent(
        renderer,
    )


# ============================================================
# Boucle
# ============================================================

running = True


def stop(sig, frame):

    global running
    running = False


signal.signal(
    signal.SIGINT,
    stop,
)

signal.signal(
    signal.SIGTERM,
    stop,
)

event = ctypes.create_string_buffer(128)


print()
print("Ready.")
print()
print("Image   :", IMAGE_PATH.decode())
print("Buttons : white 50% / green pressed")
print("Touch   :", TOUCH_DEVICE)
print("Rotation: -90 degrees GPU")
print()
print("Ctrl+C to exit.")
print()


while running:

    # Tactile

    read_touch()

    # SDL

    while SDL.SDL_PollEvent(event):

        event_type = ctypes.cast(
            event,
            ctypes.POINTER(ctypes.c_uint32),
        ).contents.value

        if event_type == SDL_QUIT:
            running = False

    # Affichage

    draw()


# ============================================================
# Cleanup
# ============================================================

print()
print("Stopping...")

os.close(touch_fd)

for button in buttons.values():

    SDL.SDL_DestroyTexture(
        button["text"][0]
    )

SDL.SDL_DestroyTexture(
    image_texture,
)

SDL.SDL_DestroyTexture(
    logical,
)

TTF.TTF_CloseFont(
    font,
)

SDL.SDL_DestroyRenderer(
    renderer,
)

SDL.SDL_DestroyWindow(
    window,
)

IMG.IMG_Quit()
TTF.TTF_Quit()
SDL.SDL_Quit()

print("Done.")