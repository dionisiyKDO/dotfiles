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

                Text {
                    id: clss
                    color: "white"
                    font.pixelSize: 10

                    text: ToplevelManager.activeToplevel?.appId ?? qsTr("Desktop")
                }

                Text {
                    id: title
                    color: "white"
                    font.pixelSize: 14
                    
                    anchors.top: clss.bottom
                    anchors.topMargin: -3

                    text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
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


                
                // Anchor to the left od the clock
                // Text {
                //     id: text
                //     color: "white"

                //     anchors.right: clock.left
                //     anchors.verticalCenter: parent.verticalCenter
                //     anchors.rightMargin: Appearance.spacing.large
                //     anchors.leftMargin: Appearance.spacing.large

                //     text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
                // }

                ClockWidget {
                    id: clock
                    color: "white"

                    anchors.centerIn: parent
                    anchors.rightMargin: Appearance.spacing.large
                    anchors.leftMargin: Appearance.spacing.large
                }
            }


            // **Right** 
            //      Window title/class
            Item {
                id: right

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.rightMargin: Appearance.spacing.small
                implicitHeight: 30

                Text {
                    id: rclss
                    color: "white"
                    font.pixelSize: 10

                    anchors.right: parent.right

                    text: ToplevelManager.activeToplevel?.appId ?? qsTr("Desktop")
                }

                Text {
                    id: rtitle
                    color: "white"
                    font.pixelSize: 14
                    
                    anchors.top: rclss.bottom
                    anchors.right: parent.right
                    anchors.topMargin: -3

                    text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
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


