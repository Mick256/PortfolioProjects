/*
From Walter Shields on LinkedIn Learning (course titled "SQL Essential Training")
Skills learned:
    Basic structure: SELECT, AS, FROM, WHERE, ORDER BY, LIMIT,
    JOINs: INNER JOIN, LEFT OUTER JOIN, joining more than 2 tables,
    Date and String functions: strftime(), length(), substr(), lower(), upper(),
    Aggregate functions: sum(), round(), avg(), min(), max(), count(),
    Grouping: GROUP BY, HAVING,
    Other: subqueries, DISTINCT, CASE-WHEN-ELSE-END-AS, * for "all", % as wildcard,
    VIEWs: CREATE VIEW, DROP VIEW,
    DML: INSERT INTO, UPDATE, DELETE FROM

List of "DB Browser for SQLite" query tabs:
    SQL 1
    SQL 3
    SQL 4
    SQL 5
    SQL 6
    SQL 7
    SQL 8
    SQL 9
    SQL 10
    SQL 11
    SQL 12
    SQL 13
    SQL 14
    SQL 15
    SQL 16
    SQL 17
    SQL 18
    Edit View V_AvgTotal
    SQL 20
    SQL 21
    SQL 22
    SQL 23
    SQL 24
    SQL 25
    SQL 26
    SQL 27
    SQL 28
    SQL 28 (1)
    SQL 29
    SQL 30
    SQL 31
    SQL 32
    SQL 35
*/


--========================================================--
-- SQL 1
--THIS IS A COMMENT

/*
[THIS IS A COMMENT]
CREATED BY: *NAME*
CREATE DATE: MM/DD/YYYY
DESCRIPTION: *QUERY QUESTION/EXPLANATION*
*/


--========================================================--
-- SQL 3
/*
Created By: Mick Lancellotti
Creation Date: 09/28/2025
Description: This query displays all customers' first and last names and email addresses
*/

SELECT
    FirstName AS [Customer First Name],
    LastName AS 'Customer Last Name',
    Email AS EMAIL
FROM
    Customer
ORDER BY
    FirstName ASC,
    LastName DESC
LIMIT 10


--========================================================--
-- SQL 4
/*
How many customers purchased two songs at $0.99 each?
*/

/*
Created By: Mick Lancellotti
Creation Date: 09/30/2025
Description: Customers who purchased two songs at $0.99 each
Description: How many invoices exist between $1.98 and $5.00?
Description: How many invoices do we have that are exactly $1.98 or $3.96?
Description: How many invoices were billed to Brussels?
Description: How many invoices were billed to Brussels, Orlando, or Paris?
Description: How many invoices were billed that start with B?
Description: How may invoices were billed in cities that have a B anywhere in their name?
Description: How many invoices were billed on 2010-05-22 00:00:00?
Description: Get all invoices that were billed after 2010-05-22 and have a total of less than $3.00
Description: Get all invoices whose billing city starts with P or starts with D
Description: Get all invoices that are greater than 1.98 from any cities whose names start with P or start with D
*/

SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity,
    total
FROM
    Invoice
WHERE
    --Customers who purchased two songs at $0.99 each
    --total = 1.98
    
    --How many invoices exist between $1.98 and $5.00?
    --total >= 1.98 --*not best
    --AND --*not best
    --total <= 5.00 --*not best
    --total BETWEEN 1.98 and 5.00 --*best
    
    --How many invoices do we have that are exactly $1.98 or $3.96?
    --total = 1.98 OR total = 3.96 --*not best
--     total IN (1.98, 3.96) --*best

    --How many invoices were billed to Brussels?
--     BillingCity = 'Brussels'

    --How many invoices were billed to Brussels, Orlando, or Paris?
--     BillingCity IN ('Brussels','Orlando','Paris')

    --How many invoices were billed that start with B?
--     BillingCity LIKE 'B%'

    --How may invoices were billed in cities that have a B anywhere in their name?
--      BillingCity LIKE '%B%'

    --No B anywhere in name
--     BillingCity NOT LIKE '%B%'

    --How many invoices were billed on 2010-05-22 00:00:00?
