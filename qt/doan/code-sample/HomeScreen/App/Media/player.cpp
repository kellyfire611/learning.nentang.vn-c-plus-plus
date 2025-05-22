#include "player.h"
#include "playlistmodel.h"
#include <QDir>
#include <QStandardPaths>
#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QRandomGenerator>

Player::Player(QObject *parent) : QObject(parent)
{
    m_player = new QMediaPlayer(this);
    m_playlistModel = new PlaylistModel(this);

    // Connect media status to handle end-of-media for playlist navigation
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::EndOfMedia) {
            if (m_repeat) {
                m_player->setPosition(0);
                m_player->play();
            } else {
                playNext(); // Auto-play next track when current one ends
            }
        }
    });

    // Initialize playlist by opening music directory
    open();
    if (!m_playlist.isEmpty()) {
        m_currentIndex = 0;
        m_player->setSource(m_playlist[m_currentIndex]);
    }

    connect(m_player, &QMediaPlayer::durationChanged, this, &Player::durationChanged);
    connect(m_player, &QMediaPlayer::positionChanged, this, &Player::positionChanged);
}

void Player::open()
{
    // Load music files from the standard music directory
    QDir directory(QStandardPaths::standardLocations(QStandardPaths::MusicLocation).value(0, QDir::homePath()));
    QStringList filters = {"*.mp3"};
    QFileInfoList musics = directory.entryInfoList(filters, QDir::Files);
    QList<QUrl> urls;
    for (const QFileInfo &music : musics) {
        urls.append(QUrl::fromLocalFile(music.absoluteFilePath()));
    }
    addToPlaylist(urls);
}

void Player::addToPlaylist(const QList<QUrl> &urls)
{
    for (const QUrl &url : urls) {
        m_playlist.append(url);
        TagLib::FileRef f(url.toLocalFile().toStdString().c_str());
        if (!f.isNull() && f.tag()) {
            TagLib::Tag *tag = f.tag();
            Song song(
                QString::fromStdString(tag->title().to8Bit(true)),
                QString::fromStdString(tag->artist().to8Bit(true)),
                url.toDisplayString(),
                getAlbumArt(url)
                );
            m_playlistModel->addSong(song); // Update UI model
        }
    }
    if (m_currentIndex == -1 && !m_playlist.isEmpty()) {
        m_currentIndex = 0;
        m_player->setSource(m_playlist[m_currentIndex]);
    }
}

void Player::setCurrentIndex(int index)
{
    if (index >= 0 && index < m_playlist.size() && index != m_currentIndex) {
        m_currentIndex = index;
        m_player->setSource(m_playlist[m_currentIndex]);
        m_player->play();
        emit m_currentIndexChanged();
    }
}

void Player::playNext()
{
    if (m_playlist.isEmpty()) return;

    if (m_shuffle) {
        int nextIndex = QRandomGenerator::global()->bounded(m_playlist.size());
        while (nextIndex == m_currentIndex && m_playlist.size() > 1) {
            nextIndex = QRandomGenerator::global()->bounded(m_playlist.size());
        }
        m_currentIndex = nextIndex;
    } else {
        if (m_currentIndex >= m_playlist.size() - 1) {
            m_currentIndex = 0; // Loop back to start
        } else {
            m_currentIndex++;
        }
    }

    m_player->setSource(m_playlist[m_currentIndex]);
    m_player->play();
    emit m_currentIndexChanged();
}

void Player::playPrevious()
{
    if (m_playlist.isEmpty() || m_currentIndex <= 0) return;

    if (m_shuffle) {
        int prevIndex = QRandomGenerator::global()->bounded(m_playlist.size());
        while (prevIndex == m_currentIndex && m_playlist.size() > 1) {
            prevIndex = QRandomGenerator::global()->bounded(m_playlist.size());
        }
        m_currentIndex = prevIndex;
    } else {
        m_currentIndex--;
    }

    m_player->setSource(m_playlist[m_currentIndex]);
    m_player->play();
    emit m_currentIndexChanged();
}

void Player::setShuffle(bool enabled)
{
    if (m_shuffle != enabled) {
        m_shuffle = enabled;
        emit shuffleChanged();
    }
}

void Player::setRepeat(bool enabled)
{
    if (m_repeat != enabled) {
        m_repeat = enabled;
        emit repeatChanged();
    }
}

QString Player::getTimeInfo(qint64 currentInfo)
{
    QString tStr = "00:00";
    currentInfo = currentInfo / 1000; // Convert ms to seconds
    qint64 duration = m_player->duration() / 1000;
    if (currentInfo || duration) {
        QTime currentTime((currentInfo / 3600) % 60, (currentInfo / 60) % 60, currentInfo % 60);
        QTime totalTime((duration / 3600) % 60, (duration / 60) % 60, duration % 60);
        QString format = duration > 3600 ? "hh:mm:ss" : "mm:ss";
        tStr = currentTime.toString(format);
    }
    return tStr;
}

QString Player::getAlbumArt(QUrl url)
{
    static const char *IdPicture = "APIC";
    TagLib::MPEG::File mpegFile(url.toLocalFile().toStdString().c_str());
    TagLib::ID3v2::Tag *id3v2tag = mpegFile.ID3v2Tag();
    if (id3v2tag) {
        TagLib::ID3v2::FrameList frame = id3v2tag->frameListMap()[IdPicture];
        if (!frame.isEmpty()) {
            for (auto it = frame.begin(); it != frame.end(); ++it) {
                auto *picFrame = static_cast<TagLib::ID3v2::AttachedPictureFrame*>(*it);
                QString outputFile = url.toLocalFile() + ".jpg";
                QFile file(outputFile);
                if (file.open(QIODevice::WriteOnly)) {
                    file.write(picFrame->picture().data(), picFrame->picture().size());
                    file.close();
                    return QUrl::fromLocalFile(outputFile).toDisplayString();
                }
            }
        }
    }
    qDebug() << "No ID3v2 tag or APIC frame found for" << url.toLocalFile();
    return "qrc:/App/Media/Image/album_art.png";
}
