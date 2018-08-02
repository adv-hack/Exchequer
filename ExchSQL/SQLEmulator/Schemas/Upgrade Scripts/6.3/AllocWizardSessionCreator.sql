--/////////////////////////////////////////////////////////////////////////////
--// Filename		: AllocWizardSessionCreator.sql
--// Author			: Chris Sandow
--// Date				: 10 February 2010
--// Copyright Notice	: (c) Advanced Business Software & Solutions Ltd 2015. All rights reserved.
--// Description		: SQL Script to create table for the 6.3 release
--//
--/////////////////////////////////////////////////////////////////////////////
--// Version History:
--//	1	10th February 2010:	File Creation - Chris Sandow
--//  2 20th May 2010: Added TRY...CATCH - Chris Sandow
--//  3 26th August 2015: Added new ArcUsePPD field - Chris Sandow
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
              WHERE   (tab.id = object_id('[!ActiveSchema!].AllocWizardSession'))
            )
  BEGIN
    SELECT CAST(SUBSTRING(varCode1, 2, 1) AS VARCHAR(1)) AS ArcCustSupp
          ,PositionId
          ,ArcBankNom
          ,ArcCtrlNom
          ,ArcPayCurr
          ,ArcInvCurr
          ,ArcDepartment
          ,ArcCostCentre
          ,ArcSortBy
          ,ArcAutoTotal
          ,ArcSDDaysOver
          ,ArcFromTrans
          ,ArcOldYourRef
          ,ArcChequeNo2
          ,ArcForceNew
          ,ArcSort2By
          ,ArcTotalOwn
          ,ArcTransValue
          ,ArcTagCount
          ,ArcTagRunDate
          ,ArcTagRunYr
          ,ArcTagRunPr
          ,ArcSRCPIRef
          ,ArcIncSDisc
          ,ArcTotal
          ,ArcVariance
          ,ArcSettleD
          ,ArcTransDate
          ,ArcUD1
          ,ArcUD2
          ,ArcUD3
          ,ArcUD4
          ,ArcJobCode
          ,ArcAnalCode
          ,ArcDelAddr1 AS ArcPayDetails1
          ,ArcDelAddr2 AS ArcPayDetails2
          ,ArcDelAddr3 AS ArcPayDetails3
          ,ArcDelAddr4 AS ArcPayDetails4
          ,ArcDelAddr5 AS ArcPayDetails5
          ,ArcIncVar
          ,ArcOurRef
          ,ArcCompanyRate
          ,ArcDailyRate
          ,ArcOpoName
          ,ArcStartDate
          ,ArcStartTime
          ,ArcWinLogIn
          ,ArcLocked
          ,ArcSalesMode
          ,ArcCustCode
          ,ArcUseOSNdx
          ,ArcOwnTransValue
          ,ArcOwnSettleD
          ,ArcFinVar
          ,ArcFinSetD
          ,ArcSortD
          ,ArcAllocFull
          ,ArcCheckFail
          ,ArcCharge1GL
          ,ArcCharge2GL
          ,ArcCharge1Amt
          ,ArcCharge2Amt
          ,ArcYourRef
          ,ArcUD5
          ,ArcUD6
          ,ArcUD7
          ,ArcUD8
          ,ArcUD9
          ,ArcUD10
          ,ArcUsePPD
    INTO [!ActiveSchema!].AllocWizardSession
    FROM [!ActiveSchema!].MLOCSTK
    WHERE RecPfix = 'X' AND SubType = 'C'
    -- Create primary index
    CREATE UNIQUE INDEX AllocWizardSession_Index_Identity ON [!ActiveSchema!].AllocWizardSession(PositionId)
    -- Create other indexes
    CREATE UNIQUE INDEX AllocWizardSession_Index0 ON [!ActiveSchema!].AllocWizardSession(ArcCustSupp, ArcCustCode, PositionId)
    -- Delete the original records
    DELETE FROM [!ActiveSchema!].MLocStk WHERE (RecPfix = 'X') AND (SubType = 'C')
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

