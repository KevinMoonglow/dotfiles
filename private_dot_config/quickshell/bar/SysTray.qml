import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: sysTray
	property PanelWindow panel
	property bool hideMode: true

	height: 32
	implicitWidth: trayRow.width + 10
	color: "#ee000000"
	//bottomLeftRadius: 16
	topLeftRadius: 10
	border.color: "#2980B9"
	border.width: 2
	Layout.alignment: Qt.AlignBottom
	Layout.preferredHeight: parent.height
	TrayMenu {
		id: menu
		anchor.gravity: Edges.Top
		visible: false
	}
	Behavior on implicitWidth {
		NumberAnimation {
			duration: 200
		}
	}
	
	Row {
		id: trayRow
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.leftMargin: 4
		anchors.rightMargin: 4
		spacing: 0

		WrapperMouseArea {
			Rectangle {
				color: "transparent"
				border.width: 0
				border.color: "#FFC5FC"
				implicitWidth: 24
				implicitHeight: 24
				SText {
					anchors.centerIn: parent
					text: sysTray.hideMode ? "↤" : "⇥"
					font.pointSize: 18
					color: "#2980B9"
				}
			}
			onClicked: {
				sysTray.hideMode = !sysTray.hideMode
			}
		}


		Repeater {
			model: SystemTray.items

			TrayButton {
				trayMenu: menu
				visible: {
					if(!sysTray.hideMode) true
					else if(modelData.status === Status.NeedsAttention) true
					else if(modelData.id === "nm-applet") false
					else if(modelData.id === "polychromatic-tray-applet") false
					else if(modelData.id === "blueman") false
					else if(modelData.status === Status.Passive) false
					else true
				}
			}

		}
	}
}
