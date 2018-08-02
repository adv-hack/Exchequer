--/////////////////////////////////////////////////////////////////////////////////////////////////////////
--//
--// Filename		: isp_RI_NonClustered.sql
--// Author		: James Waygood
--// Date		: 2013-01-21
--// Copyright Notice	: (c) 2015 Advanced Business Software & Solutions Ltd. All rights reserved.
--// Description	: SQL Script for Disabling or Rebuilding all Non-Clustered Indexes.
--// Execute		: EXEC [common].[isp_RI_NonClustered] 1 -- Rebuild all Indexes with Fill Factor 90
--//			  EXEC [common].[isp_RI_NonClustered] 0 -- Disable all Indexes
--//
--/////////////////////////////////////////////////////////////////////////////////////////////////////////
--//
--// Version History:
--//	1	2013-01-21:	File Creation - James Waygood
--//
--/////////////////////////////////////////////////////////////////////////////////////////////////////////

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[common].[isp_RI_NonClustered]') AND type in (N'P', N'PC'))
DROP PROCEDURE [common].[isp_RI_NonClustered]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [common].[isp_RI_NonClustered]
					(@Rebuild INT)
AS
BEGIN
DECLARE @schemaname sysname
DECLARE @tablename sysname
DECLARE @objectid sysname
DECLARE @indexname sysname

DECLARE tables_cursor CURSOR FOR
   SELECT s.name, t.name, t.object_id
     FROM sys.objects AS t
     JOIN sys.schemas AS s ON s.schema_id = t.schema_id
    WHERE t.type = 'U'

OPEN tables_cursor

   FETCH NEXT FROM tables_cursor
   INTO @schemaname, @tablename, @objectid

   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
   
      IF (SELECT COUNT(*)
            FROM sys.indexes
           WHERE object_id = @objectid
             AND type_desc LIKE 'NONCLUSTERED') > 0
      BEGIN
         
         DECLARE index_cursor CURSOR FOR
         SELECT name AS iname
           FROM sys.indexes
          WHERE object_id = @objectid
            AND type_desc LIKE 'NONCLUSTERED'

         OPEN index_cursor
         
            FETCH NEXT FROM index_cursor
            INTO @indexname

            WHILE (@@FETCH_STATUS <> -1)
            BEGIN
			   IF @Rebuild = 0
					EXEC ('ALTER INDEX [' + @indexname + '] ON [' + @schemaname + '].[' + @tablename + '] DISABLE')
               ELSE
					EXEC ('ALTER INDEX [' + @indexname + '] ON [' + @schemaname + '].[' + @tablename + '] REBUILD WITH (FILLFACTOR = 90)')

               FETCH NEXT FROM index_cursor
               INTO @indexname
               
            END
            
         CLOSE index_cursor
         DEALLOCATE index_cursor
         
      END
      
      FETCH NEXT FROM tables_cursor
      INTO @schemaname, @tablename, @objectid
      
   END

CLOSE tables_cursor
DEALLOCATE tables_cursor
END
GO
