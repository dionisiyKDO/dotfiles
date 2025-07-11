// LanguageIndicator.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland

Item {
    id: root

    Text {
        id: appid

        color: "white"
        // font.bold: true
        font.pointSize: 9

        anchors.top: parent.top
        anchors.left: parent.left

        text: ToplevelManager.activeToplevel?.appId ?? qsTr("Desktop")
    }

    Text {
        id: title

        color: "white"
        font.bold: true
        font.pointSize: 10

        anchors.top: appid.bottom
        anchors.left: parent.left
        anchors.topMargin: -3

        text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
    }
}
