unit SentFtp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mssocket, msFTP, StdCtrls, ExtCtrls;



type
  TUpdateTickProc = procedure of Object;

  TfrmFtp = class(TForm)
    FtpClient: TmsFTPClient;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FtpClientLineSent(Sender: TObject; const TheLine: String);
    procedure FtpClientLineReceived(Sender: TObject;
      const TheLine: String);
    procedure Timer1Timer(Sender: TObject);
  private
    FFilePath,
    FUserName,
    FPassword,
    FServer,
    FRemoteDir,
    FProxy,
    FProxyPort : AnsiString;
    FTimeout, FInterval, FPort : integer;
    FUpdateTick : TUpdateTickProc;
    FLog : TStringList;
  protected
    function GetString(Index : Integer) : AnsiString;
    procedure SetString(Index : Integer; Value : AnsiString);
    procedure LogIt(const s : AnsiString);
  public
    { Public declarations }
    function SendFile(const Filename : AnsiString) : Boolean;
    property UserName : AnsiString Index 0 read GetString write SetString;
    property Password : AnsiString Index 1 read GetString write SetString;
    property Server : AnsiString Index 2 read GetString write SetString;
    property RemoteDir : AnsiString Index 3 read GetString write SetString;
    property Proxy : AnsiString Index 4 read GetString write SetString;
    property ProxyPort : AnsiString Index 5 read GetString write SetString;
    property Port : Integer read FPort write FPort;
    property TimeOut : Integer read FTimeout write FTimeOut;
    property FilePath : AnsiString Index 7 read GetString write SetString;
    property FileName : AnsiString Index 8 read GetString write SetString;
    property Interval : Integer read FInterval write FInterval;
    property UpdateTickProc : TUpdateTickProc read FUpdateTick write FUpdateTick;
  end;

  function PathOnly(const s : AnsiString) : ShortString;


implementation


{$R *.DFM}
uses
  ElVar, DebugLog;



function TfrmFtp.SendFile(const Filename : AnsiString) : Boolean;
var
  Remote : AnsiString;
  FSize : longint;
begin
//  FLog := TStringList.Create;
  Result := True;
  Remote := ExtractFileName(Filename);
  LogIt('File ' +  Filename + ' found');
  Try
    Show;
    Repaint;
    Try
      FTPClient.UserName := Self.UserName;
      FTPClient.Password := Self.Password;
      FTPClient.Port := Self.Port;
      FTPclient.TimeOut := Timeout;
      with FTPClient do
      begin
        Host := Server;
        Login;
        Try
          LogIt('Logged in to FTP Server');
          ChangeDirectory(RemoteDir);
          LogIt('Changing directory to ' + RemoteDir);
          StoreFile(Filename, Remote);
          LogIt('File stored');
          LastFTPError := '';
        Finally
          Logout;
          LogIt('Logged out of FTP Server');
        End;
      end;
    Except
      on E : Exception do
      begin
        LogIt(E.Message);
        LastFTPError := E.Message;
{        ShowMessage('An exception occurred while sending the file: ' + Filename + #10#10 +
                     E.Message);}
        Result := False;
      end;

    End;
  Finally
//    FLog.SaveToFile(ExtractFilePath(FileName) + 'ftplog.txt');
//    FLog.Free;

    Hide;
  End;
end;


procedure TfrmFtp.FtpClientLineSent(Sender: TObject;
  const TheLine: String);
begin
  Try
    Timer1.Interval := TimeOut * 1000;
  Except
    Timer1.Interval := 60000; //default to 1 minute
  End;
  Timer1.Enabled := True;
end;

procedure TfrmFtp.FtpClientLineReceived(Sender: TObject;
  const TheLine: String);
begin
  Timer1.Enabled := False;
  if Assigned(FUpdateTick) then
    FUpdateTick;
end;

procedure TfrmFtp.Timer1Timer(Sender: TObject);
begin
  FtpClient.Cancel;
    raise Exception.Create('FTP server timed out');
end;

function TfrmFtp.GetString(Index : Integer) : AnsiString;
begin
  Case Index of
    0 : Result := FUserName;
    1 : Result := FPassword;
    2 : Result := FServer;
    3 : Result := FRemoteDir;
    4 : Result := FProxy;
    5 : Result := FproxyPort;
  end;

end;

procedure TfrmFtp.SetString(Index : Integer; Value : AnsiString);
begin
  Case Index of
    0 : FUserName := Value;
    1 : FPassword := Value;
    2 : FServer := Value;
    3 : FRemoteDir := Value;
    4 : FProxy := Value;
    5 : FProxyPort := Value;
  end;

end;



function PathOnly(const s : AnsiString) : ShortString;
var
  i : integer;
begin
  i := Length(s);
  while (i > 0) and (s[i] <> '\') do dec(i);
    if i = 0 then
      Result := ''
    else
      Result := Copy(s, 1, i);
end;

procedure TfrmFtp.LogIt(const s : AnsiString);
begin
//  if Assigned(FLog) then
//    FLog.Add('[FTP] ' + s);
  DebugLog.LogIt(spConveyor, '[FTP] ' + s);
end;

end.
