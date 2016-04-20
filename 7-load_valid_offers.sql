/***********************************************/             
--  Script Name   : 7-load_valid_offers.sql                              
--  Description   : Load Valid offers							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

USE `enterprise_data`;
DROP procedure IF EXISTS `load_valid_offers`;

DELIMITER $$
USE `enterprise_data`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `load_valid_offers`()
BEGIN	
	-- Load non-USD data
	INSERT INTO bi_data.valid_offers (
				offer_id, hotel_id, price_usd, original_price, original_currency_code,
				checkin_date, checkout_date, breakfast_included_flag, valid_from_date, valid_to_date)
	SELECT	of.id, of.hotel_id, (of.sellings_price*fx.currency_rate) as price_usd,
			of.sellings_price as original_price, lc.code AS original_currency_code, of.checkin_date,
			of.checkout_date, of.breakfast_included_flag, of.offer_valid_from, of.offer_valid_to
	FROM  enterprise_data.offer_cleanse_date_fix of, primary_data.fx_rate fx, primary_data.lst_currency lc
	WHERE of.currency_id != 1
	AND   of.currency_id=fx.prim_currency_id
	AND   of.offer_valid_from_clean = fx.date
	AND   of.currency_id=lc.id
	AND   fx.scnd_currency_id = 1;

	-- Load USD data
	INSERT INTO bi_data.valid_offers (offer_id, hotel_id, price_usd, original_price, original_currency_code,
				checkin_date, checkout_date, breakfast_included_flag, valid_from_date, valid_to_date)
	SELECT 	of.id, of.hotel_id, of.sellings_price as price_usd, of.sellings_price as original_price,
			lc.code AS original_currency_code, of.checkin_date, of.checkout_date, of.breakfast_included_flag,
			of.offer_valid_from, of.offer_valid_to
	FROM  enterprise_data.offer_cleanse_date_fix of, primary_data.lst_currency lc
	WHERE of.currency_id=1
	AND   lc.id = 1;
END$$

DELIMITER ;