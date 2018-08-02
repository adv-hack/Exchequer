/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLCCDepBudgets]    Script Date: 04/25/2016 08:33:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RollupGLCCDeptBudgets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RollupGLCCDeptBudgets]
GO

/****** Object:  StoredProcedure [!ActiveSchema!].[esp_RollupGLCCDepBudgets]    Script Date: 04/25/2016 08:33:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [!ActiveSchema!].[esp_RollupGLCCDeptBudgets] ( @iv_SummarisationLevel VARCHAR(3) )
AS
BEGIN

  SET NOCOUNT ON;

  -- Create temp. table

  --DECLARE  @iv_SummarisationLevel VARCHAR(3) = 'D'

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

  CREATE NONCLUSTERED INDEX idx_TempGLBudgetHistory1 On #GLBudgetHistory
       ( CurrencyId
       , CostCentreDepartmentFlag
       ) INCLUDE ([HistoryClassificationCode]
                 ,[NominalCode]
                 ,[HistoryPeriodKey]
                 ,[CostCentreCode]
                 ,[DepartmentCode]
                 ,[OriginalBudget]
                 ,[RevisedBudget1]
                 ,[RevisedBudget2]
                 ,[RevisedBudget3]
                 ,[RevisedBudget4]
                 ,[RevisedBudget5]
                 )

  -- Insert Lowest Level Budget Records into temp table. for budgets with CC or DP

  INSERT INTO #GLBudgetHistory
  SELECT HistoryPositionId
       , NH.HistoryClassificationCode
       , NH.HistoryCode
       , NominalCode
       , CostCentreDepartmentFlag
       , NH.CurrencyId
       , HistoryPeriodKey
       , CostCentreCode
       , DepartmentCode
       , OriginalBudgetAmount
       , RevisedBudgetAmount1
       , RevisedBudgetAmount2
       , RevisedBudgetAmount3
       , RevisedBudgetAmount4
       , RevisedBudgetAmount5
       
  FROM   !ActiveSchema!.evw_NominalHistory NH
  JOIN ( SELECT DISTINCT
                NHIST.HistoryClassificationCode
              , NHIST.HistoryCode
              , NHIST.HistoryYear
              , NHIST.CurrencyId

         FROM   !ActiveSchema!.evw_NominalHistory NHIST
         WHERE NHIST.CurrencyId <> 0
         AND   ( NHIST.OriginalBudgetAmount <> 0
            OR   NHIST.RevisedBudgetAmount1 <> 0
            OR   NHIST.RevisedBudgetAmount2 <> 0
            OR   NHIST.RevisedBudgetAmount3 <> 0
            OR   NHIST.RevisedBudgetAmount4 <> 0
            OR   NHIST.RevisedBudgetAmount5 <> 0
               )
       ) HData ON NH.HistoryClassificationCode = HData.HistoryClassificationCode
              AND NH.HistoryCode               = HData.HistoryCode
              AND NH.HistoryYear               = HData.HistoryYear
              AND NH.CurrencyId                = HData.CurrencyId
  WHERE NH.CurrencyId <> 0
  AND   NH.HistoryClassificationCode IN ('A','B','C')
  AND   NH.CostCentreDepartmentFlag  IN (@iv_SummarisationLevel)

  AND EXISTS (SELECT TOP 1 1
              FROM   !ActiveSchema!.evw_NominalHistory HData
              WHERE  NH.HistoryClassificationCode = HData.HistoryClassificationCode
              AND    NH.HistoryCode               = HData.HistoryCode
              AND    NH.HistoryYear               = HData.HistoryYear
              AND    NH.CurrencyId                = HData.CurrencyId
             )

     -- Whilst we are not summing the CTD/YTD columns the following commented out code will create necessary rows
     -- otherwise we'll need a specific block of code to create 255 records for B nominal type
     -- & 254 records for A, C Nominal Types

     -- AND   NH.HistoryPeriod < 250

  -- Create consolidated (0) for those Nominals without a currency budget
  
  INSERT INTO #GLBudgetHistory
  SELECT HistoryPositionId
       , NH.HistoryClassificationCode
       , NH.HistoryCode
       , NominalCode
       , CostCentreDepartmentFlag
       , NH.CurrencyId
       , HistoryPeriodKey
       , CostCentreCode
       , DepartmentCode
       , OriginalBudgetAmount
       , RevisedBudgetAmount1
       , RevisedBudgetAmount2
       , RevisedBudgetAmount3
       , RevisedBudgetAmount4
       , RevisedBudgetAmount5
     
  FROM   !ActiveSchema!.evw_NominalHistory NH
  JOIN ( SELECT DISTINCT
                NHIST.HistoryClassificationCode
              , NHIST.HistoryCode
              , NHIST.HistoryYear
              , NHIST.CurrencyId
         FROM   !ActiveSchema!.evw_NominalHistory NHIST
         WHERE NHIST.CurrencyId = 0
         AND   ( NHIST.OriginalBudgetAmount <> 0
            OR   NHIST.RevisedBudgetAmount1 <> 0
            OR   NHIST.RevisedBudgetAmount2 <> 0
            OR   NHIST.RevisedBudgetAmount3 <> 0
            OR   NHIST.RevisedBudgetAmount4 <> 0
            OR   NHIST.RevisedBudgetAmount5 <> 0
               )
       ) HData ON NH.HistoryClassificationCode = HData.HistoryClassificationCode
              AND NH.HistoryCode               = HData.HistoryCode
              AND NH.HistoryYear               = HData.HistoryYear
              AND NH.CurrencyId                = HData.CurrencyId
  WHERE NH.CurrencyId                = 0
  AND   NH.HistoryClassificationCode IN ('A','B','C')
  AND   NH.CostCentreDepartmentFlag  IN (@iv_SummarisationLevel)

  AND EXISTS (SELECT TOP 1 1
              FROM   !ActiveSchema!.evw_NominalHistory HData1
              WHERE  NH.HistoryClassificationCode = HData1.HistoryClassificationCode
              AND    NH.HistoryCode               = HData1.HistoryCode
              AND    NH.HistoryYear               = HData1.HistoryYear
              AND    NH.CurrencyId                = HData1.CurrencyId
             )

  AND NOT EXISTS ( SELECT TOP 1 1
                   FROM   #GLBudgetHistory G1
                   WHERE NH.HistoryClassificationCode = G1.HistoryClassificationCode COLLATE Latin1_General_CI_AS
                   AND   NH.NominalCode               = G1.NominalCode
                   AND   NH.HistoryPeriodKey          = G1.HistoryPeriodKey
                   AND   G1.CurrencyId               <> 0
                   AND   ISNULL(NH.CostCentreDepartmentFlag, '') = ISNULL(G1.CostCentreDepartmentFlag, '') COLLATE Latin1_General_CI_AS
                   AND   ISNULL(NH.CostCentreCode, '')           = ISNULL(G1.CostCentreCode, '') COLLATE Latin1_General_CI_AS
                   AND   ISNULL(NH.DepartmentCode, '')           = ISNULL(G1.DepartmentCode, '') COLLATE Latin1_General_CI_AS
                 )

  -- Whilst we are not summing the CTD/YTD columns the following commented out code will create necessary rows
  -- otherwise we'll need a specific block of code to create 255 records for B nominal type
  -- & 254 records for A, C Nominal Types

  -- AND   NH.HistoryPeriod < 250

  -- Remove the rows that are already summarised if they have children

  IF @iv_SummarisationLevel = 'C'
  BEGIN
    DELETE G1
    FROM   #GLBudgetHistory G1
    WHERE ( CostCentreDepartmentFlag = 'C' 
        AND DepartmentCode IS NULL
        AND EXISTS (SELECT TOP 1 1
                    FROM   #GLBudgetHistory G2
                    WHERE  G1.HistoryClassificationCode = G2.HistoryClassificationCode
                    AND    G1.NominalCode               = G2.NominalCode
                    AND    G1.CurrencyId                = G2.CurrencyId
                    AND    G1.HistoryPeriodKey          = G2.HistoryPeriodKey
                    AND    G1.CostCentreDepartmentFlag  = G2.CostCentreDepartmentFlag
                    AND    G1.CostCentreCode            = G2.CostCentreCode
                    AND    G2.DepartmentCode            IS NOT NULL)
          )

    -- New functionality summarise the data per CC and per Dept for each CostCentreDepartmentFlag
  
    -- Cost Centres
    MERGE #GLBudgetHistory GLBH
    USING ( SELECT HistoryClassificationCode
                 , NominalCode
                 , CostCentreDepartmentFlag
                 , CurrencyId
                 , HistoryPeriodKey
                 , CostCentreCode
                 , OriginalBudget    = SUM(OriginalBudget)
                 , RevisedBudget1    = SUM(RevisedBudget1)
                 , RevisedBudget2    = SUM(RevisedBudget2)
                 , RevisedBudget3    = SUM(RevisedBudget3)
                 , RevisedBudget4    = SUM(RevisedBudget4)
                 , RevisedBudget5    = SUM(RevisedBudget5)
         
            FROM   #GLBudgetHistory (NOLOCK)
            WHERE  CurrencyId <> 0
            AND    CostCentreDepartmentFlag = 'C'
            GROUP BY HistoryClassificationCode
                   , NominalCode
                   , CostCentreDepartmentFlag
                   , CurrencyId
                   , HistoryPeriodKey
                   , CostCentreCode ) BData ON BData.HistoryClassificationCode = GLBH.HistoryClassificationCode
                                           AND BData.NominalCode               = GLBH.NominalCode
                                           AND BData.CostCentreDepartmentFlag  = GLBH.CostCentreDepartmentFlag
                                           AND BData.CurrencyId                = GLBH.CurrencyId
                                           AND BData.HistoryPeriodKey          = GLBH.HistoryPeriodKey
                                           AND BData.CostCentreCode            = GLBH.CostCentreCode
                                           AND GLBH.DepartmentCode             IS NULL
    WHEN MATCHED THEN
         UPDATE
            SET OriginalBudget = BData.OriginalBudget
              , RevisedBudget1 = BData.RevisedBudget1
              , RevisedBudget2 = BData.RevisedBudget2
              , RevisedBudget3 = BData.RevisedBudget3
              , RevisedBudget4 = BData.RevisedBudget4
             , RevisedBudget5 = BData.RevisedBudget5
    WHEN NOT MATCHED BY TARGET THEN
         INSERT ( HistoryClassificationCode
                , NominalCode
                , CostCentreDepartmentFlag
                , CurrencyId
                , HistoryPeriodKey
                , CostCentreCode
                , OriginalBudget
                , RevisedBudget1
                , RevisedBudget2
                , RevisedBudget3
                , RevisedBudget4
                , RevisedBudget5
                )
         VALUES ( BData.HistoryClassificationCode
                , BData.NominalCode
                , BData.CostCentreDepartmentFlag
                , BData.CurrencyId
                , BData.HistoryPeriodKey
                , BData.CostCentreCode
                , OriginalBudget
                , RevisedBudget1
                , RevisedBudget2
                , RevisedBudget3
                , RevisedBudget4
                , RevisedBudget5
                )  
  ;
  END

  IF @iv_SummarisationLevel = 'D'
  BEGIN
    DELETE G1
    FROM   #GLBudgetHistory G1
    WHERE ( CostCentreDepartmentFlag = 'D' 
        AND CostCentreCode IS NULL
        AND EXISTS (SELECT TOP 1 1
                    FROM   #GLBudgetHistory G2
                    WHERE  G1.HistoryClassificationCode = G2.HistoryClassificationCode
                    AND    G1.NominalCode               = G2.NominalCode
                    AND    G1.CurrencyId                = G2.CurrencyId
                    AND    G1.HistoryPeriodKey          = G2.HistoryPeriodKey
                    AND    G1.CostCentreDepartmentFlag  = G2.CostCentreDepartmentFlag
                    AND    G2.CostCentreCode            IS NOT NULL
                    AND    G1.DepartmentCode            = G2.DepartmentCode)
          )

    -- Summarise Departments
  
    MERGE #GLBudgetHistory GLBH
    USING ( SELECT HistoryClassificationCode
                 , NominalCode
                 , CostCentreDepartmentFlag
                 , CurrencyId
                 , HistoryPeriodKey
                 , DepartmentCode
                 , OriginalBudget    = SUM(OriginalBudget)
                 , RevisedBudget1    = SUM(RevisedBudget1)
                 , RevisedBudget2    = SUM(RevisedBudget2)
                 , RevisedBudget3    = SUM(RevisedBudget3)
                 , RevisedBudget4    = SUM(RevisedBudget4)
                 , RevisedBudget5    = SUM(RevisedBudget5)
       
            FROM   #GLBudgetHistory (NOLOCK)
            WHERE  CurrencyId <> 0
            AND    CostCentreDepartmentFlag = 'D'
            GROUP BY HistoryClassificationCode
                   , NominalCode
                   , CostCentreDepartmentFlag
                   , CurrencyId
                   , HistoryPeriodKey
                   , DepartmentCode ) BData ON BData.HistoryClassificationCode = GLBH.HistoryClassificationCode
                                           AND BData.NominalCode               = GLBH.NominalCode
                                           AND BData.CostCentreDepartmentFlag  = GLBH.CostCentreDepartmentFlag
                                           AND BData.CurrencyId                = GLBH.CurrencyId
                                           AND BData.HistoryPeriodKey          = GLBH.HistoryPeriodKey
                                           AND BData.DepartmentCode            = GLBH.DepartmentCode
                                           AND GLBH.CostCentreCode             IS NULL
    WHEN MATCHED THEN
         UPDATE
            SET OriginalBudget = BData.OriginalBudget
              , RevisedBudget1 = BData.RevisedBudget1
              , RevisedBudget2 = BData.RevisedBudget2
              , RevisedBudget3 = BData.RevisedBudget3
              , RevisedBudget4 = BData.RevisedBudget4
             , RevisedBudget5 = BData.RevisedBudget5

    WHEN NOT MATCHED BY TARGET THEN
         INSERT ( HistoryClassificationCode
                , NominalCode
                , CostCentreDepartmentFlag
                , CurrencyId
                , HistoryPeriodKey
                , DepartmentCode
                , OriginalBudget
                , RevisedBudget1
                , RevisedBudget2
                , RevisedBudget3
                , RevisedBudget4
                , RevisedBudget5
                )
         VALUES ( BData.HistoryClassificationCode
                , BData.NominalCode
                , BData.CostCentreDepartmentFlag
                , BData.CurrencyId
                , BData.HistoryPeriodKey
                , BData.DepartmentCode
                , OriginalBudget
                , RevisedBudget1
                , RevisedBudget2
                , RevisedBudget3
                , RevisedBudget4
                , RevisedBudget5
                )  
    ;

  END -- Summarisation Level = D

  -- Now create consolidated currency records (0)
  
  INSERT INTO #GLBudgetHistory
            ( HistoryClassificationCode
            , NominalCode
            , CostCentreDepartmentFlag
            , CurrencyId
            , CostCentreCode
            , DepartmentCode
            , HistoryPeriodKey
            , OriginalBudget
            , RevisedBudget1
            , RevisedBudget2
            , RevisedBudget3
            , RevisedBudget4
            , RevisedBudget5
            )
  SELECT HistoryClassificationCode
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

  FROM #GLBudgetHistory GLBH
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
                           WHEN GLBH.CurrencyId = 1 THEN OriginalBudget
                           ELSE common.efn_ExchequerCurrencyConvert( OriginalBudget
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
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudget1
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudget1
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
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudget2
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudget2
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
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudget3
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudget3
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
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudget4
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudget4
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
                           WHEN GLBH.CurrencyId = 1 THEN RevisedBudget5
                           ELSE common.efn_ExchequerCurrencyConvert( RevisedBudget5
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

  GROUP BY HistoryClassificationCode
         , NominalCode
         , CostCentreDepartmentFlag
         , CostCentreCode
         , DepartmentCode
         , HistoryPeriodKey

  -- Set PositionId and HistoryCode

  UPDATE GLBH
     SET HistoryPositionId = NH.HistoryPositionId
       , HistoryCode = ISNULL(NH.HistoryCode, 
                              CONVERT(VARBINARY(21), 
                                0x14
                              + CONVERT(VARBINARY(21), 
                                CASE
                                WHEN GLBH.CostCentreDepartmentFlag IS NOT NULL THEN GLBH.CostCentreDepartmentFlag
                                ELSE ''
                                END)
                              + SUBSTRING(CONVERT(VARBINARY(21), GLBH.NominalCode), 4, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), GLBH.NominalCode), 3, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), GLBH.NominalCode), 2, 1)
                              + SUBSTRING(CONVERT(VARBINARY(21), GLBH.NominalCode), 1, 1)
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
                             )
  FROM #GLBudgetHistory GLBH
  LEFT JOIN !ActiveSchema!.evw_NominalHistory NH ON GLBH.HistoryClassificationCode            = NH.HistoryClassificationCode            COLLATE Latin1_General_CI_AS
                                        AND GLBH.CurrencyId                           = NH.CurrencyId
                                        AND GLBH.HistoryPeriodKey                     = NH.HistoryPeriodKey
                                        AND GLBH.NominalCode                          = NH.NominalCode
                                        AND ISNULL(GLBH.CostCentreDepartmentFlag, '') = ISNULL(NH.CostCentreDepartmentFlag, '') COLLATE Latin1_General_CI_AS
                                        AND ISNULL(GLBH.CostCentreCode, '')           = ISNULL(NH.CostCentreCode, '')           COLLATE Latin1_General_CI_AS
                                        AND ISNULL(GLBH.DepartmentCode, '')           = ISNULL(NH.DepartmentCode, '')           COLLATE Latin1_General_CI_AS
  WHERE GLBH.HistoryCode IS NULL

  -- Update the consolidated (0) Budgets if currency budget = 0
  -- Create temp. table first of Currency Budgets
  IF OBJECT_ID('tempdb..#CBudgets') IS NOT NULL
     DROP TABLE #CBudgets

  SELECT HistoryPositionId
       , NH.HistoryClassificationCode
       , NH.HistoryCode
       , NominalCode
       , CostCentreDepartmentFlag
       , NH.CurrencyId
       , HistoryPeriodKey
       , CostCentreCode
       , DepartmentCode
       , OriginalBudgetAmount
       , RevisedBudgetAmount1
       , RevisedBudgetAmount2
       , RevisedBudgetAmount3
       , RevisedBudgetAmount4
       , RevisedBudgetAmount5
  INTO #CBudgets     
  FROM   !ActiveSchema!.evw_NominalHistory NH
  JOIN ( SELECT DISTINCT
                NHIST.HistoryClassificationCode
              , NHIST.HistoryCode
              , NHIST.HistoryYear
              , NHIST.CurrencyId
         FROM   !ActiveSchema!.evw_NominalHistory NHIST
         WHERE NHIST.CurrencyId = 0
         AND   ( NHIST.OriginalBudgetAmount <> 0
            OR   NHIST.RevisedBudgetAmount1 <> 0
            OR   NHIST.RevisedBudgetAmount2 <> 0
            OR   NHIST.RevisedBudgetAmount3 <> 0
            OR   NHIST.RevisedBudgetAmount4 <> 0
            OR   NHIST.RevisedBudgetAmount5 <> 0
               )
       ) HData ON NH.HistoryClassificationCode = HData.HistoryClassificationCode
              AND NH.HistoryCode               = HData.HistoryCode
              AND NH.HistoryYear               = HData.HistoryYear
              AND NH.CurrencyId                = HData.CurrencyId
  WHERE NH.CurrencyId = 0
  AND   NH.HistoryClassificationCode IN ('A','B','C')
  AND   NH.CostCentreDepartmentFlag  IN ('C','D')
  --AND   NH.HistoryPeriod < 250

  AND EXISTS (SELECT TOP 1 1
              FROM   !ActiveSchema!.evw_NominalHistory HData1
              WHERE  NH.HistoryClassificationCode = HData1.HistoryClassificationCode
              AND    NH.HistoryCode               = HData1.HistoryCode
              AND    NH.HistoryYear               = HData1.HistoryYear
              AND    NH.CurrencyId                = HData1.CurrencyId
              AND   (HData1.OriginalBudgetAmount  <> 0
               OR    HData1.RevisedBudgetAmount1  <> 0
               OR    HData1.RevisedBudgetAmount2  <> 0
               OR    HData1.RevisedBudgetAmount3  <> 0
               OR    HData1.RevisedBudgetAmount4  <> 0
               OR    HData1.RevisedBudgetAmount5  <> 0
                    )
             )

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM #GLBudgetHistory G1
                  WHERE NH.HistoryClassificationCode = G1.HistoryClassificationCode COLLATE Latin1_General_CI_AS
                  AND   NH.HistoryCode               = G1.HistoryCode
                  AND   NH.HistoryPeriodKey          = G1.HistoryPeriodKey
                  AND  (G1.OriginalBudget      <> 0
                   OR   G1.RevisedBudget1      <> 0
                   OR   G1.RevisedBudget2      <> 0
                   OR   G1.RevisedBudget3      <> 0
                   OR   G1.RevisedBudget4      <> 0
                   OR   G1.RevisedBudget5      <> 0
                       )   
                  AND   G1.CurrencyId <> 0)

  UPDATE GLBH
     SET OriginalBudget = ISNULL( NULLIF(GLBH.OriginalBudget, 0), CBudgets.OriginalBudgetAmount)
       , RevisedBudget1 = ISNULL( NULLIF(GLBH.RevisedBudget1, 0), CBudgets.RevisedBudgetAmount1)
       , RevisedBudget2 = ISNULL( NULLIF(GLBH.RevisedBudget2, 0), CBudgets.RevisedBudgetAmount2)
       , RevisedBudget3 = ISNULL( NULLIF(GLBH.RevisedBudget3, 0), CBudgets.RevisedBudgetAmount3)
       , RevisedBudget4 = ISNULL( NULLIF(GLBH.RevisedBudget4, 0), CBudgets.RevisedBudgetAmount4)
       , RevisedBudget5 = ISNULL( NULLIF(GLBH.RevisedBudget5, 0), CBudgets.RevisedBudgetAmount5)
  FROM #GLBudgetHistory GLBH
  JOIN #CBudgets CBudgets ON --GLBH.HistoryPositionId = CBudgets.HistoryPositionId
                        GLBH.HistoryClassificationCode            = CBudgets.HistoryClassificationCode COLLATE Latin1_General_CI_AS
                 AND GLBH.NominalCode                          = CBudgets.NominalCode
                 AND GLBH.HistoryPeriodKey                     = CBudgets.HistoryPeriodKey
                 AND ISNULL(GLBH.CostCentreDepartmentFlag, '') = ISNULL(CBudgets.CostCentreDepartmentFlag, '') COLLATE Latin1_General_CI_AS
                 AND ISNULL(GLBH.CostCentreCode, '')           = ISNULL(CBudgets.CostCentreCode, '') COLLATE Latin1_General_CI_AS
                 AND ISNULL(GLBH.DepartmentCode, '')           = ISNULL(CBudgets.DepartmentCode, '') COLLATE Latin1_General_CI_AS
  WHERE GLBH.CurrencyId = 0

  -- Fix data

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


