// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cosecha';

  @override
  String get errorTitle => 'Error';

  @override
  String get backButton => 'Back';

  @override
  String get invalidProductMessage => 'The product is invalid.';

  @override
  String get homeTitle => 'Home';

  @override
  String get counterMessage => 'You have pushed the button this many times:';

  @override
  String get counterIncrementTooltip => 'Increment';

  @override
  String get onboardingSlide1Title => 'Record your sales';

  @override
  String get onboardingSlide1Description =>
      'Quickly and easily record every sale. All your information is securely stored on your device.';

  @override
  String get onboardingSlide2Title => 'Organize your business';

  @override
  String get onboardingSlide2Description =>
      'Manage products, prices, and transactions in one place. Stay in control without complicated processes.';

  @override
  String get onboardingSlide3Title => 'Understand your results';

  @override
  String get onboardingSlide3Description =>
      'Customize your home with widgets and presets to focus only on what matters.';

  @override
  String get onboardingSlide4Title => 'Analyze with reports';

  @override
  String get onboardingSlide4Description =>
      'Filter by channel, product, amount, and quantity to spot changes and opportunities quickly.';

  @override
  String get onboardingSlide5Title => 'Export to Excel';

  @override
  String get onboardingSlide5Description =>
      'Configure models and fields to export. By default, you can export everything in one tap.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get businessProfileTitle => 'Business profile';

  @override
  String get businessNameLabel => 'Name';

  @override
  String get businessImageUrlLabel => 'Image';

  @override
  String get businessCurrencyLabel => 'Currency';

  @override
  String get businessCurrencyOtherLabel => 'Other currency';

  @override
  String get businessCurrencySymbolLabel => 'Symbol (optional)';

  @override
  String get currencyNameUsd => 'US Dollar';

  @override
  String get currencyNameEur => 'Euro';

  @override
  String get currencyNamePen => 'Peruvian sol';

  @override
  String get currencyNameMxn => 'Mexican peso';

  @override
  String get currencyNameCop => 'Colombian peso';

  @override
  String get businessSave => 'Save';

  @override
  String get imagePickerCamera => 'Take photo';

  @override
  String get imagePickerGallery => 'Choose from gallery';

  @override
  String get imagePickerRemove => 'Remove';

  @override
  String get profileSetupTitle => 'Set up your business';

  @override
  String get profileEditTitle => 'Edit business';

  @override
  String get profileSetupNameLabel => 'Business name';

  @override
  String get profileSetupNameRequired => 'Name is required.';

  @override
  String profileSetupNameMin(Object min) {
    return 'Must be at least $min characters.';
  }

  @override
  String get profileSetupLogoRequired => 'Logo is required.';

  @override
  String get profileSetupCurrencyLabel => 'Currency';

  @override
  String get profileSetupCurrencyHint => 'Select your currency';

  @override
  String get profileSetupCurrencyOtherOption => 'Other (custom)...';

  @override
  String get profileSetupCurrencyRequired => 'You must select a currency.';

  @override
  String get profileSetupCustomSymbolLabel => 'Currency symbol (e.g. \$)';

  @override
  String get profileSetupCustomSymbolRequired => 'Symbol is required.';

  @override
  String get profileSetupCustomCodeLabel => 'Currency code (e.g. USD)';

  @override
  String get profileSetupCustomCodeRequired => 'Code is required.';

  @override
  String get profileSetupSaveContinue => 'Save and continue';

  @override
  String get profileSave => 'Save';

  @override
  String get profileSetupSaveError => 'Failed to save profile';

  @override
  String get productsTitle => 'Products';

  @override
  String get productEditTitle => 'Edit product';

  @override
  String get productAddTitle => 'Add product';

  @override
  String get productActionSave => 'Save';

  @override
  String get productActionCreate => 'Create';

  @override
  String get productImageLabel => 'Product image';

  @override
  String get productNameLabel => 'Product name';

  @override
  String get productNameHint => 'Organic watermelon (premium)';

  @override
  String get productNameRequired => 'Name is required.';

  @override
  String productNameMin(Object min) {
    return 'Must be at least $min characters.';
  }

  @override
  String get productDescriptionLabel => 'Description';

  @override
  String get productDescriptionHint =>
      'Fresh harvest, 2–3 kg per unit. Packed for local delivery.';

  @override
  String get productPriceLabel => 'Base price';

  @override
  String get productPriceHint => '189.99';

  @override
  String get productPriceRequired => 'Price is required.';

  @override
  String get productPriceInvalid => 'Enter a valid price.';

  @override
  String get productUpdatePrice => 'Update price';

  @override
  String get productPricePerformanceTitle => 'Price performance';

  @override
  String productPricePerformanceChart(Object range) {
    return 'Chart ($range)';
  }

  @override
  String get productAddButton => 'Add product';

  @override
  String get productSaving => 'Saving...';

  @override
  String get productSaveError => 'Failed to save product';

  @override
  String get productsEmptyTitle => 'No products yet';

  @override
  String get productsEmptyDescription =>
      'Add your first product to start tracking sales and prices.';

  @override
  String get productsEmptyAction => 'Add product';

  @override
  String get productsSearchHint => 'Search products...';

  @override
  String get homeSectionDashboard => 'DASHBOARD';

  @override
  String get homeProductOverview => 'Product Overview';

  @override
  String get homePerformanceOverview => 'PERFORMANCE OVERVIEW';

  @override
  String get homeToday => 'Today';

  @override
  String get homeThisWeek => 'This week';

  @override
  String get homeThisMonth => 'This month';

  @override
  String get homeQuickSale => 'QUICK SALE';

  @override
  String get homeAddSale => 'Add sale';

  @override
  String get homeRecentSales => 'Recent product sales';

  @override
  String get homeCustomizeTitle => 'Customize home widgets';

  @override
  String get homeCustomizePresetsTitle => 'Presets';

  @override
  String get homePresetBasic => 'Basic';

  @override
  String get homePresetCommercial => 'Commercial';

  @override
  String get homePresetAnalytical => 'Analytical';

  @override
  String get homeWidgetSalesGoal => 'Sales goal';

  @override
  String get homeWidgetQuickActions => 'Quick actions';

  @override
  String get homeWidgetChannelMix => 'Channel mix';

  @override
  String get homeWidgetAvgTicketTrend => 'Avg. ticket trend';

  @override
  String get homeWidgetProductsAtRisk => 'Products at risk';

  @override
  String get homeWidgetWeeklyActivity => 'Weekly activity';

  @override
  String get homeWidgetWeeklyInsights => 'Weekly insights';

  @override
  String get homeQuickActionsTitle => 'Quick actions';

  @override
  String get homeQuickActionsSubtitle => 'Shortcuts for frequent tasks';

  @override
  String get homeActionNewSale => 'New sale';

  @override
  String get homeActionSalesHistory => 'History';

  @override
  String get homeActionReports => 'Reports';

  @override
  String get homeActionBackup => 'Backup';

  @override
  String get homeActionViewProducts => 'View products';

  @override
  String get homeSalesGoalTitle => 'Monthly goal progress';

  @override
  String get homeSalesGoalSubtitle => 'Current month vs estimated goal';

  @override
  String homeSalesGoalOf(Object goal) {
    return 'of $goal';
  }

  @override
  String get homeNoSalesData => 'No sales data available.';

  @override
  String get homeChannelMixTitle => 'Channel mix';

  @override
  String get homeChannelMixSubtitle => 'Sales split in the last 30 days';

  @override
  String get homeAvgTicketTitle => 'Average ticket';

  @override
  String get homeAvgTicketSubtitle => 'Last 7 days vs previous 7 days';

  @override
  String homeAvgTicketTransactions(Object count) {
    return '$count transactions in the period';
  }

  @override
  String get homeWeeklyActivityTitle => 'Weekly activity';

  @override
  String get homeWeeklyActivitySubtitle => 'Transactions by day (last 7 days)';

  @override
  String get homeProductsAtRiskTitle => 'Products at risk';

  @override
  String get homeProductsAtRiskSubtitle => 'No sales in the last 21 days';

  @override
  String get homeProductsAtRiskEmpty => 'No products at risk right now.';

  @override
  String get homeProductsAtRiskNoSales => 'No recorded sales';

  @override
  String homeProductsAtRiskDaysNoSales(Object days) {
    return '$days days without sales';
  }

  @override
  String get homeWeeklyInsightsTitle => 'Weekly insights';

  @override
  String get homeWeeklyInsightsSubtitle =>
      'Automatic summary of the last 7 days';

  @override
  String get homeInsightDirectionUp => 'Up';

  @override
  String get homeInsightDirectionDown => 'Down';

  @override
  String homeInsightRevenueDelta(
    Object direction,
    Object percent,
    Object amount,
  ) {
    return '$direction sales $percent ($amount) vs previous week';
  }

  @override
  String homeInsightChannelShift(Object channel, Object percent) {
    return '$channel channel gains share ($percent)';
  }

  @override
  String homeInsightTopProduct(Object product) {
    return 'Top product: $product';
  }

  @override
  String get homeInsightNoSignificantChange =>
      'No significant changes this week.';

  @override
  String get homeSeeHistory => 'See history';

  @override
  String homeHoursAgo(Object hours) {
    return '$hours HOURS AGO';
  }

  @override
  String get homeYesterday => 'YESTERDAY';

  @override
  String get navSales => 'Sales';

  @override
  String get navReports => 'Reports';

  @override
  String get navProducts => 'Products';

  @override
  String get navSettings => 'Settings';

  @override
  String get comingSoonTitle => 'Coming soon';

  @override
  String get comingSoonMessage => 'We are working on this section.';

  @override
  String get comingSoonError => 'Invalid section';

  @override
  String get salesHistoryTitle => 'Sales history';

  @override
  String get salesRange1H => '1H';

  @override
  String get salesRange1D => '1D';

  @override
  String get salesRange1W => '1W';

  @override
  String get salesRange1M => '1M';

  @override
  String get salesEmptyTitle => 'No sales yet';

  @override
  String get salesEmptyDescription => 'Add your first sale to see the history.';

  @override
  String get salesEmptyAction => 'Add sale';

  @override
  String get salesToday => 'TODAY';

  @override
  String get salesYesterday => 'YESTERDAY';

  @override
  String get salesAddTitle => 'Add sale';

  @override
  String get salesProductImage => 'Product image';

  @override
  String get salesProductName => 'Product';

  @override
  String get salesProductNameRequired => 'Product is required.';

  @override
  String get salesQuantity => 'Quantity';

  @override
  String get salesQuantityRequired => 'Quantity is required.';

  @override
  String get salesAmount => 'Amount';

  @override
  String get salesAmountRequired => 'Amount is required.';

  @override
  String get salesChannel => 'Channel';

  @override
  String get salesChannelRequired => 'Select a channel.';

  @override
  String get salesChannelRetail => 'Retail';

  @override
  String get salesChannelWholesale => 'Wholesale';

  @override
  String get salesFiltersAll => 'All';

  @override
  String get salesFiltersSort => 'Sort';

  @override
  String get salesSortLatest => 'Most recent';

  @override
  String get salesSortHighestAmount => 'Highest amount';

  @override
  String get salesSortHighestQuantity => 'Highest quantity';

  @override
  String get salesFiltersClear => 'Clear';

  @override
  String get salesFiltersApply => 'Apply';

  @override
  String get salesSave => 'Save sale';

  @override
  String get salesSaving => 'Saving...';

  @override
  String get salesSaveError => 'Failed to save sale';

  @override
  String get homeRecentEmpty => 'No recent sales yet.';

  @override
  String get homeQuickAddProducts => 'Add products';

  @override
  String get salesProductSelect => 'Select a product';

  @override
  String get salesSearchHint => 'Search products...';

  @override
  String get salesChangeProduct => 'Change';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppName => 'Cosecha';

  @override
  String get settingsAppVersion => 'v1.0.0(1)';

  @override
  String get settingsAppTagline => 'Sales and product control';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsBusinessTitle => 'Business';

  @override
  String get settingsBusinessSubtitle => 'Update business details';

  @override
  String get settingsBackupTitle => 'Data & Backup';

  @override
  String get settingsBackupSubtitle => 'Backups and Export Excel';

  @override
  String get dataBackupTitle => 'Data & Backup';

  @override
  String get dataBackupSummaryTitle => 'Summary';

  @override
  String get dataBackupProducts => 'Products';

  @override
  String get dataBackupSales => 'Sales';

  @override
  String get dataBackupPriceHistory => 'Price history';

  @override
  String get dataBackupActionsTitle => 'Actions';

  @override
  String get dataBackupExportExcel => 'Export to Excel';

  @override
  String get dataBackupExportConfig => 'Configure Excel export';

  @override
  String get dataBackupExportEncrypted => 'Export encrypted backup';

  @override
  String get dataBackupRestore => 'Restore backup';

  @override
  String get dataBackupExportExcelSoon =>
      'Excel export will be available soon.';

  @override
  String get dataBackupExportEncryptedSoon =>
      'Encrypted backup will be available soon.';

  @override
  String get dataBackupRestoreSoon => 'Restore will be available soon.';

  @override
  String get dataBackupExported => 'Excel file saved';

  @override
  String get dataBackupEncryptedExported => 'Encrypted backup saved';

  @override
  String get dataBackupRestoreSuccess => 'Backup restored successfully.';

  @override
  String get dataBackupRestoreError => 'Failed to restore backup.';

  @override
  String get dataBackupPasswordTitle => 'Backup password';

  @override
  String get dataBackupPasswordLabel => 'Password';

  @override
  String get dataBackupExporting => 'Exporting to Excel...';

  @override
  String get dataBackupEncrypting => 'Generating encrypted backup...';

  @override
  String get dataBackupRestoring => 'Restoring backup...';

  @override
  String get dataBackupRestoreConfirmTitle => 'Restore backup';

  @override
  String get dataBackupRestoreConfirmBody =>
      'This will replace all current data. Do you want to continue?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get settingsSectionAbout => 'About';

  @override
  String get settingsOriginTitle => 'Our story';

  @override
  String get settingsOriginBody =>
      'This app started when I saw my friend and partner Michael “Micha” writing every sale in a notebook. I wanted to help him take control of his business with a simple, fast tool built for his day-to-day. Cosecha is that daily support to sell with clarity and decide with confidence.';

  @override
  String get settingsDeveloperTitle => 'Developer';

  @override
  String get settingsDeveloperSubtitle => 'Built with privacy in mind';

  @override
  String get developerTitle => 'Developer';

  @override
  String get developerHandle => '@christhoval';

  @override
  String get developerRole => 'Software Engineer · Technical Writer';

  @override
  String get developerBioTitle => 'About';

  @override
  String get developerBioBody =>
      'Software engineer and technical writer based in Panama.';

  @override
  String get developerFocusTitle => 'Focus';

  @override
  String get developerFocusBody =>
      'Building apps, APIs, and product‑focused tools.';

  @override
  String get developerLeadershipTitle => 'Leadership';

  @override
  String get developerLeadershipBody =>
      '10+ years building software and leading teams.';

  @override
  String get developerTechTitle => 'Technologies';

  @override
  String get developerTechBody =>
      'TypeScript, Node.js, React, Flutter, Python, PostgreSQL, and MongoDB.';

  @override
  String get developerWebsite => 'Website';

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
  String get settingsSupportTitle => 'Contact / Support';

  @override
  String get settingsSupportSubtitle => 'Report bugs or suggest ideas';

  @override
  String get supportEmail => 'support@cosecha.app';

  @override
  String get supportSubject => 'Improvement suggestions';

  @override
  String get supportBody => 'Hi team, I have a suggestion to improve the app:';

  @override
  String get settingsSectionDanger => 'Danger zone';

  @override
  String get settingsResetTitle => 'Reset App';

  @override
  String get settingsResetSubtitle => 'Delete all data and restart';

  @override
  String get settingsResetConfirmTitle => 'Reset app';

  @override
  String get settingsResetConfirmBody =>
      'This action will delete all your data. Do you want to continue?';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsCustomizeTitle => 'Customize widgets';

  @override
  String get reportsCustomizePresetsTitle => 'Presets';

  @override
  String get reportsPresetBasic => 'Basic';

  @override
  String get reportsPresetCommercial => 'Commercial';

  @override
  String get reportsPresetAnalytical => 'Analytical';

  @override
  String get reportsWidgetExportTools => 'Export tools';

  @override
  String get reportsWidgetSummary => 'Summary';

  @override
  String get reportsWidgetPeriodComparison => 'Period comparison';

  @override
  String get reportsWidgetTotalSalesTrend => 'Total sales trend';

  @override
  String get reportsWidgetChannelMix => 'Channel mix';

  @override
  String get reportsWidgetMonthlySales => 'Monthly sales';

  @override
  String get reportsWidgetDailyHeatmap => 'Daily heatmap';

  @override
  String get reportsWidgetTopProducts => 'Top products';

  @override
  String get reportsWidgetBottomProducts => 'Bottom products';

  @override
  String get reportsPeriodComparisonTitle => 'Period comparison';

  @override
  String get reportsPeriodComparisonSubtitle =>
      'Current range vs previous range';

  @override
  String get reportsChannelMixTitle => 'Sales by channel';

  @override
  String get reportsChannelMixSubtitle => 'Channel share in selected range';

  @override
  String get reportsChannelOther => 'Other';

  @override
  String get reportsExportToolsTitle => 'Excel export';

  @override
  String get reportsExportToolsSubtitle =>
      'Configure fields and export current data';

  @override
  String get reportsFilterAmountRange => 'Amount range';

  @override
  String get reportsFilterMinAmount => 'Min amount';

  @override
  String get reportsFilterMaxAmount => 'Max amount';

  @override
  String get reportsFilterMinQuantity => 'Min quantity';

  @override
  String get reportsTopProducts => 'Top products';

  @override
  String get reportsBottomProducts => 'Bottom products';

  @override
  String get reportsTopEmpty => 'No sales in this range.';

  @override
  String get reportsTotalSales => 'Total sales';

  @override
  String get reportsMonthlySalesLast6 => 'Monthly sales (last 6 months)';

  @override
  String get reportsDailyHeatmap => 'Daily activity heatmap';

  @override
  String get reportsTransactions => 'Transactions';

  @override
  String get reportsAvgTicket => 'Avg. ticket';

  @override
  String get reportsUnits => 'units';

  @override
  String get excelExportConfigTitle => 'Excel export settings';

  @override
  String get excelExportModelProducts => 'Products';

  @override
  String get excelExportModelSales => 'Sales';

  @override
  String get excelExportModelPriceHistory => 'Price history';

  @override
  String get excelExportFieldId => 'ID';

  @override
  String get excelExportFieldName => 'Name';

  @override
  String get excelExportFieldImageUrl => 'Image URL';

  @override
  String get excelExportFieldCurrentPrice => 'Current price';

  @override
  String get excelExportFieldProductId => 'Product ID';

  @override
  String get excelExportFieldProductName => 'Product name';

  @override
  String get excelExportFieldAmount => 'Amount';

  @override
  String get excelExportFieldQuantity => 'Quantity';

  @override
  String get excelExportFieldChannel => 'Channel';

  @override
  String get excelExportFieldCreatedAt => 'Created at';

  @override
  String get excelExportFieldPrice => 'Price';

  @override
  String get excelExportFieldRecordedAt => 'Recorded at';
}
