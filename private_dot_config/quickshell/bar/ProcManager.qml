pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick


Singleton {
	id: root
	readonly property string time: {
		Qt.formatDateTime(clock.date, "hh:mm")
	}
	readonly property string time_long: {
		Qt.formatDateTime(clock.date, "hh:mm:ss yyyy-MM-dd")
	}
	readonly property string monthDay: {
		Qt.formatDateTime(clock.date, "dd")
	}
	property string ramPercent
	property string calData

	SystemClock {
		id: clock
		precision: SystemClock.Seconds
	}
	property Process calendar: Process {
		id: calendar
		command: ["cal"]
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				calData = this.text.replace(/\s*$/, "")
			}
		}
	}

	function playSound(fileName: string) {
		audio.audioFile = fileName
		audio.startDetached()
	}
	Process {
		id: audio
		property string audioFile
		command: ['pw-play', `${audioFile}`]
	}


	Process {
		id: memProc
		command: ["free"]
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				let lines = this.text.split("\n").filter(x => x.match(/Mem/))
				let fields = lines[0].split(/\s+/)
				root.ramPercent = `${Math.round(fields[2] / fields[1] * 100)}%`
			}
		}
	}
	Timer {
		interval: 1000
		running: true
		repeat: true
	}
	Timer {
		interval: 30000
		running: true
		repeat: true
		onTriggered: memProc.running = true
	}
}
