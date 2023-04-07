--查詢同名同性學生名單，並統計同名人數

SELECT Sname,COUNT(SId) number
FROM Student 
GROUP BY Sname
HAVING COUNT(SId) > 1
