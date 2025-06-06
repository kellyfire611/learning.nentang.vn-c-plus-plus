import QtQuick 2.15

MouseArea {
    id: root
    property string icon_on: ""
    property string icon_off: ""
    property int status: 0 // 0-Off, 1-On
    implicitWidth: img.width
    implicitHeight: img.height

    Image {
        id: img
        source: root.status === 0 ? icon_off : icon_on
    }

    onClicked: {
        status = status === 0 ? 1 : 0
        console.log("SwitchButton status changed to:", status)
    }

    Component.onCompleted: {
        console.log("SwitchButton.qml loaded, initial status:", status)
    }
}
