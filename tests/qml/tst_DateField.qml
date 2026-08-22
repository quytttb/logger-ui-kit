pragma ComponentBehavior: Bound

import QtQuick
import QtTest

import LoggerKit.Components

Item {
    width: 400
    height: 300

    DateField {
        id: field
        anchors.centerIn: parent
        initialDate: new Date(2026, 7, 15)
    }

    TestCase {
        name: "DateFieldTests"

        function init() {
            if (field.pickerPopup.opened)
                field.pickerPopup.close()
            field.text = field.formatDate(field.initialDate)
        }

        function test_formatDate_zeroPads() {
            compare(field.formatDate(new Date(2026, 0, 5)), "05/01/2026")
            compare(field.formatDate(new Date(2026, 9, 31)), "31/10/2026")
        }

        function test_parseDate_roundTrip() {
            const d = field.parseDate("07/03/2026")
            compare(d.getFullYear(), 2026)
            compare(d.getMonth(), 2)
            compare(d.getDate(), 7)
        }

        function test_parseDate_invalid_returnsInvalidDate() {
            verify(isNaN(field.parseDate("").getTime()))
            verify(isNaN(field.parseDate("not-a-date").getTime()))
        }

        function test_dateProperty_tracksText() {
            field.text = "20/07/2026"
            compare(field.date.getFullYear(), 2026)
            compare(field.date.getMonth(), 6)
            compare(field.date.getDate(), 20)
        }

        function test_openPicker_seededFromParsedText() {
            field.text = "20/07/2026"
            field.openPicker()
            tryCompare(field.pickerPopup, "opened", true)
            compare(field.pickerPopup.selectedDate.getFullYear(), 2026)
            compare(field.pickerPopup.selectedDate.getMonth(), 6)
            compare(field.pickerPopup.selectedDate.getDate(), 20)
        }

        function test_openPicker_invalidText_fallsBackToInitialDate() {
            field.text = "bogus"
            field.openPicker()
            tryCompare(field.pickerPopup, "opened", true)
            const s = field.pickerPopup.selectedDate
            compare(s.getFullYear(), 2026)
            compare(s.getMonth(), 7)
            compare(s.getDate(), 15)
        }
    }
}
