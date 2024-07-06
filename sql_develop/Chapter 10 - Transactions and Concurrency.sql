---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 10 - Transactions and Concurrency
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Transactions
---------------------------------------------------------------------

-- Transaction Example
USE TSQLV6;

-- Start a new transaction
BEGIN TRAN;

  -- Declare a variable
  DECLARE @neworderid AS INT;

  -- Insert a new order into the Sales.Orders table
  INSERT INTO Sales.Orders
      (custid, empid, orderdate, requireddate, shippeddate, 
       shipperid, freight, shipname, shipaddress, shipcity,
       shippostalcode, shipcountry)
    VALUES
      (85, 5, '20220212', '20220301', '20220216',
       3, 32.38, N'Ship to 85-B', N'6789 rue de l''Abbaye', N'Reims',
       N'10345', N'France');

  -- Save the new order ID in a variable
  SET @neworderid = SCOPE_IDENTITY();

  -- Return the new order ID
  SELECT @neworderid AS neworderid;

  -- Insert order lines for new order into Sales.OrderDetails
  INSERT INTO Sales.OrderDetails(orderid, productid, unitprice, qty, discount)
    VALUES(@neworderid, 11, 14.00, 12, 0.000),
          (@neworderid, 42, 9.80, 10, 0.000),
          (@neworderid, 72, 34.80, 5, 0.000);

-- Commit the transaction
COMMIT TRAN;

-- Cleanup
DELETE FROM Sales.OrderDetails
WHERE orderid > 11077;

DELETE FROM Sales.Orders
WHERE orderid > 11077;

---------------------------------------------------------------------
-- Locks and Blocking
---------------------------------------------------------------------

-- In Azure SQL Database this option is ON by default
ALTER DATABASE TSQLV6 SET READ_COMMITTED_SNAPSHOT OFF;

-- Make sure in all new connections 
-- that you are connected to TSQLV6
USE TSQLV6;

-- Connection 1
BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

-- Connection 2
SELECT productid, unitprice
FROM Production.Products
WHERE productid = 2;

-- Connection 3

-- Lock info

SELECT -- use * to explore
  request_session_id            AS sid,
  resource_type                 AS restype,
  resource_database_id          AS dbid,
  DB_NAME(resource_database_id) AS dbname,
  resource_description          AS res,
  resource_associated_entity_id AS resid,
  request_mode                  AS mode,
  request_status                AS status
FROM sys.dm_tran_locks;

-- Connection info
SELECT -- use * to explore
  session_id AS sid,
  connect_time,
  last_read,
  last_write,
  most_recent_sql_handle
FROM sys.dm_exec_connections
WHERE session_id IN(52, 53);

-- SQL text
SELECT session_id, text 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST 
WHERE session_id IN(52, 53);

-- Input buffer
SELECT session_id, event_info 
FROM sys.dm_exec_connections
  CROSS APPLY sys.dm_exec_input_buffer(session_id, NULL) AS IB 
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

-- Connection 2
-- Stop, then set the LOCK_TIMEOUT, then retry
SET LOCK_TIMEOUT 5000;

SELECT productid, unitprice
FROM Production.Products
WHERE productid = 2;

-- Remove timeout
SET LOCK_TIMEOUT -1;

SELECT productid, unitprice
FROM Production.Products
WHERE productid = 2;

-- Connection 3
KILL 52;

---------------------------------------------------------------------
-- Isolation Levels
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The READ UNCOMMITTED Isolation Level
---------------------------------------------------------------------

-- Connection 1
BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT productid, unitprice
FROM Production.Products
WHERE productid = 2;

-- Connection 1
ROLLBACK TRAN;

---------------------------------------------------------------------
-- The READ COMMITTED Isolation Level
---------------------------------------------------------------------

-- Connection 1
BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT productid, unitprice
FROM Production.Products
WHERE productid = 2;

-- Connection 1
COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

---------------------------------------------------------------------
-- The REPEATABLE READ Isolation Level
---------------------------------------------------------------------

