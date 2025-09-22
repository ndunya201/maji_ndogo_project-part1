# maji_ndogo_SQL_project-part1

This project explores **water access, quality, and pollution issues** in the fictional town of **Maji Ndogo**.  
Using SQL queries, I worked with a dataset of **60,000+ survey records** to uncover patterns, identify inconsistencies, and improve data quality.

---

## Project Objectives

- Explore the database structure and foundational tables  
- Analyze water source types and visits  
- Assess water quality and flag inconsistencies  
- Investigate pollution data and clean misclassified records  

---

## Database Tables

The dataset includes the following key tables:
- **location**: Province, town, and location types  
- **water_source**: Types of water sources and population served  
- **visits**: Records of visits to water sources, queue times, and employees  
- **water_quality**: Subjective water quality scores  
- **well_pollution**: Pollution test results for wells  

---

## Key Queries

### 1. Exploring Database Structure

Preview the database structure and sample data from key tables.

```sql
-- Get to know our data
SHOW TABLES;

-- Preview first 5 rows of key tables
SELECT * FROM md_water_services.location LIMIT 5;
SELECT * FROM md_water_services.visits LIMIT 5;
SELECT * FROM md_water_services.water_source LIMIT 5;
SELECT * FROM md_water_services.employee LIMIT 5;
SELECT * FROM md_water_services.global_water_access LIMIT 5;
SELECT * FROM md_water_services.water_quality LIMIT 5;
SELECT * FROM md_water_services.well_pollution LIMIT 5;
SELECT * FROM md_water_services.data_dictionary LIMIT 5;
```

---

### 2. Water Source Types

Identify unique types of water sources in the database.

```sql
-- Find all unique water source types
SELECT DISTINCT type_of_water_source
FROM md_water_services.water_source;
```

---

### 3. Visits Analysis

Analyze visits to water sources, focusing on long queue times.

```sql
-- Find visits with queue time exceeding 500 minutes (8+ hours)
SELECT *
FROM md_water_services.visits
WHERE time_in_queue > 500;

-- Inspect water sources with long queue times
SELECT *
FROM md_water_services.water_source
WHERE source_id IN ('AkKi00881224', 'SoRu37635224', 'SoRu36096224', 'AkRu05234224', 'HaZa21742224');
```

---

### 4. Water Quality Checks

Evaluate water quality for home taps with high quality scores and multiple visits.

```sql
-- Check for home taps with perfect quality score (10) and multiple visits
SELECT *
FROM md_water_services.water_quality
WHERE subjective_quality_score = 10 AND visit_count >= 2;
```

---

### 5. Pollution Inconsistencies

Investigate inconsistencies in the `well_pollution` table.

```sql
-- Preview well_pollution table
SELECT * 
FROM md_water_services.well_pollution
LIMIT 5;

-- Identify inconsistencies where results are 'Clean' but biological contamination > 0.01
SELECT *
FROM md_water_services.well_pollution
WHERE results = 'Clean' AND biological > 0.01;

-- Check for incorrect 'Clean' descriptions
SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'Clean_%';
```

---

### 6. Pollution Data Corrections

Correct inconsistencies in the `well_pollution` table using a temporary copy.

```sql
-- Create a copy of the well_pollution table
CREATE TABLE md_water_services.well_pollution_copy
AS (SELECT * FROM md_water_services.well_pollution);

-- Verify inconsistencies in the copy
SELECT * 
FROM md_water_services.well_pollution_copy
WHERE biological > 0.01 AND results = 'Clean';

SELECT * 
FROM md_water_services.well_pollution_copy
WHERE description LIKE 'Clean_%';

-- Disable safe updates for modifications
SET SQL_SAFE_UPDATES = 0;

-- Correct mistaken descriptions
UPDATE md_water_services.well_pollution_copy
SET description = 'Bacteria: E. coli'
WHERE description = 'Clean Bacteria: E. coli';

UPDATE md_water_services.well_pollution_copy
SET description = 'Bacteria: Giardia Lamblia'
WHERE description = 'Clean Bacteria: Giardia Lamblia';

-- Correct misclassified results
UPDATE md_water_services.well_pollution_copy
SET results = 'Contaminated: Biological'
WHERE biological > 0.01 AND results = 'Clean';
```

---

### 7. Verify Corrections

Test the corrections and clean up.

```sql
-- Verify no erroneous rows remain
SELECT *
FROM md_water_services.well_pollution_copy
WHERE description LIKE 'Clean_%'
   OR (results = 'Clean' AND biological > 0.01);

-- If corrections are successful, apply changes to the original table and drop the copy
-- (Uncomment to execute)
-- DROP TABLE md_water_services.well_pollution_copy;
```

---

## Notes

- Ensure you have appropriate permissions to modify the database.
- The `DROP TABLE` statement is commented out to prevent accidental deletion. Uncomment only when ready to finalize changes.
- Run queries in a test environment before applying to production.

## Contributing

Contributions are welcome! Please submit a pull request with any improvements or additional analyses.
