---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 11 - SQL Graph
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1-1
-- Write a query that identifies who follows Stav
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname
--------------
Alma
Lilach

(2 rows affected)

-- 1-2
-- Write a query that identifies who follows Stav or Yatzek or both
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname    follows
-------------- ----------
Miko           Yatzek
Alma           Stav
Omer           Yatzek
Mitzi          Yatzek
Lilach         Stav
Lilach         Yatzek

(6 rows affected)

-- 1-3
-- Write a query that identifies who follows both Stav and Yatzek
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname
--------------
Lilach

-- 1-4
-- Write a query that identifies who follows Stav but not Yatzek
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname
--------------
Alma

-- 2-1
-- Write a query that returns relationships where the first account
-- is either a friend of or follows the second account or both
-- Tables involved: TSQLV6 database, 
-- Graph.Account, Graph.IsFriendOf and Graph.Follows tables

--Desired output
actid1  act1    actid2  act2
------- ------- ------- -------
2       Orli    379     Tami
2       Orli    641     Inka
2       Orli    727     Mitzi
71      Miko    199     Lilach
71      Miko    379     Tami
71      Miko    661     Alma
71      Miko    883     Yatzek
71      Miko    953     Omer
199     Lilach  71      Miko
199     Lilach  661     Alma
199     Lilach  883     Yatzek
199     Lilach  941     Stav
199     Lilach  953     Omer
379     Tami    2       Orli
379     Tami    71      Miko
379     Tami    421     Buzi
379     Tami    641     Inka
421     Buzi    379     Tami
421     Buzi    661     Alma
421     Buzi    727     Mitzi
641     Inka    2       Orli
641     Inka    379     Tami
641     Inka    727     Mitzi
661     Alma    71      Miko
661     Alma    199     Lilach
661     Alma    421     Buzi
661     Alma    883     Yatzek
661     Alma    941     Stav
727     Mitzi   2       Orli
727     Mitzi   421     Buzi
727     Mitzi   641     Inka
727     Mitzi   883     Yatzek
883     Yatzek  71      Miko
883     Yatzek  199     Lilach
883     Yatzek  661     Alma
883     Yatzek  727     Mitzi
883     Yatzek  953     Omer
941     Stav    199     Lilach
941     Stav    661     Alma
953     Omer    71      Miko
953     Omer    199     Lilach
953     Omer    883     Yatzek

(42 rows affected)

-- 2-2
-- Write a query that returns relationships where the first account
-- is a friend of but doesn't follow the second account
-- Tables involved: TSQLV6 database, 
-- Graph.Account, Graph.IsFriendOf and Graph.Follows tables

--Desired output
actid1  act1    actid2  act2
------- ------- ------- -------
2       Orli    641     Inka
71      Miko    199     Lilach
199     Lilach  661     Alma
379     Tami    421     Buzi
421     Buzi    727     Mitzi
661     Alma    199     Lilach
661     Alma    883     Yatzek
727     Mitzi   641     Inka
883     Yatzek  71      Miko
883     Yatzek  661     Alma
883     Yatzek  727     Mitzi
883     Yatzek  953     Omer

(12 rows affected)

-- 3
-- Given an input post ID, possibly representing a reply to another post,
-- return the chain of posts leading to the input one
-- Use a recursive query

-- Tables involved: TSQLV6 database, Graph.Post and Graph.IsReplyTo tables

--Desired output for input post ID 1187 as an example
postid  posttext
------- -------------------------------------------------
13      Got a new kitten. Any suggestions for a name?
449     Maybe Pickle?
1031    How about Gherkin?
1061    I love Gherkin!
1187    So you don't like Pickle!? I'M UNFRIENDING YOU!!!

(5 rows affected)

-- 4
-- Solve exercise 3 again, only this time using the SHORTEST_PATH option

