enum PremiumFeature {
  homeDashboardCustomization,
  reportsDashboardCustomization,
  productSuggestedPrice,
  productPriceImpact,
  productPricePerformance,
  productRecentHistory,
  excelExport,
}

class PremiumFeatureInfo {
  const PremiumFeatureInfo({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class PremiumFeatures {
  PremiumFeatures._();

  static const Map<PremiumFeature, PremiumFeatureInfo> _catalog = {
    PremiumFeature.homeDashboardCustomization: PremiumFeatureInfo(
      title: 'Ajuste de Home',
      description: 'Personaliza el dashboard del inicio.',
    ),
    PremiumFeature.reportsDashboardCustomization: PremiumFeatureInfo(
      title: 'Ajuste de Reportes',
      description: 'Configura y ordena widgets del dashboard de reportes.',
    ),
    PremiumFeature.productSuggestedPrice: PremiumFeatureInfo(
      title: 'Precio sugerido',
      description: 'Recibe recomendaciones de precio basadas en ventas.',
    ),
    PremiumFeature.productPriceImpact: PremiumFeatureInfo(
      title: 'Impacto del cambio',
      description: 'Visualiza el impacto de cambiar el precio actual.',
    ),
    PremiumFeature.productPricePerformance: PremiumFeatureInfo(
      title: 'Rendimiento del precio',
      description: 'Analiza tendencia y variaciones de precio.',
    ),
    PremiumFeature.productRecentHistory: PremiumFeatureInfo(
      title: 'Historial recientes',
      description: 'Consulta movimientos recientes de precios.',
    ),
    PremiumFeature.excelExport: PremiumFeatureInfo(
      title: 'Exportar a Excel',
      description: 'Exporta datos y reportes a archivos .xlsx.',
    ),
  };

  static PremiumFeatureInfo info(PremiumFeature feature) => _catalog[feature]!;

  static List<PremiumFeatureInfo> get all =>
      _catalog.values.toList(growable: false);
}
