import Quickshell
import QtQuick

Item {
	MouseArea {
		anchors.fill: parent
		onWheel: (wheel) => {
			if (wheel.angleDelta.y > 0) {
				DesktopManager.focusLeft()
			}
			else if(wheel.angleDelta.y < 0) {
				DesktopManager.focusRight()
			}
		}
		onClicked: (mouse) => {
			if(mouse.button === 1) {
				DesktopManager.toggleOverview()
			}
			else if(mouse.button === 2) {
				DesktopManager.windowList()
			}
		}
		HoverHandler {
			cursorShape: Qt.SizeHorCursor
		}
	}
}
