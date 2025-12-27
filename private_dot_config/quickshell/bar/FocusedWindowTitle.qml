import Quickshell
import QtQuick
import QtQuick.Layouts

ModuleTab {
	id: root
	property real size: 1000
	border.color: "#ee76d1ff"
	color: "#dd000000"
	property alias truncated: winText.truncated

	property var filters: {
	}


	SText {
		id: winText
		text: DesktopManager.focusedWindowTitle
		color: "white"
		elide: Text.ElideRight
		wrapMode: Text.WrapAnywhere
		maximumLineCount: 1
		Layout.maximumWidth: root.size
	}
}
