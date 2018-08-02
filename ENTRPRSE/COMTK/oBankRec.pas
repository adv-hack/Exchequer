unit oBankRec;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, oCustBal, ExBtTh1U, GlobList, VarRec2U, oRecLine;

Type
  TBankReconciliation = Class(TBtrieveFunctions, IBankReconciliation, IBrowseInfo)
  private
    FBankRec        : BnkRHRecType;
    FIntfType       : TInterfaceMode;
    FToolkit        : TObject;

    FLineO          : TBankReconciliationLine;
    FLineI          : IBankReconciliationLine;
    procedure InitObjects;
  protected
    function Get_brStatementDate: WideString; safecall;
    procedure Set_brStatementDate(const Value: WideString); safecall;
    function Get_brStatementRef: WideString; safecall;
    procedure Set_brStatementRef(const Value: WideString); safecall;
    function Get_brBankAccount: WideString; safecall;
    procedure Set_brBankAccount(const Value: WideString); safecall;
    function Get_brGLCode: Integer; safecall;
    procedure Set_brGLCode(Value: Integer); safecall;
    function Get_brCurrency: Integer; safecall;
    procedure Set_brCurrency(Value: Integer); safecall;
    function Get_brStatementBalance: Double; safecall;
    procedure Set_brStatementBalance(Value: Double); safecall;
    function Get_brOpeningBalance: Double; safecall;
    procedure Set_brOpeningBalance(Value: Double); safecall;
    function Get_brClosingBalance: Double; safecall;
    procedure Set_brClosingBalance(Value: Double); safecall;
    function Get_brFolio: Integer; safecall;
    function Get_brStatus: TBankReconciliationStatus; safecall;
    procedure Set_brStatus(Value: TBankReconciliationStatus); safecall;
    function Get_brUserID: WideString; safecall;
    procedure Set_brUserID(const Value: WideString); safecall;
    function Get_brDateCreated: WideString; safecall;
    function Get_brTimeCreated: WideString; safecall;
    function Get_Index: TBankStatementIndex; safecall;
    procedure Set_Index(Value: TBankStatementIndex); safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Add: IBankReconciliation; safecall;
    function Update: IBankReconciliation; safecall;
    function Clone: IBankReconciliation; safecall;
    function Get_brLines: IBankReconciliationLine; safecall;
    function Delete: Integer; safecall;
    function BuildDateIndex(const ADate: WideString): WideString; safecall;
    function BuildReferenceIndex(const Ref: WideString): WideString; safecall;
    function BuildStatusIndex(Status: TBankReconciliationStatus): WideString; safecall;

    //IBrowseInfo
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

  Function CreateTBankReconciliation (Const Toolkit  : TObject;
                                      Const ClientId : Integer) : TBankReconciliation;


implementation

{ TBankReconciliation }
uses
  oBankSt, etStrU, ComServ;

Function CreateTBankReconciliation (Const Toolkit  : TObject;
                                    Const ClientId : Integer) : TBankReconciliation;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTAccount }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by object
  BtrIntf^.Open_System(MLocF, MLocF);


  // Create bas TAccount object
  Result := TBankReconciliation.Create(imGeneral, Toolkit, BtrIntf);
End;


function TBankReconciliation.Add: IBankReconciliation;
Var
  FBankReconciliationO : TBankReconciliation;
begin { Add }
  AuthoriseFunction(100, 'Add');

  FBankReconciliationO := TBankReconciliation.Create(imAdd, FToolkit, FBtrIntf);
//  FBankReconciliationO.InitNewBankReconciliation;

  Result := FBankReconciliationO;
end;

function TBankReconciliation.BuildDateIndex(
  const ADate: WideString): WideString;
begin

end;

function TBankReconciliation.BuildReferenceIndex(
  const Ref: WideString): WideString;
begin

end;

function TBankReconciliation.BuildStatusIndex(
  Status: TBankReconciliationStatus): WideString;
begin

end;

procedure TBankReconciliation.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TBankReconciliation.Clone: IBankReconciliation;
begin

end;

function TBankReconciliation.Delete: Integer;
begin

end;

function TBankReconciliation.Get_brBankAccount: WideString;
begin
  Result := FBankRec.brBankAcc;
end;

function TBankReconciliation.Get_brClosingBalance: Double;
begin
  Result := FBankRec.brCloseBal;
end;

