--檢索“ 01 ”課程分數小於 60，按分數降序排列的學生資訊

SELECT b.* 
FROM SC a
JOIN Student b ON a.SId = b.SId
where a.CId = '01' AND a.score < 60
ORDER BY a.score desc
