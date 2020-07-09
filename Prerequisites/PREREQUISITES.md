# **Prerequisites:**

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

<kbd>
  <img src="/Images/16.png">
</kbd></p>


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
