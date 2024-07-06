---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 06 - Set Operators
-- Solutions
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1
-- Explain the difference between the UNION ALL and UNION operators
-- In what cases are they equivalent?
-- When they are equivalent, which one should you use?

-- Answer
-- The UNION ALL operator unifies the two input multisets and doesn’t
-- remove duplicates from the result. The UNION operator (implied DISTINCT)
-- also unifies the two input multisets, but does remove duplicates
-- from the result. 
-- The two have different meanings when the result can potentially have duplicates.
-- They have an equivalent meaning when the result can’t have duplicates,
-- such as when you’re unifying disjoint sets (for example, sales 2021 with sales 2022).
-- When they do have the same meaning, it’s important to use UNION ALL by default.
-- That’s in order not to pay unnecessary performance penalties
-- for the work involved in removing duplicates when they don’t exist.

-- 2
-- Write a query that generates a virtual auxiliary table of 10 numbers
-- in the range 1 through 10
-- Tables involved: no table

--Desired output
n
-----------
1
2
3
4
5
6
7
8
9
10

(10 rows affected)

-- Solutions
SELECT 1 AS n
UNION ALL SELECT 2
UNION ALL SELECT 3
UNION ALL SELECT 4
UNION ALL SELECT 5
UNION ALL SELECT 6
UNION ALL SELECT 7
UNION ALL SELECT 8
UNION ALL SELECT 9
UNION ALL SELECT 10;

-- Solution using the VALUES clause
SELECT n
FROM (VALUES(1),(2),(3),(4),(5),(6),(7),(8),(9),(10)) AS Nums(n);

-- 3
-- Write a query that returns customer and employee pairs 
-- that had order activity in January 2022 but not in February 2022
-- Tables involved: TSQLV6 database, Orders table

--Desired output
custid      empid
----------- -----------
1           1
3           3
5           8
5           9
6           9
7           6
9           1
12          2
16          7
17          1
20          7
24          8
25          1
26          3
32          4
38          9
39          3
40          2
41          2
42          2
44          8
47          3
47          4
47          8
49          7
55          2
55          3
56          6
59          8
63          8
64          9
65          3
65          8
66          5
67          5
70          3
71          2
75          1
76          2
76          5
80          1
81          1
81          3
81          4
82          6
84          1
84          3
84          4
88          7
89          4

(50 rows affected)

-- Solution
USE TSQLV6;

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220101' AND orderdate < '20220201'

EXCEPT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220201' AND orderdate < '20220301';

-- 4
-- Write a query that returns customer and employee pairs 
-- that had order activity in both January 2022 and February 2022
-- Tables involved: TSQLV6 database, Orders table

--Desired output
custid      empid
----------- -----------
20          3
39          9
46          5
67          1
71          4

(5 rows affected)

-- Solution
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220101' AND orderdate < '20220201'

INTERSECT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220201' AND orderdate < '20220301';

-- 5
-- Write a query that returns customer and employee pairs 
-- that had order activity in both January 2022 and February 2022
-- but not in 2021
-- Tables involved: TSQLV6 database, Orders table

--Desired output
custid      empid
----------- -----------
67          1
46          5

(2 rows affected)

-- Solution
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220101' AND orderdate < '20220201'

INTERSECT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20220201' AND orderdate < '20220301'

EXCEPT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20210101' AND orderdate < '20220101';

-- With parentheses
(SELECT custid, empid
 FROM Sales.Orders
 WHERE orderdate >= '20220101' AND orderdate < '20220201'

 INTERSECT

 SELECT custid, empid
 FROM Sales.Orders
 WHERE orderdate >= '20220201' AND orderdate < '20220301')

EXCEPT

SELECT custid, empid
FROM Sales.Orders
WHERE orderdate >= '20210101' AND orderdate < '20220101';

-- 6
-- You are given the following query:
SELECT country, region, city
FROM HR.Employees

UNION ALL

SELECT country, region, city
FROM Production.Suppliers;

-- You are asked to add logic to the query 
-- such that it would guarantee that the rows from Employees
-- would be returned in the output before the rows from Suppliers,
-- and within each segment, the rows should be sorted
-- by country, region, city
-- Tables involved: TSQLV6 database, Employees and Suppliers tables

--Desired output
country         region          city
--------------- --------------- ---------------
UK              NULL            London
UK              NULL            London
UK              NULL            London
UK              NULL            London
USA             WA              Kirkland
USA             WA              Redmond
USA             WA              Seattle
USA             WA              Seattle
USA             WA              Tacoma
Australia       NSW             Sydney
Australia       Victoria        Melbourne
Brazil          NULL            Sao Paulo
Canada          Québec          Montréal
Canada          Québec          Ste-Hyacinthe
Denmark         NULL            Lyngby
Finland         NULL            Lappeenranta
France          NULL            Annecy
France          NULL            Montceau
France          NULL            Paris
Germany         NULL            Berlin
Germany         NULL            Cuxhaven
Germany         NULL            Frankfurt
Italy           NULL            Ravenna
Italy           NULL            Salerno
Japan           NULL            Osaka
Japan           NULL            Tokyo
Netherlands     NULL            Zaandam
Norway          NULL            Sandvika
Singapore       NULL            Singapore
Spain           Asturias        Oviedo
Sweden          NULL            Göteborg
Sweden          NULL            Stockholm
UK              NULL            London
UK              NULL            Manchester
USA             LA              New Orleans
USA             MA              Boston
USA             MI              Ann Arbor
USA             OR              Bend

(38 rows affected)

-- Solution
SELECT country, region, city
FROM (SELECT 1 AS sortcol, country, region, city
      FROM HR.Employees

      UNION ALL

      SELECT 2, country, region, city
      FROM Production.Suppliers) AS D
ORDER BY sortcol, country, region, city;
