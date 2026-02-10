import 'dart:io';

import 'package:cosecha_app/core/widgets/notched_bottom_nav.dart';
import 'package:cosecha_app/data/models/product.dart';
import 'package:cosecha_app/data/repositories/business_repository.dart';
import 'package:cosecha_app/features/home/widgets/performance_card.dart';
import 'package:cosecha_app/features/home/widgets/quick_item.dart';
import 'package:cosecha_app/features/home/widgets/recent_item.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';

import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/data/hive/boxes.dart';
import 'package:cosecha_app/data/models/sale_transaction.dart';
import 'package:cosecha_app/data/repositories/sales_repository.dart';
import 'package:cosecha_app/core/utils/formatters.dart';
import 'package:cosecha_app/core/utils/time_utils.dart';
import 'package:cosecha_app/core/services/business_session.dart';
import 'package:cosecha_app/core/constants/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) return;
    if (index == 2) {
      Navigator.of(
        context,
      )
          .pushNamed(AppRoutes.products)
          .then((_) => setState(() => _currentIndex = 0));
      return;
    }
    if (index == 1) {
      Navigator.of(context)
          .pushNamed(AppRoutes.reports)
          .then((_) => setState(() => _currentIndex = 0));
      return;
    }
    if (index == 3) {
      Navigator.of(context)
          .pushNamed(AppRoutes.settings)
          .then((_) => setState(() => _currentIndex = 0));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final business = BusinessSession.instance.current;

    return Scaffold(
      appBar: AppBar(title: Text(business?.name ?? l10n.homeTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ValueListenableBuilder<Box<Business>>(
              valueListenable: BusinessRepository().listenable(),
              builder: (context, box, _) {
                final business = box.get(BusinessRepository.currentKey);
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: business?.logoPath != null
                          ? FileImage(File(business!.logoPath!))
                          : null,
                      child: business?.logoPath == null
                          ? const Icon(Icons.storefront, size: 22)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeSectionDashboard,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(letterSpacing: 1.2),
                          ),
                          Text(
                            business?.name ?? l10n.homeProductOverview,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homePerformanceOverview,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<Box<SaleTransaction>>(
              valueListenable: Hive.box<SaleTransaction>(
                HiveBoxes.transactions,
              ).listenable(),
              builder: (context, box, _) {
                final repo = SalesRepository();
                final now = DateTime.now();
                final todayStart = DateTime(now.year, now.month, now.day);
                final weekStart = now.subtract(const Duration(days: 7));
                final monthStart = now.subtract(const Duration(days: 30));

                final today = repo.getPeriodSummary(todayStart, now);
                final week = repo.getPeriodSummary(weekStart, now);
                final month = repo.getPeriodSummary(monthStart, now);

                return Column(
                  children: [
                    PerformanceCard(
                      label: l10n.homeToday,
                      amount: formatCurrencyCompact(today.current),
                      delta: formatPercentDelta(today.deltaPercent),
                      deltaPositive: today.deltaPercent >= 0,
                      background: colorScheme.surface,
                    ),
                    const SizedBox(height: 12),
                    PerformanceCard(
                      label: l10n.homeThisWeek,
                      amount: formatCurrencyCompact(week.current),
                      delta: formatPercentDelta(week.deltaPercent),
                      deltaPositive: week.deltaPercent >= 0,
                      background: colorScheme.surface,
                    ),
                    const SizedBox(height: 12),
                    PerformanceCard(
                      label: l10n.homeThisMonth,
                      amount: formatCurrencyCompact(month.current),
                      delta: formatPercentDelta(month.deltaPercent),
                      deltaPositive: month.deltaPercent >= 0,
                      background: colorScheme.surface,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homeQuickSale,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<Box<Product>>(
              valueListenable: Hive.box<Product>(
                HiveBoxes.products,
              ).listenable(),
              builder: (context, productBox, _) {
                if (productBox.values.isEmpty) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.products),
                      child: Text(l10n.homeQuickAddProducts),
                    ),
                  );
                }

                return ValueListenableBuilder<Box<SaleTransaction>>(
                  valueListenable: Hive.box<SaleTransaction>(
                    HiveBoxes.transactions,
                  ).listenable(),
                  builder: (context, salesBox, __) {
                    final topProducts = SalesRepository().getTopProducts(
                      limit: 3,
                    );
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final product in topProducts)
                          QuickItem(
                            label: product.name,
                            imagePath: product.imageUrl,
                            onTap: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.saleAdd, arguments: product),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.saleAdd),
                icon: const Icon(Icons.add),
                label: Text(l10n.homeAddSale),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.homeRecentSales,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.salesHistory),
                  child: Text(l10n.homeSeeHistory),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<Box<SaleTransaction>>(
              valueListenable: Hive.box<SaleTransaction>(
                HiveBoxes.transactions,
              ).listenable(),
              builder: (context, box, _) {
                final items = box.values.toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                final recent = items.take(3).toList();
                if (recent.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.homeRecentEmpty,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final sale in recent) ...[
                      RecentItem(
                        title: sale.productName,
                        subtitle: relativeTime(l10n, sale.createdAt),
                        amount: sale.formatAmount(),
                      ),
                      if (sale != recent.last) const SizedBox(height: 8),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NotchedBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
        labels: [
          l10n.navSales,
          l10n.navReports,
          l10n.navProducts,
          l10n.navSettings,
        ],
      ),
    );
  }
}

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.index});

  final int index;

  String _title(AppLocalizations l10n) {
    switch (index) {
      case 1:
        return l10n.navReports;
      case 2:
        return l10n.navProducts;
      case 3:
        return l10n.navSettings;
      default:
        return l10n.comingSoonError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_title(l10n))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              l10n.comingSoonTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoonMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
