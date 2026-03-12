import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import Quickshell.Io
import Quickshell.Widgets

ModuleTab {
	id: root
	border.color: "#76d1ff"
	RowLayout {
		SText {
			color: osLogoGetter.color
			text: `${osLogoGetter.logo}`
		}
		IconImage {
			id: hostIcon
			Layout.preferredWidth: 24
			Layout.preferredHeight: 24
			source: {
				switch(hostnameGetter.hostname) {
					case "eevee": "root:assets/eevee-icon.png"; break;
					default: "";
				}
			}
			visible: { hostIcon.source != "" }
		}
		SText {
			color: "#76d1ff"
			text: `${hostnameGetter.hostname}`
		}
	}
	Process {
		id: hostnameGetter
		property string hostname
		command: ['hostname']
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				hostnameGetter.hostname = this.text.replace("\n", "")
			}
		}
	}
	Process {
		id: osLogoGetter
		property string logo: "?"
		property string color: "#ffffff"
		command: ['cat', '/etc/os-release']
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				let m = this.text.match(/^LOGO=(.*)/m)
				if(m) {
					let logoName
					if(m[1][0] == '"') {
						let mm = m[1].match(/^"(.*)"$/)
						if(mm) logoName = mm[1]
					}
					else
						logoName = m[1]
					switch(logoName) {
						case "nix-snowflake":
							osLogoGetter.logo = "" 
							osLogoGetter.color = "#88aaff"
							break
						case "cachyos":
						case "archlinux-logo":
							osLogoGetter.logo = ""
							osLogoGetter.color = "#2966b9"
							break
						default:
							osLogoGetter.logo = "";
							osLogoGetter.color = "#ffffff"
					}
				}
			}
		}
	}
}
