# Terraform Database Reliability Assignment

## Part 5: Seed Data and Indexing

The local PostgreSQL database contains 120 seed hotel bookings covering:

- Multiple cities: Delhi, Mumbai, Bangalore, Pune, Hyderabad
- Multiple organizations
- Multiple booking statuses: CONFIRMED, CANCELLED, PENDING, COMPLETED
- Booking events for selected bookings

### Query Optimization

The following query filters bookings by city and recent creation time:

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

The following composite index was added:

```sql
CREATE INDEX idx_hotel_bookings_city_created_at
ON hotel_bookings(city, created_at);
```

The index is based on the columns used in the WHERE clause. city is the equality filter and created_at is the range filter, allowing PostgreSQL to reduce the number of rows scanned before performing the grouping and aggregation.

## Part 6: Backup and Restore

### Create a Backup

Run the backup script:

```bash
./scripts/backup.sh
```

The script creates a timestamped PostgreSQL dump under:

```text
database/backups/
```

Example:

```text
database/backups/hotel_booking_20261006_110142.dump
```

### Restore a Backup

Run the restore script with the backup file:

```bash
./scripts/restore.sh database/backups/hotel_booking_20261006_110142.dump
```

The script creates a fresh local database named hotel_booking_restore, restores the backup, and verifies the row counts in both hotel_bookings and booking_events.

A successful restore should show the restored table names and their row counts without errors.
