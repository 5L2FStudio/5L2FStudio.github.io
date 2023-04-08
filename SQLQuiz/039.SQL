--成績不重複，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績

SELECT d.* , a.score
FROM SC a
JOIN Course b ON a.CId = b.CId
JOIN Teacher c ON b.TId = c.TId AND c.Tname = N'張三'
JOIN Student d ON a.SId = d.SId
ORDER BY a.score desc
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
