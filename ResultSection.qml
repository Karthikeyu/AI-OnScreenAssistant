import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: resultSection
    width: parent.width - 40
    radius: 16
    //anchors.topMargin: 12
    color: "#2b2b2b"
    border.color: "#444"
    border.width: 1
    anchors.horizontalCenter: parent.horizontalCenter
    visible: resultText.length > 0


    property string resultText: "Ah — now it's crystal clear"

    implicitHeight: resultTextItem.implicitHeight + 32

    TextEdit {
        id: resultTextItem
        text: resultText
        color: "white"
        wrapMode: TextEdit.WordWrap
        width: parent.width - 32
        readOnly: true
        selectByMouse: true
        font.pixelSize: 16
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 30

    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            Qt.quit();
        }
    }


    Connections {
           target: groq
           onResponseReceived: resultTextItem.text = response
       }
}
