--/////////////////////////////////////////////////////////////////////////////
--// Filename		: AnalysisCodeBudgetCreator.sql
--// Author			: Chris Sandow
--// Date				: 11 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	11th February 2010:	File Creation - Chris Sandow
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
              WHERE   (tab.id = object_id('[!ActiveSchema!].AnalysisCodeBudget')) 
            )
  BEGIN
    SELECT PositionId
          ,AnalCode
          ,HistFolio
          ,JobCode
          ,StockCode
          ,BType
          ,ReCharge
          ,OverCost
          ,UnitPrice
          ,BoQty
          ,BRQty
          ,BoValue
          ,BRValue
          ,CurrBudg
          ,PayRMode
          ,CurrPType
          ,AnalHed
          ,OrigValuation
          ,RevValuation
          ,JBUpliftP
          ,JAPcntApp
          ,JABBasis
          ,JBudgetCurr
    INTO [!ActiveSchema!].AnalysisCodeBudget
    FROM [!ActiveSchema!].JOBCTRL
    WHERE RecPfix = 'J' AND SubType = 'B'
    -- Create primary index
    CREATE UNIQUE INDEX AnalysisCodeBudget_Index_Identity ON [!ActiveSchema!].AnalysisCodeBudget(PositionId) 
    -- Create other indexes
    CREATE UNIQUE INDEX AnalysisCodeBudget_Index0 ON [!ActiveSchema!].AnalysisCodeBudget(JobCode, AnalCode, CurrBudg, PositionId)     
    CREATE UNIQUE INDEX AnalysisCodeBudget_Index1 ON [!ActiveSchema!].AnalysisCodeBudget(JobCode, AnalHed, PositionId)     
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].JOBCTRL WHERE (RecPfix = 'J') AND (SubType = 'B') 
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

