-- 查詢和“ 01 ”號的同學學習的課程 完全相同的其他同學的資訊


WITH a AS
(
	SELECT SId FROM SC where SId <>'01'
	GROUP BY SId
	HAVING STRING_AGG(CId,',') = ( SELECT STRING_AGG(CId,',') FROM SC where SId = '01' )
)
SELECT  a.* FROM a
JOIN Student b ON a.SId = b.SId
