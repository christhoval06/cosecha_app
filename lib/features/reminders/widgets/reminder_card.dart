import 'package:flutter/material.dart';

import '../../../core/services/notifications/reminder_destination_localizations.dart';
import '../../../data/models/reminder_item.dart';
import '../../../l10n/app_localizations.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final ReminderItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Switch.adaptive(value: item.enabled, onChanged: onToggle),
            ],
          ),
          if (item.description.trim().isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.74),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                text: '${_formatTime(item)} · ${_daysLabel(l10n, item)}',
              ),
              _InfoPill(text: item.label),
              _InfoPill(
                text: reminderDestinationLabel(l10n, item.destinationId),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.settingsRemindersEditAction),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.settingsRemindersDeleteAction),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(ReminderItem item) {
    final hour = item.hour.toString().padLeft(2, '0');
    final minute = item.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _daysLabel(AppLocalizations l10n, ReminderItem item) {
    final labels = <int, String>{
      DateTime.sunday: l10n.settingsWeekdaySunShort,
      DateTime.monday: l10n.settingsWeekdayMonShort,
      DateTime.tuesday: l10n.settingsWeekdayTueShort,
      DateTime.wednesday: l10n.settingsWeekdayWedShort,
      DateTime.thursday: l10n.settingsWeekdayThuShort,
      DateTime.friday: l10n.settingsWeekdayFriShort,
      DateTime.saturday: l10n.settingsWeekdaySatShort,
    };

    return item.weekdays.map((day) => labels[day] ?? '?').join(', ');
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
