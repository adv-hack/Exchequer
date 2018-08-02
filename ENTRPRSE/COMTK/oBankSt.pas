unit oBankSt;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
      MiscFunc, oBtrieve, BtrvU2, GlobList, VarConst, Varrec2u, GlobVar;

const
  BankRecHeadKey  = '1';
  BankRecLineKey  = '2';
  BankAccountKey  = '3';
  BankStatHeadKey = '4';
  BankStatLineKey = '5';

type
  TBankStatementLine = class(TBtrieveFunctions, IBankStatementLine)
  private
    FLineRec : eBankLRecType;
    FToolkit  : TObject;

    FIntfType : TInterfaceMode;
    FFolio : longint;
    FGLCode : longint;
    function ValidateSave : Integer;
    function DoPrefix : string;
    function CheckPrefix : Boolean;
  protected
    function Get_bslLineDate: WideString; safecall;
    procedure Set_bslLineDate(const Value: WideString); safecall;
    function Get_bslReference: WideString; safecall;
    procedure Set_bslReference(const Value: WideString); safecall;
    function Get_bslValue: Double; safecall;
    procedure Set_bslValue(Value: Double); safecall;
    function Get_Index: TBankStatementLineIndex; safecall;
    procedure Set_Index(Value: TBankStatementLineIndex); safecall;
    function Get_bslReference2: WideString; safecall;
    procedure Set_bslReference2(const Value: WideString); safecall;
    function Get_bslFolio: Integer; safecall;
    function Get_bslLineNo: Integer; safecall;
    procedure Set_bslLineNo(Value: Integer); safecall;
    function Get_bslStatus: TBankStatementLineStatus; safecall;
    procedure Set_bslStatus(Value: TBankStatementLineStatus); safecall;


    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Add: IBankStatementLine; safecall;
    function Update: IBankStatementLine; safecall;
    function Delete: Integer; safecall;
    function Clone: IBankStatementLine; safecall;
    function BuildLineDateIndex(const LineDate: WideString): WideString; safecall;
    function BuildLineRefIndex(const LineRef: WideString): WideString; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; OverRide;

  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
    Procedure LoadDetails (Const LineDets : eBankLRecType; Const LockPos : LongInt);
    procedure CloneDetails (const LineDets : eBankLRecType);
    property Folio : longint read FFolio write FFolio;
    property GLCode : longint read FGLCode write FGLCode;
  end;


  TBankStatement = class(TBtrieveFunctions, IBankStatement, IBrowseInfo)
  private
    FStatementRec : eBankHRecType;
    FToolkit  : TObject;

    FIntfType : TInterfaceMode;
    FGLCode : longint;

    FLineO : TBankStatementLine;
    FLineI : IBankStatementLine;
    procedure InitObjects;
    function ValidateSave : Integer;
    function GetNextStatementFolio : longint;
    procedure DeleteLines;
  protected
    function Get_bsDate: WideString; safecall;
    procedure Set_bsDate(const Value: WideString); safecall;
    function Get_bsReference: WideString; safecall;
    procedure Set_bsReference(const Value: WideString); safecall;
    function Get_bsStatus: TBankStatementStatus; safecall;
    procedure Set_bsStatus(Value: TBankStatementStatus); safecall;
    function Get_bsStatementLine: IBankStatementLine; safecall;
    function Get_bsFolio: Integer; safecall;
    function Get_bsBalance: Double; safecall;

    function BuildReferenceIndex(const Reference: WideString): WideString; safecall;
    function BuildStatusIndex(Status: TBankStatementStatus): WideString; safecall;
    function BuildDateAndFolioIndex(const ADate: WideString; Folio: Integer): WideString; safecall;

    function Get_Index: TBankStatementIndex; safecall;
    procedure Set_Index(Value: TBankStatementIndex); safecall;
    function Save: Integer; safecall;
    procedure Cancel; safecall;
    function Add: IBankStatement; safecall;
    function Update: IBankStatement; safecall;
    function Delete: Integer; safecall;
    function Clone: IBankStatement; safecall;
    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt; OverRide;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
    procedure InitNewRecord;
    Procedure LoadDetails (Const Details : eBankHRecType; Const LockPos : LongInt);
    procedure CloneDetails (const Details : eBankHRecType);
    property GLCode : longint read FGLCode write FGLCode;

  end;

  Function CreateTBankStatement (Const Toolkit : TObject; Const ClientId : Integer) : TBankStatement;
  Function CreateTBankStatementLine (Const Toolkit : TObject; Const ClientId : Integer) : TBankStatementLine;

  Function ReverseFullNomKey(ncode  :  Longint)  :  Str20;


