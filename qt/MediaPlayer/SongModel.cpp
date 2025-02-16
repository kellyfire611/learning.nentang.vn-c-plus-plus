#include "songmodel.h"
#include "taglibreader.h"
#include <QDir>
#include <QDirIterator>
#include <QFileInfo>
#include <QAudioOutput>  // Nếu dùng Qt 6
#include <QFile>
#include <QCoreApplication>
#include <QDebug>

SongModel::SongModel(QObject *parent) : QAbstractListModel(parent) {
    // Dữ liệu mẫu
    // SongInfo song = *new SongInfo();
    // song.title = "Phố Không Mùa";
    // song.album = "";
    // song.albumArt = "assets/img/Bui-Anh-Tuan.png";
    // song.artist = "Bùi Anh Tuấn";
    // song.filePath = "MediaPlayer/Music/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3";
    // m_songs.append(song);

    //     ListElement { title: "Phố Không Mùa"; singer: "Bùi Anh Tuấn" ; icon: "assets/img/Bui-Anh-Tuan.png"; source: "qrc:/Music/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3" }
    //     ListElement { title: "Chuyện Của Mùa Đông"; singer: "Hà Anh Tuấn" ; icon: "assets/img/Ha-Anh-Tuan.png"; source: "qrc:/Music/Chuyen-Cua-Mua-Dong-Ha-Anh-Tuan.mp3"}
    //     ListElement { title: "Hongkong1"; singer: "Nguyễn Trọng Tài" ; icon: "assets/img/Hongkong1.png"; source: "qrc:/Music/Hongkong1-Official-Version-Nguyen-Trong-Tai-San-Ji-Double-X.mp3" }

    m_audioOutput = new QAudioOutput(this);
    m_player = new QMediaPlayer(this);
    m_player->setAudioOutput(m_audioOutput);

    // Connect event
    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if(status == QMediaPlayer::LoadedMedia) {
            emit currentSongChanged();
        }
    });

    connect(m_player, &QMediaPlayer::playbackStateChanged, this, &SongModel::playbackStateChanged);

    connect(m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        if(status == QMediaPlayer::EndOfMedia) {
            if(m_repeat) {
                m_player->play();
            } else {
                next();
            }
        }
    });

    connect(m_player, &QMediaPlayer::positionChanged, this, &SongModel::positionChanged);
    connect(m_player, &QMediaPlayer::durationChanged, this, &SongModel::durationChanged);
}

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

// Hàm sao chép tất cả file từ resource "qrc:/music" sang thư mục cùng cấp với file .exe
bool copyMusicFilesFromResource(const QString &resourcePath, const QString &outputFolder) {
    QDir outputDir(outputFolder);

    // Tạo thư mục nếu chưa tồn tại
    if (!outputDir.exists()) {
        if (!outputDir.mkpath(".")) {
            qWarning() << "Không thể tạo thư mục:" << outputFolder;
            return false;
        }
    }

    // Lấy danh sách file từ resource
    QDir resourceDir(resourcePath);
    QStringList musicFiles = resourceDir.entryList(QDir::Files);

    bool success = true;
    for (const QString &fileName : musicFiles) {
        QString sourceFilePath = resourcePath + "/" + fileName;
        QString targetFilePath = outputFolder + "/" + fileName;

        QFile sourceFile(sourceFilePath);
        if (!sourceFile.open(QIODevice::ReadOnly)) {
            qWarning() << "Không thể mở file trong resource:" << sourceFilePath;
            success = false;
            continue;
        }

        QFile targetFile(targetFilePath);
        if (!targetFile.open(QIODevice::WriteOnly)) {
            qWarning() << "Không thể tạo file:" << targetFilePath;
            success = false;
            continue;
        }

        targetFile.write(sourceFile.readAll());
        sourceFile.close();
        targetFile.close();
        qDebug() << "Đã sao chép:" << targetFilePath;
    }

    return success;
}

