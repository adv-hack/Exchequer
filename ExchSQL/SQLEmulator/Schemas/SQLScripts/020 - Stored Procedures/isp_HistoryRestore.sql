--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_HistoryRestore.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_HistoryRestore stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[!ActiveSchema!].[isp_HistoryRestore]') 
                                           AND OBJECTPROPERTY(id,N'IsProcedure') = 1 )
  DROP PROCEDURE [!ActiveSchema!].[isp_HistoryRestore];
GO
-- Exec [!ActiveSchema!].isp_HistoryRestore

CREATE PROCEDURE [!ActiveSchema!].[isp_HistoryRestore]
AS
BEGIN
  DECLARE @Schema        VARCHAR(max)
        , @TableName     VARCHAR(max)
		, @ViewName      VARCHAR(max)
		, @ViewLine      VARCHAR(max)
        , @SQLString     VARCHAR(max)
		, @SQLViewCreate VARCHAR(max)
		, @SQLViewDrop   VARCHAR(max)
		, @SQLViewIndex  VARCHAR(max)
  
  SET @Schema    = OBJECT_SCHEMA_NAME(@@PROCID)
  SET @TableName = @Schema + '.HISTPRGE'

  IF NOT EXISTS (SELECT * 
                 FROM   sys.objects 
                 WHERE object_id = OBJECT_ID(@TableName) 
                 AND   type     in (N'U'))
  BEGIN
    RAISERROR('%s table does NOT Exist', 1, 1, @TableName)
    RETURN -1
  END
  
  BEGIN TRY

    SET @TableName = @Schema + '.HISTUP'  

    --Check to see if Backup Table exists, if it does DROP it
    IF EXISTS (SELECT * 
               FROM   sys.objects 
               WHERE object_id = OBJECT_ID(@TableName) 
               AND   type     in (N'U'))
    BEGIN
      SET @SQLString = N'DROP TABLE ' + @TableName
      EXEC (@SQLString)
    END

    -- Script then Remove dependencies on HISTORY table 
	DECLARE @ViewTable TABLE (ViewString VARCHAR(max))
	SET @ViewName      = @Schema + '.HISTORY_All'
	SET @SQLViewCreate = ''
	
	INSERT INTO @ViewTable
	EXEC sp_helptext @ViewName 

	DECLARE curSQL CURSOR FOR
                          SELECT ViewString
                          FROM @ViewTable

    OPEN curSQL

    FETCH NEXT FROM curSQL INTO @ViewLine

    WHILE @@FETCH_STATUS = 0
    BEGIN
      SET @SQLViewCreate = @SQLViewCreate + @ViewLine
      FETCH NEXT FROM curSQL INTO @ViewLine
    END

    CLOSE curSQL
    DEALLOCATE curSQL

	-- Drop View
	SET @SQLViewDrop = 'DROP VIEW ' + @ViewName
	EXEC (@SQLViewDrop)

    -- Rename Current HISTORY Table as a backup in case of problems
    SET @TableName = @Schema + '.HISTORY'
    SET @SQLString = 'EXEC sp_rename N''' + @TableName + ''', N''HISTUP'' '

    EXEC (@SQLString)
  
    -- Rename HISTPRGE to HISTORY
    SET @TableName = @Schema + '.HISTPRGE'
    SET @SQLString = 'EXEC sp_rename N''' + @TableName + ''', N''HISTORY'' '
    
    EXEC (@SQLString)

	-- Recreate View dependency
	EXEC (@SQLViewCreate)

	-- Re-index View
	SET @SQLViewIndex = N'CREATE UNIQUE CLUSTERED INDEX [HISTORY_All_Clustered_Index] ON ' + @ViewName + 
                         '(
                            [hiExClass] ASC,
                            [hiCodeComputed] ASC,
                            [hiCurrency] ASC,
                            [hiYear] ASC,
                            [hiPeriod] ASC
                          ) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]'
    EXEC (@SQLViewIndex)

  END TRY
  BEGIN CATCH
    SELECT ERROR_NUMBER() AS ErrorNumber,
           ERROR_MESSAGE() AS ErrorMessage;
           
    RETURN -1

  END CATCH
  
  RETURN 0 -- Success
END



GO


