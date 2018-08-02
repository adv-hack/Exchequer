unit uHistoryImport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass
  ;

{$I ice.inc}

type
  THistoryImport = class(_ImportBase)
  private
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  EtStrU,
  BtKeys1U;

// ===========================================================================
// THistoryImport
// ===========================================================================

procedure THistoryImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    ErrorCode := 0;
    SetDrive := DataPath;

    { Open the table. }
    FuncRes := Open_File(F[NHistF], SetDrive + FileNames[NHistF], 0);
    if (FuncRes = 0) then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('THistoryImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('THistoryImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor THistoryImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor THistoryImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[NHistF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('THistoryImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function THistoryImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function THistoryImport.WriteDetails(Node: IXMLDOMNode): Boolean;

  function HexChar(c: Char): Byte;
  begin
    case c of
      '0'..'9':  Result := Byte(c) - Byte('0');
      'a'..'f':  Result := (Byte(c) - Byte('a')) + 10;
      'A'..'F':  Result := (Byte(c) - Byte('A')) + 10;
    else
      Result := 0;
    end;
  end;

  function HexByte(s : ShortString): Char;
  begin
    Result := Char((HexChar(s[1]) shl 4) + HexChar(s[2]));
  end;

  function HexStrToString(const s : string) : string; var
    i : integer;
  begin
    Result := '';
    i := 1;
    while i < Length(s) do
    begin
      Result := Result + HexByte(Copy(s, i, 2));

      i := i + 2;
    end;
  end;

  function ToChar(const Value: string): Char;
  begin
    if (Trim(Value) <> '') then
      Result := Char(StrToInt(Value))
    else
      Result := #0;
  end;

var
  FuncRes: LongInt;
begin

  { Clear the History record. }
  FillChar(NHist, SizeOf(NHistF), 0);

  { Read the details from the XML to the History record. }
  NHist.Code      := LJVar(HexStrToString(_GetNodeValue(Node, 'nhcode')), 20);
  NHist.ExClass   := ToChar(_GetNodeValue(Node, 'nhexclass'));
  NHist.Cr        := _GetNodeValue(Node, 'nhcr');
  NHist.Yr        := _GetNodeValue(Node, 'nhyr');
  NHist.Pr        := _GetNodeValue(Node, 'nhpr');
  NHist.Sales     := _GetNodeValue(Node, 'nhsales');
  NHist.Purchases := _GetNodeValue(Node, 'nhpurchases');
  NHist.Budget    := _GetNodeValue(Node, 'nhbudget');
  NHist.Cleared   := _GetNodeValue(Node, 'nhcleared');
  NHist.Budget2   := _GetNodeValue(Node, 'nhbudget2');
  NHist.Value1    := _GetNodeValue(Node, 'nhvalue1');
  NHist.Value2    := _GetNodeValue(Node, 'nhvalue2');
  NHist.Value3    := _GetNodeValue(Node, 'nhvalue3');

  { Add the record to the History file. }
  FuncRes := Add_Rec(F[NHistF], NHistF, RecPtr[NHistF]^, 0);

  if (FuncRes <> 0) then
  begin
    Result := False;
    if (FuncRes <> 0) then
      DoLogMessage('THistoryImport.WriteDetails', cPOSTINGDBVALUEERROR,
                   'Error: ' + IntToStr(FuncRes))
  end
  else
    Result := True;
end;

// ---------------------------------------------------------------------------

end.
