unit oAppView;

interface
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarCnst3, oBtrieve, MiscFunc,
     oAddr, oNotes, oViews, oViewLns;

type

  TTransactionAsApplication = class(TTransactionView, ITransactionAsApplication)
  protected
    function Get_tpFolioNum: Integer; safecall;
    function Get_tpJobCode: WideString; safecall;
    procedure Set_tpJobCode(const Value: WideString); safecall;
    function Get_tpAcCode: WideString; safecall;
    procedure Set_tpAcCode(const Value: WideString); safecall;
    function Get_tpRunNo: Integer; safecall;
    function Get_tpEmployeeCode: WideString; safecall;
    procedure Set_tpEmployeeCode(const Value: WideString); safecall;
    function Get_tpParentTerms: WideString; safecall;
    procedure Set_tpParentTerms(const Value: WideString); safecall;
    function Get_tpTermsInterimFlag: TTermsInterimType; safecall;
    procedure Set_tpTermsInterimFlag(Value: TTermsInterimType); safecall;
    function Get_tpAppsInterimFlag: TAppsInterimType; safecall;
    procedure Set_tpAppsInterimFlag(Value: TAppsInterimType); safecall;
    function Get_tpInterimStatus: Integer; safecall;
    procedure Set_tpInterimStatus(Value: Integer); safecall;
    function Get_tpPeriod: Integer; safecall;
    procedure Set_tpPeriod(Value: Integer); safecall;
    function Get_tpYear: Integer; safecall;
    procedure Set_tpYear(Value: Integer); safecall;
    function Get_tpCurrency: Integer; safecall;
    procedure Set_tpCurrency(Value: Integer); safecall;
    function Get_tpDailyRate: Double; safecall;
    procedure Set_tpDailyRate(Value: Double); safecall;
    function Get_tpCompanyRate: Double; safecall;
    procedure Set_tpCompanyRate(Value: Double); safecall;
    function Get_tpOurRef: WideString; safecall;
    procedure Set_tpOurRef(const Value: WideString); safecall;
    function Get_tpYourRef: WideString; safecall;
    procedure Set_tpYourRef(const Value: WideString); safecall;
    function Get_tpTotalCertYTD: Double; safecall;
    function Get_tpApplied: Double; safecall;
    function Get_tpTotalBudget: Double; safecall;
    function Get_tpTotalDeduct: Double; safecall;
    function Get_tpTotalRetain: Double; safecall;
    function Get_tpTotalDeductYTD: Double; safecall;
    function Get_tpTotalRetainYTD: Double; safecall;
    function Get_tpTotalAppliedYTD: Double; safecall;
    function Get_tpTotalContra: Double; safecall;
    function Get_tpCertifiedValue: Double; safecall;
    function Get_tpATR: WordBool; safecall;
    procedure Set_tpATR(Value: WordBool); safecall;
    function Get_tpDeferVAT: WordBool; safecall;
    procedure Set_tpDeferVAT(Value: WordBool); safecall;
    function Get_tpCertified: WordBool; safecall;
    procedure Set_tpCertified(Value: WordBool); safecall;
    function Get_tpDate: WideString; safecall;
    procedure Set_tpDate(const Value: WideString); safecall;
    function Get_tpDeliveryAddress: IAddress; safecall;
    function Get_tpTotalVAT: Double; safecall;
    function Get_tpVATAnalysis(const Index: WideString): Double; safecall;
    function Get_tpManualVAT: WordBool; safecall;
    procedure Set_tpManualVAT(Value: WordBool); safecall;
    function Get_tpVATCode: WideString; safecall;
    function Get_tpCISTaxDue: Double; safecall;
    procedure Set_tpCISTaxDue(Value: Double); safecall;
    function Get_tpCISTaxDeclared: Double; safecall;
    function Get_tpCISManualTax: WordBool; safecall;
    procedure Set_tpCISManualTax(Value: WordBool); safecall;
    function Get_tpCISDate: WideString; safecall;
    procedure Set_tpCISDate(const Value: WideString); safecall;
    function Get_tpCISTotalGross: Double; safecall;
    procedure Set_tpCISTotalGross(Value: Double); safecall;
    function Get_tpCISSource: Integer; safecall;
    function  Get_tpDeductionLines: ITransactionLines; safecall;
    function  Get_tpRetentionLines: ITransactionLines; safecall;
    function Get_tpUserField1: WideString; safecall;
    procedure Set_tpUserField1(const Value: WideString); safecall;
    function Get_tpUserField2: WideString; safecall;
    procedure Set_tpUserField2(const Value: WideString); safecall;
    function Get_tpUserField3: WideString; safecall;
    procedure Set_tpUserField3(const Value: WideString); safecall;
    function Get_tpUserfield4: WideString; safecall;
    procedure Set_tpUserfield4(const Value: WideString); safecall;
    function Get_tpTermsStage: TAppsInterimType; safecall;
    function Get_tpApplicationBasis: TTermsInterimType; safecall;

  public
    Trans2 : TObject;
  end;

  TTransactionLineAsApplication = Class(TTransactionViewLine, ITransactionLineAsApplication)
  protected
    function Get_tplFolioNum: Integer; safecall;
    function Get_tplJobCode: WideString; safecall;
    procedure Set_tplJobCode(const Value: WideString); safecall;
    function Get_tplAnalysisCode: WideString; safecall;
    procedure Set_tplAnalysisCode(const Value: WideString); safecall;
    function Get_tplDescr: WideString; safecall;
    procedure Set_tplDescr(const Value: WideString); safecall;
    function Get_tplAcCode: WideString; safecall;
    procedure Set_tplAcCode(const Value: WideString); safecall;
    function Get_tplQty: Double; safecall;
    procedure Set_tplQty(Value: Double); safecall;
    function Get_tplBudgetJCT: Double; safecall;
    procedure Set_tplBudgetJCT(Value: Double); safecall;
    function Get_tplApplied: Double; safecall;
    procedure Set_tplApplied(Value: Double); safecall;
    function Get_tplAppliedYTD: Double; safecall;
    procedure Set_tplAppliedYTD(Value: Double); safecall;
    function Get_tplCertifiedAmount: Double; safecall;
    procedure Set_tplCertifiedAmount(Value: Double); safecall;
    function Get_tplCertifiedYTD: Double; safecall;
    procedure Set_tplCertifiedYTD(Value: Double); safecall;
    function Get_tplPaid: Double; safecall;
    procedure Set_tplPaid(Value: Double); safecall;
    function Get_tplVATCode: WideString; safecall;
    procedure Set_tplVATCode(const Value: WideString); safecall;
    function Get_tplCostCentre: WideString; safecall;
    procedure Set_tplCostCentre(const Value: WideString); safecall;
    function Get_tplDepartment: WideString; safecall;
    procedure Set_tplDepartment(const Value: WideString); safecall;
    function Get_tplRetention: Double; safecall;
    procedure Set_tplRetention(Value: Double); safecall;
    function Get_tplLineMode: TLineModeType; safecall;

    function Get_tplLineType: TTransactionLineType; safecall;
    procedure Set_tplLineType(Value: TTransactionLineType); safecall;
    function Get_tplRetentionExpiry: Smallint; safecall;
    procedure Set_tplRetentionExpiry(Value: Smallint); safecall;
    function Get_tplRetentionExpiryBasis: Smallint; safecall;
    procedure Set_tplRetentionExpiryBasis(Value: Smallint); safecall;
    function Get_tplRetentionType: TRetentionType; safecall;
    procedure Set_tplRetentionType(Value: TRetentionType); safecall;
    function Get_tplOverrideValue: WordBool; safecall;
    procedure Set_tplOverrideValue(Value: WordBool); safecall;
    function Get_tplCalculateBeforeRetention: WordBool; safecall;
    procedure Set_tplCalculateBeforeRetention(Value: WordBool); safecall;
    function Get_tplDeductionAppliesTo: TDeductionApplyToType; safecall;
    procedure Set_tplDeductionAppliesTo(Value: TDeductionApplyToType); safecall;
    function Get_tplDeductionType: TDeductionType; safecall;
    procedure Set_tplDeductionType(Value: TDeductionType); safecall;
    function Get_tplDeductValue: Double; safecall;
    procedure Set_tplDeductValue(Value: Double); safecall;
    function Get_tplDeductionCertifiedAmount: Double; safecall;
    function Get_tplCertified: WordBool; safecall;
    function Get_tplTermsLink: Integer; safecall;
    function Get_tplTermsLineNo: Integer; safecall;
    procedure Set_tplTermsLineNo(Value: Integer); safecall;
    function GetParentBudget : Double;
  end;

