import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
	id: root
	color: "#cc000000"
	border.color: "#eeffc5fc"
	border.width: 2
	topLeftRadius: 10
	topRightRadius: 10
	implicitWidth: row.width + 24
	clip: true

	Layout.alignment: Qt.AlignBottom
	Layout.preferredHeight: parent.height

	default property list<QtObject> rowData
	property real spacing
	data: [
		RowLayout {
			id: row
			anchors.centerIn: parent
			spacing: root.spacing

			data: root.rowData
		}
	]
}
