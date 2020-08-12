

# Azure Database Migration Service: <br/> Oracle to Azure PostgreSQL-Hyperscale

The **Azure Database Migration Service** is a tool that serves as a way to :
* Migrate, guide, and automate your current **database migration** to **Azure**. 
* Effortlessly **migrate** data, schemas, and objects from various sources to the **cloud**.

## Azure DMS provides the following features:
* Supports Microsoft SQL Server, MySQL, PostgreSQL, MongoDB, and Oracle migration to Azure from **on-premise and other clouds**.
* Migration moves data, schema, and objects to Azure.
* Highly expansive migration service provides stable outcomes with almost **no downtime**.
* Database Migration Service (**DMS**) works with **PowerShell** commandlets to automatically migrate a list of databases.
* **Built-in** comprehensive **security** and **compliance**.



## Scenario
<kbd>
  <img src="./Images/15.png">
</kbd></p>



### **Scenario Details:** <br />
* Create an on-premise Oracle database through an **Azure Windows 2019 Server VM** with an Oracle image (*12.2.0.1.0 Enterprise Edition*) installed.
* Assess **tables and objects** that user wants to migrate to the created **Azure PostgreSQL Database**. 
* Then migrate the schema from the **Oracle Database** to the **Azure PostgreSQL Database**.
* After this set up **Azure DMS** by connecting both databases, so that continuous sync can happen between our tables.
* Once **Azure DMS** connection is established, the **PostgreSQL Database** can be used for applications and analytics.


### **Scenario Setup:**

* **Source VM:** Windows Server 2019 with Oracle Image (*12.2.0.1.0 Enterprise Edition*) installed.
* **Oracle Database:** Non-Container Database (*12.2.0.1.0 Enterprise Edition*).
* **PostgreSQL Database:** Azure PostgreSQL-Single Server, PostgreSQL version 10
* **Oracle Database Contents:** Contains STORE table with 1000 generated rows
* **PostgreSQL Database Contents:** Contains STORE(empty pre-migration)
* **PostgreSQL-Hyperscale Database Contents:** Contains STORE(empty pre-migration), SALES_TRANSACTION(100 million rows), and PRODUCTS(1000+ rows) tables
* **Duration of Demo:** Approximately *30 minutes*


## Oracle to PostgreSQL-Hyperscale Migration using Azure DMS
  *Duration: 30 Minutes*
* [World Wide Importer Oracle Database Migration](https://github.com/alexanderpetraliac2c/azure-oracle-migration/blob/master/Tutorials/oraToPgToPgHyper.md)
* [World Wide Importer Oracle Database Migration (Video)](Videos/azuredmsproject.mp4)

## Deploy Azure Data Controller and Postgres Hyperscale on Kubernetes Clusters.
* [Deploy Azure Data Controller on Kubernetes](Tutorials/azure-arc-postgres-hyperscale/README.md)
* [Deploy PostgreSQL Hyperscale](Tutorials/azure-arc-postgres-hyperscale/docs/003-create-pghsaa-instance.md)

