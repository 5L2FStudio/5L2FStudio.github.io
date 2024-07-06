---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 11 - SQL Graph
-- Solutions
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

-- Solution
SELECT Account2.accountname
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.Follows
WHERE MATCH(Account2-(Follows)->Account1)
  AND Account1.accountname = N'Stav';

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

-- Solution
SELECT Account2.accountname, Account1.accountname AS follows
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.Follows
WHERE MATCH(Account2-(Follows)->Account1)
  AND Account1.accountname IN (N'Stav', N'Yatzek');

-- 1-3
-- Write a query that identifies who follows both Stav and Yatzek
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname
--------------
Lilach

-- Solution
SELECT Account3.accountname
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.Account AS Account3, Graph.Follows AS Follows1,
  Graph.Follows AS Follows2
WHERE MATCH(Account2<-(Follows2)-Account3-(Follows1)->Account1)
  AND Account1.accountname = N'Stav'
  AND Account2.accountname = N'Yatzek';

-- 1-4
-- Write a query that identifies who follows Stav but not Yatzek
-- Tables involved: TSQLV6 database, Graph.Account and Graph.Follows tables

--Desired output
accountname
--------------
Alma

-- Solution
SELECT Account3.accountname
FROM Graph.Account AS Account1, 
  Graph.Account AS Account3, Graph.Follows AS Follows1
WHERE MATCH(Account3-(Follows1)->Account1)
  AND Account1.accountname = N'Stav'
  AND NOT EXISTS(SELECT * 
                 FROM Graph.Account AS Account2,
                   Graph.Follows AS Follows2
                 WHERE MATCH(Account3-(Follows2)->Account2)
                   AND Account2.accountname = N'Yatzek');

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

-- Solutions

-- The long way
SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.IsFriendOf
WHERE MATCH(Account1-(IsFriendOf)->Account2)

UNION

SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.Follows
WHERE MATCH(Account1-(Follows)->Account2);

-- The short way
SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2
WHERE EXISTS (SELECT * FROM Graph.IsFriendOf
              WHERE MATCH(Account1-(IsFriendOf)->Account2))
   OR EXISTS (SELECT * FROM Graph.Follows
              WHERE MATCH(Account1-(Follows)->Account2));

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

-- Solutions

-- The long way
SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.IsFriendOf
WHERE MATCH(Account1-(IsFriendOf)->Account2)

EXCEPT

SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2,
  Graph.Follows
WHERE MATCH(Account1-(Follows)->Account2);

-- The short way
SELECT
  Account1.accountid AS actid1, Account1.accountname AS act1,
  Account2.accountid AS actid2, Account2.accountname AS act2
FROM Graph.Account AS Account1, Graph.Account AS Account2
WHERE EXISTS (SELECT * FROM Graph.IsFriendOf
              WHERE MATCH(Account1-(IsFriendOf)->Account2))
  AND NOT EXISTS (SELECT * FROM Graph.Follows
                  WHERE MATCH(Account1-(Follows)->Account2));

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

-- Solutions

-- Using recursive member as proxy 
DECLARE @postid AS INT = 1187;

WITH C AS
(
  SELECT postid, posttext, 0 AS sortkey
  FROM Graph.Post
  WHERE postid = @postid

  UNION ALL

  SELECT ParentPost.postid, ParentPost.posttext,
    C.sortkey + 1 AS sortkey
  FROM C, Graph.Post AS ParentPost, Graph.IsReplyTo,
    Graph.Post AS ChildPost
  WHERE ChildPost.postid = C.postid -- recursive ref used as proxy
    AND MATCH(ChildPost-(IsReplyTo)->ParentPost)
)
SELECT postid, posttext
FROM C
ORDER BY sortkey DESC;
GO

-- Using traditional joins
DECLARE @postid AS INT = 1187;

WITH C AS
(
  SELECT $node_id AS nodeid, postid, posttext, 0 AS sortkey
  FROM Graph.Post
  WHERE postid = @postid

  UNION ALL

  SELECT PP.$node_id AS nodeid, PP.postid, PP.posttext,
    CP.sortkey + 1 AS sortkey
  FROM C AS CP
    INNER JOIN Graph.IsReplyTo AS R
      ON R.$from_id = CP.nodeid
    INNER JOIN Graph.Post AS PP
      ON R.$to_id = PP.$node_id
)
SELECT postid, posttext
FROM C
ORDER BY sortkey DESC;
GO

-- 4
-- Solve exercise 3 again, only this time using the SHORTEST_PATH option

-- Solution
DECLARE @postid AS INT = 1187;

WITH C AS
(
   SELECT postid, posttext, 0 AS sortkey
   FROM Graph.Post
   WHERE postid = @postid
   
   UNION ALL
   
   SELECT
     LAST_VALUE(Post.postid)   WITHIN GROUP (GRAPH PATH) AS postid,
     LAST_VALUE(Post.posttext) WITHIN GROUP (GRAPH PATH) AS posttext,
     COUNT(Post.postid)        WITHIN GROUP (GRAPH PATH) AS sortkey
   FROM
     Graph.Post AS Reply,
     Graph.IsReplyTo FOR PATH AS IRT, 
     Graph.Post FOR PATH AS Post
   WHERE MATCH(SHORTEST_PATH(Reply(-(IRT)->Post)+))
     AND Reply.postid = @postid
)
SELECT postid, posttext
FROM C
ORDER BY sortkey DESC;
GO

---------------------------------------------------------------------
-- Cleanup 
---------------------------------------------------------------------

-- When you're done reading the module and working on the exercises
-- run the following code for cleanup 
DROP TABLE IF EXISTS
  Norm.Friendships,
  Norm.Followings,
  Norm.Likes,
  Norm.AuthorsPublications,
  Norm.Posts,
  Norm.Accounts,
  Norm.Publications;

DROP TABLE IF EXISTS
  Graph.IsReplyTo,
  Graph.IsFriendOf,
  Graph.Follows,
  Graph.Posted,
  Graph.Likes,
  Graph.Authored,
  Graph.Post,
  Graph.Account,
  Graph.Publication;
GO

DROP SCHEMA IF EXISTS Norm;
DROP SCHEMA IF EXISTS Graph;
GO
