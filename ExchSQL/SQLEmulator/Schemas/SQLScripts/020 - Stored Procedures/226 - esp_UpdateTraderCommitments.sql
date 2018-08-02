

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdateTraderCommitments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_UpdateTraderCommitments
GO

CREATE PROCEDURE [!ActiveSchema!].esp_UpdateTraderCommitments
AS
BEGIN

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

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
  FROM   [!ActiveSchema!].evw_SystemSettings SS

  IF OBJECT_ID('tempdb..#TraderTransSummary') IS NOT NULL
     DROP TABLE #TraderTransSummary

  CREATE TABLE #TraderTransSummary
             ( TraderCode              VARCHAR(10)
             , ExchequerYear           INT
             , TransactionPeriod       INT
             , HistoryClassificationId INT            DEFAULT  85 -- U
             , HistoryCode             VARBINARY(21) 
             , CurrencyId              INT            DEFAULT 0
             , TotalOSAmt              FLOAT          DEFAULT 0
             )

  -- Update the Outstanding Balance for SOR, POR, SDN, PDN Transactions
  IF (@ss_IncludeVATInCommittedBalance) = 0
  BEGIN
    MERGE #TraderTransSummary TTS
    USING 
    ( SELECT TH.TraderCode
           , ExchequerYear
           , TransactionPeriod
           , TotalOrderOutstandingInBase = SUM(TotalOrderOutstandingInBase)
      FROM   [!ActiveSchema!].evw_TransactionHeader TH
      --JOIN   #Traders T ON TH.TraderCode = T.TraderCode COLLATE Latin1_General_CI_AS
      WHERE  TransactionTypeCode IN ('SOR','POR','SDN','PDN')
      AND    TH.RunNo IN (-40, -50)
      AND    TH.TransactionYear > @ss_AuditYear

      GROUP BY TH.TraderCode
             , ExchequerYear
             , TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                         AND OSData.ExchequerYear     = TTS.ExchequerYear
                                         AND OSData.TransactionPeriod = TTS.TransactionPeriod

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , HistoryCode
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , CAST(0x14 + CONVERT(VARBINARY(21), OSData.TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
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

      FROM  [!ActiveSchema!].evw_TransactionHeader TH
      LEFT JOIN [!ActiveSchema!].CURRENCY C ON TH.CurrencyId = C.CurrencyCode
      
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

      AND    TH.TransactionYear > @ss_AuditYear

      GROUP BY TH.TraderCode
             , ExchequerYear
             , TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                         AND OSData.ExchequerYear     = TTS.ExchequerYear
                                         AND OSData.TransactionPeriod = TTS.TransactionPeriod

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , HistoryCode 
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , CAST(0x14 + CONVERT(VARBINARY(21), TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
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
                                             + ([!ActiveSchema!].efn_GetVATRate(TL.VATCode, TL.InclusiveVATCode)
                                             * OSBase.TotalOrderOutstandingInBase)) 
                                              )

      FROM  [!ActiveSchema!].evw_TransactionHeader TH
      JOIN  (SELECT LineFolioNumber
                  , LineCalculatedNetValueOutstandingInBase = LineCalculatedNetValueOutstandingInBase * TransactionTypeSign * -1
                  , VATCode
                  , InclusiveVATCode
	        FROM  [!ActiveSchema!].evw_TransactionLine TL1 
			)   TL ON TL.LineFolioNumber = TH.HeaderFolioNumber

      CROSS APPLY ( VALUES ( ( TL.LineCalculatedNetValueOutstandingInBase
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

      AND    TH.TransactionYear > @ss_AuditYear

      GROUP BY TH.TraderCode
             , TH.ExchequerYear
             , TH.TransactionPeriod ) OSData ON OSData.TraderCode        = TTS.TraderCode        COLLATE Latin1_General_CI_AS
                                            AND OSData.ExchequerYear     = TTS.ExchequerYear
                                            AND OSData.TransactionPeriod = TTS.TransactionPeriod

      WHEN MATCHED THEN
           UPDATE
              SET TotalOSAmt = TotalOSAmt + OSData.TotalOrderOutstandingInBase

      WHEN NOT MATCHED BY TARGET THEN
           INSERT ( TraderCode
                  , ExchequerYear
                  , TransactionPeriod
                  , HistoryCode 
                  , TotalOSAmt
                  )
          VALUES  ( OSData.TraderCode
                  , OSData.ExchequerYear
                  , OSData.TransactionPeriod
                  , CAST(0x14 + CONVERT(VARBINARY(21), TraderCode) + CONVERT(VARBINARY(21), SPACE(14)) AS VARBINARY(21) )
                  , OSData.TotalOrderOutstandingInBase
                  )
      ;

  END -- IncludeVATInCommittedBalance = 0 (False)

  -- Merge HISTORY

  MERGE [!ActiveSchema!].HISTORY H
  USING (SELECT HistoryClassificationId
              , HistoryCode
              , ExchequerYear
              , HistoryPeriod
              , CurrencyId
              , ClearedAmount = SUM(common.efn_ExchequerRoundUp(TotalOSAmt, 2))
         FROM #TraderTransSummary TTS
         CROSS APPLY (SELECT HistoryPeriod = TransactionPeriod
                      UNION
                      SELECT HistoryPeriod = @c_CTDPeriod
                     ) HP
         GROUP BY HistoryClassificationId
                , HistoryCode
                , ExchequerYear
                , HistoryPeriod
                , CurrencyId
        ) OSData ON H.hiExClass  = OSData.HistoryClassificationId
                AND H.hiCode     = OSData.HistoryCode
                AND H.hiYear     = OSData.ExchequerYear
                AND H.hiPeriod   = OSData.HistoryPeriod
                AND H.hiCurrency = OSData.CurrencyId
  WHEN MATCHED THEN
       UPDATE
          SET hiCleared   = OSData.ClearedAmount
          
     WHEN NOT MATCHED BY TARGET THEN
          INSERT ( hiCode
                 , hiExclass
                 , hiCurrency
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
          VALUES ( OSData.HistoryCode
                 , OSData.HistoryClassificationId
                 , 0
                 , OSData.ExchequerYear
                 , OSdata.HistoryPeriod
                 , 0
                 , 0
                 , 0
                 , OSData.ClearedAmount
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

END

GO