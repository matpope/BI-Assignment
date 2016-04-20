/***********************************************/             
--  Script Name   : 4-cleanse.sql                              
--  Description   : Initial cleanse of data 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

/*
Data cleansing to Include Only:
1. Valid offers
2. Valid hotel_id, id
3. Available rooms greater than zero
4. Selling price greater than zero
5. Valid Breakfast flag
6. Check In date is less than Check Out: Hotel Stay should be at least 1 night and valid dates
7. Offer Valid From should be less than Offer Valid To
8. Valid Currency ID and in the list of Currencies from 'lst_currency'
9. Offer Valid From should be less than or equal to the checkin date: Otherwise Check In date would have elapsed when the Offer becomes valid
10. Ensure the offer is valid for at least one minute */

USE `enterprise_data`;
DROP procedure IF EXISTS `cleanse_data`;

DELIMITER $$
USE `enterprise_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cleanse_data`()
BEGIN

-- Insert valid records to 'offer_cleanse'
INSERT INTO enterprise_data.offer_cleanse (id, hotel_id, currency_id, source_system_code, available_cnt, sellings_price, checkin_date, checkout_date, valid_offer_flag, offer_valid_from, offer_valid_to, breakfast_included_flag, insert_datetime)
SELECT id, hotel_id, currency_id, trim(source_system_code), available_cnt, sellings_price,
checkin_date, checkout_date, valid_offer_flag, offer_valid_from, offer_valid_to,
breakfast_included_flag, insert_datetime
FROM  primary_data.offer
WHERE valid_offer_flag = 1
AND	  hotel_id <> -1
AND   id is not null
AND   available_cnt > 0
AND   source_system_code is not null
AND   sellings_price is not null
AND   sellings_price > 0
AND   breakfast_included_flag is not null
AND   breakfast_included_flag IN (0,1)
AND   checkin_date < checkout_date
AND   offer_valid_from < offer_valid_to    
AND   currency_id <> -1
AND   currency_id in (select id from primary_data.lst_currency)
AND   DATE(offer_valid_from) <= checkin_date
AND   timestampdiff(MINUTE, offer_valid_from, offer_valid_to) != 0;

-- Insert invalid records to 'offer_error'
insert into enterprise_data.offer_error (id, hotel_id, currency_id, source_system_code, available_cnt, sellings_price, checkin_date, checkout_date, valid_offer_flag, offer_valid_from, offer_valid_to, breakfast_included_flag, insert_datetime)
SELECT id, hotel_id, currency_id, trim(source_system_code), available_cnt, sellings_price,
checkin_date, checkout_date, valid_offer_flag, offer_valid_from, offer_valid_to,
breakfast_included_flag, insert_datetime
FROM  primary_data.offer
WHERE valid_offer_flag = 1
AND   
(     hotel_id=-1
OR    id is null
OR    available_cnt <= 0
OR    source_system_code is null
OR    sellings_price is null
OR    sellings_price <= 0
OR    breakfast_included_flag is null
OR    breakfast_included_flag NOT IN (0,1)
OR    checkin_date >= checkout_date
OR    offer_valid_from >= offer_valid_to    
OR    currency_id = -1
OR    currency_id not in (select id from primary_data.lst_currency)
OR	  date(offer_valid_from) > checkin_date
OR    timestampdiff(MINUTE, offer_valid_from, offer_valid_to) = 0);

END$$

DELIMITER ;