#!/usr/bin/env python3
import json
import pathlib
import sys

if len(sys.argv) != 4:
    raise SystemExit("usage: verify_release.py <session.json> <report.json> <report.md>")

session_path, report_path, markdown_path = map(pathlib.Path, sys.argv[1:])
session = json.loads(session_path.read_text(encoding="utf-8"))
report = json.loads(report_path.read_text(encoding="utf-8"))
markdown = markdown_path.read_text(encoding="utf-8")

assert session["schema"] == "nexvary-avionics-session/v1"
assert session["scope"] == "training-simulation"
assert report["schema"] == "nexvary-avionics-verification/v2"
assert report["scope"] == "synthetic-training"
assert len(session["frames"]) > 0
assert report["frame_count"] == len(session["frames"])
assert report["trend_window_frames"] > 0
assert report["sequence_monotonic"] is True
assert report["time_monotonic"] is True
assert report["sensors"]

required_trend_fields = {
    "unit",
    "samples",
    "valid_samples",
    "invalid_samples",
    "missing_samples",
    "has_valid_samples",
    "minimum",
    "maximum",
    "mean",
    "latest",
    "delta",
    "slope_per_second",
}

for sensor_name, sensor in report["sensors"].items():
    missing = required_trend_fields.difference(sensor)
    assert not missing, f"{sensor_name}: missing trend fields {sorted(missing)}"
    assert sensor["samples"] == sensor["valid_samples"] + sensor["invalid_samples"]
    assert sensor["missing_samples"] >= 0
    if sensor["has_valid_samples"]:
        assert sensor["minimum"] <= sensor["mean"] <= sensor["maximum"]

assert "Synthetic training/simulation data only" in markdown
assert "Slope/s" in markdown
print(
    f"release artifacts verified: {len(session['frames'])} frames, "
    f"{report['event_count']} events, {len(report['sensors'])} trend channels"
)
