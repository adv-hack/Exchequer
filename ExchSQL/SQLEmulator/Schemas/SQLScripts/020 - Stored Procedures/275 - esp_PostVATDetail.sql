IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostVATDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostVATDetail
GO

CREATE PROCEDURE !ActiveSchema!.esp_PostVATDetail ( @itvp_PostLineTransactions common.edt_Integer READONLY
                                             )
AS
BEGIN

  SET NOCOUNT ON;

  /* For Debug puposes 
  
  DECLARE @itvp_PostLineTransactions common.edt_Integer
  
  INSERT INTO @itvp_PostLineTransactions
  SELECT 66563
  UNION
  SELECT 66564
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

  IF OBJECT_ID('tempdb..#VATPostDetail') IS NOT NULL
    DROP TABLE #VATPostDetail

  SELECT VH.HistoryPositionId
       , HistoryClassificationCode = VATHistoryClass 
       , HistoryCode               = VATHistoryCode 
       , ExchequerYear             = VP.VATYear - 1900
       , HistoryPeriod             = VP.VATPeriod
       , CurrencyId                = @ss_VATCurrency
       , SalesAmount               = SUM(LineCalculatedNetValueInVATCurrency * CASE
                                                                               WHEN DTL.PaymentCode = 'N' THEN -1
                                                                               ELSE 1
                                                                               END * -1)
       , PurchaseAmount            = CONVERT(FLOAT, 0)
  INTO #VATPostDetail
  FROM !ActiveSchema!.evw_TransactionLine DTL (READUNCOMMITTED)
  JOIN !ActiveSchema!.DOCUMENT    DOC (READUNCOMMITTED) ON DTL.LineFolioNumber   = DOC.thFolioNum
  CROSS APPLY ( SELECT VATPeriodDate = CASE
                                       WHEN ISDATE(DOC.thTransDate) = @c_True THEN [!ActiveSchema!].efn_CalculateVATPeriod(DOC.thTransDate)
                                       ELSE [!ActiveSchema!].efn_CalculateVATPeriod(@c_Today)
                                       END
              ) VPD
  CROSS APPLY ( SELECT VATYear = YEAR(CONVERT(DATE, VPD.VATPeriodDate))
                     , VATPeriod = MONTH(CONVERT(DATE, VPD.VATPeriodDate))
              ) VP
  JOIN common.evw_TransactionType TT  ON DOC.thDocType    = TT.TransactionTypeId
  JOIN !ActiveSchema!.CURRENCY C ON C.CurrencyCode = @ss_VATCurrency

  CROSS APPLY ( VALUES ( ( CASE
                           WHEN DTL.VATCode = 'A' THEN '3'
                           WHEN DTL.VATCode = 'D' THEN '4'
                           WHEN DTL.VATCode = 'M' THEN 'S'
                           ELSE DTL.VATCode
                           END
                         )
                       )
              ) NVC (NewVATCode)
  CROSS APPLY ( VALUES ( ( CASE
                           WHEN DTL.TransactionTypeCode IN ('NOM','NMT') AND DOC.thNOMVATIO IN ('I','O') THEN DOC.thNOMVATIO
                           WHEN DTL.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT') THEN 'O'
                           ELSE 'I'
                           END
                         )
                       , ( CONVERT(VARBINARY(21), 0x14
                         + CONVERT(VARBINARY(20), NVC.NewVATCode + SPACE(19)))
                         )
                       )
              ) VT ( VATHistoryClass
                   , VATHistoryCode
                   )
  -- convert to VAT Currency
  CROSS APPLY ( VALUES ( (CASE
                          WHEN @ss_UsecompanyRate = @c_True THEN C.CompanyRate
                          ELSE C.DailyRate
                          END
                         )
                       )
              ) R (ConversionRate)

  CROSS APPLY ( VALUES ( ( CASE
                           WHEN @ss_VATCurrency IN (0, 1) THEN DTL.LineCalculatedNetValueInBase
                           ELSE common.efn_ExchequerCurrencyConvert( DTL.LineCalculatedNetValue
                                                                   , R.ConversionRate
                                                                   , @ss_VATCurrency
                                                                   , @c_False
                                                                   , @c_True
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating)
                           END
                         )
                       )
              ) VC (LineCalculatedNetValueInVATCurrency)

  LEFT JOIN !ActiveSchema!.evw_VATHistory VH (READUNCOMMITTED) ON VH.HistoryClassificationCode = VATHistoryClass COLLATE SQL_Latin1_General_CP437_BIN
                                    AND VH.HistoryCode               = VATHistoryCode
                                    AND VH.CurrencyId                = @ss_VATCurrency
                                    AND VH.ExchequerYear             = VP.VATYear - 1900
                                    AND VH.ExchequerPeriod           = VP.VATPeriod
                                                 
  WHERE ( TT.TransactionTypeCode NOT IN ('NOM','NMT','SRC','PPY')
     OR ( TT.TransactionTypeCode IN ('NOM','NMT') AND DOC.thNOMVATIO NOT IN ('', CHAR(0)) )
        )
  AND DTL.VATCode NOT IN ('', CHAR(0))
  AND DTL.DisplayLineNo  <> -1
  AND DOC.thProcess NOT IN ('P','T')

  AND EXISTS (SELECT TOP 1 1
              FROM @itvp_PostLineTransactions PLT
              WHERE PLT.IntegerValue = DTL.LinePositionId)
    
  GROUP BY HistoryPositionId
         , VATHistoryClass
         , VATHistoryCode
         , VATYear
         , VATPeriod
  HAVING ROUND(SUM(LineCalculatedNetValueInVATCurrency * CASE
                                                         WHEN DTL.PaymentCode = 'N' THEN -1
                                                         ELSE 1
                                                         END * -1), 2) <> 0

  -- Do Reverse Charge if required

  IF @ss_CurrentCountryCode = '044'
  AND @ss_VATEnableECServices = @c_True
  BEGIN

    INSERT INTO #VATPostDetail
    SELECT HistoryPositionId
         , VATHistoryClass 
         , VATHistoryCode 
         , VATYear = VP.VATYear - 1900
         , VP.VATPeriod
         , CurrencyId     = @ss_VATCurrency
         , SalesAmount    = SUM(LineCalculatedNetValueInVATCurrency * CASE
                                                                      WHEN DTL.PaymentCode = 'N' THEN -1
                                                                      ELSE 1
                                                                      END)
         , PurchaseAmount = 0
    FROM !ActiveSchema!.evw_TransactionLine DTL (READUNCOMMITTED)
    JOIN !ActiveSchema!.DOCUMENT    DOC (READUNCOMMITTED) ON DTL.LineFolioNumber   = DOC.thFolioNum
    JOIN !ActiveSchema!.DETAILS    ODTL (READUNCOMMITTED) ON DTL.LinePositionId    = ODTL.PositionId
    JOIN common.evw_TransactionType TT  ON DOC.thDocType    = TT.TransactionTypeId
    JOIN !ActiveSchema!.CURRENCY C ON DTL.CurrencyId = C.CurrencyCode
    CROSS APPLY ( SELECT VATPeriodDate = CASE
                                         WHEN ISDATE(DOC.thTransDate) = @c_True THEN [!ActiveSchema!].efn_CalculateVATPeriod(DOC.thTransDate)
                                         ELSE [!ActiveSchema!].efn_CalculateVATPeriod(@c_Today)
                                         END
                ) VPD
    CROSS APPLY ( SELECT VATYear = YEAR(CONVERT(DATE, VPD.VATPeriodDate))
                       , VATPeriod = MONTH(CONVERT(DATE, VPD.VATPeriodDate))
                ) VP
    CROSS APPLY ( VALUES ( ( CASE
                             WHEN DTL.VATCode = 'A' THEN '3'
                             WHEN DTL.VATCode = 'D' THEN '4'
                             ELSE DTL.VATCode
                             END
                           )
                         )
                ) NVC (NewVATCode)
    CROSS APPLY ( VALUES ( ( 'O'
                           )
                         , ( CONVERT(VARBINARY(21), 0x14
                           + CONVERT(VARBINARY(20), NVC.NewVATCode + SPACE(19)))
                           )
                         )
                ) VT ( VATHistoryClass
                     , VATHistoryCode
                     )
    -- convert to VAT Currency
    CROSS APPLY ( VALUES ( (CASE
                            WHEN @ss_UsecompanyRate = 1 THEN C.CompanyRate
                            ELSE C.DailyRate
                            END
                           )
                         )
                ) R (ConversionRate)
    CROSS APPLY ( VALUES ( ( CASE
                             WHEN @ss_VATCurrency IN (@c_BaseCurrencyId, 1) THEN DTL.LineCalculatedNetValueInBase
                             ELSE common.efn_ExchequerCurrencyConvert( DTL.LineCalculatedNetValue
                                                                     , R.ConversionRate
                                                                     , @ss_VATCurrency
                                                                     , @c_False
                                                                     , @c_True
                                                                     , C.TriRate
                                                                     , C.TriInverted
                                                                     , C.TriCurrencyCode
                                                                     , C.IsFloating)
                             END
                           )
                         )
                ) VC (LineCalculatedNetValueInVATCurrency)
              
    LEFT JOIN !ActiveSchema!.evw_VATHistory VH (READUNCOMMITTED) ON VH.HistoryClassificationCode = VATHistoryClass COLLATE SQL_Latin1_General_CP437_BIN
                                      AND VH.HistoryCode               = VATHistoryCode
                                      AND VH.CurrencyId                = @ss_VATCurrency
                                      AND VH.ExchequerYear             = VP.VATYear - 1900
                                      AND VH.ExchequerPeriod           = VP.VATPeriod

    WHERE TT.TransactionTypeCode IN ('PIN','PPI','PCR','PJI','PJC','PRF','PQU','POR','PDN')
    AND ( DOC.thProcess = ''
       OR ( @ss_IntrastatEnabled = @c_False AND DOC.thProcess = CHAR(0) )
        )
    AND ODTL.tlECService = 1

    AND EXISTS (SELECT TOP 1 1
                FROM @itvp_PostLineTransactions PLT
                WHERE PLT.IntegerValue = DTL.LinePositionId)
    
    GROUP BY HistoryPositionId
           , VATHistoryClass
           , VATHistoryCode
           , VP.VATYear
           , VP.VATPeriod

  END
 
  --SELECT *
  --FROM #VATPostDetail

  MERGE !ActiveSchema!.HISTORY VH
  USING ( SELECT HistoryPositionId
               , HistoryClassificationCode
               , HistoryCode
               , ExchequerYear
               , HistoryPeriod
               , CurrencyId
               , SalesAmount    = SUM(SalesAmount)
               , PurchaseAmount = SUM(PurchaseAmount)
          FROM #VATPostDetail 
          WHERE SalesAmount    <> 0
          OR    PurchaseAmount <> 0
          GROUP BY HistoryPositionId
                 , HistoryClassificationCode
                 , HistoryCode
                 , ExchequerYear
                 , HistoryPeriod
                 , CurrencyId
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
