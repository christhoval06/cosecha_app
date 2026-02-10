#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./scripts/create_base_structure.sh [target_dir] [feature1 feature2 ...]
#
# Examples:
#   ./scripts/create_base_structure.sh
#   ./scripts/create_base_structure.sh my_app analytics auth

print_help() {
  cat <<'EOF'
Create base Flutter project structure (core/data/features/l10n).

Usage:
  ./scripts/create_base_structure.sh [target_dir] [feature1 feature2 ...]

Arguments:
  target_dir   Destination directory (default: current directory).
  featureN     Optional list of features to create under lib/features/<feature>.

Default features (if none passed):
  business home onboarding products reports settings transactions

Examples:
  ./scripts/create_base_structure.sh
  ./scripts/create_base_structure.sh my_app
  ./scripts/create_base_structure.sh my_app analytics auth billing

Options:
  -h, --help   Show this help and exit.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  print_help
  exit 0
fi

TARGET_DIR="${1:-.}"
shift || true

FEATURES=("$@")
if [ ${#FEATURES[@]} -eq 0 ]; then
  FEATURES=(
    business
    home
    onboarding
    products
    reports
    settings
    transactions
  )
fi

mkdir -p "$TARGET_DIR/lib/core/"{constants,router,services,theme,utils,widgets}
mkdir -p "$TARGET_DIR/lib/data/"{hive,models,repositories}
mkdir -p "$TARGET_DIR/lib/l10n"

for feature in "${FEATURES[@]}"; do
  mkdir -p "$TARGET_DIR/lib/features/$feature/"{dashboard,widgets}
done

echo "Base structure created in: $TARGET_DIR"
echo "Features: ${FEATURES[*]}"
