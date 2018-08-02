Unit oLHeaderDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, SQLConvertUtils, GlobVar,
     BtrvU2;

Type
  TLHeaderDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    lhFolioNoParam, lhUserNameParam, lhAccountCodeParam, lhAccountNameParam, 
    lhCustomerNameParam, lhOrderNoParam, lhAddress1Param, lhAddress2Param, 
    lhAddress3Param, lhAddress4Param, lhAddress5Param, lhItemsDescParam, 
    lhSettDiscParam, lhSettDiscDaysParam, lhDepositToTakeParam, lhDateParam, 
    lhTimeParam, lhTillNoParam, lhValueParam, lhCostCentreParam, lhDepartmentParam, 
    lhDummyCharParam, RunNoParam, CustCodeParam, OurRefParam, PadChar1Param,
    FolioNumParam, CurrencyParam, AcYrParam, AcPrParam, DueDateParam, TransDateParam, 
    CoRateParam, VATRateParam, OldYourRefParam, LongYrRefParam, LineCountParam,
    TransDocHedParam, VATAnalysisStandardParam, VATAnalysisExemptParam, 
    VATAnalysisZeroParam, VATAnalysisRate1Param, VATAnalysisRate2Param, 
    VATAnalysisRate3Param, VATAnalysisRate4Param, VATAnalysisRate5Param, 
    VATAnalysisRate6Param, VATAnalysisRate7Param, VATAnalysisRate8Param, 
    VATAnalysisRate9Param, VATAnalysisRateTParam, VATAnalysisRateXParam, 
    VATAnalysisRateBParam, VATAnalysisRateCParam, VATAnalysisRateFParam, 
    VATAnalysisRateGParam, VATAnalysisRateRParam, VATAnalysisRateWParam, 
    VATAnalysisRateYParam, InvNetValParam, InvVatParam, DiscSetlParam,
    DiscSetAmParam, DiscAmountParam, DiscDaysParam, DiscTakenParam, SettledParam, 
    TransNatParam, TransModeParam, HoldFlgParam, PadChar2Param, TotalWeightParam,
    DAddr1Param, DAddr2Param, DAddr3Param, DAddr4Param, DAddr5Param, PadChar3Param, 
    TotalCostParam, PrintedDocParam, ManVATParam, DelTermsParam, OpNameParam, 
    DJobCodeParam, DJobAnalParam, PadChar4Param, TotOrdOSParam, DocUser1Param, 
    DocUser2Param, EmpCodeParam, PadChar5Param, TaggedParam, thNoLabelsParam, 
    PadChar6Param, CtrlNomParam, DocUser3Param, DocUser4Param, SSDProcessParam, 
    PadChar7Param, ExtSourceParam, PostDateParam, PadChar8Param, PORPickSORParam, 
    PadChar9Param, BDiscountParam, PrePostFlgParam, AllocStatParam, PadChar10Param, 
    SOPKeepRateParam, TimeCreateParam, TimeChangeParam, CISTaxParam, CISDeclaredParam, 
    CISManualTaxParam, CISDateParam, PadChar11Param, TotalCost2Param, CISEmplParam,
    PadChar12Param, CISGrossParam, CISHolderParam, NOMVatIOParam, AutoIncParam,
    AutoIncByParam, AutoEndDateParam, AutoEndPrParam, AutoEndYrParam, AutoPostParam,
    thAutoTransactionParam, PadChar13Param, thDeliveryRunNoParam, thExternalParam, 
    thSettledVATParam, thVATClaimedParam, thPickingRunNoParam, PadChar15Param, 
    thDeliveryNoteRefParam, thVATCompanyRateParam, thVATDailyRateParam, 
    thPostCompanyRateParam, thPostDailyRateParam, thPostDiscAmountParam,
    PadChar16Param, thPostDiscTakenParam, thLastDebtChaseLetterParam, thRevaluationAdjustmentParam,
    YourRefParam, SpareParam, LastCharParam: TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TLHeaderDataWrite

{$I w:\entrprse\dlltk\ExchDll.inc}
{$I w:\entrprse\epos\shared\layrec.Pas}

Implementation

Uses Graphics, Variants;

//=========================================================================

