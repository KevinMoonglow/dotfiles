import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

ModuleTab {
	id: root
	visible: UPower.displayDevice.isLaptopBattery
	property int charge: Math.floor(UPower.displayDevice.percentage * 100)
	border.color: "#80FF96"

	RowLayout {
		spacing: 8
		SText {
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
			color: {
				if(root.charge >= 50) "#80FF96"
				else if(root.charge >= 25) "#FFF3B3"
				else "#FF1244"
			}
			text: `${root.charge}%`
		}
	}
}
