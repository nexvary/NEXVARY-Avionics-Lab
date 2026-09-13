#!/usr/bin/env python3
import pathlib
import struct
import sys

PNG = b"\x89PNG\r\n\x1a\n"
LANGS = ("ar", "en", "tr", "es", "de", "it", "fr", "ur", "fa", "ru")


def png_size(path: pathlib.Path):
    data = path.read_bytes()[:24]
    if len(data) < 24 or data[:8] != PNG or data[12:16] != b"IHDR":
        raise SystemExit(f"invalid PNG: {path}")
    return struct.unpack(">II", data[16:24])


def require(path: pathlib.Path, expected=None):
    if not path.is_file() or path.stat().st_size < 20_000:
        raise SystemExit(f"missing or suspiciously small visual gate image: {path}")
    size = png_size(path)
    if expected and size != expected:
        raise SystemExit(f"wrong dimensions for {path.name}: {size}, expected {expected}")
    print(f"PASS {path.name}: {size[0]}x{size[1]} ({path.stat().st_size} bytes)")


def main():
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "build-qt")
    require(root / "stage1890-management-overview-1920x1080.png", (1920, 1080))
    require(root / "stage1890-management-overview-2560x1440.png", (2560, 1440))
    require(root / "stage1890-airspace-ar.png", (1920, 1080))
    require(root / "stage1890-air-picture-en.png", (1920, 1080))
    require(root / "stage1890-data-hub-ar.png", (1920, 1080))
    require(root / "stage1890-route-lab-en.png", (1920, 1080))
    require(root / "stage1890-aircraft-ar.png", (1920, 1080))
    require(root / "stage1890-cuas-response-en.png", (1920, 1080))
    require(root / "stage1890-air-force-management-ar.png", (1920, 1080))
    require(root / "stage1890-about-system-ar.png", (1920, 1080))
    require(root / "stage1890-diagnostic-ar.png", (1920, 1080))
    for code in LANGS:
        require(root / f"stage1890-lang-{code}.png", (1720, 1000))
    print("UI RELEASE GATE PASS: Stage 1890 air-force-management restructure, map-first executive overview, base/airfield status, squadron readiness, training/weather, sustainment, airspace awareness, RTL and ten locale renders are present.")


if __name__ == "__main__":
    main()
