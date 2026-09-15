.pragma library

// NEXVARY Aerospace Command identity — approved aviation visual reference.
// Deep black remains the structural base, Royal Gold defines frames and hierarchy,
// while restrained aviation blue/cyan restores the high-contrast telemetry/radar
// character from the verified Stage 1980 Windows reference build.
var deepBlack = "#020406"
var darkNavy = "#070B12"
var gunmetal = "#17212B"
var metallicSilver = "#AEB7C0"
var platinum = "#F2F4F7"
var electricBlue = "#6FA6CC"

var bg = "#020406"
var shell = "#070A0F"
var panel = "#0B1017"
var panel2 = "#101822"
var panel3 = "#151F2A"
var elevated = "#1A2632"

// Royal Gold is the primary structural accent. Passive separators retain a
// blue-steel undertone so dense panels read like the approved reference UI.
var border = "#6A5522"
var borderSoft = "#263440"
var borderStrong = "#D4AF37"
var goldGlow = "#22D4AF37"
var frameWidth = 1
var activeFrameWidth = 1.5
var grid = "#173047"
var text = platinum
var muted = "#9DA8B2"
var silver = metallicSilver
var accent = "#D4AF37"
var cyan = "#72B7D6"
var blue = electricBlue
var gold = "#D4AF37"

// Functional status / telemetry accents only.
var radarGreen = "#45D0A0"
var signalCyan = "#72B7D6"
var royalGold = "#D4AF37"
var rfViolet = "#A58BC8"
var skyBlue = "#76B4D6"
var warmOrange = "#D99A5F"
var deepBlue = "#0B1622"

var green = "#45D0A0"
var amber = "#D6A846"
var warning = amber
var red = "#D76565"
var radius = 7

// Ministerial readability system.
var arabicKufi = "Noto Kufi Arabic"
var latinUi = "Noto Sans"
var mono = "Noto Sans Mono"
var displayPx = 32
var titlePx = 28
var pageTitlePx = 26
var sectionPx = 17
var bodyPx = 15
var secondaryPx = 13
var smallPx = 12
var navGroupPx = 12
var navItemPx = 14

function uiFont(rtl) { return rtl ? arabicKufi : latinUi }

function stateColor(state) {
    if (state === "NOMINAL") return green
    if (state === "DEGRADED") return amber
    if (state === "FAULT") return red
    return muted
}

function platformCode(id) {
    if (id === "generic-jet") return "JET"
    if (id === "generic-turboprop" || id === "turboprop") return "TPR"
    if (id === "generic-helicopter" || id === "helicopter") return "HEL"
    if (id === "generic-uav" || id === "uav") return "UAV"
    return "GEN"
}
