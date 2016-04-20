/***********************************************/             
--  Script Name   : 5-cleanse_remove_duplicates.sql                              
--  Description   : Remove duplicate data 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

USE `enterprise_data`;
DROP procedure IF EXISTS `remove_duplicate_offer`;

DELIMITER $$
USE `enterprise_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `remove_duplicate_offer`()
BEGIN
-- Used to for the cursor result set
DECLARE v_id INT;
DECLARE v_hotel_id INT;
DECLARE v_currency_id INT;
DECLARE v_source_system_code VARCHAR(100);
DECLARE v_available_cnt SMALLINT;
DECLARE v_sellings_price DECIMAL(40,20);
DECLARE v_checkin_date DATE;
DECLARE v_checkout_date DATE;
DECLARE v_valid_offer_flag TINYINT;
DECLARE v_offer_valid_from DATETIME;
DECLARE v_offer_valid_to DATETIME;
DECLARE v_breakfast_included_flag TINYINT;
DECLARE v_insert_datetime DATETIME;

-- Used to store the previous record for later comparison. Defaults used should not exist in 
-- the underlying data
DECLARE v_previous_checkout_date DATE DEFAULT STR_TO_DATE('1970-01-01', '%Y-%m-%d ');
DECLARE v_previous_hotel_id INT DEFAULT -1;
DECLARE v_previous_breakfast_included_flag TINYINT DEFAULT -1;
DECLARE v_previous_source_system_code VARCHAR(100) DEFAULT 'DUMMY';
DECLARE v_finished INT DEFAULT 0;

-- declare cursor for offers
DECLARE offer_cursor CURSOR FOR 
SELECT hotel_id, source_system_code, breakfast_included_flag, checkin_date, checkout_date, 
       offer_valid_from, offer_valid_to, id, currency_id, available_cnt, sellings_price, 
	   valid_offer_flag, insert_datetime
FROM enterprise_data.offer_cleanse
ORDER BY
hotel_id, source_system_code, breakfast_included_flag, checkin_date, checkout_date;

-- declare NOT FOUND handler
DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET v_finished = 1;
OPEN offer_cursor;
get_next_offer: LOOP
	
	-- fetch offer records
	FETCH offer_cursor INTO 
		v_hotel_id, v_source_system_code, v_breakfast_included_flag, v_checkin_date, v_checkout_date,
		v_offer_valid_from, v_offer_valid_to, v_id, v_currency_id, v_available_cnt, v_sellings_price,
	    v_valid_offer_flag, v_insert_datetime;
		
	IF v_finished = 1 THEN 
	  LEAVE get_next_offer;
	END IF;

	-- If the next offer does not overlap the previous record then insert it otherwise it is ignored
	IF  ((v_hotel_id != v_previous_hotel_id) OR 
	    (v_breakfast_included_flag != v_previous_breakfast_included_flag) OR
	    (v_previous_source_system_code != v_source_system_code)) OR 
	   (DATE(v_checkin_date) > DATE(v_previous_checkout_date)) THEN
	   
		INSERT INTO enterprise_data.offer_cleanse_remove_duplicates (id, hotel_id, currency_id,
                source_system_code, available_cnt, sellings_price, checkin_date, checkout_date,
                valid_offer_flag, offer_valid_from, offer_valid_to, breakfast_included_flag, insert_datetime)
	    VALUES (v_id, v_hotel_id, v_currency_id, v_source_system_code, v_available_cnt, v_sellings_price,
	           v_checkin_date, v_checkout_date, v_valid_offer_flag, v_offer_valid_from, v_offer_valid_to,
	           v_breakfast_included_flag, v_insert_datetime);	
	    
		SET v_previous_checkout_date = v_checkout_date;
		SET v_previous_hotel_id = v_hotel_id;
		SET v_previous_breakfast_included_flag = v_breakfast_included_flag; 
		SET v_previous_source_system_code = v_source_system_code;

   END IF;

END LOOP get_next_offer;
CLOSE offer_cursor;

END$$

DELIMITER ;