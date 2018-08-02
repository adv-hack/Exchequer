unit uVATExport;
{
  Exports the VAT Rates and VAT details to an ICE XML document.

  Example format (with additional comments):

    <?xml version="1.0"?>
    <val:vat xmlns:val="urn:www-iris-co-uk:vat">
      <message guid="" number="" count="" source="" destination="" flag="">
        <vatrec>

          <!-- VAT details -->

          <svintervalmonths></svintervalmonths>
          <svscheme></svscheme>
          <svlastreturndate></svlastreturndate>
          <svcurrentperiod></svcurrentperiod>

          <svlastecsalesdate></lastecsalesdate>
          <svolastecsalesdate></olastecsalesdate>

          <!-- VAT Rates (multiple records) -->

          <vatrate>
            <svcode>S</svcode>
            <svrate>0.175</svrate>
            <svdesc>Standard</svdesc>
          </vatrate>
          <vatrate>
            <svcode>E</svcode>
            <svrate>0</svrate>
            <svdesc>Exempt</svdesc>
          </vatrate>
          .
          .
          .

        </vatrec>
      </message>
    </val:vat>

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
  TVATExport = class(_ExportBase)
  protected
    procedure Clear; Override;
    function BuildXmlRecord(pVAT: Pointer): Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass;

// ===========================================================================
// TVATExport
// ===========================================================================

constructor TVATExport.Create;
begin
  inherited Create;
end;

// ---------------------------------------------------------------------------

destructor TVATExport.Destroy;
begin
  Clear;
  inherited Destroy;
end;

// ---------------------------------------------------------------------------

procedure TVATExport.Clear;
{ Free the records. }
var
  lCont: Integer;
  lDoc: TXMLDoc;
begin
  for lCont := List.Count - 1 downto 0 do
  begin
    if (List[lCont] <> nil) then
    begin
      if (TObject(List[lCont]) is TXMLDoc) then
      begin
        lDoc := TXMLDoc(List[lCont]);
        FreeAndNil(lDoc);
        List.Delete(lCont);
      end; { if (TObject(List[lCont])... }
    end; { if (List[lCont]... }
  end; { for lCont... }
end;

// ---------------------------------------------------------------------------

function TVATExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
begin
  Result := False;
  ErrorCode := 0;

  { Get the identifier for the VAT record (the System Settings tables holds
    multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[VATR];

  SetDrive := DataPath;

  Clear;
  
  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the VAT record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);
    Result := (FuncRes = 0);

    if (Result) then
    begin
      FuncRes := GetPos(F[SysF], SysF, SysAddr[VATR]);
      if (FuncRes = 0) then
      begin
        { Copy the VAT details from the System Settings database buffer into
          the System Settings record structure... }
        Move(Syss, SyssVAT^, Sizeof(SyssVAT^));
        { ...and build the required XML record from the VAT details. }
        BuildXMLRecord(SyssVAT);
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
    DoLogMessage('TVATExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));

end;

// ---------------------------------------------------------------------------

function TVATExport.BuildXmlRecord(pVAT: Pointer): Boolean;
var
  lRootNode: IXMLDomNode;
  lNode, lRecNode: IXMLDomNode;
  VType: VATType;
begin
  Result := False;

  { The supplied pointer should be a pointer to a VAT record structure. }
  with VATRecT(pVAT^) do
  begin

    { Create an XML Document handler, and load the template XML file -- the
      correct XML file spec should already have been assigned to the XMLFile
      property by the calling routine. }
    CreateXMLDoc;

    lRootNode := ActiveXMLDoc.Doc.documentElement;

    if (lRootNode <> nil) then
    try
      { Locate and delete the empty VAT Rate section, because we are going to
        create multiple VAT Rate entries. For the other fields in the XML
        file, we will simply locate the elements and update the values (as
        there is only one entry for each of these). }
      lRecNode := _GetNodeByName(lRootNode, 'message');
      lRecNode := _GetNodeByName(lRecNode, 'vatrec');
      lRecNode.removeChild(_GetNodeByName(lRootNode, 'vatrate'));

      { Add the individual VAT Rate entries. }
      for VType := Low(VATRates.VAT) to High(VATRates.VAT) do
      begin

        lNode := lRecNode.appendChild(ActiveXMLDoc.Doc.createElement('vatrate'));

        _AddLeafNode(lNode, 'svcode', VATRates.VAT[VType].Code);
        _AddLeafNode(lNode, 'svrate', FormatFloat('0.000', VATRates.VAT[VType].Rate));
        _AddLeafNode(lNode, 'svdesc', VATRates.VAT[VType].Desc);

      end;

      { Add the global VAT details. }
      _SetNodeValueByName(lRecNode, 'svintervalmonths',   VATRates.VATInterval);
      _SetNodeValueByName(lRecNode, 'svscheme',           VATRates.VATScheme);
      _SetNodeValueByName(lRecNode, 'svlastreturndate',   VATRates.VATReturnDate);
      _SetNodeValueByName(lRecNode, 'svcurrentperiod',    VATRates.CurrPeriod);
      _SetNodeValueByName(lRecNode, 'svolastecsalesdate', VATRates.OLastECSalesDate);
      _SetNodeValueByName(lRecNode, 'svlastecsalesdate',  VATRates.LastECSalesDate);

      Result := True;

      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      { Add the resulting XML to the list (in this instance, there will only
        be one XML entry in the list). }
      List.Add(ActiveXMLDoc);

    except
      on E: Exception do
        DoLogMessage('TVATExport.BuildXmlRecord', cBUILDINGXMLERROR, 'Error: ' +
          E.message);
    end
    else
      DoLogMessage('TVATExport.BuildXmlRecord', cINVALIDXMLNODE);
  end;
end;

// ---------------------------------------------------------------------------

end.
