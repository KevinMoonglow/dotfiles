pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick


Singleton {
	id: root
	property var ws_data: {}
	property var windows: []
	property var focusedWindow: null
	property list<int> urgencyQueue: []

	function setWorkspace(i: int) {
		workspaceSwitcher.target = i
		workspaceSwitcher.running = true
	}
	function focusRight() {
		genericAction.action = "focus-column-right"
		genericAction.running = true
	}
	function focusLeft() {
		genericAction.action = "focus-column-left"
		genericAction.running = true
	}
	function toggleOverview() {
		genericAction.action = "toggle-overview"
		genericAction.running = true
	}
	function nameWorkspace(newName, target="None") {
		if(newName)
			genericActionArgs.args = [
				'set-workspace-name', '--workspace', `${target}`, `${newName}`
			]
		else
			genericActionArgs.args = ['unset-workspace-name', `${target}`]

		genericActionArgs.running = true
	}
	function windowList() {
		if(!windowListPopup.running)
			windowListPopup.running = true
		else
			windowListPopup.running = false
	}
	Timer {
		id: niriTimer
		interval: 1000
		running: false
		repeat: true
		onTriggered: workspaceLookup.running = true
	}

	Process {
		id: windowListPopup
		command: ['rofi', '-modi', 'window', '-show', 'window', '-location', '7',
		'-theme', 'lunacy-dmenu-v',
		'-theme-str', 'window {width: 40em; margin: 0 0 8px 18px;} listview {}']
	}
	Process {
		id: genericAction
		property string action: ""
		command: ["niri", "msg", "action", `${action}`]
	}
	Process {
		id: genericActionArgs
		property list<string> args: []
		command: ["niri", "msg", "action", ...args]
		onRunningChanged: {
			//print(args)
			//print(command)
		}
	}
	Process {
		id: workspaceSwitcher
		property int target: 1
		command: ["niri", "msg", "action", "focus-workspace", `${target}`]
	}
	Process {
		id: niriDataStream
		command: ["niri", "msg", "-j", "event-stream"]
		stdout: SplitParser {
			onRead: jsonData => {
				//console.log(jsonData)
				let data = JSON.parse(jsonData)
				let rawWorkspaceData = data?.WorkspacesChanged?.workspaces
				if(rawWorkspaceData) {
					rawWorkspaceData.sort((a, b) => {
						return a.output == b.output ?
						a.idx - b.idx :
						a.output.localeCompare(b.output)
					})
					root.ws_data = rawWorkspaceData
				}
				if(data.WorkspaceActivated && data.WorkspaceActivated.focused) {
					let oldWSi = root.ws_data.findIndex(x => x.is_focused)
					let newWSi = root.ws_data.findIndex(x => x.id == data.WorkspaceActivated.id)

					let oldWS = oldWSi !== -1 ? root.ws_data[oldWSi] : null
					let newWS = newWSi !== -1 ? root.ws_data[newWSi] : null

					if(oldWS && newWS) {
						oldWS.is_focused = false
						newWS.is_focused = true
						newWS.is_active = true

						if(oldWS.output == newWS.output)
							oldWS.is_active = false

						root.ws_data[oldWSi] = oldWS
						root.ws_data[newWSi] = newWS
					}
					ws_data = ws_data
				}
				if(data.WorkspaceUrgencyChanged) {
					let WSi = root.ws_data.findIndex(x => x.id == data.WorkspaceUrgencyChanged.id)
					if(WSi !== -1) {
						let WS = root.ws_data[WSi]
						WS.is_urgent = data.WorkspaceUrgencyChanged.urgent

						ws_data = ws_data
					}
				}
				if(data.WindowsChanged) {
					root.urgencyQueue.length = 0
					for(let w of data.WindowsChanged.windows) {
						root.windows[w.id] = w
						if(w.is_focused) root.focusedWindow = w
						if(w.is_urgent) root.urgencyQueue.push(w.id)
					}
				}
				if(data.WindowClosed) {
					root.urgencyQueue = root.urgencyQueue.filter(x => x !== data.WindowClosed.id)
					delete root.windows[data.WindowClosed.id]
				}
				if(data.WindowOpenedOrChanged) {
					let w = data.WindowOpenedOrChanged.window
					root.windows[w.id] = w
					if(w.is_focused) root.focusedWindow = w
					if(!w.is_urgent)
						root.urgencyQueue = root.urgencyQueue.filter(x => x !== data.WindowClosed.id)
				}
				if(data.WindowFocusChanged) {
					root.focusedWindow = root.windows[data.WindowFocusChanged.id]
				}
				if(data.WindowUrgencyChanged) {
					if(data.WindowUrgencyChanged.urgent) {
						root.urgencyQueue.push(data.WindowUrgencyChanged.id)
					}
				}
			}
		}
		running: true
	}


	Process {
		id: workspaceLookup
		command: ["niri", "msg", "-j", "workspaces"]
		stdout: StdioCollector {
			onStreamFinished: {
				let data = JSON.parse(this.text)
				data.sort((a, b) => {
					return a.output == b.output ?
					a.idx - b.idx :
					a.output.localeCompare(b.output)
				})
				ws_data = data
			}
		}
	}
	IpcHandler {
		target: "niriManager"
		function focusNextUrgent() {
			let next = root.urgencyQueue.shift()
			if(next != null) {
				genericActionArgs.args = ['focus-window', '--id', `${next}`]
				genericActionArgs.running = true
			}
		}
	}
}
