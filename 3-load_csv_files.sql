/***********************************************/                      
--  Script Name   : 3-load_csv_files.sql                              
--  Description   : Load csv source data to primary_data tables 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/    

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/fx_rate.csv" 
INTO TABLE primary_data.fx_rate
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, prim_currency_id, scnd_currency_id, @date, currency_rate)
SET date = STR_TO_DATE(@date, '%Y-%m-%d');

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/lst_currency.csv" 
INTO TABLE primary_data.lst_currency
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, @code, @name)
SET code=trim(@code), name=trim(@name);

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/offer.csv" 
INTO TABLE primary_data.offer
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, @hotel_id, @currency_id, source_system_code, @available_cnt, sellings_price, @checkin_date, @checkout_date, valid_offer_flag,
@offer_valid_from, @offer_valid_to, breakfast_included_flag, @insert_datetime)
set hotel_id = CASE @hotel_id WHEN "" THEN -1 WHEN NULL THEN -1 ELSE @hotel_id END,
    currency_id = CASE @currency_id WHEN "" THEN -1 WHEN NULL THEN -1 ELSE @currency_id END,
	available_cnt = CASE @available_cnt WHEN "" THEN -1 WHEN NULL THEN -1 ELSE @available_cnt END,
	checkin_date = STR_TO_DATE(@checkin_date, '%Y-%m-%d'), 
    checkout_date = STR_TO_DATE(@checkout_date, '%Y-%m-%d'),
	offer_valid_from = STR_TO_DATE(@offer_valid_from, '%Y-%m-%d %T'), 
	offer_valid_to = STR_TO_DATE(@offer_valid_to, '%Y-%m-%d %T'),
	insert_datetime = STR_TO_DATE(@insert_datetime, '%Y-%m-%d %T');