--查詢學過「張三」老師授課的同學的資訊

SELECT DISTINCT d.* FROM [Teacher] a
JOIN [Course] b ON a.TId = b.TId
JOIN [SC] c ON b.CId = c.CId
JOIN [Student] d ON c.SId = d.SId
WHERE a.Tname = N'張三'
