# Cosecha Features

## Core Features
- Business profile with logo and currency (single business session).
- Product management with images stored locally.
- Automatic price history tracking for every price change.
- Sales recording with quick add and product preselection.
- Local-first storage with Hive (no external server required).

## Sales & Insights
- Quick sale shortcuts for top products.
- Sales history with time filters (1H, 1D, 1W, 1M) and grouped sections.
- Performance overview and trend indicators.
- Reports dashboard with sparkline trends and heatmap.
- Top products by sales in selected ranges.

## Data & Backup
- Excel export for products and sales.
- Encrypted backup (AES-GCM) with restore flow.
- Full app reset with confirmation.
- Backup reminder with configurable tap destination.

## Notifications & Reminders
- Custom reminders (max 10) persisted in Hive.
- Per-reminder setup: title, description, label, weekdays, time, enabled/disabled.
- Optional navigation destination when tapping a reminder notification.
- Destination registry centralized in `ReminderDestinations` for backup and custom reminder notifications.

## UX & UI
- Onboarding flow with multiple slides.
- Centralized theme and localization (ES/EN).
- Reusable empty states and pickers.
- Custom bottom navigation with animated indicator.

## Utilities
- Currency formatting and relative time helpers.
- Image picker widgets with camera/gallery support.
- Centralized routing and Hive initialization.

## Roadmap
- Multi-business support with switcher.
- Advanced filters and tags for products/sales.
- Cloud sync (optional, end-to-end encrypted).
- PDF and CSV exports.
- Dashboard widgets and notifications.
