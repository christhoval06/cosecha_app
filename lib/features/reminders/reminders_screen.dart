import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/app_services.dart';
import '../../data/models/reminder_item.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/reminder_card.dart';
import 'widgets/reminder_form_sheet.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key, this.autoOpenCreate = false});

  final bool autoOpenCreate;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _openedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_openedOnce || !widget.autoOpenCreate) return;
    _openedOnce = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsRemindersTitle)),
      body: ValueListenableBuilder(
        valueListenable: AppServices.userReminders.listenable(),
        builder: (context, _, _) {
          final reminders = AppServices.userReminders.getAll();
          final countLabel =
              '${reminders.length}/${AppConstants.remindersMaxCount}';

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _RemindersCounterCard(countLabel: countLabel),
              const SizedBox(height: 16),
              if (reminders.isEmpty)
                Text(
                  l10n.settingsRemindersEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                )
              else
                ...reminders.map(
                  (item) => ReminderCard(
                    item: item,
                    onEdit: () => _openForm(existing: item),
                    onDelete: () => _deleteReminder(item),
                    onToggle: (value) async {
                      await AppServices.userReminders.setEnabled(
                        item.id,
                        value,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: AppServices.userReminders.listenable(),
        builder: (context, _, _) {
          final count = AppServices.userReminders.count();
          return FloatingActionButton.extended(
            onPressed: count >= AppConstants.remindersMaxCount
                ? null
                : () => _openForm(),
            icon: const Icon(Icons.add_alarm_outlined),
            label: Text(AppLocalizations.of(context).settingsRemindersAdd),
          );
        },
      ),
    );
  }

  Future<void> _deleteReminder(ReminderItem item) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.settingsRemindersDeleteTitle),
          content: Text(l10n.settingsRemindersDeleteBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.settingsRemindersDeleteAction),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    await AppServices.userReminders.delete(item.id);
  }

  Future<void> _openForm({ReminderItem? existing}) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return ReminderFormSheet(existing: existing);
        },
      );
    } on StateError catch (error) {
      if (!mounted) return;
      if (error.message == 'reminder_limit_reached') {
        messenger.showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsRemindersLimit),
          ),
        );
      }
    }
  }
}

class _RemindersCounterCard extends StatelessWidget {
  const _RemindersCounterCard({required this.countLabel});

  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.settingsRemindersCounterTitle,
                      style: Theme.of(context).textTheme.titleSmall,
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
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.settingsRemindersCounterSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
