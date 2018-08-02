IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostVATHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostVATHeader
GO

CREATE PROCEDURE !ActiveSchema!.esp_PostVATHeader ( @itvp_PostTransactions common.edt_Integer READONLY
                                              )
AS
BEGIN

  SET NOCOUNT ON;

  /* For Debug puposes 
  
  DECLARE @itvp_PostTransactions common.edt_Integer
  
  INSERT INTO @itvp_PostLineTransactions
  SELECT 7147
  */

  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_UseSeparateDiscounts BIT
        , @ss_UseCompanyRate       BIT
        , @ss_VATScheme            VARCHAR(1)
        , @ss_VATCurrency          INT
        , @ss_VATEnableECServices  BIT
        , @ss_CurrentCountryCode   VARCHAR(3)
        , @ss_IntrastatEnabled     BIT
        , @ss_StockEnabled         BIT = 0

  -- Set up System Settings
  
  SELECT @ss_UseSeparateDiscounts = SS.UseSeparateDiscounts
       , @ss_UseCompanyRate       = SS.UseCompanyRate
       , @ss_CurrentCountryCode   = SS.CurrentCountryCode
       , @ss_IntrastatEnabled     = SS.IntrastatEnabled
  FROM   !ActiveSchema!.evw_SystemSettings SS
  

  -- Set up VAT System Settings
  SELECT @ss_VATScheme           = VATScheme
       , @ss_VATCurrency         = VATCurrency
       , @ss_VATEnableECServices = VATEnableECServices
  FROM   !ActiveSchema!.evw_VATSystemSettings

  IF OBJECT_ID('tempdb..#VATPostHeader') IS NOT NULL
    DROP TABLE #VATPostHeader

  SELECT VH.HistoryPositionId
       , HistoryClassificationCode = VATHistoryClass
       , HistoryCode               = VATHistoryCode
       , ExchequerYear             = VP.VATYear - 1900
       , HistoryPeriod             = VP.VATPeriod
       , CurrencyId                = @ss_VATCurrency
       , SalesAmount               = CONVERT(FLOAT, 0)
       , PurchaseAmount            = SUM(common.efn_ExchequerRoundUp(VATAmountInVATCurrency, 2) * TT.TransactionTypeSign * -1)
  INTO #VATPostHeader
  FROM !ActiveSchema!.DOCUMENT DOC (READUNCOMMITTED)

  JOIN !ActiveSchema!.CURRENCY C ON C.CurrencyCode = @ss_VATCurrency
  JOIN common.evw_TransactionType TT         ON DOC.thDocType = TT.TransactionTypeId
  LEFT JOIN !ActiveSchema!.evw_TransactionVATAnalysis TVA ON DOC.PositionId = TVA.HeaderPositionId
  CROSS APPLY ( SELECT VATPeriodDate = CASE
                                       WHEN ISDATE(DOC.thTransDate) = @c_True THEN [!ActiveSchema!].efn_CalculateVATPeriod(DOC.thTransDate)
                                       ELSE [!ActiveSchema!].efn_CalculateVATPeriod(@c_Today)
                                       END
              ) VPD
  CROSS APPLY ( SELECT VATYear = YEAR(CONVERT(DATE, VPD.VATPeriodDate))
                     , VATPeriod = MONTH(CONVERT(DATE, VPD.VATPeriodDate))
              ) VP
  CROSS APPLY ( VALUES ( ( CASE
                           WHEN TT.TransactionTypeCode IN ('NOM','NMT') AND DOC.thNOMVATIO IN ('I','O') THEN DOC.thNOMVATIO
                           WHEN TT.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN 'O'
                           ELSE 'I'
                           END
                         )
                       , ( CONVERT(VARBINARY(21), 0x14
                         + CONVERT(VARBINARY(20), ISNULL(TVA.VATCode, 'Z') + SPACE(19)))
                         )
                       , ISNULL(TVA.VATAmount, 0)
                       )
              ) VT ( VATHistoryClass
                   , VATHistoryCode
                   , VATAmount
                   )
  -- convert to VAT Currency
  CROSS APPLY ( VALUES ( (CASE
                          WHEN @ss_UsecompanyRate = @c_True THEN DOC.thCompanyRate
                          ELSE DOC.thDailyRate
                          END
                         )
                       )
              ) R (ConversionRate)

  CROSS APPLY ( VALUES ( ( common.efn_ExchequerCurrencyConvert( VT.VATAmount
                                                              , R.ConversionRate
                                                              , @ss_VATCurrency
                                                              , @c_False
                                                              , @c_False
                                                              , C.TriRate
                                                              , C.TriInverted
                                                              , C.TriCurrencyCode
                                                              , C.IsFloating)
                         )
                       )
              ) VC (VATAmountInVATCurrency)

  LEFT JOIN !ActiveSchema!.evw_VATHistory VH (READUNCOMMITTED) ON VH.HistoryClassificationCode = VATHistoryClass COLLATE SQL_Latin1_General_CP437_BIN
                                    AND VH.HistoryCode               = VATHistoryCode
                                    AND VH.CurrencyId                = @ss_VATCurrency
                                    AND VH.ExchequerYear             = VP.VATYear - 1900
                                    AND VH.ExchequerPeriod           = VP.VATPeriod
  WHERE @ss_VATScheme <> 'C'
  AND EXISTS (SELECT TOP 1 1
              FROM @itvp_PostTransactions PLT
              WHERE PLT.IntegerValue = DOC.PositionId)

  GROUP BY HistoryPositionId
         , VATHistoryClass
         , VATHistoryCode
         , VP.VATYear
         , VP.VATPeriod

  HAVING ROUND(SUM(common.efn_ExchequerRoundUp(VATAmountInVATCurrency, 2) * TT.TransactionTypeSign * -1), 2) <> 0

  MERGE !ActiveSchema!.HISTORY VH
  USING ( SELECT HistoryPositionId
               , HistoryClassificationCode
               , HistoryCode
               , ExchequerYear
               , HistoryPeriod
               , CurrencyId
               , SalesAmount
               , PurchaseAmount
          FROM #VATPostHeader 
          WHERE ( SalesAmount    <> 0
          OR      PurchaseAmount <> 0)
        ) VATData ON VH.PositionId = VATData.HistoryPositionId
  WHEN MATCHED THEN
       UPDATE
          SET hiSales     = hiSales     + VATData.SalesAmount
            , hiPurchases = hiPurchases + VATData.PurchaseAmount
  WHEN NOT MATCHED BY TARGET THEN
       INSERT ( hiCode
              , hiExClass
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
       VALUES ( HistoryCode
              , ASCII(HistoryClassificationCode)
              , CurrencyId
              , ExchequerYear
              , HistoryPeriod
              , SalesAmount
              , PurchaseAmount
              , 0
              , 0
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
