--查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績

SELECT a.SId,a.Sname,AVG(score) avg_score FROM Student a
INNER JOIN SC b ON a.SId = b.SId 
GROUP BY a.SId,a.Sname
HAVING AVG(score)>=60
