import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
	id: root
	property Item item
	property int edges
	property int gravity
	property Rectangle rect
	property QtObject window
	default property list<QtObject> data: []
	property bool active: false
	property bool anchorLeft: false
	property bool anchorRight: false
	property bool anchorTop: false
	property bool anchorBottom: false
	property int radius: 0
	property var topLeftRadius 
	property var bottomLeftRadius 
	property var topRightRadius 
	property var bottomRightRadius 
	property real marginLeft: 8
	property real marginRight: 8
	property real marginTop: 8
	property real marginBottom: 8
	LazyLoader {
		id: loader
		active: root.active
		PanelWindow {
			id: panel
			anchors {
				left: root.anchorLeft
				right: root.anchorRight
				top: root.anchorTop
				bottom: root.anchorBottom
			}
			margins {
				left: root.marginLeft
				right: root.marginRight
				top: root.marginTop
				bottom: root.marginBottom
			}
			color: "#00000000"
			exclusionMode: ExclusionMode.Normal
			implicitWidth: wrect.implicitWidth
			implicitHeight: wrect.implicitHeight

			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
			WlrLayershell.focusable: true
			WrapperRectangle {
				anchors.fill: parent
				id: wrect
				border.width: 2
				border.color: "#FFC5FC"
				margin: 0
				radius: root.radius
				topLeftRadius: root.topLeftRadius
				topRightRadius: root.topRightRadius
				bottomLeftRadius: root.bottomLeftRadius
				bottomRightRadius: root.bottomRightRadius
				color: "#88000000"
				focus: true

				RowLayout {
					id: row
					data: root.data
				}

				Keys.onPressed: (event) => {
					if (event.key == Qt.Key_Escape) {
						root.active = false
					}
				}
			}
		}
	}
}
