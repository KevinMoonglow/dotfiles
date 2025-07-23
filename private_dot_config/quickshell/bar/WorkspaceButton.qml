import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Io
import Quickshell.Widgets

Rectangle {
	id: root
	required property var modelData

	Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
	Layout.preferredHeight: 30
	Layout.preferredWidth: wsName.width + 16
	color: {
		hover.hovered ? "#540086" : (modelData.is_urgent ? "#990055" : "transparent")
	}
	border.width: 0
	border.color: "white"

	readonly property string iconSuffix: {
		let m = modelData.name?.match(/:(.*?)$/)
		m?.[1] ?? ""
	}
	readonly property string iconOff: {
		icon_off_lookups[modelData.name] ?? icon_off_lookups[iconSuffix] ?? ""
	}
	readonly property string iconOn: {
		icon_lookups[modelData.name] ?? icon_lookups[iconSuffix] ?? ""
	}

	visible: {
		(modelData.is_active || modelData.is_focused || modelData.is_urgent) ||
			!modelData.name?.startsWith("special:")
	}
			

	HoverHandler {
		id: hover
	}


	Behavior on color {
		ColorAnimation { duration: 150; }
	}

	HoverText {
		message: modelData.name || modelData.idx
		item: root
		gravity: Edges.Top
		edges: Edges.Top
		hovered: hover.hovered
	}
	




	Rectangle {
		color: "#ffc5fc"
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		implicitHeight: 3
		visible: modelData.is_focused
	}
	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onPressed: mouse => {
			//NiruiManager.toWorkspace.target = modelData.idx
			if(mouse.button == 1) {
				NiriManager.setWorkspace(modelData.idx)
			}
			else if(mouse.button == 2) {
				renameDialog.active = true
			}
		}
	}
	TextInputDialog {
		id: renameDialog
		item: root
		edges: Edges.Top
		gravity: Edges.Top
		anchorLeft: true
		anchorBottom: true
		prompt: " Rename"
		value: modelData.name
	}
	RowLayout {
		anchors.fill: parent

		spacing: 0
		Text {
			id: wsName
			Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
			text: {
				if(!lookups[modelData.name]) {
					if(root.iconSuffix) {
						return lookups[root.iconSuffix] ?? root.iconSuffix
					}
					else
						return lookups["_default"]
				}
				lookups[modelData.name]
			}
			font.family: "Terminus"
			font.pointSize: 16
			color: modelData.is_active?"#ffc5fc":"white"
			visible: !icon_lookups[modelData.name] && !icon_lookups[root.iconSuffix]
			layer.enabled: true
			layer.effect: MultiEffect {
				saturation: modelData.is_active||modelData.is_urgent||hover.hovered?0.0:-1.0
				Behavior on saturation {
					NumberAnimation {
						duration: 200
					}
				}
			}
		}
		Loader {
			Layout.alignment: Qt.AlignHCenter | Qt.AlignCenter
			Layout.preferredWidth: 24
			Layout.preferredHeight: 24
			Layout.bottomMargin: 2
			sourceComponent: Component {
				IconImage {
					id: wsIcon
					Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
					source: (!modelData.is_active && iconOff)
					  ? iconOff
					  : iconOn
					Layout.preferredWidth: 24
					Layout.preferredHeight: 24
					layer.enabled: true
					layer.effect: MultiEffect {
						saturation: modelData.is_active||modelData.is_urgent||hover.hovered?0.0:-1.0
						Behavior on saturation {
							NumberAnimation {
								duration: 200
							}
						}
					}
				}
			}
			active: Boolean(root.iconOn)
			visible: Boolean(root.iconOn)
		}
		Text {
			Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
			Layout.bottomMargin: 2
			Layout.leftMargin: -2
			text: `${modelData.idx}`
			font.family: "Terminus"
			font.pixelSize: 8
			color: modelData.is_active?"#ffc5fc":"white"
		}
	}
}
