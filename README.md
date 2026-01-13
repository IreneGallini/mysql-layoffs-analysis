
# MySQL Data Cleaning & Exploratory Data Analysis (EDA) Project

## Project Overview
This project demonstrates an end-to-end SQL workflow using MySQL, from cleaning raw data to performing exploratory data analysis (EDA).  
The dataset contains company layoff information with inconsistent formatting, missing values, and duplicate records.

The project is divided into two phases:
1. **Data Cleaning** – preparing the raw data for analysis
2. **Exploratory Data Analysis (EDA)** – analyzing trends and patterns in layoffs


**Dataset Source:**  
https://www.kaggle.com/datasets/swaptr/layoffs-2022


## Data Cleaning (`01_data_cleaning.sql`)
Key data cleaning steps performed:

- Created staging tables to preserve raw data integrity
- Removed duplicate records using `ROW_NUMBER()` and window functions
- Standardized text fields (e.g., trimming whitespace, consolidating categories)
- Converted text-based numeric and date fields into proper data types
- Handled NULL and blank values appropriately
- Removed rows with insufficient layoff information
- Dropped unnecessary columns after cleaning

**Result:** A clean, structured dataset ready for analysis.

## 📊 Exploratory Data Analysis (`02_eda.sql`)
The EDA focuses on understanding the scope and patterns of layoffs.

Key analyses include:
- Identifying the maximum number of layoffs and highest layoff percentages
- Finding companies that laid off 100% of their workforce
- Determining the overall date range of layoff events
- Analyzing total layoffs by country
- Calculating rolling monthly layoff totals using window functions
- Ranking companies by total layoffs overall and by year
- Identifying the top 5 companies with the most layoffs per year

Advanced SQL techniques used:
- Common Table Expressions (CTEs)
- Window functions (`ROW_NUMBER`, `DENSE_RANK`, `SUM() OVER`)
- Date-based aggregation

## Key Insights
- Layoffs are heavily concentrated in specific industries and companies
- Several companies experienced complete workforce layoffs
- Layoff activity peaked during specific years and months
- A small number of companies account for a large proportion of total layoffs


