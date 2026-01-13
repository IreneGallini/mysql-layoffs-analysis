--- Data cleaning
SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null or blank values
-- 4. Remove unecessary columns/rows

-- Best practice not to work with raw data
CREATE TABLE layoffs_staging 
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- 1. Remove duplicates
# make unique id using window function
# plug that in a CTE

SELECT *
FROM layoffs_staging;

WITH duplicate_cte AS 
(
	SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY company, location, 
        industry, total_laid_off, percentage_laid_off, 
        'date', stage, country, funds_raised ) AS row_num
	FROM layoffs_staging
)

#find duplicates
SELECT *
FROM duplicate_cte
WHERE row_num>1;

#delete duplicates -> we can't update a CTE 


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
	PARTITION BY company, location, 
	industry, total_laid_off, percentage_laid_off, 
	'date', stage, country, funds_raised ) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

-- 2. Standardizing data

UPDATE layoffs_staging2
SET company=TRIM(company); #take white space off the end

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; #set Cryptocurrency to Crypto

SELECT *
FROM layoffs_staging2;

SELECT DISTINCT(location)
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET `date`=str_to_date(`date`,'%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Null values
# this data has empty spaces instead of setting those cells as nulls

# total laid off and percentage laid off have some empty ' ' text values -> remove them
UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off IS NULL
   OR TRIM(percentage_laid_off) = '';
   
UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off IS NULL
   OR TRIM(total_laid_off) = '';

#convert to decimal or int
ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off DECIMAL(5,2);

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Remove unecessary columns/rows

# We don't have a way to populate the null values for total_laid_off and percentage_laid_off
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

ALTER TABLE layoffs_staging2 DROP COLUMN source;

ALTER TABLE layoffs_staging2 DROP COLUMN date_added;

-- Final cleaned dataset
SELECT * 
FROM layoffs_staging2;

















