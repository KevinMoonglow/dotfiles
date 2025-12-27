import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: workspaces
	color: "#cc000000"
	implicitWidth: wsRow.width + 12
	//implicitHeight: 30
	topRightRadius: 10
	border.width: 2
	border.color: "#FFC5FC"

	Layout.preferredHeight: parent.height

	//property list<var> ws_data
	required property ShellScreen screen
	property var lookups: {
		"home": "",
		"dev": "",
		"browser": "",
		"gaming": "󰯉",
		"art": "󰏘",
		"scratch": "",
		"chat": "󰭹",
		"_default": "",
	}
	property var icon_lookups: {
		"home": "root:assets/fenn-home-ws.png",
		"dev": "root:assets/mew-dev-magic-ws.png",
		"browser": "root:assets/mew-browser-ws.png",
	}
	property var icon_off_lookups: {
		"home": "root:assets/fenn-home-ws-off.png",
		"dev": "root:assets/mew-dev-magic-ws-off.png",
		"browser": "root:assets/mew-browser-ws-off.png",
	}

	RowLayout {
		id: wsRow
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.verticalCenter: parent.verticalCenter
		spacing: 0
		Repeater {
			model: ScriptModel {
				values: {
					console.log("=======", DesktopManager.ws_data.length)
					//return DesktopManager.ws_data?.filter(x => x && x.output == screen.name) ?? []
					return DesktopManager.workspacesFor(screen.name)
				}
			}
			WorkspaceButton {
			}
		}


		Rectangle {
			color: "transparent"
			implicitWidth: 4
		}
	}

}
