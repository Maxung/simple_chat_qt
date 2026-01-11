import QtQuick

Rectangle {
    id: bubble

    property string content: ""
    property bool isUser: false
    property real maxBubbleWidth: 300

    property real paddingLeft: 14
    property real paddingRight: 12
    property real paddingVertical: 8

    radius: 20
    color: isUser ? Theme.bubbleBackground : Theme.background
    border.color: isUser ? "transparent" : Theme.background

    width: Math.min(textDisplay.implicitWidth + paddingLeft + paddingRight, maxBubbleWidth)

    height: textDisplay.implicitHeight + paddingVertical * 2

    TextEdit {
        id: textDisplay

        text: bubble.content
        textFormat: Text.RichText
        wrapMode: Text.WordWrap
        readOnly: true

        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0

        width: bubble.maxBubbleWidth - parent.paddingLeft - parent.paddingRight

        anchors {
            left: parent.left
            leftMargin: parent.paddingLeft
            verticalCenter: parent.verticalCenter
        }

        color: Theme.text
        selectByMouse: true
    }
}
