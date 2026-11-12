# Analysis Findings

## 1. Dataset Overview

| Metric | Value |
|---|---:|
| Total records | 1,367,436 |
| Records with rental values | 376,988 |
| Records without rental values | 990,448 |
| Rental value availability | 27.57% |
| Rental value unavailability | 72.43% |
| Distinct quarters | 73 |
| Distinct locations | 446 |
| Distinct property types | 6 |
| Distinct bedroom categories | 7 |
| First quarter | 2007 Q4 |
| Last quarter | 2025 Q4 |

## 2. Historical Rental Market Evolution

| Metric | Result |
|---|---:|
| Average rent in 2007 Q4 | €1,019.43 |
| Lowest quarterly average | €784.86 |
| Quarter with lowest average | 2012 Q2 |
| Average rent in 2025 Q4 | €1,576.35 |
| Overall increase, 2007 Q4–2025 Q4 | 54.63% |

The analysis indicates a decline in average rental values after 2007, followed by a recovery from approximately 2013. Growth became stronger during 2023–2025.

## 3. Property Segmentation

### Highest 2025 Q4 Average Rents

| Property Type | Bedroom Category | Average Rent |
|---|---|---:|
| Apartment | Four plus bed | €2,560.93 |
| Other flats | Three bed | €2,560.53 |
| Terrace house | Four plus bed | €2,454.88 |

### Highest Growth Rates

| Property Type | Bedroom Category | Average YOY Change |
|---|---|---:|
| Other flats | Three bed | 14.82% |
| Detached house | Four plus bed | 12.92% |
| Detached house | Three bed | 11.38% |
| Terrace house | Four plus bed | 11.26% |
| Semi-detached house | Three bed | 11.23% |

Some categories have very limited observations, including categories with only one valid record in 2025 Q4. These results should not be generalized to the entire property segment.

## 4. Geographic Analysis

### Most Expensive Locations

| Location | Average Rent, 2025 Q4 |
|---|---:|
| Blackrock, Dublin | €2,872.88 |
| Ballsbridge, Dublin 4 | €2,628.75 |
| Dalkey, Dublin | €2,592.84 |
| Glenageary, Dublin | €2,588.72 |
| Killiney, Dublin | €2,534.86 |

### Most Affordable Locations

| Location | Average Rent, 2025 Q4 |
|---|---:|
| Donegal | €917.40 |
| Tipperary Town | €935.41 |
| Buncrana, Donegal | €946.18 |
| Castlerea, Roscommon | €971.55 |
| Ballina, Mayo | €997.15 |

These rankings use a minimum of five valid records in 2025 Q4.

## 5. Geographic Growth Consistency

The comparable-location analysis required at least five valid observations in both 2024 Q4 and 2025 Q4.

| Metric | Result |
|---|---:|
| Comparable locations | 206 |
| Locations with an increase | 190 |
| Locations with a decrease | 16 |
| Locations with no change | 0 |
| Average location-level growth | 7.19% |
| Median location-level growth | 7.05% |
| Minimum growth | -5.61% |
| Maximum growth | 23.67% |

A total of 92.23% of comparable locations experienced an increase in average rental values.

## 6. Data Availability Analysis

Rental value availability varies considerably across time and property segments.

### Historical Availability

| Metric | Result |
|---|---:|
| Highest yearly availability | 31.85% (2015 and 2016) |
| Availability in 2007 | 14.34% |
| Availability in 2025 | 16.60% |

The percentage of available rental values declined after 2016. This means that comparisons across periods should account for changes in data coverage.

### Availability by Property Type

| Property Type | Valid Records | Availability |
|---|---:|---:|
| All property types | 141,675 | 62.16% |
| Apartment | 89,167 | 39.12% |
| Semi detached house | 57,565 | 25.26% |
| Terrace house | 46,038 | 20.20% |
| Detached house | 24,851 | 10.90% |
| Other flats | 17,692 | 7.76% |

### Availability by Bedroom Category

| Bedroom Category | Valid Records | Availability |
|---|---:|---:|
| All bedrooms | 91,408 | 46.79% |
| 1 to 3 bed | 82,506 | 42.24% |
| 1 to 2 bed | 56,111 | 28.72% |
| Three bed | 48,547 | 24.85% |
| Two bed | 47,101 | 24.11% |
| Four plus bed | 26,201 | 13.41% |
| One bed | 25,114 | 12.86% |

