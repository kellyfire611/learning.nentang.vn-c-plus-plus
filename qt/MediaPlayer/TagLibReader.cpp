#include "songmodel.h"
#include "taglibreader.h"
#include <taglib/fileref.h>
#include <taglib/tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2tag.h>
#include <taglib/attachedpictureframe.h>
#include <QBuffer>
#include <QImage>
#include <QFile>

// Sửa return type: thêm TagLibReader::
TagLibReader::SongMetadata TagLibReader::readMetadata(const QString &filePath) {
    TagLibReader::SongMetadata metadata;

    QByteArray encodedFilePath = QFile::encodeName(filePath);
    TagLib::MPEG::File file(
#ifdef Q_OS_WIN
        reinterpret_cast<const wchar_t*>(encodedFilePath.constData())
#else
        encodedFilePath.constData()
#endif
        );

    if (!file.isValid()) return metadata;

    if (file.tag()) {
        TagLib::Tag *tag = file.tag();
        metadata.title = QString::fromStdString(tag->title().toCString());
        metadata.artist = QString::fromStdString(tag->artist().toCString());
        metadata.album = QString::fromStdString(tag->album().toCString());
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
