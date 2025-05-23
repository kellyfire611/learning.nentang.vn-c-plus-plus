import QtQuick

MouseArea {
    id: root
    property string icon_on: ""
    property string icon_off: ""
    property int status: 0 //0-Off 1-On
    property int btnWidth: 120
    property int btnHeight: 64
    implicitWidth: img.width
    implicitHeight: img.height
    Image {
        id: img
        width: btnWidth
        height: btnHeight
        source: root.status === 0 ? icon_off : icon_on
    }
    onClicked: {
        if (root.status == 0){
            root.status = 1
        } else {
            root.status = 0
        }
    }
}
