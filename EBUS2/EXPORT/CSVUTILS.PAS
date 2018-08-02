unit CSVUtils;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  eBusVar, eBusCnst;

type
  TCSVHeader = (hdrNone, hdrFields, hdrDescs);
  TCSVExportFormat = (efHeadersOnly, efBothSeparate, efBothTogether);

  TMapFileRec = Record
    Filename : string;
    Description : string;
    ExportType : TExportType;
    ExportFormat : TCSVExportFormat;
    FieldSeparator : smallint;
    FieldDelimiter : smallint;
    HeaderRow : smallint;
  end;

const
  LAST_EXPORT_DATE = 'ExportDate';  // Map file last exported date key
  LAST_EXPORT_TIME = 'ExportTime';  // Map file last exported time key
  FIELD_DEFS_INI = 'DataDef.ini';   // File containing all fields for exports
  IGNORE_FIELD = 'XXXX';            // Key value in INI file for ignored fields
  IGNORE_STRING = '*** IGNORE ***'; // Ignore field displayed on screen

  CSV_DESC : array[TExportType] of string = ('Error', 'Stock', 'Account', 'StockGroup', 'TXHeader'
  , 'StockLocation', 'TXLines', 'Error');

  Delimiters : array[0..2] of char = (' ','"','''');
  Separators : array[0..3] of char = (' ',',',';',#9);

function CSVTypeNameToEnum(const CSVTypeName : string) : TExportType;
{function ReadMapFileType(const MapFileName : string) : TExportType;}
function ExtractCSVValue(Row : string; Item : integer; const Default : string = '') : string;
function GetMapFileRec(sMapFile : string) : TMapFileRec;

implementation

uses
  IniFiles, Classes, Sysutils, ExprtCSV;

//-----------------------------------------------------------------------
  
function CSVTypeNameToEnum(const CSVTypeName : string) : TExportType;
// Pre  : CSVTypeName = stock, account etc.
// Post : Returns the enumerated equivalent, etError if not found
var
  CSVType : TExportType;
begin
  Result := etError;
  for CSVType := Low(TExportType) to High(TExportType) do
    if AnsiSameText(CSVTypeName, CSV_DESC[CSVType]) then
      Result := CSVType;
end;

//-----------------------------------------------------------------------

{function ReadMapFileType(const MapFileName : string) : TExportType;
// Pre  : MapFileName = Name of a CSV mapping file
// Post : Returns the type of the mapping file, etError if unknown
var
  MapFileType : TStringList;
  SearchPos : integer;
begin
  with TMemIniFile.Create(MapFileName) do
  try
    Result := CSVTypeNameToEnum(ReadString('Details','Type',''));

{    MapFileType := TStringList.Create;
    ReadSections(MapFileType);
    SearchPos := 0;
    Result := etError;
    while (SearchPos < MapFileType.Count) and (Result = etError) do
    begin
      Result := CSVTypeNameToEnum(ReadString('Details','Type','');
      if Result = etError then
        inc(SearchPos);
    end;
    MapFileType.Free;
  finally
    Free;
  end;
end;}

//-----------------------------------------------------------------------

function ExtractCSVValue(Row : string; Item : integer; const Default : string = '') : string;
// Pre  : Row = string as a row in a CSV file i.e. values separated with commas
//        Item = Which value to extract
//        Default = default value to return if none found e.g. Item = 3 when only 2 values
// Post : Returns the selected Item from a CSV row
var
  Values : array of string;
  Count,
  Posn : integer;
begin
  Count := 0;
  Posn := Pos(',', Row);
  while Posn > 0 do
  begin
    inc(Count);
    SetLength(Values, Count);
    Values[Count-1] := copy(Row, 1, Posn-1);
    Delete(Row, 1, Posn);
    Posn := Pos(',', Row);
  end;
  // Add the value after the final comma into the array, if not blank
  if length(Row) > 0 then
  begin
    inc(Count);
    SetLength(Values, Count);
    Values[Count-1] := Row;
  end;

  if Count = 0 then
    Result := Row
  else
    if Item > Count then
      Result := ''
    else
      Result := Values[Count-1];
  if (Result = '') and (Default <> '') then
    Result := Default;
end; // TfrmFieldSelect.ExtractCSVValue

function GetMapFileRec(sMapFile : string) : TMapFileRec;
var
  sString : string;
begin
  if FileExists(sMapFile) then begin
    with TiniFile.Create(sMapFile) do begin
      Result.Filename := ExtractFilename(sMapFile);
      Result.Description := ReadString('Details', 'Description' , '');
      Result.ExportType := CSVTypeNameToEnum(ReadString('Details', 'Type' , ''));

      sString := ReadString('Details', 'ExportFormat' , '');
      if sString = 'HeadersOnly' then Result.ExportFormat := efHeadersOnly
      else begin
        if sString = 'BothSeparate' then Result.ExportFormat := efBothSeparate
        else begin
          if sString = 'BothTogether' then Result.ExportFormat := efBothTogether;
        end;{if}
      end;{if}

      Result.FieldDelimiter := ReadInteger('Details', 'FieldDelimiter' , 0);
      Result.FieldSeparator := ReadInteger('Details', 'FieldSeparator' , 0);
      Result.HeaderRow := ReadInteger('Details', 'HeaderRow' , 0);

      Free;
    end;{with}
  end;{if}
end;

end.

