unit uICETrack;

{ NOW REDUNDANT. Clients are not allowed to edit transaction records. }

{
  Class for accessing the ICE Track database file, which records edits made
  to transactions between exports.
}
interface

uses SysUtils, Dialogs, Controls, Classes, GlobVar, Btrvu2, SavePos;

const
  NUMBER_OF_INDEX_SEGMENTS = 2;
  DEFAULT_ICETRACK_FILE_INDEX = 1;
  LOCK_RECORD = True;

type
  TICETrackEntry = record
    OurRef: string[9];
    Date:   string[8];
  end;

  TICETrackFileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..NUMBER_OF_INDEX_SEGMENTS] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  TICETrack = class(TObject)
  private
    FileDef: TICETrackFileDef;
    Idx: Integer;
    FActive: Boolean;
    SearchKey: Str255;
    SearchIdx: Integer;
    Position: TBtrieveSavePosition;
    RecordSaved: Boolean;
    FEOF: Boolean;
    FBOF: Boolean;
    FDataPath: string;
    procedure DefineFile;
    procedure SetActive(const Value: Boolean);
    procedure SetDataPath(const Value: string);
  public
    Entry: TICETrackEntry;
    constructor Create;
    constructor CreateAtIndex(Idx: Integer);
    destructor Destroy; override;
    procedure Add;
    procedure CreateFile(Filespec: ShortString);
    procedure CreateFileInDefaultLocation;
    procedure Delete;
    procedure DeleteAll;
    function Find(ForOurRef: ShortString; Lock: Boolean = False): Integer;
    function FindFirst: Integer;
    function FindFirstByDate(ForDate: TDateTime; Lock: Boolean = False): Integer;
    function FindNext: Integer;
    function FindPrev: Integer;
    function Open: Integer;
    function Close: Integer;
    procedure Lock;
    procedure Unlock;
    procedure Update;
    procedure SavePosition(SaveRecord: Boolean = False);
    procedure RestorePosition;
    property Active: Boolean read FActive write SetActive;
    property DataPath: string read FDataPath write SetDataPath;
    property BOF: Boolean read FBOF;
    property EOF: Boolean read FEOF;
  end;
  EICETrackException = class(Exception)
  end;

implementation

{ TICETrack }

const
  B_GetPosition = 22; // Missing from BtrvU2.pas

procedure TICETrack.Add;
var
  Res: LongInt;
begin
  Res := Add_Rec(F[Idx], Idx, RecPtr[Idx]^, 0);
  if (Res = 5) then
    raise EICETrackException.Create('Record already exists against the specified key')
  else if (Res <> 0) then
    raise EICETrackException.Create('Failed to add record : Error ' + IntToStr(Res));
end;

function TICETrack.Close: Integer;
begin
  Result := 0;
  if Active then
  begin
    FActive := False;
    Result := Close_File(F[Idx]);
//    if (Result <> 0) then
//      raise EICETrackException.Create('Failed to close file: Error ' + IntToStr(Result));
  end;
end;

constructor TICETrack.Create;
begin
  CreateAtIndex(DEFAULT_ICETRACK_FILE_INDEX);
end;

constructor TICETrack.CreateAtIndex(Idx: Integer);
begin
  inherited Create;
  self.Idx := Idx;
  DefineFile;
  Position := TBtrieveSavePosition.Create;
  RecordSaved := False;
end;

procedure TICETrack.CreateFile(Filespec: ShortString);
var
  Res: LongInt;
begin
  if FileExists(Filespec) then
    raise EICETrackException.Create('File ' + Filespec + ' already exists.');
  Res := Make_File(F[Idx], Filespec, FileSpecOfs[Idx]^, FileSpecLen[Idx]);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to create ' + Filespec + ': Error ' + IntToStr(Res));
end;

procedure TICETrack.CreateFileInDefaultLocation;
begin
  CreateFile(DataPath + 'ICETrack.DAT');
end;

procedure TICETrack.DefineFile;
begin
  with FileDef do
  begin
    FileSpecLen[Idx] := Sizeof(FileDef);
    FillChar(FileDef, FileSpecLen[Idx], 0);

    RecLen   := Sizeof(Entry);
    PageSize := DefPageSize;

    NumIndex := 2;

    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { 00 - OurRef  }
    KeyBuff[1].KeyPos   := BTKeyPos(@Entry.OurRef[1], @Entry);
    KeyBuff[1].KeyLen   := SizeOf(Entry.OurRef) - 1;
    KeyBuff[1].KeyFlags := AltColSeq;

    { 01 - Date }
    KeyBuff[2].KeyPos   := BTKeyPos(@Entry.Date[1], @Entry);
    KeyBuff[2].KeyLen   := SizeOf(Entry.Date) - 1;
    KeyBuff[2].KeyFlags := DupMod + AltColSeq;

    AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }
  end;

  FileRecLen[Idx]  := Sizeof(Entry);
  RecPtr[Idx]      := @Entry;
  FileSpecOfs[Idx] := @FileDef;
  FileNames[Idx]   := 'ICETrack.Dat';

  FillChar(Entry, FileRecLen[Idx], 0);

