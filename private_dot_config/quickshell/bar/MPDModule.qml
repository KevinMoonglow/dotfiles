import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ModuleTab {
	border.color: "#76D1FF"
	implicitWidth: wrapper.width
	property int maxLength: 99
	property int textScroll: 0
	property bool ticker: false
	Component.onCompleted: {
		print("!!", modelData.width)
		MPDManager.onTitleChanged.connect(() => {updateTimer.restart() })
		MPDManager.onFileChanged.connect(() => {updateTimer.restart() })
		MPDManager.onStateChanged.connect(() => {updateTimer.restart() })
	}
	function nextChar(text, cursor, wrapped=false) {
		let c = cursor
		if(wrapped && cursor >= text.length - 1) c = 0
		else c = cursor + 1

		if(text[c] == "<") {
			let locate = text.slice(c).search(">")
			if(locate != -1) {
				c += locate + 1
			}
		}
		return c
	}
	function visualForward(str, start, length, wrapped=false) {
		let n = start-1
		for(let i=0;i<length+1;i++) {
			n = nextChar(str, n, wrapped)
		}
		return n;
	}
	function visualTrim(str, start, length, wrapped=false) {
		let end = visualForward(str, start, length, wrapped)

		let newStr
		if(end < start)
			newStr = (str + str).slice(start, str.length + end)
		else
			newStr = str.slice(start, end)
		
		return newStr
	}
	function visualLength(str) {
		let n = 0
		for(let i=0;i<str.length;i=nextChar(str, i)) {
			n++;			
		}
		return n;
	}
	function updateDisplay() {
		let display = (
			(MPDManager.title ? `<font color='#ffaafc'>${MPDManager.title}</font>` :'') ||
			(MPDManager.file ? `<font color='#eeeeff'>${MPDManager.file}</font>` : '') || '') +
		((MPDManager.album ? ` — <font color='#ccd1f6'>${MPDManager.album}</font>` : '') ||
		 (MPDManager.artist ? ` — <font color='#9e72ff'>${MPDManager.artist}</font>` : ''))

		switch(MPDManager.state) {
			case "stop":
				display = "« Stopped »"
				iconText.text = ""
				break
			case "play":
				iconText.text = "󰝚"
				break
			case "pause":
				iconText.text = ""
				break
		}

		if(display) {
			if(visualLength(display) > maxLength) {
				ticker = true
				displayText.text = visualTrim(display, textScroll, maxLength, true)
			}
			else {
				ticker = false
				textScroll = 0
				displayText.text = display
			}
		}
	}
	Timer {
		id: updateTimer
		interval: 50
		onTriggered: updateDisplay()
	}
	Timer {
		id: scrollTimer
		interval: 1000
		running: false
		repeat: true
		onTriggered: {
			if(ticker) {
				updateDisplay()
			}
		}
	}

	Behavior on implicitWidth {
		NumberAnimation {
			duration: 200
			easing.type: Easing.InOutQuad
		}
	}
	HoverHandler {
		id: hover
	}
	HoverText {
		hovered: hover.hovered
		message: {
			(MPDManager.title || MPDManager.file) +
			(MPDManager.album ? ` — ${MPDManager.album}` : '') +
			(MPDManager.artist ? ` (${MPDManager.artist})`:'')
		}
		item: parent
		edges: Edges.Top
		gravity: Edges.Top
	}

	WrapperMouseArea {
		leftMargin: 10
		rightMargin: 10
		id: wrapper
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: mouse => {
			if(mouse.button === 1) {
				if (MPDManager.state === "stop")
					MPDManager.sendCommand("play")
				else
					MPDManager.sendCommand("pause")
			}
			else if(mouse.button === 2) {
				MPDManager.toggleFindSongDialog()
			}
		}
		onWheel: (wheel) => {
			print(wheel.angleDelta.y)
			if(wheel.angleDelta.y >= 120) {
				MPDManager.sendCommand("volume 5")
				MPDManager.sendCommand("getvol")
			}
			else if(wheel.angleDelta.y <= 120) {
				MPDManager.sendCommand("volume -5")
				MPDManager.sendCommand("getvol")
			}
		}
		RowLayout {
			id: row
			spacing: 10
			SText {
				id: iconText
				text: "󰝚"
				color: "#76D1FF"
				font.pointSize: 15
				Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
			}
			SText {
				id: displayText
				text: "??"
				color: "#76D1FF"
				wrapMode: Text.NoWrap
				elide: Text.ElideRight
				Layout.maximumWidth: 600
				Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
				Behavior on text {
					SequentialAnimation {
						NumberAnimation { target: displayText; property: "opacity"; to: 0.0; duration: 200 }
						PropertyAction { }
						NumberAnimation { target: displayText; property: "opacity"; to: 1.0; duration: 200 }
					}
				}
			}
			ClippingRectangle {
				color: "#000000"
				border.width: 1
				border.color: "#76D1FF"
				Layout.preferredWidth: 48
				Layout.preferredHeight: 8
				Layout.alignment: Qt.AlignVCenter
				radius: 4
				visible: MPDManager.state !== "stop" && MPDManager.state !== null

				Rectangle {
					color: "#76D1FF"
					radius: 0
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					implicitWidth: parent.width * MPDManager.elapsedPercent
				}
			}
		}
	}
		
}
