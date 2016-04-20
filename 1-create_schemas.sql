/***********************************************/             
--  Script Name   : 1-create_schemas.sql                              
--  Description   : Create Schemas 							
--  Author        : Mathew Pope                                        
--  CREATE DATE   : 2016/04/20
--  Modify Date   :                                                    
/***********************************************/ 

/*******************************************/
-- Database: primary_data
-- Purpose: load raw data from source system
/*******************************************/
CREATE SCHEMA primary_data;

/*******************************************/
-- Database: enterprise_data 
-- Purpose: Cleanse and transform data
/*******************************************/
CREATE SCHEMA enterprise_data;

/*******************************************/
-- Database: bi_data 
-- Purpose: Final bi tables for consumption
/*******************************************/
CREATE SCHEMA bi_data;