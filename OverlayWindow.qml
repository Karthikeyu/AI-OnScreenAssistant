import QtQuick 2.15
import QtQuick.Window 2.15

// Window {
//     id: overlay
//     visible: true
//     width: Screen.width
//     height: Screen.height - 200
//     flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint | Qt.Tool
//     color: "transparent" // translucent black

    Rectangle {
           id: overlayBackground
           radius: 20                    // Rounded corners
           color: "#222822AA"           // Translucent black
           border.color: "black"
           border.width: 2
           width: Screen.width
           height: Screen.height - 200
           //visible: false

           // Key catcher to handle Esc
           Keys.onEscapePressed: Qt.quit()
           focus: true

           Component.onCompleted: {
                  console.log("Overlay geometry:", overlayBackground.x, overlayBackground.y, overlayBackground.width, overlayBackground.height)
              }
       }
// }
