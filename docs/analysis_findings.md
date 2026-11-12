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

## 6. Outlier Investigation

The statistical investigation identified 8,608 upper outlier records.

The outlier counts were reconciled across property type and bedroom categories, with no unexplained difference.

Outliers were retained for investigation rather than automatically removed.

## 7. Interpretation and Limitations

The analysis uses averages across available location, property type, and bedroom combinations. These averages are not weighted by the number of rental contracts.

The number of valid observations varies across quarters and segments. Geographic comparisons use minimum observation thresholds to reduce the influence of very small samples.

The results describe the available analytical dataset and should not be interpreted as a direct measure of the rent paid by every tenant in Ireland.
