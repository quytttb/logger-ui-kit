pragma ComponentBehavior: Bound

import QtGraphs
import QtQuick

// GraphsView with app theme. Root must be GraphsView so LineSeries children
// enter seriesList (not Item.data).
//
// Timezone: set `timezoneId` (IANA id) from the host; bindSystemTimezone()
// applies it to a DateTimeAxis. Hosts without timezones can ignore it (UTC).
GraphsView {
    id: root

    property string timezoneId: ""

    marginBottom: 8
    marginLeft: 8
    theme: ChartGraphsTheme {}

    readonly property alias chart: root

    function bindSystemTimezone(dateTimeAxis) {
        if (!dateTimeAxis)
            return
        dateTimeAxis.timeZone = dateTimeAxis.timeZoneFromString(
            (root.timezoneId && root.timezoneId.length > 0) ? root.timezoneId : "UTC")
    }

    onTimezoneIdChanged: if (root.axisX) bindSystemTimezone(root.axisX)
}
