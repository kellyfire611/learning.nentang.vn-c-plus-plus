import QtQuick 2.15

Item {
    property alias playlistButtonStatus: playlist_button.status
    signal clickPlaylistButton

    Image {
        id: headerItem
        source: "qrc:/App/Media/Image/title.png"
        width: parent.width
        height: parent.height
    }

    SwitchButton {
        id: playlist_button
        anchors.left: parent.left
        anchors.leftMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        icon_off: "qrc:/App/Media/Image/drawer.png"
        icon_on: "qrc:/App/Media/Image/back.png"
        onClicked: {
            clickPlaylistButton()
        }
    }

    Text {
        anchors.left: playlist_button.right
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Playlist")
        color: "white"
        font.pixelSize: 23
    }

    Text {
        id: headerTitleText
        text: qsTr("Media Player")
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 33
    }

    Component.onCompleted: {
        console.log("AppHeader.qml loaded, playlistButtonStatus:", playlistButtonStatus)
    }
}
