import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_prefs.dart';
import '../../data/hive/hive_export_schema.dart';

class ExcelExportService {
  ExcelExportService._();

  static const modelProducts = HiveExportModelIds.products;
  static const modelSales = HiveExportModelIds.sales;
  static const modelPriceHistory = HiveExportModelIds.priceHistory;

  static final List<HiveExportModelDef> _schema = hiveExportSchema();

  static List<String> get models =>
      _schema.map((model) => model.id).toList(growable: false);

  static Map<String, List<String>> get modelFields => {
        for (final model in _schema)
          model.id: model.fields.map((field) => field.id).toList(growable: false),
      };

  static Future<ExcelExportConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppPrefs.excelExportConfig);
    if (raw == null || raw.isEmpty) return ExcelExportConfig.all();
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return ExcelExportConfig.fromJson(decoded).sanitize();
    } catch (_) {
      return ExcelExportConfig.all();
    }
  }

  static Future<void> saveConfig(ExcelExportConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      AppPrefs.excelExportConfig,
      jsonEncode(config.sanitize().toJson()),
    );
  }

  static Future<String> exportToExcel({
    ExcelExportConfig? config,
  }) async {
    final effectiveConfig = (config ?? await loadConfig()).sanitize();
    final excel = Excel.createExcel();
    final errors = <String>[];
    var exportedSheets = 0;

    for (final model in _schema) {
      if (!effectiveConfig.enabledModels.contains(model.id)) continue;
      final selectedFields = effectiveConfig.fieldsFor(model.id);
      if (selectedFields.isEmpty) continue;

      try {
        if (!Hive.isBoxOpen(model.boxName)) {
          errors.add('${model.id}: box_not_open');
          continue;
        }

        final sheet = excel[model.sheetName];
        sheet.appendRow(selectedFields.map(TextCellValue.new).toList());

        final fieldDefs = {
          for (final field in model.fields) field.id: field,
        };
        final rows = model.rowsReader();
        var modelHasError = false;
        for (final row in rows) {
          try {
            sheet.appendRow([
              for (final fieldId in selectedFields)
                (fieldDefs[fieldId]?.toCell(row) ?? TextCellValue('')),
            ]);
          } catch (error) {
            modelHasError = true;
            errors.add('${model.id}: row_map_failed: $error');
          }
        }

        if (!modelHasError) {
          exportedSheets++;
        }
      } catch (error) {
        errors.add('${model.id}: $error');
      }
    }

    if (exportedSheets == 0) {
      final reason = errors.isEmpty ? 'no_models_selected' : errors.join(' | ');
      throw StateError('Excel export failed: $reason');
    }
    if (errors.isNotEmpty) {
      throw StateError('Excel export failed: ${errors.join(' | ')}');
    }

    final appDir = await getApplicationDocumentsDirectory();
    final file = File(
      '${appDir.path}/cosecha_export_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );
    file.createSync(recursive: true);
    file.writeAsBytesSync(excel.encode()!);
    return file.path;
  }
}

class ExcelExportConfig {
  const ExcelExportConfig({
    required this.enabledModels,
    required this.enabledFieldsByModel,
  });

  final Set<String> enabledModels;
  final Map<String, Set<String>> enabledFieldsByModel;

  factory ExcelExportConfig.all() {
    return ExcelExportConfig(
      enabledModels: ExcelExportService.models.toSet(),
      enabledFieldsByModel: {
        for (final model in ExcelExportService.models)
          model: ExcelExportService.modelFields[model]!.toSet(),
      },
    );
  }

  ExcelExportConfig sanitize() {
    final sanitizedModels = <String>{};
    final sanitizedFields = <String, Set<String>>{};

    for (final model in ExcelExportService.models) {
      final available = ExcelExportService.modelFields[model]!.toSet();
      final selected = (enabledFieldsByModel[model] ?? available).intersection(available);
      final fields = selected.isEmpty ? available : selected;
      sanitizedFields[model] = fields;
      if (enabledModels.contains(model)) {
        sanitizedModels.add(model);
      }
    }

    if (sanitizedModels.isEmpty) {
      sanitizedModels.addAll(ExcelExportService.models);
    }

    return ExcelExportConfig(
      enabledModels: sanitizedModels,
      enabledFieldsByModel: sanitizedFields,
    );
  }

  List<String> fieldsFor(String model) {
    final ordered = ExcelExportService.modelFields[model] ?? const <String>[];
    final selected = enabledFieldsByModel[model] ?? ordered.toSet();
    return ordered.where(selected.contains).toList();
  }

  ExcelExportConfig copyWith({
    Set<String>? enabledModels,
    Map<String, Set<String>>? enabledFieldsByModel,
  }) {
    return ExcelExportConfig(
      enabledModels: enabledModels ?? this.enabledModels,
      enabledFieldsByModel: enabledFieldsByModel ?? this.enabledFieldsByModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabledModels': enabledModels.toList(),
      'enabledFieldsByModel': {
        for (final entry in enabledFieldsByModel.entries)
          entry.key: entry.value.toList(),
      },
    };
  }

  factory ExcelExportConfig.fromJson(Map<String, dynamic> json) {
    final models = (json['enabledModels'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toSet();
    final fieldsRaw =
        (json['enabledFieldsByModel'] as Map<String, dynamic>? ?? const {});
    final fields = <String, Set<String>>{};
    for (final entry in fieldsRaw.entries) {
      final values = (entry.value as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toSet();
      fields[entry.key] = values;
    }
    return ExcelExportConfig(
      enabledModels: models,
      enabledFieldsByModel: fields,
    );
  }
}
