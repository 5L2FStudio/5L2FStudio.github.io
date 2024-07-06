---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 08 - Data Modification
-- Solutions
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1
-- Run the following code to create the dbo.Customers table
-- in the TSQLV6 database
USE TSQLV6;

DROP TABLE IF EXISTS dbo.Customers;

CREATE TABLE dbo.Customers
(
  custid      INT          NOT NULL PRIMARY KEY,
  companyname NVARCHAR(40) NOT NULL,
  country     NVARCHAR(15) NOT NULL,
  region      NVARCHAR(15) NULL,
  city        NVARCHAR(15) NOT NULL  
);
GO

-- 1-1
-- Insert into the dbo.Customers table a row with:
-- custid:  100
-- companyname: Coho Winery
-- country:     USA
-- region:      WA
-- city:        Redmond

-- Solution:
INSERT INTO dbo.Customers(custid, companyname, country, region, city)
  VALUES(100, N'Coho Winery', N'USA', N'WA', N'Redmond');

-- 1-2
-- Insert into the dbo.Customers table 
-- all customers from Sales.Customers
-- who placed orders

-- Solution:
INSERT INTO dbo.Customers(custid, companyname, country, region, city)
  SELECT custid, companyname, country, region, city
  FROM Sales.Customers AS C
  WHERE EXISTS
    (SELECT * FROM Sales.Orders AS O
     WHERE O.custid = C.custid);

-- 1-3
-- Use a SELECT INTO statement to create and populate the dbo.Orders table
-- with orders from the Sales.Orders table
-- that were placed in the years 2020 through 2022

-- Solution:
DROP TABLE IF EXISTS dbo.Orders;

SELECT *
INTO dbo.Orders
FROM Sales.Orders
WHERE orderdate >= '20200101'
  AND orderdate < '20230101';

-- 2
-- Delete from the dbo.Orders table
-- orders that were placed before August 2020
-- Use the OUTPUT clause to return the orderid and orderdate
-- of the deleted orders

-- Desired output:
orderid     orderdate
----------- -----------
10248       2020-07-04 
10249       2020-07-05 
10250       2020-07-08 
10251       2020-07-08 
10252       2020-07-09 
10253       2020-07-10 
10254       2020-07-11 
10255       2020-07-12 
10256       2020-07-15 
10257       2020-07-16 
10258       2020-07-17 
10259       2020-07-18 
10260       2020-07-19 
10261       2020-07-19 
10262       2020-07-22 
10263       2020-07-23 
10264       2020-07-24 
10265       2020-07-25 
10266       2020-07-26 
10267       2020-07-29 
10268       2020-07-30 
10269       2020-07-31 

(22 rows affected)

-- Solution:
DELETE FROM dbo.Orders
  OUTPUT deleted.orderid, deleted.orderdate
WHERE orderdate < '20200801';

-- 3
-- Delete from the dbo.Orders table orders placed by customers from Brazil

-- Solution:

-- With EXISTS
DELETE FROM dbo.Orders
WHERE EXISTS
  (SELECT *
   FROM dbo.Customers AS C
   WHERE dbo.Orders.custid = C.custid
     AND C.country = N'Brazil');

-- Non-standard T-SQL
DELETE FROM O
FROM dbo.Orders AS O
  INNER JOIN dbo.Customers AS C
    ON O.custid = C.custid
WHERE country = N'Brazil';

-- With MERGE
MERGE INTO dbo.Orders AS O
USING (SELECT * FROM dbo.Customers WHERE country = N'Brazil') AS C
  ON O.custid = C.custid
WHEN MATCHED THEN DELETE;

-- 4
-- Run the following query against dbo.Customers,
-- and notice that some rows have a NULL in the region column
SELECT * FROM dbo.Customers;

-- Output:
custid      companyname    country         region     city
----------- -------------- --------------- ---------- --------------- 
1           Customer NRZBB Germany         NULL       Berlin
2           Customer MLTDN Mexico          NULL       México D.F.
3           Customer KBUDE Mexico          NULL       México D.F.
4           Customer HFBZG UK              NULL       London
5           Customer HGVLZ Sweden          NULL       Luleå
6           Customer XHXJV Germany         NULL       Mannheim
7           Customer QXVLA France          NULL       Strasbourg
8           Customer QUHWH Spain           NULL       Madrid
9           Customer RTXGC France          NULL       Marseille
10          Customer EEALV Canada          BC         Tsawassen
...

(90 rows affected)

-- Update the dbo.Customers table and change all NULL region values to '<None>'
-- Use the OUTPUT clause to show the custid, old region and new region

