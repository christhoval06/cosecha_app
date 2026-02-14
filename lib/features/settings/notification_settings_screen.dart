import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/app_services.dart';
import '../../core/services/notifications/backup_reminder_notification_service.dart';
import '../../core/services/notifications/notification_service.dart';
import '../../core/services/notifications/reminder_destination_localizations.dart';
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
  String _tapDestinationId =
      BackupReminderNotificationService.availableTapDestinationIds.first;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await AppServices.backupReminders.isEnabled();
    final repeat = await AppServices.backupReminders.getFrequency();
    final tapDestinationId = await AppServices.backupReminders
        .getTapDestinationId();
    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _repeat = repeat;
      _tapDestinationId = tapDestinationId;
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
                          initialValue: _tapDestinationId,
                          decoration: InputDecoration(
                            labelText: l10n.settingsBackupReminderTapAction,
                            border: const OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: reminderDestinationItems(
                            l10n,
                            BackupReminderNotificationService
                                .availableTapDestinationIds,
                          ),
                          onChanged: _enabled
                              ? (value) async {
                                  if (value == null) return;
                                  setState(() => _tapDestinationId = value);
                                  await AppServices.backupReminders
                                      .setTapDestinationId(value);
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
                  const SizedBox(height: 12),
                  ValueListenableBuilder(
                    valueListenable: AppServices.userReminders.listenable(),
                    builder: (context, _, _) {
                      final remindersCount = AppServices.userReminders.count();
                      final max = AppConstants.remindersMaxCount;
                      final countLabel = '$remindersCount/$max';
                      final atLimit = remindersCount >= max;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.settingsRemindersTitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    countLabel,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.settingsRemindersCardSubtitle,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: atLimit
                                        ? null
                                        : () {
                                            Navigator.of(context).pushNamed(
                                              AppRoutes.notificationReminders,
                                              arguments: {
                                                'autoOpenCreate': true,
                                              },
                                            );
                                          },
                                    icon: const Icon(Icons.add_alarm_outlined),
                                    label: Text(l10n.settingsRemindersAdd),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.notificationReminders,
                                      );
                                    },
                                    child: Text(l10n.settingsRemindersViewAll),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
