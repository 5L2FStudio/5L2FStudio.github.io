---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 02 - Single-Table Queries
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Elements of the SELECT Statement
---------------------------------------------------------------------

-- Listing 2-1: Sample Query
USE TSQLV6;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

---------------------------------------------------------------------
-- The FROM Clause
---------------------------------------------------------------------

SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;

---------------------------------------------------------------------
-- The WHERE Clause
---------------------------------------------------------------------

SELECT orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;

---------------------------------------------------------------------
-- The GROUP BY Clause
---------------------------------------------------------------------

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT
  empid,
  YEAR(orderdate) AS orderyear,
  SUM(freight) AS totalfreight,
  COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

/*
SELECT empid, YEAR(orderdate) AS orderyear, freight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);
*/

SELECT 
  empid, 
  YEAR(orderdate) AS orderyear, 
  COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);

---------------------------------------------------------------------
-- The HAVING Clause
---------------------------------------------------------------------

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

---------------------------------------------------------------------
-- The SELECT Clause
---------------------------------------------------------------------

SELECT orderid orderdate
FROM Sales.Orders;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

/*
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE orderyear > 2021;
*/

SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE YEAR(orderdate) > 2021;

/*
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING numorders > 1;
*/

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

-- Listing 2-2: Query Returning Duplicate Rows
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

-- Listing 2-3: Query With a DISTINCT Clause
SELECT DISTINCT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

SELECT *
FROM Sales.Shippers;

/*
SELECT orderid,
  YEAR(orderdate) AS orderyear,
  orderyear + 1 AS nextyear
FROM Sales.Orders;
*/

SELECT orderid,
  YEAR(orderdate) AS orderyear,
  YEAR(orderdate) + 1 AS nextyear
FROM Sales.Orders;

---------------------------------------------------------------------
-- The ORDER BY Clause
---------------------------------------------------------------------

-- Listing 2-4: Query Demonstrating the ORDER BY Clause
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

SELECT empid, firstname, lastname, country
FROM HR.Employees
ORDER BY hiredate;

/*
SELECT DISTINCT country
FROM HR.Employees
ORDER BY empid;
*/

---------------------------------------------------------------------
-- The TOP and OFFSET-FETCH Filters
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The TOP Filter
---------------------------------------------------------------------

