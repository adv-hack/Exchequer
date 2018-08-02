unit uGLStructureExport;
{
  Class for exporting the G/L Structure array.

  Example XML format:

    <?xml version="1.0"?>
    <val:glstructure xmlns:val="urn:www-iris-co-uk:glstructure">
      <message guid="" number="" count="" source="" destination="" flag="">
        <glrec>
          <glindex>0</arrayindex>
          <glcode>33020</glcode>
        </glrec>
        <glrec>
          <glindex>1</arrayindex>
          <glcode>33010</glcode>
        </glrec>
        .
        .
        .
      </message>
    </val>
}

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
  uExportBaseClass
  ;

{$I ice.inc}

type
  TGLStructureExport = class(_ExportBase)
  protected
    function BuildXmlRecord(pSyss: Pointer): Boolean; override;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass;

// ===========================================================================
// TGLStructureExport
// ===========================================================================

function TGLStructureExport.BuildXmlRecord(pSyss: Pointer): Boolean;
var
  lRootNode: IXMLDomNode;
  lNode, lRecNode: IXMLDomNode;
  Entry: NomCtrlType;
begin
  Result := False;

  { The supplied pointer should be a pointer to the System Settings record
    structure. }
  with SysRec(pSyss^) do
  begin

    { Create an XML Document handler, and load the template XML file -- the
      correct XML file spec should already have been assigned to the XMLFile
      property by the calling routine. }
    CreateXMLDoc;

    lRootNode := ActiveXMLDoc.Doc.documentElement;

    if (lRootNode <> nil) then
    try
      { Locate and delete the empty G/L section, because we are going to
        create multiple table entries. }
      lRecNode := _GetNodeByName(lRootNode, 'message');
      lRecNode.removeChild(_GetNodeByName(lRootNode, 'glrec'));

      { Add the individual G/L entries. }
      for Entry := Low(NomCtrlCodes) to High(NomCtrlCodes) do
      begin

        lNode := lRecNode.appendChild(ActiveXMLDoc.Doc.createElement('glrec'));

        _AddLeafNode(lNode, 'glindex', Ord(Entry));
        _AddLeafNode(lNode, 'glcode', NomCtrlCodes[Entry]);

      end;

      Result := True;

      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      { Add the resulting XML to the list (in this instance, there will only
        be one XML entry in the list). }
      List.Add(ActiveXMLDoc);

    except
      on E: Exception do
        DoLogMessage('TGLStructureExport.BuildXmlRecord', cBUILDINGXMLERROR, 'Error: ' +
          E.message);
    end
    else
      DoLogMessage('TGLStructureExport.BuildXmlRecord', cINVALIDXMLNODE);
  end;
end;

// ---------------------------------------------------------------------------

function TGLStructureExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  SysRecPtr: ^SysRec;
begin
  Result := False;
  ErrorCode := 0;

  { Get the identifier for the G/L Structure record (the System Settings tables
    holds multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[SysR];

  SetDrive := DataPath;

  Clear;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the G/L Structure record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
    Result := (FuncRes = 0);

    if (Result) then
    begin
      FuncRes := GetPos(F[SysF], SysF, SysAddr[SysR]);
      if (FuncRes = 0) then
      begin
        { Build the required XML record from the G/L Structure details. }
        SysRecPtr := @Syss;
        BuildXMLRecord(SysRecPtr);
      end
      else
        ErrorCode := cEXCHLOADINGVALUEERROR;
    end
    else
      ErrorCode := cEXCHLOADINGVALUEERROR;

    FuncRes := Close_File(F[SysF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TGLStructureExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));

end;

// ---------------------------------------------------------------------------

end.
