import "root:/services"
import QtQuick

Item {
    required property string format

    Text {
        text: Qt.formatDateTime(Time.currentTime, format)

        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter

        color: "white"
        font.pixelSize: 20
        font.family: "Arial"
        font.weight: Font.Bold
    }
}