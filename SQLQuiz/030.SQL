--查詢 1990 年出生的學生名單

--方法一 : 符合 SARG
SELECT *
FROM Student 
WHERE Sage BETWEEN '1990/01/01' AND '1990/12/31'

--方法二 : 較常見做法, 但不符合 SARG
SELECT *
FROM Student 
WHERE Year(Sage) = 1990

