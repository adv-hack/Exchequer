/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateEmployeeActuals]    Script Date: 01/30/2015 14:31:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateEmployeeActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateEmployeeActuals]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateEmployeeActuals]    Script Date: 01/30/2015 14:31:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateEmployeeActuals] ( @iv_Mode INT = 0)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @c_Fix    INT = 0
      , @c_Report INT = 1
      , @c_Debug  INT = 2

-- For Debug Purposes

-- DECLARE @iv_Mode INT = 1

CREATE TABLE  #RecalcEmpActual 
      ( RecalcJobId          INT IDENTITY  (1, 1)
      , JobCode              VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
      , EmployeeCode         VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
      , TransactionTypeCode  VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
      , TransactionTypeSign  INT
      , CategoryHistoryId    INT
      , AnalysisType         INT
      , TransactionPeriodKey INT
      , TransactionCurrency  INT
      , PostedCompanyRate    FLOAT
      , PostedDailyRate      FLOAT
      , IsReversed           BIT
      , ReverseWIPElement    BIT
      , IsRevenue            BIT
      , Quantity             FLOAT NULL
      , Cost                 FLOAT NULL
      , CostInBase           FLOAT NULL
      , PostedAmount         FLOAT NULL
      , PostedAmountInBase   FLOAT NULL
      , SalesAmount          FLOAT NULL
      , SalesAmountInBase    FLOAT NULL
      , PurchaseAmount       FLOAT NULL
      , PurchaseAmountInBase FLOAT NULL
      , BalanceAmount        FLOAT NULL
      , BalanceAmountInBase  FLOAT NULL
      , PRIMARY KEY CLUSTERED (EmployeeCode, RecalcJobId)
      )

INSERT INTO #RecalcEmpActual
SELECT JA.JobCode
     , JA.EmployeeCode
     , TT.TransactionTypeCode
     , TT.TransactionTypeSign
     , JCA.CategoryHistoryId
     , JA.JobAnalysisType
     , JA.TransactionPeriodKey 
     , JA.TransactionCurrency
     , JA.PostedCompanyRate
     , JA.PostedDailyRate
     , JA.IsReversed
     , JA.ReverseWIPElement
     , JCA.IsRevenue
     , JA.Quantity
     , JA.Cost
     , BA.CostInBase
     , PostedAmount       =  common.ifn_ExchRnd(JA.Quantity * JA.Cost * TT.TransactionTypeSign, 2)       /* Rule 6 */
     , PostedAmountInBase =  common.ifn_ExchRnd(JA.Quantity * BA.CostInBase * TT.TransactionTypeSign, 2) /* Rule 6 */
     , SalesAmount        = CASE
                            WHEN (JA.Quantity * JA.Cost * TT.TransactionTypeSign) > 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * JA.Cost * TT.TransactionTypeSign, 2))
                            ELSE 0
                            END
     , SalesAmountInBase  = CASE
                            WHEN (JA.Quantity * BA.CostInBase * TT.TransactionTypeSign) > 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * BA.CostInBase * TT.TransactionTypeSign, 2))
                            ELSE 0
                            END
     , PurchaseAmount     = CASE
                            WHEN (JA.Quantity * JA.Cost * TT.TransactionTypeSign) < 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * JA.Cost * TT.TransactionTypeSign, 2))
                            ELSE 0
                            END
     , PurchaseAmountInBase = CASE
                              WHEN (JA.Quantity * BA.CostInBase * TT.TransactionTypeSign) < 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * BA.CostInBase * TT.TransactionTypeSign, 2))
                              ELSE 0
                              END
     , BalanceAmount        = CASE
                              WHEN (JA.Quantity * JA.Cost * TT.TransactionTypeSign) < 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * JA.Cost * TT.TransactionTypeSign, 2))
                              ELSE 0
                              END
                            - CASE
                              WHEN (JA.Quantity * JA.Cost * TT.TransactionTypeSign) > 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * JA.Cost * TT.TransactionTypeSign, 2))
                              ELSE 0
                              END
     , BalanceAmountInBase  = CASE
                              WHEN (JA.Quantity * BA.CostInBase * TT.TransactionTypeSign) < 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * BA.CostInBase * TT.TransactionTypeSign, 2))
                              ELSE 0
                              END
                            - CASE
                              WHEN (JA.Quantity * BA.CostInBase * TT.TransactionTypeSign) > 0 THEN ABS(common.ifn_ExchRnd(JA.Quantity * BA.CostInBase * TT.TransactionTypeSign, 2))
                              ELSE 0
                              END

