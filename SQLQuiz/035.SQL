--查詢任何一門課程成績在70分以上的姓名、課程名稱和分數

SELECT c.Sname, b.Cname , a.score
FROM SC a
JOIN Course b ON a.CId = b.CId
JOIN Student c ON a.SId = c.SId
WHERE score > 70
