import 'package:excel/excel.dart';
import 'package:hive/hive.dart';
import '../../core/utils/date_formatters.dart';
import '../models/product.dart';
import '../models/product_price_history.dart';
import '../models/sale_transaction.dart';
import 'boxes.dart';

class HiveExportModelIds {
  static const products = 'products';
  static const sales = 'sales';
  static const priceHistory = 'price_history';
}

class HiveExportFieldDef {
  const HiveExportFieldDef({
    required this.id,
    required this.toCell,
  });

  final String id;
  final CellValue Function(dynamic item) toCell;
}

class HiveExportModelDef {
  HiveExportModelDef({
    required this.id,
    required this.boxName,
    required this.sheetName,
    required this.fields,
    required this.rowsReader,
  });

  final String id;
  final String boxName;
  final String sheetName;
  final List<HiveExportFieldDef> fields;
  final List<dynamic> Function() rowsReader;
}

List<HiveExportModelDef> hiveExportSchema() {
  return [
    HiveExportModelDef(
      id: HiveExportModelIds.products,
      boxName: HiveBoxes.products,
      sheetName: 'Products',
      rowsReader: _productRows,
      fields: [
        HiveExportFieldDef(
          id: 'id',
          toCell: _productIdCell,
        ),
        HiveExportFieldDef(
          id: 'name',
          toCell: _productNameCell,
        ),
        HiveExportFieldDef(
          id: 'imageUrl',
          toCell: _productImageUrlCell,
        ),
        HiveExportFieldDef(
          id: 'currentPrice',
          toCell: _productCurrentPriceCell,
        ),
      ],
    ),
    HiveExportModelDef(
      id: HiveExportModelIds.sales,
      boxName: HiveBoxes.transactions,
      sheetName: 'Sales',
      rowsReader: _saleRows,
      fields: [
        HiveExportFieldDef(id: 'id', toCell: _saleIdCell),
        HiveExportFieldDef(id: 'productId', toCell: _saleProductIdCell),
        HiveExportFieldDef(id: 'productName', toCell: _saleProductNameCell),
        HiveExportFieldDef(id: 'amount', toCell: _saleAmountCell),
        HiveExportFieldDef(id: 'quantity', toCell: _saleQuantityCell),
        HiveExportFieldDef(id: 'channel', toCell: _saleChannelCell),
        HiveExportFieldDef(id: 'createdAt', toCell: _saleCreatedAtCell),
      ],
    ),
    HiveExportModelDef(
      id: HiveExportModelIds.priceHistory,
      boxName: HiveBoxes.productPriceHistory,
      sheetName: 'PriceHistory',
      rowsReader: _historyRows,
      fields: [
        HiveExportFieldDef(id: 'id', toCell: _historyIdCell),
        HiveExportFieldDef(id: 'productId', toCell: _historyProductIdCell),
        HiveExportFieldDef(id: 'price', toCell: _historyPriceCell),
        HiveExportFieldDef(id: 'recordedAt', toCell: _historyRecordedAtCell),
      ],
    ),
  ];
}

List<dynamic> _productRows() => Hive.box<Product>(HiveBoxes.products).values.toList();
List<dynamic> _saleRows() =>
    Hive.box<SaleTransaction>(HiveBoxes.transactions).values.toList();
List<dynamic> _historyRows() => Hive
    .box<ProductPriceHistory>(HiveBoxes.productPriceHistory)
    .values
    .toList();

CellValue _productIdCell(dynamic item) =>
    TextCellValue((item as Product).id);
CellValue _productNameCell(dynamic item) =>
    TextCellValue((item as Product).name);
CellValue _productImageUrlCell(dynamic item) =>
    TextCellValue((item as Product).imageUrl);
CellValue _productCurrentPriceCell(dynamic item) =>
    DoubleCellValue((item as Product).currentPrice);

CellValue _saleIdCell(dynamic item) =>
    TextCellValue((item as SaleTransaction).id);
CellValue _saleProductIdCell(dynamic item) =>
    TextCellValue((item as SaleTransaction).productId);
CellValue _saleProductNameCell(dynamic item) =>
    TextCellValue((item as SaleTransaction).productName);
CellValue _saleAmountCell(dynamic item) =>
    DoubleCellValue((item as SaleTransaction).amount);
CellValue _saleQuantityCell(dynamic item) =>
    IntCellValue((item as SaleTransaction).quantity);
CellValue _saleChannelCell(dynamic item) =>
    TextCellValue((item as SaleTransaction).channel);
CellValue _saleCreatedAtCell(dynamic item) =>
    TextCellValue(formatDateTimeYmdHm((item as SaleTransaction).createdAt));

CellValue _historyIdCell(dynamic item) =>
    TextCellValue((item as ProductPriceHistory).id);
CellValue _historyProductIdCell(dynamic item) =>
    TextCellValue((item as ProductPriceHistory).productId);
CellValue _historyPriceCell(dynamic item) =>
    DoubleCellValue((item as ProductPriceHistory).price);
CellValue _historyRecordedAtCell(dynamic item) =>
    TextCellValue(formatDateTimeYmdHm((item as ProductPriceHistory).recordedAt));
