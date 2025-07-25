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
    //      Language
    Item {
        id: bottom

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left

        implicitHeight: 100

        LanguageIndicator {
            id: language

            anchors.bottom: separator_1.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: separator_1

            anchors.bottom: clock.top
            implicitHeight: 1
            implicitWidth: parent.width
            
            color: "#fff"
        }

            // Debug background rectangle for visibility of the area element occupies
            // Rectangle {
            //     anchors.fill: parent
            //     color: "#fff"
            //     opacity: 0.2
            // }
            
        ClockWidget {
            id: clock

            anchors.bottom: parent.bottom

            implicitHeight: 60
            implicitWidth: parent.width

            format: "hh\nmm"
        }
    }

}
