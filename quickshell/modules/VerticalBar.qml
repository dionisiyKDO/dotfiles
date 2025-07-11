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

        }
    }
}


