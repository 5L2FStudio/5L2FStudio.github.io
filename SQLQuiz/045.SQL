--查詢選修了全部課程的學生資訊
-- 方法一
WITH a AS
(
	SELECT SId FROM SC
	GROUP BY SId
	HAVING STRING_AGG(CId,',') = ( SELECT STRING_AGG(CId,',') FROM Course )
)
SELECT * FROM a
JOIN Student b ON a.SId = b.SId


-- 方法二
SELECT * FROM Student x
WHERE x.SId NOT IN (
	SELECT a.SId 
	FROM Student a
	CROSS JOIN Course b 
	LEFT JOIN SC c ON a.SId = c.SId AND b.CId = c.CId
	WHERE c.score IS NULL )
