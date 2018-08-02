IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_PostStock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_PostStock
GO

CREATE PROCEDURE !ActiveSchema!.esp_PostStock ( @itvp_PostLineTransactions common.edt_Integer READONLY
                                              , @iv_RunNo INT
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

  DECLARE @ss_NoOfDPQuantity      INT = 2
        , @ss_UseMultiLocations   BIT = @c_False
        , @ss_TraderStockAnalysis BIT = @c_False
        , @ss_PostToCCDept        BIT = @c_False
        , @ss_PostToCCOrDept      BIT = @c_False
        
  SELECT @ss_NoOfDPQuantity    = SS.NoOfDPQuantity
       , @ss_UseMultiLocations = SS.UseMultiLocations
       , @ss_PostToCCDept      = SS.PostToCostCentreAndDepartment
       , @ss_PostToCCOrDept    = SS.PostToCostCentreOrDepartment
  FROM !ActiveSchema!.evw_SystemSettings SS
  
  SELECT @ss_TraderStockAnalysis = ISNULL((SELECT @c_True 
                                           FROM common.etb_Information CI
                                           WHERE CI.InformationName = 'Account Stock Analysis' 
                                           AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), @c_False)

  IF OBJECT_ID('tempdb..#itvp_PostLineTransactions') IS NOT NULL
    DROP TABLE #itvp_PostLineTransactions

  SELECT *
  INTO #itvp_PostLineTransactions
  FROM @itvp_PostLineTransactions

  CREATE INDEX idx_PLT ON #itvp_PostLineTransactions(IntegerValue)

  IF OBJECT_ID('tempdb..#StockPostDetail') IS NOT NULL
    DROP TABLE #StockPostDetail
  
  SELECT TL.LinePositionId
       , TL.DisplayLineNo
       , TL.StockCode
       , StockFolioNumber          = S.FolioNumber
       , HistoryClassificationCode = S.StockType
       , HistoryClassificationId   = ASCII(S.StockType)
       , TL.LocationCode
       , TL.TraderCode
       , TL.CostCentreCode
       , TL.DepartmentCode
       
       , StockMovementQuantity        = TL.StockMovementQuantity * TL.StockMovementSign
       , TSAStockMovement             = CASE
                                        WHEN TL.StockMovementQuantity = 0 THEN (TL.LineQuantity * TL.LineQuantityMultiplier)
                                        ELSE TL.StockMovementQuantity
                                        END * TL.StockMovementSign
       , TL.StockMovementSign
       , TL.TransactionTypeCode
       , TL.TransactionTypeSign

       , TL.CurrencyId
       , TL.TransactionPeriodKey
       
       , LineCalculatedNetValue       = TL.LineCalculatedNetValue * TL.TransactionTypeSign
       , LineCalculatedNetValueInBase = TL.LineCalculatedNetValueInBase * TL.TransactionTypeSign
       , LineCost                     = TL.LineCost * TL.TransactionTypeSign
       , LineCostInBase               = TL.LineCostInBase * TL.TransactionTypeSign
       , TL.COSConversionRate

  INTO #StockPostDetail

  FROM !ActiveSchema!.evw_TransactionLine TL (READUNCOMMITTED)
  JOIN !ActiveSchema!.evw_Stock S ON TL.StockCode = S.StockCode
  
  WHERE 1 = 1
  AND   TL.ExchequerYear  >   0 --@ss_AuditExchequerYear
  AND   TL.StockCode     <> ''

  AND   EXISTS (SELECT TOP 1 1
                FROM #itvp_PostLineTransactions PLT
                WHERE PLT.IntegerValue = TL.LinePositionId)

                
  ORDER BY StockCode, TransactionLineDate , LineFolioNumber , LinePositionId
  
  CREATE INDEX idx_SPD1 ON #StockPostDetail(HistoryClassificationCode, TransactionTypeCode, StockCode, CurrencyId, DisplayLineNo)

  IF OBJECT_ID('tempdb..#StockAscendant') IS NOT NULL
    DROP TABLE #StockAscendant

  SELECT StockCode
       , HierarchyLevel
       , AscendantStockCode
       , AscendantHierarchyLevel
  INTO   #StockAscendant
  FROM   [!ActiveSchema!].evw_StockAscendant

  WHERE StockCode IN (SELECT DISTINCT StockCode
                      FROM #StockPostDetail)

  CREATE INDEX idx_StockAscendant ON #StockAscendant(StockCode, AscendantStockCode)


  -- Create History Summary

  IF OBJECT_ID('tempdb..#StockPostHistory') IS NOT NULL
    DROP TABLE #StockPostHistory

  -- Insert the Stock rows only

  SELECT HistoryPositionId         = CONVERT(INT, NULL)
       , HistoryCode               = common.efn_CreateStockHistoryCode(MAX(S.stFolioNum), '')
       , StockCode                 = SA.AscendantStockCode
       , StockFolioNumber          = MAX(S.stFolioNum)
       , HistoryClassificationCode = MAX(S.stType)
       , HistoryClassificationId   = ASCII(MAX(S.stType))
       , LocationCode              = CONVERT(CHAR(3), NULL)
       , TraderCode                = CONVERT(CHAR(6), NULL)
       , CostCentreCode            = CONVERT(CHAR(3), NULL)
       , DepartmentCode            = CONVERT(CHAR(3), NULL)
       , CurrencyId                = C.CurrencyCode
       , HistoryPeriodKey          = SPD.TransactionPeriodKey

       , StockMovementQuantity     = SUM(ROUND(SPD.StockMovementQuantity, @ss_NoOfDPQuantity) * -1)

       , SalesAmount               = SUM(CASE
                                         WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCalculatedNetValueInBase
                                         ELSE SPD.LineCalculatedNetValue
                                         END * -1)
       , PurchaseAmount            = SUM(CASE
                                         WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCostInBase
                                         ELSE SPD.LineCost
                                         END * -1)
  INTO #StockPostHistory
  FROM #StockPostDetail       SPD
  JOIN #StockAscendant         SA ON SPD.StockCode = SA.StockCode
  JOIN !ActiveSchema!.STOCK    S  ON SA.AscendantStockCode = S.stCode
  JOIN !ActiveSchema!.CURRENCY C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
  
  WHERE SPD.HistoryClassificationCode  IN ('M', 'P', 'X')
  AND   SPD.TransactionTypeCode IN ('SIN','SCR','SRF','SRI','SJI','SJC','SDN')
  AND   SPD.DisplayLineNo >= 0
  
  GROUP BY SA.AscendantStockCode
         , C.CurrencyCode
         , SPD.TransactionPeriodKey

 -- Insert the Stock rows only Stock Type + 159

  INSERT INTO #StockPostHistory
            ( HistoryCode
            , StockCode
            , StockFolioNumber
            , HistoryClassificationCode
            , HistoryClassificationId
            , CurrencyId
            , HistoryPeriodKey

            , StockMovementQuantity
            , SalesAmount
            , PurchaseAmount
            )
  SELECT HistoryCode               = common.efn_CreateStockHistoryCode(MAX(S.stFolioNum), '')
       , StockCode                 = SPD.StockCode
       , StockFolioNumber          = MAX(S.stFolioNum)
       , HistoryClassificationCode = MAX(CHAR(ASCII(S.stType) + 159))
       , HistoryClassificationId   = MAX(ASCII(S.stType) + 159)
       , CurrencyId                = @c_BaseCurrencyId
       , HistoryPeriodKey          = SPD.TransactionPeriodKey

       , StockMovementQuantity     = SUM(ROUND(SPD.StockMovementQuantity, @ss_NoOfDPQuantity) )
       , SalesAmount               = SUM(CASE
                                         WHEN LineCalculatedNetValue < 0 THEN ABS(LineCalculatedNetValue)
                                         ELSE 0
                                         END)
       , PurchaseAmount            = SUM(CASE
                                         WHEN LineCalculatedNetValue > 0 THEN ABS(LineCalculatedNetValue )
                                         ELSE 0
                                         END)

  FROM #StockPostDetail SPD
  JOIN !ActiveSchema!.STOCK              S  ON SPD.StockCode = S.stCode
  
  WHERE SPD.HistoryClassificationCode     IN ('M', 'P', 'X')
  AND   SPD.TransactionTypeCode       NOT IN ('SRC','PPY')
  
  GROUP BY SPD.StockCode
         , SPD.TransactionPeriodKey

  -- Insert the Stock & Location rows
  IF @ss_UseMultiLocations = @c_True
  BEGIN
    INSERT INTO #StockPostHistory
              ( HistoryCode
              , StockCode
              , StockFolioNumber
              , HistoryClassificationCode
              , HistoryClassificationId
              , LocationCode
              , CurrencyId
              , HistoryPeriodKey

              , StockMovementQuantity
              , SalesAmount
              , PurchaseAmount
              )
    SELECT HistoryCode                = common.efn_CreateStockHistoryCode(MAX(S.stFolioNum), SPD.LocationCode)
         , SA.AscendantStockCode
         , StockFolioNumber           = MAX(S.stFolioNum)
         , HistoryClassificationCode  = MAX(S.stType)
         , HistoryClassificationId    = ASCII(MAX(S.stType))
         , SPD.LocationCode
         , CurrencyId                 = C.CurrencyCode
         , SPD.TransactionPeriodKey

         , StockMovementQuantity      = SUM(ROUND(SPD.StockMovementQuantity, @ss_NoOfDPQuantity) * -1)
         , SalesAmount                = SUM(CASE
                                            WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCalculatedNetValueInBase
                                            ELSE SPD.LineCalculatedNetValue
                                            END * -1)
         , PurchaseAmount             = SUM(CASE
                                            WHEN C.CurrencyCode = @c_BasecurrencyId THEN SPD.LineCostInBase
                                            ELSE SPD.LineCost
                                            END * -1)

    FROM #StockPostDetail SPD
    JOIN #StockAscendant         SA ON SPD.StockCode = SA.StockCode
    JOIN !ActiveSchema!.STOCK    S  ON SA.AscendantStockCode = S.stCode
    JOIN !ActiveSchema!.CURRENCY C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
  
    WHERE SPD.HistoryClassificationCode IN ('M', 'P', 'X')
    AND   SPD.TransactionTypeCode       IN ('SIN','SCR','SRF','SRI','SJI','SJC','SDN')
    AND   SPD.DisplayLineNo >= 0
 
    GROUP BY SA.AscendantStockCode
           , SPD.LocationCode
           , C.CurrencyCode
           , SPD.TransactionPeriodKey

    -- Insert the Stock & Location rows Stype + 159 rows

    INSERT INTO #StockPostHistory
              ( HistoryCode
              , StockCode
              , StockFolioNumber
              , HistoryClassificationCode
              , HistoryClassificationId
              , LocationCode
              , CurrencyId
              , HistoryPeriodKey

              , StockMovementQuantity
              , SalesAmount
              , PurchaseAmount
              )
    SELECT HistoryCode               = common.efn_CreateStockHistoryCode(MAX(S.stFolioNum), SPD.LocationCode)
         , SPD.StockCode
         , StockFolioNumber          = MAX(S.stFolioNum)
         , HistoryClassificationCode = MAX(CHAR(ASCII(S.stType) + 159))
         , HistoryClassificationId   = MAX(ASCII(S.stType) + 159)
         , SPD.LocationCode
         , CurrencyId                = @c_BaseCurrencyId
         , SPD.TransactionPeriodKey

         , StockMovementQuantity     = SUM(ROUND(SPD.StockMovementQuantity, @ss_NoOfDPQuantity) )
         , SalesAmount               = SUM(CASE
                                           WHEN LineCalculatedNetValue < 0 THEN ABS(LineCalculatedNetValue)
                                           ELSE 0
                                           END)
         , PurchaseAmount            = SUM(CASE
                                           WHEN LineCalculatedNetValue > 0 THEN ABS(LineCalculatedNetValue)
                                           ELSE 0
                                           END)

    FROM #StockPostDetail SPD
    JOIN !ActiveSchema!.STOCK     S  ON SPD.StockCode = S.stCode
  
    WHERE SPD.HistoryClassificationCode     IN ('M', 'P', 'X')
    AND   SPD.TransactionTypeCode       NOT IN ('SRC','PPY')
  
    GROUP BY SPD.StockCode
           , SPD.LocationCode
           , SPD.TransactionPeriodKey

  END
  
  -- Insert Rows for Trader Stock History
  IF @ss_TraderStockAnalysis = @c_True
  BEGIN
    
    -- Trader/Stock Folio combination
    
    INSERT INTO #StockPostHistory
              ( HistoryCode
              , StockCode
              , StockFolioNumber
              , HistoryClassificationCode
              , HistoryClassificationId
              , TraderCode
              , CurrencyId
              , HistoryPeriodKey
              , StockMovementQuantity
              , SalesAmount
              , PurchaseAmount
              )
    SELECT HistoryCode               = 0x14
                                     + CONVERT(VARBINARY(20), TraderCode)
                                     + CONVERT(VARBINARY(20), (CHAR(0) + CHAR(0) + CHAR(0) + CHAR(0) ))
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 7, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 5, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 3, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 1, 2), 2)
                                     + CONVERT(VARBINARY(max), '!')
                                     + CONVERT(VARBINARY(max), SPACE(5))
         , StockCode
         , StockFolioNumber
         , HistoryClassificationCode = 'E'
         , HistoryClassificationId   = ASCII('E')
         , SPD.TraderCode
         , C.CurrencyCode
         , TransactionPeriodKey
         , StockMovementQuantity     = SUM(SPD.TSAStockMovement * -1)
         , SalesAmount               = SUM(CASE
                                           WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCalculatedNetValueInBase
                                           ELSE SPD.LineCalculatedNetValue
                                           END * -1)
         , PurchaseAmount            = SUM(CASE
                                           WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCostInBase
                                           ELSE SPD.LineCost
                                           END * -1)
         
    FROM   #StockPostDetail SPD
    JOIN !ActiveSchema!.CURRENCY           C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
    CROSS APPLY ( VALUES ( (CONVERT(VARCHAR, CONVERT(VARBINARY(21), StockFolioNumber), 2))
                         )
                ) SFN (BinCode)
    
    GROUP BY TraderCode
           , StockCode
           , StockFolioNumber
           , SFN.BinCode
           , C.CurrencyCode
           , TransactionPeriodKey

    -- Trader/Stock Folio/CC combination
    IF ( @ss_PostToCCDept   = @c_True
      OR @ss_PostToCCOrDept = @c_True
       )
    BEGIN
      INSERT INTO #StockPostHistory
                ( HistoryCode
                , StockCode
                , StockFolioNumber
                , HistoryClassificationCode
                , HistoryClassificationId
                , TraderCode
                , CostCentreCode
                , CurrencyId
                , HistoryPeriodKey
                , StockMovementQuantity
                , SalesAmount
                , PurchaseAmount
                )
      SELECT HistoryCode               = 0x14
                                       + CONVERT(VARBINARY(max), CHAR(1))
                                       + CONVERT(VARBINARY(max), TraderCode)
                                       + CONVERT(VARBINARY(max), (CHAR(0) + CHAR(0) + CHAR(0) + CHAR(0) ))
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 7, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 5, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 3, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 1, 2), 2)
                                       + CONVERT(VARBINARY(max), '!C')
                                       + CONVERT(VARBINARY(max), CostCentreCode)
           , StockCode
           , StockFolioNumber
           , HistoryClassificationCode = 'E'
           , HistoryClassificationId   = ASCII('E')
           , SPD.TraderCode
           , SPD.CostCentreCode
           , C.CurrencyCode
           , TransactionPeriodKey
           , StockMovementQuantity     = SUM(SPD.TSAStockMovement * -1)
           , SalesAmount               = SUM(CASE
                                             WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCalculatedNetValueInBase
                                             ELSE SPD.LineCalculatedNetValue
                                             END * -1)
           , PurchaseAmount            = SUM(CASE
                                             WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCostInBase
                                             ELSE SPD.LineCost
                                             END * -1)
         
      FROM   #StockPostDetail SPD
      JOIN !ActiveSchema!.CURRENCY           C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
      CROSS APPLY ( VALUES ( (CONVERT(VARCHAR, CONVERT(VARBINARY(21), StockFolioNumber), 2))
                           )
                  ) SFN (BinCode)
    
      GROUP BY TraderCode
             , StockCode
             , StockFolioNumber
             , SFN.BinCode
             , SPD.CostCentreCode
             , C.CurrencyCode
             , TransactionPeriodKey

      -- Trader/Stock Folio/Dept combination
    
      INSERT INTO #StockPostHistory
                ( HistoryCode
                , StockCode
                , StockFolioNumber
                , HistoryClassificationCode
                , HistoryClassificationId
                , TraderCode
                , DepartmentCode
                , CurrencyId
                , HistoryPeriodKey
                , StockMovementQuantity
                , SalesAmount
                , PurchaseAmount
                )
      SELECT HistoryCode               = 0x14
                                       + CONVERT(VARBINARY(max), CHAR(1))
                                       + CONVERT(VARBINARY(max), TraderCode)
                                       + CONVERT(VARBINARY(max), (CHAR(0) + CHAR(0) + CHAR(0) + CHAR(0) ))
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 7, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 5, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 3, 2), 2)
                                       + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 1, 2), 2)
                                       + CONVERT(VARBINARY(max), '!D')
                                       + CONVERT(VARBINARY(max), DepartmentCode)
           , StockCode
           , StockFolioNumber
           , HistoryClassificationCode = 'E'
           , HistoryClassificationId   = ASCII('E')
           , SPD.TraderCode
           , SPD.DepartmentCode
           , C.CurrencyCode
           , TransactionPeriodKey
           , StockMovementQuantity     = SUM(SPD.TSAStockMovement * -1)
           , SalesAmount               = SUM(CASE
                                             WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCalculatedNetValueInBase
                                             ELSE SPD.LineCalculatedNetValue
                                             END * -1)
           , PurchaseAmount            = SUM(CASE
                                             WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCostInBase
                                             ELSE SPD.LineCost
                                             END * -1)
         
      FROM   #StockPostDetail SPD
      JOIN !ActiveSchema!.CURRENCY           C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
      CROSS APPLY ( VALUES ( (CONVERT(VARCHAR, CONVERT(VARBINARY(21), StockFolioNumber), 2))
                           )
                  ) SFN (BinCode)
    
      GROUP BY TraderCode
             , StockCode
             , StockFolioNumber
             , SFN.BinCode
             , SPD.DepartmentCode
             , C.CurrencyCode
             , TransactionPeriodKey
    END

    -- Trader/Stock Folio/Location combination
    
    INSERT INTO #StockPostHistory
              ( HistoryCode
              , StockCode
              , StockFolioNumber
              , HistoryClassificationCode
              , HistoryClassificationId
              , TraderCode
              , LocationCode
              , CurrencyId
              , HistoryPeriodKey
              , StockMovementQuantity
              , SalesAmount
              , PurchaseAmount
              )
    SELECT HistoryCode               = 0x14
                                     + CONVERT(VARBINARY(max), CHAR(2))
                                     + CONVERT(VARBINARY(max), TraderCode)
                                     + CONVERT(VARBINARY(max), (CHAR(0) + CHAR(0) + CHAR(0) + CHAR(0) ))
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 7, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 5, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 3, 2), 2)
                                     + CONVERT(VARBINARY(max), SUBSTRING(BinCode, 1, 2), 2)
                                     + CONVERT(VARBINARY(max), '!')
                                     + CONVERT(VARBINARY(max), LocationCode)
                                     + CONVERT(VARBINARY(max), SPACE(1))
         , StockCode
         , StockFolioNumber
         , HistoryClassificationCode = 'E'
         , HistoryClassificationId   = ASCII('E')
         , SPD.TraderCode
         , SPD.LocationCode
         , C.CurrencyCode
         , TransactionPeriodKey
         , StockMovementQuantity     = SUM(SPD.TSAStockMovement * -1)
         , SalesAmount               = SUM(CASE
                                           WHEN C.CurrencyCode = @c_BasecurrencyId THEN SPD.LineCalculatedNetValueInBase
                                           ELSE SPD.LineCalculatedNetValue
                                           END * -1)
         , PurchaseAmount            = SUM(CASE
                                           WHEN C.CurrencyCode = @c_BaseCurrencyId THEN SPD.LineCostInBase
                                           ELSE SPD.LineCost
                                           END * -1)
         
    FROM   #StockPostDetail SPD
    JOIN !ActiveSchema!.CURRENCY           C  ON C.CurrencyCode IN (@c_BaseCurrencyId, SPD.CurrencyId)
    CROSS APPLY ( VALUES ( (CONVERT(VARCHAR, CONVERT(VARBINARY(21), StockFolioNumber), 2))
                         )
                ) SFN (BinCode)
    WHERE LocationCode <> ''

    GROUP BY TraderCode
           , StockCode
           , StockFolioNumber
           , SFN.BinCode
           , SPD.LocationCode
           , C.CurrencyCode
           , TransactionPeriodKey

  END

  -- INSERT YTD/CTD Records
  INSERT INTO #StockPostHistory
            ( HistoryCode
            , StockCode
            , StockFolioNumber
            , HistoryClassificationCode
            , HistoryClassificationId
            , LocationCode
            , TraderCode
            , CostCentreCode
            , DepartmentCode
            , CurrencyId
            , HistoryPeriodKey
            , StockMovementQuantity
            , SalesAmount
            , PurchaseAmount
            )
  SELECT HistoryCode
       , StockCode
       , StockFolioNumber
       , SPH.HistoryClassificationCode
       , SPH.HistoryClassificationId
       , LocationCode
       , TraderCode
       , CostCentreCode
       , DepartmentCode
       , CurrencyId
       , HistoryPeriodKey      = HPK.HistoryPeriodKey
       , StockMovementQuantity = SUM(StockMovementQuantity)
       , SalesAmount           = SUM(SalesAmount)
       , PurchaseAmount        = SUM(PurchaseAmount)
       
  FROM #StockPostHistory SPH
  JOIN (SELECT DISTINCT
               HistoryClassificationId
             , HistoryClassificationCode
             , ExchquerPeriod = @c_YTDPeriod
        FROM   common.evw_HistoryClassification
        WHERE HasYTD = @c_True
        UNION
        SELECT DISTINCT
               HistoryClassificationId
             , HistoryClassificationCode
             , ExchquerPeriod = @c_CTDPeriod
        FROM   common.evw_HistoryClassification
        WHERE HasCTD = @c_True ) YTDCTD ON SPH.HistoryClassificationId = YTDCTD.HistoryClassificationId

  CROSS APPLY ( SELECT HistoryPeriodKey = (FLOOR(SPH.HistoryPeriodKey/1000) * 1000) + YTDCTD.ExchquerPeriod
              ) HPK

  GROUP BY HistoryCode
         , StockCode
         , StockFolioNumber
         , SPH.HistoryClassificationCode
         , SPH.HistoryClassificationId
         , LocationCode
         , TraderCode
         , CostCentreCode
         , DepartmentCode
         , CurrencyId
         , HPK.HistoryPeriodKey

  -- Set the History Position Id

  UPDATE SPH
     SET HistoryPositionId = SH.HistoryPositionId
  FROM #StockPostHistory SPH
  JOIN !ActiveSchema!.evw_History SH (READUNCOMMITTED) ON SPH.HistoryClassificationId = SH.HistoryClassificationId
                            AND SPH.HistoryCode      = SH.HistoryCode
                            AND SPH.HistoryPeriodKey = SH.HistoryPeriodKey
                            AND SPH.CurrencyId       = SH.CurrencyId


  CREATE NONCLUSTERED INDEX idx_SPH ON #StockPostHistory(HistoryPositionId)

  -- Post Stock Records that do not exist

  INSERT INTO !ActiveSchema!.HISTORY
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
       SELECT   SData.HistoryCode
              , SData.HistoryClassificationId
              , SData.CurrencyId
              , ExchequerYear   = (FLOOR(SData.HistoryPeriodKey/1000) - 1900)
              , ExchequerPeriod = (SData.HistoryPeriodKey%1000)
              , SUM(SData.SalesAmount)
              , SUM(SData.PurchaseAmount)
              , 0
              , SUM(SData.StockMovementQuantity)
              , 0
              , 0
              , 0
              , 0
              , 0
              , 0
              , 0
              , 0
              , 0
       FROM #StockPostHistory SData
       WHERE SData.HistoryPositionId IS NULL
       GROUP BY SData.HistoryCode
              , SData.HistoryClassificationId
              , SData.CurrencyId
              , (FLOOR(SData.HistoryPeriodKey/1000) - 1900)
              , (SData.HistoryPeriodKey%1000)


  -- Post updates to HISTORY

  UPDATE H
     SET hiSales     = hiSales     + SalesAmount
       , hiPurchases = hiPurchases + PurchaseAmount
       , hiCleared   = hiCleared   + StockMovementQuantity
  FROM !ActiveSchema!.HISTORY H
  JOIN #StockPostHistory SData ON SData.HistoryPositionId = H.PositionId

  -- Insert missing Stock HISTORY Year rows

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
     
  FROM !ActiveSchema!.evw_History H (READUNCOMMITTED)
  JOIN (SELECT DISTINCT
               HistoryCode
        FROM   #StockPostHistory SPH
        WHERE (HistoryPeriodKey%1000) = @c_CTDPeriod
       ) SData ON H.HistoryCode = SData.HistoryCode

  JOIN common.evw_HistoryClassification HC ON HC.HistoryClassificationCode = H.HistoryClassificationCode
                                          AND HC.HasCTD = @c_True
  CROSS APPLY ( SELECT MinYear = MIN(HistoryYear)
                     , MaxYear = MAX(HistoryYear)
                FROM !ActiveSchema!.evw_History HMM (READUNCOMMITTED)
                WHERE H.HistoryClassificationCode = HMM.HistoryClassificationCode
                AND   H.HistoryCode               = HMM.HistoryCode
                AND   H.CurrencyId                = HMM.CurrencyId
              ) HMM

  JOIN (SELECT DISTINCT
               PeriodYear
        FROM   !ActiveSchema!.evw_Period
        CROSS APPLY ( SELECT PMinYear = MIN(PeriodYear)
                           , PMaxYear = MAX(PeriodYear)
                      FROM !ActiveSchema!.evw_Period 
                      WHERE HasTransactions = @c_True
                    ) PM
        WHERE PeriodYear BETWEEN PM.PMinYear AND PM.PMaxYear
       ) P ON P.PeriodYear BETWEEN HMM.MinYear AND HMM.MaxYear
     
  WHERE 1 = 1
  AND   H.HistoryPeriod = @c_CTDPeriod
  AND   HMM.MinYear <> HMM.MaxYear
  AND   HMM.MinYear + 1 <> HMM.MaxYear

  AND NOT EXISTS (SELECT TOP 1 1
                  FROM   !ActiveSchema!.evw_History H1 (READUNCOMMITTED)
                  WHERE H1.HistoryClassificationCode = H.HistoryClassificationCode
                  AND   H1.HistoryCode               = H.HistoryCode
                  AND   H1.CurrencyId                = H.CurrencyId
                  AND   H1.HistoryYear               = P.PeriodYear
                  AND   H1.HistoryPeriod             = @c_CTDPeriod)

  ORDER BY H.HistoryClassificationId
         , H.HistoryCode

  -- Insert Missing History Year Rows

  INSERT INTO !ActiveSchema!.HISTORY
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
       , 0
       , 0
       , 0
       , H.hiRevisedBudget2
       , H.hiRevisedBudget3
       , H.hiRevisedBudget4
       , H.hiRevisedBudget5
       , 0
     
  FROM   !ActiveSchema!.HISTORY H (READUNCOMMITTED)
  JOIN   @MissingHistory MH ON MH.HistoryClassificationId = H.hiExCLass
                           AND MH.HistoryCode             = H.hiCode
                           AND MH.CurrencyId              = H.hiCurrency

  WHERE 1 = 1
  AND   H.hiPeriod = @c_CTDPeriod
  AND   H.hiYear   = ( SELECT MAX(hiYear)
                       FROM !ActiveSchema!.HISTORY H1 (READUNCOMMITTED)
                       WHERE H.hiExCLass  = H1.hiExCLass
                       AND   H.hiCode     = H1.hiCode
                       AND   H.hiCurrency = H1.hiCurrency
                       AND   H1.hiYear    < MH.HistoryYear - 1900
                     )


  -- Set Starting position for new 255 records

  UPDATE ThisYear
     SET hiSales     = ThisYear.hiSales     + ISNULL(LastYear.SalesAmount, 0)
       , hiPurchases = ThisYear.hiPurchases + ISNULL(LastYear.PurchaseAmount, 0)
       , hiCleared   = ThisYear.hiCleared   + ISNULL(LastYear.ClearedBalance, 0)
  FROM   !ActiveSchema!.HISTORY ThisYear (READUNCOMMITTED)
  JOIN   #StockPostHistory SPH ON ThisYear.hiExCLass = SPH.HistoryClassificationId
                                          AND ThisYear.hiCurrency              = SPH.CurrencyId
                                          AND ThisYear.hiCode             = SPH.HistoryCode
                                          AND (((ThisYear.hiYear + 1900) * 1000) + ThisYear.hiPeriod) = SPH.HistoryPeriodKey
  LEFT JOIN   !ActiveSchema!.evw_History LastYear (READUNCOMMITTED) ON ThisYear.hiExCLass  = LastYear.HistoryClassificationId
                                          AND ThisYear.hiCurrency = LastYear.CurrencyId
                                          AND ThisYear.hiCode     = LastYear.HistoryCode
                                          AND ThisYear.hiYear - 1 = LastYear.ExchequerYear
                                          AND ThisYear.hiPeriod   = LastYear.ExchequerPeriod

  WHERE SPH.HistoryPositionId IS NULL 
  AND (SPH.HistoryPeriodKey%1000) = @c_CTDPeriod

END
GO
