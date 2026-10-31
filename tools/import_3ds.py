#!/usr/bin/env python3
"""AI Planet Remaster - 3DS -> GLB converter (pure Python, no deps).

Parses Autodesk 3DS chunk format and emits a binary glTF 2.0 (.glb).
Coordinate conversion 3DS (Z-up) -> glTF (Y-up): (x, y, z) -> (x, z, -y).
Materials become pbrMetallicRoughness baseColorFactor (diffuse color).
Meshes are double-sided to survive legacy winding orders.
Usage: import_3ds.py file.3ds out.glb
"""
import json
import struct
import sys

CHUNK_MAIN = 0x4D4D
CHUNK_EDIT = 0x3D3D
CHUNK_OBJECT = 0x4000
CHUNK_TRIMESH = 0x4100
CHUNK_VERTS = 0x4110
CHUNK_FACES = 0x4120
CHUNK_FACEMAT = 0x4130
CHUNK_TEXUV = 0x4140
CHUNK_MAT = 0xAFFF
CHUNK_MAT_NAME = 0xA000
CHUNK_MAT_TEXMAP = 0xA200
CHUNK_MAT_TEXFILE = 0xA300
CHUNK_MAT_DIFFUSE = 0xA020
COLOR_F32 = 0x0010
COLOR_U8 = 0x0011
COLOR_F32_2 = 0x0013


class Reader:
    def __init__(self, data: bytes, off: int = 0, end: int = 0):
        self.d = data
        self.o = off
        self.e = end if end else len(data)

    def u16(self) -> int:
        v = struct.unpack_from("<H", self.d, self.o)[0]
        self.o += 2
        return v

    def u32(self) -> int:
        v = struct.unpack_from("<I", self.d, self.o)[0]
        self.o += 4
        return v

    def f32(self) -> float:
        v = struct.unpack_from("<f", self.d, self.o)[0]
        self.o += 4
        return v

    def cstr(self) -> str:
        s = self.d.index(b"\0", self.o)
        v = self.d[self.o:s].decode("latin1")
        self.o = s + 1
        return v


def parse(data: bytes):
    meshes = []   # {name, verts, faces, facemats}
    mats = {}     # name -> {color:[r,g,b], tex:str}

    def walk_mesh(r: Reader):
        verts, faces, facemats = [], [], {}
        while r.o < r.e:
            cid, ln = r.u16(), r.u32()
            sub = Reader(r.d, r.o, r.o + ln - 6)
            r.o += ln - 6
            if cid == CHUNK_VERTS:
                n = sub.u16()
                for _ in range(n):
                    x, y, z = sub.f32(), sub.f32(), sub.f32()
                    verts.append((x, z, -y))
            elif cid == CHUNK_FACES:
                n = sub.u16()
                for _ in range(n):
                    a, b, c = sub.u16(), sub.u16(), sub.u16()
                    sub.u16()
                    faces.append((a, b, c))
            elif cid == CHUNK_FACEMAT:
                mname = sub.cstr()
                nf = sub.u16()
                idx = [sub.u16() for _ in range(nf)]
                facemats[mname] = idx
            elif cid == CHUNK_TEXUV:
                n = sub.u16()
                for _ in range(n):
                    sub.f32()
                    sub.f32()
        return verts, faces, facemats

    def walk_mat(r: Reader):
        info = {"color": [0.8, 0.8, 0.8, 1.0], "tex": None}
        name = "?"
        while r.o < r.e:
            cid, ln = r.u16(), r.u32()
            sub = Reader(r.d, r.o, r.o + ln - 6)
            r.o += ln - 6
            if cid == CHUNK_MAT_NAME:
                name = sub.cstr()
            elif cid == CHUNK_MAT_DIFFUSE:
                while sub.o < sub.e:
                    c2, l2 = sub.u16(), sub.u32()
                    s2 = Reader(sub.d, sub.o, sub.o + l2 - 6)
                    sub.o += l2 - 6
                    if c2 in (COLOR_F32, COLOR_F32_2):
                        info["color"] = [min(1.0, s2.f32()) for _ in range(3)] + [1.0]
                    elif c2 == COLOR_U8:
                        info["color"] = [s2.d[s2.o + i] / 255.0 for i in range(3)] + [1.0]
            elif cid == CHUNK_MAT_TEXMAP:
                while sub.o < sub.e:
                    c2, l2 = sub.u16(), sub.u32()
                    s2 = Reader(sub.d, sub.o, sub.o + l2 - 6)
                    sub.o += l2 - 6
                    if c2 == CHUNK_MAT_TEXFILE:
                        info["tex"] = s2.cstr()
        mats[name] = info

    root = Reader(data)
    if root.u16() != CHUNK_MAIN:
        raise ValueError("not a 3DS file")
    root.u32()
    while root.o < root.e:
        cid, ln = root.u16(), root.u32()
        sub = Reader(root.d, root.o, root.o + ln - 6)
        root.o += ln - 6
        if cid == CHUNK_EDIT:
            while sub.o < sub.e:
                c2, l2 = sub.u16(), sub.u32()
                s2 = Reader(sub.d, sub.o, sub.o + l2 - 6)
                sub.o += l2 - 6
                if c2 == CHUNK_OBJECT:
                    oname = s2.cstr()
                    verts, faces, facemats = [], [], {}
                    while s2.o < s2.e:
                        c3, l3 = s2.u16(), s2.u32()
                        s3 = Reader(s2.d, s2.o, s2.o + l3 - 6)
                        s2.o += l3 - 6
                        if c3 == CHUNK_TRIMESH:
                            verts, faces, facemats = walk_mesh(s3)
                    if verts:
                        meshes.append({"name": oname, "verts": verts,
                                       "faces": faces, "facemats": facemats})
                elif c2 == CHUNK_MAT:
                    walk_mat(s2)
    return meshes, mats


