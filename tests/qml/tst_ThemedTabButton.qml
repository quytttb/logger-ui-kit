pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtTest

import LoggerKit.Components

Item {
    width: 260
    height: 120

    TabBar {
        id: tabs
        width: parent.width

        ThemedTabButton {
            id: dataTab
            text: "Data"
        }
        ThemedTabButton {
            id: graphTab
            text: "Graph"
            iconOnly: true
            iconName: "showChart"
        }
    }

    TestCase {
        name: "ThemedTabButton"
        when: windowShown

        function test_selectionAndAccessibleLabel() {
            compare(tabs.currentIndex, 0)
            verify(dataTab.checked)
            compare(graphTab.Accessible.name, "Graph")
            mouseClick(graphTab)
            compare(tabs.currentIndex, 1)
            verify(graphTab.checked)
            verify(!dataTab.checked)
        }
    }
}
