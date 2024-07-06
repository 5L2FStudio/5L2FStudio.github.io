---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 12 - Programmable Objects
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

USE TSQLV6;

---------------------------------------------------------------------
-- Variables
---------------------------------------------------------------------

-- Declare a variable and initialize it with a value
DECLARE @i AS INT;
SET @i = 10;
GO

-- Declare and initialize a variable in the same statement
DECLARE @i AS INT = 10;
GO

-- Store the result of a subquery in a variable
DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE empid = 3);

SELECT @empname AS empname;
GO

-- Using the SET command to assign one variable at a time
DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SET @firstname = (SELECT firstname
                  FROM HR.Employees
                  WHERE empid = 3);
SET @lastname = (SELECT lastname
                  FROM HR.Employees
                  WHERE empid = 3);

SELECT @firstname AS firstname, @lastname AS lastname;
GO

-- Using the SELECT command to assign multiple variables in the same statement
DECLARE @firstname AS NVARCHAR(20), @lastname AS NVARCHAR(40);

SELECT
  @firstname = firstname,
  @lastname  = lastname
FROM HR.Employees
WHERE empid = 3;

SELECT @firstname AS firstname, @lastname AS lastname;
GO

-- SELECT doesn't fail when multiple rows qualify
DECLARE @empname AS NVARCHAR(61);

SELECT @empname = firstname + N' ' + lastname
FROM HR.Employees
WHERE mgrid = 2;

SELECT @empname AS empname;
GO

-- SET fails when multiple rows qualify
DECLARE @empname AS NVARCHAR(61);

SET @empname = (SELECT firstname + N' ' + lastname
                FROM HR.Employees
                WHERE mgrid = 2);

SELECT @empname AS empname;
GO

---------------------------------------------------------------------
-- Batches
---------------------------------------------------------------------

-- A Batch as a Unit of Parsing

-- Valid batch
PRINT 'First batch';
USE TSQLV6;
GO
-- Invalid batch
PRINT 'Second batch';
SELECT custid FROM Sales.Customers;
SELECT orderid FOM Sales.Orders;
GO
-- Valid batch
PRINT 'Third batch';
SELECT empid FROM HR.Employees;
GO

-- Batches and Variables

DECLARE @i AS INT = 10;
-- Succeeds
PRINT @i;
GO

-- Fails
PRINT @i;
GO

-- Statements That Cannot Be Combined in the same Batch

DROP VIEW IF EXISTS Sales.MyView;

CREATE VIEW Sales.MyView
AS

SELECT YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
GROUP BY YEAR(orderdate);
GO

-- A Batch as a Unit of Resolution

-- Create T1 with one column
DROP TABLE IF EXISTS dbo.T1;
CREATE TABLE dbo.T1(col1 INT);
GO

-- Following fails
ALTER TABLE dbo.T1 ADD col2 INT;
SELECT col1, col2 FROM dbo.T1;
GO

-- Following succeeds
ALTER TABLE dbo.T1 ADD col2 INT;
GO
SELECT col1, col2 FROM dbo.T1;
GO

-- The GO n Option

-- Create T1 with identity column
DROP TABLE IF EXISTS dbo.T1;
CREATE TABLE dbo.T1(col1 INT IDENTITY CONSTRAINT PK_T1 PRIMARY KEY);
GO

-- Suppress insert messages
SET NOCOUNT ON;
GO

-- Execute batch 100 times
INSERT INTO dbo.T1 DEFAULT VALUES;
GO 100

SELECT * FROM dbo.T1;

---------------------------------------------------------------------
-- Flow Elements
---------------------------------------------------------------------

-- The IF ... ELSE Flow Element
IF YEAR(SYSDATETIME()) <> YEAR(DATEADD(day, 1, SYSDATETIME()))
  PRINT 'Today is the last day of the year.';
ELSE
  PRINT 'Today is not the last day of the year.';
GO

-- IF ELSE IF
IF YEAR(SYSDATETIME()) <> YEAR(DATEADD(day, 1, SYSDATETIME()))
  PRINT 'Today is the last day of the year.';
