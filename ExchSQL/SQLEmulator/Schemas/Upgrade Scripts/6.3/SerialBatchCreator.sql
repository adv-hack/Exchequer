--/////////////////////////////////////////////////////////////////////////////
--// Filename		: SerialBatchCreator.sql
--// Author			: Chris Sandow
--// Date				: 3 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	3rd February 2010:	File Creation - Chris Sandow
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
              WHERE   (tab.id = object_id('[!ActiveSchema!].SerialBatch')) 
            )
  BEGIN
    SELECT CAST(SUBSTRING(exstchkvar2, 2, 20) AS VARCHAR(20)) AS SerialNo
          ,[exstchkvar3] AS BatchNo
          ,[PositionId]
          ,[InDoc]
          ,[OutDoc]
          ,[Sold]
          ,[DateIn]
          ,[SerCost] AS CostPrice
          ,[SerSell] AS SalePrice
          ,[StkFolio] AS StockFolio
          ,[DateOut]
          ,[SoldLine]
          ,[CurCost] AS CostCurrency
          ,[CurSell] AS SaleCurrency
          ,[BuyLine]
          ,[BatchRec]
          ,[BuyQty]
          ,[QtyUsed]
          ,[BatchChild]
          ,[InMLoc]
          ,[OutMLoc]
          ,[SerCompanyRate]
          ,[SerDailyRate]
          ,[InOrdDoc]
          ,[OutOrdDoc]
          ,[InOrdLine]
          ,[OutOrdLine]
          ,[NLineCount]
          ,[NoteFolio]
          ,[DateUseX]
          ,[SUseORate]
          ,[TriRates]
          ,[TriEuro]
          ,[TriInvert]
          ,[TriFloat]
          ,[Spare2]
          ,[ChildNFolio]
          ,[InBinCode]
          ,[ReturnSNo]
          ,[BatchRetQty]
          ,[RetDoc]
          ,[RetDocLine]
    INTO [!ActiveSchema!].SerialBatch
    FROM [!ActiveSchema!].EXSTKCHK
    WHERE RecMfix = 'F' AND SubType = 'R'
    -- Create primary index
    CREATE UNIQUE INDEX SerialBatch_Index_Identity ON [!ActiveSchema!].SerialBatch(PositionId);
    -- Create other indexes
    CREATE UNIQUE INDEX SerialBatch_Index0 ON [!ActiveSchema!].SerialBatch(StockFolio, Sold, SerialNo, PositionId);    
    CREATE UNIQUE INDEX SerialBatch_Index1 ON [!ActiveSchema!].SerialBatch(SerialNo, PositionId);
    CREATE UNIQUE INDEX SerialBatch_Index2 ON [!ActiveSchema!].SerialBatch(BatchNo, PositionId) 
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'F') AND (SubType = 'R');
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
              , @ErrorLine      -- parameter: original error line number.
            )   WITH NOWAIT

END CATCH

SET NOCOUNT OFF

