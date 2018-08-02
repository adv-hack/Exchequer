--/////////////////////////////////////////////////////////////////////////////
--// Filename		: FiFoCreator.sql
--// Author			: Chris Sandow
--// Date				: 2 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	2nd February 2010:	File Creation - Chris Sandow
--//  2 20th May 2010: Added TRY...CATCH - Chris Sandow
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

  -- Check that table does not already exist.
  IF NOT EXISTS (
              SELECT  *
              FROM    sysobjects tab 
              WHERE   (tab.id = object_id('[!ActiveSchema!].FiFo')) 
            )
  BEGIN
    SELECT [PositionId]
          ,[FIFOStkFolio]
          ,[DocABSNo] AS FIFODocAbsNo
          ,[FIFODate] 
          ,[QtyLeft] AS FIFOQtyLeft
          ,[DocRef] AS FIFODocRef
          ,[FIFOQty]
          ,[FIFOCost]
          ,[FIFOCurr]
          ,[FIFOCust]
          ,[FIFOMLoc]
          ,[FIFOCompanyRate]
          ,[FIFODailyRate]
          ,[FUseORate] AS FIFOUseORate
          ,[FIFOTriRates]
          ,[FIFOTriEuro]
          ,[FIFOTriInvert]
          ,[FIFOTriFloat]
          ,[FIFOTtriSpare] AS FIFOTriSpare
      INTO [!ActiveSchema!].FiFo
      FROM [!ActiveSchema!].EXSTKCHK
      WHERE RecMfix = 'F' AND SubType = 'S'
    -- Create primary index
    CREATE UNIQUE INDEX FiFo_Index_Identity ON [!ActiveSchema!].FiFo(PositionId);
    -- Create other indexes
    CREATE UNIQUE INDEX FiFo_Index0 ON [!ActiveSchema!].FiFo(FIFOStkFolio, FIFODate, PositionId);
    CREATE UNIQUE INDEX FiFo_Index1 ON [!ActiveSchema!].FiFo(FIFODocRef, FIFOStkFolio, FIFODocAbsNo, PositionId);
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'F') AND (SubType = 'S');
  END
  
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

