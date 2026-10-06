#!/usr/bin/env bash

set -e

CONTAINER_NAME="hotel-bookings-db"
DB_USER="appuser"
RESTORE_DB="hotel_booking_restore"

if [ -z "$1" ]; then
  echo "Usage: ./scripts/restore.sh <backup-file>"
  exit 1
fi

BACKUP_FILE="$1"
BACKUP_NAME=$(basename "$BACKUP_FILE")

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Creating fresh database: $RESTORE_DB"

MSYS_NO_PATHCONV=1 docker.exe exec "$CONTAINER_NAME" \
  psql -U "$DB_USER" -d postgres \
  -c "DROP DATABASE IF EXISTS $RESTORE_DB;"

MSYS_NO_PATHCONV=1 docker.exe exec "$CONTAINER_NAME" \
  psql -U "$DB_USER" -d postgres \
  -c "CREATE DATABASE $RESTORE_DB;"

echo "Copying backup into container..."

docker.exe cp \
  "$BACKUP_FILE" \
  "$CONTAINER_NAME:/tmp/$BACKUP_NAME"

echo "Restoring database..."

MSYS_NO_PATHCONV=1 docker.exe exec "$CONTAINER_NAME" \
  pg_restore -U "$DB_USER" \
  -d "$RESTORE_DB" \
  "/tmp/$BACKUP_NAME"

echo "Restore completed successfully."

echo "Verifying restored data..."

MSYS_NO_PATHCONV=1 docker.exe exec "$CONTAINER_NAME" \
  psql -U "$DB_USER" -d "$RESTORE_DB" \
  -c "SELECT 'hotel_bookings' AS table_name, COUNT(*) AS row_count FROM hotel_bookings UNION ALL SELECT 'booking_events', COUNT(*) FROM booking_events;"