implementation

uses
  oTrans, BtKeys1U, BtSupU1;

const
  atTerms = 0;
  atApp   = 1;


{ TTransactionAsApplication }

function AppType(Dtype : TDocTypes) : Byte;
begin
  if DType in [dtJPA, dtJSA] then
    Result := atApp
  else
  if DType in [dtJPT, dtJCT, dtJST] then
    Result := atTerms
  else
    Result := 255;

end;

function TTransactionAsApplication.Get_tpAcCode: WideString;
begin
  Result := ITransaction(FTransactionI).thAcCode;
end;

function TTransactionAsApplication.Get_tpCertified: WordBool;
begin
  Result := FTrans^.thPostDiscTaken;
end;

function TTransactionAsApplication.Get_tpApplied: Double;
begin
  Result := FTrans^.TotalInvoiced;
end;

function TTransactionAsApplication.Get_tpAppsInterimFlag: TAppsInterimType;
begin
  if AppType(ITransaction(FTransactionI).thDocType) = atApp then
    Case FTrans^.TransMode of
      0  :  Result := aifStandAlone;
      1  :  Result := aifInterim;
      2  :  Result := aifPractical;
      3  :  Result := aifFinal;
    end
  else
    raise Exception.Create('Property tpAppsInterimFlag not available on this object');
