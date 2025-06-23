USE [USAMacroeconomicRateOfChanges1993_2025]
GO

SELECT *
  FROM [dbo].[macro_monthly]

  --Step 1: Initial Exploration and Verification ??
--First, let's get a feel for the data we just imported. This step is a crucial best practice to ensure the data loaded correctly and to understand its basic characteristics.

--Run these queries in a new query window in SSMS.

--A. Confirm Row Count. Check if all records were imported. We expect 384 rows.

SELECT COUNT(*) AS TotalRows
FROM dbo.macro_monthly;

--B. Preview the Data
    --Look at the first few rows to ensure the columns and values look correct.

SELECT TOP 10 *
FROM dbo.macro_monthly;

--C. Calculate Basic Descriptive Statistics
    -- Find the average, minimum, and maximum values for our key indicators. This tells us the typical range of monthly changes.

	SELECT
    AVG(Consumer_Price_Index) AS Avg_CPI_Change,
    MIN(Consumer_Price_Index) AS Min_CPI_Change,
    MAX(Consumer_Price_Index) AS Max_CPI_Change,
    AVG(Unemployment_Rate) AS Avg_Unemployment_Change,
    MIN(Unemployment_Rate) AS Min_Unemployment_Change,
    MAX(Unemployment_Rate) AS Max_Unemployment_Change
FROM dbo.macro_monthly;

-- Insight: This query gives us a baseline understanding. For example, a positive Avg_Unemployment_Change would tell us that, on average, unemployment has tended to increase month-over-month in our dataset.

--Step 2: Core Analysis - The Phillips Curve Relationship ??
    --Now we get to the core of the business task: investigating the relationship between inflation and unemployment. The classic Phillips Curve suggests an inverse relationship (when one goes up, the other goes down).

--SQL is excellent for querying and aggregating data, but not for creating visualizations like scatter plots. Therefore, the key task here is to write a query that prepares the data perfectly for visualization in another tool like Excel or Power BI.

--A. Extract Data for a Scatter Plot
--This query selects the two columns we need to plot against each other

-- Query for Phillips Curve Scatter Plot Analysis
SELECT
    Consumer_Price_Index,
    Unemployment_Rate
FROM dbo.macro_monthly;

--Step 3: Deeper Analysis - Segmenting by Time and Conditions ??
        --A truly insightful analysis goes deeper than just looking at the entire dataset. Let's see if the relationship changes over time or under different economic conditions.

--A. Analyze by Decade
--Has the relationship evolved? Let's group the data by decade to find out

-- Average changes by decade
SELECT
    CASE
        WHEN Year BETWEEN 1993 AND 1999 THEN '1990s'
        WHEN Year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN Year BETWEEN 2010 AND 2019 THEN '2010s'
        ELSE '2020s'
    END AS Decade,
    COUNT(*) AS NumberOfMonths,
    AVG(Consumer_Price_Index) AS Avg_CPI_Change,
    AVG(Unemployment_Rate) AS Avg_Unemployment_Change
FROM dbo.macro_monthly
GROUP BY
    CASE
        WHEN Year BETWEEN 1993 AND 1999 THEN '1990s'
        WHEN Year BETWEEN 2000 AND 2009 THEN '2000s'
        WHEN Year BETWEEN 2010 AND 2019 THEN '2010s'
        ELSE '2020s'
    END
ORDER BY Decade;

--Insight: This powerful query shows the average behavior of our two indicators across different eras. 
     -- A change in the signs (positive/negative) of the averages between decades could signal a major shift in the economic landscape.

-- B. Analyze Under High Inflation vs. Low Inflation
     --Let's examine the average change in unemployment during months with high inflation versus months with low inflation. We'll define "high inflation" as a monthly CPI change greater than 0.5%

	 -- Comparing unemployment changes in different inflation environments
SELECT
    'High Inflation Months (CPI Change > 0.5)' AS Inflation_Environment,
    AVG(Unemployment_Rate) AS Avg_Unemployment_Change
FROM dbo.macro_monthly
WHERE Consumer_Price_Index > 0.5

UNION ALL

SELECT
    'Low Inflation Months (CPI Change <= 0.5)' AS Inflation_Environment,
    AVG(Unemployment_Rate) AS Avg_Unemployment_Change
FROM dbo.macro_monthly
WHERE Consumer_Price_Index <= 0.5;

--Insight: According to the Phillips Curve, we would expect the Avg_Unemployment_Change to be lower (more negative) during the "High Inflation Months." 
    -- This query directly tests that hypothesis