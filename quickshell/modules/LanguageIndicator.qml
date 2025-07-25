// LanguageIndicator.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    id: root

    property string layoutText: "US"

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    Text {
        id: label

        color: "white"
        font.bold: true
        font.pointSize: 12

        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: layoutText
    }

    Process {
        id: devicesProc
        command: ["hyprctl", "devices", "-j"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const json = JSON.parse(this.text);
                    if (json && json.keyboards) {
                        for (const kb of json.keyboards) {
                            if (kb.main) {
                                if (kb.active_keymap == "English (US)") {
                                    layoutText = "US";
                                } else if (kb.active_keymap == "Russian") {
                                    layoutText = "RU";
                                } else if (kb.active_keymap == "Ukrainian") {
                                    layoutText = "UA";
                                } else {
                                    layoutText = kb.active_keymap;
                                }
                                break;
                            }
                        }
                    } else {
                        layoutText = "??";
                    }
                } catch (e) {
                    layoutText = "??";
                }
            }
        }
    }

    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: devicesProc.running = true
    }
}
