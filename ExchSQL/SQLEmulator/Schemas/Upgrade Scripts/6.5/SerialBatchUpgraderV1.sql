--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SerialBatchUpgraderV1.sql
--// Author			: Chris Sandow
--// Date				: 11 January 2011
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to upgrade table for the 6.6 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	11 January 2011:	File Creation - Chris Sandow
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

  -- Check whether the index already exists. If not, create it
  IF (SELECT COUNT(sys.indexes.name) FROM sys.indexes INNER JOIN sys.tables ON sys.indexes.object_id = sys.tables.object_id 
  WHERE sys.tables.name = 'SerialBatch' AND SUBSTRING(sys.indexes.name, 1, 18) = 'SerialBatch_Index2') = 0
  BEGIN
    CREATE UNIQUE INDEX SerialBatch_Index2 ON [!ActiveSchema!].SerialBatch(BatchNo, PositionId) 
  END
  
  -- Now we update the Version number in the SchemaVersion table
  UPDATE    [!ActiveSchema!].SchemaVersion
  SET       Version = 1
  WHERE     SchemaName = 'SerialBatch.xml' AND Version = 0
  
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

