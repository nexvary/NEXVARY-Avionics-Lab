#!/usr/bin/env python3
"""Small deterministic release gate; complements compiler warnings, ASan/UBSan and CodeQL."""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SOURCE_ROOTS = (ROOT / "src", ROOT / "qml")
FORBIDDEN = {
    "std::system(": "shell execution",
    "QProcess::": "process spawning",
    "popen(": "shell/process pipe",
    "strcpy(": "unbounded copy",
    "strcat(": "unbounded concatenation",
    "sprintf(": "unbounded formatting",
    "gets(": "unsafe input API",
}


def source_files():
    for base in SOURCE_ROOTS:
        for path in base.rglob("*"):
            if path.suffix.lower() in {".cpp", ".hpp", ".h", ".qml", ".js"}:
                yield path


def main():
    failures = []
    for path in source_files():
        text = path.read_text(encoding="utf-8")
        for token, reason in FORBIDDEN.items():
            if token in text:
                failures.append(f"{path.relative_to(ROOT)}: {reason} ({token})")

    about = ROOT / "qml" / "AboutNexvary.qml"
    if about.exists():
        text = about.read_text(encoding="utf-8")
        urls = re.findall(r'"url"\s*:\s*"([^"]+)"', text)
        for url in urls:
            if not (url.startswith("https://") or url.startswith("mailto:")):
                failures.append(f"AboutNexvary.qml: disallowed external-link scheme: {url}")
        if len(urls) != 5:
            failures.append(f"AboutNexvary.qml: expected 5 fixed official links, found {len(urls)}")

    if failures:
        print("SECURITY BASELINE FAILED")
        for item in failures:
            print(" -", item)
        return 1

    print("SECURITY BASELINE PASS")
    print("Checked source for unsafe process/C-string APIs and constrained About links to fixed HTTPS/mailto destinations.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
