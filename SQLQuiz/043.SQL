-- 統計每門課程的學生選修人數（超過 5 人的課程才統計）
SELECT a.CId, b.Cname, COUNT(SId) 
FROM SC a
JOIN Course b ON a.CId = b.CId
GROUP BY a.CId, b.Cname
HAVING COUNT(SId)  > 5
