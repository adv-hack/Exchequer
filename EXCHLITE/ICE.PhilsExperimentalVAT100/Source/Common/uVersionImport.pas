unit uVersionImport;

interface

uses
  SysUtils, Inifiles,

  // ICE units
  MSXML2_TLB,
  uBaseClass,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uCrypto,
  uImportBaseClass;

{$I ice.inc}

type
  TVersionImport = class(_ImportBase)
  protected
    procedure AddRecord(pNode: IXMLDOMNode); override;
    procedure EnableFile(FileName: string; Enable: Boolean);
  public
    function SaveListToDB: Boolean; override;
  end;

implementation

{ TVersionImport }

procedure TVersionImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  Inifile: TInifile;
  RecNode: IXMLDOMNode;
  Entry: Integer;
  Id: string;
  FileName: string;
begin
  FileName := IncludeTrailingPathDelimiter(Datapath) + cICEFOLDER + '\ICETrack.dat';
  EnableFile(FileName, True);
  Inifile := TInifile.Create(FileName);
  try
    if (pNode.nodeName = 'vrdetails') then
    begin
      Inifile.WriteString('VERSION', 'ModuleVersion',   _GetNodeValue(pNode, 'vrmodule'));
      Inifile.WriteString('VERSION', 'CurrencyVersion', _GetNodeValue(pNode, 'vrcurrency'));
      Inifile.WriteString('VERSION', 'ProductType',     _GetNodeValue(pNode, 'vrproduct'));
    end
    else if (pNode.nodeName = 'vrmodules') then
    begin
      for Entry := 0 to pNode.childNodes.length - 1 do
      begin
        RecNode := pNode.childNodes[Entry];
        Id := RecNode.text;
        Inifile.WriteBool('MODULES', Id, True);
        RecNode := nil;
      end;
    end;
  finally
    Inifile.Free;
    EnableFile(FileName, False);
  end;
end;

procedure TVersionImport.EnableFile(FileName: string; Enable: Boolean);
var
  Attributes: Word;
begin
  if FileExists(FileName) then
  begin
    Attributes := FileGetAttr(FileName);
    if Enable then
    begin
//      Attributes := Attributes and not faReadOnly;
      uCrypto.TCrypto.DecryptFile(FileName);
    end
    else
    begin
      uCrypto.TCrypto.EncryptFile(FileName);
//      Attributes := Attributes or faReadOnly;
    end;
    FileSetAttr(FileName, Attributes);
  end;
end;

function TVersionImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to the file via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

end.
