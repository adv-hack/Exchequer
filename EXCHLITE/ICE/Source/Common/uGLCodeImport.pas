unit uGLCodeImport;

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
  TGLCodeImport = class(_ImportBase)
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
// TGLCodeImport
// ===========================================================================

procedure TGLCodeImport.AddRecord(pNode: IXMLDOMNode);
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
    FuncRes := Open_File(F[NomF], SetDrive + FileNames[NomF], 0);
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
      DoLogMessage('TGLCodeImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TGLCodeImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TGLCodeImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TGLCodeImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := Close_File(F[NomF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TGLCodeImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  end;
  inherited;
end;

function TGLCodeImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TGLCodeImport.WriteDetails(Node: IXMLDOMNode): Boolean;
var
  Key: ShortString;
  FuncRes: LongInt;
  NomTypeStr: ShortString;
  NomSpareStr: string[47];
begin
  Key := FullNomKey(_GetNodeValue(Node, 'glcode'));

  { Try to find a record matching the code. }
  FuncRes := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, 0, Key);

  Nom.NomCode    := _GetNodeValue(Node, 'glcode');
  Nom.Desc       := LJVar(_GetNodeValue(Node, 'glname'), 40);
  Nom.Cat        := _GetNodeValue(Node, 'glparent');
  NomTypeStr     := _GetNodeValue(Node, 'gltype');
  if (NomTypeStr <> '') then
    Nom.NomType  := NomTypeStr[1]
  else
    Nom.NomType  := ' ';
  Nom.NomPage    := _GetNodeValue(Node, 'glpage');
  Nom.SubType    := _GetNodeValue(Node, 'glsubtotal');
  Nom.Total      := _GetNodeValue(Node, 'gltotal');
  Nom.CarryF     := _GetNodeValue(Node, 'glcarryfwd');
  Nom.ReValue    := _GetNodeValue(Node, 'glrevalue');
  Nom.AltCode    := Uppercase(LJVar(_GetNodeValue(Node, 'glaltcode'), 50));
  Nom.PrivateRec := _GetNodeValue(Node, 'glprivaterec');
  Nom.DefCurr    := _GetNodeValue(Node, 'glcurrency');
  Nom.ForceJC    := _GetNodeValue(Node, 'glforcejc');
  Nom.HideAC     := _GetNodeValue(Node, 'glhideac');
  Nom.NomClass   := _GetNodeValue(Node, 'glclass');
  NomSpareStr    := _GetNodeValue(Node, 'glspare');
  Move(NomSpareStr[1], Nom.Spare, Length(Nom.Spare));

  if (FuncRes = 0) then
  begin
    { Record found - update the details. }
    Put_Rec(F[NomF], NomF, RecPtr[NomF]^, 0);
  end
  else
  begin
    { No record found - add a new record. }
    Add_Rec(F[NomF], NomF, RecPtr[NomF]^, 0);
  end;

  Result := True;
end;

// ---------------------------------------------------------------------------

end.
