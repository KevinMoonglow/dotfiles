import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Quickshell.Widgets

ModuleTab {
	id: root
	PwObjectTracker {
		objects: [ Pipewire.defaultAudioSink ]
	}
	HoverHandler {
		id: hover
	}
	readonly property int volPercent: Math.round(Pipewire.defaultAudioSink?.audio.volume * 100)
	readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted ?? false
	readonly property bool headphones: Pipewire.defaultAudioSink?.description?.match(/Kraken/)
	readonly property string volSound: "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
	HoverText {
		hovered: hover.hovered && !menu.visible
		message: Pipewire.defaultAudioSink?.description ?? "No Audio?"
		item: root
		gravity: Edges.Top
		edges: Edges.Top
	}
	LazyLoader {
		id: osdLoader
		loading: false
		active: false
		VolumeOSD {
			volume: volPercent
			muted: root.muted
			onDone: {
				osdLoader.active = false
			}
		}
	}



	ListMenu {
		id: menu
		anchor.gravity: Edges.Top
		visible: false
		menuItems: {
			let l = [
				{ itemText: " Audio Select", disabled: true, itemIcon: "", color: "#76D1FF" },
				{ itemText: "---", disabled: true }
			]
			// Not sure how 17 is mapped to anything, but no other way to refer to the type I want.
			for(let o of Pipewire.nodes.values.filter(x => x.isSink && x.type == 17)) {
				let nerdIcon = "󰓃"
				let displayName = o.nickname || o.description || o.name

				if(o.nickname.match(/Kraken/)) nerdIcon = ""
				if(o.nickname.match(/Kraken/)) displayName = ""
				if(o.nickname.match(/ALC/)) displayName = "Speakers"



				l.push({
					itemText: `${nerdIcon} ${displayName}`,
					itemIcon: "",
					disabled: false,
					active: o == Pipewire.defaultAudioSink,
					action: () => {Pipewire.preferredDefaultAudioSink = o}
				})
			}
			return l
		}
	}
	WrapperMouseArea {
		cursorShape: Qt.SizeVerCursor
		acceptedButtons: Qt.RightButton
		onWheel: (wheel) => {
			if(wheel.angleDelta.y >= 120) {
				if(Pipewire.defaultAudioSink) {
					osdLoader.loading = true
					if(Pipewire.defaultAudioSink.audio.volume + 0.02 > 1.0) {
						Pipewire.defaultAudioSink.audio.volume = 1.0
					}
					else Pipewire.defaultAudioSink.audio.volume += 0.02
					ProcManager.playSound(volSound)
					
				}
			}
			else if(wheel.angleDelta.y <= 120) {
				if(Pipewire.defaultAudioSink) {
					Pipewire.defaultAudioSink.audio.volume -= 0.02
					ProcManager.playSound(volSound)
					osdLoader.loading = true
				}
			}
		}
		onClicked: {
			menu.anchor.item = root
			menu.visible = !menu.visible
		}

		RowLayout {
			id: rl
			spacing: 8
			SText {
				text: {
					if(root.headphones) {
						if(Pipewire.defaultAudioSink?.audio.muted) "󰋐"
						else if(volPercent >= 30) ""
						else if(volPercent > 0) ""
						else ""
					}
					else {
						if(Pipewire.defaultAudioSink?.audio.muted) "󰸈"
						else if(volPercent >= 30) "󰕾"
						else if(volPercent > 0) "󰖀"
						else "󰕿"
					}
				}
				font.pointSize: 15
				color: root.muted ? "#aaaaaa" : "#FFC5FC"
			}

			SText {
				text: `${root.volPercent}%`
				color: root.muted ? "#aaaaaa" : "#FFC5FC"
			}
		}
	}
}
