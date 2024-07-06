---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 10 - Transactions and Concurrency
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- In all exercises in this chapter, make sure you are connected
-- to the TSQLV6 sample database
-- by running the following code:

USE TSQLV6;

---------------------------------------------------------------------
-- 1 Blocking
---------------------------------------------------------------------

-- 1-1
-- Open three connections
-- (call them Connection 1, Connection 2 and Connection 3)
-- Run the following code in Connection 1 
-- to update rows in Sales.OrderDetails:

BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET discount = 0.05
  WHERE orderid = 10249;

-- 1-2
-- Run the following code in Connection 2 to query Sales.OrderDetails
-- Connection 2 will be blocked:

SELECT orderid, productid, unitprice, qty, discount
FROM Sales.OrderDetails
WHERE orderid = 10249;

-- 1-3
-- Run the following code in Connection 3
-- and identify the locks and session ids
-- involved in the blocking chain:

SELECT -- use * to explore
  request_session_id            AS sid,
  resource_type                 AS restype,
  resource_database_id          AS dbid,
  resource_description          AS res,
  resource_associated_entity_id AS resid,
  request_mode                  AS mode,
  request_status                AS status
FROM sys.dm_tran_locks;

-- 1-4
-- In the following exercises replace the session ids 52, 53
-- with the ones you found to be involved in the blocking chain
-- in the previous exercise
-- Run the following code to obtain connection/session/blocking
-- information about the sessions involved in the blocking chain

-- Connection info
SELECT -- use * to explore
  session_id AS sid,
  connect_time,
  last_read,
  last_write,
  most_recent_sql_handle
FROM sys.dm_exec_connections
WHERE session_id IN(52, 53);

-- Session info
SELECT -- use * to explore
  session_id AS sid,
  login_time,
  host_name,
  program_name,
  login_name,
  nt_user_name,
  last_request_start_time,
  last_request_end_time
FROM sys.dm_exec_sessions
WHERE session_id IN(52, 53);

-- Blocking
SELECT -- use * to explore
  session_id AS sid,
  blocking_session_id,
  command,
  sql_handle,
  database_id,
  wait_type,
  wait_time,
  wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;

-- 1-5
-- Run the following code to obtain the SQL text of the connections
-- involved in the blocking chain:

-- SQL text
SELECT session_id, text 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST 
WHERE session_id IN(52, 53);

-- 1-6
-- Run the following code in Connection 1 to rollback the transaction:
ROLLBACK TRAN;

-- Observe in Connection 2 that the SELECT query returned the 
-- two order detail rows, and that those rows were not modified
-- Close all connections

---------------------------------------------------------------------
-- 2 Isolation Levels
---------------------------------------------------------------------

---------------------------------------------------------------------
-- 2-1 The READ UNCOMMITTED Isolation Level
---------------------------------------------------------------------

-- 2-1a
-- Open two new connections (call them Connection 1 and Connection 2)

-- 2-1b
-- Run the following code in Connection 1 to update
-- rows in Sales.OrderDetails and query it:

BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET discount += 0.05
  WHERE orderid = 10249;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-1c
-- Run the following code in Connection 2
-- to set the isolation level to READ UNCOMMITTED
-- and query Sales.OrderDetails:

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT orderid, productid, unitprice, qty, discount
FROM Sales.OrderDetails
WHERE orderid = 10249;

-- Notice that you get the modified, uncommitted version of the rows

-- 2-1d
-- Run the following code in Connection 1 to rollback the transaction

ROLLBACK TRAN;

---------------------------------------------------------------------
-- 2-2 The READ COMMITTED Isolation Level
---------------------------------------------------------------------

-- 2-2a
-- Run the following code in Connection 1 to update
-- rows in Sales.OrderDetails and query it:

BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET discount += 0.05
  WHERE orderid = 10249;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-2b
-- Run the following code in Connection 2
-- to set the isolation level to READ COMMITTED
-- and query Sales.OrderDetails:

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT orderid, productid, unitprice, qty, discount
FROM Sales.OrderDetails
WHERE orderid = 10249;

-- Notice that you are now blocked

-- 2-2c
-- Run the following code in Connection 1 to commit the transaction

COMMIT TRAN;

-- 2-2d
-- Go to connection 2 and noticed that you got 
-- the modified, committed version of the rows

-- 2-2e
-- Run the following code for cleanup
UPDATE Sales.OrderDetails
  SET discount = 0.00
WHERE orderid = 10249;

---------------------------------------------------------------------
-- 2-3 The REPEATABLE READ Isolation Level
---------------------------------------------------------------------

-- 2-3a
-- Run the following code in Connection 1 to set the isolation
-- to REPEATABLE READ, open a transaction and read data from Sales.OrderDetails:

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRAN;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- You get two rows with discount values 0.00

-- 2-3b
-- Run the following code in Connection 2 and notice you are blocked:

UPDATE Sales.OrderDetails
  SET discount += 0.05
WHERE orderid = 10249;

-- 2-3c
-- Run the following code in Connection 1 to read the data again
-- and commit the transaction:

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;
  
COMMIT TRAN;

-- You will get the two rows with discount values 0.00 again, 
-- giving you repeatable reads. Note that if your code was running 
-- under a lower isolation level (READ UNCOMMITTED or READ COMMITTED), 
-- the UPDATE statement wouldn’t have been blocked, 
-- and you would have gotten non repeatable reads.

-- 2-3d
-- Go to Connection 2 and notice that the update finished

-- 2-3e
-- Run the following code for cleanup
UPDATE Sales.OrderDetails
  SET discount = 0.00
WHERE orderid = 10249;

