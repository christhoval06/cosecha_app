# Cosecha

Cosecha is a simple, fast sales tracker for small businesses. It helps you
register products, record sales, and understand performance without needing
external servers or complex setups.

## Why It Exists

This app was born from a real need. My friend and business partner Michael
“Micha” used to write every sale in a notebook. I wanted to help him keep
control of his business with a tool built for his daily flow. Cosecha is that
support: clear, practical, and designed for real-world selling.

## Features

- Product management with local images
- Sales tracking with quick add and history
- Home dashboard with configurable widgets and presets
- Reports dashboard with configurable widgets and presets
- Advanced report filters (channel, product, amount range, min quantity)
- Performance overview, trends, heatmap, and monthly bars
- Configurable Excel export (models/fields), shared across Reports and Settings
- Local-first storage with optional encrypted backups
- Business profile with currency preferences
- Multi-language support (EN/ES) with `gen-l10n`

## Directory Layout

```text
lib/
  core/
    constants/
    router/
    services/
    theme/
    utils/
    widgets/
  data/
    hive/
    models/
    repositories/
  features/
    business/
    home/
    onboarding/
    products/
    reports/
    settings/
    transactions/
  l10n/
  main.dart
```

## Tech Stack

- Flutter + Material 3
- Hive for local data
- FormBuilder for input flows
- Share Plus, Excel export, and encryption utilities

## Tooling & Libraries

- `hive` + `hive_flutter` for local persistence
- `flutter_form_builder` + `form_builder_validators` for forms
- `image_picker` for photo capture and gallery access
- `share_plus` for exports
- `excel` for spreadsheet export
- `cryptography` for encrypted backups
- `flutter_heatmap_calendar` and `fl_chart` for reports
- `package_info_plus` and `url_launcher` for settings/links
- `intl` for formatting

## Architecture Notes

- Local-first: data is stored on-device using Hive.
- One business profile: cached in a session singleton for fast access.
- Price changes create history records for trend charts.
- i18n managed via `lib/l10n/*.arb` and `flutter gen-l10n`.
- App routing is centralized in `lib/core/router/app_router.dart`.
- Dashboard pattern used in Home and Reports:
  - `registry`: available widget definitions (`id/title/builder`)
  - `config`: persisted enabled/order state (`SharedPreferences`)
  - `customize sheet`: toggle, reorder, and presets
  - `panels`: widget logic isolated in dedicated files
- Excel export is centralized in `lib/core/services/excel_export_service.dart`:
  - Shared configuration (models + fields) with defaults to export all
  - Reused by Reports and Data Backup screens via a shared sheet

## Internal References

- Dashboard architecture guide:
  - `DASHBOARD_ARCHITECTURE.md`
- Home roadmap/status:
  - `HOME_SUGERENCIAS.md`
- Reports roadmap/status:
  - `REPORTES_SUGERENCIAS.md`

## Getting Started

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Get packages:
   ```bash
   flutter pub get
   ```
3. Generate localizations (if you updated `lib/l10n/*.arb`):
   ```bash
   flutter gen-l10n
   ```
4. Run the app:
   ```bash
   flutter run
   ```
