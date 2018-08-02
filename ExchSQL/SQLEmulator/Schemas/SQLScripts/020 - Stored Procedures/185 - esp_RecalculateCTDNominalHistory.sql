
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateCTDNominalHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateCTDNominalHistory]
GO

-- This currently checks CTD for CC/Dept Only - need to look at all CTD inc. ProfitBF Control

CREATE PROCEDURE !ActiveSchema!.esp_RecalculateCTDNominalHistory
AS
BEGIN

  UPDATE H
     SET hiSales        = ISNULL(YTDValues.SalesAmount, 0.0)
       , hiPurchases    = ISNULL(YTDValues.PurchaseAmount, 0.0)
       , hiCleared      = ISNULL(YTDValues.ClearedBalance, 0.0)
       , hiValue1       = ISNULL(YTDValues.Value1Amount, 0.0)
       , hiValue2       = ISNULL(YTDValues.Value2Amount, 0.0)
       , hiValue3       = ISNULL(YTDValues.Value3Amount, 0.0)

  FROM   !ActiveSchema!.HISTORY H
  JOIN   !ActiveSchema!.evw_NominalHistory NH ON NH.HistoryPositionId = H.PositionId
  OUTER APPLY ( SELECT SalesAmount    = SUM(NSH.SalesAmount) 
                     , PurchaseAmount = SUM(NSH.PurchaseAmount) 
                     , BalanceAmount  = SUM(NSH.BalanceAmount) 
                     , ClearedBalance = SUM(NSH.ClearedBalance) 
                     , Value1Amount   = SUM(NSH.Value1Amount) 
                     , Value2Amount   = SUM(NSH.Value2Amount) 
                     , Value3Amount   = SUM(NSH.Value3Amount) 
                FROM !ActiveSchema!.evw_NominalHistory NSH
                WHERE NH.HistoryClassificationId = NSH.HistoryClassificationId
                AND   NH.HistoryCode             = NSH.HistoryCode
                AND   NH.CurrencyId              = NSH.CurrencyId
                AND   NH.ExchequerYear          >= NSH.ExchequerYear
                AND   NSH.ExchequerPeriod        < 250
                AND ( NSH.CostCentreCode IS NOT NULL
                 OR   NSH.DepartmentCode IS NOT NULL
                    )
              ) YTDValues ( SalesAmount
                          , PurchaseAmount
                          , BalanceAmount
                          , ClearedBalance
                          , Value1Amount
                          , Value2Amount
                          , Value3Amount
                          )

  WHERE NH.HistoryPeriod    = 255
  AND   ( NH.CostCentreCode IS NOT NULL
     OR   NH.DepartmentCode IS NOT NULL
        )
  AND   ( ROUND(NH.SalesAmount, 2)    <> ROUND(ISNULL(YTDValues.SalesAmount, 0.0), 2)
     OR   ROUND(NH.PurchaseAmount, 2) <> ROUND(ISNULL(YTDValues.PurchaseAmount, 0.0), 2)
     OR   ROUND(NH.BalanceAmount, 2)  <> ROUND(ISNULL(YTDValues.BalanceAmount, 0.0), 2)
     OR   ROUND(NH.ClearedBalance, 2) <> ROUND(ISNULL(YTDValues.ClearedBalance, 0.0), 2)
     OR   ROUND(NH.Value1Amount, 2)   <> ROUND(ISNULL(YTDValues.Value1Amount, 0.0), 2)
     OR   ROUND(NH.Value2Amount, 2)   <> ROUND(ISNULL(YTDValues.Value2Amount, 0.0), 2)
     OR   ROUND(NH.Value3Amount, 2)   <> ROUND(ISNULL(YTDValues.Value3Amount, 0.0), 2)
        )

END

GO

