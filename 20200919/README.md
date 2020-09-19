# SSMS 使用
![電子書](book.png)

## 參考資料
* [SQL Server Management Studio Tips and Tricks](https://blog.greglow.com/2018/04/24/free-ebook-sql-server-management-studio-tips-and-tricks/)
* [10 SSMS Tips and Tricks to boost your Productivity](https://www.sqlshack.com/10-ssms-tips-and-tricks-to-boost-your-productivity/)
* [25 SSMS Tips and Tricks to boost your Productivit](https://www.sqlsaturday.com/SessionDownload.aspx?suid=16388)

## SSMS 下載 \( Free \)
* Google "SSMS Download"
* 注意版本
* Only for Windows \( 其他作業系統可使用 Azure Data Studio \)
* Update \( zh-tw →  en-us \)


## 連線至伺服器
* 利用 **[Del]** 鍵刪除歷史清單
* 連接 Azure Storage 可**查看**Blob Container


## 檢視
* 物件總管 <kbd>F8</kbd>
* 物件總管詳細資料 <kbd>F7<kbd>
* 已註冊的伺服器 <kbd>Ctrl+Alt+G</kbd>
* 範本瀏覽器 <kbd>Ctrl+Alt+T</kbd>


## 選項
* \[環境\]→\[一般\] 色彩佈景主題 
* \[環境\]→\[字型與色彩\] 字型 Consolas → 美觀、等寬、可容易區分 0 \(zero\) 和 O \(OK\) 與 8 \(eight\) 和 B\(Bill\)
* \[文字編輯器\]→\[Transact-SQL\]→\[一般\] 行號
* \[文字編輯器\]→\[Transact-SQL\]→\[卷軸\] 垂直卷軸使用地圖模式
* \[設計師\] 警告受影響資料表
* \[SQL Server 物件總管\]→\[命令\] 


## SQL Query
* 顏色 : 綠色 → Save , 黃色 → unSave , 紅色 → Error
* IntelliSence : <kbd>Ctrl+Shift+R</kbd>
* sp_who <kbd>CTRL+1</kbd> sp_lock <kbd>CTRL+2</kbd>
* 放大縮小
* 分割視窗
* 回復
* 循環剪貼環 <kbd>Ctrl+Shift+V</kbd>
* 拖拉物件總管
* 移動欄位
* 行模式 <kbd>ALT+滑鼠右鍵</kbd>
* 隨標頭一同複製
* Expansion Snippet Type <kbd>CTRL+K</kbd><kbd>CTRL+X</kbd>
* Surround With Snippet Type <kbd>CTRL+K</kbd><kbd>CTRL+S</kbd>


## 系統管理工具 報表
* Instance 
* Database 
* 安全性 → 登入 
* 資料收集 

## 執行計畫
* 實際執行計畫 <kbd>CTRL+M</kbd>
* 預估執行計畫 <kbd>CTRL+L</kbd>
* 另存執行計畫
* 比較執行計畫


## 資料庫移轉
* BACKUP / RESTORE
* 匯出指令碼 \(大型資料庫要注意逾時\)
* BACPAC / DACPAC
