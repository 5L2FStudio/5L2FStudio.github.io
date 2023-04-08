--成績有重複的情況下，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績
WITH x AS
(
SELECT d.* , a.score , RANK() OVER (ORDER BY a.score desc ) [rank]
FROM SC a
JOIN Course b ON a.CId = b.CId
JOIN Teacher c ON b.TId = c.TId AND c.Tname = N'張三'
JOIN Student d ON a.SId = d.SId
)
SELECT * FROM x where [rank] = 1
