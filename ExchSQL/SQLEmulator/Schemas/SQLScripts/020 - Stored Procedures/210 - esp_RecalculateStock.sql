
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_RecalculateStock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].[esp_RecalculateStock]
GO

--
-- Recalculate Stock
--
-- To reset an Individual Stock item pass in the Stock Code otherwise resets all Stock that require resetting.
--
-- Usage: EXEC !ActiveSchema!.esp_RecalculateStock 0
--    or: EXEC !ActiveSchema!.esp_RecalculateStock 0, '11955'
--    or: EXEC !ActiveSchema!.esp_RecalculateStock 0, '11955', 0

CREATE PROCEDURE [!ActiveSchema!].[esp_RecalculateStock] ( @iv_Mode      INT         = 0
                                                 , @iv_StockCode VARCHAR(50) = NULL
                                                 , @iv_HasSPOP   BIT         = 1
                                                 ) WITH RECOMPILE
AS
BEGIN

-- For Debug purposes
--DECLARE @iv_Mode      INT = 1
--      , @iv_StockCode VARCHAR(50) --= 'CAB-SIGNAL-6CORE'
--      , @iv_HasSPOP   BIT = 1
 
  -- Modes: 0 - Fix Data
  --        1 - Report Data
  --        2 - Debug
  
  SET NOCOUNT ON;

  DECLARE @c_Fix            INT = 0
        , @c_Report         INT = 1
        , @c_Debug          INT = 2
  
  DECLARE @c_StkOutSet VARCHAR(max) = 'SIN,SCR,SRF,SRI,SJI,SJC,SDN'
        , @c_StkExcSet VARCHAR(max) = 'SQU,PQU,WOR,WIN,SRN,PRN'

  DECLARE @StockCode        VARBINARY(20)

  IF @iv_StockCode IS NOT NULL
    SET @StockCode = CONVERT(VARBINARY(20), CONVERT(CHAR(16), @iv_StockCode))

  DECLARE @ss_AuditYear           INT
        , @ss_AuditExchequerYear  INT
        , @ss_NoOfPeriodsInYear   INT
        , @ss_NoOfDPQuantity      INT
        , @ss_NoOfDPNet           INT
        , @ss_NoOfDPCost          INT
        , @ss_UseCompanyRate      BIT
        , @ss_UseMultiLocations   BIT

 -- Get System Settings

  SELECT @ss_AuditYear          = SS.AuditYear
       , @ss_AuditExchequerYear = SS.AuditExchequerYear
       , @ss_NoOfPeriodsInYear  = SS.NoOfPeriodsInYear
       , @ss_NoOfDPQuantity     = SS.NoOfDPQuantity
       , @ss_NoOfDPNet          = SS.NoOfDPNet
       , @ss_NoOfDPCost         = SS.NoOfDPCost
       , @ss_UseCompanyRate     = SS.UseCompanyRate
       , @ss_UseMultiLocations  = SS.UseMultiLocations

  FROM   !ActiveSchema!.evw_SystemSettings SS

  -- For speed purposes for large datasets create a temp. table of required transactions

  IF OBJECT_ID('tempdb..#TLData') IS NOT NULL
    DROP TABLE #TLData

  SELECT PositionId                   = CONVERT(INT, DTL.PositionId) -- Need to convert this otherwise IDENTITY column remains on it.
       , OurReference                 = DTL.tlOurRef
       , LineFolioNumber              = DTL.tlFolioNum
       , ABSLineNo                    = DTL.tlABSLineNo
       , DisplayLineNo                = DTL.tlLineNo
       , TransactionTypeId            = DTL.tlDocType
       , TT.TransactionTypeCode
       , TT.StockMovementSign
       , CurrencyId                   = tlcurrency
       , StockCode                    = CASE
                                        WHEN DTL.tlStockCodeComputed   <> 0x0120202020202020202020000000
                                         AND DTL.tlStockCodeComputed   <> 0x2020202020202020202000000000
                                         AND DTL.tlStockCodeComputed   <> 0x0000000000000000000000000000
                                         AND DTL.tlDocType NOT IN (30, 31, 41, 1, 16)
                                        THEN LTRIM(RTRIM(CONVERT(VARCHAR(50), SUBSTRING(DTL.tlStockCodeComputed, 1 , 16))))
                                        ELSE ''
                                        END
       , StockFolioNumber             = CONVERT(INT, NULL)
       , StockType                    = CONVERT(VARCHAR(1), NULL)
       , LocationCode                 = DTL.tlLocation
       , CompanyRate                  = DTL.tlCompanyRate
       , DailyRate                    = DTL.tlDailyRate
       , tlPrxPack
       , tlQtyPack
       , QuantityMultiplier           = DTL.tlQtyMul
       , tlShowCase
       , LineQuantity                 = DTL.tlQty
       , LineQuantityPicked           = DTL.tlQtyPicked
       , LineQuantityDelivered        = DTL.tlQtyDel
       , LineQuantityWrittenOff       = DTL.tlQtyWOFF
       , LineQuantityPickedWOff       = DTL.tlQtyPickedWO
       , LineQuantityOutstanding      = CASE
                                        WHEN TT.TransactionTypeCode <> 'WOR' THEN (DTL.tlQty - (DTL.tlQtyDel + DTL.tlQtyWOFF))
                                        ELSE ((DTL.tlQty + DTL.tlQtyPickedWO) - DTL.tlQtyDel)
                                        END
       , LineQuantityUsed             = CASE
                                        WHEN TT.TransactionTypeCode = 'ADJ' AND (DTL.tlBOMKitLink = 0 OR DTL.tlLineNo = -1) 
                                        THEN DTL.tlStockDeductQty * -1
                                        ELSE 0
                                        END
       , LineNetValue                 = DTL.tlNetValue
       , Discount                     = DTL.tlDiscount
       , Discount2                    = DTL.tlDiscount2
       , Discount3                    = DTL.tlDiscount3
       , StockMovementQuantity        = DTL.tlStockDeductQty
       , tlPriceMultiplier
       , tlUsePack
       , tlYear
       , tlPeriod
       , TransactionLineDate          = DTL.tlLineDate
       , tlStockCodeComputed
       , tlDiscFlag
       , tlDiscount2Chr
       , tlDiscount3Chr
       , tlPaymentCode
       , UseOriginalRates             = DTL.tlUseOriginalRates
       , TriRates                     = DTL.tlTriRates
       , TriEuro                      = DTL.tlTriEuro
       , TriInvert                    = DTL.tlTriInvert
       , TriFloat                     = DTL.tlTriFloat
       , TransactionPeriodKey         = ((DTL.tlYear + 1900) * 1000) + DTL.tlPeriod
       , TraderCode                   = CONVERT(VARCHAR(50), NULL)
       , ConversionRate               = CONVERT(FLOAT, NULL)
       , NoOfDP                       = CONVERT(FLOAT, NULL)
       , NoOfDPQuantity               = CONVERT(FLOAT, NULL)
       , PricePerUnit                 = CONVERT(FLOAT, NULL)
       , DiscountPerUnit              = CONVERT(FLOAT, 0)
       , LineCalculatedNetValue       = CONVERT(FLOAT, NULL)
       , LineCalculatedNetValueInBase = CONVERT(FLOAT, NULL)
       , LineCost                     = CONVERT(FLOAT, 0) --DTL.tlCost
       , LineCostInBase               = CONVERT(FLOAT, NULL)
       , FIFOQty                      = CONVERT(FLOAT, NULL)
       , FIFOMode                     = CONVERT(INT, NULL)
       , RunNo                        = CONVERT(INT, 0)
       , IsPosted                     = CONVERT(BIT, NULL)
       , RowNo                        = ROW_NUMBER() OVER( PARTITION BY DTL.tlStockCodeTrans1 ORDER BY DTL.PositionId)
  INTO #TLData
  FROM !ActiveSchema!.DETAILS DTL
  LEFT JOIN common.evw_TransactionType  TT ON TT.TransactionTypeId = DTL.tlDocType

  WHERE 1 = 1
  AND   DTL.tlYear                 >   @ss_AuditExchequerYear

  AND ( DTL.tlStockCodeComputed = @StockCode OR @iv_StockCode IS NULL )

  ORDER BY tlStockCodeComputed, tlLineDate , tlFolioNum , PositionId

  -- Remove Blank Rows
  DELETE
  FROM   #TLData
  WHERE  StockCode = ''

  -- Insert outstanding balance row - for purged systems

  IF @ss_AuditYear > 0
  BEGIN
      INSERT INTO #TLData
      SELECT PositionId                   = -1
           , OurReference                 = 'O/Bal'
           , LineFolioNumber              = 0
           , ABSLineNo                    = 0
           , DisplayLineNo                = 0
           , TransactionTypeId            = 35
           , TransactionTypeCode          = 'ADJ'
           , StockMovementSign            = 1
           , CurrencyId                   = S.stCostPriceCurrency
           , StockCode                    = S.stCode
           , StockFolioNumber             = S.stFolioNum
           , StockType                    = S.stType
           , LocationCode                 = S.stLocation
           , CompanyRate                  = C.CompanyRate
           , DailyRate                    = C.DailyRate
           , tlPrxPack                    = 0
           , tlQtyPack                    = 1
           , QuantityMultiplier           = 1
           , tlShowcase                   = 1
           , LineQuantity                 = CB.QuantityInStock
           , LineQuantityPicked           = 0
           , LineQuantityDelivered        = 0
           , LineQuantityWrittenOff       = 0
           , LineQuantityPickedWOff       = 0
           , LineQuantityOutstanding      = 0
           , LineQuantityUsed             = 0
           , LineNetValue                 = 0
           , Discount                     = 0
           , Discount2                    = 0
           , Discount3                    = 0
           , StockMovementQuantity        = CB.QuantityInStock
           , tlPriceMultiplier            = 1
           , tlUsePack                    = 0
           , tlYear                       = @ss_AuditExchequerYear
           , tlPeriod                     = @ss_NoOfPeriodsInYear
           , TransactionLineDate          = CONVERT(VARCHAR, @ss_AuditYear)
                                          + CONVERT(VARCHAR, @ss_NoOfPeriodsInYear)
                                          + '01'
           , tlStockCodeComputed          = 0x00
           , tlDiscFlag                   = ''
           , tlDiscount2Chr               = ''
           , tlDiscount3Chr               = ''
           , tlPaymentCode                = ''
           , UseOriginalRates             = 0
           , TriRates                     = ISNULL(C.TriRate, 0)
           , TriEuro                      = ISNULL(C.TricurrencyCode, 0)
           , TriInvert                    = C.TriInverted
           , TriFloat                     = C.IsFloating
           , TransactionPeriodKey         = (@ss_AuditYear * 1000) + @ss_NoOfPeriodsInYear
           , TraderCode                   = ''
           , ConversionRate               = CONVERT(FLOAT, NULL)
           , NoOfDP                       = CONVERT(FLOAT, NULL)
           , NoOfDPQuantity               = CONVERT(FLOAT, NULL)
           , PricePerUnit                 = CONVERT(FLOAT, NULL)
           , DiscountPerUnit              = CONVERT(FLOAT, 0)
           , LineCalculatedNetValue       = CONVERT(FLOAT, NULL)
           , LineCalculatedNetValueInBase = CONVERT(FLOAT, NULL)
           , LineCost                     = S.stCostPrice
           , LineCostInBase               = CONVERT(FLOAT, NULL)

           , FIFOQty                      = CB.QuantityInStock
           , FIFOMode                     = CASE
                                            WHEN S.stValuationMethod = 'F' THEN 2
                                            ELSE 3
                                            END
           , RunNo                        = 0
           , IsPosted                     = CONVERT(BIT, 1)
           , RowNo                        = 0

       FROM !ActiveSchema!.STOCK S
       JOIN !ActiveSchema!.CURRENCY C ON S.stCostPriceCurrency = C.CurrencyCode
       CROSS APPLY (SELECT QuantityInStock
                    FROM   !ActiveSchema!.evw_StockHistory SH
                    WHERE  HistoryClassificationId = 159 + ASCII(S.stType)
                    AND    HistoryYear             = @ss_AuditYear
                    AND    HistoryPeriod           = 255
                    AND    LocationCode            IS NULL
                    AND    StockFolioNumber        = S.stFolioNum
                   ) CB
       WHERE S.stQtyInStock <> 0
       AND   S.stValuationMethod IN ('F','L')
       AND ( @iv_StockCode IS NULL
       OR    S.stCode = @iv_StockCode
           )
    END



  IF @iv_Mode = @c_Debug
  BEGIN

    SELECT 'Detail Data'
         , *
    FROM #TLData
   
  END

  -- Set Rates and Dec. Places
  
  UPDATE DTL 
     SET ConversionRate = CASE
                          WHEN CurrencyCode NOT IN (0, 1) AND DTL.CompanyRate = 0 AND @ss_UseCompanyRate = 1 THEN C.CompanyRate
                          WHEN CurrencyCode NOT IN (0, 1) AND DTL.DailyRate = 0 AND @ss_UseCompanyRate = 0   THEN C.DailyRate
                          WHEN @ss_UseCompanyRate = 1 THEN CASE 
                                                           WHEN DTL.CompanyRate = 0 THEN 1
                                                           ELSE DTL.CompanyRate
                                                           END
                          WHEN @ss_UseCompanyRate = 0 THEN CASE 
                                                           WHEN DTL.DailyRate = 0 THEN 1
                                                           ELSE DTL.DailyRate
                                                           END
                          ELSE 1
                          END
       , NoOfDP         = CASE
                          WHEN TT.ParentTransactionTypeId = 100 THEN @ss_NoOfDPNet
                          ELSE @ss_NoOfDPcost
                          END
       , NoOfDPQuantity = CASE
                          WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.QuantityMultiplier <> 0 AND DTL.tlShowCase = 1 THEN 12
                          ELSE @ss_NoOfDPQuantity
                          END
  FROM #TLData DTL
  LEFT JOIN !ActiveSchema!.CURRENCY              C ON C.CurrencyCode       = DTL.CurrencyId
  LEFT JOIN common.evw_TransactionType  TT ON TT.TransactionTypeId = DTL.TransactionTypeId

  -- Update to Real48 Numbers
  
  UPDATE DTL
     SET LineQuantity           = CASE
                                  WHEN DTL.LineQuantity - FLOOR(DTL.LineQuantity) = 0 THEN DTL.LineQuantity
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantity)
                                  END
       , LineQuantityPicked     = CASE
                                  WHEN DTL.LineQuantityPicked - FLOOR(DTL.LineQuantityPicked) = 0 THEN DTL.LineQuantityPicked
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityPicked)
                                  END
       , LineQuantityDelivered  = CASE
                                  WHEN DTL.LineQuantityDelivered - FLOOR(DTL.LineQuantityDelivered) = 0 THEN DTL.LineQuantityDelivered
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityDelivered)
                                  END
       , LineQuantityWrittenOff = CASE
                                  WHEN DTL.LineQuantityWrittenOff - FLOOR(DTL.LineQuantityWrittenOff) = 0 THEN DTL.LineQuantityWrittenOff
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityWrittenOff)
                                  END
       , LineQuantityPickedWOff = CASE
                                  WHEN DTL.LineQuantityPickedWOff - FLOOR(DTL.LineQuantityPickedWOff) = 0 THEN DTL.LineQuantityPickedWOff
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityPickedWOff)
                                  END
       , LineQuantityOutstanding= CASE
                                  WHEN DTL.LineQuantityOutstanding - FLOOR(DTL.LineQuantityOutstanding) = 0 THEN DTL.LineQuantityOutstanding
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityOutstanding)
                                  END
       , LineQuantityUsed       = CASE
                                  WHEN DTL.LineQuantityUsed - FLOOR(DTL.LineQuantityUsed) = 0 THEN DTL.LineQuantityUsed
                                  ELSE common.efn_ConvertToReal48(DTL.LineQuantityUsed)
                                  END
       , QuantityMultiplier     = CASE
                                  WHEN DTL.QuantityMultiplier - FLOOR(DTL.QuantityMultiplier) = 0 THEN DTL.QuantityMultiplier
                                  ELSE common.efn_ConvertToReal48(DTL.QuantityMultiplier)
                                  END
       , LineNetValue           = CASE
                                  WHEN DTL.LineNetValue - FLOOR(DTL.LineNetValue) = 0 THEN DTL.LineNetValue
                                  ELSE common.efn_ConvertToReal48(DTL.LineNetValue)
                                  END
       , LineCost               = CASE
                                  WHEN DTL.LineCost - FLOOR(DTL.LineCost) = 0 THEN DTL.LineCost
                                  ELSE common.efn_ConvertToReal48(DTL.LineCost)
                                  END
       , Discount               = CASE
                                  WHEN DTL.Discount - FLOOR(DTL.Discount) = 0 THEN DTL.Discount
                                  ELSE common.efn_ConvertToReal48(DTL.Discount)
                                  END
       , Discount2              = CASE
                                  WHEN DTL.Discount2 - FLOOR(DTL.Discount2) = 0 THEN DTL.Discount2
                                  ELSE common.efn_ConvertToReal48(DTL.Discount2)
                                  END
       , Discount3              = CASE
                                  WHEN DTL.Discount3 - FLOOR(DTL.Discount3) = 0 THEN DTL.Discount3
                                  ELSE common.efn_ConvertToReal48(DTL.Discount3)
                                  END
       , ConversionRate         = CASE
                                  WHEN DTL.ConversionRate - FLOOR(DTL.ConversionRate) = 0 THEN DTL.ConversionRate
                                  ELSE common.efn_ConvertToReal48(DTL.ConversionRate)
                                  END
       , StockMovementQuantity  = CASE
                                  WHEN DTL.StockMovementQuantity - FLOOR(DTL.StockMovementQuantity) = 0 THEN DTL.StockMovementQuantity
                                  ELSE common.efn_ConvertToReal48(DTL.StockMovementQuantity)
                                  END
  FROM #TLData DTL

  -- Update LineNetValue, LineQuantity, Line Quantity Picked
  
  UPDATE DTL
     SET LineNetValue = ( CASE
                          WHEN DTL.tlPriceMultiplier <> 0 THEN DTL.LineNetValue * DTL.tlPriceMultiplier
                          ELSE DTL.LineNetValue
                          END
                        )
       , LineQuantity = ( CASE
                          WHEN DTL.tlUsePack = 1 THEN DTL.LineQuantity * DTL.QuantityMultiplier
                          ELSE DTL.LineQuantity
                          END
                        )
       , LineQuantityPicked = ( CASE
                                WHEN DTL.tlUsePack = 1 THEN DTL.LineQuantityPicked * DTL.QuantityMultiplier
                                ELSE DTL.LineQuantityPicked
                                END
                              )
  FROM #TLData DTL

  -- RoundUp
  
  UPDATE DTL
     SET PricePerUnit = CASE
                        WHEN D.PricePerUnit - FLOOR(D.PricePerUnit) <> 0 THEN  (SELECT * FROM common.efn_NewRoundUp(D.PricePerUnit, DTL.NoOfDP))
                        ELSE D.PricePerUnit
                        END
       , LineQuantity = CASE
                        WHEN D.LineQuantity - FLOOR(D.LineQuantity) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(D.LineQuantity, DTL.NoOfDPQuantity) )
                        ELSE D.LineQuantity
                        END
       , LineQuantityPicked      = CASE
                                   WHEN DTL.LineQuantityPicked - FLOOR(DTL.LineQuantityPicked) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityPicked, DTL.NoOfDPQuantity))
                                   ELSE DTL.LineQuantityPicked
                                   END
       , LineQuantityDelivered   = CASE
                                   WHEN DTL.LineQuantityDelivered - FLOOR(DTL.LineQuantityDelivered) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityDelivered, DTL.NoOfDPQuantity) )
                                   ELSE DTL.LineQuantityDelivered
                                   END
       , LineQuantityPickedWOff  = CASE
                                   WHEN DTL.LineQuantityPickedWOff - FLOOR(DTL.LineQuantityPickedWOff) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityPickedWOff, DTL.NoOfDPQuantity) )
                                   ELSE DTL.LineQuantityPickedWOff
                                   END
       , LineQuantityWrittenOff  = CASE
                                   WHEN DTL.LineQuantityWrittenOff - FLOOR(DTL.LineQuantityWrittenOff) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityWrittenOff, DTL.NoOfDPQuantity) )
                                   ELSE DTL.LineQuantityWrittenOff
                                   END
       , LineQuantityOutstanding = CASE
                                   WHEN DTL.LineQuantityOutstanding - FLOOR(DTL.LineQuantityOutstanding) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityOutstanding, DTL.NoOfDPQuantity) )
                                   ELSE DTL.LineQuantityOutstanding
                                   END
       , LineQuantityUsed        = CASE
                                   WHEN DTL.LineQuantityUsed - FLOOR(DTL.LineQuantityUsed) <> 0 THEN (SELECT * FROM common.efn_NewRoundUp(DTL.LineQuantityUsed, DTL.NoOfDPQuantity) )
                                   ELSE DTL.LineQuantityUsed
                                   END
  FROM #TLData DTL
  CROSS APPLY ( VALUES ( ( CASE
                           WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.QuantityMultiplier <> 0 
                           THEN CASE
                                WHEN DTL.tlShowCase = 1 THEN DTL.LineNetValue
                                ELSE DTL.LineNetValue * common.efn_SafeDivide(DTL.QuantityMultiplier, DTL.tlQtyPack)
                                END
                           ELSE DTL.LineNetValue
                           END
                         )
                       , ( CASE
                           WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.QuantityMultiplier <> 0 AND DTL.tlShowCase = 1
                           THEN common.efn_SafeDivide(DTL.LineQuantity, DTL.tlQtyPack)
                           ELSE DTL.LineQuantity
                           END
                         )
                       )
               ) D ( PricePerUnit
                   , LineQuantity
                   )

  -- DiscountPerUnit

  UPDATE DTL
     SET DiscountPerUnit =  common.efn_CalculateDiscount( DTL.LineNetValue
                                                        , DTL.Discount
                                                        , DTL.tlDiscFlag
                                                        , DTL.Discount2
                                                        , DTL.tlDiscount2Chr
                                                        , DTL.Discount3
                                                        , DTL.tlDiscount3chr
                                                        )
  FROM #TLData DTL
  WHERE DTL.Discount  <> 0
     OR DTL.Discount2 <> 0
     OR DTL.Discount3 <> 0

  -- Line Calculated Net Value

  UPDATE DTL
     SET LineCalculatedNetValue = ( ( ( DTL.PricePerUnit - DTL.DiscountPerUnit )
                                    * DTL.LineQuantity
                                    )
                                  ) * CASE
                                      WHEN DTL.tlPaymentCode = 'N' THEN -1
                                      ELSE 1
                                      END
       , LineCost = DTL.PricePerUnit - DTL.DiscountPerUnit
  FROM #TLData DTL

  -- Set Base values
  
  UPDATE DTL
     SET LineCalculatedNetValueInBase = ( CASE
                                          WHEN DTL.ConversionRate = 1 THEN DTL.LineCalculatedNetValue
                                          ELSE common.efn_ExchequerCurrencyConvert( DTL.LineCalculatedNetValue
                                                                                  , DTL.ConversionRate
                                                                                  , DTL.CurrencyId
                                                                                  , DTL.UseOriginalRates
                                                                                  , 0
                                                                                  , C.TriRate
                                                                                  , C.TriInverted
                                                                                  , C.TriCurrencyCode
                                                                                  , C.IsFloating)
                                          END
                                        )
       , LineCostInBase               = ( CASE
                                          WHEN DTL.ConversionRate = 1 THEN DTL.LineCost
                                          ELSE common.efn_ExchequerCurrencyConvert( DTL.Linecost
                                                                                  , DTL.ConversionRate
                                                                                  , DTL.CurrencyId
                                                                                  , DTL.UseOriginalRates
                                                                                  , 0
                                                                                  , C.TriRate
                                                                                  , C.TriInverted
                                                                                  , C.TriCurrencyCode
                                                                                  , C.IsFloating)
                                          END
                                        )
  FROM #TLData DTL
  LEFT JOIN !ActiveSchema!.CURRENCY              C ON C.CurrencyCode       = DTL.CurrencyId
 
  -- More RoundUp

  UPDATE DTL
     SET LineCalculatedNetValue       = (SELECT * FROM common.efn_NewRoundUp(LineCalculatedNetValue, 2) )
       , LineCalculatedNetValueInBase = (SELECT * FROM common.efn_NewRoundUp(LineCalculatedNetValueInBase, 2) )
       , LineCostInBase               = (SELECT * FROM common.efn_NewRoundUp(LineCostInBase, 2) )

    FROM #TLData DTL

  -- Set Header related data
  UPDATE DTL
     SET IsPosted     = CONVERT(BIT, CASE
                                     WHEN INV.thRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                     ELSE 1
                                     END)
       , RunNo        = INV.thRunNo
       , OurReference = INV.thOurRef
       , TraderCode   = INV.thAcCodeComputed

  FROM #TLData DTL
  JOIN !ActiveSchema!.DOCUMENT INV ON DTL.LineFolioNumber = INV.thFolioNum
  
  
  -- Set Stock related data 
  UPDATE DTL
     SET FIFOMode         = FM.FIFOMode
       , FIFOQty          = FQ.FIFOQty
       , StockFolioNumber = s.stFolioNum
       , StockType        = s.stType
  FROM #TLData DTL
  JOIN !ActiveSchema!.STOCK S ON DTL.StockCode = S.stCode
  CROSS APPLY ( VALUES ( (CASE S.stValuationMethod
                          WHEN 'C' THEN 1
                          WHEN 'F' THEN 2
                          WHEN 'L' THEN 3
                          WHEN 'A' THEN 4
                          WHEN 'E' THEN 4
                          WHEN 'S' THEN 6
                          WHEN 'R' THEN CASE 
                                        WHEN @iv_HasSPOP = 1 THEN 5
                                        ELSE 1
                                        END
                          END
                         )
                       )
              ) FM (FIFOMode)
  CROSS APPLY ( VALUES ( (CASE
                          WHEN FM.FIFOMode IN (2, 3)
                           AND DTL.TransactionTypeCode NOT IN ('POR','SOR','SQU','PQU','WOR','WIN','SRN','PRN') THEN DTL.StockMovementQuantity
                          ELSE 0
                          END * DTL.StockMovementSign)
                       )
              ) FQ ( FIFOQty)

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'Before Summarisation'
         , *
    FROM #TLData
  END

  -----------------------------------------------------------------------------------
  -- Summarize Data
  -----------------------------------------------------------------------------------
  IF OBJECT_ID('tempdb..#TLDataSummary') IS NOT NULL
    DROP TABLE #TLDataSummary

  SELECT TL.StockCode
       , TL.LocationCode
       , NewQtyInStock   = SUM(CASE
                               WHEN TL.TransactionTypeCode NOT IN ('POR','SOR','SQU','PQU','WOR','WIN','SRN','PRN') THEN TL.StockMovementQuantity
                               ELSE 0
                               END * TL.StockMovementSign)
       , NewQtyAllocated = SUM(CASE
                               WHEN TransactionTypeCode IN ('SOR') THEN TL.StockMovementQuantity
                               ELSE 0
                               END * TL.StockMovementSign)
       , NewQtyOnOrder   = SUM(CASE
                               WHEN TransactionTypeCode IN ('POR') THEN TL.StockMovementQuantity
                               WHEN TransactionTypeCode = 'WOR' AND TL.ABSLineNo = 1 THEN TL.LineQuantityOutstanding
                               ELSE 0
                               END * TL.StockMovementSign)
       , NewQtyPicked    = SUM(CASE
                               WHEN TransactionTypeCode IN ('SOR') THEN TL.LineQuantityPicked
                               ELSE 0
                               END * TL.StockMovementSign)
       , NewQtyAllocatedWOR = SUM(CASE
                                  WHEN TransactionTypeCode = 'WOR' AND TL.ABSLineNo <> 1 THEN TL.LineQuantityOutstanding
                                  ELSE 0
                                  END * TL.StockMovementSign)
       , NewQtyIssuedWOR    = SUM(CASE
                                  WHEN TransactionTypeCode = 'WOR' THEN TL.LineQuantityDelivered - TL.LineQuantityWrittenOff
                                  ELSE 0
                                  END * TL.StockMovementSign)
       , NewQtyPickedWOR    = SUM(CASE
                                  WHEN TransactionTypeCode = 'WOR' THEN TL.LineQuantityPicked
                                  ELSE 0
                                  END * TL.StockMovementSign)
       , NewQtySalesReturn  = SUM(CASE
                                  WHEN TransactionTypeCode = 'SRN' THEN TL.LineQuantityOutstanding
                                  ELSE 0
                                  END * TL.StockMovementSign)
       , NewQtyPurchaseReturn = SUM(CASE
                                    WHEN TransactionTypeCode = 'PRN' THEN TL.StockMovementQuantity
                                    ELSE 0
                                    END * TL.StockMovementSign)
  INTO #TLDataSummary
  FROM #TLData TL
  GROUP BY StockCode
         , LocationCode

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'Summary Table'
         , *
    FROM #TLDataSummary
  END

  -----------------------------------------------------------------------------------
  -- STOCK
  -----------------------------------------------------------------------------------
  CREATE INDEX idx_TLData_StockCode ON #TLData (StockCode, LocationCode, TransactionTypeCode)

  IF @iv_Mode IN (@c_Report, @c_Debug)
  BEGIN

    SELECT InfoMessage          = 'STOCK Errors'
         , StockCode            = S.stCode
         , StockType            = S.stType
         , QtyInStock           = S.stQtyInStock
         , NewQtyInStock        = ISNULL(NewData.NewQtyInStock, 0)
         , QtyAllocated         = S.stQtyAllocated
         , NewQtyAllocated      = ISNULL(NewData.NewQtyAllocated, 0)
         , QuantityOnOrder      = S.stQtyOnOrder
         , NewQtyOnOrder        = ISNULL(NewData.NewQtyOnOrder, 0)
         , QtyPicked            = S.stQtyPicked
         , NewQtyPicked         = ISNULL(NewData.NewQtyPicked, 0)
         , QtyAllocatedWOR      = S.stQtyAllocWOR
         , NewQtyAllocatedWOR   = ISNULL(NewData.NewQtyAllocatedWOR, 0)
         , QtyIssuedWOR         = S.stQtyIssuedWOR
         , NewQtyIssuedWOR      = ISNULL(NewData.NewQtyIssuedWOR, 0)
         , QtyPickedWOR         = S.stQtyPickedWOR
         , NewQtyPickedWOR      = ISNULL(NewData.NewQtyPickedWOR, 0)
         , QtySalesReturn       = S.stSalesReturnQty
         , NewQtySalesReturn    = ISNULL(NewData.NewQtySalesReturn, 0)
         , QtyPurchaseReturn    = S.stPurchaseReturnQty
         , NewQtyPurchaseReturn = ISNULL(NewData.NewQtyPurchaseReturn, 0)
         , StockNoteCount       = S.stNLineCount
         , NewStockNoteCount    = ISNULL(NC.MaxNoteLine, 0) + 1
     
    FROM !ActiveSchema!.STOCK S 
    OUTER APPLY ( SELECT NewQtyInStock        = SUM(TL.NewQtyInStock)
                       , NewQtyAllocated      = SUM(TL.NewQtyAllocated)
                       , NewQtyOnOrder        = SUM(TL.NewQtyOnOrder)
                       , NewQtyPicked         = SUM(TL.NewQtyPicked)
                       , NewQtyAllocatedWOR   = SUM(TL.NewQtyAllocatedWOR)
                       , NewQtyIssuedWOR      = SUM(TL.NewQtyIssuedWOR)
                       , NewQtyPickedWOR      = SUM(TL.NewQtyPickedWOR)
                       , NewQtySalesReturn    = SUM(TL.NewQtySalesReturn)
                       , NewQtyPurchaseReturn = SUM(TL.NewQtyPurchaseReturn)
                  FROM #TLDataSummary TL
                  WHERE TL.StockCode = S.stCode
                  GROUP BY TL.StockCode
                ) NewData
    OUTER APPLY ( SELECT MaxNoteLine = MAX(LineNumber)
                  FROm !ActiveSchema!.evw_StockNotes SN
                  WHERE S.stFolioNum = SN.StockFolioNumber
                ) NC
    WHERE  S.stType              IN ('M','P','X')
    AND   (S.stCode               = @iv_StockCode Or @iv_StockCode IS NULL)
    AND   (ABS(S.stQtyInStock        - ISNULL(NewData.NewQtyInStock, 0))        >= 0.01
       OR  ABS(S.stQtyAllocated      - ISNULL(NewData.NewQtyAllocated, 0))      >= 0.01
       OR  ABS(S.stQtyOnOrder        - ISNULL(NewData.NewQtyOnOrder, 0))        >= 0.01
       OR  ABS(S.stQtyPicked         - ISNULL(NewData.NewQtyPicked, 0))         >= 0.01
       OR  ABS(S.stQtyAllocWOR       - ISNULL(NewData.NewQtyAllocatedWOR, 0))   >= 0.01
       OR  ABS(S.stQtyIssuedWOR      - ISNULL(NewData.NewQtyIssuedWOR, 0))      >= 0.01
       OR  ABS(S.stQtyPickedWOR      - ISNULL(NewData.NewQtyPickedWOR, 0))      >= 0.01
       OR  ABS(S.stSalesReturnQty    - ISNULL(NewData.NewQtySalesReturn, 0))    >= 0.01
       OR  ABS(S.stPurchaseReturnQty - ISNULL(NewData.NewQtyPurchaseReturn, 0)) >= 0.01
       OR  S.stNLineCount <> ISNULL(NC.MaxNoteLine, 0) + 1
          )
  END
  
  IF @iv_Mode = @c_Fix
  BEGIN
  
    -- Stock will have a pure update, no new or deleted items.
    
    UPDATE S
       SET stQtyInStock         = ISNULL(NewData.NewQtyInStock, 0)
         , stQtyAllocated       = ISNULL(NewData.NewQtyAllocated, 0)
         , stQtyOnOrder         = ISNULL(NewData.NewQtyOnOrder, 0)
         , stQtyPicked          = ISNULL(NewData.NewQtyPicked, 0)
         , stQtyAllocWOR        = ISNULL(NewData.NewQtyAllocatedWOR, 0)
         , stQtyIssuedWOR       = ISNULL(NewData.NewQtyIssuedWOR, 0)
         , stQtyPickedWOR       = ISNULL(NewData.NewQtyPickedWOR, 0)
         , stSalesReturnQty     = ISNULL(NewData.NewQtySalesReturn, 0)
         , stPurchaseReturnQty  = ISNULL(NewData.NewQtyPurchaseReturn, 0)
         , stNLineCount         = ISNULL(NC.MaxNoteLine, 0) + 1
     
    FROM !ActiveSchema!.STOCK S 
    OUTER APPLY ( SELECT NewQtyInStock        = SUM(TL.NewQtyInStock)
                       , NewQtyAllocated      = SUM(TL.NewQtyAllocated)
                       , NewQtyOnOrder        = SUM(TL.NewQtyOnOrder)
                       , NewQtyPicked         = SUM(TL.NewQtyPicked)
                       , NewQtyAllocatedWOR   = SUM(TL.NewQtyAllocatedWOR)
                       , NewQtyIssuedWOR      = SUM(TL.NewQtyIssuedWOR)
                       , NewQtyPickedWOR      = SUM(TL.NewQtyPickedWOR)
                       , NewQtySalesReturn    = SUM(TL.NewQtySalesReturn)
                       , NewQtyPurchaseReturn = SUM(TL.NewQtyPurchaseReturn)
                  FROM #TLDataSummary TL
                  WHERE TL.StockCode = S.stCode
                  GROUP BY TL.StockCode
                ) NewData
    OUTER APPLY ( SELECT MaxNoteLine = MAX(LineNumber)
                  FROm !ActiveSchema!.evw_StockNotes SN
                  WHERE S.stFolioNum = SN.StockFolioNumber
                ) NC
    WHERE  S.stType              IN ('M','P','X')
    AND   (S.stCode               = @iv_StockCode Or @iv_StockCode IS NULL)
    AND   (ABS(S.stQtyInStock        - ISNULL(NewData.NewQtyInStock, 0))        >= 0.01
       OR  ABS(S.stQtyAllocated      - ISNULL(NewData.NewQtyAllocated, 0))      >= 0.01
       OR  ABS(S.stQtyOnOrder        - ISNULL(NewData.NewQtyOnOrder, 0))        >= 0.01
       OR  ABS(S.stQtyPicked         - ISNULL(NewData.NewQtyPicked, 0))         >= 0.01
       OR  ABS(S.stQtyAllocWOR       - ISNULL(NewData.NewQtyAllocatedWOR, 0))   >= 0.01
       OR  ABS(S.stQtyIssuedWOR      - ISNULL(NewData.NewQtyIssuedWOR, 0))      >= 0.01
       OR  ABS(S.stQtyPickedWOR      - ISNULL(NewData.NewQtyPickedWOR, 0))      >= 0.01
       OR  ABS(S.stSalesReturnQty    - ISNULL(NewData.NewQtySalesReturn, 0))    >= 0.01
       OR  ABS(S.stPurchaseReturnQty - ISNULL(NewData.NewQtyPurchaseReturn, 0)) >= 0.01
       OR  S.stNLineCount <> ISNULL(NC.MaxNoteLine, 0) + 1
          )
  END
  
  -----------------------------------------------------------------------------------
  -- Stock Location
  -----------------------------------------------------------------------------------

  IF @ss_useMultiLocations = 1
  BEGIN
    IF @iv_Mode IN (@c_Report, @c_Debug)
    BEGIN
      SELECT InfoMessage          = 'Stock Location Errors'
           , StockCode            = SLList.StockCode
           , LocationCode         = SLList.LocationCode
           , QtyInStock           = ISNULL(SL.LsQtyInStock, 0)
           , NewQtyInStock        = ISNULL(NewData.NewQtyInStock, 0)
           , QtyAllocated         = ISNULL(SL.LsQtyAlloc, 0)
           , NewQtyAllocated      = ISNULL(NewData.NewQtyAllocated, 0)
           , QuantityOnOrder      = ISNULL(SL.LsQtyOnOrder, 0)
           , NewQtyOnOrder        = ISNULL(NewData.NewQtyOnOrder, 0)
           , QtyPicked            = ISNULL(SL.LsQtyPicked, 0)
           , NewQtyPicked         = ISNULL(NewData.NewQtyPicked, 0)
           , QtyAllocatedWOR      = ISNULL(SL.LsQtyAllocWOR, 0)
           , NewQtyAllocatedWOR   = ISNULL(NewData.NewQtyAllocatedWOR, 0)
           , QtyIssuedWOR         = ISNULL(SL.LsQtyIssueWOR, 0)
           , NewQtyIssuedWOR      = ISNULL(NewData.NewQtyIssuedWOR, 0)
           , QtyPickedWOR         = ISNULL(SL.LsQtyPickWOR, 0)
           , NewQtyPickedWOR      = ISNULL(NewData.NewQtyPickedWOR, 0)
           , QtySalesReturn       = ISNULL(SL.LsQtyReturn, 0)
           , NewQtySalesReturn    = ISNULL(NewData.NewQtySalesReturn, 0)
           , QtyPurchaseReturn    = ISNULL(SL.LsQtyPReturn, 0)
           , NewQtyPurchaseReturn = ISNULL(NewData.NewQtyPurchaseReturn, 0)
     
      FROM (SELECT DISTINCT
                   StockCode
                 , StockFolioNumber
                 , LocationCode
            FROM   #TLData 
            WHERE (StockCode  = @iv_StockCode OR @iv_StockCode IS NULL)
            AND    StockCode <> ''
            AND    StockType IN ('M','P','X')
            UNION
            SELECT DISTINCT
                   StockCode        = LsStkCode
                 , StockFolioNumber = LsStkFolio
                 , LocationCode     = LsLocCode
            FROM !ActiveSchema!.StockLocation SL
            JOIN !ActiveSchema!.STOCK S ON SL.LsStkfolio = S.stFolioNum
                                       AND S.stType IN ('M','P','X')
            WHERE (LsStkCode = @iv_StockCode OR @iv_StockCode IS NULL)
            ) SLList
      
      LEFT JOIN !ActiveSchema!.StockLocation SL ON SLList.StockFolioNumber = SL.LsStkFolio
                                       AND SLList.LocationCode     = SL.LsLocCode
      OUTER APPLY ( SELECT NewQtyInStock        = SUM(TL.NewQtyInStock)
                         , NewQtyAllocated      = SUM(TL.NewQtyAllocated)
                         , NewQtyOnOrder        = SUM(TL.NewQtyOnOrder)
                         , NewQtyPicked         = SUM(TL.NewQtyPicked)
                         , NewQtyAllocatedWOR   = SUM(TL.NewQtyAllocatedWOR)
                         , NewQtyIssuedWOR      = SUM(TL.NewQtyIssuedWOR)
                         , NewQtyPickedWOR      = SUM(TL.NewQtyPickedWOR)
                         , NewQtySalesReturn    = SUM(TL.NewQtySalesReturn)
                         , NewQtyPurchaseReturn = SUM(TL.NewQtyPurchaseReturn)
                    FROM #TLDataSummary TL
                    WHERE TL.StockCode    = SLList.StockCode
                    AND   TL.LocationCode = SLList.LocationCode
                  ) NewData
      WHERE (ABS(ISNULL(SL.LsQtyInStock, 0)  - ISNULL(NewData.NewQtyInStock, 0))        >= 0.01
         OR  ABS(ISNULL(SL.LsQtyAlloc , 0)   - ISNULL(NewData.NewQtyAllocated, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyOnOrder, 0)  - ISNULL(NewData.NewQtyOnOrder, 0))        >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPicked, 0)   - ISNULL(NewData.NewQtyPicked, 0))         >= 0.01
         OR  ABS(ISNULL(SL.LsQtyAllocWOR, 0) - ISNULL(NewData.NewQtyAllocatedWOR, 0))   >= 0.01
         OR  ABS(ISNULL(SL.LsQtyIssueWOR, 0) - ISNULL(NewData.NewQtyIssuedWOR, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPickWOR, 0)  - ISNULL(NewData.NewQtyPickedWOR, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyReturn, 0)   - ISNULL(NewData.NewQtySalesReturn, 0))    >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPReturn, 0)  - ISNULL(NewData.NewQtyPurchaseReturn, 0)) >= 0.01
            )
    END

    IF @iv_Mode = @c_Fix
    BEGIN

      -- Check for new records and add if don't exist

      IF EXISTS (SELECT TOP 1 1
                 FROM   #TLDataSummary TL
                 WHERE  NOT EXISTS (SELECT TOP 1 1
                                    FROM !ActiveSchema!.StockLocation SL
                                    WHERE TL.StockCode    = SL.LsStkCode
                                    AND   TL.LocationCode = SL.LsLocCode
                                   )
                )
      BEGIN

        INSERT INTO !ActiveSchema!.StockLocation
           ( LsStkCode 
           , LsStkFolio
           , LsLocCode
           , LsROPrice
           , LsRODate
           , LsROCurrency
           , LsROCostCentre
           , LsRODepartment
           , LsCostPrice
           , LsPCurrency
           , LsQtyMin
           , LsQtyMax
           , LsBinLoc
           , LsDefNom1
           , LsDefNom2
           , LsDefNom3
           , LsDefNom4
           , LsDefNom5
           , LsDefNom6
           , LsDefNom7
           , LsDefNom8
           , LsDefNom9
           , LsDefNom10
           , LsWOPWIPGL
           , LsReturnGL
           , LsPReturnGL
           , LsCostCentre
           , LsDepartment
           , SalesPrice1
           , Currency1
           , SalesPrice2
           , Currency2
           , SalesPrice3
           , Currency3     
           , SalesPrice4
           , Currency4
           , SalesPrice5
           , Currency5
           , SalesPrice6
           , Currency6
           , SalesPrice7
           , Currency7
           , SalesPrice8
           , Currency8
           , SalesPrice9
           , Currency9
           , SalesPrice10
           , Currency10
           , LsQtyFreeze
           , LsRoQty
           , LsStkFlg
           , LsMinFlg
           , LsTempSupp
           , LsSupplier
           , LsLastUsed
           , LsQtyPosted
           , LsQtyTake
           , LsROFlg
           , LsLastTime
           , LsQtyPickWOR
           , LsSWarranty
           , LsSWarrantyType
           , LsMWarranty
           , LsMWarrantyType
           , LsReStockGL
           , LsReStockPcnt
           , LsBOMDedComp
           )
      SELECT LsStkCode         = S.stCode
           , LsStkFolio        = S.stFolioNum
           , LsLocCode         = L.LoCode
           , LsROPrice         = S.stReorderPrice
           , LsRODate          = S.stReorderDate
           , LsROCurrency      = S.stReorderCurrency
           , LsROCostCentre    = S.stReorderCostCentre
           , LsRODepartment    = S.stReorderDepartment
           , LsCostPrice       = S.stCostPrice
           , LsPCurrency       = S.stCostPriceCurrency
           , LsQtyMin          = S.stQtyMin
           , LsQtyMax          = S.stQtyMax
           , LsBinLocation     = S.stBinLocation
           , LsDefNom1         = L.LoNominal1
           , LsDefNom2         = L.LoNominal2
           , LsDefNom3         = L.LoNominal3
           , LsDefNom4         = L.LoNominal4
           , LsDefNom5         = L.LoNominal5
           , LsDefNom6         = L.LoNominal6
           , LsDefNom7         = L.LoNominal7
           , LsDefNom8         = L.LoNominal8
           , LsDefNom9         = L.LoNominal9
           , LsDefNom10        = L.LoNominal10
           , LsWOPWIPGL        = L.LoWOPWIPGL
           , LsReturnGL        = L.LoReturnGL
           , LsPReturnGL       = L.LoPReturnGL
           , LsCostCentre      = L.LoCostCentre
           , LsDepartment      = L.LoDepartment
           , SalesPrice1       = S.stSalesBand1Price
           , Currency1         = S.stSalesBand1Currency
           , SalesPrice2       = S.stSalesBand2Price
           , Currency2         = S.stSalesBand2Currency
           , SalesPrice3       = S.stSalesBand3Price
           , Currency3         = S.stSalesBand3Currency     
           , SalesPrice4       = S.stSalesBand4Price
           , Currency4         = S.stSalesBand4Currency
           , SalesPrice5       = S.stSalesBand5Price
           , Currency5         = S.stSalesBand5Currency
           , SalesPrice6       = S.stSalesBand6Price
           , Currency6         = S.stSalesBand6Currency
           , SalesPrice7       = S.stSalesBand7Price
           , Currency7         = S.stSalesBand7Currency
           , SalesPrice8       = S.stSalesBand8Price
           , Currency8         = S.stSalesBand8Currency
           , SalesPrice9       = S.stSalesBand9Price
           , Currency9         = S.stSalesBand9Currency
           , SalesPrice10      = S.stSalesBand10Price
           , Currency10        = S.stSalesBand10Currency
           , LsQtyFreeze       = S.stQtyFreeze
           , LsRoQty           = S.stReOrderQty
           , LsStkFlg          = S.stStockTakeFlag
           , LsMinFlg          = S.stMinReorderFlag
           , LsTempSupp        = S.stSuppTemp
           , LsSupplier        = S.stSupplier
           , LsLastUsed        = S.stLastUsed
           , LsQtyPosted       = S.stQtyPosted
           , LsQtyTake         = S.stQtyStockTake
           , LsROFlg           = S.stReorderFlag
           , LsLastTime        = S.stTimeChange
           , LsQtyPickWOR      = S.stQtyPickedWOR
           , LsSWarranty       = S.stSalesWarrantyLength
           , LsSWarrantyType   = S.stSalesWarrantyType
           , LsMWarranty       = S.stManufacturerWarrantyLength
           , LsMWarrantyType   = S.stManufacturerWarrantyType
           , LsReStockGL       = S.stRestockGL
           , LsReStockPcnt     = S.stRestockPercent
           , LsBOMDedComp      = S.BOMDedComp
        FROM #TLDataSummary TL
        JOIN !ActiveSchema!.STOCK    S ON S.stCode = TL.StockCode
                                      AND S.stType IN ('M','P','X')
        JOIN !ActiveSchema!.Location L ON L.LoCode = TL.LocationCode

        WHERE NOT EXISTS (SELECT TOP 1 1
                          FROM !ActiveSchema!.StockLocation SL
                          WHERE TL.StockCode    = SL.LsStkCode
                          AND   TL.LocationCode = SL.LsLocCode
                         )
      END

      -- Update StockLocation Quantity data

      UPDATE SL
         SET LsQtyInStock    = ISNULL(NewData.NewQtyInStock, 0)
           , LsQtyAlloc      = ISNULL(NewData.NewQtyAllocated, 0)
           , LsQtyOnOrder    = ISNULL(NewData.NewQtyOnOrder, 0)
           , LsQtyPicked     = ISNULL(NewData.NewQtyPicked, 0)
           , LsQtyAllocWOR   = ISNULL(NewData.NewQtyAllocatedWOR, 0)
           , LsQtyIssueWOR   = ISNULL(NewData.NewQtyIssuedWOR, 0)
           , LsQtyPickWOR    = ISNULL(NewData.NewQtyPickedWOR, 0)
           , LsQtyReturn     = ISNULL(NewData.NewQtySalesReturn, 0)
           , LsQtyPReturn    = ISNULL(NewData.NewQtyPurchaseReturn, 0)
      FROM (SELECT DISTINCT
                   StockCode
                 , StockFolioNumber
                 , LocationCode
            FROM   #TLData 
            WHERE (StockCode  = @iv_StockCode OR @iv_StockCode IS NULL)
            AND    StockCode <> ''
            AND    StockType IN ('M','P','X')

            UNION                   -- Get any that maybe set but should be 0
            SELECT DISTINCT
                   StockCode        = LsStkCode
                 , StockFolioNumber = LsStkFolio
                 , LocationCode     = LsLocCode
            FROM !ActiveSchema!.StockLocation SL1
            JOIN !ActiveSchema!.STOCK S ON SL1.LsStkfolio = S.stFolioNum
                                       AND S.stType IN ('M','P','X')
            WHERE (LsStkCode = @iv_StockCode OR @iv_StockCode IS NULL)
            ) SLList
      JOIN !ActiveSchema!.StockLocation SL ON SLList.StockFolioNumber = SL.LsStkFolio
                                  AND SLList.LocationCode     = SL.LsLocCode
      OUTER APPLY ( SELECT NewQtyInStock        = SUM(TL.NewQtyInStock)
                         , NewQtyAllocated      = SUM(TL.NewQtyAllocated)
                         , NewQtyOnOrder        = SUM(TL.NewQtyOnOrder)
                         , NewQtyPicked         = SUM(TL.NewQtyPicked)
                         , NewQtyAllocatedWOR   = SUM(TL.NewQtyAllocatedWOR)
                         , NewQtyIssuedWOR      = SUM(TL.NewQtyIssuedWOR)
                         , NewQtyPickedWOR      = SUM(TL.NewQtyPickedWOR)
                         , NewQtySalesReturn    = SUM(TL.NewQtySalesReturn)
                         , NewQtyPurchaseReturn = SUM(TL.NewQtyPurchaseReturn)
                    FROM #TLDataSummary TL
                    WHERE TL.StockCode    = SLList.StockCode
                    AND   TL.LocationCode = SLList.LocationCode
                  ) NewData
      WHERE (ABS(ISNULL(SL.LsQtyInStock, 0)  - ISNULL(NewData.NewQtyInStock, 0))        >= 0.01
         OR  ABS(ISNULL(SL.LsQtyAlloc , 0)   - ISNULL(NewData.NewQtyAllocated, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyOnOrder, 0)  - ISNULL(NewData.NewQtyOnOrder, 0))        >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPicked, 0)   - ISNULL(NewData.NewQtyPicked, 0))         >= 0.01
         OR  ABS(ISNULL(SL.LsQtyAllocWOR, 0) - ISNULL(NewData.NewQtyAllocatedWOR, 0))   >= 0.01
         OR  ABS(ISNULL(SL.LsQtyIssueWOR, 0) - ISNULL(NewData.NewQtyIssuedWOR, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPickWOR, 0)  - ISNULL(NewData.NewQtyPickedWOR, 0))      >= 0.01
         OR  ABS(ISNULL(SL.LsQtyReturn, 0)   - ISNULL(NewData.NewQtySalesReturn, 0))    >= 0.01
         OR  ABS(ISNULL(SL.LsQtyPReturn, 0)  - ISNULL(NewData.NewQtyPurchaseReturn, 0)) >= 0.01
            )
    END

  END -- Use Multi Locations

  -----------------------------------------------------------------------------------
  -- FIFO & LIFO
  -----------------------------------------------------------------------------------

  IF EXISTS(SELECT TOP 1 1
            FROM #TLData 
            WHERE FIFOMode IN (2,3) -- FIFO & LIFO
           )
  BEGIN

    IF OBJECT_ID('tempdb..#FIFO') IS NOT NULL
      DROP TABLE #FIFO
    
    CREATE TABLE #FIFO
         ( StockCode    VARCHAR(50)
         , OurReference VARCHAR(50)
         , RowNo        INT
         , QtyLeft      FLOAT
         )
    
    -- Cursor round the FIFO Rows

    DECLARE @FIFOStockCode  VARCHAR(50)
          , @FIFOOurRef     VARCHAR(50)
          , @FIFORowNo      INT
          , @FIFOQtyReqd    FLOAT
          , @FIFOMode       INT

    DECLARE curFIFO CURSOR FOR SELECT StockCode
                                    , OurReference
                                    , RowNo
                                    , FIFOQty
                                    , FIFOMode
                               FROM #TLData
                               WHERE FIFOMode IN (2, 3)
                               ORDER BY StockCode
                                      , RowNo
    OPEN curFIFO

    FETCH NEXT FROM curFIFO INTO @FIFOStockCode
                               , @FIFOOurRef
                               , @FIFORowNo
                               , @FIFOQtyReqd
                               , @FIFOMode

    WHILE @@FETCH_STATUS = 0
    BEGIN

      WHILE @FIFOQtyReqd <> 0
      BEGIN

        DECLARE @RowNo          FLOAT
              , @QtyLeft        FLOAT = 0
     
        SELECT TOP 1 @Rowno   = RowNo
                   , @QtyLeft = QtyLeft
        FROM #FIFO
        WHERE StockCode = @FIFOStockCode 
        AND   QtyLeft  <> 0
        ORDER BY CASE WHEN @FIFOMode = 3 THEN RowNo END DESC
               , RowNo ASC

        IF @QtyLeft = 0
        OR SIGN(@QtyLeft) = SIGN(@FIFOQtyReqd)
        BEGIN
          INSERT INTO #FIFO
          SELECT @FIFOStockCode
               , @FIFOOurRef
               , @FIFORowNo
               , @FIFOQtyReqd

          SET @FIFOQtyReqd = 0
        END
        ELSE
        BEGIN
    
          IF ABS(@QtyLeft) < ABS(@FIFOQtyReqd)
          BEGIN
      
            DELETE 
            FROM #FIFO
            WHERE StockCode = @FIFOStockCode
            AND   RowNo     = @RowNo
        
            SET @FIFOQtyReqd = @QtyLeft + @FIFOQtyReqd
          END
          ELSE
          BEGIN
            IF @QtyLeft + @FIFOQtyReqd = 0
            BEGIN
              DELETE 
              FROM #FIFO
              WHERE StockCode = @FIFOStockCode
              AND   RowNo     = @RowNo
            END
            ELSE
            BEGIN
              UPDATE #FIFO
                 SET QtyLeft  = @QtyLeft + @FIFOQtyReqd
              WHERE StockCode = @FIFOStockCode
              AND   RowNo     = @RowNo
            END
          
            SET @FIFOQtyReqd = 0
          END
        END
   
      END
     
      -- Get Next Row

      FETCH NEXT FROM curFIFO INTO @FIFOStockCode
                                 , @FIFOOurRef
                                 , @FIFORowNo
                                 , @FIFOQtyReqd
                                 , @FIFOMode

    END

    CLOSE curFIFO
    DEALLOCATE curFIFO

    IF @iv_Mode IN (@c_Debug, @c_Report)
    BEGIN

      SELECT FIFOStkFolio    = T.StockFolioNumber
           , StockCode       = T.StockCode
           , FIFODocAbsNo    = T.ABSLineNo
           , FIFODate        = T.TransactionLineDate
           , FIFOQtyLeft     = F.QtyLeft
           , FIFODocRef      = F.OurReference
           , FIFOQty         = T.FIFOQty
           , FIFOCost        = common.efn_ConvertToReal48((SELECT RoundedNumber FROM common.efn_NewRoundUp(common.efn_SafeDivide(T.LineCost, QuantityMultiplier), 2)))
           , FIFOCurr        = T.CurrencyId
           , FIFOCust        = T.TraderCode
           , FIFOMLoc        = T.LocationCode
           , FIFOCompanyRate = T.CompanyRate
           , FIFODailyRate   = T.DailyRate
           , FIFOUseORate    = T.UseOriginalRates
           , FIFOTriRates    = T.TriRates
           , FIFOTriEuro     = T.TriEuro
           , FIFOTriInvert   = T.TriInvert
           , FIFOTriFloat    = T.TriFloat
        FROM #FIFO F
        JOIN #TLData T ON F.StockCode = T.StockCode COLLATE Latin1_General_CI_AS
                      AND F.RowNo     = T.RowNo

        ORDER BY FIFOStkFolio

    END

    IF @iv_Mode = @c_Fix
    BEGIN

      -- Delete Existing FIFO Records
      DELETE F
      FROM !ActiveSchema!.FIFO F
      WHERE ( @iv_StockCode IS NULL
      OR      F.FIFOStkFolio = (SELECT DISTINCT
                                       StockFolioNumber
                                FROM   #TLData)
            )

      -- Insert new records

      INSERT INTO !ActiveSchema!.FIFO
                ( FIFOStkFolio
                , FIFODocAbsNo
                , FIFODate
                , FIFOQtyLeft
                , FIFODocRef
                , FIFOQty
                , FIFOCost
                , FIFOCurr
                , FIFOCust
                , FIFOMLoc
                , FIFOCompanyRate
                , FIFODailyRate
                , FIFOUseORate
                , FIFOTriRates
                , FIFOTriEuro
                , FIFOTriInvert
                , FIFOTriFloat
                , FIFOTriSpare
                )
      SELECT FIFOStkFolio    = T.StockFolioNumber
           , FIFODocAbsNo    = T.ABSLineNo
           , FIFODate        = T.TransactionLineDate
           , FIFOQtyLeft     = F.QtyLeft
           , FIFODocRef      = F.OurReference
           , FIFOQty         = T.FIFOQty
           , FIFOCost        = common.efn_ConvertToReal48((SELECT RoundedNumber FROM common.efn_NewRoundUp(common.efn_SafeDivide(T.LineCost, QuantityMultiplier), 2)))
           , FIFOCurr        = T.CurrencyId
           , FIFOCust        = T.TraderCode
           , FIFOMLoc        = T.LocationCode
           , FIFOCompanyRate = T.CompanyRate
           , FIFODailyRate   = T.DailyRate
           , FIFOUseORate    = T.UseOriginalRates
           , FIFOTriRates    = T.TriRates
           , FIFOTriEuro     = T.TriEuro
           , FIFOTriInvert   = T.TriInvert
           , FIFOTriFloat    = T.TriFloat
           , FIFOTriSpare    = 0x00000000000000000000
        FROM #FIFO F
        JOIN #TLData T ON F.StockCode = T.StockCode COLLATE Latin1_General_CI_AS
                      AND F.RowNo     = T.RowNo

        ORDER BY FIFOStkFolio

    END

    -- Remove Balance row
    DELETE
    FROM #TLData
    WHERE RowNo = 0

  END

  -----------------------------------------------------------------------------------
  -- HISTORY
  -----------------------------------------------------------------------------------
    
  IF OBJECT_ID('tempdb..#StockMovementSummary') IS NOT NULL
    DROP TABLE #StockMovementSummary

  SELECT StockCode
       , StockFolioNumber
       , LocationCode
       , StockType
       , CurrencyId      = 0
       , TransactionPeriodKey
       , SalesAmount     = SUM(CASE
                               WHEN LineCalculatedNetValue < 0 THEN ABS(LineCalculatedNetValue)
                               ELSE 0
                               END)
       , PurchaseAmount  = SUM(CASE
                               WHEN LineCalculatedNetValue > 0 THEN ABS(LineCalculatedNetValue)
                               ELSE 0
                               END)
       , QuantityInStock = SUM(StockMovementQuantity * StockMovementSign)
       , Quantityused    = SUM(LineQuantityUsed)

  INTO   #StockMovementSummary
  FROM   #TLData DTL
  WHERE  ( DTL.RunNo IN (-30, -129) OR DTL.RunNo > 0)
  AND   DTL.StockCode             <> ''
  AND   DTL.StockMovementQuantity <> 0
  AND   DTL.TransactionTypeCode   NOT IN ('PPY','SRC')
  
  GROUP BY StockCode
         , StockFolioNumber
         , LocationCode
         , StockType
         --, CurrencyId
         , TransactionPeriodKey


  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After retrieving Stock Movement Summary'
         , *
    FROM #StockMovementSummary
  END

  -- Create History Summary

  IF OBJECT_ID('tempdb..#StockMovementHistory') IS NOT NULL
    DROP TABLE #StockMovementHistory

  CREATE TABLE #StockMovementHistory
             ( HistoryPositionId     INT           NULL
             , HistoryCode           VARBINARY(21)
             , StockCode             VARCHAR(50)
             , StockFolioNumber      INT
             , StockType             VARCHAR(1)
             , LocationCode          VARCHAR(50)   NULL
             , CurrencyId            INT
             , HistoryPeriodKey      INT
             , StockMovementQuantity FLOAT
             , QuantityUsed          FLOAT         DEFAULT(0)
             , SalesAmount           FLOAT         DEFAULT(0)
             , PurchaseAmount        FLOAT         DEFAULT(0)
             )

  -- Insert the Stock & Location rows

  INSERT INTO #StockMovementHistory
            ( HistoryCode
            , StockCode
            , StockFolioNumber
            , StockType
            , LocationCode
            , CurrencyId
            , HistoryPeriodKey

            , StockMovementQuantity
            , Quantityused
            , SalesAmount
            , PurchaseAmount
            )
  SELECT HistoryCode        = 0x144C + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), MAX(SMD.StockFolioNumber) )) )
                                     + CONVERT(VARBINARY(21), CONVERT(CHAR(15), SMD.LocationCode ))
       , SMD.StockCode
       , StockFolioNumber   = MAX(SMD.StockFolioNumber)
       , StockType          = MAX(SMD.StockType)
       , SMD.LocationCode
       , SMD.CurrencyId
       , SMD.TransactionPeriodKey

       , SMQ                = SUM(ROUND(SMD.QuantityInStock, @ss_NoOfDPQuantity) )
       , QuantityUsed       = SUM(ROUND(SMD.QuantityUsed, @ss_NoOfDPQuantity) )
       , SalesAmount        = SUM(SMD.SalesAmount)
       , PurchaseAmount     = SUM(SMD.PurchaseAmount)

  FROM #StockMovementSummary SMD

  WHERE SMD.StockType IN ('M', 'P', 'X')

  GROUP BY SMD.StockCode
         , SMD.LocationCode
         , SMD.CurrencyId
         , SMD.TransactionPeriodKey

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Insert Stock & Location - Stock Movement History'
         , *
    FROM #StockMovementHistory
  END

  -- Insert the Stock rows

  INSERT INTO #StockMovementHistory
            ( HistoryCode
            , StockCode
            , StockFolioNumber
            , StockType
            , CurrencyId
            , HistoryPeriodKey

            , StockMovementQuantity
            , QuantityUsed
            , SalesAmount
            , PurchaseAmount
            )
  SELECT HistoryCode        = 0x14 + CONVERT(VARBINARY(21), REVERSE(CONVERT(VARBINARY(4), MAX(SMD.StockFolioNumber) )) )
                                   + CONVERT(VARBINARY(21), SPACE(16))
       , SMD.StockCode
       , StockFolioNumber   = MAX(SMD.StockFolioNumber)
       , StockType          = MAX(SMD.StockType)
       , CurrencyId
       , SMD.TransactionPeriodKey

       , SMQ                = SUM(ROUND(SMD.QuantityInStock, @ss_NoOfDPQuantity) )
       , QuantityUsed       = SUM(ROUND(SMD.QuantityUsed, @ss_NoofDPQuantity) )
       , SalesAmount        = SUM(SMD.SalesAmount)
       , PurchaseAmount     = SUM(SMD.PurchaseAmount)

  FROM #StockMovementSummary SMD
  WHERE SMD.StockType IN ('M', 'P', 'X')

  GROUP BY SMD.StockCode
         , SMD.CurrencyId
         , SMD.TransactionPeriodKey

  IF @iv_Mode = @c_Debug
  BEGIN
    SELECT 'After Insert Stock summary - Stock Movement History'
         , *
    FROM #StockMovementHistory
  END

  -- Update HistoryPositionId

  UPDATE SMH
     SET HistoryPositionId = SH.HistoryPositionId
  FROM #StockMovementHistory SMH
  JOIN !ActiveSchema!.evw_StockHistory SH ON SH.HistoryCode             = SMH.HistoryCode
                                         AND SH.HistoryClassificationId = (ASCII(SMH.StockType) + 159)
                                         AND SH.CurrencyId              = SMH.CurrencyId
                                         AND SH.HistoryPeriodKey        = SMH.HistoryPeriodKey

  -- Insert any History rows that should no longer exist in StockMovementHistory
  -- in order to reset them to 0

  INSERT INTO #StockMovementHistory
          ( HistoryPositionId
          , HistoryCode
          , CurrencyId
          , HistoryPeriodKey
          , StockMovementQuantity
          , QuantityUsed
          , SalesAmount
          , PurchaseAmount
          )
  SELECT HistoryPositionId
       , HistoryCode
       , CurrencyId
       , HistoryPeriodKey
       , QuantityInStock       = 0
       , QuantityUsed          = 0
       , SalesAmount           = 0
       , PurchaseAmount        = 0
  FROM !ActiveSchema!.evw_StockHistory SH
  WHERE ( @iv_stockCode IS NULL
  OR      @iv_stockCode = SH.StockCode
        )
  AND SH.HistoryClassificationId > 159
  AND NOT EXISTS ( SELECT TOP 1 1
                   FROM #StockMovementHistory SMH
                   WHERE SMH.HistoryPositionId = SH.HistoryPositionId
                 )
  AND ( SH.SalesAmount     <> 0
  OR    SH.PurchaseAmount  <> 0
  OR    SH.QuantityInStock <> 0
  OR    SH.Value1Amount    <> 0
      )
  AND   SH.HistoryYear      > @ss_AuditYear
  AND   SH.HistoryPeriod    < 250 

  IF @iv_Mode IN (@c_Debug, @c_Report)
  BEGIN

    -- check the Stock & Location Values

    SELECT SMH.HistoryPositionId
         , HistoryClassificationId = ASCII(SMH.StockType) + 159
         , SMH.StockFolioNumber
         , SMH.StockCode
         , SMH.StockType
         , SMH.CurrencyId
         , SMH.HistoryPeriodKey
         , SMH.LocationCode

         , SH.QuantityInStock
         , NewQuantityInStock = ISNULL(SMH.StockMovementQuantity, 0)

         , SH.SalesAmount
         , NewSalesAmount    = SMH.SalesAmount


         , SH.PurchaseAmount
         , NewPurchaseAmount = SMH.PurchaseAmount

         , SH.Value1Amount
         , NewValue1amount   = SMH.QuantityUsed
         

    FROM   #StockMovementHistory SMH
    LEFT JOIN !ActiveSchema!.evw_StockHistory SH ON SH.HistoryPositionId = SMH.HistoryPositionId
    WHERE 1 = 1
    AND ( ABS(ROUND(ISNULL(SMH.StockMovementQuantity, 0) - ISNULL(SH.QuantityInStock, 0), 2)) >= 0.01
     OR   ABS(ROUND(ISNULL(SMH.SalesAmount, 0)           - ISNULL(SH.SalesAmount, 0), 2))     >= 0.01
     OR   ABS(ROUND(ISNULL(SMH.PurchaseAmount, 0)        - ISNULL(SH.PurchaseAmount, 0), 2))  >= 0.01
     OR   ABS(ROUND(ISNULL(SMH.Quantityused, 0)          - ISNULL(SH.Value1Amount, 0), 2))    >= 0.01
        )
    AND   SMH.HistoryPeriodKey > (@ss_AuditYear + 1) * 1000

    ORDER BY HistoryClassificationId
           , StockCode
           , LocationCode
           , HistoryPeriodKey

  END

  IF @iv_mode = @c_Fix
  BEGIN

    MERGE !ActiveSchema!.HISTORY H
    USING ( SELECT SMH.HistoryPositionId
                 , HistoryClassificationId = ASCII(SMH.StockType) + 159
                 , SMH.HistoryCode
                 , SMH.HistoryPeriodKey
                 , SMH.CurrencyId
                 , SMH.LocationCode

                 , SH.QuantityInStock
                 , NewQuantityInStock = ISNULL(SMH.StockMovementQuantity, 0)

                 , SH.SalesAmount
                 , NewSalesAmount    = SMH.SalesAmount


                 , SH.PurchaseAmount
                 , NewPurchaseAmount = SMH.PurchaseAmount

                 , SH.Value1Amount
                 , NewValue1amount   = SMH.QuantityUsed

            FROM   #StockMovementHistory SMH
            LEFT JOIN !ActiveSchema!.evw_StockHistory SH ON SH.HistoryPositionId = SMH.HistoryPositionId
            WHERE 1 = 1
            AND ( ABS(ROUND(ISNULL(SMH.StockMovementQuantity, 0) - ISNULL(SH.QuantityInStock, 0), 2)) >= 0.01
             OR   ABS(ROUND(ISNULL(SMH.SalesAmount, 0)           - ISNULL(SH.SalesAmount, 0), 2))     >= 0.01
             OR   ABS(ROUND(ISNULL(SMH.PurchaseAmount, 0)        - ISNULL(SH.PurchaseAmount, 0), 2)) >= 0.01
             OR   ABS(ROUND(ISNULL(SMH.Quantityused, 0)          - ISNULL(SH.Value1Amount, 0), 2))    >= 0.01
                )
            AND   SMH.HistoryPeriodKey > (@ss_AuditYear + 1) * 1000
          ) NewData ON NewData.HistoryPositionId = H.PositionId
    WHEN MATCHED THEN
         UPDATE
            SET hiCleared   = NewData.NewQuantityInStock
              , hiSales     = NewData.NewSalesAmount
              , hiPurchases = NewData.NewPurchaseAmount
              , hiValue1    = NewData.NewValue1Amount


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
         VALUES ( NewData.HistoryCode
                , NewData.HistoryClassificationId
                , NewData.CurrencyId
                , FLOOR(NewData.HistoryPeriodKey / 1000) - 1900
                , (NewData.HistoryPeriodKey % 1000)
                , NewData.NewSalesAmount
                , NewData.NewPurchaseAmount
                , 0
                , NewData.NewQuantityInStock
                , 0
                , NewData.NewValue1Amount
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

  -- CTD (255) calculation for these items.
  
  MERGE !ActiveSchema!.HISTORY H
  USING
  (
  SELECT SH.HistoryPositionId
       , SH.HistoryCode
       , SH.StockCode
       , SH.LocationCode
       , SH.CurrencyId
       , SH.HistoryYear
       , SH.HistoryPeriod
       , SalesAmount        = ROUND(SH.SalesAmount, 2)
       , NewSalesAmount     = ROUND(CTDValues.SalesAmount, 2)
       , PurchaseAmount     = ROUND(SH.PurchaseAmount, 2)
       , NewPurchaseAmount  = ROUND(CTDValues.PurchaseAmount, 2)
       , BalanceAmount      = ROUND(SH.BalanceAmount, 2)
       , NewBalanceAmount   = ROUND(CTDValues.BalanceAmount, 2)
       , QuantityInStock    = ROUND(SH.QuantityInStock, 2)
       , NewQuantityInStock = ROUND(CTDValues.QuantityInStock, 2)
       , QuantityUsed       = ROUND(SH.Value1amount, 2)
       , NewQuantityUsed    = ROUND(CTDValues.QuantityUsed, 2)

  FROM !ActiveSchema!.evw_StockHistory SH

  CROSS APPLY ( SELECT SalesAmount     = SUM(CSH.SalesAmount) 
                     , PurchaseAmount  = SUM(CSH.PurchaseAmount) 
                     , BalanceAmount   = SUM(CSH.BalanceAmount)
                     , QuantityInStock = SUM(CSH.QuantityInStock)
                     , QuantityUsed    = SUM(CSH.Value1Amount)
 
                FROM !ActiveSchema!.evw_StockHistory CSH
                WHERE SH.HistoryClassificationId = CSH.HistoryClassificationId
                AND   SH.HistoryCode             = CSH.HistoryCode
                AND   SH.CurrencyId              = CSH.CurrencyId
                AND   SH.HistoryYear            >= CSH.HistoryYear
                AND   CSH.HistoryPeriod         < 250
              
              ) CTDValues

  WHERE 1 = 1
  AND   SH.HistoryPeriod = 255
  AND   ( ROUND(SH.SalesAmount, 2)     <> ROUND(CTDValues.SalesAmount, 2)
     OR   ROUND(SH.PurchaseAmount, 2)  <> ROUND(CTDValues.PurchaseAmount, 2)
     OR   ROUND(SH.BalanceAmount, 2)   <> ROUND(CTDValues.BalanceAmount, 2)
     OR   ROUND(SH.QuantityInStock, 2) <> ROUND(CTDValues.QuantityinStock, 2)
     OR   ROUND(SH.Value1Amount, 2)    <> ROUND(CTDValues.QuantityUsed, 2)
        )
  ) AS HistSumm ON HistSumm.HistoryPositionId = H.PositionId

  WHEN MATCHED THEN

       UPDATE
          SET hiSales     = HistSumm.NewSalesAmount
            , hiPurchases = HistSumm.NewPurchaseAmount
            , hiCleared   = HistSumm.NewQuantityInStock
            , hiValue1    = HistSumm.NewQuantityUsed
       ;
  
 
END
GO
