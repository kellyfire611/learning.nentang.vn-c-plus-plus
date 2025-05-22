import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    id: window
    visible: true
    width: 1360 //1920
    height: 768 //1200
    Image {
        id: background
        width: 1360 //1920
        height: 768 //1200
        source: "qrc:/Img/bg_full.png"
    }

    StatusBar {
        id: statusBar
        onBntBackClicked: stackView.pop()
        isShowBackBtn: stackView.depth == 1 ? false : true
    }

    StackView {
        id: stackView
        width: 1360 //1920
        anchors.top: statusBar.bottom
        initialItem: HomeWidget{}
        onCurrentItemChanged: {
            currentItem.forceActiveFocus()
        }
        pushExit: Transition {
            XAnimator {
                from: 0
                to: 1360 //-1920
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    }
}