Constructor TLHeaderDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TLHeaderDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TLHeaderDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].LHEADER (' +
                                              'lhFolioNo, ' +
                                              'lhUserName, ' +
                                              'lhAccountCode, ' + 
                                              'lhAccountName, ' + 
                                              'lhCustomerName, ' + 
                                              'lhOrderNo, ' + 
                                              'lhAddress1, ' + 
                                              'lhAddress2, ' + 
                                              'lhAddress3, ' + 
                                              'lhAddress4, ' + 
                                              'lhAddress5, ' +
                                              'lhItemsDesc, ' + 
                                              'lhSettDisc, ' + 
                                              'lhSettDiscDays, ' + 
                                              'lhDepositToTake, ' + 
                                              'lhDate, ' +
                                              'lhTime, ' + 
                                              'lhTillNo, ' + 
                                              'lhValue, ' +
                                              'lhCostCentre, ' +
                                              'lhDepartment, ' + 
                                              'lhDummyChar, ' +
                                              'RunNo, ' +
                                              'CustCode, ' +
                                              'OurRef, ' + 
                                              'PadChar1, ' +
                                              'FolioNum, ' + 
                                              'Currency, ' +
                                              'AcYr, ' + 
                                              'AcPr, ' +
                                              'DueDate, ' + 
                                              'TransDate, ' + 
                                              'CoRate, ' + 
                                              'VATRate, ' + 
                                              'OldYourRef, ' + 
                                              'LongYrRef, ' + 
                                              'LineCount, ' + 
                                              'TransDocHed, ' +
                                              'VATAnalysisStandard, ' + 
                                              'VATAnalysisExempt, ' +
                                              'VATAnalysisZero, ' +
                                              'VATAnalysisRate1, ' + 
                                              'VATAnalysisRate2, ' + 
                                              'VATAnalysisRate3, ' + 
                                              'VATAnalysisRate4, ' + 
                                              'VATAnalysisRate5, ' + 
                                              'VATAnalysisRate6, ' + 
                                              'VATAnalysisRate7, ' + 
                                              'VATAnalysisRate8, ' + 
                                              'VATAnalysisRate9, ' + 
                                              'VATAnalysisRateT, ' + 
                                              'VATAnalysisRateX, ' + 
                                              'VATAnalysisRateB, ' + 
                                              'VATAnalysisRateC, ' + 
                                              'VATAnalysisRateF, ' + 
                                              'VATAnalysisRateG, ' +
                                              'VATAnalysisRateR, ' + 
                                              'VATAnalysisRateW, ' + 
                                              'VATAnalysisRateY, ' + 
                                              'InvNetVal, ' +
                                              'InvVat, ' + 
                                              'DiscSetl, ' +
                                              'DiscSetAm, ' +
                                              'DiscAmount, ' +
                                              'DiscDays, ' + 
                                              'DiscTaken, ' +
                                              'Settled, ' + 
                                              'TransNat, ' +
                                              'TransMode, ' + 
                                              'HoldFlg, ' +
                                              'PadChar2, ' + 
                                              'TotalWeight, ' + 
                                              'DAddr1, ' + 
                                              'DAddr2, ' + 
                                              'DAddr3, ' + 
                                              'DAddr4, ' + 
                                              'DAddr5, ' + 
                                              'PadChar3, ' + 
                                              'TotalCost, ' + 
                                              'PrintedDoc, ' +
                                              'ManVAT, ' +
                                              'DelTerms, ' +
                                              'OpName, ' + 
                                              'DJobCode, ' + 
                                              'DJobAnal, ' + 
                                              'PadChar4, ' + 
                                              'TotOrdOS, ' + 
                                              'DocUser1, ' + 
                                              'DocUser2, ' + 
                                              'EmpCode, ' + 
                                              'PadChar5, ' + 
                                              'Tagged, ' + 
                                              'thNoLabels, ' + 
                                              'PadChar6, ' + 
                                              'CtrlNom, ' + 
                                              'DocUser3, ' +
                                              'DocUser4, ' + 
                                              'SSDProcess, ' + 
                                              'PadChar7, ' + 
                                              'ExtSource, ' + 
                                              'PostDate, ' + 
                                              'PadChar8, ' +
                                              'PORPickSOR, ' +
                                              'PadChar9, ' +
                                              'BDiscount, ' + 
                                              'PrePostFlg, ' +
                                              'AllocStat, ' +
                                              'PadChar10, ' +
                                              'SOPKeepRate, ' + 
                                              'TimeCreate, ' +
                                              'TimeChange, ' + 
                                              'CISTax, ' + 
                                              'CISDeclared, ' + 
                                              'CISManualTax, ' + 
                                              'CISDate, ' + 
                                              'PadChar11, ' + 
                                              'TotalCost2, ' + 
                                              'CISEmpl, ' + 
                                              'PadChar12, ' + 
                                              'CISGross, ' +
                                              'CISHolder, ' +
                                              'NOMVatIO, ' + 
                                              'AutoInc, ' + 
                                              'AutoIncBy, ' + 
                                              'AutoEndDate, ' + 
                                              'AutoEndPr, ' +
                                              'AutoEndYr, ' +
                                              'AutoPost, ' +
                                              'thAutoTransaction, ' +
                                              'PadChar13, ' +
                                              'thDeliveryRunNo, ' +
                                              'thExternal, ' +
                                              'thSettledVAT, ' +
                                              'thVATClaimed, ' +
                                              'thPickingRunNo, ' +
                                              'PadChar15, ' +
                                              'thDeliveryNoteRef, ' +
                                              'thVATCompanyRate, ' +
                                              'thVATDailyRate, ' +
                                              'thPostCompanyRate, ' +
                                              'thPostDailyRate, ' +
                                              'thPostDiscAmount, ' +
                                              'PadChar16, ' +
                                              'thPostDiscTaken, ' +
                                              'thLastDebtChaseLetter, ' +
                                              'thRevaluationAdjustment, ' +
                                              'YourRef, ' +
                                              'Spare, ' +
                                              'LastChar' +
                                              ') ' +
              'VALUES (' +
                       ':lhFolioNo, ' +
                       ':lhUserName, ' +
                       ':lhAccountCode, ' +
                       ':lhAccountName, ' +
                       ':lhCustomerName, ' +
                       ':lhOrderNo, ' +
                       ':lhAddress1, ' +
                       ':lhAddress2, ' +
                       ':lhAddress3, ' +
                       ':lhAddress4, ' +
                       ':lhAddress5, ' +
                       ':lhItemsDesc, ' +
                       ':lhSettDisc, ' +
                       ':lhSettDiscDays, ' +
                       ':lhDepositToTake, ' +
                       ':lhDate, ' +
                       ':lhTime, ' + 
                       ':lhTillNo, ' + 
                       ':lhValue, ' + 
                       ':lhCostCentre, ' +
                       ':lhDepartment, ' + 
                       ':lhDummyChar, ' + 
                       ':RunNo, ' + 
                       ':CustCode, ' + 
                       ':OurRef, ' +
                       ':PadChar1, ' + 
                       ':FolioNum, ' + 
                       ':Currency, ' + 
                       ':AcYr, ' + 
                       ':AcPr, ' + 
                       ':DueDate, ' +
                       ':TransDate, ' +
                       ':CoRate, ' +
                       ':VATRate, ' + 
                       ':OldYourRef, ' +
                       ':LongYrRef, ' + 
                       ':LineCount, ' + 
                       ':TransDocHed, ' + 
                       ':VATAnalysisStandard, ' +
                       ':VATAnalysisExempt, ' + 
                       ':VATAnalysisZero, ' + 
                       ':VATAnalysisRate1, ' +
                       ':VATAnalysisRate2, ' + 
                       ':VATAnalysisRate3, ' +
                       ':VATAnalysisRate4, ' +
                       ':VATAnalysisRate5, ' + 
                       ':VATAnalysisRate6, ' + 
                       ':VATAnalysisRate7, ' + 
                       ':VATAnalysisRate8, ' +
                       ':VATAnalysisRate9, ' +
                       ':VATAnalysisRateT, ' + 
                       ':VATAnalysisRateX, ' + 
                       ':VATAnalysisRateB, ' + 
                       ':VATAnalysisRateC, ' + 
                       ':VATAnalysisRateF, ' + 
                       ':VATAnalysisRateG, ' + 
                       ':VATAnalysisRateR, ' + 
                       ':VATAnalysisRateW, ' + 
                       ':VATAnalysisRateY, ' + 
                       ':InvNetVal, ' +
                       ':InvVat, ' + 
                       ':DiscSetl, ' + 
                       ':DiscSetAm, ' + 
                       ':DiscAmount, ' +
                       ':DiscDays, ' +
                       ':DiscTaken, ' + 
                       ':Settled, ' + 
                       ':TransNat, ' + 
                       ':TransMode, ' + 
                       ':HoldFlg, ' + 
                       ':PadChar2, ' +
                       ':TotalWeight, ' +
                       ':DAddr1, ' +
                       ':DAddr2, ' + 
                       ':DAddr3, ' +
                       ':DAddr4, ' + 
                       ':DAddr5, ' + 
                       ':PadChar3, ' +
                       ':TotalCost, ' +
                       ':PrintedDoc, ' + 
                       ':ManVAT, ' + 
                       ':DelTerms, ' + 
                       ':OpName, ' + 
                       ':DJobCode, ' + 
                       ':DJobAnal, ' + 
                       ':PadChar4, ' +
                       ':TotOrdOS, ' + 
                       ':DocUser1, ' +
                       ':DocUser2, ' +
                       ':EmpCode, ' +
                       ':PadChar5, ' + 
                       ':Tagged, ' + 
                       ':thNoLabels, ' + 
                       ':PadChar6, ' + 
                       ':CtrlNom, ' + 
                       ':DocUser3, ' + 
                       ':DocUser4, ' + 
                       ':SSDProcess, ' + 
                       ':PadChar7, ' + 
                       ':ExtSource, ' + 
                       ':PostDate, ' + 
                       ':PadChar8, ' + 
                       ':PORPickSOR, ' + 
                       ':PadChar9, ' +
                       ':BDiscount, ' +
                       ':PrePostFlg, ' + 
                       ':AllocStat, ' + 
                       ':PadChar10, ' +
                       ':SOPKeepRate, ' + 
                       ':TimeCreate, ' + 
                       ':TimeChange, ' +
                       ':CISTax, ' +
                       ':CISDeclared, ' +
                       ':CISManualTax, ' + 
                       ':CISDate, ' +
                       ':PadChar11, ' + 
                       ':TotalCost2, ' + 
                       ':CISEmpl, ' +
                       ':PadChar12, ' + 
                       ':CISGross, ' + 
                       ':CISHolder, ' + 
                       ':NOMVatIO, ' + 
                       ':AutoInc, ' + 
                       ':AutoIncBy, ' + 
                       ':AutoEndDate, ' + 
                       ':AutoEndPr, ' + 
                       ':AutoEndYr, ' + 
                       ':AutoPost, ' + 
                       ':thAutoTransaction, ' +
                       ':PadChar13, ' +
                       ':thDeliveryRunNo, ' +
                       ':thExternal, ' +
                       ':thSettledVAT, ' +
                       ':thVATClaimed, ' +
                       ':thPickingRunNo, ' +
                       ':PadChar15, ' +
                       ':thDeliveryNoteRef, ' +
                       ':thVATCompanyRate, ' +
                       ':thVATDailyRate, ' +
                       ':thPostCompanyRate, ' +
                       ':thPostDailyRate, ' +
                       ':thPostDiscAmount, ' +
                       ':PadChar16, ' +
                       ':thPostDiscTaken, ' +
                       ':thLastDebtChaseLetter, ' +
                       ':thRevaluationAdjustment, ' +
                       ':YourRef, ' +
                       ':Spare, ' +
                       ':LastChar' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    lhFolioNoParam := FindParam('lhFolioNo');
    lhUserNameParam := FindParam('lhUserName');
    lhAccountCodeParam := FindParam('lhAccountCode');
    lhAccountNameParam := FindParam('lhAccountName');
    lhCustomerNameParam := FindParam('lhCustomerName');
    lhOrderNoParam := FindParam('lhOrderNo');
    lhAddress1Param := FindParam('lhAddress1');
    lhAddress2Param := FindParam('lhAddress2');
    lhAddress3Param := FindParam('lhAddress3');
    lhAddress4Param := FindParam('lhAddress4');
    lhAddress5Param := FindParam('lhAddress5');
    lhItemsDescParam := FindParam('lhItemsDesc');
    lhSettDiscParam := FindParam('lhSettDisc');
    lhSettDiscDaysParam := FindParam('lhSettDiscDays');
    lhDepositToTakeParam := FindParam('lhDepositToTake');
    lhDateParam := FindParam('lhDate');
    lhTimeParam := FindParam('lhTime');
    lhTillNoParam := FindParam('lhTillNo');
    lhValueParam := FindParam('lhValue');
    lhCostCentreParam := FindParam('lhCostCentre');
    lhDepartmentParam := FindParam('lhDepartment');
    lhDummyCharParam := FindParam('lhDummyChar');
    RunNoParam := FindParam('RunNo');
    CustCodeParam := FindParam('CustCode');
    OurRefParam := FindParam('OurRef');
    PadChar1Param := FindParam('PadChar1');
    FolioNumParam := FindParam('FolioNum');
    CurrencyParam := FindParam('Currency');
    AcYrParam := FindParam('AcYr');
    AcPrParam := FindParam('AcPr');
    DueDateParam := FindParam('DueDate');
    TransDateParam := FindParam('TransDate');
    CoRateParam := FindParam('CoRate');
    VATRateParam := FindParam('VATRate');
    OldYourRefParam := FindParam('OldYourRef');
    LongYrRefParam := FindParam('LongYrRef');
    LineCountParam := FindParam('LineCount');
    TransDocHedParam := FindParam('TransDocHed');
    VATAnalysisStandardParam := FindParam('VATAnalysisStandard');
    VATAnalysisExemptParam := FindParam('VATAnalysisExempt');
    VATAnalysisZeroParam := FindParam('VATAnalysisZero');
    VATAnalysisRate1Param := FindParam('VATAnalysisRate1');
    VATAnalysisRate2Param := FindParam('VATAnalysisRate2');
    VATAnalysisRate3Param := FindParam('VATAnalysisRate3');
    VATAnalysisRate4Param := FindParam('VATAnalysisRate4');
    VATAnalysisRate5Param := FindParam('VATAnalysisRate5');
    VATAnalysisRate6Param := FindParam('VATAnalysisRate6');
    VATAnalysisRate7Param := FindParam('VATAnalysisRate7');
    VATAnalysisRate8Param := FindParam('VATAnalysisRate8');
    VATAnalysisRate9Param := FindParam('VATAnalysisRate9');
    VATAnalysisRateTParam := FindParam('VATAnalysisRateT');
    VATAnalysisRateXParam := FindParam('VATAnalysisRateX');
    VATAnalysisRateBParam := FindParam('VATAnalysisRateB');
    VATAnalysisRateCParam := FindParam('VATAnalysisRateC');
    VATAnalysisRateFParam := FindParam('VATAnalysisRateF');
    VATAnalysisRateGParam := FindParam('VATAnalysisRateG');
    VATAnalysisRateRParam := FindParam('VATAnalysisRateR');
    VATAnalysisRateWParam := FindParam('VATAnalysisRateW');
    VATAnalysisRateYParam := FindParam('VATAnalysisRateY');
    InvNetValParam := FindParam('InvNetVal');
    InvVatParam := FindParam('InvVat');
    DiscSetlParam := FindParam('DiscSetl');
    DiscSetAmParam := FindParam('DiscSetAm');
    DiscAmountParam := FindParam('DiscAmount');
    DiscDaysParam := FindParam('DiscDays');
    DiscTakenParam := FindParam('DiscTaken');
    SettledParam := FindParam('Settled');
    TransNatParam := FindParam('TransNat');
    TransModeParam := FindParam('TransMode');
    HoldFlgParam := FindParam('HoldFlg');
    PadChar2Param := FindParam('PadChar2');
    TotalWeightParam := FindParam('TotalWeight');
    DAddr1Param := FindParam('DAddr1');
    DAddr2Param := FindParam('DAddr2');
    DAddr3Param := FindParam('DAddr3');
    DAddr4Param := FindParam('DAddr4');
    DAddr5Param := FindParam('DAddr5');
    PadChar3Param := FindParam('PadChar3');
    TotalCostParam := FindParam('TotalCost');
    PrintedDocParam := FindParam('PrintedDoc');
    ManVATParam := FindParam('ManVAT');
    DelTermsParam := FindParam('DelTerms');
    OpNameParam := FindParam('OpName');
    DJobCodeParam := FindParam('DJobCode');
    DJobAnalParam := FindParam('DJobAnal');
    PadChar4Param := FindParam('PadChar4');
    TotOrdOSParam := FindParam('TotOrdOS');
    DocUser1Param := FindParam('DocUser1');
    DocUser2Param := FindParam('DocUser2');
    EmpCodeParam := FindParam('EmpCode');
    PadChar5Param := FindParam('PadChar5');
    TaggedParam := FindParam('Tagged');
    thNoLabelsParam := FindParam('thNoLabels');
    PadChar6Param := FindParam('PadChar6');
    CtrlNomParam := FindParam('CtrlNom');
    DocUser3Param := FindParam('DocUser3');
    DocUser4Param := FindParam('DocUser4');
    SSDProcessParam := FindParam('SSDProcess');
    PadChar7Param := FindParam('PadChar7');
    ExtSourceParam := FindParam('ExtSource');
    PostDateParam := FindParam('PostDate');
    PadChar8Param := FindParam('PadChar8');
    PORPickSORParam := FindParam('PORPickSOR');
    PadChar9Param := FindParam('PadChar9');
    BDiscountParam := FindParam('BDiscount');
    PrePostFlgParam := FindParam('PrePostFlg');
    AllocStatParam := FindParam('AllocStat');
    PadChar10Param := FindParam('PadChar10');
    SOPKeepRateParam := FindParam('SOPKeepRate');
    TimeCreateParam := FindParam('TimeCreate');
    TimeChangeParam := FindParam('TimeChange');
    CISTaxParam := FindParam('CISTax');
    CISDeclaredParam := FindParam('CISDeclared');
    CISManualTaxParam := FindParam('CISManualTax');
    CISDateParam := FindParam('CISDate');
    PadChar11Param := FindParam('PadChar11');
    TotalCost2Param := FindParam('TotalCost2');
    CISEmplParam := FindParam('CISEmpl');
    PadChar12Param := FindParam('PadChar12');
    CISGrossParam := FindParam('CISGross');
    CISHolderParam := FindParam('CISHolder');
    NOMVatIOParam := FindParam('NOMVatIO');
    AutoIncParam := FindParam('AutoInc');
    AutoIncByParam := FindParam('AutoIncBy');
    AutoEndDateParam := FindParam('AutoEndDate');
    AutoEndPrParam := FindParam('AutoEndPr');
    AutoEndYrParam := FindParam('AutoEndYr');
    AutoPostParam := FindParam('AutoPost');
    thAutoTransactionParam := FindParam('thAutoTransaction');
    PadChar13Param := FindParam('PadChar13');
    thDeliveryRunNoParam := FindParam('thDeliveryRunNo');
    thExternalParam := FindParam('thExternal');
    thSettledVATParam := FindParam('thSettledVAT');
    thVATClaimedParam := FindParam('thVATClaimed');
    thPickingRunNoParam := FindParam('thPickingRunNo');
    PadChar15Param := FindParam('PadChar15');
    thDeliveryNoteRefParam := FindParam('thDeliveryNoteRef');
    thVATCompanyRateParam := FindParam('thVATCompanyRate');
    thVATDailyRateParam := FindParam('thVATDailyRate');
    thPostCompanyRateParam := FindParam('thPostCompanyRate');
    thPostDailyRateParam := FindParam('thPostDailyRate');
    thPostDiscAmountParam := FindParam('thPostDiscAmount');
    PadChar16Param := FindParam('PadChar16');
    thPostDiscTakenParam := FindParam('thPostDiscTaken');
    thLastDebtChaseLetterParam := FindParam('thLastDebtChaseLetter');
    thRevaluationAdjustmentParam := FindParam('thRevaluationAdjustment');
    YourRefParam := FindParam('YourRef');
    SpareParam := FindParam('Spare');
    LastCharParam := FindParam('LastChar');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TLHeaderDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TLayHeadRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^, lhTKTHRecord Do
  Begin
    lhFolioNoParam.Value := lhFolioNo;                                                  // SQL=int, Delphi=Longint
    lhUserNameParam.Value := lhUserName;                                                // SQL=varchar, Delphi=string50
    lhAccountCodeParam.Value := lhAccountCode;                                          // SQL=varchar, Delphi=String10
    lhAccountNameParam.Value := lhAccountName;                                          // SQL=varchar, Delphi=String45
    lhCustomerNameParam.Value := lhCustomerName;                                        // SQL=varchar, Delphi=string25
    lhOrderNoParam.Value := lhOrderNo;                                                  // SQL=varchar, Delphi=String10
    lhAddress1Param.Value := lhAddress[1];                                              // SQL=varchar, Delphi=String[30]
    lhAddress2Param.Value := lhAddress[2];                                              // SQL=varchar, Delphi=String[30]
    lhAddress3Param.Value := lhAddress[3];                                              // SQL=varchar, Delphi=String[30]
    lhAddress4Param.Value := lhAddress[4];                                              // SQL=varchar, Delphi=String[30]
    lhAddress5Param.Value := lhAddress[5];                                              // SQL=varchar, Delphi=String[30]
    lhItemsDescParam.Value := lhItemsDesc;                                              // SQL=varchar, Delphi=String100
    lhSettDiscParam.Value := lhSettDisc;                                                // SQL=float, Delphi=Double
    lhSettDiscDaysParam.Value := lhSettDiscDays;                                        // SQL=int, Delphi=LongInt
    lhDepositToTakeParam.Value := lhDepositToTake;                                      // SQL=float, Delphi=Double
    lhDateParam.Value := lhDate;                                                        // SQL=varchar, Delphi=String8
    lhTimeParam.Value := lhTime;                                                        // SQL=varchar, Delphi=string6
    lhTillNoParam.Value := lhTillNo;                                                    // SQL=int, Delphi=LongInt
    lhValueParam.Value := lhValue;                                                      // SQL=float, Delphi=Double
    lhCostCentreParam.Value := lhCostCentre;                                            // SQL=varchar, Delphi=string20
    lhDepartmentParam.Value := lhDepartment;                                            // SQL=varchar, Delphi=string20
    lhDummyCharParam.Value := ConvertCharToSQLEmulatorVarChar(lhDummyChar);             // SQL=varchar, Delphi=Char
    RunNoParam.Value := RunNo;                                                          // SQL=int, Delphi=Longint
    CustCodeParam.Value := CustCode;                                                    // SQL=varchar, Delphi=String[6]
    OurRefParam.Value := OurRef;                                                        // SQL=varchar, Delphi=String[9]
    // *** BINARY ***
    PadChar1Param.Value := CreateVariantArray (@PadChar1, SizeOf(PadChar1));// SQL=varbinary, Delphi=Array[1..3] Of Char
    FolioNumParam.Value := FolioNum;                                                    // SQL=int, Delphi=Longint
    CurrencyParam.Value := Currency;                                                    // SQL=int, Delphi=SmallInt
    AcYrParam.Value := AcYr;                                                            // SQL=int, Delphi=SmallInt
    AcPrParam.Value := AcPr;                                                            // SQL=int, Delphi=SmallInt
    DueDateParam.Value := DueDate;                                                      // SQL=varchar, Delphi=String[8]
    TransDateParam.Value := TransDate;                                                  // SQL=varchar, Delphi=String[8]
    CoRateParam.Value := CoRate;                                                        // SQL=float, Delphi=Double
    VATRateParam.Value := VATRate;                                                      // SQL=float, Delphi=Double
    OldYourRefParam.Value := OldYourRef;                                                // SQL=varchar, Delphi=String[10]
    LongYrRefParam.Value := LongYrRef;                                                  // SQL=varchar, Delphi=String[20]
    LineCountParam.Value := LineCount;                                                  // SQL=int, Delphi=LongInt
    TransDocHedParam.Value := TransDocHed;                                              // SQL=varchar, Delphi=String[3]
    VATAnalysisStandardParam.Value := InvVatAnal[0];                                    // SQL=float, Delphi=Double
    VATAnalysisExemptParam.Value := InvVatAnal[1];                                      // SQL=float, Delphi=Double
    VATAnalysisZeroParam.Value := InvVatAnal[2];                                        // SQL=float, Delphi=Double
    VATAnalysisRate1Param.Value := InvVatAnal[3];                                       // SQL=float, Delphi=Double
    VATAnalysisRate2Param.Value := InvVatAnal[4];                                       // SQL=float, Delphi=Double
    VATAnalysisRate3Param.Value := InvVatAnal[5];                                       // SQL=float, Delphi=Double
    VATAnalysisRate4Param.Value := InvVatAnal[6];                                       // SQL=float, Delphi=Double
    VATAnalysisRate5Param.Value := InvVatAnal[7];                                       // SQL=float, Delphi=Double
    VATAnalysisRate6Param.Value := InvVatAnal[8];                                       // SQL=float, Delphi=Double
    VATAnalysisRate7Param.Value := InvVatAnal[9];                                       // SQL=float, Delphi=Double
    VATAnalysisRate8Param.Value := InvVatAnal[10];                                      // SQL=float, Delphi=Double
    VATAnalysisRate9Param.Value := InvVatAnal[11];                                      // SQL=float, Delphi=Double
    VATAnalysisRateTParam.Value := InvVatAnal[12];                                      // SQL=float, Delphi=Double
    VATAnalysisRateXParam.Value := InvVatAnal[13];                                      // SQL=float, Delphi=Double
    VATAnalysisRateBParam.Value := InvVatAnal[14];                                      // SQL=float, Delphi=Double
    VATAnalysisRateCParam.Value := InvVatAnal[15];                                      // SQL=float, Delphi=Double
    VATAnalysisRateFParam.Value := InvVatAnal[16];                                      // SQL=float, Delphi=Double
    VATAnalysisRateGParam.Value := InvVatAnal[17];                                      // SQL=float, Delphi=Double
    VATAnalysisRateRParam.Value := InvVatAnal[18];                                      // SQL=float, Delphi=Double
    VATAnalysisRateWParam.Value := InvVatAnal[19];                                      // SQL=float, Delphi=Double
    VATAnalysisRateYParam.Value := InvVatAnal[20];                                      // SQL=float, Delphi=Double
    InvNetValParam.Value := InvNetVal;                                                  // SQL=float, Delphi=Double
    InvVatParam.Value := InvVat;                                                        // SQL=float, Delphi=Double
    DiscSetlParam.Value := DiscSetl;                                                    // SQL=float, Delphi=Double
    DiscSetAmParam.Value := DiscSetAm;                                                  // SQL=float, Delphi=Double
    DiscAmountParam.Value := DiscAmount;                                                // SQL=float, Delphi=Double
    DiscDaysParam.Value := DiscDays;                                                    // SQL=int, Delphi=SmallInt
    DiscTakenParam.Value := DiscTaken;                                                  // SQL=int, Delphi=WordBool
    SettledParam.Value := Settled;                                                      // SQL=float, Delphi=Double
    TransNatParam.Value := TransNat;                                                    // SQL=int, Delphi=SmallInt
    TransModeParam.Value := TransMode;                                                  // SQL=int, Delphi=SmallInt
    HoldFlgParam.Value := HoldFlg;                                                      // SQL=int, Delphi=SmallInt
    // *** BINARY ***
    PadChar2Param.Value := CreateVariantArray (@PadChar2, SizeOf(PadChar2));// SQL=varbinary, Delphi=Array[1..2] Of Char
    TotalWeightParam.Value := TotalWeight;                                              // SQL=float, Delphi=Double
    DAddr1Param.Value := DAddr[1];                                                      // SQL=varchar, Delphi=String[30]
    DAddr2Param.Value := DAddr[2];                                                      // SQL=varchar, Delphi=String[30]
    DAddr3Param.Value := DAddr[3];                                                      // SQL=varchar, Delphi=String[30]
    DAddr4Param.Value := DAddr[4];                                                      // SQL=varchar, Delphi=String[30]
    DAddr5Param.Value := DAddr[5];                                                      // SQL=varchar, Delphi=String[30]
    PadChar3Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar3);                   // SQL=varchar, Delphi=Char
    TotalCostParam.Value := TotalCost;                                                  // SQL=float, Delphi=Double
    PrintedDocParam.Value := PrintedDoc;                                                // SQL=int, Delphi=WordBool
    ManVATParam.Value := ManVAT;                                                        // SQL=int, Delphi=WordBool
    DelTermsParam.Value := DelTerms;                                                    // SQL=varchar, Delphi=String[3]
    OpNameParam.Value := OpName;                                                        // SQL=varchar, Delphi=String[10]
    DJobCodeParam.Value := DJobCode;                                                    // SQL=varchar, Delphi=String[10]
    DJobAnalParam.Value := DJobAnal;                                                    // SQL=varchar, Delphi=String[10]
    // *** BINARY ***
    PadChar4Param.Value := CreateVariantArray (@PadChar4, SizeOf(PadChar4));// SQL=varbinary, Delphi=Array[1..3] Of Char
    TotOrdOSParam.Value := TotOrdOS;                                                    // SQL=float, Delphi=Double
    DocUser1Param.Value := DocUser1;                                                    // SQL=varchar, Delphi=String[20]
    DocUser2Param.Value := DocUser2;                                                    // SQL=varchar, Delphi=String[20]
    EmpCodeParam.Value := EmpCode;                                                      // SQL=varchar, Delphi=String[6]
    PadChar5Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar5);                   // SQL=varchar, Delphi=Char
    TaggedParam.Value := Tagged;                                                        // SQL=int, Delphi=SmallInt
    thNoLabelsParam.Value := thNoLabels;                                                // SQL=int, Delphi=SmallInt
    // *** BINARY ***
    PadChar6Param.Value := CreateVariantArray (@PadChar6, SizeOf(PadChar6));// SQL=varbinary, Delphi=Array[1..2] Of Char
    CtrlNomParam.Value := CtrlNom;                                                      // SQL=int, Delphi=LongInt
    DocUser3Param.Value := DocUser3;                                                    // SQL=varchar, Delphi=String[30]
    DocUser4Param.Value := DocUser4;                                                    // SQL=varchar, Delphi=String[30]
    SSDProcessParam.Value := ConvertCharToSQLEmulatorVarChar(SSDProcess);               // SQL=varchar, Delphi=Char
    PadChar7Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar7);                   // SQL=varchar, Delphi=Char
    ExtSourceParam.Value := ExtSource;                                                  // SQL=int, Delphi=SmallInt
    PostDateParam.Value := PostDate;                                                    // SQL=varchar, Delphi=String[8]
    PadChar8Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar8);                   // SQL=varchar, Delphi=Char
    PORPickSORParam.Value := PORPickSOR;                                                // SQL=int, Delphi=WordBool
    // *** BINARY ***
    PadChar9Param.Value := CreateVariantArray (@PadChar9, SizeOf(PadChar9));// SQL=varbinary, Delphi=Array[1..2] of Char
    BDiscountParam.Value := BDiscount;                                                  // SQL=float, Delphi=Double
    PrePostFlgParam.Value := PrePostFlg;                                                // SQL=int, Delphi=SmallInt
    AllocStatParam.Value := ConvertCharToSQLEmulatorVarChar(AllocStat);                 // SQL=varchar, Delphi=Char
    PadChar10Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar10);                 // SQL=varchar, Delphi=Char
    SOPKeepRateParam.Value := SOPKeepRate;                                              // SQL=int, Delphi=WordBool
    TimeCreateParam.Value := TimeCreate;                                                // SQL=varchar, Delphi=String[6]
    TimeChangeParam.Value := TimeChange;                                                // SQL=varchar, Delphi=String[6]
    CISTaxParam.Value := CISTax;                                                        // SQL=float, Delphi=Double
    CISDeclaredParam.Value := CISDeclared;                                              // SQL=float, Delphi=Double
    CISManualTaxParam.Value := CISManualTax;                                            // SQL=bit, Delphi=Boolean
    CISDateParam.Value := CISDate;                                                      // SQL=varchar, Delphi=String[8]
    // *** BINARY ***
    PadChar11Param.Value := CreateVariantArray (@PadChar11, SizeOf(PadChar11));// SQL=varbinary, Delphi=Array[1..2] of Char
    TotalCost2Param.Value := TotalCost2;                                                // SQL=float, Delphi=Double
    CISEmplParam.Value := CISEmpl;                                                      // SQL=varchar, Delphi=String[10]
    PadChar12Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar12);                 // SQL=varchar, Delphi=Char
    CISGrossParam.Value := CISGross;                                                    // SQL=float, Delphi=Double
    CISHolderParam.Value := CISHolder;                                                  // SQL=int, Delphi=Byte
    NOMVatIOParam.Value := ConvertCharToSQLEmulatorVarChar(NOMVatIO);                   // SQL=varchar, Delphi=Char
    AutoIncParam.Value := AutoInc;                                                      // SQL=int, Delphi=SmallInt
    AutoIncByParam.Value := ConvertCharToSQLEmulatorVarChar(AutoIncBy);                 // SQL=varchar, Delphi=Char
    AutoEndDateParam.Value := AutoEndDate;                                              // SQL=varchar, Delphi=String[8]
    AutoEndPrParam.Value := AutoEndPr;                                                  // SQL=int, Delphi=SmallInt
    AutoEndYrParam.Value := AutoEndYr;                                                  // SQL=int, Delphi=SmallInt
    AutoPostParam.Value := AutoPost;                                                    // SQL=int, Delphi=WordBool
    thAutoTransactionParam.Value := thAutoTransaction;                                  // SQL=int, Delphi=WordBool
    // *** BINARY ***
    PadChar13Param.Value := CreateVariantArray (@PadChar13, SizeOf(PadChar13));// SQL=varbinary, Delphi=Array[1..3] of Char
    thDeliveryRunNoParam.Value := thDeliveryRunNo;                                      // SQL=varchar, Delphi=String[12]
    thExternalParam.Value := thExternal;                                                // SQL=int, Delphi=WordBool
    thSettledVATParam.Value := thSettledVAT;                                            // SQL=float, Delphi=Double
    thVATClaimedParam.Value := thVATClaimed;                                            // SQL=float, Delphi=Double
    thPickingRunNoParam.Value := thPickingRunNo;                                        // SQL=int, Delphi=longint
    // *** BINARY ***
    PadChar15Param.Value := CreateVariantArray (@PadChar15, SizeOf(PadChar15));// SQL=varbinary, Delphi=Array[1..5] of Char
    thDeliveryNoteRefParam.Value := thDeliveryNoteRef;                                  // SQL=varchar, Delphi=String[10]
    thVATCompanyRateParam.Value := thVATCompanyRate;                                    // SQL=float, Delphi=Double
    thVATDailyRateParam.Value := thVATDailyRate;                                        // SQL=float, Delphi=Double
    thPostCompanyRateParam.Value := thPostCompanyRate;                                  // SQL=float, Delphi=Double
    thPostDailyRateParam.Value := thPostDailyRate;                                      // SQL=float, Delphi=Double
    thPostDiscAmountParam.Value := thPostDiscAmount;                                    // SQL=float, Delphi=Double
    // *** BINARY ***
    PadChar16Param.Value := CreateVariantArray (@PadChar16, SizeOf(PadChar16));// SQL=varbinary, Delphi=Array[1..2] of Char
    thPostDiscTakenParam.Value := thPostDiscTaken;                                      // SQL=int, Delphi=WordBool
    thLastDebtChaseLetterParam.Value := thLastDebtChaseLetter;                          // SQL=int, Delphi=longint
    thRevaluationAdjustmentParam.Value := thRevaluationAdjustment;                      // SQL=float, Delphi=Double
    YourRefParam.Value := YourRef;                                                      // SQL=varchar, Delphi=String[20]
    SpareParam.Value := CreateVariantArray (@PadChar17, 256);
    LastCharParam.Value := ConvertCharToSQLEmulatorVarChar(LastChar);
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

