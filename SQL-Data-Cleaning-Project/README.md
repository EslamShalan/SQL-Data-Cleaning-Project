# SQL Data Cleaning Project

## Project Overview

This project focuses on cleaning and preparing a layoffs dataset using SQL and MySQL.

The goal of the project is to transform raw and inconsistent data into a cleaner and more reliable dataset that can be used for further analysis.

## Dataset

The dataset contains information about layoffs from companies around the world, including:

- Company
- Location
- Industry
- Total Laid Off
- Percentage Laid Off
- Date
- Stage
- Country
- Funds Raised

## Data Cleaning Process

The following data cleaning steps were performed:

1. **Remove Duplicate Records**
   - Identified duplicate rows using `ROW_NUMBER()` and a CTE.
   - Removed duplicate records while keeping the required record.

2. **Trim Text Values**
   - Removed unnecessary leading and trailing spaces from text columns using `TRIM()`.

3. **Standardize Company Names**
   - Standardized inconsistent capitalization in company names.

4. **Standardize Industry Values**
   - Identified inconsistent industry values and standardized them into consistent categories.

5. **Standardize Country Values**
   - Cleaned inconsistent country names and removed unnecessary characters.

6. **Handle NULL and Blank Values**
   - Identified missing and blank values.
   - Removed records where there was no useful layoff information available.

7. **Standardize Data Types**
   - Converted the date column from text into the appropriate `DATE` data type.
   - Converted percentage values into an appropriate numeric format.

## SQL Techniques Used

- Common Table Expressions (CTEs)
- Window Functions
- `ROW_NUMBER()`
- `PARTITION BY`
- `UPDATE`
- `JOIN`
- `TRIM()`
- `UPPER()`
- `LOWER()`
- `SUBSTRING()`
- `STR_TO_DATE()`
- `GROUP BY`
- Data Type Conversion
- NULL and Blank Value Handling

## Tools

- MySQL
- SQL
- Git & GitHub

## Project Outcome

The raw layoffs dataset was cleaned, standardized, and prepared for exploratory data analysis.

This project demonstrates practical SQL data cleaning techniques and the ability to identify and handle common data quality issues.
