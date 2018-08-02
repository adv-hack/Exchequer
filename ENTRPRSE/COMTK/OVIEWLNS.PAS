unit oViewLns;

interface
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     GlobVar, VarConst, VarCnst3, oBtrieve, MiscFunc,
     oCust, oAddr, oNotes, ExBtTH1U, oMatch, ExceptIntf;

type

  TTransactionViewLine = Class(TAutoIntfObjectEx)
  protected
    FTransactionLine : ITransactionLine;
    FToolkit : Pointer;
    FIntfType    : TInterfaceMode;
    FTHLine : ^TBatchTLRec;
  public
    constructor Create(const TransLine : ITransactionLine; const Toolkit : Pointer;
                       const DispIntf : TGUID; Mode : TInterfaceMode = imGeneral;
                       THLine : Pointer = nil);
    Destructor Destroy; override;
  end;
  //PL 26/10/2016	ABSEXCH-14172 added PayInRef to ITransactionLineAsNOM as a descendant ITransactionLineAsNOM3
  TTransactionLineAsNOM = Class(TTransactionViewLine, ITransactionLineAsNOM, ITransactionLineAsNOM2, ITransactionLineAsNOM3)
  protected
    function Get_tlnDescription: WideString; safecall;
    procedure Set_tlnDescription(const Value: WideString); safecall;
    function Get_tlnGLCode: Integer; safecall;
    procedure Set_tlnGLCode(Value: Integer); safecall;
    function Get_tlnJobCode: WideString; safecall;
    procedure Set_tlnJobCode(const Value: WideString); safecall;
    function Get_tlnJobAnalysis: WideString; safecall;
    procedure Set_tlnJobAnalysis(const Value: WideString); safecall;
    function Get_tlnCurrency: Integer; safecall;
    procedure Set_tlnCurrency(Value: Integer); safecall;
    function Get_tlnExchangeRate: Double; safecall;
    procedure Set_tlnExchangeRate(Value: Double); safecall;
    function Get_tlnDebit: Double; safecall;
    procedure Set_tlnDebit(Value: Double); safecall;
    function Get_tlnCredit: Double; safecall;
    procedure Set_tlnCredit(Value: Double); safecall;
    function Get_tlnUserField1: WideString; safecall;
    procedure Set_tlnUserField1(const Value: WideString); safecall;
    function Get_tlnUserField2: WideString; safecall;
    procedure Set_tlnUserField2(const Value: WideString); safecall;
    function Get_tlnUserField3: WideString; safecall;
    procedure Set_tlnUserField3(const Value: WideString); safecall;
    function Get_tlnUserField4: WideString; safecall;
    procedure Set_tlnUserField4(const Value: WideString); safecall;
    function Get_tlnCostCentre: WideString; safecall;
    procedure Set_tlnCostCentre(const Value: WideString); safecall;
    function Get_tlnDepartment: WideString; safecall;
    procedure Set_tlnDepartment(const Value: WideString); safecall;

    function Get_tlnNomVatType: TNomLineVatType; safecall;
    procedure Set_tlnNomVatType(Value: TNomLineVatType); safecall;
    function Get_tlnVatAmount: Double; safecall;
    procedure Set_tlnVatAmount(Value: Double); safecall;

    //ITransactionLineAsNOM3 functions
	//PL 26/10/2016	ABSEXCH-14172 added PayInRef to ITransactionLineAsNOM as a descendant ITransactionLineAsNOM3
    function Get_tlnPayInRef: WideString; safecall;
    procedure Set_tlnPayInRef(const Value: WideString); safecall;

  end;


  TTransactionLineAsTSH = Class(TTransactionViewLine, ITransactionLineAsTSH)
  protected
    function Get_tltJobCode: WideString; safecall;
    procedure Set_tltJobCode(const Value: WideString); safecall;
    function Get_tltRateCode: WideString; safecall;
    procedure Set_tltRateCode(const Value: WideString); safecall;
    function Get_tltAnalysisCode: WideString; safecall;
    procedure Set_tltAnalysisCode(const Value: WideString); safecall;
    function Get_tltHours: Double; safecall;
    procedure Set_tltHours(Value: Double); safecall;
    function Get_tltNarrative: WideString; safecall;
    procedure Set_tltNarrative(const Value: WideString); safecall;
    function Get_tltChargeOutRate: Double; safecall;
    procedure Set_tltChargeOutRate(Value: Double); safecall;
    function Get_tltCostPerHour: Double; safecall;
    procedure Set_tltCostPerHour(Value: Double); safecall;
    function Get_tltUserField1: WideString; safecall;
    procedure Set_tltUserField1(const Value: WideString); safecall;
    function Get_tltUserField2: WideString; safecall;
    procedure Set_tltUserField2(const Value: WideString); safecall;
    function Get_tltUserField3: WideString; safecall;
    procedure Set_tltUserField3(const Value: WideString); safecall;
    function Get_tltUserField4: WideString; safecall;
    procedure Set_tltUserField4(const Value: WideString); safecall;
    function Get_tltCurrency: Integer; safecall;
    procedure Set_tltCurrency(Value: Integer); safecall;
    function Get_tltCostCentre: WideString; safecall;
    procedure Set_tltCostCentre(const Value: WideString); safecall;
    function Get_tltDepartment: WideString; safecall;
    procedure Set_tltDepartment(const Value: WideString); safecall;


  end;

  TTransactionLineAsADJ = Class(TTransactionViewLine, ITransactionLineAsADJ)
  protected
    function Get_tlaStockCode: WideString; safecall;
    procedure Set_tlaStockCode(const Value: WideString); safecall;
    function Get_tlaLocation: WideString; safecall;
    procedure Set_tlaLocation(const Value: WideString); safecall;
    function Get_tlaPackQty: Double; safecall;
    procedure Set_tlaPackQty(Value: Double); safecall;
    function Get_tlaQtyIn: Double; safecall;
    procedure Set_tlaQtyIn(Value: Double); safecall;
    function Get_tlaQtyOut: Double; safecall;
    procedure Set_tlaQtyOut(Value: Double); safecall;
    function Get_tlaBuild: WordBool; safecall;
    procedure Set_tlaBuild(Value: WordBool); safecall;
    function Get_tlaUnitCost: Double; safecall;
    procedure Set_tlaUnitCost(Value: Double); safecall;
    function Get_tlaGLCode: Integer; safecall;
    procedure Set_tlaGLCode(Value: Integer); safecall;
    function Get_tlaCostCentre: WideString; safecall;
    procedure Set_tlaCostCentre(const Value: WideString); safecall;
    function Get_tlaDepartment: WideString; safecall;
    procedure Set_tlaDepartment(const Value: WideString); safecall;
    function Get_tlaUserField1: WideString; safecall;
    procedure Set_tlaUserField1(const Value: WideString); safecall;
    function Get_tlaUserField2: WideString; safecall;
    procedure Set_tlaUserField2(const Value: WideString); safecall;
    function Get_tlaUserField3: WideString; safecall;
    procedure Set_tlaUserField3(const Value: WideString); safecall;
    function Get_tlaUserField4: WideString; safecall;
    procedure Set_tlaUserField4(const Value: WideString); safecall;
  end;

  TTransactionLineAsWOR = Class(TTransactionViewLine, ITransactionLineAsWOR)
  private
    FTransaction : ITransaction;
  protected
    function Get_tlwStockCode: WideString; safecall;
    procedure Set_tlwStockCode(const Value: WideString); safecall;
    function Get_tlwLocation: WideString; safecall;
    procedure Set_tlwLocation(const Value: WideString); safecall;
    function Get_tlwQtyRequired: Double; safecall;
    procedure Set_tlwQtyRequired(Value: Double); safecall;
    function Get_tlwUndersOvers: Double; safecall;
    procedure Set_tlwUndersOvers(Value: Double); safecall;
    function Get_tlwBuildOrPickQty: Double; safecall;
    procedure Set_tlwBuildOrPickQty(Value: Double); safecall;
    function Get_tlwCostCentre: WideString; safecall;
    procedure Set_tlwCostCentre(const Value: WideString); safecall;
    function Get_tlwDepartment: WideString; safecall;
    procedure Set_tlwDepartment(const Value: WideString); safecall;
    function Get_tlwUserField1: WideString; safecall;
    procedure Set_tlwUserField1(const Value: WideString); safecall;
    function Get_tlwUserField2: WideString; safecall;
    procedure Set_tlwUserField2(const Value: WideString); safecall;
    function Get_tlwUserField3: WideString; safecall;
    procedure Set_tlwUserField3(const Value: WideString); safecall;
    function Get_tlwUserField4: WideString; safecall;
    procedure Set_tlwUserField4(const Value: WideString); safecall;
    function Get_tlwQtyPerBOM: Double; safecall;
    procedure Set_tlwQtyPerBOM(Value: Double); safecall;
    procedure ExplodeBOM; safecall;
  public
    constructor Create(const TransLine : ITransactionLine; const Toolkit  : Pointer;
                       const Trans     : ITransaction;     const DispIntf : TGUID);
  end;

  TTransactionLineAsPayLine = Class(TTransactionViewLine, ITransactionLineAsPayLine)
  private
    FTransaction : ITransaction;
  protected
    function Get_plGLCode: Integer; safecall;
    procedure Set_plGLCode(Value: Integer); safecall;
    function Get_plChequeNo: WideString; safecall;
    procedure Set_plChequeNo(const Value: WideString); safecall;
    function Get_plCurrency: Integer; safecall;
    function Get_plPayInRef: WideString; safecall;
    procedure Set_plPayInRef(const Value: WideString); safecall;
    function Get_plAmount: Double; safecall;
    procedure Set_plAmount(Value: Double); safecall;
    function UpdatePayInRef(const NewRef: WideString): Integer; safecall;
    function Get_plUserField1: WideString; safecall;
    procedure Set_plUserField1(const Value: WideString); safecall;
    function Get_plUserField2: WideString; safecall;
    procedure Set_plUserField2(const Value: WideString); safecall;
    function Get_plUserField3: WideString; safecall;
    procedure Set_plUserField3(const Value: WideString); safecall;
    function Get_plUserField4: WideString; safecall;
    procedure Set_plUserField4(const Value: WideString); safecall;
  public
    constructor Create(const TransLine : ITransactionLine; const Toolkit  : Pointer;
                       const Trans     : ITransaction;     const DispIntf : TGUID;
                       Mode : TInterfaceMode = imGeneral);
  end;


  TTransactionLineAsReturn = Class(TTransactionViewLine, ITransactionLineAsReturn)
  protected
    function Get_tlrQtyExpected: Double; safecall;
    procedure Set_tlrQtyExpected(Value: Double); safecall;
    function Get_tlrQtyReturned: Double; safecall;
    procedure Set_tlrQtyReturned(Value: Double); safecall;
    function Get_tlrQtyRepaired: Double; safecall;
    procedure Set_tlrQtyRepaired(Value: Double); safecall;
    function Get_tlrQtyWrittenOff: Double; safecall;
    procedure Set_tlrQtyWrittenOff(Value: Double); safecall;
    function Get_tlrTotalQtyRepaired: Double; safecall;
    function Get_tlrTotalQtyWrittenOff: Double; safecall;
    function Get_tlrUnderWarranty: WordBool; safecall;
    procedure Set_tlrUnderWarranty(Value: WordBool); safecall;
    function Get_tlrReason: Integer; safecall;
    procedure Set_tlrReason(Value: Integer); safecall;
    function Get_tlrStockCode: WideString; safecall;
    procedure Set_tlrStockCode(const Value: WideString); safecall;
    function Get_tlrDescr: WideString; safecall;
    procedure Set_tlrDescr(const Value: WideString); safecall;
    function Get_tlrLocation: WideString; safecall;
    procedure Set_tlrLocation(const Value: WideString); safecall;
    function Get_tlrNetValue: Double; safecall;
    procedure Set_tlrNetValue(Value: Double); safecall;
    function Get_tlrRepairPrice: Double; safecall;
    function Get_tlrDiscount: Double; safecall;
    procedure Set_tlrDiscount(Value: Double); safecall;
    function Get_tlrGLCode: Integer; safecall;
    procedure Set_tlrGLCode(Value: Integer); safecall;
    function Get_tlrVatCode: WideString; safecall;
    procedure Set_tlrVatCode(const Value: WideString); safecall;
    function Get_tlrCostCentre: WideString; safecall;
    procedure Set_tlrCostCentre(const Value: WideString); safecall;
    function Get_tlrDepartment: WideString; safecall;
    procedure Set_tlrDepartment(const Value: WideString); safecall;
    function Get_tlrCost: Double; safecall;
    function Get_tlrUserField1: WideString; safecall;
    procedure Set_tlrUserField1(const Value: WideString); safecall;
    function Get_tlrUserField2: WideString; safecall;
    procedure Set_tlrUserField2(const Value: WideString); safecall;
    function Get_tlrUserField3: WideString; safecall;
    procedure Set_tlrUserField3(const Value: WideString); safecall;
    function Get_tlrUserField4: WideString; safecall;
    procedure Set_tlrUserField4(const Value: WideString); safecall;
    function Get_tlrDiscFlag: WideString; safecall;
    procedure Set_tlrDiscFlag(const Value: WideString); safecall;

  end;


