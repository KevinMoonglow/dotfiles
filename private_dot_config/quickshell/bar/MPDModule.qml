import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ModuleTab {
	border.color: "#76D1FF"
	Component.onCompleted: {
	}

	WrapperMouseArea {
		onClicked: {
			MPDManager.sendCommand("pause")
		}
		onWheel: (wheel) => {
			print(wheel.angleDelta.y)
			if(wheel.angleDelta.y >= 120) {
				MPDManager.sendCommand("volume 2")
				MPDManager.sendCommand("getvol")
			}
			else if(wheel.angleDelta.y <= 120) {
				MPDManager.sendCommand("volume -2")
				MPDManager.sendCommand("getvol")
			}
		}
		RowLayout {
			SText {
				text: "󰝚"
				color: "#76D1FF"
			}
			SText {
				text: "Song Title Goes Here"
				color: "#76D1FF"
			}
		}
	}
	
}
