import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PopupWindow {
	id: root
	property list<var> menuItems
	property Item hoveredItem

	Behavior on visible {
		id: visBehavior
		SequentialAnimation {
			ScriptAction { script: {
				if(visBehavior.targetValue === true)
					updateItems(visBehavior.targetValue)
			}}
			PauseAnimation { duration: 50 }
			ScriptAction { script: {
				if(visBehavior.targetValue === false) {
					expand.stop()
					retract.restart()
				}
			}}
			PauseAnimation { duration: !visBehavior.targetValue ? 200 : 50 }
			PropertyAction { }
			ScriptAction { script: {
				if(visBehavior.targetValue === true) {
					retract.stop()
					expand.restart()
				}
			}}
		}
	}

	function updateItems(newValue) {
	}
	Loader {
		id: subMenuLoader
	}

	implicitHeight: Math.max(wrap.height, 16)
	implicitWidth: Math.max(wrap.width, 16)


	SequentialAnimation {
		id: expand
		ParallelAnimation {
			NumberAnimation {
				target: rect
				property: "implicitHeight"
				duration: 200
				easing.type: Easing.OutCubic
				from: 16
				to: Math.max(wrap.height, 16)
			}
			NumberAnimation {
				target: rect
				property: "y"
				duration: 200
				easing.type: Easing.OutCubic
				from: { wrap.height }
				to: 0
			}
		}
		PauseAnimation { duration: 200 }
	}
	SequentialAnimation {
		id: retract
		ParallelAnimation {
			NumberAnimation {
				target: rect
				property: "implicitHeight"
				duration: 200
				easing.type: Easing.InCubic
				from: Math.max(wrap.height, 16)
				to: 16
			}
			NumberAnimation {
				target: rect
				property: "y"
				duration: 200
				easing.type: Easing.InCubic
				from: 0
				to: { wrap.height }
			}
		}
		PauseAnimation { duration: 200 }
		onRunningChanged: {
			if(!running) {
				root.done()
			}
		}
	}
	signal done
	color: "transparent"
	ClippingRectangle {
		id: rect
		color: "#cc000000"
		border.color: "#ffc5fc"
		border.width: 1
		radius: 8
		implicitHeight: wrap.height
		implicitWidth: wrap.width


		Timer {
			id: hoverTimer
			interval: 100
		}
		Timer {
			id: hoverOffTimer
			interval: 1000
			onTriggered: () => {
				if(!subMenuLoader.item) {
					root.visible = false
				}
			}
		}
		HoverHandler {
			id: menuHover
			onHoveredChanged: () => {
				if(hovered) {
					hoverTimer.start()
					hoverOffTimer.stop()
				}
				else if(!hovered) {
					if(!hoverTimer.running) {
						hoverOffTimer.start()
					}
				}
			}
		}



		WrapperItem {
			id: wrap
			leftMargin: 0
			rightMargin: 1
			topMargin: 4
			bottomMargin: 8

			ColumnLayout {
				id: columnThing
				spacing: 0
				Layout.fillWidth: true
				Layout.fillHeight: true
				Repeater {
					model: root.menuItems

					Layout.fillWidth: true
					
					Rectangle {
						id: innerWrap


						Layout.minimumHeight: 16
						Layout.minimumWidth: 16
						Layout.preferredWidth: row.width
						Layout.preferredHeight: row.height
						Layout.fillWidth: true
						Component.onCompleted: {
						}

						color: {
							(hover.hovered && modelData.itemText !== "---")
						|| (subMenuLoader.item
						&& subMenuLoader.item.anchor.item == innerWrap
						&& subMenuLoader.source !== "")
							? "#88ffaafc"
							: "transparent"
						}
						HoverHandler {
							id: hover
							onHoveredChanged: () => {
								if(hovered && modelData?.hasChildren) {
									subMenuHoverTimer.start()
								}
								else if(!hovered && menuHover.hovered) {
									subMenuOffTimer.start()
								}
							}
						}
						Timer {
							id: subMenuOffTimer
							interval: 100
							onTriggered: {
								if(!hover.hovered && menuHover.hovered) {
									subMenuLoader.source = ""
								}
							}
						}
						Timer {
							id: subMenuHoverTimer
							interval: 200
							onTriggered: {
								if(hasChildren && hover.hovered) {
									if(subMenuLoader.item) {
										subMenuLoader.item.visible = false
										subMenuLoader.source = ""
									}
									subMenuLoader.source = "ListMenu.qml"
									subMenuLoader.item.baseMenu = modelData
									subMenuLoader.item.anchor.item = innerWrap
									subMenuLoader.item.anchor.gravity = Edges.Left
									subMenuLoader.item.anchor.edges = Edges.Left
									subMenuLoader.item.updateItems()
									subMenuLoader.item.visible = true
								}
							}
						}
						MouseArea {
							id: mouse
							anchors.fill: parent
							onClicked: (mouse) => {
								if(!modelData.disabled && !modelData.itemText !== "---") {
									if(modelData.action) modelData.action()
									root.visible = false
								}
							}
						}

						RowLayout {
							id: row
							implicitWidth: parent.width
							implicitHeight: parent.height
							IconImage {
								source: modelData.itemIcon ?? ""
								Layout.leftMargin: 6
								Layout.minimumWidth: 16

								Layout.preferredWidth: 24
								Layout.preferredHeight: 24
								Layout.topMargin: 2
								visible: modelData.itemText !== "---" && modelData.itemIcon
							}
							SText {
								text: modelData.itemText
								Layout.minimumWidth: 75
								Layout.fillWidth: true
								Layout.rightMargin: 16
								Layout.leftMargin: modelData.itemIcon ? 0: 8
								font.pointSize: 14
								color: {
									if(modelData.color) modelData.color
									else if(modelData.disabled) "gray"
									else if(modelData.active) "#FFC5FC"
									else "white"
								}
								visible: modelData.itemText !== "---"

							}
							SText {
								text: ""
								Layout.rightMargin: 4
								font.pointSize: 14
								color: "white"
								visible: modelData?.hasChildren ?? false
							}
							Rectangle {
								color: "#ffc5fc"
								Layout.fillWidth: true
								Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
								Layout.preferredHeight: 2
								Layout.rightMargin: 0
								Layout.minimumHeight: 2
								Layout.minimumWidth: 16
								visible: modelData.itemText === "---"
							}
						}
					}
				}
			}
		}
	}
}
