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
- **Exploring structure**
  ```sql
  SHOW TABLES;
  SELECT * FROM location LIMIT 5;

