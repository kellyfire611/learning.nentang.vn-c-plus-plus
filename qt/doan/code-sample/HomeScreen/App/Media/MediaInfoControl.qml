import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia

Item {
    // Tiêu đề bài hát
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.left: parent.left
        anchors.leftMargin: 14
        text: {
            if (playlistModel && playlistModel.rowCount() > 0 && album_art_view.currentIndex >= 0 && album_art_view.currentIndex < playlistModel.rowCount())
                return playlistModel.data(playlistModel.index(album_art_view.currentIndex, 0), 257) || "No Title"
            return "No Title"
        }
        color: "white"
        font.pixelSize: 26
        onTextChanged: {
            textChangeAni.targets = [audioTitle, audioSinger]
            textChangeAni.restart()
        }
    }

    // Tên nghệ sĩ
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: {
            if (playlistModel && playlistModel.rowCount() > 0 && album_art_view.currentIndex >= 0 && album_art_view.currentIndex < playlistModel.rowCount())
                return playlistModel.data(playlistModel.index(album_art_view.currentIndex, 0), 258) || "No Artist"
            return "No Artist"
        }
        color: "white"
        font.pixelSize: 23
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }

    // Số lượng bài hát
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 14
        anchors.right: parent.right
        anchors.rightMargin: 14
        text: playlistModel ? playlistModel.rowCount() : 0
        color: "white"
        font.pixelSize: 26
    }

    Image {
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 7
        source: "qrc:/App/Media/Image/music.png"
    }

    // Album art PathView
    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 284
            height: 284
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 14
                anchors.horizontalCenter: parent.horizontalCenter
                source: model.album_art || "qrc:/Img/HomeScreen/cover_art.jpg"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: album_art_view.currentIndex = index
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: parent.left
        anchors.leftMargin: (parent.width - 781) / 2
        anchors.top: parent.top
        anchors.topMargin: 213
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: playlistModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 7
            startY: 36
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 390; y: 36 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 781; y: 36 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        currentIndex: player ? player.m_currentIndex : -1

        onCurrentIndexChanged: {
            if (player && currentIndex >= 0 && currentIndex != player.m_currentIndex) {
                player.setCurrentIndex(currentIndex)
                var source = playlistModel.data(playlistModel.index(currentIndex, 0), 259) // SourceRole = 259
                if (source) {
                    mediaPlayer.setSource(source)
                    mediaPlayer.play()
                    console.log("PathView changed to index:", currentIndex, "Source:", source)
                }
            }
        }
    }

    // Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 178
        anchors.right: progressBar.left
        anchors.rightMargin: 20
        text: player ? player.getTimeInfo(mediaPlayer.position) : "00:00"
        color: "white"
        font.pixelSize: 17
    }

    Slider {
        id: progressBar
        width: 1059 - 479 * playlist.position
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 174
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: mediaPlayer.duration
        value: mediaPlayer.position
        background: Rectangle {
            x: progressBar.leftPadding
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            implicitWidth: 142
            implicitHeight: 3
            width: progressBar.availableWidth
            height: implicitHeight
            radius: 1
            color: "gray"

            Rectangle {
                width: progressBar.visualPosition * parent.width
                height: parent.height
                color: "white"
                radius: 1
            }
        }
        handle: Image {
            anchors.verticalCenter: parent.verticalCenter
            x: progressBar.leftPadding + progressBar.visualPosition * (progressBar.availableWidth - width)
            y: progressBar.topPadding + progressBar.availableHeight / 2 - height / 2
            source: "qrc:/App/Media/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/App/Media/Image/center_point.png"
            }
        }
        onMoved: {
            if (mediaPlayer.seekable) {
                mediaPlayer.setPosition(Math.floor(value))
            }
        }
    }

    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 178
        anchors.left: progressBar.right
        anchors.leftMargin: 14
        text: player ? player.getTimeInfo(mediaPlayer.duration) : "00:00"
        color: "white"
        font.pixelSize: 17
    }

    // Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 85
        anchors.left: currentTime.left
        icon_off: "qrc:/App/Media/Image/shuffle.png"
        icon_on: "qrc:/App/Media/Image/shuffle-1.png"
        status: player && player.shuffle ? 1 : 0
        onClicked: {
            if (player) {
                player.setShuffle(!player.shuffle)
                console.log("Shuffle:", player.shuffle)
            }
        }
    }

    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 85
        anchors.right: play.left
        icon_default: "qrc:/App/Media/Image/prev.png"
        icon_pressed: "qrc:/App/Media/Image/hold-prev.png"
        icon_released: "qrc:/App/Media/Image/prev.png"
        onClicked: {
            if (player) {
                player.playPrevious()
            }
        }
    }

    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        icon_default: mediaPlayer && mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        icon_pressed: mediaPlayer && mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/hold-pause.png" : "qrc:/App/Media/Image/hold-play.png"
        icon_released: mediaPlayer && mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        onClicked: {
            if (mediaPlayer) {
                if (mediaPlayer.playbackState != MediaPlayer.PlayingState) {
                    mediaPlayer.play()
                } else {
                    mediaPlayer.pause()
                }
            }
        }

        Connections {
            target: mediaPlayer
            function onPlaybackStateChanged() {
                play.source = mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
            }
        }
    }

    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 85
        anchors.left: play.right
        icon_default: "qrc:/App/Media/Image/next.png"
        icon_pressed: "qrc:/App/Media/Image/hold-next.png"
        icon_released: "qrc:/App/Media/Image/next.png"
        onClicked: {
            if (player) {
                player.playNext()
            }
        }
    }

    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 85
        anchors.right: totalTime.right
        icon_on: "qrc:/App/Media/Image/repeat1_hold.png"
        icon_off: "qrc:/App/Media/Image/repeat.png"
        status: player && player.repeat ? 1 : 0
        onClicked: {
            if (player) {
                player.setRepeat(!player.repeat)
                console.log("Repeat:", player.repeat)
            }
        }
    }

    Connections {
        target: player
        function onM_currentIndexChanged() {
            album_art_view.currentIndex = player.m_currentIndex
            console.log("MediaInfoControl updated currentIndex:", player.m_currentIndex)
        }
    }

    Component.onCompleted: {
        console.log("MediaInfoControl.qml loaded")
        console.log("Player:", player)
        console.log("PlaylistModel row count:", playlistModel ? playlistModel.rowCount() : "undefined")
    }
}
