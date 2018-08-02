
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[!ActiveSchema!].[esp_CreateAutoReverseTransaction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [!ActiveSchema!].esp_CreateAutoReverseTransaction
GO

CREATE PROCEDURE !ActiveSchema!.esp_CreateAutoReverseTransaction ( @iv_AutoReversePositionId INT
                                                  , @iv_LoginName      VARCHAR(20) = '' )
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

  SET @c_Today = CONVERT(VARCHAR(8), GETDATE(), 112)

  DECLARE @AutoReverseTransactionType  VARCHAR(3)
        , @FolioType                   VARCHAR(3)
        , @ss_VATScheme                VARCHAR(1)
        , @ss_AuthorisationMode        VARCHAR(1)
        , @ss_NoOfPeriodsInYear        INT
        , @ss_VATNextPeriod            VARCHAR(8)
        , @ss_NoOfDPQuantity           INT
        , @ss_NoOfDPNet                INT
        , @ss_NoOfDPCost               INT
        , @ss_JobCostingEnabled        BIT = 0

        , @NewHeaderpositionId         INT

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
        
  -- Now Update EXCHQNUM - Transaction Type

  UPDATE !ActiveSchema!.evw_ExchequerNumber
     SET NextCount = NextCount + 1
  OUTPUT deleted.CountType
       , deleted.NextCount
       , deleted.FormattedNextCount
    INTO @NextNumTable
   WHERE CountType = 'ADC'
  
  -- Now Update EXCHQNUM - AFL

  UPDATE !ActiveSchema!.evw_ExchequerNumber
     SET NextCount = NextCount + 1
  OUTPUT deleted.CountType
       , deleted.NextCount
       , deleted.FormattedNextCount
    INTO @NextNumTable
   WHERE CountType = 'AFL'
  
  DECLARE @OurReference VARCHAR(10)
        , @FolioNumber  INT
        
  SELECT @OurReference = REPLACE(FormattedNextCount,'xxx','NOM')
  FROM   @NextNumTable
  WHERE  CountType = 'ADC'
  
  SELECT @FolioNumber = NextCount
  FROM @NextNumTable
  WHERE  CountType = 'AFL'

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
	   , thAnonymised
	   , thAnonymisedDate
	   , thAnonymisedTime
       )
  SELECT thRunNo                      = -2
       , thAcCode
       , thNomAuto                    = 0
       , thOurRef                     = @OurReference
       , thFolioNum                   = @FolioNumber
       , thCurrency
       , thYear                       = CASE
                                        WHEN thPeriod = @ss_NoOfPeriodsInYear THEN thYear + 1
                                        ELSE thYear
                                        END
       , thPeriod                     = CASE
                                        WHEN thPeriod = @ss_NoOfPeriodsInYear THEN 1
                                        ELSE thPeriod + 1
                                        END
       , thDueDate                    = thDueDate
       , thVATPostDate                = thVATPostDate
       , thTransDate
       , thCustSupp
       , thCompanyRate                = DOC.thCompanyRate
       , thDailyRate                  = DOC.thDailyRate
       , thOldYourRef
       , thBatchLink
       , thOutstanding                = CHAR(0)
       , thNextLineNumber
       , thNextNotesLineNumber
       , thDocType
       , thVATAnalysisStandard * -1
       , thVATAnalysisExempt * -1
       , thVATAnalysisZero * -1
       , thVATAnalysisRate1 * -1
       , thVATAnalysisRate2 * -1
       , thVATAnalysisRate3 * -1
       , thVATAnalysisRate4 * -1
       , thVATAnalysisRate5 * -1
       , thVATAnalysisRate6 * -1
       , thVATAnalysisRate7 * -1
       , thVATAnalysisRate8 * -1
       , thVATAnalysisRate9 * -1
       , thVATAnalysisRateT * -1
       , thVATAnalysisRateX * -1
       , thVATAnalysisRateB * -1
       , thVATAnalysisRateC * -1
       , thVATAnalysisRateF * -1
       , thVATAnalysisRateG * -1
       , thVATAnalysisRateR * -1
       , thVATAnalysisRateW * -1
       , thVATAnalysisRateY * -1
       , thVATAnalysisRateIAdj * -1
       , thVATAnalysisRateOAdj  * -1
       , thVATAnalysisRateSpare * -1
       , thNetValue * -1   -- ABSEXCH-18997 - VAT on auto-reversing NOMs causing an intital imbalance until NOM is edited
       , thTotalVAT * -1
       , thSettleDiscPerc
       , thSettleDiscAmount
       , thTotalLineDiscount
       , thSettleDiscDays
       , thSettleDiscTaken
       , thAmountSettled
       , thAutoIncrement              = 1
       , thUntilYear                  = CASE
                                        WHEN thPeriod = @ss_NoOfPeriodsInYear THEN thYear + 1
                                        ELSE thYear
                                        END
       , thUntilPeriod                = CASE
                                        WHEN thPeriod = @ss_NoOfPeriodsInYear THEN 1
                                        ELSE thPeriod + 1
                                        END
       , thTransportNature
       , thTransportMode
       , thRemitNo
       , thAutoIncrementType          = 'P'
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
       , thLongYourRef                = 0x14 + CONVERT(VARBINARY(21), CONVERT(VARCHAR(20), thLongYourRefTrans + '. Auto Reverse'))
       , thUntilDate                  = @c_MaxDate
       , thNOMVATIO
       , thExternal
       , thPrinted
       , thRevalueAdj
       , thCurrSettled
       , thSettledVAT
       , thVATClaimed
       , thBatchGL
       , thAutoPost                   = @c_True
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
       , thUnTagged                   = @c_False
       , thOriginalBaseValue
       , thUseOriginalRates
       , thOldCompanyRate
       , thOldDailyRate
       , thFixedRate
       , thUserField3
       , thUserField4
       , thProcess
       , thSource
       , thCurrencyTriRate            = DOC.thCurrencyTriRate
       , thCurrencyTriEuro            = DOC.thCurrencyTriEuro
       , thCurrencyTriInvert          = DOC.thCurrencyTriInvert
       , thCurrencyTriFloat           = DOC.thCurrencyTriFloat
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
	   , thAnonymised
	   , thAnonymisedDate
	   , thAnonymisedTime
  FROM !ActiveSchema!.DOCUMENT DOC
  LEFT JOIN !ActiveSchema!.CUSTSUPP CS ON DOC.thAcCode   = CS.acCode
  LEFT JOIN !ActiveSchema!.CURRENCY C  ON DOC.thCurrency = C.CurrencyCode
  LEFT JOIN common.evw_HoldStatus HS ON DOC.thHoldFlag = HS.HoldStatusId
  
  WHERE DOC.PositionId = @iv_AutoReversePositionId
  AND thRunNo = 0
  
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
       , tlYear                  = CASE
                                   WHEN DOC.thPeriod = @ss_NoOfPeriodsInYear THEN DOC.thYear + 1
                                   ELSE DOC.thYear
                                   END
       , tlPeriod                = CASE
                                   WHEN DOC.thPeriod = @ss_NoOfPeriodsInYear THEN 1
                                   ELSE DOC.thPeriod + 1
                                   END
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
       , tlNetValue              = tlNetValue * -1
       , tlDiscount              = tlDiscount * -1
       , tlVATCode
       , tlVATAmount             = tlVATAmount * -1
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
       , tlReconciliationDate         = @c_MaxDate
       , tlShowCase
       , tlSdbFolio
       , tlOriginalBaseValue
       , tlUseOriginalRates           = DOC.thUseOriginalRates
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
       , tlTriRates                   = DOC.thCurrencyTriRate
       , tlTriEuro                    = DOC.thCurrencyTriEuro
       , tlTriInvert                  = DOC.thCurrencyTriInvert
       , tlTriFloat                   = DOC.thCurrencyTriFloat
       , tlSpare1
       , tlSSDUseLineValues
       , tlPreviousBalance
       , tlLiveUplift
       , tlCOSDailyRate               = DOC.thDailyRate
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
    
  WHERE DOC.PositionId = @iv_AutoReversePositionId
  AND   DOC.thRunNo = 0
  
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

  -- Update Original Transaction itself
  
  UPDATE !ActiveSchema!.DOCUMENT
     SET thPrePost   = @c_True
  WHERE PositionId = @iv_AutoReversePositionId

END

GO