implementation

uses
  ComServ, BtKeys1U, oLine, DllTh_Up, DLLErrU, oToolkit;

constructor TTransactionViewLine.Create(const TransLine : ITransactionLine; const Toolkit : Pointer;
                                        const DispIntf : TGUID; Mode : TInterfaceMode = imGeneral;
                                        THLine : Pointer = nil);
begin
  inherited Create(ComServer.TypeLib, DispIntf);

  FTransactionLine := TransLine;
  FToolkit := Toolkit;
  FIntfType := Mode;
  FTHLine := THLine;
end;


{------------------------------TL as NOM--------------------------------------}

function TTransactionLineAsNOM.Get_tlnDescription: WideString;
begin
//  Result := FTransactionLine.tlDescr;
  Result := FTHLine.Desc;
end;

procedure TTransactionLineAsNOM.Set_tlnDescription(const Value: WideString);
begin
//  FTransactionLine.tlDescr := Value;
  FTHLine.Desc := Value;
end;

function TTransactionLineAsNOM.Get_tlnGLCode: Integer;
begin
//  Result := FTransactionLine.tlGLCode;
  Result := FTHLine.NomCode;
end;

procedure TTransactionLineAsNOM.Set_tlnGLCode(Value: Integer);
begin
//  FTransactionLine.tlGLCode := Value;
  FTHLine.NomCode := Value;
