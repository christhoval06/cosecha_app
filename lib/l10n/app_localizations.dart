import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Cosecha'**
  String get appTitle;

  /// No description provided for @errorTitle.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @backButton.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get backButton;

  /// No description provided for @invalidProductMessage.
  ///
  /// In es, this message translates to:
  /// **'El producto no es válido.'**
  String get invalidProductMessage;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get homeTitle;

  /// No description provided for @counterMessage.
  ///
  /// In es, this message translates to:
  /// **'Has presionado el botón esta cantidad de veces:'**
  String get counterMessage;

  /// No description provided for @counterIncrementTooltip.
  ///
  /// In es, this message translates to:
  /// **'Incrementar'**
  String get counterIncrementTooltip;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In es, this message translates to:
  /// **'Registra tus ventas'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Description.
  ///
  /// In es, this message translates to:
  /// **'Anota cada venta de forma rápida y sencilla. Toda tu información queda guardada de forma segura en tu dispositivo.'**
  String get onboardingSlide1Description;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In es, this message translates to:
  /// **'Organiza tu negocio'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Description.
  ///
  /// In es, this message translates to:
  /// **'Gestiona productos, precios y movimientos en un solo lugar. Mantén el control sin procesos complicados.'**
  String get onboardingSlide2Description;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In es, this message translates to:
  /// **'Entiende tus resultados'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Description.
  ///
  /// In es, this message translates to:
  /// **'Personaliza tu inicio con widgets y plantillas para ver solo lo importante de tu negocio.'**
  String get onboardingSlide3Description;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In es, this message translates to:
  /// **'Analiza con reportes'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Description.
  ///
  /// In es, this message translates to:
  /// **'Filtra por canal, producto, monto y cantidad para detectar cambios y oportunidades rapidamente.'**
  String get onboardingSlide4Description;

  /// No description provided for @onboardingSlide5Title.
  ///
  /// In es, this message translates to:
  /// **'Exporta a Excel'**
  String get onboardingSlide5Title;

  /// No description provided for @onboardingSlide5Description.
  ///
  /// In es, this message translates to:
  /// **'Configura modelos y campos a exportar. Por defecto puedes exportar todo con un solo toque.'**
  String get onboardingSlide5Description;

  /// No description provided for @onboardingSkip.
  ///
  /// In es, this message translates to:
  /// **'Omitir'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get onboardingStart;

  /// No description provided for @businessProfileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil del negocio'**
  String get businessProfileTitle;

  /// No description provided for @businessNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get businessNameLabel;

  /// No description provided for @businessImageUrlLabel.
  ///
  /// In es, this message translates to:
  /// **'Imagen'**
  String get businessImageUrlLabel;

  /// No description provided for @businessCurrencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get businessCurrencyLabel;

  /// No description provided for @businessCurrencyOtherLabel.
  ///
  /// In es, this message translates to:
  /// **'Otra moneda'**
  String get businessCurrencyOtherLabel;

  /// No description provided for @businessCurrencySymbolLabel.
  ///
  /// In es, this message translates to:
  /// **'Símbolo (opcional)'**
  String get businessCurrencySymbolLabel;

  /// No description provided for @currencyNameUsd.
  ///
  /// In es, this message translates to:
  /// **'Dólar estadounidense'**
  String get currencyNameUsd;

  /// No description provided for @currencyNameEur.
  ///
  /// In es, this message translates to:
  /// **'Euro'**
  String get currencyNameEur;

  /// No description provided for @currencyNamePen.
  ///
  /// In es, this message translates to:
  /// **'Sol peruano'**
  String get currencyNamePen;

  /// No description provided for @currencyNameMxn.
  ///
  /// In es, this message translates to:
  /// **'Peso mexicano'**
  String get currencyNameMxn;

  /// No description provided for @currencyNameCop.
  ///
  /// In es, this message translates to:
  /// **'Peso colombiano'**
  String get currencyNameCop;

  /// No description provided for @businessSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get businessSave;

  /// No description provided for @imagePickerCamera.
  ///
  /// In es, this message translates to:
  /// **'Tomar foto'**
  String get imagePickerCamera;

  /// No description provided for @imagePickerGallery.
  ///
  /// In es, this message translates to:
  /// **'Elegir de galería'**
  String get imagePickerGallery;

  /// No description provided for @imagePickerRemove.
  ///
  /// In es, this message translates to:
  /// **'Quitar'**
  String get imagePickerRemove;

  /// No description provided for @profileSetupTitle.
  ///
  /// In es, this message translates to:
  /// **'Configura tu Negocio'**
  String get profileSetupTitle;

  /// No description provided for @profileEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar negocio'**
  String get profileEditTitle;

  /// No description provided for @profileSetupNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del negocio'**
  String get profileSetupNameLabel;

  /// No description provided for @profileSetupNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio.'**
  String get profileSetupNameRequired;

  /// No description provided for @profileSetupNameMin.
  ///
  /// In es, this message translates to:
  /// **'Debe tener al menos {min} caracteres.'**
  String profileSetupNameMin(Object min);

  /// No description provided for @profileSetupLogoRequired.
  ///
  /// In es, this message translates to:
  /// **'El logo es obligatorio.'**
  String get profileSetupLogoRequired;

  /// No description provided for @profileSetupCurrencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get profileSetupCurrencyLabel;

  /// No description provided for @profileSetupCurrencyHint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona tu moneda'**
  String get profileSetupCurrencyHint;

  /// No description provided for @profileSetupCurrencyOtherOption.
  ///
  /// In es, this message translates to:
  /// **'Otra (personalizada)...'**
  String get profileSetupCurrencyOtherOption;

  /// No description provided for @profileSetupCurrencyRequired.
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar una moneda.'**
  String get profileSetupCurrencyRequired;

  /// No description provided for @profileSetupCustomSymbolLabel.
  ///
  /// In es, this message translates to:
  /// **'Símbolo de la moneda (ej: S/)'**
  String get profileSetupCustomSymbolLabel;

  /// No description provided for @profileSetupCustomSymbolRequired.
  ///
  /// In es, this message translates to:
  /// **'El símbolo es obligatorio.'**
  String get profileSetupCustomSymbolRequired;

  /// No description provided for @profileSetupCustomCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Código de la moneda (ej: PEN)'**
  String get profileSetupCustomCodeLabel;

  /// No description provided for @profileSetupCustomCodeRequired.
  ///
  /// In es, this message translates to:
  /// **'El código es obligatorio.'**
  String get profileSetupCustomCodeRequired;

  /// No description provided for @profileSetupSaveContinue.
  ///
  /// In es, this message translates to:
  /// **'Guardar y continuar'**
  String get profileSetupSaveContinue;

  /// No description provided for @profileSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get profileSave;

  /// No description provided for @profileSetupSaveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar el perfil'**
  String get profileSetupSaveError;

  /// No description provided for @productsTitle.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get productsTitle;

  /// No description provided for @productEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar producto'**
  String get productEditTitle;

  /// No description provided for @productAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get productAddTitle;

  /// No description provided for @productActionSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get productActionSave;

  /// No description provided for @productActionCreate.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get productActionCreate;

  /// No description provided for @productImageLabel.
  ///
  /// In es, this message translates to:
  /// **'Imagen del producto'**
  String get productImageLabel;

  /// No description provided for @productNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre del producto'**
  String get productNameLabel;

  /// No description provided for @productNameHint.
  ///
  /// In es, this message translates to:
  /// **'Sandía orgánica (premium)'**
  String get productNameHint;

  /// No description provided for @productNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio.'**
  String get productNameRequired;

  /// No description provided for @productNameMin.
  ///
  /// In es, this message translates to:
  /// **'Debe tener al menos {min} caracteres.'**
  String productNameMin(Object min);

  /// No description provided for @productDescriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get productDescriptionLabel;

  /// No description provided for @productDescriptionHint.
  ///
  /// In es, this message translates to:
  /// **'Cosecha fresca, 2–3 kg por unidad. Empaque para entrega local.'**
  String get productDescriptionHint;

  /// No description provided for @productPriceLabel.
  ///
  /// In es, this message translates to:
  /// **'Precio base'**
  String get productPriceLabel;

  /// No description provided for @productPriceHint.
  ///
  /// In es, this message translates to:
  /// **'189.99'**
  String get productPriceHint;

  /// No description provided for @productPriceRequired.
  ///
  /// In es, this message translates to:
  /// **'El precio es obligatorio.'**
  String get productPriceRequired;

  /// No description provided for @productPriceInvalid.
  ///
  /// In es, this message translates to:
  /// **'Ingresa un precio válido.'**
  String get productPriceInvalid;

  /// No description provided for @productPricePreview.
  ///
  /// In es, this message translates to:
  /// **'Vista previa: {value}'**
  String productPricePreview(Object value);

  /// No description provided for @productStrategyTitle.
  ///
  /// In es, this message translates to:
  /// **'Etiquetas de estrategia'**
  String get productStrategyTitle;

  /// No description provided for @productStrategyPromo.
  ///
  /// In es, this message translates to:
  /// **'Promocion'**
  String get productStrategyPromo;

  /// No description provided for @productStrategySeason.
  ///
  /// In es, this message translates to:
  /// **'Temporada'**
  String get productStrategySeason;

  /// No description provided for @productStrategyCost.
  ///
  /// In es, this message translates to:
  /// **'Ajuste costo'**
  String get productStrategyCost;

  /// No description provided for @productStrategyCompetition.
  ///
  /// In es, this message translates to:
  /// **'Competencia'**
  String get productStrategyCompetition;

  /// No description provided for @productSuggestedPriceTitle.
  ///
  /// In es, this message translates to:
  /// **'Precio sugerido'**
  String get productSuggestedPriceTitle;

  /// No description provided for @productSuggestedPriceSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Basado en ventas recientes del producto.'**
  String get productSuggestedPriceSubtitle;

  /// No description provided for @productSuggestedPriceApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar sugerido'**
  String get productSuggestedPriceApply;

  /// No description provided for @productPriceImpactTitle.
  ///
  /// In es, this message translates to:
  /// **'Impacto del cambio'**
  String get productPriceImpactTitle;

  /// No description provided for @productPriceImpactDelta.
  ///
  /// In es, this message translates to:
  /// **'Delta'**
  String get productPriceImpactDelta;

  /// No description provided for @productPriceImpactPercent.
  ///
  /// In es, this message translates to:
  /// **'%'**
  String get productPriceImpactPercent;

  /// No description provided for @productPriceImpactUnits.
  ///
  /// In es, this message translates to:
  /// **'Impacto estimado para {units} unidades'**
  String productPriceImpactUnits(Object units);

  /// No description provided for @productPriceHistoryCompactTitle.
  ///
  /// In es, this message translates to:
  /// **'Historial reciente de precio'**
  String get productPriceHistoryCompactTitle;

  /// No description provided for @productPriceHistoryCompactEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aun no hay cambios de precio.'**
  String get productPriceHistoryCompactEmpty;

  /// No description provided for @productPriceHistoryCompactDelta.
  ///
  /// In es, this message translates to:
  /// **'Cambio:'**
  String get productPriceHistoryCompactDelta;

  /// No description provided for @productExtremeChangeTitle.
  ///
  /// In es, this message translates to:
  /// **'Cambio de precio elevado'**
  String get productExtremeChangeTitle;

  /// No description provided for @productExtremeChangeBody.
  ///
  /// In es, this message translates to:
  /// **'El cambio es de {percent}. Estrategia: {strategy}. ¿Deseas continuar?'**
  String productExtremeChangeBody(Object percent, Object strategy);

  /// No description provided for @productDuplicateSuffix.
  ///
  /// In es, this message translates to:
  /// **'copia'**
  String get productDuplicateSuffix;

  /// No description provided for @productDuplicateSuccess.
  ///
  /// In es, this message translates to:
  /// **'Producto duplicado correctamente.'**
  String get productDuplicateSuccess;

  /// No description provided for @productUpdatePrice.
  ///
  /// In es, this message translates to:
  /// **'Actualizar precio'**
  String get productUpdatePrice;

  /// No description provided for @productPricePerformanceTitle.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento del precio'**
  String get productPricePerformanceTitle;

  /// No description provided for @productSalesPerformanceTitle.
  ///
  /// In es, this message translates to:
  /// **'Rendimiento de ventas'**
  String get productSalesPerformanceTitle;

  /// No description provided for @productPricePerformanceChart.
  ///
  /// In es, this message translates to:
  /// **'Gráfico ({range})'**
  String productPricePerformanceChart(Object range);

  /// No description provided for @productAddButton.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get productAddButton;

  /// No description provided for @productSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get productSaving;

  /// No description provided for @productSaveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar el producto'**
  String get productSaveError;

  /// No description provided for @productsEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes productos'**
  String get productsEmptyTitle;

  /// No description provided for @productsEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Agrega tu primer producto para comenzar a registrar ventas y precios.'**
  String get productsEmptyDescription;

  /// No description provided for @productsEmptyAction.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get productsEmptyAction;

  /// No description provided for @productsSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar producto...'**
  String get productsSearchHint;

  /// No description provided for @homeSectionDashboard.
  ///
  /// In es, this message translates to:
  /// **'DASHBOARD'**
  String get homeSectionDashboard;

  /// No description provided for @homeProductOverview.
  ///
  /// In es, this message translates to:
  /// **'Product Overview'**
  String get homeProductOverview;

  /// No description provided for @homePerformanceOverview.
  ///
  /// In es, this message translates to:
  /// **'RESUMEN DE RENDIMIENTO'**
  String get homePerformanceOverview;

  /// No description provided for @homeToday.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get homeToday;

  /// No description provided for @homeThisWeek.
  ///
  /// In es, this message translates to:
  /// **'Esta semana'**
  String get homeThisWeek;

  /// No description provided for @homeThisMonth.
  ///
  /// In es, this message translates to:
  /// **'Este mes'**
  String get homeThisMonth;

  /// No description provided for @homeQuickSale.
  ///
  /// In es, this message translates to:
  /// **'VENTA RÁPIDA'**
  String get homeQuickSale;

  /// No description provided for @homeAddSale.
  ///
  /// In es, this message translates to:
  /// **'Agregar venta'**
  String get homeAddSale;

  /// No description provided for @homeRecentSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas recientes'**
  String get homeRecentSales;

  /// No description provided for @homeCustomizeTitle.
  ///
  /// In es, this message translates to:
  /// **'Personalizar widgets de inicio'**
  String get homeCustomizeTitle;

  /// No description provided for @homeCustomizePresetsTitle.
  ///
  /// In es, this message translates to:
  /// **'Plantillas'**
  String get homeCustomizePresetsTitle;

  /// No description provided for @homePresetBasic.
  ///
  /// In es, this message translates to:
  /// **'Basico'**
  String get homePresetBasic;

  /// No description provided for @homePresetCommercial.
  ///
  /// In es, this message translates to:
  /// **'Comercial'**
  String get homePresetCommercial;

  /// No description provided for @homePresetAnalytical.
  ///
  /// In es, this message translates to:
  /// **'Analitico'**
  String get homePresetAnalytical;

  /// No description provided for @homeWidgetSalesGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta de ventas'**
  String get homeWidgetSalesGoal;

  /// No description provided for @homeWidgetQuickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones rapidas'**
  String get homeWidgetQuickActions;

  /// No description provided for @homeWidgetChannelMix.
  ///
  /// In es, this message translates to:
  /// **'Mix por canal'**
  String get homeWidgetChannelMix;

  /// No description provided for @homeWidgetAvgTicketTrend.
  ///
  /// In es, this message translates to:
  /// **'Tendencia de ticket promedio'**
  String get homeWidgetAvgTicketTrend;

  /// No description provided for @homeWidgetProductsAtRisk.
  ///
  /// In es, this message translates to:
  /// **'Productos en riesgo'**
  String get homeWidgetProductsAtRisk;

  /// No description provided for @homeWidgetWeeklyActivity.
  ///
  /// In es, this message translates to:
  /// **'Actividad semanal'**
  String get homeWidgetWeeklyActivity;

  /// No description provided for @homeWidgetWeeklyInsights.
  ///
  /// In es, this message translates to:
  /// **'Insights semanales'**
  String get homeWidgetWeeklyInsights;

  /// No description provided for @homeQuickActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones rapidas'**
  String get homeQuickActionsTitle;

  /// No description provided for @homeQuickActionsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Atajos para tareas frecuentes'**
  String get homeQuickActionsSubtitle;

  /// No description provided for @homeActionNewSale.
  ///
  /// In es, this message translates to:
  /// **'Nueva venta'**
  String get homeActionNewSale;

  /// No description provided for @homeActionSalesHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get homeActionSalesHistory;

  /// No description provided for @homeActionReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get homeActionReports;

  /// No description provided for @homeActionBackup.
  ///
  /// In es, this message translates to:
  /// **'Respaldo'**
  String get homeActionBackup;

  /// No description provided for @homeActionAddProduct.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get homeActionAddProduct;

  /// No description provided for @homeActionViewProducts.
  ///
  /// In es, this message translates to:
  /// **'Ver productos'**
  String get homeActionViewProducts;

  /// No description provided for @homeSalesGoalTitle.
  ///
  /// In es, this message translates to:
  /// **'Avance de meta mensual'**
  String get homeSalesGoalTitle;

  /// No description provided for @homeSalesGoalSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Mes actual vs meta estimada'**
  String get homeSalesGoalSubtitle;

  /// No description provided for @homeSalesGoalOf.
  ///
  /// In es, this message translates to:
  /// **'de {goal}'**
  String homeSalesGoalOf(Object goal);

  /// No description provided for @homeNoSalesData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos de ventas disponibles.'**
  String get homeNoSalesData;

  /// No description provided for @homeChannelMixTitle.
  ///
  /// In es, this message translates to:
  /// **'Mix por canal'**
  String get homeChannelMixTitle;

  /// No description provided for @homeChannelMixSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Distribucion de ventas en los ultimos 30 dias'**
  String get homeChannelMixSubtitle;

  /// No description provided for @homeAvgTicketTitle.
  ///
  /// In es, this message translates to:
  /// **'Ticket promedio'**
  String get homeAvgTicketTitle;

  /// No description provided for @homeAvgTicketSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ultimos 7 dias vs 7 dias previos'**
  String get homeAvgTicketSubtitle;

  /// No description provided for @homeAvgTicketTransactions.
  ///
  /// In es, this message translates to:
  /// **'{count} transacciones en el periodo'**
  String homeAvgTicketTransactions(Object count);

  /// No description provided for @homeWeeklyActivityTitle.
  ///
  /// In es, this message translates to:
  /// **'Actividad semanal'**
  String get homeWeeklyActivityTitle;

  /// No description provided for @homeWeeklyActivitySubtitle.
  ///
  /// In es, this message translates to:
  /// **'Transacciones por dia (ultimos 7 dias)'**
  String get homeWeeklyActivitySubtitle;

  /// No description provided for @homeProductsAtRiskTitle.
  ///
  /// In es, this message translates to:
  /// **'Productos en riesgo'**
  String get homeProductsAtRiskTitle;

  /// No description provided for @homeProductsAtRiskSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Sin ventas en los ultimos 21 dias'**
  String get homeProductsAtRiskSubtitle;

  /// No description provided for @homeProductsAtRiskEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay productos en riesgo actualmente.'**
  String get homeProductsAtRiskEmpty;

  /// No description provided for @homeProductsAtRiskNoSales.
  ///
  /// In es, this message translates to:
  /// **'Sin ventas registradas'**
  String get homeProductsAtRiskNoSales;

  /// No description provided for @homeProductsAtRiskDaysNoSales.
  ///
  /// In es, this message translates to:
  /// **'{days} dias sin ventas'**
  String homeProductsAtRiskDaysNoSales(Object days);

  /// No description provided for @homeWeeklyInsightsTitle.
  ///
  /// In es, this message translates to:
  /// **'Insights semanales'**
  String get homeWeeklyInsightsTitle;

  /// No description provided for @homeWeeklyInsightsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen automatico de los ultimos 7 dias'**
  String get homeWeeklyInsightsSubtitle;

  /// No description provided for @homeInsightDirectionUp.
  ///
  /// In es, this message translates to:
  /// **'Suben'**
  String get homeInsightDirectionUp;

  /// No description provided for @homeInsightDirectionDown.
  ///
  /// In es, this message translates to:
  /// **'Bajan'**
  String get homeInsightDirectionDown;

  /// No description provided for @homeInsightRevenueDelta.
  ///
  /// In es, this message translates to:
  /// **'{direction} ventas {percent} ({amount}) vs semana previa'**
  String homeInsightRevenueDelta(
    Object direction,
    Object percent,
    Object amount,
  );

  /// No description provided for @homeInsightChannelShift.
  ///
  /// In es, this message translates to:
  /// **'Canal {channel} gana participacion ({percent})'**
  String homeInsightChannelShift(Object channel, Object percent);

  /// No description provided for @homeInsightTopProduct.
  ///
  /// In es, this message translates to:
  /// **'Top producto: {product}'**
  String homeInsightTopProduct(Object product);

  /// No description provided for @homeInsightNoSignificantChange.
  ///
  /// In es, this message translates to:
  /// **'Sin cambios relevantes esta semana.'**
  String get homeInsightNoSignificantChange;

  /// No description provided for @homeSeeHistory.
  ///
  /// In es, this message translates to:
  /// **'Ver historial'**
  String get homeSeeHistory;

  /// No description provided for @homeHoursAgo.
  ///
  /// In es, this message translates to:
  /// **'HACE {hours} HORAS'**
  String homeHoursAgo(Object hours);

  /// No description provided for @homeYesterday.
  ///
  /// In es, this message translates to:
  /// **'AYER'**
  String get homeYesterday;

  /// No description provided for @navSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get navSales;

  /// No description provided for @navReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get navReports;

  /// No description provided for @navProducts.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get navProducts;

  /// No description provided for @navSettings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get navSettings;

  /// No description provided for @comingSoonTitle.
  ///
  /// In es, this message translates to:
  /// **'Muy pronto'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In es, this message translates to:
  /// **'Estamos trabajando en esta sección.'**
  String get comingSoonMessage;

  /// No description provided for @comingSoonError.
  ///
  /// In es, this message translates to:
  /// **'Sección inválida'**
  String get comingSoonError;

  /// No description provided for @salesHistoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Historial de ventas'**
  String get salesHistoryTitle;

  /// No description provided for @salesRange1H.
  ///
  /// In es, this message translates to:
  /// **'1H'**
  String get salesRange1H;

  /// No description provided for @salesRange1D.
  ///
  /// In es, this message translates to:
  /// **'1D'**
  String get salesRange1D;

  /// No description provided for @salesRange1W.
  ///
  /// In es, this message translates to:
  /// **'1S'**
  String get salesRange1W;

  /// No description provided for @salesRange1M.
  ///
  /// In es, this message translates to:
  /// **'1M'**
  String get salesRange1M;

  /// No description provided for @salesEmptyTitle.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas'**
  String get salesEmptyTitle;

  /// No description provided for @salesEmptyDescription.
  ///
  /// In es, this message translates to:
  /// **'Agrega tu primera venta para ver el historial.'**
  String get salesEmptyDescription;

  /// No description provided for @salesEmptyAction.
  ///
  /// In es, this message translates to:
  /// **'Agregar venta'**
  String get salesEmptyAction;

  /// No description provided for @salesToday.
  ///
  /// In es, this message translates to:
  /// **'HOY'**
  String get salesToday;

  /// No description provided for @salesYesterday.
  ///
  /// In es, this message translates to:
  /// **'AYER'**
  String get salesYesterday;

  /// No description provided for @salesAddTitle.
  ///
  /// In es, this message translates to:
  /// **'Agregar venta'**
  String get salesAddTitle;

  /// No description provided for @salesProductImage.
  ///
  /// In es, this message translates to:
  /// **'Imagen del producto'**
  String get salesProductImage;

  /// No description provided for @salesProductName.
  ///
  /// In es, this message translates to:
  /// **'Producto'**
  String get salesProductName;

  /// No description provided for @salesProductNameRequired.
  ///
  /// In es, this message translates to:
  /// **'El producto es obligatorio.'**
  String get salesProductNameRequired;

  /// No description provided for @salesQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get salesQuantity;

  /// No description provided for @salesQuantityRequired.
  ///
  /// In es, this message translates to:
  /// **'La cantidad es obligatoria.'**
  String get salesQuantityRequired;

  /// No description provided for @salesAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get salesAmount;

  /// No description provided for @salesAmountRequired.
  ///
  /// In es, this message translates to:
  /// **'El monto es obligatorio.'**
  String get salesAmountRequired;

  /// No description provided for @salesChannel.
  ///
  /// In es, this message translates to:
  /// **'Canal'**
  String get salesChannel;

  /// No description provided for @salesChannelRequired.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un canal.'**
  String get salesChannelRequired;

  /// No description provided for @salesChannelRetail.
  ///
  /// In es, this message translates to:
  /// **'Minorista'**
  String get salesChannelRetail;

  /// No description provided for @salesChannelWholesale.
  ///
  /// In es, this message translates to:
  /// **'Mayorista'**
  String get salesChannelWholesale;

  /// No description provided for @salesFiltersAll.
  ///
  /// In es, this message translates to:
  /// **'Todos'**
  String get salesFiltersAll;

  /// No description provided for @salesFiltersSort.
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get salesFiltersSort;

  /// No description provided for @salesSortLatest.
  ///
  /// In es, this message translates to:
  /// **'Más recientes'**
  String get salesSortLatest;

  /// No description provided for @salesSortHighestAmount.
  ///
  /// In es, this message translates to:
  /// **'Mayor monto'**
  String get salesSortHighestAmount;

  /// No description provided for @salesSortHighestQuantity.
  ///
  /// In es, this message translates to:
  /// **'Mayor cantidad'**
  String get salesSortHighestQuantity;

  /// No description provided for @salesFiltersClear.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get salesFiltersClear;

  /// No description provided for @salesFiltersApply.
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get salesFiltersApply;

  /// No description provided for @salesSave.
  ///
  /// In es, this message translates to:
  /// **'Guardar venta'**
  String get salesSave;

  /// No description provided for @salesSaving.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get salesSaving;

  /// No description provided for @salesSaveError.
  ///
  /// In es, this message translates to:
  /// **'Error al guardar la venta'**
  String get salesSaveError;

  /// No description provided for @homeRecentEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay ventas recientes.'**
  String get homeRecentEmpty;

  /// No description provided for @homeQuickAddProducts.
  ///
  /// In es, this message translates to:
  /// **'Agregar productos'**
  String get homeQuickAddProducts;

  /// No description provided for @homePerformanceDetailPeriodSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas del período'**
  String get homePerformanceDetailPeriodSales;

  /// No description provided for @homePerformanceDetailProductsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ventas por producto'**
  String get homePerformanceDetailProductsTitle;

  /// No description provided for @homePerformanceDetailProductsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Comparado con el período anterior'**
  String get homePerformanceDetailProductsSubtitle;

  /// No description provided for @homePerformanceDetailNoSales.
  ///
  /// In es, this message translates to:
  /// **'No hay ventas en este período.'**
  String get homePerformanceDetailNoSales;

  /// No description provided for @homePerformanceDetailPreviousPeriod.
  ///
  /// In es, this message translates to:
  /// **'Período anterior'**
  String get homePerformanceDetailPreviousPeriod;

  /// No description provided for @homePerformanceDetailQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cant.'**
  String get homePerformanceDetailQuantity;

  /// No description provided for @homeLatestProductsTitle.
  ///
  /// In es, this message translates to:
  /// **'Productos recientes'**
  String get homeLatestProductsTitle;

  /// No description provided for @homeLatestProductsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Últimos 3 productos agregados'**
  String get homeLatestProductsSubtitle;

  /// No description provided for @homeLatestProductsEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay productos registrados.'**
  String get homeLatestProductsEmpty;

  /// No description provided for @homeLatestProductsAddButton.
  ///
  /// In es, this message translates to:
  /// **'Agregar producto'**
  String get homeLatestProductsAddButton;

  /// No description provided for @salesProductSelect.
  ///
  /// In es, this message translates to:
  /// **'Selecciona un producto'**
  String get salesProductSelect;

  /// No description provided for @salesSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar productos...'**
  String get salesSearchHint;

  /// No description provided for @salesChangeProduct.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get salesChangeProduct;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @settingsAppName.
  ///
  /// In es, this message translates to:
  /// **'Cosecha'**
  String get settingsAppName;

  /// No description provided for @settingsAppVersion.
  ///
  /// In es, this message translates to:
  /// **'v1.0.0(1)'**
  String get settingsAppVersion;

  /// No description provided for @settingsAppTagline.
  ///
  /// In es, this message translates to:
  /// **'Control de ventas y productos'**
  String get settingsAppTagline;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In es, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsPremiumActiveTitle.
  ///
  /// In es, this message translates to:
  /// **'Plan Premium activo'**
  String get settingsPremiumActiveTitle;

  /// No description provided for @settingsPremiumInactiveTitle.
  ///
  /// In es, this message translates to:
  /// **'Volverse Premium'**
  String get settingsPremiumInactiveTitle;

  /// No description provided for @settingsPremiumActiveSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Ya tienes todas las funciones premium desbloqueadas.'**
  String get settingsPremiumActiveSubtitle;

  /// No description provided for @settingsPremiumInactiveSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Desbloquea ajustes avanzados, widgets premium y exportación Excel.'**
  String get settingsPremiumInactiveSubtitle;

  /// No description provided for @settingsPremiumAlreadyActiveMessage.
  ///
  /// In es, this message translates to:
  /// **'Tu cuenta ya es Premium.'**
  String get settingsPremiumAlreadyActiveMessage;

  /// No description provided for @settingsBusinessTitle.
  ///
  /// In es, this message translates to:
  /// **'Negocio'**
  String get settingsBusinessTitle;

  /// No description provided for @settingsBusinessSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Actualizar datos del negocio'**
  String get settingsBusinessSubtitle;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos y Respaldo'**
  String get settingsBackupTitle;

  /// No description provided for @settingsBackupSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Copias de seguridad y Exportar Excel'**
  String get settingsBackupSubtitle;

  /// No description provided for @settingsSectionNotifications.
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get settingsSectionNotifications;

  /// No description provided for @settingsBackupReminderTitle.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de respaldo'**
  String get settingsBackupReminderTitle;

  /// No description provided for @settingsBackupReminderSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Configura y gestiona recordatorios para evitar pérdida de datos.'**
  String get settingsBackupReminderSubtitle;

  /// No description provided for @settingsBackupReminderEnabled.
  ///
  /// In es, this message translates to:
  /// **'Activar recordatorios'**
  String get settingsBackupReminderEnabled;

  /// No description provided for @settingsBackupReminderFrequency.
  ///
  /// In es, this message translates to:
  /// **'Frecuencia'**
  String get settingsBackupReminderFrequency;

  /// No description provided for @settingsBackupReminderFrequencyDaily.
  ///
  /// In es, this message translates to:
  /// **'Diario'**
  String get settingsBackupReminderFrequencyDaily;

  /// No description provided for @settingsBackupReminderFrequencyWeekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get settingsBackupReminderFrequencyWeekly;

  /// No description provided for @settingsBackupReminderTapAction.
  ///
  /// In es, this message translates to:
  /// **'Al tocar la notificación'**
  String get settingsBackupReminderTapAction;

  /// No description provided for @settingsBackupReminderTapOpenDataBackup.
  ///
  /// In es, this message translates to:
  /// **'Abrir Datos y Respaldo'**
  String get settingsBackupReminderTapOpenDataBackup;

  /// No description provided for @settingsBackupReminderTapOpenSettings.
  ///
  /// In es, this message translates to:
  /// **'Abrir Ajustes'**
  String get settingsBackupReminderTapOpenSettings;

  /// No description provided for @settingsBackupReminderTapOpenNotificationSettings.
  ///
  /// In es, this message translates to:
  /// **'Abrir Notificaciones'**
  String get settingsBackupReminderTapOpenNotificationSettings;

  /// No description provided for @settingsBackupReminderTest.
  ///
  /// In es, this message translates to:
  /// **'Enviar notificación de prueba'**
  String get settingsBackupReminderTest;

  /// No description provided for @settingsBackupReminderTestSent.
  ///
  /// In es, this message translates to:
  /// **'Notificación de prueba enviada'**
  String get settingsBackupReminderTestSent;

  /// No description provided for @settingsBackupReminderPermissionDenied.
  ///
  /// In es, this message translates to:
  /// **'Permiso de notificaciones denegado. Actívalo en ajustes del sistema.'**
  String get settingsBackupReminderPermissionDenied;

  /// No description provided for @settingsBackupReminderTestError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar la notificación de prueba.'**
  String get settingsBackupReminderTestError;

  /// No description provided for @settingsRemindersTitle.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios personalizados'**
  String get settingsRemindersTitle;

  /// No description provided for @settingsRemindersCardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Crea recordatorios con días, hora y destino opcional dentro de la app.'**
  String get settingsRemindersCardSubtitle;

  /// No description provided for @settingsRemindersCounterTitle.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios disponibles'**
  String get settingsRemindersCounterTitle;

  /// No description provided for @settingsRemindersCounterSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Puedes tener hasta 10 recordatorios activos o desactivados.'**
  String get settingsRemindersCounterSubtitle;

  /// No description provided for @settingsRemindersViewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todos'**
  String get settingsRemindersViewAll;

  /// No description provided for @settingsRemindersAdd.
  ///
  /// In es, this message translates to:
  /// **'Agregar'**
  String get settingsRemindersAdd;

  /// No description provided for @settingsRemindersLimit.
  ///
  /// In es, this message translates to:
  /// **'Límite alcanzado: solo puedes tener 10 recordatorios.'**
  String get settingsRemindersLimit;

  /// No description provided for @settingsRemindersEmpty.
  ///
  /// In es, this message translates to:
  /// **'Aún no tienes recordatorios. Agrega el primero para comenzar.'**
  String get settingsRemindersEmpty;

  /// No description provided for @settingsRemindersNoDestination.
  ///
  /// In es, this message translates to:
  /// **'Sin destino'**
  String get settingsRemindersNoDestination;

  /// No description provided for @settingsRemindersDeleteTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar recordatorio'**
  String get settingsRemindersDeleteTitle;

  /// No description provided for @settingsRemindersDeleteBody.
  ///
  /// In es, this message translates to:
  /// **'Este recordatorio se eliminará y dejará de notificarse.'**
  String get settingsRemindersDeleteBody;

  /// No description provided for @settingsRemindersCreateTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo recordatorio'**
  String get settingsRemindersCreateTitle;

  /// No description provided for @settingsRemindersEditTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar recordatorio'**
  String get settingsRemindersEditTitle;

  /// No description provided for @settingsRemindersFieldTitle.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get settingsRemindersFieldTitle;

  /// No description provided for @settingsRemindersFieldDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get settingsRemindersFieldDescription;

  /// No description provided for @settingsRemindersFieldLabel.
  ///
  /// In es, this message translates to:
  /// **'Etiqueta'**
  String get settingsRemindersFieldLabel;

  /// No description provided for @settingsRemindersFieldTime.
  ///
  /// In es, this message translates to:
  /// **'Hora'**
  String get settingsRemindersFieldTime;

  /// No description provided for @settingsRemindersFieldRepeat.
  ///
  /// In es, this message translates to:
  /// **'Repetir'**
  String get settingsRemindersFieldRepeat;

  /// No description provided for @settingsRemindersFieldOpenDestination.
  ///
  /// In es, this message translates to:
  /// **'Abrir una sección al tocar la notificación'**
  String get settingsRemindersFieldOpenDestination;

  /// No description provided for @settingsRemindersFieldDestination.
  ///
  /// In es, this message translates to:
  /// **'Destino'**
  String get settingsRemindersFieldDestination;

  /// No description provided for @settingsRemindersRequired.
  ///
  /// In es, this message translates to:
  /// **'Este campo es obligatorio.'**
  String get settingsRemindersRequired;

  /// No description provided for @settingsRemindersEnabled.
  ///
  /// In es, this message translates to:
  /// **'Habilitado'**
  String get settingsRemindersEnabled;

  /// No description provided for @settingsRemindersSaveAction.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get settingsRemindersSaveAction;

  /// No description provided for @settingsRemindersEditAction.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get settingsRemindersEditAction;

  /// No description provided for @settingsRemindersDeleteAction.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get settingsRemindersDeleteAction;

  /// No description provided for @settingsReminderDestinationNewProduct.
  ///
  /// In es, this message translates to:
  /// **'Nuevo producto'**
  String get settingsReminderDestinationNewProduct;

  /// No description provided for @settingsReminderDestinationNewSale.
  ///
  /// In es, this message translates to:
  /// **'Nueva venta'**
  String get settingsReminderDestinationNewSale;

  /// No description provided for @settingsReminderDestinationReports.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get settingsReminderDestinationReports;

  /// No description provided for @settingsReminderDestinationSalesHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de ventas'**
  String get settingsReminderDestinationSalesHistory;

  /// No description provided for @settingsReminderDestinationProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get settingsReminderDestinationProfile;

  /// No description provided for @settingsReminderDestinationPerformanceToday.
  ///
  /// In es, this message translates to:
  /// **'Performance de ventas hoy'**
  String get settingsReminderDestinationPerformanceToday;

  /// No description provided for @settingsReminderDestinationPerformanceWeek.
  ///
  /// In es, this message translates to:
  /// **'Performance de ventas semana'**
  String get settingsReminderDestinationPerformanceWeek;

  /// No description provided for @settingsReminderDestinationPerformanceMonth.
  ///
  /// In es, this message translates to:
  /// **'Performance de ventas mes'**
  String get settingsReminderDestinationPerformanceMonth;

  /// No description provided for @settingsWeekdaySunShort.
  ///
  /// In es, this message translates to:
  /// **'D'**
  String get settingsWeekdaySunShort;

  /// No description provided for @settingsWeekdayMonShort.
  ///
  /// In es, this message translates to:
  /// **'L'**
  String get settingsWeekdayMonShort;

  /// No description provided for @settingsWeekdayTueShort.
  ///
  /// In es, this message translates to:
  /// **'M'**
  String get settingsWeekdayTueShort;

  /// No description provided for @settingsWeekdayWedShort.
  ///
  /// In es, this message translates to:
  /// **'M'**
  String get settingsWeekdayWedShort;

  /// No description provided for @settingsWeekdayThuShort.
  ///
  /// In es, this message translates to:
  /// **'J'**
  String get settingsWeekdayThuShort;

  /// No description provided for @settingsWeekdayFriShort.
  ///
  /// In es, this message translates to:
  /// **'V'**
  String get settingsWeekdayFriShort;

  /// No description provided for @settingsWeekdaySatShort.
  ///
  /// In es, this message translates to:
  /// **'S'**
  String get settingsWeekdaySatShort;

  /// No description provided for @dataBackupTitle.
  ///
  /// In es, this message translates to:
  /// **'Datos y Respaldo'**
  String get dataBackupTitle;

  /// No description provided for @dataBackupSummaryTitle.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get dataBackupSummaryTitle;

  /// No description provided for @dataBackupProducts.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get dataBackupProducts;

  /// No description provided for @dataBackupSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get dataBackupSales;

  /// No description provided for @dataBackupPriceHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de precios'**
  String get dataBackupPriceHistory;

  /// No description provided for @dataBackupLastBackupTitle.
  ///
  /// In es, this message translates to:
  /// **'Último respaldo'**
  String get dataBackupLastBackupTitle;

  /// No description provided for @dataBackupLastBackupNever.
  ///
  /// In es, this message translates to:
  /// **'Nunca'**
  String get dataBackupLastBackupNever;

  /// No description provided for @dataBackupActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones'**
  String get dataBackupActionsTitle;

  /// No description provided for @dataBackupExportExcel.
  ///
  /// In es, this message translates to:
  /// **'Exportar a Excel'**
  String get dataBackupExportExcel;

  /// No description provided for @dataBackupExportConfig.
  ///
  /// In es, this message translates to:
  /// **'Configurar exportacion Excel'**
  String get dataBackupExportConfig;

  /// No description provided for @dataBackupExportEncrypted.
  ///
  /// In es, this message translates to:
  /// **'Exportar respaldo encriptado'**
  String get dataBackupExportEncrypted;

  /// No description provided for @dataBackupRestore.
  ///
  /// In es, this message translates to:
  /// **'Restaurar respaldo'**
  String get dataBackupRestore;

  /// No description provided for @dataBackupExportExcelSoon.
  ///
  /// In es, this message translates to:
  /// **'Exportar a Excel estará disponible pronto.'**
  String get dataBackupExportExcelSoon;

  /// No description provided for @dataBackupExportEncryptedSoon.
  ///
  /// In es, this message translates to:
  /// **'El respaldo encriptado estará disponible pronto.'**
  String get dataBackupExportEncryptedSoon;

  /// No description provided for @dataBackupRestoreSoon.
  ///
  /// In es, this message translates to:
  /// **'La restauración estará disponible pronto.'**
  String get dataBackupRestoreSoon;

  /// No description provided for @dataBackupExported.
  ///
  /// In es, this message translates to:
  /// **'Archivo Excel guardado'**
  String get dataBackupExported;

  /// No description provided for @dataBackupEncryptedExported.
  ///
  /// In es, this message translates to:
  /// **'Respaldo encriptado guardado'**
  String get dataBackupEncryptedExported;

  /// No description provided for @dataBackupRestoreSuccess.
  ///
  /// In es, this message translates to:
  /// **'Respaldo restaurado con éxito.'**
  String get dataBackupRestoreSuccess;

  /// No description provided for @dataBackupRestoreError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo restaurar el respaldo.'**
  String get dataBackupRestoreError;

  /// No description provided for @dataBackupPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Contraseña de respaldo'**
  String get dataBackupPasswordTitle;

  /// No description provided for @dataBackupPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get dataBackupPasswordLabel;

  /// No description provided for @dataBackupExporting.
  ///
  /// In es, this message translates to:
  /// **'Exportando a Excel...'**
  String get dataBackupExporting;

  /// No description provided for @dataBackupEncrypting.
  ///
  /// In es, this message translates to:
  /// **'Generando respaldo encriptado...'**
  String get dataBackupEncrypting;

  /// No description provided for @dataBackupRestoring.
  ///
  /// In es, this message translates to:
  /// **'Restaurando respaldo...'**
  String get dataBackupRestoring;

  /// No description provided for @dataBackupRestoreConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Restaurar respaldo'**
  String get dataBackupRestoreConfirmTitle;

  /// No description provided for @dataBackupRestoreConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Esto reemplazará todos los datos actuales. ¿Deseas continuar?'**
  String get dataBackupRestoreConfirmBody;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get settingsSectionAbout;

  /// No description provided for @settingsOriginTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuestra historia'**
  String get settingsOriginTitle;

  /// No description provided for @settingsOriginBody.
  ///
  /// In es, this message translates to:
  /// **'Cosecha nació en el campo, no en una oficina: al ver a mi socio Michael “Micha” registrar ventas en una libreta y cerrar el día sin claridad real del negocio.\n\n¿Por qué usar esta app?\n• Control diario: ves ventas, productos y métricas clave en minutos.\n• Decisiones con datos: entiendes qué se vende, cuándo y por qué.\n• Orden sin fricción: recordatorios, historial y reportes en un solo lugar.\n\n¿Para qué fue creada?\nFue creada para pequeños negocios como el de Micha, que necesitan claridad operativa sin sistemas complejos ni procesos pesados.\n\n¿Qué problema resuelve?\nResuelve el mismo problema que vivimos al inicio: información dispersa, números poco confiables y decisiones a ciegas. Cosecha convierte registros sueltos en información accionable para crecer con control.'**
  String get settingsOriginBody;

  /// No description provided for @settingsDeveloperTitle.
  ///
  /// In es, this message translates to:
  /// **'Desarrollador'**
  String get settingsDeveloperTitle;

  /// No description provided for @settingsDeveloperSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Creado con privacidad en mente'**
  String get settingsDeveloperSubtitle;

  /// No description provided for @developerTitle.
  ///
  /// In es, this message translates to:
  /// **'Desarrollador'**
  String get developerTitle;

  /// No description provided for @developerHandle.
  ///
  /// In es, this message translates to:
  /// **'@christhoval'**
  String get developerHandle;

  /// No description provided for @developerRole.
  ///
  /// In es, this message translates to:
  /// **'Software Engineer · Technical Writer'**
  String get developerRole;

  /// No description provided for @developerBioTitle.
  ///
  /// In es, this message translates to:
  /// **'Sobre mí'**
  String get developerBioTitle;

  /// No description provided for @developerBioBody.
  ///
  /// In es, this message translates to:
  /// **'Ingeniero de software y escritor técnico con sede en Panamá.'**
  String get developerBioBody;

  /// No description provided for @developerFocusTitle.
  ///
  /// In es, this message translates to:
  /// **'Enfoque'**
  String get developerFocusTitle;

  /// No description provided for @developerFocusBody.
  ///
  /// In es, this message translates to:
  /// **'Desarrollo de apps, APIs y herramientas orientadas a producto.'**
  String get developerFocusBody;

  /// No description provided for @developerLeadershipTitle.
  ///
  /// In es, this message translates to:
  /// **'Liderazgo'**
  String get developerLeadershipTitle;

  /// No description provided for @developerLeadershipBody.
  ///
  /// In es, this message translates to:
  /// **'Más de 10 años creando software y liderando equipos.'**
  String get developerLeadershipBody;

  /// No description provided for @developerTechTitle.
  ///
  /// In es, this message translates to:
  /// **'Tecnologías'**
  String get developerTechTitle;

  /// No description provided for @developerTechBody.
  ///
  /// In es, this message translates to:
  /// **'TypeScript, Node.js, React, Flutter, Python, PostgreSQL y MongoDB.'**
  String get developerTechBody;

  /// No description provided for @developerWebsite.
  ///
  /// In es, this message translates to:
  /// **'Sitio web'**
  String get developerWebsite;

  /// No description provided for @developerWebsiteUrl.
  ///
  /// In es, this message translates to:
  /// **'https://s.christhoval.dev/'**
  String get developerWebsiteUrl;

  /// No description provided for @developerGitHub.
  ///
  /// In es, this message translates to:
  /// **'GitHub'**
  String get developerGitHub;

  /// No description provided for @developerGithubUrl.
  ///
  /// In es, this message translates to:
  /// **'https://github.com/christhoval'**
  String get developerGithubUrl;

  /// No description provided for @developerLinkedIn.
  ///
  /// In es, this message translates to:
  /// **'LinkedIn'**
  String get developerLinkedIn;

  /// No description provided for @developerLinkedinUrl.
  ///
  /// In es, this message translates to:
  /// **'https://www.linkedin.com/in/christhoval/'**
  String get developerLinkedinUrl;

  /// No description provided for @settingsSupportTitle.
  ///
  /// In es, this message translates to:
  /// **'Contacto / Soporte'**
  String get settingsSupportTitle;

  /// No description provided for @settingsSupportSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reportar bugs o sugerir ideas'**
  String get settingsSupportSubtitle;

  /// No description provided for @supportEmail.
  ///
  /// In es, this message translates to:
  /// **'soporte@cosecha.app'**
  String get supportEmail;

  /// No description provided for @supportSubject.
  ///
  /// In es, this message translates to:
  /// **'Sugerencias de mejora'**
  String get supportSubject;

  /// No description provided for @supportBody.
  ///
  /// In es, this message translates to:
  /// **'Hola equipo, tengo una sugerencia para mejorar la app:'**
  String get supportBody;

  /// No description provided for @settingsSectionDanger.
  ///
  /// In es, this message translates to:
  /// **'Zona de peligro'**
  String get settingsSectionDanger;

  /// No description provided for @settingsResetTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer App'**
  String get settingsResetTitle;

  /// No description provided for @settingsResetSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Borrar todos los datos y reiniciar'**
  String get settingsResetSubtitle;

  /// No description provided for @settingsResetConfirmTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer app'**
  String get settingsResetConfirmTitle;

  /// No description provided for @settingsResetConfirmBody.
  ///
  /// In es, this message translates to:
  /// **'Esta acción eliminará todos tus datos. ¿Deseas continuar?'**
  String get settingsResetConfirmBody;

  /// No description provided for @backupReminderNotificationChannelName.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios de respaldo'**
  String get backupReminderNotificationChannelName;

  /// No description provided for @backupReminderNotificationChannelDescription.
  ///
  /// In es, this message translates to:
  /// **'Recordatorios para respaldar los datos de la app'**
  String get backupReminderNotificationChannelDescription;

  /// No description provided for @backupReminderNotificationTitle.
  ///
  /// In es, this message translates to:
  /// **'Protege tus datos'**
  String get backupReminderNotificationTitle;

  /// No description provided for @backupReminderNotificationBody.
  ///
  /// In es, this message translates to:
  /// **'Haz un respaldo para no perder tu información.'**
  String get backupReminderNotificationBody;

  /// No description provided for @reportsTitle.
  ///
  /// In es, this message translates to:
  /// **'Reportes'**
  String get reportsTitle;

  /// No description provided for @reportsCustomizeTitle.
  ///
  /// In es, this message translates to:
  /// **'Personalizar widgets'**
  String get reportsCustomizeTitle;

  /// No description provided for @reportsCustomizePresetsTitle.
  ///
  /// In es, this message translates to:
  /// **'Plantillas'**
  String get reportsCustomizePresetsTitle;

  /// No description provided for @reportsPresetBasic.
  ///
  /// In es, this message translates to:
  /// **'Basico'**
  String get reportsPresetBasic;

  /// No description provided for @reportsPresetCommercial.
  ///
  /// In es, this message translates to:
  /// **'Comercial'**
  String get reportsPresetCommercial;

  /// No description provided for @reportsPresetAnalytical.
  ///
  /// In es, this message translates to:
  /// **'Analitico'**
  String get reportsPresetAnalytical;

  /// No description provided for @reportsWidgetExportTools.
  ///
  /// In es, this message translates to:
  /// **'Herramientas de exportacion'**
  String get reportsWidgetExportTools;

  /// No description provided for @reportsWidgetSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen'**
  String get reportsWidgetSummary;

  /// No description provided for @reportsWidgetPeriodComparison.
  ///
  /// In es, this message translates to:
  /// **'Comparativo de periodo'**
  String get reportsWidgetPeriodComparison;

  /// No description provided for @reportsWidgetTotalSalesTrend.
  ///
  /// In es, this message translates to:
  /// **'Tendencia de ventas'**
  String get reportsWidgetTotalSalesTrend;

  /// No description provided for @reportsWidgetChannelMix.
  ///
  /// In es, this message translates to:
  /// **'Mix por canal'**
  String get reportsWidgetChannelMix;

  /// No description provided for @reportsWidgetMonthlySales.
  ///
  /// In es, this message translates to:
  /// **'Ventas mensuales'**
  String get reportsWidgetMonthlySales;

  /// No description provided for @reportsWidgetDailyHeatmap.
  ///
  /// In es, this message translates to:
  /// **'Mapa de calor diario'**
  String get reportsWidgetDailyHeatmap;

  /// No description provided for @reportsWidgetTopProducts.
  ///
  /// In es, this message translates to:
  /// **'Top productos'**
  String get reportsWidgetTopProducts;

  /// No description provided for @reportsWidgetBottomProducts.
  ///
  /// In es, this message translates to:
  /// **'Productos con menor venta'**
  String get reportsWidgetBottomProducts;

  /// No description provided for @reportsPeriodComparisonTitle.
  ///
  /// In es, this message translates to:
  /// **'Comparativo de periodo'**
  String get reportsPeriodComparisonTitle;

  /// No description provided for @reportsPeriodComparisonSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Rango actual vs rango anterior'**
  String get reportsPeriodComparisonSubtitle;

  /// No description provided for @reportsChannelMixTitle.
  ///
  /// In es, this message translates to:
  /// **'Ventas por canal'**
  String get reportsChannelMixTitle;

  /// No description provided for @reportsChannelMixSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Participacion por canal en el rango seleccionado'**
  String get reportsChannelMixSubtitle;

  /// No description provided for @reportsChannelOther.
  ///
  /// In es, this message translates to:
  /// **'Otros'**
  String get reportsChannelOther;

  /// No description provided for @reportsExportToolsTitle.
  ///
  /// In es, this message translates to:
  /// **'Exportacion Excel'**
  String get reportsExportToolsTitle;

  /// No description provided for @reportsExportToolsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Configura campos y exporta los datos actuales'**
  String get reportsExportToolsSubtitle;

  /// No description provided for @reportsExportConfigure.
  ///
  /// In es, this message translates to:
  /// **'Configurar'**
  String get reportsExportConfigure;

  /// No description provided for @reportsExportRun.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get reportsExportRun;

  /// No description provided for @reportsFilterAmountRange.
  ///
  /// In es, this message translates to:
  /// **'Rango de monto'**
  String get reportsFilterAmountRange;

  /// No description provided for @reportsFilterMinAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto minimo'**
  String get reportsFilterMinAmount;

  /// No description provided for @reportsFilterMaxAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto maximo'**
  String get reportsFilterMaxAmount;

  /// No description provided for @reportsFilterMinQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad minima'**
  String get reportsFilterMinQuantity;

  /// No description provided for @reportsTopProducts.
  ///
  /// In es, this message translates to:
  /// **'Top productos'**
  String get reportsTopProducts;

  /// No description provided for @reportsBottomProducts.
  ///
  /// In es, this message translates to:
  /// **'Productos con menor venta'**
  String get reportsBottomProducts;

  /// No description provided for @reportsTopEmpty.
  ///
  /// In es, this message translates to:
  /// **'No hay ventas en este rango.'**
  String get reportsTopEmpty;

  /// No description provided for @reportsTotalSales.
  ///
  /// In es, this message translates to:
  /// **'Total ventas'**
  String get reportsTotalSales;

  /// No description provided for @reportsMonthlySalesLast6.
  ///
  /// In es, this message translates to:
  /// **'Ventas mensuales (últimos 6 meses)'**
  String get reportsMonthlySalesLast6;

  /// No description provided for @reportsDailyHeatmap.
  ///
  /// In es, this message translates to:
  /// **'Mapa de calor diario'**
  String get reportsDailyHeatmap;

  /// No description provided for @reportsTransactions.
  ///
  /// In es, this message translates to:
  /// **'Transacciones'**
  String get reportsTransactions;

  /// No description provided for @reportsAvgTicket.
  ///
  /// In es, this message translates to:
  /// **'Ticket promedio'**
  String get reportsAvgTicket;

  /// No description provided for @reportsUnits.
  ///
  /// In es, this message translates to:
  /// **'unidades'**
  String get reportsUnits;

  /// No description provided for @excelExportConfigTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuracion de exportacion Excel'**
  String get excelExportConfigTitle;

  /// No description provided for @excelExportModelProducts.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get excelExportModelProducts;

  /// No description provided for @excelExportModelSales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get excelExportModelSales;

  /// No description provided for @excelExportModelPriceHistory.
  ///
  /// In es, this message translates to:
  /// **'Historial de precios'**
  String get excelExportModelPriceHistory;

  /// No description provided for @excelExportFieldId.
  ///
  /// In es, this message translates to:
  /// **'ID'**
  String get excelExportFieldId;

  /// No description provided for @excelExportFieldName.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get excelExportFieldName;

  /// No description provided for @excelExportFieldImageUrl.
  ///
  /// In es, this message translates to:
  /// **'URL de imagen'**
  String get excelExportFieldImageUrl;

  /// No description provided for @excelExportFieldCurrentPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio actual'**
  String get excelExportFieldCurrentPrice;

  /// No description provided for @excelExportFieldProductId.
  ///
  /// In es, this message translates to:
  /// **'ID producto'**
  String get excelExportFieldProductId;

  /// No description provided for @excelExportFieldProductName.
  ///
  /// In es, this message translates to:
  /// **'Nombre producto'**
  String get excelExportFieldProductName;

  /// No description provided for @excelExportFieldAmount.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get excelExportFieldAmount;

  /// No description provided for @excelExportFieldQuantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get excelExportFieldQuantity;

  /// No description provided for @excelExportFieldChannel.
  ///
  /// In es, this message translates to:
  /// **'Canal'**
  String get excelExportFieldChannel;

  /// No description provided for @excelExportFieldCreatedAt.
  ///
  /// In es, this message translates to:
  /// **'Fecha creacion'**
  String get excelExportFieldCreatedAt;

  /// No description provided for @excelExportFieldPrice.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get excelExportFieldPrice;

  /// No description provided for @excelExportFieldRecordedAt.
  ///
  /// In es, this message translates to:
  /// **'Fecha registro'**
  String get excelExportFieldRecordedAt;

  /// No description provided for @excelExportFieldStrategyTags.
  ///
  /// In es, this message translates to:
  /// **'Etiquetas de estrategia'**
  String get excelExportFieldStrategyTags;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
