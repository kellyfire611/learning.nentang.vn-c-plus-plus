#include "xmlreader.h"
#include <QDebug>

XmlReader::XmlReader(QString filePath, ApplicationsModel &model)
{
    if (ReadXmlFile(filePath)) {
        PaserXml(model);
    } else {
        qDebug() << "Failed to read XML file:" << filePath;
    }
}

bool XmlReader::ReadXmlFile(QString filePath)
{
    QFile f(filePath);
    if (!f.open(QIODevice::ReadOnly)) {
        qDebug() << "Error opening file:" << filePath << f.errorString();
        return false;
    }
    if (!m_xmlDoc.setContent(&f)) {
        qDebug() << "Error parsing XML content from file:" << filePath;
        f.close();
        return false;
    }
    f.close();
    return true;
}

void XmlReader::PaserXml(ApplicationsModel &model)
{
    QDomElement root = m_xmlDoc.documentElement();
    QDomElement Component = root.firstChild().toElement();

    while (!Component.isNull()) {
        if (Component.tagName() == "APP") {
            QString ID = Component.attribute("ID", "No ID");
            QDomElement Child = Component.firstChild().toElement();

            QString title;
            QString url;
            QString iconPath;

            while (!Child.isNull()) {
                if (Child.tagName() == "TITLE") title = Child.firstChild().toText().data();
                if (Child.tagName() == "URL") url = Child.firstChild().toText().data();
                if (Child.tagName() == "ICON_PATH") iconPath = Child.firstChild().toText().data();
                Child = Child.nextSibling().toElement();
            }

            if (!title.isEmpty()) { // Chỉ thêm nếu title không rỗng
                qDebug() << "Adding application:" << title << url << iconPath;
                ApplicationItem item(title, url, iconPath);
                model.addApplication(item);
            } else {
                qDebug() << "Skipping application with ID" << ID << "due to missing title";
            }
        }
        Component = Component.nextSibling().toElement();
    }
}
