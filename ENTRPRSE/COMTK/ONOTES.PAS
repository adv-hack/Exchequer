unit oNotes;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBtTH1U, GlobList, SQLStructuresU;

type
  TNotes = class(TBtrieveFunctions, INotes, IBrowseInfo,INotes2)
  private
    // Note: All properties protected to allow descendants access
    FNote      : TBatchNotesRec;

    FReadOnly  : Boolean;
    FStartKey  : ShortString;
    FNoteSort  : ShortString;  // 'ACC', 'DOC', ...
    FNoteCode  : ShortString;  // Document Nunber, Account Code, ...

    FNoteSubType : Char;

    FIntfType  : TInterfaceMode;
    FToolkit   : TObject;
  protected
    // INotes
    function  Get_ntDate: WideString; safecall;
    procedure Set_ntDate(const Value: WideString); safecall;
    function  Get_ntText: WideString; safecall;
    procedure Set_ntText(const Value: WideString); safecall;
    function  Get_ntType: TNotesType; safecall;
    procedure Set_ntType(Value: TNotesType); safecall;
    function  Get_ntAlarmDate: WideString; safecall;
    procedure Set_ntAlarmDate(const Value: WideString); safecall;
    function  Get_ntAlarmSet: WordBool; safecall;
    procedure Set_ntAlarmSet(Value: WordBool); safecall;
    function  Get_ntLineNo: Integer; safecall;
    procedure Set_ntLineNo(Value: Integer); safecall;
    function  Get_ntOperator: WideString; safecall;
    procedure Set_ntOperator(const Value: WideString); safecall;
    function  Get_ntAlarmDays: Integer; safecall;
    procedure Set_ntAlarmDays(Value: Integer); safecall;
    function  Get_ntAlarmUser: WideString; safecall;
    procedure Set_ntAlarmUser(const Value: WideString); safecall;

    function  BuildIndex(LineNo: Integer): WideString; safecall;

    function  Add: INotes; safecall;
    function  Update: INotes; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    procedure SetSQLCaching(SubType : Char = ' '); override;
    //PR: 22/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //SS:18/10/2016:ABSEXCH-9774:Delete method to be added to the INotes Interface to allow the removal of Notes which you can in IRIS Exchequer.
    // INotes2
    function Delete: Integer; safecall;

    // Local Methods
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Procedure LoadDetails (Const NoteDets : TBatchNotesRec; Const LockPos : LongInt);
    Procedure InitNewNote;
    Procedure InitObjects;
  public
    Constructor Create (Const IType     : TInterfaceMode;
                        Const Toolkit   : TObject;
                        Const BtrIntf   : TCtkTdPostExLocalPtr;
                        Const NoteSort  : ShortString;
                        Const NoteType  : Char;
                        Const ReadOnly  : Boolean);

    Destructor Destroy; override;

    Procedure SetStartKey (Const NoteCode  : ShortString; Const StartKey : ShortString);
    procedure SetSerialNoKey(const SnoCode : ShortString; SnType : Byte; NoteFolio : longint);
  End; { TNotes }


implementation

uses ComServ, oToolkit, DLLSK01U, DllErrU, BtsupU1, BtKeys1U, EtStrU, EtMiscU, TKSQL;

{-------------------------------------------------------------------------------------------------}

Constructor TNotes.Create (Const IType     : TInterfaceMode;
                           Const Toolkit   : TObject;
                           Const BtrIntf   : TCtkTdPostExLocalPtr;
                           Const NoteSort  : ShortString;
                           Const NoteType  : Char;
                           Const ReadOnly  : Boolean);
