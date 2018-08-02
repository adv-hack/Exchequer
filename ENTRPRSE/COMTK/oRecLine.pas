unit oRecLine;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, oCustBal, ExBtTh1U, GlobList, VarRec2U;


type
  TBankReconciliationLine = Class(TBtrieveFunctions, IBankReconciliationLine, IBrowseInfo)
  private
    FLineRec : BnkRDRecType;
    FIntfType       : TInterfaceMode;
  protected
    function Get_brlPaymentRef: WideString; safecall;
    procedure Set_brlPaymentRef(const Value: WideString); safecall;
    function Get_brlLineDate: WideString; safecall;
    procedure Set_brlLineDate(const Value: WideString); safecall;
    function Get_brlMatchedOurRef: WideString; safecall;
    procedure Set_brlMatchedOurRef(const Value: WideString); safecall;
    function Get_brlValue: Double; safecall;
    procedure Set_brlValue(Value: Double); safecall;
    function Get_brlLineNo: Integer; safecall;
    procedure Set_brlLineNo(Value: Integer); safecall;
    function Get_brlMatchedLineNo: Integer; safecall;
    procedure Set_brlMatchedLineNo(Value: Integer); safecall;
    function Get_brlStatementID: WideString; safecall;
    procedure Set_brlStatementID(const Value: WideString); safecall;
    function Get_brlStatementLineNo: Integer; safecall;
    procedure Set_brlStatementLineNo(Value: Integer); safecall;
    function Get_brlAcCode: WideString; safecall;
    procedure Set_brlAcCode(const Value: WideString); safecall;
    function Get_brlPeriod: Integer; safecall;
    procedure Set_brlPeriod(Value: Integer); safecall;
    function Get_brlYear: Integer; safecall;
    procedure Set_brlYear(Value: Integer); safecall;
    function Get_brlCompanyRate: Double; safecall;
    procedure Set_brlCompanyRate(Value: Double); safecall;
    function Get_brlDailyRate: Double; safecall;
    procedure Set_brlDailyRate(Value: Double); safecall;
    function Get_brlYourRef: WideString; safecall;
    procedure Set_brlYourRef(const Value: WideString); safecall;
    function Get_brlCostCentre: WideString; safecall;
    procedure Set_brlCostCentre(const Value: WideString); safecall;
    function Get_brlDepartment: WideString; safecall;
    procedure Set_brlDepartment(const Value: WideString); safecall;
    function Get_brlStatementValue: Double; safecall;
    procedure Set_brlStatementValue(Value: Double); safecall;


    function Get_Index: TBankReconciliationLineIndex; safecall;
    procedure Set_Index(Value: TBankReconciliationLineIndex); safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;

    function Add: IBankReconciliationLine; safecall;
    function Update: IBankReconciliationLine; safecall;
    function Clone: IBankReconciliationLine; safecall;
    function Delete: Integer; safecall;
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
  end;

implementation

{ TBankReconciliationLine }
uses
  oBankSt, etStrU, ComServ;

function TBankReconciliationLine.Add: IBankReconciliationLine;
begin

end;

function TBankReconciliationLine.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin

end;

procedure TBankReconciliationLine.Cancel;
begin

end;

function TBankReconciliationLine.Clone: IBankReconciliationLine;
begin

end;

procedure TBankReconciliationLine.CopyDataRecord;
begin
  inherited;

end;

constructor TBankReconciliationLine.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin

end;

function TBankReconciliationLine.Delete: Integer;
begin

end;

destructor TBankReconciliationLine.Destroy;
begin

  inherited;
end;

function TBankReconciliationLine.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin

end;

function TBankReconciliationLine.Get_brlAcCode: WideString;
begin
  Result := FLineRec.brCustCode;
end;

function TBankReconciliationLine.Get_brlCompanyRate: Double;
begin
  Result := FLineRec.brCXRate[False];
end;

function TBankReconciliationLine.Get_brlCostCentre: WideString;
begin
  Result := FLineRec.brCCDep[True];
end;

function TBankReconciliationLine.Get_brlDailyRate: Double;
begin
  Result := FLineRec.brCXRate[True];
end;

function TBankReconciliationLine.Get_brlDepartment: WideString;
begin
  Result := FLineRec.brCCDep[False];
end;

function TBankReconciliationLine.Get_brlLineDate: WideString;
begin
  Result := FLineRec.brLineDate;
end;

function TBankReconciliationLine.Get_brlLineNo: Integer;
begin
  Result := FLineRec.brLineNo;
end;

function TBankReconciliationLine.Get_brlValue: Double;
begin
  Result := FLineRec.brTransValue;
end;

function TBankReconciliationLine.Get_brlMatchedLineNo: Integer;
begin

end;

function TBankReconciliationLine.Get_brlMatchedOurRef: WideString;
begin

end;

function TBankReconciliationLine.Get_brlPaymentRef: WideString;
begin

end;

function TBankReconciliationLine.Get_brlPeriod: Integer;
begin

end;

function TBankReconciliationLine.Get_brlStatementID: WideString;
begin

end;

function TBankReconciliationLine.Get_brlStatementLineNo: Integer;
begin

end;

function TBankReconciliationLine.Get_brlYear: Integer;
begin

end;

function TBankReconciliationLine.Get_brlYourRef: WideString;
begin

end;

function TBankReconciliationLine.Get_ibInterfaceMode: Integer;
begin

end;

function TBankReconciliationLine.Get_Index: TBankReconciliationLineIndex;
begin

end;

function TBankReconciliationLine.Save: Integer;
begin

end;

procedure TBankReconciliationLine.Set_brlAcCode(const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlCompanyRate(Value: Double);
begin

end;

procedure TBankReconciliationLine.Set_brlCostCentre(
  const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlDailyRate(Value: Double);
begin

end;

procedure TBankReconciliationLine.Set_brlDepartment(const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlLineDate(const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlLineNo(Value: Integer);
begin

end;


procedure TBankReconciliationLine.Set_brlMatchedLineNo(Value: Integer);
begin

end;

procedure TBankReconciliationLine.Set_brlMatchedOurRef(
  const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlPaymentRef(
  const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlPeriod(Value: Integer);
begin

end;

procedure TBankReconciliationLine.Set_brlStatementID(
  const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_brlStatementLineNo(Value: Integer);
begin

end;

procedure TBankReconciliationLine.Set_brlValue(Value: Double);
begin

end;

procedure TBankReconciliationLine.Set_brlYear(Value: Integer);
begin

end;

procedure TBankReconciliationLine.Set_brlYourRef(const Value: WideString);
begin

end;

procedure TBankReconciliationLine.Set_Index(
  Value: TBankReconciliationLineIndex);
begin

end;

function TBankReconciliationLine.Update: IBankReconciliationLine;
begin

end;

function TBankReconciliationLine.Get_brlStatementValue: Double;
begin

end;

procedure TBankReconciliationLine.Set_brlStatementValue(Value: Double);
begin

end;

end.
 