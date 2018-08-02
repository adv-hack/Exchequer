unit WhoIsMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, StdCtrls, ComCtrls, ExtCtrls;

type
  TWhoIsForm = class(TForm)
    Panel1: TPanel;
    StatusBar: TStatusBar;
    QueryEdit: TEdit;
    SendButton: TButton;
    CancelButton: TButton;
    ResultsMemo: TMemo;
    msClientSocket1: TmsClientSocket;
    procedure SendButtonClick(Sender: TObject);
    procedure msClientSocket1Connecting(Sender: TObject);
    procedure msClientSocket1Connected(Sender: TObject);
    procedure msClientSocket1Disconnected(Sender: TObject);
    procedure msClientSocket1TransferProgress(Sender: TObject; Perc,
      ByteCount, LineCount: Longint);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WhoIsForm: TWhoIsForm;

implementation

{$R *.DFM}

procedure TWhoIsForm.SendButtonClick(Sender: TObject);
var
  TempStream: TStream;
begin
  ResultsMemo.Clear;
  SendButton.Enabled:=false;
  CancelButton.Enabled:=true;
  try
    msClientSocket1.Host:='whois.internic.net';
    msClientSocket1.Connect;
    msClientSocket1.SendLine(QueryEdit.Text);
    TempStream:=TMemoryStream.Create;
    try
      msClientSocket1.RecvStream(TempStream,-1,0);
      TempStream.Position:=0;
      ResultsMemo.Lines.LoadFromStream(TempStream);
    finally
      TempStream.Free;
    end;
  finally
    SendButton.Enabled:=true;
    CancelButton.Enabled:=false;
  end;
end;

procedure TWhoIsForm.msClientSocket1Connecting(Sender: TObject);
begin
  StatusBar.SimpleText:='Connecting to '+msClientSocket1.Host;
end;

procedure TWhoIsForm.msClientSocket1Connected(Sender: TObject);
begin
  StatusBar.SimpleText:='Connected';
end;

procedure TWhoIsForm.msClientSocket1Disconnected(Sender: TObject);
begin
  StatusBar.SimpleText:='Disconnected';
end;

procedure TWhoIsForm.msClientSocket1TransferProgress(Sender: TObject; Perc,
  ByteCount, LineCount: Longint);
begin
  StatusBar.SimpleText:=IntToStr(ByteCount)+' bytes received';
end;

end.
