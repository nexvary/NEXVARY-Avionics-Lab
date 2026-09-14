.pragma library

// NEXVARY Aerospace Command identity — Deep Black / Royal Gold / Platinum.
// Operational state colors remain semantic; structural chrome is monochrome/gold.
var deepBlack = "#000000"
var darkNavy = deepBlack // Compatibility alias for legacy components.
var gunmetal = "#1A1A1A"
var metallicSilver = "#9E9B98"
var platinum = "#F2F2F2"
var electricBlue = "#D4AF37" // Compatibility alias; active chrome is Royal Gold.

var bg = deepBlack
var shell = "#0A0A0A"
var panel = "#111111"
var panel2 = "#151515"
var panel3 = gunmetal
var elevated = "#202020"

var border = "#D4AF37"
var borderSoft = "#665820"
var goldGlow = "#24D4AF37"
var frameWidth = 1
var activeFrameWidth = 1.5
var grid = "#292514"
var text = platinum
var muted = "#8E8E8E"
var silver = metallicSilver
var accent = "#D4AF37"
var cyan = accent
var blue = accent
var gold = accent

var radarGreen = "#62C59A"
var signalCyan = "#D4AF37"
var royalGold = "#D4AF37"
var rfViolet = "#C9B458"
var skyBlue = "#D4AF37"
var warmOrange = "#D28C62"
var deepBlue = "#665820"

var green = "#63B090"
var amber = "#B99A62"
var red = "#B66A6A"
var radius = 6

// Stage 1950 readability system.
// Arabic uses a real Kufi family when it is present on the host OS. Qt will
// fall back to the platform Arabic font when the family is not installed.
var arabicKufi = "Noto Kufi Arabic"
var latinUi = "Noto Sans"
var mono = "Noto Sans Mono"
var displayPx = 30
var titlePx = 26
var pageTitlePx = 24
var sectionPx = 16
var bodyPx = 13
var secondaryPx = 11
var smallPx = 10
var navGroupPx = 10
var navItemPx = 12

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
