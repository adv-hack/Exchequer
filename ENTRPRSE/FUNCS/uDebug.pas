{-------------------------------------------------------------------------------

  Unit name: uDebug
  Author:    Eddy Vluggen
  Purpose:   Unit to make debugging easier

  History:
  ------------------------------------------------------------------
  2-7-2001          Initial version

  Notes:
  * Project needs to be compiled with a detailed map file to work!
  * Tested under both Delphi 5 and Delphi 6
  * ExceptAddr gets reset by Application.OnException

-------------------------------------------------------------------------------}

unit uDebug;

interface
uses
  SysUtils, Contnrs, Windows, Classes;

type
  TAppExcept = class
  public
    slDontShow, slLogFiles : TStringList;
    constructor Create;
    destructor Destroy;
  private
    sEXEName : string;
    Units, Procedures, LineNumbers: TList;
    function LoadAndParseMapFile: Boolean;
    procedure CleanUpMapFile;
    function GetMapAddressFromAddress(const Address: DWORD): DWORD;
    function GetMapFileName: string;
    function GetModuleNameFromAddress(const Address: DWORD): string;
    function GetProcNameFromAddress(const Address: DWORD): string;
    function GetLineNumberFromAddress(const Address: DWORD): string;
    procedure ApplicationException(Sender: TObject; E: Exception);
  end;

var
  AppExcept : TAppExcept;

implementation
uses
  Forms, Dialogs, APIUtil, FileUtil;


const
  { Sections in .map file }
  NAME_CLASS           = 'StartLengthNameClass';
  SEGMENT_MAP          = 'Detailedmapofsegments';
  PUBLICS_BY_NAME      = 'AddressPublicsbyName';
  PUBLICS_BY_VAL       = 'AddressPublicsbyValue';
  LINE_NUMBERS         = 'Linenumbersfor';
  RESOURCE_FILES       = 'Boundresourcefiles';

type
  { Sections as enum }
  THeaderType = (htNameClass, htSegmentMap, htPublicsByName, htPublicsByValue,
    htLineNumbers, htResourceFiles);

  { unitname / pointeraddress pair -> olUnits }
  PUnitItem = ^TUnitItem;
  TUnitItem = record
    UnitName: string;
    UnitStart,
    UnitEnd: DWORD;
  end;

  { procedurename / pointeraddress pair -> olProcedures }
  PProcedureItem = ^TProcedureItem;
  TProcedureItem = record
    ProcName: string;
    ProcStart: DWORD;
  end;

  { linenumber / pointeraddress pair -> olLineNumbers }
  PLineNumberItem = ^TLineNumberItem;
  TLineNumberItem = record
    UnitName,
    LineNo: string;
    LineStart: DWORD;
  end;

