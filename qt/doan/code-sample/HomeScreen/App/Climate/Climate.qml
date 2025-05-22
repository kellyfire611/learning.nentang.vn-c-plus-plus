import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    width: 1360 // 1920
    height: 768-74 // 1200 - 104

    Rectangle {
        anchors.fill: parent
        color: "#1C2526"

        ColumnLayout {
            anchors.fill: parent
            spacing: 7 //10

            Text {
                text: "Climate Control"
                color: "white"
                font.pixelSize: 24 //34
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 14 //20
                anchors.horizontalCenter: parent.horizontalCenter

                // Driver Controls
                ColumnLayout {
                    spacing: 7 //10
                    Text {
                        text: "DRIVER"
                        color: "white"
                        font.pixelSize: 17 // 24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: climateModel.driver_temp == 16.5 ? "LOW" :
                              climateModel.driver_temp == 31.5 ? "HIGH" :
                              climateModel.driver_temp + "°C"
                        color: "white"
                        font.pixelSize: 21 //30
                        Layout.alignment: Qt.AlignHCenter
                    }
                    RowLayout {
                        spacing: 7 //10
                        Button {
                            text: "-"
                            onClicked: {
                                if (climateModel.driver_temp > 16.5)
                                    climateModel.driver_temp -= 0.5
                                else
                                    climateModel.driver_temp = 16.5
                            }
                        }
                        Button {
                            text: "+"
                            onClicked: {
                                if (climateModel.driver_temp < 31.5)
                                    climateModel.driver_temp += 0.5
                                else
                                    climateModel.driver_temp = 31.5
                            }
                        }
                    }
                    Text {
                        text: "Wind Mode: " + climateModel.driver_wind_mode
                        color: "white"
                        font.pixelSize: 14 //20
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

                // Passenger Controls
                ColumnLayout {
                    spacing: 7 // 10
                    Text {
                        text: "PASSENGER"
                        color: "white"
                        font.pixelSize: 17 //24
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Text {
                        text: climateModel.passenger_temp == 16.5 ? "LOW" :
                              climateModel.passenger_temp == 31.5 ? "HIGH" :
                              climateModel.passenger_temp + "°C"
                        color: "white"
                        font.pixelSize: 21 //30
                        Layout.alignment: Qt.AlignHCenter
                    }
                    RowLayout {
                        spacing: 7 // 10
                        Button {
                            text: "-"
                            onClicked: {
                                if (climateModel.passenger_temp > 16.5)
                                    climateModel.passenger_temp -= 0.5
                                else
                                    climateModel.passenger_temp = 16.5
                            }
                        }
                        Button {
                            text: "+"
                            onClicked: {
                                if (climateModel.passenger_temp < 31.5)
                                    climateModel.passenger_temp += 0.5
                                else
                                    climateModel.passenger_temp = 31.5
                            }
                        }
                    }
                    Text {
                        text: "Wind Mode: " + climateModel.passenger_wind_mode
                        color: "white"
                        font.pixelSize: 14 //20
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 14 //20
                Text {
                    text: "Fan Level: " + climateModel.fan_level
                    color: "white"
                    font.pixelSize: 17 //24
                }
                Button {
                    text: "-"
                    onClicked: {
                        if (climateModel.fan_level > 1)
                            climateModel.fan_level -= 1
                    }
                }
                Button {
                    text: "+"
                    onClicked: {
                        if (climateModel.fan_level < 10)
                            climateModel.fan_level += 1
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 14 //20
                Switch {
                    text: "AUTO"
                    checked: climateModel.auto_mode
                    onCheckedChanged: climateModel.auto_mode = checked ? 1 : 0
                }
                Switch {
                    text: "SYNC"
                    checked: climateModel.sync_mode
                    onCheckedChanged: climateModel.sync_mode = checked ? 1 : 0
                }
            }
        }
    }
}
