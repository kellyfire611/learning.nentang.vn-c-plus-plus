import QtQuick 2.15
// import QtGraphicalEffects 1.15
import Qt5Compat.GraphicalEffects 6.0

MouseArea {
    id: root
    implicitWidth: 450 //635
    implicitHeight: 405 //570
    Rectangle {
        anchors{
            fill: parent
            margins: 7 //10
        }
        opacity: 0.7
        color: "#111419"
    }
    Image {
        id: bgBlur
        x: 7 //10
        y: 7 //10
        width: 436 //615
        height: 391 //550
        source: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
            else
                return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
    }
    FastBlur {
        anchors.fill: bgBlur
        source: bgBlur
        radius: 13 //18
    }
    Image {
        id: idBackgroud
        source: ""
        width: root.width
        height: root.height
    }
    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 28 //40
        text: "USB Music"
        color: "white"
        font.pixelSize: 24 //34
    }
    Image {
        id: bgInner
        x: 143 //201
        y: 85 //119
        width: 183 //258
        height: 183 //258
        source: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
            else
                return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
    }
    Image{
        x: 143 //201
        y: 85 //119
        width: 183 //258
        height: 183 //258
        source: "qrc:/Img/HomeScreen/widget_media_album_bg.png"
    }
    Text {
        id: txtSinger
        x: 30 //42
        y: 40+244 //(56+343)
        width: 551
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 258)
        }
        color: "white"
        font.pixelSize: 21 //30
    }
    Text {
        id: txtTitle
        x: 30 //42
        y: 40+244+39 //(56+343+55)
        width: 391 //551
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex)
                return myModel.data(myModel.index(player.playlist.currentIndex,0), 257)
        }
        color: "white"
        font.pixelSize: 34 // 48
    }
    Image{
        id: imgDuration
        x: 44 //62
        y: 40+244+39+44 //(56+343+55+62)
        width: 363 //511
        source: "qrc:/Img/HomeScreen/widget_media_pg_n.png"
    }
    Image{
        id: imgPosition
        x: 44 // 62
        y: 40+244+39+44 // (56+343+55+62)
        width: 0
        source: "qrc:/Img/HomeScreen/widget_media_pg_s.png"
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]
    onPressed: root.state = "Pressed"
    onReleased:{
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }

    Connections{
        target: player.playlist
        onCurrentIndexChanged:{
            if (myModel.rowCount() > 0 && myModel.rowCount() >  player.playlist.currentIndex) {
                bgBlur.source = myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
                bgInner.source = myModel.data(myModel.index(player.playlist.currentIndex,0), 260)
                txtSinger.text = myModel.data(myModel.index(player.playlist.currentIndex,0), 258)
                txtTitle.text = myModel.data(myModel.index(player.playlist.currentIndex,0), 257)
            }
        }
    }

    Connections{
        target: player
        onDurationChanged:{
            imgDuration.width = 363 //511
        }
        onPositionChanged: {
            imgPosition.width = (player.position / player.duration)*(511);
        }
    }
}
