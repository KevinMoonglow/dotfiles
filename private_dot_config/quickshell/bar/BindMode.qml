import Quickshell
import QtQuick
import QtQuick.Layouts

ModuleTab {
	visible: DesktopManager.bindMode !== "default"
	border.color: "#80ff96"

	SText {
		text: DesktopManager.bindMode
		color: "#80ff96"
	}
}
