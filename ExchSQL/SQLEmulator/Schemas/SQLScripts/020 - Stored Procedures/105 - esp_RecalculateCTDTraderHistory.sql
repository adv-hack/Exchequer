/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateCTDTraderHistory]    Script Date: 18/03/2015 08:13:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDTraderHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDTraderHistory]
GO

CREATE PROCEDURE !ActiveSchema!.esp_RecalculateCTDTraderHistory (@iv_TraderCode VARCHAR(10))
AS
BEGIN

  IF OBJECT_ID('tempdb..#CTDTraders') IS NOT NULL
     DROP TABLE #CTDTraders

  -- Work out what Traders to Process

  CREATE TABLE #CTDTraders ( TraderCode       VARCHAR(10)
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
    INSERT INTO #CTDTraders
    SELECT TraderCode       = CCS.acCode
         , ParentTraderCode = ''
         , IsHeadOffice     = CASE
                              WHEN acOfficeType = 1 THEN 1
                              ELSE 0
                              END

    FROM   !ActiveSchema!.CUSTSUPP CCS
    WHERE  CCS.acCode = @TraderCode

    -- Insert Any Children
    INSERT INTO #CTDTraders
    SELECT TraderCode       = acCode
         , ParentTraderCode = T.TraderCode
         , IsHeadOffice     = 0
    FROM   !ActiveSchema!.CUSTSUPP CS
    JOIN   #CTDTraders T ON CS.acInvoiceTo = T.TraderCode COLLATE Latin1_General_CI_AS


  END
  ELSE
  BEGIN
    -- Insert ALL Traders

    INSERT INTO #CTDTraders
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

  UPDATE H
     SET hiSales        = CTDValues.SalesAmount
       , hiPurchases    = CTDValues.PurchaseAmount
       , hiCleared      = CTDValues.ClearedBalance
       , hiValue1       = CTDValues.Value1Amount
       , hiValue2       = CTDValues.Value2Amount
       , hiValue3       = CTDValues.Value3Amount

  FROM  !ActiveSchema!.HISTORY H

  JOIN !ActiveSchema!.evw_TraderHistory TH ON H.PositionId = TH.HistoryPositionId
  JOIN #CTDTraders T ON T.TraderCode = TH.TraderCode COLLATE Latin1_General_CI_AS

  CROSS APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount) 
                     , PurchaseAmount = SUM(CSH.PurchaseAmount) 
                     , BalanceAmount  = SUM(CSH.BalanceAmount) 
                     , ClearedBalance = SUM(CSH.ClearedBalance) 
                     , Value1Amount   = SUM(CSH.Value1Amount) 
                     , Value2Amount   = SUM(CSH.Value2Amount) 
                     , Value3Amount   = SUM(CSH.Value3Amount) 
                FROM !ActiveSchema!.evw_TraderHistory CSH
                WHERE TH.HistoryClassificationId = CSH.HistoryClassificationId
                AND   TH.HistoryCode             = CSH.HistoryCode
                AND   TH.CurrencyId              = CSH.CurrencyId
                AND   TH.ExchequerYear          >= CSH.ExchequerYear
                AND   CSH.ExchequerPeriod       < 250
              
              ) CTDValues ( SalesAmount
                          , PurchaseAmount
                          , BalanceAmount
                          , ClearedBalance
                          , Value1Amount
                          , Value2Amount
                          , Value3Amount
                          )

  WHERE TH.HistoryPeriod = 255
  AND   ( ROUND(TH.SalesAmount, 2)    <> ROUND(CTDValues.SalesAmount, 2)
     OR   ROUND(TH.PurchaseAmount, 2) <> ROUND(CTDValues.PurchaseAmount, 2)
     OR   ROUND(TH.BalanceAmount, 2)  <> ROUND(CTDValues.BalanceAmount, 2)
     OR   ROUND(TH.ClearedBalance, 2) <> ROUND(CTDValues.ClearedBalance, 2)
     OR   ROUND(TH.Value1Amount, 2)   <> ROUND(CTDValues.Value1Amount, 2)
     OR   ROUND(TH.Value2Amount, 2)   <> ROUND(CTDValues.Value2Amount, 2)
     OR   ROUND(TH.Value3Amount, 2)   <> ROUND(CTDValues.Value3Amount, 2)
        )

END

GO