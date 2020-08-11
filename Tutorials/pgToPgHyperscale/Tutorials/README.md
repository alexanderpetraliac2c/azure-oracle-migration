# Prerequisites for PostgreSQL to PosgreSQL-Hyperscale (Azure DMS)

* **Step 1:** Ensure that Azure DMS is already set up for Oracle to PostgreSQL (and have access to all credentials for this)
* **Step 2:** Create Azure PostgreSQL-Hyperscale Database
* **Step 3:** Migrate schema from PostgreSQL to PostgreSQL-Hyperscale
* **Step 4:** Enable logical replication in the postgresql.config file
* **Step 5:** Ensure that the Network Security Group (NSG) rules for your virtual network
   don't block the needed inbound communication ports

## Step 2: Create Azure PostgreSQL-Hyperscale Database

Go to your given Azure Resource group and create the Azure PostgreSQL-Hyperscale Database. Making sure to select the Virtual Network Resource you are using for the Oracle to PostgreSQL DMS setup.

## Step 3: Migrate schema from PostgreSQL to PostgreSQL-Hyperscale

To migrate the schema from PostgreSQL we will use PSQL which a utility we will use to dump the schema into a .sql file.
1. Download PSQL into your current enviroment, add the path to your enviroment variables or navigate to the directory conttaining the PSQL uttilitty with your given command prompt.
2. Create a blank file name source_schema.sql into the default directory for PSQL (in some cases the default directory is C:\Users\<your username>)
3. run this command with your source PostgreSQL credentials and desired database for DMS:
**pg_dump -o -h hostname -U db_username -d db_name -s > source_schema.sql**
4. Now go to that file and make sure the schema details were inserted and the file iis not blank.
5. By default, every schema in the PostgreSQL DB will be in this file for exporting, delete the schema inserts that you do not want to migrate.
5. Next, run this command to export the schema(s) to your PostgreSQL-Hyperscale DB: 
**psql -h hostname -U db_username -d db_name < source_schema.sql** 
6. Once this is completed, check to see if the schema was properly migrated.

## Step 4: Enable logical replication in the postgresql.config file
1. Navigate to your Azure PostgreSQL Database on tthe Azure Portal
2. Click on "sever parameters" and set the following parameters:
* wal_level = logical
* max_replication_slots = [number of slots], recommend setting to five slots
* max_wal_senders =[number of concurrent tasks] - The max_wal_senders parameter sets the number of concurrent tasks that can run, recommend setting to 10 tasks

## Step 5. Ensure that the Network Security Group (NSG) rules for your virtual network 
1. Navigate to the NSG resource you are using for the PostgreSQL Databases (For other types of Networks, navigate to the firewall settings)
2. Open these ports, which are needed for this DMS setup: 443, 53, 9354, 445, 12000, 5432 (PostgreSQL DB's), 1521 (Oracle DB)
   
   
   
   
   
