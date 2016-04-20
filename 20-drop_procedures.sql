/***********************************************/ 
--  Script Name   : 20-drop_procedures.sql                              
--  Description   : Drop Procedures 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/  

USE `enterprise_data`;
DROP procedure IF EXISTS `enterprise_data.cleanse_data`;
DROP procedure IF EXISTS `enterprise_data.remove_duplicate_offer`;
DROP procedure IF EXISTS `enterprise_data.fix_offer_dates`;
DROP procedure IF EXISTS `enterprise_data.load_valid_offers`;
DROP procedure IF EXISTS `enterprise_data.load_hotel_offers`;