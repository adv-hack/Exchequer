Unit oCustSuppDataWrite;

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TCustSuppDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    acCodeParam, acCustSuppParam, acCompanyParam, acAreaParam, acAccTypeParam,
    acStatementToParam, acVATRegNoParam, acAddressLine1Param, acAddressLine2Param,
    acAddressLine3Param, acAddressLine4Param, acAddressLine5Param, acDespAddrParam,
    acDespAddressLine1Param, acDespAddressLine2Param, acDespAddressLine3Param,
    acDespAddressLine4Param, acDespAddressLine5Param, acContactParam, acPhoneParam,
    acFaxParam, acTheirAccParam, acOwnTradTermParam, acTradeTerms1Param, acTradeTerms2Param,
    acCurrencyParam, acVATCodeParam, acPayTermsParam, acCreditLimitParam, acDiscountParam,
    acCreditStatusParam, acCostCentreParam, acDiscountBandParam, acOrderConsolidationModeParam,
    acDefSettleDaysParam, acSpare5Param, acBalanceParam, acDepartmentParam,
    acECMemberParam, acNLineCountParam, acStatementParam, acSalesGLParam, acLocationParam,
    acAccStatusParam, acPayTypeParam, acOldBankSortParam, acOldBankAccParam, acBankRefParam,
    acAvePayParam, acPhone2Param, acCOSGLParam, acDrCrGLParam, acLastUsedParam,
    acUserDef1Param, acUserDef2Param, acInvoiceToParam, acSOPAutoWOffParam,
    acFormSetParam, acBookOrdValParam, acDirDebModeParam, acCCStartParam, acCCEndParam,
    acCCNameParam, acCCNumberParam, acCCSwitchParam, acDefSettleDiscParam,
    acStateDeliveryModeParam, acSpare2Param, acSendReaderParam, acEBusPwordParam,
    acPostCodeParam, acAltCodeParam, acUseForEbusParam, acZIPAttachmentsParam,
    acUserDef3Param, acUserDef4Param, acWebLiveCatalogParam, acWebPrevCatalogParam,
    acTimeStampParam, acVATCountryCodeParam, acSSDDeliveryTermsParam, acInclusiveVATCodeParam,
    acSSDModeOfTransportParam, acPrivateRecParam, acLastOperatorParam, acDocDeliveryModeParam,
    acSendHTMLParam, acEmailAddrParam, acOfficeTypeParam, acDefTagNoParam,
    acUserDef5Param, acUserDef6Param, acUserDef7Param, acUserDef8Param, acUserDef9Param,
    // CJS 2013-09-17 - ABSEXCH-14598 - SEPA/IBAN changes
    acUserDef10Param, acBankSortCodeParam, acBankAccountCodeParam,
    acMandateIDParam, acMandateDateParam : TParameter;
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    acDeliveryPostCodeParam : TParameter;
    // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
    acSubTypeParam, acLongAcCodeParam : TParameter;
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    acAllowOrderPaymentsParam, acOrderPaymentsGLCodeParam, acCountryParam,
    acDeliveryCountryParam, acPPDModeParam,
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    acDefaultToQRParam,
    // CJS 2016-04-27 - Add support for new Tax fields
    acTaxRegionParam: TParameter;
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    acAnonymisationStatusParam, acAnonymisedDateParam, acAnonymisedTimeParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TCustSuppDataWrite

Implementation

Uses Variants, VarConst, SQLConvertUtils, DataConversionWarnings, LoggingUtils;

//=========================================================================

