// quickshell/services/WorkspaceManager.qml
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property var hlWorkspaces: Hyprland.workspaces.values // Raw Hyprland workspaces
    property ListModel workspaces: ListModel {} // Processed list of workspaces
    
    signal workspaceChanged()

    Component.onCompleted: updateWorkspaces();

    // When Hyprland workspaces change, update our list
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateWorkspaces();
        }
    }

    // When any Hyprland event happens, update our list
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            updateWorkspaces();
        }
    }


    // function to update workspace list
    function updateWorkspaces() {
        Hyprland.refreshWorkspaces(); // Refresh workspaces state
        hlWorkspaces = Hyprland.workspaces.values; // Get raw Hyprland workspaces data
        workspaces.clear(); // Clear existing workspaces data

        try {
            for (let i = 0; i < hlWorkspaces.length; i++) {
                const ws = hlWorkspaces[i];
                
                workspaces.append({
                    id: i,
                    idx: ws.id,
                    name: ws.name || "", // Workspace name (defaults to "1", "2", etc)
                    output: ws.monitor?.name || "", // Monitor this workspace is assigned to
                    isActive: ws.active === true,
                    isFocused: ws.focused === true,
                    isUrgent: ws.urgent === true
                });
            }
            
            workspaceChanged();
            
        } catch (e) {
            console.error("Error updating Hyprland workspaces:", e);
        }
    }

    // function to switch workspaces
    function switchToWorkspace(workspaceId) {
        try {
            Hyprland.dispatch(`workspace ${workspaceId}`);
        } catch (e) {
            console.error("Error switching Hyprland workspace:", e);
        }
    }
}