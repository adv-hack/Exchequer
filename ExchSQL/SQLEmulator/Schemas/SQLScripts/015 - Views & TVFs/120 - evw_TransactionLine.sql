IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TransactionLine]'))
DROP VIEW [!ActiveSchema!].[evw_TransactionLine]
GO

CREATE VIEW [!ActiveSchema!].[evw_TransactionLine]
AS
SELECT LinePositionId       = DTL.PositionId
     , LineFolioNumber      = DTL.tlFolioNum
     , TransactionLineNo    = DTL.tlABSLineNo
     , DisplayLineNo        = DTL.tlLineNo
     , RunNo                = DTL.tlRunNo
     , TransactionLineDate  = DTL.tlLineDate
     , ExchequerYear        = DTL.tlYear
     , TransactionYear      = DTL.tlYear + 1900
     , TransactionPeriod    = DTL.tlPeriod
     , TransactionPeriodKey = ((DTL.tlYear + 1900) * 1000) + DTL.tlPeriod

     /* The following 2 fields should really be taken from Header thRunNo */

     , PS.IsPosted
     , PS.PostingStatus
     , OurReference         = DTL.tlOurRef
     , LineDescription      = DTL.tlDescription
     , LineType             = DTL.tlLineType

     , TT.TransactionTypeId
     , TT.TransactionTypeCode
     , TT.TransactionTypeDescription
     , TT.TransactionTypeSign

     , IsSalesTransaction    = CONVERT(BIT, CASE
                                            WHEN TT.ParentTransactionTypeId = 100 THEN 1
                                            ELSE 0
                                            END)
     , IsPurchaseTransaction = CONVERT(BIT, CASE
                                            WHEN TT.ParentTransactionTypeId = 101 THEN 1
                                            ELSE 0
                                            END)

     , JobCode           = DTL.tlJobCode
     , AnalysisCode      = DTL.tlAnalysisCode
     , TraderCode        = DTL.tlAcCode      COLLATE SQL_Latin1_General_CP1_CI_AS
     , NominalCode       = DTL.tlGLCode
     , CostCentreCode    = DTL.tlCostCentre
     , DepartmentCode    = DTL.tlDepartment
     , LocationCode      = DTL.tlLocation

     , StockCode         = CASE
                           WHEN DTL.tlDocType NOT IN (30, 31, 41, 1, 16)
                            AND   DTL.tlStockCodeComputed   <> 0x2020202020202020202000000000
                            AND   DTL.tlStockCodeComputed   <> 0x0000000000000000000000000000
                            AND   SUBSTRING(DTL.tlStockCodeComputed, 1, 1) NOT IN (CHAR(1), CHAR(2))
                           THEN LTRIM(RTRIM(CONVERT(VARCHAR(50), SUBSTRING(DTL.tlStockCodeComputed, 1 , 16))))
                           ELSE ''
                           END
     , IsStockMovementTransaction = CONVERT(BIT, 
                                            CASE
                                            WHEN DTL.tlDocType NOT IN (30, 31, 41, 1, 16)
                                             AND DTL.tlStockCodeComputed   <> 0x2020202020202020202000000000
                                             AND DTL.tlStockCodeComputed   <> 0x0000000000000000000000000000
                                             AND SUBSTRING(DTL.tlStockCodeComputed, 1, 1) NOT IN (CHAR(1), CHAR(2))
                                            THEN 1
                                            ELSE 0
                                            END)
     , IsPayInLine        = CONVERT(BIT, CASE
                                         WHEN SUBSTRING(DTL.tlStockCodeComputed, 1, 1) IN (CHAR(1), CHAR(2)) THEN 1
                                         ELSE 0
                                         END
                                   )
     , PayInReference     = CASE
                            WHEN SUBSTRING(DTL.tlStockCodeComputed, 1, 1) IN (CHAR(1), CHAR(2)) 
                            THEN CASE
                                 WHEN PS.IsPosted = 0 THEN LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 2, 10))
                                 ELSE LTRIM(SUBSTRING(DTL.tlStockCodeComputed, 7, 10))
                                 END
                            ELSE ''
                            END

     , TT.StockMovementSign
     , CTR48.StockMovementQuantity

     , PaymentCode        = DTL.tlPaymentCode
     , CurrencyId         = DTL.tlCurrency
     , VATCode            = DTL.tlVATCode
     , InclusiveVATCode   = DTL.tlInclusiveVATCode

     , UseOriginalRates   = DTL.tlUseOriginalRates

     , Discount           = DTL.tlDiscount
     , DiscountFlag       = DTL.tlDiscFlag
     , Discount2          = DTL.tlDiscount2
     , DiscountFlag2      = DTL.tlDiscount2Chr
     , Discount3          = DTL.tlDiscount3
     , DiscountFlag3      = DTL.tlDiscount3Chr 

     , CTR48.ConversionRate
     , CTR48.COSConversionRate
     , CTR48.CompanyRate
     , CTR48.DailyRate
     , CTR48.VATDailyRate
     
     , SS.NoOfDPNet
     , SS.NoOfDPCost
     , QtyDP.NoOfDP
     , QtyDP.NoOfDPQuantity
     
     , Results.LineQuantity
     , Qtys.LinePackQuantity
     , Qtys.LineQuantityMultiplier
     , Qtys.LineQuantityOutstanding
     , Qtys.LineQuantityOutstandingExcDelivered
     , CTR48.QuantityDelivered
     , CTR48.QuantityWrittenOff
     , CTR48.QuantityPicked
     , CTR48.QuantityPickedWriteOff

     , Results.PricePerUnit
     , Results.VATPerUnit
     , Results.DiscountPerUnit
     , Results.CostPerUnit
     
     , Results.LineNetValue
     , ResultsInBase.LineNetValueInBase
     , Results.LineDiscount
     , ResultsInBase.LineDiscountInBase
     , Results.LineCalculatedNetValue
     , ResultsInBase.LineCalculatedNetValueInBase
     , Results.LineVAT
     , ResultsInBase.LineVATInBase
     , Results.LineGrossValue
     , ResultsInBase.LineGrossValueInBase
     , Results.LineCost
     , ResultsInBase.LineCostInBase
     , Results.LineCostApportioned
     , ResultsInBase.LineCostApportionedInBase

     , Results.LineCalculatedNetValueOutstanding
     , ResultsInBase.LineCalculatedNetValueoutstandingInBase
     , Results.LineGrossValueOutstanding
     , ResultsInBase.LineGrossValueOutstandingInBase

     , UDF1Value            = DTL.tlUserField1
     , UDF2Value            = DTL.tlUserField2
     , UDF3Value            = DTL.tlUserField3
     , UDF4Value            = DTL.tlUserField4
     , UDF5Value            = DTL.tlUserField5  
     , UDF6Value            = DTL.tlUserField6
     , UDF7Value            = DTL.tlUserField7
     , UDF8Value            = DTL.tlUserField8
     , UDF9Value            = DTL.tlUserField9
     , UDF10Value           = DTL.tlUserField10

