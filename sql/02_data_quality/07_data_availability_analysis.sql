USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 1. Analyze rent availability by quarter
SELECT
    QUARTER,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(RENT_VALUE) AS VALID_RENT_RECORDS,
    COUNT_IF(RENT_VALUE IS NULL) AS MISSING_RENT_RECORDS,
    ROUND(
        COUNT(RENT_VALUE) * 100.0 / COUNT(*),
        2
    ) AS VALID_RENT_PCT,
    ROUND(
        COUNT_IF(RENT_VALUE IS NULL) * 100.0 / COUNT(*),
        2
    ) AS MISSING_RENT_PCT
FROM GOLD.RENT_ANALYTICS
GROUP BY QUARTER_CODE, QUARTER
ORDER BY QUARTER_CODE;

-- 2. Analyze rent availability by year
SELECT
    LEFT(QUARTER, 4) AS YEAR,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(RENT_VALUE) AS VALID_RENT_RECORDS,
    COUNT_IF(RENT_VALUE IS NULL) AS MISSING_RENT_RECORDS,
    ROUND(
        COUNT(RENT_VALUE) * 100.0 / COUNT(*),
        2
    ) AS VALID_RENT_PCT,
    ROUND(
        COUNT_IF(RENT_VALUE IS NULL) * 100.0 / COUNT(*),
        2
    ) AS MISSING_RENT_PCT
FROM GOLD.RENT_ANALYTICS
GROUP BY LEFT(QUARTER, 4)
ORDER BY YEAR;

-- 3. Analyze rent availability by property type
SELECT
    PROPERTY_TYPE,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(RENT_VALUE) AS VALID_RENT_RECORDS,
    COUNT_IF(RENT_VALUE IS NULL) AS MISSING_RENT_RECORDS,
    ROUND(
        COUNT(RENT_VALUE) * 100.0 / COUNT(*),
        2
    ) AS VALID_RENT_PCT,
    ROUND(
        COUNT_IF(RENT_VALUE IS NULL) * 100.0 / COUNT(*),
        2
    ) AS MISSING_RENT_PCT
FROM GOLD.RENT_ANALYTICS
GROUP BY PROPERTY_TYPE
ORDER BY VALID_RENT_PCT DESC;

-- 4. Analyze rent availability by bedroom category
SELECT
    BEDROOM,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(RENT_VALUE) AS VALID_RENT_RECORDS,
    COUNT_IF(RENT_VALUE IS NULL) AS MISSING_RENT_RECORDS,
    ROUND(
        COUNT(RENT_VALUE) * 100.0 / COUNT(*),
        2
    ) AS VALID_RENT_PCT,
    ROUND(
        COUNT_IF(RENT_VALUE IS NULL) * 100.0 / COUNT(*),
        2
    ) AS MISSING_RENT_PCT
FROM GOLD.RENT_ANALYTICS
GROUP BY BEDROOM
ORDER BY VALID_RENT_PCT DESC;



-- ============================================================
-- KEY FINDINGS
-- ============================================================
--
-- 1. Overall rent availability is limited:
--    376,988 valid records (27.57%) out of 1,367,436.
--
-- 2. Annual data coverage peaked at 31.85% in 2015 and 2016.
--    It declined to 16.60% in 2025.
--
-- 3. Property type coverage varies considerably:
--    All property types: 62.16%
--    Apartment: 39.12%
--    Other flats: 7.76%
--
-- 4. Bedroom category coverage also varies:
--    All bedrooms: 46.79%
--    1 to 3 bed: 42.24%
--    One bed: 12.86%
--
-- 5. Missing rent values are preserved in the analytical
--    dataset and should not automatically be interpreted
--    as invalid records.
--
-- 6. Data availability limitations must be considered
--    when interpreting historical trends and comparisons.
--
-- ============================================================