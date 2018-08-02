--/////////////////////////////////////////////////////////////////////////////
--// Filename		: CustomerDiscountCreator.sql
--// Author			: Chris Sandow
--// Date				: 12 January 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	12th January 2010:	File Creation - Chris Sandow
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
                WHERE   (tab.id = object_id('[!ActiveSchema!].CustomerDiscount'))
              )
    BEGIN
      SELECT
         PositionId
        ,CAST(SUBSTRING(exstchkvar1, 2, 6) AS VARCHAR(6)) AS CustCode
        ,CAST(SUBSTRING(exstchkvar1, 8, 16) AS VARCHAR(16)) AS StockCode
        ,CAST(SUBSTRING(exstchkvar1, 24, 1) AS INTEGER) AS Currency
        ,CustQBType AS DiscountType
        ,CustQSPrice AS Price
        ,CustQBand AS Band
        ,CustQDiscP AS DiscountP
        ,CustQDiscA AS DiscountA
        ,CustQMUMG AS Markup
        ,CUseDates AS UseDates
        ,CStartD AS StartDate
        ,CEndD AS EndDate
        ,QtyBreakFolio
      INTO [!ActiveSchema!].CustomerDiscount
      FROM [!ActiveSchema!].EXSTKCHK
      WHERE (RecMfix = 'C') AND (SubType = 'C')
      -- Create primary index
      CREATE UNIQUE INDEX CustomerDiscount_Index_Identity ON [!ActiveSchema!].CustomerDiscount(PositionId);
      -- Create other indexes
      CREATE UNIQUE INDEX CustomerDiscount_Index0 ON [!ActiveSchema!].CustomerDiscount(CustCode, StockCode, Currency, PositionId);
      CREATE UNIQUE INDEX CustomerDiscount_Index1 ON [!ActiveSchema!].CustomerDiscount(StockCode, PositionId);
      -- Delete the original records
      DELETE FROM [!ActiveSchema!].EXSTKCHK WHERE (RecMfix = 'C') AND (SubType = 'C');
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

