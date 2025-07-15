import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "root:/config"



Rectangle {
    id: notificationDelegate
    
    // Public properties
    property string appName: ""
    property string summary: ""
    property string body: ""
    property var rawNotification: null
    property string iconSource: ""
    property int timeout: 4000
    
    // Internal state
    property bool isAppearing: false
    property bool isDismissing: false
    
    // Signals
    signal removeFromModel()
    
    // Styling
    color: Theme.backgroundPrimary
    radius: 0
    border.color: Theme.backgroundSecondary
    border.pixelAligned: true
    border.width: 2
    
    // Initial state - hidden
    opacity: 0
    height: 0
    x: width
    
    // Content layout
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 10 // spacing between icon and text
        width: parent.width - 20

        // Icon container
        Rectangle {
            id: iconBackground      
            width: 36
            height: 36
            radius: width / 2
            color: Theme.accentPrimary
            clip: false
            anchors.verticalCenter: parent.verticalCenter
            border.color: Qt.darker(Theme.accentPrimary, 1.2)
            border.width: 1.5

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: iconSource
                smooth: true
                cache: false
                asynchronous: true
                visible: status === Image.Ready && source.toString() !== ""
            }

            // Fallback text icon
            Text {
                anchors.centerIn: parent
                visible: !iconImage.visible
                text: appName ? appName.charAt(0).toUpperCase() : "?"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeBody
                font.bold: true
                color: Theme.backgroundPrimary
            }
        }

        // Text content
        Column {
            width: contentRow.width - iconBackground.width - 10
            spacing: 0

            Text {
                text: appName
                color: Theme.textPrimary
                
                width: parent.width

                font.family: Theme.fontFamily
                font.bold: true
                font.pixelSize: Theme.fontSizeSmall
                elide: Text.ElideRight
            }
            
            Text {
                text: summary
                width: parent.width
                color: "#eeeeee"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                visible: text !== ""
            }
            
            Text {
                text: body
                width: parent.width
                color: "#cccccc"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeCaption
                wrapMode: Text.Wrap
                visible: text !== ""
            }
        }
    }

    // Appear animation
    ParallelAnimation {
        id: appearAnimation
        NumberAnimation { 
            target: notificationDelegate
            property: "opacity"
            from: 0
            to: 1
            duration: 200
            easing.type: Easing.OutQuad
        }
        NumberAnimation { 
            target: notificationDelegate
            property: "height"
            from: 0
            to: contentRow.height + 20
            duration: 200
            easing.type: Easing.OutQuad
        }
        NumberAnimation { 
            target: notificationDelegate
            property: "x"
            from: width
            to: 0
            duration: 200
            easing.type: Easing.OutQuad
        }
        onFinished: {
            isAppearing = false;
            autoTimer.start();
        }
    }

    // Dismiss animation
    ParallelAnimation {
        id: dismissAnimation
        NumberAnimation { 
            target: notificationDelegate
            property: "opacity"
            to: 0
            duration: 150
            easing.type: Easing.InQuad
        }
        NumberAnimation { 
            target: notificationDelegate
            property: "height"
            to: 0
            duration: 150
            easing.type: Easing.InQuad
        }
        NumberAnimation { 
            target: notificationDelegate
            property: "x"
            to: width
            duration: 150
            easing.type: Easing.InQuad
        }
        onFinished: {
            isDismissing = false;
            notificationDelegate.removeFromModel();
        }
    }

    // Auto-dismiss timer
    Timer {
        id: autoTimer
        interval: timeout
        running: false
        repeat: false
        onTriggered: dismiss()
    }

    // Click to dismiss
    MouseArea {
        anchors.fill: parent
        onClicked: dismiss()
    }

    // Public methods
    function dismiss() {
        if (isDismissing) return;
        
        isDismissing = true;
        autoTimer.stop();
        
        if (rawNotification) {
            rawNotification.dismiss();
        }
        
        dismissAnimation.start();
    }

    // Initialize appearance animation
    Component.onCompleted: {
        isAppearing = true;
        appearAnimation.start();

        // debug raw notif data
        // console.log("\n",
        //     "appIcon: ", rawNotification.appIcon, "\n",
        //     "appName: ", rawNotification.appName, "\n",
        //     "body: ", rawNotification.body, "\n",
        //     "desktopEntry: ", rawNotification.desktopEntry, "\n",
        //     "expireTimeout: ", rawNotification.expireTimeout, "\n",
        //     "hasActionIcons: ", rawNotification.hasActionIcons, "\n",
        //     "hints: ", rawNotification.hints, "\n",
        //     "id: ", rawNotification.id, "\n",
        //     "image: ", rawNotification.image, "\n",
        //     "lastGeneration: ", rawNotification.lastGeneration, "\n",
        //     "resident: ", rawNotification.resident, "\n",
        //     "summary: ", rawNotification.summary, "\n",
        //     "tracked: ", rawNotification.tracked, "\n",
        //     "transient: ", rawNotification.transient, "\n",
        //     "urgency: ", rawNotification.urgency, "\n"
        // )
    }
}


// Spotify notification data
// DEBUG qml: 
//  appIcon:   
//  appName:  Spotify 
//  body:  Colorblind - Motionless 
//  desktopEntry:   
//  expireTimeout:  -1 
//  hasActionIcons:  false 
//  hints:  TypeError: Type error 
//  id:  102 
//  image:  image://qsimage/102/1 
//  lastGeneration:  false 
//  resident:  false 
//  summary:  Motionless 
//  tracked:  true 
//  transient:  false 
//  urgency:  0 


// My test notification data
//  DEBUG qml: 
//  appIcon:  "https://cdn.discordapp.com/avatars/196292133496422400/0b2bb604fc48587da279cb75c3f01d54.webp?size=64" 
//  appName:  GitHub 
//  body:  https://github.com/dionisiyKDO 
//  desktopEntry:   
//  expireTimeout:  -1 
//  hasActionIcons:  false 
//  hints:  TypeError: Type error 
//  id:  103 
//  image:   
//  lastGeneration:  false 
//  resident:  false 
//  summary:  yo 
//  tracked:  true 
//  transient:  false 
//  urgency:  1 