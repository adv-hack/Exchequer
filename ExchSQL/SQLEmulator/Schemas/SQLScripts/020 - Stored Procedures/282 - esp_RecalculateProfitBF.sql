
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateProfitBF]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateProfitBF]
GO

--
-- Recalculate Profit BF Balances
--

CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateProfitBF] @iv_IsCommitment BIT = 0
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

  DECLARE @MinYear INT
        , @MaxYear INT

  IF OBJECT_ID('tempdb..#ProfitBF') IS NOT NULL
    DROP TABLE #ProfitBF

  DECLARE @ProfitBF    INT
        , @NominalType VARCHAR(1)
        , @HistoryCode VARBINARY(21)

  SELECT @ProfitBF    = NC.ProfitBF
       , @NominalType = N.NominalTypeCode
       , @HistoryCode = HC.HistoryCode
  FROM [!ActiveSchema!].evw_NominalControl NC
  JOIN [!ActiveSchema!].evw_Nominal N ON NC.ProfitBF = N.NominalCode
  CROSS APPLY ( SELECT HistoryCode     = [common].efn_CreateNominalHistoryCode(NC.ProfitBF, NULL, NULL, NULL, @iv_IsCommitment)
              ) HC

  -- Gather qualifying data

  SELECT HistoryClassificationId = ASCII(@NominalType)
       , HistoryCode             = @HistoryCode
       , NominalCode             = @ProfitBF
       , HistoryYear             = NH.HistoryYear - 1900
       , NH.CurrencyId
       , SalesAmount             = SUM(NH.SalesAmount)
       , PurchaseAmount          = SUM(NH.PurchaseAmount)

  INTO #ProfitBF
  FROM   [!ActiveSchema!].evw_NominalHistory NH (READUNCOMMITTED)
  JOIN   [!ActiveSchema!].evw_Nominal N ON NH.NominalCode = N.NominalCode
  WHERE NH.HistoryClassificationId   = 65 --'A'
  AND   NH.HistoryPeriod             < 250
  AND   NH.CostCentreDepartmentFlag  IS NULL
  AND   NH.IsCommitment              = @iv_IsCommitment

  GROUP BY NH.HistoryYear
         , NH.CurrencyId

  -- Add in any direct bookings to the ProfitBF nominal

  MERGE #ProfitBF PBF
  USING ( SELECT HistoryClassificationId = ASCII(@NominalType)
               , HistoryCode             = @HistoryCode
               , NominalCode             = @ProfitBF
               , HistoryYear             = NH.HistoryYear - 1900
               , CurrencyId
               , SalesAmount             = SUM(SalesAmount)
               , PurchaseAmount          = SUM(PurchaseAmount)
          FROM   [!ActiveSchema!].evw_NominalHistory NH (READUNCOMMITTED)
          WHERE NH.HistoryClassificationId   = 67 --'C'
          AND   NH.HistoryCode               = @HistoryCode
          AND   NH.HistoryPeriod             < 250
          --AND   NH.CostCentreDepartmentFlag  IS NULL
          --AND   NH.IsCommitment              = @iv_IsCommitment

          GROUP BY HistoryYear
                 , CurrencyId
        ) NewData ON NewData.HistoryCode = PBF.HistoryCode
                 AND NewData.HistoryYear = PBF.HistoryYear
                 AND NewData.CurrencyId  = PBF.CurrencyId
  WHEN MATCHED THEN
       UPDATE 
          SET SalesAmount    = PBF.SalesAmount + NewData.SalesAmount
            , PurchaseAmount = PBF.PurchaseAmount + NewData.PurchaseAmount

  WHEN NOT MATCHED BY TARGET THEN
       INSERT ( HistoryClassificationId
              , HistoryCode
              , NominalCode
              , HistoryYear
              , CurrencyId
              , SalesAmount
              , PurchaseAmount
              )
       VALUES ( NewData.HistoryClassificationId
              , NewData.HistoryCode
              , NewData.NominalCode
              , NewData.HistoryYear
              , NewData.CurrencyId
              , NewData.SalesAmount
              , NewData.PurchaseAmount
              )
  ;

  SELECT @MinYear = MIN(HistoryYear)
       , @MaxYear = MAX(HistoryYear)
  FROM   #ProfitBF

  -- Fills any gaps in ProfitBF years

  INSERT INTO #ProfitBF
  SELECT P1.HistoryClassificationId
       , P1.HistoryCode
       , P1.NominalCode
       , EY.ExchequerYear
       , P1.CurrencyId
       , 0
       , 0
  FROM #ProfitBF P1
  OUTER APPLY ( SELECT DISTINCT ExchequerYear
                FROM [!ActiveSchema!].evw_Period P
                WHERE P.ExchequerYear BETWEEN @MinYear AND @MaxYear
              ) EY
  WHERE P1.HistoryYear <= EY.ExchequerYear 
  AND NOT EXISTS (SELECT TOP 1 1
                    FROM   #ProfitBF P2
                    WHERE P1.HistoryClassificationId = P2.HistoryClassificationId
                    AND   P1.HistoryCode             = P2.HistoryCode
                    AND   P1.CurrencyId              = P2.CurrencyId
                    AND   EY.ExchequerYear           = P2.HistoryYear
                   )

  MERGE [!ActiveSchema!].HISTORY H
  USING ( SELECT PBF.HistoryCode
               , PBF.HistoryClassificationId
               , PBF.HistoryYear
               , HistoryPeriod = @c_CTDPeriod
               , PBF.CurrencyId

               , SalesAmount    = SUM(PBFData.SalesAmount)
               , PurchaseAmount = SUM(PBFData.PurchaseAmount)

          FROM (SELECT DISTINCT
                       HistoryClassificationId
                     , HistoryCode
                     , HistoryYear
                     , CurrencyId
                FROM #ProfitBF
                ) PBF
          JOIN #ProfitBF PBFData ON PBF.HistoryCode  = PBFData.HistoryCode
                                AND PBF.CurrencyId   = PBFData.CurrencyId
                                AND PBF.HistoryYear >= PBFData.HistoryYear
          GROUP BY PBF.HistoryCode
                 , PBF.HistoryClassificationId
                 , PBF.HistoryYear
                 , PBF.CurrencyId
        ) PBFData ON H.hiCode     = PBFData.HistoryCode
                 AND H.hiCurrency = PBFData.CurrencyId
                 AND H.hiYear     = PBFData.HistoryYear
                 AND H.hiPeriod   = PBFData.HistoryPeriod
  WHEN MATCHED THEN
       UPDATE 
          SET hiSales     = PBFData.SalesAmount
            , hiPurchases = PBFData.PurchaseAmount

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
          VALUES ( PBFData.HistoryCode
                 , PBFData.HistoryClassificationId
                 , PBFData.CurrencyId
                 , PBFData.HistoryYear
                 , PBFData.HistoryPeriod
                 , PBFData.SalesAmount
                 , PBFData.PurchaseAmount
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

  -- The following finally checks that the ProfitBF hierarchy adds up

  DECLARE @TopLevelNominalCode INT

  SELECT @TopLevelNominalCode = N.NominalCode
  FROM   [!ActiveSchema!].evw_NominalAscendant    NA
  JOIN   [!ActiveSchema!].evw_Nominal              N ON NA.AscendantNominalCode = N.NominalCode
  JOIN   [!ActiveSchema!].evw_NominalHierarchy NHIER ON N.NominalCode           = NHIER.NominalCode
  WHERE  NHIER.NominalLevel = 0
  AND    NA.NominalCode     = @ProfitBF

  IF OBJECT_ID('tempdb..#PBFHierarchyChildren') IS NOT NULL
    DROP TABLE #PBFHierarchyChildren

  -- Put the children of the Profit BF hierarchy into a temp. table

  SELECT NominalCode = N.NominalCode
       , HC.HistoryCode
  INTO   #PBFHierarchyChildren
  FROM   [!ActiveSchema!].evw_NominalDescendant ND
  JOIN   [!ActiveSchema!].evw_Nominal            N ON ND.DescendantNominalCode = N.NominalCode
  CROSS APPLY ( SELECT HistoryCode     = [common].efn_CreateNominalHistoryCode(N.NominalCode, NULL, NULL, NULL, @iv_IsCommitment)
              ) HC
  WHERE  ND.NominalCode = @TopLevelNominalCode
  AND    N.HasChildren  = @c_False

  IF OBJECT_ID('tempdb..#PBFRawData') IS NOT NULL
    DROP TABLE #PBFRawData

  SELECT PBFHC.NominalCode
       , H.HistoryPeriodKey
       , H.ExchequerYear
       , HistoryPeriod
       , CurrencyId

       , SalesAmount
       , PurchaseAmount
  INTO #PBFRawData
  FROM   #PBFHierarchyChildren PBFHC
  JOIN   [!ActiveSchema!].evw_NominalHistory H (READUNCOMMITTED) ON PBFHC.HistoryCode           = H.HistoryCode
                                                              --AND H.CostCentreDepartmentFlag IS NULL
                                                              --AND H.IsCommitment              = @iv_IsCommitment
                                                                AND H.HistoryPeriod             < 250 
  WHERE   PBFHC.NominalCode <> @ProfitBF
  AND  ( H.SalesAmount    <> 0
   OR    H.PurchaseAmount <> 0
       )
  UNION
  SELECT NominalCode
       , HistoryPeriodKey = ((HistoryYear + 1900) * 1000) + 249
       , HistoryYear
       , HistoryPeriod    = 249
       , CurrencyId

       , SalesAmount
       , PurchaseAmount
  FROM #ProfitBF
  ORDER BY NominalCode DESC 


  IF OBJECT_ID('tempdb..#PBFH') IS NOT NULL
    DROP TABLE #PBFH

  SELECT NA.NominalCode
       , AscendantNominalCode
  INTO #PBFH
  FROM [!ActiveSchema!].evw_NominalAscendant NA
  JOIN #PBFHierarchyChildren PBFHC ON NA.NominalCode = PBFHC.NominalCode

  IF OBJECT_ID('tempdb..#PBFHierarchyData') IS NOT NULL
    DROP TABLE #PBFHierarchyData

  SELECT HistoryClassificationId = CONVERT(INT, NULL)
       , NominalCode             = P1.AscendantNominalCode
       , HistoryCode             = CONVERT(VARBINARY(21), NULL)
       , PBF.ExchequerYear
       , HistoryPeriodKey
       , CurrencyId

       , SalesAmount
       , PurchaseAmount
  INTO   #PBFHierarchyData
  FROM   #PBFRawData PBF
  JOIN   #PBFH P1 ON PBF.NominalCode = P1.NominalCode

  UPDATE PBF
     SET HistoryCode             = [common].efn_CreateNominalHistoryCode(PBF.NominalCode, NULL, NULL, NULL, @iv_IsCommitment)
       , HistoryClassificationId = ASCII(N.NominalTypeCode)
    FROM #PBFHierarchyData PBF
    JOIN [!ActiveSchema!].evw_Nominal N ON PBF.NominalCode = N.NominalCode

  MERGE [!ActiveSchema!].HISTORY H
  USING (
  SELECT NominalCode
       , HistoryClassificationId
       , HistoryCode
       , ExchequerYear
       , HistoryPeriod = @c_CTDPeriod
       , CurrencyId

       , SalesAmount
       , PurchaseAmount
  FROM   ( SELECT DISTINCT
                NominalCode
              , HistoryClassificationId
              , HistoryCode
              , ExchequerYear
              , CurrencyId
         FROM   #PBFHierarchyData
       ) PBF
  CROSS APPLY ( SELECT SalesAmount    = SUM(SalesAmount)
                     , PurchaseAmount = SUM(PurchaseAmount)
                FROM #PBFHierarchyData PBFFin
                WHERE PBF.HistoryCode                             = PBFFin.HistoryCode
                AND   PBF.CurrencyId                              = PBFFin.CurrencyId
                AND (((PBF.ExchequerYear + 1900) * 1000) + 255)  >= PBFFin.HistoryPeriodKey
              ) Fin
       ) PBFData ON H.hiCode     = PBFData.HistoryCode
                AND H.HiExCLass  = PBFData.HistoryClassificationId
                AND H.hiCurrency = PBFData.CurrencyId
                AND H.hiYear     = PBFData.ExchequerYear
                AND H.hiPeriod   = PBFData.HistoryPeriod
  WHEN MATCHED THEN
       UPDATE 
          SET hiSales     = PBFData.SalesAmount
            , hiPurchases = PBFData.PurchaseAmount

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
          VALUES ( PBFData.HistoryCode
                 , PBFData.HistoryClassificationId
                 , PBFData.CurrencyId
                 , PBFData.ExchequerYear
                 , PBFData.HistoryPeriod
                 , PBFData.SalesAmount
                 , PBFData.PurchaseAmount
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


