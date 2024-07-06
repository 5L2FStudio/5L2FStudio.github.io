---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 07 - T-SQL for Data Analysis
-- Solutions
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- All exercises for this chapter will involve querying the dbo.Orders
-- table in the TSQLV6 database that you created and populated 
-- earlier by running the code in Listing 7-1

-- 1
-- Write a query against the dbo.Orders table that computes for each
-- customer order, both a rank and a dense rank,
-- partitioned by custid, ordered by qty 

-- Desired output:
custid orderid     qty         rnk                  drnk
------ ----------- ----------- -------------------- --------------------
A      30001       10          1                    1
A      40005       10          1                    1
A      10001       12          3                    2
A      40001       40          4                    3
B      20001       12          1                    1
B      30003       15          2                    2
B      10005       20          3                    3
C      10006       14          1                    1
C      20002       20          2                    2
C      30004       22          3                    3
D      30007       30          1                    1

-- Solutions

USE TSQLV6;

SELECT custid, orderid, qty,
  RANK() OVER(PARTITION BY custid ORDER BY qty) AS rnk,
  DENSE_RANK() OVER(PARTITION BY custid ORDER BY qty) AS drnk
FROM dbo.Orders;

-- Shorten query string with WINDOW clause
SELECT custid, orderid, qty,
  RANK() OVER W AS rnk,
  DENSE_RANK() OVER W AS drnk
FROM dbo.Orders
WINDOW W AS (PARTITION BY custid ORDER BY qty);

-- 2
-- The following query against the Sales.OrderValues view returns
-- distinct values and their associated row numbers

SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues
GROUP BY val;

-- Can you think of an alternative way to achieve the same task?
-- Tables involved: TSQLV6 database, Sales.OrderValues view

-- Desired output:
val       rownum
--------- -------
12.50     1
18.40     2
23.80     3
28.00     4
30.00     5
33.75     6
36.00     7
40.00     8
45.00     9
48.00     10
...
12615.05  793
15810.00  794
16387.50  795

(795 rows affected)

-- Solution

WITH C AS
(
  SELECT DISTINCT val
  FROM Sales.OrderValues
)
SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM C;

-- 3
-- Write a query against the dbo.Orders table that computes for each
-- customer order:
-- * the difference between the current order quantity
--   and the customer's previous order quantity
-- * the difference between the current order quantity
--   and the customer's next order quantity.

-- Desired output:
custid orderid     qty         diffprev    diffnext
------ ----------- ----------- ----------- -----------
A      30001       10          NULL        -2
A      10001       12          2           -28
A      40001       40          28          30
A      40005       10          -30         NULL
B      10005       20          NULL        8
B      20001       12          -8          -3
B      30003       15          3           NULL
C      30004       22          NULL        8
C      10006       14          -8          -6
C      20002       20          6           NULL
D      30007       30          NULL        NULL

-- Solutions

SELECT custid, orderid, qty,
  qty - LAG(qty) OVER(PARTITION BY custid
                      ORDER BY orderdate, orderid) AS diffprev,
  qty - LEAD(qty) OVER(PARTITION BY custid
                       ORDER BY orderdate, orderid) AS diffnext
FROM dbo.Orders;

-- Shorten query string with WINDOW clause
SELECT custid, orderid, qty,
  qty - LAG(qty) OVER W AS diffprev,
  qty - LEAD(qty) OVER W AS diffnext
FROM dbo.Orders
WINDOW W AS (PARTITION BY custid
             ORDER BY orderdate, orderid);

-- 4
-- Write a query against the dbo.Orders table that returns a row for each
-- employee, a column for each order year, and the count of orders
-- for each employee and order year

-- Desired output:
empid       cnt2020     cnt2021     cnt2022
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

-- Solutions

-- Using standard solution
USE TSQLV6;

SELECT empid,
  COUNT(CASE WHEN orderyear = 2020 THEN orderyear END) AS cnt2020,
  COUNT(CASE WHEN orderyear = 2021 THEN orderyear END) AS cnt2021,
  COUNT(CASE WHEN orderyear = 2022 THEN orderyear END) AS cnt2022  
FROM (SELECT empid, YEAR(orderdate) AS orderyear
      FROM dbo.Orders) AS D
GROUP BY empid;

