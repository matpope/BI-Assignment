BI-Assignment
=============

## Approach Summary 
I have used MySQL for this assignment. My approach has been to create three databases: one for each layer of the ETL process: 

1. DB: *primary_data*: Load data from csv files (Extract)
2. DB: *enterprise_data*: Transform: Cleanse and normalize the data (Transform)
3. DB: *bi_data*: Load: Load the BI tables (Load)

### Create Scripts
Prerequisite: User executing scripts has permission to create schemas and tables

#### Script 1: 1-create_schemas.sql
The following three Databases/Schemas will be created for the project:

1. primary_data
2. enterprise_data
3. bi_data

#### Script 2: 2-create_tables.sql
Create all database tables

#### Script 3: 3-load_csv_files.sql
Prerequisite
.csv files copied to MySQL 'Uploads' folder and folder permissions set to allow MySQL to read these files.
In the scripts the folder is set to:
"C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/"

Load CSV files into 'primary_data' database:

1. fx_rate.csv --> primary_data.fx_rate
2. lst_currency.csv --> primary_data.lst_currency
3. offer.csv --> primary_data.offer

#### Script 4: 4-cleanse.sql

This procedure cleans the data inserts valid offer records to 'offer_cleanse' and invalid records are inserted into 'offer_error' where they can be further analyzed. 

Procedure: 'cleanse_data' will:

1. Valid records will be loaded to: enterprise_data.offer_cleanse
2. Invalid records will be loaded to (can be used for further analysys: enterprise_data.offer_error

Source: primary_data.offer

Destination: enterprise_data.offer_cleanse

Destination: enterprise_data.offer_error

Data Check (not implemented)
Data should be checked for outlying cases. E.g. in primary_data.offer table one record has a sellings_price of 7542170

#### Script 5: 5-cleanse_remove_duplicates.sql

From the specification:
"Offers cannot overlap for one hotel with the same parameters (checkin, checkout, source, breakfast)"
This procedure will remove any offers where the above parameters overlap.

Source: enterprise_data.offer_cleanse 

Destination: enterprise_data.offer_cleanse_remove_duplicates

#### Script 6: 6-cleanse_fix_dates.sql 

For all currencies (except USD) there is only data up until '2015-11-09', So if dates fall outside this range then '2015-11-09' will be used for currency conversion. The 'offer_valid_from' field has been created will be used as the source to join to the 'fx_rate' table on date and currency_id. 

Source: enterprise_data.offer_cleanse_remove_duplicates 

Destination: enterprise_data.offer_cleanse_date_fix

####  Script 7: 7-load_valid_offers.sql

This procedure will load the 'valid_offers' table.
USD rows and other countries are loaded separately as no currency conversion is required for USD, this offers the advantages:
- simplify and improve performance
- no currency conversion required and therefore no join to fx_rate required

Source: enterprise_data.offer_cleanse_date_fix

Destination: bi_data.valid_offers

Note: To Support the  API endpoint 'checkinDate', 'checkoutDate' have been added to the 'valid_offers' table

#### Script 8: 8-load_hotel_offers.sql
This procedure will load the 'hotel_offers' table.

Source: bi_data.valid_offers

Intermediate: enterprise_data.hotel_offers_full

Destination: bi_data.hotel_offers

#### Script 9: 9-create_indexes.sql
Create Indexes for BI Tables

### Execute Procedures
Prerequisite: User has permission to execute procedures

To run the ETL process the procedures should be executed in this order:

1. cleanse_data
2. remove_duplicate_offer
3. load_hotel_offers
4. fix_offer_dates
5. load_valid_offers
6. load_hotel_offers

### Cleanup Scripts

#### Script 10: 20-drop_procedures.sql
Drop stored procedures

#### Script 11: 21-drop_tables.sql
Remove tables

#### Script 12: 22-drop_schemas.sql
Remove schemas

#### Data Cleansing Ideas (not implemented)

Load all csv data into string columns so that no assumptions are made about format.
Validate 'lst_currency' table:
- Confirm all countries are available and no errors in codes or descriptions
Validate 'fx_rate' table: 
- Ensure all date ranges are available
- Confirm there are not big changes between days
