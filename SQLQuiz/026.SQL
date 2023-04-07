--查詢出只選修兩門課程的學生學號和姓名

SELECT a.SId, b.Sname
FROM SC a
JOIN Student b ON a.SId = b.SId
GROUP BY a.SId, b.Sname
HAVING COUNT(CId) = 2