end;

function TTransactionLineAsNOM.Get_tlnJobCode: WideString;
begin
//  Result := FTransactionLine.tlJobCode;
  Result := FTHLine.JobCode;
end;

procedure TTransactionLineAsNOM.Set_tlnJobCode(const Value: WideString);
begin
//  FTransactionLine.tlJobCode := Value;
  FTHLine.JobCode := Value;
end;

function TTransactionLineAsNOM.Get_tlnJobAnalysis: WideString;
begin
//  Result := FTransactionLine.tlAnalysisCode;
  Result := FTHLine.AnalCode;
end;

procedure TTransactionLineAsNOM.Set_tlnJobAnalysis(const Value: WideString);
begin
// FTransactionLine.tlAnalysisCode := Value;
  FTHLine.AnalCode := Value;
end;

function TTransactionLineAsNOM.Get_tlnCurrency: Integer;
begin
//  Result := FTransactionLine.tlCurrency;
  Result := FTHLine.Currency;
end;

procedure TTransactionLineAsNOM.Set_tlnCurrency(Value: Integer);
begin
//  FTransactionLine.tlCurrency := Value;
  FTHLine.Currency := Value;
end;

function TTransactionLineAsNOM.Get_tlnExchangeRate: Double;
begin
  if IToolkit(FToolkit).SystemSetup.ssCurrencyRateType = rtCompany then
    //Result := FTransactionLine.tlCompanyRate
    Result := FTHLine.CoRate
  else
//    Result := FTransactionLine.tlDailyRate;
    Result := FTHLine.VATRate;
end;

procedure TTransactionLineAsNOM.Set_tlnExchangeRate(Value: Double);
begin
  if IToolkit(FToolkit).SystemSetup.ssCurrencyRateType = rtCompany then
    //FTransactionLine.tlCompanyRate := Value
    FTHLine.CoRate := Value
  else
//    FTransactionLine.tlDailyRate := Value;
    FTHLine.VatRate := Value;
end;

function TTransactionLineAsNOM.Get_tlnDebit: Double;
begin
  if FTransactionLine.tlNetValue > 0 then
//    Result := FTransactionLine.tlNetValue
    Result := FTHLine.NetValue
  else
    Result := 0;
end;

procedure TTransactionLineAsNOM.Set_tlnDebit(Value: Double);
begin
  if Value > 0.0 then
//    FTransactionLine.tlNetValue := Value;
    FTHLine.NetValue := Value;
end;

function TTransactionLineAsNOM.Get_tlnCredit: Double;
begin
  if FTransactionLine.tlNetValue < 0 then
