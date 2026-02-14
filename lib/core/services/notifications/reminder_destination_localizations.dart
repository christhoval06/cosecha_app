import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import 'reminder_destinations.dart';

String reminderDestinationLabel(AppLocalizations l10n, String? destinationId) {
  if (destinationId == null) {
    return l10n.settingsRemindersNoDestination;
  }

  return switch (destinationId) {
    ReminderDestinations.newProduct =>
      l10n.settingsReminderDestinationNewProduct,
    ReminderDestinations.newSale => l10n.settingsReminderDestinationNewSale,
    ReminderDestinations.reports => l10n.settingsReminderDestinationReports,
    ReminderDestinations.salesHistory =>
      l10n.settingsReminderDestinationSalesHistory,
    ReminderDestinations.profile => l10n.settingsReminderDestinationProfile,
    ReminderDestinations.performanceToday =>
      l10n.settingsReminderDestinationPerformanceToday,
    ReminderDestinations.performanceWeek =>
      l10n.settingsReminderDestinationPerformanceWeek,
    ReminderDestinations.performanceMonth =>
      l10n.settingsReminderDestinationPerformanceMonth,
    ReminderDestinations.dataBackup =>
      l10n.settingsBackupReminderTapOpenDataBackup,
    ReminderDestinations.settings => l10n.settingsBackupReminderTapOpenSettings,
    ReminderDestinations.notificationSettings =>
      l10n.settingsBackupReminderTapOpenNotificationSettings,
    ReminderDestinations.notificationReminders => l10n.settingsRemindersTitle,
    _ => l10n.settingsRemindersNoDestination,
  };
}

List<DropdownMenuItem<String>> reminderDestinationItems(
  AppLocalizations l10n,
  List<String> destinationIds,
) {
  return destinationIds
      .where((id) => ReminderDestinations.specs.containsKey(id))
      .map((id) {
        return DropdownMenuItem<String>(
          value: id,
          child: Text(reminderDestinationLabel(l10n, id)),
        );
      })
      .toList();
}
