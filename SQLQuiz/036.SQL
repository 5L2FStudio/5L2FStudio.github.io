--查詢不及格的課程

SELECT c.Sname, b.Cname , a.score
FROM SC a
JOIN Course b ON a.CId = b.CId
JOIN Student c ON a.SId = c.SId
WHERE score < 60
