
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[evw_TransactionHeader]'))
DROP VIEW [!ActiveSchema!].[evw_TransactionHeader]
GO

CREATE VIEW !ActiveSchema!.evw_TransactionHeader
AS
SELECT HeaderPositionId  = HDR.PositionId
     , HeaderFolioNumber = HDR.thFolioNum
     , RunNo             = HDR.thRunNo
     , AutoDaybookFlag   = HDR.thNomAuto
     , TransactionDate   = HDR.thTransDate
     , ExchequerYear     = HDR.thYear
     , TransactionYear   = HDR.thYear + 1900
     , TransactionPeriod = HDR.thPeriod
     , TransactionPeriodKey = ((HDR.thYear + 1900) * 1000) + HDR.thPeriod
     , DueDate           = HDR.thDueDate
     , VATPostDate       = HDR.thVATPostDate

     , IsPosted          = CONVERT(BIT, CASE
                                        WHEN thRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 0
                                        ELSE 1
                                        END)
     , PostingStatus     = CONVERT(NVARCHAR, CASE
                                             WHEN thRunNo IN (0, -40, -41, -43, -50, -51, -53, -60, -100, -115, -118, -125, -128) THEN 'Not Posted'
                                             ELSE 'Posted'
                                             END)
     , HoldStatus                 = thHoldFlag
     , HoldStatusDescription      = ISNULL(HS.HoldStatusDescription, '')
     , HoldStatusShortDescription = ISNULL(HS.HoldStatusShortDescription, '')
     , DocumentHasnotes       = CASE
                                WHEN thHoldFlag = 32 OR thHoldFlag > 38 THEN 1
                                ELSE 0
                                END
     , IsStockMovement        = CASE
                                WHEN TT.TransactionTypeCode IN ('SIN', 'SCR', 'SRF', 'SRI', 'SJI', 'SJC', 'SDN', 'PIN', 'PDN', 'PCR', 'PRF', 'PPI', 'PJI', 'PJC' ) THEN 1
                                ELSE 0
                                END
     , IsManualVAT            = HDR.thManualVAT
     , IsNominalInputVAT      = CASE
                                WHEN TT.TransactionTypeCode IN ('NOM','NMT') THEN CASE
                                                                                  WHEN HDR.thNOMVATIO = 'I' THEN 1
                                                                                  ELSE 0
                                                                                  END
                                END
     , IsNominalOutputVAT     = CASE
                                WHEN TT.TransactionTypeCode IN ('NOM','NMT') THEN CASE
                                                                                  WHEN HDR.thNOMVATIO = 'O' THEN 1
                                                                                  ELSE 0
                                                                                  END
                                END             
     , ControlGLNominalCode   = CASE
                                WHEN HDR.thControlGL IN (SS.DebtorControlNominalCode, SS.CreditorControlNominalCode) THEN 0
                                ELSE HDR.thControlGL
                                END

     , OurReference           = HDR.thOurRef
     , YourReference          = HDR.thYourRef
     , DeliveryNoteReference  = HDR.thDeliveryNoteRef
     , BatchDocumentReference = CASE
                                WHEN HDR.thBatchLinkTrans LIKE 'SBT[0-9][0-9][0-9][0-9][0-9][0-9]' THEN HDR.thBatchLinkTrans
                                ELSE ''
                                END
     , EmployeeCode           = CASE
                                WHEN TT.TransactionTypeCode = 'TSH' THEN HDR.thBatchLinkTrans
                                ELSE ''
                                END
     , RemitNo                = HDR.thRemitNo
     , Operator               = HDR.thOperator
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
     , CurrencyId        = HDR.thCurrency
     , SS.UseCompanyRate
     , CompanyRate       = THV.CompanyRate
     , DailyRate         = THV.DailyRate
     , ConversionRate    = THV.ConversionRate
     , IsInverted        = THV.IsInverted
     , IsFloating        = THV.IsFloating
     , CurrencyTriRate   = THV.CurrencyTriRate

     , TraderCode        = HDR.thAcCodeComputed

     , TotalNetValue 
     , TotalNetValueInBase 
     , TotalCalculatedNetValue       = TotalCalculatedNetValue * TT.TransactionTypeSign * -1
     , TotalCalculatedNetValueInBase = TotalCalculatedNetValueInBase * TT.TransactionTypeSign * -1
     , TotalVAT
     , TotalVATInBase 
     , TotalGrossValue
     , TotalGrossValueInBase
     , TotalCost                    =  TotalCost * TT.TransactionTypeSign * -1
     , TotalCostInBase              =  TotalCostInBase * TT.TransactionTypeSign * -1
     , TotalInvoiced
     , TotalDiscount
     , TotalDiscountInBase
     , TotalCurrencySettled 
     , TotalSettledInBase 
     , TotalOrdered                = TotalOrdered * TT.TransactionTypeSign * -1
     , TotalOrderOutstanding       = TotalOrderOutstanding * TT.TransactionTypeSign * -1
     , TotalOrderOutstandingInBase = TotalOrderOutstandingInBase * TT.TransactionTypeSign * -1
     , TotalReserved
     , RevaluationAdjustmentInBase
     , VarianceAmountInBase
     , SettleDiscountAmount        = SettleDiscountAmount * TT.TransactionTypeSign * -1
     , SettleDiscountAmountInBase  = SettleDiscountAmountInBase * TT.TransactionTypeSign * -1
     , SettleDiscountPercent       = HDR.thSettleDiscPerc
     , SettleDiscountTaken         = HDR.thSettleDiscTaken
     , PostedDiscountAmountInBase 
     , PostedDiscountTaken = thPostDiscTaken

     , TransactionTotal
     , TransactionTotalInBase
     , TotalOutstandingAmount  = CASE
                                 WHEN thRunNo >= 0 THEN common.efn_ExchequerRoundUp( TransactionTotal
                                                                                   + (TT.TransactionTypeSign * TotalCurrencySettled)
                                                                                   , 2)
                                 ELSE 0.00
                                 END
     , TotalOutstandingAmountInBase = CASE
                                      WHEN thRunNo >= 0 THEN common.efn_ExchequerRoundUp( TransactionTotalInBase
                                                                                        + (TT.TransactionTypeSign * TotalSettledInBase)
                                                                                        , 2)
                                                          
                                      ELSE 0.00
                                      END
     , DebitAmount             = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotal)
                                 WHEN (TransactionTotal) * TT.TransactionTypeSign * -1 < 0 THEN ABS((TransactionTotal))
                                 ELSE 0
                                 END
     , DebitAmountInBase       = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotalInBase)
                                 WHEN TransactionTotalInBase * TT.TransactionTypeSign * -1 < 0 THEN ABS(TransactionTotalInBase)
                                 ELSE 0
                                 END
     , CreditAmount            = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotal)
                                 WHEN (TransactionTotal) * TT.TransactionTypeSign * -1 > 0 THEN ABS((TransactionTotal) * TT.TransactionTypeSign)
                                 ELSE 0
                                 END
     , CreditAmountInBase      = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotalInBase)
                                 WHEN TransactionTotalInBase * TT.TransactionTypeSign * -1 > 0 THEN ABS(TransactionTotalInBase)
                                 ELSE 0
                                 END
     , BalanceAmount           = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotal)
                                 WHEN (TransactionTotal) * TT.TransactionTypeSign * -1 > 0 THEN ABS((TransactionTotal) * TT.TransactionTypeSign)
                                 ELSE 0
                                 END
                               - CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotal)
                                 WHEN (TransactionTotal) * TT.TransactionTypeSign * -1 < 0 THEN ABS((TransactionTotal) * TT.TransactionTypeSign)
                                 ELSE 0
                                 END
     , BalanceAmountInBase     = CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotalInBase)
                                 WHEN TransactionTotalInBase * TT.TransactionTypeSign * -1 > 0 THEN ABS(TransactionTotalInBase)
                                 ELSE 0
                                 END
                               - CASE
                                 WHEN TransactionTypeCode IN ('SRF', 'SRI', 'PRF', 'PPI') THEN ABS(TransactionTotalInBase)
                                 WHEN TransactionTotalInBase * TT.TransactionTypeSign * -1 < 0 THEN ABS(TransactionTotalInBase)
                                 ELSE 0
                                 END
	 , IsAnonymised			   = HDR.thAnonymised
	 , AnonymisedDate		   = HDR.thAnonymisedDate
	 , AnonymisedTime		   = HDR.thAnonymisedTime
	
FROM !ActiveSchema!.DOCUMENT HDR
JOIN !ActiveSchema!.evw_TransactionHeaderValues THV ON HDR.PositionId       = THV.HeaderPositionId
LEFT JOIN common.evw_TransactionType    TT  ON TT.TransactionTypeId = HDR.thDocType
LEFT JOIN common.evw_HoldStatus          HS ON HDR.thHoldFlag       = HS.HoldStatusId
CROSS JOIN !ActiveSchema!.evw_SystemSettings    SS


GO