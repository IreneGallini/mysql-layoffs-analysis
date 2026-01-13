-- Exploratory data analysis

SELECT *
FROM layoffs_staging2;

#biggest numerical values
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

# where the whole company was laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;


# date range
SELECT MIN(date), max(date)
FROM layoffs_staging2;


# total layoffs by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# Rolling sum
WITH Rolling_total AS (
	SELECT SUBSTRING(date,1,7) AS month, SUM(total_laid_off) as total_off
    FROM layoffs_staging2
    GROUP BY month
    ORDER BY 1 ASC
)
SELECT month, SUM(total_off) OVER(ORDER BY month) AS rolling_total
FROM Rolling_total;

# total layoffs by company
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# layoffs by company per year
SELECT company, YEAR(date) AS year, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, YEAR(date) 
ORDER BY total_laid_off DESC;

WITH Company_year AS (
	SELECT company, YEAR(date) AS year, SUM(total_laid_off) as total_laid_off
	FROM layoffs_staging2
	GROUP BY company, YEAR(date) 
), 
Company_year_rank AS (
	SELECT *, DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS Ranking
	FROM Company_year
	WHERE year IS NOT NULL
	ORDER BY Ranking
)
SELECT *
FROM Company_year_rank
WHERE Ranking<=5;