{
This is a server program, which listens on the port 1080,
gets the string from the client, reverses it, and returns
back.  Corresponding client application is RvClient.drp
}
unit RvServerMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, StdCtrls;

type
  TServerForm = class(TForm)
    LogMemo: TMemo;
    StartButton: TButton;
    StopButton: TButton;
    msListenerSocket1: TmsListenerSocket;
    procedure StartButtonClick(Sender: TObject);
    procedure msListenerSocket1Start(Sender: TObject);
    procedure msListenerSocket1Stop(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure msListenerSocket1ServerThreadStart(Sender: TObject;
      ServerThread: TmsServerThread);
    procedure msListenerSocket1ServerThreadTerminate(Sender: TObject;
      ServerThread: TmsServerThread);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TReverseServer = class(TmsServerThread)
  private
    FString: string;
    procedure UpdateLog;
  protected
    procedure Execute; override;
  end;

var
  ServerForm: TServerForm;

implementation

{$R *.DFM}
procedure TReverseServer.UpdateLog;
begin
  ServerForm.LogMemo.Lines.Add(FString);
end;

procedure TReverseServer.Execute;
var
  s,s1: string;
  i: Integer;
begin
  s:=ServerSocket.RecvLine;
  FString:='Line received: '+s;
  Synchronize(UpdateLog);
  s1:='';
  for i:=Length(s) DownTo 1 do
    s1:=s1+s[i];
  ServerSocket.SendLine(s1);
  FString:='Line sent: '+s1;
  ServerSocket.Disconnect;
end;

procedure TServerForm.StartButtonClick(Sender: TObject);
begin
  msListenerSocket1.ServerThreadClass:=TReverseServer;
  msListenerSocket1.Start;
end;

procedure TServerForm.msListenerSocket1Start(Sender: TObject);
begin
  LogMemo.Lines.Add('Server started');
  StartButton.Enabled:=false;
  StopButton.Enabled:=true;
end;

procedure TServerForm.msListenerSocket1Stop(Sender: TObject);
begin
  LogMemo.Lines.Add('Server stopped');
  StartButton.Enabled:=true;
  StopButton.Enabled:=false;
end;

procedure TServerForm.StopButtonClick(Sender: TObject);
begin
  msListenerSocket1.Stop;
end;

procedure TServerForm.msListenerSocket1ServerThreadStart(Sender: TObject;
  ServerThread: TmsServerThread);
begin
  LogMemo.Lines.Add('Starting the server thread for '+ServerThread.Peer);
end;

procedure TServerForm.msListenerSocket1ServerThreadTerminate(
  Sender: TObject; ServerThread: TmsServerThread);
begin
  LogMemo.Lines.Add('Ending the server thread for '+ServerThread.Peer);
end;

end.
