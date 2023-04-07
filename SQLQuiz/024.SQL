--統計各科成績各分數段人數：課程編號，課程名稱，[100-85]，[85-70]，[70-60]，[60-0] 及所佔百分比

SELECT 
	a.CId , b.Cname
	,SUM( IIF( score >=85 , 1 , 0 ) ) countA, AVG( IIF( score > 85 , 1.0 , 0 ) ) percentA
	,SUM( IIF( score >=70 AND score < 85, 1 , 0 ) ) countB, AVG( IIF( score >=70 AND score < 85, 1.0 , 0 ) ) percentB
	,SUM( IIF( score >=60 AND score < 70, 1 , 0 ) ) countC, AVG( IIF( score >=60 AND score < 70, 1.0 , 0 ) ) percentC
	,SUM( IIF( score >= 0 AND score < 60, 1 , 0 ) ) countD, AVG( IIF( score >= 0 AND score < 60, 1.0 , 0 ) ) percentD
FROM SC a
JOIN [Course] b ON a.CId = b.CId
GROUP BY a.CId , b.Cname



