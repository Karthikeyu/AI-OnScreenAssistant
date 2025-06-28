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

    Text {
        padding: 30
        id: resultTextItem
        text: resultText
        color: "white"
        wrapMode: Text.WordWrap
        width: parent.width - 32
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 16
    }

    Connections {
           target: groq
           onResponseReceived: resultTextItem.text = response
       }
}
