#include "hmi/UiLocale.hpp"

namespace nexvary::avionics {

UiLanguage UiLocale::fromCode(std::string_view code) noexcept {
    return code == "ar" ? UiLanguage::Arabic : UiLanguage::English;
}

bool UiLocale::isRtl(UiLanguage language) noexcept {
    return language == UiLanguage::Arabic;
}

std::string UiLocale::text(UiLanguage language, std::string_view key) {
    const bool ar = language == UiLanguage::Arabic;
    if (key == "app_title") return ar ? "مختبر NEXVARY لإلكترونيات الطيران" : "NEXVARY AVIONICS LAB";
    if (key == "training") return ar ? "تدريب ومحاكاة" : "TRAINING / SIMULATION";
    if (key == "mfd") return ar ? "شاشة MFD" : "MFD";
    if (key == "systems") return ar ? "الأنظمة" : "SYSTEMS";
    if (key == "alerts") return ar ? "الإنذارات" : "ALERTS";
    if (key == "scenario") return ar ? "السيناريو" : "SCENARIO";
    if (key == "tick") return ar ? "النبضة" : "TICK";
    if (key == "language") return ar ? "ENGLISH" : "العربية";
    if (key == "systems_nominal") return ar ? "جميع الأنظمة في الحالة الاسمية" : "SYSTEMS NOMINAL";
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
