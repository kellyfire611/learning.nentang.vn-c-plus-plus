import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import MediaPlayer 1.0

ApplicationWindow {
    width: 1920
    height: 1080
    visible: true
    // visibility: "FullScreen"
    // Khóa kích thước cửa sổ
    minimumWidth: 1920
    minimumHeight: 1080
    maximumWidth: 1920
    maximumHeight: 1080
    title: qsTr("Trình chơi Đa phương tiện")

    // Thêm property điều khiển
    property bool isPlaylistVisible: true
    property string currentLanguage: "vi_VN" // Mặc định là tiếng Việt

    // Events
    Component.onCompleted: {
        songModel.loadResourceSongs()
    }

    Connections {
        target: songModel
        onCurrentSongIndexChanged: {
            mediaPlaylist.currentIndex = songModel.currentSongIndex;
            album_art_view.currentIndex = songModel.currentSongIndex;
        }
    }

    // Model
    SongModel {
        id: songModel
    }

    // Media player
    MediaPlayer{
        id: player
        property bool shuffer: false
        loops: 0
        onPlaybackStateChanged: {
            if (playbackState == MediaPlayer.StoppedState && position == duration){
                if (player.shuffer) {
                    var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                    mediaPlaylist.currentIndex = newIndex
                } else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1) {
                    mediaPlaylist.currentIndex = mediaPlaylist.currentIndex + 1;
                }
            }
        }
        audioOutput: AudioOutput {
            id: audio
            volume: 100
        }

        source: mediaPlaylist.currentItem.myData.source
    }

    // Backgroud
    Image {
        id: backgroud
        anchors.fill: parent
        source: "assets/img/background.png"
    }

    // Header
    Image {
        id: headerItem
        source: "assets/img/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Trình chơi Đa phương tiện")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }

        // Thêm nút đổi ngôn ngữ trong header
        RowLayout {
            id: toggleTranslatorLayout
            anchors {
                right: headerItem.right
                verticalCenter: headerItem.verticalCenter
                margins: 20
            }
            spacing: 6
            RowLayout {
                spacing: 10

                ButtonGroup { id: languageGroup }

                ToolButton {
                    id: vietnamButton
                    checkable: true
                    checked: currentLanguage === "vi_VN" ? true : false
                    ButtonGroup.group: languageGroup
                    icon.source: "assets/img/vietnam.png"
                    icon.width: 40
                    icon.height: 40
                    width: 60
                    height: 60
                    onClicked: {
                        currentLanguage = "vi_VN";
                        languageManager.setCurrentLanguage(currentLanguage);
                        Qt.uiLanguage = currentLanguage;
                    }

                    background: Rectangle {
                        radius: 8
                        color: "transparent"
                        border.color: vietnamButton.checked ? "white" : "transparent"
                        border.width: 3
                    }
                }

                ToolButton {
                    id: usaButton
                    checkable: true
                    checked: currentLanguage === "en_US" ? true : false
                    ButtonGroup.group: languageGroup
                    icon.source: "assets/img/united-states.png"
                    icon.width: 40
                    icon.height: 40
                    width: 60
                    height: 60
                    onClicked: {
                        currentLanguage = "en_US";
                        languageManager.setCurrentLanguage(currentLanguage);
                        Qt.uiLanguage = currentLanguage;
                    }

                    background: Rectangle {
                        radius: 8
                        color: "transparent"
                        border.color: usaButton.checked ? "white" : "transparent"
                        border.width: 3
                    }
                }
            }
        }

        // Thêm nút toggle playlist trong header
        RowLayout {
            id: togglePlayListLayout
            anchors {
                left: headerItem.left
                verticalCenter: headerItem.verticalCenter
                margins: 20
            }
            spacing: 6
            RowLayout {
                spacing: 5

                ToolButton {
                    id: togglePlaylistButton
                    icon.source: isPlaylistVisible ? "assets/img/bars-solid.png" : "assets/img/angle-left-solid.png"
                    icon.width: 40
                    icon.height: 40
                    onClicked: {
                        isPlaylistVisible = !isPlaylistVisible
                    }
                    background: Rectangle {
                        color: "transparent"
                        radius: 5
                        border.color: togglePlaylistButton.hovered ? "white" : "transparent"
                        border.width: 2
                    }
                }

                Text {
                    id: playlistText
                    text: qsTr("Danh sách bài hát")
                    color: "white"
                    font.pixelSize: 46
                }
            }
        }
    }

    // Playlist
    Image {
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        source: "assets/img/playlist.png"
        opacity: 0.2
        width: isPlaylistVisible ? 675 : 0 // Thay đổi width theo trạng thái
        Behavior on width { NumberAnimation { duration: 300 } }
    }

    // ListView
    ListView {
        id: mediaPlaylist
        width: isPlaylistVisible ? 675 : 0 // Đồng bộ width với background
        Behavior on width { NumberAnimation { duration: 300 } }
        anchors.fill: playList_bg
        model: songModel
        clip: true
        spacing: 2
        currentIndex: songModel.currentIndex
        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            property int indexOfThisDelegate: index
            Image {
                id: playlistItem
                width: 675
                height: 193
                source: "assets/img/playlist.png"
                opacity: 0.5
            }
            Text {
                text: title
                anchors.fill: parent
                anchors.leftMargin: 70
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 32
            }
            onClicked: {
                songModel.playSong(index);
                album_art_view.currentIndex = index; // Cập nhật PathView
            }
            onPressed: {
                playlistItem.source = "assets/img/hold.png"
            }
            onReleased: {
                playlistItem.source = "assets/img/playlist.png"
            }
        }
        highlight: Image {
            source: "assets/img/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                source: "assets/img/playing.png"
            }
        }
        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
        onCurrentItemChanged: {
            album_art_view.currentIndex = mediaPlaylist.currentIndex;
        }
    }

    // Metadata Media Info
    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    // Title
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.left: isPlaylistVisible ? mediaPlaylist.right : parent.left // Điều chỉnh anchor
        anchors.leftMargin: 20
        text: songModel.currentTitle
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    // Singer
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: isPlaylistVisible ? mediaPlaylist.right : parent.left // Điều chỉnh anchor
        anchors.leftMargin: 20
        text: songModel.currentArtist
        color: "white"
        font.pixelSize: 32
    }
    // List count
    Text {
        id: audioCount
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: songModel.songCount
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: headerItem.bottom
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "assets/img/music.png"
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 100
        anchors.top: headerItem.bottom
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: songModel

        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        delegate: Item {
            property int indexArt: index

            width: 400; height: 400
            scale: PathView.iconScale
            z: PathView.iconScale // Item có iconScale lớn sẽ nổi lên trên

            Rectangle {
               anchors.fill: parent
               color: "transparent"
               border.color: PathView.iconScale >= 1.0 ? "white" : "black" // Viền trắng nếu là ảnh lớn nhất
               border.width: PathView.iconScale >= 1.0 ? 2 : 4
            }

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                source: albumArt
                Component.onCompleted: {
                    console.log("Image source:", source)
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    album_art_view.currentIndex = index
                    songModel.playSong(index)
                }
            }
        }
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = album_art_view.currentIndex;
        }
    }

    // Vị trí trong thời gian phát nhạc (realtime)
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: isPlaylistVisible ? mediaPlaylist.right : parent.left // Điều chỉnh anchor
        anchors.leftMargin: 120
        color: "white"
        font.pixelSize: 24
        text: formatTime(songModel.position)
        function formatTime(ms) {
            var seconds = Math.floor(ms/1000)
            return Math.floor(seconds/60) + ":" + ("0" + (seconds%60)).slice(-2)
        }
    }

    // Thanh tiến trình phát nhạc
    Slider{
        id: progressBar
        width: 816
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.left: currentTime.right
        anchors.leftMargin: 20
        from: 0
        to: songModel.duration
        value: songModel.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 200
            implicitHeight: 4
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 2
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 2
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "assets/img/point.png"
            Image {
                anchors.centerIn: parent
                source: "assets/img/center_point.png"
            }
        }
        onMoved: {
            songModel.setPosition(value)
        }
    }

    // Tổng thời gian bài hát
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: formatTime(songModel.duration)
        color: "white"
        font.pixelSize: 24
        function formatTime(ms) {
            var seconds = Math.floor(ms/1000)
            return Math.floor(seconds/60) + ":" + ("0" + (seconds%60)).slice(-2)
        }
    }

    // Media controls
    // Nút trộn bài hát
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        icon_off: "assets/img/shuffle.png"
        icon_on: "assets/img/shuffle-1.png"
        status: player.shuffer
        onClicked: {
            songModel.toggleShuffle()
        }
    }

    // Nút previous
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: shuffer.right
        anchors.leftMargin: 220
        icon_default: "assets/img/prev.png"
        icon_pressed: "assets/img/hold-prev.png"
        icon_released: "assets/img/prev.png"
        onClicked: {
            songModel.previous()
            album_art_view.currentIndex = mediaPlaylist.currentIndex = songModel.currentIndex;
        }
    }

    // Nút play/pause
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        // icon_default: player.playbackState == MediaPlayer.PlayingState ?  "assets/img/pause.png" : "assets/img/play.png"
        // icon_pressed: player.playbackState != MediaPlayer.PlayingState ?  "assets/img/hold-pause.png" : "assets/img/hold-play.png"
        // icon_released: player.playbackState == MediaPlayer.PlayingState ?   "assets/img/play.png" : "assets/img/pause.png"
        icon_default: songModel.isPlaying ? "assets/img/pause.png" : "assets/img/play.png"
        icon_pressed: songModel.isPlaying ? "assets/img/hold-pause.png" : "assets/img/hold-play.png"
        icon_released: songModel.isPlaying ? "assets/img/play.png" : "assets/img/pause.png"
        btnWidth: 120
        btnHeight: 120
        onClicked: {
            songModel.playPause()
        }
    }

    // Nút next
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "assets/img/next.png"
        icon_pressed: "assets/img/hold-next.png"
        icon_released: "assets/img/next.png"
        onClicked: {
            songModel.next()
            album_art_view.currentIndex = mediaPlaylist.currentIndex = songModel.currentIndex;
        }
    }

    // Nút repeat
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "assets/img/repeat1_hold.png"
        icon_off: "assets/img/repeat.png"
        property bool repeat: true
        onClicked: {
            songModel.toggleRepeat()
        }
    }
}
