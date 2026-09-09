#pragma once
#include "app/AvionicsLab.hpp"
#include "hmi/CockpitViewModel.hpp"
#include "hmi/UiLocale.hpp"
#include <QObject>
#include <QStringList>
#include <QVariantList>

namespace nexvary::avionics {

class CockpitBridge final : public QObject {
    Q_OBJECT
    Q_PROPERTY(QVariantList tiles READ tiles NOTIFY dataChanged)
    Q_PROPERTY(QStringList annunciators READ annunciators NOTIFY dataChanged)
    Q_PROPERTY(QString scenario READ scenario NOTIFY dataChanged)
    Q_PROPERTY(qulonglong tick READ tick NOTIFY dataChanged)
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)
    Q_PROPERTY(bool rtl READ rtl NOTIFY languageChanged)
    Q_PROPERTY(QStringList scenarios READ scenarios CONSTANT)

public:
    explicit CockpitBridge(QObject* parent = nullptr);

    [[nodiscard]] QVariantList tiles() const;
    [[nodiscard]] QStringList annunciators() const;
    [[nodiscard]] QString scenario() const;
    [[nodiscard]] qulonglong tick() const noexcept;
    [[nodiscard]] QString language() const;
    [[nodiscard]] bool rtl() const noexcept;
    [[nodiscard]] QStringList scenarios() const;

    Q_INVOKABLE void step();
    Q_INVOKABLE void setScenario(const QString& name);
    Q_INVOKABLE void setLanguage(const QString& code);
    Q_INVOKABLE QString text(const QString& key) const;

signals:
    void dataChanged();
    void languageChanged();

private:
    void refresh(const LabSnapshot& snapshot);

    AvionicsLab lab_;
    CockpitViewModel viewModel_;
    UiLanguage language_{UiLanguage::English};
    LabSnapshot snapshot_;
    QVariantList tiles_;
    QStringList annunciators_;
};

} // namespace nexvary::avionics