//    Result := - FTransactionLine.tlNetValue
   Result := -FTHLine.NetValue
  else
    Result := 0;
end;

procedure TTransactionLineAsNOM.Set_tlnCredit(Value: Double);
begin
  if Value > 0.0 then
//    FTransactionLine.tlNetValue := - Value;
   FTHLine.NetValue := -Value;
end;

function TTransactionLineAsNOM.Get_tlnUserField1: WideString;
begin
//  Result := FTransactionLine.tlUserField1;
  Result := FTHLine.LineUser1;
end;

procedure TTransactionLineAsNOM.Set_tlnUserField1(const Value: WideString);
begin
//  FTransactionLine.tlUserField1 := Value;
  FTHLine.LineUser1 := Value;
end;

function TTransactionLineAsNOM.Get_tlnUserField2: WideString;
begin
//  Result := FTransactionLine.tlUserField2;
  Result := FTHLine.LineUser2;
end;

procedure TTransactionLineAsNOM.Set_tlnUserField2(const Value: WideString);
begin
//  FTransactionLine.tlUserField2 := Value;
  FTHLine.LineUser2 := Value;
end;

function TTransactionLineAsNOM.Get_tlnUserField3: WideString;
begin
//  Result := FTransactionLine.tlUserField3;
  Result := FTHLine.LineUser3;
end;

procedure TTransactionLineAsNOM.Set_tlnUserField3(const Value: WideString);
begin
//  FTransactionLine.tlUserField3 := Value;
  FTHLine.LineUser3 := Value;
end;

function TTransactionLineAsNOM.Get_tlnUserField4: WideString;
begin
//  Result := FTransactionLine.tlUserField4;
  Result := FTHLine.LineUser4;
end;

procedure TTransactionLineAsNOM.Set_tlnUserField4(const Value: WideString);
begin
//  FTransactionLine.tlUserField4 := Value;
  FTHLine.LineUser4 := Value;
end;

function TTransactionLineAsNOM.Get_tlnCostCentre: WideString;
begin
//  Result := FTransactionLine.tlCostCentre;
  Result := FTHLine.CC;
end;

procedure TTransactionLineAsNOM.Set_tlnCostCentre(const Value: WideString);
begin
//  FTransactionLine.tlCostCentre := Value;
  FTHLine.CC := Value;
end;

function TTransactionLineAsNOM.Get_tlnDepartment: WideString;
begin
//  Result := FTransactionLine.tlDepartment;
  Result := FTHLIne.Dep;
end;

procedure TTransactionLineAsNOM.Set_tlnDepartment(const Value: WideString);
begin
//  FTransactionLine.tlDepartment := Value;
  FTHLIne.Dep := Value
end;

function TTransactionLineAsNOM.Get_tlnNomVatType: TNomLineVatType;
begin
  Case FTHLine.NOMVatType of
    0  : Result := nlvNA;
    1  : Result := nlvAuto;
    2  : Result := nlvManual;
  end;
end;

procedure TTransactionLineAsNOM.Set_tlnNomVatType(Value: TNomLineVatType);
begin
  Case Value of
    nlvNA     : FTHLIne.NOMVatType := 0;
    nlvAuto   : FTHLIne.NOMVatType := 1;
    nlvManual : FTHLIne.NOMVatType := 2;
  end;
end;

function TTransactionLineAsNOM.Get_tlnVatAmount: Double;
begin
//  Result := FTransactionLine.tlVATAmount;
  Result := FTHLine.VAT;
end;

procedure TTransactionLineAsNOM.Set_tlnVatAmount(Value: Double);
begin
//  FTransactionLine.tlVATAmount := Value;
  FTHLine.VAT := Value;
end;


{-----------------------------TL As TSH------------------------------------}

function TTransactionLineAsTSH.Get_tltJobCode: WideString;
begin
  Result := FTransactionLine.tlJobCode;
end;

procedure TTransactionLineAsTSH.Set_tltJobCode(const Value: WideString);
begin
  FTransactionLine.tlJobCode := Value;
end;

function TTransactionLineAsTSH.Get_tltRateCode: WideString;
begin
  Result := FTransactionLine.tlStockCode;
end;

procedure TTransactionLineAsTSH.Set_tltRateCode(const Value: WideString);
begin
  FTransactionLine.tlStockCode := Value;
end;

function TTransactionLineAsTSH.Get_tltAnalysisCode: WideString;
begin
  Result := FTransactionLine.tlAnalysisCode;
end;

procedure TTransactionLineAsTSH.Set_tltAnalysisCode(const Value: WideString);
begin
  FTransactionLine.tlAnalysisCode := Value;
end;

function TTransactionLineAsTSH.Get_tltHours: Double;
begin
  Result := FTransactionLine.tlQty;
end;

procedure TTransactionLineAsTSH.Set_tltHours(Value: Double);
begin
  FTransactionLine.tlQty := Value;
end;

function TTransactionLineAsTSH.Get_tltNarrative: WideString;
begin
  Result := FTransactionLine.tlDescr;
end;

procedure TTransactionLineAsTSH.Set_tltNarrative(const Value: WideString);
begin
  FTransactionLine.tlDescr := Value;
end;

function TTransactionLineAsTSH.Get_tltChargeOutRate: Double;
begin
  Result := FTransactionLine.tlCost;
end;

procedure TTransactionLineAsTSH.Set_tltChargeOutRate(Value: Double);
begin
  FTransactionLine.tlCost := Value;
end;

function TTransactionLineAsTSH.Get_tltCostPerHour: Double;
begin
  Result := FTransactionLine.tlNetValue;
end;

procedure TTransactionLineAsTSH.Set_tltCostPerHour(Value: Double);
begin
  FTransactionLine.tlNetValue := Value;
end;

