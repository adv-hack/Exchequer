IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostTrader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_PostTrader]
GO

--
-- Post Trader History
--

CREATE PROCEDURE [!ActiveSchema!].[esp_PostTrader] ( @itvp_PostTransactions common.edt_Integer READONLY
                                                   )
AS
BEGIN

  SET NOCOUNT ON;

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @ss_AuditYear                    INT
        , @ss_UpdateBalanceOnPost          BIT
        , @ss_IncludeVATInCommittedBalance BIT
        , @ss_AgeingMode                   INT
  
  -- Get System Settings
  SELECT @ss_AuditYear                    = SS.AuditYear
       , @ss_UpdateBalanceOnPost          = SS.UpdateBalanceOnPost
       , @ss_IncludeVATInCommittedBalance = SS.IncludeVATInCommittedBalance
       , @ss_AgeingMode                   = SS.AgeingMode
  FROM   [!ActiveSchema!].evw_SystemSettings SS

-- Determine Records to Insert U, V, W or just V

  DECLARE @TraderHistoryClasses TABLE
        ( HistoryClassificationCode CHAR(1) PRIMARY KEY
        , HistoryClassificationId   INT
        )
        
  IF @ss_UpdateBalanceOnPost = @c_True
  BEGIN
    INSERT INTO @TraderHistoryClasses
    SELECT 'U',ASCII('U')
    UNION
    SELECT 'V',ASCII('V')
    UNION
    SELECT 'W',ASCII('W')
    --SET @TraderHistoryClasses = 'U,V,W'
  END
  ELSE
  BEGIN
    INSERT INTO @TraderHistoryClasses
    SELECT 'V',ASCII('V')
    --SET @TraderHistoryClasses = 'V'
  END

  -- Create temp.table of Header Data
  
  IF OBJECT_ID('tempdb..#THData') IS NOT NULL
    DROP TABLE #THData
  
  CREATE TABLE #THData
       ( PositionId INT PRIMARY KEY
       , TraderCode VARCHAR(10)
       , ExchequerYear INT
       , TransactionPeriod INT
       , ControlGLNominalCode INT
       , IsStockMovement BIT
       , DebitAmountInBase FLOAT DEFAULT (0)
       , CreditAmountInBase FLOAT DEFAULT (0)
       , TotalCostInBase FLOAT DEFAULT (0)
       , TotalCalculatedNetValueInBase FLOAT DEFAULT (0)
       )

  INSERT INTO #THData
       ( PositionId
       , TraderCode
       , ExchequerYear
       , TransactionPeriod
       , ControlGLNominalCode
       , IsStockMovement
       )
  SELECT D.HeaderPositionId
       , D.TraderCode
       , D.ExchequerYear
       , D.TransactionPeriod
       , D.ControlGLNominalCode
       , D.IsStockMovement
  FROM  [!ActiveSchema!].evw_TransactionHeader D (READUNCOMMITTED)
  WHERE EXISTS ( SELECT TOP 1 1
                 FROM   @itvp_PostTransactions PT 
                 WHERE  PT.IntegerValue = D.HeaderPositionId
               )
  AND D.TraderCode <> ''

  -- Update Values

  UPDATE TH
     SET DebitAmountInBase             = THV.DebitAmountInBase
       , CreditAmountInBase            = THV.CreditAmountInBase
       , TotalCostInBase               = THV.TotalCostInBase
       , TotalCalculatedNetValueInBase = THV.TotalCalculatedNetValueInBase
  FROM #THData TH
  JOIN [!ActiveSchema!].evw_TransactionHeader THV ON TH.PositionId = THV.HeaderPositionId

  IF OBJECT_ID('tempdb..#TraderHistory') IS NOT NULL
    DROP TABLE #TraderHistory

  SELECT HistoryPositionId         = MAX(TH.PositionId)
       , HistoryCode               = common.efn_CreateTraderHistoryCode(TXH.TraderCode, NC.NominalCode)
       , HistoryClassificationCode = CONVERT(VARCHAR(3), THC.HistoryClassificationCode)
       , TraderCode                = CONVERT(VARCHAR(10), TXH.TraderCode)
       , NominalCode               = CONVERT(INT, NC.NominalCode)
       , CurrencyId                = CONVERT(INT, @c_BaseCurrencyId)
       , ExchequerYear             = CONVERT(INT, TXH.ExchequerYear)
       , PostPeriod                = CONVERT(INT, TXH.TransactionPeriod)
       , SalesAmount               = SUM(CONVERT(FLOAT, 
                                         CASE
                                         WHEN THC.HistoryClassificationCode IN ('U','V') THEN TXH.DebitAmountInBase
                                         WHEN TXH.IsStockMovement = @c_True THEN TXH.TotalCostInBase
                                         ELSE 0.0
                                         END))
       , PurchaseAmount            = SUM(CONVERT(FLOAT, 
                                         CASE
                                         WHEN THC.HistoryClassificationCode IN ('U','V') THEN TXH.CreditAmountInBase
                                         WHEN TXH.IsStockMovement = @c_True THEN TXH.TotalCalculatedNetValueInBase
                                         ELSE 0.0
                                         END))
  INTO #TraderHistory
  FROM  #THData TXH
  CROSS APPLY ( SELECT NominalCode = NULL
                UNION
                SELECT NominalCode = TXH.ControlGLNominalCode
              ) NC
  CROSS APPLY ( SELECT HistoryClassificationCode
                     , HistoryClassificationId
                FROM   @TraderHistoryClasses
              ) THC
  LEFT JOIN [!ActiveSchema!].HISTORY TH ON TH.hiCode       = common.efn_CreateTraderHistoryCode(TXH.TraderCode, NC.NominalCode)
                                       AND TH.hiEXCLass  = THC.HistoryClassificationId
                                       AND TH.hiCurrency = 0
                                       AND TH.hiYear     = TXH.ExchequerYear
                                       AND TH.hiPeriod   = TXH.TransactionPeriod


  GROUP BY THC.HistoryClassificationCode
         , TXH.TraderCode
         , TXH.ExchequerYear
         , TXH.TransactionPeriod
         , NC.NominalCode

  -- Insert CTD Period Records

  INSERT INTO #TraderHistory
            ( HistoryPositionId
            , HistoryCode
            , HistoryClassificationCode
            , TraderCode
            , NominalCode
            , CurrencyId
            , ExchequerYear
            , PostPeriod
            , SalesAmount
            , PurchaseAmount
            )
  SELECT H.PositionId
       , TH.HistoryCode
       , TH.HistoryClassificationCode
       , TH.TraderCode
       , TH.NominalCode
       , TH.CurrencyId
       , EY.ExchequerYear
       , PostPeriod     = @c_CTDPeriod
       , SalesAmount    = SUM(TH.SalesAmount)
       , PurchaseAmount = SUM(TH.PurchaseAmount)
  FROM #TraderHistory TH
  JOIN common.evw_HistoryClassification HC ON TH.HistoryClassificationCode = HC.HistoryClassificationCode
                                          AND HC.HasCTD                    = @c_True
  CROSS APPLY( SELECT ExchequerYear
               FROM [!ActiveSchema!].evw_TraderHistory VTH
               WHERE ASCII(TH.HistoryClassificationCode) = VTH.HistoryClassificationId
               AND   TH.CurrencyId                       = VTH.CurrencyId
               AND   TH.HistoryCode                      = VTH.HistoryCode
               AND   TH.ExchequerYear                    < VTH.ExchequerYear
               AND   VTH.HistoryPeriod                   = @c_CTDPeriod
               UNION
               SELECT TH.ExchequerYear
             ) EY
  LEFT JOIN [!ActiveSchema!].HISTORY H ON H.hiCode       = TH.HistoryCode
                                    AND H.hiEXCLass  = ASCII(TH.HistoryClassificationCode)
                                    AND H.hiCurrency = TH.CurrencyId
                                    AND H.hiYear     = EY.ExchequerYear
                                    AND H.hiPeriod   = @c_CTDPeriod

  GROUP BY H.PositionId
         , TH.HistoryCode
         , TH.HistoryClassificationCode
         , TH.TraderCode
         , TH.NominalCode
         , TH.CurrencyId
         , EY.ExchequerYear

  -- Insert YTD Period Records

  INSERT INTO #TraderHistory
            ( HistoryPositionId
            , HistoryCode
            , HistoryClassificationCode
            , TraderCode
            , NominalCode
            , CurrencyId
            , ExchequerYear
            , PostPeriod
            , SalesAmount
            , PurchaseAmount
            )
  SELECT H.PositionId
       , TH.HistoryCode
       , TH.HistoryClassificationCode
       , TH.TraderCode
       , TH.NominalCode
       , TH.CurrencyId
       , TH.ExchequerYear
       , PostPeriod     = @c_YTDPeriod
       , SalesAmount    = SUM(TH.SalesAmount)
       , PurchaseAmount = SUM(TH.PurchaseAmount)
  FROM #TraderHistory TH
  JOIN common.evw_HistoryClassification HC ON TH.HistoryClassificationCode = HC.HistoryClassificationCode
                                          AND HC.HasYTD                    = @c_True
  LEFT JOIN [!ActiveSchema!].HISTORY H ON H.hiCode       = TH.HistoryCode
                                    AND H.hiEXCLass  = ASCII(TH.HistoryClassificationCode)
                                    AND H.hiCurrency = TH.CurrencyId
                                    AND H.hiYear     = TH.ExchequerYear
                                    AND H.hiPeriod   = @c_YTDPeriod
  GROUP BY H.PositionId
         , TH.HistoryCode
         , TH.HistoryClassificationCode
         , TH.TraderCode
         , TH.NominalCode
         , TH.CurrencyId
         , TH.ExchequerYear

  MERGE [!ActiveSchema!].HISTORY H
  USING ( SELECT HistoryPositionId
               , HistoryCode
               , HistoryClassificationCode
               , TraderCode
               , NominalCode
               , CurrencyId
               , ExchequerYear
               , PostPeriod
               , SalesAmount
               , PurchaseAmount
          FROM #TraderHistory ) TData ON TData.HistoryPositionId = H.PositionId
  WHEN MATCHED THEN
       UPDATE
          SET hiSales     = hiSales     + TData.SalesAmount
            , hiPurchases = hiPurchases + TData.PurchaseAmount

  WHEN NOT MATCHED BY TARGET THEN
         INSERT 
              ( hiCode
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
        VALUES
             ( HistoryCode
             , ASCII(HistoryClassificationCode)
             , CurrencyId
             , ExchequerYear
             , PostPeriod
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

  -- Need to add any Missing 255 year rows for Traders

  DECLARE @MissingHistory TABLE
        ( HistoryClassificationId INT
        , HistoryCode             VARBINARY(21)
        , CurrencyId              INT
        , HistoryYear             INT
        )

  INSERT INTO @MissingHistory
  SELECT DISTINCT
         H.HistoryClassificationId
       , H.HistoryCode
       , H.CurrencyId
       , P.PeriodYear
     
  FROM [!ActiveSchema!].evw_History H (READUNCOMMITTED)
  JOIN (SELECT DISTINCT
               HistoryCode
        FROM   #TraderHistory
        WHERE PostPeriod = @c_CTDPeriod
       ) SData ON H.HistoryCode = SData.HistoryCode

  JOIN common.evw_HistoryClassification HC ON HC.HistoryClassificationCode = H.HistoryClassificationCode
                                          AND HC.HasCTD = @c_True
  CROSS APPLY ( SELECT MinYear = MIN(HistoryYear)
                     , MaxYear = MAX(HistoryYear)
                FROM [!ActiveSchema!].evw_History HMM (READUNCOMMITTED)
                WHERE H.HistoryClassificationCode = HMM.HistoryClassificationCode
                AND   H.HistoryCode               = HMM.HistoryCode
                AND   H.CurrencyId                = HMM.CurrencyId
              ) HMM

  JOIN (SELECT DISTINCT
               PeriodYear
        FROM   [!ActiveSchema!].evw_Period
        CROSS APPLY ( SELECT PMinYear = MIN(PeriodYear)
                           , PMaxYear = MAX(PeriodYear)
                      FROM [!ActiveSchema!].evw_Period 
                    ) PM
        WHERE PeriodYear BETWEEN PM.PMinYear AND PM.PMaxYear
       ) P ON P.PeriodYear BETWEEN HMM.MinYear AND HMM.MaxYear
     
  WHERE 1 = 1
  AND   H.HistoryPeriod = 255
  AND   HMM.MinYear <> HMM.MaxYear
  AND   HMM.MinYear + 1 <> HMM.MaxYear

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM   [!ActiveSchema!].evw_History H1 (READUNCOMMITTED)
                  WHERE H1.HistoryClassificationCode = H.HistoryClassificationCode
                  AND   H1.HistoryCode               = H.HistoryCode
                  AND   H1.CurrencyId                = H.CurrencyId
                  AND   H1.HistoryYear               = P.PeriodYear
                  AND   H1.HistoryPeriod             = @c_CTDPeriod)

  ORDER BY H.HistoryClassificationId
         , H.HistoryCode

  -- Insert Missing History Year Rows

  INSERT INTO [!ActiveSchema!].HISTORY
       ( hiCode
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
  SELECT H.hiCode
       , H.hiExCLass
       , H.hiCurrency
       , hiYear = MH.HistoryYear - 1900
       , H.hiPeriod
       , H.hiSales
       , H.hiPurchases
       , H.hiBudget
       , H.hiCleared
       , H.hiRevisedBudget1
       , H.hiValue1
       , H.hiValue2
       , H.hiValue3
       , H.hiRevisedBudget2
       , H.hiRevisedBudget3
       , H.hiRevisedBudget4
       , H.hiRevisedBudget5
       , H.hiSpareV
     
  FROM   [!ActiveSchema!].HISTORY H (READUNCOMMITTED)
  JOIN   @MissingHistory MH ON MH.HistoryClassificationId = H.hiExCLass
                           AND MH.HistoryCode             = H.hiCode
                           AND MH.CurrencyId              = H.hiCurrency

  WHERE 1 = 1
  AND   H.hiPeriod = @c_CTDPeriod
  AND   H.hiYear   = ( SELECT MAX(hiYear)
                       FROM [!ActiveSchema!].HISTORY H1 (READUNCOMMITTED)
                       WHERE H.hiExCLass  = H1.hiExCLass
                       AND   H.hiCode     = H1.hiCode
                       AND   H.hiCurrency = H1.hiCurrency
                       AND   H1.hiYear    < MH.HistoryYear - 1900
                      ) 


  -- Set Starting position for new 255 records

  UPDATE ThisYear
     SET hiSales     = ThisYear.hiSales     + ISNULL(LastYear.SalesAmount, 0)
       , hiPurchases = ThisYear.hiPurchases + ISNULL(LastYear.PurchaseAmount, 0)

  FROM   [!ActiveSchema!].HISTORY ThisYear (READUNCOMMITTED)
  JOIN   #TraderHistory SPH ON ThisYear.hiExCLass   = ASCII(SPH.HistoryClassificationCode)
                            AND ThisYear.hiCurrency = SPH.CurrencyId
                            AND ThisYear.hiCode     = SPH.HistoryCode
                            AND ThisYear.hiYear     = SPH.ExchequerYear
                            AND ThisYear.hiPeriod   = SPH.PostPeriod
  LEFT JOIN   [!ActiveSchema!].evw_History LastYear (READUNCOMMITTED) ON ThisYear.hiExCLass  = LastYear.HistoryClassificationId
                                          AND ThisYear.hiCurrency = LastYear.CurrencyId
                                          AND ThisYear.hiCode     = LastYear.HistoryCode
                                          AND ThisYear.hiYear - 1 = LastYear.ExchequerYear
                                          AND ThisYear.hiPeriod   = LastYear.ExchequerPeriod

  WHERE SPH.HistoryPositionId IS NULL 
  AND   SPH.PostPeriod        = @c_CTDPeriod


END


GO