unit oAltStk;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
      VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, oNotes, ExBtTH1U, GlobList, VarRec2U;

type

  TAltStockCode = class(TBtrieveFunctions, IAltStockCode, IAltStockCode2, IBrowseInfo)
  protected
    FAltStkRec : TBatchSKAltRec;
    FToolkit : TObject;
    FIntfType : TInterfaceMode;
    FStockFolio : longint;
    FNotesO         : TNotes;
    FNotesI         : INotes;
    procedure InitObjects;
    function Get_ascAcCode: WideString; safecall;
    procedure Set_ascAcCode(const Value: WideString); safecall;
    function Get_ascAltCode: WideString; safecall;
    procedure Set_ascAltCode(const Value: WideString); safecall;
    function Get_ascAltDesc: WideString; safecall;
    procedure Set_ascAltDesc(const Value: WideString); safecall;
    function Get_ascReorderPrice: Double; safecall;
    procedure Set_ascReorderPrice(Value: Double); safecall;
    function Get_ascReorderCurrency: Integer; safecall;
    procedure Set_ascReorderCurrency(Value: Integer); safecall;
    function Get_ascUseReorderPrice: WordBool; safecall;
    procedure Set_ascUseReorderPrice(Value: WordBool); safecall;
    function Get_ascNotes: INotes; safecall;
    function Get_ascLastDateUsed: WideString; safecall;
    function Get_ascLastTimeUsed: WideString; safecall;
    function BuildCodeIndex(const Code: WideString): WideString; safecall;

    function Get_ascUseReorderQty: WordBool; safecall;
    procedure Set_ascUseReorderQty(Value: WordBool); safecall;
    function Get_ascReorderQty: Double; safecall;
    procedure Set_ascReorderQty(Value: Double); safecall;
    function Get_ascUseReplacementQty: WordBool; safecall;
    procedure Set_ascUseReplacementQty(Value: WordBool); safecall;
    function Get_ascReplacementQty: Double; safecall;
    procedure Set_ascReplacementQty(Value: Double); safecall;
    function Get_ascDisplayOrder: Integer; safecall;
    procedure Set_ascDisplayOrder(Value: Integer); safecall;


    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;
    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    function  Add: IAltStockCode; safecall;
    function  Update: IAltStockCode; safecall;
    function  Clone: IAltStockCode; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;
    function Delete : integer; safecall;

    procedure LoadDetails(const StkA : TBatchSKAltRec; const LockPos : LongInt);
    procedure CloneDetails(const StkA : TBatchSKAltRec);

    procedure SetStockFolio(Value : longint);
    procedure SetStockCode(Value : ShortString);

    procedure SetSQLCaching(SubType : Char = ' '); override;


  public
    Constructor Create (Const IType      : TInterfaceMode;
                        Const Toolkit    : TObject;
                        const StkFolio   : longint;
                        const StkCode    : string;
                        Const BtrIntf    : TCtkTdPostExLocalPtr;
                        Const RecType    : Char);
    Destructor Destroy; override;
    Function GetCloneInterface (AFolio, SFolio : longint) : IAltStockCode;
    property StockFolio : longint write SetStockFolio;

    // HM 10/09/04: Added StockCode property because otherwise new AltStk items are
    // created using the Stock Code that was passed into the constructor
    property StockCode : ShortString Write SetStockCode;
  end;

  Function CreateTAltStockCode  (Const ClientId       : Integer;
                                 Const Toolkit        : TObject;
                                 Const StkFolio       : longint;
                                 const StkCode        : string) : TAltStockCode;


implementation

uses
  DLLSK01U, ComServ, BtKeys1U, BtSupU1, DllErrU, oToolkit, EtStrU;

Function CreateTAltStockCode  (Const ClientId       : Integer;
                               Const Toolkit        : TObject;
                               Const StkFolio       : longint;
                               const StkCode        : string) : TAltStockCode;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
  RecType : Char;
Begin { CreateTStockLocation }
  RecType := #0;
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by Stock-Location object
  BtrIntf^.Open_System(MLocF, MLocF);
  BtrIntf^.Open_System(PwrdF, PwrdF);

  Case ClientID of
    36  : RecType := NoteCCode;
    45  : RecType := '1';
    46  : RecType := '2';
    47  : RecType := '3';
  end;


  // Create base TStockLocation object
  Result := TAltStockCode.Create(imGeneral, Toolkit, StkFolio, StkCode, BtrIntf, RecType);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF, PwrdF]);

End; { CreateTStockLocation }


Constructor TAltStockCode.Create (Const IType      : TInterfaceMode;
                                  Const Toolkit    : TObject;
                                  const StkFolio   : longint;
                                  const StkCode    : string;
                                  Const BtrIntf    : TCtkTdPostExLocalPtr;
                                  Const RecType    : Char);
