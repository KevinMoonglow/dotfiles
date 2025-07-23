import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Wayland

PanelWindow {
	id: root
	property int volume: 0
	property int displayTime: 1500
	property bool muted: false

	property string muteIcon: ""
	property string silentIcon: ""
	property string quietIcon: ""
	property string loudIcon: ""

	property string baseColor: "#FFC5FC"

	property int loudLevel: 30



	visible: timer.running

	signal done

	exclusionMode: ExclusionMode.Normal
	WlrLayershell.layer: WlrLayer.Overlay

	anchors {
		bottom: true
		right: true
		//top: true
	}
	margins {
		right: 16
		bottom: 16
		top: 16
		left: 16
	}
	implicitWidth: 350
	implicitHeight: 32
	color: "transparent"

	onVolumeChanged: {
		visible = true
		timer.restart()
	}
	Timer {
		id: timer
		interval: root.displayTime
		running: true
		onTriggered: {
			root.done()
		}
	}
	WrapperRectangle {
		anchors.fill: parent
		border.width: 2
		border.color: root.baseColor
		radius: 16
		color: "#cc000000"
		leftMargin: 8
		rightMargin: 8
		RowLayout {
			SText {
				color: {
					if(root.muted) "#888888"
					else "white"
				}
				text: {
					if(root.muted) root.muteIcon
					else if(root.volume <= 0) root.silentIcon
					else if(root.volume < root.loudLevel) root.quietIcon
					else if(root.volume >= root.loudLevel) root.loudIcon
				}
				Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
			}
			SText {
				color: {
					if(root.muted) "#888888"
					else "white"
				}
				text: `${root.volume}%`.padStart(4)
				Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
			}
			Rectangle {
				Layout.preferredHeight: 16
				Layout.fillWidth: true
				color: "transparent"
				border.width: 1
				border.color: root.baseColor
				radius: 16
				Rectangle {
					color: {
						if(root.muted) "#888888"
						else root.baseColor
					}
					radius: 16
					anchors.top: parent.top
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					width: parent.width * root.volume/100
				}
			}
		}
	}
}
