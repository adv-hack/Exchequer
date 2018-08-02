--/////////////////////////////////////////////////////////////////////////////
--// Filename		: idx_ClusteredIndexes_Common.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add clustered indexes for common tables
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
						     WHERE  t.TABLE_SCHEMA = 'common'
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

-- Add PositionId to common.IRISXMLSchema and create clustered index

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE common.Tmp_IRISXMLSchema
	(
	Name varchar(30) NOT NULL,
	Version int NOT NULL,
	SchemaImage varbinary(MAX) NOT NULL,
	PositionId int NOT NULL IDENTITY (1, 1)
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
--ALTER TABLE common.Tmp_IRISXMLSchema SET (LOCK_ESCALATION = TABLE)
--GO
SET IDENTITY_INSERT common.Tmp_IRISXMLSchema OFF
GO
IF EXISTS(SELECT * FROM common.IRISXMLSchema)
	 EXEC('INSERT INTO common.Tmp_IRISXMLSchema (Name, Version, SchemaImage)
		SELECT Name, Version, CONVERT(varbinary(MAX), SchemaImage) FROM common.IRISXMLSchema WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE common.IRISXMLSchema
GO
EXECUTE sp_rename N'common.Tmp_IRISXMLSchema', N'IRISXMLSchema', 'OBJECT' 
GO
CREATE NONCLUSTERED INDEX idx_IRISXMLSchema ON common.IRISXMLSchema
	(
	Name,
	Version
	) 
	INCLUDE (SchemaImage) WITH ( PAD_INDEX = OFF, FILLFACTOR = 95, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX IRISXMLSchema_Identity ON common.IRISXMLSchema
	(
	PositionId
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
COMMIT