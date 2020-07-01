# Azure DMS: Oracle to Azure PostgreSQL

The Azure Database Migration Service (Azure DMS) is a tool that serves as a way to migrate, guide, and automate your current database migration to Azure. Effortlessly migrate data, schemas, and objects from various sources to the cloud.

## Azure DMS provides the following features:
* Supports Microsoft SQL Server, MySQL, PostgreSQL, MongoDB, and Oracle migration to Azure from on-premises and other clouds
* Migration moves data, schema, and objects to Azure
* Highly expansive migration service provides stable outcomes with almost no downtime



## **Scenario**

![](/Images/13.png)






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

### Connect Oracle Database to Azure DMS 

**1. Create new Azure Migration Service resource**

![](/Images/2.png)

<br/><br/><br/>



**2. Enter in your credentials for the resource and make sure to choose the “Premium SKU” as this is required for continuous data migration.**

![](/Images/3.png)

<br/><br/><br/>



**3. Create new migration project**

![](/Images/4.png)

<br/><br/><br/>



**4. Create the migration project, making sure to once again use the “Premium SKU”**

![](/Images/5.png)

<br/><br/><br/>



**5. Create a “New Activity” in the new migration project**

![](/Images/6.png)

<br/><br/><br/>



**6. Connect to your Oracle Database**

![](/Images/7.png)

<br/><br/><br/>



**7. Connect OCI Driver from File Share Folder**

* You will need the file share link, username (which has all permissions for the drive), and the password for the username 
* If ‘readonly, archive’ error: right click the driver zip file->uncheck ‘read-only’ 

![](/Images/8.png)

<br/><br/><br/>



**8. Connect to the Azure PostgreSQL Database**

![](/Images/9.png)

<br/><br/><br/>



**9. Select the Schemas you want to use for sync**

* If nothing shows up this means you did not properly set up the names, datatypes, etc. For the Oracle and PostgreSQL tables. 

![](/Images/10.png)

<br/><br/><br/>



**10. Check the summary if all settings/configurations are correct then click "Run Migration"**

![](/Images/11.png)

<br/><br/><br/>



**11. Then check the summary to see if all settings are correct and then run the activity. Once this is done you can check on the current activities in the migration.**

![](/Images/12.png)
