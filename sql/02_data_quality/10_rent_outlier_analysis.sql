-- ============================================================
-- PROJECT: Ireland Rental Market Analysis
-- SCRIPT: 10_rent_outlier_analysis.sql
-- PURPOSE: Detect extreme rent values using the IQR method
-- PLATFORM: Snowflake
-- ============================================================

USE WAREHOUSE SNOWFLAKE_LEARNING_WH;
USE DATABASE GLOBAL_TRADE_DB;

-- 1. Calculate global rent distribution and IQR boundaries
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
)

SELECT
    Q1,
    Q3,
    Q3 - Q1 AS IQR,
    Q1 - 1.5 * (Q3 - Q1) AS LOWER_BOUND,
    Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
FROM RENT_DISTRIBUTION;


-- 2. Identify upper and lower rent outliers
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q1,
        Q3,
        Q3 - Q1 AS IQR,
        Q1 - 1.5 * (Q3 - Q1) AS LOWER_BOUND,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
)

SELECT
    COUNT(*) AS VALID_RENT_RECORDS,

    COUNT_IF(
        RENT_VALUE < LOWER_BOUND
    ) AS LOWER_OUTLIERS,

    COUNT_IF(
        RENT_VALUE > UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    COUNT_IF(
        RENT_VALUE < LOWER_BOUND
        OR RENT_VALUE > UPPER_BOUND
    ) AS TOTAL_OUTLIERS,

    ROUND(
        COUNT_IF(
            RENT_VALUE > UPPER_BOUND
        ) * 100.0 / COUNT(*),
        2
    ) AS UPPER_OUTLIER_PCT,

    MIN(
        CASE
            WHEN RENT_VALUE > UPPER_BOUND
            THEN RENT_VALUE
        END
    ) AS MIN_UPPER_OUTLIER,

    MAX(
        CASE
            WHEN RENT_VALUE > UPPER_BOUND
            THEN RENT_VALUE
        END
    ) AS MAX_UPPER_OUTLIER

FROM GOLD.RENT_ANALYTICS
CROSS JOIN OUTLIER_LIMITS
WHERE RENT_VALUE IS NOT NULL;

-- 3. Analyze outliers by property type
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q1 - 1.5 * (Q3 - Q1) AS LOWER_BOUND,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
)

SELECT
    PROPERTY_TYPE,

    COUNT(*) AS VALID_RECORDS,

    COUNT_IF(
        RENT_VALUE > UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        AVG(RENT_VALUE),
        2
    ) AS AVG_RENT,

    ROUND(
        MIN(RENT_VALUE),
        2
    ) AS MIN_RENT,

    ROUND(
        MAX(RENT_VALUE),
        2
    ) AS MAX_RENT,

    ROUND(
        COUNT_IF(RENT_VALUE > UPPER_BOUND)
        * 100.0 / COUNT(*),
        2
    ) AS OUTLIER_SHARE_PCT

FROM GOLD.RENT_ANALYTICS
CROSS JOIN OUTLIER_LIMITS
WHERE RENT_VALUE IS NOT NULL
GROUP BY PROPERTY_TYPE
ORDER BY UPPER_OUTLIERS DESC;

-- 4. Analyze outliers by bedroom category
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q1 - 1.5 * (Q3 - Q1) AS LOWER_BOUND,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
)

SELECT
    BEDROOM,

    COUNT(*) AS VALID_RECORDS,

    COUNT_IF(
        RENT_VALUE > UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        AVG(RENT_VALUE),
        2
    ) AS AVG_RENT,

    ROUND(
        MIN(RENT_VALUE),
        2
    ) AS MIN_RENT,

    ROUND(
        MAX(RENT_VALUE),
        2
    ) AS MAX_RENT,

    ROUND(
        COUNT_IF(RENT_VALUE > UPPER_BOUND)
        * 100.0 / COUNT(*),
        2
    ) AS OUTLIER_SHARE_PCT

FROM GOLD.RENT_ANALYTICS
CROSS JOIN OUTLIER_LIMITS
WHERE RENT_VALUE IS NOT NULL
GROUP BY BEDROOM
ORDER BY UPPER_OUTLIERS DESC;

-- 5. Identify locations and quarters affected by outliers
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q1 - 1.5 * (Q3 - Q1) AS LOWER_BOUND,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
),

