import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: sysTray
	property PanelWindow panel

	height: 32
	implicitWidth: trayRow.width + 10
	color: "#cc000000"
	//bottomLeftRadius: 16
	topLeftRadius: 10
	border.color: "#2980B9"
	border.width: 2
	Layout.alignment: Qt.AlignBottom
	Layout.preferredHeight: parent.height
	ListMenu {
		id: menu
		anchor.gravity: Edges.Top
		visible: false
	}
	
	Row {
		id: trayRow
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		anchors.leftMargin: 4
		anchors.rightMargin: 4
		spacing: 0
		Repeater {
			model: SystemTray.items

			TrayButton {
				trayMenu: menu
			}

		}
	}
}
