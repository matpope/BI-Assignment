/***********************************************/                  
--  Script Name   : 2-create_tables.sql                              
--  Description   : Create tables 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/  

-- Database: primary_data

CREATE TABLE primary_data.fx_rate (
id INT,
prim_currency_id INT,
scnd_currency_id INT,
date DATE,
currency_rate DECIMAL(40,20));

CREATE TABLE primary_data.lst_currency(
id INT,
code CHAR(3),
name VARCHAR(100));

CREATE TABLE primary_data.offer (
id INT,
hotel_id INT,
currency_id INT,
source_system_code VARCHAR(100),
available_cnt SMALLINT,
sellings_price DECIMAL(40,20),
checkin_date DATE,
checkout_date DATE,
valid_offer_flag TINYINT,
offer_valid_from DATETIME,
offer_valid_to DATETIME,
breakfast_included_flag TINYINT,
insert_datetime DATETIME);

-- Database: enterprise_data

CREATE TABLE enterprise_data.offer_cleanse (
id INT,
hotel_id INT,
currency_id INT,
source_system_code VARCHAR(100),
available_cnt SMALLINT,
sellings_price DECIMAL(40,20),
checkin_date DATE,
checkout_date DATE,
valid_offer_flag TINYINT,
offer_valid_from DATETIME,
offer_valid_to DATETIME,
breakfast_included_flag TINYINT,
insert_datetime DATETIME);

CREATE TABLE enterprise_data.offer_error (
id INT,
hotel_id INT,
currency_id INT,
source_system_code VARCHAR(100),
available_cnt SMALLINT,
sellings_price DECIMAL(40,20),
checkin_date DATE,
checkout_date DATE,
valid_offer_flag TINYINT,
offer_valid_from DATETIME,
offer_valid_to DATETIME,
breakfast_included_flag TINYINT,
insert_datetime DATETIME);

CREATE TABLE enterprise_data.offer_cleanse_remove_duplicates (
id INT,
hotel_id INT,
currency_id INT,
source_system_code VARCHAR(100),
available_cnt SMALLINT,
sellings_price DECIMAL(40,20),
checkin_date DATE,
checkout_date DATE,
valid_offer_flag TINYINT,
offer_valid_from DATETIME,
offer_valid_to DATETIME,
breakfast_included_flag TINYINT,
insert_datetime DATETIME);

CREATE TABLE enterprise_data.offer_cleanse_date_fix (
id INT,
hotel_id INT,
currency_id INT,
source_system_code VARCHAR(100),
available_cnt SMALLINT,
sellings_price DECIMAL(40,20),
checkin_date DATE,
checkout_date DATE,
valid_offer_flag TINYINT,
offer_valid_from DATETIME,
offer_valid_to DATETIME,
breakfast_included_flag TINYINT,
insert_datetime DATETIME,
offer_valid_from_clean date);

CREATE TABLE enterprise_data.hotel_offers_full (
hotel_id INT,
date DATE,
hour TINYINT,
breakfast_included_flag TINYINT,
valid_offer_available_flag TINYINT);

-- Database: bi_data

CREATE TABLE bi_data.valid_offers (
offer_id INT,
hotel_id INT,
price_usd DECIMAL(40,20),
original_price DECIMAL(40,20),
original_currency_code VARCHAR(35),
checkin_date DATE,
checkout_date DATE,
breakfast_included_flag TINYINT,
valid_from_date DATETIME,
valid_to_date DATETIME);

CREATE TABLE bi_data.hotel_offers (
hotel_id INT,
date DATE,
hour TINYINT,
breakfast_included_flag TINYINT,
valid_offer_available_flag TINYINT);