ELSE
  IF MONTH(SYSDATETIME()) <> MONTH(DATEADD(day, 1, SYSDATETIME()))
    PRINT 'Today is the last day of the month but not the last day of the year.';
  ELSE 
    PRINT 'Today is not the last day of the month.';
GO

-- Statement Block
IF DAY(SYSDATETIME()) = 1
BEGIN
  PRINT 'Today is the first day of the month.';
  PRINT 'Starting first-of-month-day process.';
  /* ... process code goes here ... */
  PRINT 'Finished first-of-month-day database process.';
END;
ELSE
BEGIN
  PRINT 'Today is not the first day of the month.';
  PRINT 'Starting non-first-of-month-day process.';
  /* ... process code goes here ... */
  PRINT 'Finished non-first-of-month-day process.';
END;
GO

-- The WHILE Flow Element
DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
  PRINT @i;
  SET @i = @i + 1;
END;
GO

-- BREAK
DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
  IF @i = 6 BREAK;
  PRINT @i;
  SET @i = @i + 1;
END;
GO

-- CONTINUE
DECLARE @i AS INT = 0;
WHILE @i < 10
BEGIN
  SET @i = @i + 1;
  IF @i = 6 CONTINUE;
  PRINT @i;
END;
GO

-- Using a WHILE loop to populate a table of numbers
SET NOCOUNT ON;
DROP TABLE IF EXISTS dbo.Numbers;
CREATE TABLE dbo.Numbers(n INT NOT NULL PRIMARY KEY);
GO

DECLARE @i AS INT = 1;
WHILE @i <= 1000
BEGIN
  INSERT INTO dbo.Numbers(n) VALUES(@i);
  SET @i = @i + 1;
END;
GO

---------------------------------------------------------------------
-- Cursors
---------------------------------------------------------------------

-- Example: Running Aggregations

-- Suppress messages indicating how many rows were affected
SET NOCOUNT ON;

-- Declare table variable to hold the final result
DECLARE @Result AS TABLE
(
  custid     INT,
  ordermonth DATE,
  qty        INT, 
  runqty     INT,
  PRIMARY KEY(custid, ordermonth)
);

-- Declare local variables that are used to store intermediate values
DECLARE
  @custid     AS INT,
  @prvcustid  AS INT,
  @ordermonth AS DATE,
  @qty        AS INT,
  @runqty     AS INT;

-- Step 1: Declare the cursor based on a query
DECLARE C CURSOR FAST_FORWARD /* read only, forward only */ FOR
  SELECT custid, ordermonth, qty
  FROM Sales.CustOrders
  ORDER BY custid, ordermonth;

-- Step 2: Open the cursor
OPEN C;

-- Step 3: Fetch attribute values from the first cursor record into variables
FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;

-- Initialize variables
SELECT @prvcustid = @custid, @runqty = 0;

-- Step 4: Loop through the cursor records while last fetch was successful
--         In each iteration:
--           Reset variables if customer ID changes
--           Compute current running total and insert into table variable
--           Fetch next cursor record
WHILE @@FETCH_STATUS = 0
BEGIN
  IF @custid <> @prvcustid
    SELECT @prvcustid = @custid, @runqty = 0;

  SET @runqty = @runqty + @qty;

  INSERT INTO @Result VALUES(@custid, @ordermonth, @qty, @runqty);
  
  FETCH NEXT FROM C INTO @custid, @ordermonth, @qty;
END;

-- Step 5: Close the cursor
CLOSE C;

-- Step 6: Deallocate the cursor
DEALLOCATE C;

-- Enable showing messages indicating how many rows were affected
SET NOCOUNT OFF;

-- Query the table variable to return the final result
SELECT 
  custid,
  CONVERT(VARCHAR(7), ordermonth, 121) AS ordermonth,
  qty,
  runqty
FROM @Result
ORDER BY custid, ordermonth;
GO

-- Using a window aggregate function
SELECT custid, ordermonth, qty,
  SUM(qty) OVER(PARTITION BY custid
                ORDER BY ordermonth
                ROWS UNBOUNDED PRECEDING) AS runqty
FROM Sales.CustOrders
ORDER BY custid, ordermonth;

---------------------------------------------------------------------
-- Temporary Tables
---------------------------------------------------------------------

