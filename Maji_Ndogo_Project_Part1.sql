-- Get to know our data
SHOW tables;

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


-- Dive into the water sources
-- Write a query to find all the unique types of water sources
SELECT DISTINCT 
    type_of_water_source
FROM
	md_water_services.water_source;
    
-- Unpack the visits to water sources
-- Write a query that retrieves all records from the visits table where the time in queue is more than some crazy time, say 500 min.
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

-- Assess the quality of water sources
SELECT *
FROM md_water_services.water_quality
WHERE subjective_quality_score = 10 AND visit_count >= 2;

-- Investigate pollution issues
-- print the first few rows of well_pollution table
SELECT * 
FROM md_water_services.well_pollution
LIMIT 5;

-- Write a query that checks if the results is clean but the biological column is > 0.01.
SELECT *
FROM md_water_services.well_pollution
WHERE results = 'Clean' AND biological > 0.01;

SELECT *
FROM md_water_services.well_pollution
WHERE description LIKE 'Clean_%';


CREATE TABLE well_pollution__copy
AS ( SELECT * FROM well_pollution );

SELECT * FROM well_pollution_copy
WHERE biological > 0.01 AND results = 'Clean';
SELECT * FROM well_pollution_copy
WHERE description LIKE 'Clean_%';


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
    
UPDATE
    well_pollution_copy
SET
    results = 'Contaminated: Biological'
WHERE
    biological > 0.01 AND results = 'Clean';

-- Put a test query here to make sure we fixed teh errors
-- Use the query we used to show all of the erronous rows
SELECT *
FROM well_pollution_copy
WHERE 
    description LIKE 'Clean_%'
    OR (results = 'Clean' AND biological > 0.01);

