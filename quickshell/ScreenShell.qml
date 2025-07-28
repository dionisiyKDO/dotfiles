// quickshell/ScreenShell.qml
import QtQuick
import Quickshell
import "root:/modules"
import "root:/config"

Scope {
    required property var screenModel
    property var scr: screenModel

    property bool enableHorizontalBar: true
    property bool enableBackground: true
    

    LazyLoader {
        active: enableBackground
        component: Background {
            screenModel: scr
        }
    }

    LazyLoader { 
        active: enableHorizontalBar; 
        component: HorizontalBar { 
            screenModel: scr 
            visible: screenModel.name == "DP-2"
        } 
    }


    
    // property bool enableVerticalBar: false 
    // LazyLoader { 
    //     active: enableVerticalBar; 
    //     component: VerticalBar { 
    //         screenModel: scr 
    //         visible: screenModel.name == "DP-2"
    //     } 
    // }
}
