--按各科成績進行排序，並顯示排名， Score 重複時保留名次空缺

SELECT a.*, RANK() OVER ( PARTITION BY CId ORDER BY score desc ) [rank]
FROM [SC] a
