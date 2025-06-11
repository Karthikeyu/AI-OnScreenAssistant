import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: "AI Assistant Base"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
    color: "#00000000"

    property string resultText: ""

    // Fullscreen overlay at top
    OverlayWindow {
        id: overlayWindow
    }

    // Scrollable section with control panel and results in a rectangle
    Flickable {
        id: scrollArea
        anchors {
            top: overlayWindow.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 20
        }

        contentWidth: parent.width
        contentHeight: backgroundContainer.height
        clip: true
        boundsBehavior: Flickable.StopAtBounds

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            active: true

            background: Rectangle {
                color: "#111111"
                radius: 5
            }

            contentItem: Rectangle {
                implicitWidth: 15
                radius: 3
                color: "#888888"
            }
        }

        Rectangle {
            id: backgroundContainer
            width: parent.width
            height: contentColumn.implicitHeight +10
            color: "#222222"
            radius: 12
            border.color: "#444444"
            border.width: 1
            anchors.horizontalCenter: parent.horizontalCenter


            Column {
                id: contentColumn
                width: parent.width
                spacing: 20
                padding: 20
                anchors.margins: 20

                ControlPanel {
                    id: controlPanel
                    width: parent.width - 200
                    height: 80
                }

                ResultSection {
                    id: resultSection
                    width: parent.width - 200
                    visible: resultText.length > 0
                    resultText: root.resultText
                }
            }
        }
    }

    // Populate sample data to test scrolling
    Component.onCompleted: {
        root.resultText = Array(50).fill("Line of result text").join("\n")
    }
}
