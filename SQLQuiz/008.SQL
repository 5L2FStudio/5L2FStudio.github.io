--查詢「李」姓老師的數量

select COUNT(*) countLee
from Teacher a
where a.Tname LIKE N'李%'

-- 雖然使用 Having , 但 SQL 最佳化會變成跟前面 SQL 相同的執行計畫
select COUNT(*) countLee
from Teacher a
group by LEFT(a.Tname,1)
having LEFT(a.Tname,1) = '李'
