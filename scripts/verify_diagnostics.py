#!/usr/bin/env python3
import json
import pathlib
import sys

if len(sys.argv) != 4:
    raise SystemExit("usage: verify_diagnostics.py diagnostic.json diagnostic.md casebook.json")

diagnostic_path = pathlib.Path(sys.argv[1])
markdown_path = pathlib.Path(sys.argv[2])
casebook_path = pathlib.Path(sys.argv[3])

for path in (diagnostic_path, markdown_path, casebook_path):
    if not path.is_file() or path.stat().st_size == 0:
        raise SystemExit(f"missing or empty diagnostic artifact: {path}")

diagnostic = json.loads(diagnostic_path.read_text(encoding="utf-8"))
if diagnostic.get("schema") != "nexvary-avionics-diagnostic/v1":
    raise SystemExit("unexpected diagnostic schema")
if diagnostic.get("scope") != "training-simulation":
    raise SystemExit("diagnostic scope must remain training-simulation")
score = diagnostic.get("health_score")
if not isinstance(score, (int, float)) or not 0 <= score <= 100:
    raise SystemExit("diagnostic health score outside 0..100")
if not isinstance(diagnostic.get("findings"), list):
    raise SystemExit("diagnostic findings must be a list")
fingerprint = diagnostic.get("fingerprint", "")
if not isinstance(fingerprint, str) or len(fingerprint) < 8:
    raise SystemExit("diagnostic fingerprint missing")

markdown = markdown_path.read_text(encoding="utf-8")
if "TRAINING / SIMULATION ONLY" not in markdown:
    raise SystemExit("diagnostic markdown safety scope missing")
if "Diagnostic health score" not in markdown:
    raise SystemExit("diagnostic markdown summary missing")

casebook = json.loads(casebook_path.read_text(encoding="utf-8"))
if casebook.get("schema") != "nexvary-diagnostic-casebook/v1":
    raise SystemExit("unexpected casebook schema")
if casebook.get("scope") != "training-simulation":
    raise SystemExit("casebook scope must remain training-simulation")
if not isinstance(casebook.get("cases"), list) or len(casebook["cases"]) != 1:
    raise SystemExit("release smoke casebook must contain exactly one case")

print(f"diagnostic verification passed: health={score} findings={len(diagnostic['findings'])} fingerprint={fingerprint}")
