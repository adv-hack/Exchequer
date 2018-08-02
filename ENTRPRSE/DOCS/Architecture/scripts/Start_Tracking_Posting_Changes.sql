-- ===================================================================
-- This script enables change-tracking for the tables affected by the
-- posting routines.
--
-- **IMPORTANT: SQL Server Agent must be running.**
--
-- Running the Show_Posting_Changes.sql script will list the changes 
-- that have been captured for the data in this table. Running the 
-- Stop_Tracking_Posting_Changes.sql script will switch off the change
-- tracking.
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
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'DETAILS',  @role_name = NULL;
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'EXSTKCHK', @role_name = NULL;
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'JOBDET',   @role_name = NULL;
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'MLOCSTK',  @role_name = NULL;
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'JOBMISC',  @role_name = NULL;
EXECUTE sys.sp_cdc_enable_table @source_schema = N'ZZZZ01', @source_name = N'HISTORY',  @role_name = NULL;

-- List the tables being tracked
EXECUTE sys.sp_cdc_help_change_data_capture;
