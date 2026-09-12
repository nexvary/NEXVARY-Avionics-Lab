.pragma library

function label(code) {
    switch (code) {
    case "ar": return "القيادة الجوية الموحدة"
    case "tr": return "BÜTÜNLEŞİK HAVA KOMUTA"
    case "es": return "MANDO AÉREO INTEGRADO"
    case "de": return "INTEGRIERTE LUFTFÜHRUNG"
    case "it": return "COMANDO AEREO INTEGRATO"
    case "fr": return "COMMANDE AÉRIEN INTÉGRÉE"
    case "ur": return "متحد فضائی کمانڈ"
    case "fa": return "فرماندهی یکپارچه هوایی"
    case "ru": return "ЕДИНОЕ ВОЗДУШНОЕ УПРАВЛЕНИЕ"
    default: return "UNIFIED AIR COMMAND"
    }
}

function subtitle(code) {
    switch (code) {
    case "ar": return "صورة تنفيذية موحدة للوعي الجوي والجاهزية والصيانة وصحة الأنظمة — تدريب وتحليل فقط"
    case "tr": return "Hava sahası farkındalığı, hazırlık, bakım ve sistem sağlığı için birleşik yönetici görünümü — yalnızca eğitim ve analiz"
    case "es": return "Vista ejecutiva unificada de conciencia aérea, disponibilidad, mantenimiento y salud de sistemas — solo formación y análisis"
    case "de": return "Einheitliches Lagebild für Luftraumbewusstsein, Bereitschaft, Wartung und Systemzustand — nur Training und Analyse"
    case "it": return "Quadro esecutivo unificato per consapevolezza aerea, prontezza, manutenzione e salute dei sistemi — solo addestramento e analisi"
    case "fr": return "Vue exécutive unifiée de la situation aérienne, de la disponibilité, de la maintenance et de l’état des systèmes — formation et analyse uniquement"
    case "ur": return "فضائی آگاہی، تیاری، دیکھ بھال اور نظامی صحت کا متحد انتظامی منظر — صرف تربیت اور تجزیہ"
    case "fa": return "نمای اجرایی یکپارچه برای آگاهی هوایی، آمادگی، نگهداری و سلامت سامانه — فقط آموزش و تحلیل"
    case "ru": return "Единая исполнительная картина воздушной обстановки, готовности, обслуживания и состояния систем — только обучение и анализ"
    default: return "Unified executive picture for airspace awareness, readiness, maintenance and system health — training and analysis only"
    }
}

function airspace(code) {
    switch (code) {
    case "ar": return "صورة المجال الجوي"
    case "tr": return "HAVA SAHASI GÖRÜNÜMÜ"
    case "es": return "PANORAMA DEL ESPACIO AÉREO"
    case "de": return "LUFTRAUMLAGE"
    case "it": return "QUADRO SPAZIO AEREO"
    case "fr": return "SITUATION DE L’ESPACE AÉRIEN"
    case "ur": return "فضائی حدود کی تصویر"
    case "fa": return "تصویر فضای هوایی"
    case "ru": return "ВОЗДУШНАЯ ОБСТАНОВКА"
    default: return "AIRSPACE PICTURE"
    }
}

function readiness(code) {
    switch (code) {
    case "ar": return "جاهزية الأسطول"
    case "tr": return "FİLO HAZIRLIĞI"
    case "es": return "DISPONIBILIDAD DE FLOTA"
    case "de": return "FLOTTENBEREITSCHAFT"
    case "it": return "PRONTEZZA DELLA FLOTTA"
    case "fr": return "DISPONIBILITÉ DE LA FLOTTE"
    case "ur": return "بیڑے کی تیاری"
    case "fa": return "آمادگی ناوگان"
    case "ru": return "ГОТОВНОСТЬ ПАРКА"
    default: return "FLEET READINESS"
    }
}

function engineering(code) {
    switch (code) {
    case "ar": return "الصحة الهندسية"
    case "tr": return "MÜHENDİSLİK SAĞLIĞI"
    case "es": return "SALUD DE INGENIERÍA"
    case "de": return "ENGINEERING-STATUS"
    case "it": return "SALUTE INGEGNERISTICA"
    case "fr": return "SANTÉ D’INGÉNIERIE"
    case "ur": return "انجینئرنگ صحت"
    case "fa": return "سلامت مهندسی"
    case "ru": return "ИНЖЕНЕРНОЕ СОСТОЯНИЕ"
    default: return "ENGINEERING HEALTH"
    }
}

function attention(code) {
    switch (code) {
    case "ar": return "بنود تحتاج متابعة"
    case "tr": return "TAKİP GEREKTİREN ÖĞELER"
    case "es": return "ELEMENTOS A SEGUIR"
    case "de": return "PUNKTE ZUR NACHVERFOLGUNG"
    case "it": return "ELEMENTI DA SEGUIRE"
    case "fr": return "ÉLÉMENTS À SUIVRE"
    case "ur": return "توجہ کے مطلوب نکات"
    case "fa": return "موارد نیازمند پیگیری"
    case "ru": return "ПУНКТЫ ДЛЯ КОНТРОЛЯ"
    default: return "ITEMS REQUIRING FOLLOW-UP"
    }
}

function boundary(code) {
    switch (code) {
    case "ar": return "حد الاستخدام: وعي موقفي، تدريب، Replay، تشخيص، صيانة وتحقق فقط — لا تحكم حي ولا مسار أسلحة"
    case "tr": return "Kullanım sınırı: farkındalık, eğitim, tekrar, tanı, bakım ve doğrulama — canlı kontrol veya silah yolu yok"
    case "es": return "Límite de uso: conciencia, formación, reproducción, diagnóstico, mantenimiento y verificación — sin control en vivo ni ruta de armas"
    case "de": return "Nutzungsgrenze: Lagebewusstsein, Training, Replay, Diagnose, Wartung und Verifikation — keine Live-Steuerung und kein Waffenpfad"
    case "it": return "Limite d’uso: consapevolezza, addestramento, replay, diagnostica, manutenzione e verifica — nessun controllo live o percorso armi"
    case "fr": return "Limite d’usage : connaissance de situation, formation, replay, diagnostic, maintenance et vérification — aucun contrôle réel ni chaîne d’armement"
    case "ur": return "استعمال کی حد: آگاہی، تربیت، ری پلے، تشخیص، دیکھ بھال اور تصدیق — کوئی لائیو کنٹرول یا ہتھیاروں کا راستہ نہیں"
    case "fa": return "مرز استفاده: آگاهی، آموزش، بازپخش، تشخیص، نگهداری و راستی‌آزمایی — بدون کنترل زنده یا مسیر تسلیحات"
    case "ru": return "Граница применения: ситуационная осведомлённость, обучение, replay, диагностика, обслуживание и верификация — без живого управления и оружейного контура"
    default: return "Use boundary: awareness, training, replay, diagnostics, maintenance and verification only — no live control and no weapons path"
    }
}