// Hàm load các bài hát từ folder bất kỳ
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
    emit songCountChanged();  // Thông báo số lượng bài hát thay đổi
}

// Hàm load các bài hát từ folder bất kỳ
void SongModel::loadFolder(const QUrl &folderUrl) {
    beginResetModel();
    m_songs.clear();

    QString folderPath = folderUrl.toLocalFile();
    QDir dir(folderPath);

    // Lọc các định dạng file hỗ trợ
    QStringList filters;
    filters << "*.mp3" << "*.flac" << "*.wav" << "*.ogg";

    // Duyệt đệ quy thư mục
    QDirIterator it(folderPath, filters, QDir::Files, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        QString filePath = it.next();
        TagLibReader::SongMetadata metadata = TagLibReader::readMetadata(filePath);

        SongInfo song;
        song.title = metadata.title.isEmpty() ? QFileInfo(filePath).baseName() : metadata.title;
        song.artist = metadata.artist;
        song.album = metadata.album;
        song.filePath = filePath;
        song.albumArt = metadata.albumArt;

        m_songs.append(song);
    }

    endResetModel();
    emit songCountChanged();  // Thông báo số lượng bài hát thay đổi
}

// Hàm load các bài hát từ các file nhạc trong resource
void SongModel::loadResourceSongs() {
    beginResetModel();
    m_songs.clear();

    // Copy các file trong resource ra thành file tạm
    // Lấy đường dẫn thư mục của file .exe hiện tại
    QString exeDir = QCoreApplication::applicationDirPath();
    QString outputFolder = exeDir + "/musics"; // Tạo thư mục "musics" cùng cấp với file .exe
    QString resourcePath = "MediaPlayer/assets/musics";

    if (copyMusicFilesFromResource(resourcePath, outputFolder)) {
        qDebug() << "Tất cả file nhạc đã được xuất ra thư mục:" << outputFolder;
    } else {
        qWarning() << "Có lỗi khi sao chép file nhạc!";
    }

    // Duyệt các file trong thư mục đã sao chép ra
    QString folderPath = outputFolder;
    QDir dir(folderPath);

    // Lọc các định dạng file hỗ trợ
    QStringList filters;
    filters << "*.mp3" << "*.flac" << "*.wav" << "*.ogg";

    // Duyệt đệ quy thư mục
    QDirIterator it(folderPath, filters, QDir::Files, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        QString filePath = it.next();
        TagLibReader::SongMetadata metadata = TagLibReader::readMetadata(filePath);

        SongInfo song;
        song.title = metadata.title.isEmpty() ? QFileInfo(filePath).baseName() : metadata.title;
        song.artist = metadata.artist;
        song.album = metadata.album;
        song.filePath = filePath;
        song.albumArt = metadata.albumArt;

        m_songs.append(song);
    }

    // Duyệt các file trong resource
    // QDir resourceDir("MediaPlayer/assets/musics");
    // QDir resourceDir(outputFolder);
    // QStringList files = resourceDir.entryList(QStringList() << "*.mp3" << "*.wav" << "*.flac", QDir::Files);

    // foreach (const QString &file, files) {
    //     QString filePath = "MediaPlayer/assets/musics/" + file; // Đường dẫn resource

    //     // Đọc metadata
    //     TagLibReader::SongMetadata metadata = TagLibReader::readMetadata(filePath);

    //     SongInfo song;
    //     song.title = metadata.title.isEmpty() ? QFileInfo(file).baseName() : metadata.title;
    //     song.artist = metadata.artist;
    //     song.album = metadata.album;
    //     song.filePath = filePath;
    //     song.albumArt = metadata.albumArt;

    //     m_songs.append(song);
    // }

    endResetModel();
    emit songCountChanged();  // Thông báo số lượng bài hát thay đổi
}

