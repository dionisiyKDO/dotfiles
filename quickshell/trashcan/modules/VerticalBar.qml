// quickshell/modules/VerticalBar.qml
import Quickshell
import QtQuick
import Quickshell.Wayland
import "root:/config"
import "root:/widgets"
import "root:/services"


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
    //      Workspaces

    Workspaces {
        id: workspaces

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        anchors.topMargin: 8

        implicitHeight: 200

        // Rectangle {
        //     anchors.fill: parent
        //     color: "#ffffff"
        //     opacity: 0.3
        // }


        screen: screenModel
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
            
        Item {
            id: clock

            anchors.bottom: parent.bottom

            implicitHeight: 60
            implicitWidth: parent.width

            Text {                
                text: Qt.formatDateTime(Time.currentTime, "hh\nmm")

                anchors.bottom: parent.bottom
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignHCenter

                color: "white"
                font.pixelSize: 20
                font.family: "Arial"
                font.weight: Font.Bold
            }
        }
    }

}
