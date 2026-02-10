import 'dart:io';

import 'package:cosecha_app/core/widgets/notched_bottom_nav.dart';
import 'package:cosecha_app/data/repositories/business_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';

import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/core/services/business_session.dart';
import 'package:cosecha_app/core/constants/app_routes.dart';
import 'dashboard/home_dashboard_config.dart';
import 'dashboard/home_dashboard_customize_sheet.dart';
import 'dashboard/home_dashboard_registry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final HomeDashboardConfigStore _homeConfigStore;
  late final List<HomeDashboardWidgetDef> _homeRegistry;
  HomeDashboardConfig? _homeLayout;
  bool _loadingHomeLayout = true;

  @override
  void initState() {
    super.initState();
    _homeConfigStore = HomeDashboardConfigStore();
    _homeRegistry = homeDashboardRegistry();
    _loadHomeLayout();
  }

  void _onTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) return;
    if (index == 2) {
      Navigator.of(context)
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

  Future<void> _loadHomeLayout() async {
    final defaults = _homeRegistry.map((item) => item.id).toList();
    final loaded = await _homeConfigStore.load(defaults);
    if (!mounted) return;
    setState(() {
      _homeLayout = loaded;
      _loadingHomeLayout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final business = BusinessSession.instance.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(business?.name ?? l10n.homeTitle),
        actions: [
          IconButton(
            onPressed: _homeLayout == null ? null : _openCustomize,
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildHeader(context, l10n, colorScheme),
            const SizedBox(height: 24),
            if (_loadingHomeLayout)
              const Center(child: CircularProgressIndicator())
            else
              ..._buildDashboardWidgets(l10n),
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

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
  ) {
    return ValueListenableBuilder<Box<Business>>(
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
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
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
    );
  }

  List<Widget> _buildDashboardWidgets(AppLocalizations l10n) {
    final layout = _homeLayout;
    if (layout == null) return const [SizedBox.shrink()];

    final defsById = {for (final def in _homeRegistry) def.id: def};

    final widgets = <Widget>[];
    for (final id in layout.orderedWidgetIds) {
      if (!layout.enabledWidgetIds.contains(id)) continue;
      final def = defsById[id];
      if (def == null) continue;
      widgets.add(def.builder(context));
      widgets.add(const SizedBox(height: 24));
    }
    if (widgets.isNotEmpty) widgets.removeLast();
    return widgets;
  }

  Future<void> _openCustomize() async {
    final layout = _homeLayout;
    if (layout == null) return;
    final updated = await showHomeDashboardCustomizeSheet(
      context: context,
      current: layout,
      definitions: _homeRegistry,
    );
    if (updated == null) return;
    await _homeConfigStore.save(updated);
    if (!mounted) return;
    setState(() => _homeLayout = updated);
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
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
