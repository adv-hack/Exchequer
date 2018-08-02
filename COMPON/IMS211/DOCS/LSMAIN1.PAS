unit lsmain1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, StdCtrls;

type

  TMyServerThread = class(TmsServerThread)
  private
    FOutStream: TStream;
    FStatusStr: string;
    procedure UpdateStatus;
  protected
    procedure Execute; override;
  public
    property OutStream: TStream read FOutStream write FOutStream;
  end;

  TForm1 = class(TForm)
    msListenerSocket1: TmsListenerSocket;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure msListenerSocket1ServerThreadStart(Sender: TObject;
      ServerThread: TmsServerThread);
    procedure msListenerSocket1ServerThreadTerminate(Sender: TObject;
      ServerThread: TmsServerThread);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TMyServerThread.UpdateStatus;
begin
  Form1.Memo1.Lines.Add(FStatusStr);
end;

procedure TmyServerThread.Execute;
begin
  FStatusStr:='Reqested connection from '+Peer;
  Synchronize(UpdateStatus);
  FStatusStr:='Sending data to '+Peer;
  Synchronize(UpdateStatus);
  try
    ServerSocket.SendStream(FOutStream);
  except
    on E:Exception do
    begin
      FStatusStr:='Error '+E.Message;
      Synchronize(UpdateStatus);
    end;
  end;
  FStatusStr:='Closing connection with '+Peer;
  Synchronize(UpdateStatus);
  ServerSocket.Disconnect;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  msListenerSocket1.ServerThreadClass:=TMyServerThread;
  msListenerSocket1.Start;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  msListenerSocket1.Stop;
end;

procedure TForm1.msListenerSocket1ServerThreadStart(Sender: TObject;
  ServerThread: TmsServerThread);
var
  TempStream: TStream;
begin
  TempStream:=TFileStream.Create('myfile.txt',fmShareDenyWrite);
  (ServerThread as TMyServerThread).OutStream:=TempStream;
end;

procedure TForm1.msListenerSocket1ServerThreadTerminate(Sender: TObject;
  ServerThread: TmsServerThread);
begin
  (ServerThread as TMyServerThread).OutStream.Free;
end;

end.
