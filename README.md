# Ireland Rental Market Analysis

## Project Overview

This project explores Ireland's rental market using SQL and Snowflake, focusing on rental price trends, property segmentation, geographic differences, data quality, and statistical outlier investigation.

The goal is to transform raw rental market data into a structured analytical dataset and derive insights that help explain how rental prices have evolved across locations, property types, and bedroom categories.

The project follows a structured data workflow, covering data preparation, transformation, validation, and analytical querying.

## Objectives

- Build a structured analytical dataset for rental market analysis.
- Assess data completeness, consistency, and reliability.
- Investigate historical rental price movements.
- Compare rental prices across property types and bedroom categories.
- Identify geographic differences in rental prices.
- Detect and investigate statistical outliers.
- Document the analytical methodology and validation results.

## Technology Stack

- **Snowflake SQL** — data transformation, validation, and analysis.
- **Snowflake** — cloud data warehouse and analytical environment.
- **Git and GitHub** — version control and project documentation.

## Data Model

The main analytical output is the Gold table:

`GLOBAL_TRADE_DB.GOLD.RENT_ANALYTICS`

The table contains 13 fields covering:

| Category | Fields |
|---|---|
| Time | `QUARTER_CODE`, `QUARTER` |
| Geography | `LOCATION_CODE`, `LOCATION` |
| Property | `PROPERTY_TYPE_CODE`, `PROPERTY_TYPE` |
| Bedrooms | `BEDROOM_CODE`, `BEDROOM` |
| Rental metrics | `RENT_VALUE`, `PREVIOUS_YEAR_RENT` |
| Year-over-year metrics | `YOY_CHANGE_EUR`, `YOY_CHANGE_PCT` |
| Availability | `VALID_OBSERVATIONS` |

The analytical dataset contains 1,367,436 records across 73 quarters, 446 locations, 6 property types, and 7 bedroom categories.

The time range extends from **2007 Q4 to 2025 Q4**.

## Data Quality and Validation

Data quality checks were performed to assess null values, duplicate records, dimensional consistency, financial metrics, temporal integrity, and year-over-year calculations.

Key validation results:

| Validation | Result |
|---|---:|
| Total records | 1,367,436 |
| Records with rental values | 376,988 |
| Records without rental values | 990,448 |
| Duplicate dimensional groups | 0 |
| Invalid quarter codes | 0 |
| Quarter label mapping mismatches | 0 |
| Inconsistent dimension mappings | 0 |
| Inconsistent year-over-year calculations | 0 |
| Previous-year reference mismatches | 0 |

The `VALID_OBSERVATIONS` field works as an availability indicator:

- `1`: rental value available.
- `0`: rental value unavailable.

The absence of a rental value does not automatically indicate a defective record. It represents unavailable rental observations for a given analytical combination.

## Outlier Analysis

A statistical outlier investigation identified **8,608 upper outlier records**.

The investigation included:

- Statistical detection of unusually high rental values.
- Investigation of affected property types and bedroom categories.
- Assessment of outlier distribution.
- Reconciliation of category-level counts with the overall outlier total.

The category-level reconciliation matched the total of 8,608 records, with no unexplained difference.

Outliers were investigated as analytical observations rather than automatically removed from the dataset.

## Key Analytical Findings

### 1. Historical Rental Market Evolution

The average rental value across available analytical combinations increased from **€1,019.43 in 2007 Q4** to **€1,576.35 in 2025 Q4**, representing an increase of approximately **54.63%**.

The lowest quarterly average was observed in **2012 Q2**, at €784.86.

The historical pattern shows:

- A decline in rental values during the period following 2007.
- A gradual recovery from around 2013.
- More moderate movements during 2020–2022.
- Stronger growth between 2023 and 2025.

### 2. Property Type and Bedroom Segmentation

The segmentation analysis compared 2024 Q4 and 2025 Q4.

Among the property-type aggregates, semi-detached houses had the highest average rental value in 2025 Q4, at **€1,771.20**.

The highest individual segment averages included:

- Apartments with four or more bedrooms: €2,560.93.
- Other flats with three bedrooms: €2,560.53.
- Terrace houses with four or more bedrooms: €2,454.88.

Some segments had very few observations. Their results should therefore be interpreted with caution.

### 3. Geographic Rental Differences

The geographic analysis showed substantial differences between locations.

Among locations with at least five valid observations in 2025 Q4:

- Blackrock, Dublin had the highest average rental value, at **€2,872.88**.
- Donegal had the lowest average rental value among the selected locations, at **€917.40**.

All ten locations in the most expensive ranking were in Dublin.

### 4. Geographic Growth Consistency

A comparable-location analysis required at least five valid observations in both 2024 Q4 and 2025 Q4.

| Metric | Result |
|---|---:|
| Comparable locations | 206 |
| Locations with rental increases | 190 |
| Locations with rental decreases | 16 |
| Locations with no change | 0 |
| Average location-level growth | 7.19% |
| Median location-level growth | 7.05% |

Approximately **92.23%** of comparable locations experienced an increase in average rental values.

This indicates that rental growth was geographically widespread across the locations meeting the minimum observation criteria.

## Methodological Considerations

The reported rental averages are calculated across available analytical combinations of location, property type, and bedroom category.

They are not weighted by the number of rental contracts or tenants. Therefore, they should not be interpreted as the official national average rent paid by all tenants in Ireland.

Geographic and property-segment comparisons can also be affected by changes in data coverage and the composition of available observations between periods.

Minimum observation thresholds were applied to improve the reliability of selected geographic comparisons.

## Repository Structure

```text
ireland-rental-market-analysis/
│
├── README.md
├── sql/
│   ├── 01_database_setup/
│   ├── 02_data_ingestion/
│   ├── 03_staging/
│   ├── 04_transformations/
│   ├── 05_data_quality/
│   ├── 06_outlier_analysis/
│   └── 07_business_analysis/
│
├── docs/
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── analysis_findings.md
│   └── methodology.md
│
└── results/
```

## Project Status

The analytical and validation stages have been completed for the documented checks. The repository is being organized to preserve the SQL workflow, methodology, and findings.

## Author

**Brenda Espinosa Barros**

Data Analytics | SQL | Snowflake | Python | Data Engineering

[GitHub](https://github.com/brendaespinosaa)
