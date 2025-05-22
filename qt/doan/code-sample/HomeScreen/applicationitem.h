#ifndef APPLICATIONITEM_H
#define APPLICATIONITEM_H
#include <QString>

class ApplicationItem {
public:
    ApplicationItem(QString title, QString url, QString iconPath);

    QString title() const;

    QString url() const;

    QString iconPath() const;

private:
    QString m_title;
    QString m_url;
    QString m_iconPath;
};

#endif // APPLICATIONITEM_H
