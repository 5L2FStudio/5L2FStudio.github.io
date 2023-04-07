--查詢學生的總成績，並進行排名，總分重複時不保留名次空缺
with x as
(
	SELECT a.SId, SUM(b.score) sum_score
	FROM [Student] a
	JOIN [SC] b ON a.SId = b.SId
	GROUP BY a.SId
)
select *, DENSE_RANK() OVER ( order by sum_score desc ) 
from x
