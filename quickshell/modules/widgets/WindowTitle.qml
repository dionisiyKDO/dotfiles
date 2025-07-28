// quickshell/modules/widgets/WindowTitle.qml
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import "root:/config"

Item {
    id: root

    property string fontFamily: Appearance.font.family.sans

    property string appIdFontSize: Appearance.font.size.smaller
    property string titleFontSize: Appearance.font.size.smaller

    property string appIdFontColor: Theme.textPrimary
    property string titleFontColor: Theme.textPrimary

    property string appIdText: (ToplevelManager.activeToplevel?.appId ?? qsTr("Desktop")) + ": "
    property string titleText: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
    
    implicitWidth: (appid.implicitWidth > title.implicitWidth) ? appid.implicitWidth : title.implicitWidth
    implicitHeight: parent.height

    Text {
        id: appid
        text: appIdText

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        verticalAlignment: Text.AlignVCenter

        color: appIdFontColor
        font.pointSize: appIdFontSize
        font.family: fontFamily
        font.bold: true
    }

    Text {
        id: title
        text: titleText

        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: appid.right
        verticalAlignment: Text.AlignVCenter
        
        width: 350
        clip: true                     // Hide overflowing text visually
        elide: Text.ElideRight         // show "..." at the end if text is too long

        color: titleFontColor
        font.pointSize: titleFontSize
        font.family: fontFamily
        // font.bold: true
    }
}




// Version appId and title on top of each other
// import QtQuick
// import QtQuick.Controls
// import Quickshell.Io
// import Quickshell.Wayland

// Item {
//     id: root

//     implicitWidth: (appid.implicitWidth > title.implicitWidth) ? appid.implicitWidth : title.implicitWidth
//     implicitHeight: parent.height

//     Text {
//         id: appid

//         color: "white"
//         // font.bold: true
//         font.pointSize: 9

//         anchors.top: parent.top
//         anchors.left: parent.left

//         text: ToplevelManager.activeToplevel?.appId ?? qsTr("Desktop")
//     }

//     Text {
//         id: title

//         color: "white"
//         font.bold: true
//         font.pointSize: 10

//         anchors.top: appid.bottom
//         anchors.left: parent.left
//         anchors.topMargin: -3

//         width: 500
//         clip: true                     // Hide overflowing text visually
//         elide: Text.ElideRight         // show "..." at the end if text is too long

//         text: ToplevelManager.activeToplevel?.title ?? qsTr("Desktop")
//     }
// }

