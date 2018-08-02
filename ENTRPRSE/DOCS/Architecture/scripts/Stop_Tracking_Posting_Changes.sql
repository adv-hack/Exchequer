-- ===================================================================
-- This script disables change-tracking for the database.
--
-- See Start_Tracking_Posting_Changes.sql for more information.
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

-- Disable change tracking for DETAILS
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'DETAILS',
@capture_instance = N'ZZZZ01_DETAILS'
GO

-- Disable change tracking for EXSTKCHK
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'EXSTKCHK',
@capture_instance = N'ZZZZ01_EXSTKCHK'
GO

-- Disable change tracking for HISTORY
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'HISTORY',
@capture_instance = N'ZZZZ01_HISTORY'
GO

-- Disable change tracking for JOBDET
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'JOBDET',
@capture_instance = N'ZZZZ01_JOBDET'
GO

-- Disable change tracking for MLOCSTK
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'MLOCSTK',
@capture_instance = N'ZZZZ01_MLOCSTK'
GO

-- Disable change tracking for JOBMISC
EXEC sys.sp_cdc_disable_table
@source_schema = N'ZZZZ01',
@source_name   = N'JOBMISC',
@capture_instance = N'ZZZZ01_JOBMISC'
GO

-- Disable change tracking altogether
EXEC sys.sp_cdc_disable_db
GO
