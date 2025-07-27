import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Services.Notifications
import "root:/modules"

Scope {
    id: shellRoot

    Variants {
        model: Quickshell.screens

        ScreenShell {
            id: screenComponents
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