--按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績

--方法一使用 Windows Function
SELECT a.* , AVG(score) OVER ( PARTITION BY SId ) avg_score
FROM SC a
ORDER BY avg_score desc, a.SId , a.CId


--方法二 使用 CTE 分開計算平均值和顯示所有分數
;with x AS
(
SELECT a.SId, AVG(score) avg_score
FROM SC a
GROUP BY a.SId
)
SELECT a.CId , a.score , x.avg_score FROM SC a
JOIN x ON a.SId = x.SId
ORDER BY x.avg_score DESC, a.SId , a.CId
