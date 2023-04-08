-- 查詢所有學生的課程及分數情況（存在學生沒成績，沒選課的情況）

SELECT *
FROM Student a
CROSS JOIN Course b
LEFT  JOIN SC c ON a.SId = c.SId and b.CId = c.CId