-- Listing 2-5: Query Demonstrating the TOP Option
SELECT TOP (5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP (1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- Listing 2-6: Query Demonstrating TOP with Unique ORDER BY List
SELECT TOP (5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC;

SELECT TOP (5) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

---------------------------------------------------------------------
-- The OFFSET-FETCH Filter
---------------------------------------------------------------------

-- OFFSET-FETCH
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate, orderid
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

---------------------------------------------------------------------
-- A Quick Look at Window Functions
---------------------------------------------------------------------

SELECT orderid, custid, val,
  ROW_NUMBER() OVER(PARTITION BY custid
                    ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;

---------------------------------------------------------------------
-- Predicates and Operators
---------------------------------------------------------------------

-- Predicates: IN, BETWEEN, LIKE
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid IN(10248, 10249, 10250);

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10300 AND 10310;

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

-- Comparison operators: =, >, <, >=, <=, <>, !=, !>, !< 
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20220101';

-- Logical operators: AND, OR, NOT
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20220101'
  AND empid NOT IN(1, 3, 5);

-- Arithmetic operators: +, -, *, /, %
SELECT orderid, productid, qty, unitprice, discount,
  qty * unitprice * (1 - discount) AS val
FROM Sales.OrderDetails;

-- Operator Precedence

-- AND precedes OR
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
        custid = 1
    AND empid IN(1, 3, 5)
    OR  custid = 85
    AND empid IN(2, 4, 6);

-- Equivalent to
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
      (     custid = 1
        AND empid IN(1, 3, 5) )
    OR
      (     custid = 85
        AND empid IN(2, 4, 6) );

-- *, / precedes +, -
SELECT 10 + 2 * 3   -- 16

SELECT (10 + 2) * 3 -- 36

---------------------------------------------------------------------
-- CASE Expression
---------------------------------------------------------------------

-- Simple
SELECT supplierid, COUNT(*) AS numproducts,
  CASE COUNT(*) % 2
    WHEN 0 THEN 'Even'
    WHEN 1 THEN 'Odd'
    ELSE 'Unknown'
  END AS countparity
FROM Production.Products
GROUP BY supplierid;

-- Searched
SELECT orderid, custid, val,
  CASE 
    WHEN val < 1000.00  THEN 'Less than 1000'
    WHEN val <= 3000.00 THEN 'Between 1000 and 3000'
    WHEN val > 3000.00  THEN 'More than 3000'
    ELSE 'Unknown'
  END AS valuecategory
FROM Sales.OrderValues;

---------------------------------------------------------------------
-- NULLs
---------------------------------------------------------------------

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NOT DISTINCT FROM N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA'
   OR region IS NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS DISTINCT FROM N'WA';

---------------------------------------------------------------------
-- The GREATEST and LEAST functions
---------------------------------------------------------------------

-- Use functions in a query against Sales.Orders
SELECT orderid, requireddate, shippeddate,
  GREATEST(requireddate, shippeddate) AS latestdate,
  LEAST(requireddate, shippeddate) AS earliestdate
FROM Sales.Orders
WHERE custid = 8;

-- In earlier versions of SQL Server
SELECT orderid, requireddate, shippeddate,
  CASE 
    WHEN requireddate > shippeddate OR shippeddate IS NULL THEN requireddate
    ELSE shippeddate
  END AS latestdate,
  CASE 
    WHEN requireddate < shippeddate OR shippeddate IS NULL THEN requireddate
    ELSE shippeddate
  END AS earliestdate
FROM Sales.Orders
WHERE custid = 8;

---------------------------------------------------------------------
-- All-At-Once Operations
---------------------------------------------------------------------

/*
SELECT 
  orderid, 
  YEAR(orderdate) AS orderyear, 
  orderyear + 1 AS nextyear
FROM Sales.Orders;
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE col1 <> 0 AND col2/col1 > 2;
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE
  CASE
    WHEN col1 = 0 THEN 'no' -- or 'yes' if row should be returned
    WHEN col2/col1 > 2 THEN 'yes'
    ELSE 'no'
  END = 'yes';
*/

/*
SELECT col1, col2
FROM dbo.T1
WHERE (col1 > 0 AND col2 > 2*col1) OR (col1 < 0 AND col2 < 2*col1); 
*/

---------------------------------------------------------------------
-- Working with Character Data
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Collation
---------------------------------------------------------------------

SELECT name, description
FROM sys.fn_helpcollations();

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname = N'davis';

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS = N'davis';

---------------------------------------------------------------------
-- Operators and Functions
---------------------------------------------------------------------

-- Concatenation
SELECT empid, firstname + N' ' + lastname AS fullname
FROM HR.Employees;

-- Listing 2-7: Query Demonstrating String Concatenation
SELECT custid, country, region, city,
  country + N',' + region + N',' + city AS location
FROM Sales.Customers;

-- convert NULL to empty string
SELECT custid, country, region, city,
  country + COALESCE(N',' + region, N'') + N',' + city AS location
FROM Sales.Customers;

-- using the CONCAT function
SELECT custid, country, region, city,
  CONCAT(country, N',' + region, N',' + city) AS location
FROM Sales.Customers;

-- using the CONCAT function
SELECT custid, country, region, city,
  CONCAT_WS(N',', country, region, city) AS location
FROM Sales.Customers;

-- Functions
SELECT SUBSTRING('abcde', 1, 3); -- 'abc'

SELECT RIGHT('abcde', 3); -- 'cde'

SELECT LEN(N'abcde'); -- 5

SELECT DATALENGTH(N'abcde'); -- 10

SELECT CHARINDEX(' ','Itzik Ben-Gan'); -- 6

SELECT PATINDEX('%[0-9]%', 'abcd123efgh'); -- 5

SELECT REPLACE('1-a 2-b', '-', ':'); -- '1:a 2:b'

SELECT empid, lastname,
  LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) AS numoccur
FROM HR.Employees;

-- bug
SELECT REPLACE(REPLACE('123.456.789,00', '.', ','), ',', '.'); -- '123.456.789.00'

-- no bug
SELECT REPLACE(REPLACE(REPLACE('123.456.789,00', '.', '~'), ',', '.'), '~', ','); -- '123,456,789.00'

SELECT TRANSLATE('123.456.789,00', '.,', ',.'); -- '123,456,789.00'

SELECT REPLICATE('abc', 3); -- 'abcabcabc'

SELECT supplierid,
  RIGHT(REPLICATE('0', 9) + CAST(supplierid AS VARCHAR(10)),
        10) AS strsupplierid
FROM Production.Suppliers;

SELECT STUFF('xyz', 2, 1, 'abc'); -- 'xabcz'

SELECT UPPER('Itzik Ben-Gan'); -- 'ITZIK BEN-GAN'

SELECT LOWER('Itzik Ben-Gan'); -- 'itzik ben-gan'

SELECT RTRIM(LTRIM('   abc   ')); -- 'abc'

SELECT TRIM('   abc   '); -- 'abc'

SELECT
  TRANSLATE(TRIM(TRANSLATE(TRIM(TRANSLATE(
    '//\\ remove leading and trailing backward (\) and forward (/) slashes \\//',
    ' /', '~ ')), ' \', '^ ')), ' ^~', '\/ ')
  AS outputstring;

SELECT TRIM( '/\' 
             FROM '//\\ remove leading and trailing backward (\) and forward (/) slashes \\//' )
       AS outputstring;

SELECT FORMAT(1759, '0000000000'); -- '0000001759'

-- COMPRESS
SELECT COMPRESS(N'This is my cv. Imagine it was much longer.');

/*
INSERT INTO dbo.EmployeeCVs( empid, cv )
  VALUES( @empid, COMPRESS(@cv) );
*/

-- DECOMPRESS
SELECT DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'));

SELECT
  CAST(
    DECOMPRESS(COMPRESS(N'This is my cv. Imagine it was much longer.'))
      AS NVARCHAR(MAX));

/*
SELECT empid, CAST(DECOMPRESS(cv) AS NVARCHAR(MAX)) AS cv
FROM dbo.EmployeeCVs;
*/

-- STRING_SPLIT
SELECT CAST(value AS INT) AS myvalue
FROM STRING_SPLIT('10248,10249,10250', ',') AS S;

/*
myvalue
-----------
10248
10249
10250
*/

SELECT CAST(value AS INT) AS myvalue, ordinal
FROM STRING_SPLIT('10248,10249,10250', ',', 1) AS S;

/*
myvalue     ordinal
----------- --------
10248       1
10249       2
10250       3
*/

SELECT custid, 
  STRING_AGG(CAST(orderid AS VARCHAR(10)), ',')
    WITHIN GROUP(ORDER BY orderdate DESC, orderid DESC) AS custorders
FROM Sales.Orders
GROUP BY custid;

/*
custid      custorders
----------- --------------------------------------------
1           11011,10952,10835,10702,10692,10643
2           10926,10759,10625,10308
3           10856,10682,10677,10573,10535,10507,10365
...

(89 rows affected)
*/

---------------------------------------------------------------------
-- LIKE Predicate
---------------------------------------------------------------------

-- Last name starts with D
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

-- Second character in last name is e
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'_e%';

-- First character in last name is A, B or C
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[ABC]%';

-- First character in last name is A through E
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[A-E]%';

-- First character in last name is not A through E
SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[^A-E]%';

---------------------------------------------------------------------
-- Working with Date and Time Data
---------------------------------------------------------------------

-- Literals
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = '20220212';

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = CAST('20220212' AS DATE);

-- Language dependent
SET LANGUAGE British;
SELECT CAST('02/12/2022' AS DATE);

SET LANGUAGE us_english;
SELECT CAST('02/12/2022' AS DATE);

-- Language neutral
SET LANGUAGE British;
SELECT CAST('20220212' AS DATE);

SET LANGUAGE us_english;
SELECT CAST('20220212' AS DATE);

SELECT CONVERT(DATE, '02/12/2022', 101);

SELECT CONVERT(DATE, '02/12/2022', 103);

SELECT PARSE('02/12/2022' AS DATE USING 'en-US');

SELECT PARSE('02/12/2022' AS DATE USING 'en-GB');

-- Working with Date and Time Separately

-- Create Sales.Orders2 with orderdate as DATETIME by copying data from Sales.Orders
DROP TABLE IF EXISTS Sales.Orders2;

SELECT orderid, custid, empid, CAST(orderdate AS DATETIME) AS orderdate
INTO Sales.Orders2
FROM Sales.Orders;

-- Query Sales.Orders2
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders2
WHERE orderdate = '20220212';

ALTER TABLE Sales.Orders2
  ADD CONSTRAINT CHK_Orders2_orderdate
  CHECK( CONVERT(CHAR(12), orderdate, 114) = '00:00:00:000' );

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders2
WHERE orderdate >= '20220212'
  AND orderdate < '20220213';

SELECT CAST('12:30:15.123' AS DATETIME);

-- Cleanup
DROP TABLE IF EXISTS Sales.Orders2;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE YEAR(orderdate) = 2021;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20210101' AND orderdate < '20220101';

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE YEAR(orderdate) = 2022 AND MONTH(orderdate) = 2;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20220201' AND orderdate < '20220301';

-- Functions

-- Current Date and Time
SELECT
  GETDATE()           AS [GETDATE],
  CURRENT_TIMESTAMP   AS [CURRENT_TIMESTAMP],
  GETUTCDATE()        AS [GETUTCDATE],
  SYSDATETIME()       AS [SYSDATETIME],
  SYSUTCDATETIME()    AS [SYSUTCDATETIME],
  SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET];

SELECT
  CAST(SYSDATETIME() AS DATE) AS [current_date],
  CAST(SYSDATETIME() AS TIME) AS [current_time];

-- The CAST, CONVERT and PARSE Functions and their TRY_ Counterparts
SELECT CAST('20220212' AS DATE);
SELECT CAST(SYSDATETIME() AS DATE);
SELECT CAST(SYSDATETIME() AS TIME);

SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);
SELECT CONVERT(DATETIME, CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112), 112);

SELECT CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114);
SELECT CONVERT(DATETIME, CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114), 114);

SELECT PARSE('02/12/2022' AS DATETIME USING 'en-US');
SELECT PARSE('02/12/2022' AS DATETIME USING 'en-GB');

-- SWITCHOFFSET
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-05:00');
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+00:00');

-- TODATETIMEOFFSET
/*
UPDATE dbo.T1
  SET dto = TODATETIMEOFFSET(dt, theoffset);
*/

-- AT TIME ZONE

SELECT name, current_utc_offset, is_currently_dst
FROM sys.time_zone_info;

-- Converting non-datetimeoffset values
-- behavior similar to TODATETIMEOFFSET
SELECT
  CAST('20220212 12:00:00.0000000' AS DATETIME2)
    AT TIME ZONE 'Pacific Standard Time' AS val1,
  CAST('20220812 12:00:00.0000000' AS DATETIME2)
    AT TIME ZONE 'Pacific Standard Time' AS val2;

-- Converting datetimeoffset values
-- behavior similar to SWITCHOFFSET
SELECT
  CAST('20220212 12:00:00.0000000 -05:00' AS DATETIMEOFFSET)
    AT TIME ZONE 'Pacific Standard Time' AS val1,
  CAST('20220812 12:00:00.0000000 -04:00' AS DATETIMEOFFSET)
    AT TIME ZONE 'Pacific Standard Time' AS val2;

-- Current local time in desired time zone
SELECT SYSDATETIMEOFFSET() AT TIME ZONE 'Pacific Standard Time';

-- DATEADD
SELECT DATEADD(year, 1, '20220212');

-- DATEDIFF
SELECT DATEDIFF(day, '20210212', '20220212');

SELECT DATEDIFF_BIG(millisecond, '00010101', '20220212');

SELECT
  DATEADD(
    day, 
    DATEDIFF(day, '19000101', SYSDATETIME()), '19000101');

SELECT
  DATEADD(
    month, 
    DATEDIFF(month, '19000101', SYSDATETIME()), '19000101');

SELECT
  DATEADD(
    year, 
    DATEDIFF(year, '18991231', SYSDATETIME()), '18991231');

-- DATEPART

SELECT DATEPART(month, '20220212');

SELECT 
  DATEPART(day, '20220212') AS part_day,
  DATEPART(weekday, '20220212') AS part_weekday,
  DATEPART(dayofyear, '20220212') AS part_dayofyear;

-- DAY, MONTH, YEAR

SELECT
  DAY('20220212') AS theday,
  MONTH('20220212') AS themonth,
  YEAR('20220212') AS theyear;

-- DATENAME
SELECT DATENAME(month, '20220212');

SELECT DATENAME(year, '20220212');

-- DATEPART

SELECT DATETRUNC(month, '20220212');

-- ISDATE
SELECT ISDATE('20220212');
SELECT ISDATE('20220230');

-- fromparts
SELECT
  DATEFROMPARTS(2022, 02, 12),
  DATETIME2FROMPARTS(2022, 02, 12, 13, 30, 5, 1, 7),
  DATETIMEFROMPARTS(2022, 02, 12, 13, 30, 5, 997),
  DATETIMEOFFSETFROMPARTS(2022, 02, 12, 13, 30, 5, 1, -8, 0, 7),
  SMALLDATETIMEFROMPARTS(2022, 02, 12, 13, 30),
  TIMEFROMPARTS(13, 30, 5, 1, 7);

-- EOMONTH
SELECT EOMONTH(SYSDATETIME());

-- orders placed on last day of month
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate);

