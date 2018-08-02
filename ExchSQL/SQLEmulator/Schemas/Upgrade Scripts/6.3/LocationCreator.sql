--/////////////////////////////////////////////////////////////////////////////
--// Filename		: LocationCreator.sql
--// Author			: Chris Sandow
--// Date				: 9 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	9th February 2010:	File Creation - Chris Sandow
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
              WHERE   (tab.id = object_id('[!ActiveSchema!].Location')) 
            )
  BEGIN
    SELECT CAST(SUBSTRING(varCode1, 2, 3) AS VARCHAR(3)) AS loCode
          ,CAST(RTRIM(REPLACE(SUBSTRING(varCode2, 2, 45), CHAR(0), ' ')) AS VARCHAR(45)) AS loName
          ,PositionId
          ,LoAddr1
          ,LoAddr2
          ,LoAddr3
          ,LoAddr4
          ,LoAddr5
          ,LoTel
          ,LoFax
          ,LoEmail
          ,LoModem
          ,LoContact
          ,LoCurrency
          ,LoArea
          ,LoRep
          ,LoTag
          ,LoNominal1
          ,LoNominal2
          ,LoNominal3
          ,LoNominal4
          ,LoNominal5
          ,LoNominal6
          ,LoNominal7
          ,LoNominal8
          ,LoNominal9
          ,LoNominal10
          ,LoDepartment
          ,LoCostCentre
          ,LoUsePrice
          ,LoUseNom
          ,LoUseCCDep
          ,LoUseSupp
          ,LoUseBinLoc
          ,LoNLineCount
          ,LoUseCPrice
          ,LoUseRPrice
          ,LoWOPWIPGL
          ,LoReturnGL
          ,LoPReturnGL
    INTO [!ActiveSchema!].Location
    FROM [!ActiveSchema!].MLOCSTK
    WHERE (RecPfix = 'C') AND (SubType = 'C')
    -- Create primary index
    CREATE UNIQUE INDEX Location_Index_Identity ON [!ActiveSchema!].Location(PositionId) 
    -- Create other indexes
    CREATE UNIQUE INDEX Location_Index0 ON [!ActiveSchema!].Location(loCode, PositionId)     
    CREATE UNIQUE INDEX Location_Index1 ON [!ActiveSchema!].Location(loName, PositionId)     
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'C') AND (SubType = 'C') 
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

