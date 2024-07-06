---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 01 - Background to T-SQL Querying and Programming
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Creating Tables
---------------------------------------------------------------------

-- Create table Employees
USE TSQLV6;

DROP TABLE IF EXISTS dbo.Employees;

CREATE TABLE dbo.Employees
(
  empid     INT         NOT NULL,
  firstname VARCHAR(30) NOT NULL,
  lastname  VARCHAR(30) NOT NULL,
  hiredate  DATE        NOT NULL,
  mgrid     INT         NULL,
  ssn       VARCHAR(20) NOT NULL,
  salary    MONEY       NOT NULL
);

---------------------------------------------------------------------
-- Data Integrity
---------------------------------------------------------------------

-- Primary key
ALTER TABLE dbo.Employees
  ADD CONSTRAINT PK_Employees
  PRIMARY KEY(empid);

-- Unique
ALTER TABLE dbo.Employees
  ADD CONSTRAINT UNQ_Employees_ssn
  UNIQUE(ssn);

-- Unique filtered index allowing duplicate NULLs
CREATE UNIQUE INDEX idx_ssn_notnull ON dbo.Employees(ssn) WHERE ssn IS NOT NULL;

-- Table used in foreign key example
DROP TABLE IF EXISTS dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid   INT         NOT NULL,
  empid     INT         NOT NULL,
  custid    VARCHAR(10) NOT NULL,
  orderts   DATETIME2   NOT NULL,
  qty       INT         NOT NULL,
  CONSTRAINT PK_Orders
    PRIMARY KEY(orderid)
);

-- Foreign keys
ALTER TABLE dbo.Orders
  ADD CONSTRAINT FK_Orders_Employees
  FOREIGN KEY(empid)
  REFERENCES dbo.Employees(empid);

ALTER TABLE dbo.Employees
  ADD CONSTRAINT FK_Employees_Employees
  FOREIGN KEY(mgrid)
  REFERENCES dbo.Employees(empid);

-- Check
ALTER TABLE dbo.Employees
  ADD CONSTRAINT CHK_Employees_salary
  CHECK(salary > 0.00);

-- Default
ALTER TABLE dbo.Orders
  ADD CONSTRAINT DFT_Orders_orderts
  DEFAULT(SYSDATETIME()) FOR orderts;

-- Cleanup
DROP TABLE IF EXISTS dbo.Orders, dbo.Employees;