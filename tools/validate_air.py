#!/usr/bin/env python3
"""AI Planet Remaster - .air format validator.

Mirrors the GDScript importer layout to validate the per-kind extra-field
counts against every classic world. Prints mismatches so the table can be
corrected before it is committed to the engine importer.
"""
import sys
from pathlib import Path

EXTRA = {
    0: 4, 1: 4,            # apple, orange (fruit)
    2: 4, 3: 4,            # apple/orange tree
    4: 3, 5: 3,            # seeds
    6: 16,                 # bird
    7: 15, 8: 15, 27: 15,  # fish, duck, grazer
    9: 12, 11: 12,         # crab, turtle
    10: 11,                # hawk
    12: 6, 13: 4, 40: 4, 31: 3,  # cloud, iceberg, earthquake, lightning
    14: 25, 34: 25, 35: 25,      # ladybug, fox, rabbit
    15: 11, 39: 11,        # ant, dolphin
    16: 3, 17: 3,          # sun, moon
    18: 4, 24: 1,          # community, flock
    19: 4,                 # asteroid
    20: 10, 28: 10, 38: 10, 33: 10, 37: 10, 22: 10,  # shark trex tiger terrier mouse bot
    21: 3, 36: 3,          # aqua plant, grass
    23: 4, 26: 8,          # explosion, bomb
    29: 4, 45: 3,          # vibe, speech
    30: 2, 25: 2, 32: 6,   # weapon, ball, beacon
    41: 5, 42: 4, 43: 3, 44: 4,  # evolving tree/fruit/seed, firetree
    46: 0, 47: 0,          # missile defence, missile
}

BASE = 29


def parse(path: Path):
    lines = path.read_text(errors="replace").splitlines()
    n = len(lines)
    i = 0

    def nxt():
        nonlocal i
        if i >= n:
            raise EOFError(f"eof at {i}")
        v = lines[i].strip()
        i += 1
        return v

    ver = int(nxt())
    if ver not in (920, 960):
        return f"legacy version {ver} (unsupported)"
    space_base = 1 if ver == 920 else 2
    for _ in range(2):
        nxt()                       # reality base
    nxt(); nxt(); nxt(); nxt(); nxt(); nxt(); nxt()  # unique, creator, stream, time, since, stagger, running
    for _ in range(2):
        nxt()                       # env base
    nxt(); nxt()                    # name, shadows
    for _ in range(space_base):
        nxt()                       # space base (920: handle only, 960: handle+parent)
    w = int(nxt()); h = int(nxt())
    for _ in range(5):
        float(nxt())                # radius + 4 defaults are floats
    cells = w * h
    for _ in range(cells * 12):
        nxt()
    for _ in range(2):              # two event lists
        nxt(); nxt()                # base
        active = int(nxt()); int(nxt()); nxt()
        for _ in range(active * 3):
            nxt()
    if ver == 960:
        nxt(); nxt()                # collisions, ai bools (not present in 920)
    for _ in range(64):
        nxt()                       # maximums
    thing_count = int(nxt())
    kinds = {}
    for _ in range(thing_count):
        k = int(nxt())
        kinds[k] = kinds.get(k, 0) + 1
        extra = EXTRA.get(k, None)
        if extra is None:
            return f"unknown kind {k} at line {i - 1}"
        for _ in range(BASE + extra):
            nxt()
    for _ in range(2):              # references + attachments
        cnt = int(nxt())
        for _ in range(cnt * 2):
            nxt()
    return None if i == n or lines[-1].startswith("Saved") else f"residual {n - i} lines (kinds={kinds})"


def main() -> None:
    worlds = sorted(Path(sys.argv[1]).glob("*.air"))
    bad = 0
    for wp in worlds:
        try:
            err = parse(wp)
        except (ValueError, EOFError) as exc:
            err = f"{type(exc).__name__}: {exc}"
        if err:
            bad += 1
            print(f"MISMATCH {wp.name}: {err}")
    print(f"{len(worlds) - bad}/{len(worlds)} worlds parsed cleanly")


if __name__ == "__main__":
    main()