implementation

uses
  ComServ, EtStrU, EtDateU, BtSupU1, BtKeys1U, SQLUtils, oToolkit;

//Using standard fullnomkey puts gls out of order
Function ReverseFullNomKey(ncode  :  Longint)  :  Str20;
Var
  TmpStr, TmpStr2  :  Str20;
  i : integer;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  FillChar(TmpStr2,Sizeof(TmpStr2),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));
  TmpStr2[0] := TmpStr[0];
  //reverse string
  for i := 1 to 4 do
    TmpStr2[i] := TmpStr[5-i];

  Result := TmpStr2;
end;

Function CreateTBankStatement (Const Toolkit : TObject; Const ClientId : Integer) : TBankStatement;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStock }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  //Open file
  BtrIntf^.Open_System(MLocF,  MLocF);

  Result := TBankStatement.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF]);
End; { CreateTStock }

Function CreateTBankStatementLine (Const Toolkit : TObject; Const ClientId : Integer) : TBankStatementLine;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStock }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  //Open file
  BtrIntf^.Open_System(MLocF,  MLocF);

  Result := TBankStatementLine.Create(imGeneral, Toolkit, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF]);
End; { CreateTStock }

{ TBankStatementLine }

function TBankStatementLine.Add: IBankStatementLine;
Var
  AddO : TBankStatementLine;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TBankStatementLine.Create(imAdd, FToolkit, FBtrIntf);
  AddO.Folio := FFolio;
  AddO.GLCode := FGLCode;
//  AddO.InitNewRecord;

  Result := AddO;
end;

procedure TBankStatementLine.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TBankStatementLine.Clone: IBankStatementLine;
Var
  FLineO : TBankStatementLine;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FLineO := TBankStatementLine.Create(imClone, FToolkit, FBtrIntf);
  FLineO.CloneDetails(FLineRec);
  FLineO.Folio := FFolio;
  FLineO.GLCode := FGLCode;
  Result := FLineO;
end;

function TBankStatementLine.Delete: Integer;
begin
  AuthoriseFunction(105, 'Delete');

  Result := FBtrIntf.LDelete_Rec(MLocF, FIndex);
end;

function TBankStatementLine.Get_bslLineDate: WideString;
begin
  Result := FLineRec.ebLineDate;
end;

function TBankStatementLine.Get_bslReference: WideString;
begin
  Result := FLineRec.ebLineRef;
end;

function TBankStatementLine.Get_bslValue: Double;
begin
  Result := FLineRec.ebLineValue;
end;


function TBankStatementLine.Save: Integer;
var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  Res   : SmallInt;

begin
  AuthoriseFunction(102, 'Save');
  Result := ValidateSave;
  if Result = 0 then
  begin
    FLineRec.ebGLCode := FGLCode;
    FLineRec.ebLineIntRef := FFolio;
    Move(FLineRec, FBtrIntf^.LMLocCtrl^.eBankLRec, SizeOf(FLineRec));
    if FIntfType = imAdd then
    begin
      FBtrIntf^.LMLocCtrl.RecPfix := LteBankRCode;
      FBtrIntf^.LMLocCtrl.SubType := BankStatLineKey;
      FBtrIntf^.LMLocCtrl.eBankLRec.ebLCode1 := LJVar(DoPrefix + FBtrIntf^.LMLocCtrl.eBankLRec.ebLineDate, 30);
      FBtrIntf^.LMLocCtrl.eBankLRec.ebLCode2 := LJVar(DoPrefix + FBtrIntf^.LMLocCtrl.eBankLRec.ebLineRef, 45);
      Result := FBtrIntf^.LAdd_Rec(FFileNo, FIndex);
    end
    else
    begin
      SaveMainPos(SaveInfo);
      SaveExLocalPos(SaveInfo2);
      Res := PositionOnLock;
      Result := Put_Rec(F[FFileNo],  FFileNo, FBtrIntf^.LMlocCtrl^, FIndex);
      RestoreExLocalPos(SaveInfo2);
      RestoreMainPos(SaveInfo);
    end;
  end;
