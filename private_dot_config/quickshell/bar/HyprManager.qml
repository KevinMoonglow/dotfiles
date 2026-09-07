pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Hyprland

Singleton {
	id: root
	property var running: Boolean(Hyprland.eventSockPath)
	property var ws_data: ({})
	property var windows: []
	property var focusedWindow: null
property string focusedWindowTitle: focusedWindow?.title ?? ""
	property string bindMode: "default"

	function setWorkspace(i: int) {
		Hyprland.dispatch("workspace ${i}")
	}
	function workspacesFor(screen: string): list<var> {
		return root.ws_data?.filter(x => x.output == screen) ?? []
	}
}
