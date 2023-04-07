# 50道SQL練習題
## 測試資料
```SQL
CREATE TABLE Student (
SId VARCHAR(10),
Sname VARCHAR(10),
Sage DATETIME,
Ssex VARCHAR(10)
);
GO
INSERT INTO Student VALUES('01', '趙雷', '1990-01-01', '男');
INSERT INTO Student VALUES('02', '錢電', '1990-12-21', '男');
INSERT INTO Student VALUES('03', '孫風', '1990-12-20', '男');
INSERT INTO Student VALUES('04', '李雲', '1990-12-06', '男');
INSERT INTO Student VALUES('05', '周梅', '1991-12-01', '女');
INSERT INTO Student VALUES('06', '吳蘭', '1992-01-01', '女');
INSERT INTO Student VALUES('07', '鄭竹', '1989-01-01', '女');
INSERT INTO Student VALUES('09', '張三', '2017-12-20', '女');
INSERT INTO Student VALUES('10', '李四', '2017-12-25', '女');
INSERT INTO Student VALUES('11', '李四', '2012-06-06', '女');
INSERT INTO Student VALUES('12', '趙六', '2013-06-13', '女');
INSERT INTO Student VALUES('13', '孫七', '2014-06-01', '女');
```

```SQL
CREATE TABLE Course (
CId VARCHAR(10),
Cname NVARCHAR(10),
TId VARCHAR(10)
);
GO
INSERT INTO Course VALUES('01', '國語', '02');
INSERT INTO Course VALUES('02', '數學', '01');
INSERT INTO Course VALUES('03', '英文', '03');
```

```SQL
CREATE TABLE Teacher (
TId VARCHAR(10),
Tname VARCHAR(10)
);
GO
INSERT INTO Teacher VALUES('01', '張三');
INSERT INTO Teacher VALUES('02', '李四');
INSERT INTO Teacher VALUES('03', '王五');
```

```SQL
CREATE TABLE SC (
SId VARCHAR(10),
CId VARCHAR(10),
score DECIMAL(18,1)
);
GO
INSERT INTO SC VALUES('01', '01', 80);
INSERT INTO SC VALUES('01', '02', 90);
INSERT INTO SC VALUES('01', '03', 99);
INSERT INTO SC VALUES('02', '01', 70);
INSERT INTO SC VALUES('02', '02', 60);
INSERT INTO SC VALUES('02', '03', 80);
INSERT INTO SC VALUES('03', '01', 80);
INSERT INTO SC VALUES('03', '02', 80);
INSERT INTO SC VALUES('03', '03', 80);
INSERT INTO SC VALUES('04', '01', 50);
INSERT INTO SC VALUES('04', '02', 30);
INSERT INTO SC VALUES('04', '03', 20);
INSERT INTO SC VALUES('05', '01', 76);
INSERT INTO SC VALUES('05', '02', 87);
INSERT INTO SC VALUES('06', '01', 31);
INSERT INTO SC VALUES('06', '03', 34);
INSERT INTO SC VALUES('07', '02', 89);
INSERT INTO SC VALUES('07', '03', 98);
```

## 題目

* 查詢“ 01 ”課程比“ 02 ”課程成績高的學生的信息及課程分數

  [001.SQL](001.SQL) 

* 查詢同時存在“ 01 ”課程和“ 02 ”課程的情況

  [002.SQL](002.SQL) 
  
* 查詢存在“ 01 ”課程但可能不存在“ 02 ”課程的情況（不存在時顯示為 null ）

  [003.SQL](003.SQL) 

* 查詢不存在“ 01 ”課程但存在“ 02 ”課程的情況

  [004.SQL](004.SQL) 
  
* 查詢平均成績大於等於 60 分的同學的學生編號和學生姓名和平均成績

  [005.SQL](005.SQL) 

* 查詢在 SC 表存在成績的學生資訊

  [006.SQL](006.SQL) 

* 查詢所有同學的學生編號、學生姓名、選課總數、所有課程的總成績（沒成績的顯示為 null ）

  [007.SQL](007.SQL) 

* 查詢「李」姓老師的數量

  [008.SQL](008.SQL) 
  
