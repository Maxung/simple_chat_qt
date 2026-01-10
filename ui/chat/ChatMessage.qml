import QtQuick

Rectangle {
    id: bubble

    property string content: ""
    property bool isUser: false
    property real maxBubbleWidth: 300

    width: textDisplay.width + 24
    height: textDisplay.height + 16
    radius: 20

    color: isUser ? Theme.bubbleBackground : Theme.background
    border.color: isUser ? "transparent" : Theme.background

    TextEdit {
        id: textDisplay

        text: bubble.content
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        width: Math.min(implicitWidth, bubble.maxBubbleWidth - 24)
        anchors.centerIn: parent
        color: Theme.text
        readOnly: true
    }
}
