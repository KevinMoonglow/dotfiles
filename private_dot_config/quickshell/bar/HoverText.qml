import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

HoverDialog {
	id: root
	required property string message
	property string textColor: "white"
	property int format: Text.AutoText

	Text {
		text: root.message
		font.family: "Terminus"
		font.pointSize: 15
		font.bold: true
		textFormat: root.format
		color: root.textColor
	}
}
