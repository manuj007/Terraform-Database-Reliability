-- Seed 120 hotel bookings across multiple cities,
-- organizations, and booking statuses.

INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    (
        '00000000-0000-0000-0000-' ||
        LPAD(g::text, 12, '0')
    )::uuid,
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-' ||
        LPAD(((g - 1) % 5 + 1)::text, 12, '0')
    )::uuid,
    'HOTEL-' || LPAD(((g - 1) % 20 + 1)::text, 3, '0'),
    CASE (g - 1) % 5
        WHEN 0 THEN 'delhi'
        WHEN 1 THEN 'mumbai'
        WHEN 2 THEN 'bangalore'
        WHEN 3 THEN 'pune'
        ELSE 'hyderabad'
    END,
    CURRENT_DATE + ((g % 30) + 1),
    CURRENT_DATE + ((g % 30) + 3),
    (5000 + (g * 125))::numeric(12,2),
    CASE (g - 1) % 4
        WHEN 0 THEN 'CONFIRMED'
        WHEN 1 THEN 'CANCELLED'
        WHEN 2 THEN 'PENDING'
        ELSE 'COMPLETED'
    END,
    CASE
        WHEN g % 3 = 0
            THEN NOW() - ((g % 25) || ' days')::interval
        ELSE NOW() - ((30 + (g % 20)) || ' days')::interval
    END
FROM generate_series(1, 120) AS g
ON CONFLICT (id) DO NOTHING;


-- Add events for some bookings.
INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,
    CASE (ROW_NUMBER() OVER (ORDER BY id)) % 3
        WHEN 0 THEN 'BOOKING_CONFIRMED'
        WHEN 1 THEN 'PAYMENT_COMPLETED'
        ELSE 'BOOKING_UPDATED'
    END,
    '{"source":"seed","payment_status":"paid"}'::jsonb,
    created_at
FROM hotel_bookings
WHERE id IN (
    SELECT id
    FROM hotel_bookings
    ORDER BY id
    LIMIT 30
);
