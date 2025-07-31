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
    width: 50
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
        
        // opacity: sliderVisible ? 1 : 0
        // visible: sliderVisible

        Slider {
            id: volumeSlider
            
            width: 20
            height: 150
            anchors.centerIn: parent
            orientation: Qt.Vertical

            from: 0
            to: 150
            value: 100
            stepSize: 10

            onValueChanged: Audio.setVolume(value / 100)
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
            // propagateComposedEvents: true

            onEntered: {
                hideTimer.stop()
            }
            onExited: {
                hideTimer.start()
            }
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
