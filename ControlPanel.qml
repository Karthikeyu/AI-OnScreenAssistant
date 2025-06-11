import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: controlPanel
    width: parent.width -40
    height: 60
    radius: 20
    //color: "#212121"
    color: "black"
    anchors.horizontalCenter: parent.horizontalCenter

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10




        TextField {
            id: inputField
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            placeholderText: "Type here..."
            placeholderTextColor: "#AAAAAA"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 16
            color: "white"
            focus:true
            padding: 30

            background: Rectangle {
                radius: 20
                color: "#303030"
               // border.color: "#888"       // ✅ border color
                    //    border.width: 1            // ✅ border thickness
            }

            Keys.onPressed: {
                    if (event.key === Qt.Key_Escape) {
                        Qt.quit(); // or root.close() if using window id
                    }
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