def build_glb(meshes, mats) -> bytes:
    bin_parts = []
    accessors = []
    buffer_views = []
    nodes = []
    mesh_defs = []

    def add_bv(data: bytes, target: int) -> int:
        while len(bin_parts) and (sum(len(p) for p in bin_parts) % 4):
            bin_parts.append(b"\0")
        offset = sum(len(p) for p in bin_parts)
        bin_parts.append(data)
        buffer_views.append({"buffer": 0, "byteOffset": offset,
                             "byteLength": len(data), "target": target})
        return len(buffer_views) - 1

    def add_acc_f32(vals, ncomp) -> int:
        fmt = "<%df" % (len(vals))
        raw = struct.pack(fmt, *vals)
        bv = add_bv(raw, 34962)
        mn = [min(vals[i::ncomp]) for i in range(ncomp)]
        mx = [max(vals[i::ncomp]) for i in range(ncomp)]
        accessors.append({"bufferView": bv, "componentType": 5126,
                          "count": len(vals) // ncomp,
                          "type": "VEC%d" % ncomp, "min": mn, "max": mx})
        return len(accessors) - 1

    def add_acc_u16(vals) -> int:
        raw = struct.pack("<%dH" % len(vals), *vals)
        bv = add_bv(raw, 34963)
        accessors.append({"bufferView": bv, "componentType": 5123,
                          "count": len(vals), "type": "SCALAR",
                          "min": [min(vals)], "max": [max(vals)]})
        return len(accessors) - 1

    mat_indices = {}
    mlist = [{"name": "aip_default", "doubleSided": True,
              "pbrMetallicRoughness": {"baseColorFactor": [0.8, 0.8, 0.8, 1.0],
                                        "metallicFactor": 0.0, "roughnessFactor": 0.9}}]
    for name, info in sorted(mats.items()):
        mat_indices[name] = len(mlist)
        mlist.append({"name": name.replace(" ", "_")[:60], "doubleSided": True,
                      "pbrMetallicRoughness": {
                          "baseColorFactor": info["color"],
                          "metallicFactor": 0.0, "roughnessFactor": 0.9}})
    mat_indices[None] = 0

    for m in meshes:
        prims_by_mat = {0: []}
        pos_acc = add_acc_f32([c for v in m["verts"] for c in v], 3)
        if m["facemats"]:
            for mname, fidx in m["facemats"].items():
                idxs = []
                for fi in fidx:
                    if fi < len(m["faces"]):
                        a, b, c = m["faces"][fi]
                        idxs += [a, c, b]  # flip winding for Y-up
                if idxs:
                    prims_by_mat[mat_indices.get(mname, 0)] = idxs
        else:
            idxs = []
            for a, b, c in m["faces"]:
                idxs += [a, c, b]
            prims_by_mat[0] = idxs
        prims = []
        for mi, idxs in prims_by_mat.items():
            if not idxs:
                continue
            prims.append({"attributes": {"POSITION": pos_acc},
                          "indices": add_acc_u16(idxs), "material": mi})
        mesh_defs.append({"name": m["name"][:60], "primitives": prims})
        nodes.append({"mesh": len(mesh_defs) - 1, "name": m["name"][:60]})

    bin_data = b"".join(bin_parts)
    gltf = {
        "asset": {"version": "2.0", "generator": "aip-import-3ds"},
        "scene": 0,
        "scenes": [{"nodes": list(range(len(nodes)))}],
        "nodes": nodes,
        "meshes": mesh_defs,
        "materials": mlist,
        "buffers": [{"byteLength": len(bin_data)}],
        "bufferViews": buffer_views,
        "accessors": accessors,
    }
    js = json.dumps(gltf, separators=(",", ":")).encode()
    while len(js) % 4:
        js += b" "
    while len(bin_data) % 4:
        bin_data += b"\0"
    total = 12 + 8 + len(js) + 8 + len(bin_data)
    out = struct.pack("<III", 0x46546C67, 2, total)
    out += struct.pack("<II", len(js), 0x4E4F534A) + js
    out += struct.pack("<II", len(bin_data), 0x004E4942) + bin_data
    return out


def main() -> None:
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, "rb") as f:
        data = f.read()
    meshes, mats = parse(data)
    if not meshes:
        raise SystemExit(f"no meshes in {src}")
    glb = build_glb(meshes, mats)
    with open(dst, "wb") as f:
        f.write(glb)
    total_v = sum(len(m["verts"]) for m in meshes)
    total_f = sum(len(m["faces"]) for m in meshes)
    print(f"{dst}: {len(meshes)} mesh(es), {total_v} verts, {total_f} faces, "
          f"{len(mats)} materials, {len(glb)} bytes")


if __name__ == "__main__":
    main()
