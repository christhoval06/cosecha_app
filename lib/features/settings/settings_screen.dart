import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/app_reset_service.dart';

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
                return _BrandHeader(
                  title: l10n.settingsAppName,
                  subtitle: l10n.settingsAppTagline,
                  version: version,
                );
              },
            ),
            const SizedBox(height: 28),
            _SectionTitle(text: l10n.settingsSectionGeneral),
            const SizedBox(height: 12),
            _SettingsTile(
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
            _SettingsTile(
              icon: Icons.cloud_sync_outlined,
              iconBg: colorScheme.primaryContainer,
              iconColor: colorScheme.onPrimaryContainer,
              title: l10n.settingsBackupTitle,
              subtitle: l10n.settingsBackupSubtitle,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.dataBackup),
            ),
            const SizedBox(height: 24),
            _SectionTitle(text: l10n.settingsSectionAbout),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.code,
              iconBg: colorScheme.tertiaryContainer,
              iconColor: colorScheme.onTertiaryContainer,
              title: l10n.settingsDeveloperTitle,
              subtitle: l10n.settingsDeveloperSubtitle,
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.developer),
            ),
            const SizedBox(height: 12),
            _SettingsTile(
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
            _SectionTitle(text: l10n.settingsSectionDanger),
            const SizedBox(height: 12),
            _SettingsTile(
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

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({
    required this.title,
    required this.subtitle,
    required this.version,
  });

  final String title;
  final String subtitle;
  final String version;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(Icons.eco_outlined, color: colorScheme.primary, size: 40),
        ),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          version,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        letterSpacing: 1.6,
        color: colorScheme.onSurface.withOpacity(0.5),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    this.titleColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color? titleColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: titleColor ?? colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurface.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
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
                  color: colorScheme.onSurface.withOpacity(0.7),
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
