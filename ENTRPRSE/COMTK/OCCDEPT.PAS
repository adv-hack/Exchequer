unit oCCDept;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, VarCnst3,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, oBtrieve, MiscFunc,
     BtrvU2, ExBtTH1U, GlobList, oNotes;

type
  TCCDept = class(TBtrieveFunctions, ICCDept, IBrowseInfo, ICCDept2, ICCDept3)
  private
    // Note: All properties protected to allow descendants access
    FCCDept    : TBatchCCDepRec;

    FRecPFix   : Char;
    FSubType   : Char;

    FIntfType  : TInterfaceMode;
    FParentCC  : TCCDept;

    FNotesO    : TNotes;
    FNotesI    : INotes;
    FToolkit   : TObject;
  protected
    // ICCDept
    function  Get_cdCode: WideString; safecall;
    function  Get_cdName: WideString; safecall;
    function  BuildCodeIndex(const Code: WideString): WideString; safecall;
    function  BuildNameIndex(const Name: WideString): WideString; safecall;
    function  Clone: ICCDept; safecall;
    function  Get_Index: TCCDeptIndex; safecall;
    procedure Set_Index(Value: TCCDeptIndex); safecall;

    //ICCDept2
    function Get_cdInactive: WordBool; safecall;
    procedure Set_cdInactive(Value: WordBool); safecall;
    function Get_cdCodeW: WideString; safecall;
    procedure Set_cdCodeW(const Value: WideString); safecall;
    function Get_cdNameW: WideString; safecall;
    procedure Set_cdNameW(const Value: WideString); safecall;

    //ICCDept3
    function Get_cdNotes: INotes; safecall;


    function Save: Integer; safecall;
    function Add: ICCDept2; safecall;
    function Update: ICCDept2; safecall;
    procedure Cancel; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // Local Methods
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CloneDetails(const CCDets: TBatchCCDepRec);
    Procedure LoadDetails (Const CCDets: TBatchCCDepRec; Const LockPos : LongInt);
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Procedure InitObjects;
  public
    Constructor Create (Const IType            : TInterfaceMode;
                        Const ParentCC         : TCCDept;
                        Const BtrIntf          : TCtkTdPostExLocalPtr;
                        Const RecPFix, SubType : Char);

    Destructor Destroy; override;
  End; { TGeneralLedger }


Function CreateTCCDept (Const ClientId : Integer; Const RecPFix, SubType : Char) : TCCDept;

implementation

uses ComServ, DllMiscU, DllErrU, BtKeys1U, EtStrU;


{-------------------------------------------------------------------------------------------------}

Function CreateTCCDept (Const ClientId : Integer; Const RecPFix, SubType : Char) : TCCDept;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTCCDept }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TCCDept object
  BtrIntf^.Open_System(PwrdF, PwrdF);

  // Create basic TCCDept object
  Result := TCCDept.Create(imGeneral, Nil, BtrIntf, RecPFix, SubType);

  if SQLBeingUsed then
    Result.SetFileNos([PwrdF]);

End; { CreateTCCDept }

{-------------------------------------------------------------------------------------------------}