end;

function TTransactionAsApplication.Get_tpATR: WordBool;
begin
  Result := FTrans^.thOnPickRun;
end;

function TTransactionAsApplication.Get_tpCertifiedValue: Double;
begin
  Result := FTrans^.InvNetVal;
end;

function TTransactionAsApplication.Get_tpCISDate: WideString;
begin
  Result := FTrans.CISDate;
end;

function TTransactionAsApplication.Get_tpCISManualTax: WordBool;
begin
  Result := FTrans^.CISManualTax;
end;

function TTransactionAsApplication.Get_tpCISSource: Integer;
begin
  Result := FTrans^.CISHolder;
end;

function TTransactionAsApplication.Get_tpCISTaxDeclared: Double;
begin
  Result := FTrans^.CISDeclared;
end;

function TTransactionAsApplication.Get_tpCISTaxDue: Double;
begin
  Result := FTrans^.CISTax;
end;

function TTransactionAsApplication.Get_tpCISTotalGross: Double;
begin
  Result := FTrans^.CISGross;
end;

function TTransactionAsApplication.Get_tpCompanyRate: Double;
begin
  Result := ITransaction(FTransactionI).thCompanyRate;
end;

function TTransactionAsApplication.Get_tpCurrency: Integer;
begin
  Result := ITransaction(FTransactionI).thCurrency;
end;

function TTransactionAsApplication.Get_tpDailyRate: Double;
begin
  Result := ITransaction(FTransactionI).thDailyRate;
end;

function TTransactionAsApplication.Get_tpDate: WideString;
begin
  Result := ITransaction(FTransactionI).thTransDate;
end;

function TTransactionAsApplication.Get_tpDeferVAT: WordBool;
begin
  Result := FTrans^.AutoPost;
end;

function TTransactionAsApplication.Get_tpDeliveryAddress: IAddress;
begin
  Result := ITransaction(FTransactionI).thDelAddress;
end;

