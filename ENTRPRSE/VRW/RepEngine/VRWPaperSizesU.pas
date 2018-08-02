unit VRWPaperSizesU;
{
  Implementation of interfaces in VRWPaperSizesIF
}
interface

uses SysUtils, Classes, VRWPaperSizesIF;

type
  TVRWPaperSize = class(TInterfacedObject, IVRWPaperSize)
  private
    { --- Fields for properties --------------------------------------------- }
    FprCode: ShortString;
    FprMMHeight: SmallInt;
    FprMMWidth: SmallInt;

    { --- Implementation of property access methods ------------------------- }
    function GetPrCode: ShortString;
    procedure SetPrCode(const Value: ShortString);

    function GetPrMMHeight: SmallInt;
    procedure SetPrMMHeight(const Value: SmallInt);

    function GetPrMMWidth: SmallInt;
    procedure SetPrMMWidth(const Value: SmallInt);

  end;

  TVRWPaperSizes = class(TInterfacedObject, IVRWPaperSizes)
  private
    { --- Fields for properties --------------------------------------------- }
    FList: TInterfaceList;

    { --- Implementation of property access methods ------------------------- }
    function GetCount: Integer;

    function GetPsItem(Index: SmallInt): IVRWPaperSize;
    procedure SetPsItem(Index: SmallInt; const Value: IVRWPaperSize);

    function GetPsItemByCode(Index: ShortString): IVRWPaperSize;
    procedure SetPsItemByCode(Index: ShortString; const Value: IVRWPaperSize);

    { --- Support methods --------------------------------------------------- }
    procedure CreateDefaultEntries;
    procedure WriteAll;

  public
    constructor Create;
    destructor Destroy; override;

    { --- Implementation of general methods --------------------------------- }
    procedure ReadAll;
    function Add(Code: ShortString; MMWidth, MMHeight: SmallInt): IVRWPaperSize;
    function ExtractPaperCode(FromStr: string): string;
    procedure FillCodeList(Strings: TStrings);
    function IndexOf(Strings: TStrings; PaperCode: ShortString): Integer;

  end;

implementation

uses Forms, Inifiles, GlobVar, VAOUtil;

{ TVRWPaperSize }

function TVRWPaperSize.GetPrCode: ShortString;
begin
  Result := FprCode;
end;

function TVRWPaperSize.GetPrMMHeight: SmallInt;
begin
  Result := FprMMHeight;
end;

function TVRWPaperSize.GetPrMMWidth: SmallInt;
begin
  Result := FprMMWidth;
end;

procedure TVRWPaperSize.SetPrCode(const Value: ShortString);
begin
  FprCode := Value;
end;

procedure TVRWPaperSize.SetPrMMHeight(const Value: SmallInt);
begin
  FprMMHeight := Value;
end;

procedure TVRWPaperSize.SetPrMMWidth(const Value: SmallInt);
begin
  FprMMWidth := Value;
end;

{ TVRWPaperSizes }

function TVRWPaperSizes.Add(Code: ShortString; MMWidth,
  MMHeight: SmallInt): IVRWPaperSize;
var
  Item: IVRWPaperSize;
begin
  Item := TVRWPaperSize.Create;
  Item.prCode := Code;
  Item.prMMHeight := MMHeight;
  Item.prMMWidth := MMWidth;
  FList.Add(Item);
  Result := Item;
end;

constructor TVRWPaperSizes.Create;
begin
  inherited Create;
  FList := TInterfaceList.Create;
end;

procedure TVRWPaperSizes.CreateDefaultEntries;
begin
  FList.Clear;
{
  Add('A4',           210, 297);
  Add('Letter',       216, 279);
  Add('Executive',    216, 356);
  Add('A5',           148, 210);
  Add('B4',           250, 354);
  Add('B5',           182, 257);
}
  Add('A3',           297, 420);
  Add('A4',           210, 297);
  Add('Letter',       216, 279);
  Add('Executive',    184, 267);
  Add('Legal',        216, 356);
  Add('A5',           148, 210);
  Add('B4',           250, 354);
  Add('B5',           182, 257);
  WriteAll;
end;

destructor TVRWPaperSizes.Destroy;
begin
  FList.Free;
  inherited;
end;

function TVRWPaperSizes.ExtractPaperCode(FromStr: string): string;
{ Returns the paper code from the supplied string. The string is assumed to be
  in the format created by FillCodeList below. }
var
  CharPos: Integer;
begin
  CharPos := Pos(' ', FromStr);
  if (CharPos > 0) then
    Result := Copy(FromStr, 1, CharPos - 1)
  else
    Result := FromStr;
end;

