-- 查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績

SELECT a.SId, b.Sname, avg(score) avg_score
FROM SC a
JOIN Student b ON a.SId = b.SId
GROUP BY a.SId, b.Sname
HAVING COUNT( IIF(score<60,1,NULL) ) > 1
