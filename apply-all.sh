#!/bin/bash
# apply-all.sh

CIS_LEVEL=${1:-1}  # default to Level 1 if not provided

export CIS_LEVEL

SECTIONS_DIR="$(dirname "$0")/sections"
BACKUP_DIR="$(dirname "$0")/backup_$(date +%F_%T)"

mkdir -p "$BACKUP_DIR"
export BACKUP_DIR

if [ ! -d "$SECTIONS_DIR" ]; then
    echo "❌ Sections directory not found: $SECTIONS_DIR"
    exit 1
fi

for script in "$SECTIONS_DIR"/*.sh; do
    echo "🚀 Running $(basename "$script")"
    bash "$script"
    echo
done

echo "✅ CIS Ubuntu 20.04 Level $CIS_LEVEL hardening applied."
