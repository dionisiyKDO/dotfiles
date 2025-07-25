import QtQuick
import Quickshell
import "root:/modules"
import "root:/config"

Scope {
    required property var screenModel
    property var scr: screenModel

    property bool enableHorizontalBar: false
    property bool enableVerticalBar: true
    

    Background {
        screenModel: scr
    }

    LazyLoader { active: enableHorizontalBar; component: HorizontalBar { screenModel: scr } }
    LazyLoader { active: enableVerticalBar; component: VerticalBar { screenModel: scr } }
}
