#!/usr/bin/env bash
# Owo Lane golden path: create a production-ready Node.js service
set -euo pipefail

SERVICE_NAME="${1:-}"
TEAM="${2:-}"
NAME_RULE='^[a-z][a-z0-9-]{2,39}$'

if [[ -z "$SERVICE_NAME" || -z "$TEAM" ]]; then
  echo "Usage: ./create-service.sh <service-name> <team>"
  exit 1
fi

if [[ ! "$SERVICE_NAME" =~ $NAME_RULE || ! "$TEAM" =~ $NAME_RULE ]]; then
  echo "Names must be 3 to 40 characters: lowercase letters, numbers and hyphens."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$(dirname "$SCRIPT_DIR")/$SERVICE_NAME"

if [[ -e "$TARGET_DIR" ]]; then
  echo "A folder named $SERVICE_NAME already exists. Choose another name."
  exit 1
fi

OWNER="$(gh api user --jq .login | tr '[:upper:]' '[:lower:]')"

echo "Creating $SERVICE_NAME for $TEAM..."
cp -r "$SCRIPT_DIR/template" "$TARGET_DIR"

grep -rl -e "__SERVICE_NAME__" -e "__TEAM__" -e "__OWNER__" "$TARGET_DIR" | while read -r file; do
  sed -i \
    -e "s/__SERVICE_NAME__/$SERVICE_NAME/g" \
    -e "s/__TEAM__/$TEAM/g" \
    -e "s/__OWNER__/$OWNER/g" \
    "$file"
done

echo "Template filled in $TARGET_DIR"