Aggregated categories have higher data availability than several detailed categories. Missing rental values indicate unavailable values in the source dataset and do not necessarily indicate the absence of rental market activity.

## 7. Data Quality Validation

The Gold dataset was evaluated using structural, numerical, uniqueness, temporal, and calculation consistency checks.

| Validation | Result |
|---|---:|
| Total records | 1,367,436 |
| Null dimension fields | 0 |
| Non-positive rental values | 0 |
| Non-positive previous-year rents | 0 |
| Duplicate business-key groups | 0 |
| Invalid quarter codes | 0 |
| Quarter label mismatches | 0 |
| Inconsistent observation flags | 0 |
| Inconsistent YoY calculations | 0 |

The business key used for duplicate detection consists of quarter, location, property type, and bedroom category.

### Year-over-Year Reference Validation

The previous-year reference was checked against the corresponding record for the same location, property type, and bedroom category.

| Metric | Result |
|---|---:|
| Available previous-year references | 364,547 |
| Unexpected previous-year values | 0 |
| Missing expected references | 0 |
| Previous-year reference mismatches | 0 |
| Records with both values available for YoY validation | 338,786 |
| YoY EUR calculation mismatches | 0 |
| YoY percentage calculation mismatches | 0 |

The YoY calculations were consistent with their underlying rental values and previous-year references.

### YoY Change Distribution

| Change Direction | Records | Share |
|---|---:|---:|
| Increase | 238,538 | 70.41% |
| Decrease | 100,228 | 29.58% |
| No change | 20 | 0.01% |
| Total | 338,786 | 100.00% |

These records represent analytical combinations of quarter, location, property type, and bedroom category, not individual tenants or rental contracts.

## 8. Outlier Investigation

Extreme rental values were investigated using the Interquartile Range (IQR) method.

### Global IQR Analysis

| Metric | Result |
|---|---:|
| Valid rental records | 376,988 |
| Lower outliers | 0 |
| Upper outliers | 8,608 |
| Upper outlier share | 2.28% |
| Minimum upper outlier | €2,221.04 |
| Maximum upper outlier | €6,522.48 |
| Average upper outlier rent | €2,612.41 |
| Affected locations | 122 |
| Affected quarters | 73 |

The global IQR upper boundary was approximately €2,221.01.

### Outliers by Property Type

Using the global IQR threshold, detached houses showed the highest outlier share among specific property types, at 3.39%.

A separate property-specific IQR analysis produced the following results:

| Property Type | Upper Outlier Share |
|---|---:|
| Detached house | 6.43% |
| Semi detached house | 3.03% |
| Terrace house | 2.14% |
| Apartment | 1.12% |
| Other flats | 1.01% |

### Outliers by Bedroom Category

Using the global IQR threshold, four-plus-bedroom properties showed the highest outlier share, at 10.21%.

When individual IQR thresholds were calculated for each bedroom category, the results were:

| Bedroom Category | Upper Outlier Share |
|---|---:|
| Four plus bed | 4.08% |
| Three bed | 2.59% |
| 1 to 3 bed | 1.44% |
| 1 to 2 bed | 1.11% |
| Two bed | 1.10% |
| One bed | 0.68% |

### Historical Outlier Comparison

The fixed global threshold identified an increasing share of upper outliers over time, reaching 10.05% in 2025.

However, when annual IQR thresholds were applied, the 2025 outlier share was 1.21%.

This difference indicates that the increasing share under the fixed global threshold is partly associated with changes in the overall rental price distribution over time.

Outliers were retained for investigation rather than automatically removed, as statistically extreme values are not necessarily invalid observations.

## 9. Interpretation and Limitations

The analysis uses averages across available location, property type, and bedroom combinations. These averages are not weighted by the number of rental contracts.

The number of valid observations varies across quarters and segments. Geographic comparisons use minimum observation thresholds to reduce the influence of very small samples.

Missing rental values represent unavailable source values and should not automatically be interpreted as zero rent or absence of market activity.

Outlier detection is based on statistical thresholds. An observation classified as an outlier is not necessarily an error or an invalid rental value.

Aggregated categories, such as `All property types` and `All bedrooms`, may overlap with detailed categories and should not be summed as independent groups.

The results describe the available analytical dataset and should not be interpreted as a direct measure of the rent paid by every tenant in Ireland.
