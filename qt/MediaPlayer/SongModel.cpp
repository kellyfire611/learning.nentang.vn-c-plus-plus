#include "songmodel.h"
#include "taglibreader.h"

SongModel::SongModel(QObject *parent) : QAbstractListModel(parent) {}

int SongModel::rowCount(const QModelIndex &parent) const {
    return parent.isValid() ? 0 : m_songs.size();
}

QVariant SongModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_songs.size())
        return QVariant();

    const SongInfo &song = m_songs[index.row()];
    switch (role) {
    case TitleRole: return song.title;
    case ArtistRole: return song.artist;
    case AlbumRole: return song.album;
    case FilePathRole: return song.filePath;
    case AlbumArtRole: return song.albumArt;
    }
    return QVariant();
}

QHash<int, QByteArray> SongModel::roleNames() const {
    return {
        {TitleRole, "title"},
        {ArtistRole, "artist"},
        {AlbumRole, "album"},
        {FilePathRole, "filePath"},
        {AlbumArtRole, "albumArt"}
    };
}

void SongModel::loadSongs(const QList<QUrl> &urls) {
    beginResetModel();
    m_songs.clear();

    for (const QUrl &url : urls) {
        if (url.isLocalFile()) {
            TagLibReader::SongMetadata metadata = TagLibReader::readMetadata(url.toLocalFile());

            SongInfo song = *new SongInfo();
            song.title = metadata.title;
            song.album = metadata.albumArt;
            song.albumArt = metadata.albumArt;
            song.artist = metadata.artist;
            song.filePath = url.toLocalFile(); // lấy đường dẫn tuyệt đối
            m_songs.append(song);
        }
    }

    endResetModel();
}
