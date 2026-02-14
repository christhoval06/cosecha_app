import 'package:flutter/material.dart';

import '../premium_features.dart';
import '../premium_guard.dart';

class PremiumFeatureGate extends StatelessWidget {
  const PremiumFeatureGate({
    super.key,
    required this.isPremium,
    required this.feature,
    required this.title,
    required this.child,
  });

  final bool isPremium;
  final PremiumFeature feature;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (isPremium) return child;

    final info = PremiumFeatures.info(feature);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                'Premium',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            info.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton.icon(
            onPressed: () async {
              await guardPremiumAccess(context, feature: feature);
            },
            icon: const Icon(Icons.workspace_premium),
            label: const Text('Desbloquear Premium'),
          ),
        ],
      ),
    );
  }
}
