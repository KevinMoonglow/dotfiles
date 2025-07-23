import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

Rectangle {
	property SystemTrayItem item: modelData
	property ListMenu trayMenu
	id: root
	implicitWidth: icon.width + 8
	implicitHeight: icon.height
	color: "transparent"
	
	states: [
		State {
			name: "hovered"
			when: hover.hovered && !mouseArea.pressed
			PropertyChanges {
				root.color: "#540086"
			}
		},
		State {
			name: "pressed"
			when: mouseArea.pressed
			PropertyChanges {
				root.color: "#76D1FF"
				root.y: 2
			}
		},
		State {
			name: ""
			when: mouseArea.pressed
			PropertyChanges {
				root.color: "transparent"
			}
		}
	]


	IconImage {
		anchors.centerIn: parent
		id: icon
		source: item.icon
		width: 24
		height: 24
	}
	Behavior on color {
		ColorAnimation { duration: 150; }
	}
	HoverHandler {
		id: hover
	}
	HoverText {
		id: hoverText
		message: [ modelData.tooltipTitle, modelData.tooltipDescription ]
			.filter(x => x).join("\n") || modelData.title
		item: root
		gravity: Edges.Top
		edges: Edges.Top
		hovered: hover.hovered
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: mouse => {
			print(mouse.button, root.item.hasMenu, root.item.onlyMenu)
			if(mouse.button == 2 || (mouse.button == 1 && root.item.onlyMenu)) {
				if(root.trayMenu.visible) {
					root.trayMenu.visible = false
					root.trayMenu.baseMenu = null
				}
				else if(root.item.hasMenu) {
					root.trayMenu.anchor.item = root
					root.trayMenu.anchor.updateAnchor()
					root.trayMenu.baseMenu = Qt.binding(() => item.menu)
					root.trayMenu.visible = true
				}
			}
			else if(mouse.button == 1)
				root.item.activate()
		}
		onDoubleClicked: mouse => {
			if(mouse.button == 1)
				root.item.secondaryActivate()
		}
	}
}
