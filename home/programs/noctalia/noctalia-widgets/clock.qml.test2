import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets

DraggableDesktopWidget {
    id: root

    property var pluginApi: null

    // Widget dimensions - scaled
    implicitWidth: Math.round(280 * widgetScale)
    implicitHeight: Math.round(140 * widgetScale)
    width: implicitWidth
    height: implicitHeight

    // Performance: Disable expensive effects during scaling
    layer.enabled: Settings.data.general.enableShadows && !root.isScaling
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowBlur: 0.5
    }

    // Drop shadow - hidden during scaling for performance
    NDropShadow {
        visible: !root.isScaling
        anchors.fill: contentLayout
        source: contentLayout
        shadowBlur: 1.0
        shadowOpacity: 0.9
    }

    // Background - ensure visibility
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "#333333"
        border.width: 1
        radius: 8
    }

    // Current time - updates every second
    property date currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.currentTime = new Date()
        }
    }

    // Format time as HH:MM:SS
    function formatTime(date) {
        var hours = date.getHours().toString().padStart(2, '0')
        var minutes = date.getMinutes().toString().padStart(2, '0')
        var seconds = date.getSeconds().toString().padStart(2, '0')
        return hours + ":" + minutes + ":" + seconds
    }

    // Format date as localized string
    function formatDate(date) {
        var options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        }
        return date.toLocaleDateString(undefined, options)
    }

    // Main content layout
    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: Math.round(Style.marginL * widgetScale)
        spacing: Math.round(Style.marginS * widgetScale)

        // Time display
        NText {
            id: timeText
            text: root.formatTime(root.currentTime)
            pointSize: Math.round(Style.fontSizeXL * widgetScale)
            font.weight: Font.Bold
            color: "#ffffff"
            Layout.alignment: Qt.AlignHCenter

            // Disable animations during scaling/dragging
            Behavior on pointSize {
                enabled: !root.isScaling && !root.isDragging
                NumberAnimation { duration: 200 }
            }
        }

        // Date display
        NText {
            id: dateText
            text: root.formatDate(root.currentTime)
            pointSize: Math.round(Style.fontSizeM * widgetScale)
            color: "#e0e0e0"
            Layout.alignment: Qt.AlignHCenter

            Behavior on pointSize {
                enabled: !root.isScaling && !root.isDragging
                NumberAnimation { duration: 200 }
            }
        }
    }
}

