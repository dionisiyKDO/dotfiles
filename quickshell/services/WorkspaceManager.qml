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
    
    // signal workspacesChanged()

    Component.onCompleted: initHyprland();

    // Initialize Hyprland integration
    function initHyprland() {
        try {
            updateHyprlandWorkspaces();
        } catch (e) {
            console.error("Error initializing Hyprland:", e);
        }
    }

    // =======================
    // HYPRLAND EVENT HANDLERS
    // =======================
    // doesn't detect switching workspaces, so listening to Hyprland raw events is necessary
    Connections {
        target: Hyprland.workspaces
        function onValuesChanged() {
            updateHyprlandWorkspaces();
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            updateHyprlandWorkspaces();
        }
    }


    // ==============================
    // WORKSPACE MANAGEMENT FUNCTIONS
    // ==============================
    /**
     * Updates workspaces from Hyprland
     * Converts raw Hyprland workspace data into our ListModel format
     * Called on Hyprland events and during initialization
     */
    function updateHyprlandWorkspaces() {
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
            
            workspacesChanged();
            
        } catch (e) {
            console.error("Error updating Hyprland workspaces:", e);
        }
    }

    /**
     * Switches to the specified workspace
     * @param {int} workspaceId - The ID of the workspace to switch to
     */
    function switchToWorkspace(workspaceId) {
        try {
            Hyprland.dispatch(`workspace ${workspaceId}`);
        } catch (e) {
            console.error("Error switching Hyprland workspace:", e);
        }
    }
}