OUTLIER_RECORDS AS (
    SELECT
        G.QUARTER,
        G.LOCATION_CODE,
        G.LOCATION,
        G.PROPERTY_TYPE,
        G.BEDROOM,
        G.RENT_VALUE

    FROM GOLD.RENT_ANALYTICS G
    CROSS JOIN OUTLIER_LIMITS L

    WHERE G.RENT_VALUE > L.UPPER_BOUND
)

SELECT
    COUNT(*) AS TOTAL_OUTLIERS,

    COUNT(DISTINCT LOCATION_CODE) AS AFFECTED_LOCATIONS,

    COUNT(DISTINCT QUARTER) AS AFFECTED_QUARTERS,

    ROUND(AVG(RENT_VALUE), 2) AS AVG_OUTLIER_RENT,

    ROUND(MIN(RENT_VALUE), 2) AS MIN_OUTLIER_RENT,

    ROUND(MAX(RENT_VALUE), 2) AS MAX_OUTLIER_RENT

FROM OUTLIER_RECORDS;

-- 6. Rank locations by upper outlier frequency
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
)

SELECT
    G.LOCATION_CODE,
    G.LOCATION,

    COUNT(*) AS OUTLIER_COUNT,

    COUNT(DISTINCT G.QUARTER) AS AFFECTED_QUARTERS,

    ROUND(AVG(G.RENT_VALUE), 2) AS AVG_OUTLIER_RENT,

    ROUND(MAX(G.RENT_VALUE), 2) AS MAX_OUTLIER_RENT

FROM GOLD.RENT_ANALYTICS G
CROSS JOIN OUTLIER_LIMITS L

WHERE G.RENT_VALUE > L.UPPER_BOUND

GROUP BY
    G.LOCATION_CODE,
    G.LOCATION

ORDER BY
    OUTLIER_COUNT DESC,
    AVG_OUTLIER_RENT DESC

LIMIT 15;

-- 7. Analyze outlier distribution over time
WITH RENT_DISTRIBUTION AS (
    SELECT
        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
),

OUTLIER_LIMITS AS (
    SELECT
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND
    FROM RENT_DISTRIBUTION
)

SELECT
    LEFT(G.QUARTER, 4) AS YEAR,

    COUNT(*) AS VALID_RECORDS,

    COUNT_IF(
        G.RENT_VALUE > L.UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        COUNT_IF(G.RENT_VALUE > L.UPPER_BOUND)
        * 100.0 / COUNT(*),
        2
    ) AS OUTLIER_SHARE_PCT,

    ROUND(
        AVG(G.RENT_VALUE),
        2
    ) AS AVG_RENT,

    ROUND(
        AVG(
            CASE
                WHEN G.RENT_VALUE > L.UPPER_BOUND
                THEN G.RENT_VALUE
            END
        ),
        2
    ) AS AVG_OUTLIER_RENT

FROM GOLD.RENT_ANALYTICS G
CROSS JOIN OUTLIER_LIMITS L

WHERE G.RENT_VALUE IS NOT NULL

GROUP BY LEFT(G.QUARTER, 4)

ORDER BY YEAR;

-- 8. Compare outliers using year-specific IQR thresholds
WITH YEARLY_RENT_DISTRIBUTION AS (
    SELECT
        LEFT(QUARTER, 4) AS YEAR,

        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
    GROUP BY LEFT(QUARTER, 4)
),

YEARLY_OUTLIER_LIMITS AS (
    SELECT
        YEAR,
        Q1,
        Q3,
        Q3 - Q1 AS IQR,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND

    FROM YEARLY_RENT_DISTRIBUTION
)

SELECT
    L.YEAR,

    COUNT(G.RENT_VALUE) AS VALID_RECORDS,

    ROUND(L.UPPER_BOUND, 2) AS YEARLY_UPPER_BOUND,

    COUNT_IF(
        G.RENT_VALUE > L.UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        COUNT_IF(G.RENT_VALUE > L.UPPER_BOUND)
        * 100.0 / COUNT(G.RENT_VALUE),
        2
    ) AS OUTLIER_SHARE_PCT,

    ROUND(
        AVG(G.RENT_VALUE),
        2
    ) AS AVG_RENT

FROM GOLD.RENT_ANALYTICS G

INNER JOIN YEARLY_OUTLIER_LIMITS L
    ON LEFT(G.QUARTER, 4) = L.YEAR

