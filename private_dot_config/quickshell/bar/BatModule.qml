import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

ModuleTab {
	id: root
	implicitWidth: icon.width + 24
	visible: UPower.displayDevice.isLaptopBattery
	property int charge: Math.floor(UPower.displayDevice.percentage * 100)
	border.color: "#80FF96"

	states: State {
		name: "long"
		PropertyChanges {
			batPercent.visible: true
			root.implicitWidth: batPercent.width + icon.width + 24
			batPercent.opacity: 1.0
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: (mouse) => {
			root.state = root.state?"":"long"
		}
	}

	transitions: [
		Transition {
			NumberAnimation {
				targets: [root]
				property: "implicitWidth"
				duration: 200
				easing.type: Easing.InOutQuad
			}
			PropertyAnimation {
				targets: [batPercent]
				property: "opacity"
				duration: 400
				easing.type: Easing.Linear
			}
		}
	]

	RowLayout {
		id: layout
		spacing: 8
		SText {
			id: icon
			color: {
				if(root.charge >= 50) "#80FF96"
				else if(root.charge >= 25) "#FFF3B3"
				else "#FF1244"
			}
			text: {
				if(UPower.displayDevice.state == UPowerDeviceState.Charging) {
					if(root.charge >= 100) "󰂅"
					else if(root.charge >= 90) "󰂋"
					else if(root.charge >= 80) "󰂊"
					else if(root.charge >= 70) "󰢞"
					else if(root.charge >= 60) "󰂉"
					else if(root.charge >= 50) "󰢝"
					else if(root.charge >= 40) "󰂈"
					else if(root.charge >= 30) "󰂇"
					else if(root.charge >= 20) "󰂆"
					else if(root.charge >= 10) "󰢜"
					else if(root.charge >= 0) "󰢟"
				}
				else {
					if(root.charge >= 100) "󰁹"
					else if(root.charge >= 90) "󰂂"
					else if(root.charge >= 80) "󰂁"
					else if(root.charge >= 70) "󰂀"
					else if(root.charge >= 60) "󰁿"
					else if(root.charge >= 50) "󰁾"
					else if(root.charge >= 40) "󰁽"
					else if(root.charge >= 30) "󰁼"
					else if(root.charge >= 20) "󰁻"
					else if(root.charge >= 10) "󰁺"
					else if(root.charge >= 0) "󰂎"
				}
			}	
		}
		SText {
			id: batPercent
			visible: false
			opacity: 0.0
			color: {
				if(root.charge >= 50) "#80FF96"
				else if(root.charge >= 25) "#FFF3B3"
				else "#FF1244"
			}
			text: `${root.charge}%`
		}
	}
}