FROM   !ActiveSchema!.DETAILS DTL
--JOIN   !ActiveSchema!.DOCUMENT DOC ON DTL.tlFolioNum = DOC.thFolioNum

LEFT JOIN common.evw_TransactionType TT ON TT.TransactionTypeId = DTL.tlDocType
LEFT JOIN !ActiveSchema!.CURRENCY C ON DTL.tlCurrency = C.CurrencyCode
CROSS APPLY !ActiveSchema!.evw_SystemSettings SS

     /* The following 2 fields should really be taken from Header thRunNo */
CROSS APPLY ( SELECT IsPosted             = CONVERT(BIT, CASE
                                                         WHEN DTL.tlRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                                         ELSE 1
                                                         END)
                   , PostingStatus        = CONVERT(NVARCHAR, CASE
                                                              WHEN DTL.tlRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 'Not Posted'
                                                              ELSE 'Posted'
                                                              END)
            ) PS

CROSS APPLY ( VALUES ( ( ((DTL.tlYear + 1900) * 1000) + DTL.tlPeriod
                       )
                     )
            ) TPK ( TransactionPeriodKey)

CROSS APPLY ( VALUES ( (
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND tlDailyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND UseCompanyRate = 1 THEN tlDailyRate
                        WHEN tlCompanyRate = 0 THEN 1
                        ELSE tlCompanyRate
                        END
                       )
                     , (
                        CASE 
                        WHEN CurrencyCode NOT IN (0, 1) AND tlDailyRate = 0 AND tlCompanyRate = 0 AND UseCompanyRate = 0 THEN C.DailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlDailyRate = 0 AND UseCompanyRate = 0 THEN tlCompanyRate
                        WHEN tlDailyRate = 0 THEN 1
                        ELSE tlDailyRate
                        END
                       )
                     , (tlDailyRate)
                     , (
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND tlCOSDailyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND UseCompanyRate = 1 THEN tlCOSDailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCOSDailyRate = 0 AND tlCompanyRate = 0 AND UseCompanyRate = 0 THEN C.DailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCOSDailyRate = 0 AND UseCompanyRate = 0 THEN tlCompanyRate
                        WHEN UseCompanyRate = 1 THEN CASE 
                                                     WHEN tlCompanyRate = 0 THEN 1
                                                     ELSE tlCompanyRate
                                                     END
                        WHEN UseCompanyRate = 0 THEN CASE 
                                                     WHEN tlCOSDailyRate = 0 THEN 1
                                                     ELSE tlCOSDailyRate
                                                     END
                        ELSE 1
                        END
                       )
                     , (
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND tlDailyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN currencyCode NOT IN (0, 1) AND tlCompanyRate = 0 AND UseCompanyRate = 1 THEN tlDailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlDailyRate = 0 AND tlCompanyRate = 0 AND UseCompanyRate = 0 THEN C.DailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND tlDailyRate = 0 AND UseCompanyRate = 0 THEN tlCompanyRate
                        WHEN UseCompanyRate = 1 THEN CASE 
                                                     WHEN tlCompanyRate = 0 THEN 1
                                                     ELSE tlCompanyRate
                                                     END
                        WHEN UseCompanyRate = 0 THEN CASE 
                                                     WHEN tlDailyRate = 0 THEN 1
                                                     ELSE tlDailyRate
                                                     END
                        ELSE 1
                        END
                      )
                    )
            ) Rates ( CompanyRate
                    , DailyRate
                    , VATDailyRate
                    , COSConversionRate
                    , ConversionRate
                    )

