import QtQuick
import QtQuick.Controls

Flickable {
    id: chatView

    property alias model: messageRepeater.model
    property bool autoScroll: true
    property bool containerAnimating: false

    contentHeight: messageColumn.height
    contentWidth: width
    clip: true

    ScrollBar.vertical: ScrollBar {
        policy: ScrollBar.AsNeeded
    }

    Column {
        id: messageColumn
        width: parent.width
        spacing: 8

        Repeater {
            id: messageRepeater

            delegate: Item {
                id: delegateRoot

                width: parent.width
                height: messageBubble.height + 10

                required property int index
                required property string role
                required property string content

                readonly property bool isSender: role === "sender"

                ChatMessage {
                    id: messageBubble

                    isSender: delegateRoot.isSender
                    content: delegateRoot.content
                    maxBubbleWidth: delegateRoot.width - 20

                    x: delegateRoot.isSender ? (delegateRoot.width - width - 10) : 10
                    y: 5
                }
            }

            onCountChanged: {
                if (chatView.autoScroll) {
                    scrollTimer.restart()
                }
            }
        }
    }

    Timer {
        id: scrollTimer
        interval: 10
        onTriggered: {
            if (chatView.containerAnimating) {
                waitForAnimation.restart()
            } else {
                chatView.scrollToEnd()
            }
        }
    }

    Timer {
        id: waitForAnimation
        interval: 350
        onTriggered: chatView.scrollToEnd()
    }

    function scrollToEnd() {
        var target = Math.max(0, contentHeight - height)

        if (messageRepeater.count === 1) {
            contentY = target
        } else {
            scrollAnimation.to = target
            scrollAnimation.start()
        }
    }

    NumberAnimation {
        id: scrollAnimation
        target: chatView
        property: "contentY"
        duration: 200
        easing.type: Easing.OutCubic
    }
}
