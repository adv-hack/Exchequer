IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostTransactionDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostTransactionDetail
GO

CREATE PROCEDURE !ActiveSchema!.esp_PostTransactionDetail ( @itvp_PostLineTransactions common.edt_Integer READONLY
                                                  , @iv_RunNo           INT
                                                  , @iv_SeparateControl BIT
                                                  )
AS
BEGIN

  SET NOCOUNT ON;

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_UseSeparateDiscounts          BIT
        , @ss_UseCompanyRate                BIT
        , @ss_UseDailyRate                  BIT
        , @ss_UseSalesReceiptPayInReference BIT
        , @ss_VATScheme                     VARCHAR(1)
        , @ss_StockEnabled                  BIT = @c_False
        , @ss_SPOPEnabled                   BIT = @c_False
        , @ss_CommitmentAccountingEnabled   BIT = @c_False
        , @ss_JobCostingEnabled             BIT = @c_False
        , @ss_LiveStockCOSValuation         BIT = @c_False

  -- Set up System Settings
  
  SELECT @ss_UseSeparateDiscounts          = SS.UseSeparateDiscounts
       , @ss_UseCompanyRate                = SS.UseCompanyRate
       , @ss_UseDailyRate                  = SS.UseDailyRate
       , @ss_UseSalesReceiptPayInReference = SS.UseSalesReceiptPayInReference
       , @ss_LiveStockCOSValuation         = SS.LiveStockCOSValuation

  FROM   !ActiveSchema!.evw_SystemSettings SS
  

  -- Set up VAT System Settings
  SELECT @ss_VATScheme           = VATScheme
  FROM   !ActiveSchema!.evw_VATSystemSettings

  -- Determine whether Stock is enabled
  SELECT @ss_StockEnabled   = ISNULL((SELECT TOP 1 Enabled = @c_True
                                      FROM common.etb_Information CI
                                      WHERE CI.InformationName IN ('Stock', 'Full Stock') 
                                      AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)

  -- Determine whether SPOP is enabled
  SELECT @ss_SPOPEnabled    = ISNULL((SELECT TOP 1 Enabled = @c_True
                                      FROM common.etb_Information CI
                                      WHERE CI.InformationName IN ('Sales/Purchase Order Processing') 
                                      AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)

  -- Determine whether SPOP is enabled
  SELECT @ss_commitmentAccountingEnabled    = ISNULL((SELECT TOP 1 Enabled = @c_True 
                                                      FROM common.etb_Information CI
                                                      WHERE CI.InformationName IN ('Commitment Accounting') 
                                                      AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)

  -- Determine whether Job Costing is enabled
  SELECT @ss_JobCostingEnabled    = ISNULL((SELECT TOP 1 Enabled = @c_True 
                                            FROM common.etb_Information CI
                                            WHERE CI.InformationName IN ('Job Costing') 
                                            AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)


  EXEC !ActiveSchema!.esp_PostCCDeptNominalBalances @itvp_PostLineTransactions = @itvp_PostLineTransactions
                                                  , @iv_IsControl              = @c_False
  
  IF  @ss_SPOPEnabled                 = @c_True 
  AND @ss_CommitmentAccountingEnabled = @c_True
  BEGIN
    EXEC !ActiveSchema!.esp_PostLiveCommitments @itvp_PostLineTransactions = @itvp_PostLineTransactions
  END

  -- Post to VAT History
  IF @ss_VATScheme <> 'C'
  BEGIN

    EXEC !ActiveSchema!.esp_PostVATDetail @itvp_PostLineTransactions = @itvp_PostLineTransactions

  END -- VAT Scheme <> C

  IF @ss_StockEnabled = @c_True
  BEGIN
    
    EXEC !ActiveSchema!.esp_PostStock @itvp_PostLineTransactions = @itvp_PostLineTransactions
                              , @iv_RunNo                  = @iv_RunNo

    -- Create Stock Valuation control Entries
    IF @ss_LiveStockCOSValuation = @c_True
    BEGIN
      EXEC !ActiveSchema!.esp_CreateStockValuationControl @itvp_PostLineTransactions = @itvp_PostLineTransactions
                                                        , @iv_RunNo                  = @iv_RunNo
                                                        , @iv_SeparateControl        = @iv_SeparateControl
    END

  END -- if using stock


  -- Pay In Control Entries

  DECLARE @PayInLineTransactions common.edt_Integer

  INSERT INTO @PayInLineTransactions
  SELECT LinePositionId
  FROM   !ActiveSchema!.evw_TransactionLine DTL (READUNCOMMITTED)
  WHERE EXISTS (SELECT TOP 1 1
                FROM @itvp_PostLineTransactions PLT
                WHERE PLT.IntegerValue = DTL.LinePositionId)
  AND   DTL.IsPayInLine = @c_True

  IF @ss_UseSalesReceiptPayInReference = @c_True
  AND EXISTS ( SELECT TOP 1 1
               FROM @PayInLineTransactions PILT
             )
  BEGIN
    EXEC !ActiveSchema!.esp_CreatePayInControl @itvp_PayInLineTransactions = @PayInLineTransactions
  END

  -- Job Costing Uplift Control Entries

  DECLARE @JobCostingUpliftTransactions common.edt_Integer

  INSERT INTO @JobCostingUpliftTransactions
  SELECT DTL.PositionId
  FROM   !ActiveSchema!.DETAILS         DTL (READUNCOMMITTED)
  JOIN   !ActiveSchema!.evw_Job         JOB ON DTL.tlJobCode = JOB.JobCode
  JOIN   !ActiveSchema!.evw_JobActual  JACT ON DTL.tlJobCode = JACT.JobCode
                                  AND DTL.tlFolioNum  = JACT.TransactionLineFolio
                                  AND DTL.tlABSLineNo = JACT.TransactionLineNumber

  WHERE  JOB.JobStat < 4           -- < Job Complete
  AND    JACT.UpliftTotal <> 0
  AND    EXISTS (SELECT TOP 1 1
                 FROM @itvp_PostLineTransactions PLT
                 WHERE PLT.IntegerValue = DTL.PositionId)

  IF @ss_JobCostingEnabled = @c_True
  AND EXISTS (SELECT TOP 1 1
              FROM @JobCostingUpliftTransactions)
  BEGIN
    EXEC !ActiveSchema!.esp_CreateJCUpliftControl @itvp_PostJobCostUpliftTransactions = @JobCostingUpliftTransactions
                              , @iv_RunNo                  = @iv_RunNo
                              , @iv_SeparateControl        = @iv_SeparateControl
  END

    -- Update the Transaction Lines

  IF OBJECT_ID('tempdb..#LNVIBData') IS NOT NULL
    DROP TABLE #LNVIBData

  SELECT LinePositionId
       , LineNetValueInBase = LineNetValueInBase --* TransactionTypeSign
                            * CASE
                              WHEN TransactionTypeCode = 'NOM' THEN -1
                              ELSE 1
                              END
  INTO #LNVIBData
  FROM [!ActiveSchema!].evw_TransactionLine DTL (READUNCOMMITTED)
  WHERE EXISTS (SELECT TOP 1 1
                FROM @itvp_PostLineTransactions PLT
                WHERE PLT.IntegerValue = DTL.LinePositionId)


  IF OBJECT_ID('tempdb..#PostDETAIL') IS NOT NULL
    DROP TABLE #PostDETAIL

  SELECT DTL.PositionId
       , tlOurRef
       , tlABSLineNo
       , tlGLCode
       , tlCurrency
       , tlYear
       , tlReconciliationDate = CASE
                                WHEN LTRIM(RTRIM(tlReconciliationDate)) = '' THEN CASE
                                                                                  WHEN DTL.tlRecStatus = 1 THEN @c_Today COLLATE SQL_Latin1_General_CP437_BIN
                                                                                  ELSE @c_MaxDate COLLATE SQL_Latin1_General_CP437_BIN
                                                                                  END
                                ELSE DTL.tlReconciliationDate
                                END
       , tlLineDate           = CASE
                                WHEN DTL.tlSOPFolioNum = 0 AND DTL.tlSOPABSLineNo = 0 THEN DOC.thTransDate COLLATE SQL_Latin1_General_CP437_BIN
                                ELSE DTL.tlLineDate
                                END
       , tlCompanyRate        = CASE
                                WHEN @ss_UseCompanyRate = @c_True AND DTL.tlCompanyRate = 0 AND DOC.thCompanyRate <> 0 THEN DOC.thCompanyRate
                                WHEN @ss_UseCompanyRate = @c_True AND DTL.tlCompanyRate = 0 AND DOC.thDailyRate   <> 0 THEN DOC.thDailyRate
                                WHEN DTL.tlCompanyRate = 0 THEN [common].efn_ConvertToReal48(C.CompanyRate)
                                ELSE DTL.tlCompanyRate
                                END
       , tlDailyRate          = CASE
                                WHEN @ss_UseDailyRate = @c_True AND DTL.tlDailyRate = 0 AND DOC.thDailyRate <> 0 THEN DOC.thDailyRate
                                WHEN @ss_UseDailyRate = @c_True AND DTL.tlDailyRate = 0 AND DOC.thCompanyRate <> 0 THEN DOC.thCompanyRate
                                WHEN DTL.tlDailyRate = 0 THEN [common].efn_ConvertToReal48(C.DailyRate)
                                ELSE DTL.tlDailyRate
                                END
       , tlCOSDailyRate       = CASE
                                WHEN DTL.tlCOSDailyRate IN (0, 1)
                                THEN CASE
                                     WHEN @ss_UseCompanyRate = @c_False THEN DTL.tlDailyRate
                                     ELSE DTL.tlCompanyRate
                                     END
                                WHEN CASE
                                     WHEN @ss_UseCompanyRate = @c_False THEN DTL.tlDailyRate
                                     ELSE DTL.tlCompanyRate
                                     END = 0
                                THEN CASE
                                     WHEN @ss_UseCompanyRate = @c_False THEN DOC.thDailyRate
                                     ELSE DOC.thCompanyRate
                                     END
                                ELSE DTL.tlCOSDailyRate
                                END
       , tlRunNo              = CASE
                                WHEN DOC.thRunNo < 0 THEN 0
                                ELSE @iv_RunNo
                                END
       , LineNetValueInBase   = ISNULL(LNVIB.LineNetValueInBase, 0)
       , tlPreviousBalance    = CONVERT(FLOAT, 0)

       -- The RowNo is descending because, at this point, everything has been posted 
       -- and we neeed to reverse everything to calculate the correct prev. balance.

       , RowNo                = ROW_NUMBER() OVER (ORDER BY DOC.thRunNo
                                                          , LEFT(DOC.thOurRef, 1) DESC
                                                          , DOC.thFolioNum DESC
                                                          , DOC.PositionId DESC
                                                          , DTL.tlFolioNum DESC
                                                          , DTL.tlLineNo   DESC
                                                          , DTL.PositionId DESC
                                                  )

  INTO #PostDETAIL 
  FROM !ActiveSchema!.DETAILS  DTL (READUNCOMMITTED)
  JOIN #LNVIBData            LNVIB ON LNVIB.LinePositionId = DTL.PositionId
  JOIN !ActiveSchema!.DOCUMENT DOC (READUNCOMMITTED) ON DTL.tlFolioNum = DOC.thFolioNum
  JOIN !ActiveSchema!.CURRENCY C ON DTL.tlCurrency = C.CurrencyCode

  WHERE EXISTS (SELECT TOP 1 1
                FROM @itvp_PostLineTransactions PLT
                WHERE PLT.IntegerValue = DTL.PositionId)
  
  -- Update Prev Bal

  UPDATE PD
     SET tlPreviousBalance = ISNULL(PB.BalanceAmount, 0) + ISNULL(RT.NetValueRunningTotal, 0)
  FROM #PostDETAIL PD
  OUTER APPLY ( SELECT BalanceAmount
                FROM   !ActiveSchema!.evw_NominalHistory (READUNCOMMITTED) PBal
                WHERE  PBal.HistoryCode               = common.efn_CreateNominalHistoryCode(PD.tlGLCode, NULL, NULL, NULL, @c_False)
                AND    PBal.CurrencyCode              = @c_BaseCurrencyId
                AND    PBAL.HistoryClassificationId IN (65,66,67)
                AND    PBAL.ExchequerYear             = PD.tlYear
                AND    PBal.HistoryPeriod             = CASE
                                                        WHEN PBal.HistoryClassificationId = 65 THEN @c_YTDPeriod
                                                        ELSE @c_CTDPeriod
                                                        END
              ) PB

  OUTER APPLY ( SELECT NetValueRunningTotal = SUM(DRT.LineNetValueInBase)
                FROM #PostDetail DRT 
                WHERE DRT.tlGLCode  = PD.tlGLCode
                AND   DRT.RowNo    <= PD.RowNo
              ) RT

--SELECT * FROM #PostDETAIL 

  UPDATE DTL
     SET tlReconciliationDate = PD.tlReconciliationDate
       , tlLineDate           = PD.tlLineDate
       , tlCompanyRate        = PD.tlCompanyRate
       , tlDailyRate          = PD.tlDailyRate
       , tlCOSDailyRate       = PD.tlCOSDailyRate
       , tlRunNo              = PD.tlRunNo
       , tlPreviousBalance    = PD.tlPreviousBalance
  FROM   !ActiveSchema!.DETAILS DTL
  JOIN   #PostDETAIL PD ON PD.PositionId = DTL.PositionId

END
GO
