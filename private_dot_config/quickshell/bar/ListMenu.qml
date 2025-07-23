import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

PopupWindow {
	id: root
	property var baseMenu
	property ObjectModel menuItems
	property Item hoveredItem

	QsMenuOpener {
		id: menu
	}

	Behavior on visible {
		id: visBehavior
		SequentialAnimation {
			ScriptAction { script: updateItems(visBehavior.targetValue) }
			PauseAnimation { duration: 100 }
			PropertyAction { }
		}
	}

	function updateItems(newValue) {
		print(newValue)
		if(newValue) {
			menu.menu = Qt.binding(() => root.baseMenu)
			menuItems = Qt.binding(() => menu.children)
			print("show")
		}
		else {
			menu.menu = null
			menuItems = null
			print("empty")
		}
	}
	Loader {
		id: subMenuLoader
	}

	implicitHeight: Math.max(wrap.height, 16)
	implicitWidth: Math.max(wrap.width, 16)

	color: "transparent"
	ClippingRectangle {
		id: rect
		anchors.fill: parent
		color: "#cc000000"
		border.color: "#ffc5fc"
		border.width: 1
		radius: 8
	
///		Behavior on width {
///			NumberAnimation {
///				duration: 2000
///				easing.type: Easing.InOutQuad
///			}
///		}



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
							(hover.hovered && !modelData.isSeparator)
						|| (subMenuLoader.item
						&& subMenuLoader.item.anchor.item == innerWrap
						&& subMenuLoader.source !== "")
							? "#88ffaafc"
							: "transparent"
						}
						HoverHandler {
							id: hover
							onHoveredChanged: () => {
								if(hovered && modelData.hasChildren) {
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
								if(modelData.hasChildren && hover.hovered) {
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
								if(modelData.enabled && !modelData.isSeparator) {
									modelData.triggered()
									root.visible = false
								}
							}
						}

						RowLayout {
							id: row
							implicitWidth: parent.width
							implicitHeight: parent.height
							IconImage {
								source: modelData.icon
								Layout.leftMargin: 6
								Layout.minimumWidth: 16

								Layout.preferredWidth: 24
								Layout.preferredHeight: 24
								Layout.topMargin: 2
								visible: !modelData.isSeparator
							}
							SText {
								text: modelData.text
								Layout.minimumWidth: 75
								Layout.fillWidth: true
								Layout.rightMargin: 16
								font.pointSize: 14
								color: modelData.enabled ? "white" : "gray"
								visible: !modelData.isSeparator

							}
							SText {
								text: ""
								Layout.rightMargin: 4
								font.pointSize: 14
								color: "white"
								visible: modelData.hasChildren
							}
							Rectangle {
								color: "#ffc5fc"
								Layout.fillWidth: true
								Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
								Layout.preferredHeight: 2
								Layout.rightMargin: 0
								Layout.minimumHeight: 2
								Layout.minimumWidth: 16
								visible: modelData.isSeparator
							}
						}
					}
				}
			}
		}
	}
}
