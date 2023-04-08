-- 查詢課程名稱為「數學」，且分數低於 60 的學生姓名和分數

SELECT b.Sname, a.score 
FROM SC a
JOIN Student b ON a.SId = b.SId
JOIN Course c ON c.Cname = N'數學' and a.CId = c.CId
WHERE a.score < 60
