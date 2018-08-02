--/////////////////////////////////////////////////////////////////////////////
--// Filename		: idx_ClusteredIndexes_ActiveSchema.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add clustered indexes for company-specific tables
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

DECLARE @SchemaTable VARCHAR(max)
      , @SQLString   NVARCHAR(max)

DECLARE curTables CURSOR FOR SELECT SchemaTable = t.TABLE_SCHEMA + '.' + t.TABLE_NAME
                             FROM   INFORMATION_SCHEMA.TABLES t
						     WHERE  t.TABLE_SCHEMA = '!ActiveSchema!'
						     AND    t.TABLE_TYPE   = 'BASE TABLE'
OPEN curTables

FETCH NEXT FROM curTables INTO @SchemaTable

WHILE @@FETCH_STATUS = 0
BEGIN

  -- Is Table a HEAP structure?

  IF EXISTS(SELECT TOP 1 1
            FROM   sys.indexes x
            WHERE  x.object_id = OBJECT_ID(@SchemaTable)
            AND    x.index_id = 0)
  BEGIN
    PRINT @SchemaTable + ' is a HEAP'

	-- Does table have an 'Identity' Index

	IF EXISTS(SELECT TOP 1 1
	          FROM   sys.indexes x
			  WHERE  x.object_id = OBJECT_ID(@SchemaTable)
			  AND    x.name LIKE '%_Identity%')
	BEGIN
	  -- Get Index Name
	  DECLARE @IndexName VARCHAR(max)

	  SELECT @IndexName = x.name
      FROM   sys.indexes x
      WHERE  x.object_id = OBJECT_ID(@SchemaTable)
	  AND    x.name LIKE '%_Identity%'
	  
	  -- Drop Index

	  SET @SQLString = 'DROP INDEX ' + @IndexName + ' ON ' + @SchemaTable

	  PRINT @SQLString
	  EXEC sp_executesql @SQLString

	  SET @SQLString = 'CREATE UNIQUE CLUSTERED INDEX [' + @IndexName + ']
                        ON ' + @SchemaTable + '([PositionId] ASC) WITH (FILLFACTOR = 90, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
                        ON [PRIMARY];'

	  PRINT @SQLString
	  EXEC sp_executesql @SQLString
	END
  END

  -- Get Next Table
  FETCH NEXT FROM curTables INTO @SchemaTable
END

CLOSE curTables
DEALLOCATE curTables
GO

-- Change Clustered Index on DOCUMENT

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') AND name = N'DOCUMENT_Index_Identity')
DROP INDEX [DOCUMENT_Index_Identity] ON [!ActiveSchema!].[DOCUMENT] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[DOCUMENT]') AND name = N'DOCUMENT_IndexCandidate')
DROP INDEX [DOCUMENT_IndexCandidate] ON [!ActiveSchema!].[DOCUMENT] WITH ( ONLINE = OFF )
GO

CREATE UNIQUE CLUSTERED INDEX [DOCUMENT_Index_Identity] ON [!ActiveSchema!].[DOCUMENT] 
(
	[PositionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [DOCUMENT_IndexCandidate] ON [!ActiveSchema!].[DOCUMENT] 
(
	[thFolioNum] ASC,
	[PositionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