-- Desired output:
custid      oldregion       newregion
----------- --------------- ---------------
1           NULL            <None>
2           NULL            <None>
3           NULL            <None>
4           NULL            <None>
5           NULL            <None>
6           NULL            <None>
7           NULL            <None>
8           NULL            <None>
9           NULL            <None>
11          NULL            <None>
12          NULL            <None>
13          NULL            <None>
14          NULL            <None>
16          NULL            <None>
17          NULL            <None>
18          NULL            <None>
19          NULL            <None>
20          NULL            <None>
23          NULL            <None>
24          NULL            <None>
25          NULL            <None>
26          NULL            <None>
27          NULL            <None>
28          NULL            <None>
29          NULL            <None>
30          NULL            <None>
39          NULL            <None>
40          NULL            <None>
41          NULL            <None>
44          NULL            <None>
49          NULL            <None>
50          NULL            <None>
52          NULL            <None>
53          NULL            <None>
54          NULL            <None>
56          NULL            <None>
58          NULL            <None>
59          NULL            <None>
60          NULL            <None>
63          NULL            <None>
64          NULL            <None>
66          NULL            <None>
68          NULL            <None>
69          NULL            <None>
70          NULL            <None>
72          NULL            <None>
73          NULL            <None>
74          NULL            <None>
76          NULL            <None>
79          NULL            <None>
80          NULL            <None>
83          NULL            <None>
84          NULL            <None>
85          NULL            <None>
86          NULL            <None>
87          NULL            <None>
90          NULL            <None>
91          NULL            <None>

(58 rows affected)

-- Solution:
UPDATE dbo.Customers
  SET region = '<None>'
OUTPUT
  deleted.custid,
  deleted.region AS oldregion,
  inserted.region AS newregion
WHERE region IS NULL;

-- 5
-- Update in the dbo.Orders table all orders placed by UK customers
-- and set their shipcountry, shipregion, shipcity values
-- to the country, region, city values of the corresponding customers from dbo.Customers

-- Solutions:

-- UPDATE with join
UPDATE O
  SET shipcountry = C.country,
      shipregion = C.region,
      shipcity = C.city
FROM dbo.Orders AS O
  INNER JOIN dbo.Customers AS C
    ON O.custid = C.custid
WHERE C.country = N'UK';

-- UPDATE through CTE
WITH CTE_UPD AS
(
  SELECT
    O.shipcountry AS ocountry, C.country AS ccountry,
    O.shipregion  AS oregion,  C.region  AS cregion,
    O.shipcity    AS ocity,    C.city    AS ccity
  FROM dbo.Orders AS O
    INNER JOIN dbo.Customers AS C
      ON O.custid = C.custid
  WHERE C.country = N'UK'
)
UPDATE CTE_UPD
  SET ocountry = ccountry, oregion = cregion, ocity = ccity;

-- Using MERGE
MERGE INTO dbo.Orders AS O
USING (SELECT * FROM dbo.Customers WHERE country = N'UK') AS C
  ON O.custid = C.custid
WHEN MATCHED THEN
  UPDATE SET shipcountry = C.country,
             shipregion = C.region,
             shipcity = C.city;

-- 6
-- Run the following code to create the tables dbo.Orders and dbo.OrderDetails and populate them with data

USE TSQLV6;

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      DATE         NOT NULL,
  requireddate   DATE         NOT NULL,
  shippeddate    DATE         NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity       NVARCHAR(15) NOT NULL,
  shipregion     NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

CREATE TABLE dbo.OrderDetails
(
  orderid   INT           NOT NULL,
  productid INT           NOT NULL,
  unitprice MONEY         NOT NULL
    CONSTRAINT DFT_OrderDetails_unitprice DEFAULT(0),
  qty       SMALLINT      NOT NULL
    CONSTRAINT DFT_OrderDetails_qty DEFAULT(1),
  discount  NUMERIC(4, 3) NOT NULL
    CONSTRAINT DFT_OrderDetails_discount DEFAULT(0),
  CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid),
  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid)
    REFERENCES dbo.Orders(orderid),
  CONSTRAINT CHK_discount  CHECK (discount BETWEEN 0 AND 1),
  CONSTRAINT CHK_qty  CHECK (qty > 0),
  CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
);
GO

INSERT INTO dbo.Orders SELECT * FROM Sales.Orders;
INSERT INTO dbo.OrderDetails SELECT * FROM Sales.OrderDetails;

-- Write and test the T-SQL code that is required to truncate both tables,
-- and make sure that your code runs successfully

-- Solution
ALTER TABLE dbo.OrderDetails DROP CONSTRAINT FK_OrderDetails_Orders;

TRUNCATE TABLE dbo.OrderDetails;
TRUNCATE TABLE dbo.Orders;

ALTER TABLE dbo.OrderDetails ADD CONSTRAINT FK_OrderDetails_Orders
  FOREIGN KEY(orderid) REFERENCES dbo.Orders(orderid);

-- When you're done, run the following code for cleanup
DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders, dbo.Customers;
