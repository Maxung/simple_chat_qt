import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    padding: 8
    Layout.fillWidth: true

    background: Rectangle {
        color: "#ffffff"
        border.color: "#e5e7eb"
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

            icon.source: "qrc:/simple_chat_qt/icons/arrow-up.svg"
            background: Rectangle {
                radius: height / 2
                color: submitButton.pressed ? "#2563eb" : "#3b82f6"
            }
            onClicked: console.log("submit")
        }
    }
}
