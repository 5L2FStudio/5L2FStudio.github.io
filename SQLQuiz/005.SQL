--查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績

SELECT a.SId,a.Sname,AVG(score) avg_score 
FROM Student a
INNER JOIN SC b ON a.SId = b.SId 
GROUP BY a.SId,a.Sname
HAVING AVG(score)>=60

-- 當如果需要顯示所有學生資料時候，可改用 CTE 的寫法來協助
;with a as
(
select b.SId , AVG(score) score
from SC b
group by b.SId 
having AVG(score) >= 60
)
select c.* , a.score from a
join Student c ON a.SId = c.SId
