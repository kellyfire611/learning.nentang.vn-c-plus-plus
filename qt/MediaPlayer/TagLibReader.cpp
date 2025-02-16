#include "taglibreader.h"
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#include <QBuffer>
#include <QImage>
#include <QFile>
#include <QTemporaryFile>
#include <QDebug>
#include <QThread>

// Sửa return type: thêm TagLibReader::
TagLibReader::SongMetadata TagLibReader::readMetadata(const QString &filePath) {
    TagLibReader::SongMetadata metadata;

    QString realPath = filePath;
    // // if(realPath.startsWith("qrc:/")) {
    //     // Đọc nội dung từ resource
    //     QFile resourceFile(realPath);
    //     if (!resourceFile.open(QIODevice::ReadOnly)) {
    //         qWarning() << "Không thể mở resource file:" << realPath;
    //         return metadata;
    //     }

    //     // Tạo file tạm
    //     QTemporaryFile tempFile;
    //     if (!tempFile.open()) {
    //         qWarning() << "Không thể tạo file tạm.";
    //         return metadata;
    //     }

    //     // Ghi dữ liệu vào file tạm
    //     tempFile.write(resourceFile.readAll());
    //     tempFile.flush();
    //     realPath = tempFile.fileName(); // Đường dẫn file thực tế
    //     tempFile.close();
    // // }

    // QFile::Permissions perms = tempFile.permissions();
    // qDebug() << "File permissions: " << perms;

    // Dùng TagLib để đọc file từ hệ thống
    // QThread::msleep(100);  // Chờ trước khi mở lại với TagLib
    TagLib::MPEG::File file(realPath.toUtf8().constData());
    if (!file.isValid()) return metadata;

    if (file.tag()) {
        TagLib::Tag *tag = file.tag();
        metadata.title = QString::fromStdString(tag->title().to8Bit(true).c_str());
        metadata.artist = QString::fromStdString(tag->artist().to8Bit(true).c_str());
        metadata.album = QString::fromStdString(tag->album().to8Bit(true).c_str());
    }

    if (file.ID3v2Tag()) {
        TagLib::ID3v2::FrameList frames = file.ID3v2Tag()->frameList("APIC");
        if (!frames.isEmpty()) {
            auto *pic = static_cast<TagLib::ID3v2::AttachedPictureFrame *>(frames.front());
            QImage image;
            image.loadFromData((const uchar *)pic->picture().data(), pic->picture().size());

            if (!image.isNull()) {
                QByteArray byteArray;
                QBuffer buffer(&byteArray);
                image.save(&buffer, "PNG");
                metadata.albumArt = "data:image/png;base64," + byteArray.toBase64();
            }
        }
    }

    return metadata;
}