Begin { Create }
  //SS:20/10/2016:ABSEXCH-9774:Delete method to be added to the INotes Interface to allow the removal of Notes which you can in IRIS Exchequer.
  Inherited Create (ComServer.TypeLib, INotes2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := PwrdF;

  // Setup note indexing fields
  FStartKey := '';
  FNoteSubType := NoteType;
  FNoteSort := NoteSort;
  FNoteCode := '';
  FReadOnly := ReadOnly;

  // Initialise variables
  FillChar (FNote, SizeOf(FNote), #0);
  InitObjects;
  FObjectID := tkoNotes;

  // Setup Link for child SL objects to parent SL object
  FIntfType := IType;
  FToolkit := Toolkit;
  FIndex := PWK;
End; { Create }

{-----------------------------------------}

Destructor TNotes.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TNotes.InitObjects;
Begin { InitObjects }
  FToolkit := NIL;
End; { InitObjects }

{-----------------------------------------}

Function TNotes.AuthoriseFunction (Const FuncNo     : Byte;
                                   Const MethodName : String;
                                   Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as MLocF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral) And (Not FReadOnly);
    // .Update method
    101       : Result := (FIntfType = imGeneral) And (Not FReadOnly);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);
    //SS:18/10/2016:ABSEXCH-9774:Delete method to be added to the INotes Interface to allow the removal of Notes which you can in IRIS Exchequer.
    //.Delete method
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
End; { AuthoriseFunction }

{-----------------------------------------}

Procedure TNotes.CopyDataRecord;
Begin { CopyDataRecord }
  CopyExNotesToTKNotes(FBtrIntf^.LPassword.NotesRec, FNote);

  // Set additional fields needed by Toolkit for updating
  With FNote Do Begin
    NoteSort := FNoteSort;
    NoteType := FNoteSubType;
    NoteCode := FNoteCode;
  End; { With FNote }
End; { CopyDataRecord }

{-----------------------------------------}

Function TNotes.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;

Begin { GetDataRecord }
  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  begin
    Result := 0;
    LastErDesc := '';
    BtrOpCode2 := 0;
    With FBtrIntf^ Do Begin
      // General index including Notes, Passwords, Matching, BOM, etc... records

      BtrOpCode := BtrOp;
      KeyS := SetKeyString(BtrOp, FStartKey + FNoteSubType + SearchKey);

      Loop := True;
      Case BtrOp of
        // Moving forward through file
        B_GetGEq,
        B_GetGretr,
        B_GetNext    : BtrOpCode2 := B_GetNext;

        // PR: 04/06/2013 ABSEXCH-14312 Keystring consists of PFix + SubType + Code/Folio + NoteSubType + Dec2Hex(LineNo),
        //                              so change GetFirst & GetLast from appending #0 & #255 to appending first and last
        //                              possible hex values. This stops the SQL redirection from raising an exception when
        //                              it expects a hex string and finds #255
        B_GetFirst   : Begin
                         KeyS := FStartKey + FNoteSubType + '0';
                         BtrOpCode  := B_GetGEq;
                         BtrOpCode2 := B_GetNext;
                       End;

        // Moving backward through file
        B_GetLess,
        B_GetLessEq,
        B_GetPrev    : BtrOpCode2 := B_GetPrev;

        B_GetLast    : Begin
                         KeyS := FStartKey + FNoteSubType + Dec2Hex(MaxLongInt);
                         BtrOpCode  := B_GetLessEq;
                         BtrOpCode2 := B_GetPrev;
                       End;

        // Looking for exact match - do it and finish
        B_GetEq      : Loop := False;
      Else
        Raise Exception.Create ('Invalid Btrieve Operation');
      End; { Case BtrOp}

      KeyChk := FStartKey + FNoteSubType;

      Repeat
        Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

        BtrOpCode := BtrOpCode2;

        //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
        If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) and (BtrOp <> B_GetEq) Then
          // Not a valid record - abandon operation
          Result := 9;
      Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

      FKeyString := KeyS;

      If (Result = 0) Then Begin
        // check correct record type was returned
        If CheckKey(KeyS, KeyChk, Length(KeyChk), True) Then
          // Convert to Toolkit structure
          CopyDataRecord
        Else
          Result := 4;
      End; { If (Result = 0) }
    End; { With FBtrIntf^ }
  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (77, Result);
