# Third-party components

| Component | Version | License | Use |
|---|---:|---|---|
| nlohmann/json | 3.12.0 | MIT | JSON session serialization and defensive parsing |
| CLI11 | 2.6.2 | BSD-3-Clause | Cross-platform CLI parsing and validation |
| Qt 6 Quick / Quick Controls 2 | system Qt 6 | LGPLv3/GPL/commercial | Optional desktop training HMI |

Candidate evaluated but not enabled by default: JSBSim (LGPL-2.1) for a future optional civilian flight-dynamics simulation adapter.

Policy: pin versions; document licenses; prefer permissive dependencies; keep copyleft components optional/separated where needed; never import code with unclear provenance; never import targeting, weapon-control, guidance, firing, or operational combat code.
