pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd - MMM d | hh:mm:ss AP")
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}