end;

procedure TICETrack.Delete;
var
  Res: LongInt;
begin
  Lock;
  Res := Delete_Rec(F[Idx], Idx, SearchIdx);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to delete record: Error ' + IntToStr(Res));
end;

destructor TICETrack.Destroy;
begin
  Active := False;
  FreeAndNil(Position);
  inherited;
end;

function TICETrack.Find(ForOurRef: ShortString; Lock: Boolean): Integer;
var
  SearchType: Integer;
  Response: Word;
  Cancelled: Boolean;
begin
  FEOF := False;
  Cancelled := False;
  SearchKey := ForOurRef;
  SearchIdx := 0;
  SearchType := B_GetEq;
  if Lock then
    SearchType := SearchType + B_SingNWLock;
  repeat
    Result := Find_Rec(SearchType, F[Idx], Idx, Entry, SearchIdx, SearchKey);
    if (Result = 84) then
    begin
      Response := MessageDlg('Record is locked', mtWarning,
                    [mbRetry, mbCancel], 0);
      Cancelled := (Response = mrCancel);
    end;
  until (Result <> 84) or Cancelled;
  if Result = 4 then
    FEOF := True;
  if Result = 84 then
    raise EICETrackException.Create('Record is locked by another user');
end;

function TICETrack.FindFirst: Integer;
begin
  SearchIdx := 0;
  Result    := Find_Rec(B_GetFirst, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  FEOF      := (Result = 9);
end;

function TICETrack.FindFirstByDate(ForDate: TDateTime; Lock: Boolean): Integer;
var
  SearchType: Integer;
  Response: Word;
  Cancelled: Boolean;
begin
  FEOF       := False;
  Cancelled  := False;
  SearchKey  := FormatDateTime('yyyymmdd', ForDate);
  SearchIdx  := 1;
  SearchType := B_GetGEq;
  if Lock then
    SearchType := SearchType + B_SingNWLock;
  repeat
    Result := Find_Rec(SearchType, F[Idx], Idx, Entry, SearchIdx, SearchKey);
    if (Result = 84) then
    begin
      Response  := MessageDlg('Record is locked', mtWarning, [mbRetry, mbCancel], 0);
      Cancelled := (Response = mrCancel);
    end;
  until (Result <> 84) or Cancelled;
  if Result = 4 then
    FEOF := True;
  if Result = 84 then
    raise EICETrackException.Create('Record is locked by another user');
end;

function TICETrack.FindNext: Integer;
begin
  Result := Find_Rec(B_GetNext, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  FEOF   := (Result = 9);
end;

function TICETrack.FindPrev: Integer;
begin
  Result := Find_Rec(B_GetPrev, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  FBOF   := (Result = 9);
end;

function TICETrack.Open: Integer;
begin
  Result := 0;
  if not Active then
  begin
    Result := Open_File(F[Idx], DataPath + FileNames[Idx], 0);
    if (Result <> 0) then
      raise EICETrackException.Create('Failed to open file: Error ' + IntToStr(Result))
    else
      FActive := True;
  end;
end;

procedure TICETrack.RestorePosition;
begin
  Position.RestoreSavedPosition(True);
  if RecordSaved then
    Position.RestoreDataBlock(@Entry);
end;

procedure TICETrack.SavePosition(SaveRecord: Boolean);
begin
  if SaveRecord then
  begin
    Position.SaveDataBlock(@Entry, SizeOf(Entry));
    RecordSaved := True;
  end
  else
    RecordSaved := False;
  Position.SaveFilePosition(Idx, SearchIdx);
end;

procedure TICETrack.SetActive(const Value: Boolean);
begin
  if (Active <> Value) then
    if Active then
      Close
    else
      Open;
  FActive := Value;
end;

procedure TICETrack.SetDataPath(const Value: string);
begin
  if Active then
    raise EICETrackException.Create('Cannot change path while file is open.');
  FDataPath := IncludeTrailingPathDelimiter(Value);
end;

procedure TICETrack.Unlock;
var
  Res: LongInt;
begin
  Res := Find_Rec(B_Unlock, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to unlock record: Error ' + IntToStr(Res));
end;

procedure TICETrack.Update;
var
  Res: LongInt;
begin
  Res := Put_Rec(F[Idx], Idx, Entry, 0);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to update record : Error ' + IntToStr(Res));
end;

procedure TICETrack.DeleteAll;
begin
  while (FindFirst = 0) do
    Delete;
end;

procedure TICETrack.Lock;
var
  Res: LongInt;
begin
  Res := Find_Rec(B_GetPosition, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to get the record position for locking: Error ' + IntToStr(Res));
  Res := Find_Rec(B_GetDirect + B_SingNWLock, F[Idx], Idx, Entry, SearchIdx, SearchKey);
  if (Res <> 0) then
    raise EICETrackException.Create('Failed to re-read the record for locking: Error ' + IntToStr(Res));
end;

end.
