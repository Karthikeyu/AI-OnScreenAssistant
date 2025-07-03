import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: controlPanel
    width: parent.width -40
    color: "#303030"
    border.color: "#888"
    border.width: 2
    radius:16
    height: inputField.implicitHeight
    anchors.horizontalCenter: parent.horizontalCenter
    //signal userSubmitted(string inputText)




    TextEdit {
        id: inputField
        text: ""
        width: parent.width - 24
        wrapMode: TextEdit.Wrap
        readOnly: false
        selectByMouse: true
        focus: true
        color: "white"
        font.pixelSize: 16
        height: Math.min(200, implicitHeight)
        leftPadding: 12
        topPadding: 12

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                shutdown.shutdownApp()
                event.accepted = true
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                if (event.modifiers & Qt.ShiftModifier) {
                    // Allow Shift+Enter to insert newline
                    inputField.insert("\n")
                    event.accepted = true
                } else {
                    // Submit normally
                    console.log("User entered:", inputField.text)
                    root.isLoading = true
                    groq.sendRequest(inputField.text)
                    inputField.clear()
                    event.accepted = true
                }
            }
        }
    }

        MouseArea {
            anchors.fill: parent
            z: 1
            onPressed: inputField.forceActiveFocus()
            hoverEnabled: true
            cursorShape: Qt.IBeamCursor
        }

        Text {
            id: placeholder
            text: "Type here..."
            color: "#AAAAAA"
            font.pixelSize: inputField.font.pixelSize
            x: inputField.leftPadding    // align horizontally
            topPadding: inputField.topPadding
            visible: inputField.text.length === 0
            z: 2
        }

        BusyIndicator {
            running: root.isLoading
            visible: root.isLoading
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48
            z: 2

        }




        Behavior on height {
            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        }




        property int lineCount: Math.ceil(inputField.implicitHeight / inputField.font.pixelSize)

        onLineCountChanged: {
            controlPanel.height = inputField.implicitHeight + 20;
        }









}