procedure TVRWPaperSizes.FillCodeList(Strings: TStrings);
{ Fills the supplied string-list with the paper size codes and the actual
  paper sizes. Use the ExtractPaperCode function above to read the paper code
  from an entry in the string-list. }
var
  Entry: Integer;
  Item: IVRWPaperSize;
  Str: string;
begin
  Strings.Clear;
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := GetPsItem(Entry);
    Str := Item.prCode + ' ' +
           '(' +
           IntToStr(Item.prMMWidth)  + ' x ' +
           IntToStr(Item.prMMHeight) +
           ')';
    Strings.Add(Str);
  end;
end;

function TVRWPaperSizes.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TVRWPaperSizes.GetPsItem(Index: SmallInt): IVRWPaperSize;
begin
  if (Index > -1) and (Index < FList.Count) then
    Result := IVRWPaperSize(FList[Index]);
end;

function TVRWPaperSizes.GetPsItemByCode(Index: ShortString): IVRWPaperSize;
var
  Entry: Integer;
  Item: IVRWPaperSize;
  CodeToFind: ShortString;
begin
  Result := nil;
  CodeToFind := ExtractPaperCode(Index);
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWPaperSize(FList[Entry]);
    if (Item.prCode = CodeToFind) then
    begin
      Result := Item;
      Item := nil;
      Break;
    end;
    Item := nil;
  end;

  if not Assigned(Result) then
    Result := GetPsItemByCode('A4');

end;

function TVRWPaperSizes.IndexOf(Strings: TStrings;
  PaperCode: ShortString): Integer;
var
  Entry: Integer;
  Item: IVRWPaperSize;
  CodeToFind: ShortString;
begin
  Result := -1;
  CodeToFind := ExtractPaperCode(PaperCode);
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := IVRWPaperSize(FList[Entry]);
    if (Item.prCode = CodeToFind) then
    begin
      Result := Entry;
      Item := nil;
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWPaperSizes.ReadAll;
var
  IniFile: TIniFile;
  Sections: TStringList;
  Entry: Integer;
  Item: IVRWPaperSize;
  Code: ShortString;
  Path: string;
begin
  FList.Clear;
//  Path := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  Path := IncludeTrailingPathDelimiter(VAOInfo.vaoCompanyDir);
  if FileExists(Path + 'REPORTS\VRWPAPER.INI') then
  begin
    IniFile := TIniFile.Create(Path + 'REPORTS\VRWPAPER.INI');
    Sections := TStringList.Create;
    try
      IniFile.ReadSections(Sections);
      for Entry := 0 to Sections.Count - 1 do
      begin
        Code := Sections[Entry];
        Item := Add(Code, 0, 0);
        Item.prMMHeight := IniFile.ReadInteger(Code, 'MMHeight', 0);
        Item.prMMWidth  := IniFile.ReadInteger(Code, 'MMWidth',  0);
      end;
    finally
      Sections.Free;
      Inifile.Free;
    end;
  end
  else
    CreateDefaultEntries;
end;

procedure TVRWPaperSizes.SetPsItem(Index: SmallInt;
  const Value: IVRWPaperSize);
var
  Item: IVRWPaperSize;
begin
  Item := GetPsItem(Index);
  if (Item <> nil) then
  begin
    Item.prCode := Value.prCode;
    Item.prMMHeight := Value.prMMHeight;
    Item.prMMWidth := Value.prMMWidth;
  end;
  Item := nil;
end;

procedure TVRWPaperSizes.SetPsItemByCode(Index: ShortString;
  const Value: IVRWPaperSize);
var
  Item: IVRWPaperSize;
  Entry: Integer;
  CodeToFind: ShortString;
begin
  CodeToFind := ExtractPaperCode(Index);
  for Entry := 0 to FList.Count - 1 do
  begin
    Item := GetPsItem(Entry);
    if (Item.prCode = CodeToFind) then
    begin
      SetPsItem(Entry, Value);
      Item := nil;
      Break;
    end;
    Item := nil;
  end;
end;

procedure TVRWPaperSizes.WriteAll;
var
  IniFile: TIniFile;
  Entry: Integer;
  Item: IVRWPaperSize;
  Code: ShortString;
  Path: string;
begin
  Path := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  IniFile := TIniFile.Create(Path + 'REPORTS\VRWPAPER.INI');
  try
    for Entry := 0 to FList.Count - 1 do
    begin
      Item := GetPsItem(Entry);
      Code := Item.prCode;
      IniFile.WriteInteger(Code, 'MMHeight', Item.prMMHeight);
      IniFile.WriteInteger(Code, 'MMWidth',  Item.prMMWidth);
    end;
  finally
    IniFile.Free;
  end;
end;

end.
