#!/usr/bin/env python3
"""AI Planet Remaster - icon generator.

Builds the Godot project icon from the original AI Planet logo
(Built/manual/planet_big.png, GPL-2.0 by the ai.planet authors).
Chroma-keys the uniform background (sampled from corners) to transparency,
pads to square and exports 512x512 PNG.
"""
import sys
from PIL import Image, ImageFilter

SRC = sys.argv[1]
DST = sys.argv[2]
SIZE = 512


def main() -> None:
    img = Image.open(SRC).convert("RGBA")
    w, h = img.size
    px = img.load()
    corners = [px[0, 0], px[w - 1, 0], px[0, h - 1], px[w - 1, h - 1]]
    bg = corners[0][:3]
    uniform = all(all(abs(c[i] - bg[i]) < 28 for i in range(3)) for c in corners)
    if uniform:
        lo = tuple(max(0, v - 26) for v in bg)
        hi = tuple(min(255, v + 26) for v in bg)
        data = []
        for r, g, b, a in img.getdata():
            if lo[0] <= r <= hi[0] and lo[1] <= g <= hi[1] and lo[2] <= b <= hi[2]:
                data.append((r, g, b, 0))
            else:
                data.append((r, g, b, 255))
        img.putdata(data)
        # soften the alpha edge a bit
        alpha = img.getchannel("A").filter(ImageFilter.GaussianBlur(1.2))
        img.putalpha(alpha)
    # pad to square
    side = max(img.size)
    sq = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    sq.paste(img, ((side - img.size[0]) // 2, (side - img.size[1]) // 2), img)
    sq = sq.resize((SIZE, SIZE), Image.LANCZOS)
    sq.save(DST, "PNG")
    print(f"icon written: {DST} ({SIZE}x{SIZE}, bg-removed={uniform})")


if __name__ == "__main__":
    main()
