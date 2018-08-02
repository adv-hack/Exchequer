/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateJobCostingActuals]    Script Date: 02/04/2015 13:47:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateJobCostingActuals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateJobCostingActuals]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RecalculateJobCostingActuals]    Script Date: 02/04/2015 13:47:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Recalculates Job Costing History Actuals 

--       Modes: 0 - Fix the data
--              1 - Report erroneous data
--              2 - Debug 

-- Optional Parameters mainly used for Debug Mode (2)


CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateJobCostingActuals] ( @iv_Mode    INT
                                                            , @iv_jobCode VARCHAR(50) = NULL
                                                            , @iv_Period  INT         = NULL)
AS
BEGIN

SET NOCOUNT ON;

DECLARE @c_Fix    INT = 0
      , @c_Report INT = 1
      , @c_Debug  INT = 2

-- Ignore JobCode and Period Parameters in not in Debug Mode

IF @iv_Mode <> @c_Debug
BEGIN
  SET @iv_JobCode = NULL
  SET @iv_Period  = NULL
END

-- For Debug Purposes
--DECLARE @iv_JobCode VARCHAR(50) = 'CONSIGN1'

CREATE TABLE  #RecalcJobActual 
      ( RecalcJobId          INT IDENTITY  (1, 1)
      , HistArray            INT
      , JobCode              VARCHAR(50)    COLLATE SQL_Latin1_General_CP1_CI_AS
	  , TransactionOurReference VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
      , TransactionTypeCode  VARCHAR(50)    COLLATE SQL_Latin1_General_CP1_CI_AS
      , TransactionTypeSign  INT
      , AnalysisHistoryId    INT   NULL 
      , AnalysisCode         VARCHAR(50)    COLLATE SQL_Latin1_General_CP1_CI_AS NULL
      , AnalysisType         INT
      , TransactionPeriodKey INT
      , TransactionCurrency  INT
      , PostedCompanyRate    FLOAT
      , PostedDailyRate      FLOAT
      , IsInvoiced           BIT
      , IsReversed           BIT
      , IsRevenue            BIT   NULL
      , JobStatus            INT        -- Stores Status of Original Job so can be ignored for WIP Generation
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
--      , PRIMARY KEY CLUSTERED (JobCode, AnalysisHistoryId, AnalysisCode, RecalcJobId)
      )

INSERT INTO #RecalcJobActual
SELECT HistArray = 1
     , JASC.AscendantJobCode
     , JA.TransactionOurReference
     , TT.TransactionTypeCode
     , TT.TransactionTypeSign
     , NULL
     , JA.AnalysisCode
     , JA.JobAnalysisType
     , JA.TransactionPeriodKey 
     , JA.TransactionCurrency
     , JA.PostedCompanyRate
     , JA.PostedDailyRate
     , JA.IsInvoiced
     , IsReversed         = CASE
                            WHEN JA.IsReversed = 1 AND JA.ReverseWIPElement = 1 THEN 1
                            ELSE 0
                            END
     , IsRevenue          = NULL
     , JOB.JobStat
     , JA.Quantity
     , JA.Cost
     , BA.CostInBase
     , PostedAmount       =  common.ifn_ExchRnd(CASE
                                                WHEN TransactionTypeCode IN ('JCT', 'JST', 'JPT', 'JSA', 'JPA') THEN JA.Cost * TT.TransactionTypeSign /* Rule 5 */
                                                ELSE JA.Quantity * JA.Cost * TT.TransactionTypeSign /* Rule 6 */
                                                END, 2)
     , PostedAmountInBase =  common.ifn_ExchRnd(CASE
                                                WHEN TransactionTypeCode IN ('JCT', 'JST', 'JPT', 'JSA', 'JPA') THEN BA.CostInBase * TT.TransactionTypeSign /* Rule 5 */
                                                ELSE JA.Quantity * BA.CostInBase * TT.TransactionTypeSign /* Rule 6 */
                                                END, 2)
     , NULL
     , NULL
     , NULL
     , NULL
     , NULL
     , NULL

FROM  !ActiveSchema!.evw_JobActual    JA
JOIN  !ActiveSchema!.evw_Job          JOB  ON JA.JobCode   = JOB.JobCode COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN  !ActiveSchema!.evw_JobAscendant JASC ON JASC.JobCode = JA.JobCode COLLATE SQL_Latin1_General_CP1_CI_AS

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
WHERE 1 = 1
AND   JA.IsPosted = 1
AND   JA.LinePostedStatus > 0
AND   JA.Cost <> 0
AND   JA.AnalysisCode <> ''
AND   TT.TransactionTypeCode IN ('SOR','POR','SDN','PDN', 'JCT', 'JST') /* Rule 3 */
AND  (JA.JobCode = @iv_JobCode OR @iv_JobCode Is NULL)
AND  (JA.TransactionPeriodKey = @iv_Period OR @iv_Period IS NULL)

