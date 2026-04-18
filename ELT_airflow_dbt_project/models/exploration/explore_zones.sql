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

