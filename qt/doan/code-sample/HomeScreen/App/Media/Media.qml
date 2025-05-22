import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1360 //1920
    height: 768-74 //1200-104
    //Header
    AppHeader{
        id: headerItem
        width: parent.width
        height: 100 //141
        playlistButtonStatus: playlist.opened ? 1 : 0
        onClickPlaylistButton: {
            if (!playlist.opened) {
                playlist.open()
            } else {
                playlist.close()
            }
        }
    }

    //Playlist
    PlaylistView{
        id: playlist
        y: 100 //141 + 104
        width: 749 //675
        height: parent.height-headerItem.height
    }

    //Media Info
    MediaInfoControl{
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: playlist.position*playlist.width
        anchors.bottom: parent.bottom
    }
}
