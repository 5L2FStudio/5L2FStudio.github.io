--查詢在 SC 表存在成績的學生資訊

--使用 IN
SELECT a.* FROM Student a
WHERE a.SId IN ( Select SId FROM SC )

--使用 JOIN 搭配 DISTINCT
select distinct a.*
from Student a
join SC b ON a.SId = b.SId

--使用 SubQuery 搭配 EXISTS
select a.*
from Student a
where EXISTS ( select SId from SC b where b.SId = a.SId )

--使用 GROUP BY 搭配 CTE
;with a as
(
	select SId FROM SC GROUP BY SId
)
select b.* from a
join Student b ON a.SId = b.SId
