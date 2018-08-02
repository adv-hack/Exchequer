
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDHistory]
GO

CREATE PROCEDURE [!ActiveSchema!].esp_RecalculateCTDHistory
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

  UPDATE H
     SET hiSales        = ISNULL(CTDValues.SalesAmount, 0.0)
       , hiPurchases    = ISNULL(CTDValues.PurchaseAmount, 0.0)
       , hiCleared      = ISNULL(CTDValues.ClearedBalance, 0.0)
       , hiValue1       = ISNULL(CTDValues.Value1Amount, 0.0)
       , hiValue2       = ISNULL(CTDValues.Value2Amount, 0.0)
       , hiValue3       = ISNULL(CTDValues.Value3Amount, 0.0)

  FROM   [!ActiveSchema!].HISTORY H
  JOIN   [!ActiveSchema!].evw_History       NH ON NH.HistoryPositionId = H.PositionId
  JOIN   common.evw_HistoryClassification HC ON NH.HistoryClassificationId = HC.HistoryClassificationId
                                            AND HC.HasCTD = @c_True

  OUTER APPLY ( SELECT SalesAmount    = SUM(CSH.SalesAmount) 
                     , PurchaseAmount = SUM(CSH.PurchaseAmount) 
                     , BalanceAmount  = SUM(CSH.BalanceAmount) 
                     , ClearedBalance = SUM(CSH.ClearedBalance) 
                     , Value1Amount   = SUM(CSH.Value1Amount) 
                     , Value2Amount   = SUM(CSH.Value2Amount) 
                     , Value3Amount   = SUM(CSH.Value3Amount) 
                FROM [!ActiveSchema!].evw_History CSH
                WHERE NH.HistoryClassificationId = CSH.HistoryClassificationId
                AND   NH.HistoryCode             = CSH.HistoryCode
                AND   NH.CurrencyId              = CSH.CurrencyId
                AND   NH.ExchequerYear          >= CSH.ExchequerYear
                AND   CSH.ExchequerPeriod        < 250
              ) CTDValues ( SalesAmount
                          , PurchaseAmount
                          , BalanceAmount
                          , ClearedBalance
                          , Value1Amount
                          , Value2Amount
                          , Value3Amount
                          )

  WHERE NH.HistoryPeriod    = @c_CTDPeriod
  AND   ( ROUND(NH.SalesAmount, 2)    <> ROUND(ISNULL(CTDValues.SalesAmount, 0.0), 2)
     OR   ROUND(NH.PurchaseAmount, 2) <> ROUND(ISNULL(CTDValues.PurchaseAmount, 0.0), 2)
     OR   ROUND(NH.BalanceAmount, 2)  <> ROUND(ISNULL(CTDValues.BalanceAmount, 0.0), 2)
     OR   ROUND(NH.ClearedBalance, 2) <> ROUND(ISNULL(CTDValues.ClearedBalance, 0.0), 2)
     OR   ROUND(NH.Value1Amount, 2)   <> ROUND(ISNULL(CTDValues.Value1Amount, 0.0), 2)
     OR   ROUND(NH.Value2Amount, 2)   <> ROUND(ISNULL(CTDValues.Value2Amount, 0.0), 2)
     OR   ROUND(NH.Value3Amount, 2)   <> ROUND(ISNULL(CTDValues.Value3Amount, 0.0), 2)
        )

END

GO

