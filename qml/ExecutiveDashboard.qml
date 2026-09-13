import QtQuick

// Executive entry point intentionally delegates to the integrated visual command center.
// Keeping this compatibility wrapper means existing navigation, smoke tests and release
// tooling continue to open page 0 while the richer dashboard owns the actual UI.
UnifiedAirCommandDashboard {
}
