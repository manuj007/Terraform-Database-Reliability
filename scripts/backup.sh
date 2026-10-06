#!/usr/bin/env bash

set -e

CONTAINER_NAME="hotel-bookings-db"
DB_NAME="hotel_booking"
DB_USER="appuser"
BACKUP_DIR="database/backups"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="hotel_booking_${TIMESTAMP}.dump"

echo "Creating database backup..."

MSYS_NO_PATHCONV=1 docker.exe exec "$CONTAINER_NAME" \
  pg_dump -U "$DB_USER" -d "$DB_NAME" -F c \
  -f "/tmp/$BACKUP_FILE"

docker.exe cp \
  "$CONTAINER_NAME:/tmp/$BACKUP_FILE" \
  "$BACKUP_DIR/$BACKUP_FILE"

echo "Backup created: $BACKUP_DIR/$BACKUP_FILE"
