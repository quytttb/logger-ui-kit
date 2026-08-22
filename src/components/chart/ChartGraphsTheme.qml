import QtGraphs

import LoggerKit.Theme

GraphsTheme {
    id: root

    colorScheme: AppTheme.isLightTheme ? GraphsTheme.ColorScheme.Light : GraphsTheme.ColorScheme.Dark
    // Match elevated panes/cards — plot area defaults to a darker scheme color.
    backgroundColor: AppColors.surfaceContainerLow
    plotAreaBackgroundColor: AppColors.surfaceContainerLow
    seriesColors: AppColors.graphSeriesColors
    labelTextColor: AppColors.onSurfaceVariant
}
