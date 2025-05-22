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
        name: "osm" //"osm" // mapboxgl // , "esri", ...
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
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(21.03, 105.78)
        zoomLevel: 14
        copyrightsVisible: false
        Component.onCompleted: {
            map.addMapItem(marker)
        }
    }
}
