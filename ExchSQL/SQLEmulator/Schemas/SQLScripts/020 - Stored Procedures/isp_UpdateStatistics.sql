--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_UpdateStatistics.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_UpdateStatistics stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

/****** Object:  StoredProcedure [Common].[isp_UpdateStatistics]    Script Date: 11/20/2006 13:19:24 ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[Common].[isp_UpdateStatistics]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
  DROP PROCEDURE [Common].[isp_UpdateStatistics]
END
GO

CREATE PROCEDURE Common.isp_UpdateStatistics
AS
BEGIN
  DECLARE @SQLString   NVARCHAR(1000)
        , @SQLVersion  NVARCHAR(10)
        , @TableName   NVARCHAR(100)
        , @ReturnValue INT


  PRINT ''
  PRINT 'Update Statistics starting at: ' + CONVERT(NVARCHAR, GETDATE(), 113)

  -- Get current SQL compatibility level as commands differ for each version

  SELECT @SQLVersion = cmptlevel
  FROM   master..sysdatabases
  WHERE  name = DB_NAME()

  -- Declare a READ-ONLY cursor to go through each table in Database

  DECLARE CurDatabaseTables CURSOR FOR
          SELECT TABLE_NAME
          FROM   INFORMATION_SCHEMA.tables
          WHERE  TABLE_TYPE   = 'BASE TABLE'   -- User Tables
          AND    TABLE_SCHEMA = 'dbo'          -- dbo schema
          ORDER BY TABLE_NAME
          FOR READ ONLY

  OPEN CurDatabaseTables

  FETCH NEXT FROM CurDatabaseTables INTO @TableName

  WHILE @@fetch_status = 0
  BEGIN

    SELECT @SQLString = 'UPDATE STATISTICS ' + @TableName

    RAISERROR('Started Updating Statistics on : %s', 1, 1, @TableName)

    EXECUTE @ReturnValue = sp_executesql @SQLString

    IF @ReturnValue <> 0
    BEGIN
      RAISERROR('There is a problem Updating Statistics on: %s', 1, 1, @TableName)
    END

    RAISERROR('Finished Updating Statistics on: %s', 1, 1, @TableName)

    FETCH NEXT FROM CurDatabaseTables INTO @TableName
  END

  CLOSE CurDatabaseTables
  DEALLOCATE CurDatabaseTables

  PRINT 'Update Statistics Completed at: ' + CONVERT(NVARCHAR, GETDATE(), 113)

END
