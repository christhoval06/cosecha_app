import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/services/app_services.dart';
import '../../core/services/notifications/notification_service.dart';
import '../../l10n/app_localizations.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _loading = true;
  bool _enabled = true;
  AppNotificationRepeat _repeat = AppNotificationRepeat.weekly;
  String _tapRoute = AppRoutes.dataBackup;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await AppServices.backupReminders.isEnabled();
    final repeat = await AppServices.backupReminders.getFrequency();
    final tapRoute = await AppServices.backupReminders.getTapRoute();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _repeat = repeat;
      _tapRoute = tapRoute;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSectionNotifications)),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsBackupReminderTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.settingsBackupReminderSubtitle,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.settingsBackupReminderEnabled),
                          value: _enabled,
                          onChanged: (value) async {
                            setState(() => _enabled = value);
                            await AppServices.backupReminders.setEnabled(value);
                          },
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<AppNotificationRepeat>(
                          initialValue: _repeat,
                          decoration: InputDecoration(
                            labelText: l10n.settingsBackupReminderFrequency,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: AppNotificationRepeat.daily,
                              child: Text(
                                l10n.settingsBackupReminderFrequencyDaily,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppNotificationRepeat.weekly,
                              child: Text(
                                l10n.settingsBackupReminderFrequencyWeekly,
                              ),
                            ),
                          ],
                          onChanged: _enabled
                              ? (value) async {
                                  if (value == null) return;
                                  setState(() => _repeat = value);
                                  await AppServices.backupReminders
                                      .setFrequency(value);
                                }
                              : null,
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _tapRoute,
                          decoration: InputDecoration(
                            labelText: l10n.settingsBackupReminderTapAction,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: AppRoutes.dataBackup,
                              child: Text(
                                l10n.settingsBackupReminderTapOpenDataBackup,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppRoutes.settings,
                              child: Text(
                                l10n.settingsBackupReminderTapOpenSettings,
                              ),
                            ),
                            DropdownMenuItem(
                              value: AppRoutes.notificationSettings,
                              child: Text(
                                l10n.settingsBackupReminderTapOpenNotificationSettings,
                              ),
                            ),
                          ],
                          onChanged: _enabled
                              ? (value) async {
                                  if (value == null) return;
                                  setState(() => _tapRoute = value);
                                  await AppServices.backupReminders.setTapRoute(
                                    value,
                                  );
                                }
                              : null,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await AppServices.backupReminders
                                    .sendTestNotification();
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.settingsBackupReminderTestSent,
                                    ),
                                  ),
                                );
                              } on StateError catch (error) {
                                if (!mounted) return;
                                final message =
                                    error.message ==
                                        'notification_permission_denied'
                                    ? l10n.settingsBackupReminderPermissionDenied
                                    : l10n.settingsBackupReminderTestError;
                                messenger.showSnackBar(
                                  SnackBar(content: Text(message)),
                                );
                              } catch (error) {
                                if (!mounted) return;
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${l10n.settingsBackupReminderTestError}: $error',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.notifications_active_outlined,
                            ),
                            label: Text(l10n.settingsBackupReminderTest),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
