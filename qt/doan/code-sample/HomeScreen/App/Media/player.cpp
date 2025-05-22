#include "player.h"
#include "playlistmodel.h"
#include <QDir>
#include <QFileInfo>
#include <QRandomGenerator>
#include <QDebug>

Player::Player(QObject *parent) : QObject(parent)
{
    qDebug() << "Player constructor called";
    m_player = new QMediaPlayer(this);
    m_playlistModel = new PlaylistModel(this);

    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if (status == QMediaPlayer::EndOfMedia) {
            if (m_repeat) {
                m_player->setPosition(0);
                m_player->play();
            } else {
                playNext();
            }
        }
    });

    connect(m_player, &QMediaPlayer::errorOccurred, this, [this](QMediaPlayer::Error error, const QString &errorString) {
        qDebug() << "MediaPlayer error:" << error << errorString;
    });

    open();
    qDebug() << "Player open() called";

    if (!m_playlist.isEmpty()) {
        m_currentIndex = 0;
        m_player->setSource(m_playlist[m_currentIndex]);
        m_player->play();
        emit m_currentIndexChanged();
    } else {
        qDebug() << "Playlist is empty, m_currentIndex remains -1";
    }

    connect(m_player, &QMediaPlayer::durationChanged, this, &Player::durationChanged);
    connect(m_player, &QMediaPlayer::positionChanged, this, &Player::positionChanged);
}

void Player::open()
{
    qDebug() << "Entering Player::open()";
    // Tính đường dẫn từ thư mục build đến thư mục gốc của dự án
    QString buildDir = QDir::currentPath();
    QDir projectDir(buildDir);
    projectDir.cdUp(); // Lên 1 cấp: build/
    projectDir.cdUp(); // Lên 1 cấp nữa: HomeScreen/
    QDir musicDir(projectDir.absolutePath() + "/Musics");

    qDebug() << "Music directory:" << musicDir.absolutePath();
    if (!musicDir.exists()) {
        qDebug() << "Musics directory not found!";
        return;
    }

    QStringList filters = {"*.mp3"};
    QFileInfoList musics = musicDir.entryInfoList(filters, QDir::Files);
    qDebug() << "Found MP3 files:" << musics.size();
    if (musics.isEmpty()) {
        qDebug() << "No MP3 files found in Musics directory!";
        return;
    }

    QList<QUrl> urls;
    for (const QFileInfo &music : musics) {
        qDebug() << "Adding file:" << music.absoluteFilePath();
        urls.append(QUrl::fromLocalFile(music.absoluteFilePath()));
    }
    addToPlaylist(urls);
    qDebug() << "Exiting Player::open()";
}

void Player::addToPlaylist(const QList<QUrl> &urls)
{
    for (const QUrl &url : urls) {
        m_playlist.append(url);
        qDebug() << "Processing file:" << url.toLocalFile();
        TagLib::FileRef f(url.toLocalFile().toStdString().c_str());
        QString title, artist;
        if (!f.isNull() && f.tag()) {
            TagLib::Tag *tag = f.tag();
            title = QString::fromStdString(tag->title().to8Bit(true));
            artist = QString::fromStdString(tag->artist().to8Bit(true));
            qDebug() << "Title:" << title << "Artist:" << artist;
        } else {
            qDebug() << "Failed to read metadata for:" << url.toLocalFile();
        }

        // Nếu title hoặc artist rỗng, sử dụng tên file làm tiêu đề
        if (title.isEmpty()) {
            QFileInfo fileInfo(url.toLocalFile());
            title = fileInfo.fileName().remove(".mp3");
        }
        if (artist.isEmpty()) {
            artist = "Unknown Artist";
        }

        Song song(title, artist, url.toDisplayString(), getAlbumArt(url));
        m_playlistModel->addSong(song);
    }
    if (m_currentIndex == -1 && !m_playlist.isEmpty()) {
        m_currentIndex = 0;
        m_player->setSource(m_playlist[m_currentIndex]);
        m_player->play();
        emit m_currentIndexChanged();
    }
}

void Player::setCurrentIndex(int index)
{
    if (index >= 0 && index < m_playlist.size() && index != m_currentIndex) {
        m_currentIndex = index;
        m_player->setSource(m_playlist[m_currentIndex]);
        m_player->play();
        qDebug() << "Emitting m_currentIndexChanged with index:" << m_currentIndex;
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
            m_currentIndex = 0;
        } else {
            m_currentIndex++;
        }
    }

    m_player->setSource(m_playlist[m_currentIndex]);
    m_player->play();
    qDebug() << "Emitting m_currentIndexChanged with index:" << m_currentIndex;
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
    qDebug() << "Emitting m_currentIndexChanged with index:" << m_currentIndex;
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
    currentInfo = currentInfo / 1000;
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

void Player::shufflePlaylist()
{
    // Không cần triển khai vì bạn đã xử lý shuffle trong playNext/playPrevious
}