function TTransactionLineAsTSH.Get_tltUserField1: WideString;
begin
  Result := FTransactionLine.tlUserField1;
end;

procedure TTransactionLineAsTSH.Set_tltUserField1(const Value: WideString);
begin
  FTransactionLine.tlUserField1 := Value;
end;

function TTransactionLineAsTSH.Get_tltUserField2: WideString;
begin
  Result := FTransactionLine.tlUserField2;
end;

procedure TTransactionLineAsTSH.Set_tltUserField2(const Value: WideString);
begin
  FTransactionLine.tlUserField2 := Value;
end;

function TTransactionLineAsTSH.Get_tltUserField3: WideString;
begin
  Result := FTransactionLine.tlUserField3;
end;

procedure TTransactionLineAsTSH.Set_tltUserField3(const Value: WideString);
begin
  FTransactionLine.tlUserField3 := Value;
end;

function TTransactionLineAsTSH.Get_tltUserField4: WideString;
begin
  Result := FTransactionLine.tlUserField4;
end;

procedure TTransactionLineAsTSH.Set_tltUserField4(const Value: WideString);
begin
  FTransactionLine.tlUserField4 := Value;
end;

function TTransactionLineAsTSH.Get_tltCurrency: Integer;
begin
  Result := FTransactionLine.tlCurrency;
end;

procedure TTransactionLineAsTSH.Set_tltCurrency(Value: Integer);
begin
  FTransactionLine.tlCurrency := Value;
end;

function TTransactionLineAsTSH.Get_tltCostCentre: WideString;
begin
  Result := FTransactionLine.tlCostCentre;
end;

procedure TTransactionLineAsTSH.Set_tltCostCentre(const Value: WideString);
begin
  FTransactionLine.tlCostCentre := Value;
end;

function TTransactionLineAsTSH.Get_tltDepartment: WideString;
begin
  Result := FTransactionLine.tlDepartment;
end;

procedure TTransactionLineAsTSH.Set_tltDepartment(const Value: WideString);
begin
  FTransactionLine.tlDepartment := Value;
end;


{------------------------------TL as ADJ--------------------------------}

function TTransactionLineAsADJ.Get_tlaStockCode: WideString;
begin
  Result := FTransactionLine.tlStockCode;
end;

procedure TTransactionLineAsADJ.Set_tlaStockCode(const Value: WideString);
begin
  FTransactionLine.tlStockCode := Value;
end;

function TTransactionLineAsADJ.Get_tlaLocation: WideString;
begin
  Result := FTransactionLine.tlLocation;
end;

procedure TTransactionLineAsADJ.Set_tlaLocation(const Value: WideString);
begin
  FTransactionLine.tlLocation := Value;
end;

function TTransactionLineAsADJ.Get_tlaPackQty: Double;
begin
  Result := FTransactionLine.tlQtyMul;
end;

procedure TTransactionLineAsADJ.Set_tlaPackQty(Value: Double);
begin
  FTransactionLine.tlQtyMul := Value;
end;

function TTransactionLineAsADJ.Get_tlaQtyIn: Double;
begin
  if FTransactionLine.tlQty > 0 then
    Result := FTransactionLine.tlQty
  else
    Result := 0;
end;

procedure TTransactionLineAsADJ.Set_tlaQtyIn(Value: Double);
begin
  FTransactionLine.tlQty := Value;
end;

function TTransactionLineAsADJ.Get_tlaQtyOut: Double;
begin
  if FTransactionLine.tlQty < 0 then
    Result :=  -FTransactionLine.tlQty
  else
    Result := 0;
end;

procedure TTransactionLineAsADJ.Set_tlaQtyOut(Value: Double);
begin
  FTransactionLine.tlQty := -Value;
end;

function TTransactionLineAsADJ.Get_tlaBuild: WordBool;
begin
  with FTransactionLine do
  begin
    Result := Assigned(tlStockCodeI);

    if Result then
      Result := (tlStockCodeI.stType = stTypeBillOfMaterials) and
                (tlBOMKitLink = 1);

  end;
end;

procedure TTransactionLineAsADJ.Set_tlaBuild(Value: WordBool);
begin
  with FTransactionLine do
  begin
    if Assigned(tlStockCodeI) and (tlStockCodeI.stType = stTypeBillOfMaterials) then
    begin
      if Value then
        tlBOMKitLink := 1
      else
        tlBOMKitLink := 0;
    end;
  end;

end;

function TTransactionLineAsADJ.Get_tlaUnitCost: Double;
begin
  Result := FTransactionLine.tlCost;
end;

procedure TTransactionLineAsADJ.Set_tlaUnitCost(Value: Double);
begin
  FTransactionLine.tlCost := Value;
end;

function TTransactionLineAsADJ.Get_tlaGLCode: Integer;
begin
  Result := FTransactionLine.tlGLCode;
end;

procedure TTransactionLineAsADJ.Set_tlaGLCode(Value: Integer);
begin
  FTransactionLine.tlGLCode := Value;
end;

function TTransactionLineAsADJ.Get_tlaCostCentre: WideString;
begin
  Result := FTransactionLine.tlCostCentre;
end;

procedure TTransactionLineAsADJ.Set_tlaCostCentre(const Value: WideString);
begin
  FTransactionLine.tlCostCentre := Value;
end;

function TTransactionLineAsADJ.Get_tlaDepartment: WideString;
begin
  Result := FTransactionLine.tlDepartment;
end;

procedure TTransactionLineAsADJ.Set_tlaDepartment(const Value: WideString);
begin
  FTransactionLine.tlDepartment := Value;
end;


function TTransactionLineAsADJ.Get_tlaUserField1: WideString;
begin
  Result := FTransactionLine.tlUserField1;
end;

procedure TTransactionLineAsADJ.Set_tlaUserField1(const Value: WideString);
begin
  FTransactionLine.tlUserField1 := Value;
