/***********************************************/             
--  Script Name   : 6-cleanse_remove_duplicates.sql                              
--  Description   : Fix Offer Dates 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

USE `enterprise_data`;
DROP procedure IF EXISTS `fix_offer_dates`;

DELIMITER $$
USE `enterprise_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fix_offer_dates`()
BEGIN
	INSERT INTO enterprise_data.offer_cleanse_date_fix
	SELECT 	id, hotel_id, currency_id, source_system_code, available_cnt, sellings_price,
			checkin_date, checkout_date, valid_offer_flag, offer_valid_from, offer_valid_to,
			breakfast_included_flag, insert_datetime,
			CASE  WHEN DATE(offer_valid_from) > DATE('2015-11-09') THEN DATE('2015-11-09')
				  WHEN DATE(offer_valid_from) < DATE('2015-05-01') THEN DATE('2015-05-01')
			ELSE DATE(offer_valid_from)
            END as offer_valid_from_clean
FROM  enterprise_data.offer_cleanse_remove_duplicates;

END$$

DELIMITER ;