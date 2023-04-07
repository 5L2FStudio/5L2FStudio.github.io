--按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績
SELECT a.* , AVG(score) OVER ( PARTITION BY SId ) avg_score
FROM SC a
ORDER BY avg_score desc, a.SId , a.CId
