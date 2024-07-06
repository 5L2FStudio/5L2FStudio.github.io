---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 03 - Joins
-- Solutions
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1 
-- 1-1 
-- Write a query that generates 5 copies out of each employee row
-- Tables involved: TSQLV6 database, Employees and Nums tables

--Desired output
empid       firstname  lastname             n
----------- ---------- -------------------- -----------
1           Sara       Davis                1
2           Don        Funk                 1
3           Judy       Lew                  1
4           Yael       Peled                1
5           Sven       Mortensen            1
6           Paul       Suurs                1
7           Russell    King                 1
8           Maria      Cameron              1
9           Patricia   Doyle                1
1           Sara       Davis                2
2           Don        Funk                 2
3           Judy       Lew                  2
4           Yael       Peled                2
5           Sven       Mortensen            2
6           Paul       Suurs                2
7           Russell    King                 2
8           Maria      Cameron              2
9           Patricia   Doyle                2
1           Sara       Davis                3
2           Don        Funk                 3
3           Judy       Lew                  3
4           Yael       Peled                3
5           Sven       Mortensen            3
6           Paul       Suurs                3
7           Russell    King                 3
8           Maria      Cameron              3
9           Patricia   Doyle                3
1           Sara       Davis                4
2           Don        Funk                 4
3           Judy       Lew                  4
4           Yael       Peled                4
5           Sven       Mortensen            4
6           Paul       Suurs                4
7           Russell    King                 4
8           Maria      Cameron              4
9           Patricia   Doyle                4
1           Sara       Davis                5
2           Don        Funk                 5
3           Judy       Lew                  5
4           Yael       Peled                5
5           Sven       Mortensen            5
6           Paul       Suurs                5
7           Russell    King                 5
8           Maria      Cameron              5
9           Patricia   Doyle                5

(45 rows affected)

-- Solution
SELECT E.empid, E.firstname, E.lastname, N.n
FROM HR.Employees AS E
  CROSS JOIN dbo.Nums AS N 
WHERE N.n <= 5
ORDER BY n, empid;

-- 1-2
-- Write a query that returns a row for each employee and day 
-- in the range June 12, 2022 – June 16 2022.
-- Tables involved: TSQLV6 database, Employees and Nums tables

--Desired output
empid       dt
----------- -----------
1           2022-06-12 
1           2022-06-13 
1           2022-06-14 
1           2022-06-15 
1           2022-06-16 
2           2022-06-12 
2           2022-06-13 
2           2022-06-14 
2           2022-06-15 
2           2022-06-16 
3           2022-06-12 
3           2022-06-13 
3           2022-06-14 
3           2022-06-15 
3           2022-06-16 
4           2022-06-12 
4           2022-06-13 
4           2022-06-14 
4           2022-06-15 
4           2022-06-16 
5           2022-06-12 
5           2022-06-13 
5           2022-06-14 
5           2022-06-15 
5           2022-06-16 
6           2022-06-12 
6           2022-06-13 
6           2022-06-14 
6           2022-06-15 
6           2022-06-16 
7           2022-06-12 
7           2022-06-13 
7           2022-06-14 
7           2022-06-15 
7           2022-06-16 
8           2022-06-12 
8           2022-06-13 
8           2022-06-14 
8           2022-06-15 
8           2022-06-16 
9           2022-06-12 
9           2022-06-13 
9           2022-06-14 
9           2022-06-15 
9           2022-06-16 

(45 rows affected)

-- Solution
SELECT E.empid,
  DATEADD(day, D.n - 1, CAST('20220612' AS DATE)) AS dt
FROM HR.Employees AS E
  CROSS JOIN Nums AS D
WHERE D.n <= DATEDIFF(day, '20220612', '20220616') + 1
ORDER BY empid, dt;

-- 2
-- Explain what’s wrong in the following query and provide a correct alternative
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON Customers.custid = Orders.custid;

-- Correct solutions
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Sales.Customers
  INNER JOIN Sales.Orders
    ON Customers.custid = Orders.custid;

SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON C.custid = O.custid;

-- 3
-- Return US customers, and for each customer the total number of orders 
-- and total quantities.
-- Tables involved: TSQLV6 database, Customers, Orders and OrderDetails tables

--Desired output
custid      numorders   totalqty
----------- ----------- -----------
32          11          345
36          5           122
43          2           20
45          4           181
48          8           134
55          10          603
65          18          1383
71          31          4958
75          9           327
77          4           46
78          3           59
82          3           89
89          14          1063

(13 rows affected)

-- Solution
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM(OD.qty) AS totalqty
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON O.custid = C.custid
  INNER JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
WHERE C.country = N'USA'
GROUP BY C.custid;

