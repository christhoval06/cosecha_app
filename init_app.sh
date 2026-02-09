#!/bin/bash

APP_NAME="cosecha_app"
LIB_PATH="$APP_NAME/lib"

echo "🌱 Creando estructura base de $APP_NAME..."

mkdir -p $LIB_PATH/core/{theme,i18n,constants,utils,services}
mkdir -p $LIB_PATH/data/hive/{adapters}
mkdir -p $LIB_PATH/data/{models,repositories}
mkdir -p $LIB_PATH/features/{onboarding,business,products,transactions,stats,export}

touch $LIB_PATH/core/theme/app_theme.dart
touch $LIB_PATH/core/i18n/app_localizations.dart
touch $LIB_PATH/core/constants/app_constants.dart
touch $LIB_PATH/core/utils/date_utils.dart
touch $LIB_PATH/core/services/logger_service.dart

touch $LIB_PATH/data/hive/hive_init.dart
touch $LIB_PATH/data/hive/boxes.dart

touch $LIB_PATH/main.dart

echo "✅ Estructura creada correctamente"
