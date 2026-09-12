.pragma library

function label(code) {
    switch (code) {
    case "ar": return "العمليات الجوية"
    case "tr": return "HAVA HAREKÂTLARI"
    case "es": return "OPERACIONES AÉREAS"
    case "de": return "LUFTOPERATIONEN"
    case "it": return "OPERAZIONI AEREE"
    case "fr": return "OPÉRATIONS AÉRIENNES"
    case "ur": return "فضائی آپریشنز"
    case "fa": return "عملیات هوایی"
    case "ru": return "ВОЗДУШНЫЕ ОПЕРАЦИИ"
    default: return "AIR OPERATIONS"
    }
}