-- without the EOMONTH function
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(month, DATEDIFF(month, '18991231', orderdate), '18991231');

-- GENERATE_SERIES

-- Sequence of integers between 1 and 31
SELECT value
FROM GENERATE_SERIES( 1, 10 ) AS N;

-- Sequence of all dates in 2022
DECLARE @startdate AS DATE = '20220101', @enddate AS DATE = '20221231';

SELECT DATEADD(day, value, @startdate) AS dt
FROM GENERATE_SERIES( 0, DATEDIFF(day, @startdate, @enddate) ) AS N;

---------------------------------------------------------------------
-- Querying Metadata
---------------------------------------------------------------------

-- Catalog Views
USE TSQLV6;

SELECT SCHEMA_NAME(schema_id) AS table_schema_name, name AS table_name
FROM sys.tables;

SELECT 
  name AS column_name,
  TYPE_NAME(system_type_id) AS column_type,
  max_length,
  collation_name,
  is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'Sales.Orders');

-- Information Schema Views
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = N'BASE TABLE';

SELECT 
  COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
  COLLATION_NAME, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'Sales'
  AND TABLE_NAME = N'Orders';

-- System Stored Procedures and Functions
EXEC sys.sp_tables;

EXEC sys.sp_help
  @objname = N'Sales.Orders';

EXEC sys.sp_columns
  @table_name = N'Orders',
  @table_owner = N'Sales';

EXEC sys.sp_helpconstraint
  @objname = N'Sales.Orders';

SELECT 
  SERVERPROPERTY('Collation');

SELECT
  DATABASEPROPERTYEX(N'TSQLV6', 'Collation');

SELECT 
  OBJECTPROPERTY(OBJECT_ID(N'Sales.Orders'), 'TableHasPrimaryKey');

SELECT
  COLUMNPROPERTY(OBJECT_ID(N'Sales.Orders'), N'shipcountry', 'AllowsNull');
  