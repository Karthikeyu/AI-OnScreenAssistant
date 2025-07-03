import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15


Window {
    id: root
    objectName: "mainAppWindow"
    visible: true
    width: Screen.width
    //height: screenHeight  // Only occupy the bottom strip
    height: controlPanel.height + Math.min(resultSection.implicitHeight, bottomPanel.maxResultHeight) + 80
   // only take required height
    y: Screen.height - height- 20         // align window to bottom of screen
    title: "AI Assistant Base"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    property bool isLoading: false
    onResultTextChanged: {
            Qt.callLater(() => {
                resultSection.visible = resultText.length > 0
            })
        }

    property string resultText: ""
    Behavior on height {
        NumberAnimation {
            duration: 40

        }
    }
    Behavior on y {
        NumberAnimation {
            duration: 80
            easing.type: Easing.OutCubic
        }
    }




    Rectangle {
        id: bottomPanel
        width: parent.width
        height: screenHeight
        color: "#99000000"
        radius: 16

        border.width: 2
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 10
            rightMargin : 10
            topMargin: 10
        }

           border.color: "#00ffff"

        property int controlPanelHeight: controlPanel.height
        property int maxResultHeight: 200

        property int actualResultHeight: Math.min(resultSection.implicitHeight, maxResultHeight)
        property int screenHeight: controlPanelHeight + resultFlick.height + 80


        Column {
            id: contentColumn
            width: parent.width
            spacing: 20
            topPadding: 30

            ControlPanel {
                id: controlPanel
            }

            Flickable {
                id: resultFlick
                width: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
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




