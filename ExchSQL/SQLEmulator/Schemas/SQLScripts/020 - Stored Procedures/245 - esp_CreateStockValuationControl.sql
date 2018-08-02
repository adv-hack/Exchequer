
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateStockValuationControl]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateStockValuationControl
GO

CREATE PROCEDURE [!ActiveSchema!].esp_CreateStockValuationControl ( @itvp_PostLineTransactions [common].edt_Integer READONLY
                                                        , @iv_RunNo           INT
                                                        , @iv_SeparateControl BIT = 0
                                                        )
AS
BEGIN

  SET NOCOUNT ON;

  /* -- For Debug Purposes
     DECLARE @itvp_PostLineTransactions [common].edt_Integer

     INSERT INTO @itvp_PostLineTransactions
     SELECT 66579

     DECLARE @iv_RunNo INT = 1012
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

  DECLARE @ss_AutoPostUplift        BIT = @c_False
        , @ss_LiveStockCOSValuation BIT = @c_False
        , @ss_FreightNominalCode    INT
      
  SELECT @ss_FreightNominalCode = NC.FreightUplift
  FROM   [!ActiveSchema!].evw_NominalControl NC

  SELECT @ss_AutoPostUplift        = SS.AutoPostUplift
       , @ss_LiveStockCOSValuation = SS.LiveStockCOSValuation
  FROM   [!ActiveSchema!].evw_SystemSettings SS

  --For Performance reasons create temp. table of TL Values required
  IF OBJECT_ID('tempdb..#TLDataValues') IS NOT NULL
     DROP TABLE #TLDataValues

  SELECT LinePositionId
       , StockMovementQuantity  
       , DailyRate
       , CompanyRate
       , LineQuantity
       , LineCost
       , LineCostInBase
  INTO #TLDataValues
  FROM [!ActiveSchema!].evw_TransactionLine VTL (READUNCOMMITTED)
  WHERE EXISTS ( SELECT TOP 1 1
                 FROM @itvp_PostLineTransactions PLT
                 WHERE PLT.IntegerValue = VTL.LinePositionId
               )  

  CREATE INDEX idx_TV ON #TLDataValues(LinePositionId)

  -- Create temp. table of Transaction Line Data

  IF OBJECT_ID('tempdb..#TLData') IS NOT NULL
     DROP TABLE #TLData
    
  SELECT LinePositionId = DTL.PositionId
       , OurReference    = DTL.tlOurRef
       , TransactionLineNo = DTL.tlABSLineNo
       , DepartmentCode    = DTL.tlDepartment
       , CostCentreCode    = DTL.tlCostCentre
       , TransactionYear   = DTL.tlYear + 1900
       , ExchequerYear     = DTL.tlYear
       , TransactionPeriod = DTL.tlPeriod
       , TransactionPeriodKey = ((DTL.tlYear + 1900) * 1000) + DTL.tlPeriod
       , TT.TransactionTypeCode
       , TT.TransactionTypeSign
       , X.StockCode
       , LocationCode       = DTL.tlLocation
       , StockMovementQuantity  
       , CurrencyId         = DTL.tlCurrency
       , DailyRate
       , CompanyRate
       , LineQuantity
       , LineCost
       , LineCostInBase
       , CostPrice        = CONVERT(FLOAT, NULL)
       
       , NominalMode      = DTL.tlNominalMode
       , B2BLineNo        = DTL.tlB2BLineNo
       , COSNomCode       = DTL.tlCOSNomCode
       , TraderCode       = DTL.tlAcCode
       , SOPABSLineNo     = DTL.tlSOPABSLineNo
       , DisplayLineNo    = DTL.tlLineNo
       , IsBOM            = @c_False
       , AccountCode      = DTL.tlAcCode
       , COSNominalCode   = DTL.tlCOSNomCode

       , StockNominalCode = CONVERT(INTEGER, NULL)
       , StockType        = CONVERT(VARCHAR(1), NULL)

  INTO #TLData
  FROM   [!ActiveSchema!].DETAILS DTL (READUNCOMMITTED)
  JOIN #TLDataValues TV ON DTL.PositionId = TV.LinePositionId
  JOIN  common.evw_TransactionType TT ON DTL.tlDocType = TT.TransactionTypeId
  CROSS APPLY (SELECT StockCode = CASE
                                  WHEN DTL.tlDocType NOT IN (30, 31, 41, 1, 16)
                                   AND   DTL.tlStockCodeComputed   <> 0x2020202020202020202000000000
                                   AND   DTL.tlStockCodeComputed   <> 0x0000000000000000000000000000
                                   AND   SUBSTRING(DTL.tlStockCodeComputed, 1, 1) NOT IN (CHAR(1), CHAR(2))
                                  THEN LTRIM(RTRIM(CONVERT(VARCHAR(50), SUBSTRING(DTL.tlStockCodeComputed, 1 , 16))))
                                  ELSE ''
                                  END
              ) X
  JOIN [!ActiveSchema!].evw_Stock S ON X.StockCode = S.StockCode

  WHERE EXISTS ( SELECT TOP 1 1
                 FROM @itvp_PostLineTransactions PLT
                 WHERE PLT.IntegerValue = DTL.PositionId
               )
  AND X.StockCode <> ''

  UPDATE DTL
     SET COSNominalCode   = CASE
                            WHEN TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
                            THEN CASE
                                 WHEN DTL.COSNominalCode <> 0 AND COSGL.glType IN ('A','B') THEN DTL.COSNominalCode
                                 WHEN Trader.acCOSGL <> 0 THEN Trader.acCOSGL
                                 ELSE ISNULL( CASE
                                              WHEN L.LoUseNom = @c_True THEN NULLIF(SL.LsDefNom2, 0)
                                              END, S.CostOfSalesNominalCode
                                            )
                                 END
                            ELSE @ss_FreightNominalCode
                            END
       , StockNominalCode = CASE
                            WHEN S.StockType = 'M' THEN CASE
                                                        WHEN L.loUseNom = @c_True THEN SL.LsDefNom5
                                                        ELSE S.BoMFinishedGoodsNominalCode
                                                        END
                            ELSE CASE
                                 WHEN L.loUseNom = @c_True THEN SL.LsDefNom4
                                 ELSE S.StockValueNominalCode
                                 END
                            END
        , StockType       = S.StockType
        , CostPrice       = S.CostPrice
  FROM #TLData DTL
  LEFT JOIN [!ActiveSchema!].CUSTSUPP Trader ON Trader.acCode     = DTL.AccountCode COLLATE SQL_Latin1_General_CP437_BIN
  LEFT JOIN [!ActiveSchema!].NOMINAL COSGL ON COSGL.glCode = Trader.acCOSGL
  LEFT JOIN [!ActiveSchema!].Location L ON DTL.LocationCode = L.loCode
  LEFT JOIN [!ActiveSchema!].StockLocation SL (READUNCOMMITTED) ON DTL.LocationCode = SL.LsLocCode
                                                       AND DTL.StockCode    = SL.LsStkCode
  JOIN [!ActiveSchema!].evw_Stock S (READUNCOMMITTED) ON DTL.StockCode = S.StockCode


  -- Update any BOM Lines with header data

  UPDATE BOMLine
     SET COSNominalCode = BOM.COSNominalCode
       , CurrencyId     = BOM.CurrencyId
       , IsBOM          = @c_True
  FROM #TLDATA BOMLine
  JOIN #TLDATA BOM ON BOMLine.OurReference = BOM.OurReference
                  AND BOMLine.SOPABSLineNo = BOM.TransactionLineNo
  WHERE BOMLine.TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
  AND   BOMLine.DisplayLineNo    = -1
  AND   BOMLine.CostPrice       <> 0.0
  AND   BOMLine.B2BLineNo       <> 1

  IF OBJECT_ID('tempdb..#StockValDETAILS') IS NOT NULL
     DROP TABLE #StockValDETAILS

  -- Create data to be inserted into DETAILS

  CREATE TABLE #StockValDETAILS
        ( RunNo                INT
        , NominalCode          INT
        , NominalMode          INT
        , CurrencyCode         INT
        , ExchequerYear        INT
        , TransactionPeriod    INT
        , TransactionPeriodKey INT
        , DepartmentCode       VARCHAR(3)
        , CostCentreCode       VARCHAR(3)
        , CompanyRate          FLOAT
        , DailyRate            FLOAT
        , NetValue             FLOAT
        , Discount             FLOAT
        , OurReference         VARCHAR(10)
        , LineDescription      VARCHAR(60)
        , PreviousBalance      FLOAT

        , ProcessOrder         INT NULL
        , StockValDetailId     INT IDENTITY(1,1) PRIMARY KEY
        )

  INSERT INTO #StockValDETAILS
        ( RunNo                
        , NominalCode          
        , NominalMode          
        , CurrencyCode         
        , ExchequerYear        
        , TransactionPeriod    
        , TransactionPeriodKey 
        , DepartmentCode       
        , CostCentreCode       
        , CompanyRate          
        , DailyRate            
        , NetValue             
        , Discount             
        , OurReference         
        , LineDescription      
        , PreviousBalance      
        )
  SELECT RunNo                  = @iv_RunNo
       , StockNominalCode
       , NominalMode            = MAX(TL.NominalMode)
       , C.CurrencyCode
       , TL.ExchequerYear
       , TL.TransactionPeriod
       , TL.TransactionPeriodKey
       , TL.DepartmentCode
       , TL.CostCentreCode
       , CompanyRate            = Rates.CompanyRate
       , DailyRate              = Rates.DailyRate
       , NetValue               = SUM( CASE
                                       WHEN C.CurrencyCode = 0 THEN CASE
                                                                    WHEN CTot.AmountInBase > 0 THEN ABS(CTot.AmountInBase)
                                                                    ELSE 0
                                                                    END
                                       ELSE CASE
                                            WHEN CTot.Amount > 0 THEN ABS(CTot.Amount)
                                            ELSE 0
                                            END
                                       END
                                     )
       , Discount               = SUM( CASE
                                       WHEN C.CurrencyCode = 0 THEN CASE
                                                                    WHEN CTot.AmountInBase < 0 THEN ABS(CTot.AmountInBase)
                                                                    ELSE 0
                                                                    END
                                       ELSE CASE
                                            WHEN CTot.Amount < 0 THEN ABS(CTot.Amount)
                                            ELSE 0
                                            END
                                       END
                                     )
       , TLD.OurReference
       , LineDescription         = (TLD.LineDescription)
       , PreviousBalance         = MAX(ISNULL(PB.BalanceAmount, 0))

  FROM   #TLData TL 
  CROSS APPLY ( SELECT LineDescription = CASE
                                         WHEN @iv_SeparateControl = @c_True THEN TL.OurReference + ' - Stock movement valuation'
                                         ELSE 'Stock movement valuation'
                                         END
                     , OurReference    = CASE
                                         WHEN @iv_SeparateControl = @c_True THEN TL.OurReference
                                         ELSE ''
                                         END
              ) TLD

  JOIN   [!ActiveSchema!].CURRENCY C ON  C.CurrencyCode IN (0, TL.CurrencyId)

  CROSS APPLY ( SELECT CompanyRate = CASE
                                     WHEN C.CurrencyCode = 0 THEN C.CompanyRate
                                     ELSE TL.CompanyRate
                                     END
                     , DailyRate   = CASE
                                     WHEN C.CurrencyCode = 0 THEN C.DailyRate
                                     ELSE TL.DailyRate
                                     END
              ) Rates

  CROSS APPLY ( SELECT Amount       = common.efn_ConvertToReal48(
                                      CASE
                                      WHEN TL.StockType = 'M' AND TL.B2BLineNo <> 1 AND TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
                                      THEN (TL.LineCost / TL.LineQuantity) * TL.StockMovementQuantity * TransactionTypeSign
                                      ELSE TL.LineCost * TransactionTypeSign
                                      END
                                      )
                     , AmountInBase = common.efn_ConvertToReal48(
                                      CASE
                                      WHEN TL.StockType = 'M' AND TL.B2BLineNo <> 1 AND TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
                                      THEN (TL.LineCostInBase / TL.LineQuantity) * TL.StockMovementQuantity * TransactionTypeSign
                                      ELSE TL.LineCostInBase * TransactionTypeSign
                                      END
                                      )
              ) CTot 
  OUTER APPLY ( SELECT BalanceAmount
                FROM   [!ActiveSchema!].evw_NominalHistory PBal
                WHERE  PBal.HistoryCode               = [common].efn_CreateNominalHistoryCode(StockNominalCode, NULL, NULL, NULL, 0)
                AND    PBal.CurrencyCode              = C.CurrencyCode
                AND    PBAL.HistoryClassificationCode IN ('A','B','C')
                AND    PBal.HistoryPeriodKey          = CASE 
                                                        WHEN C.CurrencyCode = @c_BaseCurrencyId THEN (TransactionYear * 1000) + CASE
                                                                                                                                WHEN PBal.HistoryClassificationCode = 'A' THEN @c_YTDPeriod
                                                                                                                                ELSE @c_CTDPeriod
                                                                                                                                END
                                                        ELSE TransactionPeriodKey
                                                        END
              ) PB
  WHERE ( TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
     OR   ( TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PCR','PIN','PQU','POR','PDN','PBT') 
       --AND  CostPrice <> 0
       AND  @ss_AutoPostUplift = @c_True
          )
        )

  GROUP BY TLD.OurReference
         , TLD.LineDescription
         , TL.StockNominalCode
         , C.CurrencyCode
         , TL.ExchequerYear
         , TL.TransactionPeriod
         , TL.TransactionPeriodKey
         , TL.CostCentrecode
         , TL.DepartmentCode
         , Rates.CompanyRate
         , Rates.DailyRate
  UNION
  SELECT RunNo                  = @iv_RunNo
       , TL.COSNominalCode
       , NominalMode            = MAX(TL.NominalMode)
       , C.CurrencyCode
       , TL.ExchequerYear
       , TL.TransactionPeriod
       , TL.TransactionPeriodKey
       , TL.DepartmentCode
       , TL.CostCentreCode
       , CompanyRate            = Rates.CompanyRate
       , DailyRate              = Rates.DailyRate
       , NetValue               = SUM( CASE
                                       WHEN C.CurrencyCode = 0 THEN CASE
                                                                    WHEN CTot.AmountInBase > 0 THEN ABS(CTot.AmountInBase)
                                                                    ELSE 0
                                                                    END
                                       ELSE CASE
                                            WHEN CTot.Amount > 0 THEN ABS(CTot.Amount)
                                            ELSE 0
                                            END
                                       END
                                     )
       , Discount               = SUM( CASE
                                       WHEN C.CurrencyCode = 0 THEN CASE
                                                                    WHEN CTot.AmountInBase < 0 THEN ABS(CTot.AmountInBase)
                                                                    ELSE 0
                                                                    END
                                       ELSE CASE
                                            WHEN CTot.Amount < 0 THEN ABS(CTot.Amount)
                                            ELSE 0
                                            END
                                       END
                                     )
       , TLD.OurReference
       , LineDescription         = (TLD.LineDescription)
       , PreviousBalance         = MAX(ISNULL(PB.BalanceAmount, 0))

  FROM   #TLData TL
  CROSS APPLY ( SELECT LineDescription = CASE
                                         WHEN @iv_SeparateControl = @c_True THEN TL.OurReference + ' - Stock movement valuation'
                                         ELSE 'Stock movement valuation'
                                         END
                     , OurReference    = CASE
                                         WHEN @iv_SeparateControl = @c_True THEN TL.OurReference
                                         ELSE ''
                                         END
              ) TLD

  JOIN   [!ActiveSchema!].CURRENCY C ON  C.CurrencyCode IN (0, TL.CurrencyId)

  CROSS APPLY ( SELECT CompanyRate = CASE
                                     WHEN C.CurrencyCode = 0 THEN C.CompanyRate
                                     ELSE TL.CompanyRate
                                     END
                     , DailyRate   = CASE
                                     WHEN C.CurrencyCode = 0 THEN C.DailyRate
                                     ELSE TL.DailyRate
                                     END
              ) Rates

  CROSS APPLY ( SELECT Amount       = common.efn_ConvertToReal48(
                                      CASE
                                      WHEN TL.StockType = 'M' AND TL.B2BLineNo <> 1 AND TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
                                      THEN (TL.LineCost / TL.LineQuantity) * TL.StockMovementQuantity * TransactionTypeSign * -1
                                      ELSE TL.LineCost * TransactionTypeSign * -1
                                      END
                                      )
                     , AmountInBase = common.efn_ConvertToReal48(
                                      CASE
                                      WHEN TL.StockType = 'M' AND TL.B2BLineNo <> 1 AND TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
                                      THEN (TL.LineCostInBase / TL.LineQuantity) * TL.StockMovementQuantity * TransactionTypeSign * -1
                                      ELSE TL.LineCostInBase * TransactionTypeSign * -1
                                      END
                                      )
              ) CTot 

  OUTER APPLY ( SELECT BalanceAmount
                FROM   [!ActiveSchema!].evw_NominalHistory PBal
                WHERE  PBal.HistoryCode               = [common].efn_CreateNominalHistoryCode(TL.COSNominalCode, NULL, NULL, NULL, 0)
                AND    PBal.CurrencyCode              = C.CurrencyCode
                AND    PBAL.HistoryClassificationCode IN ('A','B','C')
                AND    PBal.HistoryPeriodKey          = CASE 
                                                        WHEN C.CurrencyCode = @c_BaseCurrencyId THEN (TransactionYear * 1000) + CASE
                                                                                                                                WHEN PBal.HistoryClassificationCode = 'A' THEN @c_YTDPeriod
                                                                                                                                ELSE @c_CTDPeriod
                                                                                                                                END
                                                        ELSE TransactionPeriodKey
                                                        END
              ) PB
  WHERE ( TransactionTypeCode IN ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOR','SDN','SBT')
     OR   ( TransactionTypeCode IN ('PIN','PPY','PCR','PJI','PJC','PCR','PIN','PQU','POR','PDN','PBT') 
       --AND  CostPrice <> 0
       AND  @ss_AutoPostUplift = @c_True
          )
        )

  GROUP BY TLD.OurReference
         , TLD.LineDescription
         , TL.COSNominalCode
         , C.CurrencyCode
         , TL.ExchequerYear
         , TL.TransactionPeriod
         , TL.TransactionPeriodKey
         , TL.CostCentrecode
         , TL.DepartmentCode
         , Rates.CompanyRate
         , Rates.DailyRate

  -- Create Temp. index on temp table
  CREATE NONCLUSTERED INDEX idx_tmp ON #StockValDETAILS (OurReference, TransactionPeriodKey, NominalCode DESC, CurrencyCode DESC)

  -- Update process Order
  UPDATE SVD
     SET ProcessOrder = NewOrder.ProcessOrder
  FROM #StockValDETAILS SVD
  JOIN (SELECT StockValDetailId
             , ProcessOrder = ROW_NUMBER() OVER (ORDER BY OurReference
                                                        , TransactionPeriodKey
                                                        , NominalCode DESC
                                                        , CurrencyCode DESC
                                                )
        FROM #StockValDETAILS
       ) NewOrder ON SVD.StockValDetailId = NewOrder.StockValDetailId

  INSERT INTO [!ActiveSchema!].DETAILS
       ( tlFolioNum
       , tlLineNo
       , tlRunNo
       , tlGLCode
       , tlNominalMode
       , tlCurrency
       , tlYear
       , tlPeriod
       , tlDepartment
       , tlCostCentre
       , tlStockCode
       , tlABSLineNo
       , tlLineType
       , tlDocType
       , tlDLLUpdate
       , tlOldSerialQty
       , tlQty
       , tlQtyMul
       , tlNetValue
       , tlDiscount
       , tlVATCode
       , tlVATAmount
       , tlPaymentCode
       , tlOldPBal
       , tlRecStatus
       , tlDiscFlag
       , tlQtyWOFF
       , tlQtyDel
       , tlCost
       , tlAcCode
       , tlLineDate
       , tlItemNo
       , tlDescription
       , tlJobCode
       , tlAnalysisCode
       , tlCompanyRate
       , tlDailyRate
       , tlUnitWeight
       , tlStockDeductQty
       , tlBOMKitLink
       , tlSOPFolioNum
       , tlSOPABSLineNo
       , tlLocation
       , tlQtyPicked
       , tlQtyPickedWO
       , tlUsePack
       , tlSerialQty
       , tlCOSNomCode
       , tlOurRef
       , tlDocLTLink
       , tlPrxPack
       , tlQtyPack
       , tlReconciliationDate
       , tlShowCase
       , tlSdbFolio
       , tlOriginalBaseValue
       , tlUseOriginalRates
       , tlUserField1
       , tlUserField2
       , tlUserField3
       , tlUserField4
       , tlSSDUpliftPerc
       , tlSSDCountry
       , tlInclusiveVATCode
       , tlSSDCommodCode
       , tlSSDSalesUnit
       , tlPriceMultiplier
       , tlB2BLinkFolio
       , tlB2BLineNo
       , tlTriRates
       , tlTriEuro
       , tlTriInvert
       , tlTriFloat
       , tlSpare1
       , tlSSDUseLineValues
       , tlPreviousBalance
       , tlLiveUplift
       , tlCOSDailyRate
       , tlVATIncValue
       , tlLineSource
       , tlCISRateCode
       , tlCISRate
       , tlCostApport
       , tlNOMIOFlag
       , tlBinQty
       , tlCISAdjustment
       , tlDeductionType
       , tlSerialReturnQty
       , tlBinReturnQty
       , tlDiscount2
       , tlDiscount2Chr
       , tlDiscount3
       , tlDiscount3Chr
       , tlDiscount3Type
       , tlECService
       , tlServiceStartDate
       , tlServiceEndDate
       , tlECSalesTaxReported
       , tlPurchaseServiceTax
       , tlReference
       , tlReceiptNo
       , tlFromPostCode
       , tlToPostCode
       , tlUserField5
       , tlUserField6
       , tlUserField7
       , tlUserField8
       , tlUserField9
       , tlUserField10
       , tlThresholdCode
       , tlMaterialsOnlyRetention
       , tlIntrastatNoTC
       , tlTaxRegion
       )
  SELECT FolioNumber            = 0
       , DisplayLineNo          = 0
       , SVD.RunNo
       , SVD.NominalCode
       , SVD.NominalMode
       , SVD.CurrencyCode
       , SVD.ExchequerYear
       , SVD.TransactionPeriod
       , SVD.DepartmentCode
       , SVD.CostCentreCode
       , tlStockCode            = CONVERT(VARBINARY(21), 0x000000000000000000000000000000000000000000)
       , TransactionLineNo      = 0
       , LineType               = ''
       , DocumentType           = 31
       , DLLUpdate              = 0
       , OldSerialQty           = 0 
       , LineQuantity           = 1
       , QuantityMultiplier     = 0
       , NetValue               = SVD.NetValue
       , Discount               = SVD.Discount
       , VATCode                = ''
       , VATAmount              = 0
       , PaymentCode            = ISNULL( (SELECT PaymentType FROM [common].evw_TransactionType TT WHERE TT.TransactionTypeId = 31) , '')
       , OldPBal                = 0
       , RecStatus              = 0
       , DiscFlag               = ''
       , QuantityWOFF           = 0
       , QuantityDelivered      = 0
       , Cost                   = 0
       , TraderCode             = ''
       , LineDate               = RIGHT(SPACE(8) + CONVERT(VARCHAR(8), SVD.RunNo), 8)
       , ItemNo                 = ''
       , Description            = SVD.LineDescription
       , JobCode                = ''
       , AnalysisCode           = ''
       , SVD.CompanyRate
       , SVD.DailyRate
       , UnitWeight             = 0
       , StockDeductQty         = 0
       , BOMKitLink             = 0
       , SOPFolioNum            = 0
       , SOPLineNo              = 0
       , LocationCode           = ''
       , QuantityPicked         = 0
       , QuantityPickedWriteOff = 0
       , UsePack                = 0
       , SerialQty              = 0
       , COSNomCode             = 0
       , SVD.OurReference
       , DocLTLink              = 0
       , PricePerPack           = 0
       , QtyPack                = 0
       , ReconciliationDate     = CONVERT(VARCHAR(8), GETDATE(), 112)
       , ShowCase               = 0
       , SdbFolio               = 0
       , OriginalBaseValue      = 0
       , UseOriginalRates       = 0
       , UserField1             = ''
       , UserField2             = ''
       , UserField3             = ''
       , UserField4             = ''
       , SSDUpliftPerc          = 0
       , SSDCountry             = ''
       , IncVATCode             = ''
       , SSDCommodCode          = ''
       , SSDSalesUnit           = 0
       , PriceMultiplier        = 0
       , B2BLinkFolio           = 0
       , B2BLineNo              = 0
       , TriRate                = 0
       , TriEuro                = 0
       , TriInvert              = 0
       , TriFloat               = 0
       , Spare1                 = CONVERT(VARBINARY(10), 0x00000000000000000000)
       , SSDUseLineValues       = 0
       , PreviousBalance        = SVD.PreviousBalance
       , LiveUplift             = 0
       , COSDailyRate           = 0
       , VATIncValue            = 0
       , LineSource             = 0
       , CISRateCode            = ''
       , CISRate                = 0
       , CostApportionment      = 0
       , NOMIOFlag              = 0
       , BinQuantity            = 0
       , CISAdjustment          = 0
       , DeductionType          = 0
       , SerialReturnQty        = 0
       , BinReturnQty           = 0
       , Discount2              = 0
       , DiscountFlag2          = ''
       , Discount3              = 0
       , DiscountFlag3          = ''
       , Discount3Type          = 0
       , ECService              = 0
       , ServiceStartDate       = ''
       , ServiceEndDate         = ''
       , ECSalesTaxReported     = 0
       , PurchaseServiceTax     = 0
       , Reference              = ''
       , ReceiptNo              = ''
       , FromPostCode           = ''
       , ToPostCode             = ''
       , UserField5             = ''
       , UserField6             = ''
       , UserField7             = ''
       , UserField8             = ''
       , UserField9             = ''
       , UserField10            = ''
       , ThresholdCode          = ''
       , MaterialsOnlyRetention = 0
       , IntrastatNoTC          = ''
       , TaxRegion              = 0
     
  FROM #StockValDETAILS SVD
  WHERE ROUND(SVD.NetValue, 2) <> 0 
  OR    ROUND(SVD.Discount, 2) <> 0

  ORDER BY ProcessOrder

END
GO


