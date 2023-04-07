--查詢所有同學的學生編號、學生姓名、選課總數、所有課程的總成績（沒成績的顯示為 null ）

SELECT a.SId,a.Sname,COUNT(CId) count_sid, sum(score) sum_score 
FROM Student a
LEFT JOIN SC b ON a.SId = b.SId
GROUP BY a.SId,a.Sname
