-- ===================================================================
-- This script enables change-tracking for the DOCUMENT table. Running
-- the Show_Changes_Example.sql script will list the changes that have
-- been captured for the data in this table. Running the 
-- Stop_Tracking_Changes_Example.sql script will switch off the change
-- tracking.
--
-- **IMPORTANT: SQL Server Agent must be running.**
--
-- CJS 20/04/2011
-- ===================================================================

-- Change this to the correct database
USE EXCH67
GO

-- Enable change-tracking for the database
EXECUTE sys.sp_cdc_enable_db;

-- Add the tables to be tracked
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'DOCUMENT', @role_name = NULL;

-- List the tables being tracked
EXECUTE sys.sp_cdc_help_change_data_capture;
