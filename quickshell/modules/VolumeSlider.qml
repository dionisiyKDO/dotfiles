import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland

import "root:/widgets"

ShellRoot {
    Variants {
        model: Quickshell.screens
        
        PanelWindow {
            property var modelData
            
            screen: modelData
            anchors {
                right: true
                top: false
                bottom: false
                left: false
            }
            
            // Position the window at the center of the right edge
            margins {
                right: 0
                top: (screen.height - height) / 2
            }
            
            width: 60
            height: 300
            
            color: "transparent"
            exclusionMode: ExclusionMode.None
            
            Rectangle {
                id: sliderBackground
                anchors.fill: parent
                color: "#2d2d2d"
                opacity: 0.8
                radius: 10
                border.color: "#404040"
                border.width: 1
                
                // Auto-hide functionality
                states: [
                    State {
                        name: "visible"
                        PropertyChanges { target: sliderBackground; opacity: 0.8 }
                    },
                    State {
                        name: "hidden"
                        PropertyChanges { target: sliderBackground; opacity: 0.0 }
                    }
                ]
                
                state: "hidden"
                
                transitions: Transition {
                    PropertyAnimation {
                        properties: "opacity"
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    
                    onEntered: sliderBackground.state = "visible"
                    onExited: sliderBackground.state = "hidden"
                    
                    Column {
                        anchors.centerIn: parent
                        spacing: 10
                        
                        // Volume percentage text
                        Text {
                            id: volumeText
                            text: Math.round(volumeSlider.value * 100) + "%"
                            color: "#ffffff"
                            font.pixelSize: 12
                            font.bold: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        
                        // Volume slider
                        Slider {
                            id: volumeSlider
                            orientation: Qt.Vertical
                            height: 200
                            width: 20
                            
                            from: 0.0
                            to: 1.0
                            value: 0.5
                            
                            background: StyledRect {
                                color: Colours.alpha(Colours.palette.m3surfaceContainer, true)
                                radius: Appearance.rounding.full

                                StyledRect {
                                    anchors.left: parent.left
                                    anchors.right: parent.right

                                    y: root.handle.y
                                    implicitHeight: parent.height - y

                                    color: Colours.alpha(Colours.palette.m3secondary, true)
                                    radius: Appearance.rounding.full
                                }
                            }
                            
                            handle: Rectangle {
                                x: volumeSlider.leftPadding + volumeSlider.availableWidth / 2 - width / 2
                                y: volumeSlider.topPadding + volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 8
                                color: volumeSlider.pressed ? "#ffffff" : "#00aaff"
                                border.color: "#ffffff"
                                border.width: 1
                            }
                            
                            onValueChanged: {
                                // Set system volume using pactl
                                var volumePercent = Math.round(value * 100);
                                Process.execute("pactl", ["set-sink-volume", "@DEFAULT_SINK@", volumePercent + "%"]);
                            }
                        }
                        
                        // Mute button
                        Rectangle {
                            width: 30
                            height: 30
                            color: muteMouseArea.pressed ? "#555555" : "#404040"
                            radius: 15
                            border.color: "#00aaff"
                            border.width: 1
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Text {
                                anchors.centerIn: parent
                                text: volumeSlider.value === 0 ? "🔇" : "🔊"
                                color: "#ffffff"
                                font.pixelSize: 12
                            }
                            
                            MouseArea {
                                id: muteMouseArea
                                anchors.fill: parent
                                
                                onClicked: {
                                    if (volumeSlider.value > 0) {
                                        volumeSlider.value = 0;
                                    } else {
                                        volumeSlider.value = 0.5;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Get initial volume on startup
            Component.onCompleted: {
                var process = Process.execute("pactl", ["get-sink-volume", "@DEFAULT_SINK@"]);
                // Parse the output to get current volume
                // This is a simplified approach - you might need to adjust based on your system
                var output = process.stdout;
                var match = output.match(/(\d+)%/);
                if (match) {
                    volumeSlider.value = parseInt(match[1]) / 100.0;
                }
            }
        }
    }
}