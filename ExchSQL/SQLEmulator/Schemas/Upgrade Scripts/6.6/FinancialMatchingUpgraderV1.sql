--/////////////////////////////////////////////////////////////////////////////
--// Filename		: FinancialMatchingUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 12 January 2011
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12 January 2011:	File Creation - Chris Sandow
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

  -- Check whether the erroneously-named indexes exist, and drop them.
  DECLARE @RecreateIndexes BIT
  SET @RecreateIndexes = 0
  IF (SELECT COUNT(sys.indexes.name) FROM sys.indexes INNER JOIN sys.tables ON sys.indexes.object_id = sys.tables.object_id 
  WHERE sys.tables.name = 'FinancialMatching' AND SUBSTRING(sys.indexes.name, 1, 15) = 'TransactionNote') > 0
  BEGIN
    SELECT @RecreateIndexes = 1
    DROP INDEX TransactionNote_Index0 ON [!ActiveSchema!].FinancialMatching
    DROP INDEX TransactionNote_Index1 ON [!ActiveSchema!].FinancialMatching
  END
  
  IF (@RecreateIndexes = 1)
  BEGIN
    CREATE UNIQUE INDEX FinancialMatching_Index0 ON [!ActiveSchema!].FinancialMatching(DocRef, PositionId);
    CREATE UNIQUE INDEX FinancialMatching_Index1 ON [!ActiveSchema!].FinancialMatching(PayRef, PositionId);
  END
  
  -- Now we update the Version number in the SchemaVersion table
  UPDATE    [!ActiveSchema!].SchemaVersion
  SET       Version = 1
  WHERE     SchemaName = 'FinancialMatching.xml' AND Version = 0
  
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