FROM   !ActiveSchema!.evw_JobActual           JA
JOIN !ActiveSchema!.CURRENCY          C    ON JA.TransactionCurrency = C.CurrencyCode

CROSS JOIN [!ActiveSchema!].evw_SystemSettings SS

CROSS APPLY ( VALUES ( (CASE
                        WHEN TransactionCurrency NOT IN (0, 1) AND PostedCompanyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN TransactionCurrency NOT IN (0, 1) AND PostedDailyRate = 0 AND UseCompanyRate = 0   THEN C.DailyRate
                        WHEN UseCompanyRate = 1 THEN CASE 
                                                     WHEN PostedCompanyRate = 0 THEN 1
                                                     ELSE PostedCompanyRate
                                                     END
                        WHEN UseCompanyRate = 0 THEN CASE 
                                                     WHEN PostedDailyRate = 0 THEN 1
                                                     ELSE PostedDailyRate
                                                     END
                        ELSE 1
                        END
                       )
                     )
            ) CRate ( ConversionRate )
CROSS APPLY ( VALUES ( ( common.efn_ExchequerCurrencyConvert( JA.Cost
                                                             , ConversionRate
                                                             , TransactionCurrency
                                                             , 0
                                                             , 0
                                                             , PCTriRates
                                                             , PCTriInvert
                                                             , PCTriEuro
                                                             , PCTriFloat
                                                             )
                                )
                    )) BA (CostInBase)
JOIN   common.ivw_TransactionType     TT  ON JA.TransactionType = TT.TransactionTypeId
                                       
LEFT JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCA ON JA.JobCode         = JCA.JobCode      COLLATE SQL_Latin1_General_CP1_CI_AS
                                            AND JA.AnalysisCode    = JCA.AnalysisCode COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE 1 = 1
AND   JA.IsPosted = 1
AND   JA.LinePostedStatus > 0
AND   JA.Cost <> 0
AND   TT.TransactionTypeCode IN ('TSH') /* Rule 14 */

IF @iv_Mode = @c_Debug
BEGIN
  SELECT *
  FROM #RecalcEmpActual
END

CREATE TABLE #EmpHist
      ( EmployeeCode         VARCHAR(50)
      , HistoryPeriodKey     INT
      , HistoryCurrencyId    INT
      , SalesAmount          FLOAT
      , PurchaseAmount       FLOAT
      , BalanceAmount        FLOAT
      , SalesAmountInBase    FLOAT
      , PurchaseAmountInBase FLOAT
      , BalanceAmountInBase  FLOAT
      , PRIMARY KEY CLUSTERED (EmployeeCode, HistoryPeriodKey, HistoryCurrencyId )
      )

INSERT INTO #EmpHist
SELECT REA.EmployeeCode
     , TransactionPeriodKey
     , TransactionCurrency  = CUR.CurrencyCode
     , SalesAmount          = SUM(SalesAmount)
     , PurchaseAmount       = SUM(PurchaseAmount)
     , BalanceAmount        = SUM(BalanceAmount)
     , SalesAmountInBase    = SUM(SalesAmountInBase)
     , PurchaseAmountInBase = SUM(PurchaseAmountInBase)
     , BalanceAmountInBase  = SUM(BalanceAmountInBase)
     
FROM   #RecalcEmpActual REA
JOIN !ActiveSchema!.CURRENCY CUR ON CUR.CurrencyCode IN (REA.TransactionCurrency)   /* Rule 13 */

GROUP BY REA.EmployeeCode
       , TransactionPeriodKey
       , CUR.CurrencyCode

ORDER BY EmployeeCode
      , TransactionPeriodKey
      , TransactionCurrency

