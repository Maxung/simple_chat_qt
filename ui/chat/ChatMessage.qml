import QtQuick

Rectangle {
    property string content: "Hallo"
    property bool isSender: false

    id: message_bubble
    width: Math.min(textDisplay.implicitWidth + 24, parent.width * 0.7)
    height: textDisplay.implicitHeight + 16
    radius: 12

    color: isSender ? "#DCF8C6" : "#FFFFFF"
    border.color: "#E0E0E0"

    anchors.right: isSender ? parent.right : undefined
    anchors.left: isSender ? undefined : parent.left
    anchors.margins: 10
    Text {
        id: textDisplay
        text: parent.content
        wrapMode: Text.WordWrap
        anchors.centerIn: parent
        color: "black"
    }
}
