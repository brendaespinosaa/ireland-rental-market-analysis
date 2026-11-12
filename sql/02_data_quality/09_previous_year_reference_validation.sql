-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 09_previous_year_reference_validation.sql
-- PURPOSE: Validate previous-year rent references
-- PLATFORM: Snowflake
-- ============================================================

USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 1. Validate previous-year rent using a self-join
WITH PREVIOUS_YEAR_CHECK AS (
    SELECT
        CURRENT_DATA.QUARTER_CODE,
        CURRENT_DATA.LOCATION_CODE,
        CURRENT_DATA.PROPERTY_TYPE_CODE,
        CURRENT_DATA.BEDROOM_CODE,

        CURRENT_DATA.PREVIOUS_YEAR_RENT,
        PREVIOUS_DATA.RENT_VALUE AS EXPECTED_PREVIOUS_YEAR_RENT

    FROM GOLD.RENT_ANALYTICS CURRENT_DATA

    LEFT JOIN GOLD.RENT_ANALYTICS PREVIOUS_DATA
        ON CURRENT_DATA.LOCATION_CODE = PREVIOUS_DATA.LOCATION_CODE
        AND CURRENT_DATA.PROPERTY_TYPE_CODE = PREVIOUS_DATA.PROPERTY_TYPE_CODE
        AND CURRENT_DATA.BEDROOM_CODE = PREVIOUS_DATA.BEDROOM_CODE
        AND PREVIOUS_DATA.QUARTER_CODE =
            (CURRENT_DATA.QUARTER_CODE - 10)
)

SELECT
    COUNT_IF(
        EXPECTED_PREVIOUS_YEAR_RENT IS NOT NULL
    ) AS AVAILABLE_PREVIOUS_YEAR_REFERENCES,

    COUNT_IF(
        EXPECTED_PREVIOUS_YEAR_RENT IS NULL
        AND PREVIOUS_YEAR_RENT IS NOT NULL
    ) AS UNEXPECTED_PREVIOUS_YEAR_VALUES,

    COUNT_IF(
        EXPECTED_PREVIOUS_YEAR_RENT IS NOT NULL
        AND PREVIOUS_YEAR_RENT IS NULL
    ) AS MISSING_PREVIOUS_YEAR_VALUES,

    COUNT_IF(
        EXPECTED_PREVIOUS_YEAR_RENT IS NOT NULL
        AND PREVIOUS_YEAR_RENT IS NOT NULL
        AND ABS(
            PREVIOUS_YEAR_RENT - EXPECTED_PREVIOUS_YEAR_RENT
        ) > 0.01
    ) AS PREVIOUS_YEAR_VALUE_MISMATCHES

FROM PREVIOUS_YEAR_CHECK;

-- 2. Analyze previous-year rent availability by year
SELECT
    LEFT(QUARTER, 4) AS YEAR,
    COUNT(*) AS TOTAL_RECORDS,
    COUNT(PREVIOUS_YEAR_RENT) AS AVAILABLE_PREVIOUS_YEAR_RENT,
    COUNT_IF(PREVIOUS_YEAR_RENT IS NULL) AS MISSING_PREVIOUS_YEAR_RENT,
    ROUND(
        COUNT(PREVIOUS_YEAR_RENT) * 100.0 / COUNT(*),
        2
    ) AS PREVIOUS_YEAR_AVAILABILITY_PCT
FROM GOLD.RENT_ANALYTICS
GROUP BY LEFT(QUARTER, 4)
ORDER BY YEAR;

-- 3. Validate year-over-year calculations against rent values
SELECT
    COUNT(*) AS RECORDS_WITH_BOTH_RENT_VALUES,

    COUNT_IF(
        ABS(
            YOY_CHANGE_EUR -
            (RENT_VALUE - PREVIOUS_YEAR_RENT)
        ) > 0.01
    ) AS YOY_EUR_MISMATCHES,

    COUNT_IF(
        ABS(
            YOY_CHANGE_PCT -
            (
                (RENT_VALUE - PREVIOUS_YEAR_RENT)
                / PREVIOUS_YEAR_RENT * 100
            )
        ) > 0.01
    ) AS YOY_PCT_MISMATCHES

FROM GOLD.RENT_ANALYTICS
WHERE RENT_VALUE IS NOT NULL
  AND PREVIOUS_YEAR_RENT IS NOT NULL;

  -- 4. Analyze year-over-year rent change distribution
SELECT
    COUNT(*) AS TOTAL_COMPARABLE_RECORDS,

    COUNT_IF(YOY_CHANGE_EUR > 0) AS RENT_INCREASES,
    COUNT_IF(YOY_CHANGE_EUR < 0) AS RENT_DECREASES,
    COUNT_IF(YOY_CHANGE_EUR = 0) AS NO_RENT_CHANGE,

    ROUND(
        COUNT_IF(YOY_CHANGE_EUR > 0) * 100.0 / COUNT(*),
        2
    ) AS RENT_INCREASE_PCT,

    ROUND(
        COUNT_IF(YOY_CHANGE_EUR < 0) * 100.0 / COUNT(*),
        2
    ) AS RENT_DECREASE_PCT,

    ROUND(
        COUNT_IF(YOY_CHANGE_EUR = 0) * 100.0 / COUNT(*),
        2
    ) AS NO_CHANGE_PCT

FROM GOLD.RENT_ANALYTICS
WHERE YOY_CHANGE_EUR IS NOT NULL;





-- ============================================================
-- KEY FINDINGS
-- ============================================================
--
-- 1. The previous-year rent reference was validated against
--    the same location, property type, bedroom category and
--    quarter from the previous year.
--
-- 2. A total of 364,547 previous-year rent references were
--    available, with zero mismatches.
--
-- 3. No unexpected or missing previous-year values were
--    identified when a valid reference existed.
--
-- 4. All 338,786 comparable records passed the YoY EUR
--    and percentage calculation checks.
--
-- 5. Among comparable records:
--    - 70.41% showed rent increases.
--    - 29.58% showed rent decreases.
--    - 0.01% showed no change.
--
-- 6. These figures represent analytical combinations,
--    not individual rental contracts or properties.
--
-- ============================================================