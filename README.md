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

##  Database Tables
The dataset included the following key tables:
- **location** → Province, town, and location types  
- **water_source** → Types of water sources and population served  
- **visits** → Records of visits to water sources, queue times, and employees  
- **water_quality** → Subjective water quality scores  
- **well_pollution** → Pollution test results for wells  

---

##  Key Queries
- **1. Exploring database structure**
  ```sql
-- Get to know our data
SHOW tables;
-- Preview first 5 rows of key tables
SELECT *
FROM md_water_services.location
LIMIT 5;
SELECT *
FROM md_water_services.visits
LIMIT 5;
SELECT *
FROM md_water_services.water_source
LIMIT 5;
SELECT *
FROM md_water_services.employee
LIMIT 5;
SELECT *
FROM md_water_services.global_water_access
LIMIT 5;
SELECT *
FROM md_water_services.water_quality
LIMIT 5;
SELECT *
FROM md_water_services.well_pollution
LIMIT 5;
SELECT *
FROM md_water_services.data_dictionary
LIMIT 5;

- **2. Water Source Types**
-- Dive into the water sources
-- Find all the unique types of water sources
SELECT DISTINCT 
    type_of_water_source
FROM
	md_water_services.water_source;

- **3. Visits Analysis**
-- Unpack the visits to water sources
-- Find visits where the time in queue is more than 500 min(8+ hrs).
SELECT *
FROM 
    md_water_services.visits
WHERE
    time_in_queue > 500;
-- type of water sources with long queue time
SELECT *
FROM md_water_services.water_source
WHERE source_id IN
    ('AkKi00881224',
    'SoRu37635224',
    'SoRu36096224',
    'AkRu05234224',
    'HaZa21742224');

- **4. Water Quality Checks**
-- Assess the quality of water sources
-- Check for taps in homes with perfect quality score (10)
-- that were visited more than once
SELECT *
FROM md_water_services.water_quality
WHERE subjective_quality_score = 10 AND visit_count >= 2;

- **5. Pollution Inconsistencies**
-- Investigate pollution issues
-- print the first few rows of well_pollution table
SELECT * 
FROM md_water_services.well_pollution
LIMIT 5;

-- Check for inconsistencies in the table
-- by checking if the results is clean but the biological column is > 0.01.
SELECT *
FROM md_water_services.well_pollution
WHERE results = 'Clean' AND biological > 0.01;
SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'Clean_%';

- **6. Pollution data corrections**
-- Create a copy of the well pollution table for data corrections
-- Check for inconsistencies in the table
CREATE TABLE well_pollution__copy
AS ( SELECT * FROM well_pollution );
SELECT * FROM well_pollution_copy
WHERE biological > 0.01 AND results = 'Clean';
SELECT * FROM well_pollution_copy
WHERE description LIKE 'Clean_%';

-- Correct mistaken descriptions
SET SQL_SAFE_UPDATES = 0;
UPDATE 
    well_pollution_copy
SET 
    description = 'Bacteria: E. coli'
WHERE 
    description = 'Clean Bacteria: E. coli';
UPDATE
    well_pollution_copy
SET
    description = 'Bacteria: Giardia Lamblia'
WHERE
    description = 'Clean Bacteria: Giardia Lamblia';
    
-- Correct misclassified results    
UPDATE
    well_pollution_copy
SET
    results = 'Contaminated: Biological'
WHERE
    biological > 0.01 AND results = 'Clean';
    
- **7. Test the Query**
-- Put a test query here to make sure we fixed the errors
-- Use the query we used to show all of the erronous rows
SELECT *
FROM well_pollution_copy
WHERE 
    description LIKE 'Clean_%'
    OR (results = 'Clean' AND biological > 0.01);

-- If we're sure it works as intended, we can change the table back to the well_pollution and delete the well_pollution_copy
table.
DROP TABLE
md_water_services.well_pollution_copy;


