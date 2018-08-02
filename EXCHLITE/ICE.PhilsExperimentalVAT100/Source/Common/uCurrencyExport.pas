unit uCurrencyExport;
{
  Exports the Currency details to an ICE XML document.

  Example format:

    <?xml version="1.0"?>
    <val:curr xmlns:val="urn:www-iris-co-uk:curr">
      <message guid="" number="" count="" source="" destination="" flag="">
        <currpage>
          <pageno>0</pageno>
          <currec>
            <screensymb>£</screensymb>
            <printersymb>£</printersymb>
            <name>Consolidatd</name>
            <dailyrate>1</dailyrate>
            <companyrate>1</companyrate>
            <trieuro>0</trieuro>
            <trirates>0</trirates>
            <triinvert>False</triinvert>
            <trifloat>False</trifloat>
          </currec>
          <currec>
            <screensymb>£</screensymb>
            <printersymb>£</printersymb>
            <name>Sterling</name>
            <dailyrate>1</dailyrate>
            <companyrate>1</companyrate>
            <trieuro>0</trieuro>
            <trirates>0</trirates>
            <triinvert>False</triinvert>
            <trifloat>False</trifloat>
          </currec>
          .
          .
          .
        </currpage>
        <currpage>
          <pageno>1</pageno>
          <currec>
            <screensymb></screensymb>
            <printersymb></printersymb>
            <name></name>
            <dailyrate>0</dailyrate>
            <companyrate>0</companyrate>
          </currec>
        </currpage>
        .
        .
        .
      </message>
    </val:curr>

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
  TCurrencyExport = class(_ExportBase)
  private
    function PrepareXML: IXMLDomNode;
    function ReadCurrencyDetails: Boolean;
    function WriteCurrencyDetails(RootNode: IXMLDomNode): Boolean;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass,
  BtSupU1;

// ===========================================================================
// TCurrencyExport
// ===========================================================================

function TCurrencyExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  ErrorCode: Integer;
  RootNode: IXMLDomNode;
begin
  Result := False;
  ErrorCode := 0;

  SetDrive := DataPath;

  Clear;

  { Open the System Settings table. }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin
    { Read all the currency details into the global Syss record structure. }
    if ReadCurrencyDetails then
    begin
      { Write the currency details out to XML. }
      RootNode := PrepareXML;
      if (RootNode <> nil) and WriteCurrencyDetails(RootNode) then
      begin
        { Remove any comments from the XML. }
        RemoveComments;
        { Add the resulting XML to the list (in this instance, there will only
          be one XML entry in the list). }
        List.Add(ActiveXMLDoc);
        Result := True;
      end
      else
        ErrorCode := cWRITINGXMLERROR;
    end
    else
      ErrorCode := cREADINGDATAERROR;
    FuncRes := Close_File(F[SysF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TCurrencyExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));

end;

// ---------------------------------------------------------------------------

function TCurrencyExport.PrepareXML: IXMLDomNode;
begin
  { Create an XML Document handler, and load the template XML file -- the
    correct XML file spec should already have been assigned to the XMLFile
    property by the calling routine. }
  CreateXMLDoc;
  Result := ActiveXMLDoc.Doc.documentElement;
end;

// ---------------------------------------------------------------------------

function TCurrencyExport.ReadCurrencyDetails: Boolean;
var
  TempSys  :  Sysrec;
  Key2F    :  Str255;
  LStatus  :  SmallInt;
  SysMode :  SysRecTypes;
  ModeNo: Integer;
const
  // There are three 'pages' of Currency details.
  Modes: array[0..5] of SysRecTypes =
    (
      CurR,
      CuR2,
      CuR3,
      GCuR,
      GCU2,
      GCU3
    );
begin
  TempSys := Syss;
  Result := True;
  try
    for ModeNo := Low(Modes) to High(Modes) do
    begin
      SysMode := Modes[ModeNo];

      Key2F := SysNames[SysMode];
      LStatus := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key2F);

      if (lStatus = 0) then
      begin

        LStatus := GetPos(F[SysF],SysF,SysAddr[SysMode]);

        if (LStatus = 0) then
        begin
          case SysMode of
            CurR, CuR2, CuR3:
              begin
                Move(Syss, SyssCurr1P^, Sizeof(SyssCurr1P^));
                SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                            SyssCurr1P^,
                            SyssCurr^,
                            BOn);
              end;
            GCuR, GCU2, GCU3:
              begin
                Move(Syss, SyssGCur1P^, Sizeof(SyssGCur1P^));
                SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                            SyssGCuR1P^,
                            SyssGCuR^,
                            BOn);
              end;
          end; { case SysMode of... }
        end; { if (lStatus = 0)... }
      end; { if (lStatus = 0)... }
    end; { for ModeNo := Low(Modes)... }
  except
    on Exception do
    begin
      Result := False;
    end;
  end;
  Syss := TempSys;
