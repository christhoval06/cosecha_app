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
- Performance overview, trends, and reports
- Local-first storage with optional encrypted backups
- Business profile with currency preferences

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
