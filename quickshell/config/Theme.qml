// Theme.qml
pragma Singleton
import QtQuick

QtObject {
    // Backgrounds
    readonly property color backgroundPrimary: "#0C0D11"     // Deep indigo-black
    readonly property color backgroundSecondary: "#151720"   // Slightly lifted dark
    readonly property color backgroundTertiary: "#1D202B"    // Soft contrast surface

    // Surfaces & Elevation
    readonly property color surface: "#1a2625"               // Material-like base layer
    readonly property color surfaceVariant: "#2a3a3a"        // Lightly elevated

    // Text Colors
    readonly property color textPrimary: "#daf4ef"           // Gentle off-white
    readonly property color textSecondary: "#b7d0cd"         // Muted lavender-blue
    readonly property color textDisabled: "#6b8a7f"          // Dimmed blue-gray

    // Accent Colors
    readonly property color accentPrimary: "#a8ffd6"         // Light enchanted lavender
    readonly property color accentSecondary: "#9effc2"       // Softer lavender hue
    readonly property color accentTertiary: "#8effb9"        // Warm golden glow (from lantern)

    // Error/Warning
    readonly property color error: "#FF6B81"                 // Soft rose red
    readonly property color warning: "#FFBB66"               // Candlelight amber-orange

    // Highlights & Focus
    readonly property color highlight: "#c2f9ff"             // Bright magical lavender
    readonly property color rippleEffect: "#defbff"          // Gentle soft splash

    // Additional Theme Properties
    readonly property color onAccent: "#1A1A1A"              // Text on accent background
    readonly property color outline: "#44485A"               // Subtle bluish-gray line

    // Shadows & Overlays
    readonly property color shadow: "#000000B3"              // Standard soft black shadow
    readonly property color overlay: "#11121ACC"             // Deep bluish overlay
}