-- Using the native PIVOT operator
SELECT empid, [2020] AS cnt2020, [2021] AS cnt2021, [2022] AS cnt2022
FROM (SELECT empid, YEAR(orderdate) AS orderyear
      FROM dbo.Orders) AS D
  PIVOT(COUNT(orderyear)
        FOR orderyear IN([2020], [2021], [2022])) AS P;

-- 5
-- Run the following code to create and populate the EmpYearOrders table:
USE TSQLV6;

DROP TABLE IF EXISTS dbo.EmpYearOrders;

CREATE TABLE dbo.EmpYearOrders
(
  empid INT NOT NULL
    CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
  cnt2020 INT NULL,
  cnt2021 INT NULL,
  cnt2022 INT NULL
);

INSERT INTO dbo.EmpYearOrders(empid, cnt2020, cnt2021, cnt2022)
  SELECT empid, [2020] AS cnt2020, [2021] AS cnt2021, [2022] AS cnt2022
  FROM (SELECT empid, YEAR(orderdate) AS orderyear
        FROM dbo.Orders) AS D
    PIVOT(COUNT(orderyear)
          FOR orderyear IN([2020], [2021], [2022])) AS P;

SELECT * FROM dbo.EmpYearOrders;

-- Output:
empid       cnt2020     cnt2021     cnt2022
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

-- Write a query against the EmpYearOrders table that unpivots
-- the data, returning a row for each employee and order year
-- with the number of orders
-- Exclude rows where the number of orders is 0
-- (in our example, employee 3 in year 2021)

-- Desired output:
empid       orderyear   numorders
----------- ----------- -----------
1           2020        1
1           2021        1
1           2022        1
2           2020        1
2           2021        2
2           2022        1
3           2020        2
3           2022        2

-- Solutions

-- Using the APPLY operator
SELECT empid, orderyear, numorders
FROM dbo.EmpYearOrders
  CROSS APPLY (VALUES(2020, cnt2020),
                     (2021, cnt2021),
                     (2022, cnt2022)) AS A(orderyear, numorders)
WHERE numorders <> 0;

-- Using the UNPIVOT operator
SELECT empid, CAST(RIGHT(orderyear, 4) AS INT) AS orderyear, numorders
FROM dbo.EmpYearOrders
  UNPIVOT(numorders FOR orderyear IN(cnt2020, cnt2021, cnt2022)) AS U
WHERE numorders <> 0;

-- 6
-- Write a query against the dbo.Orders table that returns the 
-- total quantities for each:
-- employee, customer, and order year
-- employee and order year
-- customer and order year
-- Include a result column in the output that uniquely identifies 
-- the grouping set with which the current row is associated

-- Desired output:
groupingset empid       custid orderyear   sumqty
----------- ----------- ------ ----------- -----------
0           2           A      2020        12
0           3           A      2020        10
4           NULL        A      2020        22
0           2           A      2021        40
4           NULL        A      2021        40
0           3           A      2022        10
4           NULL        A      2022        10
0           1           B      2020        20
4           NULL        B      2020        20
0           2           B      2021        12
4           NULL        B      2021        12
0           2           B      2022        15
4           NULL        B      2022        15
0           3           C      2020        22
4           NULL        C      2020        22
0           1           C      2021        14
4           NULL        C      2021        14
0           1           C      2022        20
4           NULL        C      2022        20
0           3           D      2022        30
4           NULL        D      2022        30
2           1           NULL   2020        20
2           2           NULL   2020        12
2           3           NULL   2020        32
2           1           NULL   2021        14
2           2           NULL   2021        52
2           1           NULL   2022        20
2           2           NULL   2022        15
2           3           NULL   2022        40

(29 rows affected)

-- Solution
SELECT
  GROUPING_ID(empid, custid, YEAR(Orderdate)) AS groupingset,
  empid, custid, YEAR(Orderdate) AS orderyear, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY
  GROUPING SETS
  (
    (empid, custid, YEAR(orderdate)),
    (empid, YEAR(orderdate)),
    (custid, YEAR(orderdate))
  );
GO

-- 7
-- Write a query against the Sales.Orders table that returns a row for
-- each week, assuming the week starts on a Sunday, with result columns
-- showing when the week started, ended, and the week’s order count
-- Table involved: TSQLV6 database, Sales.Orders table

