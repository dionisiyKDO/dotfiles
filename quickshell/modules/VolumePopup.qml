import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "root:/services"
import "root:/config"


PanelWindow {
    id: volumePopup

    required property var screenModel
    screen: screenModel

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell-volume-slider"

    // Full transparent panel, wide enough to host both hover zone + popup
    width: 60
    height: 200
    color: "transparent"

    anchors.right: true

    // Controls visibility of slider
    property bool sliderVisible: false

    // Slider container
    Rectangle {
        id: popupContainer

        width: parent.width
        height: parent.height
        anchors.right: parent.right
        color: Theme.surface
                
        state: sliderVisible ? "visible" : "hidden"
        
        Slider {
            id: volumeSlider
            
            width: 16  // Wider track
            height: 150
            anchors.centerIn: parent
            orientation: Qt.Vertical

            from: 0
            to: 150
            value: 100
            stepSize: 1

            property bool isMoving: pressed

            // Custom background (track)
            background: Rectangle {
                width: volumeSlider.width
                height: volumeSlider.height

                color: "#40ffffff"  // Semi-transparent white
                radius: width / 2  // Fully rounded
                
                // Filled portion
                Rectangle {
                    width: parent.width
                    height: (1 - volumeSlider.visualPosition) * parent.height
                    anchors.bottom: parent.bottom

                    color: Theme.accentPrimary || "#0078d4"  // Use theme accentPrimary or fallback
                    radius: parent.radius
                }
            }

            // Custom handle (circle)
            handle: Item {
                width: 24
                height: 24
                x: (volumeSlider.width - width) / 2
                y: volumeSlider.visualPosition * (volumeSlider.availableHeight - height)
                
                // Shadow effect
                Rectangle {
                    width: parent.width + 2
                    height: parent.height + 2
                    anchors.centerIn: parent

                    color: "#20000000"  // Subtle shadow
                    radius: width / 2
                }
                
                // Main handle circle
                Rectangle {
                    id: handleCircle

                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent
                    
                    color: Theme.surfaceVariant
                    border.color: Theme.accentPrimary || "#0078d4"
                    border.width: 2
                    radius: width / 2
                    
                    // Scale animation when pressed
                    scale: volumeSlider.pressed ? 1.2 : 1.0
                    
                    Behavior on scale {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutCubic
                        }
                    }
                    
                    // Value display
                    Text {
                        text: Math.round(volumeSlider.value)

                        anchors.centerIn: parent

                        color: Theme.accentPrimary || "#0078d4"
                        opacity: volumeSlider.isMoving ? 1.0 : 0.0

                        font.pixelSize: 8
                        font.bold: true
                        
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 200
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }

            // Smooth value animation
            Behavior on value {
                enabled: !volumeSlider.pressed
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            
            // Timer to hide value after interaction
            Timer {
                id: valueDisplayTimer
                interval: 1000
                onTriggered: volumeSlider.isMoving = false
            }
            
            onPressedChanged: {
                isMoving = pressed
                if (pressed) {
                    valueDisplayTimer.stop()
                } else {
                    valueDisplayTimer.start()
                }
            }
            
            onValueChanged: {
                Audio.setVolume(value / 100)
                if (!pressed) {
                    isMoving = true
                    valueDisplayTimer.restart()
                }
            }



        }

        // Timer trigger hiding the popup after the delay
        Timer {
            id: hideTimer
            interval: 300 // 300ms delay before hiding
            onTriggered: volumePopup.sliderVisible = false
        }

        // This MouseArea triggers the hiding of the popup on slider exit
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton // To let click events pass through, so MouseArea doesn't what is underneath
            propagateComposedEvents: true

            onEntered: hideTimer.stop()
            onExited: hideTimer.start()
        }

        transitions: [
            Transition {
                // Animate the transition between any state
                from: "*"; to: "*"
                
                // Animate both properties at the same time for a smooth effect
                ParallelAnimation {
                    NumberAnimation { 
                        properties: "anchors.rightMargin, opacity"
                        duration: 200
                        easing.type: Easing.OutCubic 
                    }
                }
            }
        ]

        states: [
            State {
                name: "visible"
                // When visible, the margin is 0 and it's fully opaque
                PropertyChanges { target: popupContainer; anchors.rightMargin: 0; opacity: 1 }
            },
            State {
                name: "hidden"
                // When hidden, move it off-screen by its own width and make it transparent
                PropertyChanges { target: popupContainer; anchors.rightMargin: -popupContainer.width; opacity: 0 }
            }
        ]
    }

    // This MouseArea triggers the popup visibility on hover and hides it after mouse exit
    MouseArea {
        id: edgeHoverZone
        
        width: 2
        height: parent.height
        anchors.right: parent.right
        hoverEnabled: true // without it only works when lmb is pressed

        onEntered: {
            hideTimer.stop()
            volumePopup.sliderVisible = true
        }
        onExited: {
            hideTimer.start()
        }
    }
}
