--以如下形式顯示：課程 ID，課程 name，最高分，最低分，平均分，及格率，中等率，優良率，優秀率
--及格為>=60，中等為：70-80，優良為：80-90，優秀為：>=90

SELECT a.CId, b.Cname, Max(score) max_score, MIN(score) min_score, AVG(score) avg_score
,avg(IIF(score>=60,1.0,0)) 及格率
,avg(IIF(score>=70,1.0,0)) 中等率
,avg(IIF(score>=80,1.0,0)) 優良率
,avg(IIF(score>=90,1.0,0)) 優秀率
FROM [SC] a
JOIN [Course] b ON a.CId=b.CId
GROUP BY a.CId, b.Cname
