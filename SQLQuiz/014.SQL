-- 查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績

-- 方法一
WITH x AS
(
SELECT SId, COUNT(*) scorecount FROM SC
WHERE score < 60
GROUP BY SId
HAVING COUNT(*) > 1
)
SELECT b.SId, c.Sname, AVG(score) avg_score 
FROM x
JOIN SC b ON x.SId = b.SId
JOIN Student c ON b.SId= c.SId
GROUP BY b.SId, c.Sname

-- 方法二
SELECT a.SId, b.Sname, avg(score) avg_score
FROM SC a
JOIN Student b ON a.SId = b.SId
GROUP BY a.SId, b.Sname
HAVING COUNT( IIF(score<60,1,NULL) ) > 1