End; { GetDataRecord }

{-----------------------------------------}

function TNotes.Get_ntDate: WideString;
begin
  Result := FNote.NoteDate;
end;

procedure TNotes.Set_ntDate(const Value: WideString);
begin
  FNote.NoteDate := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntText: WideString;
begin
  Result := FNote.NoteLine;
end;

procedure TNotes.Set_ntText(const Value: WideString);
begin
  FNote.NoteLine := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntType: TNotesType;
begin
  If (FNoteSubType = '1') Then
    Result := ntTypeGeneral
  Else
    Result := ntTypeDated;
end;

procedure TNotes.Set_ntType(Value: TNotesType);
begin
  If (Value = ntTypeGeneral) Then
    FNoteSubType := '1'
  Else
    FNoteSubType := '2';
end;

{-----------------------------------------}

Procedure TNotes.SetStartKey (Const NoteCode  : ShortString; Const StartKey : ShortString);
begin
  FNoteCode := NoteCode;
  FStartKey := StartKey;
  FSQLParentKey := FStartKey;
  FRecordSubType := FNoteSubType;
end;

{-----------------------------------------}

function TNotes.BuildIndex(LineNo: Integer): WideString;
begin
  Result := Dec2Hex(LineNo);
end;

{-----------------------------------------}

function TNotes.Get_ntAlarmDate: WideString;
begin
  Result := FNote.AlarmDate;
end;

procedure TNotes.Set_ntAlarmDate(const Value: WideString);
begin
  FNote.AlarmDate := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntAlarmDays: Integer;
begin
  Result := FNote.RepeatDays;
end;

procedure TNotes.Set_ntAlarmDays(Value: Integer);
begin
  FNote.RepeatDays := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntAlarmSet: WordBool;
begin
  Result := FNote.AlarmSet In ['Y', 'y'];
end;

procedure TNotes.Set_ntAlarmSet(Value: WordBool);
begin
  If Value Then
    FNote.AlarmSet := 'Y'
  Else
    FNote.AlarmSet := 'N';
end;

{-----------------------------------------}

function TNotes.Get_ntAlarmUser: WideString;
begin
  Result := FNote.NoteFor;
end;

procedure TNotes.Set_ntAlarmUser(const Value: WideString);
begin
  FNote.NoteFor := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntLineNo: Integer;
begin
  Result := FNote.LineNo;
end;

procedure TNotes.Set_ntLineNo(Value: Integer);
begin
  FNote.LineNo := Value;
end;

{-----------------------------------------}

function TNotes.Get_ntOperator: WideString;
begin
  Result := FNote.User;
end;

procedure TNotes.Set_ntOperator(const Value: WideString);
begin
  FNote.User := Value;
end;

{-----------------------------------------}

