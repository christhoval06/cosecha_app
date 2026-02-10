import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/hive/boxes.dart';
import '../../data/models/product.dart';
import '../../data/models/product_price_history.dart';
import '../../data/models/sale_transaction.dart';
import '../utils/date_formatters.dart';

class ExcelExportService {
  ExcelExportService._();

  static const modelProducts = 'products';
  static const modelSales = 'sales';
  static const modelPriceHistory = 'price_history';

  static const List<String> models = [
    modelProducts,
    modelSales,
    modelPriceHistory,
  ];

  static const Map<String, List<String>> modelFields = {
    modelProducts: ['id', 'name', 'imageUrl', 'currentPrice'],
    modelSales: [
      'id',
      'productId',
      'productName',
      'amount',
      'quantity',
      'channel',
      'createdAt',
    ],
    modelPriceHistory: ['id', 'productId', 'price', 'recordedAt'],
  };

  static const _prefsKey = 'excel_export_config_v1';

  static Future<ExcelExportConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
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
    await prefs.setString(_prefsKey, jsonEncode(config.sanitize().toJson()));
  }

  static Future<String> exportToExcel({
    ExcelExportConfig? config,
  }) async {
    final effectiveConfig = (config ?? await loadConfig()).sanitize();
    final excel = Excel.createExcel();

    if (effectiveConfig.enabledModels.contains(modelProducts)) {
      final selectedFields = effectiveConfig.fieldsFor(modelProducts);
      final sheet = excel['Products'];
      sheet.appendRow(selectedFields.map(TextCellValue.new).toList());

      final products = Hive.box<Product>(HiveBoxes.products).values.toList();
      for (final product in products) {
        sheet.appendRow([
          for (final field in selectedFields) _productCell(field, product),
        ]);
      }
    }

    if (effectiveConfig.enabledModels.contains(modelSales)) {
      final selectedFields = effectiveConfig.fieldsFor(modelSales);
      final sheet = excel['Sales'];
      sheet.appendRow(selectedFields.map(TextCellValue.new).toList());

      final sales = Hive.box<SaleTransaction>(HiveBoxes.transactions).values.toList();
      for (final sale in sales) {
        sheet.appendRow([
          for (final field in selectedFields) _saleCell(field, sale),
        ]);
      }
    }

    if (effectiveConfig.enabledModels.contains(modelPriceHistory)) {
      final selectedFields = effectiveConfig.fieldsFor(modelPriceHistory);
      final sheet = excel['PriceHistory'];
      sheet.appendRow(selectedFields.map(TextCellValue.new).toList());

      final history =
          Hive.box<ProductPriceHistory>(HiveBoxes.productPriceHistory).values.toList();
      for (final item in history) {
        sheet.appendRow([
          for (final field in selectedFields) _priceHistoryCell(field, item),
        ]);
      }
    }

    final appDir = await getApplicationDocumentsDirectory();
    final file = File(
      '${appDir.path}/cosecha_export_${DateTime.now().millisecondsSinceEpoch}.xlsx',
    );
    file.createSync(recursive: true);
    file.writeAsBytesSync(excel.encode()!);
    return file.path;
  }

  static CellValue _productCell(String field, Product product) {
    switch (field) {
      case 'id':
        return TextCellValue(product.id);
      case 'name':
        return TextCellValue(product.name);
      case 'imageUrl':
        return TextCellValue(product.imageUrl);
      case 'currentPrice':
        return DoubleCellValue(product.currentPrice);
      default:
        return TextCellValue('');
    }
  }

  static CellValue _saleCell(String field, SaleTransaction sale) {
    switch (field) {
      case 'id':
        return TextCellValue(sale.id);
      case 'productId':
        return TextCellValue(sale.productId);
      case 'productName':
        return TextCellValue(sale.productName);
      case 'amount':
        return DoubleCellValue(sale.amount);
      case 'quantity':
        return IntCellValue(sale.quantity);
      case 'channel':
        return TextCellValue(sale.channel);
      case 'createdAt':
        return TextCellValue(formatDateTimeYmdHm(sale.createdAt));
      default:
        return TextCellValue('');
    }
  }

  static CellValue _priceHistoryCell(String field, ProductPriceHistory item) {
    switch (field) {
      case 'id':
        return TextCellValue(item.id);
      case 'productId':
        return TextCellValue(item.productId);
      case 'price':
        return DoubleCellValue(item.price);
      case 'recordedAt':
        return TextCellValue(formatDateTimeYmdHm(item.recordedAt));
      default:
        return TextCellValue('');
    }
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
