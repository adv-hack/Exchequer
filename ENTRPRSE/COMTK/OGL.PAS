unit oGL;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     VarCnst3, oBtrieve, MiscFunc, BtrvU2, ExBtTH1U, GlobList;

type
  TGeneralLedger = class(TBtrieveFunctions, IGeneralLedger, IGeneralLedger2, IGeneralLedger3, IBrowseInfo)
  private
    // Note: All properties protected to allow descendants access
    FGL       : TBatchNomRec;

    FIntfType : TInterfaceMode;
    FParentGL : TGeneralLedger;

  protected
    // IGeneralLedger
    function  Get_glCode: Integer; safecall;
    procedure Set_glCode(Value: Integer); safecall;
    function  Get_glName: WideString; safecall;
    procedure Set_glName(const Value: WideString); safecall;
    function  Get_glParent: Integer; safecall;
    procedure Set_glParent(Value: Integer); safecall;
    function  Get_glType: TGeneralLedgerType; safecall;
    procedure Set_glType(Value: TGeneralLedgerType); safecall;
    function  Get_glAltCode: WideString; safecall;
    procedure Set_glAltCode(const Value: WideString); safecall;
    function  Get_glPage: WordBool; safecall;
    procedure Set_glPage(Value: WordBool); safecall;
    function  Get_glSubtotal: WordBool; safecall;
    procedure Set_glSubtotal(Value: WordBool); safecall;
    function  Get_glTotal: WordBool; safecall;
    procedure Set_glTotal(Value: WordBool); safecall;
    function  Get_glCarryFwd: Integer; safecall;
    procedure Set_glCarryFwd(Value: Integer); safecall;
    function  Get_glRevalue: WordBool; safecall;
    procedure Set_glRevalue(Value: WordBool); safecall;
    function  Get_glCurrency: Smallint; safecall;
    procedure Set_glCurrency(Value: Smallint); safecall;
    function  Get_glParentI: IGeneralLedger; safecall;
    function Get_glClass: TGeneralLedgerClass; safecall;
    procedure Set_glClass(Value: TGeneralLedgerClass); safecall;
    function Get_glInactive: WordBool; safecall;
    procedure Set_glInactive(Value: WordBool); safecall;
    function Get_glForceJobCode: WordBool; safecall;
    procedure Set_glForceJobCode(Value: WordBool); safecall;

    function  BuildCodeIndex(GLCode: Integer): WideString; safecall;
    function  BuildNameIndex(const Name: WideString): WideString; safecall;
    function  BuildParentIndex(ParentCode: Integer; ChildCode: Integer): WideString; safecall;
    function  BuildAltCodeIndex(const AltCode: WideString): WideString; safecall;

    function BuildCodeStringIndex(glCode: Integer): WideString; safecall;

    function  Get_Index: TGeneralLedgerIndex; safecall;
    procedure Set_Index(Value: TGeneralLedgerIndex); safecall;

    function  Add: IGeneralLedger; safecall;
    function  Update: IGeneralLedger; safecall;
    function  Clone: IGeneralLedger; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local Methods
    Procedure CloneDetails (Const GLDets : TBatchNomRec);
    Function  GetCloneInterface (Const GLCode : LongInt) : IGeneralLedger;
    Procedure InitNewGLCode;
    Procedure InitObjects;
    Procedure LoadDetails (Const GLDets : TBatchNomRec; Const LockPos : LongInt);
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const ParentGL : TGeneralLedger;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
  End; { TGeneralLedger }


Function CreateTGeneralLedger (Const ClientId : Integer) : TGeneralLedger;

implementation

uses ComServ, DLL01U, DllErrU, BtKeys1U, BTSupU1, EtStrU, SQLFields;

{-------------------------------------------------------------------------------------------------}

