unit uTransactionTracker;
{ ORIGINAL VERSION. Includes ICETrack to track edits to transactions, but
  these are no longer allowed, so this version is redundant. }
  
{
  Classes to keep track of edits of transactions, and to detect new
  transactions.
}
interface

uses
  Classes, SysUtils, Inifiles,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  uConsts,
  uICETrack,
  uICEDripFeed
  ;

type
  TDocNumbers = class(TObject)
  private
    List: TStringList;
    FINIFilename: string;
    FDataPath: string;
    function GetLastNumber(ForDocType: ShortString): Integer;
    procedure SetDataPath(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    { Clears all the current entries. }
    procedure Clear;

    { Reads the last numbers from the Exchequer database. }
    function Update: Boolean;

    { Reads the last numbers from the INI file. }
    procedure Read;

    { Writes the last numbers to the INI file. }
    procedure Write;

    property INIFilename: string read FINIFilename write FINIFilename;

    property LastNumber[ForDocType: ShortString]: Integer read GetLastNumber; default;

    { Property holding the path of the Exchequer installation. }
    property DataPath: string read FDataPath write SetDataPath;

  end;

  TTransactionTracker = class(TObject)
  private
    FEditTracker: TICETrack;
    FDripFeed: TICEDripFeed;
    FPath: string;
    FDataPath: string;
    FDocNumbers: TDocNumbers;
    procedure SetPath(const Value: string);
    procedure SetDataPath(const Value: string);
  public

    constructor Create;
    destructor Destroy; override;

    { Returns True if OurRef is greater than the last document number for its
      type. }
    function IsNew(OurRef: ShortString): Boolean;

    { Returns True if OurRef is found in the tracking file, indicating that it
      has been changed since the last export. }
    function HasChanged(OurRef: ShortString): Boolean;

    { Returns the last document number recorded for the specified document
      type, as at the time of the last export. Any documents with a higher
      document number must have been added since the export. Recorded when
      the bulk Document Numbers export is done, and then after every
      dripfeed export (dnnextcount). }
    function LastDocumentNumber(ForDocType: ShortString): string;

    { Fills the supplied stringlist with a list of document numbers and
      their values, in INI file format (e.g. 'SOR=8'). }
    procedure FillDocumentList(List: TStrings);

    { Reads the last document numbers from the database, and stores them in
      the INI file. }
    procedure UpdateDocumentNumbers;

    { Property holding the path of the Exchequer installation. Setting this
      value will also update the Path property. }
    property DataPath: string read FDataPath write SetDataPath;

    { Property holding the path of the ICE folder. By default this is
      DataPath + 'ICS\'. }
    property Path: string read FPath write SetPath;

    property Edits: TICETrack read FEditTracker;

    property DripFeed: TICEDripFeed read FDripFeed;

  end;

implementation

// ============================================================================
// TTransactionTracker
// ============================================================================

constructor TTransactionTracker.Create;
begin
  inherited Create;
  FDocNumbers := TDocNumbers.Create;
  FEditTracker := TICETrack.CreateAtIndex(16);
  FDripFeed    := TICEDripFeed.Create;
end;

// ----------------------------------------------------------------------------

destructor TTransactionTracker.Destroy;
begin
  FDripFeed.Free;
  FEditTracker.Free;
  FDocNumbers.Free;
  inherited;
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.FillDocumentList(List: TStrings);
begin
  List.Clear;
  List.AddStrings(FDocNumbers.List);
end;

function TTransactionTracker.HasChanged(OurRef: ShortString): Boolean;
begin
  Result := (FEditTracker.Find(OurRef) = 0);
end;

// ----------------------------------------------------------------------------

function TTransactionTracker.IsNew(OurRef: ShortString): Boolean;
var
  DocType: ShortString;
begin
  DocType := Uppercase(Copy(OurRef, 1, 3));
  { If OurRef is greater than the last document number for this type, it has
    been added since the last export. }
  Result := (OurRef > LastDocumentNumber(DocType));
end;

// ----------------------------------------------------------------------------

function TTransactionTracker.LastDocumentNumber(
  ForDocType: ShortString): string;
var
  LastNumber: Integer;
begin
  Result := '';
  LastNumber := FDocNumbers.LastNumber[ForDocType];
  Result := ForDocType + Format('%.6d', [LastNumber]);
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.SetDataPath(const Value: string);
begin
  FDataPath := IncludeTrailingPathDelimiter(Value);
  FDocNumbers.DataPath := DataPath;
  Path := DataPath + cICEFOLDER;
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.SetPath(const Value: string);
begin
  FPath := IncludeTrailingPathDelimiter(Value);
  FDocNumbers.FINIFilename := Path + 'ICETrack.INI';
  FDocNumbers.Read;
  FEditTracker.Close;
  FEditTracker.DataPath := Path;
  FEditTracker.Open;
  FDripFeed.Datapath := Path;
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.UpdateDocumentNumbers;
begin
  FDocNumbers.Update;
  FDocNumbers.Write;
end;

// ----------------------------------------------------------------------------

// ============================================================================
// TDocNumbers
// ============================================================================

procedure TDocNumbers.Clear;
begin
  List.Clear;
end;

// ----------------------------------------------------------------------------

constructor TDocNumbers.Create;
begin
  inherited Create;
  List := TStringList.Create;
end;

// ----------------------------------------------------------------------------

destructor TDocNumbers.Destroy;
begin
  List.Free;
  inherited;
end;

// ----------------------------------------------------------------------------

function TDocNumbers.GetLastNumber(ForDocType: ShortString): Integer;
begin
  Result := StrToIntDef(List.Values[ForDocType], 0);
end;

// ----------------------------------------------------------------------------

procedure TDocNumbers.Read;
var
  Inifile: TInifile;
begin
  Inifile := TInifile.Create(INIFilename);
  try
    Inifile.ReadSectionValues('LAST_NUMBERS', List);
  finally
    Inifile.Free;
  end;
end;

// ----------------------------------------------------------------------------

procedure TDocNumbers.SetDataPath(const Value: string);
begin
  FDataPath := Value;
end;

function TDocNumbers.Update: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  NextDocNumber: LongInt;
begin
  Result := False;

  ErrorCode := 0;

  SetDrive := DataPath;

  Clear;

  { Open the table... }
  FuncRes := Open_File(F[IncF], SetDrive + FileNames[IncF], 0);
  if (FuncRes = 0) then
  begin
    { ...and find the record. }
    FuncRes := Find_Rec(B_GetFirst, F[IncF], IncF, RecPtr[IncF]^, 0, Key);
    Result := (FuncRes = 0);

    while (FuncRes = 0) do
    begin
      Move(Count.NextCount[1], NextDocNumber, Sizeof(NextDocNumber));
      List.Add(Count.CountTyp + '=' + IntToStr(NextDocNumber - 1));

      FuncRes := Find_Rec(B_GetNext, F[IncF], IncF, RecPtr[IncF]^, 0, Key);
    end;

    FuncRes := Close_File(F[IncF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
//  if (ErrorCode <> 0) then
//    DoLogMessage('TDocNumberExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
end;

// ----------------------------------------------------------------------------

procedure TDocNumbers.Write;
var
  Inifile: TInifile;
  Entry: Integer;
  DocType: string;
begin
  Inifile := TInifile.Create(INIFilename);
  try
    for Entry := 0 to List.Count - 1 do
    begin
      DocType := List.Names[Entry];
      Inifile.WriteInteger('LAST_NUMBERS', DocType, LastNumber[DocType]);
    end;
  finally
    Inifile.Free;
  end;
end;

// ----------------------------------------------------------------------------

end.