CROSS APPLY ( VALUES ( ( CASE
                         WHEN TT.ParentTransactionTypeId = 100 THEN SS.NoOfDPNet
                         --WHEN TT.ParentTransactionTypeId = 101 THEN SS.NoOfDPCost
                         ELSE SS.NoOfDPcost
                         END
                       )
                     , ( CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.tlQtyMul <> 0 AND DTL.tlShowCase = 1 THEN 12
                         ELSE SS.NoOfDPQuantity
                         END
                       )
                     ) 
             ) QtyDP ( NoOfDP
                     , NoOfDPQuantity)

-- The following CASE statements have been done for performance purposes

CROSS APPLY (SELECT Quantity               = CASE
                                             WHEN DTL.tlQty - FLOOR(DTL.tlQty) = 0 THEN DTL.tlQty
                                             ELSE common.efn_ConvertToReal48(DTL.tlQty)
                                             END
                  , QuantityMultiplier     = CASE
                                             WHEN DTL.tlQtyMul - FLOOR(DTL.tlQtyMul) = 0 THEN DTL.tlQtyMul
                                             ELSE common.efn_ConvertToReal48(DTL.tlQtyMul)
                                             END
                  , QuantityDelivered      = CASE
                                             WHEN DTL.tlQtyDel - FLOOR(DTL.tlQtyDel) = 0 THEN DTL.tlQtyDel
                                             ELSE common.efn_ConvertToReal48(DTL.tlQtyDel)
                                             END
                  , QuantityWrittenOff     = CASE
                                             WHEN DTL.tlQtyWOFF - FLOOR(DTL.tlQtyWOFF) = 0 THEN DTL.tlQtyWOFF
                                             ELSE common.efn_ConvertToReal48(DTL.tlQtyWOFF)
                                             END
                  , QuantityPicked         = CASE
                                             WHEN DTL.tlQtyPicked - FLOOR(DTL.tlQtyPicked) = 0 THEN DTL.tlQtyPicked
                                             ELSE common.efn_ConvertToReal48(DTL.tlQtyPicked)
                                             END
                  , QuantityPickedWriteOff = CASE
                                             WHEN DTL.tlQtyPickedWO - FLOOR(DTL.tlQtyPickedWO) = 0 THEN DTL.tlQtyPickedWO
                                             ELSE common.efn_ConvertToReal48(DTL.tlQtyPickedWO)
                                             END
                  , NetValue               = CASE
                                             WHEN DTL.tlNetValue - FLOOR(DTL.tlNetValue) = 0 THEN DTL.tlNetValue
                                             ELSE common.efn_ConvertToReal48(DTL.tlNetValue)
                                             END
                  , Cost                   = CASE
                                             WHEN DTL.tlCost - FLOOR(DTL.tlCost) = 0 THEN DTL.tlCost
                                             ELSE common.efn_ConvertToReal48(DTL.tlCost)
                                             END
                  , CostApportioned        = CASE
                                             WHEN DTL.tlCostApport - FLOOR(DTL.tlCostApport) = 0 THEN DTL.tlCostApport
                                             ELSE common.efn_ConvertToReal48(DTL.tlCostApport)
                                             END
                  , Discount               = CASE
                                             WHEN DTL.tlDiscount - FLOOR(DTL.tlDiscount) = 0 THEN DTL.tlDiscount
                                             ELSE common.efn_ConvertToReal48(DTL.tlDiscount)
                                             END
                  , Discount2              = CASE
                                             WHEN DTL.tlDiscount2 - FLOOR(DTL.tlDiscount2) = 0 THEN DTL.tlDiscount2
                                             ELSE common.efn_ConvertToReal48(DTL.tlDiscount2)
                                             END
                  , Discount3              = CASE
                                             WHEN DTL.tlDiscount3 - FLOOR(DTL.tlDiscount3) = 0 THEN DTL.tlDiscount3
                                             ELSE common.efn_ConvertToReal48(DTL.tlDiscount3)
                                             END
                  , CompanyRate            = CASE
                                             WHEN Rates.CompanyRate - FLOOR(Rates.CompanyRate) = 0 THEN Rates.CompanyRate
                                             ELSE common.efn_ConvertToReal48(Rates.CompanyRate)
                                             END
                  , DailyRate              = CASE
                                             WHEN Rates.DailyRate - FLOOR(Rates.DailyRate) = 0 THEN Rates.DailyRate
                                             ELSE common.efn_ConvertToReal48(Rates.DailyRate)
                                             END
                  , VATDailyRate           = CASE
                                             WHEN Rates.VATDailyRate - FLOOR(Rates.VATDailyRate) = 0 THEN Rates.VATDailyRate
                                             ELSE common.efn_ConvertToReal48(Rates.VATDailyRate)
                                             END
                  , COSConversionRate      = CASE
                                             WHEN Rates.COSConversionRate - FLOOR(Rates.COSConversionRate) = 0 THEN Rates.COSConversionRate
                                             ELSE common.efn_ConvertToReal48(Rates.COSConversionRate)
                                             END
                  , ConversionRate         = CASE
                                             WHEN Rates.ConversionRate - FLOOR(Rates.ConversionRate) = 0 THEN Rates.ConversionRate
                                             ELSE common.efn_ConvertToReal48(Rates.ConversionRate)
                                             END
                  , StockMovementQuantity  = CASE
                                             WHEN DTL.tlStockDeductQty - FLOOR(DTL.tlStockDeductQty) = 0 THEN DTL.tlStockDeductQty
                                             ELSE common.efn_ConvertToReal48(DTL.tlStockDeductQty)
                                             END
            ) CTR48 
