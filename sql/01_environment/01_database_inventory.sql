
-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 01_database_inventory.sql
-- PURPOSE: Inspect Snowflake environment and project objects
-- ============================================================

-- 1. Set execution context
USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 2. Inspect active session
SELECT
    CURRENT_WAREHOUSE() AS ACTIVE_WAREHOUSE,
    CURRENT_DATABASE() AS ACTIVE_DATABASE,
    CURRENT_SCHEMA() AS ACTIVE_SCHEMA,
    CURRENT_ROLE() AS ACTIVE_ROLE;

-- 3. List available warehouses
SHOW WAREHOUSES;

-- 4. List project schemas
SHOW SCHEMAS IN DATABASE GLOBAL_TRADE_DB;

-- 5. List project tables
SHOW TABLES IN DATABASE GLOBAL_TRADE_DB;

-- 6. Inspect Gold table structure
DESCRIBE TABLE GLOBAL_TRADE_DB.GOLD.RENT_ANALYTICS;

-- 7. Check Gold table coverage
SELECT
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(DISTINCT QUARTER) AS DISTINCT_QUARTERS,
    COUNT(DISTINCT LOCATION_CODE) AS DISTINCT_LOCATIONS
FROM GLOBAL_TRADE_DB.GOLD.RENT_ANALYTICS;
