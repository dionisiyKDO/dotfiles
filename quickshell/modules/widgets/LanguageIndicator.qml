// quickshell/modules/widgets/LanguageIndicator.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "root:/config"

Item {
    id: root

    required property string format 

    property string fontFamily: Appearance.font.family.sans
    property string textFontSize: Appearance.font.size.smaller
    property string textFontColor: Theme.textPrimary
    property string textContent: "US"

    implicitWidth: label.implicitWidth
    implicitHeight: parent.height

    Text {
        id: label
        text: textContent

        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: textFontColor
        font.pointSize: textFontSize
        font.family: fontFamily
        font.bold: true
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
                                    if (format === "short") {
                                        textContent = "US";
                                    } else {
                                        textContent = "English";
                                    }
                                } else if (kb.active_keymap == "Russian") {
                                    if (format === "short") {
                                        textContent = "RU";
                                    } else {
                                        textContent = "Russian";
                                    }
                                } else if (kb.active_keymap == "Ukrainian") {
                                    if (format === "short") {
                                        textContent = "UA";
                                    } else {
                                        textContent = "Ukrainian";
                                    }
                                } else {
                                    textContent = kb.active_keymap;
                                }
                                break;
                            }
                        }
                    } else {
                        textContent = "??";
                    }
                } catch (e) {
                    textContent = "??";
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
