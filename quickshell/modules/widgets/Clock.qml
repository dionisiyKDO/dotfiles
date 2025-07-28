// quickshell/modules/widgets/Clock.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import "root:/config"
import "root:/services"


Item {
    id: root

    required property var format

    property string fontFamily: Appearance.font.family.sans
    property string textFontSize: Appearance.font.size.smaller
    property string textFontColor: Theme.textPrimary
    property string layoutText: Qt.formatDateTime(Time.currentTime, format)

    implicitWidth: clock.implicitWidth
    implicitHeight: parent.height

    Text {
        id: clock
        text: layoutText

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        verticalAlignment: Text.AlignVCenter

        color: textFontColor
        font.pointSize: textFontSize
        font.family: fontFamily
        font.bold: true
    }
}