-- Set the Relevant Analysis History Id
UPDATE RJA
SET  AnalysisHistoryId = CASE
                         WHEN TransactionTypeCode IN ('JSA', 'JPA') THEN RJA.AnalysisType
                         ELSE JCA.AnalysisHistoryId
                         END
  ,  IsRevenue         = JCA.IsRevenue
FROM #RecalcJobActual RJA
JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCA ON RJA.JobCode      = JCA.JobCode
                                       AND RJA.AnalysisCode = JCA.AnalysisCode

-- Set the Analysis History Id for the NULL values
UPDATE RJA
SET  AnalysisHistoryId = JC.CategoryHistoryId
  ,  IsRevenue         = CASE
                         WHEN JC.JobCategoryId = 1 THEN CONVERT(BIT, 1)
                         ELSE CONVERT(BIT, 0)
                         END
FROM #RecalcJobActual RJA
JOIN !ActiveSchema!.evw_JobAnalysis JAN ON JAN.JobAnalysisCode = RJA.AnalysisCode
JOIN !ActiveSchema!.evw_JobCategory JC ON JAN.JobAnalysisCategoryId = JC.JobCategoryId
WHERE RJA.AnalysisHistoryId IS NULL

-- Calculate Sales Amount, Purchase Amount and Balance

UPDATE RJA
   SET SalesAmount    = CASE
                        WHEN PostedAmount < 0 THEN ABS(PostedAmount)
                        ELSE 0
                        END
     , PurchaseAmount = CASE
                        WHEN PostedAmount > 0 THEN ABS(PostedAmount)
                        ELSE 0
                        END
     , BalanceAmount  = CASE
                        WHEN PostedAmount > 0 THEN ABS(PostedAmount)
                        ELSE 0
                        END
                      - CASE
                        WHEN PostedAmount < 0 THEN ABS(PostedAmount)
                        ELSE 0
                        END
     , SalesAmountInBase    = CASE
                              WHEN PostedAmountInBase < 0 THEN ABS(PostedAmountInBase)
                              ELSE 0
                              END
     , PurchaseAmountInBase = CASE
                              WHEN PostedAmountInBase > 0 THEN ABS(PostedAmountInBase)
                              ELSE 0
                              END
     , BalanceAmountInBase  = CASE
                              WHEN PostedAmountInBase > 0 THEN ABS(PostedAmountInBase)
                              ELSE 0
                              END
                            - CASE
                              WHEN PostedAmountInBase < 0 THEN ABS(PostedAmountInBase)
                              ELSE 0
                              END
FROM   #RecalcJobActual RJA

IF @iv_Mode = @c_Debug
BEGIN
  SELECT 'After Initial Load & Updates'
       , *
  FROM   #RecalcJobActual
END

-- Now Insert Parent Analysis (HistArray = 2)
INSERT INTO #RecalcJobActual
SELECT HistArray = 2
     , RJA.JobCode
     , RJA.TransactionOurReference
     , RJA.TransactionTypeCode
     , RJA.TransactionTypeSign
     , JCA.CategoryHistoryId
     , RJA.AnalysisCode           
     , RJA.AnalysisType
     , RJA.TransactionPeriodKey
     , RJA.TransactionCurrency
     , RJA.PostedCompanyRate
     , RJA.PostedDailyRate
     , RJA.IsInvoiced
     , RJA.IsReversed
     , RJA.IsRevenue
     , RJA.JobStatus
     , RJA.Quantity
     , RJA.Cost
     , RJA.CostInBase
     , RJA.PostedAmount
     , RJA.PostedAmountInBase
     , RJA.SalesAmount
     , RJA.SalesAmountInBase
     , RJA.PurchaseAmount
     , RJA.PurchaseAmountInBase
     , RJA.BalanceAmount
     , RJA.BalanceAmountInBase

FROM   #RecalcJobActual RJA
JOIN !ActiveSchema!.evw_JobCategoryAnalysis JCA ON RJA.JobCode      = JCA.JobCode
                                       AND RJA.AnalysisCode = JCA.AnalysisCode

