unit uCISdemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CISOutgoing_TLB, DSROutgoing_TLB, AdvEdit, AdvEdBtn,
  AdvFileNameEdit;

type
  TForm1 = class(TForm)
    btnPostDoc: TButton;
    edtFileName: TAdvFileNameEdit;
    Button1: TButton;
    procedure btnPostDocClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
//    '{B902924F-EF57-4189-B01A-4BD534B9702E}'
  public
  end;

var
  Form1: TForm1;

implementation
uses uCommon, uxmlbaseclass, uDSRFileFunc, uconsts, MSXML2_TLB;

{$R *.dfm}

procedure TForm1.btnPostDocClick(Sender: TObject);
var
  lPost: CISSending;
  lDoc, lcis: TXMLDoc;
  lNode: IXMLDOMNode;
  lXmlHeader: TXMLHeader;
begin
  lDoc:= TXMLDoc.Create;
  //lDoc.LoadXml(ExtractFilePath(application.exename) + 'sampleReturnComplete.xml');
  lDoc.LoadXml(ExtractFilePath(application.exename) + 'IRmarkExample(submission).xml');
  lcis:= TXMLDoc.Create;
  lcis.LoadXml('C:\Projects\Ice\Bin\XMLDIR\cis.xml');

  lNode := _GetNodeByName(lCis.Doc, 'cisxml');
  _SetNodeValueByName(lNode, 'cisxml', lDoc.Doc.xml);
  _FillXMLHeader(lXmlHeader, StringToGUID('{B902924F-EF57-4189-B01A-4BD534B9702E}'), 1, 1, 'vmoura@exchequer.com', 'redbaron@exchequer.com', 'cis', 0);
  _SetXmlHeader(lCis, lXmlHeader);
  lcis.Save('test.xml');

  lPost := CoCISSending.Create;
  (lPost as IDSROutgoingSystem).Files := ExtractFilePath(application.exename) +'test.xml';
  (lPost as IDSROutgoingSystem).SendMsg;
//  (lPost as IDSROutgoingSystem).SendMsg('vmoura@exchequer.com', 'redbaron@exchequer.com', 'test', 'empty', lcis.Doc.xml);
  lPost := nil;
  lCis.Free;
  ldoc.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  lPost: CISSending;
begin
  if edtFileName.Text <> '' then
    if _FileSize(edtFileName.Text) > 0 then
    begin
      lPost := CoCISSending.Create;
      (lPost as IDSROutgoingSystem).Files := edtFileName.Text;
      (lPost as IDSROutgoingSystem).SendMsg;
      lPost := nil;
    end;
end;

end.
