.pragma library

function label(code) {
    switch (code) {
    case "ar": return "المجال الجوي والتصنيف"
    case "tr": return "HAVA SAHASI SINIFLANDIRMASI"
    case "es": return "CLASIFICACIÓN DEL ESPACIO AÉREO"
    case "de": return "LUFTRAUMKLASSIFIZIERUNG"
    case "it": return "CLASSIFICAZIONE DELLO SPAZIO AEREO"
    case "fr": return "CLASSIFICATION DE L’ESPACE AÉRIEN"
    case "ur": return "فضائی حدود کی درجہ بندی"
    case "fa": return "طبقه‌بندی فضای هوایی"
    case "ru": return "КЛАССИФИКАЦИЯ ВОЗДУШНОГО ПРОСТРАНСТВА"
    default: return "AIRSPACE CLASSIFICATION"
    }
}

function chart(code) { return code === "ar" ? "خريطة المجال الجوي" : "AIRSPACE CHART" }
function picture(code) { return code === "ar" ? "الصورة الجوية و RF" : "AIR PICTURE / RF" }
function subtitle(code) {
    return code === "ar"
        ? "تصنيف مرئي للمجال الجوي، المطارات والمساعدات الملاحية ومسارات الطيران العامة — بيانات تدريبية"
        : "VISUAL AIRSPACE CLASSIFICATION, AIRPORTS, NAVAIDS AND PUBLIC FLIGHT TRACKS — TRAINING DATA"
}
function notForNavigation(code) { return code === "ar" ? "للتدريب فقط — غير صالح للملاحة" : "TRAINING ONLY — NOT FOR NAVIGATION" }
function layers(code) { return code === "ar" ? "الطبقات" : "LAYERS" }
function details(code) { return code === "ar" ? "تفاصيل القطاع" : "SECTOR DETAILS" }
function legend(code) { return code === "ar" ? "دليل التصنيف" : "CLASS LEGEND" }
function airports(code) { return code === "ar" ? "المطارات" : "AIRPORTS" }
function navaids(code) { return code === "ar" ? "المساعدات الملاحية" : "NAVAIDS" }
function traffic(code) { return code === "ar" ? "حركة الطائرات العامة" : "PUBLIC TRAFFIC" }
function route(code) { return code === "ar" ? "مسار تدريبي" : "TRAINING ROUTE" }
function all(code) { return code === "ar" ? "الكل" : "ALL" }
function controlled(code) { return code === "ar" ? "متحكم به" : "CONTROLLED" }
function uncontrolled(code) { return code === "ar" ? "غير متحكم" : "UNCONTROLLED" }
