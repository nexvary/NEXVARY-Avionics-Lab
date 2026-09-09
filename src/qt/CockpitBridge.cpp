#include "qt/CockpitBridge.hpp"
#include "sim/ScenarioEngine.hpp"
#include <QVariantMap>
#include <algorithm>
#include <stdexcept>

namespace nexvary::avionics {
CockpitBridge::CockpitBridge(QObject* parent):QObject(parent),lab_(ScenarioKind::Nominal){refresh(lab_.step());}
QVariantList CockpitBridge::tiles()const{return tiles_;} QVariantList CockpitBridge::sensorRows()const{return sensorRows_;} QVariantList CockpitBridge::eventRows()const{return eventRows_;}
QStringList CockpitBridge::annunciators()const{return annunciators_;} QString CockpitBridge::scenario()const{return QString::fromUtf8(ScenarioEngine::toString(snapshot_.scenario));} qulonglong CockpitBridge::tick()const noexcept{return snapshot_.tick;}
int CockpitBridge::recordedFrames()const noexcept{return static_cast<int>(lab_.recorder().size());} int CockpitBridge::sensorCount()const noexcept{return static_cast<int>(snapshot_.sensors.size());} int CockpitBridge::eventCount()const noexcept{return static_cast<int>(lab_.eventLog().size());}
int CockpitBridge::activeAlertCount()const noexcept{int c=0;for(const auto&a:snapshot_.alerts)if(a.active)++c;return c;} bool CockpitBridge::replayMode()const noexcept{return replayMode_;} int CockpitBridge::replayIndex()const noexcept{return replayIndex_;} int CockpitBridge::replayMaximum()const noexcept{return lab_.recorder().size()?static_cast<int>(lab_.recorder().size()-1):0;}
QString CockpitBridge::language()const{return language_==UiLanguage::Arabic?QStringLiteral("ar"):QStringLiteral("en");} bool CockpitBridge::rtl()const noexcept{return UiLocale::isRtl(language_);} QStringList CockpitBridge::scenarios()const{QStringList r;for(const auto&n:ScenarioEngine::names())r.push_back(QString::fromStdString(n));return r;}
void CockpitBridge::step(){if(replayMode_){if(replayIndex_<replayMaximum())++replayIndex_;showReplayFrame();return;}refresh(lab_.step());}
void CockpitBridge::resetLab(){replayMode_=false;replayIndex_=0;lab_.reset();refresh(lab_.step());}
void CockpitBridge::setScenario(const QString&name){try{replayMode_=false;replayIndex_=0;lab_.setScenario(ScenarioEngine::fromName(name.toStdString()));lab_.reset();refresh(lab_.step());}catch(const std::invalid_argument&){}}
void CockpitBridge::setLanguage(const QString&code){auto next=UiLocale::fromCode(code.toStdString());if(next==language_)return;language_=next;refresh(snapshot_);emit languageChanged();}
QString CockpitBridge::text(const QString&key)const{return QString::fromStdString(UiLocale::text(language_,key.toStdString()));}
void CockpitBridge::setReplayMode(bool enabled){if(enabled&&lab_.recorder().size()==0)return;replayMode_=enabled;if(enabled){replayIndex_=0;showReplayFrame();}else refresh(lab_.snapshot());}
void CockpitBridge::seekReplay(int index){if(!replayMode_)return;replayIndex_=std::clamp(index,0,replayMaximum());showReplayFrame();}
void CockpitBridge::showReplayFrame(){auto f=lab_.recorder().frame(static_cast<std::size_t>(replayIndex_));if(!f)return;LabSnapshot r=snapshot_;r.tick=f->sequence;r.simTime=f->simTime;r.sensors=f->sensors;r.issues.clear();r.alerts.clear();refresh(r);}
void CockpitBridge::refresh(const LabSnapshot&s){snapshot_=s;auto page=viewModel_.build(snapshot_);tiles_.clear();for(const auto&t:page.tiles){QVariantMap i;i["id"]=QString::fromStdString(t.id);i["label"]=QString::fromStdString(UiLocale::text(language_,t.id));i["value"]=QString::fromStdString(t.value);i["state"]=QString::fromStdString(t.state);tiles_.push_back(i);}sensorRows_.clear();for(const auto&[name,sample]:snapshot_.sensors){QVariantMap i;i["id"]=QString::fromStdString(name);i["label"]=QString::fromStdString(UiLocale::text(language_,name));i["value"]=sample.value;i["unit"]=QString::fromStdString(sample.unit);i["valid"]=sample.valid;sensorRows_.push_back(i);}eventRows_.clear();for(const auto&e:lab_.eventLog().snapshot()){QVariantMap i;i["severity"]=QString::fromLatin1(to_string(e.severity));i["source"]=QString::fromStdString(e.source);i["message"]=QString::fromStdString(e.message);eventRows_.push_back(i);}annunciators_.clear();if(replayMode_)annunciators_.push_back(QString::fromStdString(UiLocale::text(language_,"replay_mode")));for(const auto&a:page.annunciators)annunciators_.push_back(QString::fromStdString(a=="SYSTEMS NOMINAL"?UiLocale::text(language_,"systems_nominal"):a));emit dataChanged();}
}
