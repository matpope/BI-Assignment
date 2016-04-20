/***********************************************/               
--  Script Name   : 21-drop_tables.sql                              
--  Description   : Drop Tables 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/  

DROP TABLE primary_data.fx_rate;
DROP TABLE primary_data.lst_currency;
DROP TABLE primary_data.offer;
DROP TABLE enterprise_data.offer_cleanse; 
DROP TABLE enterprise_data.offer_error; 
DROP TABLE enterprise_data.offer_cleanse_remove_duplicates; 
DROP TABLE enterprise_data.offer_cleanse_date_fix;
DROP TABLE enterprise_data.hotel_offers_full;
DROP TABLE bi_data.valid_offers;
DROP TABLE bi_data.hotel_offers;