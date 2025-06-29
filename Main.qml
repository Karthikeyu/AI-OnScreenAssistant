import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root
    objectName: "mainAppWindow"
    visible: true
    width: Screen.width
    //height: screenHeight  // Only occupy the bottom strip
    height: bottomPanel.screenHeight   // only take required height
        y: Screen.height - height          // align window to bottom of screen
    title: "AI Assistant Base"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "#00000000"


    property string resultText: ""



    Rectangle {
        id: bottomPanel
        width: parent.width
        height: screenHeight
        color: "#222222"
        radius: 12
        border.color: "#444444"
        border.width: 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 5
        }

        property int controlPanelHeight: 80
        property int maxResultHeight: 200

        property int actualResultHeight: Math.min(resultSection.implicitHeight, maxResultHeight)
        property int screenHeight: controlPanelHeight + actualResultHeight + 40


        Column {
            id: contentColumn
            width: parent.width
            spacing: 10
            padding: 20

            ControlPanel {
                id: controlPanel
                width: parent.width - 40
                height: bottomPanel.controlPanelHeight
            }

            Flickable {
                id: resultFlick
                width: parent.width - 40
                //height: bottomPanel.maxResultHeight
                height: Math.min(resultSection.implicitHeight, bottomPanel.maxResultHeight)
                clip: true
                contentHeight: resultSection.implicitHeight
                boundsBehavior: Flickable.StopAtBounds

                ResultSection {
                    id: resultSection
                    width: resultFlick.width
                    resultText: root.resultText
                    visible: resultText.length > 0
                }

                ScrollBar.vertical: ScrollBar {
                    width: 8
                    policy: ScrollBar.AsNeeded
                    active: true

                    contentItem: Rectangle {
                        implicitWidth: 8
                        radius: 4
                        color: "#888888"
                    }

                    background: Rectangle {
                        color: "#333333"
                        radius: 4
                        width: 8
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        root.resultText = "Please ask any question to fetch the answer. Press ESC to quit."
    }
}




