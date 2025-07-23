import Quickshell
import QtQuick
import QtQuick.Layouts

ModuleTab {
	border.color: "#80FF96"
	SText {
		color: "#80FF96"
		text: ""
		font.pointSize: 14
		Layout.rightMargin: 6
	}

	SText {
		color: "#80FF96"
		text: ProcManager.ramPercent
	}
}
