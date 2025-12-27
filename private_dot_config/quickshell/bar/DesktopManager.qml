pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id: root
	property string bindMode: backend.bindMode
	property var backend: {
		console.log("@@", MangoManager.running)
		if(NiriManager.running) return NiriManager
		else if(MangoManager.running) return MangoManager
		else if(I3Manager.running) return I3Manager
		else return null
	}
	property list<var> ws_data: []

	Component.onCompleted: {
		NiriManager.onWorkspaceUpdate.connect(newData => {
			updateWorkspaces(newData)
		})
		I3Manager.onWorkspaceUpdate.connect(newData => {
			updateWorkspaces(newData)
		})
		MangoManager.onWorkspaceUpdate.connect(newData => {
			updateWorkspaces(newData)
		})
	}

	function updateWorkspaces(newData) {
		if(NiriManager.running) console.log("Niri")
		else if(I3Manager.running) console.log("I3")
		else console.log("null")
		if(newData != null) {
			for(let x of newData.filter(x => x)) {
				console.log("bbb", x.name, x.is_focused)
			}
		}
		if(newData != null) root.ws_data = newData.filter(x => x)
		else root.ws_data = []
	}

	function workspacesFor(screen: string): list<var> {
		return backend ? backend.workspacesFor(screen) : []
	}
	property string focusedWindowTitle: backend?.focusedWindowTitle ?? ""

	function setWorkspace(i: var) {
		return backend.setWorkspace(i)
	}
	function focusRight() {
		return backend.focusRight()
	}
	function focusLeft() {
		return backend.focusLeft()
	}
	function focusUp() {
		return backend.focusRight()
	}
	function focusDown() {
		return backend.focusLeft()
	}
	function toggleOverview() {
		return backend.toggleOverview()
	}
	function nameWorkspace(newName, target="None") {
		return backend.nameWorkspace(newName, target)
	}
	function windowList() {
		if(!windowListPopup.running)
			windowListPopup.running = true
		else
			windowListPopup.running = false
	}
	Process {
		id: windowListPopup
		command: ['rofi', '-modi', 'window', '-show', 'window', '-location', '7',
		'-theme', 'lunacy-dmenu-v',
		'-theme-str', 'window {width: 40em; margin: 0 0 8px 18px;} listview {}']
	}
}