function TTransactionAsApplication.Get_tpEmployeeCode: WideString;
begin
  Result := FTrans.CISEmpl;
end;

function TTransactionAsApplication.Get_tpFolioNum: Integer;
begin
  Result := ITransaction(FTransactionI).thFolioNum;
end;

function TTransactionAsApplication.Get_tpInterimStatus: Integer;
begin
  Result := FTrans.TransNat;
end;

function TTransactionAsApplication.Get_tpJobCode: WideString;
begin
  Result := ITransaction(FTransactionI).thJobCode;
end;

function TTransactionAsApplication.Get_tpManualVAT: WordBool;
begin
  Result := ITransaction(FTransactionI).thManualVAT;
end;

function TTransactionAsApplication.Get_tpOurRef: WideString;
begin
  Result := ITransaction(FTransactionI).thOurRef;
end;

function TTransactionAsApplication.Get_tpParentTerms: WideString;
begin
  Result := FTrans.thDeliveryNoteRef;
end;

function TTransactionAsApplication.Get_tpPeriod: Integer;
begin
  Result := ITransaction(FTransactionI).thPeriod;
end;

function TTransactionAsApplication.Get_tpRunNo: Integer;
begin
  Result := ITransaction(FTransactionI).thRunNo;
end;

function TTransactionAsApplication.Get_tpTermsInterimFlag: TTermsInterimType;
begin
  if AppType(ITransaction(FTransactionI).thDocType) = atTerms then
    Case FTrans^.TransMode of
      0  :  Result := tifIncremental;
      1  :  Result := tifGrossIncremental;
      2  :  Result := tifGross;
    end
  else
    raise Exception.Create('Property tpTermsInterimFlag not available on this object');
end;

function TTransactionAsApplication.Get_tpTotalAppliedYTD: Double;
begin
  Result := FTrans^.thTotalReserved;
end;

function TTransactionAsApplication.Get_tpTotalBudget: Double;
begin
  Result := FTrans^.TotalCost;
end;

function TTransactionAsApplication.Get_tpTotalCertYTD: Double;
begin
  Result := FTrans^.thTotalOrdered;
end;

function TTransactionAsApplication.Get_tpTotalContra: Double;
begin
  Result := FTrans^.BDiscount;
end;

function TTransactionAsApplication.Get_tpTotalDeduct: Double;
begin
  Result := FTrans^.DiscAmount;
end;

function TTransactionAsApplication.Get_tpTotalDeductYTD: Double;
begin
  Result := FTrans^.thPostDiscAmount;
end;

function TTransactionAsApplication.Get_tpTotalRetain: Double;
begin
  Result := FTrans^.DiscSetAm;
end;

function TTransactionAsApplication.Get_tpTotalRetainYTD: Double;
begin
  Result := FTrans^.TotOrdOS;
end;

function TTransactionAsApplication.Get_tpTotalVAT: Double;
begin
  Result := ITransaction(FTransactionI).thTotalVAT;
end;

function TTransactionAsApplication.Get_tpVATAnalysis(
  const Index: WideString): Double;
begin
  Result := ITransaction(FTransactionI).thVATAnalysis[Index];
end;

function TTransactionAsApplication.Get_tpVATCode: WideString;
begin
//  Result := ITransaction(FTransactionI).th
end;

function TTransactionAsApplication.Get_tpYear: Integer;
begin
  Result := ITransaction(FTransactionI).thYear;
end;

function TTransactionAsApplication.Get_tpYourRef: WideString;
begin
  Result := ITransaction(FTransactionI).thYourRef;
end;

procedure TTransactionAsApplication.Set_tpAcCode(const Value: WideString);
begin
  ITransaction(FTransactionI).thAcCode := Value;
end;

procedure TTransactionAsApplication.Set_tpCertified(Value: WordBool);
begin
  FTrans^.thPostDiscTaken := Value;
end;


procedure TTransactionAsApplication.Set_tpAppsInterimFlag(
  Value: TAppsInterimType);
