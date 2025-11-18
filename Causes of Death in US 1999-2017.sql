/*
Data Source URL:
https://catalog.data.gov/dataset/nchs-leading-causes-of-death-united-states
Data visualization Google Sheets URL:
https://docs.google.com/spreadsheets/d/1tlz4pZKmNGuki-6TEcC48kpFluZjOoHYr_yNSSACdLM/edit?usp=sharing
*/


--========================================================--
/*
Tab name: SQL 1
This is the 1st query, made to limit the columns to Year, CauseName,
and Deaths, and made to limit the rows to 'United States'.
The resulting table is used for the 2nd query, and with the manual
addition of the 'Other' row to each year is also used for the 3rd
query.
*/
SELECT
	Year,
	CauseName,
	Deaths
FROM
	Causes_of_Death
WHERE
	State = 'United States'
ORDER BY
	Year DESC, CauseName
-- 	Year DESC, Deaths DESC


--========================================================--
/*
Tab name: SQL 2
This is the 2nd query, made for the 3rd query by first grouping all
the results by CauseName to determine the ideal CauseName order.
In the 3rd query the causes of death are ordered from most common to
least common.
This 2nd query also provides an overview of the total number of deaths
by each of the most common types in the whole US from 1999 to 2017, to
which an 'Other' row can be added manually to account for the deaths not
caused by any of the leading 10 causes.
*/
SELECT
	CauseName as 'Cause Name',
	sum(Deaths) AS 'Total Deaths'
FROM
	Causes_of_Death
WHERE
	State = 'United States'
GROUP BY
	CauseName
ORDER BY
	sum(Deaths) DESC


--========================================================--
/*
Tab name: SQL 3
This is the 3rd query, made to order the cause names for each year by a
standard order 01 to 11, the order being based on the results of the 2nd
query.
The table from the 1st query was copied into Excel, modified by manually
adding the row of cause name 'Other' to each year, each value of 'Other'
being calculated with the following general formula: "=C2-SUM(C3:C12)",
where C2 represents 'All causes' and SUM(C3:C12) represents the sum of
the 10 non-'All causes' causes of death.
Then the grouped and ordered 'sum(Deaths)' column from the 2nd query is
used in the 3rd query (below) to order the causes of death as 01 to 11 in
decreasing order of deaths count, except for 'Other', which comes last.
The next step from here is to copy the table into Google Sheets, then add
a row above where all the years will go (1999-2017), then copy each
year's 'Deaths' data below the respective year-named column header (you
can see what I mean if you look at the Google Sheets table, it's the
ultimately resulting table).
I used Google Sheets because the visualization was cleaner than in Excel.
*/
SELECT
	Year,
	CASE
	WHEN CauseName = 'Heart disease' THEN '01 Heart disease'
	WHEN CauseName = 'Cancer' THEN '02 Cancer'
	WHEN CauseName = 'Stroke' THEN '03 Stroke'
	WHEN CauseName = 'CLRD' THEN '04 CLRD'
	WHEN CauseName = 'Unintentional injuries' THEN '05 Unintentional injuries'
	WHEN CauseName = "Alzheimer's disease" THEN "06 Alzheimer's disease"
	WHEN CauseName = 'Diabetes' THEN '07 Diabetes'
	WHEN CauseName = 'Influenza and pneumonia' THEN '08 Influenza and pneumonia'
	WHEN CauseName = 'Kidney disease' THEN '09 Kidney disease'
	WHEN CauseName = 'Suicide' THEN '10 Suicide'
	ELSE '11 Other'
	END AS SortedCauseName,
	Deaths
FROM
	Causes_of_Death_with_Other
WHERE
	CauseName <> 'All causes'
ORDER BY
	Year ASC, SortedCauseName
