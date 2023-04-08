--查詢選修了全部課程的學生資訊

WITH a AS
(
	SELECT SId FROM SC
	GROUP BY SId
	HAVING STRING_AGG(CId,',') = ( SELECT STRING_AGG(CId,',') FROM Course )
)
SELECT * FROM a
JOIN Student b ON a.SId = b.SId