begin
  Case Value of
    aifStandAlone : FTrans^.TransMode := 0;
    aifInterim    : FTrans^.TransMode := 1;
    aifPractical  : FTrans^.TransMode := 2;
    aifFinal      : FTrans^.TransMode := 3;
    else
      raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
  end;
end;

procedure TTransactionAsApplication.Set_tpATR(Value: WordBool);
begin
  FTrans^.thOnPickRun := Value;
end;


procedure TTransactionAsApplication.Set_tpCISDate(const Value: WideString);
begin
  FTrans.CISDate := Value;
end;

procedure TTransactionAsApplication.Set_tpCISManualTax(Value: WordBool);
begin
  FTrans^.CISManualTax := Value;
end;

procedure TTransactionAsApplication.Set_tpCISTaxDue(Value: Double);
begin
  FTrans^.CISTax := Value;
end;

procedure TTransactionAsApplication.Set_tpCISTotalGross(Value: Double);
begin
  FTrans.CISGross := Value;
end;

procedure TTransactionAsApplication.Set_tpCompanyRate(Value: Double);
begin
  ITransaction(FTransactionI).thCompanyRate := Value;
end;

procedure TTransactionAsApplication.Set_tpCurrency(Value: Integer);
begin
  ITransaction(FTransactionI).thCurrency := Value;
end;

procedure TTransactionAsApplication.Set_tpDailyRate(Value: Double);
begin
  ITransaction(FTransactionI).thDailyRate := Value;
end;

procedure TTransactionAsApplication.Set_tpDate(const Value: WideString);
begin
  ITransaction(FTransactionI).thTransDate := Value;
end;

procedure TTransactionAsApplication.Set_tpDeferVAT(Value: WordBool);
begin
  FTrans.AutoPost := Value;
end;


procedure TTransactionAsApplication.Set_tpEmployeeCode(
  const Value: WideString);
begin
  FTrans.CISEmpl := Value;
end;

procedure TTransactionAsApplication.Set_tpInterimStatus(Value: Integer);
begin
  FTrans.TransNat := Value;
end;

procedure TTransactionAsApplication.Set_tpJobCode(const Value: WideString);
begin
  ITransaction(FTransactionI).thJobCode := Value;
end;

procedure TTransactionAsApplication.Set_tpManualVAT(Value: WordBool);
begin
  ITransaction(FTransactionI).thManualVAT := Value;
end;

procedure TTransactionAsApplication.Set_tpOurRef(const Value: WideString);
begin
  ITransaction(FTransactionI).thOurRef := Value;
end;

procedure TTransactionAsApplication.Set_tpParentTerms(
  const Value: WideString);
begin
  FTrans.thDeliveryNoteRef := Value;
end;

procedure TTransactionAsApplication.Set_tpPeriod(Value: Integer);
begin
  ITransaction(FTransactionI).thPeriod := Value;
end;

procedure TTransactionAsApplication.Set_tpTermsInterimFlag(
  Value: TTermsInterimType);
begin
  if AppType(ITransaction(FTransactionI).thDocType) = atTerms then
    Case Value of
      tifIncremental      : FTrans^.TransMode := 0;
      tifGrossIncremental : FTrans^.TransMode := 1;
      tifGross            : FTrans^.TransMode := 2;
      else
        raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
    end
  else
    raise Exception.Create('Property tpTermsInterimFlag not available on this object');
end;


procedure TTransactionAsApplication.Set_tpYear(Value: Integer);
begin
   ITransaction(FTransactionI).thYear := Value;
end;

procedure TTransactionAsApplication.Set_tpYourRef(const Value: WideString);
begin
  ITransaction(FTransactionI).thYourRef := Value;
end;

function  TTransactionAsApplication.Get_tpDeductionLines: ITransactionLines;
begin
  Result := TTransaction2(Trans2).GetDeductionLines;
end;

function  TTransactionAsApplication.Get_tpRetentionLines: ITransactionLines;
begin
  Result := TTransaction2(Trans2).GetRetentionLines;
end;

function TTransactionAsApplication.Get_tpUserField1: WideString;
begin
  Result := ITransaction(FTransactionI).thUserField1;
