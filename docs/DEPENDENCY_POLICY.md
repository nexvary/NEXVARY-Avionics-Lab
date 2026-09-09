# Dependency Policy

1. Prefer MIT, BSD and Apache licensed reusable components.
2. Pin dependency versions/tags in build configuration.
3. Record source, version, license and role in the release manifest.
4. Treat code, assets and fonts as separately licensed artifacts.
5. Keep GPL-family code outside the core unless the intended distribution model is explicitly compatible.
6. External simulation engines must integrate through the SimulationProvider boundary.
7. No third-party binary plugin loading is enabled without a future trust/signing gate.
