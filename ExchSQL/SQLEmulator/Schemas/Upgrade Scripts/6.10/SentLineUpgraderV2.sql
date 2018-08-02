--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SentLineUpgraderV2.sql
--// Author			: C Sandow
--// Date				: 13 March 2012
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade SENTLINE for the 6.10 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	2	13 March 2012:	File Creation - C Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

DECLARE @table_id INT
SET @table_id = object_id('[!ActiveSchema!].[SENTLINE]')

-- Check to see if the existing index 3 on SENTLINE is using the LineNumber
-- field.
IF EXISTS
  (
    SELECT idx.name, cols.name
    FROM sys.index_columns icols
    INNER JOIN sys.columns cols ON cols.column_id = icols.column_id
    INNER JOIN sys.indexes idx ON icols.index_id = idx.index_id
    WHERE icols.object_id = @table_id
      AND cols.object_id = @table_id
      AND idx.object_id = @table_id
      AND idx.name = 'SENTLINE_Index3'
      AND cols.name = 'LineNumber'
  )
BEGIN
  -- Drop the existing index, and recreate it using the DummyLineNumber field
	DROP INDEX SENTLINE_Index3 ON [!ActiveSchema!].[SENTLINE]
	CREATE UNIQUE NONCLUSTERED INDEX [SENTLINE_Index3] ON [!ActiveSchema!].[SENTLINE]
	(
		[Prefix] ASC,
		[UserId] ASC,
		[Name] ASC,
		[ID] ASC,
		[DummyLineNumber] ASC,
		[TermChar] ASC,
		[PositionId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

-- Now we update the Version number for the SchemaVersion
UPDATE    [!ActiveSchema!].SchemaVersion
SET       Version = 2
WHERE     SchemaName = 'SentLine_Final.xml' AND Version = 1

SET NOCOUNT OFF

