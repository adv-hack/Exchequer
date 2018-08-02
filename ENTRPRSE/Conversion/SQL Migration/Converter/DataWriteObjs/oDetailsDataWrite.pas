Unit oDetailsDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket;

Type
  TDetailsDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    FTableName: string;
    tlFolioNumParam, tlLineNoParam, tlRunNoParam, tlGLCodeParam, tlNominalModeParam,
    tlCurrencyParam, tlYearParam, tlPeriodParam, tlDepartmentParam, tlCostCentreParam, 
    tlStockCodeParam, tlABSLineNoParam, tlLineTypeParam, tlDocTypeParam, 
    tlDLLUpdateParam, tlOldSerialQtyParam, tlQtyParam, tlQtyMulParam, tlNetValueParam, 
    tlDiscountParam, tlVATCodeParam, tlVATAmountParam, tlPaymentCodeParam, 
    tlOldPBalParam, tlRecStatusParam, tlDiscFlagParam, tlQtyWOFFParam, 
    tlQtyDelParam, tlCostParam, tlAcCodeParam, tlLineDateParam, tlItemNoParam,
    tlDescriptionParam, tlJobCodeParam, tlAnalysisCodeParam, tlCompanyRateParam,
    tlDailyRateParam, tlUnitWeightParam, tlStockDeductQtyParam, tlBOMKitLinkParam,
    tlSOPFolioNumParam, tlSOPABSLineNoParam, tlLocationParam, tlQtyPickedParam,
    tlQtyPickedWOParam, tlUsePackParam, tlSerialQtyParam, tlCOSNomCodeParam,
    tlOurRefParam, tlDocLTLinkParam, tlPrxPackParam, tlQtyPackParam, tlReconciliationDateParam,
    tlShowCaseParam, tlSdbFolioParam, tlOriginalBaseValueParam, tlUseOriginalRatesParam,
    tlUserField1Param, tlUserField2Param, tlUserField3Param, tlUserField4Param,
    tlSSDUpliftPercParam, tlSSDCountryParam, tlInclusiveVATCodeParam, tlSSDCommodCodeParam,
    tlSSDSalesUnitParam, tlPriceMultiplierParam, tlB2BLinkFolioParam, tlB2BLineNoParam,
    tlTriRatesParam, tlTriEuroParam, tlTriInvertParam, tlTriFloatParam,
    tlSpare1Param, tlSSDUseLineValuesParam, tlPreviousBalanceParam, tlLiveUpliftParam,
    tlCOSDailyRateParam, tlVATIncValueParam, tlLineSourceParam, tlCISRateCodeParam,
    tlCISRateParam, tlCostApportParam, tlNOMIOFlagParam, tlBinQtyParam,
    tlCISAdjustmentParam, tlDeductionTypeParam, tlSerialReturnQtyParam,
    tlBinReturnQtyParam, tlDiscount2Param, tlDiscount2ChrParam, tlDiscount3Param,
    tlDiscount3ChrParam, tlDiscount3TypeParam, tlECServiceParam, tlServiceStartDateParam,
    tlServiceEndDateParam, tlECSalesTaxReportedParam, tlPurchaseServiceTaxParam,
    tlReferenceParam, tlReceiptNoParam, tlFromPostCodeParam, tlToPostCodeParam,
    tlUserField5Param, tlUserField6Param, tlUserField7Param, tlUserField8Param,
    tlUserField9Param, tlUserField10Param, tlThresholdCodeParam : TParameter;
    // MH 14/02/2014 v7.0.9 ABSEXCH-14946: Added support for new Apps 'n Vals field
    tlMaterialsOnlyRetentionParam,
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tlIntrastatNoTCParam,
    // CJS 2016-04-27 - Add support for new Tax fields
    tlTaxRegionParam: TParameter;
  Public
    Constructor Create(ForEBusiness: Boolean = False);
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TDetailsDataWrite

Implementation

Uses Graphics, Variants, EntSettings, SQLConvertUtils, VarConst;

//=========================================================================

Constructor TDetailsDataWrite.Create(ForEBusiness: Boolean = False);
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
  if ForEBusiness then
    FTableName := 'EBUSDETL'
  else
    FTableName := 'DETAILS';
End; // Create

//------------------------------

