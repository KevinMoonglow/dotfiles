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
	readonly property bool muted: Pipewire.defaultAudioSink?.audio.muted
	readonly property bool headphones: Pipewire.defaultAudioSink.description?.match(/Kraken/)
	readonly property string volSound: "/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
	HoverText {
		hovered: hover.hovered
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
	WrapperMouseArea {
		cursorShape: Qt.SizeVerCursor
		onWheel: (wheel) => {
			if(wheel.angleDelta.y >= 120) {
				if(Pipewire.defaultAudioSink) {
					if(Pipewire.defaultAudioSink.audio.volume + 0.02 > 1.0) {
						Pipewire.defaultAudioSink.audio.volume = 1.0
					}
					else Pipewire.defaultAudioSink.audio.volume += 0.02
					ProcManager.playSound(volSound)
					osdLoader.loading = true
					
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

		RowLayout {
			id: rl
			SText {
				text: {
					if(root.headphones) {
						if(Pipewire.defaultAudioSink?.audio.muted) "󰋐"
						else if(volPercent >= 30) ""
						else if(volPercent > 0) ""
						else ""
					}
					else {
						if(Pipewire.defaultAudioSink?.audio.muted) ""
						else if(volPercent >= 30) ""
						else if(volPercent > 0) ""
						else ""
					}
				}
				color: root.muted ? "#aaaaaa" : "#FFC5FC"
				rightPadding: 8
			}

			SText {
				text: `${root.volPercent}%`
				color: root.muted ? "#aaaaaa" : "#FFC5FC"
			}
		}
	}


}
