"""Genera icona app + immagini splash da Icons.graphic_eq (Material Icons),
ricostruendo geometricamente le 5 barre dell'equalizzatore dal path SVG
originale (viewBox 24x24): rettangoli a x=3,7,11,15,19 (larghezza 2) con
altezze 4,12,20,12,4, centrati verticalmente.

Uso (da rifare dopo aver cambiato colori/geometria qui sotto):
    pip install pillow
    python3 tool/gen_icon.py
    dart run flutter_launcher_icons
    dart run flutter_native_splash:create
"""
from PIL import Image, ImageDraw

TEAL = (0, 121, 107, 255)       # teal 700, background icona/launcher
TEAL_DARK = (0, 30, 27, 255)    # sfondo splash dark mode
WHITE = (255, 255, 255, 255)
TRANSPARENT = (0, 0, 0, 0)

# geometria barre in coordinate viewBox 0-24
BARS = [
    (3, 4),   # (x_start, height)
    (7, 12),
    (11, 20),
    (15, 12),
    (19, 4),
]
BAR_WIDTH = 2
VIEWBOX = 24


def draw_bars(size, color, scale=1.0, y_offset=0):
    """Ritorna un'immagine RGBA size x size con le barre disegnate, scalate
    di `scale` rispetto al canvas pieno e centrate (per il safe-zone delle
    adaptive icon / splash Android 12)."""
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw = ImageDraw.Draw(img)

    unit = (size * scale) / VIEWBOX
    total_w = 18 * unit  # da x=3 a x=21 nel viewBox originale (larghezza occupata: 21-3)
    margin_x = (size - total_w) / 2
    center_y = size / 2 + y_offset

    for x_start, height in BARS:
        x0 = margin_x + (x_start - 3) * unit
        x1 = x0 + BAR_WIDTH * unit
        h = height * unit
        y0 = center_y - h / 2
        y1 = center_y + h / 2
        radius = BAR_WIDTH * unit / 2
        draw.rounded_rectangle([x0, y0, x1, y1], radius=radius, fill=color)

    return img


def save_icon(path, size=1024, bg=TEAL, fg=WHITE, scale=0.62):
    img = Image.new("RGBA", (size, size), bg)
    bars = draw_bars(size, fg, scale=scale)
    img.alpha_composite(bars)
    img.save(path)
    print("saved", path)


def save_foreground(path, size=1024, fg=WHITE, scale=0.42):
    # scale ridotta per stare nella safe-zone delle adaptive icon Android
    # (contenuto utile entro ~66% del canvas, centrato).
    bars = draw_bars(size, fg, scale=scale)
    bars.save(path)
    print("saved", path)


def save_splash_icon(path, size=1152, fg=WHITE, scale=0.34):
    # Android 12 splash: icona entro un cerchio, safe-zone ~2/3 del canvas.
    bars = draw_bars(size, fg, scale=scale)
    bars.save(path)
    print("saved", path)


if __name__ == "__main__":
    import os

    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    base = os.path.join(repo_root, "assets")
    os.makedirs(f"{base}/icon", exist_ok=True)
    os.makedirs(f"{base}/splash", exist_ok=True)

    # Icona app "piena" (bg teal + barre bianche): usata come icon_image
    # generale (iOS, web, e fallback Android legacy).
    save_icon(f"{base}/icon/icon.png")

    # Foreground trasparente per adaptive icon Android (bg separato a tinta
    # unita definito nella config flutter_launcher_icons).
    save_foreground(f"{base}/icon/icon_foreground.png")

    # Icona per splash screen, trasparente, bianca (va su sfondo teal sia
    # in light che dark: dark mode friendly per design).
    save_splash_icon(f"{base}/splash/splash_icon.png")
