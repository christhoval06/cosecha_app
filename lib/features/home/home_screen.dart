import 'dart:io';

import 'package:cosecha_app/core/widgets/notched_bottom_nav.dart';
import 'package:cosecha_app/data/repositories/business_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cosecha_app/l10n/app_localizations.dart';

import 'package:cosecha_app/data/models/business.dart';
import 'package:cosecha_app/core/constants/app_routes.dart';
import '../../core/premium/premium_features.dart';
import '../../core/premium/premium_guard.dart';
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
  late final ScrollController _scrollController;
  HomeDashboardConfig? _homeLayout;
  bool _loadingHomeLayout = true;
  bool _isHeaderCollapsed = false;

  @override
  void initState() {
    super.initState();
    _homeConfigStore = HomeDashboardConfigStore();
    _homeRegistry = homeDashboardRegistry();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadHomeLayout();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const collapseOffset = 72.0;
    final collapsed =
        _scrollController.hasClients &&
        _scrollController.offset > collapseOffset;
    if (collapsed == _isHeaderCollapsed) return;
    setState(() => _isHeaderCollapsed = collapsed);
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

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 128,
            title: AnimatedOpacity(
              opacity: _isHeaderCollapsed ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              child: _buildCollapsedTitle(l10n),
            ),
            titleSpacing: 8,
            actions: [
              IconButton(
                onPressed: _homeLayout == null
                    ? null
                    : () async {
                        final canUse = await guardPremiumAccess(
                          context,
                          feature: PremiumFeature.homeDashboardCustomization,
                        );
                        if (!canUse) return;
                        await _openCustomize();
                      },
                icon: const Icon(Icons.tune),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    kToolbarHeight + 8,
                    20,
                    12,
                  ),
                  child: _buildHeader(context, l10n),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            sliver: SliverToBoxAdapter(
              child: _loadingHomeLayout
                  ? const Center(child: CircularProgressIndicator())
                  : Column(children: _buildDashboardWidgets(l10n)),
            ),
          ),
        ],
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

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return ValueListenableBuilder<Box<Business>>(
      valueListenable: BusinessRepository().listenable(),
      builder: (context, box, _) {
        final business = box.get(BusinessRepository.currentKey);
        final logoPath = business?.logoPath?.trim() ?? '';
        final hasValidLogo = logoPath.isNotEmpty && File(logoPath).existsSync();
        return Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage: hasValidLogo ? FileImage(File(logoPath)) : null,
              child: !hasValidLogo
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
          ],
        );
      },
    );
  }

  Widget _buildCollapsedTitle(AppLocalizations l10n) {
    return ValueListenableBuilder<Box<Business>>(
      valueListenable: BusinessRepository().listenable(),
      builder: (context, box, _) {
        final business = box.get(BusinessRepository.currentKey);
        final logoPath = business?.logoPath?.trim() ?? '';
        final hasValidLogo = logoPath.isNotEmpty && File(logoPath).existsSync();
        final colorScheme = Theme.of(context).colorScheme;
        return Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colorScheme.primaryContainer,
              backgroundImage: hasValidLogo ? FileImage(File(logoPath)) : null,
              child: !hasValidLogo
                  ? const Icon(Icons.storefront, size: 14)
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                business?.name ?? l10n.homeTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
