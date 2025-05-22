import QtQuick 2.15

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: ""
    property alias source: img.source
    implicitWidth: img.width
    implicitHeight: img.height

    Image {
        id: img
        source: icon_default
    }

    onPressed: {
        img.source = icon_pressed
        console.log("ButtonControl pressed:", icon_pressed)
    }

    onReleased: {
        img.source = icon_released
        console.log("ButtonControl released:", icon_released)
    }
}