end;

procedure TTransactionAsApplication.Set_tpUserField1(const Value: WideString);
begin
  ITransaction(FTransactionI).thUserField1 := Value;
end;

function TTransactionAsApplication.Get_tpUserField2: WideString;
begin
  Result := ITransaction(FTransactionI).thUserField2;
end;

procedure TTransactionAsApplication.Set_tpUserField2(const Value: WideString);
begin
  ITransaction(FTransactionI).thUserField2 := Value;
end;

function TTransactionAsApplication.Get_tpUserField3: WideString;
begin
  Result := ITransaction(FTransactionI).thUserField3;
end;

procedure TTransactionAsApplication.Set_tpUserField3(const Value: WideString);
begin
  ITransaction(FTransactionI).thUserField3 := Value;
end;

function TTransactionAsApplication.Get_tpUserfield4: WideString;
begin
  Result := ITransaction(FTransactionI).thUserField4;
end;

procedure TTransactionAsApplication.Set_tpUserfield4(const Value: WideString);
begin
  ITransaction(FTransactionI).thUserField4 := Value;
end;

function TTransactionAsApplication.Get_tpTermsStage: TAppsInterimType;
begin
  if ITransaction(FTransactionI).thDocType in [dtJCT, dtJST] then
    Case FTrans^.TransNat of
      0  :  Result := aifStandAlone;
      1  :  Result := aifInterim;
      2  :  Result := aifPractical;
      3  :  Result := aifFinal;
    end
  else
    raise Exception.Create('Property tpTermsStage not available on this object');
end;

function TTransactionAsApplication.Get_tpApplicationBasis: TTermsInterimType;
begin
  if AppType(ITransaction(FTransactionI).thDocType) <> atTerms then
    Case FTrans^.TransNat of
      0  :  Result := tifIncremental;
      1  :  Result := tifGrossIncremental;
      2  :  Result := tifGross;
    end
  else
    raise Exception.Create('Property tpApplicationBasis not available on this object');

end;



{================================================================================================}
{ TTransactionLineAsApplication }

function TTransactionLineAsApplication.Get_tplTermsLink: Integer;
begin
  Result := ITransactionLine(FTransactionLine).tlSOPFolioNum;
end;

function TTransactionLineAsApplication.Get_tplTermsLineNo: Integer;
begin
  Result := ITransactionLine(FTransactionLine).tlSOPABSLineNo;
end;

procedure TTransactionLineAsApplication.Set_tplTermsLineNo(Value: Integer);
begin
  ITransactionLine(FTransactionLine).tlSOPABSLineNo := Value;
end;

function TTransactionLineAsApplication.Get_tplAcCode: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlAcCode;
end;

function TTransactionLineAsApplication.Get_tplCertified: WordBool;
begin
  Result := ITransactionLine(FTransactionLine).tlSSDUseLineValues;
end;

function TTransactionLineAsApplication.Get_tplAnalysisCode: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlAnalysisCode;
end;

function TTransactionLineAsApplication.Get_tplApplied: Double;
begin
  if (FTHLine.DocHed = 'JPA') or
     (FTHLine.DocHed = 'JSA') then
    Result := ITransactionLine(FTransactionLine).tlCost
  else
    raise Exception.Create('property tplApplied is not available in this object');
end;

function TTransactionLineAsApplication.Get_tplAppliedYTD: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlQtyDel;
end;

function TTransactionLineAsApplication.Get_tplBudgetJCT: Double;
begin
  if (FTHLine.DocHed = 'JCT') or
     (FTHLine.DocHed = 'JPT') or
     (FTHLine.DocHed = 'JST') then
    Result := ITransactionLine(FTransactionLine).tlCost
  else
    Result := GetParentBudget;
end;

function TTransactionLineAsApplication.Get_tplCalculateBeforeRetention: WordBool;
begin
  Result := FTHLine.tlUseCase;
end;

