.pragma library

// Ministerial / aerospace engineering palette
// Approved identity:
// Dark Navy          #0C1319
// Gunmetal           #2E3945
// Metallic Silver    #9E9B98
// Platinum           #D9D7D4
// Electric Blue      #6A88A0
var bg = "#0C1319"
var panel = "#111A22"
var panel2 = "#18232C"
var panel3 = "#222E38"
var elevated = "#26323C"
var border = "#2E3945"
var borderSoft = "#202C35"
var grid = "#1B2730"
var gold = "#D9D7D4"          // compatibility alias: legacy gold -> platinum
var platinum = "#D9D7D4"
var silver = "#9E9B98"
var text = "#D9D7D4"
var muted = "#7F898F"
var accent = "#6A88A0"
var cyan = "#6A88A0"
var blue = "#7899B2"

// Status-only colors. Keep saturated colors out of structural chrome.
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
