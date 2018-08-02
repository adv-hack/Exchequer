unit FingerDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, StdCtrls, ComCtrls, ExtCtrls;

type
  TFingerForm = class(TForm)
    Panel1: TPanel;
    ResultsMemo: TMemo;
    StatusBar: TStatusBar;
    Label1: TLabel;
    QueryEdit: TEdit;
    SendQueryButton: TButton;
    CancelButton: TButton;
    msClientSocket1: TmsClientSocket;
    procedure SendQueryButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure msClientSocket1Connecting(Sender: TObject);
    procedure msClientSocket1Connected(Sender: TObject);
    procedure msClientSocket1Disconnected(Sender: TObject);
    procedure msClientSocket1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    procedure GetHostAndQuery(var Host, Query: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FingerForm: TFingerForm;

implementation

{$R *.DFM}
procedure TFingerForm.GetHostAndQuery(var Host, Query: string);
var
  i: Integer;
begin
  i:=Pos('@',QueryEdit.Text);
  Host:=Copy(QueryEdit.Text,i+1,Length(QueryEdit.Text));
  Query:=Copy(QueryEdit.Text,1,i-1);
end;

procedure TFingerForm.SendQueryButtonClick(Sender: TObject);
var
  Host,Query: string;
  TempStream: TStream;
begin
  ResultsMemo.Clear;
  SendQueryButton.Enabled:=false;
  CancelButton.Enabled:=true;
  try
    GetHostAndQuery(Host,Query);
    msClientSocket1.Host:=Host;
    msClientSocket1.Connect;
    msClientSocket1.SendLine(Query);
    TempStream:=TMemoryStream.Create;
    try
      msClientSocket1.RecvStream(TempStream,-1,0);
      TempStream.Position:=0;
      ResultsMemo.Lines.LoadFromStream(TempStream);
    finally
      TempStream.Free;
    end;
    msClientSocket1.Disconnect;
  finally
    SendQueryButton.Enabled:=true;
    CancelButton.Enabled:=false;
  end;
end;

procedure TFingerForm.CancelButtonClick(Sender: TObject);
begin
  msClientSocket1.Cancel;
end;

procedure TFingerForm.msClientSocket1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Opening connection with '+msClientSocket1.Host;
end;

procedure TFingerForm.msClientSocket1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TFingerForm.msClientSocket1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

procedure TFingerForm.msClientSocket1TransferProgress(Sender: TObject;
  Perc, ByteCount, LineCount: Longint);
begin
  StatusBar.SimpleText:=IntToStr(ByteCount)+' bytes received';
end;

end.
