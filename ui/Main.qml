import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "SimpleChatQt"

    color: Theme.background

    ListModel {
        id: chatModel
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        ChatView {
            model: chatModel
        }

        Prompt {
            model: chatModel
        }
    }
}
