# Connect Oracle and PostgreSQL Database to Azure DMS 

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
