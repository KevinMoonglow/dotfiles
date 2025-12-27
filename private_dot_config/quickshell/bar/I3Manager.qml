pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.I3

Singleton {
	id: root
	
	property string focusedWindowTitle: ""
	property bool running: I3.socketPath != null

	property var ws_data: []
	property var windows: []
	property var focusedWindow: null
	property string bindMode: "default"

	signal workspaceUpdate(newData: var)

	function workspacesFor(screen: string): list<var> {
		console.log(screen)
		console.log("ws_data:", root.ws_data.length)
		let x = root.ws_data?.filter(x => {
			console.log("fff", x && x.output)
			return x && x.output == screen
		}) ?? []
		x.sort((a, b) => a.idx - b.idx)
		return x
	}
	function setWorkspace(i: var) {
		I3.dispatch(`workspace number ${i}`)
	}
	function nameWorkspace(newName: string, target) {
		I3.dispatch(`rename workspace number ${target} to ${target}:${newName}`)
	}
	function focusRight() {
		I3.dispatch(`focus right`)
	}
	function focusLeft() {
		I3.dispatch(`focus left`)
	}
	function focusUp() {
		I3.dispatch(`focus up`)
	}
	function focusDown() {
		I3.dispatch(`focus down`)
	}
	function toggleOverview() {
		I3.dispatch(`jump`)
	}


	Component.onCompleted: {
		// Apparently this only listens to workspace events???
		I3.onRawEvent.connect(x => {
			eventHandler(x)
		})
	}
	function eventHandler(event) {
		if(event.type !== "workspace") return

		let data = JSON.parse(event.data)
		console.log(data.change)

		let cid = parseInt(data.current.id)

		if(data.change === "init") {
			console.log(data.current.name)
			root.ws_data[cid] = {
				raw_name: data.current.name,
				name: data.current.name.match(/^(?:[0-9]+:)?(.*)/)[1],
				id: cid,
				idx: parseInt(data.current.num),
				type: "workspace",
				orientation: data.current.orientation,
				is_urgent: data.current.urgent,
				is_active: data.current.active,
				is_focused: data.current.focused,
				output: data.current.output
			}
		}
		else if(data.change === "empty") {
			delete root.ws_data[cid]
		}
		else if(data.change === "focus") {
			let oid = parseInt(data.old.id)

			root.ws_data[oid].is_focused = false
			if(data.old.output == data.current.output)
				root.ws_data[oid].is_active = false
			root.ws_data[cid].is_focused = true
			root.ws_data[cid].is_active = true


			//console.log(data.old.focused, data.current.focused)
			//console.log(data.old.active, data.current.active)

			//console.log(DesktopManager.backend)
		}
		else if(data.change === "move") {
			root.ws_data[cid].output = data.current.output
		}
		else if(data.change === "rename") {
			root.ws_data[cid].raw_name = data.current.name
			root.ws_data[cid].name = data.current.name.match(/^(?:[0-9]+:)?(.*)/)[1]
			root.ws_data[cid].idx = data.current.num
		}
		else if(data.change === "urgent") {
			root.ws_data[cid].is_urgent = data.current.urgent
		}
		workspaceUpdate(root.ws_data)
	}
	Process {
		running: root.running
		id: windowEventListener
		command: ['i3-msg', '-m', '-t', 'subscribe', "['window']"]
		stdout: SplitParser {
			onRead: jsonData => {
				let data = JSON.parse(jsonData)
				if(data.container?.focused) {
					root.focusedWindowTitle = data.container.name 
				}
			}
		}
	}
	Process {
		running: root.running
		id: modeEventListener
		command: ['i3-msg', '-m', '-t', 'subscribe', "['mode']"]
		stdout: SplitParser {
			onRead: jsonData => {
				let data = JSON.parse(jsonData)
				root.bindMode = data.change
			}
		}
	}
	Process {
		running: root.running
		id: initialDataTree
		command: ['i3-msg', '-t', "get_tree"]
		stdout: StdioCollector {
			onStreamFinished: {
				let data = JSON.parse(this.text)
				root.windows = []
				root.ws_data = []

				root.parseTreeItem(data)
				workspaceUpdate(root.ws_data)
				console.log("yyy", root.ws_data.length)
			}
		}
	}
	function parseTreeItem(data: var) {
		console.log(`type: ${data.type}; id: ${data.id}; name: ${data.name}; app_id: ${data.app_id}; output: ${data.output}`)

		if(data.type === "workspace" && !data.name.startsWith("__")) {
			root.ws_data[parseInt(data.id)] = {
				raw_name: data.name,
				name: data.name.match(/^(?:[0-9]+:)?(.*)/)[1],
				id: parseInt(data.id),
				idx: parseInt(data.num),
				type: "workspace",
				orientation: data.orientation,
				is_urgent: data.urgent,
				is_active: data.active,
				is_focused: data.focused,
				output: data.output
			}
			console.log("xxx", root.ws_data.length)
			workspaceUpdate(root.ws_data)
		}
		else if(data.type === "con" && data.app_id !== null) {
		}

		for(let child of data.nodes) {
			root.parseTreeItem(child)
		}
	}
}
