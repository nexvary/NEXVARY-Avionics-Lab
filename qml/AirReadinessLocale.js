.pragma library

function label(code) {
    switch (code) {
    case "ar": return "الجاهزية وإدارة العمليات"
    case "tr": return "HAZIRLIK VE OPERASYON YÖNETİMİ"
    case "es": return "PREPARACIÓN Y GESTIÓN OPERATIVA"
    case "de": return "EINSATZBEREITSCHAFT UND BETRIEBSFÜHRUNG"
    case "it": return "PRONTEZZA E GESTIONE OPERATIVA"
    case "fr": return "PRÉPARATION ET GESTION DES OPÉRATIONS"
    case "ur": return "تیاری اور آپریشن مینجمنٹ"
    case "fa": return "آمادگی و مدیریت عملیات"
    case "ru": return "ГОТОВНОСТЬ И УПРАВЛЕНИЕ ОПЕРАЦИЯМИ"
    default: return "AIR READINESS & OPERATIONS"
    }
}

function subtitle(code) {
    if (code === "ar") return "صورة تنفيذية موحدة للجاهزية والصيانة والأطقم وجدول التدريب داخل بيئة محاكاة آمنة"
    if (code === "tr") return "Hazırlık, bakım, ekip ve eğitim planını tek güvenli simülasyon görünümünde birleştirir"
    if (code === "es") return "Integra disponibilidad, mantenimiento, tripulaciones y agenda de entrenamiento en una vista segura"
    if (code === "de") return "Vereint Bereitschaft, Wartung, Crews und Trainingsplanung in einer sicheren Simulationsansicht"
    if (code === "it") return "Unifica prontezza, manutenzione, equipaggi e pianificazione addestrativa in una vista sicura"
    if (code === "fr") return "Unifie disponibilité, maintenance, équipages et planification d'entraînement dans une vue sûre"
    if (code === "ur") return "تیاری، دیکھ بھال، عملہ اور تربیتی شیڈول کو ایک محفوظ سمولیشن منظر میں یکجا کرتا ہے"
    if (code === "fa") return "آمادگی، نگهداری، خدمه و برنامه آموزشی را در یک نمای شبیه‌سازی ایمن یکپارچه می‌کند"
    if (code === "ru") return "Объединяет готовность, обслуживание, экипажи и учебный график в безопасной среде моделирования"
    return "Executive readiness, maintenance, crew and training-schedule picture for a safe synthetic environment"
}

function fleet(code) { return code === "ar" ? "جاهزية الأسطول" : "FLEET READINESS" }
function ready(code) { return code === "ar" ? "منصات جاهزة" : "READY PLATFORMS" }
function maintenance(code) { return code === "ar" ? "بنود الصيانة المفتوحة" : "OPEN MAINTENANCE" }
function crew(code) { return code === "ar" ? "جاهزية الأطقم" : "CREW READINESS" }
function platformState(code) { return code === "ar" ? "حالة المنصات التدريبية" : "TRAINING PLATFORM STATUS" }
function maintenanceQueue(code) { return code === "ar" ? "قائمة الصيانة" : "MAINTENANCE QUEUE" }
function trainingPlan(code) { return code === "ar" ? "الجدول التدريبي القادم" : "NEXT TRAINING CYCLE" }
function integration(code) { return code === "ar" ? "سلسلة التكامل" : "INTEGRATION CHAIN" }
function boundary(code) { return code === "ar" ? "حدود الاستخدام" : "USAGE BOUNDARY" }
function boundaryText(code) {
    return code === "ar"
        ? "هذه الشاشة للتدريب والتحليل والجاهزية الهندسية ببيانات صناعية؛ لا تصدر أوامر تشغيلية أو تحكمًا حيًا بالطائرات."
        : "Training, analysis and engineering-readiness workspace using synthetic data only; it issues no operational or live-aircraft control commands."
}
