import Quickshell
import QtQuick
import Quickshell.Wayland
import "root:/config"
import "root:/widgets"


Scope {
    Variants {
        model: Quickshell.screens // for each screan in Quickshell.screens create PanelWindow
        
        PanelWindow {
            property var modelData // screen from the screens list will be injected into this property
            screen: modelData // set the the screen on which it is shown as the injected screen, so it creates bar for each screen

            // left bar
            // implicitWidth: 30
            // anchors {
            //     top: true
            //     left: true
            //     bottom: true
            // }

            // top bar
            implicitHeight: 30
            anchors {
                top: true
                left: true
                right: true
            }

            Rectangle {
                anchors.fill: parent
                color: "#000000"
            }

            Item {
                id: child

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                
                implicitHeight: 30

                Text {
                    id: text
                    color: "white"

                    anchors.right: clock.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: Appearance.spacing.large
                    anchors.leftMargin: Appearance.spacing.large

                    text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
                }

                ClockWidget {
                    id: clock
                    color: "white"

                    anchors.centerIn: parent
                    anchors.rightMargin: Appearance.spacing.large
                    anchors.leftMargin: Appearance.spacing.large
                }

                // Tray {
                //     id: tray

                //     anchors.horizontalCenter: parent.horizontalCenter
                //     anchors.bottom: clock.top
                //     anchors.bottomMargin: Appearance.spacing.larger
                // }
            }
        }
    }
}


