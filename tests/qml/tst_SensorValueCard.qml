pragma ComponentBehavior: Bound

import QtQuick
import QtTest

import LoggerKit.Components
import LoggerKit.Theme

Item {
    id: fixture
    width: 380
    height: 240

    Component {
        id: cardComponent
        SensorValueCard {
            anchors.centerIn: parent
        }
    }

    Component {
        id: hostAction
        Item {
            objectName: "hostAction"
            implicitWidth: 40
            implicitHeight: 32
        }
    }

    TestCase {
        name: "SensorValueCard"
        when: windowShown

        function test_analogRendersProvidedPresentation() {
            const card = createTemporaryObject(cardComponent, fixture, {
                name: "SO2", value: "34.2", unit: "mg/Nm³", sensorType: "ANALOG",
                valid: true, statusText: "Measuring", limitText: "Limit: 30",
                alarmText: "▲ MAX", attachDiLabels: ["Input 1", "Input 2"],
                footerAction: hostAction
            })
            verify(card)
            compare(findChild(card, "sensorReading").text, "34.2")
            compare(findChild(card, "sensorLimit").text, "Limit: 30")
            compare(findChild(card, "sensorStatus").text, "Measuring")
            compare(findChild(card, "sensorAlarm").text, "▲ MAX")
            compare(findChild(card, "sensorAttachedInputs").text, "Input 1 · Input 2")
            verify(findChild(card, "hostAction").visible)
            card.valid = false
            compare(findChild(card, "sensorReading").text, "—")
        }

        function test_filledIsOptIn() {
            const card = createTemporaryObject(cardComponent, fixture, {
                fillColor: AppColors.successContainer, frameWidth: 2
            })
            verify(card)
            compare(card.color, AppColors.monitorCardBg)
            compare(card.border.width, 2)
            card.filled = true
            compare(card.color, AppColors.successContainer)
            compare(card.border.width, 0)
            card.fillColor = AppColors.errorContainer
            compare(card.color, AppColors.errorContainer)
        }

        function test_digitalUnavailabilityIsNotOff_data() {
            return [{tag: "input", type: "DI"}, {tag: "output", type: "DO"}]
        }

        function test_digitalUnavailabilityIsNotOff(data) {
            const card = createTemporaryObject(cardComponent, fixture, {
                name: "Digital channel", sensorType: data.type, digitalOn: true
            })
            verify(card)
            const value = findChild(card, "sensorIoValue")
            compare(value.text, "—")
            verify(!card.digitalActive)
            card.valid = true
            compare(value.text, "ON")
            verify(card.digitalActive)
            card.digitalOn = false
            compare(value.text, "OFF")
            compare(card.border.width, 1)
            card.valid = false
            compare(value.text, "—")
        }

        function test_kioskTypographyIsRetained() {
            const card = createTemporaryObject(cardComponent, fixture, {compact: false})
            verify(card)
            const reading = findChild(card, "sensorReading")
            compare(reading.font.pixelSize, 42)
            card.compact = true
            compare(reading.font.pixelSize, AppTypography.headlineSmall.pixelSize)
            card.fontScale = 1.5
            compare(reading.font.pixelSize, AppTypography.headlineSmall.pixelSize * 1.5)
            verify(!findChild(card, "sensorStatus").visible)
            verify(!findChild(card, "sensorAlarm").visible)
            verify(!findChild(card, "sensorLimit").visible)
            verify(!findChild(card, "sensorAttachedInputs").visible)
        }
    }
}