function TBankReconciliation.Get_brCurrency: Integer;
begin
  Result := FBankRec.brCurrency;
end;

function TBankReconciliation.Get_brDateCreated: WideString;
begin
  Result := FBankRec.brCreateDate;
end;

function TBankReconciliation.Get_brFolio: Integer;
begin
  Result := FBankRec.brIntRef;
end;

function TBankReconciliation.Get_brGLCode: Integer;
begin
  Result := FBankRec.brGLCode;
end;

function TBankReconciliation.Get_brLines: IBankReconciliationLine;
begin

end;

function TBankReconciliation.Get_brOpeningBalance: Double;
begin
  Result := FBankRec.brOpenBal;
end;

function TBankReconciliation.Get_brStatementBalance: Double;
begin
  Result := FBankRec.brStatBal;
end;

function TBankReconciliation.Get_brStatementDate: WideString;
begin
  Result := FBankRec.brStatDate;
end;

function TBankReconciliation.Get_brStatementRef: WideString;
begin
  Result := FBankRec.brStatRef;
end;

function TBankReconciliation.Get_brStatus: TBankReconciliationStatus;
begin
  Result := FBankRec.brStatus;
end;

function TBankReconciliation.Get_brTimeCreated: WideString;
begin
  Result := FBankRec.brCreateTime;
end;

function TBankReconciliation.Get_brUserID: WideString;
begin
  Result := FBankRec.brUserId;
end;

function TBankReconciliation.Get_Index: TBankStatementIndex;
begin
  Result := FIndex;
end;


function TBankReconciliation.Save: Integer;
begin

end;


procedure TBankReconciliation.Set_brBankAccount(const Value: WideString);
begin
  FBankRec.brBankAcc := Value;
end;

procedure TBankReconciliation.Set_brClosingBalance(Value: Double);
begin
  FBankRec.brCloseBal := Value;
end;

procedure TBankReconciliation.Set_brCurrency(Value: Integer);
begin
  FBankRec.brCurrency := Value;
end;

procedure TBankReconciliation.Set_brGLCode(Value: Integer);
begin
  FBankRec.brGLCode := Value;
end;

procedure TBankReconciliation.Set_brOpeningBalance(Value: Double);
begin
  FBankRec.brOpenBal := Value;
end;

procedure TBankReconciliation.Set_brStatementBalance(Value: Double);
begin
  FBankRec.brStatBal := Value;
end;

procedure TBankReconciliation.Set_brStatementDate(const Value: WideString);
begin
  FBankRec.brStatDate := Value;
end;

procedure TBankReconciliation.Set_brStatementRef(const Value: WideString);
begin
  FBankRec.brStatRef := Value;
end;

procedure TBankReconciliation.Set_brStatus(
  Value: TBankReconciliationStatus);
begin
  FBankRec.brStatus := Value;
end;

procedure TBankReconciliation.Set_brUserID(const Value: WideString);
begin
  FBankRec.brUserId := Value;
end;

procedure TBankReconciliation.Set_Index(Value: TBankStatementIndex);
begin
  inherited Set_Index(Value);
end;

function TBankReconciliation.Update: IBankReconciliation;
begin

end;

function TBankReconciliation.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin

end;

procedure TBankReconciliation.CopyDataRecord;
begin
  Move(FBtrIntf^.LMLocCtrl^.BnkRHRec, FBankRec, SizeOf(FBankRec));
end;

function TBankReconciliation.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TBankReconciliation.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;
    if FIndex = 0 then
      KeyS := SetKeyString(BtrOp, LteBankRCode + BankRecHeadKey + LJVar(SearchKey + '!', 30));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := LteBankRCode + BankRecHeadKey + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := LteBankRCode + BankRecHeadKey + #255;
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      If ((LMLocCtrl.RecPFix <> LteBankRCode) Or (LMLocCtrl.SubType <> BankRecHeadKey)) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankRecHeadKey));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankAccountKey) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

 { If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (72, Result);}
end;

constructor TBankReconciliation.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IAccount2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := CustF;

  // Initialise variables
  FillChar (FBankRec, SizeOf(FBankRec), #0);
  InitObjects;

  FToolkit := Toolkit;

  FIntfType := IType;
end;

destructor TBankReconciliation.Destroy;
begin
  InitObjects;
  inherited;
end;

procedure TBankReconciliation.InitObjects;
begin
  FLineO := nil;
  FLineI := nil;
end;

end.
