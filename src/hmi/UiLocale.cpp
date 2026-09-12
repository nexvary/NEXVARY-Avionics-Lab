#include "hmi/UiLocale.hpp"
#include <unordered_map>

namespace nexvary::avionics {
namespace {
using Dict = std::unordered_map<std::string_view, std::string_view>;

const Dict& chrome(UiLanguage language) {
    static const Dict tr{
        {"app_title","NEXVARY AVİYONİK LABORATUVARI"},{"training","EĞİTİM / SİMÜLASYON"},{"mfd","KOMUTA PANELİ"},{"systems","SİSTEM SAĞLIĞI"},{"alerts","UYARILAR"},{"sensors","SENSÖRLER"},{"events","OLAY KAYDI"},{"replay","YENİDEN OYNATMA"},{"trends","EĞİLİMLER"},{"digital_twin","DİJİTAL İKİZ"},{"platform_library","PLATFORM KÜTÜPHANESİ"},{"fault_lab","ARIZA LABORATUVARI"},{"diagnostic_center","TANI MERKEZİ"},{"verification_center","DOĞRULAMA MERKEZİ"},{"about_system","SİSTEM HAKKINDA"},{"about_us","HAKKIMIZDA"},{"back","GERİ"},{"language","DİL"},{"contact","İLETİŞİM"},{"social_links","SOSYAL MEDYA"},{"programming_languages","PROGRAMLAMA DİLLERİ"},{"technology_stack","TEKNOLOJİ YIĞINI"},{"about_nexvary_intro","NEXVARY, güvenli mühendislik, eğitim, analiz ve doğrulanabilir dijital ikiz iş akışları için ileri teknoloji sistemleri geliştirir."},{"about_nexvary_mission","Amaç: karmaşık sistemleri güvenli, izlenebilir ve karar vermeye uygun bir mühendislik ortamında anlaşılır hale getirmek."},{"about_nexvary_safety","Bu laboratuvar çevrimdışı ve sentetik eğitim/verifikasyon içindir; canlı uçak kontrol yolu içermez."}},
    es{
        {"app_title","LABORATORIO DE AVIÓNICA NEXVARY"},{"training","ENTRENAMIENTO / SIMULACIÓN"},{"mfd","PANEL DE MANDO"},{"systems","SALUD DEL SISTEMA"},{"alerts","ALERTAS"},{"sensors","SENSORES"},{"events","REGISTRO DE EVENTOS"},{"replay","REPRODUCCIÓN"},{"trends","TENDENCIAS"},{"digital_twin","GEMELO DIGITAL"},{"platform_library","BIBLIOTECA DE PLATAFORMAS"},{"fault_lab","LABORATORIO DE FALLOS"},{"diagnostic_center","CENTRO DE DIAGNÓSTICO"},{"verification_center","CENTRO DE VERIFICACIÓN"},{"about_system","ACERCA DEL SISTEMA"},{"about_us","SOBRE NOSOTROS"},{"back","VOLVER"},{"language","IDIOMA"},{"contact","CONTACTO"},{"social_links","REDES SOCIALES"},{"programming_languages","LENGUAJES DE PROGRAMACIÓN"},{"technology_stack","TECNOLOGÍAS"},{"about_nexvary_intro","NEXVARY desarrolla sistemas tecnológicos avanzados para ingeniería segura, formación, análisis y flujos de gemelo digital verificables."},{"about_nexvary_mission","Objetivo: convertir sistemas complejos en un entorno de ingeniería seguro, trazable y útil para la toma de decisiones."},{"about_nexvary_safety","Este laboratorio es para entrenamiento y verificación sintéticos sin conexión; no incluye control de aeronaves reales."}},
    de{
        {"app_title","NEXVARY AVIONIKLABOR"},{"training","TRAINING / SIMULATION"},{"mfd","KOMMANDOZENTRALE"},{"systems","SYSTEMZUSTAND"},{"alerts","WARNUNGEN"},{"sensors","SENSOREN"},{"events","EREIGNISPROTOKOLL"},{"replay","WIEDERGABE"},{"trends","TRENDS"},{"digital_twin","DIGITALER ZWILLING"},{"platform_library","PLATTFORMBIBLIOTHEK"},{"fault_lab","FEHLERLABOR"},{"diagnostic_center","DIAGNOSEZENTRUM"},{"verification_center","VERIFIKATIONSZENTRUM"},{"about_system","ÜBER DAS SYSTEM"},{"about_us","ÜBER UNS"},{"back","ZURÜCK"},{"language","SPRACHE"},{"contact","KONTAKT"},{"social_links","SOZIALE MEDIEN"},{"programming_languages","PROGRAMMIERSPRACHEN"},{"technology_stack","TECHNOLOGIE-STACK"},{"about_nexvary_intro","NEXVARY entwickelt fortschrittliche Technologiesysteme für sichere Technik, Training, Analyse und überprüfbare Digital-Twin-Arbeitsabläufe."},{"about_nexvary_mission","Ziel: komplexe Systeme in einer sicheren, nachvollziehbaren und entscheidungsorientierten Engineering-Umgebung verständlich machen."},{"about_nexvary_safety","Dieses Labor ist für Offline-, synthetisches Training und Verifikation bestimmt und enthält keine Live-Flugzeugsteuerung."}},
    it{
        {"app_title","LABORATORIO AVIONICO NEXVARY"},{"training","ADDESTRAMENTO / SIMULAZIONE"},{"mfd","PANNELLO DI COMANDO"},{"systems","STATO SISTEMI"},{"alerts","AVVISI"},{"sensors","SENSORI"},{"events","REGISTRO EVENTI"},{"replay","RIPRODUZIONE"},{"trends","TENDENZE"},{"digital_twin","GEMELLO DIGITALE"},{"platform_library","LIBRERIA PIATTAFORME"},{"fault_lab","LABORATORIO GUASTI"},{"diagnostic_center","CENTRO DIAGNOSTICO"},{"verification_center","CENTRO DI VERIFICA"},{"about_system","INFORMAZIONI SUL SISTEMA"},{"about_us","CHI SIAMO"},{"back","INDIETRO"},{"language","LINGUA"},{"contact","CONTATTI"},{"social_links","SOCIAL MEDIA"},{"programming_languages","LINGUAGGI DI PROGRAMMAZIONE"},{"technology_stack","STACK TECNOLOGICO"},{"about_nexvary_intro","NEXVARY sviluppa sistemi tecnologici avanzati per ingegneria sicura, formazione, analisi e flussi digital-twin verificabili."},{"about_nexvary_mission","Obiettivo: rendere comprensibili i sistemi complessi in un ambiente ingegneristico sicuro, tracciabile e orientato alle decisioni."},{"about_nexvary_safety","Questo laboratorio è destinato a formazione e verifica sintetica offline; non include controllo di aeromobili reali."}},
    fr{
        {"app_title","LABORATOIRE AVIONIQUE NEXVARY"},{"training","FORMATION / SIMULATION"},{"mfd","TABLEAU DE COMMANDE"},{"systems","SANTÉ SYSTÈME"},{"alerts","ALERTES"},{"sensors","CAPTEURS"},{"events","JOURNAL DES ÉVÉNEMENTS"},{"replay","RELECTURE"},{"trends","TENDANCES"},{"digital_twin","JUMEAU NUMÉRIQUE"},{"platform_library","BIBLIOTHÈQUE DE PLATEFORMES"},{"fault_lab","LABORATOIRE DE PANNES"},{"diagnostic_center","CENTRE DE DIAGNOSTIC"},{"verification_center","CENTRE DE VÉRIFICATION"},{"about_system","À PROPOS DU SYSTÈME"},{"about_us","À PROPOS DE NOUS"},{"back","RETOUR"},{"language","LANGUE"},{"contact","CONTACT"},{"social_links","RÉSEAUX SOCIAUX"},{"programming_languages","LANGAGES DE PROGRAMMATION"},{"technology_stack","PILE TECHNOLOGIQUE"},{"about_nexvary_intro","NEXVARY développe des systèmes technologiques avancés pour l’ingénierie sûre, la formation, l’analyse et des flux de jumeau numérique vérifiables."},{"about_nexvary_mission","Objectif : rendre les systèmes complexes compréhensibles dans un environnement d’ingénierie sûr, traçable et orienté décision."},{"about_nexvary_safety","Ce laboratoire est destiné à la formation et à la vérification synthétiques hors ligne ; il ne comporte aucun contrôle d’aéronef réel."}},
    ur{
        {"app_title","NEXVARY ایویونکس لیب"},{"training","تربیت / سمولیشن"},{"mfd","کمانڈ ڈیش بورڈ"},{"systems","نظام کی صحت"},{"alerts","انتباہات"},{"sensors","سینسرز"},{"events","واقعات کا ریکارڈ"},{"replay","ری پلے"},{"trends","رجحانات"},{"digital_twin","ڈیجیٹل ٹوئن"},{"platform_library","پلیٹ فارم لائبریری"},{"fault_lab","فالٹ لیب"},{"diagnostic_center","تشخیصی مرکز"},{"verification_center","تصدیقی مرکز"},{"about_system","نظام کے بارے میں"},{"about_us","ہمارے بارے میں"},{"back","واپس"},{"language","زبان"},{"contact","رابطہ"},{"social_links","سوشل میڈیا"},{"programming_languages","پروگرامنگ زبانیں"},{"technology_stack","ٹیکنالوجی اسٹیک"},{"about_nexvary_intro","NEXVARY محفوظ انجینئرنگ، تربیت، تجزیہ اور قابلِ تصدیق ڈیجیٹل ٹوئن ورک فلو کے لیے جدید ٹیکنالوجی سسٹمز تیار کرتا ہے۔"},{"about_nexvary_mission","مقصد: پیچیدہ نظاموں کو ایک محفوظ، قابلِ سراغ اور فیصلہ سازی کے لیے موزوں انجینئرنگ ماحول میں قابلِ فہم بنانا۔"},{"about_nexvary_safety","یہ لیب آف لائن مصنوعی تربیت اور تصدیق کے لیے ہے؛ اس میں حقیقی طیارے کے کنٹرول کا راستہ موجود نہیں۔"}},
    fa{
        {"app_title","آزمایشگاه اویونیک NEXVARY"},{"training","آموزش / شبیه‌سازی"},{"mfd","داشبورد فرمان"},{"systems","سلامت سامانه"},{"alerts","هشدارها"},{"sensors","حسگرها"},{"events","گزارش رویدادها"},{"replay","بازپخش"},{"trends","روندها"},{"digital_twin","دوقلوی دیجیتال"},{"platform_library","کتابخانه پلتفرم‌ها"},{"fault_lab","آزمایشگاه خطا"},{"diagnostic_center","مرکز تشخیص"},{"verification_center","مرکز راستی‌آزمایی"},{"about_system","درباره سامانه"},{"about_us","درباره ما"},{"back","بازگشت"},{"language","زبان"},{"contact","تماس"},{"social_links","شبکه‌های اجتماعی"},{"programming_languages","زبان‌های برنامه‌نویسی"},{"technology_stack","پشته فناوری"},{"about_nexvary_intro","NEXVARY سامانه‌های فناوری پیشرفته برای مهندسی ایمن، آموزش، تحلیل و گردش‌کارهای دوقلوی دیجیتال قابل‌راستی‌آزمایی توسعه می‌دهد."},{"about_nexvary_mission","هدف: قابل‌فهم کردن سامانه‌های پیچیده در یک محیط مهندسی ایمن، قابل‌ردیابی و مناسب تصمیم‌گیری."},{"about_nexvary_safety","این آزمایشگاه برای آموزش و راستی‌آزمایی مصنوعی و آفلاین است و مسیر کنترل زنده هواگرد ندارد."}},
    ru{
        {"app_title","АВИОНИЧЕСКАЯ ЛАБОРАТОРИЯ NEXVARY"},{"training","ОБУЧЕНИЕ / СИМУЛЯЦИЯ"},{"mfd","ПАНЕЛЬ УПРАВЛЕНИЯ"},{"systems","СОСТОЯНИЕ СИСТЕМ"},{"alerts","ПРЕДУПРЕЖДЕНИЯ"},{"sensors","ДАТЧИКИ"},{"events","ЖУРНАЛ СОБЫТИЙ"},{"replay","ВОСПРОИЗВЕДЕНИЕ"},{"trends","ТРЕНДЫ"},{"digital_twin","ЦИФРОВОЙ ДВОЙНИК"},{"platform_library","БИБЛИОТЕКА ПЛАТФОРМ"},{"fault_lab","ЛАБОРАТОРИЯ ОТКАЗОВ"},{"diagnostic_center","ЦЕНТР ДИАГНОСТИКИ"},{"verification_center","ЦЕНТР ВЕРИФИКАЦИИ"},{"about_system","О СИСТЕМЕ"},{"about_us","О НАС"},{"back","НАЗАД"},{"language","ЯЗЫК"},{"contact","КОНТАКТЫ"},{"social_links","СОЦИАЛЬНЫЕ СЕТИ"},{"programming_languages","ЯЗЫКИ ПРОГРАММИРОВАНИЯ"},{"technology_stack","ТЕХНОЛОГИЧЕСКИЙ СТЕК"},{"about_nexvary_intro","NEXVARY разрабатывает передовые технологические системы для безопасной инженерии, обучения, анализа и проверяемых рабочих процессов цифрового двойника."},{"about_nexvary_mission","Цель: сделать сложные системы понятными в безопасной, прослеживаемой и ориентированной на решения инженерной среде."},{"about_nexvary_safety","Лаборатория предназначена для автономного синтетического обучения и верификации и не содержит канала управления реальным воздушным судном."}};
    switch (language) {
        case UiLanguage::Turkish: return tr;
        case UiLanguage::Spanish: return es;
        case UiLanguage::German: return de;
        case UiLanguage::Italian: return it;
        case UiLanguage::French: return fr;
        case UiLanguage::Urdu: return ur;
        case UiLanguage::Persian: return fa;
        case UiLanguage::Russian: return ru;
        default: { static const Dict empty; return empty; }
    }
}

std::string localizedChrome(UiLanguage language, std::string_view key) {
    const auto& dict = chrome(language);
    const auto it = dict.find(key);
    return it == dict.end() ? std::string{} : std::string(it->second);
}
} // namespace

UiLanguage UiLocale::fromCode(std::string_view code) noexcept {
    if (code == "ar") return UiLanguage::Arabic;
    if (code == "tr") return UiLanguage::Turkish;
    if (code == "es") return UiLanguage::Spanish;
    if (code == "de") return UiLanguage::German;
    if (code == "it") return UiLanguage::Italian;
    if (code == "fr") return UiLanguage::French;
    if (code == "ur") return UiLanguage::Urdu;
    if (code == "fa") return UiLanguage::Persian;
    if (code == "ru") return UiLanguage::Russian;
    return UiLanguage::English;
}

std::string UiLocale::code(UiLanguage language) {
    switch (language) {
        case UiLanguage::Arabic: return "ar";
        case UiLanguage::Turkish: return "tr";
        case UiLanguage::Spanish: return "es";
        case UiLanguage::German: return "de";
        case UiLanguage::Italian: return "it";
        case UiLanguage::French: return "fr";
        case UiLanguage::Urdu: return "ur";
        case UiLanguage::Persian: return "fa";
        case UiLanguage::Russian: return "ru";
        default: return "en";
    }
}

bool UiLocale::isRtl(UiLanguage language) noexcept {
    return language == UiLanguage::Arabic || language == UiLanguage::Urdu || language == UiLanguage::Persian;
}

std::string UiLocale::text(UiLanguage language, std::string_view key) {
    if (language != UiLanguage::English && language != UiLanguage::Arabic) {
        const auto translated = localizedChrome(language, key);
        if (!translated.empty()) return translated;
        language = UiLanguage::English; // Technical avionics terminology has a controlled English fallback.
    }
    const bool ar = language == UiLanguage::Arabic;
    if (key == "app_title") return ar ? "مختبر NEXVARY لإلكترونيات الطيران" : "NEXVARY AVIONICS LAB";
    if (key == "training") return ar ? "تدريب ومحاكاة" : "TRAINING / SIMULATION";
    if (key == "mfd") return ar ? "لوحة القيادة" : "DASHBOARD";
    if (key == "systems") return ar ? "صحة الأنظمة" : "SYSTEM HEALTH";
    if (key == "alerts") return ar ? "الإنذارات" : "ALERTS";
    if (key == "sensors") return ar ? "المستشعرات" : "SENSORS";
    if (key == "events") return ar ? "سجل الأحداث" : "EVENT LOG";
    if (key == "replay") return ar ? "مختبر الإعادة" : "REPLAY LAB";
    if (key == "trends") return ar ? "الاتجاهات" : "TRENDS";
    if (key == "digital_twin") return ar ? "التوأم الرقمي" : "DIGITAL TWIN";
    if (key == "platform_library") return ar ? "مكتبة المنصات" : "PLATFORM LIBRARY";
    if (key == "fault_lab") return ar ? "مختبر الأعطال" : "FAULT LAB";
    if (key == "diagnostic_center") return ar ? "مركز التشخيص" : "DIAGNOSTIC CENTER";
    if (key == "verification_center") return ar ? "مركز التحقق" : "VERIFICATION CENTER";
    if (key == "about_system") return ar ? "حول النظام" : "ABOUT SYSTEM";
    if (key == "about_us") return ar ? "عنا" : "ABOUT US";
    if (key == "contact") return ar ? "التواصل" : "CONTACT";
    if (key == "social_links") return ar ? "روابط التواصل الاجتماعي" : "SOCIAL LINKS";
    if (key == "programming_languages") return ar ? "لغات البرمجة المستخدمة" : "PROGRAMMING LANGUAGES";
    if (key == "technology_stack") return ar ? "التقنيات المستخدمة" : "TECHNOLOGY STACK";
    if (key == "about_nexvary_intro") return ar ? "تطوّر NEXVARY أنظمة تقنية متقدمة للهندسة الآمنة والتدريب والتحليل ومسارات التوأم الرقمي القابلة للتحقق." : "NEXVARY develops advanced technology systems for safe engineering, training, analysis and verifiable digital-twin workflows.";
    if (key == "about_nexvary_mission") return ar ? "الهدف: تحويل الأنظمة المعقدة إلى بيئة هندسية مفهومة وآمنة وقابلة للتتبع وداعمة لاتخاذ القرار." : "Mission: make complex systems understandable inside a safe, traceable and decision-oriented engineering environment.";
    if (key == "about_nexvary_safety") return ar ? "هذا المختبر مخصص للتدريب والتحقق الاصطناعي دون اتصال، ولا يحتوي مسار تحكم بطائرة حقيقية." : "This lab is for offline synthetic training and verification and contains no live-aircraft control path.";
    if (key == "system_readiness") return ar ? "جاهزية النظام" : "SYSTEM READINESS";
    if (key == "verification_status") return ar ? "حالة التحقق" : "VERIFICATION STATUS";
    if (key == "runtime_verification") return ar ? "تحقق لحظي من سلامة حالة المحاكاة" : "LIVE SIMULATION CONSISTENCY CHECK";
    if (key == "no_active_alerts") return ar ? "لا توجد تنبيهات نشطة" : "NO ACTIVE ALERTS";
    if (key == "attention_required") return ar ? "توجد حالة تحتاج إلى انتباه" : "ATTENTION REQUIRED";
    if (key == "session_data") return ar ? "بيانات الجلسة الحالية" : "CURRENT SESSION DATA";
    if (key == "telemetry_health") return ar ? "سلامة القياسات" : "TELEMETRY HEALTH";
    if (key == "data_quality") return ar ? "جودة البيانات" : "DATA QUALITY";
    if (key == "digital_twin_aircraft") return ar ? "التوأم الرقمي لمنظومة الطيران" : "DIGITAL TWIN — AIRCRAFT SYSTEMS";
    if (key == "primary_flight_display") return ar ? "شاشة العرض الرئيسية" : "PRIMARY FLIGHT DISPLAY";
    if (key == "recent_events") return ar ? "أحدث الأحداث والتنبيهات" : "RECENT EVENTS & ALERTS";
    if (key == "training_scenario") return ar ? "معلومات السيناريو التدريبي" : "TRAINING SCENARIO";
    if (key == "scenario_description") return ar ? "سيناريو محاكاة اصطناعي متكرر لاختبار القياسات وصحة الأنظمة والاستجابة للأعطال." : "Deterministic synthetic scenario for telemetry, health monitoring and fault-response verification.";
    if (key == "system_performance") return ar ? "مخطط أداء الأنظمة" : "SYSTEM PERFORMANCE";
    if (key == "active") return ar ? "نشط" : "ACTIVE";
    if (key == "power") return ar ? "الطاقة" : "POWER";
    if (key == "compute") return ar ? "الحوسبة" : "COMPUTE";
    if (key == "flight_sensors") return ar ? "مستشعرات الطيران" : "FLIGHT SENSORS";
    if (key == "hydraulics") return ar ? "الهيدروليك" : "HYDRAULICS";
    if (key == "fuel") return ar ? "الوقود" : "FUEL";
    if (key == "propulsion") return ar ? "الدفع" : "PROPULSION";
    if (key == "rotor") return ar ? "الدوار" : "ROTOR";
    if (key == "energy") return ar ? "الطاقة المخزنة" : "ENERGY";
    if (key == "datalink") return ar ? "وصلة البيانات" : "DATA LINK";
    if (key == "navigation") return ar ? "الملاحة" : "NAVIGATION";
    if (key == "nominal") return ar ? "طبيعي" : "NOMINAL";
    if (key == "degraded") return ar ? "متدهور" : "DEGRADED";
    if (key == "fault") return ar ? "عطل" : "FAULT";
    if (key == "unknown") return ar ? "غير معروف" : "UNKNOWN";
    if (key == "channels") return ar ? "القنوات" : "CHANNELS";
    if (key == "issues") return ar ? "الملاحظات" : "ISSUES";
    if (key == "health") return ar ? "الصحة" : "HEALTH";
    if (key == "window") return ar ? "نافذة التحليل" : "ANALYSIS WINDOW";
    if (key == "latest") return ar ? "الأحدث" : "LATEST";
    if (key == "mean") return ar ? "المتوسط" : "MEAN";
    if (key == "delta") return ar ? "التغير" : "DELTA";
    if (key == "slope") return ar ? "المعدل/ث" : "SLOPE/S";
    if (key == "quality") return ar ? "جودة البيانات" : "DATA QUALITY";
    if (key == "minimum") return ar ? "الأدنى" : "MIN";
    if (key == "maximum") return ar ? "الأقصى" : "MAX";
    if (key == "scenario") return ar ? "السيناريو الحالي" : "CURRENT SCENARIO";
    if (key == "tick") return ar ? "النبضة" : "TICK";
    if (key == "language") return ar ? "اللغة" : "LANGUAGE";
    if (key == "systems_nominal") return ar ? "جميع الأنظمة تعمل بشكل طبيعي" : "ALL SYSTEMS NOMINAL";
    if (key == "replay_mode") return ar ? "وضع إعادة التسجيل" : "REPLAY MODE";
    if (key == "active_alerts") return ar ? "التنبيهات النشطة" : "ACTIVE ALERTS";
    if (key == "active_training_faults") return ar ? "أعطال التدريب النشطة" : "ACTIVE TRAINING FAULTS";
    if (key == "recorded_frames") return ar ? "الإطارات المسجلة" : "RECORDED FRAMES";
    if (key == "sensor_count") return ar ? "عدد المستشعرات" : "SENSOR COUNT";
    if (key == "event_count") return ar ? "عدد الأحداث" : "EVENT COUNT";
    if (key == "reset") return ar ? "إعادة ضبط" : "RESET";
    if (key == "back") return ar ? "رجوع" : "BACK";
    if (key == "enter_replay") return ar ? "بدء الإعادة" : "ENTER REPLAY";
    if (key == "exit_replay") return ar ? "خروج من الإعادة" : "EXIT REPLAY";
    if (key == "apply_fault") return ar ? "تطبيق العطل" : "APPLY FAULT";
    if (key == "clear_faults") return ar ? "مسح الأعطال" : "CLEAR FAULTS";
    if (key == "fault_imu_dropout") return ar ? "فقد مستشعر الميل الطولي" : "IMU PITCH DROPOUT";
    if (key == "fault_imu_dropout_detail") return ar ? "يجعل قناة الميل الطولي غير صالحة داخل المحاكاة فقط." : "Marks the synthetic pitch channel invalid for training.";
    if (key == "fault_low_power") return ar ? "انخفاض ناقل الطاقة" : "LOW POWER BUS";
    if (key == "fault_low_power_detail") return ar ? "يضبط جهد ناقل الطاقة الاصطناعي على قيمة منخفضة تدريبية." : "Overrides the synthetic power bus with a bounded low-voltage training value.";
    if (key == "fault_compute_hot") return ar ? "ارتفاع حرارة الحوسبة" : "COMPUTE OVER-TEMPERATURE";
    if (key == "fault_compute_hot_detail") return ar ? "يضبط حرارة الحوسبة الاصطناعية أعلى من حد التحذير التدريبي." : "Overrides synthetic compute temperature above the training warning threshold.";
    if (key == "fault_jet_engine_low") return ar ? "انخفاض مؤشر قلب المحرك النفاث" : "JET CORE INDICATION LOW";
    if (key == "fault_jet_engine_low_detail") return ar ? "يخفض مؤشر قلب المحرك الاصطناعي لاختبار التشخيص." : "Lowers the synthetic jet-core indication for diagnostic training.";
    if (key == "fault_jet_hydraulic_low") return ar ? "انخفاض هيدروليك الطائرة النفاثة" : "JET HYDRAULIC LOW";
    if (key == "fault_jet_hydraulic_low_detail") return ar ? "يخفض ضغط الهيدروليك ضمن سيناريو تدريبي مضبوط." : "Applies a bounded low hydraulic-pressure training condition.";
    if (key == "fault_turboprop_torque_low") return ar ? "انخفاض عزم التوربوبروب" : "TURBOPROP TORQUE LOW";
    if (key == "fault_turboprop_torque_low_detail") return ar ? "يخفض مؤشر العزم الاصطناعي للتدريب التشخيصي." : "Lowers synthetic turboprop torque indication for diagnostics.";
    if (key == "fault_prop_rpm_low") return ar ? "انخفاض سرعة المروحة" : "PROP RPM LOW";
    if (key == "fault_prop_rpm_low_detail") return ar ? "يخفض مؤشر سرعة المروحة الاصطناعي." : "Lowers the synthetic propeller RPM indication.";
    if (key == "fault_rotor_rpm_low") return ar ? "انخفاض سرعة الدوار" : "ROTOR RPM LOW";
    if (key == "fault_rotor_rpm_low_detail") return ar ? "يخفض مؤشر سرعة الدوار الاصطناعي." : "Lowers the synthetic rotor RPM indication.";
    if (key == "fault_helicopter_hydraulic_low") return ar ? "انخفاض هيدروليك المروحية" : "HELICOPTER HYDRAULIC LOW";
    if (key == "fault_helicopter_hydraulic_low_detail") return ar ? "يخفض ضغط الهيدروليك في ملف المروحية التدريبي." : "Applies low hydraulic pressure in the rotorcraft training profile.";
    if (key == "fault_uav_battery_low") return ar ? "انخفاض بطارية المنصة غير المأهولة" : "UAV BATTERY LOW";
    if (key == "fault_uav_battery_low_detail") return ar ? "يخفض حالة شحن البطارية الاصطناعية." : "Lowers the synthetic UAV battery state of charge.";
    if (key == "fault_uav_link_degrade") return ar ? "تدهور وصلة البيانات" : "UAV DATA LINK DEGRADED";
    if (key == "fault_uav_link_degrade_detail") return ar ? "يخفض جودة وصلة البيانات الاصطناعية." : "Degrades the synthetic UAV data-link quality.";
    if (key == "fault_uav_nav_degrade") return ar ? "تدهور جودة الملاحة" : "UAV NAVIGATION DEGRADED";
    if (key == "fault_uav_nav_degrade_detail") return ar ? "يخفض جودة الملاحة الاصطناعية." : "Degrades the synthetic UAV navigation-quality channel.";
    if (key == "fault_lab_notice") return ar ? "أعطال تدريبية محددة وقابلة للتدقيق فقط؛ لا توجد قيم عشوائية أو واجهة تحكم بطائرة حقيقية." : "Bounded, auditable training faults only; no arbitrary values and no live-aircraft control path.";
    if (key == "altitude_m") return ar ? "الارتفاع" : "ALTITUDE";
    if (key == "airspeed_kph") return ar ? "السرعة الجوية" : "AIRSPEED";
    if (key == "imu_pitch_deg") return ar ? "الميل الطولي" : "PITCH";
    if (key == "imu_roll_deg") return ar ? "الميل الجانبي" : "ROLL";
    if (key == "bus_voltage_v") return ar ? "جهد ناقل الطاقة" : "POWER BUS";
    if (key == "cpu_temp_c") return ar ? "حرارة الحوسبة" : "COMPUTE TEMP";
    if (key == "hydraulic_pressure_pct") return ar ? "ضغط الهيدروليك" : "HYDRAULIC";
    if (key == "fuel_level_pct") return ar ? "مستوى الوقود" : "FUEL";
    if (key == "jet_engine_core_pct") return ar ? "مؤشر قلب المحرك" : "JET CORE";
    if (key == "turboprop_torque_pct") return ar ? "عزم التوربوبروب" : "TURBOPROP TORQUE";
    if (key == "prop_rpm_pct") return ar ? "سرعة المروحة" : "PROP RPM";
    if (key == "rotor_rpm_pct") return ar ? "سرعة الدوار" : "ROTOR RPM";
    if (key == "battery_soc_pct") return ar ? "شحن البطارية" : "BATTERY SOC";
    if (key == "link_quality_pct") return ar ? "جودة وصلة البيانات" : "LINK QUALITY";
    if (key == "nav_quality_pct") return ar ? "جودة الملاحة" : "NAV QUALITY";
    if (key == "simulation_only") return ar ? "محاكاة تدريبية فقط — لا توجد واجهة تحكم بطائرة حقيقية" : "TRAINING AND SIMULATION ONLY — NO LIVE AIRCRAFT CONTROL INTERFACE";
    return std::string(key);
}
} // namespace nexvary::avionics
