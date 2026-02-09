import 'package:cosecha_app/l10n/app_localizations.dart';

String relativeTime(AppLocalizations l10n, DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  if (date.isAfter(today)) {
    final hours = now.difference(date).inHours;
    return l10n.homeHoursAgo(hours == 0 ? 1 : hours);
  }
  final day = DateTime(date.year, date.month, date.day);
  if (day == yesterday) return l10n.homeYesterday;
  return '${date.day}/${date.month}/${date.year}';
}