CROSS APPLY ( VALUES ( ( CASE
                         WHEN DTL.tlPriceMultiplier <> 0 THEN NetValue * DTL.tlPriceMultiplier
                         ELSE NetValue
                         END
                       )
                     , ( tlVATAmount )
                     , ( CASE
                         WHEN UseDailyRate = 1 AND CTR48.DailyRate <> 0 THEN DTL.tlUseOriginalRates
                         WHEN UseCompanyRate = 1 AND CTR48.CompanyRate <> 0 THEN DTL.tlUseOriginalRates
                         ELSE 0
                         END
                       )
                     )
            ) Calc1 ( NetValue
                    , LineVAT
                    , UseDiscountOriginalRates )
CROSS APPLY ( VALUES ( ( CASE
                         WHEN DTL.tlUsePack = 1 THEN Quantity * QuantityMultiplier
                         ELSE Quantity
                         END
                       )
                     , ( DTL.tlQtyPack)
                     , ( QuantityMultiplier)
                     , ( CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.tlQtyMul <> 0 AND DTL.tlShowCase = 1
                         THEN common.efn_SafeDivide((Quantity - (QuantityDelivered + QuantityWrittenOff)), tlQtyPack)
                         ELSE (Quantity - (QuantityDelivered + QuantityWrittenOff))  * CASE
                                                                                       WHEN tlUsePack = 1 THEN QuantityMultiplier
                                                                                                          ELSE 1
                                                                                                          END
                         END )
                     , ( CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.tlQtyMul <> 0 AND DTL.tlShowCase = 1
                         THEN common.efn_SafeDivide((Quantity - (0 + QuantityWrittenOff)), tlQtyPack)
                         ELSE (Quantity - (0 + QuantityWrittenOff))  * CASE
                                                                       WHEN tlUsePack = 1 THEN QuantityMultiplier
                                                                       ELSE 1
                                                                       END
                         END )
                     )
            ) Qtys ( LineQuantity
                   , LinePackQuantity
                   , LineQuantityMultiplier
                   , LineQuantityOutstanding
                   , LineQuantityOutstandingExcDelivered
                   )

