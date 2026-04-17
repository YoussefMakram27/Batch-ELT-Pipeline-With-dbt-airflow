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

-- (No Primrary Key) trips
/******************************Handle This*******************************/


-- Duplicates

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

-- ===================================================
-- NULLS & MISSINGS
-- ===================================================

SELECT
  COUNT(*) FILTER (WHERE "VendorID" IS NULL),
  COUNT(*) FILTER (WHERE "tpep_pickup_datetime" IS NULL), 
  COUNT(*) FILTER (WHERE "tpep_dropoff_datetime" IS NULL),
  COUNT(*) FILTER (WHERE "passenger_count" IS NULL),
  COUNT(*) FILTER (WHERE "trip_distance" IS NULL),
  COUNT(*) FILTER (WHERE "RatecodeID" IS NULL),
  COUNT(*) FILTER (WHERE "store_and_fwd_flag" IS NULL),
  COUNT(*) FILTER (WHERE "PULocationID" IS NULL),
  COUNT(*) FILTER (WHERE "DOLocationID" IS NULL),
  COUNT(*) FILTER (WHERE "trip_distance" IS NULL), 
  COUNT(*) FILTER (WHERE "payment_type" IS NULL),
  COUNT(*) FILTER (WHERE "fare_amount" IS NULL),
  COUNT(*) FILTER (WHERE "extra" IS NULL),
  COUNT(*) FILTER (WHERE "mta_tax" IS NULL),
  COUNT(*) FILTER (WHERE "tip_amount" IS NULL),
  COUNT(*) FILTER (WHERE "tolls_amount" IS NULL), 
  COUNT(*) FILTER (WHERE "improvement_surcharge" IS NULL),
  COUNT(*) FILTER (WHERE "total_amount" IS NULL),
  COUNT(*) FILTER (WHERE "congestion_surcharge" IS NULL), 
  COUNT(*) FILTER (WHERE "Airport_fee" IS NULL),
  COUNT(*) FILTER (WHERE "cbd_congestion_fee" IS NULL)

FROM raw.trips; -- No NULLS


SELECT
  COUNT(*) FILTER (WHERE "LocationID" IS NULL),
  COUNT(*) FILTER (WHERE "Borough" IS NULL), 
  COUNT(*) FILTER (WHERE "Zone" IS NULL),
  COUNT(*) FILTER (WHERE "service_zone" IS NULL)
FROM RAW.zones; -- Borough: 1, Zone: 1, service_zone: 2


SELECT *
FROM raw.zones
WHERE "Borough" IS NULL OR "Zone" IS NULL OR "service_zone" IS NULL 
/****************************************Just two rows with nulls delete them******************/

