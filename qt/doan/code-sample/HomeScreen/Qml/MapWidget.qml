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

    Plugin {
        id: mapPlugin
        name: "osm"
        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: "qrc:/custom_providers/"
        }
        Component.onCompleted: {
            console.log("Plugin available:", mapPlugin.availableServiceProviders)
            console.log("Plugin error:", mapPlugin.errorString)
        }
    }

    Item {
        id: map
        x: 7 //10
        y: 7 //10
        width: 436 //615
        height: 391 //550
        MapQuickItem {
            id: marker
            anchorPoint.x: image.width/4
            anchorPoint.y: image.height
            coordinate: QtPositioning.coordinate(10.032445494864064, 105.7815355124529)

            sourceItem: Image {
                id: image
                source: "qrc:/Img/Map/car_icon.png"
            }
        }
        Map {
            id: mapView
            anchors.fill: parent
            plugin: mapPlugin
            center: QtPositioning.coordinate(10.032445494864064, 105.7815355124529) // Tọa độ TP.CT
            zoomLevel: 12
            activeMapType: supportedMapTypes.find(function(mt) { return mt.name === "thf-cycle-custom"; }) || supportedMapTypes[0]
            copyrightsVisible: false
            enabled: false
            onMapReadyChanged: {
                // if (map.ready) {
                //     if (map.supportedMapTypes && map.supportedMapTypes.length > 0) {
                //         for (var i = 0; i < map.supportedMapTypes.length; i++) {
                //             console.log("Map type:", map.supportedMapTypes[i].name)
                //         }
                //     } else {
                //         console.log("No supported map types available")
                //     }
                // } else {
                //     console.log("Map not ready:", map.errorString)
                // }
            }
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
