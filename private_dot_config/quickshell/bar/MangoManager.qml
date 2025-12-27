pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root
	property string bindMode
	property string focusedWindowTitle: "🥭"
	property var ws_data: ({})

	property bool running: mangoDataStream.running

	signal workspaceUpdate(newData: var)

	function setWorkspace(i: int) {
		dispatch(`-o DP-1 -t ${i}`)
	}
	function workspacesFor(screen: string): list<var> {
		console.log("????", Object.entries(root.ws_data[screen]).map(x => x[1]))
		if(root.ws_data?.[screen] == undefined) return []
		return Object.entries(root.ws_data[screen]).map(x => x[1])
	}
	function focusRight() {
		dispatch("-d focusdir,right")
	}
	function focusLeft() {
		dispatch("-d focusdir,left")
	}
	function focusUp() {
	dispatch("-d focusdir,up")
	}
	function focusDown() {
		dispatch("-d focusdir,down")
	}
	function toggleOverview() {
		dispatch("-d toggleoverview")
	}
	function nameWorkspace(newName, target="None") {
	}

	function dispatch(command: string) {
		let args = command.split(" ")
		dispatcher.args = args
		dispatcher.running = true
	}
	Process {
		id: dispatcher
		property list<string> args: []
		command: ['mmsg', ...args]
	}
	Process {
		id: mangoDataStream
		command: ["mmsg", "-w"]
		running: true
		stdout: SplitParser {
			onRead: dataEntry => {
				//console.log("MM:", dataEntry)

				let m = dataEntry.match(/(\S+) (\S+) (.*)/)
				if(m) {
					let [_, display, type, info] = m
					if(type === "tag") {
						let tag_args = info.split(" ")
						let [tag_num, tag_state, clients, focused_client] = tag_args
						let d_data = root.ws_data[display] ?? {}
						let t_data = d_data[tag_num] ?? {
							name: tag_num,
							output: display,
							idx: tag_num
						}

						if(tag_state == 1) {
							t_data.is_active = true
							t_data.is_urgent = false
						}
						else if(tag_state == 2) {
							t_data.is_active = false
							t_data.is_urgent = true
						}
						else {
							t_data.is_active = false
							t_data.is_urgent = false
						}
						if(focused_client)
							t_data.is_focused = true

						root.ws_data[display] = d_data
						root.ws_data[display][tag_num] = t_data
					}
					if(type === "clients") {
						let data = []
						for(let d of Object.values(root.ws_data)) {
							for(let t of Object.values(d)) {
								data.push(t)
							}
						}
						root.workspaceUpdate(data)
					}
				}
			}	
		}
	}
}