Constructor TCCDept.Create (Const IType            : TInterfaceMode;
                            Const ParentCC         : TCCDept;
                            Const BtrIntf          : TCtkTdPostExLocalPtr;
                            Const RecPFix, SubType : Char);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICCDept3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392
  // Initialise Btrieve Ancestor
  FFileNo := PwrdF;

  // Initialise variables
  FillChar (FCCDept, SizeOf(FCCDept), #0);
  InitObjects;

  FRecPFix := RecPFix;
  FSubType := SubType;

  // Setup Link for child GL objects to parent GL object
  FIntfType := IType;
  If Assigned(ParentCC) Then Begin
    FParentCC := ParentCC;
    FIndex := FParentCC.FIndex;
  End { If Assigned(ParentCC) }
  Else Begin
    FParentCC := Self;
    Set_Index(cdIdxCode);
  End; { Else }

  if FSubtype = 'C' then
    FObjectID := tkoCostCentre
  else
    FObjectID := tkoDepartment;
End; { Create }

{-----------------------------------------}

Destructor TCCDept.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If (FIntfType = imGeneral) Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TCCDept.InitObjects;
Begin { InitObjects }
  FParentCC := Nil;
End; { InitObjects }

{-----------------------------------------}

function TCCDept.Get_cdCode: WideString;
begin
  Result := FCCDept.ccDepCode;
end;

{-----------------------------------------}

function TCCDept.Get_cdName: WideString;
begin
  Result := FCCDept.ccDepDesc;
end;

{-----------------------------------------}

function TCCDept.Get_Index: TCCDeptIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TCCDept.Set_Index(Value: TCCDeptIndex);
begin
  Inherited Set_Index (Value);
end;

{-----------------------------------------}

function TCCDept.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

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
    // .cdNotes property
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
end;

{-----------------------------------------}

function TCCDept.BuildCodeIndex(const Code: WideString): WideString;
begin
  Result := LJVar(UpperCase(Code), CCKeyLen);
end;

{-----------------------------------------}

function TCCDept.BuildNameIndex(const Name: WideString): WideString;
begin
  Result := LJVar(Name, CCDescLen);
end;

{-----------------------------------------}

procedure TCCDept.CloneDetails(const CCDets: TBatchCCDepRec);
begin
  FCCDept := CCDets;
end;

{-----------------------------------------}

function TCCDept.Clone: ICCDept;
Var
  CloneO : TCCDept;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new CC/Dept object and initialise
  CloneO := TCCDept.Create(imClone, FParentCC, FBtrIntf, FRecPFix, FSubType);
  CloneO.CloneDetails(FCCDept);

  Result := CloneO;
end;

{-----------------------------------------}

Procedure TCCDept.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExCCDepToTKCCDep(FBtrIntf^.LPassword.CostCtrRec, FCCDept)
End; { CopyDataRecord }

{-----------------------------------------}


Function TCCDept.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS                  : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;

  With FBtrIntf^ Do Begin
    // General index including CC, Dept, Notes, Matching, etc... records
    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, FRecPFix + FSubType + SearchKey);

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      B_GetFirst   : Begin
                       KeyS := FRecPFix + FSubType + #0;
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       KeyS := FRecPFix + FSubType + #255;
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
      If ((LPassword.RecPFix <> FRecPFix) Or (LPassword.SubType <> FSubType)) and (BtrOp <> B_GetEq) Then
        // Not a CC/Dept record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or ((LPassword.RecPFix = FRecPFix) And (LPassword.SubType = FSubType));

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LPassword.RecPFix = FRecPFix) And (LPassword.SubType = FSubType) Then
        // Convert to Toolkit structure
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (79, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TCCDept.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TCCDept.Add: ICCDept2;
Var
  AddO : ICCDept2;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TCCDept.Create(imAdd, FParentCC, FBtrIntf, FRecPfix, FSubType);

  Result := AddO;
end;

procedure TCCDept.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TCCDept.Get_cdInactive: WordBool;
begin
  Result := FCCDept.CCDepInactive = 1;
end;

function TCCDept.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  BtrOp, Res  : SmallInt;
  CCType : SmallInt;
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

  if FSubType = CSubCode[True] then
    CCType := 0
  else
    CCType := 1;


  If (Res = 0) Then Begin
    // Add/Update GL Code
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreCCDep(@FCCDept,                  // P
                         SizeOf (FCCDept),          // PSIZE
                         BtrOp,                     // SEARCHMODE
                         CCType);
    RestoreExLocalPos(SaveInfo2);

  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

procedure TCCDept.Set_cdInactive(Value: WordBool);
begin
  if Value then
    FCCDept.CCDepInactive := 1
  else
    FCCDept.CCDepInactive := 0;
end;

function TCCDept.Update: ICCDept2;
Var
  UpdateO : TCCDept;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TCCDept.Create(imUpdate, FParentCC, FBtrIntf, FRecPFix, FSubType);

    // Pass current Account Record and Locking Details into sub-object
    UpdateO.LoadDetails(FCCDept, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

procedure TCCDept.LoadDetails(const CCDets: TBatchCCDepRec;
  const LockPos: Integer);
begin
  FCCDept := CCDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

function TCCDept.Get_cdCodeW: WideString;
begin
  Result := FCCDept.CCDepCode;
end;

function TCCDept.Get_cdNameW: WideString;
begin
  Result := FCCDept.CCDepDesc;
end;

procedure TCCDept.Set_cdCodeW(const Value: WideString);
begin
  FCCDept.CCDepCode := UpperCase(Value);
end;

procedure TCCDept.Set_cdNameW(const Value: WideString);
begin
  FCCDept.CCDepDesc := Value;
end;

function TCCDept.Get_cdNotes: INotes;
var
  NoteSort : String;
begin
  AuthoriseFunction(201, 'cdNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    if FSubType = CSubCode[True] then
      NoteSort := 'CC'
    else
      NoteSort := 'DP';
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             NoteSort,
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  FNotesO.SetStartKey (FullCustCode(FCCDept.CCDepCode),
                       NoteTCode + NoteDpCode[FSubType = CSubCode[True]] + FullCustCode(FCCDept.CCDepCode));

  Result := FNotesI;
end;


end.
