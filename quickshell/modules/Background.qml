import QtQuick
import Quickshell
import Quickshell.Wayland
import "root:/config"


PanelWindow {
    required property var screenModel
    screen: screenModel

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "quickshell-wallpaper"

    color: "transparent"
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    Image {
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: Settings.currentWallpaper !== "" ? Settings.currentWallpaper : Settings.favoriteWallpaper
        cache: true
        smooth: true
    }
}