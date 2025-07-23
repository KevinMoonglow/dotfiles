import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: clockRect
	color: "#cc000000"
	implicitWidth: clock.width + icon.width + 28
	Layout.preferredHeight: parent.height
	Layout.alignment: Qt.AlignBottom
	//anchors.topMargin: 0
	border.color: "#eeffaafc"
	border.width: 2
	border.pixelAligned: true
	//radius: 16
	topLeftRadius: 10
	topRightRadius: 10
	clip: true

	HoverHandler { id: hover }
	HoverText {
		message: {
			if(ProcManager.calData === undefined) return ""

			let t = ProcManager.calData.split("\n")
			let d = x => {
				let today = ProcManager.monthDay
				return x.trim() == today ? `<font color="yellow">${x}</font>` : x
			}
			t[0] = `<center><font color="white">${t[0].trim()}</font></center><table>`
			t[1] = `<tr>` + (t[1]).split(/(...)/).filter(x=>x).map(x => `<th><font color='#80FF96'>${x}</font></th>`).join('') + `</tr>`

			for(let i=2;i<t.length;i++) {

				let days = (t[i] + " ").split(/(...)/).filter(x=>x)
				for(let j=0;j<7;j++) {
					let o = days[j] ?? "   "
					if(j==6) o = o.trim()
					o = d(o)
					days[j] = `<td align='right'>${o}</td>`
				}
			
				t[i] = `<tr>` + days.join('') + `</tr>`
			}


			t.join("") + "</table>"
		}
		item: clockRect
		gravity: Edges.Top
		edges: Edges.Top
		hovered: hover.hovered
		onTriggered: {
			ProcManager.calendar.running = true
		}
		format: Text.RichText
		textColor: "#FFC5FC"
	}

	states: State {
		name: "long"
		PropertyChanges {
			clockRect.implicitWidth: clock_long.width + icon.width + 28
			clock.visible: false
			clock_long.visible: true
			clockRectBar.implicitWidth: clock_long.width
		}
	}
	transitions: [
		Transition {
			NumberAnimation {
				targets: [clockRect, clockRectBar]
				property: "implicitWidth"
				duration: 200
				easing.type: Easing.InOutQuad
			}
			PropertyAnimation {
				targets: [clock, clock_long]
				property: "visible"
				duration: 200
				easing.type: Easing.Linear
			}
		}
	]




	Rectangle {
		visible: false
		id: clockRectBar
		color: "#FFC5FD"
		//color: "green"
		implicitHeight: 4
		implicitWidth: clock.width + icon.width
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.leftMargin: 0
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
//		onWheel: (wheel) => {
//			if(wheel.angleDelta.y < 0) {
//				scroller.command[3] = "focus-column-right"
//				scroller.running = true
//			}
//			else if(wheel.angleDelta.y > 0) {
//				scroller.command[3] = "focus-column-left"
//				scroller.running = true
//			}
//		}
		onClicked: (mouse) => {
			clockRect.state = clockRect.state?"":"long"
		}
	}
	Row {
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 10
		spacing: 8


		Text {
			id: icon
			//anchors.left: clockRect.left
			//anchors.leftMargin: 14
			anchors.verticalCenter: parent.verticalCenter
			antialiasing: true
			renderType: Text.NativeRendering
			font.family: "Terminus"
			font.pointSize: 14
			font.bold: true
			color: '#FFC5FD'
			text: "󱑌"
		}

		Text {
			id: clock
			// center the bar in its parent component (the window)
			//anchors.centerIn: parent
			//anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			//anchors.left: icon.right
			//anchors.leftMargin: -4
			//anchors.top: clockRect.top
			//anchors.topMargin: 5

			visible: true
			antialiasing: false
			renderType: Text.NativeRendering
			font.family: "Terminus"
			font.pointSize: 18
			font.bold: true
			text: ProcManager.time
			color: '#FFC5FD'
		}
		Text {
			id: clock_long
			// center the bar in its parent component (the window)
			//anchors.centerIn: parent
			//anchors.left: icon.right
			//anchors.leftMargin: -4
			//anchors.horizontalCenter: parent.horizontalCenter
			//anchors.top: parent.top
			//anchors.topMargin: 5
			anchors.verticalCenter: parent.verticalCenter

			visible: false
			antialiasing: false
			renderType: Text.NativeRendering
			font.family: "Terminus"
			font.pointSize: 18
			font.bold: true
			text: ProcManager.time_long
			color: '#FFC5FD'
		}
	}
}
