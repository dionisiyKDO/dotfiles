import Quickshell
import QtQuick
import Quickshell.Wayland
import "root:/config"
import "root:/widgets"


PanelWindow {
    required property var screenModel // screen from the screens list will be injected into this property
    screen: screenModel // set the the screen on which it is shown as the injected screen, so it creates bar for each screen

    // left bar
    implicitWidth: 30
    anchors {
        top: true
        left: true
        bottom: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    // **Bottom** 
    //      Clock
    Item {
        id: center

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        implicitHeight: 60
        
        
        ClockWidget {
            id: clock

            anchors.centerIn: parent
            anchors.rightMargin: Appearance.spacing.large
            anchors.leftMargin: Appearance.spacing.large

            format: "hh\nmm"
        }
    }
}
