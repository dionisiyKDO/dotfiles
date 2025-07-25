pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property date currentTime: clock.date
    SystemClock { id: clock; precision: SystemClock.Seconds }
}