function TAppExcept.LoadAndParseMapFile: Boolean;
var
  F: TextFile;
  CurrentLine,
  CurrentUnit: string;
  CurrentHeader: THeaderType;

  { helper func of SyncHeaders }
  function CompareHeaders(AHeader, ALine: string): Boolean;
  begin
    Result := Copy(ALine, 1, Length(AHeader)) = AHeader;
  end;

  { Keeps track of section in .map file }
  procedure SyncHeaders(var Header: THeaderType; Line: string);
  const
    Pfx = Length('Line numbers for ');

    function StripFromString(const Strip: char; var AString: string): string;
    var
      Pos: Cardinal;
    begin{StripFromString}
      Pos := Length(AString);
      while Pos > 0 do
      begin
        if AString[Pos] = Strip then
          Delete(AString, Pos, Length(Strip))
        else
          Dec(Pos);
      end;
      Result := AString;
    end;{StripFromString}

  begin
    Line := StripFromString(' ', Line);

    if CompareHeaders(NAME_CLASS, Line)      then Header := htNameClass;
    if CompareHeaders(SEGMENT_MAP, Line)     then Header := htSegmentMap;
    if CompareHeaders(PUBLICS_BY_NAME, Line) then Header := htPublicsByName;
    if CompareHeaders(PUBLICS_BY_VAL, Line)  then Header := htPublicsByValue;
    if CompareHeaders(LINE_NUMBERS, Line)    then
    begin
      Header := htLineNumbers;
      CurrentUnit := Copy(Line, Pfx -2, Pos('(', Line) - Pfx + 2);
    end;
    if CompareHeaders(RESOURCE_FILES, Line)  then Header := htResourceFiles;
  end;

  { Adds a segment from .map to segment-list }
  procedure AddUnit(ALine: string);
  var
    SStart: string;
    SLength: string;
    AUnitItem: PUnitItem;
  begin
    if StrToInt(Trim(Copy(ALine, 1, Pos(':', ALine) -1))) = 1 then
    begin
      SStart  := Copy(ALine, Pos(':', ALine) + 1, 8);
      SLength := Copy(ALine, Pos(':', ALine) + 10, 8);
      New(AUnitItem);
      with AUnitItem^ do
      begin
        UnitStart := StrToInt('$' + SStart);
        UnitEnd   := UnitStart + DWORD(StrToInt('$' + SLength));
        Delete(ALine, 1, Pos('M', ALine) + 1);
        UnitName := Copy(ALine, 1, Pos(' ', ALine) -1);
      end;
      Units.Add(AUnitItem);
    end;
  end;

  { Adds a public procedure from .map to procedure-list }
  procedure AddProcedure(ALine: string);
  var
    SStart: string;
    AProcedureItem: PProcedureItem;
  begin
    if StrToInt(Trim(Copy(ALine, 1, Pos(':', ALine) -1))) = 1 then
    begin
      SStart  := Copy(ALine, Pos(':', ALine) + 1, 8);
      New(AProcedureItem);
      with AProcedureItem^ do
      begin
        ProcStart := StrToInt('$' + SStart);
        Delete(ALine, 1, Pos(':', ALine) + 1);
        ProcName  := Trim(Copy(ALine, Pos(' ', ALine), Length(ALine) - Pos(' ', ALine) + 1));
      end;
      Procedures.Add(AProcedureItem);
    end;
  end;

  { Adds a lineno from .map to lineno-list }
  procedure AddLineNo(ALine: string);
  var
    ALineNumberItem: PLineNumberItem;
  begin
    while Length(Trim(ALine)) > 0 do
    begin
      New(ALineNumberItem);
      with ALineNumberItem^ do
      begin
        Aline     := Trim(ALine);
        UnitName  := CurrentUnit;
        LineNo    := Copy(ALine, 1, Pos(' ', ALine)-1);
        Delete(ALine, 1, Pos(' ', ALine) + 5);
        LineStart := StrToInt('$' + Copy(ALine, 1, 8));
        Delete(ALine, 1, 8);
      end;
      LineNumbers.Add(ALineNumberItem);
    end;
  end;

{ procedure TExtExceptionInfo.LoadAndParseMapFile }
begin

  if FileExists(GetMapFileName) then
  begin
    AssignFile(F, GetMapFileName);
    Reset(F);
    while not EOF(F) do
    begin
      ReadLn(F, CurrentLine);
      SyncHeaders(CurrentHeader, CurrentLine);
      if Length(CurrentLine) > 0 then
        if (Pos(':', CurrentLine) > 0) and (CurrentLine[1] = ' ') then
          case CurrentHeader of
            htSegmentMap:     AddUnit(CurrentLine);
            htPublicsByValue: AddProcedure(CurrentLine);
            htLineNumbers:    AddLineNo(CurrentLine);
          end;
    end;
    CloseFile(F);
    Result :=
      (Units.Count > 0) and
      (Procedures.Count > 0) and
      (LineNumbers.Count > 0);
  end
  else
    Result := False;
end;

procedure TAppExcept.CleanUpMapFile;
begin
  if Units.Count > 0 then
    while Units.Count > 0 do
    begin
      Dispose(PUnitItem(Units.Items[0]));
      Units.Delete(0);
    end;
  if Procedures.Count > 0 then
    while Procedures.Count > 0 do
    begin
      Dispose(PProcedureItem(Procedures.Items[0]));
      Procedures.Delete(0)
    end;
  if LineNumbers.Count > 0 then
    while LineNumbers.Count > 0 do
    begin
      Dispose(PLineNumberItem(LineNumbers.Items[0]));
      LineNumbers.Delete(0);
    end;

  FreeAndNil(Units);
  FreeAndNil(Procedures);
  FreeAndNil(LineNumbers);
