--查詢同時存在“ 01 ”課程和“ 02 ”課程的情況

SELECT a.* FROM Student a
JOIN SC b ON a.SId = b.SId AND b.CId = '01'
JOIN SC c ON a.SId = c.SId AND c.CId = '02'
