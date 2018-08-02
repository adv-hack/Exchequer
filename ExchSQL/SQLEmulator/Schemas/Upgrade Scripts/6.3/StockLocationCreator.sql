--/////////////////////////////////////////////////////////////////////////////
--// Filename		: StockLocationCreator.sql
--// Author			: Chris Sandow
--// Date				: 10 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	10th February 2010:	File Creation - Chris Sandow
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
              WHERE   (tab.id = object_id('[!ActiveSchema!].StockLocation')) 
            )
  BEGIN
      SELECT PositionId
            ,LsStkCode
            ,LsStkFolio
            ,LsLocCode
            ,LsQtyInStock
            ,LsQtyOnOrder
            ,LsQtyAlloc
            ,LsQtyPicked
            ,LsQtyMin
            ,LsQtyMax
            ,LsQtyFreeze
            ,LsRoQty
            ,LsRoDate
            ,LsRoDepartment
            ,LsRoCostCentre
            ,LsDepartment
            ,LsCostCentre
            ,LsBinLoc
            ,Currency1
            ,SalesPrice1
            ,Currency2
            ,SalesPrice2
            ,Currency3
            ,SalesPrice3
            ,Currency4
            ,SalesPrice4
            ,Currency5
            ,SalesPrice5
            ,Currency6
            ,SalesPrice6
            ,Currency7
            ,SalesPrice7
            ,Currency8
            ,SalesPrice8
            ,Currency9
            ,SalesPrice9
            ,Currency10
            ,SalesPrice10
            ,LsRoPrice
            ,LsRoCurrency
            ,LsCostPrice
            ,LsPCurrency
            ,LsDefNom1
            ,LsDefNom2
            ,LsDefNom3
            ,LsDefNom4
            ,LsDefNom5
            ,LsDefNom6
            ,LsDefNom7
            ,LsDefNom8
            ,LsDefNom9
            ,LsDefNom10
            ,LsStkFlg
            ,LsMinFlg
            ,LsTempSupp
            ,LsSupplier
            ,LsLastUsed
            ,LsQtyPosted
            ,LsQtyTake
            ,LsROFlg
            ,LsLastTime
            ,LsQtyAllocWOR
            ,LsQtyIssueWOR
            ,LsQtyPickWOR
            ,LsWOPWIPGL
            ,LsSWarranty
            ,LsSWarrantyType
            ,LsMWarranty
            ,LsMWarrantyType
            ,LsQtyPReturn
            ,LsReturnGL
            ,LsReStockPcnt
            ,LsReStockGL
            ,LsBOMDedComp
            ,LsQtyReturn
            ,LsPReturnGL
      INTO [!ActiveSchema!].StockLocation
      FROM [!ActiveSchema!].MLOCSTK
      WHERE RecPfix = 'C' AND SubType = 'D'
      -- Create primary index
      CREATE UNIQUE INDEX StockLocation_Index_Identity ON [!ActiveSchema!].StockLocation(PositionId) 
      -- Create other indexes
      CREATE UNIQUE INDEX StockLocation_Index0 ON [!ActiveSchema!].StockLocation(LsStkCode, LsLocCode, PositionId)     
      CREATE UNIQUE INDEX StockLocation_Index1 ON [!ActiveSchema!].StockLocation(LsLocCode, LsStkCode, PositionId)     
      -- Delete the original records
      DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'C') AND (SubType = 'D') 
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

