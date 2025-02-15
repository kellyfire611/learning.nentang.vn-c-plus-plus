import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

Window {
    width: 1920
    height: 1080
    visible: true
    // visibility: "FullScreen"
    title: qsTr("Trình chơi Đa phương tiện")

    // Model
    ListModel {
        id: appModel
        ListElement { title: "Phố Không Mùa"; singer: "Bùi Anh Tuấn" ; icon: "assets/img/Bui-Anh-Tuan.png"; source: "qrc:/Music/Pho-Khong-Mua-Duong-Truong-Giang-ft-Bui-Anh-Tuan.mp3" }
        ListElement { title: "Chuyện Của Mùa Đông"; singer: "Hà Anh Tuấn" ; icon: "assets/img/Ha-Anh-Tuan.png"; source: "qrc:/Music/Chuyen-Cua-Mua-Dong-Ha-Anh-Tuan.mp3"}
        ListElement { title: "Hongkong1"; singer: "Nguyễn Trọng Tài" ; icon: "assets/img/Hongkong1.png"; source: "qrc:/Music/Hongkong1-Official-Version-Nguyen-Trong-Tai-San-Ji-Double-X.mp3" }
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

    //Backgroud
    Image {
        id: backgroud
        anchors.fill: parent
        source: "assets/img/background.png"
    }

    //Header
    Image {
        id: headerItem
        source: "assets/img/title.png"
        Text {
            id: headerTitleText
            text: qsTr("Media Player")
            anchors.centerIn: parent
            color: "white"
            font.pixelSize: 46
        }
    }

    //Playlist
    Image {
        id: playList_bg
        anchors.top: headerItem.bottom
        anchors.bottom: parent.bottom
        source: "assets/img/playlist.png"
        opacity: 0.2
    }

    // ListView
    ListView {
        id: mediaPlaylist
        anchors.fill: playList_bg
        model: appModel
        clip: true
        spacing: 2
        currentIndex: 0
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
                mediaPlaylist.currentIndex = indexOfThisDelegate
                album_art_view.currentIndex = indexOfThisDelegate
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
            player.source = mediaPlaylist.currentItem.myData.source;
            player.play();
            audioTitle.text = mediaPlaylist.currentItem.myData.title
            audioSinger.text = mediaPlaylist.currentItem.myData.singer
        }
    }

    //Media Info
    Text {
        id: audioTitle
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: "Phố không mùa"
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
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 20
        text: "Bùi Anh Tuấn"
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
        anchors.top: headerItem.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        text: appModel.count
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

    Component {
        id: appDelegate

        Item {
            property int indexArt: index

            width: 400; height: 400
            scale: PathView.iconScale

            Image {
                id: myIcon
                width: parent.width
                height: parent.height
                y: 20; anchors.horizontalCenter: parent.horizontalCenter
                source: icon
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    album_art_view.currentIndex = indexArt
                    mediaPlaylist.currentIndex = indexArt

                }
            }
        }
    }

    PathView {
        id: album_art_view
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 50
        anchors.top: headerItem.bottom
        anchors.topMargin: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        focus: true
        model: appModel
        delegate: appDelegate

        path: Path {
            startX: 10
            startY: 50
            PathAttribute { name: "iconScale"; value: 0.5 }
            PathLine { x: 550; y: 50 }
            PathAttribute { name: "iconScale"; value: 1.0 }
            PathLine { x: 1100; y: 50 }
            PathAttribute { name: "iconScale"; value: 0.5 }
        }
        onCurrentIndexChanged: {
//            album_art_view.currentIndex = indexOfThisDelegate
        }
    }
    //Progress
    function str_pad_left(string,pad,length) {
        return (new Array(length+1).join(pad)+string).slice(-length);
    }

    function getTime(time){
        time = time/1000
        var minutes = Math.floor(time / 60);
        var seconds = Math.floor(time - minutes * 60);

        return str_pad_left(minutes,'0',2)+':'+str_pad_left(seconds,'0',2);
    }

    Text {
        id: currentTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: mediaPlaylist.right
        anchors.leftMargin: 120
        text: getTime(player.position)
        color: "white"
        font.pixelSize: 24
    }
    Slider{
        id: progressBar
        width: 816
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 245
        anchors.left: currentTime.right
        anchors.leftMargin: 20
        from: 0
        to: 1.0
        value: player.position / player.duration
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
            if (player.seekable){
                player.setPosition(value * player.duration)
            }
        }
    }
    Text {
        id: totalTime
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 250
        anchors.left: progressBar.right
        anchors.leftMargin: 20
        text: getTime(player.duration)
        color: "white"
        font.pixelSize: 24
    }
    //Media control
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
            if (!player.shuffer) {
                player.shuffer = true
            } else {
                player.shuffer = false
            }
        }
    }
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
            if(mediaPlaylist.currentIndex > 0){
                mediaPlaylist.currentIndex = (mediaPlaylist.currentIndex) - 1
                album_art_view.currentIndex = (album_art_view.currentIndex) - 1
                audioTitle.text = title
                audioSinger.text = singer
            }

        }
    }
    ButtonControl {
        id: play
        anchors.verticalCenter: prev.verticalCenter
        anchors.left: prev.right
        icon_default: player.playbackState == MediaPlayer.PlayingState ?  "assets/img/pause.png" : "assets/img/play.png"
        icon_pressed: player.playbackState != MediaPlayer.PlayingState ?  "assets/img/hold-pause.png" : "assets/img/hold-play.png"
        icon_released: player.playbackState == MediaPlayer.PlayingState ?   "assets/img/play.png" : "assets/img/pause.png"
        onClicked: {
            if(player.playbackState == MediaPlayer.PlayingState){
                player.pause()
            }
            else{
                player.play()
            }
        }
        Connections {
            target: player
            onPlaybackStateChanged:{
                play.source = player.state == MediaPlayer.PlayingState ?  "assets/img/pause.png" : "assets/img/play.png"
            }
        }
    }
    ButtonControl {
        id: next
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.left: play.right
        icon_default: "assets/img/next.png"
        icon_pressed: "assets/img/hold-next.png"
        icon_released: "assets/img/next.png"
        onClicked: {
            if (player.shuffer) {
                var newIndex = Math.floor(Math.random() * mediaPlaylist.count)
                mediaPlaylist.currentIndex = newIndex
            }
            else if(mediaPlaylist.currentIndex < mediaPlaylist.count - 1 && !player.shuffer) {
                mediaPlaylist.currentIndex = (mediaPlaylist.currentIndex) + 1
                album_art_view.currentIndex = (album_art_view.currentIndex) + 1
            }
        }
    }

    SwitchButton {
        id: repeater
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        anchors.right: totalTime.right
        icon_on: "assets/img/repeat1_hold.png"
        icon_off: "assets/img/repeat.png"
        property bool repeat: true
        onClicked: {
            if(repeat){
                player.loops = 1
            }
        }
    }
}
