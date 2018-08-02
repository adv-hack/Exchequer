unit UfrmTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, janXMLTree;


type
  TfrmXMLBrowse = class(TForm)
    tvwXML: TTreeView;
    pnlTop: TPanel;
    edtXMLFileName: TEdit;
    btnBrowse: TButton;
    btnParse: TButton;
    dlgOpen: TOpenDialog;
    procedure btnBrowseClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
  private
    fXMLFileName : string;
    fXMLTree : TjanXMLTree;
  protected
    procedure SetString(Index : integer; const Value : string);
    procedure ParseXML;
  public
    property XMLFileName : string index 1 read fXMLFileName write SetString;
  end;

var
  frmXMLBrowse: TfrmXMLBrowse;

implementation

{$R *.DFM}

procedure TfrmXMLBrowse.SetString(Index: integer; const Value: string);
begin
  case Index of
    1: begin
         fXMLFileName := Value;
         edtXMLFileName.Text := Value;
       end;
  end;
end;

//----------------------------------------------------------------------------

procedure TfrmXMLBrowse.btnBrowseClick(Sender: TObject);
begin
  with dlgOpen do
    if Execute then
      XMLFileName := FileName;
end;

//----------------------------------------------------------------------------

procedure TfrmXMLBrowse.btnParseClick(Sender: TObject);
begin
  ParseXML;
end;

//----------------------------------------------------------------------------

procedure TfrmXMLBrowse.DisplayNode(CurrNode : TjanXMLNode);
begin
  // Can use
end;

procedure TfrmXMLBrowse.DrawTree(CurrNode : TjanXMLNode);
begin
  DisplayNode(CurrNode.parentNode, CurrNode);
  if CurrNode.hasChildNodes then
  begin
    CurrNode
    DrawTree(
  end;
      function    hasChildNodes:boolean;
    function    cloneNode:TjanXMLNode;
    function    firstChild:TjanXMLNode;
    function    lastChild:TjanXMLNode;
    function    previousSibling:TjanXMLNode;
    function    nextSibling:TjanXMLNode;







end;

//----------------------------------------------------------------------------

procedure TfrmXMLBrowse.ParseXML;
begin
  fXMLTree := TjanXMLTree.Create('', null, nil);
  with fXMLTree do
  try
    LoadFromFile(XMLFileName);
    DrawTree(FirstChild);
  finally
    Free;
  end;
end;

end.
