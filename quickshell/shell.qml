import Quickshell
import QtQuick
import "root:/modules"



Scope {
    Variants {
        model: Quickshell.screens

        ScreenShell {
            property var modelData  // 👈 you MUST declare this
            screenModel: modelData  // ✅ now it's valid
        }
    }
}