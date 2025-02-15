#ifndef TAGLIBREADER_H
#define TAGLIBREADER_H

#include <QString>

class TagLibReader {
public:
    struct SongMetadata {
        QString title;
        QString artist;
        QString album;
        QString albumArt;
    };

    static SongMetadata readMetadata(const QString &filePath);
};

#endif // TAGLIBREADER_H
