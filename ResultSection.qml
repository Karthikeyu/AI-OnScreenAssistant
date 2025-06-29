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
        width: parent.width
        readOnly: true
        selectByMouse: true
        font.pixelSize: 16
        textFormat: TextEdit.RichText
        anchors.horizontalCenter: parent.horizontalCenter
        padding: 20

    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Escape) {
            Qt.quit();
        }
    }


    Connections {
           target: groq
           onResponseReceived: {

            resultTextItem.text = markdownToHtml(response)
            root.isLoading = false
       }
    }

    function markdownToHtml(text) {
        let lines = text.split("\n");
        let html = "";
        let inList = false;
        let inCode = false;

        for (let i = 0; i < lines.length; i++) {
            let line = lines[i];

            // Code block handling
            if (line.trim().startsWith("```")) {
                if (!inCode) {
                    html += "<pre style='background:#2a2a2a; color:#ccc; padding:10px; border-radius:6px; overflow-x:auto; font-family:monospace;'><code>";
                    inCode = true;
                } else {
                    html += "</code></pre>";
                    inCode = false;
                }
                continue;
            }

            if (inCode) {
                html += line.replace(/</g, "&lt;").replace(/>/g, "&gt;") + "\n";
                continue;
            }

            // Bullet lists
            if (line.match(/^\s*[\*\-]\s+/)) {
                if (!inList) {
                    html += "<ul style='margin-top: 0px; margin-bottom: 0px; padding-left: 16px;'>";
                    inList = true;
                }
                html += "<li style='margin-bottom: 4px;'>" + line.replace(/^\s*[\*\-]\s+/, "") + "</li>";
            } else {
                if (inList) {
                    html += "</ul>";
                    inList = false;
                }

                const nextLineIsList = (i + 1 < lines.length) && lines[i + 1].match(/^\s*[\*\-]\s+/);
                html += line
                    .replace(/\*\*(.+?)\*\*/g, "<b>$1</b>")
                    .replace(/(^|[^\*])\*(?!\*)(.+?)\*(?!\*)/g, "$1<i>$2</i>");

                if (!nextLineIsList) {
                    html += "<br/>";
                }
            }
        }

        if (inList) html += "</ul>";
        if (inCode) html += "</code></pre>"; // auto-close if unbalanced

        return html;
    }






}
