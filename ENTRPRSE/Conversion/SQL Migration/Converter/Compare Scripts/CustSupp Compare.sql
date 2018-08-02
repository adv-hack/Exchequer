-- Target Table columns
DECLARE @srcacCode varchar(10)
      , @srcacCustSupp varchar(1)
      , @srcacCompany varchar(45)
      , @srcacArea varchar(4)
      , @srcacAccType varchar(4)
      , @srcacStatementTo varchar(10)
      , @srcacVATRegNo varchar(30)
      , @srcacAddressLine1 varchar(30)
      , @srcacAddressLine2 varchar(30)
      , @srcacAddressLine3 varchar(30)
      , @srcacAddressLine4 varchar(30)
      , @srcacAddressLine5 varchar(30)
      , @srcacDespAddr bit
      , @srcacDespAddressLine1 varchar(30)
      , @srcacDespAddressLine2 varchar(30)
      , @srcacDespAddressLine3 varchar(30)
      , @srcacDespAddressLine4 varchar(30)
      , @srcacDespAddressLine5 varchar(30)
      , @srcacContact varchar(25)
      , @srcacPhone varchar(30)
      , @srcacFax varchar(30)
      , @srcacTheirAcc varchar(10)
      , @srcacOwnTradTerm bit
      , @srcacTradeTerms1 varchar(80)
      , @srcacTradeTerms2 varchar(80)
      , @srcacCurrency int
      , @srcacVATCode varchar(1)
      , @srcacPayTerms int
      , @srcacCreditLimit float
      , @srcacDiscount float
      , @srcacCreditStatus int
      , @srcacCostCentre varchar(3)
      , @srcacDiscountBand varchar(1)
      , @srcacOrderConsolidationMode int
      , @srcacDefSettleDays int
      , @srcacSpare5 varbinary(2)
      , @srcacBalance float
      , @srcacDepartment varchar(3)
      , @srcacECMember bit
      , @srcacNLineCount int
      , @srcacStatement bit
      , @srcacSalesGL int
      , @srcacLocation varchar(3)
      , @srcacAccStatus int
      , @srcacPayType varchar(1)
      , @srcacBankSort varchar(15)
      , @srcacBankAcc varchar(20)
      , @srcacBankRef varchar(28)
      , @srcacAvePay int
      , @srcacPhone2 varchar(30)
      , @srcacCOSGL int
      , @srcacDrCrGL int
      , @srcacLastUsed varchar(8)
      , @srcacUserDef1 varchar(30)
      , @srcacUserDef2 varchar(30)
      , @srcacInvoiceTo varchar(10)
      , @srcacSOPAutoWOff bit
      , @srcacFormSet int
      , @srcacBookOrdVal float
      , @srcacDirDebMode int
      , @srcacCCStart varchar(8)
      , @srcacCCEnd varchar(8)
      , @srcacCCName varchar(50)
      , @srcacCCNumber varchar(30)
      , @srcacCCSwitch varchar(4)
      , @srcacDefSettleDisc float
      , @srcacStateDeliveryMode int
      , @srcacSpare2 varchar(50)
      , @srcacSendReader bit
      , @srcacEBusPword varchar(20)
      , @srcacPostCode varchar(20)
      , @srcacAltCode varchar(20)
      , @srcacUseForEbus int
      , @srcacZIPAttachments int
      , @srcacUserDef3 varchar(30)
      , @srcacUserDef4 varchar(30)
      , @srcacWebLiveCatalog varchar(20)
      , @srcacWebPrevCatalog varchar(20)
      , @srcacTimeStamp varchar(6)
      , @srcacVATCountryCode varchar(5)
      , @srcacSSDDeliveryTerms varchar(5)
      , @srcacInclusiveVATCode varchar(1)
      , @srcacSSDModeOfTransport int
      , @srcacPrivateRec bit
      , @srcacLastOperator varchar(10)
      , @srcacDocDeliveryMode int
      , @srcacSendHTML bit
      , @srcacEmailAddr varchar(100)
      , @srcacOfficeType int
      , @srcacDefTagNo int
      , @srcacUserDef5 varchar(30)
      , @srcacUserDef6 varchar(30)
      , @srcacUserDef7 varchar(30)
      , @srcacUserDef8 varchar(30)
      , @srcacUserDef9 varchar(30)
      , @srcacUserDef10 varchar(30)

-- Target Table columns

      , @trgacCode varchar(10)
      , @trgacCustSupp varchar(1)
      , @trgacCompany varchar(45)
      , @trgacArea varchar(4)
      , @trgacAccType varchar(4)
      , @trgacStatementTo varchar(10)
      , @trgacVATRegNo varchar(30)
      , @trgacAddressLine1 varchar(30)
      , @trgacAddressLine2 varchar(30)
      , @trgacAddressLine3 varchar(30)
      , @trgacAddressLine4 varchar(30)
      , @trgacAddressLine5 varchar(30)
      , @trgacDespAddr bit
      , @trgacDespAddressLine1 varchar(30)
      , @trgacDespAddressLine2 varchar(30)
      , @trgacDespAddressLine3 varchar(30)
      , @trgacDespAddressLine4 varchar(30)
      , @trgacDespAddressLine5 varchar(30)
      , @trgacContact varchar(25)
      , @trgacPhone varchar(30)
      , @trgacFax varchar(30)
      , @trgacTheirAcc varchar(10)
      , @trgacOwnTradTerm bit
      , @trgacTradeTerms1 varchar(80)
      , @trgacTradeTerms2 varchar(80)
      , @trgacCurrency int
      , @trgacVATCode varchar(1)
      , @trgacPayTerms int
      , @trgacCreditLimit float
      , @trgacDiscount float
      , @trgacCreditStatus int
      , @trgacCostCentre varchar(3)
      , @trgacDiscountBand varchar(1)
      , @trgacOrderConsolidationMode int
      , @trgacDefSettleDays int
      , @trgacSpare5 varbinary(2)
      , @trgacBalance float
      , @trgacDepartment varchar(3)
      , @trgacECMember bit
      , @trgacNLineCount int
      , @trgacStatement bit
      , @trgacSalesGL int
      , @trgacLocation varchar(3)
      , @trgacAccStatus int
      , @trgacPayType varchar(1)
      , @trgacBankSort varchar(15)
      , @trgacBankAcc varchar(20)
      , @trgacBankRef varchar(28)
      , @trgacAvePay int
      , @trgacPhone2 varchar(30)
      , @trgacCOSGL int
      , @trgacDrCrGL int
      , @trgacLastUsed varchar(8)
      , @trgacUserDef1 varchar(30)
      , @trgacUserDef2 varchar(30)
      , @trgacInvoiceTo varchar(10)
      , @trgacSOPAutoWOff bit
      , @trgacFormSet int
      , @trgacBookOrdVal float
      , @trgacDirDebMode int
      , @trgacCCStart varchar(8)
      , @trgacCCEnd varchar(8)
      , @trgacCCName varchar(50)
      , @trgacCCNumber varchar(30)
      , @trgacCCSwitch varchar(4)
      , @trgacDefSettleDisc float
      , @trgacStateDeliveryMode int
      , @trgacSpare2 varchar(50)
      , @trgacSendReader bit
      , @trgacEBusPword varchar(20)
      , @trgacPostCode varchar(20)
      , @trgacAltCode varchar(20)
      , @trgacUseForEbus int
      , @trgacZIPAttachments int
      , @trgacUserDef3 varchar(30)
      , @trgacUserDef4 varchar(30)
      , @trgacWebLiveCatalog varchar(20)
      , @trgacWebPrevCatalog varchar(20)
      , @trgacTimeStamp varchar(6)
      , @trgacVATCountryCode varchar(5)
      , @trgacSSDDeliveryTerms varchar(5)
      , @trgacInclusiveVATCode varchar(1)
      , @trgacSSDModeOfTransport int
      , @trgacPrivateRec bit
      , @trgacLastOperator varchar(10)
      , @trgacDocDeliveryMode int
      , @trgacSendHTML bit
      , @trgacEmailAddr varchar(100)
      , @trgacOfficeType int
      , @trgacDefTagNo int
      , @trgacUserDef5 varchar(30)
      , @trgacUserDef6 varchar(30)
      , @trgacUserDef7 varchar(30)
      , @trgacUserDef8 varchar(30)
      , @trgacUserDef9 varchar(30)
      , @trgacUserDef10 varchar(30)