end;

function TAppExcept.GetModuleNameFromAddress(const Address: DWORD): string;
var
  i: Integer;
begin
  for i := Units.Count -1 downto 0 do
    if ((PUnitItem(Units.Items[i])^.UnitStart <= Address) and
       (PUnitItem(Units.Items[i])^.UnitEnd >= Address)) then
    begin
      Result := PUnitItem(Units.Items[i])^.UnitName;
      Break;
    end;
end;

function TAppExcept.GetProcNameFromAddress(const Address: DWORD): string;
var
  i: Integer;
begin
  for i := Procedures.Count -1 downto 0 do
    if (PProcedureItem(Procedures.Items[i])^.ProcStart <= Address) then
    begin
      Result := PProcedureItem(Procedures.Items[i])^.ProcName;
      Break;
    end;
end;

function TAppExcept.GetLineNumberFromAddress(const Address: DWORD): string;
var
  i: Cardinal;
  LastLineNo: string;
  UnitName: string;
begin
  Result     := '';
  LastLineNo := '';
  UnitName   := GetModuleNameFromAddress(Address);

  for i := 0 to LineNumbers.Count -1 do
    if PLineNumberItem(LineNumbers.Items[i])^.UnitName = UnitName then
      if (PLineNumberItem(LineNumbers.Items[i])^.LineStart >= Address) then
      begin
        Result := LastLineNo;
        Break;
      end
      else
        LastLineNo := PLineNumberItem(LineNumbers.Items[i])^.LineNo;
end;

function TAppExcept.GetMapFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.map');
end;

function TAppExcept.GetMapAddressFromAddress(const Address: DWORD): DWORD;
const
  CodeBase = $1000;
var
  OffSet: DWORD;
  ImageBase: DWORD; //$400000: hInstance or GetModuleHandle(0)
begin
  ImageBase := hInstance;
  OffSet := ImageBase + CodeBase;

  // Map file address = Access violation address - Offset
  Result := Address - OffSet;
end;

procedure TAppExcept.ApplicationException(Sender: TObject; E: Exception);
var
  MapFileAddress: DWORD;
  UnitName, ProcedureName, LineNumber: string;
  iPos : integer;
begin
  MapFileAddress := GetMapAddressFromAddress(DWORD(ExceptAddr));
  UnitName := GetModuleNameFromAddress(MapFileAddress);
  ProcedureName := GetProcNameFromAddress(MapFileAddress);
  LineNumber := GetLineNumberFromAddress(MapFileAddress);

  if slDontShow.IndexOf(Uppercase(E.ClassName)) = -1 then
  begin
    MsgBox(E.ClassName + ' : ' + E.Message + #13#13
    + 'File :            '#9 + UnitName + #13
    + 'Procedure : '#9 + ProcedureName + #13
    + 'Line No :      '#9 + LineNumber
    , mtError, [mbOk], mbOK, sEXEName + ' Exception');
  end;

  if slLogFiles.Count > 0 then
  begin
    For iPos := 0 to slLogFiles.Count -1 do begin
      AddLineToFile(sEXEName + ' ' + DateToStr(Date) + ' ' + TimeToStr(now) + ' ' + 'EXCEPTION : '
      + E.Message, slLogFiles[iPos]);
      AddLineToFile(' - File: ' + UnitName + ', Procedure: '
      + ProcedureName + ', LineNo: ' + LineNumber, slLogFiles[iPos]);
    end;{for}
  end;{if}

//  TechSuppLog('EXCEPTION : ' + E.Message);
//  TechSuppLog('                          File : ' + UnitName + ', Procedure : ' + ProcedureName
//  + ', Line No : ' + LineNumber);
end;

constructor TAppExcept.create;
begin
  inherited;
  sEXEName := ExtractFileName(ParamStr(0));
  slLogFiles := TStringList.Create;
  slDontShow := TStringList.Create;
  Units       := TList.Create;
  Procedures  := TList.Create;
  LineNumbers := TList.Create;
  LoadAndParseMapFile;
  Application.OnException := ApplicationException;
end;

destructor TAppExcept.Destroy;
begin
  slLogFiles.Free;
  slDontShow.Free;
  CleanUpMapFile;
  inherited;
end;


end.


