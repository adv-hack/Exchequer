--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DETAILSUpgraderV8.sql
--// Author			: Chris Sandow
--// Date				: 2014-02-14
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the v7.0.9 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2014-02-14:	File Creation - Chris Sandow
--//  2 2014-03-12: Added corrections to v7.0.8 indexes - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- First we check to see if the new column already exists in the table. This is
-- because all the upgrade scripts are run every time the system is upgraded,
-- so we must be careful not to try to make amendments which have already been
-- done.
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].DETAILS'))
                 AND   (col.name = 'tlMaterialsOnlyRetention')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].DETAILS
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlMaterialsOnlyRetention bit NOT NULL DEFAULT 0
END
GO

-- Check for the v7.0.8 indexes and remove them if found
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[DETAILS]')

IF EXISTS (
  SELECT name FROM sys.indexes
  WHERE object_id = @table_id
    AND name = 'DETAILS_Index10'
)
BEGIN
  DROP INDEX
      DETAILS_Index10 ON [!ActiveSchema!].DETAILS,
      DETAILS_Index11 ON [!ActiveSchema!].DETAILS,
      DETAILS_Index12 ON [!ActiveSchema!].DETAILS;
END
GO

-- Create the new versions of the indexes
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[DETAILS]')

IF NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'DETAILS_Index10'
)
BEGIN
	CREATE NONCLUSTERED INDEX DETAILS_Index10 ON [!ActiveSchema!].[DETAILS] ([tlAcCode], [tlOurRef], [PositionID])
	CREATE NONCLUSTERED INDEX DETAILS_Index11 ON [!ActiveSchema!].[DETAILS] ([tlOurRef], [PositionID])
	CREATE NONCLUSTERED INDEX DETAILS_Index12 ON [!ActiveSchema!].[DETAILS] ([tlYear], [tlPeriod], [tlOurRef], [PositionID])
END
GO

--/////////////////////////////////////////////////////////////////////////////
-- The EBUSDETL table duplicates the structure of the DETAILS table, so it must
-- be updated to match
--/////////////////////////////////////////////////////////////////////////////
IF EXISTS (
            SELECT *
            FROM   sysobjects tab
            WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
          )
   AND
   NOT EXISTS (
                SELECT *
                FROM   sysobjects tab INNER JOIN
                       syscolumns col ON tab.id = col.id
                WHERE  (tab.id = object_id('[!ActiveSchema!].EBUSDETL'))
                 AND   (col.name = 'tlMaterialsOnlyRetention')
              )
BEGIN
  ALTER TABLE [!ActiveSchema!].EBUSDETL
  ADD
    -- Fields which are in the <fixedfields> section of the XML schema MUST
    -- be specified as NOT NULL, with a DEFAULT.
    --
    -- Fields which are in the <recordtype> sections of the XML schema MUST be
    -- specified as NULL (to allow null values).
    tlMaterialsOnlyRetention bit NOT NULL DEFAULT 0

	-- Check for the v7.0.8 indexes and remove them if found
	DECLARE @table_id INT
	SET @table_id = object_id('[!ActiveSchema!].[EBUSDETL]')

	IF EXISTS (
	  SELECT name FROM sys.indexes
	  WHERE object_id = @table_id
		AND name = 'EBUSDETL_Index10'
	)
	BEGIN
	  DROP INDEX
		  EBUSDETL_Index10 ON [!ActiveSchema!].EBUSDETL,
		  EBUSDETL_Index11 ON [!ActiveSchema!].EBUSDETL,
		  EBUSDETL_Index12 ON [!ActiveSchema!].EBUSDETL;
	END

	-- Create the new versions of the indexes
	IF NOT EXISTS (
		SELECT name FROM sys.indexes
		WHERE object_id = @table_id
		  AND name = 'EBUSDETL_Index10'
	)
	BEGIN
		CREATE NONCLUSTERED INDEX EBUSDETL_Index10 ON [!ActiveSchema!].[EBUSDETL] ([tlAcCode], [tlOurRef], [PositionID])
		CREATE NONCLUSTERED INDEX EBUSDETL_Index11 ON [!ActiveSchema!].[EBUSDETL] ([tlOurRef], [PositionID])
		CREATE NONCLUSTERED INDEX EBUSDETL_Index12 ON [!ActiveSchema!].[EBUSDETL] ([tlYear], [tlPeriod], [tlOurRef], [PositionID])
	END

END
GO

--/////////////////////////////////////////////////////////////////////////////
-- Update the Version number for the SchemaVersion table
--/////////////////////////////////////////////////////////////////////////////
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 8
WHERE     SchemaName = 'DETAILS_Final.xml' AND Version = 7

SET NOCOUNT OFF

