unit uPeriodImport;

interface

uses
  SysUtils, Inifiles,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass;

{$I ice.inc}

type
  TPeriodImport = class(_ImportBase)
  protected
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    function SaveListToDB: Boolean; override;
  end;

implementation

{ TSystemSettingsImport }

procedure TPeriodImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  Inifile: TInifile;
  SectionNode, RecNode: IXMLDOMNode;
  Entry: Integer;
  Id, DateStr: string;
  UsePlugin: string;
begin
  Inifile := TInifile.Create(IncludeTrailingPathDelimiter(Datapath) + 'Periods.INI');
  try
    SectionNode := _GetNodeByName(pNode, 'settings');
    UsePlugin := _GetNodeValue(SectionNode, 'useplugin');
    Inifile.WriteString('SETTINGS', 'UsePlugIn', UsePlugin);
    SectionNode := nil;

    SectionNode := _GetNodeByName(pNode, 'periodlist');
    for Entry := 0 to SectionNode.childNodes.length - 1 do
    begin
      RecNode := SectionNode.childNodes[Entry];
      Id := _GetNodeValue(RecNode, 'id');
      DateStr := _GetNodeValue(RecNode, 'date');
      Inifile.WriteString('PERIODS', Id, DateStr);
      RecNode := nil;
    end;
    SectionNode := nil;
  finally
    Inifile.Free;
  end;
end;

function TPeriodImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to the file via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

end.
