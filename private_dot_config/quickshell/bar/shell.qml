import Quickshell // for PanelWindow
import QtQuick // for Text
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io // for Process
import Quickshell.Wayland
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Scope {
	id: root

	enum WorkspacePos { Bottom, Left, Right }

	property bool visibleBars: true
	property int workspacePos: root.WorkspacePos.Bottom

	IpcHandler {
		target: "bars"
		function toggle() { root.visibleBars = !root.visibleBars; }
		function on() { root.visibleBars = true; }
		function off() { root.visibleBars = false; }
		function volDisplay(percent: int, mute: string) {
			let isMute = mute == "yes" || mute == "true"

			volOsdLoader.volume = percent
			volOsdLoader.mute = isMute
			volOsdLoader.loading = true
		}
	}
	LazyLoader {
		property int volume: 0
		property bool mute: false
		id: volOsdLoader
		loading: false
		active: false
		VolumeOSD {
			volume: volOsdLoader.volume
			muted: volOsdLoader.mute
			onDone: {
				volOsdLoader.active = false
			}
		}
	}
	Component.onCompleted: {
		MPDManager
	}


	PanelWindow {
		id: capture
		anchors {
			top: true
			bottom: true
			left: true
			right: true
		}
		color: "#88000000"
		exclusionMode: ExclusionMode.Ignore
		MouseArea {
			anchors.fill: parent
			onClicked: () => {
				capture.visible = false
			}
		}
		Rectangle {
			implicitWidth: rtext.width + 10
			implicitHeight: rtext.height + 4
			anchors.centerIn: parent
			color: "#aa000088"
			focus: true
			Keys.onPressed: (event) => {
				if (event.key == Qt.Key_Escape) {
					capture.visible = false
				}
			}
			Text {
				id: rtext
				anchors.centerIn: parent
				text: "hello, world"
				renderType: Text.NativeRendering
				antialiasing: false
				font.family: "Terminus (TTF)"
				font.bold: true
				font.pointSize: 24
				color: "white"
			}
			MouseArea {
				anchors.fill: parent
				onClicked: (mouse) => {
					rtext.text = "Ouch!"
				}
			}
		}
		visible: false
		//WlrLayershell.layer: WlrLayer.Bottom
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
		IpcHandler {
			target: "capture"
			function display(): void { capture.visible = true }
		}
	}

	Variants {
		model: Quickshell.screens



		PanelWindow {
			id: panel
			property var modelData
			screen: modelData
			color: "#00000000"
			implicitHeight: 32
			//visible: root.visibleBars

			anchors {
				//top: true
				left: true
				right: true
				bottom: true
			}
			WrapperRectangle {
				anchors.left: parent.left
				anchors.right: parent.right
				implicitHeight: parent.height




				color: "transparent"
				RowLayout {
					id: row
					anchors.fill: parent
					anchors.leftMargin: -2
					anchors.bottomMargin: -2
					anchors.rightMargin: -2

					spacing: 0

					state: root.visibleBars ? "" : "collapsed"

					states: [
						State {
							name: "collapsed"
							PropertyChanges {
								row.anchors.bottomMargin: -34
								row.anchors.topMargin: 32
							}
						}
					]
					transitions: [
						Transition {
							to: "collapsed"
							reversible: true
							SequentialAnimation {
								NumberAnimation {
									properties: "row.anchors.bottomMargin,row.anchors.topMargin"
									duration: 200
								}
								PropertyAction {
									target: panel
									property: "visible"
									value: row.state !== "collapsed"
								}
							}
						}
					]


					RowLayout {
						id: leftModules
						spacing: 8
						Layout.alignment: Qt.AlignBottom
						Layout.preferredHeight: parent.height
						Workspaces {
							Layout.preferredHeight: parent.height
							screen: modelData
						}
						BindMode {}
						FocusedWindowModule {}
					}
					RowLayout {
						id: centerModules
						Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
						Layout.preferredHeight: parent.height
						spacing: 8
					}
					RowLayout {
						id: rightModules
						Layout.alignment: Qt.AlignBottom | Qt.AlignRight
						Layout.preferredHeight: parent.height
						spacing: 8
						Loader {
							Layout.alignment: Qt.AlignTop

							active: modelData.width > modelData.height
							sourceComponent: MPDModule {
								id: mpd
								implicitHeight: rightModules.height
							}
						}
						Volume { }
						RamModule { }
						Clock { }
						SysTray {
							panel: panel
						}
					}
				}
			}
		}
	}
}
