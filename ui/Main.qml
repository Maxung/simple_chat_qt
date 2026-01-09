import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import simple_chat_qt

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "SimpleChatQt"

    color: Theme.background

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        Item {
            id: chatContainer
            Layout.fillWidth: true

            property real expandRatio: ChatModel.count > 0 ? 1.0 : 0.0
            property bool isAnimating: expandAnimation.running

            Behavior on expandRatio {
                NumberAnimation {
                    id: expandAnimation
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            Layout.preferredHeight: expandRatio * (mainLayout.height - prompt.implicitHeight
                                                   - mainLayout.spacing)

            clip: true

            ChatView {
                anchors.fill: parent
                model: ChatModel
                containerAnimating: chatContainer.isAnimating // Pass this down
            }
        }

        Prompt {
            id: prompt
        }
    }
}