void SongModel::playSong(int index) {
    if (index < 0 || index >= m_songs.size()) return;

    m_currentIndex = index;
    QString filePath = m_songs[index].filePath;
    QUrl fileUrl = QUrl::fromLocalFile(filePath);
    m_player->setSource(fileUrl);
    m_player->play();
    emit currentSongChanged();
    emit playbackStateChanged();
}

void SongModel::playPause() {
    if(m_player->playbackState() == QMediaPlayer::PlayingState) {
        m_player->pause();
    } else {
        m_player->play();
    }
    emit playbackStateChanged();
}

void SongModel::next() {
    if(m_songs.isEmpty()) return;

    if(m_shuffle) {
        if (m_shuffleList.isEmpty()) {
            // Tạo danh sách phát ngẫu nhiên mới nếu chưa có hoặc đã phát hết
            m_shuffleList.resize(m_songs.size());
            std::iota(m_shuffleList.begin(), m_shuffleList.end(), 0); // Tạo danh sách index [0,1,2,...]
            std::random_shuffle(m_shuffleList.begin(), m_shuffleList.end());
        }

        // Lấy index kế tiếp trong danh sách shuffle
        m_currentIndex = m_shuffleList.takeFirst();
    } else {
        m_currentIndex = (m_currentIndex + 1) % m_songs.size();
    }

    playSong(m_currentIndex);
    emit currentSongChanged();
}

void SongModel::previous() {
    if(m_songs.isEmpty()) return;

    m_currentIndex = (m_currentIndex - 1 + m_songs.size()) % m_songs.size();
    playSong(m_currentIndex);
    emit currentSongChanged();
}

void SongModel::toggleShuffle() {
    m_shuffle = !m_shuffle;
    if(m_shuffle) {
        // Tạo danh sách ngẫu nhiên
        m_shuffleList.resize(m_songs.size());
        std::iota(m_shuffleList.begin(), m_shuffleList.end(), 0);
        std::random_shuffle(m_shuffleList.begin(), m_shuffleList.end());
    } else {
        m_shuffleList.clear();
    }
    emit shuffleChanged();
}

void SongModel::toggleRepeat() {
    m_repeat = !m_repeat;
    emit repeatChanged();
}

QString SongModel::currentTitle() const {
    return (m_currentIndex >= 0 && m_currentIndex < m_songs.size())
    ? m_songs[m_currentIndex].title
    : tr("...");
}

QString SongModel::currentArtist() const {
    return (m_currentIndex >= 0 && m_currentIndex < m_songs.size())
    ? (m_songs[m_currentIndex].artist.isEmpty()
           ? tr("#")
           : m_songs[m_currentIndex].artist)
    : tr("#");
}

QString SongModel::currentAlbumArt() const {
    if(m_currentIndex >= 0 && m_currentIndex < m_songs.size()) {
        // Trả về đường dẫn ảnh nếu có, nếu không dùng ảnh mặc định
        return !m_songs[m_currentIndex].albumArt.isEmpty()
                   ? m_songs[m_currentIndex].albumArt
                   : "assets/img/no_album.jpg";
    }
    return "assets/img/no_album.jpg";
}

bool SongModel::isPlaying() const {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    return m_player->state() == QMediaPlayer::PlayingState;
#else
    return m_player->playbackState() == QMediaPlayer::PlayingState;
#endif
}

// Triển khai thêm các getters cho duration và position
qint64 SongModel::duration() const {
    return m_player->duration();
}

qint64 SongModel::position() const {
    return m_player->position();
}

// Triển khai getters
bool SongModel::shuffle() const {
    return m_shuffle;
}

bool SongModel::repeat() const {
    return m_repeat;
}

int SongModel::songCount() const {
    return rowCount(QModelIndex());
}

// Triển khai setters
void SongModel::setPosition(qint64 position) {
    if(position >= 0 && position <= m_player->duration()) {
        m_player->setPosition(position);
        emit positionChanged();
    }
}
