# Analytics
* Descriptive Analytics : tells you what happened in the past.
* Diagnostic Analytics : helps you understand why something happened in the past.
* Predictive Analytics : predicts what is most likely to happen in the future.
* Prescriptive Analytics : recommends actions you can take to affect those outcomes.

[參考網址](https://www.logianalytics.com/predictive-analytics/comparing-descriptive-predictive-prescriptive-and-diagnostic-analytics/)Comparing Descriptive, Predictive, Prescriptive, and Diagnostic Analytics

[參考網址](https://demand-planning.com/2020/01/20/the-differences-between-descriptive-diagnostic-predictive-cognitive-analytics/)THE DIFFERENCES BETWEEN DESCRIPTIVE, DIAGNOSTIC, PREDICTIVE & COGNITIVE ANALYTICS

![重要](https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/f4891908-9e54-49c1-b8f8-615e76f2920e.jpg)

------------------------

# Big Data

* Big data architectures 

[參考網址](https://docs.microsoft.com/en-us/azure/architecture/data-guide/big-data/?WT.mc_id=DP-MVP-5000099)
  
* Batch processing

[參考網址](https://docs.microsoft.com/en-us/azure/architecture/data-guide/big-data/batch-processing?WT.mc_id=DP-MVP-5000099) Batch processing

[參考網址](https://docs.microsoft.com/en-us/azure/architecture/data-guide/technology-choices/analytical-data-stores) Choosing an analytical data store in Azure

* Real time processing

[參考網址](https://docs.microsoft.com/en-us/azure/architecture/data-guide/big-data/real-time-processing?WT.mc_id=DP-MVP-5000099)

------------------------

# Dedicated SQL pool 

* Dedicated SQL pool (formerly SQL DW) architecture in Azure Synapse Analytics
[參考網址](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/massively-parallel-processing-mpp-architecture?WT.mc_id=DP-MVP-5000099)

------------------------

# Cosmos DB
* Azure Cosmos DB Fast NoSQL database with SLA-backed speed and availability, automatic and instant scalability, and open-source APIs for MongoDB and Cassandra.
[參考網址](https://docs.microsoft.com/en-us/azure/cosmos-db/?WT.mc_id=DP-MVP-5000099)

* Partitioning and horizontal scaling in Azure Cosmos DB
[參考網址](https://docs.microsoft.com/en-us/azure/cosmos-db/partitioning-overview/?WT.mc_id=DP-MVP-5000099)

* Developing with Azure Cosmos DB Table API and Azure Table storage
[參考網址](https://docs.microsoft.com/en-us/azure/cosmos-db/table-support/?WT.mc_id=DP-MVP-5000099) Developing with Azure Cosmos DB Table API and Azure Table storage

[參考網址](https://docs.microsoft.com/zh-tw/azure/cosmos-db/how-to-multi-master/?WT.mc_id=DP-MVP-5000099) 在您的應用程式中設定使用 Azure Cosmos DB 的多重區域寫入

------------------------

# Azure Application Architecture Guide

* Understand data store models
[參考網址](https://docs.microsoft.com/en-us/azure/architecture/guide/technology-choices/data-store-overview?WT.mc_id=DP-MVP-5000099)


------------------------

# ADF
![圖片](https://docs.microsoft.com/en-us/azure/data-factory/media/concepts-pipelines-activities/relationship-between-dataset-pipeline-activity.png)
[參考網址](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipelines-activities)

------------------------

# Power BI

* Treemaps 
![圖片](https://docs.microsoft.com/en-us/power-bi/visuals/media/power-bi-visualization-treemaps/treemaphoverdetail-new.png)

[參考網址](https://docs.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-treemaps?WT.mc_id=DP-MVP-5000099) 

* Key influencers 
![圖片](https://docs.microsoft.com/en-us/power-bi/visuals/media/power-bi-visualization-influencers/power-bi-ki-numbers-new.png)

[參考網址](https://docs.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-influencers?WT.mc_id=DP-MVP-5000099) 

* Scatter 
![圖片](https://docs.microsoft.com/en-us/power-bi/visuals/media/power-bi-visualization-scatter/power-bi-bubble-chart.png)

[參考網址](https://docs.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-scatter?WT.mc_id=DP-MVP-5000099) 

------------------------

# SQL vs NOSQL

* What is Schema On Write

Schema on write is defined as creating a schema for data before writing into the database. If you have done any kind of development with a database you understand the structured nature of Relational Database(RDBMS) because you have used Structured Query Language (SQL) to read data from the database.

One of the most time consuming task in a RDBMS  is doing Extract Transform Load (ETL) work. Remember just because the data is structured doesn’t mean it starts out that way. Most of the data that exist is in an unstructured fashion. Not only do you have to define the schema for the data but you must also structure it based on that schema.

* What is Schema On Read

Schema on read differs from schema on write because you create the schema only when reading the data. Structured is applied to the data only when it’s read, this allows unstructured data to be stored in the database. Since it’s not necessary to define the schema before storing the data it makes it easier to bring in new data sources on the fly.

The exploding growth of unstructured data and overhead of ETL for storing data in RDBMS is the main reason for shift to schema on read. Many times analyst aren’t sure what types of insights they will gain from new data sources which is why getting new data source is time consuming. Remember back to our schema on write scenario let’s walk through it using schema on read.

