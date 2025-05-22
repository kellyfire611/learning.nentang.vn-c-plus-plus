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
        model: playlistModel //myModel
        clip: true
        spacing: 2
        currentIndex: player.m_currentIndex //player.playlist.currentIndex

        delegate: MouseArea {
            property variant myData: model
            implicitWidth: playlistItem.width
            implicitHeight: playlistItem.height
            Image {
                id: playlistItem
                width: 675
                height: 193
                source: "qrc:/App/Media/Image/playlist.png"
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
                //player.playlist.currentIndex = index
                player.m_currentIndex = index
                mediaPlayer.setSource(source)
                mediaPlayer.play()
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
                anchors.leftMargin: 15
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

    Connections{
        target: player // player.playlist
        onCurrentIndexChanged: {
            mediaPlaylist.currentIndex = player.m_currentIndex //index;
        }
    }
}