Function CreateTGeneralLedger (Const ClientId : Integer) : TGeneralLedger;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTGeneralLedger }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TAccount object
  BtrIntf^.Open_System(NomF, NomF);

  // Create bas TAccount object
  Result := TGeneralLedger.Create(imGeneral, Nil, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([NomF]);

End; { CreateTGeneralLedger }

{-------------------------------------------------------------------------------------------------}

Constructor TGeneralLedger.Create (Const IType    : TInterfaceMode;
                                   Const ParentGL : TGeneralLedger;
                                   Const BtrIntf  : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IGeneralLedger3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FFileNo := NomF;

  // Initialise variables
  FillChar (FGL, SizeOf(FGL), #0);
  InitObjects;

  // Setup Link for child GL objects to parent GL object
  FIntfType := IType;
  If Assigned(ParentGL) Then Begin
    FParentGL := ParentGL;
    FIndex := FParentGL.FIndex;
  End { If Assigned(ParentGL) }
  Else Begin
    FParentGL := Self;
    Set_Index(glIdxCode);
  End; { Else }

  FObjectID := tkoNominal;
  FWhereClause := '';
End; { Create }

{-----------------------------------------}

Destructor TGeneralLedger.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TGeneralLedger.InitObjects;
Begin { Destroy }
  FParentGL := Nil;
End; { Destroy }

{-----------------------------------------}

Function TGeneralLedger.AuthoriseFunction (Const FuncNo     : Byte;
                                           Const MethodName : String;
                                           Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // TBtrieveFunctions
    1..99     : Result := (FIntfType = imGeneral);

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
End; { AuthoriseFunction }

{-----------------------------------------}

Procedure TGeneralLedger.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExNomToTKNom(FBtrIntf^.LNom, FGL);
End; { CopyDataRecord }

{-----------------------------------------}

Function TGeneralLedger.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  KeyS      : Str255;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';


  With FBtrIntf^ Do Begin
    KeyS := SetKeyString(BtrOp, SearchKey);
    BtrOpCode := BtrOp;

    // Get record
    Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

    If (Result = 0) Then
      // Convert to Toolkit structure
      CopyDataRecord;

    FKeyString := KeyS;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (44, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TGeneralLedger.Get_glCode: Integer;
begin
  Result := FGL.NomCode;
end;

procedure TGeneralLedger.Set_glCode(Value: Integer);
begin
  FGL.NomCode := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glAltCode: WideString;
begin
  Result := FGL.AltCode;
end;

procedure TGeneralLedger.Set_glAltCode(const Value: WideString);
begin
  FGL.AltCode := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glCarryFwd: Integer;
begin
  Result := FGL.CarryF;
end;

procedure TGeneralLedger.Set_glCarryFwd(Value: Integer);
begin
  FGL.CarryF := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glCurrency: Smallint;
begin
  Result := FGL.DefCurr;
end;

procedure TGeneralLedger.Set_glCurrency(Value: Smallint);
begin
  FGL.DefCurr := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TGeneralLedger.Get_glName: WideString;
begin
  Result := FGL.Desc;
end;

procedure TGeneralLedger.Set_glName(const Value: WideString);
begin
  FGL.Desc := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glPage: WordBool;
begin
  Result := FGL.NomPage;
end;

procedure TGeneralLedger.Set_glPage(Value: WordBool);
begin
  FGL.NomPage := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glParent: Integer;
begin
  Result := FGL.Cat;
end;

procedure TGeneralLedger.Set_glParent(Value: Integer);
begin
  FGL.Cat := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glRevalue: WordBool;
begin
  Result := FGL.Revalue;
end;

procedure TGeneralLedger.Set_glRevalue(Value: WordBool);
begin
  FGL.Revalue := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glSubtotal: WordBool;
begin
  Result := FGL.SubType;
end;

procedure TGeneralLedger.Set_glSubtotal(Value: WordBool);
begin
  FGL.SubType := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glTotal: WordBool;
begin
  Result := FGL.Total;
end;

procedure TGeneralLedger.Set_glTotal(Value: WordBool);
begin
  FGL.Total := Value;
end;

{-----------------------------------------}

function TGeneralLedger.Get_glType: TGeneralLedgerType;
begin
  Case FGL.NomType Of
    'A' : Result := glTypeProfitLoss;
    'B' : Result := glTypeBalanceSheet;
    'C' : Result := glTypeControl;
    'F' : Result := glTypeCarryFwd;
    'H' : Result := glTypeHeading;
  Else
    Raise EUnknownValue.Create ('Invalid General Ledger Type (' + FGL.NomType + ')');
  End; { Case FGL.NomType }
end;

procedure TGeneralLedger.Set_glType(Value: TGeneralLedgerType);
begin
  Case Value Of
    glTypeProfitLoss   : FGL.NomType := 'A';
    glTypeBalanceSheet : FGL.NomType := 'B';
    glTypeControl      : FGL.NomType := 'C';
    glTypeCarryFwd     : FGL.NomType := 'F';
    glTypeHeading      : FGL.NomType := 'H';
  Else
    Raise EUnknownValue.Create ('Invalid General Ledger Type (' + IntToStr(Ord(Value)) + ')');
  End; { Case Value }
end;

{-----------------------------------------}

function TGeneralLedger.Get_Index: TGeneralLedgerIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TGeneralLedger.Set_Index(Value: TGeneralLedgerIndex);
begin
  Inherited Set_Index (Value);
end;

{-------------------------------------------------------------------------------------------------}

Procedure TGeneralLedger.InitNewGLCode;
Begin { InitNewGLCode }
  FillChar (FGL, SizeOf(FGL), #0);
  With FGL Do Begin
    NomType := 'H';
  End; { With FGL }
End; { InitNewGLCode }

{-----------------------------------------}

function TGeneralLedger.Add: IGeneralLedger;
Var
  AddO : TGeneralLedger;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TGeneralLedger.Create(imAdd, FParentGL, FBtrIntf);
  AddO.InitNewGLCode;

  Result := AddO;
end;

{-----------------------------------------}

procedure TGeneralLedger.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

Procedure TGeneralLedger.CloneDetails (Const GLDets : TBatchNomRec);
begin
  FGL := GLDets;
end;

{-----------------------------------------}

function TGeneralLedger.Clone: IGeneralLedger;
Var
  CloneO : TGeneralLedger;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Customer Account object and initialise
  CloneO := TGeneralLedger.Create(imClone, FParentGL, FBtrIntf);
  CloneO.CloneDetails(FGL);

  Result := CloneO;
end;

{-----------------------------------------}

function TGeneralLedger.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  BtrOp, Res  : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update GL Code
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreGLAccount(@FGL,                  // P
                             SizeOf (FGL),          // PSIZE
                             FIndex,                // SEARCHPATH
                             BtrOp);                // SEARCHMODE
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

{-----------------------------------------}

Procedure TGeneralLedger.LoadDetails (Const GLDets : TBatchNomRec; Const LockPos : LongInt);
begin
  FGL := GLDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TGeneralLedger.Update: IGeneralLedger;
Var
  UpdateO : TGeneralLedger;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TGeneralLedger.Create(imUpdate, FParentGL, FBtrIntf);

    // Pass current Account Record and Locking Details into sub-object
    UpdateO.LoadDetails(FGL, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

Function TGeneralLedger.GetCloneInterface (Const GLCode : LongInt) : IGeneralLedger;
Var
  SaveInfo : TBtrieveFileSavePos;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Check GL Code is set
  If (GLCode <> 0) Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FGL, SizeOf(FGL));

    // Find record for GL Code
    Res := GetDataRecord (B_GetEq, BuildCodeIndex(GLCode));
    If (Res = 0) Then Begin
      // Got Record - generate and return a Clone interface
      Result := Clone;
    End; { If (Res = 0) }

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FGL, SizeOf(FGL));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

{-----------------------------------------}

function TGeneralLedger.Get_glParentI: IGeneralLedger;
begin
  Result := FParentGL.GetCloneInterface(FGL.Cat);
end;

{-----------------------------------------}

function TGeneralLedger.BuildCodeIndex(GLCode: Integer): WideString;
begin
  Result := FullNomKey(GLCode);
end;

{-----------------------------------------}

function TGeneralLedger.BuildAltCodeIndex(const AltCode: WideString): WideString;
begin
  Result := UpperCase(Copy(AltCode, 1, 50));
end;

{-----------------------------------------}

function TGeneralLedger.BuildNameIndex(const Name: WideString): WideString;
begin
  Result := Copy(Name, 1, 40);
end;

{-----------------------------------------}

function TGeneralLedger.BuildParentIndex(ParentCode, ChildCode: Integer): WideString;
begin
  Result := FullNomKey(ParentCode) + FullNomKey(ChildCode);
end;

function TGeneralLedger.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TGeneralLedger.Get_glClass: TGeneralLedgerClass;
begin
  Result := FGL.NomClass div 10;
end;

procedure TGeneralLedger.Set_glClass(Value: TGeneralLedgerClass);
begin
  if (Value <= glcPurchaseReturns) then
    FGL.NomClass := Value * 10
  else
    raise EUnknownValue.Create ('Invalid General Ledger Class (' + IntToStr(Ord(Value)) + ')');
end;

function TGeneralLedger.Get_glInactive: WordBool;
begin
  Result := FGL.Inactive;
end;

procedure TGeneralLedger.Set_glInactive(Value: WordBool);
begin
  FGL.Inactive := Value;
end;

function TGeneralLedger.Get_glForceJobCode: WordBool;
begin
  Result := FGL.ForceJC;
end;

procedure TGeneralLedger.Set_glForceJobCode(Value: WordBool);
begin
  FGL.ForceJC := Value;
end;

function TGeneralLedger.BuildCodeStringIndex(glCode: Integer): WideString;
begin
  Result := LJVar(IntToStr(glCode), 20);
end;

end.
