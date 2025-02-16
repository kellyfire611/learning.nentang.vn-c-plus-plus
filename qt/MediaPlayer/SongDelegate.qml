import QtQuick
import QtQuick.Controls

Item {
    property alias onClicked: mouseArea.clicked
    width: parent.width
    height: 60

    Row {
        spacing: 10
        anchors.fill: parent

        Image {
            width: 50
            height: 50
            source: albumArt
        }

        Column {
            Text { text: title }
            Text { text: artist }
            Text { text: album }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.onClicked()
    }
}
