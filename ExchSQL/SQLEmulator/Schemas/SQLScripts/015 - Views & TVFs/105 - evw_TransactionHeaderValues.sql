IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TransactionHeaderValues]'))
DROP VIEW [!ActiveSchema!].[evw_TransactionHeaderValues]
GO

CREATE VIEW !ActiveSchema!.evw_TransactionHeaderValues
AS
SELECT HeaderPositionId            = PositionId
     , Rates.CompanyRate
     , Rates.DailyRate
     , Rates.ConversionRate
     , IsInverted                  = C.TriInverted
     , IsFloating                  = C.IsFloating
     , CurrencyTriRate             = C.TriRate

     , TotalNetValue               = common.efn_ExchequerRoundUp(CTR48.TotalNetValue , 2)
     , TotalDiscount               = common.efn_ExchequerRoundUp(CTR48.TotalDiscount , 2)
     , TotalVAT                    = common.efn_ExchequerRoundUp(CTR48.TotalVAT, 2)
     , TotalGrossValue             = common.efn_ExchequerRoundUp(CTR48.TotalNetValue
                                                               - CTR48.TotalDiscount
                                                               + CTR48.TotalVAT, 2)
     , TotalCalculatedNetValue     =  ( common.efn_ExchequerRoundUp(TotalNetValue, 2)
                                      - common.efn_ExchequerRoundUp(TotalDiscount, 2)
                                      - ( common.efn_ExchequerRoundUp(SettlementDiscountAmount, 2) 
                                        * thSettleDiscTaken
                                        )
                                      )

     , TotalCost
     , TotalInvoiced               = common.efn_ExchequerRoundUp(thTotalInvoiced, 2)
     , TotalCurrencySettled        = common.efn_ExchequerRoundUp(TotalCurrencySettled, 2)
     , TotalOrdered                = common.efn_ExchequerRoundUp(thTotalOrdered, 2)
     , TotalOrderOutstanding       = common.efn_ExchequerRoundUp(thTotalOrderOS, 2)
     , TotalReserved               = common.efn_ExchequerRoundUp(thTotalReserved, 2)
     , SettleDiscountAmount        = common.efn_ExchequerRoundUp(SettlementDiscountAmount, 2)

     --Base Values
     , TotalSettledInBase          = common.efn_ExchequerRoundUp(thAmountSettled, 2)
     , RevaluationAdjustmentInBase = common.efn_ExchequerRoundUp(thRevalueAdj, 2)
     , VarianceAmountInBase        = common.efn_ExchequerRoundUp(thVariance, 2)
     , PostedDiscountAmountInBase  = common.efn_ExchequerRoundUp(PostDiscAm, 2)

     , TotalNetValueInBase         = common.efn_ExchequerRoundUp(TotalNetValueInBase, 2)
     , TotalVATInBase              = common.efn_ExchequerRoundUp(TotalVATInBase, 2)
     , TotalDiscountInBase         = common.efn_ExchequerRoundUp(TotalDiscountInBase, 2)
     , TotalGrossValueInBase       = common.efn_ExchequerRoundUp(TotalNetValueInBase
                                                               + TotalVATInBase
                                                               - TotalDiscountInBase, 2)
     , TotalCalculatedNetValueInBase = common.efn_ExchequerRoundUp( ( TotalNetValueInBase 
                                              - TotalDiscountInBase
                                              - ( SettlementDiscountAmountInBase
                                                * thSettleDiscTaken
                                                )
                                              ), 2)
     , TotalCostInBase             = common.efn_ExchequerRoundUp(TotalCostInBase, 2)
     , SettleDiscountAmountInBase  = common.efn_ExchequerRoundUp(SettlementDiscountAmountInBase , 2)
     , TotalOrderOutstandingInBase = CASE
                                     WHEN UseCompanyRate = 1 THEN
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( thTotalOrderOS
                                                                              , ConversionRate
                                                                              , thCurrency
                                                                              , 0
                                                                              , 0
                                                                              , C.TriRate
                                                                              , C.TriInverted
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating) , 2)
                                     ELSE
                                     common.efn_ExchequerRoundUp(common.efn_ExchequerCurrencyConvert( thTotalOrderOS
                                                                              , C.DailyRate
                                                                              , thCurrency
                                                                              , 0
                                                                              , 0
                                                                              , C.TriRate
                                                                              , C.TriInverted
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating) , 2)
                                     END
     , TransactionTotal            = common.efn_ExchequerRoundUp(TransactionTotal, 2)
                                   
     , TransactionTotalInBase      = common.efn_ExchequerRoundUp(TotalNetValueInBase, 2)
                                   + common.efn_ExchequerRoundUp(TotalVATInBase, 2)
                                   - common.efn_ExchequerRoundUp(TotalDiscountInBase, 2)
                                   + common.efn_ExchequerRoundUp(thRevalueAdj, 2)
                                   + common.efn_ExchequerRoundUp(thVariance, 2)
                                   - (common.efn_ExchequerRoundUp(SettlementDiscountAmountInBase * thSettleDiscTaken, 2))
                                   + common.efn_ExchequerRoundUp(PostDiscAm, 2)

     , TotalOutstandingAmount       = common.efn_ExchequerRoundUp(TotalOutstandingAmount, 2)
     , TotalOutstandingAmountInBase = common.efn_ExchequerRoundUp(TotalOutstandingAmountInBase, 2)

FROM   !ActiveSchema!.DOCUMENT HDR
JOIN common.evw_TransactionType TT ON HDR.thDocType = TT.TransactionTypeId

