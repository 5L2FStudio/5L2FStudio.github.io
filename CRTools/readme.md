# 安裝 Crystal Report 
可連結到 Crysyal Report 官方網站進行下載 [網址](https://www.crystalreports.com/download/)

# 安裝 Crystal Report Runtime
一般來說只要安裝最新版本, 而搭配所安裝的 CR 去使用 32 位元或 64 位元

Version       | Developer Edition | 32Bit | 64Bit
--------------|:-----------------:| -----:|------------------------
13.0.28       |	[SP 28](https://origin.softwaredownloads.sap.com/public/file/0020000001263622020)|[32bit](https://origin.softwaredownloads.sap.com/public/file/0020000001263572020)|[64bit](https://origin.softwaredownloads.sap.com/public/file/0020000001263562020)
13.0.27       |	[SP 27](https://origin.softwaredownloads.sap.com/public/file/0020000000543482020)|[32bit](https://origin.softwaredownloads.sap.com/public/file/0020000000543412020)|[64bit](https://origin.softwaredownloads.sap.com/public/file/0020000000543422020)
13.0.26       |	[SP 26](https://origin.softwaredownloads.sap.com/public/file/0020000002112552019)|[32bit](https://origin.softwaredownloads.sap.com/public/file/0020000002112472019)|[64bit](https://origin.softwaredownloads.sap.com/public/file/0020000002112482019)

# 下載安裝程式
檔案下載網址 [CR翻譯工具](CRTools.zip) .


# 安裝環境

## 解開壓縮檔案
![壓縮目錄](001.PNG)

在目錄下會有 setup.exe , 點選該檔案來進行安裝

## 預備環境
![.Net Framework Readme](002.PNG)

如果環境下沒有 .Net framework 的情況下，則會出現該提示畫面，讓使用者可以透過線上下載的方式來進行安裝，選擇 *接受* 即可進行下載。但如果環境中已經有安裝 .Net Framework，則會自動跳到後面的安裝程式的部分

## 安裝中
![.Net Framework Install](003.PNG)

此部分則視網路狀況和主機效能，大約會花 3-5 分鐘進行下載。

## 安裝完畢
![Post Install](004.PNG)

安裝好 .Net Framework 之後，則會提示使用者重新開機


# 安裝程式

## 執行安裝作業
![Install](010.PNG)

如果之前已經安裝好 .Net Framework 的話，則執行安裝程式 setup.exe 之後，就會進入此畫面。但如果沒有安裝 .Net Framework 的話，則經過前面 *安裝環境* 的步驟，再重開機之後則繼續點選 setup.exe 來進行安裝程式。看到畫面之後，選擇 *安裝* 即可。

## 啟動作業
![Install](011.PNG)

安裝好之後，則會自動帶起 CR翻譯工具，此時可以選擇右上方的 X 按鈕關閉作業

## 設定啟動捷徑
![Install](012.PNG)

關閉作業之後，點選 Windows 左下方 Windows 的圖示，則會出現選單。此時可以選擇剛剛安裝的 TransTool 的工具，按下滑鼠右鍵，選擇將作業 *釘選到工作列* ，這樣下次要找作業就會比較方便一點了。


# 備註

## 資料來源如果是文字檔案，則將 查詢文字 和 替換文字 之間，使用 *,* 符號來進行分隔
