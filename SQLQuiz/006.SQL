--查詢在 SC 表存在成績的學生資訊

SELECT a.* FROM Student a
WHERE a.SId IN ( Select SId FROM SC )
