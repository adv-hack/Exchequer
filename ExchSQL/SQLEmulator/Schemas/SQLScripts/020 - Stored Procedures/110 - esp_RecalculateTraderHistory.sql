IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateTraderHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateTraderHistory]
GO

--
-- Recalculate Trader History
--
-- To reset an Individual Trader pass in the Trader Code otherwise resets all Traders that require resetting.
--
-- Usage: EXEC !ActiveSchema!.esp_RecalculateTraderHistory 0
--    or: EXEC !ActiveSchema!.esp_RecalculateTraderHistory 0, 'ABAP01'

CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateTraderHistory] ( @iv_Mode INT = 0
                                                                 , @iv_TraderCode VARCHAR(10) = NULL
                                                                 , @iv_TransactionPeriodKey INT = NULL)
AS
BEGIN

-- Modes: 0 - Fix Data
--        1 - Report Data
--        2 - Debug
--        5 - Output Traders Only

  DECLARE @c_Fix            INT = 0
        , @c_Report         INT = 1
        , @c_Debug          INT = 2
        , @c_TraderOnly     INT = 5
        , @c_ProcStartTime  DATETIME = GETDATE()
        , @v_QueryTime      DATETIME = GETDATE()
        , @v_InfoMessage    VARCHAR(1000)
        , @v_ProcMessage    VARCHAR(1000)
        , @v_QueryMessage   VARCHAR(1000)
  
  DECLARE @ss_AuditYear                    INT
        , @ss_UpdateBalanceOnPost          BIT
        , @ss_IncludeVATInCommittedBalance BIT
        , @ss_AgeingMode                   INT

  SET NOCOUNT ON;

  -- Get System Settings
  SELECT @ss_AuditYear                    = SS.AuditYear
       , @ss_UpdateBalanceOnPost          = SS.UpdateBalanceOnPost
       , @ss_IncludeVATInCommittedBalance = SS.IncludeVATInCommittedBalance
       , @ss_AgeingMode                   = SS.AgeingMode
  FROM   !ActiveSchema!.evw_SystemSettings SS


  IF OBJECT_ID('tempdb..#Traders') IS NOT NULL
     DROP TABLE #Traders

  -- Work out what Traders to Process

  CREATE TABLE #Traders ( TraderCode       VARCHAR(10)
                        , ParentTraderCode VARCHAR(10) 
                        , IsHeadOffice     BIT
                        )

  IF ISNULL(@iv_TraderCode, '') <> ''
  BEGIN

    DECLARE @TraderCode VARCHAR(10)

    SELECT @TraderCode = PCS.acCode
    FROM   !ActiveSchema!.CUSTSUPP CCS
    JOIN   !ActiveSchema!.CUSTSUPP PCS ON CCS.acInvoiceTo  = PCS.acCode
                              AND PCS.acOfficeType = 1
    WHERE  CCS.acCode = @iv_TraderCode

    IF ISNULL(@TraderCode, '') = '' SET @TraderCode = @iv_TraderCode   

    -- Insert Trader Code
    INSERT INTO #Traders
    SELECT TraderCode       = CCS.acCode
         , ParentTraderCode = ''
         , IsHeadOffice     = CASE
                              WHEN acOfficeType = 1 THEN 1
                              ELSE 0
                              END

    FROM   !ActiveSchema!.CUSTSUPP CCS
    WHERE  CCS.acCode = @TraderCode

    -- Insert Any Children
    INSERT INTO #Traders
    SELECT TraderCode       = acCode
         , ParentTraderCode = T.TraderCode
         , IsHeadOffice     = 0
    FROM   !ActiveSchema!.CUSTSUPP CS
    JOIN   #Traders T ON CS.acInvoiceTo = T.TraderCode COLLATE Latin1_General_CI_AS

  END
  ELSE
  BEGIN
    -- Insert ALL Traders

    INSERT INTO #Traders
    SELECT TraderCode       = CCS.acCode
         , ParentTraderCode = CASE
                              WHEN PCS.acCode IS NOT NULL THEN PCS.acCode
                              ELSE ''
                              END
         , IsHeadOffice     = CASE
                              WHEN PCS.acCode IS NOT NULL THEN 1
                              ELSE 0
                              END

    FROM   !ActiveSchema!.CUSTSUPP CCS
    LEFT JOIN !ActiveSchema!.CUSTSUPP PCS ON CCS.acInvoiceTo  = PCS.acCode
                                 AND PCS.acOfficeType = 1

  END

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT *
    FROM #Traders
  END

  IF OBJECT_ID('tempdb..#TraderTransSummary') IS NOT NULL
     DROP TABLE #TraderTransSummary

  CREATE TABLE #TraderTransSummary
             ( TraderCode           VARCHAR(10)
             , ExchequerYear        INT
             , TransactionPeriod    INT
             , IsPosted             BIT
             , ControlGLNominalCode INT NULL
             , CreditAmt    NUMERIC(24, 10)
             , DebitAmt     NUMERIC(24, 10)
             , BalanceAmt   NUMERIC(24, 10)
             , TransTotal   NUMERIC(24, 10)
             , PurchaseAmt  NUMERIC(24, 10)
             , CostAmt      NUMERIC(24, 10)
             , PCBalanceAmt NUMERIC(24, 10)
             , TotalOSAmt   NUMERIC(24, 10) DEFAULT 0
             )

  SET @v_InfoMessage  = 'RecalculateTraderhistory: Prep. Work Complete - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

  SET @v_QueryTime = GETDATE()

  INSERT INTO #TraderTransSummary
  SELECT D.TraderCode
       , D.ExchequerYear
       , D.TransactionPeriod
       , D.IsPosted
       , D.ControlGLNominalCode
       , CreditAmt       = SUM(CreditAmountInBase)
       , DebitAmt        = SUM(DebitAmountInBase)
       , BalanceAmt      = SUM(BalanceAmountInBase)
       , TransTotal      = SUM(TransactionTotalInBase)
       , PurchaseAmt     = SUM(CASE
                               WHEN IsStockMovement = 1 THEN TotalCalculatedNetValueInBase
                               ELSE 0
                               END)
       , CostAmt         = SUM(CASE
                               WHEN IsStockMovement = 1 THEN TotalCostInBase
                               ELSE 0
                               END
                              )
       , PCBalanceAmt    = SUM(CASE
                               WHEN IsStockMovement = 1 THEN TotalCalculatedNetValueInBase - TotalCostInBase
                               ELSE 0
                               END
                              )
       , TotalOSAmt      = 0
  FROM   !ActiveSchema!.evw_TransactionHeader D
  --JOIN   #Traders T ON D.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
  WHERE  D.TransactionTypeCode NOT IN ('SQU', 'PQU', 'SOR', 'SDN', 'POR', 'PDN', 'WOR', 'WIN', 'JCT', 'JST', 'JPT', 'JSA', 'JPA', 'SRN', 'PRN')
  AND    D.AutoDaybookFlag  > 0
  
  AND    D.IsPosted IN (@ss_UpdateBalanceOnPost, 1)  

  AND  ( D.TransactionPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

  AND    D.TransactionYear > @ss_AuditYear

  AND    D.TraderCode IN (SELECT TraderCode COLLATE Latin1_General_CI_AS FROM #Traders)

  GROUP BY D.TraderCode
         , D.ExchequerYear
         , D.TransactionPeriod
         , D.IsPosted
         , D.ControlGLNominalCode

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Inital Data Load'
         , *
    FROM   #TraderTransSummary
  END

  SET @v_InfoMessage  = 'RecalculateTraderhistory: Initial Data Load - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

  SET @v_QueryTime = GETDATE()

  -- Update the Outstanding Balance for SOR, POR, SDN, PDN Transactions
  IF (@ss_IncludeVATInCommittedBalance) = 0
  BEGIN
    MERGE #TraderTransSummary TTS
    USING 
    ( SELECT TH.TraderCode
           , ExchequerYear
           , TransactionPeriod
           , TotalOrderOutstandingInBase = SUM(TotalOrderOutstandingInBase)
      FROM   !ActiveSchema!.evw_TransactionHeader TH
      --JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
      WHERE  TransactionTypeCode IN ('SOR','POR','SDN','PDN')
      AND    TH.RunNo IN (-40, -50)
      
      AND  ( TH.TransactionPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

      AND    TH.TransactionYear > @ss_AuditYear

	  AND    TH.TraderCode IN (SELECT TraderCode COLLATE Latin1_General_CI_AS FROM #Traders)

      GROUP BY TH.TraderCode
             , ExchequerYear
             , TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                         AND OSData.ExchequerYear     = TTS.ExchequerYear
                                         AND OSData.TransactionPeriod = TTS.TransactionPeriod
                                         AND TTS.ControlGLNominalCode IS NULL
                                         AND TTS.IsPosted              = 0

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , IsPosted
                  , ControlGLNominalCode 
                  , CreditAmt   
                  , DebitAmt     
                  , BalanceAmt  
                  , TransTotal  
                  , PurchaseAmt 
                  , CostAmt  
                  , PCBalanceAmt 
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , 0
                  , NULL
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , OSData.TotalOrderOutstandingInBase
                  )
      ;
  END
  ELSE -- IncludeVATInCommittedBalance = 1 (True)
  BEGIN

    -- Deal with Manual VAT

    MERGE #TraderTransSummary TTS
    USING 
    ( SELECT TH.TraderCode
           , ExchequerYear
           , TransactionPeriod
           , TotalOrderOutstandingInBase = SUM(OSBase.TotalOrderOutstandingInBase)

      FROM  !ActiveSchema!.evw_TransactionHeader TH
      -- JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
      LEFT JOIN !ActiveSchema!.CURRENCY C ON TH.CurrencyId = C.CurrencyCode
      
      CROSS APPLY ( VALUES (  CASE
                              WHEN TotalOrderOutstanding = 0 OR (TotalCalculatedNetValue - SettleDiscountAmount) = 0
                              THEN 0
                              ELSE ROUND(TotalOrderOutstanding / (TotalCalculatedNetValue - SettleDiscountAmount) , 2)
                              END
                           )
                  ) OS1 (OSPortion)
      CROSS APPLY ( VALUES (  TotalOrderOutstanding + ((TotalVAT * TH.TransactionTypeSign * -1) * OSPortion) 
                           )
                  ) OS (TotalOrderOutstanding)

      CROSS APPLY ( VALUES ( CASE
                             WHEN UseCompanyRate = 1 THEN
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( OS.TotalOrderOutstanding
                                                                                                    , TH.ConversionRate
                                                                                                    , TH.CurrencyId
                                                                                                    , 0
                                                                                                    , 0
                                                                                                    , C.TriRate
                                                                                                    , C.TriInverted
                                                                                                    , C.TriCurrencyCode
                                                                                                    , C.IsFloating) , 2)
                                     ELSE
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( OS.TotalOrderOutstanding
                                                                                                    , C.DailyRate
                                                                                                    , TH.CurrencyId
                                                                                                    , 0
                                                                                                    , 0
                                                                                                    , C.TriRate
                                                                                                    , C.TriInverted
                                                                                                    , C.TriCurrencyCode
                                                                                                    , C.IsFloating) , 2)
                                     END
                           )

                  ) OSBase (TotalOrderOutstandingInBase)

      WHERE TransactionTypeCode IN ('SOR','POR','SDN','PDN')
      AND   TH.RunNo IN (-40, -50)
      AND   TH.IsManualVAT = 1

      AND  ( TH.TransactionPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

      AND    TH.TransactionYear > @ss_AuditYear

	  AND    TH.TraderCode IN (SELECT TraderCode COLLATE Latin1_General_CI_AS FROM #Traders)

      GROUP BY TH.TraderCode
             , ExchequerYear
             , TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                         AND OSData.ExchequerYear     = TTS.ExchequerYear
                                         AND OSData.TransactionPeriod = TTS.TransactionPeriod
                                         AND TTS.ControlGLNominalCode IS NULL
                                         AND TTS.IsPosted              = 0

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , IsPosted
                  , ControlGLNominalCode 
                  , CreditAmt   
                  , DebitAmt     
                  , BalanceAmt  
                  , TransTotal  
                  , PurchaseAmt 
                  , CostAmt  
                  , PCBalanceAmt 
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , 0
                  , NULL
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , OSData.TotalOrderOutstandingInBase
                  )
      ;

    -- Deal with Auto VAT
    MERGE #TraderTransSummary TTS
    USING 
    ( SELECT TH.TraderCode
           , TH.ExchequerYear
           , TH.TransactionPeriod
          
           , TotalOrderOutstandingInBase = SUM((OSBase.TotalOrderOutstandingInBase
                                             + (!ActiveSchema!.efn_GetVATRate(TL.VATCode, TL.InclusiveVATCode)
                                             * OSBase.TotalOrderOutstandingInBase)) 
                                              )

      FROM  !ActiveSchema!.evw_TransactionHeader TH
      --JOIN  #Traders                      T ON TH.TraderCode      = T.TraderCode COLLATE Latin1_General_CI_AS
      JOIN  (SELECT LineFolioNumber
                  , LineCalculatedNetValueoutstandingInBase
                  , VATCode
                  , InclusiveVATCode
	        FROM  !ActiveSchema!.evw_TransactionLine TL1 
			JOIN #Traders T ON TL1.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
			)   TL ON TL.LineFolioNumber = TH.HeaderFolioNumber

      CROSS APPLY ( VALUES ( ( TL.LineCalculatedNetValueoutstandingInBase
                             * ( CASE
                                 WHEN TH.SettleDiscountPercent <> 0 THEN TH.SettleDiscountPercent
                                 ELSE 1.0
                                 END
                               )
                             * TH.TransactionTypeSign * -1
                             )
                           )
                  ) OSBase ( TotalOrderOutstandingInBase)

      WHERE TH.TransactionTypeCode IN ('SOR','POR','SDN','PDN')
      AND   TH.RunNo IN (-40, -50)
      AND   TH.IsManualVAT = 0

      AND  ( TH.TransactionPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

      AND    TH.TransactionYear > @ss_AuditYear

	  AND    TH.TraderCode IN (SELECT TraderCode COLLATE Latin1_General_CI_AS FROM #Traders)

      GROUP BY TH.TraderCode
             , TH.ExchequerYear
             , TH.TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                            AND OSData.ExchequerYear     = TTS.ExchequerYear
                                            AND OSData.TransactionPeriod = TTS.TransactionPeriod
                                            AND TTS.ControlGLNominalCode IS NULL
                                            AND TTS.IsPosted             = 0

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , IsPosted
                  , ControlGLNominalCode 
                  , CreditAmt   
                  , DebitAmt     
                  , BalanceAmt  
                  , TransTotal  
                  , PurchaseAmt 
                  , CostAmt  
                  , PCBalanceAmt 
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , 0
                  , NULL
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , 0
                  , OSData.TotalOrderOutstandingInBase
                  )
      ;

  END -- IncludeVATInCommittedBalance = 0 (False)

  SET @v_InfoMessage  = 'RecalculateTraderhistory: VAT In Committed Balance - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

  SET @v_QueryTime = GETDATE()

  /* Commented out as the code ignores JCT/JST Transactions - so this is redundant

  -- JCT & JST Transactions
  MERGE #TraderTransSummary TTS
  USING 
  (  SELECT TH.TraderCode
           , TH.ExchequerYear
           , TH.TransactionPeriod
          
           , TotalOrderOutstandingInBase = SUM(OSBase.TotalOrderOutstandingInBase)

      FROM  !ActiveSchema!.evw_TransactionHeader TH
      JOIN  #Traders                      T ON TH.TraderCode = T.TraderCode     COLLATE Latin1_General_CI_AS
      LEFT JOIN !ActiveSchema!.CURRENCY           C ON TH.CurrencyId = C.CurrencyCode

      CROSS APPLY ( VALUES ( ( common.efn_ConvertToReal48(TotalCost) - common.efn_ConvertToReal48(TotalOrdered) )
                           )
                  ) OS     ( TotalOrderOutstanding)
      CROSS APPLY ( VALUES ( CASE
                                     WHEN UseCompanyRate = 1 THEN
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( OS.TotalOrderOutstanding
                                                                                                    , TH.ConversionRate
                                                                                                    , TH.CurrencyId
                                                                                                    , 0
                                                                                                    , 0
                                                                                                    , C.TriRate
                                                                                                    , C.TriInverted
                                                                                                    , C.TriCurrencyCode
                                                                                                    , C.IsFloating) , 2)
                                     ELSE
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( OS.TotalOrderOutstanding
                                                                                                    , C.DailyRate
                                                                                                    , TH.CurrencyId
                                                                                                    , 0
                                                                                                    , 0
                                                                                                    , C.TriRate
                                                                                                    , C.TriInverted
                                                                                                    , C.TriCurrencyCode
                                                                                                    , C.IsFloating) , 2)
                                     END
                           )

                  ) OSBase (TotalOrderOutstandingInBase)
      WHERE ( (TH.TransactionTypeCode = 'JCT' AND TH.RunNo = -110)
         OR   (TH.TransactionTypeCode = 'JST' AND TH.RunNo = -111 AND TH.DeliveryNoteReference = '')
            )

      AND  ( TH.TransactionPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

      AND    TH.TransactionYear > @ss_AuditYear

      GROUP BY TH.TraderCode
             , TH.ExchequerYear
             , TH.TransactionPeriod) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                           AND OSData.ExchequerYear     = TTS.ExchequerYear
                                           AND OSData.TransactionPeriod = TTS.TransactionPeriod
                                           AND TTS.ControlGLNominalCode IS NULL
                                           AND TTS.IsPosted              = 0

    WHEN MATCHED THEN
         UPDATE
            SET TotalOSAmt = OSData.TotalOrderOutstandingInBase

    WHEN NOT MATCHED BY TARGET THEN
         INSERT ( TraderCode
                , ExchequerYear
                , TransactionPeriod
                , IsPosted
                , ControlGLNominalCode 
                , CreditAmt   
                , DebitAmt     
                , BalanceAmt  
                , TransTotal  
                , PurchaseAmt 
                , CostAmt  
                , PCBalanceAmt 
                , TotalOSAmt
                )
        VALUES  ( OSData.TraderCode
                , OSData.ExchequerYear
                , OSData.TransactionPeriod
                , 0
                , NULL
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , 0
                , OSData.TotalOrderOutstandingInBase
                )
    ;

  */

  -- Insert OS Amounts for Parent/Head Office Traders

  INSERT INTO #TraderTransSummary
  SELECT T.ParentTraderCode
       , TTS.ExchequerYear
       , TTS.TransactionPeriod
       , 0
       , NULL
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , 0
       , SUM(TTS.TotalOSAmt)
  FROM   #TraderTransSummary TTS
  JOIN   #Traders            T ON TTS.TraderCode      = T.TraderCode
                              AND T.ParentTraderCode <> ''
  WHERE  TTS.TotalOSAmt <> 0
  GROUP BY T.ParentTraderCode
         , TTS.ExchequerYear
         , TTS.TransactionPeriod

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Update of OS Balances'
         , *
    FROM   #TraderTransSummary
  END

  SET @v_InfoMessage  = 'RecalculateTraderhistory: After update of OS Balances - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

  SET @v_QueryTime = GETDATE()

  IF OBJECT_ID('tempdb..#TraderHistory') IS NOT NULL
     DROP TABLE #TraderHistory

  CREATE TABLE #TraderHistory
             ( HistoryClassificationCode VARCHAR(1)
             , HistoryCode               VARBINARY(21)
             , TraderCode                VARCHAR(10)
             , ControlGLNominalCode      INT    NULL
             , ExchequerYear             INT
             , TransactionPeriod         INT
             , SalesAmount               NUMERIC(24, 10)
             , PurchaseAmount            NUMERIC(24, 10)
             , BalanceAmount             NUMERIC(24, 10)
             , ClearedBalance            NUMERIC(24, 10) DEFAULT 0
             )

  INSERT INTO #TraderHistory
  SELECT HistoryClassificationCode = 'U'
       , HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
       , TraderCode
       , ControlGLNominalCode = NULL
       , ExchequerYear
       , TransactionPeriod
       , SalesAmount        = SUM(DebitAmt)
       , PurchaseAmount     = SUM(CreditAmt)
       , BalanceAmount      = SUM(BalanceAmt)
       , ClearedBalance     = SUM(TotalOSAmt)

  FROM #TraderTransSummary TTS

  GROUP BY TraderCode
         , ExchequerYear
         , TransactionPeriod

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'Trader History - U without ControlGL'
         , *
    FROM   #TraderHistory
  END

  INSERT INTO #TraderHistory
  SELECT HistoryClassificationCode = 'U'
       , HistoryCode               = CAST(0x14 + CONVERT(VARBINARY(21), CONVERT(CHAR(6), TraderCode) )
                                      + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), ControlGLNominalCode)))
                                      + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
       , TraderCode
       , ControlGLNominalCode
       , ExchequerYear
       , TransactionPeriod
       , SalesAmount        = SUM(DebitAmt)
       , PurchaseAmount     = SUM(CreditAmt)
       , BalanceAmount      = SUM(BalanceAmt)
       , ClearBalance       = 0

  FROM #TraderTransSummary TTS
  WHERE TTS.IsPosted = 0
  AND   TTS.ControlGLNominalCode IS NOT NULL

  GROUP BY TraderCode
         , ControlGLNominalCode
         , ExchequerYear
         , TransactionPeriod

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'Trader History - U with ControlGL'
         , *
    FROM   #TraderHistory
  END

  INSERT INTO #TraderHistory
  SELECT HistoryClassificationCode = 'V'
       , HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
       , TraderCode
       , ControlGLNominalCode = NULL
       , ExchequerYear
       , TransactionPeriod
       , SalesAmount        = SUM(DebitAmt)
       , PurchaseAmount     = SUM(CreditAmt)
       , BalanceAmount      = SUM(BalanceAmt)
       , ClearedBalance     = 0

  FROM #TraderTransSummary TTS
  WHERE TTs.IsPosted = 1

  GROUP BY TraderCode
         , ExchequerYear
         , TransactionPeriod

  INSERT INTO #TraderHistory
  SELECT HistoryClassificationCode = 'V'
       , HistoryCode               = CAST(0x14 + CONVERT(VARBINARY(21), CONVERT(CHAR(6), TraderCode) )
                                      + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), ControlGLNominalCode)))
                                      + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
       , TraderCode
       , ControlGLNominalCode
       , ExchequerYear
       , TransactionPeriod
       , SalesAmount        = SUM(DebitAmt)
       , PurchaseAmount     = SUM(CreditAmt)
       , BalanceAmount      = SUM(BalanceAmt)
       , ClearedBalance     = 0

  FROM #TraderTransSummary TTS
  WHERE TTs.IsPosted = 1

  GROUP BY TraderCode
         , ControlGLNominalCode
         , ExchequerYear
         , TransactionPeriod

  INSERT INTO #TraderHistory
  SELECT HistoryClassificationCode = 'W'
       , HistoryCode = CAST(0x14 + CONVERT(VARBINARY(21), TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
       , TraderCode
       , ControlGLNominalCode = NULL
       , ExchequerYear
       , TransactionPeriod
       , SalesAmount        = SUM(CostAmt)
       , PurchaseAmount     = SUM(PurchaseAmt)
       , BalanceAmount      = SUM(PCBalanceAmt)
       , ClearedBalance     = 0

  FROM #TraderTransSummary TTS

  GROUP BY TraderCode
         , ExchequerYear
         , TransactionPeriod

-- Now insert any rows that are set in history but we can't find

  INSERT INTO #TraderHistory
  SELECT DISTINCT
         TH.HistoryClassificationCode
       , TH.HistoryCode
       , TH.TraderCode
       , TH.ControlGLNominalCode
       , TH.ExchequerYear
       , TH.HistoryPeriod
       , 0
       , 0
       , 0
       , 0

  FROM   !ActiveSchema!.evw_TraderHistory TH
  JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
  WHERE  NOT EXISTS (SELECT TOP 1 1
                     FROM   #TraderHistory Trans
                     WHERE Trans.HistoryClassificationCode         = TH.HistoryClassificationCode COLLATE Latin1_General_CI_AS
                       AND Trans.TraderCode                        = TH.TraderCode                COLLATE Latin1_General_CI_AS
    	               AND Trans.ExchequerYear                     = TH.ExchequerYear
	    	           AND Trans.TransactionPeriod                 = TH.HistoryPeriod
                       AND ISNULL(Trans.ControlGLNominalCode, -99) = ISNULL(TH.ControlGLNominalCode, -99)
                    )

  AND  ( TH.HistoryPeriodKey = @iv_TransactionPeriodKey OR @iv_TransactionPeriodKey IS NULL)

  AND  TH.HistoryPeriod  < 250
  AND (TH.SalesAmount    <> 0
  OR   TH.PurchaseAmount <> 0
  OR   TH.BalanceAmount  <> 0
  OR   TH.ClearedBalance <> 0
      )

  SET @v_InfoMessage  = 'RecalculateTraderhistory: Data gathering complete - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

  SET @v_QueryTime = GETDATE()

  -- Reset Trader History
  IF @iv_Mode = @c_Fix
  BEGIN
    MERGE !ActiveSchema!.HISTORY H
    USING
    ( SELECT HistoryPositionId
           , Trans.HistoryClassificationCode
           , TH.HistoryCode
           , GeneratedHistoryCode = Trans.HistoryCode
           , Trans.ControlGLNominalCode
           , Trans.TraderCode
           , CurrencyId     = 0
           , Trans.ExchequerYear
           , Trans.TransactionPeriod
           , SalesAmount    = ROUND(ISNULL(TH.SalesAmount, 0.0), 2)
           , NewSales       = ROUND(ISNULL(Trans.SalesAmount, 0.0), 2)
           , PurchaseAmount = ROUND(ISNULL(TH.PurchaseAmount, 0.0), 2)
           , NewPurch       = ROUND(ISNULL(Trans.PurchaseAmount, 0.0), 2)
           , BalanceAmount  = ROUND(ISNULL(TH.BalanceAmount, 0.0), 2)
           , NewBalance     = ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)
           , ClearedBalance = ROUND(ISNULL(TH.ClearedBalance, 0.0), 2)
           , NewCleared     = ROUND(ISNULL(Trans.ClearedBalance, 0.0), 2)

           , BalDiff        = ROUND(ISNULL(TH.BalanceAmount, 0.0), 2) - ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)

      FROM  #TraderHistory    Trans
      LEFT JOIN !ActiveSchema!.evw_TraderHistory TH     ON Trans.HistoryClassificationCode         = TH.HistoryClassificationCode COLLATE Latin1_General_CI_AS
												-- AND Trans.TraderCode                        = TH.TraderCode                COLLATE Latin1_General_CI_AS
												AND Trans.HistoryCode                       = TH.HistoryCode
												AND Trans.ExchequerYear                     = TH.ExchequerYear
                                                AND Trans.TransactionPeriod                 = TH.HistoryPeriod
												-- AND ISNULL(Trans.ControlGLNominalCode, -99) = ISNULL(TH.ControlGLNominalCode, -99)

      WHERE (  ABS(ROUND(ISNULL(TH.BalanceAmount, 0.0), 2)  - ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)) > 0.005
           OR  ABS(ROUND(ISNULL(TH.SalesAmount, 0.0), 2)    - ROUND(ISNULL(Trans.SalesAmount, 0.0), 2)) > 0.005
           OR  ABS(ROUND(ISNULL(TH.PurchaseAmount, 0.0), 2) - ROUND(ISNULL(Trans.PurchaseAmount, 0.0), 2)) > 0.005
           OR  ABS(ROUND(ISNULL(TH.ClearedBalance, 0.0), 2) - ROUND(ISNULL(Trans.ClearedBalance, 0.0), 2)) > 0.005
            )


     ) TransData ON TransData.HistoryPositionId = H.PositionId

     WHEN MATCHED THEN
          UPDATE
          SET hiSales     = TransData.NewSales
            , hiPurchases = TransData.NewPurch
            , hiCleared   = TransData.NewCleared
          
     WHEN NOT MATCHED BY TARGET THEN
          INSERT ( hiCode
                 , hiExclass
                 , hicurrency
                 , hiYear
                 , hiPeriod
                 , hiSales
                 , hiPurchases
                 , hiBudget
                 , hiCleared
                 , hiRevisedBudget1
                 , hiValue1
                 , hiValue2
                 , hiValue3
                 , hiRevisedBudget2
                 , hiRevisedBudget3
                 , hiRevisedBudget4
                 , hiRevisedBudget5
                 , hiSpareV
                 )
          VALUES ( TransData.GeneratedHistoryCode
                 , ASCII(TransData.HistoryClassificationCode)
                 , 0
                 , TransData.ExchequerYear
				 , TransData.TransactionPeriod
                 , TransData.NewSales
                 , TransData.NewPurch
                 , 0
                 , TransData.NewCleared
                 , 0
                 , 0
                 , 0
                 , 0
                 , 0
                 , 0
                 , 0
                 , 0
                 , 0
                 )
     ;

    SET @v_InfoMessage  = 'RecalculateTraderhistory: Data Insert/Update complete - Query duration - %s. Duration to this point - %s.'
    SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
    SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

    RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

    SET @v_QueryTime = GETDATE()

    -- Reset YTD Totals
    EXEC !ActiveSchema!.esp_RecalculateYTDTraderHistory @iv_TraderCode = @iv_TraderCode
    
    -- Reset CTD Totals
    EXEC !ActiveSchema!.esp_RecalculateCTDTraderHistory @iv_TraderCode = @iv_TraderCode
 
    SET @v_InfoMessage  = 'RecalculateTraderhistory: Reset YTD/CTD Totals complete - Query duration - %s. Duration to this point - %s.'
    SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
    SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

    RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

    -- look at pre-purge data for each trader/gl code combination


    IF @ss_AuditYear > 0
    BEGIN

      SET @v_QueryTime = GETDATE()

      DECLARE @HistoryCode               VARBINARY(21)
            , @HistoryCodecomputed       VARBINARY(20)
            , @HistoryClassificationCode VARCHAR(1)

      DECLARE curTraderHistory CURSOR FOR SELECT DISTINCT
                                                 TH.HistoryClassificationCode
                                               , TH.HistoryCode

                                          FROM   #TraderHistory TH
                                          WHERE  TH.ControlGLNominalCode IS NOT NULL
                                                 
      OPEN curTraderHistory

      FETCH NEXT FROM curTraderHistory
                 INTO @HistoryClassificationCode
                    , @HistoryCode;

      WHILE @@FETcH_STATUS = 0
      BEGIN
        
        DECLARE @AuditExchequerYear INT
              , @v_Purchases        FLOAT
              , @v_Sales            FLOAT
              , @v_Balance          FLOAT
              , @v_cleared          FLOAT
              , @v_Budget           FLOAT
              , @v_RevBudget1       FLOAT
              , @v_RevBudget2       FLOAT
              , @v_RevBudget3       FLOAT
              , @v_RevBudget4       FLOAT
              , @v_RevBudget5       FLOAT
              , @v_Value1           FLOAT
              , @v_Value2           FLOAT

        SET @AuditExchequerYear  = @ss_AuditYear - 1900
        SET @HistoryCodeComputed = SUBSTRING(@HistoryCode, 2, 20)

        -- Call Profit To Date
        EXEC !ActiveSchema!.isp_TotalProfitToDateRange @HistoryClassificationCode
                                                     , @HistoryCodeComputed
                                                     , 0
                                                     , @AuditExchequerYear
                                                     , 99
                                                     , 0
                                                     , 1
                                                     , 1
                                                     , @v_Purchases
                                                     , @v_Sales
                                                     , @v_Balance
                                                     , @v_cleared
                                                     , @v_Budget
                                                     , @v_RevBudget1
                                                     , @v_RevBudget2
                                                     , @v_RevBudget3
                                                     , @v_RevBudget4
                                                     , @v_RevBudget5
                                                     , @v_Value1
                                                     , @v_Value2

        -- if values returned then post to history
        IF ( @v_Purchases  <> 0
          OR @v_Sales      <> 0
          OR @v_Balance    <> 0
          OR @v_Cleared    <> 0
          OR @v_Budget     <> 0
          OR @v_RevBudget1 <> 0
          OR @v_RevBudget2 <> 0
          OR @v_RevBudget3 <> 0
          OR @v_RevBudget4 <> 0
          OR @v_RevBudget5 <> 0
          OR @v_Value1     <> 0
          OR @v_Value2     <> 0
           )
        BEGIN

          EXEC !ActiveSchema!.isp_PostToHistory @HistoryClassificationCode
                                              , @HistoryCode
                                              , @v_Purchases
                                              , @v_Sales
                                              , @v_Cleared
                                              , @v_Value1
                                              , @v_Value2
                                              , 0
                                              , @AuditExchequerYear
                                              , 254
                                              , 2

        END

        FETCH NEXT FROM curTraderHistory
                   INTO @HistoryClassificationCode
                      , @HistoryCode;
      END

      CLOSE curTraderHistory;
      DEALLOCATE curTraderHistory;

      SET @v_InfoMessage  = 'RecalculateTraderhistory: Calculation of pre-purge data complete - Query duration - %s. Duration to this point - %s.'
      SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
      SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

      RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT
    END

    SET @v_QueryTime = GETDATE()

    -- Clear thUntilDate

    UPDATE D
    SET thUntilDate = ''
    FROM   !ActiveSchema!.DOCUMENT D
    LEFT JOIN common.evw_TransactionType TT ON D.thDocType = TT.TransactionTypeId
    JOIN   #Traders T ON D.thAcCode = T.TraderCode COLLATE Latin1_General_CI_AS
    WHERE  TT.TransactionTypeCode IN ('SRF','PRF','SRI','PPI')  
    AND  (( CASE
             WHEN thRunNo >= 0 THEN common.efn_ExchequerRoundUp(common.efn_ExchequerRoundUp( ( thNetValue
                                            - thTotalLineDiscount
                                            + thTotalVAT
                                            )
                                            - ( thSettleDiscAmount
                                              * thSettleDiscTaken
                                              ), 2) + (thCurrSettled * TT.TransactionTypeSign), 2)
             ELSE 0
             END  <> 0)
      
      
      OR    (thOutstanding = CHAR(0) AND thUntilDate = CHAR(255))
          )

    -- Update Credit Status on CUSTSUPP
	-- Transaction Types changed in accordance with QA

    UPDATE T
       SET acCreditStatus = CASE
                            WHEN @ss_AgeingMode IN (1, 3, 5) THEN OldestDebtDays
                            ELSE OldestDebtWeeks
                            END
    FROM   !ActiveSchema!.CUSTSUPP T
    JOIN   #Traders TR ON TR.TraderCode = T.acCode COLLATE Latin1_General_CI_AS
    JOIN (SELECT TH.TraderCode
               , OldestDueDate = MIN(TH.DueDate)
          FROM  !ActiveSchema!.evw_TransactionHeader TH
          JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
          WHERE TH.TransactionTypeCode IN ('SIN','SJI','SBT','PIN','PJI','PPI','PBT') 
          AND   TH.DueDate <> ''
          AND   TH.DueDate <  CONVERT(DATE, GETDATE())
          AND   TH.TotalOutstandingAmount <> 0
          GROUP BY TH.TraderCode) TH ON T.acCode = TH.TraderCode
    CROSS APPLY ( SELECT MIN(OldestDebtDays)
                       , MIN(OldestDebtWeeks)
              FROM ( SELECT OldestDebtDays  = DATEDIFF(DAY, CONVERT(DATE, OldestDueDate), GETDATE())
                          , OldestDebtWeeks = DATEDIFF(WEEK, CONVERT(DATE, OldestDueDate), GETDATE())
                     UNION
                     SELECT OldestDebtDays  = 32767
                          , OldestDebtWeeks = 32767 ) OData
            ) OldDebt ( OldestDebtDays
                      , OldestDebtWeeks)

    SET @v_InfoMessage  = 'RecalculateTraderhistory: Updates to DOCUMENT/CUSTSUPP complete - Query duration - %s. Duration to this point - %s.'
    SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
    SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

    RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

    SET @v_QueryTime = GETDATE()
  END

  IF @iv_Mode IN (@c_Report, @c_Debug)
  BEGIN

    SELECT HistoryPositionId
         , Trans.HistoryClassificationCode
         , TH.HistoryCode
         , GeneratedHistoryCode = Trans.HistoryCode
         , Trans.ControlGLNominalCode
         , Trans.TraderCode
         , CurrencyId = 0
         , Trans.ExchequerYear
         , Trans.TransactionPeriod
         , SalesAmount    = ROUND(ISNULL(TH.SalesAmount, 0.0), 2)
         , NewSales       = ROUND(ISNULL(Trans.SalesAmount, 0.0), 2)
         , PurchaseAmount = ROUND(ISNULL(TH.PurchaseAmount, 0.0), 2)
         , NewPurch       = ROUND(ISNULL(Trans.PurchaseAmount, 0.0), 2)
         , BalanceAmount  = ROUND(ISNULL(TH.BalanceAmount, 0.0), 2)
         , NewBalance     = ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)
         , ClearedBalance = ROUND(ISNULL(TH.ClearedBalance, 0.0), 2)
         , NewCleared     = ROUND(ISNULL(Trans.ClearedBalance, 0.0), 2)

         , BalDiff        = ROUND(ISNULL(TH.BalanceAmount, 0.0), 2) - ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)

    FROM  #TraderHistory    Trans
    LEFT JOIN !ActiveSchema!.evw_TraderHistory TH   ON Trans.HistoryClassificationCode         = TH.HistoryClassificationCode COLLATE Latin1_General_CI_AS
													AND Trans.HistoryCode                      = TH.HistoryCode --                COLLATE Latin1_General_CI_AS
                                                    AND Trans.ExchequerYear                    = TH.ExchequerYear
                                                    AND Trans.TransactionPeriod                = TH.HistoryPeriod

    WHERE (  ABS(ROUND(ISNULL(TH.BalanceAmount, 0.0), 2)  - ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.SalesAmount, 0.0), 2)    - ROUND(ISNULL(Trans.SalesAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.PurchaseAmount, 0.0), 2) - ROUND(ISNULL(Trans.PurchaseAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.ClearedBalance, 0.0), 2) - ROUND(ISNULL(Trans.ClearedBalance, 0.0), 2)) > 0.005
          )

    ORDER BY TH.TraderCode
           , TH.HistoryPeriodKey

    SET @v_InfoMessage  = 'RecalculateTraderhistory: Reporting phase complete - Query duration - %s. Duration to this point - %s.'
    SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
    SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

    RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

    SET @v_QueryTime = GETDATE()
  END

  IF @iv_Mode = @c_TraderOnly
  BEGIN
    SELECT DISTINCT Trans.TraderCode
    FROM  #TraderHistory    Trans
    LEFT JOIN !ActiveSchema!.evw_TraderHistory TH   ON Trans.HistoryClassificationCode         = TH.HistoryClassificationCode COLLATE Latin1_General_CI_AS
                                                    AND Trans.HistoryCode                      = TH.HistoryCode --                COLLATE Latin1_General_CI_AS
                                                    AND Trans.ExchequerYear                    = TH.ExchequerYear
                                                    AND Trans.TransactionPeriod                = TH.HistoryPeriod

    WHERE (  ABS(ROUND(ISNULL(TH.BalanceAmount, 0.0), 2)  - ROUND(ISNULL(Trans.BalanceAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.SalesAmount, 0.0), 2)    - ROUND(ISNULL(Trans.SalesAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.PurchaseAmount, 0.0), 2) - ROUND(ISNULL(Trans.PurchaseAmount, 0.0), 2)) > 0.005
         OR  ABS(ROUND(ISNULL(TH.ClearedBalance, 0.0), 2) - ROUND(ISNULL(Trans.ClearedBalance, 0.0), 2)) > 0.005
          )

    ORDER BY Trans.TraderCode

    SET @v_InfoMessage  = 'RecalculateTraderhistory: Reporting phase complete - Query duration - %s. Duration to this point - %s.'
    SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
    SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

    RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

    SET @v_QueryTime = GETDATE()

  END

  SET @v_InfoMessage  = 'RecalculateTraderhistory: Procedure complete - Query duration - %s. Duration to this point - %s.'
  SET @v_QueryMessage = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @v_QueryTime))
  SET @v_ProcMessage  = CONVERT(VARCHAR(20), CONVERT(TIME, GETDATE() - @c_ProcStartTime))

  RAISERROR(@v_InfoMessage, 1, 1, @v_QueryMessage, @v_ProcMessage) WITH NOWAIT

END


GO