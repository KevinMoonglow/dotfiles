pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root
	property string runtimeDir
	Process {
		running: true
		command: ['sh', '-c', 'echo -n $XDG_RUNTIME_DIR']
		stdout: StdioCollector {
			onStreamFinished: {
				runtimeDir = this.text
				sock.connected = true
			}
		}
	}
	signal mixer(command: string)
	signal player(command: string)
	signal volume(command: string, value: int)

	property list<string> commandQueue

	function sendCommand(command: string) {
		commandQueue.push(command)
		//print(sock.isIdle, command)
		if(sock.isIdle) {
			sock.write("noidle\n")
			//print(`sent noidle`)
			sock.isIdle = false
		}
	}
	function nextCommand() {
		if(sock.isIdle) {
			sock.write("noidle\n")
			sock.isIdle = false
			//print(`sent noidle`)
		}
		else if(!sock.lastCommand) {
			let command = commandQueue.shift()
			sock.lastCommand = command
			sock.data = []
			sock.write(`${command}\n`)
			console.log(commandQueue)
			print(`sent ${command}`)
		}
		else print(`??? ${sock.lastCommand}`)
	}
	Socket {
		id: sock
		connected: false
		property bool isIdle: true
		property string lastCommand
		property var data: []
		path: `${root.runtimeDir}/mpd/socket`

		signal commandOK(command: string, data: var)
		signal commandACK(command: string, error: string)

		parser: SplitParser {
			onRead: message => {
				//print(`message "${message}"`)
				let key, value
				let m
				if(message.match(/^OK MPD/)) {
					sock.isIdle = false
				}
				else if(m = message.match(/^ACK (.*)/)) {
					sock.isIdle = false
					let command = sock.lastCommand
					sock.lastCommand = null
					sock.data = []
					sock.commandACK(command, m[1])
				}
				else if(message === "OK") {
					sock.isIdle = false
					let command = sock.lastCommand
					let cdata = sock.data
					sock.lastCommand = null
					sock.data = []
					//print(`signal OK ${command}, ${cdata}`)
					sock.commandOK(command, cdata)
				}
				else if(m = message.match(/^([^:]+): (.*)/)) {
					print(`data: ${m[1]}: ${m[2]}`)
					let data = sock.data
					data.push({key: m[1], value: m[2]})
					sock.data = data
				}
				else print(`unknown: "${message}"`)
				onError: error => {
					print(`error: ${error}`)
				}
			}
		}
		onCommandOK: (command, data) => {
			//print(`OK! ${command}`)
			console.log(data, data.length)

			for(let {key, value} of data) {
				if(key === "changed" && value === "mixer")
					root.mixer(command)
				else if(key === "changed" && value === "player")
					root.player(command)
				else if(key === "volume")
					root.volume(command, parseInt(value, 10))
			}
		}
		onIsIdleChanged: {
			if(!sock.isIdle) {
				idleTimer.restart()
			}
		}
		onConnectionStateChanged: {
			if(connected) print("MPD Connected")
			if(!connected) {
				print("MPD Disconnected")

				reconnectTimer.running = true
			}
		}
	}
	Timer {
		id: idleTimer
		running: false
		interval: 50
		onTriggered: {
			if(!sock.isIdle) {
				if(root.commandQueue.length > 0 && !sock.lastCommand) {
					root.nextCommand()
					this.restart()
				}
				else {
					sock.write("idle\n")
					sock.lastCommand = "idle"
					sock.data = []
					sock.isIdle = true
					print("idle")
				}
			}
		}
	}
	Timer {
		id: reconnectTimer
		running: false
		interval: 6000
		onTriggered: {
			sock.connected = true
		}
	}
	onVolume: (command, value) => {
		if(command !== "status") {
			volLoader.volume = value
			volLoader.loading = true
			ProcManager.playSound(root.volSound)
		}
	}
	readonly property string volSound: "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
	LazyLoader {
		property int volume: 0
		id: volLoader
		loading: false
		active: false
		VolumeOSD {
			volume: volLoader.volume
			muted: false
			onDone: {
				volLoader.active = false
				print("done")
			}
			onVisibleChanged: {
				print(`visible: ${this.visible}`)
			}
			baseColor: "#76D1FF"
			loudIcon: "󰝚"
			quietIcon: "󰎇"
			silentIcon: "󰽹"
			muteIcon: "󰝛"
			loudLevel: 50
		}
	}
}
