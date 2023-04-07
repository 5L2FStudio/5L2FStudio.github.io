--查詢學生的總成績，並進行排名，總分重複時保留名次空缺

SELECT a.*, DENSE_RANK() OVER ( PARTITION BY CId ORDER BY score desc ) [rank]
FROM [SC] a