function TTransactionLineAsApplication.Get_tplCertifiedAmount: Double;
begin
  if (FTHLine.DocHed = 'JPA') or
     (FTHLine.DocHed = 'JSA') then
    Result := ITransactionLine(FTransactionLine).tlNetValue
  else
    raise Exception.Create('property tplCertifiedAmount is not available in this object');
end;

function TTransactionLineAsApplication.Get_tplDeductionCertifiedAmount: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlSSDUpliftPerc;
end;

function TTransactionLineAsApplication.Get_tplCertifiedYTD: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlQtyPickedWO;
end;

function TTransactionLineAsApplication.Get_tplCostCentre: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlCostCentre;
end;

function TTransactionLineAsApplication.Get_tplDeductionAppliesTo: TDeductionApplyToType;
begin
  Result := ITransactionLine(FTransactionLine).tlBOMKitLink;
end;

function TTransactionLineAsApplication.Get_tplDeductionType: TDeductionType;
begin
  Result := FTHLine.tlDeductType;
end;

function TTransactionLineAsApplication.Get_tplDepartment: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlDepartment;
end;

function TTransactionLineAsApplication.Get_tplDescr: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlDescr;
end;

function TTransactionLineAsApplication.Get_tplFolioNum: Integer;
begin
  Result := ITransactionLine(FTransactionLine).tlFolioNum;
end;

function TTransactionLineAsApplication.Get_tplJobCode: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlJobCode;
end;

