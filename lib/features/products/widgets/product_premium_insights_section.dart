import 'package:flutter/material.dart';

import '../../../core/premium/premium_access.dart';
import '../../../core/premium/premium_features.dart';
import '../../../core/premium/widgets/premium_feature_gate.dart';
import '../../../data/models/product.dart';
import '../../../data/models/product_price_history.dart';
import '../../../l10n/app_localizations.dart';
import 'price_performance_card.dart';
import 'product_price_history_compact.dart';
import 'product_price_impact_card.dart';

class ProductPremiumInsightsSection extends StatelessWidget {
  const ProductPremiumInsightsSection({
    super.key,
    required this.l10n,
    required this.product,
    required this.currentPrice,
    required this.suggestedPriceCard,
    required this.totalLabel,
    required this.changePercent,
    required this.values,
    required this.from,
    required this.to,
    required this.history,
  });

  final AppLocalizations l10n;
  final Product product;
  final double currentPrice;
  final Widget suggestedPriceCard;
  final String totalLabel;
  final double? changePercent;
  final List<double> values;
  final DateTime from;
  final DateTime to;
  final List<ProductPriceHistory> history;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: PremiumAccess.instance.listenable,
      builder: (context, isPremium, _) {
        return Column(
          children: [
            const SizedBox(height: 16),
            PremiumFeatureGate(
              isPremium: isPremium,
              feature: PremiumFeature.productSuggestedPrice,
              title: l10n.productSuggestedPriceTitle,
              child: suggestedPriceCard,
            ),
            const SizedBox(height: 16),
            PremiumFeatureGate(
              isPremium: isPremium,
              feature: PremiumFeature.productPriceImpact,
              title: l10n.productPriceImpactTitle,
              child: ProductPriceImpactCard(
                title: l10n.productPriceImpactTitle,
                previousPrice: product.currentPrice,
                currentPrice: currentPrice,
                deltaLabel: l10n.productPriceImpactDelta,
                percentLabel: l10n.productPriceImpactPercent,
                unitsLabel: l10n.productPriceImpactUnits,
              ),
            ),
            const SizedBox(height: 24),
            PremiumFeatureGate(
              isPremium: isPremium,
              feature: PremiumFeature.productPricePerformance,
              title: l10n.productPricePerformanceTitle,
              child: PricePerformanceCard(
                title: l10n.productPricePerformanceTitle,
                totalLabel: totalLabel,
                changePercent: changePercent,
                values: values,
                from: from,
                to: to,
                showLabels: false,
              ),
            ),
            const SizedBox(height: 16),
            PremiumFeatureGate(
              isPremium: isPremium,
              feature: PremiumFeature.productRecentHistory,
              title: l10n.productPriceHistoryCompactTitle,
              child: ProductPriceHistoryCompact(
                title: l10n.productPriceHistoryCompactTitle,
                entries: history,
                emptyLabel: l10n.productPriceHistoryCompactEmpty,
                deltaLabel: l10n.productPriceHistoryCompactDelta,
              ),
            ),
          ],
        );
      },
    );
  }
}