DECLARE srcCustSupp CURSOR FOR SELECT acCode
                                    , acCustSupp
                                    , acCompany
                                    , acArea
                                    , acAccType
                                    , acStatementTo
                                    , acVATRegNo
                                    , acAddressLine1
                                    , acAddressLine2
                                    , acAddressLine3
                                    , acAddressLine4
                                    , acAddressLine5
                                    , acDespAddr
                                    , acDespAddressLine1
                                    , acDespAddressLine2
                                    , acDespAddressLine3
                                    , acDespAddressLine4
                                    , acDespAddressLine5
                                    , acContact
                                    , acPhone
                                    , acFax
                                    , acTheirAcc
                                    , acOwnTradTerm
                                    , acTradeTerms1
                                    , acTradeTerms2
                                    , acCurrency
                                    , acVATCode
                                    , acPayTerms
                                    , acCreditLimit
                                    , acDiscount
                                    , acCreditStatus
                                    , acCostCentre
                                    , acDiscountBand
                                    , acOrderConsolidationMode
                                    , acDefSettleDays
                                    , acSpare5
                                    , acBalance
                                    , acDepartment
                                    , acECMember
                                    , acNLineCount
                                    , acStatement
                                    , acSalesGL
                                    , acLocation
                                    , acAccStatus
                                    , acPayType
                                    , acBankSort
                                    , acBankAcc
                                    , acBankRef
                                    , acAvePay
                                    , acPhone2
                                    , acCOSGL
                                    , acDrCrGL
                                    , acLastUsed
                                    , acUserDef1
                                    , acUserDef2
                                    , acInvoiceTo
                                    , acSOPAutoWOff
                                    , acFormSet
                                    , acBookOrdVal
                                    , acDirDebMode
                                    , acCCStart
                                    , acCCEnd
                                    , acCCName
                                    , acCCNumber
                                    , acCCSwitch
                                    , acDefSettleDisc
                                    , acStateDeliveryMode
                                    , acSpare2
                                    , acSendReader
                                    , acEBusPword
                                    , acPostCode
                                    , acAltCode
                                    , acUseForEbus
                                    , acZIPAttachments
                                    , acUserDef3
                                    , acUserDef4
                                    , acWebLiveCatalog
                                    , acWebPrevCatalog
                                    , acTimeStamp
                                    , acVATCountryCode
                                    , acSSDDeliveryTerms
                                    , acInclusiveVATCode
                                    , acSSDModeOfTransport
                                    , acPrivateRec
                                    , acLastOperator
                                    , acDocDeliveryMode
                                    , acSendHTML
                                    , acEmailAddr
                                    , acOfficeType
                                    , acDefTagNo
                                    , acUserDef5
                                    , acUserDef6
                                    , acUserDef7
                                    , acUserDef8
                                    , acUserDef9
                                    , acUserDef10
                               FROM   ConvMasterPR70.MAIN01.CustSupp

OPEN srcCustSupp

FETCH NEXT FROM srcCustSupp INTO @srcacCode
                               , @srcacCustSupp
                               , @srcacCompany
                               , @srcacArea
                               , @srcacAccType
                               , @srcacStatementTo
                               , @srcacVATRegNo
                               , @srcacAddressLine1
                               , @srcacAddressLine2
                               , @srcacAddressLine3
                               , @srcacAddressLine4
                               , @srcacAddressLine5
                               , @srcacDespAddr
                               , @srcacDespAddressLine1
                               , @srcacDespAddressLine2
                               , @srcacDespAddressLine3
                               , @srcacDespAddressLine4
                               , @srcacDespAddressLine5
                               , @srcacContact
                               , @srcacPhone
                               , @srcacFax
                               , @srcacTheirAcc
                               , @srcacOwnTradTerm
                               , @srcacTradeTerms1
                               , @srcacTradeTerms2
                               , @srcacCurrency
                               , @srcacVATCode
                               , @srcacPayTerms
                               , @srcacCreditLimit
                               , @srcacDiscount
                               , @srcacCreditStatus
                               , @srcacCostCentre
                               , @srcacDiscountBand
                               , @srcacOrderConsolidationMode
                               , @srcacDefSettleDays
                               , @srcacSpare5
                               , @srcacBalance
                               , @srcacDepartment
                               , @srcacECMember
                               , @srcacNLineCount
                               , @srcacStatement
                               , @srcacSalesGL
                               , @srcacLocation
                               , @srcacAccStatus
                               , @srcacPayType
                               , @srcacBankSort
                               , @srcacBankAcc
                               , @srcacBankRef
                               , @srcacAvePay
                               , @srcacPhone2
                               , @srcacCOSGL
                               , @srcacDrCrGL
                               , @srcacLastUsed
                               , @srcacUserDef1
                               , @srcacUserDef2
                               , @srcacInvoiceTo
                               , @srcacSOPAutoWOff
                               , @srcacFormSet
                               , @srcacBookOrdVal
                               , @srcacDirDebMode
                               , @srcacCCStart
                               , @srcacCCEnd
                               , @srcacCCName
                               , @srcacCCNumber
                               , @srcacCCSwitch
                               , @srcacDefSettleDisc
                               , @srcacStateDeliveryMode
                               , @srcacSpare2
                               , @srcacSendReader
                               , @srcacEBusPword
                               , @srcacPostCode
                               , @srcacAltCode
                               , @srcacUseForEbus
                               , @srcacZIPAttachments
                               , @srcacUserDef3
                               , @srcacUserDef4
                               , @srcacWebLiveCatalog
                               , @srcacWebPrevCatalog
                               , @srcacTimeStamp
                               , @srcacVATCountryCode
                               , @srcacSSDDeliveryTerms
                               , @srcacInclusiveVATCode
                               , @srcacSSDModeOfTransport
                               , @srcacPrivateRec
                               , @srcacLastOperator
                               , @srcacDocDeliveryMode
                               , @srcacSendHTML
                               , @srcacEmailAddr
                               , @srcacOfficeType
                               , @srcacDefTagNo
                               , @srcacUserDef5
                               , @srcacUserDef6
                               , @srcacUserDef7
                               , @srcacUserDef8
                               , @srcacUserDef9
                               , @srcacUserDef10

