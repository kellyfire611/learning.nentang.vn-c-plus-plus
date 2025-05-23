import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "Common"

Item {
    width: 1360 //1920
    height: 74 //104
    signal bntBackClicked
    property bool isShowBackBtn: false

    Button {
        anchors.left: parent.left
        icon: "qrc:/Img/StatusBar/btn_top_back"
        width: 96 //135
        height: 72 //101
        iconWidth: width
        iconHeight: height
        onClicked: bntBackClicked()
        visible: isShowBackBtn
    }

    Item {
        id: clockArea
        x: 468 // 660
        width: 213 // 300
        height: parent.height
        Image {
            anchors.left: parent.left
            height: 74 //104
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
        Text {
            id: clockTime
            text: Qt.formatTime(new Date(), "hh:mm")
            color: "white"
            font.pixelSize: 51 //72
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 74 // 104
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }
    Item {
        id: dayArea
        anchors.left: clockArea.right
        width: 213 //300
        height: parent.height
        Text {
            id: day
            text: Qt.formatDate(new Date(), "MMM. dd")
            color: "white"
            font.pixelSize: 51 //72
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
        }
        Image {
            anchors.right: parent.right
            height: 74 //104
            source: "qrc:/Img/StatusBar/status_divider.png"
        }
    }

    QtObject {
        id: time
        property var locale: Qt.locale()
        property date currentTime: new Date()

        Component.onCompleted: {
            clockTime.text = currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = currentTime.toLocaleDateString(locale, "MMM. dd");
        }
    }

    Timer{
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            time.currentTime = new Date()
            clockTime.text = time.currentTime.toLocaleTimeString(locale, "hh:mm");
            day.text = time.currentTime.toLocaleDateString(locale, "MMM. dd");
        }

    }

}