end;

// ---------------------------------------------------------------------------

function TCurrencyExport.WriteCurrencyDetails(RootNode: IXMLDomNode): Boolean;
var
  i: Integer;
  lRecNode: IXMLDomNode;
  lPageNode: IXMLDomNode;
  lNode: IXMLDomNode;
  Symbol: string;
const
  PageBoundaries: set of Byte = [0, 31, 61];
  AS_CDATA = True;
begin
  try
    { Locate and delete the empty Currency section, because we are going to
      create multiple Currency table entries. For the other fields in the XML
      file, we will simply locate the elements and update the values (as
      there is only one entry for each of these). }
    lRecNode := _GetNodeByName(RootNode, 'message');
    lRecNode.removeChild(_GetNodeByName(RootNode, 'currpage'));

    { Create XML nodes for each record in the Currencies array, assigning
      them to the relevant currency 'page'. }
    for i := Low(SyssCurr^.Currencies) to High(SyssCurr^.Currencies) do
    begin
      { If this is the start of a new page, add a page node. }
      if (i in PageBoundaries) then
      begin
        lPageNode := lRecNode.appendChild(ActiveXMLDoc.Doc.createElement('currpage'));
        case i of
           0: _AddLeafNode(lPageNode, 'pageno', 0);
          31: _AddLeafNode(lPageNode, 'pageno', 1);
          61: _AddLeafNode(lPageNode, 'pageno', 2);
        end;
      end;

      { Create the XML node, and add the fields. }
      lNode := lPageNode.appendChild(ActiveXMLDoc.Doc.createElement('currrec'));

      Symbol := SyssCurr^.Currencies[i].Ssymb;
      if (Symbol = 'œ') then
        Symbol := '£';

      _AddLeafNode(lNode, 'scsymbol', Symbol, AS_CDATA);
      SetAsCDATASection('scsymbol');

      Symbol := SyssCurr^.Currencies[i].PSymb;
      if (Symbol = 'œ') then
        Symbol := '£';

      _AddLeafNode(lNode, 'scprintsymb', Symbol, AS_CDATA);
      SetAsCDATASection('scprintsymb');

      _AddLeafNode(lNode, 'scdesc',        SyssCurr^.Currencies[i].Desc, AS_CDATA);
      _AddLeafNode(lNode, 'scdailyrate',   SyssCurr^.Currencies[i].CRates[True]);
      _AddLeafNode(lNode, 'sccompanyrate', SyssCurr^.Currencies[i].CRates[False]);

      _AddLeafNode(lNode, 'sctrieuroccy',  SyssGCur^.GhostRates.TriEuro[i]);
      _AddLeafNode(lNode, 'sctrirate',     SyssGCur^.GhostRates.TriRates[i]);
      _AddLeafNode(lNode, 'sctriinvert',   SyssGCur^.GhostRates.TriInvert[i]);
      _AddLeafNode(lNode, 'sctrifloating', SyssGCur^.GhostRates.TriFloat[i]);
    end;

    Result := True;
  except
    on E:Exception do
    begin
      Result := False;
    end;
  end;
end;

// ---------------------------------------------------------------------------

end.
