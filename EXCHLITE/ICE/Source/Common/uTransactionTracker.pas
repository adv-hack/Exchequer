unit uTransactionTracker;
{
  Classes to detect new transactions.
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
  uCrypto,
  uICEDripFeed
  ;

type
  { The TDocNumbers class keeps a record of the last-used document numbers,
    and stores them in an INI file in the ICE directory }
  TDocNumbers = class(TObject)
  private
    List: TStringList;
    FINIFilename: string;
    FDataPath: string;
    procedure EnableFile(FileName: string; SetEnabled: Boolean);
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

    property DripFeed: TICEDripFeed read FDripFeed;

  end;

implementation

uses
  BtKeys1U;

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

procedure TDocNumbers.EnableFile(FileName: string; SetEnabled: Boolean);
var
  Attributes: Word;
begin
  if FileExists(FileName) then
  begin
    Attributes := FileGetAttr(FileName);
    if SetEnabled then
    begin
//      Attributes := Attributes and not faReadOnly;
      uCrypto.TCrypto.DecryptFile(FileName);
    end
    else
    begin
      uCrypto.TCrypto.EncryptFile(FileName);
//      Attributes := Attributes or faReadOnly;
    end;
//    FileSetAttr(FileName, Attributes);
  end;
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
  EnableFile(INIFilename, True);
  Inifile := TInifile.Create(INIFilename);
  try
    Inifile.ReadSectionValues('LAST_NUMBERS', List);
  finally
    Inifile.Free;
    EnableFile(INIFilename, False);
  end;
end;

// ----------------------------------------------------------------------------

procedure TDocNumbers.SetDataPath(const Value: string);
begin
  FDataPath := Value;
end;

function TDocNumbers.Update: Boolean;

  function OurRefToNumber(OurRef: string): Integer;
  var
    AddChar: Char;
    Add: Integer;
  begin
    AddChar := OurRef[4];
    {
      Tortuous code follows.

      The numeric part of an OurRef code only has 6 characters, so it cannot
      store numbers greater than 999,999 without special coding. If a number
      greater than this is required, the 1st character is replaced with an
      alpha: A=1000000, B=1100000, C=1200000, and so on. In other words, each
      letter represents 100,000 numbers. For clarity, the letters 'I', 'O',
      and 'S' are not used:

          NOM000001:       1
          NOM000100:     100
          NOM001000:    1000
          NOM010000:   10000
          NOM100000:  100000
          NOM999999:  999999
          NOMA00000: 1000000
          NOMA00001: 1000001
          NOMA99999: 1099999
          NOMB00000: 1100000
          NOMC00000: 1200000

      To decode this numeric part the first character is extracted. If it is
      an alpha character (as opposed to a number), the ASCII value of the
      character is adjusted to start from 1, and the result is multiplied by
      100,000 and added 1,000,000 to get the final amount to be added. The
      values are adjusted to accommodate the missing 'I', 'O', and 'S'
      characters.
    }
    case AddChar of
      '0'..'9': Add :=  100000 * (Ord(AddChar) - 48);
      'A'..'H': Add := 1000000 + (100000 * (Ord(AddChar) - 65));
      'J'..'N': Add := 1000000 + (100000 * ((Ord(AddChar) - 1) - 65));
      'P'..'R': Add := 1000000 + (100000 * ((Ord(AddChar) - 2) - 65));
      'T'..'Z': Add := 1000000 + (100000 * ((Ord(AddChar) - 3) - 65));
    else
      begin
        { Unrecognised character }
        raise Exception.Create(OurRef + ' is not in a recognised OurRef format');
      end;
    end;
    if Copy(OurRef, Length(OurRef), 1)[1] in ['A'..'Z'] then
      Result := StrToIntDef(Copy(OurRef, 5, 4), 0) + Add
    else
      Result := StrToIntDef(Copy(OurRef, 5, 5), 0) + Add;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  LastDocNumber: LongInt;
  CharPos: Integer;
  DocCode: Str10;
  OurRef: Str10;
begin
  Result := False;

  ErrorCode := 0;

  SetDrive := DataPath;

  Clear;

{
  ----------------------------------------------------------------------------
  Original version, reading from the Document Numbers table. Not reliable,
  because the Last Used Document number is user-editable.
  ----------------------------------------------------------------------------
}
(*
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
*)

{
  ----------------------------------------------------------------------------
  Revised version, reading directly from the Documents table, and finding
  the highest used document number for each relevant transaction type.
  ----------------------------------------------------------------------------
}

  { Open the table... }
  FuncRes := Open_File(F[InvF], SetDrive + FileNames[InvF], 0);
  if (FuncRes = 0) then
  begin
    CharPos := 1;
    while CharPos <= Length(ICEDocCodes) do
    begin
      DocCode := Copy(ICEDocCodes, CharPos, 3);
      { Find the highest used document number for this code. }
      Key := BtKeys1U.FullOurRefKey(DocCode + 'ZZZZZZZ');
      FuncRes := Find_Rec(B_GetLessEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key);
      if (FuncRes = 0) and (Copy(Key, 1, 3) = DocCode) then
      begin
        OurRef := Inv.OurRef;
        { Some Nominal codes have an alpha character at the end. If one of
          these happens to be the last entry, it will give spurious results,
          so step back through the file until we find an entry without an
          alpha character at the end. }
        while (FuncRes = 0) and
              (Copy(Key, 1, 3) = DocCode) and
              (Copy(OurRef, Length(OurRef), 1)[1] in ['A'..'Z']) do
        begin
          FuncRes := Find_Rec(B_GetPrev, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key);
          OurRef  := Inv.OurRef;
        end;
        if (FuncRes = 0) and (Copy(Key, 1, 3) = DocCode) then
          { Extract the numeric part of the OurRef field. }
          LastDocNumber := OurRefToNumber(OurRef)
        else
          LastDocNumber := 0;
      end
      else
      begin
        { No transactions found for this type. }
        LastDocNumber := 0;
      end;
      List.Add(DocCode + '=' + IntToStr(LastDocNumber));
      CharPos := CharPos + 4;
    end;
    FuncRes := Close_File(F[InvF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
//  if (ErrorCode <> 0) then
//    DoLogMessage('TDocNumbers.Update', ErrorCode, 'Error: ' + IntToStr(FuncRes));
end;

// ----------------------------------------------------------------------------

procedure TDocNumbers.Write;
var
  Inifile: TInifile;
  Entry: Integer;
  DocType: string;
begin
  EnableFile(INIFilename, True);
  Inifile := TInifile.Create(INIFilename);
  try
    for Entry := 0 to List.Count - 1 do
    begin
      DocType := List.Names[Entry];
      Inifile.WriteInteger('LAST_NUMBERS', DocType, LastNumber[DocType]);
    end;
  finally
    Inifile.Free;
    EnableFile(INIFilename, False);
  end;
end;

// ============================================================================
// TTransactionTracker
// ============================================================================

constructor TTransactionTracker.Create;
begin
  inherited Create;
  FDocNumbers := TDocNumbers.Create;
  FDripFeed    := TICEDripFeed.Create;
end;

// ----------------------------------------------------------------------------

destructor TTransactionTracker.Destroy;
begin
  FDripFeed.Free;
  FDocNumbers.Free;
  inherited;
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.FillDocumentList(List: TStrings);
begin
  List.Clear;
  List.AddStrings(FDocNumbers.List);
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
  FDocNumbers.FINIFilename := Path + 'ICETrack.dat';
  FDocNumbers.Read;
  DripFeed.Datapath := Path;
end;

// ----------------------------------------------------------------------------

procedure TTransactionTracker.UpdateDocumentNumbers;
begin
  FDocNumbers.Update;
  FDocNumbers.Write;
end;

// ----------------------------------------------------------------------------

end.
