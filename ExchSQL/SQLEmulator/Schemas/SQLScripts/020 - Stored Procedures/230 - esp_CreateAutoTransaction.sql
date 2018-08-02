
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateAutoTransaction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateAutoTransaction
GO

CREATE PROCEDURE !ActiveSchema!.esp_CreateAutoTransaction ( @iv_AutoPositionId INT
                                                  , @iv_LoginName      VARCHAR(20) = '' )
AS
BEGIN

  SET NOCOUNT ON;

  --DECLARE @iv_AutoPositionId INT = 3034
  
  -- Declare Constants

  DECLARE @c_Today          VARCHAR(8)
        , @c_MaxDate        VARCHAR(8) = '20491231'
        , @c_True           BIT = 1
        , @c_False          BIT = 0
        , @c_BaseCurrencyId INT = 0
        , @c_YTDPeriod      INT = 254
        , @c_CTDPeriod      INT = 255

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @AutoTransactionType  VARCHAR(3)
        , @FolioType            VARCHAR(3)
        , @ss_VATScheme         VARCHAR(1)
        , @ss_AuthorisationMode VARCHAR(1)
        , @ss_NoOfPeriodsInYear INT
        , @ss_VATNextPeriod     VARCHAR(8)
        , @ss_NoOfDPQuantity    INT
        , @ss_NoOfDPNet         INT
        , @ss_NoOfDPCost        INT
        , @ss_JobCostingEnabled BIT = 0

        , @NewHeaderpositionId  INT

  -- Get System Settings

  SELECT @ss_AuthorisationMode = AuthorisationMode
       , @ss_NoOfPeriodsInYear = NoOfPeriodsInYear
       , @ss_NoOfDPQuantity    = NoOfDPQuantity
       , @ss_NoOfDPNet         = NoOfDPNet
       , @ss_NoOfDPCost        = NoOfDPCost

  FROM   !ActiveSchema!.evw_SystemSettings SS

  -- Get VAT System Settings

  SELECT @ss_VATScheme     = VATScheme
       , @ss_VATNextPeriod = VATNextPeriod
  FROM   !ActiveSchema!.evw_VATSystemSettings VAT

  -- Determine whether job Costing is enabled
  SELECT @ss_JobCostingEnabled   = ISNULL((SELECT 1 
                                           FROM common.etb_Information CI
                                           WHERE CI.InformationName = 'Job Costing' 
                                           AND UPPER(CI.InformationValue) IN ('Y','1','TRUE') ), 0)


  DECLARE @NextNumTable TABLE
        ( CountType          VARCHAR(3)
        , NextCount          INT
        , FormattedNextCount VARCHAR(20)
        )
        
  SELECT @AutoTransactionType = TransactionTypeCode
  FROM   !ActiveSchema!.evw_TransactionHeader
  WHERE  HeaderPositionId = @iv_AutoPositionId  

  -- Now Update EXCHQNUM - Transaction Type

  UPDATE !ActiveSchema!.evw_ExchequerNumber
     SET NextCount = NextCount + 1
  OUTPUT deleted.CountType
       , deleted.NextCount
       , deleted.FormattedNextCount
    INTO @NextNumTable
   WHERE CountType = @AutoTransactionType
  
  -- Now Update EXCHQNUM - AFL/FOL

  SET @FolioType = CASE
                   WHEN @AutoTransactionType IN ('SBT', 'PBT', 'SQU', 'PQU', 'ADJ', 'SOR', 'POR', 'SDN', 'PDN', 'TSH', 'NOM') THEN 'AFL'
                   ELSE 'FOL'
                   END

  UPDATE !ActiveSchema!.evw_ExchequerNumber
     SET NextCount = NextCount + 1
  OUTPUT deleted.CountType
       , deleted.NextCount
       , deleted.FormattedNextCount
    INTO @NextNumTable
   WHERE CountType = @FolioType
  
  DECLARE @OurReference VARCHAR(10)
        , @FolioNumber  INT
        
  SELECT @OurReference = FormattedNextCount
  FROM   @NextNumTable
  WHERE  CountType = @AutoTransactionType
  
  SELECT @FolioNumber = NextCount
  FROM @NextNumTable
  WHERE  CountType = @FolioType

  INSERT INTO !ActiveSchema!.DOCUMENT
       ( thRunNo
       , thAcCode
       , thNomAuto
       , thOurRef
       , thFolioNum
       , thCurrency
       , thYear
       , thPeriod
       , thDueDate
       , thVATPostDate
       , thTransDate
       , thCustSupp
       , thCompanyRate
       , thDailyRate
       , thOldYourRef
       , thBatchLink
       , thOutstanding
       , thNextLineNumber
       , thNextNotesLineNumber
       , thDocType
       , thVATAnalysisStandard
       , thVATAnalysisExempt
       , thVATAnalysisZero
       , thVATAnalysisRate1
       , thVATAnalysisRate2
       , thVATAnalysisRate3
       , thVATAnalysisRate4
       , thVATAnalysisRate5
       , thVATAnalysisRate6
       , thVATAnalysisRate7
       , thVATAnalysisRate8
       , thVATAnalysisRate9
       , thVATAnalysisRateT
       , thVATAnalysisRateX
       , thVATAnalysisRateB
       , thVATAnalysisRateC
       , thVATAnalysisRateF
       , thVATAnalysisRateG
       , thVATAnalysisRateR
       , thVATAnalysisRateW
       , thVATAnalysisRateY
       , thVATAnalysisRateIAdj
       , thVATAnalysisRateOAdj
       , thVATAnalysisRateSpare
       , thNetValue
       , thTotalVAT
       , thSettleDiscPerc
       , thSettleDiscAmount
       , thTotalLineDiscount
       , thSettleDiscDays
       , thSettleDiscTaken
       , thAmountSettled
       , thAutoIncrement
       , thUntilYear
       , thUntilPeriod
       , thTransportNature
       , thTransportMode
       , thRemitNo
       , thAutoIncrementType
       , thHoldFlag
       , thAuditFlag
       , thTotalWeight
       , thDeliveryAddr1
       , thDeliveryAddr2
       , thDeliveryAddr3
       , thDeliveryAddr4
       , thDeliveryAddr5
       , thVariance
       , thTotalOrdered
       , thTotalReserved
       , thTotalCost
       , thTotalInvoiced
       , thLongYourRef
       , thUntilDate
       , thNOMVATIO
       , thExternal
       , thPrinted
       , thRevalueAdj
       , thCurrSettled
       , thSettledVAT
       , thVATClaimed
       , thBatchGL
       , thAutoPost
       , thManualVAT
       , thDeliveryTerms
       , thIncludeInPickingRun
       , thOperator
       , thNoLabels
       , thTagged
       , thPickingRunNo
       , thOrdMatch
       , thDeliveryNoteRef
       , thVATCompanyRate
       , thVATDailyRate
       , thOriginalCompanyRate
       , thOriginalDailyRate
       , PostDiscAm
       , thSpareNomCode
       , thPostDiscTaken
       , thControlGL
       , thJobCode
       , thAnalysisCode
       , thTotalOrderOS
       , thAppDepartment
       , thAppCostCentre
       , thUserField1
       , thUserField2
       , thLineTypeAnalysis1
       , thLineTypeAnalysis2
       , thLineTypeAnalysis3
       , thLineTypeAnalysis4
       , thLineTypeAnalysis5
       , thLineTypeAnalysis6
       , thLastDebtChaseLetter
       , thBatchNow
       , thBatchThen
       , thUnTagged
       , thOriginalBaseValue
       , thUseOriginalRates
       , thOldCompanyRate
       , thOldDailyRate
       , thFixedRate
       , thUserField3
       , thUserField4
       , thProcess
       , thSource
       , thCurrencyTriRate
       , thCurrencyTriEuro
       , thCurrencyTriInvert
       , thCurrencyTriFloat
       , thCurrencyTriSpare
       , thVATTriRate
       , thVATTriEuro
       , thVATTriInvert
       , thVATTriFloat
       , thVATTriSpare
       , thOriginalTriRate
       , thOriginalTriEuro
       , thOriginalTriInvert
       , thOriginalTriFloat
       , thOriginalTriSpare
       , thOldOriginalTriRate
       , thOldOriginalTriEuro
       , thOldOriginalTriInvert
       , thOldOriginalTriFloat
       , thOldOriginalTriSpare
       , thPostedDate
       , thPORPickSOR
       , thBatchDiscAmount
       , thPrePost
       , thAuthorisedAmnt
       , thTimeChanged
       , thTimeCreated
       , thCISTaxDue
       , thCISTaxDeclared
       , thCISManualTax
       , thCISDate
       , thTotalCostApportioned
       , thCISEmployee
       , thCISTotalGross
       , thCISSource
       , thTimesheetExported
       , thCISExcludedFromGross
       , thWeekMonth
       , thWorkflowState
       , thOverrideLocation
       , thSpare5
       , thYourRef
       , thUserField5
       , thUserField6
       , thUserField7
       , thUserField8
       , thUserField9
       , thUserField10
       , thDeliveryPostCode
       , thOriginator
       , thCreationTime
       , thCreationDate
       , thOrderPaymentOrderRef
       , thOrderPaymentElement
       , thOrderPaymentFlags
       , thCreditCardType
       , thCreditCardNumber
       , thCreditCardExpiry
       , thCreditCardAuthorisationNo
       , thCreditCardReferenceNo
       , thCustomData1
       , thDeliveryCountry
       , thPPDPercentage
       , thPPDDays
       , thPPDGoodsValue
       , thPPDVATValue
       , thPPDTaken
       , thPPDCreditNote
       , thBatchPayPPDStatus
       , thIntrastatOutOfPeriod
       , thUserField11
       , thUserField12
       , thTaxRegion
       )
  SELECT thRunNo                      = 0
       , thAcCode
       , thNomAuto                    = 1
       , thOurRef                     = @OurReference
       , thFolioNum                   = @FolioNumber
       , thCurrency
       , thYear
       , thPeriod
       , thDueDate                    = CONVERT(VARCHAR(8), DATEADD(DD, ISNULL(CS.acPayTerms, 0), CONVERT(DATE, STUFF(STUFF(thTransDate, 5, 0, '-'), 8, 0, '-'))), 112)
       , thVATPostDate                = CASE
                                        WHEN @AutoTransactionType IN ('SRF','SRI','PRF','PRI') AND @ss_VATScheme = 'N' THEN @ss_VATNextPeriod
                                        ELSE thVATPostDate
                                        END
       , thTransDate
       , thCustSupp
       , thCompanyRate                = CASE
                                        WHEN @AutoTransactionType NOT IN ('SRF','SRI','PRF','PRI') THEN 0
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.CompanyRate
                                        ELSE DOC.thCompanyRate
                                        END
       , thDailyRate                  = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.DailyRate
                                        ELSE DOC.thDailyRate
                                        END
       , thOldYourRef
       , thBatchLink
       , thOutstanding                = CASE
                                        WHEN @AutoTransactionType IN ('PIN', 'PCR', 'PJI', 'PJC', 'PPY', 'SIN', 'SCR', 'SJI', 'SJC', 'SRC') THEN thCustSupp
                                        ELSE CHAR(0)
                                        END
       , thNextLineNumber
       , thNextNotesLineNumber
       , thDocType
       , thVATAnalysisStandard
       , thVATAnalysisExempt
       , thVATAnalysisZero
       , thVATAnalysisRate1
       , thVATAnalysisRate2
       , thVATAnalysisRate3
       , thVATAnalysisRate4
       , thVATAnalysisRate5
       , thVATAnalysisRate6
       , thVATAnalysisRate7
       , thVATAnalysisRate8
       , thVATAnalysisRate9
       , thVATAnalysisRateT
       , thVATAnalysisRateX
       , thVATAnalysisRateB
       , thVATAnalysisRateC
       , thVATAnalysisRateF
       , thVATAnalysisRateG
       , thVATAnalysisRateR
       , thVATAnalysisRateW
       , thVATAnalysisRateY
       , thVATAnalysisRateIAdj
       , thVATAnalysisRateOAdj 
       , thVATAnalysisRateSpare 
       , thNetValue
       , thTotalVAT
       , thSettleDiscPerc
       , thSettleDiscAmount
       , thTotalLineDiscount
       , thSettleDiscDays
       , thSettleDiscTaken
       , thAmountSettled
       , thAutoIncrement
       , thUntilYear
       , thUntilPeriod
       , thTransportNature
       , thTransportMode
       , thRemitNo
       , thAutoIncrementType
       , thHoldFlag
       , thAuditFlag
       , thTotalWeight
       , thDeliveryAddr1
       , thDeliveryAddr2
       , thDeliveryAddr3
       , thDeliveryAddr4
       , thDeliveryAddr5
       , thVariance
       , thTotalOrdered
       , thTotalReserved
       , thTotalCost
       , thTotalInvoiced
       , thLongYourRef
       , thUntilDate                  = CASE
                                        WHEN @AutoTransactionType IN ('SRF','SRI','PRF','PRI') AND @ss_VATScheme = 'N' THEN CONVERT(VARCHAR(8), GETDATE(), 112)
                                        WHEN @AutoTransactionType IN ('PIN', 'PCR', 'PJI', 'PJC', 'PPY', 'SIN', 'SCR', 'SJI', 'SJC', 'SRC') THEN CHAR(255)
                                        ELSE ''
                                        END
       , thNOMVATIO
       , thExternal
       , thPrinted
       , thRevalueAdj
       , thCurrSettled
       , thSettledVAT
       , thVATClaimed
       , thBatchGL
       , thAutoPost
       , thManualVAT
       , thDeliveryTerms
       , thIncludeInPickingRun
       , thOperator                   = @iv_LoginName 
       , thNoLabels
       , thTagged
       , thPickingRunNo
       , thOrdMatch
       , thDeliveryNoteRef
       , thVATCompanyRate
       , thVATDailyRate
       , thOriginalCompanyRate
       , thOriginalDailyRate
       , PostDiscAm
       , thSpareNomCode
       , thPostDiscTaken
       , thControlGL
       , thJobCode
       , thAnalysisCode
       , thTotalOrderOS
       , thAppDepartment
       , thAppCostCentre
       , thUserField1
       , thUserField2
       , thLineTypeAnalysis1
       , thLineTypeAnalysis2
       , thLineTypeAnalysis3
       , thLineTypeAnalysis4
       , thLineTypeAnalysis5
       , thLineTypeAnalysis6
       , thLastDebtChaseLetter
       , thBatchNow
       , thBatchThen
       , thUnTagged
       , thOriginalBaseValue
       , thUseOriginalRates
       , thOldCompanyRate
       , thOldDailyRate
       , thFixedRate
       , thUserField3
       , thUserField4
       , thProcess
       , thSource
       , thCurrencyTriRate            = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN ISNULL(C.TriRate, 0)
                                        ELSE DOC.thCurrencyTriRate
                                        END
       , thCurrencyTriEuro            = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN ISNULL(C.TriCurrencyCode, 0)
                                        ELSE DOC.thCurrencyTriEuro
                                        END
       , thCurrencyTriInvert          = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.TriInverted
                                        ELSE DOC.thCurrencyTriInvert
                                        END
       , thCurrencyTriFloat           = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.IsFloating
                                        ELSE DOC.thCurrencyTriFloat
                                        END
       , thCurrencyTriSpare
       , thVATTriRate
       , thVATTriEuro
       , thVATTriInvert
       , thVATTriFloat
       , thVATTriSpare
       , thOriginalTriRate
       , thOriginalTriEuro
       , thOriginalTriInvert
       , thOriginalTriFloat
       , thOriginalTriSpare
       , thOldOriginalTriRate
       , thOldOriginalTriEuro
       , thOldOriginalTriInvert
       , thOldOriginalTriFloat
       , thOldOriginalTriSpare
       , thPostedDate
       , thPORPickSOR
       , thBatchDiscAmount
       , thPrePost
       , thAuthorisedAmnt             = CASE
                                        WHEN @ss_AuthorisationMode = 'A' AND HS.OnHold = 0 THEN 0
                                        ELSE DOC.thAuthorisedAmnt
                                        END
       , thTimeChanged
       , thTimeCreated
       , thCISTaxDue
       , thCISTaxDeclared
       , thCISManualTax
       , thCISDate
       , thTotalCostApportioned
       , thCISEmployee
       , thCISTotalGross
       , thCISSource
       , thTimesheetExported
       , thCISExcludedFromGross
       , thWeekMonth
       , thWorkflowState
       , thOverrideLocation
       , thSpare5
       , thYourRef
       , thUserField5
       , thUserField6
       , thUserField7
       , thUserField8
       , thUserField9
       , thUserField10
       , thDeliveryPostCode
       , thOriginator                 = @iv_LoginName
       , thCreationTime
       , thCreationDate
       , thOrderPaymentOrderRef
       , thOrderPaymentElement
       , thOrderPaymentFlags
       , thCreditCardType
       , thCreditCardNumber
       , thCreditCardExpiry
       , thCreditCardAuthorisationNo
       , thCreditCardReferenceNo
       , thCustomData1
       , thDeliveryCountry
       , thPPDPercentage
       , thPPDDays
       , thPPDGoodsValue
       , thPPDVATValue
       , thPPDTaken
       , thPPDCreditNote
       , thBatchPayPPDStatus
       , thIntrastatOutOfPeriod
       , thUserField11
       , thUserField12
       , thTaxRegion
  FROM !ActiveSchema!.DOCUMENT DOC
  LEFT JOIN !ActiveSchema!.CUSTSUPP CS ON DOC.thAcCode   = CS.acCode
  LEFT JOIN !ActiveSchema!.CURRENCY C  ON DOC.thCurrency = C.CurrencyCode
  LEFT JOIN common.evw_HoldStatus HS ON DOC.thHoldFlag = HS.HoldStatusId
  
  WHERE DOC.PositionId = @iv_AutoPositionId
  AND thRunNo IN (-1,-2)
  
  -- Now create Transaction Lines
  INSERT INTO !ActiveSchema!.DETAILS
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
  SELECT tlFolioNum              = @FolioNumber
       , tlLineNo
       , tlRunNo                 = 0
       , tlGLCode
       , tlNominalMode
       , tlCurrency
       , tlYear                  = DOC.thYear
       , tlPeriod                = DOc.thPeriod
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
       , tlOurRef                     = @OurReference
       , tlDocLTLink
       , tlPrxPack
       , tlQtyPack
       , tlReconciliationDate
       , tlShowCase
       , tlSdbFolio
       , tlOriginalBaseValue
       , tlUseOriginalRates           = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN 0
                                        ELSE DOC.thUseOriginalRates
                                        END
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
       , tlTriRates                   = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN ISNULL(C.TriRate, 0)
                                        ELSE DOC.thCurrencyTriRate
                                        END
       , tlTriEuro                    = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN ISNULL(C.TriCurrencyCode, 0)
                                        ELSE DOC.thCurrencyTriEuro
                                        END
       , tlTriInvert                  = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.TriInverted
                                        ELSE DOC.thCurrencyTriInvert
                                        END
       , tlTriFloat                   = CASE
                                        WHEN @AutoTransactionType NOT IN ('NOM', 'NMT') THEN C.IsFloating
                                        ELSE DOC.thCurrencyTriFloat
                                        END
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
  FROM !ActiveSchema!.DETAILS DTL
  JOIN !ActiveSchema!.DOCUMENT DOC ON DOC.thFolioNum = DTL.tlFolioNum
    LEFT JOIN !ActiveSchema!.CURRENCY C  ON DTL.tlCurrency = C.CurrencyCode
    
  WHERE DOC.PositionId = @iv_AutoPositionId
  AND   DOC.thRunNo IN (-1, -2)
  
  -- Insert JobDet Records if required
  IF ( @ss_JobCostingEnabled = @c_True
  AND  EXISTS ( SELECT TOP 1 1
                FROM   !ActiveSchema!.DETAILS DTL
                JOIN !ActiveSchema!.DOCUMENT DOC ON DOC.thFolioNum = DTL.tlFolioNum
 
                WHERE DOC.thFolioNum = @FolioNumber
                AND   DTL.tlJobCode <> ''
              )
     )
  BEGIN
  
    INSERT INTO !ActiveSchema!.JOBDET
         ( RecPfix
         , SubType
         , var_code1
         , var_code2
         , var_code3
         , var_code4
         , var_code5
         , var_code6
         , var_code7
         , var_code8
         , var_code9
         , var_code10
         , Posted
         , LineFolio
         , LineNUmber
         , LineORef
         , JobCode
         , StockCode
         , JDate
         , Qty
         , Cost
         , Charge
         , Invoiced
         , InvRef
         , EmplCode
         , JAType
         , PostedRun
         , [Reverse]
         , ReconTS
         , Reversed
         , JDDT
         , CurrCharge
         , ActCCode
         , HoldFlg
         , Post2Stk
         , PCRates1
         , PCRates2
         , Tagged
         , OrigNCode
         , JUseORate
         , PCTriRates
         , PCTriEuro
         , PCTriInvert
         , PCTriFloat
         , PC_tri_Spare
         , JPriceMulX
         , UpliftTotal
         , UpliftGL
         
         )
    SELECT RecPfix      = 'J'                                                                  
         , SubType      = 'E'                                                                 
         , var_code1    = 0x15 
                        + CONVERT(VARBINARY(22), CONVERT(CHAR(10), DTL.tlJobCode))
                        + 0x000100
                        + CONVERT(VARBINARY(22), CONVERT(CHAR(8), DOC.thTransDate))
         , var_code2    = CONVERT(VARBINARY(3), 0x000000)
         , var_code3    = CONVERT(VARBINARY(21), 0x000000000000000000000000000000000000000000)
         , var_code4    = ''
         , var_code5    = DTL.tlAnalysisCode                                                    
         , var_code6    = CONVERT(VARBINARY(22), 0x00000000000000000000000000000000000000000000)
         , var_code7    = 0x1600000000 
                        + CONVERT(VARBINARY(22), CONVERT(CHAR(10), DTL.tlJobCode))
                        + CONVERT(VARBINARY(22), CONVERT(CHAR(8), DOC.thTransDate))
         , var_code8    = 0x09
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlFolioNum), 4, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlFolioNum), 3, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlFolioNum), 2, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlFolioNum), 1, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlABSLineNo), 4, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlABSLineNo), 3, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlABSLineNo), 2, 1)
                        + SUBSTRING(CONVERT(VARBINARY(4), DTL.tlABSLineNo), 1, 1)
                        + CONVERT(VARBINARY(1), '!')
                        + 0x0000000000000000000
         , var_code9    = CONVERT(VARBINARY(15), 0x000000000000000000000000000000)
         , var_code10   = CONVERT(VARBINARY(1), DTL.tlCurrency)
                        + CONVERT(VARBINARY(1), DTL.tlYear)
                        + CONVERT(VARBINARY(1), DTL.tlPeriod)                                       
         , Posted       = 0
         , LineFolio    = @FolioNumber                                                       
         , LineNUmber   = DTL.tlABSLineNo                                                     
         , LineORef     = @OurReference                                                        
         , JobCode      = DTL.tlJobCode                                                        
         , StockCode    = common.GetString(DTL.tlStockCode, 1)                                 
         , JDate        = DOC.thTransDate                                                      
         , Qty          = TL.LineQuantity
         , Cost         = TL.PricePerUnit
         , Charge       = CASE                  -- May need to convert this to charge currency??
                          WHEN J.ChargeType = 3 THEN common.efn_ExchequerRoundUp(TL.LineQuantity * TL.PricePerUnit, 2)
                          WHEN J.ChargeType = 1 AND common.GetString(DTL.tlStockCode, 1) <> '' 
                          THEN TL.LineQuantity * !ActiveSchema!.efn_StockDiscount( common.GetString(DTL.tlStockCode, 1)
                                                                           , DTL.tlLocation
                                                                           , DOC.thAcCode
                                                                           , DOC.thTransDate
                                                                           , DOC.thTransDate
                                                                           , DTL.tlCurrency
                                                                           , TL.LineQuantityOutstanding
                                                                           , TL.LineQuantityMultiplier
                                                                           )
                          ELSE 0
                          END
         , Invoiced     = 0
         , InvRef       = ''
         , EmplCode     = CASE
                          WHEN TT.TransactionTypeCode = 'TSH' THEN DOC.thBatchLinkTrans
                          ELSE ''
                          END
         , JAType       = ISNULL(JA.JobAnalysisCategoryId, '')                                 
         , PostedRun    = 0
         , [Reverse]    = 0
         , ReconTS      = 0
         , Reversed     = 0
         , JDDT         = DTL.tlDocType                                                        
         , CurrCharge   = CASE
                          WHEN TT.TransactionTypeCode = 'TSH' THEN DTL.tlRecStatus
                          ELSE J.FixedPriceCurrency
                          END
         , ActCCode     = DTL.tlAcCode                                                         
         , HoldFlg      = 0
         , Post2Stk     = 0
         , PCRates1     = 0
         , PCRates2     = 0
         , Tagged       = 0
         , OrigNCode    = DTL.tlGLCode                                                         
         , JUseORate    = DTL.tlUseOriginalRates                                               
         , PCTriRates   = 0
         , PCTriEuro    = 0
         , PCTriInvert  = 0
         , PCTriFloat   = 0
         , PC_tri_Spare = CONVERT(VARBINARY(10), 0x00000000000000000000)
         , JPriceMulX   = DTL.tlPriceMultiplier                                               
         , UpliftTotal  = 0
         , UpliftGL     = 0

        -- , ChargeType   = J.ChargeType
                   
    FROM !ActiveSchema!.DETAILS DTL
    JOIN !ActiveSchema!.DOCUMENT DOC ON DOC.thFolioNum = DTL.tlFolioNum
    JOIN common.evw_TransactionType TT ON DOC.thDocType = TT.TransactionTypeId

    LEFT JOIN !ActiveSchema!.evw_Job         J  ON DTL.tlJobCode      = J.JobCode
    LEFT JOIN !ActiveSchema!.evw_JobAnalysis JA ON DTL.tlAnalysisCode = JA.JobAnalysisCode

    LEFT JOIN !ActiveSchema!.evw_TransactionLine TL ON TL.LinePositionId = DTl.PositionId

    WHERE DOC.thFolioNum = @FolioNumber -- The new record
    AND   DTL.tlJobCode <> ''

  END
  
  -----------------------------------------------------------------
  -- Add Transaction Note 1.13.24
  -----------------------------------------------------------------

  INSERT INTO !ActiveSchema!.TransactionNote
            ( NoteFolio
            , NoteDate
            , NoteType
            , LineNumber
            , NoteUser
            , NoteLine
            , NoteAlarm
            , TmpImpCode
            , ShowDate
            , RepeatNo
            , NoteFor
            )
  SELECT NoteFolio  = @FolioNumber
       , NoteDate   = CONVERT(VARCHAR(8), GETDATE(), 112)
       , NoteType   = 3
       , LineNumber = ISNULL((SELECT MAX(LineNumber) + 1 FROM !ActiveSchema!.TransactionNote (READUNCOMMITTED) WHERE NoteFolio = @FolioNumber), 1)
 
       , NoteUser   = @iv_LoginName
       , NoteLine   = 'CREATED BY ' + @iv_LoginName + ':' + CONVERT(VARCHAR(10), GETDATE(), 103) + ' ' + CONVERT(VARCHAR(8), GETDATE(), 114)
       , NoteAlarm  = ''
       , TmpImpCode = ''
       , ShowDate   = 0
       , RepeatNo   = 0
       , NoteFor    = ''
  
  -- Update Trader History
  EXEC !ActiveSchema!.esp_UpdateTraderHistory @iv_Mode       = 2
                                    , @iv_PositionId = @iv_AutoPositionId
  
  -- Update Auto Transaction itself
  
  UPDATE !ActiveSchema!.DOCUMENT
     SET thTransDate = CONVERT(VARCHAR(8), DATEADD(dd, thAutoIncrement, CONVERT(DATE, thTransDate)), 112)
       , thDueDate   = CONVERT(VARCHAR(8), DATEADD(dd, thAutoIncrement, DATEADD(dd, thAutoIncrement, CONVERT(DATE, thTransDate))), 112)
  WHERE PositionId = @iv_AutoPositionId
  AND   thAutoIncrementType = 'D'

  UPDATE !ActiveSchema!.DOCUMENT
     SET thPeriod    = CASE
                       WHEN (thPeriod + thAutoIncrement)%@ss_NoOfPeriodsInYear = 0 THEN @ss_NoOfPeriodsInYear
                       ELSE (thPeriod + thAutoIncrement)%@ss_NoOfPeriodsInYear
                       END
       , thYear      = thYear
                     + CASE
                       WHEN (thPeriod + thAutoIncrement)%@ss_NoOfPeriodsInYear = 0 THEN ((thPeriod + thAutoIncrement)/@ss_NoOfPeriodsInYear) - 1
                       ELSE (thPeriod + thAutoIncrement)/@ss_NoOfPeriodsInYear
                       END
  WHERE PositionId = @iv_AutoPositionId
  AND   thAutoIncrementType = 'P'

  -- Remove any Auto transactions that have expired.

  IF EXISTS(SELECT TOP 1 1
            FROM   !ActiveSchema!.evw_AutoTransaction
            WHERE  HeaderPositionId = @iv_AutoPositionId
            AND  ( (AutoCreateTransNextPeriodKey > AutoCreateTransUntilPeriodKey AND IncrementType = 'P')
             OR    (AutoCreateTransNextDate      > AutoCreateTransUntilDate COLLATE SQL_Latin1_General_CP1_CI_AS AND IncrementType = 'D')
                 )
           )
  BEGIN

    -- Delete DETAILS

    DELETE DTL
    FROM   !ActiveSchema!.DETAILS DTL
    JOIN   !ActiveSchema!.DOCUMENT DOC ON DOC.thFolioNum = DTL.tlFolioNum
    WHERE  DOC.PositionId = @iv_AutoPositionId

    -- Delete DOCUMENT

    DELETE DOC
    FROM   !ActiveSchema!.DOCUMENT DOC
    WHERE  DOC.PositionId = @iv_AutoPositionId

  END

END

GO