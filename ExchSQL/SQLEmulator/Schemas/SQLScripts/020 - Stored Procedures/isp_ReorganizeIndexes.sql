--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_ReorganizeIndexes.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_ReorganizeIndexes stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [Common].[isp_ReorganizeIndexes]    Script Date: 11/20/2006 13:19:24 ******/

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[isp_ReorganizeIndexes]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [Common].[isp_ReorganizeIndexes]
END
GO
-- Stored Procedure to Reorganize the Indexes of a given database.

CREATE PROCEDURE Common.isp_ReorganizeIndexes
AS
BEGIN
  DECLARE @SQLString   NVARCHAR(1000)
        , @SQLVersion  NVARCHAR(10)
        , @TableName   NVARCHAR(100)
        , @ReturnValue INT

  PRINT ''
  PRINT 'Index Reorganize starting at: ' + CONVERT(NVARCHAR, GETDATE(), 113)

  -- Get current SQL compatibility level as commands differ for each version

  SELECT @SQLVersion = cmptlevel
  FROM   master..sysdatabases
  WHERE  name = DB_NAME()

  -- Declare a READ-ONLY cursor to go through each table in Database

  DECLARE CurDatabaseTables CURSOR FOR
          SELECT TABLE_NAME = TABLE_SCHEMA + '.' + TABLE_NAME
          FROM   INFORMATION_SCHEMA.tables
          WHERE  TABLE_TYPE   = 'BASE TABLE'   -- User Tables
 --         AND    TABLE_SCHEMA = 'common'       -- common schema (was dbo schema previously)
          ORDER BY TABLE_NAME
          FOR READ ONLY

  OPEN CurDatabaseTables

  FETCH NEXT FROM CurDatabaseTables INTO @TableName

  WHILE @@fetch_status = 0
  BEGIN

    IF @SQLVersion = '90'
    BEGIN
      SELECT @SQLString = 'ALTER INDEX ALL ON ' + @TableName + ' REORGANIZE'
    END
    ELSE
    BEGIN
      SELECT @SQLString = 'DBCC INDEXDEFRAG( 0,''' + @TableName + ''')'
    END

    RAISERROR('Reorganize Indexes on: %s', 1, 1, @TableName)

    EXECUTE @ReturnValue = sp_executesql @SQLString

    IF @ReturnValue <> 0
    BEGIN
      RAISERROR('There is a problem Reorganizing Index on: %s', 1, 1, @TableName)
    END

    RAISERROR ('Finished reorganizing Indexes on: %s', 1, 1, @TableName)

    FETCH NEXT FROM CurDatabaseTables INTO @TableName
  END

  CLOSE CurDatabaseTables
  DEALLOCATE CurDatabaseTables

  PRINT 'Index Reorganize Complete at: ' + CONVERT(NVARCHAR, GETDATE(), 113)

END