* 查詢學過「張三」老師授課的同學的資訊

  [009.SQL](009.SQL) 
  
* 查詢沒有學全所有課程的同學的資訊

  [010.SQL](010.SQL) 

---

* 查詢至少有一門課與學號為“ 01 ”的同學所學相同的同學的資訊

  [011.SQL](011.SQL) 
  
* 查詢和“ 01 ”號的同學學習的課程 完全相同的其他同學的資訊

  [012.SQL](012.SQL) 
  
* 查詢沒學過「張三」老師講授的任一門課程的學生姓名

  [013.SQL](013.SQL) 

* 查詢兩門及其以上不及格課程的同學的學號，姓名及其平均成績

  [014.SQL](014.SQL) 
  
* 檢索“ 01 ”課程分數小於 60，按分數降序排列的學生資訊

  [015.SQL](015.SQL) 
  
* 按平均成績從高到低顯示所有學生的所有課程的成績以及平均成績

  [016.SQL](016.SQL) 
  
* 查詢各科成績最高分、最低分和平均分：

  [017.SQL](017.SQL) 

* 以如下形式顯示：課程 ID，課程 name，最高分，最低分，平均分，及格率，中等率，優良率，優秀率
及格為>=60，中等為：70-80，優良為：80-90，優秀為：>=90

  [018.SQL](018.SQL) 

* 要求輸出課程號和選修人數，查詢結果按人數降序排列，若人數相同，按課程號升序排列

  [019.SQL](019.SQL) 

* 按各科成績進行排序，並顯示排名， Score 重複時保留名次空缺

  [020.SQL](020.SQL) 

---

* 按各科成績進行排序，並顯示排名， Score 重複時合併名次

  [021.SQL](021.SQL) 
  
* 查詢學生的總成績，並進行排名，總分重複時保留名次空缺

  [022.SQL](022.SQL) 

* 查詢學生的總成績，並進行排名，總分重複時不保留名次空缺

  [023.SQL](023.SQL) 

* 統計各科成績各分數段人數：課程編號，課程名稱，[100-85]，[85-70]，[70-60]，[60-0] 及所佔百分比

  [024.SQL](024.SQL) 
 
* 查詢各科成績前三名的記錄

  [025.SQL](025.SQL) 
  
* 查詢出只選修兩門課程的學生學號和姓名

  [026.SQL](026.SQL) 
  
* 查詢男生、女生人數

  [027.SQL](027.SQL) 

* 查詢名字中含有「風」字的學生資訊

  [028.SQL](028.SQL) 
  
* 查詢同名同性學生名單，並統計同名人數

  [029.SQL](029.SQL) 

* 查詢 1990 年出生的學生名單

  [030.SQL](030.SQL) 
  
---  
  
* 查詢每門課程的平均成績，結果按平均成績降序排列，平均成績相同時，按課程編號升序排列

* 查詢平均成績大於等於85的所有學生的學號、姓名和平均成績

* 查詢課程名稱為「數學」，且分數低於 60 的學生姓名和分數

* 查詢所有學生的課程及分數情況（存在學生沒成績，沒選課的情況）

* 查詢任何一門課程成績在70分以上的姓名、課程名稱和分數

* 查詢不及格的課程

* 查詢課程編號為 01 且課程成績在 80 分以上的學生的學號和姓名

* 求每門課程的學生人數

* 成績不重複，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績

* 成績有重複的情況下，查詢選修「張三」老師所授課程的學生中，成績最高的學生資訊及其成績

* 查詢不同課程成績相同的學生的學生編號、課程編號、學生成績

* 查詢每門功成績最好的前兩名

* 統計每門課程的學生選修人數（超過 5 人的課程才統計）。

* 檢索至少選修兩門課程的學生學號

* 查詢選修了全部課程的學生資訊

* 查詢各學生的年齡，只按年份來算

* 按照出生日期來算，當前月日 < 出生年月的月日則，年齡減一

* 查詢本周過生日的學生

* 查詢下周過生日的學生

* 查詢本月過生日的學生

* 查詢下月過生日的學生
