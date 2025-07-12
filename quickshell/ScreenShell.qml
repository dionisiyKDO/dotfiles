import QtQuick
import Quickshell
import "root:/modules"
import "root:/config"

Scope {
    required property var screenModel
    property var scr: screenModel

    Background {
        screenModel: scr
    }

    HorizontalBar {
        screenModel: scr
    }
}