--     --InvoiceDate = '2010-05-22 00:00:00'
--     DATE(InvoiceDate) = '2010-05-22'

    --Get all invoices that were billed after 2010-05-22 and have a total of less than $3.00
--     DATE(InvoiceDate) > '2010-05-22' AND total < 3.00

    --Get all invoices whose billing city starts with P or starts with D
--     BillingCity LIKE 'P%' OR BillingCity LIKE 'D%'

    --Get all invoices that are greater than 1.98 from any cities whose names start with P or start with D
    total > 1.98 AND (BillingCity LIKE 'P%' OR BillingCity LIKE 'D%')

ORDER BY
    InvoiceDate


--========================================================--
-- SQL 5
SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity,
    total,
    CASE
    WHEN total < 2.00 THEN 'Baseline Purchase'
    WHEN total BETWEEN 2.00 AND 6.99 THEN 'Low Purchase'
    WHEN total BETWEEN 7.00 AND 15.00 THEN 'Target Purchase'
    ELSE 'Top Performer'
    END AS PurchaseType
FROM
    Invoice
WHERE
    PurchaseType = 'Top Performer'
ORDER BY
    BillingCity


--========================================================--
-- SQL 6
/*
Created By: Mick
Creation Date: 10/01/2025
Description: JOINS
 "We use the keyword 'ON' to provide the query with the link between
 these two tables, which are the customer ID field in the invoice
 table to the customer ID field in the customer table."
 "Since two tables in any given database may have fields with the
 identical names, when creating joins, we must specify the table
 name followed by the column name that we would like to join so that
 the SQL browser knows exactly which version of the field we are
 referencing."
*/

SELECT
--     *
    c.LastName,
    c.FirstName,
    i.InvoiceId,
    i.CustomerId,
    i.InvoiceDate,
    i.total
FROM
    Invoice AS i
-- INNER JOIN
JOIN
-- LEFT OUTER JOIN
    Customer AS c
ON
--     Invoice.CustomerId = Customer.CustomerId
    i.CustomerId = c.CustomerId
ORDER BY c.CustomerId


--========================================================--
-- SQL 7
/*
Created By: Mick
Creation Date: 10/03/2025
Description: JOINS on more than two tables | What employees are responsible for the 10 highest individual sales?
*/

SELECT
    e.FirstName,
    e.LastName,
    e.EmployeeId,
    c.FirstName,
    c.LastName,
    c.SupportRepId,
    c.CustomerId,
    i.total
FROM
    Invoice AS i
INNER JOIN
    Customer AS c
ON
    i.CustomerId = c.CustomerId
INNER JOIN
    Employee AS e
ON
    c.SupportRepId = e.EmployeeId
ORDER BY
    i.total DESC
LIMIT 10


--========================================================--
-- SQL 8
/*
Created By: Mick
Creation Date: 10/05/2025
Description: FUNCTIONS
*/

