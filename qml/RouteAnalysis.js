.pragma library

// Training-only route analysis over the normalized Stage 1810 chart geometry.
// The scale factors are intentionally approximate and are not for navigation.

function pointDistanceKm(a, b) {
    var dx = (b.x - a.x) * 1200.0
    var dy = (b.y - a.y) * 1050.0
    return Math.sqrt(dx * dx + dy * dy)
}

function segmentIntersectsRect(a, b, zone) {
    var minX = Math.min(a.x, b.x)
    var maxX = Math.max(a.x, b.x)
    var minY = Math.min(a.y, b.y)
    var maxY = Math.max(a.y, b.y)
    var zx0 = zone.x
    var zx1 = zone.x + zone.w
    var zy0 = zone.y
    var zy1 = zone.y + zone.h
    if (maxX < zx0 || minX > zx1 || maxY < zy0 || minY > zy1) return false

    // Sample the segment to keep the implementation deterministic and easy to audit.
    for (var i = 0; i <= 24; ++i) {
        var t = i / 24.0
        var x = a.x + (b.x - a.x) * t
        var y = a.y + (b.y - a.y) * t
        if (x >= zx0 && x <= zx1 && y >= zy0 && y <= zy1) return true
    }
    return false
}

function summary(route, zones) {
    var distance = 0
    var crossed = []
    var classes = []
    var controlled = 0
    var uncontrolled = 0

    for (var s = 0; s < route.length - 1; ++s) {
        distance += pointDistanceKm(route[s], route[s + 1])
        for (var z = 0; z < zones.length; ++z) {
            var zone = zones[z]
            if (!segmentIntersectsRect(route[s], route[s + 1], zone)) continue
            var already = false
            for (var c = 0; c < crossed.length; ++c) {
                if (crossed[c].id === zone.id) { already = true; break }
            }
            if (!already) {
                crossed.push(zone)
                if (zone.controlled) controlled += 1
                else uncontrolled += 1
                if (classes.indexOf(zone.classCode) < 0) classes.push(zone.classCode)
            }
        }
    }

    classes.sort()
    return {
        distanceKm: Math.round(distance),
        segmentCount: Math.max(0, route.length - 1),
        zoneCount: crossed.length,
        controlledCount: controlled,
        uncontrolledCount: uncontrolled,
        classes: classes,
        zones: crossed,
        advisory: crossed.length === 0 ? "CLEAR TRAINING ROUTE" : "REVIEW CLASS / ALTITUDE CONTEXT"
    }
}