IF @iv_Mode = @c_Debug
BEGIN

  SELECT *
  FROM #EmpHist
END

IF @iv_Mode IN ( @c_Report, @c_Debug)
BEGIN
  SELECT EH.HistoryPositionId
       , NEH.EmployeeCode
       , HistoryClassificationId = ASCII('\')
       , HistoryCode             = CAST(0x14 + CONVERT(VARBINARY(21), NEH.EmployeeCode) 
                                 + CONVERT(VARBINARY(21), SPACE(24) ) AS VARBINARY(21))
       , NEH.HistoryPeriodKey
       , HistoryCurrencyId = 0

       , SalesAmount           = NEH.SalesAmountInBase
       , PurchaseAmount        = NEH.PurchaseAmountInBase
       , BalanceAmount         = NEH.BalanceAmountInBase
                           
       , HistorySalesAmount    = EH.SalesAmount
       , HistoryPurchaseAmount = EH.PurchaseAmount
       , HistoryBalanceAmount  = EH.BalanceAmount

       , BalDiff = ROUND(NEH.BalanceAmountInBase , 2) - (ROUND(ISNULL(EH.BalanceAmount, 0), 2))

  FROM #EmpHist NEH

  LEFT JOIN !ActiveSchema!.evw_EmployeeHistory EH ON NEH.EmployeeCode       = EH.EmployeeCode            COLLATE SQL_Latin1_General_CP1_CI_AS
                                         AND NEH.HistoryPeriodKey   = EH.HistoryPeriodKey
                                         AND EH.CurrencyId = 0

  WHERE ABS((ROUND(NEH.BalanceAmountInBase, 2)) - (ROUND(ISNULL(EH.BalanceAmount, 0), 2))) > 0.005
END

IF @iv_Mode = @c_Fix
BEGIN
  -- Insert/Update Data if necessary
  SET NOCOUNT OFF;

  MERGE !ActiveSchema!.HISTORY H
  USING
  (
  SELECT EH.HistoryPositionId
       , NEH.EmployeeCode
       , HistoryClassificationId = ASCII('\')
       , HistoryCode             = CAST(0x14 + CONVERT(VARBINARY(21), NEH.EmployeeCode) 
                                 + CONVERT(VARBINARY(21), SPACE(24) ) AS VARBINARY(21))
       , NEH.HistoryPeriodKey
       , HistoryCurrencyId = 0

       , SalesAmount     = NEH.SalesAmountInBase

       , PurchaseAmount  = NEH.PurchaseAmountInBase

       , BalanceAmount   = NEH.BalanceAmountInBase

       , HistorySalesAmount    = EH.SalesAmount
       , HistoryPurchaseAmount = EH.PurchaseAmount
       , HistoryBalanceAmount  = EH.BalanceAmount

       , BalDiff = ROUND(NEH.BalanceAmountInBase , 2) - (ROUND(ISNULL(EH.BalanceAmount, 0), 2))

  FROM #EmpHist NEH

  LEFT JOIN !ActiveSchema!.evw_EmployeeHistory EH ON NEH.EmployeeCode       = EH.EmployeeCode            COLLATE SQL_Latin1_General_CP1_CI_AS
                                         AND NEH.HistoryPeriodKey    = EH.HistoryPeriodKey
                                         AND EH.CurrencyId = 0

  WHERE ABS((ROUND(NEH.BalanceAmountInBase, 2)) - (ROUND(ISNULL(EH.BalanceAmount, 0), 2))) > 0.005

  ) HData ON H.PositionId = HData.HistoryPositionId
  WHEN MATCHED THEN
     UPDATE
        SET hiSales     = HData.SalesAmount
          , hiPurchases = HData.PurchaseAmount

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
     VALUES ( HData.HistoryCode
            , HData.HistoryClassificationId
            , HData.HistoryCurrencyId
            , FLOOR(HData.HistoryPeriodKey / 1000) - 1900
            , HData.HistoryPeriodKey % 1000
            , HData.SalesAmount
            , HData.PurchaseAmount
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

DROP TABLE #EmpHist;

DROP TABLE #RecalcEmpActual;

END
GO

