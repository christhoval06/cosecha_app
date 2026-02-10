// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cosecha';

  @override
  String get errorTitle => 'Error';

  @override
  String get backButton => 'Volver';

  @override
  String get invalidProductMessage => 'El producto no es válido.';

  @override
  String get homeTitle => 'Inicio';

  @override
  String get counterMessage =>
      'Has presionado el botón esta cantidad de veces:';

  @override
  String get counterIncrementTooltip => 'Incrementar';

  @override
  String get onboardingSlide1Title => 'Registra tus ventas';

  @override
  String get onboardingSlide1Description =>
      'Anota cada venta de forma rápida y sencilla. Toda tu información queda guardada de forma segura en tu dispositivo.';

  @override
  String get onboardingSlide2Title => 'Organiza tu negocio';

  @override
  String get onboardingSlide2Description =>
      'Gestiona productos, precios y movimientos en un solo lugar. Mantén el control sin procesos complicados.';

  @override
  String get onboardingSlide3Title => 'Entiende tus resultados';

  @override
  String get onboardingSlide3Description =>
      'Consulta estadísticas claras sobre ingresos y ventas. Toma mejores decisiones con datos reales.';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingStart => 'Comenzar';

  @override
  String get businessProfileTitle => 'Perfil del negocio';

  @override
  String get businessNameLabel => 'Nombre';

  @override
  String get businessImageUrlLabel => 'Imagen';

  @override
  String get businessCurrencyLabel => 'Moneda';

  @override
  String get businessCurrencyOtherLabel => 'Otra moneda';

  @override
  String get businessCurrencySymbolLabel => 'Símbolo (opcional)';

  @override
  String get currencyNameUsd => 'Dólar estadounidense';

  @override
  String get currencyNameEur => 'Euro';

  @override
  String get currencyNamePen => 'Sol peruano';

  @override
  String get currencyNameMxn => 'Peso mexicano';

  @override
  String get currencyNameCop => 'Peso colombiano';

  @override
  String get businessSave => 'Guardar';

  @override
  String get imagePickerCamera => 'Tomar foto';

  @override
  String get imagePickerGallery => 'Elegir de galería';

  @override
  String get imagePickerRemove => 'Quitar';

  @override
  String get profileSetupTitle => 'Configura tu Negocio';

  @override
  String get profileEditTitle => 'Editar negocio';

  @override
  String get profileSetupNameLabel => 'Nombre del negocio';

  @override
  String get profileSetupNameRequired => 'El nombre es obligatorio.';

  @override
  String profileSetupNameMin(Object min) {
    return 'Debe tener al menos $min caracteres.';
  }

  @override
  String get profileSetupLogoRequired => 'El logo es obligatorio.';

  @override
  String get profileSetupCurrencyLabel => 'Moneda';

  @override
  String get profileSetupCurrencyHint => 'Selecciona tu moneda';

  @override
  String get profileSetupCurrencyOtherOption => 'Otra (personalizada)...';

  @override
  String get profileSetupCurrencyRequired => 'Debes seleccionar una moneda.';

  @override
  String get profileSetupCustomSymbolLabel => 'Símbolo de la moneda (ej: S/)';

  @override
  String get profileSetupCustomSymbolRequired => 'El símbolo es obligatorio.';

  @override
  String get profileSetupCustomCodeLabel => 'Código de la moneda (ej: PEN)';

  @override
  String get profileSetupCustomCodeRequired => 'El código es obligatorio.';

  @override
  String get profileSetupSaveContinue => 'Guardar y continuar';

  @override
  String get profileSave => 'Guardar';

  @override
  String get profileSetupSaveError => 'Error al guardar el perfil';

  @override
  String get productsTitle => 'Productos';

  @override
  String get productEditTitle => 'Editar producto';

  @override
  String get productAddTitle => 'Agregar producto';

  @override
  String get productActionSave => 'Guardar';

  @override
  String get productActionCreate => 'Crear';

  @override
  String get productImageLabel => 'Imagen del producto';

  @override
  String get productNameLabel => 'Nombre del producto';

  @override
  String get productNameHint => 'Sandía orgánica (premium)';

  @override
  String get productNameRequired => 'El nombre es obligatorio.';

  @override
  String productNameMin(Object min) {
    return 'Debe tener al menos $min caracteres.';
  }

  @override
  String get productDescriptionLabel => 'Descripción';

  @override
  String get productDescriptionHint =>
      'Cosecha fresca, 2–3 kg por unidad. Empaque para entrega local.';

  @override
  String get productPriceLabel => 'Precio base';

  @override
  String get productPriceHint => '189.99';

  @override
  String get productPriceRequired => 'El precio es obligatorio.';

  @override
  String get productPriceInvalid => 'Ingresa un precio válido.';

  @override
  String get productUpdatePrice => 'Actualizar precio';

  @override
  String get productPricePerformanceTitle => 'Rendimiento del precio';

  @override
  String productPricePerformanceChart(Object range) {
    return 'Gráfico ($range)';
  }

  @override
  String get productAddButton => 'Agregar producto';

  @override
  String get productSaving => 'Guardando...';

  @override
  String get productSaveError => 'Error al guardar el producto';

  @override
  String get productsEmptyTitle => 'Aún no tienes productos';

  @override
  String get productsEmptyDescription =>
      'Agrega tu primer producto para comenzar a registrar ventas y precios.';

  @override
  String get productsEmptyAction => 'Agregar producto';

  @override
  String get productsSearchHint => 'Buscar producto...';

  @override
  String get homeSectionDashboard => 'DASHBOARD';

  @override
  String get homeProductOverview => 'Product Overview';

  @override
  String get homePerformanceOverview => 'RESUMEN DE RENDIMIENTO';

  @override
  String get homeToday => 'Hoy';

  @override
  String get homeThisWeek => 'Esta semana';

  @override
  String get homeThisMonth => 'Este mes';

  @override
  String get homeQuickSale => 'VENTA RÁPIDA';

  @override
  String get homeAddSale => 'Agregar venta';

  @override
  String get homeRecentSales => 'Ventas recientes';

  @override
  String get homeSeeHistory => 'Ver historial';

  @override
  String homeHoursAgo(Object hours) {
    return 'HACE $hours HORAS';
  }

  @override
  String get homeYesterday => 'AYER';

  @override
  String get navSales => 'Ventas';

  @override
  String get navReports => 'Reportes';

  @override
  String get navProducts => 'Productos';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get comingSoonTitle => 'Muy pronto';

  @override
  String get comingSoonMessage => 'Estamos trabajando en esta sección.';

  @override
  String get comingSoonError => 'Sección inválida';

  @override
  String get salesHistoryTitle => 'Historial de ventas';

  @override
  String get salesRange1H => '1H';

  @override
  String get salesRange1D => '1D';

  @override
  String get salesRange1W => '1S';

  @override
  String get salesRange1M => '1M';

  @override
  String get salesEmptyTitle => 'Aún no hay ventas';

  @override
  String get salesEmptyDescription =>
      'Agrega tu primera venta para ver el historial.';

  @override
  String get salesEmptyAction => 'Agregar venta';

  @override
  String get salesToday => 'HOY';

  @override
  String get salesYesterday => 'AYER';

  @override
  String get salesAddTitle => 'Agregar venta';

  @override
  String get salesProductImage => 'Imagen del producto';

  @override
  String get salesProductName => 'Producto';

  @override
  String get salesProductNameRequired => 'El producto es obligatorio.';

  @override
  String get salesQuantity => 'Cantidad';

  @override
  String get salesQuantityRequired => 'La cantidad es obligatoria.';

  @override
  String get salesAmount => 'Monto';

  @override
  String get salesAmountRequired => 'El monto es obligatorio.';

  @override
  String get salesChannel => 'Canal';

  @override
  String get salesChannelRequired => 'Selecciona un canal.';

  @override
  String get salesChannelRetail => 'Minorista';

  @override
  String get salesChannelWholesale => 'Mayorista';

  @override
  String get salesSave => 'Guardar venta';

  @override
  String get salesSaving => 'Guardando...';

  @override
  String get salesSaveError => 'Error al guardar la venta';

  @override
  String get homeRecentEmpty => 'Aún no hay ventas recientes.';

  @override
  String get homeQuickAddProducts => 'Agregar productos';

  @override
  String get salesProductSelect => 'Selecciona un producto';

  @override
  String get salesSearchHint => 'Buscar productos...';

  @override
  String get salesChangeProduct => 'Cambiar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsAppName => 'Cosecha';

  @override
  String get settingsAppVersion => 'v1.0.0(1)';

  @override
  String get settingsAppTagline => 'Control de ventas y productos';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsBusinessTitle => 'Negocio';

  @override
  String get settingsBusinessSubtitle => 'Actualizar datos del negocio';

  @override
  String get settingsBackupTitle => 'Datos y Respaldo';

  @override
  String get settingsBackupSubtitle => 'Copias de seguridad y Exportar Excel';

  @override
  String get dataBackupTitle => 'Datos y Respaldo';

  @override
  String get dataBackupSummaryTitle => 'Resumen';

  @override
  String get dataBackupProducts => 'Productos';

  @override
  String get dataBackupSales => 'Ventas';

  @override
  String get dataBackupPriceHistory => 'Historial de precios';

  @override
  String get dataBackupActionsTitle => 'Acciones';

  @override
  String get dataBackupExportExcel => 'Exportar a Excel';

  @override
  String get dataBackupExportEncrypted => 'Exportar respaldo encriptado';

  @override
  String get dataBackupRestore => 'Restaurar respaldo';

  @override
  String get dataBackupExportExcelSoon =>
      'Exportar a Excel estará disponible pronto.';

  @override
  String get dataBackupExportEncryptedSoon =>
      'El respaldo encriptado estará disponible pronto.';

  @override
  String get dataBackupRestoreSoon =>
      'La restauración estará disponible pronto.';

  @override
  String get dataBackupExported => 'Archivo Excel guardado';

  @override
  String get dataBackupEncryptedExported => 'Respaldo encriptado guardado';

  @override
  String get dataBackupRestoreSuccess => 'Respaldo restaurado con éxito.';

  @override
  String get dataBackupRestoreError => 'No se pudo restaurar el respaldo.';

  @override
  String get dataBackupPasswordTitle => 'Contraseña de respaldo';

  @override
  String get dataBackupPasswordLabel => 'Contraseña';

  @override
  String get dataBackupExporting => 'Exportando a Excel...';

  @override
  String get dataBackupEncrypting => 'Generando respaldo encriptado...';

  @override
  String get dataBackupRestoring => 'Restaurando respaldo...';

  @override
  String get dataBackupRestoreConfirmTitle => 'Restaurar respaldo';

  @override
  String get dataBackupRestoreConfirmBody =>
      'Esto reemplazará todos los datos actuales. ¿Deseas continuar?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsOriginTitle => 'Nuestra historia';

  @override
  String get settingsOriginBody =>
      'Esta app nació al ver a mi amigo y socio Michael “Micha” anotar cada venta en una libreta. Quise ayudarlo a tener el control de su negocio con una herramienta simple, rápida y hecha a su medida. Cosecha es ese apoyo diario para vender con claridad y decidir con confianza.';

  @override
  String get settingsDeveloperTitle => 'Desarrollador';

  @override
  String get settingsDeveloperSubtitle => 'Creado con privacidad en mente';

  @override
  String get developerTitle => 'Desarrollador';

  @override
  String get developerHandle => '@christhoval';

  @override
  String get developerRole => 'Software Engineer · Technical Writer';

  @override
  String get developerBioTitle => 'Sobre mí';

  @override
  String get developerBioBody =>
      'Ingeniero de software y escritor técnico con sede en Panamá.';

  @override
  String get developerFocusTitle => 'Enfoque';

  @override
  String get developerFocusBody =>
      'Desarrollo de apps, APIs y herramientas orientadas a producto.';

  @override
  String get developerLeadershipTitle => 'Liderazgo';

  @override
  String get developerLeadershipBody =>
      'Más de 10 años creando software y liderando equipos.';

  @override
  String get developerTechTitle => 'Tecnologías';

  @override
  String get developerTechBody =>
      'TypeScript, Node.js, React, Flutter, Python, PostgreSQL y MongoDB.';

  @override
  String get developerWebsite => 'Sitio web';

  @override
  String get developerWebsiteUrl => 'https://s.christhoval.dev/';

  @override
  String get developerGitHub => 'GitHub';

  @override
  String get developerGithubUrl => 'https://github.com/christhoval';

  @override
  String get developerLinkedIn => 'LinkedIn';

  @override
  String get developerLinkedinUrl => 'https://www.linkedin.com/in/christhoval/';

  @override
  String get settingsSupportTitle => 'Contacto / Soporte';

  @override
  String get settingsSupportSubtitle => 'Reportar bugs o sugerir ideas';

  @override
  String get supportEmail => 'soporte@cosecha.app';

  @override
  String get supportSubject => 'Sugerencias de mejora';

  @override
  String get supportBody =>
      'Hola equipo, tengo una sugerencia para mejorar la app:';

  @override
  String get settingsSectionDanger => 'Zona de peligro';

  @override
  String get settingsResetTitle => 'Restablecer App';

  @override
  String get settingsResetSubtitle => 'Borrar todos los datos y reiniciar';

  @override
  String get settingsResetConfirmTitle => 'Restablecer app';

  @override
  String get settingsResetConfirmBody =>
      'Esta acción eliminará todos tus datos. ¿Deseas continuar?';

  @override
  String get reportsTitle => 'Reportes';

  @override
  String get reportsTopProducts => 'Top productos';

  @override
  String get reportsTopEmpty => 'No hay ventas en este rango.';

  @override
  String get reportsTotalSales => 'Total ventas';

  @override
  String get reportsMonthlySalesLast6 => 'Ventas mensuales (últimos 6 meses)';

  @override
  String get reportsDailyHeatmap => 'Mapa de calor diario';

  @override
  String get reportsTransactions => 'Transacciones';

  @override
  String get reportsAvgTicket => 'Ticket promedio';

  @override
  String get reportsUnits => 'unidades';
}
