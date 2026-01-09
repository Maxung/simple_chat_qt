import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import simple_chat_qt

Pane {
    id: promptField
    property ListModel model

    padding: 8
    Layout.fillWidth: true

    background: Rectangle {
        color: Theme.base
        border.color: Qt.alpha(Theme.border, 0.05)
        border.width: 1
        radius: 16
    }

    RowLayout {
        anchors.fill: parent
        spacing: 8

        ScrollView {
            Layout.fillWidth: true
            Layout.maximumHeight: 256
            clip: true

            TextArea {
                id: promptInput
                placeholderText: "Ask anything..."
                placeholderTextColor: Theme.placeholderText
                color: Theme.text
                selectionColor: Theme.selectionColor

                wrapMode: TextArea.Wrap
                selectByMouse: true

                background: Item {}
            }
        }

        Button {
            id: submitButton
            Layout.preferredWidth: 32
            Layout.preferredHeight: 32
            Layout.alignment: Qt.AlignBottom

            icon.source: "qrc:/qt/qml/simple_chat_qt/icons/arrow-up.svg"
            background: Rectangle {
                radius: height / 2
                color: submitButton.pressed ? Qt.darker(Theme.primaryButton, 1.2) : Theme.primaryButton
            }
            onClicked: {
                promptField.model.append({
                    "role": "sender",
                    "content": promptInput.text
                });

                promptField.model.append({
                    "role": "receiver",
                    "content": ""
                });
                OpenAIClient.sendPrompt(promptInput.text);
                promptInput.clear();
            }
        }
        Shortcut {
            sequences: ["Ctrl+Return", "Ctrl+Enter"]
            onActivated: submitButton.clicked()
        }
    }

    Connections {
        target: OpenAIClient

        function onPartialResponse(text) {
            if (promptField.model.count === 0)
                return;
            const lastIndex = promptField.model.count - 1;
            const currentText = promptField.model.get(lastIndex).content;

            promptField.model.set(lastIndex, {
                role: promptField.model.get(lastIndex).role,
                content: currentText + text
            });
        }

        function onFinished() {
            console.log("Done");
        }

        function onError(message) {
            console.error(message);
        }
    }
}