WHERE G.RENT_VALUE IS NOT NULL

GROUP BY
    L.YEAR,
    L.UPPER_BOUND

ORDER BY L.YEAR;

-- 9. Analyze outliers using property-specific IQR thresholds
WITH PROPERTY_DISTRIBUTION AS (
    SELECT
        PROPERTY_TYPE,

        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
    GROUP BY PROPERTY_TYPE
),

PROPERTY_LIMITS AS (
    SELECT
        PROPERTY_TYPE,
        Q1,
        Q3,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND

    FROM PROPERTY_DISTRIBUTION
)

SELECT
    G.PROPERTY_TYPE,

    COUNT(*) AS VALID_RECORDS,

    ROUND(L.UPPER_BOUND, 2) AS UPPER_BOUND,

    COUNT_IF(
        G.RENT_VALUE > L.UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        COUNT_IF(G.RENT_VALUE > L.UPPER_BOUND)
        * 100.0 / COUNT(*),
        2
    ) AS OUTLIER_SHARE_PCT,

    ROUND(AVG(G.RENT_VALUE), 2) AS AVG_RENT

FROM GOLD.RENT_ANALYTICS G

INNER JOIN PROPERTY_LIMITS L
    ON G.PROPERTY_TYPE = L.PROPERTY_TYPE

WHERE G.RENT_VALUE IS NOT NULL

GROUP BY
    G.PROPERTY_TYPE,
    L.UPPER_BOUND

ORDER BY OUTLIER_SHARE_PCT DESC;

-- 10. Analyze outliers using bedroom-specific IQR thresholds
WITH BEDROOM_DISTRIBUTION AS (
    SELECT
        BEDROOM,

        PERCENTILE_CONT(0.25)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q1,

        PERCENTILE_CONT(0.75)
            WITHIN GROUP (ORDER BY RENT_VALUE) AS Q3

    FROM GOLD.RENT_ANALYTICS
    WHERE RENT_VALUE IS NOT NULL
    GROUP BY BEDROOM
),

BEDROOM_LIMITS AS (
    SELECT
        BEDROOM,
        Q1,
        Q3,
        Q3 + 1.5 * (Q3 - Q1) AS UPPER_BOUND

    FROM BEDROOM_DISTRIBUTION
)

SELECT
    G.BEDROOM,

    COUNT(*) AS VALID_RECORDS,

    ROUND(L.UPPER_BOUND, 2) AS UPPER_BOUND,

    COUNT_IF(
        G.RENT_VALUE > L.UPPER_BOUND
    ) AS UPPER_OUTLIERS,

    ROUND(
        COUNT_IF(G.RENT_VALUE > L.UPPER_BOUND)
        * 100.0 / COUNT(*),
        2
    ) AS OUTLIER_SHARE_PCT,

    ROUND(AVG(G.RENT_VALUE), 2) AS AVG_RENT

FROM GOLD.RENT_ANALYTICS G

INNER JOIN BEDROOM_LIMITS L
    ON G.BEDROOM = L.BEDROOM

WHERE G.RENT_VALUE IS NOT NULL

GROUP BY
    G.BEDROOM,
    L.UPPER_BOUND

ORDER BY OUTLIER_SHARE_PCT DESC;


-- ============================================================
-- KEY FINDINGS
-- ============================================================
--
-- 1. Global IQR analysis identified 8,608 upper outliers,
--    representing 2.28% of valid rent records.
--
-- 2. No lower outliers were identified.
--
-- 3. The highest global outlier was EUR 6,522.48.
--
-- 4. Detached houses showed the highest outlier share
--    among specific property types (3.39%).
--
-- 5. Properties with four or more bedrooms showed the
--    highest outlier share among bedroom categories (10.21%).
--
-- 6. Ballsbridge, Dublin 4, had the highest number of
--    upper outlier records (683).
--
-- 7. The fixed global threshold identified 10.05% outliers
--    in 2025, while the year-specific IQR identified 1.21%.
--
-- 8. Segment-specific IQR analysis confirmed differences
--    in outlier distributions across property and bedroom
--    categories.
--
-- 9. Outliers were retained. Statistical extremes do not
--    necessarily represent invalid rental observations.
--
-- IMPORTANT:
-- Aggregated categories may overlap with specific categories.
-- Outlier counts must not be interpreted as individual
-- properties or rental contracts.
--
-- ============================================================