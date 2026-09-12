.pragma library

function label(code) {
    switch (code) {
    case "ar": return "إدارة القوة الجوية"
    case "tr": return "HAVA KUVVETİ YÖNETİMİ"
    case "es": return "GESTIÓN DE FUERZA AÉREA"
    case "de": return "LUFTSTREITKRÄFTE-MANAGEMENT"
    case "it": return "GESTIONE FORZA AEREA"
    case "fr": return "GESTION DE LA FORCE AÉRIENNE"
    case "ur": return "فضائی فورس انتظام"
    case "fa": return "مدیریت نیروی هوایی"
    case "ru": return "УПРАВЛЕНИЕ ВВС"
    default: return "AIR FORCE MANAGEMENT"
    }
}

function subtitle(code) {
    if (code === "ar") return "إدارة موحدة للقواعد والأسراب والجاهزية والصيانة والأطقم والتدريب داخل بيئة محاكاة آمنة"
    if (code === "tr") return "Üsler, filolar, hazırlık, bakım, ekip ve eğitimi güvenli bir simülasyon görünümünde birleştirir"
    if (code === "es") return "Integra bases, escuadrones, disponibilidad, mantenimiento, tripulaciones y entrenamiento en una vista segura"
    if (code === "de") return "Vereint Basen, Staffeln, Bereitschaft, Wartung, Crews und Training in einer sicheren Simulationsansicht"
    if (code === "it") return "Unifica basi, squadriglie, prontezza, manutenzione, equipaggi e addestramento in una vista sicura"
    if (code === "fr") return "Unifie bases, escadrons, disponibilité, maintenance, équipages et formation dans une vue sûre"
    if (code === "ur") return "اڈوں، اسکواڈرن، تیاری، دیکھ بھال، عملہ اور تربیت کو ایک محفوظ سمولیشن منظر میں یکجا کرتا ہے"
    if (code === "fa") return "پایگاه‌ها، اسکادران‌ها، آمادگی، نگهداری، خدمه و آموزش را در یک نمای شبیه‌سازی ایمن یکپارچه می‌کند"
    if (code === "ru") return "Объединяет базы, эскадрильи, готовность, обслуживание, экипажи и обучение в безопасной среде моделирования"
    return "Unified bases, squadrons, readiness, maintenance, crew and training picture for a safe synthetic environment"
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
