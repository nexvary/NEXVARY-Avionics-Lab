#!/usr/bin/env python3
"""Run every primary QML route headlessly and reject runtime diagnostics."""

from __future__ import annotations

import os
import pathlib
import re
import subprocess
import sys
import tempfile


LANGUAGES = ("ar", "en", "tr", "es", "de", "it", "fr", "ur", "fa", "ru")
QML_FAILURE = re.compile(
    r"qrc:/qml/|TypeError|ReferenceError|RangeError|Unable to assign|Cannot anchor|"
    r"is not a type|Failed to load component|QQmlApplicationEngine failed",
    re.IGNORECASE,
)


def run_case(executable: pathlib.Path, args: list[str], runtime_dir: str) -> None:
    environment = os.environ.copy()
    environment["QT_QPA_PLATFORM"] = "offscreen"
    environment["QT_QUICK_BACKEND"] = "software"
    environment["XDG_RUNTIME_DIR"] = runtime_dir
    completed = subprocess.run(
        [str(executable), *args],
        cwd=executable.parent,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=30,
        check=False,
    )
    output = completed.stdout.strip()
    if completed.returncode != 0 or QML_FAILURE.search(output):
        command = " ".join(args)
        raise SystemExit(
            f"QML RUNTIME GATE FAILED ({completed.returncode}): {command}\n{output}"
        )


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: qml_runtime_gate.py <nexvary_avionics_hmi>")
    executable = pathlib.Path(sys.argv[1]).resolve()
    if not executable.is_file():
        raise SystemExit(f"HMI executable not found: {executable}")

    cases: list[list[str]] = []
    cases.extend([["--smoke", "--page", "0", "--language", language] for language in LANGUAGES])
    cases.extend([["--smoke", "--page", str(page), "--language", "en"] for page in range(1, 17)])
    cases.extend([["--smoke", "--page", "11", "--air-ops-workspace", str(workspace), "--language", "en"] for workspace in range(8)])
    cases.extend([["--smoke", "--page", "12", "--force-workspace", str(workspace), "--language", "ar"] for workspace in range(6)])
    cases.extend([["--smoke", "--page", "11", "--air-ops-workspace", "6", "--cuas-section", str(section), "--language", "en"] for section in range(4)])
    cases.extend([["--smoke", "--page", "16", "--system-workspace", str(workspace), "--language", "en"] for workspace in range(3)])
    cases.extend([
        ["--navigation-smoke", "--language", "en"],
        ["--navigation-smoke", "--language", "ar"],
        ["--rtl-smoke", "--language", "ar"],
        ["--radar-motion-smoke", "--page", "11", "--air-ops-workspace", "6", "--cuas-section", "0", "--language", "en"],
        ["--orbit-motion-smoke", "--page", "11", "--air-ops-workspace", "7", "--language", "en"],
        ["--aircraft-details-smoke", "--page", "11", "--air-ops-workspace", "5", "--language", "en"],
        ["--flight-popup-layout-smoke", "--page", "11", "--air-ops-workspace", "5", "--language", "en"],
    ])

    with tempfile.TemporaryDirectory(prefix="nexvary-qml-") as runtime_dir:
        os.chmod(runtime_dir, 0o700)
        for args in cases:
            run_case(executable, args, runtime_dir)

    print(f"QML RUNTIME GATE PASS: {len(cases)} route, workspace, locale, interaction, back-stack and RTL cases")


if __name__ == "__main__":
    main()
