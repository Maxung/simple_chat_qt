import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ListView {
    id: chatView
    Layout.fillWidth: true
    Layout.fillHeight: true

    ScrollBar.vertical: ScrollBar {
        id: vBar
        active: true
        policy: ScrollBar.AsNeeded
    }

    model: ListModel {
        id: chatModel
        ListElement {
            role: "sender"
            content: "Hello! How are you?"
        }
        ListElement {
            role: "receiver"
            content: "I'm doing great, thanks for asking!"
        }
        ListElement {
            role: "sender"
            content: "Glad to hear that. Did you finish the QML project?"
        }
        ListElement {
            role: "sender"
            content: "Hello! How are you?"
        }
        ListElement {
            role: "receiver"
            content: "I'm doing great, thanks for asking!"
        }
        ListElement {
            role: "sender"
            content: "Glad to hear that. Did you finish the QML project?"
        }
        ListElement {
            role: "sender"
            content: "Hello! How are you?"
        }
        ListElement {
            role: "receiver"
            content: "I'm doing great, thanks for asking!"
        }
        ListElement {
            role: "sender"
            content: "Glad to hear that. Did you finish the QML project?"
        }
        ListElement {
            role: "sender"
            content: "Hello! How are you?"
        }
        ListElement {
            role: "receiver"
            content: "I'm doing great, thanks for asking!"
        }
        ListElement {
            role: "sender"
            content: "Glad to hear that. Did you finish the QML project?"
        }
        ListElement {
            role: "sender"
            content: "Hello! How are you?"
        }
        ListElement {
            role: "receiver"
            content: "I'm doing great, thanks for asking!"
        }
        ListElement {
            role: "sender"
            content: "Glad to hear that. Did you finish the QML project?"
        }
    }

    clip: true
    spacing: 8

    onCountChanged: chatView.positionViewAtEnd()

    delegate: Item {
        width: ListView.view.width
        height: messageBubble.height + 10

        required property string role
        required property string content

        readonly property bool isSender: role === "sender"

        ChatMessage {
            id: messageBubble
            isSender: parent.isSender
            content: parent.content
        }
    }
}
