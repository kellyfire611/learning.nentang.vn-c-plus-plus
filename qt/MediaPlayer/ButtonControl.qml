import QtQuick

MouseArea {
    property string icon_default: ""
    property string icon_pressed: ""
    property string icon_released: ""
    property alias source: img.source
    property int btnWidth: 80
    property int btnHeight: 64
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        width: btnWidth
        height: btnHeight
        source: icon_default
    }
    onPressed: {
        img.source = icon_pressed
    }
    onReleased: {
        img.source = icon_released
    }
}
