import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    width: 800
    height: 600
    visible: true
    title: "Layout Animation Example"
    color: "#f0f0f0"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        Prompt {}
    }
}
