unit frmMainImp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, INternetFiling_TLB, FBICallback, ComCtrls, ExtCtrls,
  xmldom, XMLIntf, msxmldom, XMLDoc, MSXML2_TLB;

type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    btnDummyStartPolling: TButton;
    Bevel1: TBevel;
    btnAddIR: TButton;
    btnPostDoc: TButton;
    btnBeginPolling: TButton;
    btnReassignURL: TButton;
    btnDelete: TButton;
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    XMLDocument1: TXMLDocument;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDummyStartPollingClick(Sender: TObject);
    procedure btnAddIRClick(Sender: TObject);
    procedure btnPostDocClick(Sender: TObject);
    procedure btnBeginPollingClick(Sender: TObject);
    procedure btnReassignURLClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    FCallback: ICallback;
    FGuid: string;
    FPosting: _Posting;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
    FCallback := TFBI_Callback.Create;
    FPosting := CoPosting.Create;

    XMLDocument1.LoadFromFile('sampleReturnComplete.xml');
    memo2.lines.LoadFromFile('sampleReturnComplete.xml');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    FPosting := nil;
end;

procedure TfrmMain.btnDummyStartPollingClick(Sender: TObject);
begin
    // instance of callback
    // -999 is the magic number to test that the callback reference is working. It simply passes back a message immediately
    // rest of the params don;t matter as not used in the test scenario...
    FPosting.BeginPolling_3(FCallback, '-999', 'something', true, '', 60);
end;

procedure TfrmMain.btnAddIRClick(Sender: TObject);
var
    irMark, xmlContents, s: widestring;
    i: integer;
begin
    xmlContents := '';
    for i:= 0 to Pred(XMLDocument1.XML.Count) do
        xmlContents := xmlContents +XMLDocument1.XML[i];

    // getting failures, let's
    // get rid of the tabs in the document before sending
    xmlContents := StringReplace(xmlContents, Chr(9), '', [rfReplaceAll]);


    irMark := FPosting.AddIRMark(xmlContents, 3, s);
    memo1.lines.Add('IR Mark generated as: '+irMark);
    memo1.lines.Add('XML document also ammended to include the IRMark, see revised document');
    memo1.lines.Add('----------------------------------');
    memo2.lines.text := s;
end;

procedure TfrmMain.btnPostDocClick(Sender: TObject);
var
    xmlContents: string;
begin
    Fposting.SetConfiguration('https://secure.dev.gateway.gov.uk/submission/ggsubmission.asp');

    xmlContents := FPosting.Submit('IR_AB_AB123', true, memo2.lines.text);

    if (xmlContents <> '') then begin
        memo2.lines.Text := xmlContents;
        memo1.lines.Add('Posting seemed to work, check returned document for details');
    end else
        memo1.lines.Add('posting failed - reason unknown!');

    memo1.lines.Add('----------------------------------');
end;

procedure TfrmMain.btnBeginPollingClick(Sender: TObject);
begin
    Fguid := FPosting.BeginPolling(FCallback, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456', 'IR-AB-AB123', true, 'https://secure.dev.gateway.gov.uk/submission');
    memo1.lines.add('New polling thread started, identified as: '+Fguid);
    memo1.lines.Add('----------------------------------');
end;

procedure TfrmMain.btnReassignURLClick(Sender: TObject);
begin
    FPosting.RedirectPolling(Fguid, 'https://secure.dev.gateway.gov.uk/polling');
    memo1.lines.add('Polling redirected');
    memo1.lines.Add('----------------------------------');
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
    FPosting.Delete('ABCDEFGHIJKLMNOPQRSTUVWXYZ123456', 'IR-AB-AB123', true, 'https://secure.dev.gateway.gov.uk/polling');
    memo1.lines.add('Submission deleted');
    memo1.lines.Add('----------------------------------');
end;

end.
