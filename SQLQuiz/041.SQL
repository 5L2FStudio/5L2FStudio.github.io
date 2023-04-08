-- 查詢不同課程成績相同的學生的學生編號、課程編號、學生成績

WITH a AS
(
	SELECT SId
	FROM SC
	GROUP BY SId
	HAVING COUNT( distinct score ) = 1
)
SELECT b.* FROM a
JOIN SC b ON a.SId = b.SId
