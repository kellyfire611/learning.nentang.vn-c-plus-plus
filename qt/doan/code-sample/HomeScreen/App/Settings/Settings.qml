import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1200 - 104

    Rectangle {
        anchors.fill: parent
        color: "#1C2526"

        Text {
            anchors.centerIn: parent
            text: "Settings App"
            color: "white"
            font.pixelSize: 24
        }
    }
}
