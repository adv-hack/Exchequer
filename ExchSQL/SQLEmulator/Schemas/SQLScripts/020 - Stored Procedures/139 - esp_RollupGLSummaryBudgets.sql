/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLBudgets]    Script Date: 04/25/2016 10:46:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RollupGLSummaryBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RollupGLSummaryBudgets]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLSummaryBudgets]    Script Date: 04/25/2016 10:46:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [!ActiveSchema!].[esp_RollupGLSummaryBudgets] ( @iv_SummarisationLevel VARCHAR(3) = 'C' )
AS
BEGIN

  SET NOCOUNT ON;

  -- Create/Update any summary level consolidated budgets from the currency children
  MERGE !ActiveSchema!.HISTORY H
  USING(
  SELECT HistoryClassificationCode
       , HistoryCode
       , NominalCode
       , CostCentreDepartmentFlag
       , CurrencyId = 0
       , CostCentreCode
       , DepartmentCode
       , HistoryPeriodKey
       , OriginalBudget    = SUM(ROUND(Budgets.OriginalBudget, 2) )
       , RevisedBudget1    = SUM(ROUND(Budgets.RevisedBudget1, 2) )
       , RevisedBudget2    = SUM(ROUND(Budgets.RevisedBudget2, 2) )
       , RevisedBudget3    = SUM(ROUND(Budgets.RevisedBudget3, 2) )
       , RevisedBudget4    = SUM(ROUND(Budgets.RevisedBudget4, 2) )
       , RevisedBudget5    = SUM(ROUND(Budgets.RevisedBudget5, 2) )

  FROM !ActiveSchema!.evw_NominalHistory GLBH
  JOIN !ActiveSchema!.CURRENCY C ON GLBH.CurrencyId = C.CurrencyCode
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS

  CROSS APPLY ( VALUES ( (CASE
                          WHEN C.CurrencyCode NOT IN (0, 1) AND SS.UseCompanyRate = 1 THEN C.CompanyRate
                          WHEN C.CurrencyCode NOT IN (0, 1) AND SS.UseCompanyRate = 0 THEN C.DailyRate
                          ELSE 1
                          END
                         )
                     )
            ) Rates ( ConversionRate
                    )
  CROSS APPLY ( VALUES ( ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN OriginalBudgetAmount
                           ELSE common.efn_ExchequerCurrencyConvert( OriginalBudgetAmount
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       , ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudgetAmount1
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudgetAmount1
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       , ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudgetAmount2
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudgetAmount2
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       , ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudgetAmount3
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudgetAmount3
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       , ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudgetAmount4
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudgetAmount5
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       , ( CASE
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudgetAmount5
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudgetAmount5
                                                                   , ConversionRate
                                                                   , GLBH.CurrencyId
                                                                   , 0
                                                                   , 0
                                                                   , C.TriRate
                                                                   , C.TriInverted
                                                                   , C.TriCurrencyCode
                                                                   , C.IsFloating
                                                                   )
                          END
                         )
                       )
              ) Budgets ( OriginalBudget
                        , RevisedBudget1
                        , RevisedBudget2
                        , RevisedBudget3
                        , RevisedBudget4
                        , RevisedBudget5
                        )
  WHERE GLBH.CurrencyId <> 0
  AND   GLBH.CostCentreDepartmentFlag IS NULL
  AND   GLBH.HistoryClassificationCode IN ('A','B','C')
  AND  (GLBH.OriginalBudgetAmount <> 0
   OR   GLBH.RevisedBudgetAmount1 <> 0
   OR   GLBH.RevisedBudgetAmount2 <> 0
   OR   GLBH.RevisedBudgetAmount3 <> 0
   OR   GLBH.RevisedBudgetAmount4 <> 0
   OR   GLBH.RevisedBudgetAmount5 <> 0
       )
 
  --AND NOT EXISTS (SELECT TOP 1 1
  --                FROM   !ActiveSchema!.evw_NominalHistory NH0
  --                WHERE GLBH.HistoryClassificationCode = NH0.HistoryClassificationCode
  --                AND   GLBH.HistoryCode               = NH0.HistoryCode
  --                AND   GLBH.HistoryPeriodKey          = NH0.HistoryPeriodKey
  --                AND   NH0.CostCentreDepartmentFlag  IS NULL
  --                AND   NH0.CurrencyId                 = 0
  --                AND  (NH0.OriginalBudgetAmount      <> 0
  --                 OR   NH0.RevisedBudgetAmount1      <> 0
  --                 OR   NH0.RevisedBudgetAmount2      <> 0
  --                 OR   NH0.RevisedBudgetAmount3      <> 0
  --                 OR   NH0.RevisedBudgetAmount4      <> 0
  --                 OR   NH0.RevisedBudgetAmount5      <> 0
  --                     )
  --               )
  GROUP BY HistoryClassificationCode
         , HistoryCode
         , NominalCode
         , CostCentreDepartmentFlag
         , CostCentreCode
         , DepartmentCode
         , HistoryPeriodKey

  ) BData ON H.hiExCLass  = ASCII(BData.HistoryClassificationCode)
         AND H.hiCode     = BData.HistoryCode
         AND H.hiCurrency = BData.CurrencyId
         AND H.hiYear     = FLOOR(BData.HistoryPeriodKey/1000) - 1900
         AND H.hiPeriod   = BData.HistoryPeriodKey%1000
         
  WHEN NOT MATCHED BY TARGET THEN
          INSERT ( hiCode
                 , hiExCLass
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
       VALUES    ( HistoryCode
                 , ASCII(HistoryClassificationCode)
                 , CurrencyId
                 , FLOOR(BData.HistoryPeriodKey/1000) - 1900
                 , HistoryPeriodKey%1000
                 , 0
                 , 0
                 , OriginalBudget
                 , 0
                 , RevisedBudget1
                 , 0
                 , 0
                 , 0
                 , RevisedBudget2
                 , RevisedBudget3
                 , RevisedBudget4
                 , RevisedBudget5
                 , 0
                 )
                   
  WHEN MATCHED AND ( hiBudget         <> OriginalBudget
                  OR hiRevisedBudget1 <> RevisedBudget1
                  OR hiRevisedBudget2 <> RevisedBudget2
                  OR hiRevisedBudget3 <> RevisedBudget3
                  OR hiRevisedBudget4 <> RevisedBudget4
                  OR hiRevisedBudget5 <> RevisedBudget5
                   ) THEN
       UPDATE
          SET hiBudget         = OriginalBudget
            , hiRevisedBudget1 = RevisedBudget1
            , hiRevisedBudget2 = RevisedBudget2
            , hiRevisedBudget3 = RevisedBudget3
            , hiRevisedBudget4 = RevisedBudget4
            , hiRevisedBudget5 = RevisedBudget5
  ;
  
  -- Create/Update the Nominal Level summary 
  
  MERGE !ActiveSchema!.HISTORY H
  USING ( SELECT HistoryClassificationCode
                , HistoryCode = CONVERT(VARBINARY(21),
                                0x14
                              + SUBSTRING(CONVERT(VARBINARY(21), NH.NominalCode), 4, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NH.NominalCode), 3, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NH.NominalCode), 2, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NH.NominalCode), 1, 1)
                              + CONVERT(VARBINARY(21), SPACE(20))
                               )
                , NominalCode
                , ExchequerYear
                , ExchequerPeriod
                , CurrencyId

                , OriginalBudget = SUM(OriginalBudgetAmount)
                , RevisedBudget1 = SUM(RevisedBudgetAmount1)
                , RevisedBudget2 = SUM(RevisedBudgetAmount2)
                , RevisedBudget3 = SUM(RevisedBudgetAmount3)
                , RevisedBudget4 = SUM(RevisedBudgetAmount4)
                , RevisedBudget5 = SUM(RevisedBudgetAmount5)

           FROM   !ActiveSchema!.evw_NominalHistory NH
           WHERE ( ( @iv_SummarisationLevel IN ('C', 'C+D') AND NH.CostCentreDepartmentFlag = 'C' AND NH.DepartmentCode IS NULL )
                OR ( @iv_SummarisationLevel IN ('D', 'C+D') AND NH.CostCentreDepartmentFlag = 'D' AND NH.CostCentreCode IS NULL )
                 ) 
           AND NH.HistoryClassificationCode IN ('A','B','C')
           AND (NH.OriginalBudgetAmount <> 0
             OR NH.RevisedBudgetAmount1 <> 0
             OR NH.RevisedBudgetAmount2 <> 0
             OR NH.RevisedBudgetAmount3 <> 0
             OR NH.RevisedBudgetAmount4 <> 0
             OR NH.RevisedBudgetAmount5 <> 0
               )

           GROUP BY HistoryClassificationCode
                  , NominalCode
                  , ExchequerYear
                  , ExchequerPeriod
                  , CurrencyId

          ) BData ON H.hiExCLass  = ASCII(BData.HistoryClassificationCode)
                 AND H.hiCode     = BData.HistoryCode
                 AND H.hiCurrency = BData.CurrencyId
                 AND H.hiYear     = BData.ExchequerYear
                 AND H.hiPeriod   = BData.ExchequerPeriod
         
  WHEN NOT MATCHED BY TARGET THEN
          INSERT ( hiCode
                 , hiExCLass
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
       VALUES    ( HistoryCode
                 , ASCII(HistoryClassificationCode)
                 , CurrencyId
                 , ExchequerYear
                 , ExchequerPeriod
                 , 0
                 , 0
                 , OriginalBudget
                 , 0
                 , RevisedBudget1
                 , 0
                 , 0
                 , 0
                 , RevisedBudget2
                 , RevisedBudget3
                 , RevisedBudget4
                 , RevisedBudget5
                 , 0
                 )
                   
  WHEN MATCHED AND ( hiBudget         <> OriginalBudget
                  OR hiRevisedBudget1 <> RevisedBudget1
                  OR hiRevisedBudget2 <> RevisedBudget2
                  OR hiRevisedBudget3 <> RevisedBudget3
                  OR hiRevisedBudget4 <> RevisedBudget4
                  OR hiRevisedBudget5 <> RevisedBudget5
                   ) THEN
       UPDATE
          SET hiBudget         = OriginalBudget
            , hiRevisedBudget1 = RevisedBudget1
            , hiRevisedBudget2 = RevisedBudget2
            , hiRevisedBudget3 = RevisedBudget3
            , hiRevisedBudget4 = RevisedBudget4
            , hiRevisedBudget5 = RevisedBudget5
  ;

    -- Reset Header Nominal Budgets to 0

  UPDATE GLBH
     SET OriginalBudgetAmount = 0
       , RevisedBudgetAmount1 = 0
       , RevisedBudgetAmount2 = 0
       , RevisedBudgetAmount3 = 0
       , RevisedBudgetAmount4 = 0
       , RevisedBudgetAmount5 = 0

  FROM !ActiveSchema!.evw_NominalHistory GLBH
  WHERE 1 = 1
  AND ( GLBH.OriginalBudgetAmount <> 0
   OR   GLBH.RevisedBudgetAmount1 <> 0
   OR   GLBH.RevisedBudgetAmount2 <> 0
   OR   GLBH.RevisedBudgetAmount3 <> 0
   OR   GLBH.RevisedBudgetAmount4 <> 0
   OR   GLBH.RevisedBudgetAmount5 <> 0
      )
  --AND GLBH.CostCentreDepartmentFlag IS NULL
  AND GLBH.HistoryClassificationCode = 'H'

  -- now rollup the Nominal Tree
  -- It is faster to load data into temp. table and update PositionId and use this in MERGE
  -- than a MERGE using single select

  IF OBJECT_ID('tempdb..#GLBudgetHistory') IS NOT NULL
     DROP TABLE #GLBudgetHistory

  CREATE TABLE #GLBudgetHistory
             ( HistoryPositionId              INT            NULL
             , HistoryClassificationCode      VARCHAR(3)
             , HistoryCode                    VARBINARY(21)  NULL
             , NominalCode                    INT
             , CostCentreDepartmentFlag       VARCHAR(1)     NULL
             , CurrencyId                     INT
             , HistoryPeriodKey               INT
             , CostCentreCode                 VARCHAR(3)     NULL
             , DepartmentCode                 VARCHAR(3)     NULL
             , OriginalBudget                 FLOAT
             , RevisedBudget1                 FLOAT
             , RevisedBudget2                 FLOAT
             , RevisedBudget3                 FLOAT
             , RevisedBudget4                 FLOAT
             , RevisedBudget5                 FLOAT
             )

  CREATE NONCLUSTERED INDEX idx_TempGLBudgetHistory ON #GLBudgetHistory
       ( HistoryClassificationCode
       , NominalCode
       , CostCentreDepartmentFlag
       , CurrencyId
       , HistoryPeriodKey
       , CostCentreCode
       , DepartmentCode
       )

  INSERT INTO #GLBudgetHistory
            ( HistoryCode
            , HistoryClassificationCode
            , NominalCode
            , CostCentreDepartmentFlag
            , CurrencyId
            , HistoryPeriodKey
            , CostCentreCode
            , DepartmentCode
            , OriginalBudget
            , RevisedBudget1
            , RevisedBudget2
            , RevisedBudget3
            , RevisedBudget4
            , RevisedBudget5
            )
  SELECT HistoryCode = CONVERT(VARBINARY(21), 
                                0x14
                              + CONVERT(VARBINARY(21), 
                                CASE
                                WHEN GLBH.CostCentreDepartmentFlag IS NOT NULL THEN GLBH.CostCentreDepartmentFlag
                                ELSE ''
                                END)
                              + SUBSTRING(CONVERT(VARBINARY(21), NA.AscendantNominalCode), 4, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NA.AscendantNominalCode), 3, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NA.AscendantNominalCode), 2, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), NA.AscendantNominalCode), 1, 1)
                              + CONVERT(VARBINARY(21), 
                                CASE
                                WHEN GLBH.CostCentreDepartmentFlag = 'C' THEN ISNULL(GLBH.CostCentreCode, SPACE(3))
                                ELSE ISNULL(GLBH.DepartmentCode, SPACE(3))
                                END
                                )
                              + CONVERT(VARBINARY(21),
                                CASE
                                WHEN GLBH.CostCentreDepartmentFlag = 'C' AND GLBH.DepartmentCode IS NOT NULL THEN CHAR(2)
                                WHEN GLBH.CostCentreDepartmentFlag = 'D' AND GLBH.CostCentreCode IS NOT NULL THEN CHAR(1)
                                ELSE ''
                                END
                                )
                              + CONVERT(VARBINARY(21),
                                CASE
                                WHEN GLBH.CostCentreDepartmentFlag = 'C' THEN ISNULL(GLBH.DepartmentCode, SPACE(3))
                                ELSE ISNULL(GLBH.CostCentreCode, SPACE(3))
                                END
                                )
                              + CONVERT(VARBINARY(21), SPACE(20))
                                )
       , N.NominalTypeCode
       , NA.AscendantNominalCode
       , GLBH.CostCentreDepartmentFlag 
       , GLBH.CurrencyId
       , GLBH.HistoryPeriodKey
       , GLBH.CostCentreCode
       , GLBH.DepartmentCode
       , OriginalBudget    = SUM(GLBH.OriginalBudgetAmount)
       , RevisedBudget1    = SUM(GLBH.RevisedBudgetAmount1)
       , RevisedBudget2    = SUM(GLBH.RevisedBudgetAmount2)
       , RevisedBudget3    = SUM(GLBH.RevisedBudgetAmount3)
       , RevisedBudget4    = SUM(GLBH.RevisedBudgetAmount4)
       , RevisedBudget5    = SUM(GLBH.RevisedBudgetAmount5)
  FROM !ActiveSchema!.evw_NominalHistory GLBH
  JOIN !ActiveSchema!.evw_NominalAscendant NA ON NA.NominalCode           = GLBH.NominalCode
                                     AND NA.AscendantNominalCode <> GLBH.NominalCode
  JOIN !ActiveSchema!.evw_Nominal N ON NA.AscendantNominalCode = N.NominalCode

  WHERE GLBH.HistoryPeriod < 250
  AND   GLBH.HistoryClassificationCode IN ('A','B','C')

  AND  (GLBH.OriginalBudgetAmount <> 0
   OR   GLBH.RevisedBudgetAmount1 <> 0
   OR   GLBH.RevisedBudgetAmount2 <> 0
   OR   GLBH.RevisedBudgetAmount3 <> 0
   OR   GLBH.RevisedBudgetAmount4 <> 0
   OR   GLBH.RevisedBudgetAmount5 <> 0
       )

  GROUP BY N.NominalTypeCode
         , NA.AScendantNominalCode
         , GLBH.CostCentreDepartmentFlag 
         , GLBH.CurrencyId
         , GLBH.HistoryPeriodKey
         , GLBH.CostCentreCode
         , GLBH.DepartmentCode

  -- Update PositionId

  UPDATE GLBH
     SET HistoryPositionId = NH.HistoryPositionId
  FROM #GLBudgetHistory GLBH
  LEFT JOIN !ActiveSchema!.evw_NominalHistory NH ON GLBH.HistoryClassificationCode            = NH.HistoryClassificationCode            COLLATE Latin1_General_CI_AS
                                        AND GLBH.CurrencyId                           = NH.CurrencyId
                                        AND GLBH.HistoryPeriodKey                     = NH.HistoryPeriodKey
                                        AND GLBH.NominalCode                          = NH.NominalCode
                                        AND ISNULL(GLBH.CostCentreDepartmentFlag, '') = ISNULL(NH.CostCentreDepartmentFlag, '') COLLATE Latin1_General_CI_AS
                                        AND ISNULL(GLBH.CostCentreCode, '')           = ISNULL(NH.CostCentreCode, '')           COLLATE Latin1_General_CI_AS
                                        AND ISNULL(GLBH.DepartmentCode, '')           = ISNULL(NH.DepartmentCode, '')           COLLATE Latin1_General_CI_AS
  WHERE GLBH.HistoryPositionId IS NULL
  
  MERGE !ActiveSchema!.HISTORY H
  USING ( SELECT HistoryPositionId
               , HistoryClassificationCode
               , HistoryCode
               , CurrencyId
               , ExchequerYear   = FLOOR(HistoryPeriodKey/1000) - 1900
               , ExchequerPeriod = HistoryPeriodKey%1000
               , OriginalBudget
               , RevisedBudget1
               , RevisedBudget2
               , RevisedBudget3
               , RevisedBudget4
               , RevisedBudget5
          FROM   #GLBudgetHistory ) GLBHData ON H.PositionId = GLBHData.HistoryPositionId
  WHEN NOT MATCHED BY TARGET THEN
       INSERT    ( hiCode
                 , hiExCLass
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
       VALUES    ( HistoryCode
                 , ASCII(HistoryClassificationCode)
                 , CurrencyId
                 , ExchequerYear
                 , ExchequerPeriod
                 , 0
                 , 0
                 , OriginalBudget
                 , 0
                 , RevisedBudget1
                 , 0
                 , 0
                 , 0
                 , RevisedBudget2
                 , RevisedBudget3
                 , RevisedBudget4
                 , RevisedBudget5
                 , 0
                 )
                   
  WHEN MATCHED AND ( hiBudget         <> OriginalBudget
                  OR hiRevisedBudget1 <> RevisedBudget1
                  OR hiRevisedBudget2 <> RevisedBudget2
                  OR hiRevisedBudget3 <> RevisedBudget3
                  OR hiRevisedBudget4 <> RevisedBudget4
                  OR hiRevisedBudget5 <> RevisedBudget5
                   ) THEN
       UPDATE
          SET hiBudget         = OriginalBudget
            , hiRevisedBudget1 = RevisedBudget1
            , hiRevisedBudget2 = RevisedBudget2
            , hiRevisedBudget3 = RevisedBudget3
            , hiRevisedBudget4 = RevisedBudget4
            , hiRevisedBudget5 = RevisedBudget5
  ;

END



GO