end;

function TTransactionLineAsADJ.Get_tlaUserField2: WideString;
begin
  Result := FTransactionLine.tlUserField2;
end;

procedure TTransactionLineAsADJ.Set_tlaUserField2(const Value: WideString);
begin
  FTransactionLine.tlUserField2 := Value;
end;

function TTransactionLineAsADJ.Get_tlaUserField3: WideString;
begin
  Result := FTransactionLine.tlUserField3;
end;

procedure TTransactionLineAsADJ.Set_tlaUserField3(const Value: WideString);
begin
  FTransactionLine.tlUserField3 := Value;
end;

function TTransactionLineAsADJ.Get_tlaUserField4: WideString;
begin
  Result := FTransactionLine.tlUserField4;
end;

procedure TTransactionLineAsADJ.Set_tlaUserField4(const Value: WideString);
begin
  FTransactionLine.tlUserField4 := Value;
end;

{-------------------------- TL as WOR ----------------------------------------}

constructor TTransactionLineAsWOR.Create(const TransLine : ITransactionLine; const Toolkit  : Pointer;
                                         const Trans     : ITransaction;     const DispIntf : TGUID);
begin
  inherited Create(TransLine, Toolkit, DispIntf);

  FTransactionLine := TransLine;
  FToolkit := Toolkit;
  FTransaction := Trans;
end;


function TTransactionLineAsWOR.Get_tlwStockCode: WideString;
begin
  Result := FTransactionLine.tlStockCode;
end;

procedure TTransactionLineAsWOR.Set_tlwStockCode(const Value: WideString);
begin
  FTransactionLine.tlStockCode := Value;
end;

function TTransactionLineAsWOR.Get_tlwLocation: WideString;
begin
  Result := FTransactionLine.tlLocation;
end;

procedure TTransactionLineAsWOR.Set_tlwLocation(const Value: WideString);
begin
  FTransactionLine.tlLocation := Value;
end;

function TTransactionLineAsWOR.Get_tlwQtyRequired: Double;
begin
  Result := FTransactionLine.tlQty;
end;

procedure TTransactionLineAsWOR.Set_tlwQtyRequired(Value: Double);
begin
  FTransactionLine.tlQty := Value;
end;

function TTransactionLineAsWOR.Get_tlwUndersOvers: Double;
begin
  Result := FTransactionLine.tlQtyPickedWO;
end;

procedure TTransactionLineAsWOR.Set_tlwUndersOvers(Value: Double);
begin
  FTransactionLine.tlQtyPickedWO := Value;
end;

function TTransactionLineAsWOR.Get_tlwBuildOrPickQty: Double;
begin
  Result := FTransactionLine.tlQtyPicked;
end;

procedure TTransactionLineAsWOR.Set_tlwBuildOrPickQty(Value: Double);
begin
  FTransactionLine.tlQtyPicked := Value;
end;

function TTransactionLineAsWOR.Get_tlwCostCentre: WideString;
begin
  Result := FTransactionLine.tlCostCentre;
end;

procedure TTransactionLineAsWOR.Set_tlwCostCentre(const Value: WideString);
begin
  FTransactionLine.tlCostCentre := Value;
end;

function TTransactionLineAsWOR.Get_tlwDepartment: WideString;
begin
  Result := FTransactionLine.tlDepartment;
end;

procedure TTransactionLineAsWOR.Set_tlwDepartment(const Value: WideString);
begin
  FTransactionLine.tlDepartment := Value;
end;

function TTransactionLineAsWOR.Get_tlwUserField1: WideString;
begin
  Result := FTransactionLine.tlUserField1;
end;

procedure TTransactionLineAsWOR.Set_tlwUserField1(const Value: WideString);
begin
  FTransactionLine.tlUserField1 := Value;
end;

function TTransactionLineAsWOR.Get_tlwUserField2: WideString;
begin
  Result := FTransactionLine.tlUserField2;
end;

procedure TTransactionLineAsWOR.Set_tlwUserField2(const Value: WideString);
begin
  FTransactionLine.tlUserField2 := Value;
end;

function TTransactionLineAsWOR.Get_tlwUserField3: WideString;
begin
  Result := FTransactionLine.tlUserField3;
end;

procedure TTransactionLineAsWOR.Set_tlwUserField3(const Value: WideString);
begin
  FTransactionLine.tlUserField3 := Value;
end;

function TTransactionLineAsWOR.Get_tlwUserField4: WideString;
begin
  Result := FTransactionLine.tlUserField4;
end;

procedure TTransactionLineAsWOR.Set_tlwUserField4(const Value: WideString);
begin
  FTransactionLine.tlUserField4 := Value;
end;

function TTransactionLineAsWOR.Get_tlwQtyPerBOM: Double;
begin
  Result := FTransactionLine.tlQtyMul;
end;

procedure TTransactionLineAsWOR.Set_tlwQtyPerBOM(Value: Double);
begin
  FTransactionLine.tlQtyMul := Value;
end;

procedure TTransactionLineAsWOR.ExplodeBOM;
var
  i : integer;
  ThisQty : Double;
