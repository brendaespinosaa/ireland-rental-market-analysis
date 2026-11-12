
-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 03_layer_record_counts.sql
-- PURPOSE: Compare record counts and inspect Bronze ingestion
-- PLATFORM: Snowflake
-- ============================================================

USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 1. Compare record counts across Medallion layers
SELECT
    'BRONZE' AS LAYER,
    COUNT(*) AS TOTAL_RECORDS
FROM BRONZE.RAW_RENT_DATA

UNION ALL

SELECT
    'SILVER',
    COUNT(*)
FROM SILVER.RENT_DATA

UNION ALL

SELECT
    'GOLD',
    COUNT(*)
FROM GOLD.RENT_ANALYTICS;


-- 2. Inspect Bronze ingestion summary
SELECT
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(DISTINCT SOURCE_FILE) AS DISTINCT_SOURCE_FILES,
    MIN(INGESTION_TIMESTAMP) AS FIRST_INGESTION,
    MAX(INGESTION_TIMESTAMP) AS LAST_INGESTION
FROM BRONZE.RAW_RENT_DATA;


-- 3. Inspect records by source file
SELECT
    SOURCE_FILE,
    COUNT(*) AS TOTAL_RECORDS,
    MIN(INGESTION_TIMESTAMP) AS FIRST_INGESTION,
    MAX(INGESTION_TIMESTAMP) AS LAST_INGESTION
FROM BRONZE.RAW_RENT_DATA
GROUP BY SOURCE_FILE
ORDER BY SOURCE_FILE;