Constructor TCustSuppDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TCustSuppDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TCustSuppDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].CustSupp (' +
                                               'acCode, ' +
                                               'acCustSupp, ' +
                                               'acCompany, ' +
                                               'acArea, ' +
                                               'acAccType, ' +
                                               'acStatementTo, ' +
                                               'acVATRegNo, ' +
                                               'acAddressLine1, ' +
                                               'acAddressLine2, ' +
                                               'acAddressLine3, ' +
                                               'acAddressLine4, ' +
                                               'acAddressLine5, ' +
                                               'acDespAddr, ' +
                                               'acDespAddressLine1, ' +
                                               'acDespAddressLine2, ' +
                                               'acDespAddressLine3, ' +
                                               'acDespAddressLine4, ' +
                                               'acDespAddressLine5, ' +
                                               'acContact, ' +
                                               'acPhone, ' +
                                               'acFax, ' +
                                               'acTheirAcc, ' +
                                               'acOwnTradTerm, ' + 
                                               'acTradeTerms1, ' + 
                                               'acTradeTerms2, ' + 
                                               'acCurrency, ' + 
                                               'acVATCode, ' + 
                                               'acPayTerms, ' + 
                                               'acCreditLimit, ' + 
                                               'acDiscount, ' +
                                               'acCreditStatus, ' + 
                                               'acCostCentre, ' +
                                               'acDiscountBand, ' +
                                               'acOrderConsolidationMode, ' + 
                                               'acDefSettleDays, ' +
                                               'acSpare5, ' + 
                                               'acBalance, ' +
                                               'acDepartment, ' +
                                               'acECMember, ' +
                                               'acNLineCount, ' +
                                               'acStatement, ' +
                                               'acSalesGL, ' +
                                               'acLocation, ' +
                                               'acAccStatus, ' +
                                               'acPayType, ' +
                                               'acOldBankSort, ' +
                                               'acOldBankAcc, ' +
                                               'acBankRef, ' +
                                               'acAvePay, ' +
                                               'acPhone2, ' +
                                               'acCOSGL, ' +
                                               'acDrCrGL, ' +
                                               'acLastUsed, ' +
                                               'acUserDef1, ' +
                                               'acUserDef2, ' +
                                               'acInvoiceTo, ' +
                                               'acSOPAutoWOff, ' +
                                               'acFormSet, ' +
                                               'acBookOrdVal, ' +
                                               'acDirDebMode, ' +
                                               'acCCStart, ' +
                                               'acCCEnd, ' +
                                               'acCCName, ' +
                                               'acCCNumber, ' +
                                               'acCCSwitch, ' +
                                               'acDefSettleDisc, ' +
                                               'acStateDeliveryMode, ' +
                                               'acSpare2, ' +
                                               'acSendReader, ' +
                                               'acEBusPword, ' +
                                               'acPostCode, ' +
                                               'acAltCode, ' +
                                               'acUseForEbus, ' +
                                               'acZIPAttachments, ' +
                                               'acUserDef3, ' +
                                               'acUserDef4, ' +
                                               'acWebLiveCatalog, ' +
                                               'acWebPrevCatalog, ' +
                                               'acTimeStamp, ' +
                                               'acVATCountryCode, ' +
                                               'acSSDDeliveryTerms, ' +
                                               'acInclusiveVATCode, ' +
                                               'acSSDModeOfTransport, ' +
                                               'acPrivateRec, ' +
                                               'acLastOperator, ' +
                                               'acDocDeliveryMode, ' +
                                               'acSendHTML, ' +
                                               'acEmailAddr, ' +
                                               'acOfficeType, ' +
                                               'acDefTagNo, ' +
                                               'acUserDef5, ' +
                                               'acUserDef6, ' +
                                               'acUserDef7, ' +
                                               'acUserDef8, ' +
                                               'acUserDef9, ' +
                                               'acUserDef10, ' +
                                               'acBankSortCode, ' +
                                               'acBankAccountCode, ' +
                                               'acMandateID, ' +
                                               'acMandateDate, ' +
                                               // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                                               'acDeliveryPostCode, ' +
                                               // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
                                               'acSubType, ' +
                                               'acLongAcCode, ' +
                                               // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
                                               'acAllowOrderPayments, ' +
                                               'acOrderPaymentsGLCode, ' +
                                               'acCountry, ' +
                                               'acDeliveryCountry, ' +
                                               'acPPDMode, ' +
                                               // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                                               'acDefaultToQR, ' +
                                               // CJS 2016-04-27 - Add support for new Tax fields
                                               'acTaxRegion, ' +
                                               // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                                               'acAnonymisationStatus, ' +
                                               'acAnonymisedDate, ' +
                                               'acAnonymisedTime' +
                                               ') ' +
            'VALUES (' +
                     ':acCode, ' +
                     ':acCustSupp, ' +
                     ':acCompany, ' +
                     ':acArea, ' +
                     ':acAccType, ' +
                     ':acStatementTo, ' +
                     ':acVATRegNo, ' +
                     ':acAddressLine1, ' +
                     ':acAddressLine2, ' +
                     ':acAddressLine3, ' +
                     ':acAddressLine4, ' +
                     ':acAddressLine5, ' +
                     ':acDespAddr, ' +
                     ':acDespAddressLine1, ' +
                     ':acDespAddressLine2, ' +
                     ':acDespAddressLine3, ' +
                     ':acDespAddressLine4, ' +
                     ':acDespAddressLine5, ' +
                     ':acContact, ' +
                     ':acPhone, ' +
                     ':acFax, ' +
                     ':acTheirAcc, ' +
                     ':acOwnTradTerm, ' +
                     ':acTradeTerms1, ' +
                     ':acTradeTerms2, ' +
                     ':acCurrency, ' +
                     ':acVATCode, ' +
                     ':acPayTerms, ' +
                     ':acCreditLimit, ' +
                     ':acDiscount, ' +
                     ':acCreditStatus, ' + 
                     ':acCostCentre, ' +
                     ':acDiscountBand, ' +
                     ':acOrderConsolidationMode, ' + 
                     ':acDefSettleDays, ' + 
                     ':acSpare5, ' + 
                     ':acBalance, ' + 
                     ':acDepartment, ' +
                     ':acECMember, ' +
                     ':acNLineCount, ' +
                     ':acStatement, ' + 
                     ':acSalesGL, ' +
                     ':acLocation, ' +
                     ':acAccStatus, ' +
                     ':acPayType, ' +
                     ':acOldBankSort, ' +
                     ':acOldBankAcc, ' +
                     ':acBankRef, ' + 
                     ':acAvePay, ' + 
                     ':acPhone2, ' + 
                     ':acCOSGL, ' +
                     ':acDrCrGL, ' +
                     ':acLastUsed, ' + 
                     ':acUserDef1, ' +
                     ':acUserDef2, ' +
                     ':acInvoiceTo, ' +
                     ':acSOPAutoWOff, ' +
                     ':acFormSet, ' +
                     ':acBookOrdVal, ' +
                     ':acDirDebMode, ' +
                     ':acCCStart, ' +
                     ':acCCEnd, ' +
                     ':acCCName, ' + 
                     ':acCCNumber, ' + 
                     ':acCCSwitch, ' +
                     ':acDefSettleDisc, ' +
                     ':acStateDeliveryMode, ' +
                     ':acSpare2, ' + 
                     ':acSendReader, ' +
                     ':acEBusPword, ' + 
                     ':acPostCode, ' + 
                     ':acAltCode, ' +
                     ':acUseForEbus, ' +
                     ':acZIPAttachments, ' +
                     ':acUserDef3, ' +
                     ':acUserDef4, ' + 
                     ':acWebLiveCatalog, ' +
                     ':acWebPrevCatalog, ' +
                     ':acTimeStamp, ' +
                     ':acVATCountryCode, ' +
                     ':acSSDDeliveryTerms, ' +
                     ':acInclusiveVATCode, ' +
                     ':acSSDModeOfTransport, ' +
                     ':acPrivateRec, ' +
                     ':acLastOperator, ' +
                     ':acDocDeliveryMode, ' +
                     ':acSendHTML, ' +
                     ':acEmailAddr, ' +
                     ':acOfficeType, ' +
                     ':acDefTagNo, ' +
                     ':acUserDef5, ' +
                     ':acUserDef6, ' +
                     ':acUserDef7, ' +
                     ':acUserDef8, ' +
                     ':acUserDef9, ' +
                     ':acUserDef10, ' +
                     ':acBankSortCode, ' +
                     ':acBankAccountCode, ' +
                     ':acMandateID, ' +
                     ':acMandateDate, ' +
                     // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
                     ':acDeliveryPostCode, ' +
                     // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
                     ':acSubType, ' +
                     ':acLongAcCode, ' +
                     // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
                     ':acAllowOrderPayments, ' +
                     ':acOrderPaymentsGLCode, ' +
                     ':acCountry, ' +
                     ':acDeliveryCountry, ' +
                     ':acPPDMode, ' +
                     // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                     ':acDefaultToQR, ' +
                     // CJS 2016-04-27 - Add support for new Tax fields
                     ':acTaxRegion, ' +
                     // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
                     ':acAnonymisationStatus, ' +
                     ':acAnonymisedDate, ' +
                     ':acAnonymisedTime' +
                     ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    acCodeParam := FindParam('acCode');
    acCustSuppParam := FindParam('acCustSupp');
    acCompanyParam := FindParam('acCompany');
    acAreaParam := FindParam('acArea');
    acAccTypeParam := FindParam('acAccType');
    acStatementToParam := FindParam('acStatementTo');
    acVATRegNoParam := FindParam('acVATRegNo');
    acAddressLine1Param := FindParam('acAddressLine1');
    acAddressLine2Param := FindParam('acAddressLine2');
    acAddressLine3Param := FindParam('acAddressLine3');
    acAddressLine4Param := FindParam('acAddressLine4');
    acAddressLine5Param := FindParam('acAddressLine5');
    acDespAddrParam := FindParam('acDespAddr');
    acDespAddressLine1Param := FindParam('acDespAddressLine1');
    acDespAddressLine2Param := FindParam('acDespAddressLine2');
    acDespAddressLine3Param := FindParam('acDespAddressLine3');
    acDespAddressLine4Param := FindParam('acDespAddressLine4');
    acDespAddressLine5Param := FindParam('acDespAddressLine5');
    acContactParam := FindParam('acContact');
    acPhoneParam := FindParam('acPhone');
    acFaxParam := FindParam('acFax');
    acTheirAccParam := FindParam('acTheirAcc');
    acOwnTradTermParam := FindParam('acOwnTradTerm');
    acTradeTerms1Param := FindParam('acTradeTerms1');
    acTradeTerms2Param := FindParam('acTradeTerms2');
    acCurrencyParam := FindParam('acCurrency');
    acVATCodeParam := FindParam('acVATCode');
    acPayTermsParam := FindParam('acPayTerms');
    acCreditLimitParam := FindParam('acCreditLimit');
    acDiscountParam := FindParam('acDiscount');
    acCreditStatusParam := FindParam('acCreditStatus');
    acCostCentreParam := FindParam('acCostCentre');
    acDiscountBandParam := FindParam('acDiscountBand');
    acOrderConsolidationModeParam := FindParam('acOrderConsolidationMode');
    acDefSettleDaysParam := FindParam('acDefSettleDays');
    acSpare5Param := FindParam('acSpare5');
    acBalanceParam := FindParam('acBalance');
    acDepartmentParam := FindParam('acDepartment');
    acECMemberParam := FindParam('acECMember');
    acNLineCountParam := FindParam('acNLineCount');
    acStatementParam := FindParam('acStatement');
    acSalesGLParam := FindParam('acSalesGL');
    acLocationParam := FindParam('acLocation');
    acAccStatusParam := FindParam('acAccStatus');
    acPayTypeParam := FindParam('acPayType');
    acOldBankSortParam := FindParam('acOldBankSort');
    acOldBankAccParam := FindParam('acOldBankAcc');
    acBankRefParam := FindParam('acBankRef');
    acAvePayParam := FindParam('acAvePay');
    acPhone2Param := FindParam('acPhone2');
    acCOSGLParam := FindParam('acCOSGL');
    acDrCrGLParam := FindParam('acDrCrGL');
    acLastUsedParam := FindParam('acLastUsed');
    acUserDef1Param := FindParam('acUserDef1');
    acUserDef2Param := FindParam('acUserDef2');
    acInvoiceToParam := FindParam('acInvoiceTo');
    acSOPAutoWOffParam := FindParam('acSOPAutoWOff');
    acFormSetParam := FindParam('acFormSet');
    acBookOrdValParam := FindParam('acBookOrdVal');
    acDirDebModeParam := FindParam('acDirDebMode');
    acCCStartParam := FindParam('acCCStart');
    acCCEndParam := FindParam('acCCEnd');
    acCCNameParam := FindParam('acCCName');
    acCCNumberParam := FindParam('acCCNumber');
    acCCSwitchParam := FindParam('acCCSwitch');
    acDefSettleDiscParam := FindParam('acDefSettleDisc');
    acStateDeliveryModeParam := FindParam('acStateDeliveryMode');
    acSpare2Param := FindParam('acSpare2');
    acSendReaderParam := FindParam('acSendReader');
    acEBusPwordParam := FindParam('acEBusPword');
    acPostCodeParam := FindParam('acPostCode');
    acAltCodeParam := FindParam('acAltCode');
    acUseForEbusParam := FindParam('acUseForEbus');
    acZIPAttachmentsParam := FindParam('acZIPAttachments');
    acUserDef3Param := FindParam('acUserDef3');
    acUserDef4Param := FindParam('acUserDef4');
    acWebLiveCatalogParam := FindParam('acWebLiveCatalog');
    acWebPrevCatalogParam := FindParam('acWebPrevCatalog');
    acTimeStampParam := FindParam('acTimeStamp');
    acVATCountryCodeParam := FindParam('acVATCountryCode');
    acSSDDeliveryTermsParam := FindParam('acSSDDeliveryTerms');
    acInclusiveVATCodeParam := FindParam('acInclusiveVATCode');
    acSSDModeOfTransportParam := FindParam('acSSDModeOfTransport');
    acPrivateRecParam := FindParam('acPrivateRec');
    acLastOperatorParam := FindParam('acLastOperator');
    acDocDeliveryModeParam := FindParam('acDocDeliveryMode');
    acSendHTMLParam := FindParam('acSendHTML');
    acEmailAddrParam := FindParam('acEmailAddr');
    acOfficeTypeParam := FindParam('acOfficeType');
    acDefTagNoParam := FindParam('acDefTagNo');
    acUserDef5Param := FindParam('acUserDef5');
    acUserDef6Param := FindParam('acUserDef6');
    acUserDef7Param := FindParam('acUserDef7');
    acUserDef8Param := FindParam('acUserDef8');
    acUserDef9Param := FindParam('acUserDef9');
    acUserDef10Param := FindParam('acUserDef10');
    // CJS 2013-09-17 - ABSEXCH-14598 - SEPA/IBAN changes
    acBankSortCodeParam := FindParam('acBankSortCode');
    acBankAccountCodeParam := FindParam('acBankAccountCode');
    acMandateIDParam := FindParam('acMandateID');
    acMandateDateParam := FindParam('acMandateDate');
    // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
    acDeliveryPostCodeParam := FindParam('acDeliveryPostCode');
    // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
    acSubTypeParam := FindParam('acSubType');
    acLongAcCodeParam := FindParam('acLongAcCode');
    // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
    acAllowOrderPaymentsParam := FindParam('acAllowOrderPayments');
    acOrderPaymentsGLCodeParam := FindParam('acOrderPaymentsGLCode');
    acCountryParam := FindParam('acCountry');
    acDeliveryCountryParam := FindParam('acDeliveryCountry');
    acPPDModeParam := FindParam('acPPDMode');
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    acDefaultToQRParam := FindParam('acDefaultToQR');
    // CJS 2016-04-27 - Add support for new Tax fields
    acTaxRegionParam := FindParam('acTaxRegion');
    // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
    acAnonymisationStatusParam := FindParam('acAnonymisationStatus');
    acAnonymisedDateParam := FindParam('acAnonymisedDate');
    acAnonymisedTimeParam := FindParam('acAnonymisedTime');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TCustSuppDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^CustRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  acCodeParam.Value := DataRec^.CustCode;                                                    // SQL=varchar, Delphi=string[10]
  acCustSuppParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.CustSupp);               // SQL=varchar, Delphi=Char
  acCompanyParam.Value := DataRec^.Company;                                                  // SQL=varchar, Delphi=string[45]
  acAreaParam.Value := DataRec^.AreaCode;                                                    // SQL=varchar, Delphi=String[4]
  acAccTypeParam.Value := DataRec^.RepCode;                                                  // SQL=varchar, Delphi=String[4]
  acStatementToParam.Value := DataRec^.RemitCode;                                            // SQL=varchar, Delphi=String[10]
  acVATRegNoParam.Value := DataRec^.VATRegNo;                                                // SQL=varchar, Delphi=String[30]
  acAddressLine1Param.Value := DataRec^.Addr[1];                                             // SQL=varchar, Delphi=String[30]
  acAddressLine2Param.Value := DataRec^.Addr[2];                                             // SQL=varchar, Delphi=String[30]
  acAddressLine3Param.Value := DataRec^.Addr[3];                                             // SQL=varchar, Delphi=String[30]
  acAddressLine4Param.Value := DataRec^.Addr[4];                                             // SQL=varchar, Delphi=String[30]
  acAddressLine5Param.Value := DataRec^.Addr[5];                                             // SQL=varchar, Delphi=String[30]
  acDespAddrParam.Value := DataRec^.DespAddr;                                                // SQL=bit, Delphi=Boolean
  acDespAddressLine1Param.Value := DataRec^.DAddr[1];                                        // SQL=varchar, Delphi=String[30]
  acDespAddressLine2Param.Value := DataRec^.DAddr[2];                                        // SQL=varchar, Delphi=String[30]
  acDespAddressLine3Param.Value := DataRec^.DAddr[3];                                        // SQL=varchar, Delphi=String[30]
  acDespAddressLine4Param.Value := DataRec^.DAddr[4];                                        // SQL=varchar, Delphi=String[30]
  acDespAddressLine5Param.Value := DataRec^.DAddr[5];                                        // SQL=varchar, Delphi=String[30]
  acContactParam.Value := DataRec^.Contact;                                                  // SQL=varchar, Delphi=String[25]
  acPhoneParam.Value := DataRec^.Phone;                                                      // SQL=varchar, Delphi=string[30]
  acFaxParam.Value := DataRec^.Fax;                                                          // SQL=varchar, Delphi=string[30]
  acTheirAccParam.Value := DataRec^.RefNo;                                                   // SQL=varchar, Delphi=String[10]
  acOwnTradTermParam.Value := DataRec^.TradTerm;                                             // SQL=bit, Delphi=Boolean
  acTradeTerms1Param.Value := DataRec^.STerms[1];                                            // SQL=varchar, Delphi=Str80
  acTradeTerms2Param.Value := DataRec^.STerms[2];                                            // SQL=varchar, Delphi=Str80
  acCurrencyParam.Value := DataRec^.Currency;                                                // SQL=int, Delphi=Byte
  acVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.VATCode);                 // SQL=varchar, Delphi=Char
  acPayTermsParam.Value := DataRec^.PayTerms;                                                // SQL=int, Delphi=SmallInt
  acCreditLimitParam.Value := DataRec^.CreditLimit;                                          // SQL=float, Delphi=Real
  acDiscountParam.Value := DataRec^.Discount;                                                // SQL=float, Delphi=Real
  acCreditStatusParam.Value := DataRec^.CreditStatus;                                        // SQL=int, Delphi=SmallInt
  acCostCentreParam.Value := DataRec^.CustCC;                                                // SQL=varchar, Delphi=String[3]
  acDiscountBandParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.CDiscCh);            // SQL=varchar, Delphi=Char
  acOrderConsolidationModeParam.Value := DataRec^.OrdConsMode;                               // SQL=int, Delphi=Byte
  acDefSettleDaysParam.Value := DataRec^.DefSetDDays;                                        // SQL=int, Delphi=SmallInt
  acSpare5Param.Value := CreateVariantArray (@DataRec^.Spare5, SizeOf(DataRec^.Spare5));     // SQL=varbinary, Delphi=Array[1..2] of Byte
  acBalanceParam.Value := DataRec^.Balance;                                                  // SQL=float, Delphi=Real
  acDepartmentParam.Value := DataRec^.CustDep;                                               // SQL=varchar, Delphi=String[3]
  acECMemberParam.Value := DataRec^.EECMember;                                               // SQL=bit, Delphi=Boolean
  acNLineCountParam.Value := DataRec^.NLineCount;                                            // SQL=int, Delphi=LongInt
  acStatementParam.Value := DataRec^.IncStat;                                                // SQL=bit, Delphi=Boolean
  acSalesGLParam.Value := DataRec^.DefNomCode;                                               // SQL=int, Delphi=LongInt
  acLocationParam.Value := DataRec^.DefMLocStk;                                              // SQL=varchar, Delphi=String[3]
  acAccStatusParam.Value := DataRec^.AccStatus;                                              // SQL=int, Delphi=Byte
  acPayTypeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.PayType);                 // SQL=varchar, Delphi=Char
  acOldBankSortParam.Value := DataRec^.OldBankSort;                                          // SQL=varchar, Delphi=String[15]
  acOldBankAccParam.Value := DataRec^.OldBankAcc;                                            // SQL=varchar, Delphi=String[20]
  acBankRefParam.Value := DataRec^.BankRef;                                                  // SQL=varchar, Delphi=String[28]
  acAvePayParam.Value := DataRec^.AvePay;                                                    // SQL=int, Delphi=SmallInt
  acPhone2Param.Value := DataRec^.Phone2;                                                    // SQL=varchar, Delphi=String[30]
  acCOSGLParam.Value := DataRec^.DefCOSNom;                                                  // SQL=int, Delphi=LongInt
  acDrCrGLParam.Value := DataRec^.DefCtrlNom;                                                // SQL=int, Delphi=LongInt
  acLastUsedParam.Value := DataRec^.LastUsed;                                                // SQL=varchar, Delphi=LongDate
  acUserDef1Param.Value := DataRec^.UserDef1;                                                // SQL=varchar, Delphi=String[30]
  acUserDef2Param.Value := DataRec^.UserDef2;                                                // SQL=varchar, Delphi=String[30]
  acInvoiceToParam.Value := DataRec^.SOPInvCode;                                             // SQL=varchar, Delphi=String[10]
  acSOPAutoWOffParam.Value := DataRec^.SOPAutoWOff;                                          // SQL=bit, Delphi=Boolean
  acFormSetParam.Value := DataRec^.FDefPageNo;                                               // SQL=int, Delphi=Byte
  acBookOrdValParam.Value := DataRec^.BOrdVal;                                               // SQL=float, Delphi=Double
  acDirDebModeParam.Value := DataRec^.DirDeb;                                                // SQL=int, Delphi=Byte
  acCCStartParam.Value := DataRec^.CCDSDate;                                                 // SQL=varchar, Delphi=LongDate
  acCCEndParam.Value := DataRec^.CCDEDate;                                                   // SQL=varchar, Delphi=LongDate
  acCCNameParam.Value := DataRec^.CCDName;                                                   // SQL=varchar, Delphi=String[50]
  acCCNumberParam.Value := DataRec^.CCDCardNo;                                               // SQL=varchar, Delphi=String[30]
  acCCSwitchParam.Value := DataRec^.CCDSARef;                                                // SQL=varchar, Delphi=String[4]
  acDefSettleDiscParam.Value := DataRec^.DefSetDisc;                                         // SQL=float, Delphi=Double
  acStateDeliveryModeParam.Value := DataRec^.StatDMode;                                      // SQL=int, Delphi=Byte
  acSpare2Param.Value := DataRec^.Spare2;                                                    // SQL=varchar, Delphi=String[50]
  acSendReaderParam.Value := DataRec^.EmlSndRdr;                                             // SQL=bit, Delphi=Boolean
  acEBusPwordParam.Value := DataRec^.ebusPwrd;                                               // SQL=varchar, Delphi=String[20]
  acPostCodeParam.Value := DataRec^.PostCode;                                                // SQL=varchar, Delphi=String[20]
  acAltCodeParam.Value := DataRec^.CustCode2;                                                // SQL=varchar, Delphi=String[20]
  acUseForEbusParam.Value := DataRec^.AllowWeb;                                              // SQL=int, Delphi=Byte
  acZIPAttachmentsParam.Value := DataRec^.EmlZipAtc;                                         // SQL=int, Delphi=Byte
  acUserDef3Param.Value := DataRec^.UserDef3;                                                // SQL=varchar, Delphi=String[30]
  acUserDef4Param.Value := DataRec^.UserDef4;                                                // SQL=varchar, Delphi=String[30]
  acWebLiveCatalogParam.Value := DataRec^.WebLiveCat;                                        // SQL=varchar, Delphi=String[20]
  acWebPrevCatalogParam.Value := DataRec^.WebPrevCat;                                        // SQL=varchar, Delphi=String[20]
  acTimeStampParam.Value := DataRec^.TimeChange;                                             // SQL=varchar, Delphi=String[6]
  acVATCountryCodeParam.Value := DataRec^.VATRetRegC;                                        // SQL=varchar, Delphi=String[5]
  acSSDDeliveryTermsParam.Value := DataRec^.SSDDelTerms;                                     // SQL=varchar, Delphi=String[5]
  acInclusiveVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(DataRec^.CVATIncFlg);     // SQL=varchar, Delphi=Char
  acSSDModeOfTransportParam.Value := DataRec^.SSDModeTr;                                     // SQL=int, Delphi=Byte
  acPrivateRecParam.Value := DataRec^.PrivateRec;                                            // SQL=bit, Delphi=Boolean
  acLastOperatorParam.Value := DataRec^.LastOpo;                                             // SQL=varchar, Delphi=String[10]
  acDocDeliveryModeParam.Value := DataRec^.InvDMode;                                         // SQL=int, Delphi=Byte
  acSendHTMLParam.Value := DataRec^.EmlSndHTML;                                              // SQL=bit, Delphi=Boolean
  acEmailAddrParam.Value := DataRec^.EmailAddr;                                              // SQL=varchar, Delphi=String[100]
  acOfficeTypeParam.Value := DataRec^.SOPConsHO;                                             // SQL=int, Delphi=Byte
  acDefTagNoParam.Value := DataRec^.DefTagNo;                                                // SQL=int, Delphi=Byte
  acUserDef5Param.Value := DataRec^.UserDef5;                                                // SQL=varchar, Delphi=String[30]
  acUserDef6Param.Value := DataRec^.UserDef6;                                                // SQL=varchar, Delphi=String[30]
  acUserDef7Param.Value := DataRec^.UserDef7;                                                // SQL=varchar, Delphi=String[30]
  acUserDef8Param.Value := DataRec^.UserDef8;                                                // SQL=varchar, Delphi=String[30]
  acUserDef9Param.Value := DataRec^.UserDef9;                                                // SQL=varchar, Delphi=String[30]
  acUserDef10Param.Value := DataRec^.UserDef10;                                              // SQL=varchar, Delphi=String[30]
  // CJS 2013-09-17 - ABSEXCH-14598 - SEPA/IBAN changes
  acBankSortCodeParam.Value := CreateVariantArray(@DataRec^.acBankSortCode, SizeOf(DataRec^.acBankSortCode)); // SQL=varbinary, Delphi=String[22]
  acBankAccountCodeParam.Value := CreateVariantArray(@DataRec^.acBankAccountCode, SizeOf(DataRec^.acBankAccountCode)); // SQL=varbinary, Delphi=String[54]
  acMandateIDParam.Value := CreateVariantArray(@DataRec^.acMandateID, SizeOf(DataRec^.acMandateID)); // SQL=varbinary, Delphi=String[54]
  acMandateDateParam.Value := DataRec^.acMandateDate;                                        // SQL=varchr, Delphi=LongDate
  // MH 16/10/2013 v7.0.7 ABSEXCH-14703: Added support for new Delivery Postcode field
  acDeliveryPostCodeParam.Value := DataRec^.acDeliveryPostCode;
  // MH 27/11/2013 v7.0.8 ABSEXCH-14797: Added support for new Consumer fields
  acSubTypeParam.Value := DataRec^.acSubType;
  acLongAcCodeParam.Value := DataRec^.acLongAcCode;
  // CJS 2015-05-14 - v7.0.14 - T2-139 - Added support for new fields
  acAllowOrderPaymentsParam.Value := DataRec^.acAllowOrderPayments;
  acOrderPaymentsGLCodeParam.Value := DataRec^.acOrderPaymentsGLCode;
  acCountryParam.Value := DataRec^.acCountry;
  acDeliveryCountryParam.Value := DataRec^.acDeliveryCountry;
  acPPDModeParam.Value := DataRec^.acPPDMode;
  // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
  acDefaultToQRParam.Value := DataRec^.acDefaultToQR;
  // CJS 2016-04-27 - Add support for new Tax fields
  acTaxRegionParam.Value := DataRec^.acTaxRegion;
  // MH 19/12/2017 2018-R1 ABSEXCH-19475: GDPR Changes
  acAnonymisationStatusParam.Value := Ord(DataRec^.acAnonymisationStatus);
  acAnonymisedDateParam.Value := DataRec^.acAnonymisedDate;
  acAnonymisedTimeParam.Value := DataRec^.acAnonymisedTime;
End; // SetParameterValues

//=========================================================================

End.