Destructor TDetailsDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TDetailsDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].' + FTableName + ' (' +
                                              'tlFolioNum, ' + 
                                              'tlLineNo, ' + 
                                              'tlRunNo, ' + 
                                              'tlGLCode, ' + 
                                              'tlNominalMode, ' + 
                                              'tlCurrency, ' +
                                              'tlYear, ' + 
                                              'tlPeriod, ' + 
                                              'tlDepartment, ' + 
                                              'tlCostCentre, ' +
                                              'tlStockCode, ' + 
                                              'tlABSLineNo, ' + 
                                              'tlLineType, ' + 
                                              'tlDocType, ' + 
                                              'tlDLLUpdate, ' + 
                                              'tlOldSerialQty, ' + 
                                              'tlQty, ' + 
                                              'tlQtyMul, ' + 
                                              'tlNetValue, ' + 
                                              'tlDiscount, ' + 
                                              'tlVATCode, ' +
                                              'tlVATAmount, ' + 
                                              'tlPaymentCode, ' + 
                                              'tlOldPBal, ' + 
                                              'tlRecStatus, ' + 
                                              'tlDiscFlag, ' + 
                                              'tlQtyWOFF, ' + 
                                              'tlQtyDel, ' +
                                              'tlCost, ' +
                                              'tlAcCode, ' + 
                                              'tlLineDate, ' + 
                                              'tlItemNo, ' + 
                                              'tlDescription, ' + 
                                              'tlJobCode, ' + 
                                              'tlAnalysisCode, ' + 
                                              'tlCompanyRate, ' +
                                              'tlDailyRate, ' + 
                                              'tlUnitWeight, ' + 
                                              'tlStockDeductQty, ' + 
                                              'tlBOMKitLink, ' + 
                                              'tlSOPFolioNum, ' + 
                                              'tlSOPABSLineNo, ' + 
                                              'tlLocation, ' + 
                                              'tlQtyPicked, ' + 
                                              'tlQtyPickedWO, ' +
                                              'tlUsePack, ' + 
                                              'tlSerialQty, ' + 
                                              'tlCOSNomCode, ' + 
                                              'tlOurRef, ' + 
                                              'tlDocLTLink, ' +
                                              'tlPrxPack, ' + 
                                              'tlQtyPack, ' + 
                                              'tlReconciliationDate, ' + 
                                              'tlShowCase, ' + 
                                              'tlSdbFolio, ' + 
                                              'tlOriginalBaseValue, ' + 
                                              'tlUseOriginalRates, ' + 
                                              'tlUserField1, ' + 
                                              'tlUserField2, ' + 
                                              'tlUserField3, ' + 
                                              'tlUserField4, ' + 
                                              'tlSSDUpliftPerc, ' + 
                                              'tlSSDCountry, ' + 
                                              'tlInclusiveVATCode, ' + 
                                              'tlSSDCommodCode, ' + 
                                              'tlSSDSalesUnit, ' + 
                                              'tlPriceMultiplier, ' +
                                              'tlB2BLinkFolio, ' + 
                                              'tlB2BLineNo, ' +
                                              'tlTriRates, ' + 
                                              'tlTriEuro, ' + 
                                              'tlTriInvert, ' +
                                              'tlTriFloat, ' + 
                                              'tlSpare1, ' + 
                                              'tlSSDUseLineValues, ' + 
                                              'tlPreviousBalance, ' +
                                              'tlLiveUplift, ' + 
                                              'tlCOSDailyRate, ' + 
                                              'tlVATIncValue, ' + 
                                              'tlLineSource, ' + 
                                              'tlCISRateCode, ' + 
                                              'tlCISRate, ' + 
                                              'tlCostApport, ' + 
                                              'tlNOMIOFlag, ' + 
                                              'tlBinQty, ' + 
                                              'tlCISAdjustment, ' + 
                                              'tlDeductionType, ' + 
                                              'tlSerialReturnQty, ' + 
                                              'tlBinReturnQty, ' + 
                                              'tlDiscount2, ' + 
                                              'tlDiscount2Chr, ' +
                                              'tlDiscount3, ' + 
                                              'tlDiscount3Chr, ' + 
                                              'tlDiscount3Type, ' +
                                              'tlECService, ' + 
                                              'tlServiceStartDate, ' + 
                                              'tlServiceEndDate, ' + 
                                              'tlECSalesTaxReported, ' + 
                                              'tlPurchaseServiceTax, ' + 
                                              'tlReference, ' + 
                                              'tlReceiptNo, ' + 
                                              'tlFromPostCode, ' + 
                                              'tlToPostCode, ' + 
                                              'tlUserField5, ' + 
                                              'tlUserField6, ' + 
                                              'tlUserField7, ' + 
                                              'tlUserField8, ' + 
                                              'tlUserField9, ' +
                                              'tlUserField10, ' +
                                              'tlThresholdCode, ' +
                                              // MH 14/02/2014 v7.0.9 ABSEXCH-14946: Added support for new Apps 'n Vals field
                                              'tlMaterialsOnlyRetention, ' +
                                              // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                                              'tlIntrastatNoTC, ' +
                                              // CJS 2016-04-27 - Add support for new Tax fields
                                              'tlTaxRegion ' +
                                              ') ' +
              'VALUES (' +
                       ':tlFolioNum, ' +
                       ':tlLineNo, ' +
                       ':tlRunNo, ' +
                       ':tlGLCode, ' +
                       ':tlNominalMode, ' +
                       ':tlCurrency, ' +
                       ':tlYear, ' +
                       ':tlPeriod, ' +
                       ':tlDepartment, ' +
                       ':tlCostCentre, ' +
                       ':tlStockCode, ' +
                       ':tlABSLineNo, ' +
                       ':tlLineType, ' +
                       ':tlDocType, ' +
                       ':tlDLLUpdate, ' +
                       ':tlOldSerialQty, ' +
                       ':tlQty, ' +
                       ':tlQtyMul, ' +
                       ':tlNetValue, ' +
                       ':tlDiscount, ' +
                       ':tlVATCode, ' +
                       ':tlVATAmount, ' +
                       ':tlPaymentCode, ' +
                       ':tlOldPBal, ' + 
                       ':tlRecStatus, ' + 
                       ':tlDiscFlag, ' +
                       ':tlQtyWOFF, ' + 
                       ':tlQtyDel, ' + 
                       ':tlCost, ' + 
                       ':tlAcCode, ' + 
                       ':tlLineDate, ' +
                       ':tlItemNo, ' + 
                       ':tlDescription, ' +
                       ':tlJobCode, ' + 
                       ':tlAnalysisCode, ' + 
                       ':tlCompanyRate, ' + 
                       ':tlDailyRate, ' + 
                       ':tlUnitWeight, ' + 
                       ':tlStockDeductQty, ' +
                       ':tlBOMKitLink, ' + 
                       ':tlSOPFolioNum, ' + 
                       ':tlSOPABSLineNo, ' + 
                       ':tlLocation, ' + 
                       ':tlQtyPicked, ' +
                       ':tlQtyPickedWO, ' +
                       ':tlUsePack, ' + 
                       ':tlSerialQty, ' + 
                       ':tlCOSNomCode, ' +
                       ':tlOurRef, ' + 
                       ':tlDocLTLink, ' + 
                       ':tlPrxPack, ' + 
                       ':tlQtyPack, ' + 
                       ':tlReconciliationDate, ' + 
                       ':tlShowCase, ' + 
                       ':tlSdbFolio, ' + 
                       ':tlOriginalBaseValue, ' + 
                       ':tlUseOriginalRates, ' + 
                       ':tlUserField1, ' + 
                       ':tlUserField2, ' + 
                       ':tlUserField3, ' + 
                       ':tlUserField4, ' + 
                       ':tlSSDUpliftPerc, ' + 
                       ':tlSSDCountry, ' + 
                       ':tlInclusiveVATCode, ' + 
                       ':tlSSDCommodCode, ' + 
                       ':tlSSDSalesUnit, ' + 
                       ':tlPriceMultiplier, ' + 
                       ':tlB2BLinkFolio, ' +
                       ':tlB2BLineNo, ' + 
                       ':tlTriRates, ' +
                       ':tlTriEuro, ' +
                       ':tlTriInvert, ' + 
                       ':tlTriFloat, ' + 
                       ':tlSpare1, ' + 
                       ':tlSSDUseLineValues, ' + 
                       ':tlPreviousBalance, ' + 
                       ':tlLiveUplift, ' + 
                       ':tlCOSDailyRate, ' +
                       ':tlVATIncValue, ' + 
                       ':tlLineSource, ' + 
                       ':tlCISRateCode, ' + 
                       ':tlCISRate, ' + 
                       ':tlCostApport, ' + 
                       ':tlNOMIOFlag, ' + 
                       ':tlBinQty, ' + 
                       ':tlCISAdjustment, ' + 
                       ':tlDeductionType, ' + 
                       ':tlSerialReturnQty, ' + 
                       ':tlBinReturnQty, ' + 
                       ':tlDiscount2, ' +
                       ':tlDiscount2Chr, ' +
                       ':tlDiscount3, ' +
                       ':tlDiscount3Chr, ' +
                       ':tlDiscount3Type, ' +
                       ':tlECService, ' +
                       ':tlServiceStartDate, ' +
                       ':tlServiceEndDate, ' +
                       ':tlECSalesTaxReported, ' +
                       ':tlPurchaseServiceTax, ' +
                       ':tlReference, ' +
                       ':tlReceiptNo, ' +
                       ':tlFromPostCode, ' +
                       ':tlToPostCode, ' +
                       ':tlUserField5, ' +
                       ':tlUserField6, ' +
                       ':tlUserField7, ' +
                       ':tlUserField8, ' +
                       ':tlUserField9, ' +
                       ':tlUserField10, ' +
                       ':tlThresholdCode, ' +
                       // MH 14/02/2014 v7.0.9 ABSEXCH-14946: Added support for new Apps 'n Vals field
                       ':tlMaterialsOnlyRetention, ' +
                       // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
                       ':tlIntrastatNoTC, ' +
                       // CJS 2016-04-27 - Add support for new Tax fields
                       ':tlTaxRegion ' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    tlFolioNumParam := FindParam('tlFolioNum');
    tlLineNoParam := FindParam('tlLineNo');
    tlRunNoParam := FindParam('tlRunNo');
    tlGLCodeParam := FindParam('tlGLCode');
    tlNominalModeParam := FindParam('tlNominalMode');
    tlCurrencyParam := FindParam('tlCurrency');
    tlYearParam := FindParam('tlYear');
    tlPeriodParam := FindParam('tlPeriod');
    tlDepartmentParam := FindParam('tlDepartment');
    tlCostCentreParam := FindParam('tlCostCentre');
    tlStockCodeParam := FindParam('tlStockCode');
    tlABSLineNoParam := FindParam('tlABSLineNo');
    tlLineTypeParam := FindParam('tlLineType');
    tlDocTypeParam := FindParam('tlDocType');
    tlDLLUpdateParam := FindParam('tlDLLUpdate');
    tlOldSerialQtyParam := FindParam('tlOldSerialQty');
    tlQtyParam := FindParam('tlQty');
    tlQtyMulParam := FindParam('tlQtyMul');
    tlNetValueParam := FindParam('tlNetValue');
    tlDiscountParam := FindParam('tlDiscount');
    tlVATCodeParam := FindParam('tlVATCode');
    tlVATAmountParam := FindParam('tlVATAmount');
    tlPaymentCodeParam := FindParam('tlPaymentCode');
    tlOldPBalParam := FindParam('tlOldPBal');
    tlRecStatusParam := FindParam('tlRecStatus');
    tlDiscFlagParam := FindParam('tlDiscFlag');
    tlQtyWOFFParam := FindParam('tlQtyWOFF');
    tlQtyDelParam := FindParam('tlQtyDel');
    tlCostParam := FindParam('tlCost');
    tlAcCodeParam := FindParam('tlAcCode');
    tlLineDateParam := FindParam('tlLineDate');
    tlItemNoParam := FindParam('tlItemNo');
    tlDescriptionParam := FindParam('tlDescription');
    tlJobCodeParam := FindParam('tlJobCode');
    tlAnalysisCodeParam := FindParam('tlAnalysisCode');
    tlCompanyRateParam := FindParam('tlCompanyRate');
    tlDailyRateParam := FindParam('tlDailyRate');
    tlUnitWeightParam := FindParam('tlUnitWeight');
    tlStockDeductQtyParam := FindParam('tlStockDeductQty');
    tlBOMKitLinkParam := FindParam('tlBOMKitLink');
    tlSOPFolioNumParam := FindParam('tlSOPFolioNum');
    tlSOPABSLineNoParam := FindParam('tlSOPABSLineNo');
    tlLocationParam := FindParam('tlLocation');
    tlQtyPickedParam := FindParam('tlQtyPicked');
    tlQtyPickedWOParam := FindParam('tlQtyPickedWO');
    tlUsePackParam := FindParam('tlUsePack');
    tlSerialQtyParam := FindParam('tlSerialQty');
    tlCOSNomCodeParam := FindParam('tlCOSNomCode');
    tlOurRefParam := FindParam('tlOurRef');
    tlDocLTLinkParam := FindParam('tlDocLTLink');
    tlPrxPackParam := FindParam('tlPrxPack');
    tlQtyPackParam := FindParam('tlQtyPack');
    tlReconciliationDateParam := FindParam('tlReconciliationDate');
    tlShowCaseParam := FindParam('tlShowCase');
    tlSdbFolioParam := FindParam('tlSdbFolio');
    tlOriginalBaseValueParam := FindParam('tlOriginalBaseValue');
    tlUseOriginalRatesParam := FindParam('tlUseOriginalRates');
    tlUserField1Param := FindParam('tlUserField1');
    tlUserField2Param := FindParam('tlUserField2');
    tlUserField3Param := FindParam('tlUserField3');
    tlUserField4Param := FindParam('tlUserField4');
    tlSSDUpliftPercParam := FindParam('tlSSDUpliftPerc');
    tlSSDCountryParam := FindParam('tlSSDCountry');
    tlInclusiveVATCodeParam := FindParam('tlInclusiveVATCode');
    tlSSDCommodCodeParam := FindParam('tlSSDCommodCode');
    tlSSDSalesUnitParam := FindParam('tlSSDSalesUnit');
    tlPriceMultiplierParam := FindParam('tlPriceMultiplier');
    tlB2BLinkFolioParam := FindParam('tlB2BLinkFolio');
    tlB2BLineNoParam := FindParam('tlB2BLineNo');
    tlTriRatesParam := FindParam('tlTriRates');
    tlTriEuroParam := FindParam('tlTriEuro');
    tlTriInvertParam := FindParam('tlTriInvert');
    tlTriFloatParam := FindParam('tlTriFloat');
    tlSpare1Param := FindParam('tlSpare1');
    tlSSDUseLineValuesParam := FindParam('tlSSDUseLineValues');
    tlPreviousBalanceParam := FindParam('tlPreviousBalance');
    tlLiveUpliftParam := FindParam('tlLiveUplift');
    tlCOSDailyRateParam := FindParam('tlCOSDailyRate');
    tlVATIncValueParam := FindParam('tlVATIncValue');
    tlLineSourceParam := FindParam('tlLineSource');
    tlCISRateCodeParam := FindParam('tlCISRateCode');
    tlCISRateParam := FindParam('tlCISRate');
    tlCostApportParam := FindParam('tlCostApport');
    tlNOMIOFlagParam := FindParam('tlNOMIOFlag');
    tlBinQtyParam := FindParam('tlBinQty');
    tlCISAdjustmentParam := FindParam('tlCISAdjustment');
    tlDeductionTypeParam := FindParam('tlDeductionType');
    tlSerialReturnQtyParam := FindParam('tlSerialReturnQty');
    tlBinReturnQtyParam := FindParam('tlBinReturnQty');
    tlDiscount2Param := FindParam('tlDiscount2');
    tlDiscount2ChrParam := FindParam('tlDiscount2Chr');
    tlDiscount3Param := FindParam('tlDiscount3');
    tlDiscount3ChrParam := FindParam('tlDiscount3Chr');
    tlDiscount3TypeParam := FindParam('tlDiscount3Type');
    tlECServiceParam := FindParam('tlECService');
    tlServiceStartDateParam := FindParam('tlServiceStartDate');
    tlServiceEndDateParam := FindParam('tlServiceEndDate');
    tlECSalesTaxReportedParam := FindParam('tlECSalesTaxReported');
    tlPurchaseServiceTaxParam := FindParam('tlPurchaseServiceTax');
    tlReferenceParam := FindParam('tlReference');
    tlReceiptNoParam := FindParam('tlReceiptNo');
    tlFromPostCodeParam := FindParam('tlFromPostCode');
    tlToPostCodeParam := FindParam('tlToPostCode');
    tlUserField5Param := FindParam('tlUserField5');
    tlUserField6Param := FindParam('tlUserField6');
    tlUserField7Param := FindParam('tlUserField7');
    tlUserField8Param := FindParam('tlUserField8');
    tlUserField9Param := FindParam('tlUserField9');
    tlUserField10Param := FindParam('tlUserField10');
    tlThresholdCodeParam := FindParam('tlThresholdCode');
    // MH 14/02/2014 v7.0.9 ABSEXCH-14946: Added support for new Apps 'n Vals field
    tlMaterialsOnlyRetentionParam := FindParam('tlMaterialsOnlyRetention');
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tlIntrastatNoTCParam := FindParam('tlIntrastatNoTC');
    // CJS 2016-04-27 - Add support for new Tax fields
    tlTaxRegionParam := FindParam('tlTaxRegion');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TDetailsDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^Idetail;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^ Do
  Begin
    tlFolioNumParam.Value := FolioRef;                                                                 // SQL=int, Delphi=LongInt
    tlLineNoParam.Value := LineNo;                                                                     // SQL=int, Delphi=LongInt
    tlRunNoParam.Value := PostedRun;                                                                   // SQL=int, Delphi=LongInt
    tlGLCodeParam.Value := NomCode;                                                                    // SQL=int, Delphi=LongInt
    tlNominalModeParam.Value := NomMode;                                                               // SQL=int, Delphi=Byte
    tlCurrencyParam.Value := Currency;                                                                 // SQL=int, Delphi=Byte
    tlYearParam.Value := PYr;                                                                          // SQL=int, Delphi=Byte
    tlPeriodParam.Value := PPr;                                                                        // SQL=int, Delphi=Byte
    tlDepartmentParam.Value := CCDep[False];                                                           // SQL=varchar, Delphi=String[3]
    tlCostCentreParam.Value := CCDep[True];                                                            // SQL=varchar, Delphi=String[3]
    // *** BINARY ***
    tlStockCodeParam.Value := CreateVariantArray (@StockCode, SizeOf(StockCode));       // SQL=varbinary, Delphi=String[20]
    tlABSLineNoParam.Value := ABSLineNo;                                                               // SQL=int, Delphi=LongInt
    tlLineTypeParam.Value := ConvertCharToSQLEmulatorVarChar(LineType);                                // SQL=varchar, Delphi=Char
    tlDocTypeParam.Value := IdDocHed;                                                                  // SQL=int, Delphi=DocTypes
    tlDLLUpdateParam.Value := DLLUpdate;                                                               // SQL=int, Delphi=Byte
    tlOldSerialQtyParam.Value := OldSerQty;                                                            // SQL=int, Delphi=SmallInt
    tlQtyParam.Value := Qty;                                                                           // SQL=float, Delphi=Real
    tlQtyMulParam.Value := QtyMul;                                                                     // SQL=float, Delphi=Real
    tlNetValueParam.Value := NetValue;                                                                 // SQL=float, Delphi=Real
    tlDiscountParam.Value := Discount;                                                                 // SQL=float, Delphi=Real
    tlVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VATCode);                                  // SQL=varchar, Delphi=Char
    tlVATAmountParam.Value := VAT;                                                                     // SQL=float, Delphi=Real
    tlPaymentCodeParam.Value := ConvertCharToSQLEmulatorVarChar(Payment);                              // SQL=varchar, Delphi=Char
    tlOldPBalParam.Value := OldPBal;                                                                   // SQL=float, Delphi=Real
    tlRecStatusParam.Value := Reconcile;                                                               // SQL=int, Delphi=Byte
    tlDiscFlagParam.Value := ConvertCharToSQLEmulatorVarChar(DiscountChr);                             // SQL=varchar, Delphi=Char
    tlQtyWOFFParam.Value := QtyWOFF;                                                                   // SQL=float, Delphi=Real
    tlQtyDelParam.Value := QtyDel;                                                                     // SQL=float, Delphi=Real
    tlCostParam.Value := CostPrice;                                                                    // SQL=float, Delphi=Real
    tlAcCodeParam.Value := CustCode;                                                                   // SQL=varchar, Delphi=String[10]
    tlLineDateParam.Value := PDate;                                                                    // SQL=varchar, Delphi=LongDate
    tlItemNoParam.Value := Item;                                                                       // SQL=varchar, Delphi=String[3]
    tlDescriptionParam.Value := Desc;                                                                  // SQL=varchar, Delphi=String[60]
    tlJobCodeParam.Value := JobCode;                                                                   // SQL=varchar, Delphi=String[10]
    tlAnalysisCodeParam.Value := AnalCode;                                                             // SQL=varchar, Delphi=String[10]
    tlCompanyRateParam.Value := CXrate[False];                                                         // SQL=float, Delphi=Double
    tlDailyRateParam.Value := CXRate[True];                                                            // SQL=float, Delphi=Double
    tlUnitWeightParam.Value := LWeight;                                                                // SQL=float, Delphi=Real
    tlStockDeductQtyParam.Value := DeductQty;                                                          // SQL=float, Delphi=Real
    tlBOMKitLinkParam.Value := KitLink;                                                                // SQL=int, Delphi=LongInt
    tlSOPFolioNumParam.Value := SOPLink;                                                               // SQL=int, Delphi=LongInt
    tlSOPABSLineNoParam.Value := SOPLineNo;                                                            // SQL=int, Delphi=LongInt
    tlLocationParam.Value := MLocStk;                                                                  // SQL=varchar, Delphi=String[3]
    tlQtyPickedParam.Value := QtyPick;                                                                 // SQL=float, Delphi=Real
    tlQtyPickedWOParam.Value := QtyPWOff;                                                              // SQL=float, Delphi=Real
    tlUsePackParam.Value := UsePack;                                                                   // SQL=bit, Delphi=Boolean
    tlSerialQtyParam.Value := SerialQty;                                                               // SQL=float, Delphi=Real
    tlCOSNomCodeParam.Value := COSNomCode;                                                             // SQL=int, Delphi=LongInt
    tlOurRefParam.Value := DocPRef;                                                                    // SQL=varchar, Delphi=String[10]
    tlDocLTLinkParam.Value := DocLTLink;                                                               // SQL=int, Delphi=Byte
    tlPrxPackParam.Value := PrxPack;                                                                   // SQL=bit, Delphi=Boolean
    tlQtyPackParam.Value := QtyPack;                                                                   // SQL=float, Delphi=Double
    tlReconciliationDateParam.Value := ReconDate;                                                      // SQL=varchar, Delphi=LongDate
    tlShowCaseParam.Value := ShowCase;                                                                 // SQL=bit, Delphi=Boolean
    tlSdbFolioParam.Value := sdbFolio;                                                                 // SQL=int, Delphi=LongInt
    tlOriginalBaseValueParam.Value := OBaseEquiv;                                                      // SQL=float, Delphi=Double
    tlUseOriginalRatesParam.Value := UseORate;                                                         // SQL=int, Delphi=Byte
    tlUserField1Param.Value := LineUser1;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField2Param.Value := LineUser2;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField3Param.Value := LineUser3;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField4Param.Value := LineUser4;                                                              // SQL=varchar, Delphi=String[30]
    tlSSDUpliftPercParam.Value := SSDUplift;                                                           // SQL=float, Delphi=Double
    tlSSDCountryParam.Value := SSDCountry;                                                             // SQL=varchar, Delphi=String[5]
    tlInclusiveVATCodeParam.Value := ConvertCharToSQLEmulatorVarChar(VATIncFlg);                       // SQL=varchar, Delphi=Char
    tlSSDCommodCodeParam.Value := SSDCommod;                                                           // SQL=varchar, Delphi=String[10]
    tlSSDSalesUnitParam.Value := SSDSPUnit;                                                            // SQL=float, Delphi=Double
    tlPriceMultiplierParam.Value := PriceMulx;                                                         // SQL=float, Delphi=Double
    tlB2BLinkFolioParam.Value := B2BLink;                                                              // SQL=int, Delphi=Longint
    tlB2BLineNoParam.Value := B2BLineNo;                                                               // SQL=int, Delphi=LongInt
    tlTriRatesParam.Value := CurrTriR.TriRates;                                                        // SQL=float, Delphi=Double
    tlTriEuroParam.Value := CurrTriR.TriEuro;                                                          // SQL=int, Delphi=Byte
    tlTriInvertParam.Value := CurrTriR.TriInvert;                                                      // SQL=bit, Delphi=Boolean
    tlTriFloatParam.Value := CurrTriR.TriFloat;                                                        // SQL=bit, Delphi=Boolean
    // *** BINARY ***
    tlSpare1Param.Value := CreateVariantArray (@CurrTriR.Spare, SizeOf(CurrTriR.Spare));               // SQL=varbinary, Delphi=array[1..10] of Byte
    tlSSDUseLineValuesParam.Value := SSDUseLine;                                                       // SQL=bit, Delphi=Boolean
    tlPreviousBalanceParam.Value := PreviousBal;                                                       // SQL=float, Delphi=Double
    tlLiveUpliftParam.Value := LiveUplift;                                                             // SQL=bit, Delphi=Boolean
    tlCOSDailyRateParam.Value := COSConvRate;                                                          // SQL=float, Delphi=Double
    tlVATIncValueParam.Value := IncNetValue;                                                           // SQL=float, Delphi=Double
    tlLineSourceParam.Value := AutoLineType;                                                           // SQL=int, Delphi=Byte
    tlCISRateCodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRateCode);                          // SQL=varchar, Delphi=Char
    tlCISRateParam.Value := CISRate;                                                                   // SQL=float, Delphi=Double
    tlCostApportParam.Value := CostApport;                                                             // SQL=float, Delphi=Double
    tlNOMIOFlagParam.Value := NOMIOFlg;                                                                // SQL=int, Delphi=Byte
    tlBinQtyParam.Value := BinQty;                                                                     // SQL=float, Delphi=Double
    tlCISAdjustmentParam.Value := CISAdjust;                                                           // SQL=float, Delphi=Double
    tlDeductionTypeParam.Value := JAPDedType;                                                          // SQL=int, Delphi=Byte
    tlSerialReturnQtyParam.Value := SerialRetQty;                                                      // SQL=float, Delphi=Double
    tlBinReturnQtyParam.Value := BinRetQty;                                                            // SQL=float, Delphi=Double
    tlDiscount2Param.Value := Discount2;                                                               // SQL=float, Delphi=Real48
    tlDiscount2ChrParam.Value := ConvertCharToSQLEmulatorVarChar(Discount2Chr);                        // SQL=varchar, Delphi=Char
    tlDiscount3Param.Value := Discount3;                                                               // SQL=float, Delphi=Real48
    tlDiscount3ChrParam.Value := ConvertCharToSQLEmulatorVarChar(Discount3Chr);                        // SQL=varchar, Delphi=Char
    tlDiscount3TypeParam.Value := Discount3Type;                                                       // SQL=int, Delphi=Byte
    tlECServiceParam.Value := ECService;                                                               // SQL=bit, Delphi=Boolean
    tlServiceStartDateParam.Value := ServiceStartDate;                                                 // SQL=varchar, Delphi=LongDate
    tlServiceEndDateParam.Value := ServiceEndDate;                                                     // SQL=varchar, Delphi=LongDate
    tlECSalesTaxReportedParam.Value := ECSalesTaxReported;                                             // SQL=float, Delphi=Double
    tlPurchaseServiceTaxParam.Value := PurchaseServiceTax;                                             // SQL=float, Delphi=Double
    tlReferenceParam.Value := tlReference;                                                             // SQL=varchar, Delphi=String[20]
    tlReceiptNoParam.Value := tlReceiptNo;                                                             // SQL=varchar, Delphi=String[20]
    tlFromPostCodeParam.Value := tlFromPostCode;                                                       // SQL=varchar, Delphi=String[15]
    tlToPostCodeParam.Value := tlToPostCode;                                                           // SQL=varchar, Delphi=String[15]
    tlUserField5Param.Value := LineUser5;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField6Param.Value := LineUser6;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField7Param.Value := LineUser7;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField8Param.Value := LineUser8;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField9Param.Value := LineUser9;                                                              // SQL=varchar, Delphi=String[30]
    tlUserField10Param.Value := LineUser10;                                                            // SQL=varchar, Delphi=String[30]
    tlThresholdCodeParam.Value := tlThresholdCode;                                                     // SQL=varchar, Delphi=String[12]
    // MH 14/02/2014 v7.0.9 ABSEXCH-14946: Added support for new Apps 'n Vals field
    tlMaterialsOnlyRetentionParam.Value := tlMaterialsOnlyRetention;
    // CJS 2016-01-27 - ABSEXCH-17118 - Add support for new Intrastat fields
    tlIntrastatNoTCParam.Value := tlIntrastatNoTC;
    // CJS 2016-04-27 - Add support for new Tax fields
    tlTaxRegionParam.Value := tlTaxRegion;
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

