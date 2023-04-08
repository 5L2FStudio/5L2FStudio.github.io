--檢索至少選修兩門課程的學生學號

SELECT SId 
FROM SC
GROUP BY SId
HAVING COUNT(CId) > 1
