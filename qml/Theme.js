.pragma library

// NEXVARY Aerospace Command identity.
// Deep Black and Royal Gold define the brand. Operational layers use restrained
// electric blue, radar green and violet so status remains readable at a glance.
var deepBlack = "#000000"
var darkNavy = "#061018"
var gunmetal = "#1B2A34"
var metallicSilver = "#9EABB5"
var platinum = "#F2F5F7"
var electricBlue = "#168DFF"

var bg = "#02070B"
var shell = "#050D13"
var panel = "#07131A"
var panel2 = "#0A1821"
var panel3 = "#10232D"
var elevated = "#142B36"

var border = "#294653"
var borderSoft = "#1B3440"
var borderStrong = "#D4AF37"
var goldGlow = "#20D4AF37"
var frameWidth = 1
var activeFrameWidth = 1.5
var grid = "#17323E"
var text = platinum
var muted = "#80919B"
var silver = metallicSilver
var accent = "#D4AF37"
var cyan = "#2CCEFF"
var blue = electricBlue
var gold = "#D4AF37"

var radarGreen = "#46E2A0"
var signalCyan = "#2CCEFF"
var royalGold = "#D4AF37"
var rfViolet = "#A984E9"
var skyBlue = "#65BFFF"
var warmOrange = "#FF9B54"
var deepBlue = "#0A5F9E"

var green = "#46D49B"
var amber = "#F4B942"
var red = "#F06262"
var radius = 7

// Stage 1970 ministerial readability system.
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
