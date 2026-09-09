.pragma library
var bg = "#010609"
var panel = "#061017"
var panel2 = "#09151c"
var panel3 = "#0c1b23"
var border = "#2d3c44"
var grid = "#13242d"
var gold = "#c9a54d"
var silver = "#b9c5ca"
var text = "#d9e2e6"
var muted = "#71838c"
var green = "#39e59a"
var cyan = "#4bb8e9"
var blue = "#4f88e8"
var amber = "#e3a33b"
var red = "#ef5b62"
var radius = 3
function stateColor(state) {
    if (state === "NOMINAL") return green
    if (state === "DEGRADED") return amber
    if (state === "FAULT") return red
    return muted
}
