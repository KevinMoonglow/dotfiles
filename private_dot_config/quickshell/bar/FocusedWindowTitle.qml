import Quickshell
import QtQuick
import QtQuick.Layouts

ModuleTab {
	id: root
	property real size: 1000
	border.color: "#ee76d1ff"

	SText {
		text: NiriManager.focusedWindow?.title.trim() ?? ""
		color: "white"
		elide: Text.ElideRight
		wrapMode: Text.WrapAnywhere
		maximumLineCount: 1
		Layout.maximumWidth: root.size
	}
}
