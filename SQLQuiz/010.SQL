-- 查詢沒有學全所有課程的同學的資訊

SELECT DISTINCT a.* FROM [Student] a
CROSS JOIN [Course] b 
LEFT JOIN [SC] c ON a.SId = c.SId and b.CId = c.CId
WHERE c.score IS NULL
