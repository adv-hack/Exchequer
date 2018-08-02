unit uPeriodExport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,
  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TPeriodExport = class(_ExportBase)
  protected
//    function BuildXmlRecord(pSys: Pointer): Boolean; override;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses Inifiles, StrUtils;

{ TPeriodExport }

function TPeriodExport.LoadFromDB: Boolean;
var
  Inifile: TInifile;
  PeriodList: TStringList;
  RootNode, MessageNode, BaseNode, SectionNode, RecNode: IXMLDOMNode;
  PeriodName: string;
  Entry: Integer;
begin
  Result := False;
  Inifile := TInifile.Create(IncludeTrailingPathDelimiter(DataPath) + 'PERIODS.INI');
  PeriodList := TStringList.Create;
  try

    { Create an XML Document handler, and load the template XML file -- the
      correct XML file spec should already have been assigned to the XMLFile
      property by the calling routine. }
    CreateXMLDoc;

    RootNode := ActiveXMLDoc.Doc.documentElement;

    if (RootNode <> nil) then
    try
      MessageNode := _GetNodeByName(RootNode,    'message');
      BaseNode    := _GetNodeByName(MessageNode, 'periodrec');
      
      BaseNode.removeChild(_GetNodeByName(BaseNode, 'settings'));
      BaseNode.removeChild(_GetNodeByName(BaseNode, 'periodlist'));

      { Base settings }
      SectionNode := BaseNode.appendChild(ActiveXMLDoc.Doc.createElement('settings'));
      _AddLeafNode(SectionNode, 'useplugin', Inifile.ReadString('Settings', 'UsePlugIn', 'FALSE'));
      SectionNode := nil;

      { Periods and values }
      SectionNode := BaseNode.appendChild(ActiveXMLDoc.Doc.createElement('periodlist'));

      Inifile.ReadSectionValues('Periods', PeriodList);

      { For each period, add a new node and assign the period and date
        values. }
      for Entry := 0 to PeriodList.Count - 1 do
      begin
        PeriodName := PeriodList.Names[Entry];
        RecNode := SectionNode.appendChild(ActiveXMLDoc.Doc.createElement('period'));

        _AddLeafNode(RecNode, 'id', PeriodName);
        _AddLeafNode(RecNode, 'date', PeriodList.Values[PeriodName]);
      end;

      SectionNode := nil;

      { Add the resulting XML to the list (in this instance, there will only
        be one XML entry in the list). }
      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;
      List.Add(ActiveXMLDoc);

      Result := True;

    finally
      RootNode := nil;
    end;

  finally
    PeriodList.Free;
    Inifile.Free;
  end;
end;

end.
