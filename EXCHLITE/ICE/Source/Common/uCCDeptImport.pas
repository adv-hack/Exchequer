unit uCCDeptImport;

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
  TCCDeptImport = class(_ImportBase)
  private
    fImportType: TCCDeptImportType;
    function IsCostCentre: Boolean;
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
    property ImportType: TCCDeptImportType read fImportType write fImportType;
  end;

implementation

uses
  BtKeys1U;

// ===========================================================================
// TCCDeptImport
// ===========================================================================

procedure TCCDeptImport.AddRecord(pNode: IXMLDOMNode);
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
    FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
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
      DoLogMessage('TCCDeptImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TCCDeptImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TCCDeptImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TCCDeptImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[PwrdF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TCCDeptImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TCCDeptImport.IsCostCentre: Boolean;
begin
  Result := (fImportType = cdImportCostCentres);
end;

// ---------------------------------------------------------------------------

function TCCDeptImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TCCDeptImport.WriteDetails(Node: IXMLDOMNode): Boolean;
var
  FuncRes: LongInt;
  Code: ShortString;
  Key: ShortString;
  RecPFix, SubType: Char;
begin
  RecPfix := CostCCode;
  Subtype := CSubCode[IsCostCentre];

  Code := _GetNodeValue(Node, 'cdcode');
  Key := FullCCKey(RecPFix, SubType, Code);

  { Try to find a record matching the code. }
  FuncRes := Find_Rec(B_GetEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);
  { Prepare the new or updated record }
  Password.RecPfix := RecPFix;
  Password.SubType := SubType;
  Password.CostCtrRec.PCostC := Uppercase(FullCCDepKey(Code));
  Password.CostCtrRec.CCDesc := _GetNodeValue(Node, 'cdname');
  Password.CostCtrRec.HideAC := _GetNodeValue(Node, 'cdhideac');
  Password.CostCtrRec.CCTag  := _GetNodeValue(Node, 'cdcctag');
  { Save the record }
  if (FuncRes = 0) then
  begin
    { Record found - update the details. }
    Put_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0);
  end
  else
  begin
    { No record found - add a new record. }
    Add_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0);
  end;
  Result := True;
end;

// ---------------------------------------------------------------------------

end.
