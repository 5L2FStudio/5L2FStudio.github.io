-- 查詢沒有學全所有課程的同學的資訊

-- 方法一
SELECT DISTINCT a.* FROM [Student] a
CROSS JOIN [Course] b 
LEFT JOIN [SC] c ON a.SId = c.SId and b.CId = c.CId
WHERE c.score IS NULL

-- 方法二
SELECT b.SId, b.Sname, b.Ssex, b.Sage, COUNT(score) 
FROM SC a
RIGHT JOIN Student b ON a.SId = b.SId
GROUP BY b.SId, b.Sname, b.Ssex, b.Sage
HAVING COUNT(score) < 3

-- 方法三
SELECT * FROM Student a
WHERE a.SId not in ( SELECT SId FROM SC GROUP BY SId HAVING COUNT(score) = 3 )
