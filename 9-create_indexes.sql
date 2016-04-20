/***********************************************/                  
--  Script Name   : 9-create_indexes.sql                              
--  Description   : Create Indexes for BI_Data tables 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

ALTER TABLE bi_data.valid_offers ADD INDEX `hotel_id` (`hotel_id`);
ALTER TABLE bi_data.valid_offers ADD INDEX `checkin_date` (`checkin_date`);
ALTER TABLE bi_data.valid_offers ADD INDEX `checkout_date` (`checkout_date`);

ALTER TABLE bi_data.hotel_offers ADD INDEX `hotel_id` (`hotel_id`);
ALTER TABLE bi_data.hotel_offers ADD INDEX `date` (`date`);