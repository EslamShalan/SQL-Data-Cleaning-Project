-- EDA ==> Exploratory data analysis

SELECT * FROM
layoffs_staging2;

-- SUM = إجمالي layoffs للشركة عبر كل الـ rows
-- MAX = أكبر قيمة layoffs موجودة في row واحد

-- Q1 ==> Get for each company the total_number of lay offs done?
-- important note ==> take care of null before doing an aggeregate function
SELECT company,sum(total_laid_off) as total_layoffs
FROM layoffs_staging2
WHERE total_laid_off is not null
GROUP BY company
ORDER By 2 DESC;
  
-- conclusion ==> we can get the minimum and maximum companies done total_layoffs
WITH company_layoffs AS (
    SELECT company,
           SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging2
    WHERE total_laid_off IS NOT NULL
    GROUP BY company
	ORDER BY 2 DESC
)
SELECT * 
FROM Company_layoffs
WHERE total_layoffs = (SELECT max(total_layoffs) FROM company_layoffs)
or total_layoffs = (SELECT min(total_layoffs) FROM company_layoffs);

-- Q2 ==> Which industries has the highest number of layoffs?
SELECT industry , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP BY industry 
ORDER By total_layoffs DESC
limit 3;


-- dataset overview  ==> What are the Duration of layoffs?
SELECT MIN(`date`) as start_date , MAX(`date`) as end_date FROM layoffs_staging2;

-- Q3 ==> Which year had the highest total number of layoffs?
SELECT YEAR(`date`) AS year,
       SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY total_layoffs DESC
LIMIT 1;

-- Q4 ==> what are the country that has the lowest number of layoffs ?

SELECT country , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP by country 
HAVING SUM(total_laid_off) is not null
Order by 2 
limit 1;

-- Q5 ==> what company has the highest funds_raised_millions?
-- Note funds are constant value ==> hint : use Max()  not SUM()
SELECT company , MAX(funds_raised_millions) as total_funds FROM layoffs_staging2
GROUP BY company 
ORDER by 2 DESC;

SELECT * FROM layoffs_staging2
WHERE company like 'Netflix%';

-- Instructor's business questions
SELECT * FROM layoffs_staging2;

-- Q1 ==> What are the highest number of layoff & percentage_layoff done once or in a certain row(date)
SELECT MAX(total_laid_off) , MAX(percentage_laid_off) FROM layoffs_staging2;

# explore dataset from main query
SELECT * FROM layoffs_staging2;

-- Q2 ==> What is the number of layoffs done where it's 100% of the company employees
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Q3 ==> What are the funds a stakeholder or investor invest within a company
-- where it's 100% of the company's employees laid off
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- exploring dataset 
SELECT MIN(`date`) as start_date , MAX(`date`) as end_date FROM layoffs_staging2;

-- Q2 again here (repeated)
SELECT industry , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP BY industry 
ORDER By total_layoffs DESC;

-- Q3 as Q2 , but with country
SELECT country , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP BY country 
ORDER By total_layoffs DESC;


SELECT YEAR(`date`) year , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP BY YEAR(`date`) 
ORDER By 1 DESC;

SELECT stage , SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP BY stage
ORDER By 2 DESC;


-- Intermediate queries starts here 

SELECT SUBSTRING(`date`,1,7) as MONTH  , SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is not null
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- rolling total the sum
WITH rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) as MONTH  , SUM(total_laid_off) as total_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) is not null
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` , total_layoffs,SUM(total_layoffs) OVER(ORDER by `MONTH`) as rolling_total
FROM rolling_total;

# OVER( ORDER BY ) ==> Get the sum(total_layoffs) , but in order (1st cell , 1st & 2nd cell , 1st , 2nd,3rd cell, etc)

-- Q* ==> What is the ranking of the company with the highest layoffs in each year?
SELECT company ,YEAR(`date`) ,SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP by company , YEAR(`date`)
HAVING SUM(total_laid_off) is not null
Order by 3 DESC ;

WITH Company_Year(company,years,total_laid_off) AS
(
SELECT company ,YEAR(`date`) ,SUM(total_laid_off) as total_layoffs FROM layoffs_staging2
GROUP by company , YEAR(`date`)
HAVING SUM(total_laid_off) is not null
Order by 3 DESC 
) , Company_year_rank AS
(
SELECT * , dense_rank() over(PARTITION BY years order BY total_laid_off DESC) as Ranking
FROM Company_Year
WHERE years is not null
)
SELECT * FROM company_year_rank
WHERE Ranking <= 5;