-- UPPER(

--Create a mailing list of US customers
-- "||" <--"double pipe"
SELECT
    FirstName,
    LastName,
    Address,
    FirstName || ' ' || LastName || ' ' || Address || ', ' || City || ' ' || State || ' ' || PostalCode AS 'Mailing Address',
    LENGTH(postalcode),
    substr(postalcode,1,5) AS '5 Digit Postal Code',
    upper(firstname) AS 'First Name All Caps',
    lower(lastname) AS 'Last Name All Lower'
FROM
    Customer
WHERE
    Country = 'USA'


--========================================================--
-- SQL 9
/*
Created By: Mick
Creation Date: 10/06/2025
Description: Calculate the ages of all employees
*/

SELECT
    FirstName,
    LastName,
    BirthDate,
    strftime('%Y-%m-%d',Birthdate) AS [Birthdate No Timecode],
    strftime('%Y-%m-%d','now') - strftime('%Y-%m-%d',Birthdate) AS Age
FROM
    Employee


--========================================================--
-- SQL 10
/*
Created By: Mick
Creation Date: 10/06/2025
Description: Aggregate Functions | What are our all time global sales?
*/

SELECT
    SUM(total) AS [Total Sales],
--     AVG(total) AS [Average Sales],
    round(AVG(total),2) AS [Average Sales],
    MAX(total) AS [Maximum Sale],
    MIN(total) AS [Minimum Sale],
    COUNT(*) AS [Sales Count]
FROM
    Invoice


--========================================================--
-- SQL 11
/*
Created By: Mick
Creation Date: 10/06/2025
Description: Grouping in SQL | What are the average invoice totals by city?
Description: What are the average invoice totals by city for only the cities that start with L?
Description: What are the average invoice totals greater than $5.00?
Description: What are the average invoice totals greater than $5.00 for cities starting with B?
*/

SELECT
    BillingCity,
    round(avg(total),2)
FROM 
    Invoice
-- WHERE
-- --     BillingCity LIKE 'L%'
--     total >= 5
WHERE
    BillingCity like 'B%'
GROUP BY
    BillingCity
HAVING
    avg(total) > 5
ORDER BY
    BillingCity


--========================================================--
-- SQL 12
/*
Created By: Mick
Creation Date: 10/09/2025
Description: Grouping by more than one field at a time | What are the average invoice totals by billing country and city?
*/

SELECT
    BillingCountry,
    BillingCity,
    round(avg(total),2)
FROM 
    Invoice
GROUP BY
    BillingCountry, BillingCity
ORDER BY
    BillingCountry


--========================================================--
-- SQL 13
/*
Created By: Mick
Creation Date: 10/11/2025
Description: Subqueries | Gather data about all invoices that are less than this average
*/

SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity,
    total
FROM
    Invoice
WHERE
    total< (SELECT avg(total) AS 'Average Total' FROM Invoice)
ORDER BY
    total DESC


--========================================================--
-- SQL 14
/*
Created By: Mick
Creation Date: 10/11/2025
Description: Subqueries in the SELECT | How is each individual city performing against the global average sales?
*/

SELECT
--     BillingCountry,
    BillingCity,
    round(avg(total),2) AS 'City Average',-- Total',
    (SELECT round(avg(total),2) FROM Invoice) AS 'Global Average'-- Total'
FROM 
    Invoice
GROUP BY
--     BillingCountry,
    BillingCity
ORDER BY
--     avg(total) DESC
    BillingCity


--========================================================--
-- SQL 15
/*
Created By: Mick
Creation Date: 10/13/2025
Description: Subqueries without aggregate functions
*/

SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity
FROM
    Invoice
WHERE
    InvoiceDate >
(SELECT
    InvoiceDate
FROM
    Invoice
WHERE
    InvoiceId = 251)


--========================================================--
-- SQL 16
/*
Created By: Mick
Creation Date: 10/13/2025
Description: Returning multiple values from a subquery
*/

SELECT
    InvoiceDate,
    BillingAddress,
    BillingCity,
    InvoiceId
FROM
    Invoice
WHERE
    InvoiceDate IN
(SELECT
    InvoiceDate
FROM
    Invoice
WHERE
    InvoiceId IN (1,2,3,4,251, 252, 254))


--========================================================--
-- SQL 17
/*
Created By: Mick
Creation Date: 10/13/2025
Description: Subqueries and DISTINCT | Which tracks are not selling?
*/

SELECT
    TrackId,
    Composer,
    Name
FROM
    Track
WHERE
    TrackId NOT IN
(SELECT
    DISTINCT
    TrackId
FROM
    InvoiceLine
ORDER BY
    TrackId)


--========================================================--
-- SQL 18
/*
Created By: Mick
Creation Date: 10/15/2025
Description: Views
*/

CREATE VIEW V_AvgTotal AS
SELECT
    round(avg(total),2) AS [Average total]
FROM
    Invoice


--========================================================--
-- Edit View V_AvgTotal
DROP VIEW IF EXISTS "main"."V_AvgTotal";
CREATE VIEW V_AvgTotal AS
SELECT
    avg(total) AS [Average total]
FROM
    Invoice


--========================================================--
-- SQL 20
/*
Created By: Mick
Creation Date: 10/15/2025
Description: Views and Joins
*/

CREATE VIEW V_Tracks_InvoiceLine AS
SELECT
    il.InvoiceId,
    il.UnitPrice,
    il.Quantity,
    t.Name,
    t.Composer,
    t.Milliseconds
FROM
    InvoiceLine il
INNER JOIN
    Track t
ON
    il.TrackId = t.TrackId


--========================================================--
-- SQL 21
/*
Created By: Mick
Creation Date: 10/15/2025
Description: Deleting Views
*/

DROP VIEW
    V_AvgTotal


--========================================================--
-- SQL 22
/*
Created By: Mick
Creation Date: 10/17/2025
Description: DML | Inserting Data
*/

INSERT INTO
    Artist (Name)
VALUES ('Bob Marley')


--========================================================--
-- SQL 23
/*
Created By: Mick
Creation Date: 10/17/2025
Description: DML | Updating Data
*/

UPDATE
Artist
SET Name = 'Damien Marley'
WHERE
    ArtistId = 276


--========================================================--
-- SQL 24
/*
Created By: Mick
Creation Date: 10/17/2025
Description: DML | Deleting Data
*/

DELETE FROM
    Artist
WHERE
    ArtistId = 276


--========================================================--
-- SQL 25
SELECT
    InvoiceId AS InvID,
    CustomerId AS CstID,
    InvoiceDate,
    strftime('%Y-%m-%d','now') - strftime('%Y-%m-%d',InvoiceDate) AS [Yrs ago?],
    BillingAddress,
    length(BillingPostalCode),
    substr(BillingPostalCode,1,5),
    lower(BillingCity),
    upper(BillingCountry),
    total,
    (SELECT round(avg(total),2) FROM Invoice) AS GlobalAvg,
    CASE
    WHEN total < 2.00 THEN 'Baseline Purchase'
    WHEN total BETWEEN 2.00 AND 6.99 THEN 'Low Purchase' 
    WHEN total BETWEEN 7.00 AND 15.00 THEN 'Target Purchase'
    ELSE 'Top Performer'
    END AS PurchaseType
FROM
    Invoice
WHERE
    BillingCountry NOT IN ('France') AND total NOT BETWEEN 5 and 6 AND 
    total >= 1.98 AND (BillingCity like '%P%' OR BillingCity like '%D%')
ORDER BY
    InvoiceDate DESC
LIMIT 115


--========================================================--
-- SQL 26
SELECT
    BillingCountry,
    BillingCity,
    round(avg(total),2)
FROM 
    Invoice
WHERE
    BillingCity NOT like 'Lo%on'
GROUP BY
    BillingCountry, BillingCity
HAVING
    BillingCountry <> 'Sweden'
ORDER BY
    BillingCountry


--========================================================--
-- SQL 27
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 1.1: How many transactions took place between the years 2011 and 2012?
Part 1.2: How much money did WSDA Music make during the same period?
*/

SELECT
    InvoiceId,
    CustomerId,
    InvoiceDate,
    total,
    (SELECT sum(total) FROM Invoice WHERE 
    InvoiceDate like '2011%' or InvoiceDate like '2012%')
FROM
    Invoice
WHERE
    InvoiceDate like '2011%' or InvoiceDate like '2012%'
ORDER BY
    InvoiceDate


--========================================================--
-- SQL 28
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 2.3: How many transactions are above the average transaction amount
during the same time period?
*/

SELECT
    i.InvoiceId,
    i.CustomerId,
    c.SupportRepId,
    i.InvoiceDate,
    c.FirstName,
    c.LastName,
    i.total,
    round((SELECT avg(total) FROM Invoice WHERE
    InvoiceDate like '2011%' OR InvoiceDate like '2012%'),2)
    AS Avg_2011_2012
FROM
    Invoice i
JOIN
    Customer c
ON
    i.CustomerId = c.CustomerId -- note order doesn't matter
WHERE
    i.total > Avg_2011_2012 AND
    (InvoiceDate like '2011%' OR InvoiceDate like '2012%')


--========================================================--
-- SQL 28 (1)
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 2.1: Get a list of customers who made purchases between 2011 and 2012.
Part 2.2: Get a list of customers, sales reps, and total transaction amounts
for each customer between 2011 and 2012.
*/

SELECT
    i.InvoiceId,
    i.CustomerId,
    c.SupportRepId,
    i.InvoiceDate,
    c.FirstName,
    c.LastName,
    i.total
FROM
    Invoice i
JOIN
    Customer c
ON
    i.CustomerId = c.CustomerId
WHERE
    InvoiceDate like '2011%' or InvoiceDate like '2012%'


--========================================================--
-- SQL 29
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 2.4: What is the average transaction amount for each year that WSDA
Music has been in business?
*/

SELECT
--     strftime('%Y-%m-%d',InvoiceDate) AS Year,
    substr(InvoiceDate,1,4) AS Year,
    round(avg(total),2)
FROM
    Invoice
GROUP BY
    Year


--========================================================--
-- SQL 30
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
MESSUP ALERT; IGNORE THIS QUERY
*/

SELECT
    i.InvoiceId,
    i.CustomerId,
    c.SupportRepId,
    i.InvoiceDate,
    c.FirstName,
    c.LastName,
    i.total,
    round((SELECT avg(total) FROM Invoice WHERE
    InvoiceDate like '2011%' OR InvoiceDate like '2012%'),2)
    AS Avg_2011_2012,
    round((i.total * 0.15),2) AS CommissionPayout
FROM
    Invoice i
JOIN
    Customer c
ON
    i.CustomerId = c.CustomerId -- note order doesn't matter
WHERE
    i.total > Avg_2011_2012 AND
    (InvoiceDate like '2011%' OR InvoiceDate like '2012%')
ORDER BY
    total


--========================================================--
-- SQL 31
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 3.1: Get a list of employees who exceeded the average transaction
amount from sales they generated during 2011 and 2012.
Part 3.2: Create a Commission Payout column that displays each employee’s
commission based on 15% of the sales transaction amount.
Part 3.3: Which employee made the highest commission?
*/

SELECT
    c.SupportRepId,
    e.FirstName,
    e.LastName,
    round(sum(i.total),2) AS TotalSales,
    round((sum(i.total) * 0.15),2) AS CommissionPayout
FROM
    Customer c
JOIN
    Invoice i
ON
    c.CustomerId = i.CustomerId
JOIN
    Employee e
ON
    c.SupportRepId = e.EmployeeId
WHERE
    InvoiceDate like '2011%' OR InvoiceDate like '2012%'
GROUP BY
    c.SupportRepId


--========================================================--
-- SQL 32
/*
Created by: Mick
Creation Date: 10/20/2025
Description: Project Missing Money Matters
Part 3.4: List the customers that the employee identified in the last question.
Part 3.5: Which customer made the highest purchase?
Part 3.6: Look at this customer record—do you see anything suspicious?
Part 3.7: Who do you conclude is our primary person of interest?
*/

SELECT
    i.InvoiceId,
    i.CustomerId,
    c.SupportRepId,
    strftime('%Y-%m-%d',i.InvoiceDate) AS Date,
    c.FirstName,
    c.LastName,
    i.total
FROM
    Customer c
JOIN
    Invoice i
ON
    c.CustomerId = i.CustomerId
JOIN
    Employee e
ON
    c.SupportRepId = e.EmployeeId
WHERE
    e.EmployeeId = 3 AND (InvoiceDate like '2011%' OR InvoiceDate like '2012%')
ORDER BY
    total, InvoiceId


--========================================================--
-- SQL 35
-- A query to test a Hackerrank SQL challenge

SELECT BillingCity, LENGTH(BillingCity) AS NAME_LENGTH
FROM (
    SELECT BillingCity
    FROM Invoice
    ORDER BY LENGTH(BillingCity) ASC, BillingCity ASC
    LIMIT 1
)
UNION
SELECT BillingCity, LENGTH(BillingCity) AS NAME_LENGTH
FROM (
    SELECT BillingCity
    FROM Invoice
    ORDER BY LENGTH(BillingCity) DESC, BillingCity ASC
    LIMIT 1
);