---------------------------------------------------------------------
-- 2-4 The SERIALIZABLE Isolation Level
---------------------------------------------------------------------

-- 2-4a
-- Run the following code in Connection 1
-- to set the isolation to SERIALIZABLE and query Sales.OrderDetails:

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-4b
-- Run the following code in Connection 2 to attempt
-- to insert a row to Sales.OrderDetails with the same
-- order ID that is filtered by the previous query
-- and notice that you are blocked:

INSERT INTO Sales.OrderDetails
    (orderid, productid, unitprice, qty, discount)
  VALUES(10249, 2, 19.00, 10, 0.00);

-- Note that in lower isolations (READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ),
-- this INSERT statement wouldn’t have been blocked.

-- 2-4c
-- Run the following code in Connection 1 to query Sales.OrderDetails 
-- again, and commit the transaction:

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

COMMIT TRAN;

-- You get the same result set as you got from the previous query
-- in the same transaction, and since the INSERT statement was blocked,
-- you got no phantom reads.

-- 2-4d
-- Go back to Connection 2 and notice that the INSERT statement finished

-- 2-4e
-- Run the following code for cleanup:
DELETE FROM Sales.OrderDetails
WHERE orderid = 10249
  AND productid = 2;
  
-- 2-4f
-- Run the following code in both Connection 1 and Connection 2
-- to set the isolation level to the default:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

---------------------------------------------------------------------
-- 2-5 The SNAPSHOT Isolation Level
---------------------------------------------------------------------

-- 2-5a
-- Run the following code to allow SNAPSHOT isolation (in Azure SQL Database ON by default)
-- in the TSQLV6 database:
ALTER DATABASE TSQLV6 SET ALLOW_SNAPSHOT_ISOLATION ON;

-- 2-5b
-- Run the following code in Connection 1 to open a transaction,
-- update rows in Sales.OrderDetails and query it:

BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET discount += 0.05
  WHERE orderid = 10249;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-5c

-- Run the following code in Connection 2 to set the isolation
-- to SNAPSHOT and query Sales.OrderDetails
-- Notice that you're not blocked, rather you get an earlier
-- consistent version of the data that was available when the 
-- transaction started (discount values 0.00):

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-5d
-- Go to Connection 1 and commit the transaction:

COMMIT TRAN;

-- 2-5e
-- Go to Connection 2 and query the data again; notice that
-- you still get discount values 0.00:

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-5f
-- In Connection 2 commit the transaction and query the data again;
-- notice that now you get discount values 0.05:

COMMIT TRAN;

SELECT orderid, productid, unitprice, qty, discount
FROM Sales.OrderDetails
WHERE orderid = 10249;

-- 2-5g
-- Run the following code for cleanup:
UPDATE Sales.OrderDetails
  SET discount = 0.00
WHERE orderid = 10249;

-- Close all connections

---------------------------------------------------------------------
-- 2-6 The READ COMMITTED SNAPSHOT Isolation Level
---------------------------------------------------------------------

-- 2-6a
-- Turn on READ_COMMITTED_SNAPSHOT in the TSQLV6 database: (in Azure SQL Database ON by default)
ALTER DATABASE TSQLV6 SET READ_COMMITTED_SNAPSHOT ON;

-- 2-6b
-- Open two new connections (call them Connection 1 and Connection 2)

-- 2-6c
-- Run the following code in Connection 1 to open a transaction
-- and update rows in Sales.OrderDetails:

BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET discount += 0.05
  WHERE orderid = 10249;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-6d

-- Run the following code in Connection 2 which is now
-- running under the isolation READ COMMITTED SNAPSHOT
-- since the database flag READ_COMMITTED_SNAPSHOT is turned on
-- Notice that you're not blocked, rather you get an earlier
-- consistent version of the data that was available when the 
-- statement started (discount values 0.00):

BEGIN TRAN;

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

-- 2-6e
-- Go to Connection 1 and commit the transaction:

COMMIT TRAN;

-- 2-6f
-- Go to Connection 2 and query the data again and commit
-- the transaction; notice that you get the new discount values 0.05:

  SELECT orderid, productid, unitprice, qty, discount
  FROM Sales.OrderDetails
  WHERE orderid = 10249;

COMMIT TRAN;

-- 2-6g
-- Run the following code for cleanup:
UPDATE Sales.OrderDetails
  SET discount = 0.00
WHERE orderid = 10249;

-- Close all connections

-- 2-6h
-- Change the database flags back to the defaults,
-- disabling snapshot isolations:
ALTER DATABASE TSQLV6 SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE TSQLV6 SET READ_COMMITTED_SNAPSHOT OFF;

---------------------------------------------------------------------
-- 3 Deadlocks
---------------------------------------------------------------------

-- 3-1
-- Open two new connections (call them Connection 1 and Connection 2)

-- 3-2
-- Run the following code in Connection 1 to open a transaction
-- and update the row for product 2 in Production.Products:

BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

-- 3-3
-- Run the following code in Connection 2 to open a transaction
-- and update the row for product 3 in Production.Products:

BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 3;

-- 3-4
-- Run the following code in Connection 1 to query product 3;
-- you will be blocked:

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 3;

COMMIT TRAN;

-- 3-5
-- Run the following code in Connection 2 to query product 2;
-- you will be blocked, and a deadlock error will be generated
-- either in Connection 1 or Connection 2:

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- 3-6
-- Can you suggest a way to prevent this deadlock?
-- Answer: swap the order in which you access the objects
-- in one of the transactions.

-- 3-7
-- Run the following code for cleanup:
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

UPDATE Production.Products
  SET unitprice = 10.00
WHERE productid = 3;

