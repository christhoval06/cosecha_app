import 'package:flutter/material.dart';

import '../../reports/widgets/sparkline_card.dart';

class PricePerformanceCard extends StatelessWidget {
  const PricePerformanceCard({
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
    return SparklineCard(
      title: title,
      totalLabel: totalLabel,
      changePercent: changePercent,
      values: values,
      from: from,
      to: to,
      showLabels: showLabels,
    );
  }
}