end;

procedure TBankStatementLine.Set_bslLineDate(const Value: WideString);
begin
  FLineRec.ebLineDate := Value;
end;

procedure TBankStatementLine.Set_bslReference(const Value: WideString);
begin
  FLineRec.ebLineRef := Value;
end;

procedure TBankStatementLine.Set_bslValue(Value: Double);
begin
  FLineRec.ebLineValue := Value;
end;

procedure TBankStatementLine.Set_Index(Value: TBankStatementLineIndex);
begin
  inherited Set_Index(Value);
end;


function TBankStatementLine.Update: IBankStatementLine;
Var
  FLineO : TBankStatementLine;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    FLineO := TBankStatementLine.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current Account Record and Locking Details into sub-object
    FLineO.LoadDetails(FLineRec, LockPosition);
    FLineO.GLCode := FGLCode;
    FLineO.Folio := FFolio;
    LockCount := 0;
    LockPosition := 0;

    Result := FLineO;
  End; { If (FuncRes = 0) }
end;

function TBankStatementLine.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo of
    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .Delete method
    105       : Result := (FIntfType = imGeneral);
    Else
       Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }

end;

procedure TBankStatementLine.CloneDetails(const LineDets: eBankLRecType);
begin
  FLineRec := LineDets;
end;

procedure TBankStatementLine.CopyDataRecord;
begin
  Move(FBtrIntf^.LMLocCtrl^.eBankLRec, FLineRec, SizeOf(FLineRec));
end;

constructor TBankStatementLine.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IBankStatementLine, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MlocF;
  FIndex := 0;
  // Initialise variables
  FillChar (FLineRec, SizeOf(FLineRec), #0);
  FIntfType := IType;
  FToolkit := Toolkit;

  FObjectID := tkoBankStatLine;
end;

destructor TBankStatementLine.Destroy;
begin

  inherited;
end;

function TBankStatementLine.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TBankStatementLine.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, CheckStr        : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, LteBankRCode + BankStatLineKey + LJVar(DoPrefix + SearchKey, 30));
    CheckStr := KeyS;

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := LteBankRCode + BankStatLineKey + DoPrefix + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := LteBankRCode + BankStatLineKey + DoPrefix + #255;
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

      If (LMLocCtrl.RecPFix <> LteBankRCode) Or (LMLocCtrl.SubType <> BankStatLineKey) or
          (Copy(KeyS, 1, 10) <> Copy(CheckStr, 1, 10)) Then

        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankStatLineKey));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankStatLineKey) and
         (Copy(KeyS, 1, 10) = Copy(CheckStr, 1, 10)) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

 { If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (72, Result);}
end;

procedure TBankStatementLine.LoadDetails(const LineDets: eBankLRecType;
  const LockPos: Integer);
begin
  FLineRec := LineDets;

  LockCount := 1;
  LockPosition := LockPos;

end;

function TBankStatementLine.TranslateIndex(const IdxNo: SmallInt;
  const FromTLB: Boolean): SmallInt;
begin
  if IdxNo in [bslIdxLineDate..bslIdxValue] then
    Result := IdxNo
  else
  if FromTLB then
    Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the BankStatementLine object')
  else
    Raise EInvalidIndex.Create ('The BankStatementLine object is using an invalid index');
end;


function TBankStatementLine.Get_Index: TBankStatementLineIndex;
begin
  Result := Inherited Get_Index;
end;

function TBankStatementLine.ValidateSave: Integer;
begin
  Result := 0;
  if not ValidDate(FLineRec.ebLineDate) then
    Result := 30000;
end;

function TBankStatementLine.BuildLineDateIndex(
  const LineDate: WideString): WideString;
begin

end;

function TBankStatementLine.BuildLineRefIndex(
  const LineRef: WideString): WideString;
begin

end;

function TBankStatementLine.DoPrefix: string;
begin
  Result := ReverseFullNomKey(FGLCode) + ReverseFullNomKey(FFolio);
end;

function TBankStatementLine.CheckPrefix: Boolean;
begin
  with FBtrIntf^.LMLocCtrl^ do
    Result := (eBankLRec.ebLineIntRef = FFolio) and (eBankLRec.ebGLCode = FGLCode);