CROSS APPLY ( VALUES ( (
                         CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND DTL.tlQtyMul <> 0 
                         THEN CASE
                              WHEN DTL.tlShowCase = 1 THEN CTR48.Cost * DTL.tlQtyMul * tlQtyPack
                              ELSE CTR48.Cost * common.efn_SafeDivide(tlQtyMul, DTL.tlQtyPack)
                              END
                          ELSE CTR48.Cost
                          END
                       )
                     , ( 
                         CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND QuantityMultiplier <> 0 
                         THEN CASE
                              WHEN DTL.tlShowCase = 1 THEN Calc1.NetValue
                              ELSE Calc1.NetValue * common.efn_SafeDivide(QuantityMultiplier, DTL.tlQtyPack)
                              END
                         ELSE Calc1.NetValue
                         END
                         
                       )
                     , ( common.efn_SafeDivide(Calc1.LineVAT, Qtys.LineQuantity)
                       )
                     , ( common.efn_ExchequerRoundUp(
                         CASE
                         WHEN DTL.tlPrxPack = 1 AND DTL.tlQtyPack <> 0 AND QuantityMultiplier <> 0 AND DTL.tlShowCase = 1
                         THEN common.efn_SafeDivide(Qtys.LineQuantity, DTL.tlQtyPack)
                         ELSE Qtys.LineQuantity
                         END, QtyDP.NoOfDPQuantity)
                       ) 
                     )
            ) Calc2 ( CostPerUnit
                    , PricePerUnit
                    , VATPerUnit
                    , LineQuantity
                    )

CROSS APPLY ( VALUES ( ( common.efn_ConvertToReal48(
                         CASE
                         WHEN DTL.tlVATCode = 'M' AND DTL.tlVATIncValue <> 0 THEN DTL.tlVATIncValue
                         ELSE PricePerUnit
                         END)
                       )
                     , ( 0
                       )
                     , ( common.efn_ExchequerRoundUp(PricePerUnit , QtyDP.NoOfDP)
                       )
                     )
            ) Calc3 ( DiscountBasis
                    , DiscountPerUnit
                    , PricePerUnit
                    )
-- Apply Discounts 
CROSS APPLY ( VALUES ( ( CASE
                         WHEN ( CTR48.Discount  <> 0
                           OR   CTR48.Discount2 <> 0
                           OR   CTR48.Discount3 <> 0
                              ) THEN common.efn_CalculateDiscount( Calc1.NetValue
                                                                 , CTR48.Discount
                                                                 , DTL.tlDiscFlag
                                                                 , CTR48.Discount2
                                                                 , DTL.tlDiscount2Chr
                                                                 , CTR48.Discount3
                                                                 , DTL.tlDiscount3chr
                                                                 )
                         ELSE 0
                         END
                       )
                     )
            ) Discount (DiscountPerUnit)

