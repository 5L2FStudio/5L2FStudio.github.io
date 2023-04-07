--查詢男生、女生人數

SELECT Ssex, COUNT(*) number
FROM Student 
GROUP BY Ssex
