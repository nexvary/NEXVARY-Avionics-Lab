#include "hmi/UiLocale.hpp"

namespace nexvary::avionics {
UiLanguage UiLocale::fromCode(std::string_view code) noexcept { return code == "ar" ? UiLanguage::Arabic : UiLanguage::English; }
bool UiLocale::isRtl(UiLanguage language) noexcept { return language == UiLanguage::Arabic; }
std::string UiLocale::text(UiLanguage language, std::string_view key) {
    const bool ar = language == UiLanguage::Arabic;
    if (key == "app_title") return ar ? "مختبر NEXVARY لإلكترونيات الطيران" : "NEXVARY AVIONICS LAB";
    if (key == "training") return ar ? "تدريب ومحاكاة" : "TRAINING / SIMULATION";
    if (key == "mfd") return ar ? "شاشة MFD" : "MFD";
    if (key == "systems") return ar ? "صحة الأنظمة" : "SYSTEM HEALTH";
    if (key == "alerts") return ar ? "الإنذارات" : "ALERTS";
    if (key == "sensors") return ar ? "الحساسات" : "SENSORS";
    if (key == "events") return ar ? "سجل الأحداث" : "EVENT LOG";
    if (key == "replay") return ar ? "مختبر الإعادة" : "REPLAY LAB";
    if (key == "trends") return ar ? "الاتجاهات" : "TRENDS";
    if (key == "digital_twin") return ar ? "التوأم الرقمي" : "DIGITAL TWIN";
    if (key == "power") return ar ? "الطاقة" : "POWER";
    if (key == "compute") return ar ? "الحوسبة" : "COMPUTE";
    if (key == "flight_sensors") return ar ? "حساسات الطيران" : "FLIGHT SENSORS";
    if (key == "hydraulics") return ar ? "الهيدروليك" : "HYDRAULICS";
    if (key == "fuel") return ar ? "الوقود" : "FUEL";
    if (key == "nominal") return ar ? "اسمي" : "NOMINAL";
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
    if (key == "scenario") return ar ? "السيناريو" : "SCENARIO";
    if (key == "tick") return ar ? "النبضة" : "TICK";
    if (key == "language") return ar ? "ENGLISH" : "العربية";
    if (key == "systems_nominal") return ar ? "جميع الأنظمة في الحالة الاسمية" : "SYSTEMS NOMINAL";
    if (key == "replay_mode") return ar ? "وضع إعادة التسجيل" : "REPLAY MODE";
    if (key == "active_alerts") return ar ? "الإنذارات النشطة" : "ACTIVE ALERTS";
    if (key == "recorded_frames") return ar ? "الإطارات المسجلة" : "RECORDED FRAMES";
    if (key == "sensor_count") return ar ? "عدد الحساسات" : "SENSOR COUNT";
    if (key == "event_count") return ar ? "عدد الأحداث" : "EVENT COUNT";
    if (key == "reset") return ar ? "إعادة ضبط" : "RESET";
    if (key == "back") return ar ? "رجوع" : "BACK";
    if (key == "enter_replay") return ar ? "بدء الإعادة" : "ENTER REPLAY";
    if (key == "exit_replay") return ar ? "خروج من الإعادة" : "EXIT REPLAY";
    if (key == "altitude_m") return ar ? "الارتفاع" : "ALTITUDE";
    if (key == "airspeed_kph") return ar ? "السرعة الجوية" : "AIRSPEED";
    if (key == "imu_pitch_deg") return ar ? "الميل الطولي" : "PITCH";
    if (key == "imu_roll_deg") return ar ? "الميل الجانبي" : "ROLL";
    if (key == "bus_voltage_v") return ar ? "ناقل الطاقة" : "POWER BUS";
    if (key == "cpu_temp_c") return ar ? "حرارة الحوسبة" : "COMPUTE TEMP";
    if (key == "hydraulic_pressure_pct") return ar ? "الهيدروليك" : "HYDRAULIC";
    if (key == "fuel_level_pct") return ar ? "الوقود" : "FUEL";
    if (key == "simulation_only") return ar ? "محاكاة تدريبية فقط - لا توجد واجهة تحكم بطائرة حقيقية" : "SIMULATION ONLY - NO LIVE AIRCRAFT CONTROL INTERFACE";
    return std::string(key);
}
} // namespace nexvary::avionics