-- Local Temporary Tables

DROP TABLE IF EXISTS #MyOrderTotalsByYear;
GO

CREATE TABLE #MyOrderTotalsByYear
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO #MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM dbo.#MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN dbo.#MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
GO

-- Try accessing the table from another session
SELECT orderyear, qty FROM dbo.#MyOrderTotalsByYear;

-- cleanup from the original session
DROP TABLE IF EXISTS #MyOrderTotalsByYear;

-- Global Temporary Tables
CREATE TABLE ##Globals
(
  id  sysname     NOT NULL PRIMARY KEY,
  val SQL_VARIANT NOT NULL
);

-- Run from any session
INSERT INTO ##Globals(id, val) VALUES(N'i', CAST(10 AS INT));

-- Run from any session
SELECT val FROM ##Globals WHERE id = N'i';

-- Run from any session
DROP TABLE IF EXISTS ##Globals;
GO

-- Table Variables
DECLARE @MyOrderTotalsByYear TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT Cur.orderyear, Cur.qty AS curyearqty, Prv.qty AS prvyearqty
FROM @MyOrderTotalsByYear AS Cur
  LEFT OUTER JOIN @MyOrderTotalsByYear AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
GO

-- with the LAG function
SELECT
  YEAR(O.orderdate) AS orderyear,
  SUM(OD.qty) AS curyearqty,
  LAG(SUM(OD.qty)) OVER(ORDER BY YEAR(orderdate)) AS prvyearqty
FROM Sales.Orders AS O
  INNER JOIN Sales.OrderDetails AS OD
    ON OD.orderid = O.orderid
GROUP BY YEAR(orderdate);
GO

-- Table Types
DROP TYPE IF EXISTS dbo.OrderTotalsByYear;

CREATE TYPE dbo.OrderTotalsByYear AS TABLE
(
  orderyear INT NOT NULL PRIMARY KEY,
  qty       INT NOT NULL
);
GO

-- Use table type
DECLARE @MyOrderTotalsByYear AS dbo.OrderTotalsByYear;

INSERT INTO @MyOrderTotalsByYear(orderyear, qty)
  SELECT
    YEAR(O.orderdate) AS orderyear,
    SUM(OD.qty) AS qty
  FROM Sales.Orders AS O
    INNER JOIN Sales.OrderDetails AS OD
      ON OD.orderid = O.orderid
  GROUP BY YEAR(orderdate);

SELECT orderyear, qty FROM @MyOrderTotalsByYear;
GO

---------------------------------------------------------------------
-- Dynamic SQL
---------------------------------------------------------------------

-- The EXEC Command

-- Simple example of EXEC
DECLARE @sql AS VARCHAR(100);
SET @sql = 'PRINT ''This message was printed by a dynamic SQL batch.'';';
EXEC(@sql);
GO

-- The sp_executesql Stored Procedure

-- Simple example using sp_executesql
DECLARE @sql AS NVARCHAR(100);

SET @sql = N'SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderid = @orderid;';

EXEC sys.sp_executesql
  @stmt = @sql,
  @params = N'@orderid AS INT',
  @orderid = 10248;
GO

---------------------------------------------------------------------
-- Using PIVOT with Dynamic SQL
---------------------------------------------------------------------

-- Static PIVOT
SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
      FROM Sales.Orders) AS D
  PIVOT(SUM(freight) FOR orderyear IN([2020],[2021],[2022])) AS P;

