import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
	id: root
	property int popupDelay: 1000
	property bool hovered: false
	property Item item
	property int edges
	property int gravity
	property Rectangle rect
	property QtObject window
	default property list<QtObject> data: []

	signal triggered

	onHoveredChanged: {
		if(hovered) timer.running = true
		else {
			timer.running = false
			loader.active = false
			if(root.rect) popupRoot.rect = root.rect
			if(root.window) popupRoot.window = root.window
		}
	}

	Timer {
		id: timer
		interval: root.popupDelay
		running: root.hovered
		onTriggered: {
			loader.active = true
			root.triggered()
		}
	}
	Loader {
		id: loader
		active: false
		sourceComponent: Component {
			PopupWindow {
				id: popupRoot
				visible: true
				anchor.item: root.item
				anchor.edges: root.edges
				anchor.gravity: root.gravity

				implicitWidth: rect.implicitWidth
				implicitHeight: rect.implicitHeight
				color: "transparent"

				WrapperRectangle {
					anchors.centerIn: parent
					id: rect
					border.width: 1
					border.color: "#FFC5FC"
					margin: 6
					radius: 4
					color: "#cc000000"
					RowLayout {
						data: root.data
					}
				}
			}
		}
	}
}
