// quickshell/modules/Workspaces.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import "root:/config"
import "root:/services"

Item {
    id: root
    required property ShellScreen screen

    property int verticalPadding: 16
    property int spacingBetweenPills: 8
    property int pillWidth: 12
    property int pillHeightFocused: 22
    property int pillHeightActive: 20
    property int pillHeightInactive: 16

    // Only contains workspaces **on this screen**
    // The global WorkspaceManager lists all screens' workspaces, but we filter per-display here
    property ListModel localWorkspaces: ListModel {}

    // Useful for parent components to react to workspace focus changes
    // For example: change wallpaper, animate other shell parts, etc.
    signal workspaceChanged(int workspaceId, color accentColor)

    // ==========
    // DIMENSIONS

    width: 36
    height: {
        let total = 0;
        
        // Calculate height based on workspace states
        for (let i = 0; i < localWorkspaces.count; i++) {
            const ws = localWorkspaces.get(i);
            // Focused workspace is taller than active, which is taller than inactive
            total += ws.isFocused ? pillHeightFocused : 
                     ws.isActive ? pillHeightActive : 
                     pillHeightInactive;
        }
        
        // Add spacing between pills
        total += Math.max(localWorkspaces.count - 1, 0) * spacingBetweenPills;
        
        // Add vertical padding
        total += verticalPadding * 2;
        
        return total;
    }

    // ==============
    // INITIALIZATION

    Component.onCompleted: {
        reloadLocalWorkspaces();
    }

    // ==============
    // EVENT HANDLERS

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

    // Listen for workspace changes from WorkspaceManager
    Connections {
        target: WorkspaceManager
        function onWorkspacesChanged() {
            reloadLocalWorkspaces();
        }
    }

    // ==============================
    // WORKSPACE MANAGEMENT FUNCTIONS

    /**
     * Reloads local workspaces for this specific screen
     * Filters global WorkspaceManager workspaces to only include those on this screen
     */
    function reloadLocalWorkspaces() {
        localWorkspaces.clear();
        
        for (let i = 0; i < WorkspaceManager.workspaces.count; i++) {
            const ws = WorkspaceManager.workspaces.get(i);
            
            if (ws.output.toLowerCase() === screen.name.toLowerCase()) {
                localWorkspaces.append(ws);
            }
        }
    }

    // =================
    // VISUAL COMPONENTS

    // Background container for workspace pills
    Rectangle {
        id: workspaceBackground

        // Dimensions
        height: parent.height - 15
        width: 26

        // Positioning
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        // Styling
        radius: 12
        color: Theme.surfaceVariant
        border.color: Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.1)
        border.width: 3

        // Optional shadow effect
        // layer.enabled: true
        // layer.effect: DropShadow {
        //     color: "black"
        //     radius: 12
        //     samples: 24
        //     verticalOffset: 0
        //     horizontalOffset: 0
        //     opacity: 0.10
        // }
    }

    // Container for workspace pills
    Column {
        id: wsColumn

        // Positioning
        anchors.horizontalCenter: workspaceBackground.horizontalCenter
        y: verticalPadding // Padding from top

        // Layout
        spacing: spacingBetweenPills
        height: root.height - verticalPadding * 2
        width: 12

        // Workspace pill repeater
        Repeater {
            id: workspaceRepeater
            model: localWorkspaces

            // Individual workspace container
            Item {
                id: workspaceContainer
                
                width: 12
                height: model.isFocused ?   pillHeightFocused : 
                        model.isActive ?    pillHeightActive : 
                                            pillHeightInactive

                // Workspace pill
                Rectangle {
                    id: workspace

                    
                    anchors.fill: parent

                    // Styling based on workspace state
                    radius: model.isFocused ? 12 : 6
                    scale: model.isFocused ? 1.0 : 0.9
                    
                    color: {
                        if (model.isFocused) {
                            return Theme.accentPrimary;
                        } else if (model.isActive) {
                            return Theme.accentPrimary.lighter(130);
                        } else if (model.isUrgent) {
                            return Theme.error;
                        } else {
                            return Qt.lighter(Theme.surfaceVariant, 1.6);
                        }
                    }

                    // Click handler
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        z: 20 // Always clickable
                        
                        onClicked: {
                            WorkspaceManager.switchToWorkspace(model.idx);
                        }
                    }
                }
            }
        }
    }
}