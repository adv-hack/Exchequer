
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_UpdatebuildCosts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_UpdateBuildCosts]
GO

-- Usage: EXEC !ActiveSchema!.esp_UpdateBuildCosts 1

CREATE PROCEDURE !ActiveSchema!.esp_UpdateBuildCosts ( @iv_Mode INT = 0 )
AS 
BEGIN

-- Modes: 0 - Fix Data
--        1 - Report Data

  DECLARE @c_Fix        INT = 0
        , @c_Report     INT = 1
        , @c_Debug      INT = 2

  SET NOCOUNT ON;

  IF OBJECT_ID('tempdb..#BOMDetail') IS NOT NULL
  DROP TABLE #BOMDetail

  CREATE TABLE #BOMDetail
       ( BOMDetailId             INT IDENTITY(1, 1)
       , BOMPositionId           INT
       , StockFolioNumber        INT
       , FullStockCode           VARCHAR(50)
       , QuantityCurrency        INT
       , QuantityUsed            FLOAT
       , QuantityUnitCost        FLOAT
       , QuantityUnitCostInBase  FLOAT
       , QuantityTotalCost       FLOAT
       , QuantityTotalCostInBase FLOAT
       , IsFreeIssue             BIT
       , QuantityTime            INT
       , ParentBOMFolioNumber    INT
       UNIQUE CLUSTERED (ParentBOMFolioNumber, StockFolioNumber, BOMDetailId)
       ) 

  INSERT INTO #BOMDetail
            ( BOMPositionId        
            , StockFolioNumber     
            , FullStockCode        
            , QuantityCurrency     
            , QuantityUsed         
            , QuantityUnitCost         
            , QuantityTotalCost    
            , IsFreeIssue          
            , QuantityTime         
            , ParentBOMFolioNumber
            , QuantityUnitCostInBase
            , QuantityTotalCostInBase
            )
      SELECT  BOMPositionId
            , StockFolioNumber
            , FullStockCode
            , QuantityCurrency
            , QuantityUsed
            , QuantityUnitCost
            , QuantityTotalCost
            , IsFreeIssue
            , QuantityTime

            , ParentBOMFolioNumber
            , QuantityUnitCostInBase  
            , QuantityTotalCostInBase
       FROM   !ActiveSchema!.evw_BillOfMaterials BOM

  -- Update values if they are different in Stock Record

  UPDATE BOM
     SET QuantityUnitCost        = BOMPrice
       , QuantityTotalCost       = QuantityUsed * BOMPrice
       , QuantityUnitCostInBase  = BOMPriceInBase
       , QuantityTotalCostInBase = QuantityUsed * BOMPriceInBase

    FROM #BOMDetail BOM
    JOIN   !ActiveSchema!.evw_Stock S ON S.FolioNumber = BOM.StockFolioNumber
    LEFT JOIN !ActiveSchema!.CURRENCY C ON S.BOMPriceCurrency = C.CurrencyCode
    CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
    CROSS APPLY ( VALUES ( (CASE
                            WHEN CurrencyCode IN (0, 1) THEN 1
                            WHEN UseCompanyRate = 1 THEN C.CompanyRate
                            WHEN UseDailyRate = 1 THEN C.DailyRate
                            END
                           )
                         )
                ) Rate (ConversionRate)
    CROSS APPLY ( VALUES ( common.efn_ExchequerCurrencyConvert( BOMPrice
                                                              , ConversionRate
                                                              , BOMPriceCurrency
                                                              , 0
                                                              , 0
                                                              , C.TriRate
                                                              , C.TriInverted
                                                              , C.TriCurrencyCode
                                                              , C.IsFloating
                                                              )
                      )
                ) BOMBase ( BOMPriceInBase )

    WHERE ABS(BOM.QuantityUnitCostInBase - BOMPriceInBase) > 0.01
    --AND   QuantityUsedCurrency = BOMPriceCurrency

  IF OBJECT_ID('tempdb..#BOMData') IS NOT NULL
  DROP TABLE #BOMData

  CREATE TABLE #BOMData
             ( BOMId                INT IDENTITY(1, 1)
             , BOMPositionId        INT
             , BOMFolioNumber       INT
             , BOMParentFolioNumber INT NULL
             , StockCode            VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS
             , StockValuationMethod VARCHAR(1)

             , BOMLevel             INT
             , BOMHierarchy         VARCHAR(max) COLLATE SQL_Latin1_General_CP1_CI_AS
             , BOMCurrency          INT

             , BOMQuantity          FLOAT NULL
             , BOMUnitCost          FLOAT NULL
             , BOMUnitCostInBase    FLOAT NULL
             , BOMTotalCost         FLOAT NULL
             , BOMTotalCostInBase   FLOAT NULL
             , BOMProductionTime    FLOAT NULL

             , StockReOrderCurrency           INT   NULL
             , StockReOrderPrice              FLOAT NULL
             , StockReOrderPriceInBase        FLOAT NULL

             , SumOfChildrenTotalCost         FLOAT NULL
             , SumOfChildrenTotalCostInBase   FLOAT NULL
             , SumOfChildrenTotalCostInReOrderCurrency FLOAT NULL

             , BalanceDifference                       FLOAT NULL

             , UNIQUE CLUSTERED (BOMLevel, BOMFolioNumber, BOMId)
             )

  DECLARE @Level    INT = 0
        , @NoOfRows INT = 0

  -- Insert Level 0 - Top Level BOM's -- Originally it just had Stock Type M, however, it was felt we should include discontinued stock too
                                      -- if they were formally part of a BOM

  INSERT INTO #BOMData
            ( BOMPositionId
            , BOMFolioNumber
            , StockCode
            , StockValuationMethod
            , BOMLevel
            , BOMHierarchy
            , BOMCurrency
            , BOMQuantity
            , BOMUnitCost
            , BOMTotalCost
            , BOMProductionTime

            , StockReOrderCurrency
            , StockReOrderPrice
            )
       SELECT BOMPositionId        = PBD.BOMPositionId
            , BOMFolioNumber       = BOM.stFolioNum
            , StockCode            = RTRIM(BOM.stCode) COLLATE SQL_Latin1_General_CP1_CI_AS
            , StockValuationMethod = BOM.stValuationMethod COLLATE SQL_Latin1_General_CP1_CI_AS
            , BOMLevel             = 0
            , BOMHierarchy         = '~' + CONVERT(VARCHAR(max), RTRIM(BOM.stCode)) + '~' COLLATE SQL_Latin1_General_CP1_CI_AS
            , BOMCurrency          = BOM.stCostPriceCurrency
            , BOMQuantity          = CONVERT(FLOAT, 1)
            , BOMUnitCost          = BOM.stCostPrice
            , BOMTotalCost         = ROUND(CASE
                                           WHEN BOM.stCalcPack = 1 THEN BOM.stCostPrice / BOM.stPurchaseUnits
                                           ELSE BOM.stCostPrice
                                           END, SS.NoOfDPCost)
            , BOMProductionTime    = stBOMProductionTime 

            , StockReOrderCurrency = BOM.stReorderCurrency
            , StockReOrderPrice    = BOM.stReorderPrice

  FROM   !ActiveSchema!.STOCK BOM
  JOIN   (SELECT DISTINCT ParentBOMFolioNumber FROM #BOMDetail) AS BD ON BD.ParentBOMFolioNumber = BOM.stFolioNum
  JOIN   #BOMDetail PBD ON BD.ParentBOMFolioNumber = PBD.StockFolioNumber

  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS

  SELECT @NoOfRows = @@ROWCOUNT

  WHILE @NoOfRows > 0
  BEGIN
    -- Loop Through each level adding children
    IF @iv_Mode = @c_Debug RAISERROR ('Adding Level %i ... ', 1, 1, @Level) WITH NOWAIT

    INSERT INTO #BOMData
              ( BOMPositionId
              , BOMFolioNumber
              , BOMParentFolioNumber
              , StockCode
              , StockValuationMethod
              , BOMLevel
              , BOMHierarchy
              , BOMCurrency
              , BOMQuantity
              , BOMUnitCost
              , BOMUnitCostInBase
              , BOMTotalCost
              , BOMTotalCostInBase
              , BOMProductionTime

              , StockReOrderCurrency
              , StockReOrderPrice
              )
         SELECT BOMPositionId        = BD.BOMPositionId
              , BOMFolioNumber       = BD.StockFolioNumber
              , BOMParentFolioNumber = BOMParent.BOMFolioNumber
              , StockCode            = BD.FullStockCode COLLATE SQL_Latin1_General_CP1_CI_AS
              , StockValuationMethod = S.stValuationMethod COLLATE SQL_Latin1_General_CP1_CI_AS
              , BOMLevel             = @Level + 1
              , BOMHierarchy         = BOMParent.BOMHierarchy + BD.FullStockCode COLLATE SQL_Latin1_General_CP1_CI_AS + '~'
              , BOMCurrency          = BD.QuantityCurrency
              , BOMQuantity          = BD.QuantityUsed
              , BOMUnitCost          = BD.QuantityUnitCost
              , BOMUnitCostInBase    = BD.QuantityUnitCostInBase
              , BOMTotalCost         = ROUND(CASE
                                             WHEN S.stCalcPack = 1 THEN BD.QuantityTotalCost / S.stPurchaseUnits
                                             ELSE BD.QuantityTotalCost
                                             END, SS.NoOfDPCost)
              , BOMTotalCostInBase   = ROUND(CASE
                                             WHEN S.stCalcPack = 1 THEN BD.QuantityTotalCostInBase / S.stPurchaseUnits
                                             ELSE BD.QuantityTotalCostInBase
                                             END, SS.NoOfDPCost)
              , BOMProductionTime    = BD.QuantityTime

              , StockReOrderCurrency = S.stReorderCurrency
              , StockReOrderPrice    = S.stReorderPrice
        
         FROM #BOMData     BOMParent
         JOIN #BOMDetail   BD ON BOMParent.BOMFolioNumber = BD.ParentBOMFolioNumber
         JOIN !ActiveSchema!.STOCK S  ON BD.StockFolioNumber = S.stFolioNum
         CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
         WHERE BOMParent.BOMLevel =  @Level

    SELECT @NoOfRows = @@ROWCOUNT

    SET @Level = @Level + 1

  END

  -- Update ReOrderPrice in Base

  UPDATE BOM
     SET StockReOrderPriceInBase = common.efn_ExchequerCurrencyConvert( StockReOrderPrice
                                                                      , ConversionRate
                                                                      , StockReOrderCurrency
                                                                      , 0
                                                                      , 0
                                                                      , CC.TriRate
                                                                      , CC.TriInverted
                                                                      , CC.TriCurrencyCode
                                                                      , CC.IsFloating
                                                                      )
  FROM #BOMData BOM
  JOIN !ActiveSchema!.CURRENCY CC ON BOM.StockReOrderCurrency = CC.CurrencyCode
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
  CROSS APPLY ( VALUES ( (CASE
                          WHEN UseCompanyRate = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.CompanyRate
                          WHEN UseDailyRate   = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.DailyRate
                          ELSE 1
                          END
                         )
                       )
              ) Rate ( ConversionRate)

  -- Update SumOfChildrenInBase
  DECLARE @MaxBOMLevel INT

  SELECT @MaxBOMLevel = MAX(BOMLevel)
  FROM   #BOMData BOM

  WHILE @MaxBOMLevel >= 0
  BEGIN
    UPDATE #BOMData
       SET SumOfChildrenTotalCostInBase = #BOMData.BOMQuantity * BOMSumm.SumOfChildrenTotalCostInBase
    FROM (SELECT ParentHierarchy              = REPLACE(BOMHierarchy, StockCode + '~', '') 
               , SumOfChildrenTotalCostInBase = SUM(BOMTotalCostInBase)
          FROM #BOMData BOM
          WHERE BOM.BOMLevel = @MaxBOMLevel
          GROUP BY REPLACE(BOMHierarchy, StockCode + '~', '')) BOMSumm
    WHERE BOMSumm.ParentHierarchy = #BOMData.BOMHierarchy

    SET @MaxBOMLevel = @MaxBOMLevel - 1
  END

  -- Now Convert SumOfChildrenInBase to Currency

  UPDATE BOM
     SET SumOfChildrenTotalCost = common.efn_ExchequerCurrencyConvert( BOM.SumOfChildrenTotalCostInBase
                                                                     , ConversionRate
                                                                     , BOM.BOMCurrency
                                                                     , 0
                                                                     , 1
                                                                     , CC.TriRate
                                                                     , CC.TriInverted
                                                                     , CC.TriCurrencyCode
                                                                     , CC.IsFloating
                                                                     )
  FROM #BOMData BOM
  JOIN !ActiveSchema!.CURRENCY CC ON BOM.BOMCurrency = CC.CurrencyCode
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
  CROSS APPLY ( VALUES ( (CASE
                          WHEN UseCompanyRate = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.CompanyRate
                          WHEN UseDailyRate   = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.DailyRate
                          ELSE 1
                          END
                         )
                       )
              ) Rate ( ConversionRate)

  -- Now Convert SumOfChilrenInBase to ReOrderCurrency

  UPDATE BOM
     SET SumOfChildrenTotalCostInReOrderCurrency = common.efn_ExchequerCurrencyConvert( BOM.SumOfChildrenTotalCostInBase
                                                                                      , ConversionRate
                                                                                      , BOM.StockReOrderCurrency
                                                                                      , 0
                                                                                      , 1
                                                                                      , CC.TriRate
                                                                                      , CC.TriInverted
                                                                                      , CC.TriCurrencyCode
                                                                                      , CC.IsFloating
                                                                                      )
  FROM #BOMData BOM
  JOIN !ActiveSchema!.CURRENCY CC ON BOM.StockReOrderCurrency = CC.CurrencyCode
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS 
  CROSS APPLY ( VALUES ( (CASE
                          WHEN UseCompanyRate = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.CompanyRate
                          WHEN UseDailyRate   = 1 AND CC.CurrencyCode NOT IN (0, 1) THEN CC.DailyRate
                          ELSE 1
                          END
                         )
                       )
              ) Rate ( ConversionRate)

  -- Update Balance Difference
  UPDATE BOM
     SET BalanceDifference = BalDiff
  FROM   #BOMData BOM
  CROSS JOIN !ActiveSchema!.evw_SystemSettings SS
  CROSS APPLY ( VALUES ( (CASE
                          WHEN BOM.StockValuationMethod IN ('A', 'E') THEN ROUND(ABS(ROUND(SumOfChildrenTotalCostInReOrderCurrency, SS.NoOfDPCost) - ROUND(StockReOrderPrice, SS.NoOfDPCost)), SS.NoOfDPCost)
                          ELSE ROUND(ABS(ROUND(SumOfChildrenTotalCost, SS.NoOfDPCost) - ROUND(BOMTotalCost, SS.NoOfDPCost)), SS.NoOfDPCost)
                          END)
                       )
              ) Diff (BalDiff)

  IF @iv_Mode = @c_Debug
  BEGIN

    SELECT 'BOMDetail'
         , *
    FROM #BOMDetail
    --WHERE FullStockCode LIKE 'GJ %'
    ORDER BY FullStockCode

    SELECT 'BOMData'
         , *
    FROM #BOMData
    --WHERE BOMHierarchy LIKE '~GJ %'
    ORDER BY BOMHierarchy

  END

  IF @iv_Mode IN (@c_Report, @c_Debug)
  BEGIN

    -- Return Data
    SELECT BOM.*
    FROM   #BOMData BOM
    WHERE 1 = 1
    AND BalanceDifference > 0.01
    ORDER BY BOMHierarchy

    SELECT E.PositionId
         , E.FullStkCode
         , E.Exchqchkcode3Trans2
         , E.QtyCost
         , E.QtyUsedTrans
         , Cost = (E.QtyCost * E.QtyUsedTrans)
         , BOM.SumOfChildrenTotalCost
         , BOM.BalanceDifference

    FROM !ActiveSchema!.EXCHQCHK E
    JOIN #BOMData BOM ON BOM.BOMPositionId = E.PositionId
    WHERE BOM.BalanceDifference > 0.01

  END

  IF @iv_Mode = @c_Fix
  BEGIN

    -- UPDATE 1: Stock - either stCostPrice or stReorderPrice depending on Valuation Method

    UPDATE S
       SET stCostPrice    = CASE
                            WHEN BOM.StockValuationMethod NOT IN ('A','E') THEN BOM.SumOfChildrenTotalCost
                            ELSE stCostPrice
                            END
         , stReorderPrice = CASE
                            WHEN BOM.StockValuationMethod IN ('A','E') THEN BOM.SumOfChildrenTotalCostInReOrderCurrency
                            ELSE stReorderPrice
                            END
    FROM !ActiveSchema!.STOCK S
    JOIN #BOMData BOM ON S.stFolioNum = BOM.BOMFolioNumber
    WHERE BOM.BalanceDifference > 0.01

    -- Update 2: Qty Cost on BOM parent records

    UPDATE E
    SET    E.QtyCost = SumOfChildrenTotalCost
    FROM !ActiveSchema!.EXCHQCHK E
    JOIN #BOMData BOM ON BOM.BOMPositionId = E.PositionId
    WHERE BOM.BalanceDifference > 0.01

  END

  IF OBJECT_ID('tempdb..#BOMDetail') IS NOT NULL
  DROP TABLE #BOMDetail

  IF OBJECT_ID('tempdb..#BOMData') IS NOT NULL
  DROP TABLE #BOMData

END

GO