-- 4
-- Return customers and their orders including customers who placed no orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output
custid      companyname     orderid     orderdate
----------- --------------- ----------- -----------
85          Customer ENQZT  10248       2020-07-04 
79          Customer FAPSM  10249       2020-07-05 
34          Customer IBVRG  10250       2020-07-08 
84          Customer NRCSK  10251       2020-07-08 
...
73          Customer JMIKW  11074       2022-05-06 
68          Customer CCKOT  11075       2022-05-06 
9           Customer RTXGC  11076       2022-05-06 
65          Customer NYUHS  11077       2022-05-06 
22          Customer DTDMN  NULL        NULL
57          Customer WVAXS  NULL        NULL

(832 rows affected)

-- Solution
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid;

-- 5
-- Return customers who placed no orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output
custid      companyname
----------- ---------------
22          Customer DTDMN
57          Customer WVAXS

(2 rows affected)

-- Solution
SELECT C.custid, C.companyname
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
WHERE O.orderid IS NULL;

-- 6
-- Return customers with orders placed on Feb 12, 2022 along with their orders
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output
custid      companyname     orderid     orderdate
----------- --------------- ----------- ----------
48          Customer DVFMB  10883       2022-02-12
45          Customer QXPPT  10884       2022-02-12
76          Customer SFOGW  10885       2022-02-12

(3 rows affected)

-- Solution
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  INNER JOIN Sales.Orders AS O
    ON O.custid = C.custid
WHERE O.orderdate = '20220212';

-- 7
-- Write a query that returns all customers, but matches
-- them with their respective orders only if they were placed on February 12, 2022
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output
custid      companyname     orderid     orderdate
----------- --------------- ----------- ----------
72          Customer AHPOP  NULL        NULL
58          Customer AHXHT  NULL        NULL
25          Customer AZJED  NULL        NULL
18          Customer BSVAR  NULL        NULL
91          Customer CCFIZ  NULL        NULL
68          Customer CCKOT  NULL        NULL
49          Customer CQRAA  NULL        NULL
24          Customer CYZTN  NULL        NULL
22          Customer DTDMN  NULL        NULL
48          Customer DVFMB  10883       2022-02-12
10          Customer EEALV  NULL        NULL
40          Customer EFFTC  NULL        NULL
85          Customer ENQZT  NULL        NULL
82          Customer EYHKM  NULL        NULL
79          Customer FAPSM  NULL        NULL
...
51          Customer PVDZC  NULL        NULL
52          Customer PZNLA  NULL        NULL
56          Customer QNIVZ  NULL        NULL
8           Customer QUHWH  NULL        NULL
67          Customer QVEPD  NULL        NULL
45          Customer QXPPT  10884       2022-02-12
7           Customer QXVLA  NULL        NULL
60          Customer QZURI  NULL        NULL
19          Customer RFNQC  NULL        NULL
9           Customer RTXGC  NULL        NULL
76          Customer SFOGW  10885       2022-02-12
69          Customer SIUIH  NULL        NULL
86          Customer SNXOJ  NULL        NULL
88          Customer SRQVM  NULL        NULL
54          Customer TDKEG  NULL        NULL
20          Customer THHDP  NULL        NULL
...

(91 rows affected)

-- Solution
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
    AND O.orderdate = '20220212';

-- 8
-- Explain why the following query isn’t a correct solution query for exercise 7.
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
WHERE O.orderdate = '20220212'
   OR O.orderid IS NULL;

-- Answer
-- The outer join matches all customers with their respective orders,
-- and preserves also customers who didn’t place any orders. 
-- Customers without orders have NULLs in the order attributes. 
-- Then the WHERE filter keeps only rows where the order date is February 12, 2022
--  or the order ID is NULL (a customer without orders at all). 
-- The filter discards customers who didn’t place orders in February 12, 2022 
-- but did place orders in other dates, and according to exercise 7 
-- the query is supposed to return all customers.

-- 9
-- Return all customers, and for each return a Yes/No value
-- depending on whether the customer placed an order on Feb 12, 2022
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output
custid      companyname     HasOrderOn20220212
----------- --------------- ------------------
...
40          Customer EFFTC  No
41          Customer XIIWM  No
42          Customer IAIJK  No
43          Customer UISOJ  No
44          Customer OXFRU  No
45          Customer QXPPT  Yes
46          Customer XPNIK  No
47          Customer PSQUZ  No
48          Customer DVFMB  Yes
49          Customer CQRAA  No
50          Customer JYPSC  No
51          Customer PVDZC  No
52          Customer PZNLA  No
53          Customer GCJSG  No
...

(91 rows affected)

-- Solution
SELECT DISTINCT C.custid, C.companyname, 
  CASE WHEN O.orderid IS NOT NULL THEN 'Yes' ELSE 'No' END AS HasOrderOn20220212
FROM Sales.Customers AS C
  LEFT OUTER JOIN Sales.Orders AS O
    ON O.custid = C.custid
    AND O.orderdate = '20220212';
