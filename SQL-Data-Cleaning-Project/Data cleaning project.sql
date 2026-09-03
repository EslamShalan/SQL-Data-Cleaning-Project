-- Data cleaning Project

-- [1] CREATE a DATABASE either by mouse (click on create a new schema) or using query statement

-- [2] right click Tables menu in the DB world_layoffs and Import data.  We got the data itself from GitHUb and downloaded it. 

-- [3] leave every thing as it. then we will modify them (data type mainly)

-- [4] double click the world_layoffs from the Schemas menu to use it. 


-- Steps for data cleaning
-- 1. Remove Duplicates
-- 2. Standardize the Data (i.e: ESLam ==> Eslam)
-- 3.NULL Values or blank values
-- 4.Remove any Columns or rows



-- Like ==> شبه
-- This will create a table with the same columns of the previous table. 
CREATE TABLE layoffs_staging 
LIKE layoffs;


SELECT * from layoffs;
-- Only columns shown here
SELECT * from layoffs_staging;

-- Insert the data in the staging table  (Insert = Insert Into)
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- After inserting data to table
SELECT * from layoffs_staging;


-- [1] Removing duplicates
-- Note : for any reserved word in MySQL do it between `` example : (date ==> `date`)

SELECT * ,
ROW_NUMBER() OVER(partition by company,industry,total_laid_off,percentage_laid_off,`date`) As row_num
FROM layoffs_staging;

-- We have to make either subquery or CTE as we want to make a query on the query. 

WITH duplicate_cte AS
(
-- "لكل مجموعة (rows) عندها نفس Column values , رقملي كل row جواها"
SELECT * ,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) As row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

-- Check they are duplicates first.
SELECT * FROM layoffs_staging
WHERE company = 'Yahoo';


-- This works in SQL server , but not here. 
WITH duplicate_cte AS
(
-- "لكل مجموعة (rows) عندها نفس Column values , رقملي كل row جواها"
SELECT * ,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) As row_num
FROM layoffs_staging
)
DELETE FROM duplicate_cte
WHERE row_num > 1;


-- 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,
stage,country,funds_raised_millions) As row_num
FROM layoffs_staging;


DELETE FROM layoffs_staging2
WHERE row_num > 1;


-- [2] Standardizaing data ==> finding issues in your data and fixing it. 
-- 1) TRIM spaces

-- Test the trim before action
SELECT distinct company , TRIM(company)
FROM layoffs_staging2;

Update layoffs_staging2
SET company = trim(company);

-- 2) Redundant data with the same meaning like "CRYPTO"
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry like 'CRYPTO%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry like 'CRYPTO%';

-- 3)issue 'United states' & 'United states.'
-- trailing 'What Endswith' ==>  used with trim
SELECT Distinct country , TRIM(trailing '.' FROM country)
FROM layoffs_staging2
ORDER By 1;

UPDATE layoffs_staging2
SET country = TRIM(trailing '.' FROM country)
WHERE country like 'United States%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- 4) Change date format from text to date using str_to_date(current_date,old_date_format)
SELECT `date` , str_to_date(`date`,'%m/%d/%Y')
FROM layoffs_staging2;


Update layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y');

-- We notice that the date in the schema is text although we change its format , but we did not change the column name format

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

SELECT * FROM layoffs_staging2;


-- [3] Deal with blank and null values
-- 1) here if total_laid_off & percentage_laid_off is NULL so its useless as the table is for layoffs
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off is NULL
and total_laid_off is NULL;

-- 2) As we found before industry has null values & empty values
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;


-- OR by this query we check also
SELECT  * 
FROM layoffs_staging2
WHERE industry = ''
OR industry is NULL;

-- 3) Check a certain company
SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- 4) Self join

-- But first Update all blank values to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT t1.industry , t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry is NULL OR t1.industry = '')
AND t2.industry is NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry is NULL OR t1.industry = '')
AND t2.industry is NOT NULL;


DELETE
FROM layoffs_staging2
WHERE percentage_laid_off is NULL
and total_laid_off is NULL;

SELECT distinct * FROM layoffs_staging2;

-- DROP the column row_num
ALTER TABLE layoffs_staging2
DROP column row_num

