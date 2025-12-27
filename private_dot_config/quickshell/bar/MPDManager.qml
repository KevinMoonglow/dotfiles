pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root
	property string runtimeDir
	property string configHome
	property string title
	property string file
	property string artist
	property string album
	property string state
	property real duration
	property real elapsed
	readonly property real elapsedPercent: {
		duration > 0 ? elapsed / duration : 0
	}
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
	Process {
		running: true
		command: ['sh', '-c', 'echo -n ${XDG_CONFIG_HOME:-~/.config}']
		stdout: StdioCollector {
			onStreamFinished: {
				configHome = this.text
			}
		}
	}

	function toggleFindSongDialog() {
		print(findSong.running)
		if(!findSong.running)
			findSong.running = true
		else
			findSong.running = false
		
	}
	Process {
		id: findSong
		command: [`${configHome}/bin/mpc_find_in_playlist`, "-location", "5", "-theme-str", "window {margin: 0 18px 8px 0; width: 51em;}"]
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
					root.sendCommand("status")
					root.sendCommand("currentsong")
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
				switch(key) {
					case "changed":
						if(value === "mixer")
							root.mixer(command)
						else if(value === "player")
							root.player(command)
						break
					case "volume":
						root.volume(command, parseInt(value, 10))
						break
					case "Title":
						root.title = value
						break
					case "Artist":
						root.artist = value
						break
					case "Album":
						root.album = value
						break
					case "file":
						root.file = value
						break
					case "state":
						root.state = value
						break
					case "elapsed":
						root.elapsed = parseFloat(value)
						break
					case "duration":
						root.duration = parseFloat(value)
						break
				}
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
	Timer {
		id: songElapsedTimer
		interval: 2000
		running: root.state === "play"
		repeat: true
		onTriggered: updateElapsed()
	}
	function updateElapsed() {
		MPDManager.sendCommand("status")
	}
	onVolume: (command, value) => {
		if(command !== "status") {
			volLoader.volume = value
			volLoader.loading = true
			ProcManager.playSound(root.volSound)
		}
	}
	onPlayer: {
		root.title = null
		root.artist = null
		root.file = null
		root.album = null

		sendCommand("status")
		sendCommand("currentsong")
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
