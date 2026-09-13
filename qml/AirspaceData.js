.pragma library

// Stage 1810 training dataset. Geometry is intentionally synthetic and must not be
// interpreted as an official aeronautical chart or operational boundary.
var zones = [
    {id:"SYN-DELTA-C", name:"Delta Training Sector", classCode:"C", controlled:true, floor:"1500 ft", ceiling:"FL195", x:0.31, y:0.24, w:0.27, h:0.16, note:"Synthetic terminal-area training block."},
    {id:"SYN-ALEX-D", name:"Alexandria Training CTR", classCode:"D", controlled:true, floor:"SFC", ceiling:"4500 ft", x:0.18, y:0.20, w:0.14, h:0.12, note:"Synthetic controlled-zone example."},
    {id:"SYN-CAIRO-C", name:"Cairo Training TMA", classCode:"C", controlled:true, floor:"2500 ft", ceiling:"FL195", x:0.43, y:0.36, w:0.20, h:0.18, note:"Synthetic terminal-area classification example."},
    {id:"SYN-UPPER-A", name:"Upper Egypt High Corridor", classCode:"A", controlled:true, floor:"FL180", ceiling:"FL450", x:0.43, y:0.60, w:0.22, h:0.28, note:"Synthetic high-level controlled corridor."},
    {id:"SYN-SINAI-E", name:"Sinai Advisory Sector", classCode:"E", controlled:true, floor:"700 ft", ceiling:"FL180", x:0.67, y:0.34, w:0.22, h:0.27, note:"Synthetic advisory/controlled transition sector."},
    {id:"SYN-REDSEA-E", name:"Red Sea Training Corridor", classCode:"E", controlled:true, floor:"1200 ft", ceiling:"FL180", x:0.70, y:0.62, w:0.12, h:0.25, note:"Synthetic coastal corridor for visualization."},
    {id:"SYN-WEST-G", name:"Western Desert Open Sector", classCode:"G", controlled:false, floor:"SFC", ceiling:"5500 ft", x:0.08, y:0.48, w:0.30, h:0.34, note:"Synthetic uncontrolled-airspace example."},
    {id:"SYN-MID-B", name:"Central Training Block", classCode:"B", controlled:true, floor:"5000 ft", ceiling:"FL180", x:0.35, y:0.47, w:0.16, h:0.12, note:"Synthetic Class B comparison block."},
    {id:"SYN-COAST-F", name:"North Coast Advisory", classCode:"F", controlled:false, floor:"2500 ft", ceiling:"9500 ft", x:0.12, y:0.12, w:0.40, h:0.08, note:"Synthetic advisory Class F comparison band."}
]

var airports = [
    {code:"HEAX", name:"Alexandria", x:0.245, y:0.255},
    {code:"HECA", name:"Cairo", x:0.515, y:0.445},
    {code:"HELX", name:"Luxor", x:0.535, y:0.750},
    {code:"HEGN", name:"Hurghada", x:0.690, y:0.705},
    {code:"HESH", name:"Sharm El Sheikh", x:0.755, y:0.535},
    {code:"HESN", name:"Aswan", x:0.545, y:0.885}
]

var navaids = [
    {code:"NAV-01", type:"VOR/DME", x:0.29, y:0.33},
    {code:"NAV-02", type:"VOR/DME", x:0.50, y:0.50},
    {code:"NAV-03", type:"DME", x:0.59, y:0.67},
    {code:"NAV-04", type:"VOR/DME", x:0.73, y:0.57}
]

var route = [
    {x:0.245, y:0.255},
    {x:0.515, y:0.445},
    {x:0.535, y:0.750},
    {x:0.690, y:0.705}
]

var classInfo = [
    {code:"A", description:"Controlled IFR training reference"},
    {code:"B", description:"Controlled high-density reference"},
    {code:"C", description:"Controlled terminal reference"},
    {code:"D", description:"Controlled aerodrome reference"},
    {code:"E", description:"Controlled transition reference"},
    {code:"F", description:"Advisory comparison reference"},
    {code:"G", description:"Uncontrolled reference"}
]
