import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: controlPanel
    width: parent.width -40
    height: 60
    radius: 30
    color: "#1c1c1ccc" // dark translucent background
    anchors.horizontalCenter: parent.horizontalCenter

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10




        TextField {
            id: inputField
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            placeholderText: "Type here..."
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 16
            color: "white"

            padding: 30

            background: Rectangle {
                radius: 20
                color: "#2c2c2c"
            }

        }



        // // Mic button
        // RoundButton {
        //     iconChar: "\uD83C\uDFA4" // 🎤
        //     onClicked: console.log("Mic")
        // }

        // Music note button
        RoundButton {
           // iconChar: "\u266B" // ♫
            onClicked: console.log("Music")
        }

        // Translate button
        RoundButton {
           // iconChar: "\uD83C\uDF0D" // 🌍
            onClicked: console.log("Translate")
        }
    }
}
