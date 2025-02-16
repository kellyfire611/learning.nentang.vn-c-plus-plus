#ifndef SONGMODEL_H
#define SONGMODEL_H

#include <QAbstractListModel>
#include <QMediaPlayer>
#include <QUrl>
#include <QDir>
#include <QTime>
#include <QAudioOutput>

#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
#include <QMediaMetaData>
#else
#include <QMediaContent>
#endif

struct SongInfo {
    QString title;
    QString artist;
    QString album;
    QString filePath;
    QString albumArt;
};

class SongModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentTitle READ currentTitle NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentArtist READ currentArtist NOTIFY currentSongChanged)
    Q_PROPERTY(QString currentAlbumArt READ currentAlbumArt NOTIFY currentSongChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY playbackStateChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(bool shuffle READ shuffle NOTIFY shuffleChanged)
    Q_PROPERTY(bool repeat READ repeat NOTIFY repeatChanged)
    Q_PROPERTY(int songCount READ rowCount NOTIFY songCountChanged)

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
    Q_INVOKABLE void loadFolder(const QUrl &folderUrl);
    Q_INVOKABLE void loadResourceSongs();
    Q_INVOKABLE void playSong(int index);
    Q_INVOKABLE void playPause();
    Q_INVOKABLE void next();
    Q_INVOKABLE void previous();
    Q_INVOKABLE void toggleShuffle();
    Q_INVOKABLE void toggleRepeat();
    Q_INVOKABLE void setPosition(qint64 position);

    QString currentTitle() const;
    QString currentArtist() const;
    QString currentAlbumArt() const;
    bool isPlaying() const;
    qint64 duration() const;
    qint64 position() const;
    bool shuffle() const;
    bool repeat() const;
    int songCount() const;
    int currentIndex() const { return m_currentIndex; }

signals:
    void currentSongChanged();
    void playbackStateChanged();
    void durationChanged();
    void positionChanged();
    void shuffleChanged();
    void repeatChanged();
    void songCountChanged();

private:
    QVector<SongInfo> m_songs;
    QMediaPlayer *m_player;
    QAudioOutput *m_audioOutput;  // Nếu dùng Qt 6
    int m_currentIndex = -1;
    bool m_shuffle = false;
    bool m_repeat = false;
    QVector<int> m_shuffleList;

    void generateShuffleList();
    QString formatTime(qint64 ms) const;
};

#endif // SONGMODEL_H
