
-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 02_inspect_table_structure.sql
-- PURPOSE: Inspect the Bronze, Silver and Gold data models
-- PLATFORM: Snowflake
-- ============================================================

-- 1. Set execution context
USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 2. Confirm active warehouse
SELECT CURRENT_WAREHOUSE() AS ACTIVE_WAREHOUSE;

-- 3. Inspect table structures across Medallion layers
SELECT
    TABLE_SCHEMA,
    TABLE_NAME,
    ORDINAL_POSITION,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM GLOBAL_TRADE_DB.INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA IN ('BRONZE', 'SILVER', 'GOLD')
  AND TABLE_NAME IN (
      'RAW_RENT_DATA',
      'RENT_DATA',
      'RENT_ANALYTICS'
  )
ORDER BY
    CASE TABLE_SCHEMA
        WHEN 'BRONZE' THEN 1
        WHEN 'SILVER' THEN 2
        WHEN 'GOLD' THEN 3
    END,
    TABLE_NAME,
    ORDINAL_POSITION;
