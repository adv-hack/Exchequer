unit OLoc;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     oAddr, MiscFunc, BtrvU2, ExBtTH1U, oStkLoc, GlobList, oNotes;

type
  TLocation = class(TBtrieveFunctions, ILocation, ILocation2, IBrowseInfo)
  private
    // Note: All properties protected to allow descendants access
    FLocation  : TBatchMLocRec;

    FIntfType  : TInterfaceMode;
    FParentLoc : TLocation;
    FToolkit   : TObject;

    FAddressO  : TAddress;
    FAddressI  : IAddress;

    FStkLocO   : TStockLocation;
    FStkLocI   : IStockLocation;

    FNotesO    : TNotes;
    FNotesI    : INotes;
  protected
    // ILocation
    function  Get_loCode: WideString; safecall;
    procedure Set_loCode(const Value: WideString); safecall;
    function  Get_loName: WideString; safecall;
    procedure Set_loName(const Value: WideString); safecall;
    function  Get_loAddress: IAddress; safecall;
    function  Get_loPhone: WideString; safecall;
    procedure Set_loPhone(const Value: WideString); safecall;
    function  Get_loFax: WideString; safecall;
    procedure Set_loFax(const Value: WideString); safecall;
    function  Get_loEmailAddr: WideString; safecall;
    procedure Set_loEmailAddr(const Value: WideString); safecall;
    function  Get_loModem: WideString; safecall;
    procedure Set_loModem(const Value: WideString); safecall;
    function  Get_loContact: WideString; safecall;
    procedure Set_loContact(const Value: WideString); safecall;
    function  Get_loCurrency: Smallint; safecall;
    procedure Set_loCurrency(Value: Smallint); safecall;
    function  Get_loArea: WideString; safecall;
    procedure Set_loArea(const Value: WideString); safecall;
    function  Get_loRep: WideString; safecall;
    procedure Set_loRep(const Value: WideString); safecall;
    function  Get_loTagged: WordBool; safecall;
    procedure Set_loTagged(Value: WordBool); safecall;
    function  Get_loCostCentre: WideString; safecall;
    procedure Set_loCostCentre(const Value: WideString); safecall;
    function  Get_loDepartment: WideString; safecall;
    procedure Set_loDepartment(const Value: WideString); safecall;
    function  Get_loOverrideSalesPrice: WordBool; safecall;
    procedure Set_loOverrideSalesPrice(Value: WordBool); safecall;
    function  Get_loOverrideGLCodes: WordBool; safecall;
    procedure Set_loOverrideGLCodes(Value: WordBool); safecall;
    function  Get_loOverrideCCDept: WordBool; safecall;
    procedure Set_loOverrideCCDept(Value: WordBool); safecall;
    function  Get_loOverrideSupplier: WordBool; safecall;
    procedure Set_loOverrideSupplier(Value: WordBool); safecall;
    function  Get_loOverrideBinLocation: WordBool; safecall;
    procedure Set_loOverrideBinLocation(Value: WordBool); safecall;
    function  Get_loSalesGL: Integer; safecall;
    procedure Set_loSalesGL(Value: Integer); safecall;
    function  Get_loCostOfSalesGL: Integer; safecall;
    procedure Set_loCostOfSalesGL(Value: Integer); safecall;
    function  Get_loPandLGL: Integer; safecall;
    procedure Set_loPandLGL(Value: Integer); safecall;
    function  Get_loBalSheetGL: Integer; safecall;
    procedure Set_loBalSheetGL(Value: Integer); safecall;
    function  Get_loWIPGL: Integer; safecall;
    procedure Set_loWIPGL(Value: Integer); safecall;
    function  Get_loStockList: IStockLocation; safecall;

    function Get_loPurchaseReturnGL: Integer; safecall;
    procedure Set_loPurchaseReturnGL(Value: Integer); safecall;
    function Get_loSalesReturnGL: Integer; safecall;
    procedure Set_loSalesReturnGL(Value: Integer); safecall;

    function Get_loWOPFinishedWIPGL: Integer; safecall;
    procedure Set_loWOPFinishedWIPGL(Value: Integer); safecall;
    function Get_loNotes: INotes; safecall;
    function Get_loOverrideCostPrice: WordBool; safecall;
    procedure Set_loOverrideCostPrice(Value: WordBool); safecall;
    function Get_loOverrideReorderPrice: WordBool; safecall;
    procedure Set_loOverrideReorderPrice(Value: WordBool); safecall;


    function  Get_Index: TLocationIndex; safecall;
    procedure Set_Index(Value: TLocationIndex); safecall;

    function  BuildCodeIndex(const Code: WideString): WideString; safecall;
    function  BuildNameIndex(const Name: WideString): WideString; safecall;

    function  Add: ILocation; safecall;
    function  Update: ILocation; safecall;
    function  Clone: ILocation; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    //PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
    function GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
    Procedure SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //PR: 22/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;

    // Local Methods
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CloneDetails (Const LocDets : TBatchMLocRec);
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Procedure InitNewLocation;
    Procedure InitObjects;
    Procedure LoadDetails (Const LocDets : TBatchMLocRec; Const LockPos : LongInt);
  public
    Constructor Create (Const IType     : TInterfaceMode;
                        Const Toolkit   : TObject;
                        Const ParentLoc : TLocation;
                        Const BtrIntf   : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Function GetCloneInterface (Const LocCode : ShortString) : ILocation;
  End; { TGeneralLedger }


Function CreateTLocation (Const ClientId : Integer; Const Toolkit : TObject) : TLocation;

implementation

uses ComServ, DLLSK01U, DllErrU, BtKeys1U, EtStrU, oToolkit, SQLStructuresU, TKSQL;

{-------------------------------------------------------------------------------------------------}

Function CreateTLocation (Const ClientId : Integer; Const Toolkit : TObject) : TLocation;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTLocation }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TAccount object
  BtrIntf^.Open_System(MLocF, MLocF);
  BtrIntf^.Open_System(PwrdF,  PwrdF);   { Notes }

  // Create bas TAccount object
  Result := TLocation.Create(imGeneral, Toolkit, Nil, BtrIntf);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF, PwrdF]);