procedure TTransactionLineAsApplication.Set_tplJobCode(const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlJobCode := Value;
end;

function TTransactionLineAsApplication.Get_tplLineMode: TLineModeType;
begin
  Result := ITransactionLine(FTransactionLine).tlRecStatus;
end;

function TTransactionLineAsApplication.Get_tplLineType: TTransactionLineType;
begin
  Result := ITransactionLine(FTransactionLine).tlLineType;
end;

function TTransactionLineAsApplication.Get_tplOverrideValue: WordBool;
begin
  Result := FTHLine.tlLiveUplift;
end;

function TTransactionLineAsApplication.Get_tplPaid: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlQtyWOFF;
end;

function TTransactionLineAsApplication.Get_tplQty: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlQty;
end;

function TTransactionLineAsApplication.Get_tplRetention: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlDiscount;
end;

function TTransactionLineAsApplication.Get_tplRetentionExpiryBasis: Smallint;
begin
  Result := Trunc(ITransactionLine(FTransactionLine).tlSSDSalesUnit);
end;

function TTransactionLineAsApplication.Get_tplRetentionType: TRetentionType;
begin
  Result := FTHLine.tlCOSNomCode;
end;

function TTransactionLineAsApplication.Get_tplRetentionExpiry: Smallint;
begin
    Result := FTHLine.tlOldSerialQty;
end;

function TTransactionLineAsApplication.Get_tplDeductValue: Double;
begin
  Result := ITransactionLine(FTransactionLine).tlNetValue;
end;

function TTransactionLineAsApplication.Get_tplVATCode: WideString;
begin
  Result := ITransactionLine(FTransactionLine).tlVATCode;
end;


procedure TTransactionLineAsApplication.Set_tplAcCode(
  const Value: WideString);
begin
end;

procedure TTransactionLineAsApplication.Set_tplAnalysisCode(
  const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlAnalysisCode := Value;
end;

procedure TTransactionLineAsApplication.Set_tplApplied(Value: Double);
begin
  if (FTHLine.DocHed = 'JPA') or
     (FTHLine.DocHed = 'JSA') then
    ITransactionLine(FTransactionLine).tlCost := Value
  else
    Raise Exception.Create('Property tplApplied is not available in this object');
end;

procedure TTransactionLineAsApplication.Set_tplAppliedYTD(Value: Double);
begin
  ITransactionLine(FTransactionLine).tlQtyDel := Value;
end;

procedure TTransactionLineAsApplication.Set_tplCertifiedYTD(Value: Double);
begin
  ITransactionLine(FTransactionLine).tlQtyPickedWO := Value;
end;

procedure TTransactionLineAsApplication.Set_tplBudgetJCT(Value: Double);
begin
  if (FTHLine.DocHed = 'JCT') or
     (FTHLine.DocHed = 'JPT') or
     (FTHLine.DocHed = 'JST') then
    ITransactionLine(FTransactionLine).tlCost := Value
  else
    Raise Exception.Create('Property tplBudgetJCT is read-only in this object');
end;

procedure TTransactionLineAsApplication.Set_tplCalculateBeforeRetention(
  Value: WordBool);
begin
  FTHLine.tlUseCase := Value;
end;

procedure TTransactionLineAsApplication.Set_tplCertifiedAmount(Value: Double);
begin
  if (FTHLine.DocHed = 'JPA') or
     (FTHLine.DocHed = 'JSA') then
    ITransactionLine(FTransactionLine).tlNetValue := Value
  else
    Raise Exception.Create('Property tplCertifiedAmount is not available in this object');
end;

procedure TTransactionLineAsApplication.Set_tplCostCentre(
  const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlCostCentre := Value;
end;

procedure TTransactionLineAsApplication.Set_tplDeductionAppliesTo(
  Value: TDeductionApplyToType);
begin
  if Value in [datAll..datOverheads] then
    ITransactionLine(FTransactionLine).tlBOMKitLink := Value
  else
    raise ERangeError.Create('Value out of range (' + IntToStr(Value) + ')');
end;

procedure TTransactionLineAsApplication.Set_tplDeductionType(
  Value: TDeductionType);
begin
  FTHLine.tlDeductType := Value;
end;

procedure TTransactionLineAsApplication.Set_tplDepartment(const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlDepartment := Value;
end;

procedure TTransactionLineAsApplication.Set_tplDescr(
  const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlDescr := Value;
end;

procedure TTransactionLineAsApplication.Set_tplLineType(
  Value: TTransactionLineType);
begin
  ITransactionLine(FTransactionLine).tlLineType := Value;
end;

procedure TTransactionLineAsApplication.Set_tplOverrideValue(
  Value: WordBool);
begin
  FTHLine.tlLiveUplift := Value;
end;

procedure TTransactionLineAsApplication.Set_tplPaid(Value: Double);
begin
  ITransactionLine(FTransactionLine).tlQtyWOFF := Value;
end;

procedure TTransactionLineAsApplication.Set_tplQty(Value: Double);
begin
 ITransactionLine(FTransactionLine).tlQty := Value;
end;

procedure TTransactionLineAsApplication.Set_tplRetention(Value: Double);
begin
  ITransactionLine(FTransactionLine).tlDiscount := Value;
end;

procedure TTransactionLineAsApplication.Set_tplRetentionExpiryBasis(
  Value: Smallint);
begin
  ITransactionLine(FTransactionLine).tlSSDSalesUnit := Value;
end;

procedure TTransactionLineAsApplication.Set_tplRetentionType(
  Value: TRetentionType);
begin
  FTHLine.tlCOSNomCode := Value;
end;

procedure TTransactionLineAsApplication.Set_tplRetentionExpiry(
  Value: Smallint);
begin
    FTHLine.tlOldSerialQty := Value;
end;

procedure TTransactionLineAsApplication.Set_tplDeductValue(Value: Double);
begin
  ITransactionLine(FTransactionLine).tlNetValue := Value;
  FTHLine.tlLiveUplift :=  True;
end;

procedure TTransactionLineAsApplication.Set_tplVATCode(
  const Value: WideString);
begin
  ITransactionLine(FTransactionLine).tlVATCode := Value;
end;

function TTransactionLineAsApplication.GetParentBudget : Double;
var
  KeyS : Str255;
  TmpID : IDetail;
begin
  KeyS:=FullidKey(Get_tplTermsLink,Get_tplTermsLineNo);

  TmpId := ID;
  if CheckRecExsists(KeyS, IDetailF, IdLinkK) then
    Result := ID.CostPrice
  else
    Result := 0;
  ID := TmpId;

end;


end.
