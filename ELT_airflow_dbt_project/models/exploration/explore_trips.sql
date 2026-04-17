/*
    File: explore_trips.sql
    Purpose:
        This file performs multiple explorations on raw.trips data to extract the insights needed
        for the transformation and cleansing in the next step.
    Author: Youssef M.Makram M.Osman
    Date: 2026-04-17
*/

/***************Counting Number of Rows***************/
SELECT COUNT(*) FROM raw.trips

/***************Counting Number of Rows***************/
SELECT * FROM raw.trips LIMIT 5