#include "hmi/UiLocale.hpp"
namespace nexvary::avionics {
UiLanguage UiLocale::fromCode(std::string_view code) noexcept{return code=="ar"?UiLanguage::Arabic:UiLanguage::English;}
bool UiLocale::isRtl(UiLanguage l) noexcept{return l==UiLanguage::Arabic;}
std::string UiLocale::text(UiLanguage l,std::string_view k){const bool ar=l==UiLanguage::Arabic;
if(k=="app_title")return ar?"مختبر NEXVARY لإلكترونيات الطيران":"NEXVARY AVIONICS LAB"; if(k=="training")return ar?"تدريب ومحاكاة":"TRAINING / SIMULATION";
if(k=="mfd")return ar?"شاشة MFD":"MFD"; if(k=="systems")return ar?"صحة الأنظمة":"SYSTEM HEALTH"; if(k=="alerts")return ar?"الإنذارات":"ALERTS"; if(k=="sensors")return ar?"الحساسات":"SENSORS"; if(k=="events")return ar?"سجل الأحداث":"EVENT LOG"; if(k=="replay")return ar?"مختبر الإعادة":"REPLAY LAB";
if(k=="scenario")return ar?"السيناريو":"SCENARIO"; if(k=="tick")return ar?"النبضة":"TICK"; if(k=="language")return ar?"ENGLISH":"العربية"; if(k=="systems_nominal")return ar?"جميع الأنظمة في الحالة الاسمية":"SYSTEMS NOMINAL"; if(k=="replay_mode")return ar?"وضع إعادة التسجيل":"REPLAY MODE";
if(k=="active_alerts")return ar?"الإنذارات النشطة":"ACTIVE ALERTS"; if(k=="recorded_frames")return ar?"الإطارات المسجلة":"RECORDED FRAMES"; if(k=="sensor_count")return ar?"عدد الحساسات":"SENSOR COUNT"; if(k=="event_count")return ar?"عدد الأحداث":"EVENT COUNT"; if(k=="reset")return ar?"إعادة ضبط":"RESET"; if(k=="back")return ar?"رجوع":"BACK"; if(k=="enter_replay")return ar?"بدء الإعادة":"ENTER REPLAY"; if(k=="exit_replay")return ar?"خروج من الإعادة":"EXIT REPLAY";
if(k=="altitude_m")return ar?"الارتفاع":"ALTITUDE"; if(k=="airspeed_kph")return ar?"السرعة الجوية":"AIRSPEED"; if(k=="imu_pitch_deg")return ar?"الميل الطولي":"PITCH"; if(k=="imu_roll_deg")return ar?"الميل الجانبي":"ROLL"; if(k=="bus_voltage_v")return ar?"ناقل الطاقة":"POWER BUS"; if(k=="cpu_temp_c")return ar?"حرارة الحوسبة":"COMPUTE TEMP"; if(k=="hydraulic_pressure_pct")return ar?"الهيدروليك":"HYDRAULIC"; if(k=="fuel_level_pct")return ar?"الوقود":"FUEL";
if(k=="simulation_only")return ar?"محاكاة تدريبية فقط - لا توجد واجهة تحكم بطائرة حقيقية":"SIMULATION ONLY - NO LIVE AIRCRAFT CONTROL INTERFACE";return std::string(k);}
}
