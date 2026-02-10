import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/services/backup_service.dart';
import '../../core/services/excel_export_service.dart';
import '../../core/widgets/excel_export_config_sheet.dart';
import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import '../../l10n/app_localizations.dart';

class DataBackupScreen extends StatelessWidget {
  const DataBackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dataBackupTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l10n.dataBackupSummaryTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              title: l10n.dataBackupProducts,
              valueListenable:
                  Hive.box<Product>(HiveBoxes.products).listenable(),
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              title: l10n.dataBackupSales,
              valueListenable:
                  Hive.box<SaleTransaction>(HiveBoxes.transactions)
                      .listenable(),
            ),
            const SizedBox(height: 12),
            _SummaryCard(
              title: l10n.dataBackupPriceHistory,
              valueListenable: Hive
                  .box<ProductPriceHistory>(HiveBoxes.productPriceHistory)
                  .listenable(),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.dataBackupActionsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  _exportExcel(context, l10n);
                },
                icon: const Icon(Icons.table_view),
                label: Text(l10n.dataBackupExportExcel),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _configureExcelExport(context);
                },
                icon: const Icon(Icons.tune),
                label: Text(l10n.dataBackupExportConfig),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                ),
                onPressed: () {
                  _exportEncrypted(context, l10n);
                },
                icon: const Icon(Icons.lock_outline),
                label: Text(l10n.dataBackupExportEncrypted),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _restoreBackup(context, l10n);
                },
                icon: const Icon(Icons.restore),
                label: Text(l10n.dataBackupRestore),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.valueListenable,
  });

  final String title;
  final ValueListenable<Box> valueListenable;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;
    return ValueListenableBuilder<Box>(
      valueListenable: valueListenable,
      builder: (context, box, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(title, style: Theme.of(context).textTheme.titleSmall),
              ),
              Text(
                box.length.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _exportExcel(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final result = await _withLoader(
    context,
    l10n.dataBackupExporting,
    () async {
      final config = await ExcelExportService.loadConfig();
      return ExcelExportService.exportToExcel(config: config);
    },
  );
  if (result == null || !context.mounted) return;
  final path = result;
  await Share.shareXFiles(
    [XFile(path)],
    sharePositionOrigin: _shareOrigin(context),
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${l10n.dataBackupExported}: $path')),
    );
  }
}

Future<void> _configureExcelExport(BuildContext context) async {
  final current = await ExcelExportService.loadConfig();
  if (!context.mounted) return;
  final updated = await showExcelExportConfigSheet(
    context: context,
    current: current,
  );
  if (updated == null) return;
  await ExcelExportService.saveConfig(updated);
}

Future<void> _exportEncrypted(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final password = await _askPassword(context, l10n);
  if (!context.mounted) return;
  if (password == null || password.isEmpty) return;
  final result = await _withLoader(
    context,
    l10n.dataBackupEncrypting,
    () => BackupService.exportEncryptedBackup(password),
  );
  if (result == null || !context.mounted) return;
  final path = result;
  await Share.shareXFiles(
    [XFile(path)],
    sharePositionOrigin: _shareOrigin(context),
  );
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${l10n.dataBackupEncryptedExported}: $path')),
    );
  }
}

Future<void> _restoreBackup(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );
  if (!context.mounted) return;
  if (result == null || result.files.single.path == null) return;

  final confirmed = await _confirmRestore(context, l10n);
  if (!context.mounted) return;
  if (!confirmed) return;

  final password = await _askPassword(context, l10n);
  if (!context.mounted) return;
  if (password == null || password.isEmpty) return;

  final file = File(result.files.single.path!);
  try {
    await _withLoader(
      context,
      l10n.dataBackupRestoring,
      () => BackupService.restoreEncryptedBackup(
        file: file,
        password: password,
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dataBackupRestoreSuccess)),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.dataBackupRestoreError)),
      );
    }
  }
}

Future<T?> _withLoader<T>(
  BuildContext context,
  String message,
  Future<T> Function() task,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );
  try {
    final result = await task();
    if (context.mounted) Navigator.of(context).pop();
    return result;
  } catch (_) {
    if (context.mounted) Navigator.of(context).pop();
    rethrow;
  }
}

Future<bool> _confirmRestore(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.dataBackupRestoreConfirmTitle),
        content: Text(l10n.dataBackupRestoreConfirmBody),
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
  return result ?? false;
}

Future<String?> _askPassword(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.dataBackupPasswordTitle),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: l10n.dataBackupPasswordLabel,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
}

Rect _shareOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null) return Rect.zero;
  final origin = box.localToGlobal(Offset.zero) & box.size;
  return origin;
}