end;

function TBankStatementLine.Get_bslReference2: WideString;
begin
  Result := FLineRec.ebLineRef2;
end;

procedure TBankStatementLine.Set_bslReference2(const Value: WideString);
begin
  FLineRec.ebLineRef2 := Value;
end;

function TBankStatementLine.Get_bslFolio: Integer;
begin
  Result := FLineRec.ebLineIntRef;
end;

function TBankStatementLine.Get_bslLineNo: Integer;
begin
  Result := FLineRec.ebLineNo;
end;

procedure TBankStatementLine.Set_bslLineNo(Value: Integer);
begin
  FLineRec.ebLineNo := Value;
end;

function TBankStatementLine.Get_bslStatus: TBankStatementLineStatus;
begin
  Result := FLineRec.ebLineStatus;
end;

procedure TBankStatementLine.Set_bslStatus(
  Value: TBankStatementLineStatus);
begin
  FLineRec.ebLineStatus := Value;
end;

{ TBankStatement }

function TBankStatement.Add: IBankStatement;
Var
  AddO : TBankStatement;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TBankStatement.Create(imAdd, FToolkit, FBtrIntf);
  AddO.GLCode := FGLCode;
  AddO.InitNewRecord;

  Result := AddO;
end;

procedure TBankStatement.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TBankStatement.Clone: IBankStatement;
Var
  FBankO : TBankStatement;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FBankO := TBankStatement.Create(imClone, FToolkit, FBtrIntf);
  FBankO.GLCode := FGLCode;
  FBankO.CloneDetails(FStatementRec);

  Result := FBankO;
end;

function TBankStatement.Delete: Integer;
begin
  AuthoriseFunction(105, 'Delete');

  Result := FBtrIntf.LDelete_Rec(MLocF, FIndex);
  DeleteLines;
end;

function TBankStatement.Get_bsDate: WideString;
begin
  Result := FStatementRec.ebStatDate;
end;

function TBankStatement.Get_bsReference: WideString;
begin
  Result := FStatementRec.ebStatRef;
end;

function TBankStatement.Get_bsStatus: TBankStatementStatus;
begin
  Result := FStatementRec.ebStatInd;
end;

function TBankStatement.Get_Index: TBankStatementIndex;
begin
  Result := inherited Get_Index;
end;


function TBankStatement.Save: Integer;
var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  Res   : SmallInt;

begin
  AuthoriseFunction(102, 'Save');
  Result := ValidateSave;
  if Result = 0 then
  begin
    Move(FStatementRec, FBtrIntf^.LMLocCtrl^.eBankHRec, SizeOf(FStatementRec));
    if FIntfType = imAdd then
    begin
      FBtrIntf^.LMLocCtrl.RecPfix := LteBankRCode;
      FBtrIntf^.LMLocCtrl.SubType := BankStatHeadKey;
      Result := FBtrIntf^.LAdd_Rec(FFileNo, FIndex);
    end
    else
    begin
      SaveMainPos(SaveInfo);
      SaveExLocalPos(SaveInfo2);
      Res := PositionOnLock;
      Result := Put_Rec(F[FFileNo],  FFileNo, FBtrIntf^.LMlocCtrl^, FIndex);
      RestoreExLocalPos(SaveInfo2);
      RestoreMainPos(SaveInfo);
    end;

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  end;
end;

procedure TBankStatement.Set_bsDate(const Value: WideString);
begin
  FStatementRec.ebStatDate := Value;
end;

procedure TBankStatement.Set_bsReference(const Value: WideString);
begin
  FStatementRec.ebStatRef := Value;
end;

procedure TBankStatement.Set_bsStatus(Value: TBankStatementStatus);
begin
  FStatementRec.ebStatInd := Value;
end;

procedure TBankStatement.Set_Index(Value: TBankStatementIndex);
begin
  inherited Set_Index(Value);
end;

function TBankStatement.Update: IBankStatement;
Var
  FStatementO : TBankStatement;
  FuncRes   : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    FStatementO := TBankStatement.Create(imUpdate, FToolkit, FBtrIntf);

    // Pass current Account Record and Locking Details into sub-object
    FStatementO.LoadDetails(FStatementRec, LockPosition);
    FStatementO.GLCode := FGLCode;
    LockCount := 0;
    LockPosition := 0;

    Result := FStatementO;
  End; { If (FuncRes = 0) }
