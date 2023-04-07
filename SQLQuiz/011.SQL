-- 查詢至少有一門課與學號為“ 01 ”的同學所學相同的同學的資訊

SELECT DISTINCT a.* FROM [Student] a
JOIN [SC] b ON a.SId = b.SId and b.CId in ( SELECT CId FROM SC where SId = '01' )
WHERE a.SId <> '01'
