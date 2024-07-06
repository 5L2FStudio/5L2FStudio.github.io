---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 07 - T-SQL for Data Analysis
-- Exercises
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

-- 2
-- The following query against the Sales.OrderValues view returns
-- distinct values and their associated row numbers
USE TSQLV6;

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

-- 4
-- Write a query against the dbo.Orders table that returns a row for each
-- employee, a column for each order year, and the count of orders
-- for each employee and order year
-- Tables involved: TSQLV6 database, dbo.Orders table

-- Desired output:
empid       cnt2020     cnt2021     cnt2022
----------- ----------- ----------- -----------
1           1           1           1
2           1           2           1
3           2           0           2

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

-- 6
-- Write a query against the dbo.Orders table that returns the 
-- total quantities for each:
-- employee, customer, and order year
-- employee and order year
-- customer and order year
-- Include a result column in the output that uniquely identifies 
-- the grouping set with which the current row is associated
-- Tables involved: TSQLV6 database, dbo.Orders table

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

-- 8
-- Suppose that your organization's fiscal year runs from July 1st to June 30th
-- Write a query against the Sales.OrderValues view that returns the 
-- total quantities and values per shipper and fiscal year of the order date
-- Tables involved: TSQLV6 database, Sales.OrderValues view

-- Desired output:
shipperid   startofyear endofyear  totalqty    totalval
----------- ----------- ---------- ----------- ----------
1           2020-07-01  2021-06-30 6141        123376.50
1           2021-07-01  2022-06-30 9778        225463.50
2           2020-07-01  2021-06-30 8284        190603.18
2           2021-07-01  2022-06-30 11661       342944.51
3           2020-07-01  2021-06-30 7170        175570.33
3           2021-07-01  2022-06-30 8283        207835.20

(6 rows affected)

-- When you're done, run the following code for cleanup
DROP TABLE IF EXISTS
  dbo.Orders, 
  dbo.EmpYearOrders, 
  dbo.EmpCustOrders, 
  dbo.SensorMeasurements, 
  dbo.Sensors;
