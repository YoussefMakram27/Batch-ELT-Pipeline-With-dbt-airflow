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

-- Rows Count

SELECT COUNT(*) FROM raw.trips -- 250,000


-- Columns Count

SELECT * FROM raw.trips LIMIT 20

-- DataTypes

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'trips'; -- Data Types Correct


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


-- ===================================================
-- PLAYING WITH EACH COLUMN
-- ===================================================

-- VendorID

SElECT DISTINCT "VendorID"
From raw.trips -- 1, 2, 7
/****************************** Replace 1:Creative Mobile Technologies, 2:Curb Mobility, 7:Helix  
                                Rename VendorID -> vendor_name*******************************/

-- tpep_pickup_datetime, tpep_dropoff_datetime

SELECT MAX(trips.tpep_pickup_datetime) AS pickup_maxy,
       MIN(trips.tpep_pickup_datetime) AS pickup_mini,
       MAX(trips.tpep_dropoff_datetime) As dropoff_maxy,
       MIN(trips.tpep_dropoff_datetime) AS dropoff_mini
FROM raw.trips

SELECT *
FROM raw.trips
WHERE trips.tpep_pickup_datetime = '2025-01-04 03:59:57'


SELECT *
FROM raw.trips
WHERE trips.tpep_dropoff_datetime = '2025-01-05 03:39:48'

/****************************** Problem: pickup_time:  2025-01-04 03:43:19
                                         dropoff_time: 2025-01-05 03:39:48  
                                Rename tpep_pickup_datetime  ->  pickup_datetime
                                Rename tpep_dropoff_datetime -> dropoff_datetime *******************************/


-- Checking Whether pickup is after dropoff

SELECT *
FROM raw.trips 
WHERE "tpep_pickup_datetime" > "tpep_dropoff_datetime"

/****************************** Problem (1 ROW): pickup_time:  2025-01-02 12:26:00
                                                 dropoff_time: 2025-01-02 11:29:58 *******************************/

-- Checking Wrong Durations

SELECT *,
      "tpep_dropoff_datetime" - "tpep_pickup_datetime" AS trip_range
FROM raw.trips
ORDER BY trip_range DESC

SELECT COUNT(*)
FROM raw.trips
WHERE "tpep_dropoff_datetime" - "tpep_pickup_datetime" > INTERVAL '2 HOURS' -- 220 trips

SELECT COUNT(*)
FROM raw.trips
WHERE "tpep_dropoff_datetime" - "tpep_pickup_datetime" < INTERVAL '1 MINUTES' -- 4148


SELECT COUNT(*)
FROM raw.trips
WHERE "tpep_dropoff_datetime" - "tpep_pickup_datetime" < INTERVAL '1 SECONDS' -- 94 

/****************************** Problem (4148 ROWs): Duration of trips < 1 minute
                                       (220 ROWs) : Duration of trips > 2 hours 
                                                    NEED TO BE CHECHKED WITH SOURCE SYSTEM AND FLAG THEM 
                                                    *******************************/


-- passenger_count

SELECT DISTINCT trips.passenger_count
FROM raw.trips -- o -> 9

SELECT COUNT(*)
FROM raw.trips 
WHERE trips.passenger_count <= 0 -- 1838

/****************************** Problem (1838 ROWs): passenger_count = 0
                                                    (MAKE THEM = 1 BASED ON THE SOURCE SYSTEM) 
                                                    *******************************/


-- trip_distance

SELECT MAX(trips.trip_distance),
       MIN(trips.trip_distance)
FROM raw.trips -- min: 0, max=133.3

SELECT COUNT(*)
FROM raw.trips
WHERE trips.trip_distance > 30  -- 279

SELECT COUNT(*)
FROM raw.trips
WHERE trips.trip_distance = 0  -- 4033

SELECT *
FROM raw.trips
WHERE trips.trip_distance = 0  

/****************************** Problem (279 ROWs) : trp_distance > 30
                                       (4033 ROWs): trip_ditance = 0
                                            NEED TO BE CHECHKED WITH SOURCE SYSTEM AND FLAG THEM
                                                    *******************************/

-- RateCodeID

SELECT DISTINCT trips."RatecodeID"
FROM raw.trips -- 1,2,3,4,5,6,99

/****************************** Rename RatecodeID -> rate_code_ID
                               Replace(1=Standard, 2=JFK, 3=Newark, 4=Nassau/Westchester, 5=Negotiated,
                                       6=Group ride, 99=Unknown) *******************************/

-- store_and_fwd_flag

SELECT DISTINCT trips."store_and_fwd_flag"
FROM raw.trips -- N, Y

/****************************** Replace Y: stored_then_sent, N: sent_immediately *******************************/

-- payment_type

SELECT DISTINCT trips.payment_type
FROM raw.trips -- 1 2 3 4

/****************************** Replace (1=Credit card, 2=Cash, 3=No charge, 4=Dispute)*******************************/

-- fare_amount, extra, mta_tax, tip_amount, tolls_amount, imporvement_surchage, total_amount, 
-- congestion_surchage, Airport_fee, cbd_congestion_fee

SELECT * FROM raw.trips LIMIT 20