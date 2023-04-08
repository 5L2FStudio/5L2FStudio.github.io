--查詢課程編號為 01 且課程成績在 80 分以上的學生的學號和姓名

SELECT b.SId, b.Sname 
FROM SC a
JOIN Student b ON a.SId = b.SId
WHERE a.score >= 80 AND a.CId = '01'
