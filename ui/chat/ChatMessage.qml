import QtQuick

Rectangle {
    id: bubble

    property string content: "Hallo"
    property bool isSender: false
    readonly property real maxTextWidth: (parent.width) - 24

    width: textDisplay.width + 24
    height: textDisplay.height + 16
    radius: 20
    anchors.margins: 10

    Text {
        id: textDisplay
        text: bubble.content
        wrapMode: Text.WordWrap
        width: Math.min(implicitWidth, bubble.maxTextWidth)
        anchors.centerIn: parent
        color: Theme.text
    }

    states: [
        State {
            name: "sender"
            when: bubble.isSender
            PropertyChanges {
                target: bubble
                color: Theme.bubbleBackground
                anchors.right: bubble.parent.right
                anchors.left: undefined
            }
        },
        State {
            name: "receiver"
            when: !bubble.isSender
            PropertyChanges {
                target: bubble
                color: Theme.background
                border.color: Theme.background
                anchors.left: bubble.parent.left
                anchors.right: undefined
            }
        }
    ]
}
