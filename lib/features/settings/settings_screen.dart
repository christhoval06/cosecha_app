import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_routes.dart';
import '../../core/premium/premium_access.dart';
import '../../core/premium/premium_features.dart';
import '../../core/premium/premium_guard.dart';
import '../../core/services/app_reset_service.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/settings_brand_header.dart';
import 'widgets/settings_section_title.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final info = snapshot.data;
                final version = info == null
                    ? l10n.settingsAppVersion
                    : '${info.version} (${info.buildNumber})';
                return SettingsBrandHeader(
                  title: l10n.settingsAppName,
                  subtitle: l10n.settingsAppTagline,
                  version: version,
                );
              },
            ),
            const SizedBox(height: 28),
            SettingsSectionTitle(text: l10n.settingsSectionGeneral),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: PremiumAccess.instance.listenable,
              builder: (context, isPremium, _) {
                return SettingsTile(
                  icon: isPremium
                      ? Icons.workspace_premium
                      : Icons.workspace_premium_outlined,
                  iconBg: colorScheme.tertiaryContainer,
                  iconColor: colorScheme.onTertiaryContainer,
                  title: isPremium ? 'Plan Premium activo' : 'Volverse Premium',
                  subtitle: isPremium
                      ? 'Ya tienes todas las funciones premium desbloqueadas.'
                      : 'Desbloquea ajustes avanzados, widgets premium y exportación Excel.',
                  onTap: () async {
                    if (isPremium) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tu cuenta ya es Premium.'),
                        ),
                      );
                      return;
                    }
                    await showPremiumUpsellModal(
                      context,
                      feature: PremiumFeature.homeDashboardCustomization,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.storefront_outlined,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsBusinessTitle,
              subtitle: l10n.settingsBusinessSubtitle,
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.profileSetup, arguments: true),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.cloud_sync_outlined,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsBackupTitle,
              subtitle: l10n.settingsBackupSubtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.dataBackup),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.notifications_outlined,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsSectionNotifications,
              subtitle: l10n.settingsBackupReminderSubtitle,
              onTap: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.notificationSettings),
            ),
            const SizedBox(height: 24),
            SettingsSectionTitle(text: l10n.settingsSectionAbout),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.menu_book_outlined,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsOriginTitle,
              subtitle: _storyPreview(l10n.settingsOriginBody),
              onTap: () => _showOurStorySheet(context, l10n),
            ),
            const SizedBox(height: 16),
            SettingsTile(
              icon: Icons.code,
              iconBg: colorScheme.tertiaryContainer,
              iconColor: colorScheme.onTertiaryContainer,
              title: l10n.settingsDeveloperTitle,
              subtitle: l10n.settingsDeveloperSubtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.developer),
            ),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.mail_outline,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsSupportTitle,
              subtitle: l10n.settingsSupportSubtitle,
              onTap: () async {
                final uri = Uri(
                  scheme: 'mailto',
                  path: l10n.supportEmail,
                  queryParameters: {
                    'subject': l10n.supportSubject,
                    'body': l10n.supportBody,
                  },
                );
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
            ),
            const SizedBox(height: 24),
            SettingsSectionTitle(text: l10n.settingsSectionDanger),
            const SizedBox(height: 12),
            SettingsTile(
              icon: Icons.delete_forever_outlined,
              iconBg: colorScheme.errorContainer,
              iconColor: colorScheme.onErrorContainer,
              title: l10n.settingsResetTitle,
              subtitle: l10n.settingsResetSubtitle,
              titleColor: colorScheme.error,
              onTap: () => _resetApp(context, l10n),
            ),
          ],
        ),
      ),
    );
  }
}

String _storyPreview(String body) {
  final normalized = body.replaceAll('\n', ' ').trim();
  if (normalized.length <= 72) return normalized;
  return '${normalized.substring(0, 72).trim()}...';
}

class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _resetApp(BuildContext context, AppLocalizations l10n) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.settingsResetConfirmTitle),
        content: Text(l10n.settingsResetConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
  if (confirmed != true) return;

  await AppResetService.resetAll();

  if (context.mounted) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppResetService.initialRouteAfterReset(),
      (_) => false,
    );
  }
}

Future<void> _showOurStorySheet(
  BuildContext context,
  AppLocalizations l10n,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.settingsOriginTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                    child: Text(
                      l10n.settingsOriginBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.78),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
