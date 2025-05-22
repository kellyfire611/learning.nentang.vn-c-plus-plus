import QtQuick 2.15
import Qt5Compat.GraphicalEffects 6.0

MouseArea {
    id: root
    implicitWidth: 450
    implicitHeight: 405

    Rectangle {
        anchors {
            fill: parent
            margins: 7
        }
        opacity: 0.7
        color: "#111419"
    }

    Image {
        id: bgBlur
        x: 7
        y: 7
        width: 436
        height: 391
        source: {
            if (playlistModel && playlistModel.rowCount() > 0 && player && player.m_currentIndex >= 0 && player.m_currentIndex < playlistModel.rowCount())
                return playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 260) || "qrc:/Img/HomeScreen/cover_art.jpg"
            return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
    }

    FastBlur {
        anchors.fill: bgBlur
        source: bgBlur
        radius: 13
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
        y: 28
        text: "USB Music"
        color: "white"
        font.pixelSize: 24
    }

    Image {
        id: bgInner
        x: 143
        y: 85
        width: 183
        height: 183
        source: {
            if (playlistModel && playlistModel.rowCount() > 0 && player && player.m_currentIndex >= 0 && player.m_currentIndex < playlistModel.rowCount())
                return playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 260) || "qrc:/Img/HomeScreen/cover_art.jpg"
            return "qrc:/Img/HomeScreen/cover_art.jpg"
        }
    }

    Image {
        x: 143
        y: 85
        width: 183
        height: 183
        source: "qrc:/Img/HomeScreen/widget_media_album_bg.png"
    }

    Text {
        id: txtSinger
        x: 30
        y: 40 + 244
        width: 551
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (playlistModel && playlistModel.rowCount() > 0 && player && player.m_currentIndex >= 0 && player.m_currentIndex < playlistModel.rowCount()) {
                var singer = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 258);
                return singer && singer !== "" ? singer : "No Artist";
            }
            return "No Artist";
        }
        color: "white"
        font.pixelSize: 21
    }

    Text {
        id: txtTitle
        x: 30
        y: 40 + 244 + 39
        width: 391
        horizontalAlignment: Text.AlignHCenter
        text: {
            if (playlistModel && playlistModel.rowCount() > 0 && player && player.m_currentIndex >= 0 && player.m_currentIndex < playlistModel.rowCount()) {
                var title = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 257);
                return title && title !== "" ? title : "No Title";
            }
            return "No Title";
        }
        color: "white"
        font.pixelSize: 34
    }

    Image {
        id: imgDuration
        x: 44
        y: 40 + 244 + 39 + 44
        width: 363
        source: "qrc:/Img/HomeScreen/widget_media_pg_n.png"
    }

    Image {
        id: imgPosition
        x: 44
        y: 40 + 244 + 39 + 44
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
    onReleased: {
        root.focus = true
        root.state = "Focus"
    }

    onFocusChanged: {
        if (root.focus)
            root.state = "Focus"
        else
            root.state = "Normal"
    }

    Connections {
        target: player
        function onM_currentIndexChanged() {
            if (player && playlistModel && playlistModel.rowCount() > 0 && player.m_currentIndex >= 0 && player.m_currentIndex < playlistModel.rowCount()) {
                bgBlur.source = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 260) || "qrc:/Img/HomeScreen/cover_art.jpg"
                bgInner.source = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 260) || "qrc:/Img/HomeScreen/cover_art.jpg"
                txtSinger.text = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 258) || "No Artist"
                txtTitle.text = playlistModel.data(playlistModel.index(player.m_currentIndex, 0), 257) || "No Title"
            } else {
                console.log("Invalid state: player=", player, "rowCount=", playlistModel ? playlistModel.rowCount() : "undefined", "m_currentIndex=", player ? player.m_currentIndex : "undefined")
            }
        }
    }

    Connections {
        target: player
        function onDurationChanged() {
            imgDuration.width = 363
        }
        function onPositionChanged() {
            imgPosition.width = player.duration > 0 ? (player.position / player.duration) * 363 : 0
        }
    }

    Component.onCompleted: {
        console.log("MediaWidget loaded")
        console.log("Playlist row count:", playlistModel ? playlistModel.rowCount() : "undefined")
        console.log("Current index:", player ? player.m_currentIndex : "undefined")
        if (playlistModel && playlistModel.rowCount() > 0) {
            console.log("First song - Title:", playlistModel.data(playlistModel.index(0, 0), 257))
            console.log("First song - Artist:", playlistModel.data(playlistModel.index(0, 0), 258))
        }
    }
}
