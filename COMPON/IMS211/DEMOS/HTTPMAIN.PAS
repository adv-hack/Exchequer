unit HttpMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, Mssocket, mshttp, ComCtrls;

type
  THTTPForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    URLEdit: TEdit;
    HeadersMemo: TMemo;
    Panel2: TPanel;
    DocMemo: TMemo;
    StatusBar1: TStatusBar;
    msHTTPClient1: TmsHTTPClient;
    GetButton: TButton;
    HeadButton: TButton;
    CancelButton: TButton;
    procedure msHTTPClient1Connecting(Sender: TObject);
    procedure msHTTPClient1RequestSent(Sender: TObject);
    procedure msHTTPClient1Connected(Sender: TObject);
    procedure msHTTPClient1Disconnected(Sender: TObject);
    procedure GetButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure msHTTPClient1SendingRequest(Sender: TObject);
    procedure HeadButtonClick(Sender: TObject);
    procedure msHTTPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    procedure EnableControls(Enable: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HTTPForm: THTTPForm;

implementation

{$R *.DFM}

procedure THTTPForm.msHTTPClient1Connecting(Sender: TObject);
begin
  StatusBar1.SimpleText:='Connecting to the server '+msHTTPClient1.Host;
end;

procedure THTTPForm.msHTTPClient1RequestSent(Sender: TObject);
begin
  StatusBar1.SimpleText:='Request has been sent';
end;

procedure THTTPForm.msHTTPClient1Connected(Sender: TObject);
begin
  StatusBar1.SimpleText:='Connected';
end;

procedure THTTPForm.msHTTPClient1Disconnected(Sender: TObject);
begin
  StatusBar1.SimpleText:='Disconnected';
end;

procedure THTTPForm.EnableControls(Enable: boolean);
begin
  GetButton.Enabled:=Enable;
  HeadButton.Enabled:=Enable;
  CancelButton.Enabled:=not Enable;
end;

procedure THTTPForm.GetButtonClick(Sender: TObject);
begin
  EnableControls(false);
  try
    msHTTPClient1.URL:=URLEdit.Text;
    msHTTPClient1.Get;
    HeadersMemo.Lines.Assign(msHTTPClient1.Headers);
    DocMemo.Lines.LoadFromStream(msHTTPClient1.InStream);
  finally
    EnableControls(true);
  end;
end;

procedure THTTPForm.CancelButtonClick(Sender: TObject);
begin
  msHTTPClient1.Cancel;
end;

procedure THTTPForm.msHTTPClient1SendingRequest(Sender: TObject);
begin
  StatusBar1.SimpleText:='Sending request';
end;

procedure THTTPForm.HeadButtonClick(Sender: TObject);
begin
  EnableControls(false);
  try
    msHTTPClient1.URL:=URLEdit.Text;
    msHTTPClient1.Head;
    HeadersMemo.Lines.Assign(msHTTPClient1.Headers);
    DocMemo.Lines.Clear;
    DocMemo.Lines.Add('See retrieved headers above');
  finally
    EnableControls(true);
  end;
end;

procedure THTTPForm.msHTTPClient1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  StatusBar1.SimpleText:=IntToStr(ByteCount)+' bytes received';
end;

end.
