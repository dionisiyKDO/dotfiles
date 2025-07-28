// quickshell/NotificationPopup.qml
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "root:/config"

PanelWindow {
    id: window

    color: "transparent"
    implicitWidth: 350
    implicitHeight: notificationColumn.implicitHeight + 60
    
    visible: notificationModel.count > 0
    screen: null
    focusable: false

    anchors.top: true
    anchors.right: true
    margins.top: 6
    margins.right: 6 

    // Configuration
    readonly property int maxVisible: 10
    readonly property int spacing: 5
    readonly property int notificationTimeout: 4000
    readonly property string targetScreenName: "DP-2" // "HDMI-A-1"  "DP-2"
    
    // Models and data
    ListModel {
        id: notificationModel
    }

    // Screen assignment - find target screen by name
    function assignToTargetScreen() {
        for (let i = 0; i < Quickshell.screens.length; ++i) {
            const screen = Quickshell.screens[i];
            if (screen.name === targetScreenName) {
                console.log("Assigning notifications to screen:", screen);
                window.screen = screen;
                return;
            }
        }
        console.warn(`Screen "${targetScreenName}" not found in Quickshell.screens`);
    }

    // Notification management
    function addNotification(notification) {
        notificationModel.insert(0, {
            id: notification.id,
            appName: notification.appName || "Notification",
            summary: notification.summary || "",
            body: notification.body || "",
            rawNotification: notification
        });

        // Remove excess notifications
        while (notificationModel.count > maxVisible) {
            notificationModel.remove(notificationModel.count - 1);
        }
    }

    function dismissNotificationById(id) {
        for (let i = 0; i < notificationModel.count; i++) {
            const item = notificationModel.get(i);
            if (item.id === id) {
                notificationRepeater.itemAt(i)?.dismiss();
                break;
            }
        }
    }

    // Get valid icon source from notification
    function getIconSource(rawNotification) {
        const sources = [
            rawNotification?.image || "",
            rawNotification?.appIcon || "",
            rawNotification?.icon || ""
        ];

        

        for (const icon of sources) {
            if (!icon) continue;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                const fileName = name.substring(name.lastIndexOf("/") + 1);
                return `file://${path}/${fileName}`;
            }

            if (icon.startsWith('/')) {
                return "file://" + icon;
            }
            
            return icon;
        }
        return "";
    }

    Component.onCompleted: {
        assignToTargetScreen()
    }
    

    // Debug send notification
    // Process {
    //     id: debugProcess
    //     command: ["notify-send", "yo", "https://github.com/dionisiyKDO", "--app-name=GitHub"]
    //     running: true
    // }

    Column {
        id: notificationColumn
        anchors.right: parent.right
        spacing: window.spacing
        width: parent.width
        clip: false

        Repeater {
            id: notificationRepeater
            model: notificationModel

            delegate: NotificationDelegate {
                id: delegate
                width: parent.width
                
                // Data properties
                appName: model.appName
                summary: model.summary
                body: model.body
                rawNotification: model.rawNotification
                
                // Behavior properties
                timeout: window.notificationTimeout
                iconSource: window.getIconSource(model.rawNotification)
                
                onRemoveFromModel: {
                    notificationModel.remove(model.index);
                }
            }
        }
    }

    // Handle screen changes
    Connections {
        target: Quickshell
        function onScreensChanged() {
            if (window.screen) {
                x = window.screen.width - width - 20;
            }
        }
    }
}
