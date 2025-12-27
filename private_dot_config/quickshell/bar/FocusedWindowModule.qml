import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
	Layout.maximumWidth: modelData.width * 0.4
	Layout.preferredWidth: 100
	Layout.preferredHeight: parent.height

	HoverText {
		hovered: hover.hovered && title.truncated
		message: DesktopManager.focusedWindowTitle
		item: title
		gravity: Edges.Top
		edges: Edges.Top
	}



	FocusedWindowTitle {
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.top: parent.top
		size: modelData.width * 0.25
		id: title
	}
	WorkspaceNav {
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.top: parent.top
		implicitWidth: modelData.width * 0.4
		HoverHandler {
			id: hover
		}
	}
}
