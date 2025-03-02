# CTF Analytics

## All about the Charity Day (11/11/2021) - KNOW BEFORE YOU GO!

- [KNOW BEFORE YOU GO on MS Teams Site](https://teams.microsoft.com/_#/files/General?groupId=3030cf82-5b5c-4eb5-9a6b-0008ea494501&threadId=19%3AbcSCgLhhicTIaMjj3EnFPdnxBafabqiegsOdRLZh7lc1%40thread.tacv2&ctx=channel&context=CTF%2520Charity%2520Day&rootfolder=%252Fsites%252FDEAACharityEvents%252FShared%2520Documents%252FGeneral%252FCTF%2520Charity%2520Day)

- Divvying up the questions for the teams is TBD
- If you want to see some questions beyond what Simon has covered, take a look at these two documents: [1](https://spteam.aa.com/:w:/s/DEAACharityEvents/ESybbaEUjl9KvLeqZdnLt4kBlrALkFS5hyOINzs_3OfgJQ?e=psduxk) and [2](https://spteam.aa.com/:w:/s/DEAACharityEvents/EYKkylPDIaVAsma2gOMNVtMByrfO8nUg5k64DvTwJISb3Q?e=PA4Tya)
- Great [video](https://spteam.aa.com/:v:/s/DEAACharityEvents/ESQM2zGfRC1NlWRonjDhJq8Ba9W5Lvc7ndBaXw2_pkQY2Q?e=WjY5MB) to watch on CTF's data from their SalesForce consultant, Kala

## Snowflake as the Data warehouse
A starter template for [Snowflake Cloud Database](https://snowflake.com)

* Snowflake offers a 1 month free trial, and with this repo you should be able to get a sense for the basics of Snowflake within an hour.
* This template will create the necessary `ROLE`, `USER`, `DATABASE`, `SCHEMA` & `WAREHOUSE`(s) necessary to get up and running with Snowflake:



# Usage

## Requirements

* [Snowflake instance](https://trial.snowflake.com/) (takes 5min to setup, no credit card for 1 month)
* [SnowSQL CLI](https://docs.snowflake.com/en/user-guide/snowsql.html) (optional)

## Run Examples on the Trial snowflake

Copy [first_run.sql](./examples/first_run.sql) into a worksheet and Run All. 

Or use the CLI
```bash
snowsql -c <your_connection_name> -f first_run.sql
```

# Deploy Snowflake (done by an Admin) for CTF

- Copy [ProdDatabaseCreation.sql](./db_admin/ProdDatabaseCreation.sql) into a worksheet and Run All. 
- Copy [ProdRoleCreation.sql](./db_admin/ProdRoleCreation.sql) into a worksheet and Run All. 
- Copy [ProdFuncUserCreation.sql](./db_admin/ProdFuncUserCreation.sql) into a worksheet and Run All. 
- Copy [ProdUserCreation.sql](./db_admin/ProdUserCreation.sql) into a worksheet and Run All. 

Or use the CLI
```bash
snowsql -c <your_connection_name> -f ProdDatabaseCreation.sql
snowsql -c <your_connection_name> -f ProdRoleCreation.sql
snowsql -c <your_connection_name> -f ProdFuncUserCreation.sql
snowsql -c <your_connection_name> -f ProdUserCreation.sql
```
### Infrastructure Details
The following is created, as described in [first_run.sql](/first_run.sql)
```
├── DATABASES
│   ├── PROD_CTF_RAW                    # BRONZE LAYER:This is the landing pad for everything extracted and loaded
│   ├── PROD_CTF_CLEAN                  # SILVER LAYER: This is the area where clean data is stored
│   └── PROD_CTF_USE                    # GOLD LAYER: This database contains tables and views accessible to analysts and reporting
│   └── PROD_CTF_SANDBOX                # EXPERIMENT LAYER: This database contains tables and views created in the sandbox or experiment phase
├── WAREHOUSES
│   ├── WAREHOUSE_INGEST                # Tools like Matillion will use this warehouse to perform loads of new data
│   ├── WAREHOUSE_TRANSFORM             # This is the warehouse that dataform/dbt will use to perform all data transformations
│   ├── WAREHOUSE_REPORT                # BI tools will connect to this warehouse to run analytical queries
├── ROLES
│   ├── prod_db_gbl_r_rl                # Global read role
│   ├── prod_db_raw_crwx_rl             # Raw database create/read/write role 
│   ├── prod_db_raw_sch_sprdsht_rwx_rl  # Raw database spreadsheet schema create/read/write role 
│   ├── prod_db_trf_rwx_rl              # Clean/Use database read/write role 
│   ├── prod_db_sndbx_rwx_rl            # Sandbox database create/read/write role 
│   ├── prod_func_de_rl                 # Functional Data Engineering Role 
│   ├── prod_func_ingest_rl             # Functional Ingestion Role setup
│   ├── prod_func_adhoc_ingest_rl       # Functional adhoc Ingestion Role setup
│   ├── prod_usr_de_rl                  # Data Engineer Role setup
│   ├── prod_usr_ba_rl                  # Business Analyst Role setup
│   ├── USERADMIN                       # User administrator
├── USERS
│   ├── PROD_CTF_INGEST_FUNC_USER       # eg: Matillion User
│   ├── PROD_CTF_ADHOC_INGEST_FUNC_USER # eg: Excel upload
│   ├── USER_REPORT                     # eg: BI user
│   ├── aa_<firstname>_<lastname>       # eg: aa_craig_cargile
│   ├── ctf_<firstname>_<lastname>       # eg: ctf_simon_vukelj

```
### Roles Mapping

![MicrosoftTeams-image (25)](https://user-images.githubusercontent.com/69059535/141008283-723bf9cb-e5bc-46a8-bc90-6b9511dd0b9e.png)



## 2. Test

Use the [test_permissions.sql](./db_admin/ProdTestPermissions.sql) SQL to:
1. create a base table in the `PROD_CTF_RAW` database, load a test row using the `prod_func_ingest_rl` role
1. create a new table and view in `PROD_CTF_CLEAN` using the `prod_func_de_rl` role
1. query that view in `PROD_CTF_USE` using the `prod_usr_ba_rl` role

**NB replace `<USERNAME>` in the file with your login name** 

Or use the CLI:
```bash
snowsql -c <your_connection_name> -f ProdTestPermissions.sql
```

## 3. JSON

JSON is very well handled in Snowflake, and worth a look. The [test_json.sql](./examples/test_json.sql) file runs through the flattening of raw JSON into a table.

Or use the CLI:
```bash
snowsql -c <your_connection_name> -f test_json.sql
```

* Key to note is the `RECURSIVE=>TRUE` flag

## 4. User-Defined Functions

UDF allow you to create functions in SQL or JavaScript. The [test_udf.sql](./examples/test_udf.sql) file runs through the creation and testing of a SQL and JavaScript UDF. See the [docs](https://docs.snowflake.com/en/sql-reference/udf-overview.html) for more

Or use the CLI:
```bash
snowsql -c <your_connection_name> -f test_udf.sql
```
