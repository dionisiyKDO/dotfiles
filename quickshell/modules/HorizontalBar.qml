import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Io
import "root:/config"
import "root:/modules/widgets"


PanelWindow {
    required property var screenModel // screen from the screens list will be injected into this property
    screen: screenModel // set the the screen on which it is shown as the injected screen, so it creates bar for each screen

    implicitWidth: screen.width
    implicitHeight: 18

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
        anchors.rightMargin: Appearance.spacing.small

        implicitHeight: parent.height
        implicitWidth: title.implicitWidth

        WindowTitle {
            id: title

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

        anchors.leftMargin: Appearance.spacing.small
        anchors.rightMargin: Appearance.spacing.small
        
        implicitHeight: parent.height
    }


    // **Right** 
    //      Language
    //      Clock
    Item {
        id: right

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right

        anchors.leftMargin: Appearance.spacing.small
        anchors.rightMargin: Appearance.spacing.small
        
        implicitHeight: parent.height
        implicitWidth: language.implicitWidth + clock.implicitWidth + Appearance.spacing.normal * 4

        LanguageIndicator {
            id: language

            anchors.right: clock.left
            anchors.rightMargin: Appearance.spacing.normal
            anchors.leftMargin: Appearance.spacing.normal

            format: "long" // "short" for "US", "RU", "UA"       "long" for "English", "Russian", "Ukrainian"
        }


        Clock {
            id: clock

            anchors.right: parent.right
            anchors.rightMargin: Appearance.spacing.normal
            anchors.leftMargin: Appearance.spacing.normal

            // format: "ddd - MMM d | hh:mm:ss AP"
            // format: "hh:mm:ss AP"
            format: "hh:mm:ss"
        }
    }
}


