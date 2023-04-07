--查詢存在“ 01 ”課程但可能不存在“ 02 ”課程的情況（不存在時顯示為 null ）

SELECT * FROM Student a
INNER JOIN SC b ON a.SId = b.SId AND b.CId = '01'
LEFT  JOIN SC c ON a.SId = c.SId AND c.CId = '02'
where c.SId IS NULL
