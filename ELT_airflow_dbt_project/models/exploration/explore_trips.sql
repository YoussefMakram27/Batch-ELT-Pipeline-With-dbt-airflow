/*
    File: explore_trips.sql
    Purpose:
        This file performs multiple explorations on raw.trips data to extract the insights needed
        for the transformation and cleansing in the next step.
    Author: Youssef M.Makram M.Osman
    Date: 2026-04-17
*/

-- ===================================================
-- STRUCTURE & SHAPE
-- ===================================================

-- How many Rows are there?

SELECT COUNT(*) FROM raw.trips -- 250,000
SELECT COUNT(*) FROM raw.zones -- 265

-- What columns are there?

SELECT * FROM raw.trips LIMIT 20
SELECT * FROM raw.zones LIMIT 20

-- DataTypes

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'trips';

SELECT column_name, columns.data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'zones'; -- Data Types Correct


-- ===================================================
-- IDENTITY & UNIQUENESS
-- ===================================================

-- (No Primrary Key)
/******************************Handle This*******************************/
-- Duplicates

SELECT STRING_AGG(column_name, ', ')
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'trips'

SELECT *
From raw.trips
GROUP BY "VendorID", tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count,
         trip_distance, "RatecodeID", store_and_fwd_flag, "PULocationID", "DOLocationID",
         payment_type, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge,
         total_amount, congestion_surcharge, "Airport_fee", cbd_congestion_fee
HAVING COUNT(*) > 1  -- No Duplicates

SELECT STRING_AGG(column_name, ', ')
FROM information_schema.columns
WHERE table_schema = 'raw'
AND table_name = 'zones'

SELECT *
FROM raw.zones
GROUP BY "LocationID", "Borough", "Zone", "service_zone"
HAVING COUNT(*) > 1 -- No Duplicates

-- Foregin Key Existence in The Parent Check

SELECT *
FROM raw.trips t
WHERE NOT EXISTS (
  SELECT 1 
  FROM raw.zones z
  WHERE z."LocationID" = t."PULocationID" OR  z."LocationID" = t."DOLocationID"
) -- No Orphan Keys

