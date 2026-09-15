.pragma library

// NEXVARY Aerospace Command identity — locked executive visual system.
// Deep Black + Royal Gold define the shell. Semantic colors are restrained and
// reserved for operational status, telemetry and alert meaning only.
var deepBlack = "#000000"
// Compatibility aliases retained for existing QML; they no longer carry a navy hue.
var darkNavy = "#080808"
var gunmetal = "#1A1A1A"
var metallicSilver = "#9E9B98"
var platinum = "#F2F2F2"
var electricBlue = "#6A88A0"

var bg = "#000000"
var shell = "#080808"
var panel = "#111111"
var panel2 = "#161616"
var panel3 = "#1A1A1A"
var elevated = "#202020"

// Passive dividers use a muted gold; selected/active frames use full Royal Gold.
var border = "#5A4A1C"
var borderSoft = "#332B18"
var borderStrong = "#D4AF37"
var goldGlow = "#20D4AF37"
var frameWidth = 1
var activeFrameWidth = 1.5
var grid = "#2B271B"
var text = platinum
var muted = "#9E9B98"
var silver = metallicSilver
var accent = "#D4AF37"
var cyan = "#6A88A0"
var blue = electricBlue
var gold = "#D4AF37"

// Functional status colors only — not structural/background colors.
var radarGreen = "#46C990"
var signalCyan = "#6A88A0"
var royalGold = "#D4AF37"
var rfViolet = "#9A87B8"
var skyBlue = "#7B9AAF"
var warmOrange = "#D69A60"
var deepBlue = "#161616"

var green = "#46C990"
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
