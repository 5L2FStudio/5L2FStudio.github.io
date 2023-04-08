-- 查詢每門功成績最好的前兩名
with a AS
(
	SELECT * , RANK() OVER ( PARTITION BY CId ORDER BY score DESC ) [rank] FROM SC 
)
SELECT CId, score, b.Sname
FROM a
JOIN Student b ON a.SId = b.SId
where [rank] < 3
ORDER BY CId, score desc