-- Dynamic PIVOT
DECLARE @sql AS NVARCHAR(1000) = N'SELECT *
FROM (SELECT shipperid, YEAR(orderdate) AS orderyear, freight
      FROM Sales.Orders) AS D
  PIVOT(SUM(freight) FOR orderyear IN('

  + (SELECT STRING_AGG(QUOTENAME(orderyear), N',') WITHIN GROUP(ORDER BY orderyear)
     FROM (SELECT DISTINCT(YEAR(orderdate)) AS orderyear FROM Sales.Orders) AS D)

  + N')) AS P;';

EXEC sys.sp_executesql @stmt = @sql;
GO

---------------------------------------------------------------------
-- Routines
---------------------------------------------------------------------

---------------------------------------------------------------------
-- User Defined Functions
---------------------------------------------------------------------

CREATE OR ALTER FUNCTION dbo.GetAge
(
  @birthdate AS DATE,
  @eventdate AS DATE
)
RETURNS INT
AS
BEGIN
  RETURN
    DATEDIFF(year, @birthdate, @eventdate)
    - CASE WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
              < 100 * MONTH(@birthdate) + DAY(@birthdate)
           THEN 1 ELSE 0
      END;
END;
GO

-- Test function
SELECT
  empid, firstname, lastname, birthdate,
  dbo.GetAge(birthdate, SYSDATETIME()) AS age
FROM HR.Employees;
GO

---------------------------------------------------------------------
-- Stored Procedures
---------------------------------------------------------------------

-- Using a Stored Procedure
CREATE OR ALTER PROC Sales.GetCustomerOrders
  @custid   AS INT,
  @fromdate AS DATETIME = '19000101',
  @todate   AS DATETIME = '99991231',
  @numrows  AS INT OUTPUT
AS
SET NOCOUNT ON;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;

SET @numrows = @@rowcount;
GO

DECLARE @rc AS INT;

EXEC Sales.GetCustomerOrders
  @custid   = 1, -- Also try with 100
  @fromdate = '20210101',
  @todate   = '20220101',
  @numrows  = @rc OUTPUT;

SELECT @rc AS numrows;
GO

---------------------------------------------------------------------
-- Triggers
---------------------------------------------------------------------

-- Example for a DML audit trigger
DROP TABLE IF EXISTS dbo.T1_Audit, dbo.T1;

CREATE TABLE dbo.T1
(
  keycol  INT         NOT NULL PRIMARY KEY,
  datacol VARCHAR(10) NOT NULL
);

CREATE TABLE dbo.T1_Audit
(
  audit_lsn  INT          NOT NULL IDENTITY PRIMARY KEY,
  dt         DATETIME2(3) NOT NULL DEFAULT(SYSDATETIME()),
  login_name sysname      NOT NULL DEFAULT(ORIGINAL_LOGIN()),
  keycol     INT          NOT NULL,
  datacol    VARCHAR(10)  NOT NULL
);
GO

CREATE OR ALTER TRIGGER trg_T1_insert_audit ON dbo.T1 AFTER INSERT
AS
SET NOCOUNT ON;

INSERT INTO dbo.T1_Audit(keycol, datacol)
  SELECT keycol, datacol FROM inserted;
GO

INSERT INTO dbo.T1(keycol, datacol) VALUES(10, 'a');
INSERT INTO dbo.T1(keycol, datacol) VALUES(30, 'x');
INSERT INTO dbo.T1(keycol, datacol) VALUES(20, 'g');

SELECT audit_lsn, dt, login_name, keycol, datacol
FROM dbo.T1_Audit;
GO

-- cleanup
DROP TABLE IF EXISTS dbo.T1_Audit, dbo.T1;

-- Example for a DDL audit trigger

-- Creation Script for AuditDDLEvents Table and trg_audit_ddl_events Trigger
DROP TABLE IF EXISTS dbo.AuditDDLEvents;

CREATE TABLE dbo.AuditDDLEvents
(
  audit_lsn        INT          NOT NULL IDENTITY,
  posttime         DATETIME2(3) NOT NULL,
  eventtype        sysname      NOT NULL,
  loginname        sysname      NOT NULL,
  schemaname       sysname      NOT NULL,
  objectname       sysname      NOT NULL,
  targetobjectname sysname      NULL,
  eventdata        XML          NOT NULL,
  CONSTRAINT PK_AuditDDLEvents PRIMARY KEY(audit_lsn)
);
GO

CREATE OR ALTER TRIGGER trg_audit_ddl_events
  ON DATABASE FOR DDL_DATABASE_LEVEL_EVENTS
AS
SET NOCOUNT ON;

DECLARE @eventdata AS XML = EVENTDATA();

INSERT INTO dbo.AuditDDLEvents(
  posttime, eventtype, loginname, schemaname, 
  objectname, targetobjectname, eventdata)
  VALUES(
    @eventdata.value('(/EVENT_INSTANCE/PostTime)[1]',         'VARCHAR(23)'),
    @eventdata.value('(/EVENT_INSTANCE/EventType)[1]',        'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/LoginName)[1]',        'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/SchemaName)[1]',       'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/ObjectName)[1]',       'sysname'),
    @eventdata.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'sysname'),
    @eventdata);
GO

-- Test trigger trg_audit_ddl_events
CREATE TABLE dbo.T1(col1 INT NOT NULL PRIMARY KEY);
ALTER TABLE dbo.T1 ADD col2 INT NULL;
ALTER TABLE dbo.T1 ALTER COLUMN col2 INT NOT NULL;
CREATE NONCLUSTERED INDEX idx1 ON dbo.T1(col2);
GO

SELECT * FROM dbo.AuditDDLEvents;
GO

-- Cleanup
DROP TRIGGER IF EXISTS trg_audit_ddl_events ON DATABASE;
DROP TABLE IF EXISTS dbo.AuditDDLEvents, dbo.T1;
GO

---------------------------------------------------------------------
-- Error Handling
---------------------------------------------------------------------

-- Simple example
BEGIN TRY
  PRINT 10/2;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH;
GO

BEGIN TRY
  PRINT 10/0;
  PRINT 'No error';
END TRY
BEGIN CATCH
  PRINT 'Error';
END CATCH;
GO

-- Script to create Employees table in the current database
DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid   INT         NOT NULL,
  empname VARCHAR(25) NOT NULL,
  mgrid   INT         NULL,
  CONSTRAINT PK_Employees PRIMARY KEY(empid),
  CONSTRAINT CHK_Employees_empid CHECK(empid > 0),
  CONSTRAINT FK_Employees_Employees
    FOREIGN KEY(mgrid) REFERENCES dbo.Employees(empid)
);
GO

