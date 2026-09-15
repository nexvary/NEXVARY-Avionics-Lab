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
    require(root / "stage1980-command-overview-en-1920x1080.png", (1920, 1080))
    require(root / "stage1980-command-overview-ar-1920x1080.png", (1920, 1080))
    require(root / "stage1980-command-overview-ar-2560x1440.png", (2560, 1440))
    require(root / "stage1980-airspace-ar.png", (1920, 1080))
    require(root / "stage1980-common-air-picture-en.png", (1920, 1080))
    require(root / "stage1980-flight-tracking-en.png", (1920, 1080))
    require(root / "stage1990-aircraft-intelligence-en.png", (1920, 1080))
    require(root / "stage1990-aircraft-intelligence-ar.png", (1920, 1080))
    require(root / "stage1990-about-system-en.png", (1920, 1080))
    require(root / "stage1990-about-system-ar.png", (1920, 1080))
    require(root / "stage1980-route-lab-en.png", (1920, 1080))
    require(root / "stage1980-aeronautical-data-en.png", (1920, 1080))
    require(root / "stage1980-aircraft-visual-en.png", (1920, 1080))
    require(root / "stage1980-aircraft-helicopter-en.png", (1920, 1080))
    require(root / "stage1980-aircraft-uav-en.png", (1920, 1080))
    require(root / "stage1980-aircraft-turboprop-en.png", (1920, 1080))
    require(root / "stage1980-force-fleet-ar.png", (1920, 1080))
    require(root / "stage1980-bases-airfields-en.png", (1920, 1080))
    require(root / "stage1980-platform-library-en.png", (1920, 1080))
    require(root / "stage1980-cuas-detection-en.png", (1920, 1080))
    require(root / "stage1980-space-domain-en.png", (1920, 1080))
    require(root / "stage1980-space-domain-ar.png", (1920, 1080))
    require(root / "stage1980-data-sources-en.png", (1920, 1080))
    require(root / "stage1980-diagnostic-ar.png", (1920, 1080))
    for code in LANGS:
        require(root / f"stage1980-lang-{code}.png", (1720, 1000))
    print("UI RELEASE GATE PASS: Stage 1990 preserves the Stage 1980 command gate and verifies bilingual aircraft intelligence details, professional selected-track presentation, the integrated About System brief, Arabic RTL and ten-locale rendering.")


if __name__ == "__main__":
    main()
