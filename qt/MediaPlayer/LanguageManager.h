#ifndef LANGUAGEMANAGER_H
#define LANGUAGEMANAGER_H

#include <QObject>
#include <QTranslator>
#include <QGuiApplication>

class LanguageManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString currentLanguage READ currentLanguage WRITE setCurrentLanguage NOTIFY languageChanged)

public:
    explicit LanguageManager(QObject *parent = nullptr);

    QString currentLanguage() const;
    Q_INVOKABLE void setCurrentLanguage(const QString &languageCode);

signals:
    void languageChanged();

private:
    QTranslator translator;
    QString m_currentLanguage;
};

#endif // LANGUAGEMANAGER_H
