.pragma library

function label(code) {
    switch (code) {
    case "ar": return "الصورة الجوية / RF"
    case "tr": return "HAVA RESMİ / RF"
    case "es": return "PANORAMA AÉREO / RF"
    case "de": return "LUFTLAGE / RF"
    case "it": return "QUADRO AEREO / RF"
    case "fr": return "SITUATION AÉRIENNE / RF"
    case "ur": return "فضائی منظر / RF"
    case "fa": return "تصویر هوایی / RF"
    case "ru": return "ВОЗДУШНАЯ ОБСТАНОВКА / RF"
    default: return "AIR PICTURE / RF"
    }
}
