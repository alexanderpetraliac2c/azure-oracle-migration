# Connect Oracle and PostgreSQL Database to Azure DMS 

**Scenario Details:**
* In this scenario we are connecting our Oracle and PostgreSQL Databases to the Azure DMS service.
* Prerequisites for this process are located in the "Prerequisites" directory in this repository.
* Once the prerequisites are properly alligned, connections to **Azure DMS** should be successful.
<br/> 

**Technologies used:**
* Azure Database Migration Service
* File Sharing
* Oracle Database (*12.2.0.1 Enterprise Edition*)
* Azure PostreSQL-Single Server Database
<br/>



**1. Create new Azure Migration Service resource.**

<kbd>
  <img src="/Images/2.png">
</kbd></p>

<br/><br/><br/>



**2. Enter in your credentials for the resource and make sure to choose the “Premium SKU” as this is required for continuous data migration.**

<kbd>
  <img src="/Images/3.png">
</kbd></p>

<br/><br/><br/>



**3. Create new migration project.**

<kbd>
  <img src="/Images/4.png">
</kbd></p>

<br/><br/><br/>



**4. Create the migration project, make sure to use the “Premium SKU” once again.**

<kbd>
  <img src="/Images/5.png">
</kbd></p>

<br/><br/><br/>



**5. Create a “New Activity” in the new migration project.**

<kbd>
  <img src="/Images/6.png">
</kbd></p>

<br/><br/><br/>



**6. Connect to your Oracle Database.**

<kbd>
  <img src="/Images/7.png">
</kbd></p>

<br/><br/><br/>



**7. Connect OCI Driver from File Share Folder.**

* You will need the file share link, username (which has all permissions for the drive), and the password for the username 
* If ‘readonly, archive’ error: right click the driver zip file->uncheck ‘read-only’ 

<kbd>
  <img src="/Images/8.png">
</kbd></p>

<br/><br/><br/>



**8. Connect to the Azure PostgreSQL Database.**

<kbd>
  <img src="/Images/9.png">
</kbd></p>

<br/><br/><br/>



**9. Select the Schemas you want to use for sync.**

* If nothing shows up this means you did not properly set up the names, datatypes, etc. For the Oracle and PostgreSQL tables. 

<kbd>
  <img src="/Images/10.png">
</kbd></p>

<br/><br/><br/>



**10. Check the summary if all settings/configurations are correct then click "Run Migration".**

<kbd>
  <img src="/Images/11.png">
</kbd></p>

<br/><br/><br/>



**11. Then check the summary to see if all settings are correct and then run the activity. Once this is done you can check on the current activities in the migration.**

<kbd>
  <img src="/Images/12.png">
</kbd></p>
