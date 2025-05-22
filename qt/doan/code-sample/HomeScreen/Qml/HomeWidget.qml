import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQml.Models 2.15

Item {
    id: root
    width: 1360 //1920
    height: 694 //1096

    function openApplication(url) {
        stackView.push(url)
    }

    // Widgets (Map, Climate, Media)
    ListView {
        id: lvWidget
        spacing: 7 //10
        orientation: ListView.Horizontal
        width: 1360 // 1920
        height: 405 //570
        interactive: false

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModelWidget
            model: ListModel {
                id: widgetModel
                ListElement { type: "map" }
                ListElement { type: "climate" }
                ListElement { type: "media" }
            }

            delegate: DropArea {
                id: delegateRootWidget
                width: 450 //635
                height: 405 //570
                keys: ["widget"]

                onEntered: {
                    visualModelWidget.items.move(drag.source.visualIndex, iconWidget.visualIndex)
                    iconWidget.item.enabled = false
                }
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: iconWidget; property: "visualIndex"; value: visualIndex }
                onExited: iconWidget.item.enabled = true

                Loader {
                    id: iconWidget
                    property int visualIndex: 0
                    width: 450 //635
                    height: 405 //570
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    sourceComponent: {
                        switch(model.type) {
                        case "map": return mapWidget
                        case "climate": return climateWidget
                        case "media": return mediaWidget
                        }
                    }

                    Drag.active: iconWidget.item ? iconWidget.item.drag.active : false
                    Drag.keys: "widget"
                    Drag.hotSpot.x: delegateRootWidget.width / 2
                    Drag.hotSpot.y: delegateRootWidget.height / 2

                    states: [
                        State {
                            when: iconWidget.Drag.active
                            ParentChange {
                                target: iconWidget
                                parent: root
                            }
                            AnchorChanges {
                                target: iconWidget
                                anchors.horizontalCenter: undefined
                                anchors.verticalCenter: undefined
                            }
                        }
                    ]
                }
            }
        }

        Component {
            id: mapWidget
            MapWidget {
                onClicked: openApplication("qrc:/App/Map/Map.qml")
            }
        }
        Component {
            id: climateWidget
            ClimateWidget {
                onClicked: openApplication("qrc:/App/Climate/Climate.qml")
            }
        }
        Component {
            id: mediaWidget
            MediaWidget {
                onClicked: openApplication("qrc:/App/Media/Media.qml")
            }
        }
    }

    // App Buttons
    ListView {
        x: 0
        y: 405 //570
        width: 1360 //1920
        height: 429 //604
        orientation: ListView.Horizontal
        interactive: false
        spacing: 4 //5

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }

        model: DelegateModel {
            id: visualModel
            model: ListModel {
                id: appsModel
                ListElement { title: "Map"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_map"; url: "qrc:/App/Map/Map.qml" }
                ListElement { title: "Video"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_climate"; url: "qrc:/App/Video/Video.qml" }
                ListElement { title: "Media"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_media"; url: "qrc:/App/Media/Media.qml" }
                ListElement { title: "Phone"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_phone"; url: "qrc:/App/Phone/Phone.qml" }
                ListElement { title: "Radio"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_radio"; url: "qrc:/App/Radio/Radio.qml" }
                ListElement { title: "Settings"; iconPath: "qrc:/Img/HomeScreen/btn_home_menu_settings"; url: "qrc:/App/Settings/Settings.qml" }
            }
            delegate: DropArea {
                id: delegateRoot
                width: 224 //316
                height: 429 //604
                keys: ["AppButton"]

                onEntered: visualModel.items.move(drag.source.visualIndex, icon.visualIndex)
                property int visualIndex: DelegateModel.itemsIndex
                Binding { target: icon; property: "visualIndex"; value: visualIndex }

                Item {
                    id: icon
                    property int visualIndex: 0
                    width: 224 // 316
                    height: 429 //604
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }

                    AppButton {
                        id: app
                        anchors.fill: parent
                        title: model.title
                        icon: model.iconPath
                        onClicked: openApplication(model.url)
                        onReleased: {
                            app.focus = true
                            app.state = "Focus"
                            for (var index = 0; index < visualModel.items.count; index++) {
                                if (index !== icon.visualIndex)
                                    visualModel.items.get(index).focus = false
                                else
                                    visualModel.items.get(index).focus = true
                            }
                        }
                    }

                    onFocusChanged: app.focus = icon.focus

                    Drag.active: app.drag.active
                    Drag.keys: "AppButton"
                }
            }
        }
    }
}
