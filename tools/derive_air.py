#!/usr/bin/env python3
"""AI Planet Remaster - iteratively derive per-kind extra line counts.

Greedy solver: on parse failure, adjust the failing kind's extra count to the
value that lets the parse advance furthest, then repeat until every classic
world of the target version parses cleanly.
"""
import sys
from pathlib import Path

BASE = 29
EXTRA = {}


def parse(path: Path, extra, stop_on_fail=True):
    lines = path.read_text(errors="replace").splitlines()
    n = len(lines)
    i = 0

    def nxt():
        nonlocal i
        if i >= n:
            raise EOFError()
        v = lines[i].strip()
        i += 1
        return v

    try:
        ver = int(nxt())
        space_base = 1 if ver == 920 else 2
        for _ in range(2):
            nxt()
        for _ in range(7):
            nxt()
        for _ in range(2):
            nxt()
        nxt(); nxt()
        for _ in range(space_base):
            nxt()
        w = int(nxt()); h = int(nxt())
        for _ in range(5):
            float(nxt())
        for _ in range(w * h * 12):
            nxt()
        for _ in range(2):
            nxt(); nxt()
            active = int(nxt()); int(nxt()); nxt()
            for _ in range(active * 3):
                nxt()
        if ver == 960:
            nxt(); nxt()
        for _ in range(64):
            nxt()
        thing_count = int(nxt())
        for _ in range(thing_count):
            k = int(nxt())
            e = extra.get(k)
            if e is None:
                raise ValueError(f"@unknown-kind {k} @{i}")
            for _ in range(BASE + e):
                nxt()
        for _ in range(2):
            cnt = int(nxt())
            for _ in range(cnt * 2):
                nxt()
        if not (i == n or lines[-1].startswith("Saved")):
            raise ValueError(f"@residual {n - i}")
        return i
    except ValueError as exc:
        if "@unknown-kind" in str(exc) or "@residual" in str(exc):
            raise
        raise ValueError(f"@format @{i}: {exc}")
    except EOFError:
        raise ValueError(f"@eof @{i}")


def solve(paths):
    rounds = 0
    while True:
        rounds += 1
        if rounds > 200:
            print("gave up after 200 rounds")
            break
        progressed = False
        for p in paths:
            try:
                parse(p, EXTRA)
                continue
            except ValueError as exc:
                msg = str(exc)
                if "unknown-kind" in msg:
                    k = int(msg.split("unknown-kind ")[1].split(" ")[0])
                    best = None
                    for d in range(0, 40):
                        EXTRA[k] = d
                        try:
                            reach = parse(p, EXTRA)
                        except ValueError as e2:
                            m2 = str(e2)
                            try:
                                reach = int(m2.rsplit("@", 1)[1].split(":")[0])
                            except Exception:
                                reach = 0
                        if best is None or reach > best[1]:
                            best = (d, reach)
                    EXTRA[k] = best[0]
                    progressed = True
                    print(f"{p.name}: kind {k} -> extra {best[0]} (reaches line {best[1]})")
                elif "residual" in msg or "format" in msg or "eof" in msg:
                    print(f"{p.name}: {msg} (needs manual look)")
                    return False
        if not progressed:
            break
    ok = 0
    for p in paths:
        try:
            parse(p, EXTRA)
            ok += 1
        except ValueError as exc:
            print(f"FINAL FAIL {p.name}: {exc}")
    print(f"clean: {ok}/{len(paths)}")
    print("EXTRA =", EXTRA)
    return ok == len(paths)


if __name__ == "__main__":
    worlds = sorted(Path(sys.argv[1]).glob("*.air"))
    targets = [w for w in worlds if w.read_text(errors="replace").splitlines()[0].strip() in ("920", "960")]
    solve(targets)