end;

function TBankStatement.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo of
    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    // .Delete method
    105       : Result := (FIntfType = imGeneral);
    Else
       Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }

end;

procedure TBankStatement.CloneDetails(const Details: eBankHRecType);
begin
  FStatementRec := Details;
end;

procedure TBankStatement.CopyDataRecord;
begin
  Move(FBtrIntf^.LMLocCtrl^.eBankHRec, FStatementRec, SizeOf(FStatementRec));
end;

constructor TBankStatement.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  Inherited Create (ComServer.TypeLib, IBankStatement, BtrIntf);
  // Initialise Btrieve Ancestor
  FFileNo := MlocF;
  FIndex := 0;
  // Initialise variables
  FillChar (FStatementRec, SizeOf(FStatementRec), #0);
  InitObjects;
  FIntfType := IType;
  FToolkit := Toolkit;

  FObjectID := tkoBankStatHead;
end;

destructor TBankStatement.Destroy;
begin
  InitObjects;
  inherited;
end;

function TBankStatement.Get_bsStatementLine: IBankStatementLine;
begin
  if not Assigned(FLineO) then
  begin
    FLineO := CreateTBankStatementLine (FToolkit, 51);

    FLineI := FLineO;
  end;
  FLineO.GLCode := FGLCode;
  FLineO.Folio := FStatementRec.ebIntRef;
  Result := FLineI;

end;

function TBankStatement.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TBankStatement.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
  Len : Byte;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;

    if FIndex in [0, 2] then
      Len := 30
    else
      Len := 45;

    KeyS := SetKeyString(BtrOp, LteBankRCode + BankStatHeadKey + LJVar(ReverseFullNomKey(FGLCode) + SearchKey + '!', Len));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := LteBankRCode + BankStatHeadKey + ReverseFullNomKey(FGLCode) + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := LteBankRCode + BankStatHeadKey + ReverseFullNomKey(FGLCode) + #255;
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
      If ((LMLocCtrl.RecPFix <> LteBankRCode) Or (LMLocCtrl.SubType <> BankStatHeadKey) or
          (LMLocCtrl.eBankHRec.ebAccNOM <> FGLCode)) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankStatHeadKey) or
           (LMLocCtrl.eBankHRec.ebAccNOM <> FGLCode));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = LteBankRCode) And (LMLocCtrl.SubType = BankStatHeadKey) and
      (LMLocCtrl.eBankHRec.ebAccNOM = FGLCode)Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

 { If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (72, Result);}
end;

procedure TBankStatement.LoadDetails(const Details: eBankHRecType;
  const LockPos: Integer);
begin
  FStatementRec := Details;

  LockCount := 1;
  LockPosition := LockPos;

end;

function TBankStatement.TranslateIndex(const IdxNo: SmallInt;
  const FromTLB: Boolean): SmallInt;
begin
  if IdxNo in [bsIdxDateAndFolio..bsIdxStatus] then
    Result := IdxNo
  else
  if FromTLB then
    Raise EInvalidIndex.Create ('Index ' + IntToStr(IdxNo) + ' is not valid in the BankStatement object')
  else
    Raise EInvalidIndex.Create ('The BankStatement object is using an invalid index');
end;

procedure TBankStatement.InitObjects;
begin
  FLineO := nil;
  FLineI := nil;
end;

function TBankStatement.ValidateSave: Integer;
begin
  Result := 0;
  if not ValidDate(FStatementRec.ebStatDate) then
    Result := 30000;

  if Result = 0 then
  begin
    if FIntfType = imAdd then
    begin
//      FStatementRec.ebIntRef := GetNextStatementFolio;
      FStatementRec.ebAccNOM := FGLCode;
      FStatementRec.ebHCode1 := LJVar(ReverseFullNomKey(FStatementRec.ebAccNOM) +
                                      FStatementRec.ebStatDate +
                                      ReverseFullNomKey(FStatementRec.ebIntRef) + '!', 30);

      FStatementRec.ebHCode2 := LJVar(ReverseFullNomKey(FStatementRec.ebAccNOM) +
                                      FStatementRec.ebStatRef, 45);
      FStatementRec.ebHCode3 := LJVar(ReverseFullNomKey(FStatementRec.ebAccNOM) +
                                      ReverseFullNomKey(FStatementRec.ebStatInd) + '!', 30);
    end;
  end;
