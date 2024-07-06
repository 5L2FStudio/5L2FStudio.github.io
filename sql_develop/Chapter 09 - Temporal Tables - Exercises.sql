---------------------------------------------------------------------
-- T-SQL Fundamentals Fourth Edition
-- Chapter 09 - Temporal Tables
-- Exercises
-- © Itzik Ben-Gan 
---------------------------------------------------------------------

-- 1
-- In this exercise you create a system-versioned temporal table and
-- identify it in SSMS.

-- 1-1
-- Create a system-versioned temporal table called Departments with
-- an associated history table called DepartmentsHistory in the
-- database TSQLV6. The table should have the following columns:
-- deptid INT, deptname VARCHAR(25) and mgrid INT, all disallowing NULLs.
-- Also include columns called validfrom and validto that define the
-- validity period of the row. Define those with precision zero (1 second)
-- and make them hidden. Define a history retention policy of six months.

-- 1-2
-- Browse the object tree in Object Explorer in SSMS and identify the
-- Departments table and its associated history table.

-- 2
-- In this exercise you will modify data in the table Departments.
-- Make a note of the point in time in UTC when you submit each
-- statement, and mark those as P1, P2, and so on. You can do so by
-- invoking the SYSUTCDATETIME function in the same batch that you
-- submit the modification. Another option is to query the Departments
-- table and its associated history table and to obtain the point in time
-- from the validfrom and validto columns.

-- 2-1
-- Insert four rows to the table Departments with the following details
-- and make a note of the time when you apply this insert (call it P1).
-- deptid: 1, deptname: HR, mgrid: 7
-- deptid: 2, deptname: IT, mgrid: 5
-- deptid: 3, deptname: Sales, mgrid: 11
-- deptid: 4, deptname: Marketing, mgrid: 13

-- 2-2
-- In one transaction, update the name of department 3 to Sales and Marketing
-- and delete department 4. Call the point in time when the transaction starts P2.

-- 2-3
-- Update the manager ID of department 3 to 13. Call the point in time
-- when you apply this update P3.

-- 3
-- In this exercise you will query data from the table Departments.

-- 3-1
-- Query the current state of the table Departments.

-- Desired output:
deptid      deptname                  mgrid
----------- ------------------------- -----------
1           HR                        7
2           IT                        5
3           Sales and Marketing       13

-- 3-2
-- Query the state of the table Departments at a point in time after P2
-- and before P3.

-- Desired output:
deptid      deptname                  mgrid
----------- ------------------------- -----------
1           HR                        7
2           IT                        5
3           Sales and Marketing       11

-- 3-3
-- Query the state of the table Departments in the period between P2 and P3.
-- Be explicit about the column names in the SELECT list,
-- and include the validfrom and validto columns).

-- Desired output (with validfrom and validto reflecting your modification times):
deptid  deptname             mgrid  validfrom            validto
------- -------------------- ------ -------------------- --------------------
1       HR                   7      2022-02-18 10:26:07  9999-12-31 23:59:59
2       IT                   5      2022-02-18 10:26:07  9999-12-31 23:59:59
3       Sales and Marketing  13     2022-02-18 10:30:40  9999-12-31 23:59:59
3       Sales and Marketing  11     2022-02-18 10:28:27  2022-02-18 10:30:40

-- 4
-- Drop the table Departments and its associated history table.