begin
  Inherited Create (ComServer.TypeLib, IAltStockCode2, BtrIntf);

  InitObjects;

  FAltStkRec.RecType := RecType;
  FToolkit := Toolkit;
  FIntfType := IType;
  FStockFolio := StkFolio;
  FAltStkRec.StockCode := StkCode;
  if TToolkit(FToolkit).SystemSetupI.ssCurrencyVersion = enProfessional then
    FAltStkRec.ROCurr := 0
  else
    FAltStkRec.ROCurr := 1;

  FFileNo := MLocF;
  FIndex := 1;

  FBtrIntf := BtrIntf;
  FObjectID := tkoAltStock;
end;

Destructor TAltStockCode.Destroy;
begin
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  Inherited;
end;

procedure TAltStockCode.InitObjects;
begin
  FNotesO := nil;
  FNotesI := nil;
end;

function TAltStockCode.Get_ascAcCode: WideString;
begin
  Result := FAltStkRec.SuppCode;
end;

procedure TAltStockCode.Set_ascAcCode(const Value: WideString);
begin
  FAltStkRec.SuppCode := Value;
end;

function TAltStockCode.Get_ascAltCode: WideString;
begin
  Result := FAltStkRec.AltCode;
end;

procedure TAltStockCode.Set_ascAltCode(const Value: WideString);
begin
  FAltStkRec.AltCode := Value;
end;

function TAltStockCode.Get_ascAltDesc: WideString;
begin
  Result := FAltStkRec.AltDesc;
end;

procedure TAltStockCode.Set_ascAltDesc(const Value: WideString);
begin
  FAltStkRec.AltDesc := Value;
end;

function TAltStockCode.Get_ascReorderPrice: Double;
begin
  Result := FAltStkRec.ROPrice;
end;

procedure TAltStockCode.Set_ascReorderPrice(Value: Double);
begin
  FAltStkRec.ROPrice := Value;
end;

function TAltStockCode.Get_ascReorderCurrency: Integer;
begin
  Result := FAltStkRec.ROCurr;
end;

procedure TAltStockCode.Set_ascReorderCurrency(Value: Integer);
begin
  FAltStkRec.ROCurr := Value;
end;

function TAltStockCode.Get_ascUseReorderPrice: WordBool;
begin
  Result := FAltStkRec.UseROPrice;
end;

procedure TAltStockCode.Set_ascUseReorderPrice(Value: WordBool);
begin
  FAltStkRec.UseROPrice := Value;
end;

function TAltStockCode.Get_ascNotes: INotes;
begin
  AuthoriseFunction(201, 'ascNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'ALT',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FullCustCode(FAltStkRec.AltCode),
                       NoteTCode + NotesdbCode + FullNCode(FullNomKey(FAltStkRec.FolioNum)));
  FNotesO.SetSerialNoKey(PartCCKey(NoteTCode,FAltStkRec.RecType)+Full_SupStkKey(FStockFolio,FAltStkRec.AltCode),
                           1, 0);
  Result := FNotesI;
end;

function TAltStockCode.Get_ascLastDateUsed: WideString;
begin
  Result := FAltStkRec.LastUsed;
end;

function TAltStockCode.Get_ascLastTimeUsed: WideString;
begin
  Result := FAltStkRec.LastTime;
end;

//IBrowseInfo
function TAltStockCode.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

