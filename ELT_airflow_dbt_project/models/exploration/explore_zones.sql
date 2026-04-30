/*
    File: explore_zones.sql
    Purpose:
        This file performs multiple explorations on raw.zones data to extract the insights needed
        for the transformation and cleansing in the next step.
    Author: Youssef M.Makram M.Osman
    Date: 2026-04-17
*/

-- ===================================================
-- STRUCTURE & SHAPE
-- ===================================================

-- Rows Count

SELECT COUNT(*) FROM raw.zones -- 265

-- Columns Count

SELECT * FROM raw.zones LIMIT 20


-- DataTypes

SELECT column_name, columns.data_type
FROM information_schema.columns
WHERE table_schema = 'raw'
  AND table_name = 'zones'; -- Data Types Correct


-- ===================================================
-- IDENTITY & UNIQUENESS
-- ===================================================

SELECT STRING_AGG(column_name, ', ')
FROM information_schema.columns
WHERE table_schema = 'raw'
AND table_name = 'zones'

SELECT *
FROM raw.zones
GROUP BY "LocationID", "Borough", "Zone", "service_zone"
HAVING COUNT(*) > 1 -- No Duplicates


-- ===================================================
-- NULLS & MISSINGS
-- ===================================================

SELECT
  COUNT(*) FILTER (WHERE "LocationID" IS NULL),
  COUNT(*) FILTER (WHERE "Borough" IS NULL), 
  COUNT(*) FILTER (WHERE "Zone" IS NULL),
  COUNT(*) FILTER (WHERE "service_zone" IS NULL)
FROM RAW.zones; -- Borough: 1, Zone: 1, service_zone: 2



SELECT *
FROM raw.zones
WHERE "Borough" IS NULL OR "Zone" IS NULL OR "service_zone" IS NULL 
/****************************** Just two rows with nulls delete them *******************************/


-- ===================================================
-- PLAYING WITH EACH COLUMN
-- ===================================================

-- LocationID

SELECT COUNT(*) FROM raw.zones -- 265

SELECT MIN(zones."LocationID"), MAX(zones."LocationID") FROM raw.zones -- 1 to 265 Correct


-- Borough

SELECT DISTINCT zones."Borough" FROM raw.zones -- Bronx, NULL, Queens, EWR, Unknown, Brooklyn, Staten Island, Manhatten

SELECT * FROM raw.zones WHERE zones."Borough" IS NULL OR zones."Borough" = 'Unknown'

/******************* Only two records: 264: Unknown, 265: Null --> Delete them *******************/

-- Zone

SELECT DISTINCT zones."Zone" FROM raw.zones -- 261 distinct one, 1 NULL, left with 3 need to checked
 
SELECT * FROM raw.zones WHERE zones."Zone" IS NULL

SELECT zones."Zone", COUNT(*)
FROM raw.zones
GROUP BY zones."Zone"
HAVING COUNT(*) > 1  -- There are duplicates


SELECT "LocationID" 
FROM ( 
  SELECT *, ROW_NUMBER() OVER(
  PARTITION BY zones."Zone"
  ORDER BY zones."LocationID"
) rn
FROM raw.zones
ORDER BY zones."LocationID" 
) F
WHERE rn > 1  -- 57, 104, 105

-- checking these zones in raw.trips
SELECT * 
FROM raw.trips
WHERE trips."DOLocationID" IN (57, 104, 105) OR trips."PULocationID" IN (57, 104, 105)  -- 7 records hve DOLocationID: 57


SELECT *
FROM raw.zones
WHERE zones."Zone" IN ('Corona', 'Governor''s Island/Ellis Island/Liberty Island')   -- 56, 57   103 104 105

/******************* Only one record: 264: NULL --> Delete it
                     Governor's Island/Ellis Island/Liberty Island --> duplicate 3 times delete them 103 104 105
                     delete 104 104
                     Corona --> duplicate 2 times 56, 57
                     in "raw.trips" replace 57 with 56, then delete 57 in raw.zones
                     *******************/


-- service_zone

SELECT DISTINCT zones.service_zone FROM raw.zones


SELECT * FROM raw.zones WHERE zones.service_zone IS NULL -- 264, 265 delete them