-- Calculate Line Values
CROSS APPLY ( VALUES ( ( common.efn_ExchequerRoundUp(
                         ( Calc3.PricePerUnit * Calc2.LineQuantity), 2) 
                       )
                     , ( common.efn_ExchequerRoundUp(
                         ( ( Calc3.PricePerUnit - Discount.DiscountPerUnit )
                         * Calc2.LineQuantity
                         ), 2)
                       )
                     )
            ) LValue ( LineNetValue
                     , LineCalculatedNetValue)

CROSS APPLY ( VALUES ( (common.efn_ExchequerRoundUp((LValue.LineCalculatedNetValue - LValue.LineNetValue), 2) 
                        * CASE
                          WHEN DTL.tlPaymentCode = 'N' THEN -1
                          ELSE 1
                          END
                       )
                     )
            ) LDisc  ( LineDiscount )

CROSS APPLY ( VALUES ( (Calc3.PricePerUnit)
                     , (common.efn_ExchequerRoundUp(Calc2.VATPerUnit , QtyDP.NoOfDP))
                     , (Discount.DiscountPerUnit)
                     , (Calc2.CostPerUnit)
                     , (Calc2.LineQuantity)
                     , (LValue.LineNetValue)
                     , (Calc1.LineVAT)
                     , (LValue.LineCalculatedNetValue)
                     , (common.efn_ExchequerRoundUp(LValue.LineCalculatedNetValue + Calc1.LineVAT, QtyDP.NoOfDP) )
                     , (LDisc.LineDiscount)
                     , (common.efn_ExchequerRoundUp((Calc2.LineQuantity * Calc2.CostPerUnit), 2) )
                     , (common.efn_ExchequerRoundUp((Calc2.LineQuantity * CTR48.CostApportioned), 2) )
                     , (common.efn_ExchequerRoundUp((Calc3.PricePerUnit - Discount.DiscountPerUnit)
                                                    * common.efn_ExchequerRoundUp(Qtys.LineQuantityOutstanding, QtyDP.NoOfDPQuantity), 2))
                     , (common.efn_ExchequerRoundUp((Calc3.PricePerUnit - Discount.DiscountPerUnit + Calc2.VATPerUnit)
                                                    * common.efn_ExchequerRoundUp(Qtys.LineQuantityOutstanding, QtyDP.NoOfDPQuantity), 2) )
                     )
            ) Results ( PricePerUnit
                      , VATPerUnit
                      , DiscountPerUnit
                      , CostPerUnit
                      , LineQuantity
                      , LineNetValue
                      , LineVAT
                      , LineCalculatedNetValue
                      , LineGrossValue
                      , LineDiscount
                      , LineCost
                      , LineCostApportioned
                      , LineCalculatedNetValueOutstanding
                      , LineGrossValueOutstanding
                      )
-- Create Base Values
CROSS APPLY ( VALUES ( (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineNetValue
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineNetValue
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineVAT
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineVAT
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineCalculatedNetValue
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineCalculatedNetValue
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineGrossValue
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineGrossValue
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, QtyDP.NoOfDP)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineDiscount
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineDiscount
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , UseDiscountOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.COSConversionRate = 1 THEN Results.LineCost
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( (Calc2.LineQuantity * Calc2.CostPerUnit)
                                                                                         , CTR48.COSConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.COSConversionRate = 1 THEN Results.LineCostApportioned
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( (Calc2.LineQuantity * CTR48.CostApportioned)
                                                                                         , CTR48.COSConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineCalculatedNetValueoutstanding
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineCalculatedNetValueoutstanding
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, 2)
                       )
                     , (  common.efn_ExchequerRoundUp(CASE
                                                      WHEN CTR48.ConversionRate = 1 THEN Results.LineGrossValueOutstanding
                                                      ELSE
                                                      common.efn_ExchequerCurrencyConvert( Results.LineGrossValueOutstanding
                                                                                         , CTR48.ConversionRate
                                                                                         , tlCurrency
                                                                                         , tlUseOriginalRates
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                                                      END, QtyDP.NoOfDP)
                       )
                     )
             ) ResultsInBase ( LineNetValueInBase
                             , LineVATInBase
                             , LineCalculatedNetValueInBase
                             , LineGrossValueInBase
                             , LineDiscountInBase
                             , LineCostInBase
                             , LineCostApportionedInBase
                             , LineCalculatedNetValueOutstandingInBase
                             , LineGrossValueOutstandingInBase
                             )
GO