LEFT JOIN !ActiveSchema!.CURRENCY C ON HDR.thCurrency = C.CurrencyCode
CROSS JOIN !ActiveSchema!.evw_SystemSettings SS

CROSS APPLY ( VALUES ( (common.efn_ConvertToReal48( 
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND thCompanyRate = 0 AND thDailyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND thCompanyRate = 0 AND UseCompanyRate = 1 THEN thDailyRate
                        WHEN thCompanyRate = 0 THEN 1
                        ELSE thCompanyRate
                        END)
                       )
                     , (common.efn_ConvertToReal48( 
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND thDailyRate = 0 AND thCompanyRate = 0 AND UseCompanyRate = 0 THEN C.DailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND thDailyRate = 0 AND UseCompanyRate = 0 THEN thCompanyRate
                        WHEN thDailyRate = 0 THEN 1
                        ELSE thDailyRate
                        END)
                       )
                     , (common.efn_ConvertToReal48( 
                        CASE
                        WHEN thUseOriginalRates = 1 THEN thOriginalDailyRate
                        ELSE thDailyRate
                        END)
                       )
                     , (common.efn_ConvertToReal48(
                        CASE
                        WHEN CurrencyCode NOT IN (0, 1) AND thCompanyRate = 0 AND thDailyRate = 0 AND UseCompanyRate = 1 THEN C.CompanyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND thCompanyRate = 0 AND UseCompanyRate = 1 THEN thDailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND thDailyRate = 0 AND thCompanyRate = 0 AND UseCompanyRate = 0   THEN C.DailyRate
                        WHEN CurrencyCode NOT IN (0, 1) AND thDailyRate = 0 AND UseCompanyRate = 0   THEN thCompanyRate
                        WHEN UseCompanyRate = 1 THEN CASE 
                                                     WHEN thCompanyRate = 0 THEN 1
                                                     ELSE thCompanyRate
                                                     END
                        WHEN UseCompanyRate = 0 THEN CASE 
                                                     WHEN thDailyRate = 0 THEN 1
                                                     ELSE thDailyRate
                                                     END
                        ELSE 1
                        END)
                       )
                     )
            ) Rates ( CompanyRate
                    , DailyRate
                    , VATDailyRate
                    , ConversionRate
                    )
CROSS APPLY ( VALUES ( (common.efn_ConvertToReal48(thNetValue) )
                     , (common.efn_ConvertToReal48(thTotalVAT) )
                     , (common.efn_ConvertToReal48(thTotalLineDiscount) )
                     , (common.efn_ConvertToReal48(thSettleDiscAmount) )
                     , (common.efn_ConvertToReal48(thTotalCost) )
                     , (common.efn_ConvertToReal48(thCurrSettled) )
                     )
            ) CTR48  ( TotalNetValue
                     , TotalVAT
                     , TotalDiscount
                     , SettlementDiscountAmount
                     , TotalCost
                     , TotalCurrencySettled
                     )
CROSS APPLY ( VALUES ( ( ( thNetValue
                         - thTotalLineDiscount
                         + thTotalVAT
                         )
                         - ( thSettleDiscAmount
                           * thSettleDiscTaken
                           )
                       )
                     )
            ) Trans  ( TransactionTotal )
CROSS APPLY ( VALUES ( ( (common.efn_ExchequerRoundUp(TransactionTotal, 2)
                         + (TT.TransactionTypeSign * common.efn_ExchequerRoundUp(TotalCurrencySettled, 2))
                         )
                       )
                     )
            ) OS     ( TotalOutstandingAmount )
CROSS APPLY ( SELECT TotalNetValueInBase = common.efn_ExchequerCurrencyConvert( TotalNetValue
                                                                              , ConversionRate
                                                                              , thCurrency
                                                                              , 0
                                                                              , 0
                                                                              , C.TriRate
                                                                              , C.TriInverted
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating)

                   , TotalVATInBase      = common.efn_ExchequerCurrencyConvert( TotalVAT
                                                                              , VATDailyRate
                                                                              , thCurrency
                                                                              , thUseOriginalRates
                                                                              , 0
                                                                              , C.TriRate
                                                                              , C.TriInverted
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating)
                   , TotalDiscountInBase = common.efn_ExchequerCurrencyConvert( TotalDiscount
                                                                              , ConversionRate
                                                                              , thCurrency
                                                                              , 0
                                                                              , 0
                                                                              , C.TriRate
                                                                              , C.TriInverted
                                                                              , C.TriCurrencyCode
                                                                              , C.IsFloating)
                   , SettlementDiscountAmountInBase = common.efn_ExchequerCurrencyConvert( SettlementDiscountAmount
                                                                                         , ConversionRate
                                                                                         , thCurrency
                                                                                         , 0
                                                                                         , 0
                                                                                         , C.TriRate
                                                                                         , C.TriInverted
                                                                                         , C.TriCurrencyCode
                                                                                         , C.IsFloating)
                   , TotalCostInBase              = common.efn_ExchequerCurrencyConvert( TotalCost
                                                                                       , ConversionRate
                                                                                       , thCurrency
                                                                                       , 0
                                                                                       , 0
                                                                                       , C.TriRate
                                                                                       , C.TriInverted
                                                                                       , C.TriCurrencyCode
                                                                                       , C.IsFloating)
                   , TotalOutstandingAmountInBase = common.efn_ExchequerCurrencyConvert( TotalOutstandingAmount
                                                                                       , ConversionRate
                                                                                       , thCurrency
                                                                                       , 0
                                                                                       , 0
                                                                                       , C.TriRate
                                                                                       , C.TriInverted
                                                                                       , C.TriCurrencyCode
                                                                                       , C.IsFloating)
            ) BaseValues 

GO