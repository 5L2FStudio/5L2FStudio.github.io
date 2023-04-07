--查詢各科成績前三名的記錄

WITH a AS
(
SELECT 
  CId , SId, score, RANK() OVER ( PARTITION BY CId ORDER BY score desc ) [rank]
FROM SC 
)
SELECT * FROM a WHERE  [rank] < 4
