import Quickshell
import QtQuick
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import "root:/modules"

Scope {
    Variants {
        model: Quickshell.screens

        ScreenShell {
            property var modelData
            screenModel: modelData
        }
    }

    NotificationServer {
        id: notificationServer
        onNotification: function(notification) {
            console.log("Notification received:", notification.appName);
            notification.tracked = true;
            notificationPopup.addNotification(notification);
        }
    }

    NotificationPopup {
        id: notificationPopup
    }
}