Function TAltStockCode.AuthoriseFunction (Const FuncNo     : Byte;
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
    // .Delete method
    105       : Result := (FIntfType = imGeneral);

    // .ascNotes property
    201       : Result := (FIntfType = imGeneral);
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

Procedure TAltStockCode.CopyDataRecord;
begin
  CopyAltToExAlt(FBtrIntf^.LMLocCtrl.SdbStkRec, FAltStkRec);
end;

Function TAltStockCode.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;

  With FBtrIntf^ Do Begin

    BtrOpCode := BtrOp;
    KeyS:=SetKeyString(BtrOp, PartCCKey(NoteTCode,FAltStkRec.RecType) + Full_SupStkKey(FStockFolio,SearchKey));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS:=PartCCKey(NoteTCode,FAltStkRec.RecType)+Full_SupStkKey(FStockFolio,#0);
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS:=PartCCKey(NoteTCode,FAltStkRec.RecType)+Full_SupStkKey(FStockFolio,#255);
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    KeyChk := PartCCKey(NoteTCode,FAltStkRec.RecType)+FullNomKey(FStockFolio);

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      If (FIndex <> 2) and Not CheckKey(KeyS, KeyChk, Length(KeyChk), True) Then
        Result := 9;

    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;

    If (Result = 0) Then
        CopyDataRecord;
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (51, Result);
End; { GetDataRecord }

function TAltStockCode.BuildCodeIndex(const Code: WideString): WideString;
begin
  Result := FullStockCode(Code);
end;

function TAltStockCode.Delete : Integer;
begin
  AuthoriseFunction(105, 'Delete');

  Result := FBtrIntf^.LDelete_Rec(FFileNo, FIndex);
end;

function  TAltStockCode.Add: IAltStockCode;
Var
  AddO : TAltStockCode;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TAltStockCode.Create(imAdd, FToolkit, FStockFolio, FAltStkRec.StockCode, FBtrIntf, FAltStkRec.RecType);

  Result := AddO;
end;

procedure TAltStockCode.LoadDetails(const StkA : TBatchSKAltRec; const LockPos : LongInt);
begin
  FAltStkRec := StkA;

  LockCount := 1;
  LockPosition := LockPos;
end;

function  TAltStockCode.Update: IAltStockCode;
Var
  UpdateO : TAltStockCode;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TAltStockCode.Create(imUpdate, FToolkit, FStockFolio, FAltStkRec.StockCode, FBtrIntf, FAltStkRec.RecType);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FAltStkRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

procedure TAltStockCode.CloneDetails(const StkA : TBatchSKAltRec);
begin
  FAltStkRec := StkA;
end;

function  TAltStockCode.Clone: IAltStockCode;
Var
  CloneO : TAltStockCode;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock-Location details object and initialise
  CloneO := TAltStockCode.Create(imClone, FToolkit, FStockFolio, FAltStkRec.StockCode, FBtrIntf, FAltStkRec.RecType);
  CloneO.CloneDetails(FAltStkRec);

  Result := CloneO;
end;

function  TAltStockCode.Save: Integer;
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
    // Add/Update Stock-Location
    SaveExLocalPos(SaveInfo2);
    FAltStkRec.StockFolio := FStockFolio;
    Res := Ex_StoreStkAlt(@FAltStkRec,          // P
                          SizeOf (FAltStkRec),  // PSIZE
                          FIndex,
                          BtrOp);               // SEARCHMODE
    RestoreExLocalPos(SaveInfo2);

  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

procedure TAltStockCode.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

Function TAltStockCode.GetCloneInterface (AFolio, SFolio : longint) : IAltStockCode;
Var
  SaveInfo : TBtrieveFileSavePos;
  lStkCode : ShortString;
  Res      : LongInt;
Begin { GetCloneInterface }
  Result := NIL;

  // Reformat as valid account code
// lStkCode := LJVar(FullNomKey(AFolio) + FullNomKey(SFolio), 31);
  lStkCode := FullRunNoKey(AFolio, SFolio);
  FStockFolio := SFolio;
  // Check not blank
  If (Trim(lStkCode) <> '') Then Begin
    // Save Current Position and index
    SaveExLocalPosRec (SaveInfo, @FAltStkRec, SizeOf(FAltStkRec));

    // Find record for AcCode
    Set_Index(2);
    Res := GetDataRecord (B_GetEq, lStkCode);
    If (Res = 0) Then
      // Got Record - generate and return a Clone interface
      Result := Clone;

    // Restore Original Index and position
    RestoreExLocalPosRec (SaveInfo, @FAltStkRec, SizeOf(FAltStkRec));
  End; { If (Trim(lAcCode) <> '') }
End; { GetCloneInterface }

procedure TAltStockCode.SetStockFolio(Value : longint);
begin
  FStockFolio := Value;
end;

procedure TAltStockCode.SetStockCode(Value : ShortString);
begin
  FAltStkRec.StockCode := Value;
end;



function TAltStockCode.Get_ascDisplayOrder: Integer;
begin
  Result := FAltStkRec.LineNo;
end;

function TAltStockCode.Get_ascReorderQty: Double;
begin
  Result := FAltStkRec.ROQty;
end;

function TAltStockCode.Get_ascReplacementQty: Double;
begin
  Result := FAltStkRec.LineQty;
end;

function TAltStockCode.Get_ascUseReorderQty: WordBool;
begin
  Result := FAltStkRec.UseROQty;
end;

function TAltStockCode.Get_ascUseReplacementQty: WordBool;
begin
  Result := FAltStkRec.UseLineQty;
end;

procedure TAltStockCode.Set_ascDisplayOrder(Value: Integer);
begin
  FAltStkRec.LineNo := Value;
end;

procedure TAltStockCode.Set_ascReorderQty(Value: Double);
begin
  FAltStkRec.ROQty := Value;
end;

procedure TAltStockCode.Set_ascReplacementQty(Value: Double);
begin
  FAltStkRec.LineQty := Value;
end;

procedure TAltStockCode.Set_ascUseReorderQty(Value: WordBool);
begin
  FAltStkRec.UseROQty := Value;
end;

procedure TAltStockCode.Set_ascUseReplacementQty(Value: WordBool);
begin
  FAltStkRec.UseLineQty := Value;
end;

procedure TAltStockCode.SetSQLCaching(SubType: Char);
begin
  inherited SetSQLCaching(FAltStkRec.RecType);
end;

end.
