#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractListModel>
#include <QString>

class Song
{
public:
    Song(const QString &title, const QString &singer, const QString &source, const QString &albumArt);

    QString title() const;
    QString singer() const;
    QString source() const;
    QString album_art() const;

private:
    QString m_title;
    QString m_singer;
    QString m_source;
    QString m_albumArt;
};

class PlaylistModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum SongRoles {
        TitleRole = Qt::UserRole + 1,
        SingerRole,
        SourceRole,
        AlbumArtRole
    };

    explicit PlaylistModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addSong(Song &song);

private:
    QList<Song> m_data;
};

#endif // PLAYLISTMODEL_H
