unit uGLStructureImport;

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
  TGLStructureImport = class(_ImportBase)
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
// TGLStructureImport
// ===========================================================================

procedure TGLStructureImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
  Key: ShortString;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    ErrorCode := 0;
    SetDrive := DataPath;

    { Get the identifier for the G/L Structure record (the System Settings
      tables holds multiple types of information -- the identifier allows the
      program to locate the correct record for specific information). }
    Key := SysNames[SysR];

    { Open the System Settings table... }
    FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
    if (FuncRes = 0) then
    begin
      { ...and find the G/L Structure record. }
      FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
      { Copy the details into the System Settings record structure. }
      if (FuncRes = 0) then
      begin
        FuncRes := GetPos(F[SysF], SysF, SysAddr[SysR]);
        if (FuncRes = 0) then
          isFileOpen := True
        else
          ErrorCode := cCONNECTINGDBERROR;
      end;
    end;

  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TGLStructureImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TGLStructureImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TGLStructureImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TGLStructureImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[SysF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TGLStructureImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TGLStructureImport.SaveListToDB: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TGLStructureImport.SaveListToDB', cUPDATINGDBERROR);
    Result := False;
  end
  else
    Result := True;
end;

// ---------------------------------------------------------------------------

function TGLStructureImport.WriteDetails(Node: IXMLDOMNode): Boolean;
var
  ArrayIndex: NomCtrlType;
  GLCode: Integer;
begin
  ArrayIndex := NomCtrlType(_GetNodeValue(Node, 'glindex'));
  GLCode     := _GetNodeValue(Node, 'glcode');
  if (ArrayIndex <= High(Syss.NomCtrlCodes)) then
  begin
    Syss.NomCtrlCodes[ArrayIndex] := GLCode;
    Result := True;
  end
  else
  begin
    DoLogMessage('TGLStructureImport.WriteDetails', cXMLDATAMISMATCH);
    Result := False;
  end;
end;

// ---------------------------------------------------------------------------

end.
