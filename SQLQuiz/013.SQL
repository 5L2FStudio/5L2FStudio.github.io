-- 查詢沒學過「張三」老師講授的任一門課程的學生姓名


WITH x AS
(
	SELECT c.SId FROM [Teacher] a 
	JOIN [Course] b ON a.TId = b.TId and a.Tname = '張三'
	JOIN [SC] c ON b.CId = c.CId
)
SELECT y.* 
FROM Student y 
WHERE y.SId not in ( select SId FROM x) 
