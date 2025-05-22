import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1360
    height: 768 - 74

    // Header
    AppHeader {
        id: headerItem
        width: parent.width
        height: 100
        z: 10 // Đặt z cao hơn để tránh bị che bởi Drawer
        playlistButtonStatus: playlist.opened ? 1 : 0
        onClickPlaylistButton: {
            console.log("ClickPlaylistButton, current opened state:", playlist.opened)
            if (!playlist.opened) {
                playlist.open()
                console.log("Drawer opened")
            } else {
                playlist.close()
                console.log("Drawer closed")
            }
        }
    }

    // Playlist
    PlaylistView {
        id: playlist
        y: 174
        width: 640
        height: parent.height - headerItem.height
        topMargin: headerItem.height // Đảm bảo Drawer không che khuất header
        z: 0 // Đảm bảo z thấp hơn AppHeader
    }

    // Media Info
    MediaInfoControl {
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: playlist.position * playlist.width
        anchors.bottom: parent.bottom
    }

    // Debug
    Component.onCompleted: {
        console.log("Media.qml loaded")
        console.log("Player:", player)
        console.log("PlaylistModel row count:", playlistModel ? playlistModel.rowCount() : "undefined")
    }
}
