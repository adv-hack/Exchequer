(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msFTP;

{$I msDef.inc}

interface

uses
  Windows, Messages, SysUtils, Classes,
{$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs,
{$ENDIF}
  msSocket, msWSock, msDef, msFTPCls;

type

  TmsDataTransferProgressEvent = procedure(Sender: TObject; ByteCount: LongInt) of Object;

  TmsFTPOperation=(foReceive,foSend);

  TmsFTPClient = class;  // forward declaration

  TmsFTPClient = class(TmsClientSocket)
  private
    { Private declarations }
    FUserName : string;
    FPassword : string;
    FTransferType: TmsTransferType;
    FTransferStream: TStream;
    FOnDataTransferStart: TNotifyEvent;
    FOnDataTransferTerminate: TNotifyEvent;
    FOnDataTransferProgress: TmsDataTransferProgressEvent;
    FTransferDone: boolean;
    FDirList: TmsFTPDirList;
    FProxyType: TmsProxyType;
    FPassiveMode: boolean;
    function GetCurrentDirectory: string;
    procedure SetCurrentDirectory(const Value: string);
    procedure DoDataTransferStart(Sender: TObject);
    procedure DoDataTransferTerminate(Sender: TObject);
    procedure DoDataTransferProgress(Sender: TObject; ByteCount: LongInt);
    procedure ProcessDirectoryOutput(InStream: TStream);
    function GetServerType: TmsServerType;
    procedure SetServerType(const Value: TmsServerType);
    procedure ConnectionRequested(Sender: TObject);
    procedure DTProgress(Sender: TObject; Perc, ByteCount,
      LineCount: LongInt);
    function PickPortParameters(const s: string; var Domain: string;
      var Port: DWord): boolean;
//    function PickPortParameters(const s: string; var Domain: string;
//      var Port: SmallInt): boolean;
    function PickParameterString(const s: string): string;
  protected
    { Protected declarations }
{    ConnRequested: boolean; NF: Moved to public so I can stop infinite loops}
    function GetServerReplyCode(const s : string) : Integer; override;
    procedure ProcessPassiveDataTransfer(const Cmd: string;
      Stream: TStream; StartPosition: LongInt; Operation: TmsFTPOperation);
    procedure ProcessActiveDataTransfer(const Cmd: string; Stream: TStream;
      StartPosition: LongInt; Operation: TmsFTPOperation);
    procedure ProcessDataTransfer(const Cmd: string; Stream: TStream;
      StartPosition: LongInt; Operation: TmsFTPOperation);
  public
    { Public declarations }
    ConnRequested: boolean; {NF: Moved from protected so I can stop infinite loops}
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure LogIn;
    procedure LogOut;
    procedure ProcessSiteCommand(const Cmd: string);
    procedure GetDirectoryOutput(Stream: TStream);
    procedure GetFileList(Strings: TStrings);
    procedure GetDirList;
    procedure StoreFile(const LocalFilePath, RemoteFilePath: string);
    procedure ResumeStoreFile(const LocalFilePath, RemoteFilePath: string;
      Marker: LongInt);
    procedure AppendStoreFile(const LocalFilePath, RemoteFilePath: string);
    procedure RetrieveFile(const RemoteFilePath, LocalFilePath: string);
    procedure ResumeRetrieveFile(const RemoteFilePath, LocalFilePath: string;
      Marker: LongInt);
    procedure EraseFile(const RemoteFilePath: string);
    procedure RenameFile(const OldFilePath, NewFilePath: string);
    procedure ChangeDirectory(const Path: string);
    procedure ChangeToUpperDirectory;
    procedure MakeDirectory(const Path: string);
    procedure DeleteDirectory(const Path: string);
    function GetFileSize(const FileName: string): LongInt;
    procedure CancelDataTransfer;
    property DirList: TmsFTPDirList read FDirList;
    property CurrentDirectory: string read GetCurrentDirectory write SetCurrentDirectory;
  published
    { Published declarations }
    property UserName : string read FUserName write FUserName;
    property Password : string read FPassword write FPassword;
    property PassiveMode: boolean read FPassiveMode write FPassiveMode;
    property ServerType: TmsServerType read GetServerType write SetServerType;
    property TransferType: TmsTransferType read FTransferType write FTransferType;
    property Proxy;
    property ProxyPort;
    property ProxyType: TmsProxyType read FProxyType write FProxyType;
    property OnDataTransferStart: TNotifyEvent read FOnDataTransferStart write
      FOnDataTransferStart;
    property OnDataTransferTerminate: TNotifyEvent read FOnDataTransferTerminate write
      FOnDataTransferTerminate;
    property OnDataTransferProgress: TmsDataTransferProgressEvent read FOnDataTransferProgress
      write FOnDataTransferProgress;
    property OnLineSent;
    property OnLineReceived;
  end;

implementation

uses msUtils, msConst;

{TmsFTPClient}
constructor TmsFTPClient.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Port:=21;
  FDefaultPort:=Port;
  FDirList:=TmsFTPDirList.Create;
end;

destructor TmsFTPClient.Destroy;
begin
  FDirList.Free;
  inherited Destroy;
end;

procedure TmsFTPClient.SetCurrentDirectory(const Value: string);
begin
  ChangeDirectory(Value);
end;

function TmsFTPClient.GetCurrentDirectory: string;
var
  rs: Integer;
begin
  Result:='';
  if OnLine then
  begin
    SendLine('PWD');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    Result:=TrimQuotes(PickString(TempS,1,false));
  end
end;

procedure TmsFTPClient.DoDataTransferProgress(Sender: TObject; ByteCount: LongInt);
begin
  if Assigned(FOnDataTransferProgress) then
    FOnDataTransferProgress(Sender,ByteCount);
end;

procedure TmsFTPClient.DoDataTransferStart(Sender: TObject);
begin
  if Assigned(FOnDataTransferStart) then
    FOnDataTransferStart(Sender);
end;

procedure TmsFTPClient.DoDataTransferTerminate(Sender: TObject);
begin
  if Assigned(FOnDataTransferTerminate) then
    FOnDataTransferTerminate(Sender);
end;

procedure TmsFTPClient.DTProgress(Sender: TObject;  Perc, ByteCount,
  LineCount: LongInt);
begin
  DoDataTransferProgress(Sender,ByteCount);
end;

procedure TmsFTPClient.ConnectionRequested(Sender: TObject);
begin
  ConnRequested:=true;
end;

function TmsFTPClient.PickParameterString(const s: string): string;
var
  i1, i2: Integer;
begin
  i1:=Pos('(',s);
  i2:=Pos(')',s);
  if (i1>0) and (i2>0) and (i1<i2) then
    Result:=Copy(s,i1+1,i2-i1-1)
  else
    Result:='';
end;

function TmsFTPClient.PickPortParameters(const s: string; var Domain: string;
  var Port: DWord): boolean;
//function TmsFTPClient.PickPortParameters(const s: string; var Domain: string;
//  var Port: SmallInt): boolean;
var
  s1: string;
  b: array[1..6] of Integer;
  i,j: Integer;
begin
  Result:=true;
  s1:=PickParameterString(s);
  if s1='' then
  begin
    Result:=false;
    Exit;
  end
  else
  begin
    for j:=1 to 6 do
    begin
      if j=6 then
        i:=Length(s1)+1
      else
        i:=Pos(',',s1);
      if i>0 then
      begin
        b[j]:=StrToIntDef(Copy(s1,1,i-1),-1);
        if b[j]=-1 then
        begin
          Result:=false;
          Break;
        end
        else
          Delete(s1,1,i);
      end
      else
      begin
        Result:=false;
        Break;
      end;
    end;
    if Result then
    begin
      Domain:='';
      for i:=1 to 4 do
      begin
        Domain:=Concat(Domain,IntToStr(b[i]));
        if i<>4 then
          Domain:=Concat(Domain,'.');
      end;
      Port:=b[6]+256*b[5];
    end;
  end;
end;

procedure TmsFTPClient.ProcessPassiveDataTransfer(const Cmd: string; Stream: TStream;
  StartPosition: LongInt; Operation: TmsFTPOperation);
var
  ClientSocket: TmsClientSocket;
  rs: Integer;
  Domain: string;
//  Port: SmallInt;
  Port: Dword;
begin
  DoDataTransferStart(Self);
  ConnRequested:=false;
  ClientSocket:=TmsClientSocket.Create(Self);
  try
    ClientSocket.OnTransferProgress:=DTProgress;
    ClientSocket.OnConnected:=ConnectionRequested;
    SendLine('PASV');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    if not PickPortParameters(TempS,Domain,Port) then
      raise EmsServerError.Create('Problems getting the parameters');
    ClientSocket.Host:=Domain;
    ClientSocket.Port:=Port;
    ClientSocket.Connect;
    repeat
      Application.ProcessMessages;
    until ConnRequested;
    if StartPosition>-1 then
    begin
      SendLine('REST '+IntToStr(StartPosition));
      rs:=iRecvLines;
      if (rs div 100)<>3 then
        raise EmsServerError.Create(TempS);
    end;
    if StartPosition<0 then
      StartPosition:=0;
    SendLine(Cmd);
    rs:=iRecvLines;
    if (rs div 100)<>1 then
      raise EmsServerError.Create(TempS);
    try
      if Operation=foReceive then
        ClientSocket.RecvStream(Stream,-1,StartPosition)
      else
        ClientSocket.SendStream(Stream,StartPosition);
        ClientSocket.Disconnect;
    except
      ClientSocket.Disconnect;
    end;
  finally
    ClientSocket.Free;
    DoDataTransferTerminate(Self);
  end;
end;

procedure TmsFTPClient.ProcessActiveDataTransfer(const Cmd: string; Stream: TStream;
  StartPosition: LongInt; Operation: TmsFTPOperation);
var
  ListenerSocket: TmsSimpleListenerSocket;
  rs, NameLen, LocalPort: Integer;
  SockAddr: TSockAddr;
  s: string;
begin
  ConnRequested:=false;
  DoDataTransferStart(Self);
  ListenerSocket:=TmsSimpleListenerSocket.Create(Self);
  try
    ListenerSocket.ServerSocket.OnTransferProgress:=DTProgress;
    ListenerSocket.Port:=0;
    ListenerSocket.ServerSocketTimeOut:=TimeOut;
    ListenerSocket.SleepTime:=SleepTime;
    ListenerSocket.OnSLSConnectionRequested:=ConnectionRequested;
    ListenerSocket.Start;
    NameLen:=SizeOf(SockAddr);
    if msWinsock.getsockname(ListenerSocket.Socket,SockAddr,NameLen)=SOCKET_ERROR
      then Error(msWinsock.WSAGetLastError);
    LocalPort:=SockAddr.sin_port;
    if msWinsock.getsockname(Socket,SockAddr,NameLen)=SOCKET_ERROR then
      Error(msWinsock.WSAGetLastError);
    with SockAddr.sin_addr.S_un_b do
      s:=Format('%d,%d,%d,%d,%d,%d',[byte(s_b1),byte(s_b2),byte(s_b3),byte(s_b4),
                LocalPort and $ff,LocalPort shr 8]);
    SendLine('PORT '+s);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    if StartPosition>-1 then
    begin
      SendLine('REST '+IntToStr(StartPosition));
      rs:=iRecvLines;
      if (rs div 100)<>3 then
        raise EmsServerError.Create(TempS);
    end;
    if StartPosition<0 then
      StartPosition:=0;
    FTransferDone:=false;
    SendLine(Cmd);
    rs:=iRecvLines;
    if (rs div 100)<>1 then
      raise EmsServerError.Create(TempS);
    repeat
      Application.ProcessMessages;
    until ConnRequested;
    try
      if Operation=foReceive then
        ListenerSocket.ServerSocket.RecvStream(Stream,-1,StartPosition)
      else
        ListenerSocket.ServerSocket.SendStream(Stream,StartPosition);
        ListenerSocket.ServerSocket.Disconnect;
    except
      ListenerSocket.ServerSocket.Disconnect;
    end;
    ListenerSocket.Stop;
  finally
    ListenerSocket.Free;
    DoDataTransferTerminate(Self);
  end;
end;

procedure TmsFTPClient.ProcessDataTransfer(const Cmd: string; Stream: TStream;
  StartPosition: LongInt; Operation: TmsFTPOperation);
begin
  if not FPassiveMode then
    ProcessActiveDataTransfer(Cmd,Stream,StartPosition,Operation)
  else
    ProcessPassiveDataTransfer(Cmd,Stream,StartPosition,Operation);
end;

procedure TmsFTPClient.GetFileList(Strings: TStrings);
var
  TempStream: TStream;
  rs: Integer;
begin
  TempStream:=TMemoryStream.Create;
  try
    SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=TempStream;
    ProcessDataTransfer('NLST',TempStream,-1,foReceive);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    TempStream.Position:=0;
    Strings.LoadFromStream(TempStream);
  finally
    TempStream.Free;
  end;
end;

procedure TmsFTPClient.ProcessSiteCommand(const Cmd: string);
var
  rs: Integer;
begin
  SendLine('SITE '+Cmd);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.GetDirectoryOutput(Stream: TStream);
var
  rs: Integer;
begin
  SendLine('TYPE A');
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
  FTransferStream:=Stream;
  ProcessDataTransfer('LIST',Stream,-1,foReceive);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.GetDirList;
var
  TempStream: TStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    GetDirectoryOutput(TempStream);
    ProcessDirectoryOutput(TempStream);
  finally
    TempStream.Free;
  end;
end;

procedure TmsFTPClient.ProcessDirectoryOutput(InStream: TStream);
var
  SL: TStrings;
  s: string;
  i: Integer;
begin
  SL:=TStringList.Create;
  try
    InStream.Position:=0;
    SL.LoadFromStream(InStream);
    TrimStrings(SL);
    FDirList.Clear;
    if SL.Count>0 then
    begin
      s:=SL[0];
      if LowerCase(Copy(s,1,5))='total' then
      begin
        SL.Delete(0);
        FDirList.ServerType:=stUnix;
      end;
      if FDirList.ServerType=stAuto then
      begin
        if (s[1] in ['0'..'9']) then
        begin
          FDirList.ServerType:=stDos;
        end
        else
        if (Pos('PATH',s)>0) then
        begin
          FDirList.ServerType:=stHP3000;
          repeat
            SL.Delete(0);
            if SL.Count>0 then
              s:=SL[0];
          until (SL.Count=0) or ((Length(s)>16) and (s[16] in ['F','D']));
          if SL.Count>0 then
            SL.Insert(0,'');
        end
        else
        if (Copy(s,41,4)='*FLR') or (Copy(s,41,4)='*DOC')
           or (Copy(s,41,4)='*DIR') or (Copy(s,41,4)='*LIB')
           or (Copy(s,41,5)='*DDIR') or (Pos('AS400',s)>0) then
        begin
          FDirList.ServerType:=stAS400;
          if SL.Count>0 then
            SL.Insert(0,'');
        end
        else
          FDirList.ServerType:=stUnix;
      end;
    end;
    for i:=0 to SL.Count-1 do
      FDirList.AddString(SL[i]);
  finally
    SL.Free;
  end;
end;

procedure TmsFTPClient.StoreFile(const LocalFilePath, RemoteFilePath: string);
var
  rs: Integer;
  FileStream: TFileStream;
begin
  FileStream:=TFileStream.Create(LocalFilePath, fmShareDenyWrite);
  try
    if FTransferType=ttBinary then
      SendLine('TYPE I')
    else
      SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=FileStream;
    ProcessDataTransfer(Concat('STOR ',RemoteFilePath),FileStream,-1,foSend);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  finally
    FileStream.Free;
  end;
end;

procedure TmsFTPClient.ResumeStoreFile(const LocalFilePath, RemoteFilePath: string;
      Marker: LongInt);
var
  rs: Integer;
  FileStream: TFileStream;
begin
  FileStream:=TFileStream.Create(LocalFilePath, fmShareDenyWrite);
  try
    if FTransferType=ttBinary then
      SendLine('TYPE I')
    else
      SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=FileStream;
    ProcessDataTransfer(Concat('STOR ',RemoteFilePath),FileStream,
      Marker,foSend);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  finally
    FileStream.Free;
  end;
end;

procedure TmsFTPClient.AppendStoreFile(const LocalFilePath, RemoteFilePath: string);
var
  rs: Integer;
  FileStream: TFileStream;
begin
  FileStream:=TFileStream.Create(LocalFilePath,fmOpenRead);
  try
    if FTransferType=ttBinary then
      SendLine('TYPE I')
    else
      SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=FileStream;
    ProcessDataTransfer(Concat('APPE ',RemoteFilePath),FileStream,-1,foSend);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  finally
    FileStream.Free;
  end;
end;

procedure TmsFTPClient.RetrieveFile(const RemoteFilePath, LocalFilePath: string);
var
  rs: Integer;
  FileStream: TFileStream;
begin
  FileStream:=TFileStream.Create(LocalFilePath,fmOpenWrite or fmCreate);
  try
    if FTransferType=ttBinary then
      SendLine('TYPE I')
    else
      SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=FileStream;
    ProcessDataTransfer(Concat('RETR ',RemoteFilePath),FileStream,-1,foReceive);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  finally
    FileStream.Free;
  end;
end;

procedure TmsFTPClient.ResumeRetrieveFile(const RemoteFilePath, LocalFilePath: string;
  Marker: Longint);
var
  rs: Integer;
  FileStream: TFileStream;
begin
  FileStream:=TFileStream.Create(LocalFilePath,fmOpenWrite);
  try
    if FTransferType=ttBinary then
      SendLine('TYPE I')
    else
      SendLine('TYPE A');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
    FTransferStream:=FileStream;
    ProcessDataTransfer(Concat('RETR ',RemoteFilePath),FileStream,Marker,foReceive);
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  finally
    FileStream.Free;
  end;
end;

procedure TmsFTPClient.EraseFile(const RemoteFilePath: string);
var
  rs: Integer;
begin
  SendLine(Concat('DELE ',RemoteFilePath));
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.RenameFile(const OldFilePath, NewFilePath: string);
var
  rs: Integer;
begin
  SendLine('RNFR '+OldFilePath);
  rs:=iRecvLines;
  if (rs div 100)<>3 then
    raise EmsServerError.Create(TempS);
  SendLine('RNTO '+NewFilePath);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.ChangeDirectory(const Path: string);
var
  rs: Integer;
begin
  SendLine('CWD '+Path);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.ChangeToUpperDirectory;
var
  rs: Integer;
begin
  SendLine('CDUP');
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.MakeDirectory(const Path: string);
var
  rs: Integer;
begin
  SendLine('MKD '+Path);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.DeleteDirectory(const Path: string);
var
  rs: Integer;
begin
  SendLine('RMD '+Path);
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
end;

function TmsFTPClient.GetFileSize(const FileName: string): LongInt;
var
  rs: Integer;
begin
  SendLine(Concat('SIZE ',FileName));
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    Result:=-1
  else
    Result:=PickNumber(TempS,1);
end;

procedure TmsFTPClient.CancelDataTransfer;
const
  EscChars: PChar = #255#244#255#242;
var
  rs: Integer;
begin
  if not FTransferDone then
  begin
//    FDataProcessor.Cancel;
    SendRcvFlags:=MSG_OOB;
    Write(EscChars^,4);
    SendRcvFlags:=0;
    SendLine('ABOR');
    rs:=iRecvLines;
    if (rs div 100)<>2 then
      raise EmsServerError.Create(TempS);
  end;
end;

function TmsFTPClient.GetServerReplyCode(const s : string) : Integer;
begin
  Result:=StrToIntDef(Copy(s,1,3),-1);
end;

procedure TmsFTPClient.LogIn;
var
  rs : Integer;
begin
  Connect;
  rs:=iRecvLines;
  if rs<>220 then
    raise EmsServerError.Create(TempS);
  if Proxy<>'' then
  begin
    if FProxyType=fpUserNoLogon then
      SendLine('USER '+FUserName+'@'+Host)
    else
    begin
      SendLine('OPEN '+Host);
      rs:=iRecvLines;
      if rs<>220 then
        raise EmsServerError.Create(TempS);
      SendLine('USER '+FUserName);
    end;
  end
  else
    SendLine('USER '+FUserName);
  rs:=iRecvLines;
  if (rs<>230) and (rs<>331) and (rs<>332) then
    raise EmsServerError.Create(TempS);
  SendLine('PASS '+FPassword);
  rs:=iRecvLines;
  if (rs<>230) and (rs<>202) then
    raise EmsServerError.Create(TempS);
end;

procedure TmsFTPClient.LogOut;
var
  rs : Integer;
begin
  SendLine('QUIT');
  rs:=iRecvLines;
  if (rs div 100)<>2 then
    raise EmsServerError.Create(TempS);
  Disconnect;
end;

function TmsFTPClient.GetServerType: TmsServerType;
begin
  Result:=FDirList.ServerType;
end;

procedure TmsFTPClient.SetServerType(const Value: TmsServerType);
begin
  FDirList.ServerType:=Value;
end;

end.
