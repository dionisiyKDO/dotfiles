import "root:/services"
import QtQuick

Item {
    anchors.fill: parent
    anchors.margins: 10

    required property string format

    Text {
        text: Qt.formatDateTime(Time.currentTime, format)

        anchors.centerIn: parent

        font.pixelSize: 20
        font.family: "Arial"
        font.weight: Font.Bold
        color: "white"

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}