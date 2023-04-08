-- 查詢平均成績大於等於85的所有學生的學號、姓名和平均成績

SELECT a.SId, b.Sname, AVG(score) score 
FROM SC a
JOIN Student b ON a.SId = b.SId
GROUP BY a.SId, b.Sname
HAVING AVG(score) > 85
