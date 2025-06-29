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
  height: inputField.implicitHeight + 20
    anchors.horizontalCenter: parent.horizontalCenter
    //signal userSubmitted(string inputText)
    RowLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing:0




        TextEdit {
            id: inputField
            text: ""
            wrapMode: TextEdit.Wrap
            readOnly: false
            selectByMouse: true
            focus: true
            color: "white"
           // placeholderText: "Type here..."  // works in newer Qt or can be custom
            font.pixelSize: 16
            height: 20  // or dynamically grow
            padding: 5
            leftPadding: 12
            width: parent.width

            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    Qt.quit()
                    event.accepted = true
                } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    if (event.modifiers & Qt.ShiftModifier) {
                        inputField.insert("\n");  // ✅ insert newline
                    } else {
                        console.log("User entered:", inputField.text)
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
            anchors.verticalCenter: inputField.verticalCenter
            anchors.left: inputField.left
            anchors.leftMargin: inputField.leftPadding || 12  // match inputField padding
            visible: inputField.text.length === 0
            font.pixelSize: inputField.font.pixelSize
            z: 2
        }

        property int lineCount: Math.ceil(inputField.implicitHeight / inputField.font.pixelSize)

        onLineCountChanged: {
            controlPanel.height = inputField.implicitHeight + 20;
        }





    }



}
