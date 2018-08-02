unit TNoteDataClass;

interface

uses Contnrs, Enterprise01_TLB, CtkUtil, SysUtils;

type
  TNote = class(TObject)
  private
    FAlarmDays: integer;
    FLineNo: integer;
    FNoteType: TNotesType;
    FAlarmDate: WideString;
    FText: WideString;
    FOperator: WideString;
    FAlarmUser: WideString;
    FNoteDate: WideString;
    FShowNoteDate: WordBool;
    FNoteChanged: boolean;
    FIsNew: boolean;
    FDeleted: boolean;
  public
    function GetAlarmDays(AlarmDays: integer; var EveryDays: integer): integer;
    function SetAlarmDays(const EveryText: string; EveryDays: integer): string;
    property AlarmDate: WideString read FAlarmDate write FAlarmDate;
    property AlarmDays: integer read FAlarmDays write FAlarmDays;
    property ShowNoteDate: WordBool read FShowNoteDate write FShowNoteDate;
    property AlarmUser: WideString read FAlarmUser write FAlarmUser;
    property NoteDate: WideString read FNoteDate write FNoteDate;
    property LineNo: integer read FLineNo write FLineNo;
    property Operator: WideString read FOperator write FOperator;
    property Text: WideString read FText write FText;
    property NoteType: TNotesType read FNoteType write FNoteType;
    property IsNew: boolean read FIsNew write FIsNew;
    property NoteChanged: boolean read FNoteChanged write FNoteChanged;
    property Deleted: boolean read FDeleted write FDeleted;
  end;

  TNoteData = class(TObject)
    FNotes: TObjectList;
    FDataPath: string;
    FOurRef: string;
    FToolkit: IToolkit;
    FNote: TNote;
    function  OpenCOMToolkit: IToolkit;
    procedure CloseCOMToolkit;
    procedure CopyNoteData;
  private
    FCurrentIx: Integer;
    FOperator: string;
  public
    constructor Create(const ADataPath: string; const AnOurRef: string);
    destructor  Destroy;
    procedure   FetchNoteData;
    procedure   LocateNote(ALineNo: integer);
    function    FirstNote: TNote;
    function    NextNote: TNote;
    function    NoteCount: integer;
    function    SaveNote: integer;
    function    NewNote(ANotesType: TNotesType): TNote;
    property    Note: TNote read FNote;
    property    Operator: string read FOperator write FOperator;
  end;

implementation

uses Classes;


{ TNoteData }

procedure TNoteData.CloseCOMToolkit;
begin
  FToolkit.CloseToolkit;
  FToolkit := nil;
end;

procedure TNoteData.CopyNoteData;
var
  NewNote: TNote;
begin
  NewNote := TNote.Create;
  with NewNote, FToolkit.Transaction.thNotes do begin
    AlarmDate    := trim(ntAlarmDate); // the tick box in Exchequer is ticked if this field contains a date.
    AlarmDays    := ntAlarmDays;
    ShowNoteDate := ntAlarmSet; // ntAlarmSet; this field actually means "Show Date" on a dated noted. Its the tick box under the date in Exchequer.
    AlarmUser    := ntAlarmUser;
    NoteDate     := ntDate;
    LineNo       := ntLineNo;
    Operator     := ntOperator;
    Text         := ntText;
    NoteType     := ntType;
  end;
  FNotes.Add(NewNote);
end;

constructor TNoteData.Create(const ADataPath: string; const AnOurRef: string);
begin
  inherited Create;
  FDataPath := ADataPath;
  FOurRef := AnOurRef;
  FNotes := TObjectList.Create;
  FNotes.OwnsObjects := true;
end;

destructor TNoteData.Destroy;
begin
  if FNotes <> nil then
    FNotes.Free;
end;

procedure TNoteData.FetchNoteData;
var
  res: integer;
begin
  FNotes.Clear;
  if FOurRef = '' then EXIT;
  if OpenCOMToolkit = nil then EXIT;
  try
    with FToolkit.Transaction do begin
      Index := thIdxOurRef;
      res := GetEqual(BuildOurRefIndex(FOurRef));
      if res <> 0 then EXIT;
      with thNotes do begin
        ntType := ntTypeDated;
        res := GetFirst;
        while res = 0 do begin
          CopyNoteData;
          res := GetNext;
        end;
        ntType := ntTypeGeneral;
        res := GetFirst;
        while res = 0 do begin
          CopyNoteData;
          res := GetNext;
        end;
      end;
    end;
  finally
    CloseCOMToolkit;
  end;
end;

function TNoteData.FirstNote: TNote;
begin
  if FNotes.Count = 0 then
    FetchNoteData;
  FNote := nil;
  FCurrentIx := 0;
  if NoteCount = 0 then EXIT;
  FNote := TNote(FNotes[FCurrentIx]);
  result := FNote;
end;

procedure TNoteData.LocateNote(ALineNo: integer);
var ix: integer;
begin
  FNote := nil;
  for ix := 0 to FNotes.Count - 1 do
    if TNote(FNotes[ix]).LineNo = ALineNo then
      FNote := TNote(FNotes[ix]);
end;

function TNoteData.NewNote(ANotesType: TNotesType): TNote;
var
  NewNote: TNote;
