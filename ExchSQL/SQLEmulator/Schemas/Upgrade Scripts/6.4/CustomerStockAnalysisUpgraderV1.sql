--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustomerStockAnalysisUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 2 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.4 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	21st October 2010:	File Creation - Chris Sandow
--//
--/////////////////////////////////////////////////////////////////////////////

SET NOCOUNT ON

BEGIN TRY
  DECLARE @ErrorMessage   NVARCHAR(1000)
        , @DisplayMessage NVARCHAR(1000)
        , @ErrorNumber    INT
        , @ErrorSeverity  INT
        , @ErrorState     INT
        , @ErrorLine      INT
        , @ErrorProcedure NVARCHAR(400)
        , @ReturnValue    INT

  -- Check whether the erroneously-named indexes exist, and drop them. Otherwise
  -- drop the correctly-named index.
  DECLARE @RecreateAllIndexes BIT
  DECLARE @HasIndex1 BIT
  SET @RecreateAllIndexes = 0
  SET @HasIndex1 = 0
  IF (SELECT COUNT(sys.indexes.name) FROM sys.indexes INNER JOIN sys.tables ON sys.indexes.object_id = sys.tables.object_id 
  WHERE sys.tables.name = 'CustomerStockAnalysis' AND SUBSTRING(sys.indexes.name, 1,16) = 'CustomerDiscount') > 0
  BEGIN
    SELECT @RecreateAllIndexes = 1
    DROP INDEX CustomerDiscount_Index_Identity ON [!ActiveSchema!].CustomerStockAnalysis
    DROP INDEX CustomerDiscount_Index0 ON [!ActiveSchema!].CustomerStockAnalysis
    DROP INDEX CustomerDiscount_Index1 ON [!ActiveSchema!].CustomerStockAnalysis
    DROP INDEX CustomerDiscount_Index2 ON [!ActiveSchema!].CustomerStockAnalysis
  END
  ELSE
  BEGIN
    DROP INDEX CustomerStockAnalysis_Index1 ON [!ActiveSchema!].CustomerStockAnalysis
  END
  
  -- Update the column size
  IF NOT((SELECT COLUMNPROPERTY( OBJECT_ID('[!ActiveSchema!].CustomerStockAnalysis'), 'csIndex', 'PRECISION') AS COL_LENGTH) = 27)
  BEGIN
    ALTER TABLE [!ActiveSchema!].CustomerStockAnalysis DROP COLUMN CsIndexComputed
    ALTER TABLE [!ActiveSchema!].CustomerStockAnalysis ALTER COLUMN CsIndex varbinary(27)
    ALTER TABLE [!ActiveSchema!].CustomerStockAnalysis ADD CsIndexComputed AS (substring([CsIndex],(2),(26)))
    CREATE UNIQUE INDEX CustomerStockAnalysis_Index1 ON [!ActiveSchema!].CustomerStockAnalysis(CsIndexComputed, PositionId);
    SELECT @HasIndex1 = 1
  END
  
  IF (@RecreateAllIndexes = 1)
  BEGIN
    -- Create primary index
    CREATE UNIQUE INDEX CustomerStockAnalysis_Index_Identity ON [!ActiveSchema!].CustomerStockAnalysis(PositionId);
    -- Create other indexes
    CREATE UNIQUE INDEX CustomerStockAnalysis_Index0 ON [!ActiveSchema!].CustomerStockAnalysis(CsCustCode, CsLineNo, PositionId);
    IF (@HasIndex1 = 0)
    BEGIN
        CREATE UNIQUE INDEX CustomerStockAnalysis_Index1 ON [!ActiveSchema!].CustomerStockAnalysis(CsIndexComputed, PositionId);
    END
    CREATE UNIQUE INDEX CustomerStockAnalysis_Index2 ON [!ActiveSchema!].CustomerStockAnalysis(CsStockCode, CsCustCode, PositionId);
  END
  
  -- Now we update the Version number in the SchemaVersion table
  UPDATE    [!ActiveSchema!].SchemaVersion
  SET       Version = 1
  WHERE     SchemaName = 'CustomerStockAnalysis.xml' AND Version = 0
  
END TRY
BEGIN CATCH
  -- Assign variables to error-handling functions to 
  -- capture information for RAISERROR.

  SELECT @ErrorNumber    = ISNULL(ERROR_NUMBER(), -1)
       , @ErrorSeverity  = ISNULL(ERROR_SEVERITY(), 1)
       , @ErrorState     = ISNULL(ERROR_STATE(), 1)
       , @ErrorLine      = ISNULL(ERROR_LINE(), 1)
       , @ErrorMessage   = ISNULL(ERROR_MESSAGE(), '')
       , @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '')

  -- parameter of RAISERROR.
  RAISERROR (   @ErrorMessage
              , @ErrorSeverity 
              , 1
              , @ErrorNumber    -- parameter: original error number.
              , @ErrorSeverity  -- parameter: original error severity.
              , @ErrorState     -- parameter: original error state.
              , @ErrorProcedure -- parameter: original error procedure name.
              , @ErrorLine       -- parameter: original error line number.
            )   WITH NOWAIT

END CATCH

SET NOCOUNT OFF