-- Detailed Example
BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);
  -- Also try with empid = 0, 'A', NULL

END TRY
BEGIN CATCH

  IF ERROR_NUMBER() = 2627
  BEGIN
    PRINT 'Handling PK violation...';
  END;
  ELSE IF ERROR_NUMBER() = 547
  BEGIN
    PRINT 'Handling CHECK/FK constraint violation...';
  END;
  ELSE IF ERROR_NUMBER() = 515
  BEGIN
    PRINT 'Handling NULL violation...';
  END;
  ELSE IF ERROR_NUMBER() = 245
  BEGIN
    PRINT 'Handling conversion error...';
  END;
  ELSE
  BEGIN
    PRINT 'Re-throwing error...';
    THROW;
  END;

  PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
  PRINT 'Error Message : ' + ERROR_MESSAGE();
  PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
  PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
  PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
  PRINT 'Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
 
END CATCH;
GO

-- Encapsulating Reusable Code
CREATE OR ALTER PROC dbo.ErrInsertHandler
AS
SET NOCOUNT ON;

IF ERROR_NUMBER() = 2627
BEGIN
  PRINT 'Handling PK violation...';
END;
ELSE IF ERROR_NUMBER() = 547
BEGIN
  PRINT 'Handling CHECK/FK constraint violation...';
END;
ELSE IF ERROR_NUMBER() = 515
BEGIN
  PRINT 'Handling NULL violation...';
END;
ELSE IF ERROR_NUMBER() = 245
BEGIN
  PRINT 'Handling conversion error...';
END;

PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
PRINT 'Error Message : ' + ERROR_MESSAGE();
PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR(10));
PRINT 'Error State   : ' + CAST(ERROR_STATE() AS VARCHAR(10));
PRINT 'Error Line    : ' + CAST(ERROR_LINE() AS VARCHAR(10));
PRINT 'Error Proc    : ' + COALESCE(ERROR_PROCEDURE(), 'Not within proc');
GO

-- Calling Proc in CATCH Block
BEGIN TRY

  INSERT INTO dbo.Employees(empid, empname, mgrid)
    VALUES(1, 'Emp1', NULL);

END TRY
BEGIN CATCH

  IF ERROR_NUMBER() IN (2627, 547, 515, 245)
    EXEC dbo.ErrInsertHandler;
  ELSE
    THROW;
  
END CATCH;
