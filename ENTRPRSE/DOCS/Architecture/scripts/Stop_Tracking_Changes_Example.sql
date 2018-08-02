-- ===================================================================
-- This script disables change-tracking for the database.
--
-- See Start_Tracking_Changes_Example.sql for more information.
--
-- CJS 20/04/2011
-- ===================================================================

-- Change this to the correct database
USE EXCH67
GO

-- Disable change tracking for DOCUMENT
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'DOCUMENT',
@capture_instance = N'ZZZZ01_DOCUMENT'
GO

-- Disable change tracking altogether
EXEC sys.sp_cdc_disable_db
GO
