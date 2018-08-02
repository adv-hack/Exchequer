-- ===================================================================
-- This script will list the changes that have been captured for the 
-- data in the DOCUMENT table.
--
-- See Start_Tracking_Changes.sql for more information
--
-- CJS 20/04/2011
-- ===================================================================

-- Change this to the correct database
USE EXCH67
GO

-- Enumerate all changes up until now
DECLARE @from_lsn binary(10), @to_lsn binary(10), @end_time datetime
SET @from_lsn = sys.fn_cdc_get_min_lsn('ZZZZ01_DOCUMENT')
SET @end_time = GETDATE()

/*
-- Wait to make sure all changes have been committed
DELAY:
	IF (sys.fn_cdc_map_lsn_to_time(sys.fn_cdc_get_max_lsn()) <= @end_time)
	BEGIN
		WAITFOR DELAY '00:01:00'
		GOTO DELAY
	END
*/	

-- List the changes
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time)
SELECT * FROM cdc.fn_cdc_get_all_changes_ZZZZ01_DOCUMENT(@from_lsn, @to_lsn, N'all')
GO
