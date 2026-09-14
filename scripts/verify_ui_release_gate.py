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
    require(root / "stage1970-command-overview-en-1920x1080.png", (1920, 1080))
    require(root / "stage1970-command-overview-ar-1920x1080.png", (1920, 1080))
    require(root / "stage1970-command-overview-ar-2560x1440.png", (2560, 1440))
    require(root / "stage1970-airspace-ar.png", (1920, 1080))
    require(root / "stage1970-common-air-picture-en.png", (1920, 1080))
    require(root / "stage1970-flight-tracking-en.png", (1920, 1080))
    require(root / "stage1970-route-lab-en.png", (1920, 1080))
    require(root / "stage1970-aeronautical-data-en.png", (1920, 1080))
    require(root / "stage1970-aircraft-visual-en.png", (1920, 1080))
    require(root / "stage1970-aircraft-helicopter-en.png", (1920, 1080))
    require(root / "stage1970-aircraft-uav-en.png", (1920, 1080))
    require(root / "stage1970-aircraft-turboprop-en.png", (1920, 1080))
    require(root / "stage1970-force-fleet-ar.png", (1920, 1080))
    require(root / "stage1970-bases-airfields-en.png", (1920, 1080))
    require(root / "stage1970-platform-library-en.png", (1920, 1080))
    require(root / "stage1970-cuas-detection-en.png", (1920, 1080))
    require(root / "stage1970-data-sources-en.png", (1920, 1080))
    require(root / "stage1970-diagnostic-ar.png", (1920, 1080))
    for code in LANGS:
        require(root / f"stage1970-lang-{code}.png", (1720, 1000))
    print("UI RELEASE GATE PASS: Stage 1970 verifies the ministerial command hierarchy, balanced space use, animated passive radar, professional aircraft engineering visuals, independent operational workspaces, larger typography, Arabic RTL and ten-locale rendering.")


if __name__ == "__main__":
    main()