WHILE @@FETCH_STATUS = 0
BEGIN
  -- Get Target Columns for same row
  SELECT @trgacCustSupp = acCustSupp
       , @trgacCompany = acCompany
       , @trgacArea = acArea
       , @trgacAccType = acAccType
       , @trgacStatementTo = acStatementTo
       , @trgacVATRegNo = acVATRegNo
       , @trgacAddressLine1 = acAddressLine1
       , @trgacAddressLine2 = acAddressLine2
       , @trgacAddressLine3 = acAddressLine3
       , @trgacAddressLine4 = acAddressLine4
       , @trgacAddressLine5 = acAddressLine5
       , @trgacDespAddr = acDespAddr
       , @trgacDespAddressLine1 = acDespAddressLine1
       , @trgacDespAddressLine2 = acDespAddressLine2
       , @trgacDespAddressLine3 = acDespAddressLine3
       , @trgacDespAddressLine4 = acDespAddressLine4
       , @trgacDespAddressLine5 = acDespAddressLine5
       , @trgacContact = acContact
       , @trgacPhone = acPhone
       , @trgacFax = acFax
       , @trgacTheirAcc = acTheirAcc
       , @trgacOwnTradTerm = acOwnTradTerm
       , @trgacTradeTerms1 = acTradeTerms1
       , @trgacTradeTerms2 = acTradeTerms2
       , @trgacCurrency = acCurrency
       , @trgacVATCode = acVATCode
       , @trgacPayTerms = acPayTerms
       , @trgacCreditLimit = acCreditLimit
       , @trgacDiscount = acDiscount
       , @trgacCreditStatus = acCreditStatus
       , @trgacCostCentre = acCostCentre
       , @trgacDiscountBand = acDiscountBand
       , @trgacOrderConsolidationMode = acOrderConsolidationMode
       , @trgacDefSettleDays = acDefSettleDays
       , @trgacSpare5 = acSpare5
       , @trgacBalance = acBalance
       , @trgacDepartment = acDepartment
       , @trgacECMember = acECMember
       , @trgacNLineCount = acNLineCount
       , @trgacStatement = acStatement
       , @trgacSalesGL = acSalesGL
       , @trgacLocation = acLocation
       , @trgacAccStatus = acAccStatus
       , @trgacPayType = acPayType
       , @trgacBankSort = acBankSort
       , @trgacBankAcc = acBankAcc
       , @trgacBankRef = acBankRef
       , @trgacAvePay = acAvePay
       , @trgacPhone2 = acPhone2
       , @trgacCOSGL = acCOSGL
       , @trgacDrCrGL = acDrCrGL
       , @trgacLastUsed = acLastUsed
       , @trgacUserDef1 = acUserDef1
       , @trgacUserDef2 = acUserDef2
       , @trgacInvoiceTo = acInvoiceTo
       , @trgacSOPAutoWOff = acSOPAutoWOff
       , @trgacFormSet = acFormSet
       , @trgacBookOrdVal = acBookOrdVal
       , @trgacDirDebMode = acDirDebMode
       , @trgacCCStart = acCCStart
       , @trgacCCEnd = acCCEnd
       , @trgacCCName = acCCName
       , @trgacCCNumber = acCCNumber
       , @trgacCCSwitch = acCCSwitch
       , @trgacDefSettleDisc = acDefSettleDisc
       , @trgacStateDeliveryMode = acStateDeliveryMode
       , @trgacSpare2 = acSpare2
       , @trgacSendReader = acSendReader
       , @trgacEBusPword = acEBusPword
       , @trgacPostCode = acPostCode
       , @trgacAltCode = acAltCode
       , @trgacUseForEbus = acUseForEbus
       , @trgacZIPAttachments = acZIPAttachments
       , @trgacUserDef3 = acUserDef3
       , @trgacUserDef4 = acUserDef4
       , @trgacWebLiveCatalog = acWebLiveCatalog
       , @trgacWebPrevCatalog = acWebPrevCatalog
       , @trgacTimeStamp = acTimeStamp
       , @trgacVATCountryCode = acVATCountryCode
       , @trgacSSDDeliveryTerms = acSSDDeliveryTerms
       , @trgacInclusiveVATCode = acInclusiveVATCode
       , @trgacSSDModeOfTransport = acSSDModeOfTransport
       , @trgacPrivateRec = acPrivateRec
       , @trgacLastOperator = acLastOperator
       , @trgacDocDeliveryMode = acDocDeliveryMode
       , @trgacSendHTML = acSendHTML
       , @trgacEmailAddr = acEmailAddr
       , @trgacOfficeType = acOfficeType
       , @trgacDefTagNo = acDefTagNo
       , @trgacUserDef5 = acUserDef5
       , @trgacUserDef6 = acUserDef6
       , @trgacUserDef7 = acUserDef7
       , @trgacUserDef8 = acUserDef8
       , @trgacUserDef9 = acUserDef9
       , @trgacUserDef10 = acUserDef10
  FROM Exch70Conv.MAIN01.CustSupp
  WHERE acCode = @srcacCode

  -- Compare columns
  IF (@srcacCustSupp <> @trgacCustSupp) Or ((@srcacCustSupp IS NULL) And (@trgacCustSupp IS NOT NULL)) Or ((@srcacCustSupp IS NOT NULL) And (@trgacCustSupp IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCustSupp = ' + @srcacCustSupp + ' / ' + @trgacCustSupp
  END
  ELSE IF (@srcacCompany <> @trgacCompany) Or ((@srcacCompany IS NULL) And (@trgacCompany IS NOT NULL)) Or ((@srcacCompany IS NOT NULL) And (@trgacCompany IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCompany = ' + @srcacCompany + ' / ' + @trgacCompany
  END
  ELSE IF (@srcacArea <> @trgacArea) Or ((@srcacArea IS NULL) And (@trgacArea IS NOT NULL)) Or ((@srcacArea IS NOT NULL) And (@trgacArea IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acArea = ' + @srcacArea + ' / ' + @trgacArea
  END
  ELSE IF (@srcacAccType <> @trgacAccType) Or ((@srcacAccType IS NULL) And (@trgacAccType IS NOT NULL)) Or ((@srcacAccType IS NOT NULL) And (@trgacAccType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAccType = ' + @srcacAccType + ' / ' + @trgacAccType
  END
  ELSE IF (@srcacStatementTo <> @trgacStatementTo) Or ((@srcacStatementTo IS NULL) And (@trgacStatementTo IS NOT NULL)) Or ((@srcacStatementTo IS NOT NULL) And (@trgacStatementTo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acStatementTo = ' + @srcacStatementTo + ' / ' + @trgacStatementTo
  END
  ELSE IF (@srcacVATRegNo <> @trgacVATRegNo) Or ((@srcacVATRegNo IS NULL) And (@trgacVATRegNo IS NOT NULL)) Or ((@srcacVATRegNo IS NOT NULL) And (@trgacVATRegNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acVATRegNo = ' + @srcacVATRegNo + ' / ' + @trgacVATRegNo
  END
  ELSE IF (@srcacAddressLine1 <> @trgacAddressLine1) Or ((@srcacAddressLine1 IS NULL) And (@trgacAddressLine1 IS NOT NULL)) Or ((@srcacAddressLine1 IS NOT NULL) And (@trgacAddressLine1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAddressLine1 = ' + @srcacAddressLine1 + ' / ' + @trgacAddressLine1
  END
  ELSE IF (@srcacAddressLine2 <> @trgacAddressLine2) Or ((@srcacAddressLine2 IS NULL) And (@trgacAddressLine2 IS NOT NULL)) Or ((@srcacAddressLine2 IS NOT NULL) And (@trgacAddressLine2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAddressLine2 = ' + @srcacAddressLine2 + ' / ' + @trgacAddressLine2
  END
  ELSE IF (@srcacAddressLine3 <> @trgacAddressLine3) Or ((@srcacAddressLine3 IS NULL) And (@trgacAddressLine3 IS NOT NULL)) Or ((@srcacAddressLine3 IS NOT NULL) And (@trgacAddressLine3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAddressLine3 = ' + @srcacAddressLine3 + ' / ' + @trgacAddressLine3
  END
  ELSE IF (@srcacAddressLine4 <> @trgacAddressLine4) Or ((@srcacAddressLine4 IS NULL) And (@trgacAddressLine4 IS NOT NULL)) Or ((@srcacAddressLine4 IS NOT NULL) And (@trgacAddressLine4 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAddressLine4 = ' + @srcacAddressLine4 + ' / ' + @trgacAddressLine4
  END
  ELSE IF (@srcacAddressLine5 <> @trgacAddressLine5) Or ((@srcacAddressLine5 IS NULL) And (@trgacAddressLine5 IS NOT NULL)) Or ((@srcacAddressLine5 IS NOT NULL) And (@trgacAddressLine5 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAddressLine5 = ' + @srcacAddressLine5 + ' / ' + @trgacAddressLine5
  END
  ELSE IF (@srcacDespAddr <> @trgacDespAddr) Or ((@srcacDespAddr IS NULL) And (@trgacDespAddr IS NOT NULL)) Or ((@srcacDespAddr IS NOT NULL) And (@trgacDespAddr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddr = ' + STR(@srcacDespAddr) + ' / ' + STR(@trgacDespAddr)
  END
  ELSE IF (@srcacDespAddressLine1 <> @trgacDespAddressLine1) Or ((@srcacDespAddressLine1 IS NULL) And (@trgacDespAddressLine1 IS NOT NULL)) Or ((@srcacDespAddressLine1 IS NOT NULL) And (@trgacDespAddressLine1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddressLine1 = ' + @srcacDespAddressLine1 + ' / ' + @trgacDespAddressLine1
  END
  ELSE IF (@srcacDespAddressLine2 <> @trgacDespAddressLine2) Or ((@srcacDespAddressLine2 IS NULL) And (@trgacDespAddressLine2 IS NOT NULL)) Or ((@srcacDespAddressLine2 IS NOT NULL) And (@trgacDespAddressLine2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddressLine2 = ' + @srcacDespAddressLine2 + ' / ' + @trgacDespAddressLine2
  END
  ELSE IF (@srcacDespAddressLine3 <> @trgacDespAddressLine3) Or ((@srcacDespAddressLine3 IS NULL) And (@trgacDespAddressLine3 IS NOT NULL)) Or ((@srcacDespAddressLine3 IS NOT NULL) And (@trgacDespAddressLine3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddressLine3 = ' + @srcacDespAddressLine3 + ' / ' + @trgacDespAddressLine3
  END
  ELSE IF (@srcacDespAddressLine4 <> @trgacDespAddressLine4) Or ((@srcacDespAddressLine4 IS NULL) And (@trgacDespAddressLine4 IS NOT NULL)) Or ((@srcacDespAddressLine4 IS NOT NULL) And (@trgacDespAddressLine4 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddressLine4 = ' + @srcacDespAddressLine4 + ' / ' + @trgacDespAddressLine4
  END
  ELSE IF (@srcacDespAddressLine5 <> @trgacDespAddressLine5) Or ((@srcacDespAddressLine5 IS NULL) And (@trgacDespAddressLine5 IS NOT NULL)) Or ((@srcacDespAddressLine5 IS NOT NULL) And (@trgacDespAddressLine5 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDespAddressLine5 = ' + @srcacDespAddressLine5 + ' / ' + @trgacDespAddressLine5
  END
  ELSE IF (@srcacContact <> @trgacContact) Or ((@srcacContact IS NULL) And (@trgacContact IS NOT NULL)) Or ((@srcacContact IS NOT NULL) And (@trgacContact IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acContact = ' + @srcacContact + ' / ' + @trgacContact
  END
  ELSE IF (@srcacPhone <> @trgacPhone) Or ((@srcacPhone IS NULL) And (@trgacPhone IS NOT NULL)) Or ((@srcacPhone IS NOT NULL) And (@trgacPhone IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPhone = ' + @srcacPhone + ' / ' + @trgacPhone
  END
  ELSE IF (@srcacFax <> @trgacFax) Or ((@srcacFax IS NULL) And (@trgacFax IS NOT NULL)) Or ((@srcacFax IS NOT NULL) And (@trgacFax IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acFax = ' + @srcacFax + ' / ' + @trgacFax
  END
  ELSE IF (@srcacTheirAcc <> @trgacTheirAcc) Or ((@srcacTheirAcc IS NULL) And (@trgacTheirAcc IS NOT NULL)) Or ((@srcacTheirAcc IS NOT NULL) And (@trgacTheirAcc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acTheirAcc = ' + @srcacTheirAcc + ' / ' + @trgacTheirAcc
  END
  ELSE IF (@srcacOwnTradTerm <> @trgacOwnTradTerm) Or ((@srcacOwnTradTerm IS NULL) And (@trgacOwnTradTerm IS NOT NULL)) Or ((@srcacOwnTradTerm IS NOT NULL) And (@trgacOwnTradTerm IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acOwnTradTerm = ' + STR(@srcacOwnTradTerm) + ' / ' + STR(@trgacOwnTradTerm)
  END
  ELSE IF (@srcacTradeTerms1 <> @trgacTradeTerms1) Or ((@srcacTradeTerms1 IS NULL) And (@trgacTradeTerms1 IS NOT NULL)) Or ((@srcacTradeTerms1 IS NOT NULL) And (@trgacTradeTerms1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acTradeTerms1 = ' + @srcacTradeTerms1 + ' / ' + @trgacTradeTerms1
  END
  ELSE IF (@srcacTradeTerms2 <> @trgacTradeTerms2) Or ((@srcacTradeTerms2 IS NULL) And (@trgacTradeTerms2 IS NOT NULL)) Or ((@srcacTradeTerms2 IS NOT NULL) And (@trgacTradeTerms2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acTradeTerms2 = ' + @srcacTradeTerms2 + ' / ' + @trgacTradeTerms2
  END
  ELSE IF (@srcacCurrency <> @trgacCurrency) Or ((@srcacCurrency IS NULL) And (@trgacCurrency IS NOT NULL)) Or ((@srcacCurrency IS NOT NULL) And (@trgacCurrency IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCurrency = ' + STR(@srcacCurrency) + ' / ' + STR(@trgacCurrency)
  END
  ELSE IF (@srcacVATCode <> @trgacVATCode) Or ((@srcacVATCode IS NULL) And (@trgacVATCode IS NOT NULL)) Or ((@srcacVATCode IS NOT NULL) And (@trgacVATCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acVATCode = ' + @srcacVATCode + ' / ' + @trgacVATCode
  END
  ELSE IF (@srcacPayTerms <> @trgacPayTerms) Or ((@srcacPayTerms IS NULL) And (@trgacPayTerms IS NOT NULL)) Or ((@srcacPayTerms IS NOT NULL) And (@trgacPayTerms IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPayTerms = ' + STR(@srcacPayTerms) + ' / ' + STR(@trgacPayTerms)
  END
  ELSE IF (@srcacCreditLimit <> @trgacCreditLimit) Or ((@srcacCreditLimit IS NULL) And (@trgacCreditLimit IS NOT NULL)) Or ((@srcacCreditLimit IS NOT NULL) And (@trgacCreditLimit IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCreditLimit = ' + @srcacCreditLimit + ' / ' + @trgacCreditLimit
  END
  ELSE IF (@srcacDiscount <> @trgacDiscount) Or ((@srcacDiscount IS NULL) And (@trgacDiscount IS NOT NULL)) Or ((@srcacDiscount IS NOT NULL) And (@trgacDiscount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDiscount = ' + @srcacDiscount + ' / ' + @trgacDiscount
  END
  ELSE IF (@srcacCreditStatus <> @trgacCreditStatus) Or ((@srcacCreditStatus IS NULL) And (@trgacCreditStatus IS NOT NULL)) Or ((@srcacCreditStatus IS NOT NULL) And (@trgacCreditStatus IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCreditStatus = ' + STR(@srcacCreditStatus) + ' / ' + STR(@trgacCreditStatus)
  END
  ELSE IF (@srcacCostCentre <> @trgacCostCentre) Or ((@srcacCostCentre IS NULL) And (@trgacCostCentre IS NOT NULL)) Or ((@srcacCostCentre IS NOT NULL) And (@trgacCostCentre IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCostCentre = ' + @srcacCostCentre + ' / ' + @trgacCostCentre
  END
  ELSE IF (@srcacDiscountBand <> @trgacDiscountBand) Or ((@srcacDiscountBand IS NULL) And (@trgacDiscountBand IS NOT NULL)) Or ((@srcacDiscountBand IS NOT NULL) And (@trgacDiscountBand IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDiscountBand = ' + @srcacDiscountBand + ' / ' + @trgacDiscountBand
  END
  ELSE IF (@srcacOrderConsolidationMode <> @trgacOrderConsolidationMode) Or ((@srcacOrderConsolidationMode IS NULL) And (@trgacOrderConsolidationMode IS NOT NULL)) Or ((@srcacOrderConsolidationMode IS NOT NULL) And (@trgacOrderConsolidationMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acOrderConsolidationMode = ' + STR(@srcacOrderConsolidationMode) + ' / ' + STR(@trgacOrderConsolidationMode)
  END
  ELSE IF (@srcacDefSettleDays <> @trgacDefSettleDays) Or ((@srcacDefSettleDays IS NULL) And (@trgacDefSettleDays IS NOT NULL)) Or ((@srcacDefSettleDays IS NOT NULL) And (@trgacDefSettleDays IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDefSettleDays = ' + STR(@srcacDefSettleDays) + ' / ' + STR(@trgacDefSettleDays)
  END
  ELSE IF (@srcacSpare5 <> @trgacSpare5) Or ((@srcacSpare5 IS NULL) And (@trgacSpare5 IS NOT NULL)) Or ((@srcacSpare5 IS NOT NULL) And (@trgacSpare5 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSpare5 is different'
  END
  ELSE IF (@srcacBalance <> @trgacBalance) Or ((@srcacBalance IS NULL) And (@trgacBalance IS NOT NULL)) Or ((@srcacBalance IS NOT NULL) And (@trgacBalance IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acBalance = ' + @srcacBalance + ' / ' + @trgacBalance
  END
  ELSE IF (@srcacDepartment <> @trgacDepartment) Or ((@srcacDepartment IS NULL) And (@trgacDepartment IS NOT NULL)) Or ((@srcacDepartment IS NOT NULL) And (@trgacDepartment IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDepartment = ' + @srcacDepartment + ' / ' + @trgacDepartment
  END
  ELSE IF (@srcacECMember <> @trgacECMember) Or ((@srcacECMember IS NULL) And (@trgacECMember IS NOT NULL)) Or ((@srcacECMember IS NOT NULL) And (@trgacECMember IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acECMember = ' + STR(@srcacECMember) + ' / ' + STR(@trgacECMember)
  END
  ELSE IF (@srcacNLineCount <> @trgacNLineCount) Or ((@srcacNLineCount IS NULL) And (@trgacNLineCount IS NOT NULL)) Or ((@srcacNLineCount IS NOT NULL) And (@trgacNLineCount IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acNLineCount = ' + STR(@srcacNLineCount) + ' / ' + STR(@trgacNLineCount)
  END
  ELSE IF (@srcacStatement <> @trgacStatement) Or ((@srcacStatement IS NULL) And (@trgacStatement IS NOT NULL)) Or ((@srcacStatement IS NOT NULL) And (@trgacStatement IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acStatement = ' + STR(@srcacStatement) + ' / ' + STR(@trgacStatement)
  END
  ELSE IF (@srcacSalesGL <> @trgacSalesGL) Or ((@srcacSalesGL IS NULL) And (@trgacSalesGL IS NOT NULL)) Or ((@srcacSalesGL IS NOT NULL) And (@trgacSalesGL IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSalesGL = ' + STR(@srcacSalesGL) + ' / ' + STR(@trgacSalesGL)
  END
  ELSE IF (@srcacLocation <> @trgacLocation) Or ((@srcacLocation IS NULL) And (@trgacLocation IS NOT NULL)) Or ((@srcacLocation IS NOT NULL) And (@trgacLocation IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acLocation = ' + @srcacLocation + ' / ' + @trgacLocation
  END
  ELSE IF (@srcacAccStatus <> @trgacAccStatus) Or ((@srcacAccStatus IS NULL) And (@trgacAccStatus IS NOT NULL)) Or ((@srcacAccStatus IS NOT NULL) And (@trgacAccStatus IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAccStatus = ' + STR(@srcacAccStatus) + ' / ' + STR(@trgacAccStatus)
  END
  ELSE IF (@srcacPayType <> @trgacPayType) Or ((@srcacPayType IS NULL) And (@trgacPayType IS NOT NULL)) Or ((@srcacPayType IS NOT NULL) And (@trgacPayType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPayType = ' + @srcacPayType + ' / ' + @trgacPayType
  END
  ELSE IF (@srcacBankSort <> @trgacBankSort) Or ((@srcacBankSort IS NULL) And (@trgacBankSort IS NOT NULL)) Or ((@srcacBankSort IS NOT NULL) And (@trgacBankSort IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acBankSort = ' + @srcacBankSort + ' / ' + @trgacBankSort
  END
  ELSE IF (@srcacBankAcc <> @trgacBankAcc) Or ((@srcacBankAcc IS NULL) And (@trgacBankAcc IS NOT NULL)) Or ((@srcacBankAcc IS NOT NULL) And (@trgacBankAcc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acBankAcc = ' + @srcacBankAcc + ' / ' + @trgacBankAcc
  END
  ELSE IF (@srcacBankRef <> @trgacBankRef) Or ((@srcacBankRef IS NULL) And (@trgacBankRef IS NOT NULL)) Or ((@srcacBankRef IS NOT NULL) And (@trgacBankRef IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acBankRef = ' + @srcacBankRef + ' / ' + @trgacBankRef
  END
  ELSE IF (@srcacAvePay <> @trgacAvePay) Or ((@srcacAvePay IS NULL) And (@trgacAvePay IS NOT NULL)) Or ((@srcacAvePay IS NOT NULL) And (@trgacAvePay IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAvePay = ' + STR(@srcacAvePay) + ' / ' + STR(@trgacAvePay)
  END
  ELSE IF (@srcacPhone2 <> @trgacPhone2) Or ((@srcacPhone2 IS NULL) And (@trgacPhone2 IS NOT NULL)) Or ((@srcacPhone2 IS NOT NULL) And (@trgacPhone2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPhone2 = ' + @srcacPhone2 + ' / ' + @trgacPhone2
  END
  ELSE IF (@srcacCOSGL <> @trgacCOSGL) Or ((@srcacCOSGL IS NULL) And (@trgacCOSGL IS NOT NULL)) Or ((@srcacCOSGL IS NOT NULL) And (@trgacCOSGL IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCOSGL = ' + STR(@srcacCOSGL) + ' / ' + STR(@trgacCOSGL)
  END
  ELSE IF (@srcacDrCrGL <> @trgacDrCrGL) Or ((@srcacDrCrGL IS NULL) And (@trgacDrCrGL IS NOT NULL)) Or ((@srcacDrCrGL IS NOT NULL) And (@trgacDrCrGL IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDrCrGL = ' + STR(@srcacDrCrGL) + ' / ' + STR(@trgacDrCrGL)
  END
  ELSE IF (@srcacLastUsed <> @trgacLastUsed) Or ((@srcacLastUsed IS NULL) And (@trgacLastUsed IS NOT NULL)) Or ((@srcacLastUsed IS NOT NULL) And (@trgacLastUsed IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acLastUsed = ' + @srcacLastUsed + ' / ' + @trgacLastUsed
  END
  ELSE IF (@srcacUserDef1 <> @trgacUserDef1) Or ((@srcacUserDef1 IS NULL) And (@trgacUserDef1 IS NOT NULL)) Or ((@srcacUserDef1 IS NOT NULL) And (@trgacUserDef1 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef1 = ' + @srcacUserDef1 + ' / ' + @trgacUserDef1
  END
  ELSE IF (@srcacUserDef2 <> @trgacUserDef2) Or ((@srcacUserDef2 IS NULL) And (@trgacUserDef2 IS NOT NULL)) Or ((@srcacUserDef2 IS NOT NULL) And (@trgacUserDef2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef2 = ' + @srcacUserDef2 + ' / ' + @trgacUserDef2
  END
  ELSE IF (@srcacInvoiceTo <> @trgacInvoiceTo) Or ((@srcacInvoiceTo IS NULL) And (@trgacInvoiceTo IS NOT NULL)) Or ((@srcacInvoiceTo IS NOT NULL) And (@trgacInvoiceTo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acInvoiceTo = ' + @srcacInvoiceTo + ' / ' + @trgacInvoiceTo
  END
  ELSE IF (@srcacSOPAutoWOff <> @trgacSOPAutoWOff) Or ((@srcacSOPAutoWOff IS NULL) And (@trgacSOPAutoWOff IS NOT NULL)) Or ((@srcacSOPAutoWOff IS NOT NULL) And (@trgacSOPAutoWOff IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSOPAutoWOff = ' + STR(@srcacSOPAutoWOff) + ' / ' + STR(@trgacSOPAutoWOff)
  END
  ELSE IF (@srcacFormSet <> @trgacFormSet) Or ((@srcacFormSet IS NULL) And (@trgacFormSet IS NOT NULL)) Or ((@srcacFormSet IS NOT NULL) And (@trgacFormSet IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acFormSet = ' + STR(@srcacFormSet) + ' / ' + STR(@trgacFormSet)
  END
  ELSE IF (@srcacBookOrdVal <> @trgacBookOrdVal) Or ((@srcacBookOrdVal IS NULL) And (@trgacBookOrdVal IS NOT NULL)) Or ((@srcacBookOrdVal IS NOT NULL) And (@trgacBookOrdVal IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acBookOrdVal = ' + @srcacBookOrdVal + ' / ' + @trgacBookOrdVal
  END
  ELSE IF (@srcacDirDebMode <> @trgacDirDebMode) Or ((@srcacDirDebMode IS NULL) And (@trgacDirDebMode IS NOT NULL)) Or ((@srcacDirDebMode IS NOT NULL) And (@trgacDirDebMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDirDebMode = ' + STR(@srcacDirDebMode) + ' / ' + STR(@trgacDirDebMode)
  END
  ELSE IF (@srcacCCStart <> @trgacCCStart) Or ((@srcacCCStart IS NULL) And (@trgacCCStart IS NOT NULL)) Or ((@srcacCCStart IS NOT NULL) And (@trgacCCStart IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCCStart = ' + @srcacCCStart + ' / ' + @trgacCCStart
  END
  ELSE IF (@srcacCCEnd <> @trgacCCEnd) Or ((@srcacCCEnd IS NULL) And (@trgacCCEnd IS NOT NULL)) Or ((@srcacCCEnd IS NOT NULL) And (@trgacCCEnd IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCCEnd = ' + @srcacCCEnd + ' / ' + @trgacCCEnd
  END
  ELSE IF (@srcacCCName <> @trgacCCName) Or ((@srcacCCName IS NULL) And (@trgacCCName IS NOT NULL)) Or ((@srcacCCName IS NOT NULL) And (@trgacCCName IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCCName = ' + @srcacCCName + ' / ' + @trgacCCName
  END
  ELSE IF (@srcacCCNumber <> @trgacCCNumber) Or ((@srcacCCNumber IS NULL) And (@trgacCCNumber IS NOT NULL)) Or ((@srcacCCNumber IS NOT NULL) And (@trgacCCNumber IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCCNumber = ' + @srcacCCNumber + ' / ' + @trgacCCNumber
  END
  ELSE IF (@srcacCCSwitch <> @trgacCCSwitch) Or ((@srcacCCSwitch IS NULL) And (@trgacCCSwitch IS NOT NULL)) Or ((@srcacCCSwitch IS NOT NULL) And (@trgacCCSwitch IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acCCSwitch = ' + @srcacCCSwitch + ' / ' + @trgacCCSwitch
  END
  ELSE IF (@srcacDefSettleDisc <> @trgacDefSettleDisc) Or ((@srcacDefSettleDisc IS NULL) And (@trgacDefSettleDisc IS NOT NULL)) Or ((@srcacDefSettleDisc IS NOT NULL) And (@trgacDefSettleDisc IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDefSettleDisc = ' + @srcacDefSettleDisc + ' / ' + @trgacDefSettleDisc
  END
  ELSE IF (@srcacStateDeliveryMode <> @trgacStateDeliveryMode) Or ((@srcacStateDeliveryMode IS NULL) And (@trgacStateDeliveryMode IS NOT NULL)) Or ((@srcacStateDeliveryMode IS NOT NULL) And (@trgacStateDeliveryMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acStateDeliveryMode = ' + STR(@srcacStateDeliveryMode) + ' / ' + STR(@trgacStateDeliveryMode)
  END
  ELSE IF (@srcacSpare2 <> @trgacSpare2) Or ((@srcacSpare2 IS NULL) And (@trgacSpare2 IS NOT NULL)) Or ((@srcacSpare2 IS NOT NULL) And (@trgacSpare2 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSpare2 = ' + @srcacSpare2 + ' / ' + @trgacSpare2
  END
  ELSE IF (@srcacSendReader <> @trgacSendReader) Or ((@srcacSendReader IS NULL) And (@trgacSendReader IS NOT NULL)) Or ((@srcacSendReader IS NOT NULL) And (@trgacSendReader IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSendReader = ' + STR(@srcacSendReader) + ' / ' + STR(@trgacSendReader)
  END
  ELSE IF (@srcacEBusPword <> @trgacEBusPword) Or ((@srcacEBusPword IS NULL) And (@trgacEBusPword IS NOT NULL)) Or ((@srcacEBusPword IS NOT NULL) And (@trgacEBusPword IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acEBusPword = ' + @srcacEBusPword + ' / ' + @trgacEBusPword
  END
  ELSE IF (@srcacPostCode <> @trgacPostCode) Or ((@srcacPostCode IS NULL) And (@trgacPostCode IS NOT NULL)) Or ((@srcacPostCode IS NOT NULL) And (@trgacPostCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPostCode = ' + @srcacPostCode + ' / ' + @trgacPostCode
  END
  ELSE IF (@srcacAltCode <> @trgacAltCode) Or ((@srcacAltCode IS NULL) And (@trgacAltCode IS NOT NULL)) Or ((@srcacAltCode IS NOT NULL) And (@trgacAltCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acAltCode = ' + @srcacAltCode + ' / ' + @trgacAltCode
  END
  ELSE IF (@srcacUseForEbus <> @trgacUseForEbus) Or ((@srcacUseForEbus IS NULL) And (@trgacUseForEbus IS NOT NULL)) Or ((@srcacUseForEbus IS NOT NULL) And (@trgacUseForEbus IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUseForEbus = ' + STR(@srcacUseForEbus) + ' / ' + STR(@trgacUseForEbus)
  END
  ELSE IF (@srcacZIPAttachments <> @trgacZIPAttachments) Or ((@srcacZIPAttachments IS NULL) And (@trgacZIPAttachments IS NOT NULL)) Or ((@srcacZIPAttachments IS NOT NULL) And (@trgacZIPAttachments IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acZIPAttachments = ' + STR(@srcacZIPAttachments) + ' / ' + STR(@trgacZIPAttachments)
  END
  ELSE IF (@srcacUserDef3 <> @trgacUserDef3) Or ((@srcacUserDef3 IS NULL) And (@trgacUserDef3 IS NOT NULL)) Or ((@srcacUserDef3 IS NOT NULL) And (@trgacUserDef3 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef3 = ' + @srcacUserDef3 + ' / ' + @trgacUserDef3
  END
  ELSE IF (@srcacUserDef4 <> @trgacUserDef4) Or ((@srcacUserDef4 IS NULL) And (@trgacUserDef4 IS NOT NULL)) Or ((@srcacUserDef4 IS NOT NULL) And (@trgacUserDef4 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef4 = ' + @srcacUserDef4 + ' / ' + @trgacUserDef4
  END
  ELSE IF (@srcacWebLiveCatalog <> @trgacWebLiveCatalog) Or ((@srcacWebLiveCatalog IS NULL) And (@trgacWebLiveCatalog IS NOT NULL)) Or ((@srcacWebLiveCatalog IS NOT NULL) And (@trgacWebLiveCatalog IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acWebLiveCatalog = ' + @srcacWebLiveCatalog + ' / ' + @trgacWebLiveCatalog
  END
  ELSE IF (@srcacWebPrevCatalog <> @trgacWebPrevCatalog) Or ((@srcacWebPrevCatalog IS NULL) And (@trgacWebPrevCatalog IS NOT NULL)) Or ((@srcacWebPrevCatalog IS NOT NULL) And (@trgacWebPrevCatalog IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acWebPrevCatalog = ' + @srcacWebPrevCatalog + ' / ' + @trgacWebPrevCatalog
  END
  ELSE IF (@srcacTimeStamp <> @trgacTimeStamp) Or ((@srcacTimeStamp IS NULL) And (@trgacTimeStamp IS NOT NULL)) Or ((@srcacTimeStamp IS NOT NULL) And (@trgacTimeStamp IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acTimeStamp = ' + @srcacTimeStamp + ' / ' + @trgacTimeStamp
  END
  ELSE IF (@srcacVATCountryCode <> @trgacVATCountryCode) Or ((@srcacVATCountryCode IS NULL) And (@trgacVATCountryCode IS NOT NULL)) Or ((@srcacVATCountryCode IS NOT NULL) And (@trgacVATCountryCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acVATCountryCode = ' + @srcacVATCountryCode + ' / ' + @trgacVATCountryCode
  END
  ELSE IF (@srcacSSDDeliveryTerms <> @trgacSSDDeliveryTerms) Or ((@srcacSSDDeliveryTerms IS NULL) And (@trgacSSDDeliveryTerms IS NOT NULL)) Or ((@srcacSSDDeliveryTerms IS NOT NULL) And (@trgacSSDDeliveryTerms IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSSDDeliveryTerms = ' + @srcacSSDDeliveryTerms + ' / ' + @trgacSSDDeliveryTerms
  END
  ELSE IF (@srcacInclusiveVATCode <> @trgacInclusiveVATCode) Or ((@srcacInclusiveVATCode IS NULL) And (@trgacInclusiveVATCode IS NOT NULL)) Or ((@srcacInclusiveVATCode IS NOT NULL) And (@trgacInclusiveVATCode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acInclusiveVATCode = ' + @srcacInclusiveVATCode + ' / ' + @trgacInclusiveVATCode
  END
  ELSE IF (@srcacSSDModeOfTransport <> @trgacSSDModeOfTransport) Or ((@srcacSSDModeOfTransport IS NULL) And (@trgacSSDModeOfTransport IS NOT NULL)) Or ((@srcacSSDModeOfTransport IS NOT NULL) And (@trgacSSDModeOfTransport IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSSDModeOfTransport = ' + STR(@srcacSSDModeOfTransport) + ' / ' + STR(@trgacSSDModeOfTransport)
  END
  ELSE IF (@srcacPrivateRec <> @trgacPrivateRec) Or ((@srcacPrivateRec IS NULL) And (@trgacPrivateRec IS NOT NULL)) Or ((@srcacPrivateRec IS NOT NULL) And (@trgacPrivateRec IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acPrivateRec = ' + STR(@srcacPrivateRec) + ' / ' + STR(@trgacPrivateRec)
  END
  ELSE IF (@srcacLastOperator <> @trgacLastOperator) Or ((@srcacLastOperator IS NULL) And (@trgacLastOperator IS NOT NULL)) Or ((@srcacLastOperator IS NOT NULL) And (@trgacLastOperator IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acLastOperator = ' + @srcacLastOperator + ' / ' + @trgacLastOperator
  END
  ELSE IF (@srcacDocDeliveryMode <> @trgacDocDeliveryMode) Or ((@srcacDocDeliveryMode IS NULL) And (@trgacDocDeliveryMode IS NOT NULL)) Or ((@srcacDocDeliveryMode IS NOT NULL) And (@trgacDocDeliveryMode IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDocDeliveryMode = ' + STR(@srcacDocDeliveryMode) + ' / ' + STR(@trgacDocDeliveryMode)
  END
  ELSE IF (@srcacSendHTML <> @trgacSendHTML) Or ((@srcacSendHTML IS NULL) And (@trgacSendHTML IS NOT NULL)) Or ((@srcacSendHTML IS NOT NULL) And (@trgacSendHTML IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acSendHTML = ' + STR(@srcacSendHTML) + ' / ' + STR(@trgacSendHTML)
  END
  ELSE IF (@srcacEmailAddr <> @trgacEmailAddr) Or ((@srcacEmailAddr IS NULL) And (@trgacEmailAddr IS NOT NULL)) Or ((@srcacEmailAddr IS NOT NULL) And (@trgacEmailAddr IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acEmailAddr = ' + @srcacEmailAddr + ' / ' + @trgacEmailAddr
  END
  ELSE IF (@srcacOfficeType <> @trgacOfficeType) Or ((@srcacOfficeType IS NULL) And (@trgacOfficeType IS NOT NULL)) Or ((@srcacOfficeType IS NOT NULL) And (@trgacOfficeType IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acOfficeType = ' + STR(@srcacOfficeType) + ' / ' + STR(@trgacOfficeType)
  END
  ELSE IF (@srcacDefTagNo <> @trgacDefTagNo) Or ((@srcacDefTagNo IS NULL) And (@trgacDefTagNo IS NOT NULL)) Or ((@srcacDefTagNo IS NOT NULL) And (@trgacDefTagNo IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acDefTagNo = ' + STR(@srcacDefTagNo) + ' / ' + STR(@trgacDefTagNo)
  END
  ELSE IF (@srcacUserDef5 <> @trgacUserDef5) Or ((@srcacUserDef5 IS NULL) And (@trgacUserDef5 IS NOT NULL)) Or ((@srcacUserDef5 IS NOT NULL) And (@trgacUserDef5 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef5 = ' + @srcacUserDef5 + ' / ' + @trgacUserDef5
  END
  ELSE IF (@srcacUserDef6 <> @trgacUserDef6) Or ((@srcacUserDef6 IS NULL) And (@trgacUserDef6 IS NOT NULL)) Or ((@srcacUserDef6 IS NOT NULL) And (@trgacUserDef6 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef6 = ' + @srcacUserDef6 + ' / ' + @trgacUserDef6
  END
  ELSE IF (@srcacUserDef7 <> @trgacUserDef7) Or ((@srcacUserDef7 IS NULL) And (@trgacUserDef7 IS NOT NULL)) Or ((@srcacUserDef7 IS NOT NULL) And (@trgacUserDef7 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef7 = ' + @srcacUserDef7 + ' / ' + @trgacUserDef7
  END
  ELSE IF (@srcacUserDef8 <> @trgacUserDef8) Or ((@srcacUserDef8 IS NULL) And (@trgacUserDef8 IS NOT NULL)) Or ((@srcacUserDef8 IS NOT NULL) And (@trgacUserDef8 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef8 = ' + @srcacUserDef8 + ' / ' + @trgacUserDef8
  END
  ELSE IF (@srcacUserDef9 <> @trgacUserDef9) Or ((@srcacUserDef9 IS NULL) And (@trgacUserDef9 IS NOT NULL)) Or ((@srcacUserDef9 IS NOT NULL) And (@trgacUserDef9 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef9 = ' + @srcacUserDef9 + ' / ' + @trgacUserDef9
  END
  ELSE IF (@srcacUserDef10 <> @trgacUserDef10) Or ((@srcacUserDef10 IS NULL) And (@trgacUserDef10 IS NOT NULL)) Or ((@srcacUserDef10 IS NOT NULL) And (@trgacUserDef10 IS NULL))
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  CustSupp.acUserDef10 = ' + @srcacUserDef10 + ' / ' + @trgacUserDef10
  END
  ELSE
  BEGIN
    PRINT 'Code: ' + @srcacCode + '  AOK'
  END 
  FETCH NEXT FROM srcCustSupp INTO @srcacCode
                                 , @srcacCustSupp
                                 , @srcacCompany
                                 , @srcacArea
                                 , @srcacAccType
                                 , @srcacStatementTo
                                 , @srcacVATRegNo
                                 , @srcacAddressLine1
                                 , @srcacAddressLine2
                                 , @srcacAddressLine3
                                 , @srcacAddressLine4
                                 , @srcacAddressLine5
                                 , @srcacDespAddr
                                 , @srcacDespAddressLine1
                                 , @srcacDespAddressLine2
                                 , @srcacDespAddressLine3
                                 , @srcacDespAddressLine4
                                 , @srcacDespAddressLine5
                                 , @srcacContact
                                 , @srcacPhone
                                 , @srcacFax
                                 , @srcacTheirAcc
                                 , @srcacOwnTradTerm
                                 , @srcacTradeTerms1
                                 , @srcacTradeTerms2
                                 , @srcacCurrency
                                 , @srcacVATCode
                                 , @srcacPayTerms
                                 , @srcacCreditLimit
                                 , @srcacDiscount
                                 , @srcacCreditStatus
                                 , @srcacCostCentre
                                 , @srcacDiscountBand
                                 , @srcacOrderConsolidationMode
                                 , @srcacDefSettleDays
                                 , @srcacSpare5
                                 , @srcacBalance
                                 , @srcacDepartment
                                 , @srcacECMember
                                 , @srcacNLineCount
                                 , @srcacStatement
                                 , @srcacSalesGL
                                 , @srcacLocation
                                 , @srcacAccStatus
                                 , @srcacPayType
                                 , @srcacBankSort
                                 , @srcacBankAcc
                                 , @srcacBankRef
                                 , @srcacAvePay
                                 , @srcacPhone2
                                 , @srcacCOSGL
                                 , @srcacDrCrGL
                                 , @srcacLastUsed
                                 , @srcacUserDef1
                                 , @srcacUserDef2
                                 , @srcacInvoiceTo
                                 , @srcacSOPAutoWOff
                                 , @srcacFormSet
                                 , @srcacBookOrdVal
                                 , @srcacDirDebMode
                                 , @srcacCCStart
                                 , @srcacCCEnd
                                 , @srcacCCName
                                 , @srcacCCNumber
                                 , @srcacCCSwitch
                                 , @srcacDefSettleDisc
                                 , @srcacStateDeliveryMode
                                 , @srcacSpare2
                                 , @srcacSendReader
                                 , @srcacEBusPword
                                 , @srcacPostCode
                                 , @srcacAltCode
                                 , @srcacUseForEbus
                                 , @srcacZIPAttachments
                                 , @srcacUserDef3
                                 , @srcacUserDef4
                                 , @srcacWebLiveCatalog
                                 , @srcacWebPrevCatalog
                                 , @srcacTimeStamp
                                 , @srcacVATCountryCode
                                 , @srcacSSDDeliveryTerms
                                 , @srcacInclusiveVATCode
                                 , @srcacSSDModeOfTransport
                                 , @srcacPrivateRec
                                 , @srcacLastOperator
                                 , @srcacDocDeliveryMode
                                 , @srcacSendHTML
                                 , @srcacEmailAddr
                                 , @srcacOfficeType
                                 , @srcacDefTagNo
                                 , @srcacUserDef5
                                 , @srcacUserDef6
                                 , @srcacUserDef7
                                 , @srcacUserDef8
                                 , @srcacUserDef9
                                 , @srcacUserDef10
  END

  CLOSE srcCustSupp
  DEALLOCATE srcCustSupp
