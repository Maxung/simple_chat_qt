import QtQuick
import QtQuick.Controls

import simple_chat_qt

Flickable {
    id: chatView

    property alias model: messageRepeater.model
    property bool autoScroll: true
    property bool containerAnimating: false
    property bool forceImmediateScroll: false

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
                required property string htmlContent

                readonly property bool isUser: role === "user"

                ChatMessage {
                    id: messageBubble

                    isUser: delegateRoot.isUser
                    content: delegateRoot.htmlContent
                    maxBubbleWidth: delegateRoot.width - 20

                    x: delegateRoot.isUser ? (delegateRoot.width - width - 10) : 10
                    y: 5
                }
            }

            onCountChanged: {
                if (chatView.autoScroll) {
                    chatView.forceImmediateScroll = false
                    scrollTimer.restart()
                }
            }
        }
    }

    Connections {
        target: ChatModel
        function onMessageUpdated(index) {
            if (chatView.autoScroll && index === messageRepeater.count - 1) {
                chatView.forceImmediateScroll = true
                scrollTimer.restart()
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
                chatView.scrollToEnd(chatView.forceImmediateScroll)
                chatView.forceImmediateScroll = false
            }
        }
    }

    Timer {
        id: waitForAnimation
        interval: 350
        onTriggered: {
            chatView.scrollToEnd(chatView.forceImmediateScroll)
            chatView.forceImmediateScroll = false
        }
    }

    function scrollToEnd(immediate) {
        var target = Math.max(0, contentHeight - height)

        if (immediate || messageRepeater.count === 1) {
            scrollAnimation.stop()
            contentY = target
        } else {
            if (scrollAnimation.running) {
                scrollAnimation.stop()
            }
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
