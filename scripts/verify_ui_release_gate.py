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
    require(root / "stage1780-desktop-1920x1080.png", (1920, 1080))
    require(root / "stage1780-large-2560x1440.png", (2560, 1440))
    require(root / "stage1780-unified-command-ar.png", (1920, 1080))
    require(root / "stage1780-unified-command-en.png", (1920, 1080))
    require(root / "stage1780-air-operations-ar.png", (1920, 1080))
    require(root / "stage1780-air-operations-en.png", (1920, 1080))
    require(root / "stage1780-air-readiness-ar.png", (1920, 1080))
    require(root / "stage1780-air-readiness-en.png", (1920, 1080))
    require(root / "stage1780-about-system-ar.png", (1920, 1080))
    require(root / "stage1780-about-us-ar.png", (1920, 1080))
    require(root / "stage1780-about-us-en.png", (1920, 1080))
    require(root / "stage1780-diagnostic-ar.png", (1920, 1080))
    for code in LANGS:
        require(root / f"stage1780-lang-{code}.png", (1720, 1000))
    print("UI RELEASE GATE PASS: Stage 1780 dense command center, air operations, air readiness, desktop/large-display sizing, RTL surfaces and ten locale renders are present.")


if __name__ == "__main__":
    main()
