unit HttpPostMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI, Mssocket, mshttp;

type
  TPostTestForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    FormMemo: TMemo;
    PostButton: TButton;
    CancelButton: TButton;
    Label5: TLabel;
    ResultsMemo: TMemo;
    StatusBar: TStatusBar;
    msHTTPClient1: TmsHTTPClient;
    CityEdit: TEdit;
    CountryEdit: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    procedure PostButtonClick(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure msHTTPClient1Connecting(Sender: TObject);
    procedure msHTTPClient1Connected(Sender: TObject);
    procedure msHTTPClient1Disconnected(Sender: TObject);
    procedure msHTTPClient1RequestSent(Sender: TObject);
    procedure msHTTPClient1SendingRequest(Sender: TObject);
    procedure msHTTPClient1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    procedure EnableControls(Enable: boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PostTestForm: TPostTestForm;

implementation

{$R *.DFM}

procedure TPostTestForm.EnableControls(Enable: boolean);
begin
  PostButton.Enabled:=Enabled;
  CancelButton.Enabled:=not Enabled;
end;

procedure TPostTestForm.PostButtonClick(Sender: TObject);
var
  PostData: ShortString;
begin
  EnableControls(false);
  try
    msHTTPClient1.URL:='http://www.argosoft.com/cgi-bin/PostTest.exe';
    PostData:=Concat('city=',CityEdit.Text,'&country=',CountryEdit.Text);
    msHTTPClient1.OutStream.Write(PostData[1],Length(PostData));
    msHTTPClient1.OutStream.Position:=0;
    msHTTPClient1.Post;
    msHTTPClient1.InStream.Position:=0;
    ResultsMemo.Lines.LoadFromStream(msHTTPClient1.InStream);
  finally
    EnableControls(true);
  end;
end;

procedure TPostTestForm.Label7Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.argosoft.com/delphi/PostTest.html','','',SW_SHOW);
end;

procedure TPostTestForm.msHTTPClient1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Connecting to '+msHTTPClient1.Host;
end;

procedure TPostTestForm.msHTTPClient1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TPostTestForm.msHTTPClient1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

procedure TPostTestForm.msHTTPClient1RequestSent(Sender: TObject);
begin
  StatusBar.SimpleText:='Request has been sent';
end;

procedure TPostTestForm.msHTTPClient1SendingRequest(Sender: TObject);
begin
  StatusBar.SimpleText:='Sending request';
end;

procedure TPostTestForm.msHTTPClient1TransferProgress(Sender: TObject;
  Perc, ByteCount, LineCount: Longint);
begin
  StatusBar.SimpleText:=IntToStr(ByteCount)+' bytes received';
end;

end.