Procedure TNotes.InitNewNote;
Begin { InitNewNote }
  FillChar (FNote, SizeOf(FNote), #0);
  With FNote Do Begin
    NoteSort := FNoteSort;
    NoteCode := FNoteCode;
    NoteType := FNoteSubType;
  End; { With FNote }

  { TODO : Need to automatically set the note line number - possibly do during the SAVE method if not already set ? }

End; { InitNewNote }

{-----------------------------------------}

function TNotes.Add: INotes;
Var
  AddO : TNotes;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TNotes.Create(imAdd, FToolkit, FBtrIntf, FNoteSort, FNoteSubType, False);
  AddO.SetStartKey (FNoteCode, '');
  AddO.InitNewNote;
  AddO.SetSerialNoKey(FNote.KeyStr, FNote.SnoType, FNote.NFolio);

  Result := AddO;
end;

{-----------------------------------------}

procedure TNotes.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;
//SS:18/10/2016:ABSEXCH-9774:Delete method to be added to the INotes Interface to allow the removal of Notes which you can in IRIS Exchequer.
function TNotes.Delete : Integer;
begin
  AuthoriseFunction(105, 'Delete');

  Result := FBtrIntf^.LDelete_Rec(FFileNo, FIndex);
end;


{-----------------------------------------}

function TNotes.Save: Integer;
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
    // Add/Update Note
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreNotes (@FNote,             // P
                          SizeOf (FNote),    // PSIZE
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

Procedure TNotes.LoadDetails (Const NoteDets : TBatchNotesRec; Const LockPos : LongInt);
begin
  FNote := NoteDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TNotes.Update: INotes;
Var
  UpdateO : TNotes;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TNotes.Create(imUpdate, FToolkit, FBtrIntf, FNoteSort, FNoteSubType, False);
    UpdateO.SetStartKey (FNoteCode, '');
    UpdateO.SetSerialNoKey(FNote.KeyStr, FNote.SnoType, FNote.NFolio);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FNote, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

procedure TNotes.SetSerialNoKey(const SnoCode : ShortString; SnType : Byte; NoteFolio : longint);
begin
  FNote.KeyStr := SnoCode;
  FNote.SnoType := SnType;
  FNote.NFolio := NoteFolio;
end;


{-----------------------------------------}

//IBrowseInfo
function TNotes.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


procedure TNotes.SetSQLCaching(SubType: Char);
begin
  inherited SetSQLCaching(FNoteSubType);
end;

function TNotes.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if FNoteSubType <> '2' then
    Result := inherited LoadTheCache
  else
  begin
    if not UsingRedirectCache then
    begin
      FSQLRedirect := TSQLRedirect.Create;
      FSQLRedirect.FileNo := F_TRANSNOTES;
      FSQLRedirect.WhereClause := FullQuery;;
      FSQLRedirect.FieldList := FColumns;
      FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
      Result := FSQLRedirect.Open;
    end
  end;

end;

function TNotes.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TTransactionNotesRec;
  sKey : Str255;

  function LineNoToKeyString(const s : string) : string;
  begin
    if s <> '' then
      Result := FullNomKey(StrToInt('$' + s));
  end;

begin
  sKey := SetKeyString(BtrOp, Copy(Trim(FStartKey), 3, Length(FStartKey)) + FNoteSubtype + LineNoToKeyString(SearchKey));
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LPassword.RecPfix := 'N';
    FBtrIntf^.LPassword.SubType := FNoteSubType;
    FBtrIntf^.LPassword.NotesRec.NoteNo     := FullNCode(FullNomKey(DataRec.NoteFolio)) + DataRec.NType + Dec2Hex(DataRec.LineNo);
    FBtrIntf^.LPassword.NotesRec.NoteDate   := DataRec.NoteDate;
    FBtrIntf^.LPassword.NotesRec.NoteAlarm  := DataRec.NoteAlarm;
    FBtrIntf^.LPassword.NotesRec.NoteFolio  := FullNomKey(DataRec.NoteFolio);
    FBtrIntf^.LPassword.NotesRec.NType      := DataRec.NType;
    FBtrIntf^.LPassword.NotesRec.LineNo     := DataRec.LineNo;
    FBtrIntf^.LPassword.NotesRec.NoteLine   := DataRec.NoteLine;
    FBtrIntf^.LPassword.NotesRec.NoteUser   := DataRec.NoteUser;
    FBtrIntf^.LPassword.NotesRec.TmpImpCode := DataRec.TmpImpCode;
    FBtrIntf^.LPassword.NotesRec.ShowDate   := DataRec.ShowDate;
    FBtrIntf^.LPassword.NotesRec.RepeatNo   := DataRec.RepeatNo;
    FBtrIntf^.LPassword.NotesRec.NoteFor    := DataRec.NoteFor;

    CopyDataRecord;

    FKeyString := FNoteSubType + sKey;
  end;
end;

end.
