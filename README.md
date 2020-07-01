# Azure DMS: Oracle to Azure PostgreSQL

The Azure Database Migration Service (Azure DMS) is a tool that serves as a way to migrate, guide, and automate your current database migration to Azure. Effortlessly migrate data, schemas, and objects from various sources to the cloud.

## Azure DMS provides the following features:
* Supports Microsoft SQL Server, MySQL, PostgreSQL, MongoDB, and Oracle migration to Azure from on-premises and other clouds.
* Migration moves data, schema, and objects to Azure.
* Highly expansive migration service provides stable outcomes with almost no downtime.
* Database Migration Service works with PowerShell commandlets to automatically migrate a list of databases.
* Comprehensive security and compliance, built in.




## **Scenario**

![](/Images/13.png)

**Scenario Details:**

* **Source VM:** Windows Server 2019 with Oracle Image installed (12.2.0.1.0 Enterprise Edition)
* **Oracle Database:** Non-Container Database, version 12.2.0.1.0 Enterprise Edition
* **PostgreSQL Database:** Azure PostgreSQL-Single Server, PostgreSQL version 10
* **Oracle Database Contents:** Contains STORE table with 1000 generated rows
* **PostgreSQL Database Contents:** Contains STORE(empty pre-migration), SALES_TRANSACTION(100 million rows), and PRODUCTS(1000+ rows) tables
* **Duration of Demo:** Approximately 


**Prerequisites:**

1.  Have credentials for a single-tenant Oracle Database (10g, 11c, 12c)
2.  Have credentials for single-tenant Azure PostgreSQL Database
3.  Have these ports open for both databases/Vm’s: 443, 53, 9354, 445, 12000
4.  Have a network drive set up for “File Share” which contains the OCI Driver for Azure DMS to use, driver download: [https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html#ic_winx64_inst](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html#ic_winx64_inst)
5. Setup Tables for data sync: edit properties of your tables that you want to sync so they show up in DMS (datatypes, column names, etc.) [**tutorial below**]
6. Enable Archive Redo Logs (Required by Azure DMS to capture data change) [**tutorial below**]
    

**Prerequisite 5: Setup Tables for data sync**

1.  Go to your PostgreSQL Database and create a table with the exact same name as the table you want to data sync with (from Oracle Database)
2.  Ensure that column datatypes from the PostgreSQL table are properly mapped to the Oracle Database table.
3.  In your Oracle Database; change the ‘UNITS’ to be ‘CHAR’ and not ‘BYTE’ for character datatypes in your desired table for DMS. (When DMS is active and the character outputs to PostgreSQL are incorrect, change this setting)

![](/Images/1.png)


**Prerequisite 6: Enable Archive Redo Logs (Required by Azure DMS to capture data change)**

1. Sign into your oracle database using sqlplus: sqlplus (user)/(password) as sysdba
2.  SHUTDOWN IMMEDIATE;
3.  STARTUP MOUNT;
4.  ALTER DATABASE ARCHIVELOG;
5.  ALTER DATABASE OPEN;
6.  SELECT log_mode FROM v$database;
7.  This should return ‘ARCHIVELOG’ if done correctly
8.  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY, UNIQUE) COLUMNS;
9.  ALTER TABLE [TABLENAME] ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
10.  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
11.  ALTER TABLE xxx ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
12.  SELECT supplemental_log_data_min FROM v$database;
13.  This should return ‘YES’ if done correctly

##1. Set up prerequisites
* Before provisioning the Azure DMS tool, we will have to set up our databases correctly
* These steps are required in order for our Source and Target Databases to connect to Azure DMS
* Link to Prerequisites page: [Prerequisites](https://github.com/Click2Cloud/azure-oracle-migration/tree/master/Prerequisites)

##2. Connect Oracle Database and PostgreSQL Database to Azure DMS
* Once prerequisites are done we can move on to setting up Azure DMS
* Here is a link to a detailed guide (with pictures) on how to set up Azure DMS: [Prerequisites](https://github.com/Click2Cloud/azure-oracle-migration/blob/master/Tutorials/DMStutorial.md)



