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
        implicitHeight: contentColumn.implicitHeight + 48
        modal: true
        focus: true
        padding: 0
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            radius: 16
            color: Theme.background
            border.color: Qt.alpha(Theme.border, 0.2)
            border.width: 1
        }

        ColumnLayout {
            id: contentColumn
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            Label {
                text: "Set OpenRouter model"
                color: Theme.text
                font.bold: true
                font.pixelSize: 16
            }

            TextField {
                id: modelEditor
                Layout.fillWidth: true
                placeholderText: "e.g. openai/gpt-5.2"
                text: OpenAIClient.currentModel()
                color: Theme.text
                placeholderTextColor: Theme.placeholderText
                selectionColor: Theme.selectionColor
                focus: true

                padding: 12

                background: Rectangle {
                    color: Theme.base
                    border.color: Qt.alpha(Theme.border, 0.05)
                    border.width: 1
                    radius: 12
                }

                onAccepted: confirmModel()

                Keys.onReturnPressed: confirmModel()
                Keys.onEnterPressed: confirmModel()

                function confirmModel() {
                    const trimmed = modelEditor.text.trim();
                    if (!trimmed)
                        return;
                    OpenAIClient.setModel(trimmed);
                    inputPopup.close();
                }
            }
        }

        onOpened: {
            modelEditor.text = OpenAIClient.currentModel();
            modelEditor.selectAll();
            modelEditor.forceActiveFocus();
        }
    }

    Shortcut {
        sequences: [StandardKey.Open]
        context: Qt.ApplicationShortcut
        onActivated: {
            if (!inputPopup.visible) {
                inputPopup.open();
            }
        }
    }

    Shortcut {
        sequences: [StandardKey.Close]
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }

    Shortcut {
        sequences: [StandardKey.New]
        context: Qt.ApplicationShortcut
        onActivated: ChatModel.clear()
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

            Layout.preferredHeight: expandRatio * (mainLayout.height - prompt.implicitHeight - mainLayout.spacing)

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
