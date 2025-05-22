import QtQuick 2.15
import QtLocation 6.9
import QtPositioning 6.9

MouseArea {
    id: root
    preventStealing: true
    propagateComposedEvents: true
    implicitWidth: 450 //635
    implicitHeight: 405 //570

    Rectangle {
        anchors{
            fill: parent
            margins: 7 //10
        }
        opacity: 0.7
        color: "#111419"
    }

    Item {
        id: map
        x: 7 //10
        y: 7 //10
        width: 436 //615
        height: 391 //550
        Plugin {
            id: mapPlugin
            name: "osm" //"mapboxgl", "osm", "esri", ...
        }
        MapQuickItem {
            id: marker
            anchorPoint.x: image.width/4
            anchorPoint.y: image.height
            coordinate: QtPositioning.coordinate(21.03, 105.78)

            sourceItem: Image {
                id: image
                source: "qrc:/Img/Map/car_icon.png"
            }
        }
        Map {
            id: mapView
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(21.03, 105.78)
            zoomLevel: 14
            copyrightsVisible: false
            enabled: false
            Component.onCompleted: {
                mapView.addMapItem(marker)
            }
        }
    }
    Image {
        id: idBackgroud
        width: root.width
        height: root.height
        source: ""
    }

    states: [
        State {
            name: "Focus"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_f.png"
            }
        },
        State {
            name: "Pressed"
            PropertyChanges {
                target: idBackgroud
                source: "qrc:/Img/HomeScreen/bg_widget_p.png"
            }
        },
        State {
            name: "Normal"
            PropertyChanges {
                target: idBackgroud
                source: ""
            }
        }
    ]
    onPressed: root.state = "Pressed"
    onReleased:{
        root.focus = true
        root.state = "Focus"
    }
    onFocusChanged: {
        if (root.focus == true )
            root.state = "Focus"
        else
            root.state = "Normal"
    }
}
