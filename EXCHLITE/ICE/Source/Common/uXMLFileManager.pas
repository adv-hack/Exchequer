unit uXMLFileManager;

interface

uses SysUtils, Windows, Classes;

{
  TXMLFileManager is a class for saving XML files exported by ICE, ready to be
  picked up and transmitted by the DSR.
}

type
  TXMLFileManager = class
  private
    fBaseFileName: string;
    fDirectory: string;
    fHex: string;

    { Verify checks that all the parameters have been set up for the file
      manager, and raises an exception if there are any omissions. }
    procedure Verify;

    { NextFileName returns the next available file name, using the Base
      File Name plus an alphanumeric extension (actually a hex number). Raises
      an exception if no more numbers are available for an 8 character name. }
    function NextFileName: string;

    procedure SetDirectory(const Value: string);
    procedure SetExtension(const Value: Integer);
    procedure SetBaseFileName(const Value: string);
//    property Extension: Integer read fExtension write SetExtension;
    property Hex: string read fHex write fHex;
  public

    { Deletes all the XML files which match the Base File Name. }
    procedure ClearDirectory;

    { Saves the supplied XML, using the next available file name. }
    function SaveXML(XML: WideString): string;

    { Directory specifies the directory into which the files should be saved. }
    property Directory: string read fDirectory write SetDirectory;

    { BaseFileName is a short prefix to be used as the basis for creating
      unique file names when saving files. Ideally it should be no more 3 or
      (at most) 4 characters, to avoid running out of extension numbers. See
      NextFileName. }
    property BaseFileName: string read fBaseFileName write SetBaseFileName;

  end;
  EXMLFileManager = class(Exception)
  end;

implementation

var
  Extension: Integer = 0;

// ============================================================================
// TXMLFileManager
// ============================================================================

procedure TXMLFileManager.ClearDirectory;
var
  SearchRec: TSearchRec;
  Found: Integer;
begin
  Verify;
  Found := FindFirst(Directory + BaseFileName + '*.xml', faAnyFile, SearchRec);
  try
    while (Found = 0) do
    begin
      SysUtils.DeleteFile(Directory + SearchRec.Name);
      Found := FindNext(SearchRec);
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

// ----------------------------------------------------------------------------

function TXMLFileManager.NextFileName: string;
var
  HexLen: Integer;
  MaxHex: string;
  Hex: string;
begin

  Verify;

  { Assume 8.3 filenames, and calculate the maximum hex number that can be
    used, based on the number of characters left after taking the Base File
    Name into account. }
  HexLen := 8 - Length(BaseFileName);
  MaxHex := StringOfChar('F', HexLen);
  Hex    := '';
//  Extension := 0;
  repeat
    if (Hex = MaxHex) then
      raise EXMLFileManager.Create('No more file names available.');
    Hex := IntToHex(Extension, HexLen);
    Extension := Extension + 1;
    Result := Directory + BaseFileName + Hex + '.xml';
  until not FileExists(Result);

end;

// ----------------------------------------------------------------------------

function TXMLFileManager.SaveXML(XML: WideString): string;
var
  FileOut: TextFile;
  FileName: AnsiString;
begin
  FileName := NextFileName;

//  { Alternative method 1 for getting file name. }
//  FileName := StringOfChar(#0, 255);
//  GetTempFileName(PChar(Directory), PChar(BaseFileName), 0, PChar(FileName));

//  { Alternative method 2 for getting file name. }
//  repeat
//    FileName := Directory + BaseFileName + FormatDateTime('hhnnsszzz', Now) + '.xml';
//  until not FileExists(FileName);

  { The xml property of TXMLDoc (the most likely source of the supplied XML
    string) will return the XML with the encoding instruction removed.

    (See:
    http://msdn.microsoft.com/library/en-us/dnxml/html/xmlencodings.asp,
    esp. the last two paragraphs of the 'Creating new XML documents'
    section).

    We need to put the encoding back in, if it does not exist, otherwise
    reloading a saved copy of the file will choke over pound signs and some
    other characters. }

  if (Pos('encoding', XML) = 0) then
    XML := StringReplace(XML, '?>', ' encoding="ISO-8859-1"?>', []);

  AssignFile(FileOut, FileName);
  Rewrite(FileOut);
  try
    Write(FileOut, XML);
    Result := FileName;
  finally
    CloseFile(FileOut);
  end;

end;

// ----------------------------------------------------------------------------

procedure TXMLFileManager.SetBaseFileName(const Value: string);
begin
  fBaseFileName := Trim(Value);
  Extension     := 0;
end;

// ----------------------------------------------------------------------------

procedure TXMLFileManager.SetDirectory(const Value: string);
begin
  if (Trim(Value) <> '') then
    fDirectory := IncludeTrailingPathDelimiter(Trim(Value))
  else
    fDirectory := Trim(Value);
end;

// ----------------------------------------------------------------------------

procedure TXMLFileManager.SetExtension(const Value: Integer);
begin
//  fExtension := Value;
end;

// ----------------------------------------------------------------------------

procedure TXMLFileManager.Verify;
begin
  if (Directory = '') then
    raise EXMLFileManager.Create('Output directory not specified for XML files.')
  else if not ForceDirectories(Directory) then
    raise EXMLFileManager.Create('Could not create output directory ' +
                                 Directory +
                                 ' for XML files.')
  else if (BaseFileName = '') then
    raise EXMLFileManager.Create('Base file name not specified for XML files.')
  else if (Length(BaseFileName) > 6) then
    raise EXMLFileManager.Create('Base file name "' + BaseFileName + '" ' +
                                 'is too long (should be no more than 6 characters).');
end;

// ----------------------------------------------------------------------------

end.
