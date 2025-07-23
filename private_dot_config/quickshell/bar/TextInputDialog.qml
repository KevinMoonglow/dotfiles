import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts

ControlDialog {
	id: root

	property string prompt: ""
	property string value: ""

	radius: 10
	topLeftRadius: 0
	bottomLeftRadius: 0

	Loader {
		id: loader
		Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
		active: root.active
		sourceComponent: Component {
			RowLayout {
				id: rowl
				Layout.preferredWidth: 250
				WrapperRectangle {
					color: "#29315A"
					margin: 2
					rightMargin: 5
					SText {
						color: "white"
						text: root.prompt
					}
				}

				ClippingRectangle {
					Layout.preferredWidth: 250
					Layout.fillHeight: true
					color: "transparent"
					TextInput {
						id: textInput
						font.family: "Terminus"
						font.pointSize: 18
						font.bold: true
						//Layout.preferredHeight: 1
						color: "white"
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						text: modelData.name
						focus: true
						Timer {
							interval: 10
							running: true
							repeat: false
							onTriggered: {
								// Incredibly scuffed but after hours of
								// fighting with it it's the only way I'm able
								// to get this blasted thing to get focus by
								// default when the dialog appears.
								textInput.selectAll()
								textInput.forceActiveFocus()
							}
						}
						onAccepted: {
							NiriManager.nameWorkspace(textInput.text, modelData.idx)
							root.active = false
						}
					}
				}
			}
		}
	}
}
