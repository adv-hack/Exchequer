unit uDocNumberImport;

interface

uses
  SysUtils,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TDocNumberImport = class(_ImportBase)
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

// ===========================================================================
// TDocNumberImport
// ===========================================================================

procedure TDocNumberImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes: LongInt;
  ErrorCode: Integer;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    SetDrive := DataPath;
    Clear;
    { Open the table. }
    FuncRes := Open_File(F[IncF], SetDrive + FileNames[IncF], 0);
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
      DoLogMessage('TDocNumberImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TDocNumberImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TDocNumberImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TDocNumberImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[IncF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TDocNumberImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TDocNumberImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TDocNumberImport.WriteDetails(Node: IXMLDOMNode): Boolean;
var
  Key: ShortString;
  NextDocNumber: LongInt;
  FuncRes: LongInt;
begin
  Key := _GetNodeValue(Node, 'dncounttype');

  { Try to find a record matching the code. }
  FuncRes := Find_Rec(B_GetEq, F[IncF], IncF, RecPtr[IncF]^, 0, Key);

  Count.CountTyp  := Key;
  Count.LastValue := _GetNodeValue(Node, 'dnlastvalue');
  Count.Spare     := _GetNodeValue(Node, 'dnspare');

  NextDocNumber := _GetNodeValue(Node, 'dnnextcount');
  Move(NextDocNumber, Count.NextCount[1], Length(Count.NextCount));

  if (FuncRes = 0) then
  begin
    { Record found - update the details. }
    Put_Rec(F[IncF], IncF, RecPtr[IncF]^, 0);
  end
  else
  begin
    { No record found - add a new record. }
    Add_Rec(F[IncF], IncF, RecPtr[IncF]^, 0);
  end;
  Result := True;
end;

// ---------------------------------------------------------------------------

end.
