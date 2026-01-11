import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import simple_chat_qt

Pane {
    id: promptField

    padding: 8
    Layout.fillWidth: true

    background: Rectangle {
        color: Theme.base
        border.color: Qt.alpha(Theme.border, 0.05)
        border.width: 1
        radius: 16
    }

    Component.onCompleted: {
        promptInput.forceActiveFocus();
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
            enabled: !OpenAIClient.isLoading

            icon.source: OpenAIClient.isLoading ? "qrc:/qt/qml/simple_chat_qt/icons/loader-circle.svg" : "qrc:/qt/qml/simple_chat_qt/icons/arrow-up.svg"
            icon.color: "black"
            background: Rectangle {
                radius: height / 2
                color: submitButton.pressed ? Qt.darker(Theme.primaryButton, 1.2) : Theme.primaryButton
            }
            onClicked: {
                OpenAIClient.sendPrompt(promptInput.text);
                promptInput.clear();
            }

            RotationAnimator {
                target: submitButton
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
                running: OpenAIClient.isLoading
                onStopped: submitButton.rotation = 0
            }
        }
        Shortcut {
            sequences: ["Ctrl+Return", "Ctrl+Enter"]
            onActivated: submitButton.clicked()
        }
    }

    Connections {
        target: OpenAIClient

        function onFinished() {
            console.log("Done");
        }

        function onError(message) {
            console.error(message);
        }
    }
}
