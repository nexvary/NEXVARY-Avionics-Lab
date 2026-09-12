.pragma library

// NEXVARY Ministerial Command Interface — approved identity
var darkNavy = "#0C1319"
var gunmetal = "#2E3945"
var metallicSilver = "#9E9B98"
var platinum = "#D9D7D4"
var electricBlue = "#6A88A0"

var bg = darkNavy
var shell = "#0A1117"
var panel = "#121B22"
var panel2 = "#18232C"
var panel3 = gunmetal
var elevated = "#24313B"
var border = "#52606B"
var borderSoft = "#26333D"
var grid = "#1C2831"
var text = platinum
var muted = "#7E898F"
var silver = metallicSilver
var accent = electricBlue
var cyan = electricBlue
var blue = electricBlue
var gold = platinum

var green = "#63B090"
var amber = "#B99A62"
var red = "#B66A6A"
var radius = 2

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
