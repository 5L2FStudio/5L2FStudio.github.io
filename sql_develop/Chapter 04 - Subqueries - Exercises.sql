---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 04 - Subqueries
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1 
-- Write a query that returns all orders placed on the last day of
-- activity that can be found in the Orders table
-- Tables involved: TSQLV6 database, Orders table

--Desired output
orderid     orderdate   custid      empid
----------- ----------- ----------- -----------
11077       2022-05-06  65          1
11076       2022-05-06  9           4
11075       2022-05-06  68          8
11074       2022-05-06  73          7

(4 rows affected)

-- 2 
-- Write a query that returns all orders placed
-- by the customer(s) who placed the highest number of orders
-- * Note: there may be more than one customer
--   with the same number of orders
-- Tables involved: TSQLV6 database, Orders table

-- Desired output:
custid      orderid     orderdate  empid
----------- ----------- ---------- -----------
71          10324       2020-10-08 9
71          10393       2020-12-25 1
71          10398       2020-12-30 2
71          10440       2021-02-10 4
71          10452       2021-02-20 8
71          10510       2021-04-18 6
71          10555       2021-06-02 6
71          10603       2021-07-18 8
71          10607       2021-07-22 5
71          10612       2021-07-28 1
71          10627       2021-08-11 8
71          10657       2021-09-04 2
71          10678       2021-09-23 7
71          10700       2021-10-10 3
71          10711       2021-10-21 5
71          10713       2021-10-22 1
71          10714       2021-10-22 5
71          10722       2021-10-29 8
71          10748       2021-11-20 3
71          10757       2021-11-27 6
71          10815       2022-01-05 2
71          10847       2022-01-22 4
71          10882       2022-02-11 4
71          10894       2022-02-18 1
71          10941       2022-03-11 7
71          10983       2022-03-27 2
71          10984       2022-03-30 1
71          11002       2022-04-06 4
71          11030       2022-04-17 7
71          11031       2022-04-17 6
71          11064       2022-05-01 1

(31 rows affected)

-- 3
-- Write a query that returns employees
-- who did not place orders on or after May 1st, 2022
-- Tables involved: TSQLV6 database, Employees and Orders tables

-- Desired output:
empid       firstname  lastname
----------- ---------- --------------------
3           Judy       Lew
5           Sven       Mortensen
6           Paul       Suurs
9           Patricia   Doyle

(4 rows affected)

-- 4
-- Write a query that returns
-- countries where there are customers but not employees
-- Tables involved: TSQLV6 database, Customers and Employees tables

-- Desired output:
country
---------------
Argentina
Austria
Belgium
Brazil
Canada
Denmark
Finland
France
Germany
Ireland
Italy
Mexico
Norway
Poland
Portugal
Spain
Sweden
Switzerland
Venezuela

(19 rows affected)

-- 5
-- Write a query that returns for each customer
-- all orders placed on the customer's last day of activity
-- Tables involved: TSQLV6 database, Orders table

-- Desired output:
custid      orderid     orderdate   empid
----------- ----------- ----------- -----------
1           11011       2022-04-09  3
2           10926       2022-03-04  4
3           10856       2022-01-28  3
4           11016       2022-04-10  9
5           10924       2022-03-04  3
...
87          11025       2022-04-15  6
88          10935       2022-03-09  4
89          11066       2022-05-01  7
90          11005       2022-04-07  2
91          11044       2022-04-23  4

(90 rows affected)

-- 6
-- Write a query that returns customers
-- who placed orders in 2021 but not in 2022
-- Tables involved: TSQLV6 database, Customers and Orders tables

-- Desired output:
custid      companyname
----------- ----------------------------------------
21          Customer KIDPX
23          Customer WVFAF
33          Customer FVXPQ
36          Customer LVJSO
43          Customer UISOJ
51          Customer PVDZC
85          Customer ENQZT

(7 rows affected)

-- 7 
-- Write a query that returns customers
-- who ordered product 12
-- Tables involved: TSQLV6 database,
-- Customers, Orders and OrderDetails tables

-- Desired output:
custid      companyname
----------- ----------------------------------------
48          Customer DVFMB
39          Customer GLLAG
71          Customer LCOUJ
65          Customer NYUHS
44          Customer OXFRU
51          Customer PVDZC
86          Customer SNXOJ
20          Customer THHDP
90          Customer XBBVR
46          Customer XPNIK
31          Customer YJCBX
87          Customer ZHYOS

(12 rows affected)

-- 8 
-- Write a query that calculates a running total qty
-- for each customer and month using subqueries
-- Tables involved: TSQLV6 database, Sales.CustOrders view

-- Desired output:
custid      ordermonth  qty         runqty
----------- ----------- ----------- -----------
1           2021-08-01  38          38
1           2021-10-01  41          79
1           2022-01-01  17          96
1           2022-03-01  18          114
1           2022-04-01  60          174
2           2020-09-01  6           6
2           2021-08-01  18          24
2           2021-11-01  10          34
2           2022-03-01  29          63
3           2020-11-01  24          24
3           2021-04-01  30          54
3           2021-05-01  80          134
3           2021-06-01  83          217
3           2021-09-01  102         319
3           2022-01-01  40          359
...

(636 rows affected)

-- 9
-- Explain the difference between IN and EXISTS

-- 10 
-- Write a query that returns for each order the number of days that past
-- since the same customer’s previous order. To determine recency among orders,
-- use orderdate as the primary sort element and orderid as the tiebreaker.
-- Tables involved: TSQLV6 database, Sales.Orders table

-- Desired output:
custid      orderdate  orderid     diff
----------- ---------- ----------- -----------
1           2021-08-25 10643       NULL
1           2021-10-03 10692       39
1           2021-10-13 10702       10
1           2022-01-15 10835       94
1           2022-03-16 10952       60
1           2022-04-09 11011       24
2           2020-09-18 10308       NULL
2           2021-08-08 10625       324
2           2021-11-28 10759       112
2           2022-03-04 10926       96
...

(830 rows affected)