JOIN !ActiveSchema!.evw_JobAnalysis JAN ON JAN.JobAnalysisCode = RJA.AnalysisCode

WHERE RJA.HistArray = 1
AND   RJA.TransactionTypeCode NOT IN ('JPA', 'JSA')
AND   JAN.JobAnalysisCategoryId <> 8

--IF @iv_Mode = @c_Debug
--BEGIN
--  SELECT 'After Parent Analysis'
--       , *
--  FROM   #RecalcJobActual
--  WHERE  TransactionOurReference = 'PPI000500'
--END

-- Rule 19  - Switch Sales & Purchase if JSA or Revenue

UPDATE RJA
   SET SalesAmount          = PurchaseAmount
     , PurchaseAmount       = SalesAmount
     , BalanceAmount        = SalesAmount - PurchaseAmount
     , SalesAmountInBase    = PurchaseAmountInBase
     , PurchaseAmountInBase = SalesAmountInBase
     , BalanceAmountInBase  = SalesAmountInBase - PurchaseAmountInBase
FROM   #RecalcJobActual RJA
WHERE HistArray IN (1, 2)
  AND ( RJA.IsRevenue  = 1 
   OR   RJA.TransactionTypeCode = 'JSA'
      )

IF @iv_Mode = @c_Debug
BEGIN
  SELECT 'After Rule 19'
       , *
  FROM   #RecalcJobActual
END

-- Insert Stock Analysis (HistArray = 3)

-- Insert WIP (170) (HistArray = 4)

INSERT INTO #RecalcJobActual
SELECT HistArray = 4
     , RJA.JobCode
     , RJA.TransactionOurReference
     , RJA.TransactionTypeCode
     , RJA.TransactionTypeSign
     , 170
     , RJA.AnalysisCode           -- May need to use 170
     , RJA.AnalysisType
     , RJA.TransactionPeriodKey
     , RJA.TransactionCurrency
     , RJA.PostedCompanyRate
     , RJA.PostedDailyRate
     , RJA.IsInvoiced
     , RJA.IsReversed
     , RJA.IsRevenue
     , RJA.JobStatus
     , RJA.Quantity
     , RJA.Cost
     , RJA.CostInBase
     , RJA.PostedAmount
     , RJA.PostedAmountInBase
     , RJA.SalesAmount
     , RJA.SalesAmountInBase
     , RJA.PurchaseAmount
     , RJA.PurchaseAmountInBase
     , RJA.BalanceAmount
     , RJA.BalanceAmountInBase

FROM #RecalcJobActual RJA
JOIN !ActiveSchema!.evw_JobAnalysis JAN ON JAN.JobAnalysisCode = RJA.AnalysisCode   COLLATE SQL_Latin1_General_CP1_CI_AS

WHERE RJA.HistArray = 2           -- Based on Parent Row
AND   RJA.TransactionTypeCode NOT IN ('JPA', 'JSA')
AND   RJA.TransactionTypeCode NOT IN ('SOR', 'POR', 'SDN', 'PDN', 'JCT', 'JST', 'JSA','JPA')
AND   JAN.JobAnalysisCategoryId <> 8
AND   RJA.AnalysisHistoryId < 60
AND   RJA.AnalysisHistoryId NOT IN ( 5, 10, 14)
AND  (RJA.JobStatus NOT IN (4, 5) OR RJA.IsReversed = 1)

IF @iv_Mode = @c_Debug
BEGIN
  SELECT 'After WIP Insert'
       , *
  FROM   #RecalcJobActual
END

-- Insert Profit (99) (HistArray = 5)

INSERT INTO #RecalcJobActual
SELECT HistArray = 5
     , RJA.JobCode
     , RJA.TransactionOurReference
     , RJA.TransactionTypeCode
     , RJA.TransactionTypeSign
     , 99
     , RJA.AnalysisCode           -- May need to use 99
     , RJA.AnalysisType
     , RJA.TransactionPeriodKey
     , RJA.TransactionCurrency
     , RJA.PostedCompanyRate
     , RJA.PostedDailyRate
     , RJA.IsInvoiced
     , RJA.IsReversed
     , RJA.IsRevenue
     , RJA.JobStatus
     , RJA.Quantity
     , RJA.Cost
     , RJA.CostInBase
     , RJA.PostedAmount
     , RJA.PostedAmountInBase
     , RJA.SalesAmount
     , RJA.SalesAmountInBase
     , RJA.PurchaseAmount
     , RJA.PurchaseAmountInBase
     , RJA.BalanceAmount
     , RJA.BalanceAmountInBase

