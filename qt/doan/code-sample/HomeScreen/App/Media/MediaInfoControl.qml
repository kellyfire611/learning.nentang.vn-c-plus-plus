import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtMultimedia

Item {
    Text {
        id: audioTitle
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        text: //album_art_view.currentItem.myData.title
            playlistModel.rowCount() > album_art_view.currentIndex ?
            playlistModel.data(playlistModel.index(album_art_view.currentIndex, 0), playlistModel.TitleRole) : ""
        color: "white"
        font.pixelSize: 36
        onTextChanged: {
            textChangeAni.targets = [audioTitle,audioSinger]
            textChangeAni.restart()
        }
    }
    Text {
        id: audioSinger
        anchors.top: audioTitle.bottom
        anchors.left: audioTitle.left
        text: //album_art_view.currentItem.myData.singer
            playlistModel.rowCount() > album_art_view.currentIndex ?
            playlistModel.data(playlistModel.index(album_art_view.currentIndex, 0), playlistModel.SingerRole) : ""
        color: "white"
        font.pixelSize: 32
    }

    NumberAnimation {
        id: textChangeAni
        property: "opacity"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.InOutQuad
    }
    Text {
        id: audioCount
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: playlistModel.rowCount() //album_art_view.count
        color: "white"
        font.pixelSize: 36
    }
    Image {
        anchors.top: parent.top
        anchors.topMargin: 23
        anchors.right: audioCount.left
        anchors.rightMargin: 10
        source: "qrc:/App/Media/Image/music.png"
    }

    Component {
        id: appDelegate
        Item {
            property variant myData: model
            width: 400; height: 400
            scale: PathView.iconScale
            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20
                anchors.horizontalCenter: parent.horizontalCenter
                source: album_art
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
        anchors.leftMargin: (parent.width - 1100)/2
        anchors.top: parent.top
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: playlistModel // myModel
        delegate: appDelegate
        pathItemCount: 3
        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        currentIndex: player.m_currentIndex //player.playlist.currentIndex
        onCurrentIndexChanged: {
            // if (currentIndex != player.playlist.currentIndex) {
            //     player.playlist.currentIndex = currentIndex
            // }
            if (currentIndex != player.m_currentIndex) {
                player.m_currentIndex = currentIndex
                mediaPlayer.setSource(playlistModel.data(playlistModel.index(currentIndex, 0), playlistModel.SourceRole))
                mediaPlayer.play()
            }
        }
    }
    //Progress
    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.right: progressBar.left
        anchors.rightMargin: 20
        text: player.getTimeInfo(mediaPlayer.position) //utility.getTimeInfo(player.position)
        color: "white"
        font.pixelSize: 24
    }
    Slider{
        id: progressBar
        width: 1491 - 675*playlist.position
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: mediaPlayer.duration //player.duration
        value: mediaPlayer.position //player.position
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
            source: "qrc:/App/Media/Image/point.png"
            Image {
                anchors.centerIn: parent
                source: "qrc:/App/Media/Image/center_point.png"
            }
        }
        onMoved: {
            // if (player.seekable){
            //     player.setPosition(Math.floor(position*player.duration))
            // }
            if (mediaPlayer.seekable) {
                mediaPlayer.setPosition(Math.floor(value))
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: player.getTimeInfo(mediaPlayer.duration) //utility.getTimeInfo(player.duration)
        color: "white"
        font.pixelSize: 24
    }
    //Media control
    SwitchButton {
        id: shuffer
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: currentTime.left
        icon_off: "qrc:/App/Media/Image/shuffle.png"
        icon_on: "qrc:/App/Media/Image/shuffle-1.png"
        status: player.shuffle ? 1 : 0 // player.playlist.playbackMode === Playlist.Random ? 1 : 0
        onClicked: {
            // console.log(player.playlist.playbackMode)
            // if (player.playlist.playbackMode === Playlist.Random) {
            //     player.playlist.playbackMode = Playlist.Sequential
            // } else {
            //     player.playlist.playbackMode = Playlist.Random
            // }
            player.shuffle = !player.shuffle
        }
    }
    ButtonControl {
        id: prev
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: play.left
        icon_default: "qrc:/App/Media/Image/prev.png"
        icon_pressed: "qrc:/App/Media/Image/hold-prev.png"
        icon_released: "qrc:/App/Media/Image/prev.png"
        onClicked: {
            //player.playlist.previous()
            player.playPrevious()
        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        //icon_default: player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        //icon_pressed: player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/hold-pause.png" : "qrc:/App/Media/Image/hold-play.png"
        //icon_released: player.state== MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        icon_default: mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        icon_pressed: mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/hold-pause.png" : "qrc:/App/Media/Image/hold-play.png"
        icon_released: mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
        onClicked: {
            // if (player.state != MediaPlayer.PlayingState){
            //     player.play()
            // } else {
            //     player.pause()
            // }
            if (mediaPlayer.playbackState != MediaPlayer.PlayingState) {
                mediaPlayer.play()
            } else {
                mediaPlayer.pause()
            }
        }
        Connections {
            target: mediaPlayer// player
            // onStateChanged:{
            //     play.source = player.state == MediaPlayer.PlayingState ?  "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
            // }
            function onPlaybackStateChanged() {
                play.source = mediaPlayer.playbackState == MediaPlayer.PlayingState ? "qrc:/App/Media/Image/pause.png" : "qrc:/App/Media/Image/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "qrc:/App/Media/Image/next.png"
        icon_pressed: "qrc:/App/Media/Image/hold-next.png"
        icon_released: "qrc:/App/Media/Image/next.png"
        onClicked: {
            //player.playlist.next()
            player.playNext()
        }
    }
    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "qrc:/App/Media/Image/repeat1_hold.png"
        icon_off: "qrc:/App/Media/Image/repeat.png"
        status: player.repeat ? 1 : 0 //player.playlist.playbackMode === Playlist.Loop ? 1 : 0
        onClicked: {
            // console.log(player.playlist.playbackMode)
            // if (player.playlist.playbackMode === Playlist.Loop) {
            //     player.playlist.playbackMode = Playlist.Sequential
            // } else {
            //     player.playlist.playbackMode = Playlist.Loop
            // }
            player.repeat = !player.repeat
        }
    }

    Connections{
        target: player //player.playlist
        // onCurrentIndexChanged: {
        //     album_art_view.currentIndex = index;
        // }
        function onM_currentIndexChanged() {
            album_art_view.currentIndex = player.m_currentIndex
        }
    }
}
