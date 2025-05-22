import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Drawer {
    id: drawer
    property alias mediaPlaylist: mediaPlaylist
    interactive: false
    modal: false
    background: Rectangle {
        id: playList_bg
        anchors.fill: parent
        color: "transparent"
    }

    ListView {
        id: mediaPlaylist
        anchors.fill: parent
        model: playlistModel
        clip: true
        spacing: 1
        currentIndex: player ? player.m_currentIndex : -1

        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height

            Image {
                id: playlistItem
                width: 479
                height: 137
                source: "qrc:/App/Media/Image/playlist.png"
                opacity: 0.5
            }

            Text {
                text: model.title || "Unknown Title"
                anchors.fill: parent
                anchors.leftMargin: 50
                verticalAlignment: Text.AlignVCenter
                color: "white"
                font.pixelSize: 23
            }

            onClicked: {
                if (player && mediaPlayer) {
                    player.setCurrentIndex(index)
                    var source = playlistModel.data(playlistModel.index(index, 0), 259) // SourceRole = 259
                    mediaPlayer.setSource(source)
                    mediaPlayer.play()
                    console.log("PlaylistView selected index:", index, "Source:", source)
                }
            }

            onPressed: {
                playlistItem.source = "qrc:/App/Media/Image/hold.png"
            }

            onReleased: {
                playlistItem.source = "qrc:/App/Media/Image/playlist.png"
            }
        }

        highlight: Image {
            source: "qrc:/App/Media/Image/playlist_item.png"
            Image {
                anchors.left: parent.left
                anchors.leftMargin: 11
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/App/Media/Image/playing.png"
            }
        }

        ScrollBar.vertical: ScrollBar {
            parent: mediaPlaylist.parent
            anchors.top: mediaPlaylist.top
            anchors.left: mediaPlaylist.right
            anchors.bottom: mediaPlaylist.bottom
        }
    }

    Connections {
        target: player
        function onM_currentIndexChanged() {
            mediaPlaylist.currentIndex = player.m_currentIndex
            console.log("PlaylistView updated currentIndex:", player.m_currentIndex)
        }
    }

    onOpened: {
        console.log("Drawer is now opened")
    }

    onClosed: {
        console.log("Drawer is now closed")
    }

    onPositionChanged: {
        console.log("Drawer position changed to:", position)
    }

    Component.onCompleted: {
        console.log("PlaylistView.qml loaded")
        console.log("PlaylistModel row count:", playlistModel ? playlistModel.rowCount() : "undefined")
        console.log("Current index:", player ? player.m_currentIndex : "undefined")
        console.log("Initial opened state:", drawer.opened)
    }
}
