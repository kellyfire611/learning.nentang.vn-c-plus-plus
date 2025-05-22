import QtQuick 2.15

MouseArea {
    id: root
    implicitWidth: 450 //635
    implicitHeight: 405 // 570

    Rectangle {
        anchors{
            fill: parent
            margins: 7 // 10
        }
        opacity: 0.7
        color: "#111419"
    }

    Image {
        id: idBackgroud
        source: ""
        width: root.width
        height: root.height
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        y: 28 // 40
        text: "Climate"
        color: "white"
        font.pixelSize: 24 // 34
    }

    //Driver
    Text {
        x: 30 // 43
        y: 96 // 135
        width: 130 // 184
        text: "DRIVER"
        color: "white"
        font.pixelSize: 24 // 34
        horizontalAlignment: Text.AlignHCenter
    }

    Image {
        x: 30 //43
        y: 96+29 // (135+41)
        width: 130 // 184
        source: "qrc:/Img/HomeScreen/widget_climate_line.png"
    }

    Image {
        x: 39+18+18 // (55+25+26)
        y: 146// 205
        width: 78 //110
        height: 85 //120
        source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
    }
    Image {
        x: 39+18// (55+25)
        y: 146+24 // (205+34)
        width: 50 // 70
        height: 36 // 50
        source: climateModel.driver_wind_mode == 0 || climateModel.driver_wind_mode == 2 ?
                    "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"

    }
    Image {
        x: 39// 55
        y: 146+24+18 // (205+34+26)
        width: 50 // 70
        height: 36 // 50
        source: climateModel.driver_wind_mode == 1 || climateModel.driver_wind_mode == 2 ?
                    "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
    }
    Text {
        id: driver_temp
        x: 30 // 43
        y: 176+76 // (248 + 107)
        width: 130 // 184
        text: climateModel.driver_temp == 16.5 ? "LOW" :
             climateModel.driver_temp == 31.5 ? "HIGH" :
             climateModel.driver_temp + "°C"
        color: "white"
        font.pixelSize: 33 // 46
        horizontalAlignment: Text.AlignHCenter
    }

    //Passenger
    Text {
        x: 30+130+129// (43+184+182)
        y: 96 // 135
        width: 130 // 184
        text: "PASSENGER"
        color: "white"
        font.pixelSize: 24 // 34
        horizontalAlignment: Text.AlignHCenter
    }
    Image {
        x: 30+130+129 // (43+184+182)
        y: 96+29 // (135+41)
        width: 130 // 184
        source: "qrc:/Img/HomeScreen/widget_climate_line.png"
    }
    Image {
        x: 39+18+18+223+18+18 // (55+25+26+314+25+26)
        y: 146 // 205
        width: 78 // 110
        height: 85 // 120
        source: "qrc:/Img/HomeScreen/widget_climate_arrow_seat.png"
    }
    Image {
        x: 39+18+18+223+18 // (55+25+26+314+25)
        y: 146+24 // (205+34)
        width: 50 // 70
        height: 36 // 50
        source: climateModel.passenger_wind_mode == 0 || climateModel.passenger_wind_mode == 2 ?
                    "qrc:/Img/HomeScreen/widget_climate_arrow_01_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_01_n.png"
    }
    Image {
        x: 39+18+18+223 // (55+25+26+314)
        y: 146+24+18 // (205+34+26)
        width: 50 // 70
        height: 36 // 50
        source: climateModel.passenger_wind_mode == 1 || climateModel.passenger_wind_mode == 2 ?
                    "qrc:/Img/HomeScreen/widget_climate_arrow_02_s_b.png" : "qrc:/Img/HomeScreen/widget_climate_arrow_02_n.png"
    }
    Text {
        id: passenger_temp
        x: 30+130+129 // (43+184+182)
        y: 176+76 // (248 + 107)
        width: 130 // 184
        text: climateModel.passenger_temp == 16.5 ? "LOW" :
            climateModel.passenger_temp == 31.5 ? "HIGH" :
            climateModel.passenger_temp + "°C"
        color: "white"
        font.pixelSize: 33 // 46
        horizontalAlignment: Text.AlignHCenter
    }
    //Wind level
    Image {
        x: 122// 172
        y: 176 // 248
        width: 206 // 290
        height: 71 // 100
        source: "qrc:/Img/HomeScreen/widget_climate_wind_level_bg.png"
    }
    Image {
        id: fan_level
        x: 122 // 172
        y: 176 // 248
        width: 206 // 290
        height: 71 // 100
        source: //"qrc:/Img/HomeScreen/widget_climate_wind_level_01.png"
        {
            if (climateModel.fan_level < 1)
                return "qrc:/Img/HomeScreen/widget_climate_wind_level_01.png"
            if (climateModel.fan_level < 10)
                return "qrc:/Img/HomeScreen/widget_climate_wind_level_0" + climateModel.fan_level + ".png"
            return "qrc:/Img/HomeScreen/widget_climate_wind_level_" + climateModel.fan_level + ".png"
        }
    }
    // Connections{
    //     target: climateModel
    //     onDataChanged: {
    //         //set data for fan level
    //         if (climateModel.fan_level < 1) {
    //             fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_01.png"
    //         }
    //         else if (climateModel.fan_level < 10) {
    //             fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_0"+climateModel.fan_level+".png"
    //         } else {
    //             fan_level.source = "qrc:/Img/HomeScreen/widget_climate_wind_level_"+climateModel.fan_level+".png"
    //         }
    //         //set data for driver temp
    //         if (climateModel.driver_temp == 16.5) {
    //             driver_temp.text = "LOW"
    //         } else if (climateModel.driver_temp == 31.5) {
    //             driver_temp.text = "HIGH"
    //         } else {
    //             driver_temp.text = climateModel.driver_temp+"°C"
    //         }

    //         //set data for passenger temp
    //         if (climateModel.passenger_temp == 16.5) {
    //             passenger_temp.text = "LOW"
    //         } else if (climateModel.passenger_temp == 31.5) {
    //             passenger_temp.text = "HIGH"
    //         } else {
    //             passenger_temp.text = climateModel.passenger_temp+"°C"
    //         }
    //     }
    // }

    //Fan
    Image {
        x: 122+82 // (172 + 115)
        y: 176+76 // (248 + 107)
        width: 43 // 60
        height: 43 // 60
        source: "qrc:/Img/HomeScreen/widget_climate_ico_wind.png"
    }
    //Bottom
    Text {
        x: 21 //30
        y: 331+13 // (466 + 18)
        width: 122 // 172
        horizontalAlignment: Text.AlignHCenter
        text: "AUTO"
        color: !climateModel.auto_mode ? "white" : "gray"
        font.pixelSize: 33 // 46
    }
    Text {
        x: 21+122+21 // (30+172+30)
        y: 331 // 466
        width: 122 // 171
        horizontalAlignment: Text.AlignHCenter
        text: "OUTSIDE"
        color: "white"
        font.pixelSize: 18 // 26
    }
    Text {
        x: 21+122+21 // (30+172+30)
        y: 331+13+15 // (466 + 18 + 21)
        width: 122// 171
        horizontalAlignment: Text.AlignHCenter
        text: "27.5°C"
        color: "white"
        font.pixelSize: 27 // 38
    }
    Text {
        x: 21+122+21+122+21// (30+172+30+171+30)
        y: 331+13 // (466 + 18)
        width: 122 // 171
        horizontalAlignment: Text.AlignHCenter
        text: "SYNC"
        color: !climateModel.sync_mode ? "white" : "gray"
        font.pixelSize: 33 // 46
    }
    //
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