begin
  NewNote := TNote.Create;
  with NewNote do begin
    AlarmDate := '';
    AlarmDays := 0;
    ShowNoteDate := true;
    AlarmUser := '';
    NoteDate  := FormatDateTime('yyyymmdd', Date);
    LineNo    := FNotes.Count + 1; // LineNo is zero-based  // *** REMOVE THE +1 
    Operator  := '';
    Text      := '';
    NoteType  := ANotesType;
    IsNew     := true;
  end;
  FNotes.Add(NewNote);
  FNote  := NewNote;
  result := NewNote;
end;

function TNoteData.NextNote: TNote;
begin
  FNote := nil;
  if FCurrentIx < FNotes.Count - 1 then begin
    inc(FCurrentIx);
    FNote := TNote(FNotes[FCurrentIx]);
  end;

  result := FNote;
end;

function TNoteData.NoteCount: integer;
begin
  result := FNotes.Count;
end;

function TNoteData.OpenCOMToolkit;
begin
  FToolkit := OpenToolkit(FDataPath, True);
  result := FToolkit;
end;

function TNoteData.SaveNote: integer;
var
  NewNote: INotes;
  res: integer;
begin
  result := -1;
  OpenCOMToolkit;
  if FToolkit = nil then EXIT;
  try
    with FToolkit.Transaction do begin
      index := thIdxOurRef;
      res   := GetEqual(BuildOurRefIndex(FOurRef));
      result := -2;
      if res <> 0 then EXIT;
      thNotes.ntType := FNote.FNoteType;
      if FNote.IsNew then
        NewNote := thNotes.Add
      else begin
        with thNotes do begin
          GetFirst;
          while ntLineNo <> FNote.LineNo do
            GetNext;
          result := -3;
          NewNote := Update;
          if NewNote = nil then EXIT;
        end;
      end;
      with FNote, NewNote do begin
        ntAlarmDate := AlarmDate;
        ntAlarmDays := AlarmDays;
//        ntAlarmSet  := ShowNoteDate; // i.e. In Exchequer this field means "show note date", not "is Alarm Set ?" ntAlarmSet is ReadOnly
        ntAlarmUser := AlarmUser;
        if ShowNoteDate then
          ntDate    := NoteDate
        else
          ntDate    := '';
        ntLineNo    := LineNo;
        ntOperator  := FOperator;
        ntText      := Text;
        result := Save;
      end;
    end;
  finally
    NewNote := nil;
    CloseCOMToolkit;
  end;
end;

{ TNote }

function TNote.SetAlarmDays(const EveryText: string; EveryDays: integer): string;
  function stndrdth(ADayInMonth: integer): string;
  var
    DayDigits: string;
  begin
    DayDigits := format('%.2d', [ADayInMonth]);
    if DayDigits[1] = '1' then result := 'th' else  // 11th to 19th
    if DayDigits[2] = '1' then result := 'st' else  // 1st, 21st and 31st
    if DayDigits[2] = '2' then result := 'nd' else  // 2nd and 22nd
    if DayDigits[2] = '3' then result := 'rd' else  // 3rd and 23rd
                               result := 'th';      // everything else is nth
  end;
begin
  if EveryText = '' then begin     // allow a call to just return the suffix without altering the AlarmDays property.
    result := stndrdth(EveryDays);
    EXIT;
  end;

  if SameText(EveryText, 'every') then begin
    AlarmDays := EveryDays;
    if EveryDays = 1 then
      result := '  day'
    else
      result := '  days';
    EXIT;
  end;

  if SameText(EveryText, 'next month on the') then begin
    AlarmDays := 900 + EveryDays;
    result := stndrdth(EveryDays);
    EXIT;
  end;

  if SameText(EveryText, 'at the end of next month') then begin
    AlarmDays := 999;
    result    := '';
    EXIT;
  end;

  if SameText(EveryText, 'every 2 months on the') then begin
    AlarmDays := 800 + EveryDays;
    result := stndrdth(EveryDays);
    EXIT;
  end;

  if SameText(EveryText, 'every 3 months on the') then begin
    AlarmDays := 700 + EveryDays;
    result := stndrdth(EveryDays);
    EXIT;
  end;

  if SameText(EveryText, 'every 4 months on the') then begin
    AlarmDays := 600 + EveryDays;
    result := stndrdth(EveryDays);
    EXIT;
  end;

  if SameText(EveryText, 'every 5 months on the') then begin
    AlarmDays := 500 + EveryDays;
    result := stndrdth(EveryDays);
    EXIT;
  end;
end;

function TNote.GetAlarmDays(AlarmDays: integer; var EveryDays: integer): integer;
begin
  if AlarmDays <= 500 then begin
    EveryDays := AlarmDays;
    result    := 0; // "every"
    EXIT;
  end;

  if AlarmDays = 999 then begin
    EveryDays := 0;
    result    := 2; // "at the end of next month"
    EXIT;
  end;

  if AlarmDays > 900 then begin
    EveryDays := AlarmDays - 900;
    result    := 1; // "next month on the"
    EXIT;
  end;

  if AlarmDays > 800 then begin
    EveryDays := AlarmDays - 800;
    result    := 3; // "every 2 months on the"
    EXIT;
  end;

  if AlarmDays > 700 then begin
    EveryDays := AlarmDays - 700;
    result    := 4; // "every 3 months on the"
    EXIT;
  end;

  if AlarmDays > 600 then begin
    EveryDays := AlarmDays - 600;
    result    := 5; // "every 4 months on the"
    EXIT;
  end;

  if AlarmDays > 500 then begin
    EveryDays := AlarmDays - 500;
    result    := 6; // "every 5 months on the"
    EXIT;
  end;
end;

end.
