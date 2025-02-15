#ifndef SONGMODEL_H
#define SONGMODEL_H

#include <QAbstractListModel>
#include <QUrl>

struct SongInfo {
    QString title;
    QString artist;
    QString album;
    QUrl filePath;
    QString albumArt;
};

class SongModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        ArtistRole,
        AlbumRole,
        FilePathRole,
        AlbumArtRole
    };

    explicit SongModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void loadSongs(const QList<QUrl> &urls);

private:
    QList<SongInfo> m_songs;
};

#endif // SONGMODEL_H
