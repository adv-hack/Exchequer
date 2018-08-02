--/////////////////////////////////////////////////////////////////////////////
--// Filename		: DETAILSUpgraderV7.sql
--// Author			: Chris Sandow
--// Date				: 2014-01-06
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the v7.0.8 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2014-01-06:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

-- Create the new indexes
DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[DETAILS]')

IF NOT EXISTS (
	SELECT name FROM sys.indexes
	WHERE object_id = @table_id
	  AND name = 'DETAILS_Index10'
)
BEGIN
	CREATE NONCLUSTERED INDEX DETAILS_Index10 ON [!ActiveSchema!].[DETAILS] ([tlAcCode], [tlFolioNum], [PositionID])
	CREATE NONCLUSTERED INDEX DETAILS_Index11 ON [!ActiveSchema!].[DETAILS] ([tlOurRef], [tlFolioNum], [PositionID])
	CREATE NONCLUSTERED INDEX DETAILS_Index12 ON [!ActiveSchema!].[DETAILS] ([tlYear], [tlPeriod], [tlFolioNum], [PositionID])
END
GO

IF EXISTS (
            SELECT  *
            FROM    sysobjects tab 
            WHERE   (tab.id = object_id('[!ActiveSchema!].EBUSDETL')) 
          )
BEGIN          
  -- Create the new indexes
  DECLARE @table_id INT
  SET @table_id = object_id('[!ActiveSchema!].[EBUSDETL]')
  
  IF NOT EXISTS (
    SELECT name FROM sys.indexes
    WHERE object_id = @table_id
      AND name = 'EBUSDETL_Index10'
  )
  BEGIN
    CREATE NONCLUSTERED INDEX EBUSDETL_Index10 ON [!ActiveSchema!].[EBUSDETL] ([tlAcCode], [tlFolioNum], [PositionID])
    CREATE NONCLUSTERED INDEX EBUSDETL_Index11 ON [!ActiveSchema!].[EBUSDETL] ([tlOurRef], [tlFolioNum], [PositionID])
    CREATE NONCLUSTERED INDEX EBUSDETL_Index12 ON [!ActiveSchema!].[EBUSDETL] ([tlYear], [tlPeriod], [tlFolioNum], [PositionID])
  END
END
GO

-- Now update the Version number for the SchemaVersion table
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 7
WHERE     SchemaName = 'DETAILS_Final.xml' AND Version = 6

SET NOCOUNT OFF

