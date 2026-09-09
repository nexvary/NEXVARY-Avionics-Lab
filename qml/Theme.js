.pragma library
var bg = "#02070b"
var panel = "#071218"
var panel2 = "#0b1921"
var border = "#314750"
var gold = "#f2c95c"
var silver = "#c8d5dc"
var text = "#dce8ed"
var muted = "#7f929b"
var green = "#35f59a"
var cyan = "#61cbff"
var amber = "#ffb326"
var red = "#ff5a63"
var radius = 10
function stateColor(state) {
    if (state === "NOMINAL") return green
    if (state === "DEGRADED") return amber
    if (state === "FAULT") return red
    return muted
}
