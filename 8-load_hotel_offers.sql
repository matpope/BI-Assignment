/***********************************************/             
--  Script Name   : 8-load_hotel_offers.sql                              
--  Description   : Load hotel offers							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

USE `enterprise_data`;
DROP procedure IF EXISTS `load_hotel_offers`;

DELIMITER $$
USE `enterprise_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `load_hotel_offers`()
BEGIN
DECLARE v_valid_from_date_hour TINYINT;
DECLARE v_valid_to_date_hour TINYINT;
DECLARE v_hour_counter TINYINT;
DECLARE v_hour_counter_full_day TINYINT;
DECLARE v_min_valid_from_date DATE;
DECLARE v_max_valid_to_date DATE;
DECLARE v_hotel_id INT;
DECLARE v_finished INT DEFAULT 0;
DECLARE v_valid_from_date DATETIME;
DECLARE v_valid_to_date DATETIME;
DECLARE v_in_between_dates DATETIME;
DECLARE v_valid_to_date_adjusted DATETIME;
DECLARE v_breakfast_included_flag TINYINT;

-- declare cursor for valid offers
DECLARE offer_cursor CURSOR FOR 
SELECT 	hotel_id, valid_from_date, valid_to_date, breakfast_included_flag
FROM 	bi_data.valid_offers;

-- declare NOT FOUND handler
DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET v_finished = 1;
OPEN offer_cursor;
get_hotel_id: LOOP
	FETCH offer_cursor INTO v_hotel_id, v_valid_from_date, v_valid_to_date, v_breakfast_included_flag;
	IF v_finished = 1 THEN 
	  LEAVE get_hotel_id;
	END IF;

	-- Assumption: if the year of valid_to_date is 2999, data will be loaded until '2015-11-27' 
	-- Currently '2015-11-27' is the maximum valid_to_date for valid orders. This can be adjusted if required.
	IF YEAR(v_valid_to_date) = 2999 THEN
		SET v_valid_to_date = STR_TO_DATE('2015-11-27 23:59:59', '%Y-%m-%d %T');
	END IF;

	-- Insert records for days in-between the date range (if they exist)
	SET v_in_between_dates = DATE_ADD(v_valid_from_date, INTERVAL 1 DAY); 
	WHILE v_in_between_dates < v_valid_to_date DO
		SET v_hour_counter_full_day = 0;
		WHILE v_hour_counter_full_day  <= 23 DO
			INSERT INTO enterprise_data.hotel_offers_full (
			hotel_id, date, hour, breakfast_included_flag, valid_offer_available_flag)
			VALUES  (v_hotel_id, v_in_between_dates, v_hour_counter_full_day, v_breakfast_included_flag, 1);
			SET  v_hour_counter_full_day = v_hour_counter_full_day + 1;
		END WHILE;
		SET  v_in_between_dates = DATE_ADD(v_in_between_dates, INTERVAL 1 DAY);
	END WHILE;

	-- Insert records for the hours of the from and to dates
	SET v_valid_from_date_hour = HOUR(v_valid_from_date);
	SET v_valid_to_date_hour = HOUR(v_valid_to_date);
	SET v_hour_counter = 0;
	WHILE v_hour_counter  <= 23 DO
		-- insert hotel_offers
		INSERT INTO enterprise_data.hotel_offers_full (
		hotel_id, date, hour, breakfast_included_flag, valid_offer_available_flag)
		VALUES  (v_hotel_id, v_valid_from_date, v_hour_counter, 
		IF(v_hour_counter >= v_valid_from_date_hour, v_breakfast_included_flag, 0),
		IF(v_hour_counter >= v_valid_from_date_hour, 1, 0));

		INSERT INTO enterprise_data.hotel_offers_full (hotel_id, date, hour, breakfast_included_flag, valid_offer_available_flag)
		VALUES  (v_hotel_id, v_valid_to_date, v_hour_counter, 
		IF(v_hour_counter <= v_valid_to_date_hour, v_breakfast_included_flag, 0),
		IF(v_hour_counter <= v_valid_to_date_hour, 1, 0));
		SET  v_hour_counter = v_hour_counter + 1; 
	END WHILE;
 
END LOOP get_hotel_id;
CLOSE offer_cursor;

--  Load BI Data: removing duplicates 
INSERT INTO bi_data.hotel_offers (hotel_id, date, hour, breakfast_included_flag, valid_offer_available_flag)
SELECT hotel_id, date, hour, breakfast_included_flag, max(valid_offer_available_flag) 
from enterprise_data.hotel_offers_full
GROUP BY hotel_id, date, hour, breakfast_included_flag;

END$$

DELIMITER ;

