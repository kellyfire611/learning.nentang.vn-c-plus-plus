import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1360
    height: 768 - 74
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
