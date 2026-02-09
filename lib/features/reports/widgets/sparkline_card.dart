import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SparklineCard extends StatelessWidget {
  const SparklineCard({
    super.key,
    required this.title,
    required this.totalLabel,
    required this.changePercent,
    required this.values,
    required this.from,
    required this.to,
    this.showLabels = true,
  });

  final String title;
  final String totalLabel;
  final double? changePercent;
  final List<double> values;
  final DateTime from;
  final DateTime to;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final trendUp = (changePercent ?? 0) >= 0;
    final trendColor = trendUp ? colorScheme.secondary : colorScheme.error;
    final badgeBg = trendUp
        ? colorScheme.secondaryContainer
        : colorScheme.errorContainer;

    if (values.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        height: 180,
      );
    }
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final padding = (max - min).abs() * 0.1;
    final minY = min - padding;
    final maxY = max + padding;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  totalLabel,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (changePercent != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${trendUp ? '+' : ''}${changePercent!.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: trendColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (values.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: showLabels,
                      interval: _bottomInterval(values.length),
                      reservedSize: showLabels ? 24 : 0,
                      getTitlesWidget: (value, meta) => showLabels
                          ? _bottomTitle(
                              context,
                              value,
                              values.length,
                              from,
                              to,
                              meta,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: colorScheme.secondary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary.withOpacity(0.2),
                          colorScheme.secondary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    spots: [
                      for (int i = 0; i < values.length; i++)
                        FlSpot(i.toDouble(), values[i]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _bottomInterval(int length) {
    if (length <= 1) return 1;
    return (length - 1).toDouble() / 2;
  }

  Widget _bottomTitle(
    BuildContext context,
    double value,
    int length,
    DateTime from,
    DateTime to,
    TitleMeta meta,
  ) {
    final index = value.round().clamp(0, length - 1);
    final fraction = length <= 1 ? 0.0 : index / (length - 1);
    final diff = to.difference(from);
    final date = from.add(
      Duration(milliseconds: (diff.inMilliseconds * fraction).round()),
    );
    final locale = Localizations.localeOf(context).toString();
    final label = DateFormat.MMMd(locale).format(date);
    return SideTitleWidget(
      // axisSide: AxisSide.bottom,
      meta: meta,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
