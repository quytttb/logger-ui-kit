pragma ComponentBehavior: Bound

import QtQuick
import QtTest

import LoggerKit.Components

Item {
    width: 600
    height: 400

    ListModel {
        id: emptyModel
    }

    ListModel {
        id: sampleModel
        // Role named "display" matches the header textRole convention of AppTableView.
        ListElement { display: "Alpha" }
        ListElement { display: "Beta" }
        ListElement { display: "Gamma" }
    }

    AppTableView {
        id: table
        anchors.fill: parent
        model: emptyModel
        colWeights: [1]
        colMinimums: [80]
    }

    TestCase {
        name: "AppTableViewTests"

        function init() {
            table.model = emptyModel
        }

        function test_emptyByDefault() {
            tryCompare(table, "rows", 0)
            verify(!table.hasData)
        }

        function test_rowsFollowModel() {
            table.model = sampleModel
            tryCompare(table, "rows", 3)
            verify(table.hasData)
        }

        function test_colWidthsDistributed() {
            table.model = sampleModel
            tryCompare(table, "rows", 3)
            compare(table.colWidths.length, 1)
            verify(table.colWidths[0] > 80)
        }
    }
}
