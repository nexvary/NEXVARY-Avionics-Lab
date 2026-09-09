#!/usr/bin/env python3
import json
import pathlib
import sys
if len(sys.argv)!=4: raise SystemExit("usage: verify_release.py <session.json> <report.json> <report.md>")
session_path,report_path,markdown_path=map(pathlib.Path,sys.argv[1:])
session=json.loads(session_path.read_text(encoding="utf-8"));report=json.loads(report_path.read_text(encoding="utf-8"));markdown=markdown_path.read_text(encoding="utf-8")
assert session["schema"]=="nexvary-avionics-session/v1";assert session["scope"]=="training-simulation";assert report["schema"]=="nexvary-avionics-verification/v1";assert report["scope"]=="synthetic-training";assert len(session["frames"])>0;assert report["frame_count"]==len(session["frames"]);assert report["sequence_monotonic"] is True;assert report["time_monotonic"] is True;assert "Synthetic training/simulation data only" in markdown
print(f"release artifacts verified: {len(session['frames'])} frames, {report['event_count']} events")
