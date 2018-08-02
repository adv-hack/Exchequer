unit uVersionExport;
{
  Exports the version details of the installed IRIS Exchequer/Accounts Office
  system, in XML format.

    <?xml version="1.0" encoding="ISO-8859-1"?>
    <val:version xmlns:val="urn:www-iris-co-uk:version">
      <message guid="" number="0" count="0" source="" destination="" flag="0" plugin="0" datatype="16" desc="" xsl="version.xsl" xsd="version.xsd" startperiod="0" startyear="0" endperiod="0" endyear="0">

        <!-- Basic licence/product details -->

        <vrdetails>
          <vrmodule>2</vrmodule>
          <vrcurrency>2</vrcurrency>
          <vrproduct>2</vrproduct>
        </vrdetails>

        <!-- List of installed modules -->

        <vrmodules>
          <vrinstalled>4</vrinstalled>
          <vrinstalled>10</vrinstalled>
          <vrinstalled>20</vrinstalled>
          <vrinstalled>21</vrinstalled>
        </vrmodules>
      </message>
    </val:version>

}

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  EntLicence,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TVersionExport = class(_ExportBase)
  private
    function WriteDetails(Node: IXMLDOMNode): Boolean;
    function WriteModules(Node: IXMLDOMNode): Boolean;
  public
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
  end;

implementation

{ TVersionExport }

destructor TVersionExport.Destroy;
begin
  Clear;
  inherited;
end;

function TVersionExport.LoadFromDB: Boolean;
var
  RootNode, SectionNode, RecNode: IXMLDOMNode;
begin
  Result := False;

  SetDrive := DataPath;

  Clear;

  { Create an XML Document handler, and load the template XML file -- the
    correct XML file spec should already have been assigned to the XMLFile
    property by the calling routine. }
  CreateXMLDoc;

  RootNode := ActiveXMLDoc.Doc.documentElement;

  if (RootNode <> nil) then
  try
    { Locate and delete the empty sections, because we are going to
      create the entries from scratch. }
    SectionNode := _GetNodeByName(RootNode, 'message');
    SectionNode.removeChild(_GetNodeByName(RootNode, 'vrdetails'));
    SectionNode.removeChild(_GetNodeByName(RootNode, 'vrmodules'));

    RecNode := SectionNode.appendChild(ActiveXMLDoc.Doc.createElement('vrdetails'));
    Result := WriteDetails(RecNode);

    if Result then
    begin
      RecNode := SectionNode.appendChild(ActiveXMLDoc.Doc.createElement('vrmodules'));
      Result := WriteModules(RecNode);
    end;

    if Result then
    begin
      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      List.Add(ActiveXMLDoc);
    end;
    
  except

    on E:Exception do
    begin
      Result := False;
      DoLogMessage('TVersionExport.LoadFromDB', cBUILDINGXMLERROR, 'Error: ' + E.Message);
    end;

  end;

end;

function TVersionExport.WriteDetails(Node: IXMLDOMNode): Boolean;
begin
  Result := True;
  _AddLeafNode(Node, 'vrmodule',   Ord(EnterpriseLicence.elModuleVersion));
  _AddLeafNode(Node, 'vrcurrency', Ord(EnterpriseLicence.elCurrencyVersion));
  _AddLeafNode(Node, 'vrproduct',  Ord(EnterpriseLicence.elProductType));
end;

function TVersionExport.WriteModules(Node: IXMLDOMNode): Boolean;
var
  Module: TelEntModuleEnum;
begin
  Result := True;
  { For each module... }
  for Module := Low(TelEntModuleEnum) to High(TelEntModuleEnum) do
  begin
    { ...if it is installed... }
    if (EnterpriseLicence.elModules[Module] <> mrNone) then
    begin
      { ...add it to the list of installed modules. }
      _AddLeafNode(Node, 'vrinstalled', Ord(Module));
    end;
  end;
end;

end.
