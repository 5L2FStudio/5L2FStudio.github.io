--查詢各科成績最高分、最低分和平均分：

SELECT CId , Max(score) max_score, MIN(score) min_score, AVG(score) avg_score
FROM SC a
GROUP BY CId
