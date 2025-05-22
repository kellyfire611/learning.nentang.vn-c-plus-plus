import QtQuick 2.15
import QtLocation 6.9
import QtPositioning 6.9

Item {
    id: root
    width: 1360 //1920
    height: 768-74 //1200 - 104 //70

    Item {
        id: startAnimation
        XAnimator{
            target: root
            from: 1360 //1920
            to: 0
            duration: 200
            running: true
        }
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
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(10.032445494864064, 105.7815355124529) // Tọa độ TP.CT
        zoomLevel: 12
        activeMapType: supportedMapTypes.find(function(mt) { return mt.name === "thf-cycle-custom"; }) || supportedMapTypes[0]
        copyrightsVisible: false
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
            //     console.log("Map not ready:", map.errorString())
            // }
        }
        Component.onCompleted: {
            map.addMapItem(marker)
        }
    }
}
