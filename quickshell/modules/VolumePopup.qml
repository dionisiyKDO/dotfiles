import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "root:/services"


PanelWindow {
    id: volumePopup

    required property var screenModel
    screen: screenModel

    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell-volume-slider"

    // Full transparent panel, wide enough to host both hover zone + popup
    width: 200
    height: 200
    color: "transparent"

    anchors.right: true

    // Controls visibility of slider
    property bool sliderVisible: false

    // Slider container
    Rectangle {
        id: popupContainer

        width: 50
        height: parent.height
        anchors.right: parent.right
        color: "#222"
        
        opacity: sliderVisible ? 1 : 0
        visible: sliderVisible
        Behavior on opacity { NumberAnimation { duration: 150 } }

        Slider {
            id: volumeSlider
            anchors.centerIn: parent
            width: 20
            height: 150
            orientation: Qt.Vertical
            from: 0
            to: 150
            stepSize: 1
            value: 100

            onValueChanged: {
                console.log("Volume changed to:", value)
                Audio.setVolume(value / 100)
            }
        }

        // This MouseArea allows user interaction with the slider
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            acceptedButtons: Qt.NoButton // <--- THIS is key
            onExited: volumePopup.sliderVisible = false
        }
    }

    // Invisible edge trigger
    MouseArea {
        id: edgeHoverZone
        width: 5
        height: parent.height
        anchors.right: parent.right
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            console.log("Edge hover triggered")
            volumePopup.sliderVisible = true
        }
    }
}
