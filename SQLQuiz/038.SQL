--求每門課程的學生人數

SELECT a.CId, b.Cname, COUNT(a.SId ) number
FROM SC a
JOIN Course b ON a.CId = b.CId
GROUP BY a.CId,b.Cname
