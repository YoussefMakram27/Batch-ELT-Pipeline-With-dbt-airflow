/*
    File: explore_zones.sql
    Purpose:
        This file performs multiple explorations on raw.zones data to extract the insights needed
        for the transformation and cleansing in the next step.
    Author: Youssef M.Makram M.Osman
    Date: 2026-04-17
*/

/***************Counting Number of Rows***************/
SELECT COUNT(*) FROM raw.zones

/***************Counting Number of Rows***************/
SELECT * FROM raw.zones LIMIT 5