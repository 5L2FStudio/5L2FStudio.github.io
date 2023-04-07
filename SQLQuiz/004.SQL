--查詢不存在“ 01 ”課程但存在“ 02 ”課程的情況

SELECT * FROM Student a
LEFT  JOIN SC b ON a.SId = b.SId AND b.CId = '01'
INNER JOIN SC c ON a.SId = c.SId AND c.CId = '02'
where b.SId IS NULL
