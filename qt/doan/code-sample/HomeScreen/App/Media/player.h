#ifndef PLAYER_H
#define PLAYER_H

#include <QMediaPlayer>
#include <QUrl>
#include <QObject>
#include <taglib/tag.h>
#include <taglib/fileref.h>
#include <taglib/id3v2tag.h>
#include <taglib/mpegfile.h>
#include <taglib/id3v2frame.h>
#include <taglib/id3v2header.h>
#include <taglib/attachedpictureframe.h>

QT_BEGIN_NAMESPACE
class QAbstractItemView;
class QMediaPlayer;
QT_END_NAMESPACE

class PlaylistModel;
class Song;

class Player : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int m_currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY m_currentIndexChanged)
    Q_PROPERTY(bool shuffle READ shuffle WRITE setShuffle NOTIFY shuffleChanged)
    Q_PROPERTY(bool repeat READ repeat WRITE setRepeat NOTIFY repeatChanged)
    Q_PROPERTY(qint64 position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)

public:
    explicit Player(QObject *parent = nullptr);

    QMediaPlayer* mediaPlayer() const { return m_player; }

    int currentIndex() const { return m_currentIndex; }
    Q_INVOKABLE void setCurrentIndex(int index);

    bool shuffle() const { return m_shuffle; }
    Q_INVOKABLE void setShuffle(bool enabled);

    bool repeat() const { return m_repeat; }
    Q_INVOKABLE void setRepeat(bool enabled);

    qint64 position() const { return m_player->position(); }
    qint64 duration() const { return m_player->duration(); }

    void addToPlaylist(const QList<QUrl> &urls);
    Q_INVOKABLE void playNext();
    Q_INVOKABLE void playPrevious();

public slots:
    void open();
    QString getTimeInfo(qint64 currentInfo);

public:
    QString getAlbumArt(QUrl url);

    QMediaPlayer *m_player = nullptr;
    QList<QUrl> m_playlist;
    int m_currentIndex = -1;
    bool m_shuffle = false;
    bool m_repeat = false;
    PlaylistModel *m_playlistModel = nullptr;

signals:
    void m_currentIndexChanged();
    void shuffleChanged();
    void repeatChanged();
    void durationChanged();
    void positionChanged();

private:
    void shufflePlaylist();
};

#endif // PLAYER_H
