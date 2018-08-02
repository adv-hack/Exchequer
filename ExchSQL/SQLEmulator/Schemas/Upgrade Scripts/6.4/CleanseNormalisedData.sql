--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CleanseNormalisedData.sql
--// Author			: Chris Sandow
--// Date				: 8 July 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create remove redundant data
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	8th July 2010:	File Creation - Chris Sandow
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

  -- Delete the original Allocation Wizard Session records
  DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'X') AND (SubType = 'C') 
  
  -- Delete the original Analysis Code Budget records
  DELETE FROM [!ActiveSchema!].JOBCTRL WHERE (RecPfix = 'J') AND (SubType = 'B')
  
  -- Delete the original Customer Discount records
  DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'C') AND (SubType = 'C')
  
  -- Delete the original Customer Stock Analysis records
  DELETE FROM [!ActiveSchema!].MLOCSTK WHERE (RecPfix = 'T') AND (SubType = 'P');
  
  -- Delete the original FiFo records
  DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'F') AND (SubType = 'S');
  
  -- Delete the original Financial Matching records
  DELETE FROM [!ActiveSchema!].EXCHQCHK WHERE (RecPFix = 'T') AND (SubType = ASCII('P'));
  
  -- Delete the original Job Totals Budget records
  DELETE FROM [!ActiveSchema!].JOBCTRL WHERE (RecPfix = 'J') AND (SubType = 'M')
  
  -- Delete the original Location records
  DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'C') AND (SubType = 'C')
  
  -- Delete the original Serial Batch records
  DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'F') AND (SubType = 'R');
  
  -- Delete the original Stock Location records
  DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'C') AND (SubType = 'D')
  
  -- Delete the original Transaction Note records
  DELETE FROM [!ActiveSchema!].EXCHQCHK WHERE (RecPFix = 'N') AND (SubType = ASCII('D'));
  
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
              , @ErrorLine      -- parameter: original error line number.
            )   WITH NOWAIT

END CATCH

SET NOCOUNT OFF