-- Desired output:
startofweek endofweek  numorders
----------- ---------- -----------
2020-06-28  2020-07-04 1
2020-07-05  2020-07-11 6
2020-07-12  2020-07-18 5
2020-07-19  2020-07-25 6
2020-07-26  2020-08-01 6
2020-08-02  2020-08-08 5
2020-08-09  2020-08-15 6
2020-08-16  2020-08-22 5
2020-08-23  2020-08-29 6
2020-08-30  2020-09-05 5
...
2022-02-27  2022-03-05 16
2022-03-06  2022-03-12 17
2022-03-13  2022-03-19 17
2022-03-20  2022-03-26 16
2022-03-27  2022-04-02 17
2022-04-03  2022-04-09 17
2022-04-10  2022-04-16 16
2022-04-17  2022-04-23 17
2022-04-24  2022-04-30 17
2022-05-01  2022-05-07 14

(97 rows affected)

-- Solutions

-- Using DATE_BUCKET
WITH C AS
(
  SELECT
    DATE_BUCKET(week, 1, orderdate, CAST('19000107' AS DATE)) AS startofweek
  FROM Sales.Orders
)
SELECT 
  startofweek, DATEADD(day, 6, startofweek) AS endofweek,
  COUNT(*) AS numorders
FROM C
GROUP BY startofweek
ORDER BY startofweek;
GO

-- Using custom method
WITH C AS
(
  SELECT 
    DATEADD(
      week,
      (DATEDIFF(week, '19000107', orderdate)
        - CASE
            WHEN DATEADD(week, DATEDIFF(week, '19000107', orderdate), '19000107')
                   > orderdate THEN 1
            ELSE 0
          END),
      CAST('19000107' AS DATE)) AS startofweek
  FROM Sales.Orders
)
SELECT 
  startofweek, DATEADD(day, 6, startofweek) AS endofweek,
  COUNT(*) AS numorders
FROM C
GROUP BY startofweek
ORDER BY startofweek;
GO

-- 8
-- Suppose that your organization's fiscal year runs from July 1st to June 30th
-- Write a query against the Sales.OrderValues view that returns the 
-- total quantities and values per shipper and fiscal year of the order date

-- Desired output:
shipperid   startofyear endtofyear totalqty    totalval
----------- ----------- ---------- ----------- ----------
1           2020-07-01  2021-06-30 6141        123376.50
1           2021-07-01  2022-06-30 9778        225463.50
2           2020-07-01  2021-06-30 8284        190603.18
2           2021-07-01  2022-06-30 11661       342944.51
3           2020-07-01  2021-06-30 7170        175570.33
3           2021-07-01  2022-06-30 8283        207835.20

(6 rows affected)

-- Solution using DATE_BUCKET
DECLARE
  @bucketwidth AS INT = 1,
  @origin      AS DATE = '19000701';

WITH C AS
(
  SELECT shipperid, qty, val,
    DATE_BUCKET(year, @bucketwidth, orderdate, @origin) AS startofyear
  FROM Sales.OrderValues
)
SELECT shipperid, startofyear,
  DATEADD(day, -1, DATEADD(year, @bucketwidth, startofyear)) AS endofyear,
  SUM(qty) AS totalqty,
  SUM(val) AS totalval
FROM C
GROUP BY shipperid, startofyear
ORDER BY shipperid, startofyear;
GO

-- Solution using custom method for start of bucket
DECLARE
  @bucketwidth AS INT = 1,
  @origin      AS DATE = '19000701';

WITH C AS
(
  SELECT shipperid, qty, val,
    DATEADD(
      year,
      (DATEDIFF(year, @origin, orderdate)
        - CASE
            WHEN DATEADD(year, DATEDIFF(year, @origin, orderdate), @origin)
                   > orderdate THEN 1
            ELSE 0
          END) / @bucketwidth * @bucketwidth,
      @origin) AS startofyear
  FROM Sales.OrderValues
)
SELECT shipperid, startofyear,
  DATEADD(day, -1, DATEADD(year, @bucketwidth, startofyear)) AS endofyear,
  SUM(qty) AS totalqty,
  SUM(val) AS totalval
FROM C
GROUP BY shipperid, startofyear
ORDER BY shipperid, startofyear;
GO