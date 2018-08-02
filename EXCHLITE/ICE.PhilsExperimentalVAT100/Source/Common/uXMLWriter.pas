unit uXMLWriter;
{
  Very simple XML Generator.
}
interface

uses SysUtils, Classes, Variants;

type
  TXMLWriter = class(TObject)
  private
    fXML: TStringList;
    fFileName: string;
    fIndentBy: Integer;
    fNameSpace: string;
    fNameSpaceURI: string;
    fStartYear: Integer;
    fEndYear: Integer;
    fStartPeriod: Integer;
    fEndPeriod: Integer;
    function AsHTML(Line: string): string;
    function Indent(NoOfSpaces: Integer): string;
    function MakeHeader: string;
    function MakeNameSpace(NameSpace, URI: string): string;
    function MakeEmptyTag(TagName: string): string;
    function MakeOpeningTag(TagName: string): string;
    function MakeClosingTag(TagName: string): string;
    function MakeCDATATag(TagName: string): string;
    property IndentBy: Integer read fIndentBy write fIndentBy;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddCDATATag(TagName: string);
    procedure AddClosingTag(TagName: string);
    procedure AddEmptyTag(TagName: string);
    procedure AddLeafTag(TagName: string; Contents: Variant);
    procedure AddOpeningTag(TagName: string);
    procedure Finish;
    procedure Start(DataType: Integer; BaseXMLName: string);
    property FileName: string read fFileName write fFileName;
    property NameSpace: string read fNameSpace write fNameSpace;
    property NameSpaceURI: string read fNameSpaceURI write fNameSpaceURI;
    property StartPeriod: Integer read fStartPeriod write fStartPeriod;
    property StartYear: Integer read fStartYear write fStartYear;
    property EndPeriod: Integer read fEndPeriod write fEndPeriod;
    property EndYear: Integer read fEndYear write fEndYear;
    property XML: TStringList read fXML;
  end;

implementation

uses uCommon;

{ TXMLWriter }

procedure TXMLWriter.AddCDATATag(TagName: string);
begin
  fXML.Add(Indent(IndentBy) + MakeCDATATag(TagName));
end;

procedure TXMLWriter.AddClosingTag(TagName: string);
begin
  fIndentBy := fIndentBy - 2;
  fXML.Add(Indent(IndentBy) + MakeClosingTag(TagName));
end;

procedure TXMLWriter.AddEmptyTag(TagName: string);
begin
  fXML.Add(Indent(IndentBy) + MakeEmptyTag(TagName));
end;

procedure TXMLWriter.AddLeafTag(TagName: string; Contents: Variant);
var
  ContentsAsString: string;
  VType: TVarType;
  OldSeparator: Char;
begin
  VType := VarType(Contents);
  if (VType = varOLEStr) or
     (VType = varStrArg) or
     (VType = varString) then
    ContentsAsString := AsHTML(Contents)
  else if (VType = varSingle) or
          (VType = varDouble) then
  begin
    OldSeparator := SetDecimalSeparator('.');
    try
      ContentsAsString := FormatFloat('0.000000', Contents);
    finally
      SetDecimalSeparator(OldSeparator);
    end;
  end
  else
    ContentsAsString := Contents;
  ContentsAsString := Trim(ContentsAsString);
  fXML.Add(Indent(IndentBy) +
           MakeOpeningTag(TagName) +
           ContentsAsString +
           MakeClosingTag(TagName));
end;

procedure TXMLWriter.AddOpeningTag(TagName: string);
begin
  fXML.Add(Indent(IndentBy) + MakeOpeningTag(TagName));
  fIndentBy := fIndentBy + 2;
end;

function TXMLWriter.AsHTML(Line: string): string;
begin
  Result := StringReplace(Line,   '&', '&amp;', [rfReplaceAll]);
  Result := StringReplace(Result, '<', '&lt;',  [rfReplaceAll]);
  Result := StringReplace(Result, '>', '&gt;',  [rfReplaceAll]);
end;

constructor TXMLWriter.Create;
begin
  inherited Create;
  fXML := TStringList.Create;
  fIndentBy := 0;
  fNameSpaceURI := 'www-iris-co-uk';
  fNameSpace := '[NAMESPACE_NOT_DEFINED]';
end;

destructor TXMLWriter.Destroy;
begin
  FreeAndNil(fXML);
  inherited;
end;

procedure TXMLWriter.Finish;
begin
  AddClosingTag('message');
  AddClosingTag(Format('val:%s', [fNameSpace]));
end;

function TXMLWriter.Indent(NoOfSpaces: Integer): string;
begin
  Result := StringOfChar(' ', NoOfSpaces);
end;

function TXMLWriter.MakeCDATATag(TagName: string): string;
begin
  Result := MakeOpeningTag(TagName) +
            '<![CDATA[]]>' +
            MakeClosingTag(TagName);
end;

function TXMLWriter.MakeClosingTag(TagName: string): string;
begin
  Result := Lowercase(Format('</%s>', [TagName]));
end;

function TXMLWriter.MakeEmptyTag(TagName: string): string;
begin
  Result := Lowercase(Format('<%s/>', [TagName]));
end;

function TXMLWriter.MakeHeader: string;
begin
  Result := '<?xml version="1.0" encoding="ISO-8859-1"?>';
end;

function TXMLWriter.MakeNameSpace(NameSpace, URI: string): string;
begin
  Result := Lowercase(Format('<val:%s xmlns:val="urn:%s:%s">', [NameSpace, URI, NameSpace]));
end;

function TXMLWriter.MakeOpeningTag(TagName: string): string;
begin
  Result := Lowercase(Format('<%s>', [TagName]));
end;

procedure TXMLWriter.Start(DataType: Integer; BaseXMLName: string);
begin
  fXML.Clear;
  fIndentBy := 0;
  fXML.Add(MakeHeader);
  fXML.Add(MakeNameSpace(fNameSpace, fNameSpaceURI));
  fIndentBy := 2;
  fXML.Add(Indent(fIndentBy) +
           Format(
             '<message guid="" number="0" count="0" ' +
             'source="" destination="" flag="0" ' +
             'plugin="" datatype="%d" desc="" ' +
             'xsl="%s.xsl" ' +
             'xsd="%s.xsd" ' +
             'startperiod="%s" ' +
             'startyear="%s" ' +
             'endperiod="%s" ' +
             'endyear="%s" ' +
             '>',
             [
               DataType,
               BaseXMLName,
               BaseXMLName,
               IntToStr(StartPeriod),
               IntToStr(StartYear),
               IntToStr(EndPeriod),
               IntToStr(EndYear)
             ]
           )
          );
  fIndentBy := 4;
end;

end.
