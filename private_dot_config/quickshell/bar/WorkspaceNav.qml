import Quickshell
import QtQuick

Item {
	MouseArea {
		anchors.fill: parent
		onWheel: (wheel) => {
			if (wheel.angleDelta.y > 0) {
				NiriManager.focusLeft()
			}
			else if(wheel.angleDelta.y < 0) {
				NiriManager.focusRight()
			}
		}
		onClicked: (mouse) => {
			if(mouse.button === 1) {
				NiriManager.toggleOverview()
			}
			else if(mouse.button === 2) {
				NiriManager.windowList()
			}
		}
		HoverHandler {
			cursorShape: Qt.SizeHorCursor
		}
	}
}
