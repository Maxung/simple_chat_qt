import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import QtQuick.Window
import simple_chat_qt

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: "SimpleChatQt"

    color: Theme.background

    Popup {
        id: inputPopup

        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.min(360, parent.width - 40)
        implicitHeight: modelEditor.implicitHeight + 40
        modal: true
        focus: true
        padding: 20
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 16
            color: Theme.base
            border.color: Qt.alpha(Theme.border, 0.2)
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            Label {
                text: "Set OpenRouter model"
                color: Theme.text
                font.bold: true
            }



            TextField {
                id: modelEditor
                Layout.fillWidth: true
                placeholderText: "e.g. openai/gpt-5.2"
                text: OpenAIClient.currentModel()
                color: Theme.text
                selectionColor: Theme.selectionColor
                focus: true

                onAccepted: confirmModel()

                Keys.onReturnPressed: confirmModel()
                Keys.onEnterPressed: confirmModel()

                function confirmModel() {
                    const trimmed = modelEditor.text.trim()
                    if (!trimmed)
                        return

                    OpenAIClient.setModel(trimmed)
                    inputPopup.close()
                }
            }
        }



        onOpened: {
            modelEditor.text = OpenAIClient.currentModel()
            modelEditor.selectAll()
            modelEditor.forceActiveFocus()
        }
    }

    Shortcut {
        sequence: StandardKey.Open
        context: Qt.ApplicationShortcut
        onActivated: {
            if (!inputPopup.visible) {
                inputPopup.open()
            }
        }
    }

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
