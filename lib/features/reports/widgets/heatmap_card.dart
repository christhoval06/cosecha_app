import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapCard extends StatelessWidget {
  const HeatmapCard({super.key, required this.totals, required this.to});

  final Map<DateTime, double> totals;
  final DateTime to;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    final maxValue = totals.values.isEmpty
        ? 0.0
        : totals.values.reduce((a, b) => a > b ? a : b);
    final datasets = _normalizeTotals(totals, maxValue);
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
      child: HeatMap(
        startDate: DateTime(
          to.year,
          to.month,
          to.day,
        ).subtract(const Duration(days: 120)),
        endDate: DateTime(to.year, to.month, to.day),
        datasets: datasets,
        colorMode: ColorMode.opacity,
        defaultColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
        textColor: colorScheme.onSurface,
        size: 14,
        fontSize: 10,
        showText: false,
        showColorTip: false,
        scrollable: true,
        colorsets: {
          1: colorScheme.primary.withOpacity(0.2),
          2: colorScheme.primary.withOpacity(0.35),
          3: colorScheme.primary.withOpacity(0.5),
          4: colorScheme.primary.withOpacity(0.7),
          5: colorScheme.primary.withOpacity(0.9),
        },
      ),
    );
  }

  Map<DateTime, int> _normalizeTotals(
    Map<DateTime, double> totals,
    double maxValue,
  ) {
    final normalized = <DateTime, int>{};
    for (final entry in totals.entries) {
      final day = DateTime(entry.key.year, entry.key.month, entry.key.day);
      if (maxValue <= 0) {
        normalized[day] = 1;
      } else {
        final intensity = ((entry.value / maxValue) * 5).ceil().clamp(1, 5);
        normalized[day] = intensity;
      }
    }
    return normalized;
  }
}
