#include "LanguageManager.h"

LanguageManager::LanguageManager(QObject *parent) : QObject(parent), m_currentLanguage("vi") {}

QString LanguageManager::currentLanguage() const {
    return m_currentLanguage;
}

void LanguageManager::setCurrentLanguage(const QString &languageCode) {
    if (m_currentLanguage == languageCode) return;

    if (translator.load("MediaPlayer/translations/lang_" + languageCode + ".qm")) {
        QCoreApplication::installTranslator(&translator);
        m_currentLanguage = languageCode;
        emit languageChanged();
    }
}
