/*
    File: 01_schemas.sql
    Purpose:
        This file creates the main schemas for NYC Taxi Data Warehouse:-
            - raw: raw parquet and csv files
            - staging: Cleansing and Transformation
            - marts: fact and dimension tables for analytics
    Author: Youssef M.Makram M.Osman
    Date: 2026-04-07
    Notes: Run automatically on first container creation. 
*/

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS marts;