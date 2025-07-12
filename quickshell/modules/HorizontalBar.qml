import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Io
import "root:/config"
import "root:/widgets"
import "root:/modules"


PanelWindow {
    required property var screenModel // screen from the screens list will be injected into this property
    screen: screenModel // set the the screen on which it is shown as the injected screen, so it creates bar for each screen

    implicitWidth: screen.width
    implicitHeight: 32
    anchors {
        top: true
        left: true
        right: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    // **Left** 
    //      Window title/class
    Item {
        id: left

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: Appearance.spacing.small
        implicitHeight: 30
        implicitWidth: 150  // TEMP

        WindowTitle {
            anchors.left: parent.left
        }
    }

    // **Center** 
    //      Clock
    Item {
        id: center

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        implicitHeight: 30
        implicitWidth: 150  // TEMP
        
        ClockWidget {
            id: clock
            color: "white"

            anchors.centerIn: parent
            anchors.rightMargin: Appearance.spacing.large
            anchors.leftMargin: Appearance.spacing.large
        }
    }


    // **Right** 
    //      Language
    Item {
        id: right

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: Appearance.spacing.small
        implicitHeight: 30
        implicitWidth: 150  // TEMP

        LanguageIndicator {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}


