// quickshell/modules/widgets/Media.qml
import "root:/config"
import "root:/services"
import "root:/modules/widgets"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris


Item {
    id: root

    readonly property MprisPlayer activePlayer: MprisController.activePlayer
    readonly property string songInfo: {
        if (!activePlayer || !activePlayer.trackTitle) return "No media playing"
        const title = activePlayer.trackTitle
        const artist = activePlayer.trackArtist
        return artist ? `${title} • ${artist}` : title
    }
    
    property string fontFamily: Appearance.font.family.sans
    property string textFontSize: Appearance.font.size.smaller
    property color textFontColor: Theme.textPrimary

    property int buttonSize: 10
    property int buttonRadius: 2
    property string buttonFontSize: Appearance.font.size.smaller

    property bool autoHidden: false
    
    implicitWidth: mediaRow.implicitWidth
    implicitHeight: mediaRow.implicitHeight
    
    opacity: (activePlayer && activePlayer.trackTitle && !autoHidden) ? 1.0 : 0.0
    visible: root.opacity > 0

    // Animate the opacity property whenever it changes
    Behavior on opacity {
        NumberAnimation {
            duration: 400 // Animation duration in milliseconds
            easing.type: Easing.InOutQuad
        }
    }

    
    
    RowLayout {
        id: mediaRow
        anchors.centerIn: parent
        spacing: Appearance.spacing.normal
        
        // Control buttons
        RowLayout {
            id: controlButtons
            spacing: Appearance.spacing.small
            
            // Previous button
            Rectangle {
                width: buttonSize
                height: buttonSize
                radius: buttonRadius
                color: prevMouseArea.containsMouse ? "#1affffff" : "transparent"
                
                Text {
                    text: "⏮"

                    anchors.centerIn: parent

                    color: textFontColor
                    font.pointSize: buttonFontSize
                    font.family: fontFamily
                }
                
                MouseArea {
                    id: prevMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: activePlayer?.previous()
                }
            }
            
            // Play/Pause button
            Rectangle {
                width: buttonSize
                height: buttonSize
                radius: buttonRadius
                color: playMouseArea.containsMouse ? "#1affffff" : "transparent"
                
                Text {
                    text: activePlayer?.playbackState === MprisPlaybackState.Playing ? "⏸" : "▶"

                    anchors.centerIn: parent

                    color: textFontColor
                    font.pointSize: buttonFontSize
                    font.family: fontFamily
                }
                
                MouseArea {
                    id: playMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: activePlayer?.togglePlaying()
                }
            }
            
            // Next button
            Rectangle {
                width: buttonSize
                height: buttonSize
                radius: buttonRadius
                color: nextMouseArea.containsMouse ? "#1affffff" : "transparent"
                
                Text {
                    text: "⏭"

                    anchors.centerIn: parent

                    color: textFontColor
                    font.pointSize: buttonFontSize
                    font.family: fontFamily
                }
                
                MouseArea {
                    id: nextMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: activePlayer?.next()
                }
            }
        }
        
        // Song info
        Text {
            id: songText
            text: songInfo

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            Layout.preferredWidth: 250      // Use Layout.preferredWidth instead of width
            Layout.fillWidth: false         // Don't let it expand beyond preferredWidth
            clip: true                     // Hide overflowing text visually
            elide: Text.ElideRight         // show "..." at the end if text is too long

            color: textFontColor
            font.pointSize: textFontSize
            font.family: fontFamily
            // font.bold: true
        }
    }


    // Timer for auto-hide functionality
    Timer {
        id: autoHideTimer
        interval: 10_000 // 10 seconds
        running: false
        repeat: false
        onTriggered: {
            if (activePlayer && activePlayer.playbackState !== MprisPlaybackState.Playing) {
                autoHidden = true
            }
        }
    }

    // Watch for playback state changes
    Connections {
        target: activePlayer
        function onPlaybackStateChanged() {
            if (activePlayer.playbackState === MprisPlaybackState.Playing) {
                // Player started playing - show widget and reset timer
                autoHidden = false
                autoHideTimer.stop()
            } else {
                // Player paused/stopped - start hide timer
                autoHideTimer.restart()
            }
        }
    }
}