FROM #RecalcJobActual RJA
JOIN !ActiveSchema!.evw_JobAnalysis JAN ON JAN.JobAnalysisCode       = RJA.AnalysisCode   COLLATE SQL_Latin1_General_CP1_CI_AS
JOIN !ActiveSchema!.evw_JobCategory JAC ON JAN.JobAnalysisCategoryId = JAC.JobCategoryId 
WHERE RJA.HistArray = 1
AND   RJA.TransactionTypeCode NOT IN ('JPA', 'JSA')
AND   RJA.TransactionTypeCode NOT IN ('SOR', 'POR', 'SDN', 'PDN', 'JCT', 'JST')
AND   JAN.JobAnalysisCategoryId <> 8
AND   JAC.CategoryHistoryId     <= 67

IF @iv_Mode = @c_Debug
BEGIN
  SELECT 'After Profit Insert'
       , *
  FROM   #RecalcJobActual
END

-- Rule 30 - Switch Sales & Purchase on Profit (99) if not revenue

UPDATE RJA
   SET SalesAmount    = PurchaseAmount
     , PurchaseAmount = SalesAmount
     , BalanceAmount  = SalesAmount - PurchaseAmount
     , SalesAmountInBase    = PurchaseAmountInBase
     , PurchaseAmountInBase = SalesAmountInBase
     , BalanceAmountInBase  = SalesAmountInBase - PurchaseAmountInBase
FROM   #RecalcJobActual RJA
WHERE  RJA.HistArray         = 5
AND    RJA.AnalysisHistoryId = 99
AND    RJA.IsRevenue         = 0

IF @iv_Mode = @c_Debug
BEGIN
  SELECT 'After Rule 30'
       , *
  FROM   #RecalcJobActual
END

CREATE TABLE #JobHist
      ( JobCode              VARCHAR(50)
      , AnalysisHistoryId    INT
      , HistoryPeriodKey     INT
      , HistoryCurrencyId    INT
      , SalesAmount          FLOAT
      , PurchaseAmount       FLOAT
      , BalanceAmount        FLOAT
      , SalesAmountInBase    FLOAT
      , PurchaseAmountInBase FLOAT
      , BalanceAmountInBase  FLOAT
      , PRIMARY KEY CLUSTERED (JobCode, AnalysisHistoryId, HistoryPeriodKey, HistoryCurrencyId )
      )

INSERT INTO #JobHist
SELECT JobCode 
     , AnalysisHistoryId    =  RJA.AnalysisHistoryId
     , TransactionPeriodKey
     , TransactionCurrency  = CUR.CurrencyCode
     , SalesAmount          = SUM(SalesAmount)
     , PurchaseAmount       = SUM(PurchaseAmount)
     , BalanceAmount        = SUM(BalanceAmount)
     , SalesAmountInBase    = SUM(SalesAmountInBase)
     , PurchaseAmountInBase = SUM(PurchaseAmountInBase)
     , BalanceAmountInBase  = SUM(BalanceAmountInBase)
     
FROM   #RecalcJobActual RJA
JOIN !ActiveSchema!.CURRENCY CUR ON CUR.CurrencyCode IN (0, RJA.TransactionCurrency)   /* Rule 13 */

GROUP BY RJA.JobCode
       , RJA.AnalysisHistoryId
       , TransactionPeriodKey
       , CUR.CurrencyCode

ORDER BY JobCode
      , AnalysisHistoryId
      , TransactionPeriodKey
      , TransactionCurrency