end;

function TBankStatement.BuildReferenceIndex(const Reference: WideString): WideString;
begin
  Result := LJVar(Reference, 41);  //SSK 06/10/2016 2017-R1 ABSEXCH-14087:LJVar used for padding Reference to 41 characters
end;

function TBankStatement.BuildStatusIndex(Status: TBankStatementStatus): WideString;
begin
  Result := ReverseFullNomKey(Status);
end;

function TBankStatement.GetNextStatementFolio: longint;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, CheckStr        : Str255;
  Res        : longint;
  SaveInfo              : TBtrieveFileSavePos;
begin
  Result := 0;
  SaveExLocalPos(SaveInfo);
  //Do something
  KeyS := LteBankRCode + BankStatHeadKey + ReverseFullNomKey(FGLCode) + #0;
  CheckStr := KeyS;
  with FBtrIntf^ do
  begin
    Res := LFind_Rec (B_GetGEq, FFileNo, 0, KeyS);

    while (Res = 0) and (Copy(KeyS, 1, 6) = Copy(CheckStr, 1, 6)) do
    begin
      if LMLocCtrl.eBankHRec.ebIntRef > Result then
        Result := LMLocCtrl.eBankHRec.ebIntRef;

      Res := LFind_Rec (B_GetNext, FFileNo, 0, KeyS);
    end;
  end;
  RestoreExLocalPos(SaveInfo);
  Inc(Result);
end;

procedure TBankStatement.InitNewRecord;
begin
  FStatementRec.ebIntRef := GetNextStatementFolio;
end;

function TBankStatement.Get_bsFolio: Integer;
begin
  Result := FStatementRec.ebIntRef;
end;

function TBankStatement.Get_bsBalance: Double;
var
  SaveInfo : TBtrieveFileSavePos;
  Res : Integer;
  KeyS, KeyChk : Str255;
begin
  Result := 0;
  SaveExLocalPos(SaveInfo);

  with FBtrIntf^ do
  begin
    KeyS := LteBankRCode + BankStatLineKey +  ReverseFullNomKey(FGLCode) + ReverseFullNomKey(Get_bsFolio);
    KeyChk := KeyS;
    Res := LFind_Rec(B_GetGEq, MLocF, 0, KeyS);

    while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) do
    begin
      Result := Result + LMLocCtrl^.eBankLRec.ebLineValue;

      Res := LFind_Rec(B_GetNext, MLocF, 0, KeyS);
    end;
  end;
  RestoreExLocalPos(SaveInfo);
end;

function TBankStatement.BuildDateAndFolioIndex(const ADate: WideString;
  Folio: Integer): WideString;
begin
  Result := ADate + ReverseFullNomKey(Folio);
end;

procedure TBankStatement.DeleteLines;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  WhereClause : AnsiString;
begin
  with FBtrIntf^ do
  begin
    if SQLUtils.UsingSQL then
    begin
      WhereClause := GetDBColumnName('MLOCSTK.DAT', 'rec_pfix', '') + ' = ' + QuotedStr(LteBankRCode) + ' AND ' +
                     GetDBColumnName('MLOCSTK.DAT', 'sub_type', '') + ' = ' + QuotedStr(BankStatLineKey) + ' AND ' +
                     GetDBColumnName('MLOCSTK.DAT', 'eb_glcode', 'K5') + ' = ' + IntToStr(FGLCode) + ' AND ' +
                     GetDBColumnName('MLOCSTK.DAT', 'eb_line_int_ref', 'K5') + ' = ' + IntToStr(Get_bsFolio);
      DeleteRows((FToolkit as TToolkit).CompanyCode, 'MLOCSTK.DAT', WhereClause);
    end
    else
    begin
      KeyS := LteBankRCode + BankStatLineKey +  ReverseFullNomKey(FGLCode) + ReverseFullNomKey(Get_bsFolio);
      KeyChk := KeyS;
      Res := LFind_Rec(B_GetGEq, MLocF, 0, KeyS);

      while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) do
      begin
        LDelete_Rec(MLocF, 0);

        Res := LFind_Rec(B_GetGEq, MLocF, 0, KeyS);
      end;
    end;
  end;
end;

end.