End; { CreateTLocation }

{-------------------------------------------------------------------------------------------------}

Constructor TLocation.Create (Const IType     : TInterfaceMode;
                              Const Toolkit   : TObject;
                              Const ParentLoc : TLocation;
                              Const BtrIntf   : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ILocation2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MLocF;

  // Initialise variables
  FillChar (FLocation, SizeOf(FLocation), #0);
  with Toolkit as TToolkit do
    if EnterpriseI.enCurrencyVersion > enProfessional then
      FLocation.loCurrency := 1;
  InitObjects;

  // Setup Link for child GL objects to parent GL object
  FIntfType := IType;
  FToolkit := Toolkit;
  If Assigned(ParentLoc) Then Begin
    FParentLoc := ParentLoc;
    FIndex := FParentLoc.FIndex;
  End { If Assigned(ParentLoc) }
  Else Begin
    FParentLoc := Self;
    Set_Index(loIdxCode);
  End; { Else }
  FObjectID := tkoMLoc;
End; { Create }

{-----------------------------------------}

Destructor TLocation.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TLocation.InitObjects;
Begin { InitObjects }
  FAddressO := Nil;
  FAddressI := Nil;

  FStkLocO := Nil;
  FStkLocI := Nil;

  FParentLoc := Nil;
  FToolkit := Nil;
End; { InitObjects }

{-----------------------------------------}
//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
function TLocation.GetAddrLine (AddrIdx, Idx : Byte; DirectToLines : Boolean = True) : String;
begin
  Result := FLocation.loAddr[Idx];
end;

//PR: 15/10/2013 MRD 2.5.18 Add DirectToLines default parameter
Procedure TLocation.SetAddrLine(AddrIdx, Idx : Byte; Value : String; DirectToLines : Boolean = True);
begin
  FLocation.loAddr[Idx] := Value;
end;

function TLocation.Get_loAddress: IAddress;
begin
  If (Not Assigned(FAddressO)) Then Begin
    { Create and initialise Customer Address Sub-Object}
    FAddressO := TAddress.Create(1, GetAddrLine, SetAddrLine);

    FAddressI := FAddressO;
  End; { If (Not Assigned(FAddressO)) }

  Result := FAddressI;
end;

{-----------------------------------------}

function TLocation.Get_loArea: WideString;
begin
  Result := FLocation.loArea;
end;

procedure TLocation.Set_loArea(const Value: WideString);
begin
  FLocation.loArea := Value;
end;

{-----------------------------------------}

function TLocation.Get_loBalSheetGL: Integer;
begin
  Result := FLocation.loNominal[4];
end;

procedure TLocation.Set_loBalSheetGL(Value: Integer);
begin
  FLocation.loNominal[4] := Value;
end;

{-----------------------------------------}

function TLocation.Get_loCode: WideString;
begin
  Result := FLocation.loCode;
end;

procedure TLocation.Set_loCode(const Value: WideString);
begin
  FLocation.loCode := LJVar(UpperCase(Copy(Value, 1, 3)), MLocKeyLen);
end;

{-----------------------------------------}

function TLocation.Get_loContact: WideString;
begin
  Result := FLocation.loContact;
end;

procedure TLocation.Set_loContact(const Value: WideString);
begin
  FLocation.loContact := Value;
end;

{-----------------------------------------}

function TLocation.Get_loCostCentre: WideString;
begin
  Result := FLocation.loCC;
end;

procedure TLocation.Set_loCostCentre(const Value: WideString);
begin
  FLocation.loCC := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TLocation.Get_loCostOfSalesGL: Integer;
begin
  Result := FLocation.loNominal[2];
end;

procedure TLocation.Set_loCostOfSalesGL(Value: Integer);
begin
  FLocation.loNominal[2] := Value;
end;

{-----------------------------------------}

function TLocation.Get_loCurrency: Smallint;
begin
  Result := FLocation.loCurrency;
end;

procedure TLocation.Set_loCurrency(Value: Smallint);
begin
  FLocation.loCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TLocation.Get_loDepartment: WideString;
begin
  Result := FLocation.loDep;
end;

procedure TLocation.Set_loDepartment(const Value: WideString);
begin
  FLocation.loDep := FullCCDepKey(UpperCase(Value));
end;

{-----------------------------------------}

function TLocation.Get_loEmailAddr: WideString;
begin
  Result := FLocation.loEmail;
end;

procedure TLocation.Set_loEmailAddr(const Value: WideString);
begin
  FLocation.loEmail := Value;
end;

{-----------------------------------------}

function TLocation.Get_loFax: WideString;
begin
  Result := FLocation.loFax;
end;

procedure TLocation.Set_loFax(const Value: WideString);
begin
  FLocation.loFax := Value;
end;

{-----------------------------------------}

function TLocation.Get_loModem: WideString;
begin
  Result := FLocation.loModem;
end;

procedure TLocation.Set_loModem(const Value: WideString);
begin
  FLocation.loModem := Value;
end;

{-----------------------------------------}

function TLocation.Get_loName: WideString;
begin
  Result := FLocation.loName;
end;

procedure TLocation.Set_loName(const Value: WideString);
begin
  FLocation.loName := LJVar(Value, MLDescKeyLen);
end;

{-----------------------------------------}

function TLocation.Get_loOverrideBinLocation: WordBool;
begin
  Result := FLocation.loUseBinLoc;
end;

procedure TLocation.Set_loOverrideBinLocation(Value: WordBool);
begin
  FLocation.loUseBinLoc := Value;
end;

{-----------------------------------------}

function TLocation.Get_loOverrideCCDept: WordBool;
begin
  Result := FLocation.loUseCCDep;
end;

procedure TLocation.Set_loOverrideCCDept(Value: WordBool);
begin
  FLocation.loUseCCDep := Value;
end;

{-----------------------------------------}

function TLocation.Get_loOverrideGLCodes: WordBool;
begin
  Result := FLocation.loUseNom;
end;

procedure TLocation.Set_loOverrideGLCodes(Value: WordBool);
begin
  FLocation.loUseNom := Value;
end;

{-----------------------------------------}

function TLocation.Get_loOverrideSalesPrice: WordBool;
begin
  Result := FLocation.loUsePrice;
end;

procedure TLocation.Set_loOverrideSalesPrice(Value: WordBool);
begin
  FLocation.loUsePrice := Value;
end;

{-----------------------------------------}

function TLocation.Get_loOverrideSupplier: WordBool;
begin
  Result := FLocation.loUseSupp;
end;

procedure TLocation.Set_loOverrideSupplier(Value: WordBool);
begin
  FLocation.loUseSupp := Value;
end;

{-----------------------------------------}

function TLocation.Get_loPandLGL: Integer;
begin
  Result := FLocation.loNominal[3];
end;

procedure TLocation.Set_loPandLGL(Value: Integer);
begin
  FLocation.loNominal[3] := Value;
end;

{-----------------------------------------}

function TLocation.Get_loPhone: WideString;
begin
  Result := FLocation.loTel;
end;

procedure TLocation.Set_loPhone(const Value: WideString);
begin
  FLocation.loTel := Value;
end;

{-----------------------------------------}

function TLocation.Get_loRep: WideString;
begin
  Result := FLocation.loRep;
end;

procedure TLocation.Set_loRep(const Value: WideString);
begin
  FLocation.loRep := Value;
end;

{-----------------------------------------}

function TLocation.Get_loSalesGL: Integer;
begin
  Result := FLocation.loNominal[1];
end;

procedure TLocation.Set_loSalesGL(Value: Integer);
begin
  FLocation.loNominal[1] := Value;
end;

{-----------------------------------------}

function TLocation.Get_loTagged: WordBool;
begin
  Result := FLocation.loTag;
end;

procedure TLocation.Set_loTagged(Value: WordBool);
begin
  FLocation.loTag := Value;
end;

{-----------------------------------------}

function TLocation.Get_loWIPGL: Integer;
begin
  Result := FLocation.loNominal[5];
end;

procedure TLocation.Set_loWIPGL(Value: Integer);
begin
  FLocation.loNominal[5] := Value;
end;

{-----------------------------------------}

function TLocation.Get_Index: TLocationIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TLocation.Set_Index(Value: TLocationIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

function TLocation.Get_loStockList: IStockLocation;
begin
  AuthoriseFunction(201, 'loStockList');

  If (Not Assigned(FStkLocO)) Then Begin
    { Create and initialise Stock-Location Sub-Object}
    FStkLocO := CreateTStockLocation (9, FToolkit, StkKeyLen, 1);

    FStkLocI := FStkLocO;
  End; { If (Not Assigned(FStkLocO)) }

  FStkLocO.SetStartKey (LJVar(UpperCase(FLocation.loCode), MLocKeyLen));

  Result := FStkLocI;
end;

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TLocation.AuthoriseFunction (Const FuncNo     : Byte;
                                      Const MethodName : String;
                                      Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as MLocF is shared file }

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

    // .loStockList property
    201       : Result := (FIntfType In [imGeneral, imUpdate, imClone]);

    // .loNotes property
    202       : Result := (FIntfType In [imGeneral]);

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

Procedure TLocation.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExLocToTKLoc (FBtrIntf^.LMLocCtrl.MLocLoc, FLocation);
End; { CopyDataRecord }

{-----------------------------------------}

Function TLocation.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  With FBtrIntf^ Do Begin
    // General index including Location, StkLoc, AltStk, Telesales, etc... records

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, CostCCode + CSubCode[True] + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := CostCCode + CSubCode[True] + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := CostCCode + CSubCode[True] + #255;
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
      If ((LMLocCtrl.RecPFix <> CostCCode) Or (LMLocCtrl.SubType <> CSubCode[True])) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LMLocCtrl.RecPFix = CostCCode) And (LMLocCtrl.SubType = CSubCode[True]));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMLocCtrl.RecPFix = CostCCode) And (LMLocCtrl.SubType = CSubCode[True]) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (72, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TLocation.BuildCodeIndex(const Code: WideString): WideString;
begin
  Result := LJVar(UpperCase(Copy(Code, 1, 3)), MLocKeyLen);
end;

function TLocation.BuildNameIndex(const Name: WideString): WideString;
begin
  Result := LJVar(Name, MLDescKeyLen);
end;

{-----------------------------------------}

Procedure TLocation.InitNewLocation;
Begin { InitNewLocation }
  FillChar (FLocation, SizeOf(FLocation), #0);
  With FLocation Do Begin

  End; { With FLocation }
End; { InitNewLocation }

{-----------------------------------------}

function TLocation.Add: ILocation;
Var
  AddO : TLocation;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TLocation.Create(imAdd, FToolkit, FParentLoc, FBtrIntf);
  AddO.InitNewLocation;

  Result := AddO;
end;

{-----------------------------------------}

procedure TLocation.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

Function TLocation.GetCloneInterface (Const LocCode : ShortString) : ILocation;
Var
  SaveInfo : TBtrieveFileSavePos;
  lLocCode : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
  lLocCode := BuildCodeIndex(LocCode);

  // Check not blank
  If (Trim(lLocCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FLocation, SizeOf(FLocation));

    // Find record for AcCode
    Set_Index(loIdxCode);
    Res := GetDataRecord (B_GetEq, lLocCode);
    If (Res = 0) Then
      // Got Record - generate and return a Clone interface
      Result := Clone;

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FLocation, SizeOf(FLocation));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

{-----------------------------------------}

Procedure TLocation.CloneDetails (Const LocDets : TBatchMLocRec);
begin
  FLocation := LocDets;
end;

{-----------------------------------------}

function TLocation.Clone: ILocation;
Var
  CloneO : TLocation;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Customer Account object and initialise
  CloneO := TLocation.Create(imClone, FToolkit, FParentLoc, FBtrIntf);
  CloneO.CloneDetails(FLocation);

  Result := CloneO;
end;

{-----------------------------------------}

function TLocation.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
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
    // Add/Update Location
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreLocation(@FLocation,             // P
                            SizeOf (FLocation),    // PSIZE
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

Procedure TLocation.LoadDetails (Const LocDets : TBatchMLocRec; Const LockPos : LongInt);
begin
  FLocation := LocDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TLocation.Update: ILocation;
Var
  UpdateO : TLocation;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TLocation.Create(imUpdate, FToolkit, FParentLoc, FBtrIntf);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FLocation, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

function TLocation.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TLocation.Get_loPurchaseReturnGL: Integer;
begin
  Result := FLocation.loPurchRetGL;
end;

function TLocation.Get_loSalesReturnGL: Integer;
begin
  Result := FLocation.loSalesRetGL;
end;

procedure TLocation.Set_loPurchaseReturnGL(Value: Integer);
begin
  FLocation.loPurchRetGL := Value;
end;

procedure TLocation.Set_loSalesReturnGL(Value: Integer);
begin
  FLocation.loSalesRetGL := Value;
end;

function TLocation.Get_loWOPFinishedWIPGL: Integer;
begin
  Result := FLocation.loWOPWIPGL;
end;

function TLocation.Get_loNotes: INotes;
begin
  AuthoriseFunction(202, 'loNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'LOC',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FLocation.loCode, NoteTCode + NoteLCode + FullNCode(FLocation.loCode));

  Result := FNotesI;
end;

procedure TLocation.Set_loWOPFinishedWIPGL(Value: Integer);
begin
  FLocation.loWOPWIPGL := Value;
end;

function TLocation.Get_loOverrideCostPrice: WordBool;
begin
  Result := FLocation.loUseCPrice;
end;

function TLocation.Get_loOverrideReorderPrice: WordBool;
begin
  Result := FLocation.loUseRPrice;
end;

procedure TLocation.Set_loOverrideCostPrice(Value: WordBool);
begin
  FLocation.loUseCPrice := Value;
end;

procedure TLocation.Set_loOverrideReorderPrice(Value: WordBool);
begin
  FLocation.loUseRPrice := Value;
end;

function TLocation.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TLocationRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LMLocCtrl.RecPfix := 'C';
    FBtrIntf^.LMLocCtrl.SubType := 'C';
    FBtrIntf^.LMLocCtrl.MLocLoc.loCode := DataRec.loCode;
    FBtrIntf^.LMLocCtrl.MLocLoc.loName := DataRec.loName;
    Move(DataRec.loAddr, FBtrIntf^.LMLocCtrl.MLocLoc.loAddr, SizeOf(DataRec) - (BtKeyPos(@DataRec.loAddr, @DataRec) - 1));


    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TLocation.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if not UsingRedirectCache then
  begin
    FSQLRedirect := TSQLRedirect.Create;
    FSQLRedirect.FileNo := F_LOCATION;
    FSQLRedirect.WhereClause := FullQuery;;
    FSQLRedirect.FieldList := FColumns;
    FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
    Result := FSQLRedirect.Open;
  end;
end;

end.
