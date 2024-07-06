---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 02 - Single-Table Queries
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1 
-- Return orders placed in June 2021
-- Tables involved: TSQLV6 database, Sales.Orders table

-- Desired output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10555       2021-06-02 71          6
10556       2021-06-03 73          2
10557       2021-06-03 44          9
10558       2021-06-04 4           1
10559       2021-06-05 7           6
10560       2021-06-06 25          8
10561       2021-06-06 24          2
10562       2021-06-09 66          1
10563       2021-06-10 67          2
10564       2021-06-10 65          4
...

(30 rows affected)

-- 2 
-- Return orders placed on the day before the last day of the month
-- Tables involved: Sales.Orders table

-- Desired output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10268       2020-07-30 33          8
10294       2020-08-30 65          4
10342       2020-10-30 25          4
10368       2020-11-29 20          2
10398       2020-12-30 71          2
10430       2021-01-30 20          4
10431       2021-01-30 10          4
10459       2021-02-27 84          4
10520       2021-04-29 70          7
10521       2021-04-29 12          8
...

(30 rows affected)

-- 3 
-- Return employees with last name containing the letter 'e' twice or more
-- Tables involved: HR.Employees table

-- Desired output:
empid       firstname  lastname
----------- ---------- --------------------
4           Yael       Peled
5           Sven       Mortensen

(2 rows affected)

-- 4 
-- Return orders with total value(qty*unitprice) greater than 10000
-- sorted by total value
-- Tables involved: Sales.OrderDetails table

-- Desired output:
orderid     totalvalue
----------- ---------------------
10865       17250.00
11030       16321.90
10981       15810.00
10372       12281.20
10424       11493.20
10817       11490.70
10889       11380.00
10417       11283.20
10897       10835.24
10353       10741.60
10515       10588.50
10479       10495.60
10540       10191.70
10691       10164.80

(14 rows affected)

-- 5
-- Write a query against the HR.Employees table that returns employees
-- with a last name that starts with a lower case letter.
-- Remember that the collation of the sample database
-- is case insensitive (Latin1_General_CI_AS).
-- For simplicity, you can assume that only English letters are used
-- in the employee last names.
-- Tables involved: Sales.OrderDetails table

-- Desired output:
empid       lastname
----------- --------------------

(0 rows affected)

-- 6
-- Explain the difference between the following two queries

-- Query 1
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
WHERE orderdate < '20220501'
GROUP BY empid;

-- Query 2
SELECT empid, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY empid
HAVING MAX(orderdate) < '20220501';

-- 7 
-- Return the three ship countries with the highest average freight for orders placed in 2021
-- Tables involved: Sales.Orders table

-- Desired output:
shipcountry     avgfreight
--------------- ---------------------
Austria         178.3642
Switzerland     117.1775
Sweden          105.16

(3 rows affected)

-- 8 
-- Calculate row numbers for orders
-- based on order date ordering (using order id as tiebreaker)
-- for each customer separately
-- Tables involved: Sales.Orders table

-- Desired output:
custid      orderdate  orderid     rownum
----------- ---------- ----------- --------------------
1           2021-08-25 10643       1
1           2021-10-03 10692       2
1           2021-10-13 10702       3
1           2022-01-15 10835       4
1           2022-03-16 10952       5
1           2022-04-09 11011       6
2           2020-09-18 10308       1
2           2021-08-08 10625       2
2           2021-11-28 10759       3
2           2022-03-04 10926       4
...

(830 rows affected)

-- 9
-- Figure out and return for each employee the gender based on the title of courtesy
-- Ms., Mrs. - Female, Mr. - Male, Dr. - Unknown
-- Tables involved: HR.Employees table

-- Desired output:
empid       firstname  lastname             titleofcourtesy           gender
----------- ---------- -------------------- ------------------------- -------
1           Sara       Davis                Ms.                       Female
2           Don        Funk                 Dr.                       Unknown
3           Judy       Lew                  Ms.                       Female
4           Yael       Peled                Mrs.                      Female
5           Sven       Mortensen            Mr.                       Male
6           Paul       Suurs                Mr.                       Male
7           Russell    King                 Mr.                       Male
8           Maria      Cameron              Ms.                       Female
9           Patricia   Doyle                Ms.                       Female

(9 rows affected)

-- 10
-- Return for each customer the customer ID and region
-- sort the rows in the output by region, ascending
-- having NULLs sort last (after non-NULL values)
-- Note that the default in T-SQL is that NULLs sort first
-- Tables involved: Sales.Customers table

-- Desired output:
custid      region
----------- ---------------
55          AK
10          BC
42          BC
45          CA
37          Co. Cork
33          DF
71          ID
38          Isle of Wight
46          Lara
78          MT
...
1           NULL
2           NULL
3           NULL
4           NULL
5           NULL
6           NULL
7           NULL
8           NULL
9           NULL
11          NULL
...

(91 rows affected)
