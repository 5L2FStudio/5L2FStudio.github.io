--要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列

SELECT a.CId, COUNT(SId) [選修人數]
FROM [SC] a
GROUP BY a.CId
ORDER BY [選修人數] desc , a.CId
