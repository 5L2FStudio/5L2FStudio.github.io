--查詢“ 01 ”課程比“ 02 ”課程成績高的學生的信息及課程分數

SELECT a.* FROM Student a
JOIN SC b ON a.SId = b.SId AND b.CId = '01'
JOIN SC c ON a.SId = c.SId AND c.CId = '02'
where b.score > c.score
