--/////////////////////////////////////////////////////////////////////////////
--// Filename		: isp_RebuildIndexes.sql
--// Author		: 
--// Date		: 
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script to add isp_RebuildIndexes stored procedure
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	: File Creation
--//    2   : Updated to fix issue when rebuilding indexes on views
--//
--/////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[isp_RebuildIndexes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [common].[isp_RebuildIndexes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_RebuildIndexes]
AS
BEGIN
	DECLARE @tsql NVARCHAR(MAX)  
	DECLARE @fillfactor INT

	DECLARE @Indexes TABLE(TableName varchar(max))

	INSERT @Indexes
	SELECT distinct '['+Sch.name+'].['+ Tab.[name]+']' AS TableName
	FROM sys.[indexes] Ind
	INNER JOIN sys.[tables] AS Tab
	ON Tab.[object_id] = Ind.[object_id]
	INNER JOIN sys.[schemas] AS Sch
	ON Sch.[schema_id] = Tab.[schema_id]
	ORDER BY TableName

	INSERT @Indexes
	SELECT distinct '['+Sch.name+'].['+ Tab.[name]+']' AS TableName
	FROM sys.[indexes] Ind
	INNER JOIN sys.[views] AS Tab
	ON Tab.[object_id] = Ind.[object_id]
	INNER JOIN sys.[schemas] AS Sch
	ON Sch.[schema_id] = Tab.[schema_id]
	ORDER BY TableName

	SET @fillfactor = 90 
	 
	SELECT @tsql = 
	  STUFF(( SELECT  ';PRINT ''Rebuilding ' + TableName + ''';' + 'ALTER INDEX ALL ON ' + TableName + ' REBUILD WITH (FILLFACTOR = ' + CONVERT(VARCHAR(3),@fillfactor) + ');PRINT ''Finished Rebuilding  '+ TableName+''''
			  FROM @Indexes 
			  FOR XML PATH('')), 1,1,'')
	 
	EXEC sp_executesql @tsql  

	PRINT 'Index Rebuild Complete at: ' + CONVERT(NVARCHAR, GETDATE(), 113)


END

GO

