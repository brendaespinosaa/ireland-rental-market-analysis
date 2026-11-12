
-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 05_silver_data_inspection.sql
-- PURPOSE: Inspect structured records and data coverage in Silver
-- PLATFORM: Snowflake
-- ============================================================

USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 1. Inspect representative Silver records
SELECT *
FROM SILVER.RENT_DATA
LIMIT 15;


-- 2. Count distinct dimension values
SELECT
    COUNT(DISTINCT QUARTER_CODE) AS DISTINCT_QUARTERS,
    COUNT(DISTINCT BEDROOM_CODE) AS DISTINCT_BEDROOMS,
    COUNT(DISTINCT PROPERTY_TYPE_CODE) AS DISTINCT_PROPERTY_TYPES,
    COUNT(DISTINCT LOCATION_CODE) AS DISTINCT_LOCATIONS
FROM SILVER.RENT_DATA;


-- 3. Analyze rent value availability
SELECT
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(RENT_VALUE) AS VALID_RENT_RECORDS,
    COUNT_IF(RENT_VALUE IS NULL) AS MISSING_RENT_RECORDS
FROM SILVER.RENT_DATA;