-- Connection 1
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN TRAN;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2
UPDATE Production.Products
  SET unitprice += 1.00
WHERE productid = 2;

-- Connection 1
  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

---------------------------------------------------------------------
-- The SERIALIZABLE Isolation Level
---------------------------------------------------------------------

-- Connection 1
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN

  SELECT productid, productname, categoryid, unitprice
  FROM Production.Products
  WHERE categoryid = 1;

-- Connection 2
INSERT INTO Production.Products
    (productname, supplierid, categoryid,
     unitprice, discontinued)
  VALUES('Product ABCDE', 1, 1, 20.00, 0);

-- Connection 1
  SELECT productid, productname, categoryid, unitprice
  FROM Production.Products
  WHERE categoryid = 1;

COMMIT TRAN;

-- Cleanup
DELETE FROM Production.Products
WHERE productid > 77;

-- In all connections issue:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

---------------------------------------------------------------------
-- Isolation Levels Based on Row Versioning
---------------------------------------------------------------------

---------------------------------------------------------------------
-- The SNAPSHOT Isolation Level
---------------------------------------------------------------------

-- Allow SNAPSHOT isolation in the database (in Azure SQL Database ON by default)
ALTER DATABASE TSQLV6 SET ALLOW_SNAPSHOT_ISOLATION ON;

-- Connection 1
BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 1

COMMIT TRAN;

-- Connection 2

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- Connection 2
BEGIN TRAN

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

---------------------------------------------------------------------
-- Conflict Detection
---------------------------------------------------------------------

-- Connection 1, Step 1
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

BEGIN TRAN;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 1, Step 2
  UPDATE Production.Products
    SET unitprice = 20.00
  WHERE productid = 2;
  
COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

-- Connection 1, Step 1
BEGIN TRAN;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2, Step 1
UPDATE Production.Products
  SET unitprice = 25.00
WHERE productid = 2;

-- Connection 1, Step 2
  UPDATE Production.Products
    SET unitprice = 20.00
  WHERE productid = 2;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

-- Close all connections

---------------------------------------------------------------------
-- The READ COMMITTED SNAPSHOT Isolation Level
---------------------------------------------------------------------

-- Turn on READ_COMMITTED_SNAPSHOT (in Azure SQL Database ON by default)
ALTER DATABASE TSQLV6 SET READ_COMMITTED_SNAPSHOT ON; 

-- Connection 1
USE TSQLV6;

BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 2
BEGIN TRAN;

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

-- Connection 1

COMMIT TRAN;

-- Connection 2

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

-- Close all connections

-- Make sure you're back in default mode
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Change database options to default
ALTER DATABASE TSQLV6 SET ALLOW_SNAPSHOT_ISOLATION OFF;
ALTER DATABASE TSQLV6 SET READ_COMMITTED_SNAPSHOT OFF;

---------------------------------------------------------------------
-- Deadlocks
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Simple Deadlock Example
---------------------------------------------------------------------

-- Connection 1
USE TSQLV6;

BEGIN TRAN;

  UPDATE Production.Products
    SET unitprice += 1.00
  WHERE productid = 2;

-- Connection 2
BEGIN TRAN;

  UPDATE Sales.OrderDetails
    SET unitprice += 1.00
  WHERE productid = 2;

-- Connection 1

  SELECT orderid, productid, unitprice
  FROM Sales.OrderDetails
  WHERE productid = 2;

COMMIT TRAN;

-- Connection 2

  SELECT productid, unitprice
  FROM Production.Products
  WHERE productid = 2;

COMMIT TRAN;

-- Cleanup
UPDATE Production.Products
  SET unitprice = 19.00
WHERE productid = 2;

UPDATE Sales.OrderDetails
  SET unitprice = 19.00
WHERE productid = 2
  AND orderid >= 10500;

UPDATE Sales.OrderDetails
  SET unitprice = 15.20
WHERE productid = 2
  AND orderid < 10500;