begin
(**  //Do something - what?
  if Assigned(FTransactionLine.tlStockCodeI) and
             (FTransactionLine.tlStockCodeI.stType = stTypeBillOfMaterials) then
  begin
    if (FTransaction.thLines.thLineCount > 0) and
       (FTransaction.thLines[1] = FTransactionLine) then
    begin
      ThisQty := FTransactionLine.tlQty;
      for i := 1 to FTransactionLine.tlStockCodeI.stBillOfMaterials.blComponentCount do
      begin
        with FTransaction.thLines.Add do
        begin
          tlStockCode := FTransactionLine.tlStockCodeI.stBillOfMaterials.blComponent[i].bmStockCode;
          tlQty := FTransactionLine.tlStockCodeI.stBillOfMaterials.blComponent[i].bmQuantityUsed * ThisQty;
          tlNetValue := FTransactionLine.tlStockCodeI.stBillOfMaterials.blComponent[i].bmUnitCost;
          tlCurrency := FTransactionLine.tlStockCodeI.stBillOfMaterials.blComponent[i].bmUnitCostCurrency;
          tlLocation := ITransaction2(FTransaction).thAsWOR.twLocation;
          ImportDefaults;
          Save;
        end;
      end;
    end
    else
      raise EInvalidMethod.Create('The method ExplodeBOM is not available until the line has been saved');
  end
  else
    raise EInvalidMethod.Create('The method ExplodeBOM is only available for BOMs');
  *)
  (FTransactionLine as ITransactionLine3).ExplodeBOM;
end;

{=====================================PayLine=====================================}
constructor TTransactionLineAsPayLine.Create(const TransLine : ITransactionLine; const Toolkit  : Pointer;
                                             const Trans     : ITransaction;     const DispIntf : TGUID;
                                             Mode : TInterfaceMode = imGeneral);
begin
  inherited Create(TransLine, Toolkit, DispIntf);

  FTransactionLine := TransLine;
  FToolkit := Toolkit;
  FTransaction := Trans;
end;


function TTransactionLineAsPayLine.Get_plGLCode: Integer;
begin
  Result := FTransactionLine.tlGLCode;
end;

procedure TTransactionLineAsPayLine.Set_plGLCode(Value: Integer);
begin
  FTransactionLine.tlGLCode := Value;
end;

function TTransactionLineAsPayLine.Get_plChequeNo: WideString;
begin
  Result := FTransactionLine.tlDescr;
end;

procedure TTransactionLineAsPayLine.Set_plChequeNo(const Value: WideString);
begin
  FTransactionLine.tlDescr := Value;
end;

function TTransactionLineAsPayLine.Get_plCurrency: Integer;
begin
  Result := FTransactionLine.tlCurrency;
end;

function TTransactionLineAsPayLine.Get_plPayInRef: WideString;
begin
  Result := FTransactionLine.tlStockCode;
end;