IF @iv_Mode IN (@c_Report, @c_Debug)
BEGIN
  SELECT JH.HistoryPositionId
       , NJH.JobCode
       , HistoryClassificationId = ASCII('[')
       , HistoryCode             = CAST(0x14 + CONVERT(VARBINARY(21), NJH.JobCode + SPACE(10 - LEN(NJH.JobCode))) 
                                 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), NJH.AnalysisHistoryId)))
                                 + CONVERT(VARBINARY(21), SPACE(6)) AS VARBINARY(21))
       , NJH.AnalysisHistoryId
       , NJH.HistoryPeriodKey
       , NJH.HistoryCurrencyId

       , SalesAmount     = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.SalesAmountInBase
                           ELSE NJH.SalesAmount
                           END
       , PurchaseAmount  = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.PurchaseAmountInBase
                           ELSE NJH.PurchaseAmount
                           END
       , BalanceAmount   = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.BalanceAmountInBase
                           ELSE NJH.BalanceAmount
                           END
       , HistorySalesAmount    = JH.SalesAmount
       , HistoryPurchaseAmount = JH.PurchaseAmount
       , HistoryBalanceAmount  = JH.BalanceAmount

       , BalDiff = CASE
	               WHEN NJH.HistoryCurrencyId = 0 THEN ROUND(NJH.BalanceAmountInBase , 2)
				   ELSE ROUND(NJH.BalanceAmount, 2)
				   END - (ROUND(ISNULL(JH.BalanceAmount, 0), 2))

  FROM #JobHist NJH
  JOIN !ActiveSchema!.evw_Job  JOB ON NJH.JobCode = JOB.JobCode                                COLLATE SQL_Latin1_General_CP1_CI_AS

  LEFT JOIN !ActiveSchema!.evw_JobCostingHistory JH ON NJH.JobCode            = JH.JobCode            COLLATE SQL_Latin1_General_CP1_CI_AS
                                           AND NJH.AnalysisHistoryId  = JH.AnalysisHistoryId
                                           AND NJH.HistoryPeriodKey   = JH.HistoryPeriodKey
                                           AND NJH.HistoryCurrencyId  = JH.CurrencyId

  WHERE CASE
        WHEN NJH.HistoryCurrencyId = 0 THEN ABS((ROUND(NJH.BalanceAmountInBase, 2)) - (ROUND(ISNULL(JH.BalanceAmount, 0), 2)))
        ELSE ABS((ROUND(NJH.BalanceAmount, 2)) - (ROUND(ISNULL(JH.BalanceAmount, 0), 2))) 
        END > 0.005

END

IF @iv_Mode = @c_Fix
BEGIN
  -- Insert/Update Data if necessary
  SET NOCOUNT OFF;

  MERGE !ActiveSchema!.HISTORY H
  USING
  (
  SELECT JH.HistoryPositionId
       , NJH.JobCode
       , HistoryClassificationId = ASCII('[')
       , HistoryCode             = CAST(0x14 + CONVERT(VARBINARY(21), NJH.JobCode + SPACE(10 - LEN(NJH.JobCode))) 
                                 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), NJH.AnalysisHistoryId)))
                                 + CONVERT(VARBINARY(21), SPACE(6)) AS VARBINARY(21))
       , NJH.AnalysisHistoryId
       , NJH.HistoryPeriodKey
       , NJH.HistoryCurrencyId

       , SalesAmount     = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.SalesAmountInBase
                           ELSE NJH.SalesAmount
                           END
       , PurchaseAmount  = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.PurchaseAmountInBase
                           ELSE NJH.PurchaseAmount
                           END
       , BalanceAmount   = CASE
                           WHEN NJH.HistoryCurrencyId = 0 THEN NJH.BalanceAmountInBase
                           ELSE NJH.BalanceAmount
                           END
       , HistorySalesAmount    = JH.SalesAmount
       , HistoryPurchaseAmount = JH.PurchaseAmount
       , HistoryBalanceAmount  = JH.BalanceAmount

       , BalDiff = CASE
	               WHEN NJH.HistoryCurrencyId = 0 THEN ROUND(NJH.BalanceAmountInBase , 2)
				   ELSE ROUND(NJH.BalanceAmount, 2)
				   END - (ROUND(ISNULL(JH.BalanceAmount, 0), 2))

  FROM #JobHist NJH
  JOIN !ActiveSchema!.evw_Job  JOB ON NJH.JobCode = JOB.JobCode                                COLLATE SQL_Latin1_General_CP1_CI_AS

  LEFT JOIN !ActiveSchema!.evw_JobCostingHistory JH ON NJH.JobCode            = JH.JobCode            COLLATE SQL_Latin1_General_CP1_CI_AS
                                           AND NJH.AnalysisHistoryId  = JH.AnalysisHistoryId
                                           AND NJH.HistoryPeriodKey   = JH.HistoryPeriodKey
                                           AND NJH.HistoryCurrencyId  = JH.CurrencyId

  WHERE CASE
        WHEN NJH.HistoryCurrencyId = 0 THEN ABS((ROUND(NJH.BalanceAmountInBase, 2)) - (ROUND(ISNULL(JH.BalanceAmount, 0), 2)))
        ELSE ABS((ROUND(NJH.BalanceAmount, 2)) - (ROUND(ISNULL(JH.BalanceAmount, 0), 2))) 
        END > 0.005

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

DROP TABLE #JobHist;

DROP TABLE #RecalcJobActual;

END


GO


