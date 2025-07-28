// quickshell/modules/Workspaces.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell.Hyprland
import Quickshell
import Quickshell.Io
import "root:/config"
import "root:/services"

Item {
    id: root
    required property ShellScreen screenModel

    // settings for the dots
    property int dotSize: 8
    property int dotSpacing: 16
    property int containerPadding: 7

    // List of workspaces for THIS screen only
    property ListModel localWorkspaces: ListModel {}

    height: parent.width
    width: localWorkspaces.count * (dotSize + dotSpacing) - dotSpacing + (containerPadding * 2)



    Component.onCompleted: reloadLocalWorkspaces();

    // Listen for workspace changes from WorkspaceManager
    Connections {
        target: WorkspaceManager
        function onWorkspaceChanged() {
            reloadLocalWorkspaces();
        }
    }

    // Scroll to switch workspaces
    WheelHandler {
        onWheel: (event) => {
            if (event.angleDelta.y < 0) {
                Hyprland.dispatch(`workspace r+1`);
            } else if (event.angleDelta.y > 0) {
                Hyprland.dispatch(`workspace r-1`);
            }
        }
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    }

    // function to get workspaces for this screen only
    function reloadLocalWorkspaces() {
        localWorkspaces.clear();
        
        // Go through all workspaces and only keep ones for this screen
        for (let i = 0; i < WorkspaceManager.workspaces.count; i++) {
            const ws = WorkspaceManager.workspaces.get(i);
            
            if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                localWorkspaces.append(ws);
            }
        }
    }


    // Background container for workspaces
    Rectangle {
        id: workspaceBackground

        anchors.centerIn: parent

        width: localWorkspaces.count * (dotSize + dotSpacing) - dotSpacing + (containerPadding * 2)
        height: dotSize + (containerPadding * 2)

        color: Theme.surfaceVariant
        radius: 8
    }

    // Column of dots(workspaces)
    Row {
        anchors.centerIn: parent
        spacing: dotSpacing

        // Create a dot for each workspace
        Repeater {
            model: localWorkspaces // source of workspaces

            // Each dot
            Rectangle {
                width: dotSize
                height: dotSize
                radius: dotSize / 2  // Makes it perfectly round

                // Color based on workspace state
                color: {
                    if (model.isFocused) {
                        return Theme.accentPrimary;                 // Current workspace - bright
                    } else if (model.isActive) {
                        return Theme.accentPrimary.lighter(150);    // Has windows - medium
                    } else if (model.isUrgent) {
                        return Theme.error;                         // Needs attention - red
                    } else {
                        return Qt.rgba(Theme.accentPrimary.r, Theme.accentPrimary.g, Theme.accentPrimary.b, 0.6); // Empty - dim
                    }
                }

                // ANIMATION: Smooth color changes when workspace state changes
                Behavior on color {
                    ColorAnimation {
                        duration: 200  // 200ms to change color
                        easing.type: Easing.OutCubic  // Smooth easing
                    }
                }

                // ANIMATION: Smooth size changes - focused dot gets slightly bigger
                scale: model.isFocused ? 1.2 : 1.0  // 20% bigger when focused
                Behavior on scale {
                    NumberAnimation {
                        duration: 300  // 300ms to change size
                        easing.type: Easing.OutBack  // Bouncy effect
                    }
                }

                // ANIMATION: Subtle opacity pulse for urgent workspaces
                opacity: model.isUrgent ? 0.7 : 1.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 500  // 500ms fade
                        easing.type: Easing.InOutQuad
                    }
                }

                // Make dots clickable
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        WorkspaceManager.switchToWorkspace(model.idx);
                    }

                    // ANIMATION: Hover effect - dot gets slightly bigger on hover
                    onEntered: parent.scale = model.isFocused ? 1.2 : 1.1
                    onExited: parent.scale = model.isFocused ? 1.2 : 1.0
                }
            }
        }
    }

}
