import QtQuick 2.15
import QtQuick.Window 2.15


Window {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: "AI Assistant Base"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    color: "#00000000"

    // Key handler container
    Item {
        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: Qt.quit() // or root.close()

    }



        // Reserve space for control panel
        Overlay {
            id: overlayWindow
        }
        // Launch overlay on top
        Component.onCompleted: overlayWindow.show()

        // Control panel docked at the bottom
        ControlPanel {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: 20
            }
            height: 180
        }
}
