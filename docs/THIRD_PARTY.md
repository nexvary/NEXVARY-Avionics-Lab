# Third-party components

| Component | Version | License | Use |
|---|---:|---|---|
| nlohmann/json | 3.12.0 | MIT | JSON session serialization, run profiles and defensive parsing |
| CLI11 | 2.6.2 | BSD-3-Clause | Cross-platform CLI parsing and validation |
| spdlog | 1.17.0 | MIT | Thread-safe structured diagnostics, levels and optional file logging |
| Qt 6 Quick / Quick Controls 2 | system Qt 6 | LGPLv3/GPL/commercial | Optional desktop training HMI |

Evaluated candidates, not linked into the core by default:

- JSBSim (LGPL-2.1): future optional civilian flight-dynamics adapter.
- NASA Open MCT (Apache-2.0): optional telemetry/web visualization concepts or adapter.
- NASA F´ / F Prime: component/telemetry architecture reference; exact reused files require license review.
- Zephyr RTOS (Apache-2.0): future separate embedded demonstrator target.
- FreeRTOS Kernel (MIT): future separate lightweight MCU demonstrator target.

Policy: pin versions; document licenses; prefer permissive dependencies; keep copyleft components optional/separated where needed; never import code with unclear provenance; never import targeting, weapon-control, guidance, firing, or operational combat code.