procedure TTransactionLineAsPayLine.Set_plPayInRef(const Value: WideString);
begin
  FTransactionLine.tlStockCode := {Pre_PostPayInKey(#1, Value)}Value;
end;

function TTransactionLineAsPayLine.Get_plAmount: Double;
begin
  Result := FTransactionLine.tlNetValue;
end;

procedure TTransactionLineAsPayLine.Set_plAmount(Value: Double);
begin
  FTransactionLine.tlNetValue := Value;
end;

function TTransactionLineAsPayLine.UpdatePayInRef(const NewRef: WideString): Integer;
var
  OurRef, NewPayRef : PChar;
begin
  if NOT (FIntFType in [imAdd, imUpdate, imUpdateEx]) then
  begin
    OurRef := StrAlloc(255);
    NewPayRef := StrAlloc(255);
    Try
      StrPCopy(OurRef, FTransactionLine.tlOurRef);
      StrPCopy(NewPayRef, NewRef);

      Result := Ex_UpdatePayInRef(OurRef, FTransactionLine.tlAbsLineNo, NewPayRef);
    Finally
      StrDispose(OurRef);
      StrDispose(NewPayRef);
    End;

    if Result <> 0 then
      LastErDesc := EX_ERRORDESCRIPTION(158, Result);
  end
  else
    Raise EInvalidMethod.Create ('The UpdatePayIn method is not available in this object')

end;

function TTransactionLineAsPayLine.Get_plUserField1: WideString;
begin
  Result := FTransactionLine.tlUserField1;
end;

procedure TTransactionLineAsPayLine.Set_plUserField1(const Value: WideString);
begin
  FTransactionLine.tlUserField1 := Value;
end;

function TTransactionLineAsPayLine.Get_plUserField2: WideString;
begin
  Result := FTransactionLine.tlUserField2;
end;

procedure TTransactionLineAsPayLine.Set_plUserField2(const Value: WideString);
begin
  FTransactionLine.tlUserField2 := Value;
end;

function TTransactionLineAsPayLine.Get_plUserField3: WideString;
begin
  Result := FTransactionLine.tlUserField3;
end;

procedure TTransactionLineAsPayLine.Set_plUserField3(const Value: WideString);
begin
  FTransactionLine.tlUserField3 := Value;
end;

function TTransactionLineAsPayLine.Get_plUserField4: WideString;
begin
  Result := FTransactionLine.tlUserField4;
end;

procedure TTransactionLineAsPayLine.Set_plUserField4(const Value: WideString);
begin
  FTransactionLine.tlUserField4 := Value;
end;





{ TTransactionLineAsReturn }

function TTransactionLineAsReturn.Get_tlrQtyReturned: Double;
begin
  Result := FTransactionLine.tlQty;
end;

function TTransactionLineAsReturn.Get_tlrQtyExpected: Double;
begin
  Result := FTransactionLine.tlQtyPicked;
end;

function TTransactionLineAsReturn.Get_tlrQtyRepaired: Double;
begin
  Result := FTransactionLine.tlQtyPickedWO;
end;

function TTransactionLineAsReturn.Get_tlrQtyWrittenOff: Double;
begin
  Result := FTransactionLine.tlSSDUpliftPerc;
end;

function TTransactionLineAsReturn.Get_tlrReason: Integer;
begin
  //AP : 03/01/2017 : ABSEXCH-14958 Exception raised when reading tlAsReturn.tlrReason when the reason is more than 17.
  Result  := FTHLine.DocLTLink; 
end;

function TTransactionLineAsReturn.Get_tlrTotalQtyRepaired: Double;
begin
  Result := FTransactionLine.tlQtyDel;
end;

function TTransactionLineAsReturn.Get_tlrTotalQtyWrittenOff: Double;
begin
  Result := FTransactionLine.tlQtyWOFF;
end;

function TTransactionLineAsReturn.Get_tlrUnderWarranty: WordBool;
begin
  Result := FTHLine.NOMVatType = 1;
end;

procedure TTransactionLineAsReturn.Set_tlrQtyReturned(Value: Double);
begin
  FTransactionLine.tlQty := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrQtyExpected(Value: Double);
begin
  FTransactionLine.tlQtyPicked := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrQtyRepaired(Value: Double);
begin
  FTransactionLine.tlQtyPickedWO := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrQtyWrittenOff(Value: Double);
begin
  FTransactionLine.tlSSDUpliftPerc := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrReason(Value: Integer);
var
  Res : longint;
  LastReason : Integer;
begin
  with TToolkit(FToolkit).SystemSetupI as ISystemSetup4 do
  begin
    Res := ssReturnLineReason.GetLast;
    if Res = 0 then
      LastReason := ssReturnLineReason.rlrNumber
    else
      LastReason := -1;
  end;

  if Value > LastReason then
    raise EValidation.Create('Invalid Reason Number (' + IntToStr(Value) + ')');

  FTHLine.DocLTLink := Value;
  
end;

procedure TTransactionLineAsReturn.Set_tlrUnderWarranty(Value: WordBool);
begin
  if Value then
    FTHLine.NOMVatType := 1
  else
    FTHLine.NOMVatType := 0;
end;

function TTransactionLineAsReturn.Get_tlrDescr: WideString;
begin
  Result := FTransactionLine.tlDescr;
end;

function TTransactionLineAsReturn.Get_tlrLocation: WideString;
begin
  Result := FTransactionLine.tlLocation;
end;

function TTransactionLineAsReturn.Get_tlrCost: Double;
begin
  Result := FTransactionLine.tlCost;
end;

function TTransactionLineAsReturn.Get_tlrCostCentre: WideString;
begin
  Result := FTransactionLine.tlCostCentre;
end;

function TTransactionLineAsReturn.Get_tlrDepartment: WideString;
begin
  Result := FTransactionLine.tlDepartment;
end;

function TTransactionLineAsReturn.Get_tlrDiscount: Double;
begin
  Result := FTransactionLine.tlDiscount;
end;

function TTransactionLineAsReturn.Get_tlrGLCode: Integer;
begin
  Result := FTransactionLine.tlGLCode;
end;

function TTransactionLineAsReturn.Get_tlrNetValue: Double;
begin
  Result := FTransactionLine.tlNetValue;
end;

function TTransactionLineAsReturn.Get_tlrRepairPrice: Double;
begin
  Result := FTransactionLine.tlSSDSalesUnit;
end;

function TTransactionLineAsReturn.Get_tlrStockCode: WideString;
begin
  Result := FTransactionLine.tlStockCode;
end;

function TTransactionLineAsReturn.Get_tlrUserField1: WideString;
begin
  Result := FTransactionLine.tlUserField1;
end;

function TTransactionLineAsReturn.Get_tlrUserField2: WideString;
begin
  Result := FTransactionLine.tlUserField2;
end;

function TTransactionLineAsReturn.Get_tlrUserField3: WideString;
begin
  Result := FTransactionLine.tlUserField3;
end;

function TTransactionLineAsReturn.Get_tlrUserField4: WideString;
begin
  Result := FTransactionLine.tlUserField4;
end;

function TTransactionLineAsReturn.Get_tlrVatCode: WideString;
begin
  Result := FTransactionLine.tlVATCode;
end;

procedure TTransactionLineAsReturn.Set_tlrDescr(const Value: WideString);
begin
  FTransactionLine.tlDescr := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrLocation(const Value: WideString);
begin
  FTransactionLine.tlLocation := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrCostCentre(
  const Value: WideString);
begin
  FTransactionLine.tlCostCentre := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrDepartment(
  const Value: WideString);
begin
  FTransactionLine.tlDepartment := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrDiscount(Value: Double);
begin
  FTransactionLine.tlDiscount := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrGLCode(Value: Integer);
begin
  FTransactionLine.tlGLCode := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrNetValue(Value: Double);
begin
  FTransactionLine.tlNetValue := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrStockCode(
  const Value: WideString);
begin
  FTransactionLine.tlStockCode := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrUserField1(
  const Value: WideString);
begin
  FTransactionLine.tlUserField1 := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrUserField2(
  const Value: WideString);
begin
  FTransactionLine.tlUserField2 := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrUserField3(
  const Value: WideString);
begin
  FTransactionLine.tlUserField3 := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrUserField4(
  const Value: WideString);
begin
  FTransactionLine.tlUserField4 := Value;
end;

procedure TTransactionLineAsReturn.Set_tlrVatCode(const Value: WideString);
begin
  FTransactionLine.tlVATCode := Value;
end;

function TTransactionLineAsReturn.Get_tlrDiscFlag: WideString;
begin
  Result := FTransactionLine.tlDiscFlag;
end;

procedure TTransactionLineAsReturn.Set_tlrDiscFlag(
  const Value: WideString);
begin
  FTransactionLine.tlDiscFlag := Value;
end;

destructor TTransactionViewLine.Destroy;
begin
  FTransactionLine := nil;
  FToolkit := nil;
  FTHLine := nil;
  inherited;
end;


function TTransactionLineAsNOM.Get_tlnPayInRef: WideString;
begin
  Result := FTHLine.StockCode;
end;

procedure TTransactionLineAsNOM.Set_tlnPayInRef(const Value: WideString);
begin
  FTHLine.StockCode := Value;
end;

end.
