(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit Mssocket;

{$I msdef.inc}

interface

uses
  Windows,
{$IFDEF VCL}
  Forms,
{$ENDIF}
  Classes,
{$IFDEF ActiveX}
  Controls,
{$ENDIF}
  SysUtils,
  msConst,
  Messages,
  msDef,
  msCls,
  msWsock;

type

{$IFDEF VCL}
  TmsServerThread=class;
  TmsServerThreadClass=class of TmsServerThread;
  TmsSocket=class;
{$ENDIF}

  TmsProgressEvent = procedure(Sender: TObject; Perc, ByteCount,
     LineCount: LongInt) of Object;
  TmsRequestEvent = procedure(Sender: TObject; const Peer: string;
     var Allow: boolean) of Object;
  TmsCloseEvent = procedure(Sender: TObject; Peer: string) of Object;
  TmsAddressRejectEvent = procedure(Sender: TObject; const TheAddress,
    ServerReply: string; var Proceed: boolean) of Object;
  TmsLineTransferEvent = procedure(Sender: TObject; const TheLine: string)
    of Object;
{$IFDEF VCL}
  TmsServerThreadEvent = procedure(Sender: TObject; ServerThread: TmsServerThread)
    of Object;

  TmsConnList = class
  private
    FCS: TRTLCriticalSection;
    FList: TList;
    function GetCount: Integer;
    function Get(Index: Integer): TmsServerThread;
    procedure Put(Index: Integer; Value: TmsServerThread);
  protected
    procedure LockList;
    procedure UnlockList;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Item: TmsServerThread): Integer;
    procedure Remove(Item: TmsServerThread);
    procedure Delete(Index: Integer);
    function IndexOf(Value: TmsServerThread): Integer;
    procedure Clear;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TmsServerThread read Get write Put; default;
  end;
{$ENDIF}

{$IFDEF VCL}
{$IFDEF ActiveX}
  TmsSocketBase = class(TWinControl)
{$ELSE}
  TmsSocketBase = class(TComponent)
{$ENDIF}
{$ELSE}
  TmsSocketBase = class
{$ENDIF}
  private
    { Private declarations }
    FBufSize: Integer;
{$IFDEF VCL}
    FWindow : THandle;
    FSleepTime : Integer;
    FTimeOut: Integer;
    FTC: TmsTimeCounter;
    FBlocking: boolean;
    function GetVersion: string;
    procedure SetVersion(const Value: string);
    procedure SetBlocking(Value: boolean);
    procedure TimerOn;
    procedure TimerOff;
    procedure TimerReset;
    function TimedOut: boolean;
{$ENDIF}
  protected
    { Protected declarations }
    FSocket : TSocket;
    rc : Integer;
    FAsyncError : word;
{$IFDEF VCL}
    procedure WndProcedure(var Msg : TMessage); virtual; abstract;
{$ENDIF}
  public
    { Public declarations }
    procedure Error(Ident : word);
    procedure LastError;
{$IFDEF VCL}
    property Blocking: boolean read FBlocking write FBlocking;
    property SleepTime : Integer read FSleepTime write FSleepTime;
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create; virtual;
{$ENDIF}
    destructor Destroy; override;
    property Socket : TSocket read FSocket write FSocket;
    property BufSize: Integer read FBufSize write FBufSize;
{$IFDEF VCL}
  published
    property Version: string read GetVersion write SetVersion;
{$ENDIF}
  end;

  TmsSocket = class(TmsSocketBase)
  private
    { Private declarations }
    FOnDisconnected : TNotifyEvent;
    FOnConnected: TNotifyEvent;
    FOnTransferProgress : TmsProgressEvent;
    FOnLineSent : TmsLineTransferEvent;
    FOnLineReceived : TmsLineTransferEvent;
    FChunkSize : Integer;
    FSendRcvFlags: Integer;
    FLogFileName : string;
    FStreamLimit: Integer;
    FLinger: boolean;
    FLingerTimeOut: Integer;
    FOnRead : TNotifyEvent;
    FOnWrite : TNotifyEvent;
    FOnOOBData: TNotifyEvent;
    FIbusSocket: boolean;
    function GetOnline: boolean;
{$IFDEF VCL}
    function GetTimeOut : Integer;
    procedure SetTimeOut(Value : Integer);
    procedure DoRead(Sender : TObject);
    procedure DoWrite(Sender : TObject);
    procedure DoOOBData(Sender: TObject);
    procedure DoConnected(Sender : TObject);
    procedure DoDisconnected(Sender : TObject);
    procedure DoTransferProgress(Sender : TObject; Perc, ByteCount, LineCount : LongInt);
    procedure DoLineSent(Sender : TObject; const TheLine : string);
    procedure DoLineReceived(Sender : TObject; const TheLine : string);
    function StreamSocket: boolean;
{$ENDIF}
  protected
    { Protected declarations }
    FCanceled : boolean;
    Log : TStrings;
    SocketType: Integer;
    Proto: Integer;
    procedure ReInit; virtual;
{$IFDEF VCL}
    procedure WndProcedure(var Msg : TMessage); override;
{$ENDIF}
  public
    { Public declarations }
{$IFDEF VCL}
    ConnectionAccepted : boolean;
    ConnectionReset : boolean;
    constructor Create(AOwner : TComponent); override;
{$ELSE}
    constructor Create; override;
{$ENDIF}
    destructor Destroy; override;
{$IFDEF VCL}
    procedure SetNetEvents;
{$ENDIF}
    procedure SetLinger;
    procedure Disconnect;
    procedure Cancel;
    procedure Write(const Buffer; Count : LongInt);
    function Read(var Buffer; Count : LongInt) : LongInt;
    procedure SendLine(const s : string);
    function RecvLine : string;
    procedure SendStream(Stream : TStream; StartPosition: Integer);
    procedure RecvStream(Stream : TStream; FullSize, StartPosition: Integer);
    procedure SendChunkedStream(Stream : TStream);
    procedure RecvChunkedStream(Stream : TStream);
    procedure RecvLineStream(Stream : TStream; FullSize : LongInt);
    procedure RecvMultiLines(Lines : TStrings);
    procedure SaveLogFile;
    property IbusSocket: boolean read FIbusSocket write FIbusSocket; 
    property StreamLimit: Integer read FStreamLimit write FStreamLimit;
    property Online : boolean read GetOnline;
    property SendRcvFlags: Integer read FSendRcvFlags write FSendRcvFlags;
    property ChunkSize : Integer read FChunkSize write FChunkSize;
    property LogFileName : string read FLogFileName write FLogFileName;
    property Linger: boolean read FLinger write FLinger;
    property LingerTimeOut: Integer read FLingerTimeOut write FLingerTimeOut;
    property OnRead : TNotifyEvent read FOnRead write FOnRead;
    property OnWrite : TNotifyEvent read FOnWrite write FOnWrite;
    property OnOOBData: TNotifyEvent read FOnOOBData write FOnOOBData;
    property OnTransferProgress : TmsProgressEvent read FOnTransferProgress
       write FOnTransferProgress;
    property OnLineSent : TmsLineTransferEvent read FOnLineSent write FOnLineSent;
    property OnLineReceived : TmsLineTransferEvent read FOnLineReceived
      write FOnLineReceived;
{$IFDEF VCL}
  published
    { Published declarations }
    property TimeOut : Integer read GetTimeOut write SetTimeOut default 60;
{$ENDIF}
    property OnConnected: TNotifyEvent read FOnConnected write FOnConnected;
    property OnDisconnected : TNotifyEvent read FOnDisconnected
       write FOnDisconnected;
  end;

  TmsClientSocket = class(TmsSocket)
  private
    { Private declarations }
    FHost: ShortString;
//    FPort: SmallInt;
    FPort: DWord;
    FProxy: ShortString;
    FProxyPort: SmallInt;
    FOnConnecting : TNotifyEvent;
    FDebug: boolean;
    procedure DoConnecting(Sender : TObject);
    procedure SetHost(const Value: ShortString);
    procedure SetProxy(const Value: ShortString);
  protected
    { Protected declarations }
    TempS : string;
    FDefaultPort: SmallInt;
    function iRecvLine(var s : string) : Integer;
    function iRecvLines : Integer;
    function GetServerReplyCode(const s : string) : Integer; virtual;
    property Proxy: ShortString read FProxy write SetProxy;
    property ProxyPort: SmallInt read FProxyPort write FProxyPort;
  public
    { Public declarations }
{$IFDEF VCL}
    constructor Create(AOwner: TComponent); override;
{$ELSE}
    constructor Create; override;
{$ENDIF}
    procedure Connect; virtual;
    property Debug: boolean read FDebug write FDebug;
  published
    { Published declarations }
    property Host : ShortString read FHost write SetHost;
//    property Port : SmallInt read FPort write FPort;
    property Port : DWord read FPort write FPort;
{$IFDEF VCL}
    property Blocking default false;
{$ENDIF}
    property OnTransferProgress;
    property OnConnecting : TNotifyEvent read FOnConnecting write FOnConnecting;
  end;

{$IFDEF VCL}
//  TmsListenerSocket=class;

  TmsServerThread=class(TThread)
  public
    IPHome: ShortString;
    Peer: ShortString;
    ServerSocket: TmsSocket;
    procedure Cancel; virtual;
  end;

  TmsListenerSocketBase=class(TmsSocketBase)
  private
//    FPort: SmallInt;
    FPort: DWord;
    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FServerSocketTimeOut: Integer;
    FBlockingServerSockets: boolean;
    FIPHome: string;
    procedure DoStart(Sender: TObject);
    procedure DoStop(Sender: TObject);
  protected
    AsyncHandle : THandle;
    procedure WndProcedure(var Msg : TMessage); override;
    procedure ProcessConnectionRequest; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
  published
    property IPHome: string read FIPHome write FIPHome;
//    property Port: SmallInt read FPort write FPort;
    property Port: DWord read FPort write FPort;
    property ServerSocketTimeOut: Integer read FServerSocketTimeOut write FServerSocketTimeOut
      default 60;
    property BlockingServerSockets: boolean read FBlockingServerSockets write FBlockingServerSOckets
      default false;
    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
  end;

  TmsSimpleListenerSocket=class(TmsListenerSocketBase)
  private
    FServerSocket: TmsSocket;
    FOnSLSConnectionRequested: TNotifyEvent;
    procedure DoSLSConnectionRequested(Sender: TObject);
  protected
    procedure ProcessConnectionRequest; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ServerSocket: TmsSocket read FServerSocket;
  published
    property OnSLSConnectionRequested: TNotifyEvent read FOnSLSConnectionRequested
      write FOnSLSConnectionRequested;
  end;

  TmsCustomListenerSocket=class(TmsListenerSocketBase)
  private
    FServerThreadClass: TmsServerThreadClass;
    FOnConnectionRequested: TmsRequestEvent;
    FOnServerThreadStart: TmsServerThreadEvent;
    FOnServerThreadTerminate: TmsServerThreadEvent;
    FConnectionList: TmsConnList;
    FSuspendedServer: boolean;
    function GetConnectionCount: Integer;
    procedure DoServerThreadStart(Sender: TObject; ServerThread: TmsServerThread);
    procedure DoServerThreadTerminate(Sender: TObject; ServerThread: TmsServerThread);
    procedure DoConnectionRequested(Sender: TObject; const Peer: string; var Allow: boolean);
    procedure ServerThreadTerminated(Sender: TObject);
  protected
    procedure ProcessConnectionRequest; override;
  public
    property ServerThreadClass: TmsServerThreadClass read FServerThreadClass
      write FServerThreadClass;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelAllConnections;
    property ConnectionList: TmsConnList read FConnectionList;
    property ConnectionCount: Integer read GetConnectionCount;
    property SuspendedServer: boolean read FSuspendedServer write FSuspendedServer
      default false;
    property OnConnectionRequested: TmsRequestEvent read FOnConnectionRequested
      write FOnConnectionRequested;
    property OnServerThreadStart: TmsServerThreadEvent read FOnServerThreadStart
      write FOnServerThreadStart;
    property OnServerThreadTerminate: TmsServerThreadEvent read FOnServerThreadTerminate
      write FOnServerThreadTerminate;
  end;

  TmsListenerSocket = class(TmsCustomListenerSocket)
  published
    property SuspendedServer;
    property OnConnectionRequested;
    property OnServerThreadStart;
    property OnServerThreadTerminate;
  end;
{$ENDIF} {VCL}

implementation

{$IFDEF VCL}
uses Dialogs;
{$ENDIF}

{TmsSocketBase}
{$IFDEF VCL}
constructor TmsSocketBase.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  if not (csDesigning in ComponentState) then
    FWindow:=AllocateHWnd(WndProcedure);
  FSocket:=INVALID_SOCKET;
  FBufSize:=$8000;
  FTimeOut:=60;
  FBlocking:=false;
  FSleepTime:=-1;
  FTC:=TmsTimeCounter.Create;
end;

function TmsSocketBase.GetVersion: string;
begin
  Result:=msVersion;
end;

procedure TmsSocketBase.SetVersion(const Value: string);
begin
end;

procedure TmsSocketBase.SetBlocking(Value: boolean);
var
  Arg: u_long;
begin
  if not Value then
  begin
    Arg:=1;
    if msWinsock.ioctlsocket(FSocket,LongInt(FIONBIO),Arg)=SOCKET_ERROR
      then Error(msWinsock.WSAGetLastError);
    if FTC=nil then
    begin
      FTC:=TmsTimeCounter.Create;
      FTC.TimeOut:=FTimeOut;
    end;
  end
  else
  begin
    if msWinsock.WSAAsyncSelect(FSocket,FWindow,WM_ASYNCNOTIFICATION,0)=SOCKET_ERROR
      then Error(msWinsock.WSAGetLastError);
    Arg:=0;
    if msWinsock.ioctlsocket(FSocket,LongInt(FIONBIO),Arg)=SOCKET_ERROR
      then Error(msWinsock.WSAGetLastError);
    if FTC<>nil then
    begin
      FTC.Free;
      FTC:=nil;
    end;
  end;
  FBlocking:=Value;
end;

procedure TmsSocketBase.TimerOn;
begin
  if FTC<>nil then
    FTC.TimerOn;
end;

procedure TmsSocketBase.TimerOff;
begin
  if FTC<>nil then
    FTC.TimerOff;
end;

procedure TmsSocketBase.TimerReset;
begin
  if FTC<>nil then
    FTC.TimerReset;
end;

function TmsSocketBase.TimedOut: boolean;
begin
  if FTC=nil then
    Result:=false
  else
    Result:=FTC.TimedOut;
end;
{$ELSE}
constructor TmsSocketBase.Create;
begin
  inherited Create;
  FSocket:=INVALID_SOCKET;
  FBufSize:=$8000;
end;
{$ENDIF}

destructor TmsSocketBase.Destroy;
begin
{$IFDEF VCL}
  if FTC<>nil then
    FTC.Free;
  if not (csDesigning in ComponentState) then
    DeallocateHWnd(FWindow);
{$ENDIF}
  inherited Destroy;
end;

procedure TmsSocketBase.Error(Ident : word);
begin
  msWinsock.Error(Ident);
end;

procedure TmsSocketBase.LastError;
begin
  msWinsock.Error(msWinsock.WSAGetLastError);
end;

{TmsSocket}
{$IFDEF VCL}
constructor TmsSocket.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Log:=TStringList.Create;
  FChunkSize:=$4000;
  FStreamLimit:=-1;
  SocketType:=SOCK_STREAM;
  Proto:=IPPROTO_IP;
{$IFDEF IBUS}
  FIbusSocket:=true;
{$ELSE}
  FIBusSocket:=false;
{$ENDIF}
end;
{$ELSE}
constructor TmsSocket.Create;
begin
  inherited Create;
  Log:=TStringList.Create;
  FChunkSize:=$4000;
  FStreamLimit:=-1;
  SocketType:=SOCK_STREAM;
  Proto:=IPPROTO_IP;
{$IFDEF IBUS}
  FIbusSocket:=true;
{$ELSE}
  FIBusSocket:=false;
{$ENDIF}
end;
{$ENDIF}

destructor TmsSocket.Destroy;
begin
  Log.Free;
  inherited Destroy;
end;

{$IFDEF VCL}
function TmsSocket.GetTimeOut : Integer;
begin
  Result:=FTimeOut;
end;

procedure TmsSocket.SetTimeOut(Value : Integer);
begin
  FTimeOut:=Value;
  if FTC<>nil then
    FTC.TimeOut:=Value;
end;
{$ENDIF}

procedure TmsSocket.SetLinger;
var
  LingerRec: TLinger;
begin
  LingerRec.l_onoff:=Ord(FLinger);
  LingerRec.l_linger:=FLingerTimeOut;
  if msWinsock.setsockopt(FSocket,SOL_SOCKET,SO_LINGER,
    @LingerRec,SizeOf(TLinger))=SOCKET_ERROR then
    Error(msWinsock.WSAGetLastError);
end;

function TmsSocket.GetOnline : boolean;
begin
  Result:=FSocket<>INVALID_SOCKET;
end;

{$IFDEF VCL}
procedure TmsSocket.DoRead(Sender : TObject);
begin
  if Assigned(FOnRead) then
    FOnRead(Sender);
end;

procedure TmsSocket.DoWrite(Sender : TObject);
begin
  if Assigned(FOnWrite) then
    FOnWrite(Sender);
end;

procedure TmsSocket.DoOOBData(Sender: TObject);
begin
  if Assigned(FOnOOBData) then
    FOnOOBData(Sender);
end;

procedure TmsSocket.DoConnected(Sender : TObject);
begin
  if Assigned(FOnConnected) then
    FOnConnected(Sender);
end;

procedure TmsSocket.DoDisconnected(Sender : TObject);
begin
  if Assigned(FOnDisconnected) then
    FOnDisconnected(Sender);
end;

procedure TmsSocket.DoTransferProgress(Sender : TObject; Perc, ByteCount,
  LineCount : LongInt);
begin
  if Assigned(FOnTransferProgress) then
    FOnTransferProgress(Sender, Perc, ByteCount, LineCount);
end;

procedure TmsSocket.DoLineSent(Sender : TObject; const TheLine : string);
begin
  if FLogFileName<>'' then Log.Add(TheLine);
  if Assigned(FOnLineSent) then
    FOnLineSent(Sender, TheLine);
end;

procedure TmsSocket.DoLineReceived(Sender : TObject; const TheLine : string);
begin
  if FLogFileName<>'' then Log.Add(TheLine);
  if Assigned(FOnLineReceived) then
    FOnLineReceived(Sender, TheLine);
end;

procedure TmsSocket.WndProcedure(var Msg : TMessage);
begin
  with Msg do
  if Msg=WM_ASYNCNOTIFICATION then
  begin
    FAsyncError:=msWinsock.WSAGetAsyncError(lParam);
    if (FAsyncError=0) then
    begin
      case msWinsock.WSAGetSelectEvent(lParam) of
        FD_CONNECT :
        begin
          ConnectionAccepted:=true;
          DoConnected(Self);
        end;
        FD_CLOSE :
        begin
          ConnectionReset:=true;
          DoDisconnected(Self);
        end;
        FD_WRITE :
        begin
          DoWrite(Self);
        end;
        FD_READ :
        begin
          DoRead(Self);
        end;
        FD_OOB :
        begin
          DoOOBData(Self);
        end;
      end;
    end;
    Result:=0;
  end
  else
    Result:=DefWindowProc(FWindow,Msg,wParam,lParam);
end;

procedure TmsSocket.SetNetEvents;
begin
  if not FBlocking then
  begin
    if msWinsock.WSAAsyncSelect(FSocket,FWindow,WM_ASYNCNOTIFICATION,
       FD_CONNECT or FD_CLOSE or FD_READ or FD_WRITE or FD_OOB)=SOCKET_ERROR
         then Error(msWinsock.WSAGetLastError);
  end;
end;
{$ENDIF}

procedure TmsSocket.Cancel;
begin
{$IFNDEF VCL}
  if msWinsock.WSAIsBlocking then
  begin
    msWinsock.WSACancelBlockingCall;
  end;
{$ENDIF}
{$IFDEF VCL}
  if FBlocking then
    msWinsock.WSACancelBlockingCall
  else
    TimerOff;
{$ENDIF}
  FCanceled:=true;
  Disconnect;
end;

procedure TmsSocket.ReInit;
begin
{$IFDEF VCL}
  ConnectionAccepted:=false;
  ConnectionReset:=false;
  FCanceled:=false;
  FAsyncError:=0;
  TimerReset;
{$ENDIF}
end;

procedure TmsSocket.Write(const Buffer; Count : LongInt);
var
  Done : boolean;
  p : LongInt;
begin
  p:=0; Done:=false;
{$IFDEF VCL}
  TimerOn;
{$ENDIF}
  repeat
    rc:=msWinsock.send(FSocket,PChar(@Buffer)+p,Count-p,FSendRcvFlags);
    if rc=SOCKET_ERROR then
    begin
{$IFDEF VCL}
      if not FBlocking then
      begin
        if msWinsock.WSAGetLastError=WSAEWOULDBLOCK then
          Done:=false
        else
        if (not FCanceled) and (not TimedOut) then
          Error(msWinsock.WSAGetLastError)
      end
      else
        Error(msWinsock.WSAGetLastError);
{$ELSE}
        Error(msWinsock.WSAGetLastError);
{$ENDIF}
    end
    else
    begin
      Inc(p,rc);
      Done:=p=Count;
{$IFDEF VCL}
      TimerReset;
{$ENDIF}
    end;
{$IFDEF VCL}
    if not FBlocking then
      Application.ProcessMessages;
    if FSleepTime>-1 then
      Sleep(FSleepTime);
  until Done or TimedOut or FCanceled;
  TimerOff;
  if TimedOut then
    raise EmsTimedOutError.Create;
  if FCanceled then
    raise EmsCanceledError.Create;
{$ELSE}
  until Done;
{$ENDIF}
end;

function TmsSocket.Read(var Buffer; Count : LongInt) : LongInt;
begin
  Result:=msWinsock.recv(FSocket,PChar(@Buffer),Count,FSendRcvFlags);
end;

procedure TmsSocket.SendLine(const s : string);
var
  s1: string;
begin
  s1:=Concat(s,^M^J);
  Write(s1[1],Length(s1));
{$IFDEF VCL}
  DoLineSent(Self,s);
{$ENDIF}
end;

function TmsSocket.RecvLine : string;
{Receives data until CR arrives}
const
  BufSize = 4096;
var
  Buf : PChar;
  p : Cardinal;
  Done : boolean;
begin
  Buf:=StrAlloc(BufSize);
  Done:=false;
  try
    FillChar(Buf^,BufSize,0);
    p:=0;
{$IFDEF VCL}
    TimerOn;
{$ENDIF}
    repeat
      if FIbusSocket then
        rc:=Read((Buf+p)^,BufSize)
      else
        rc:=Read((Buf+p)^,1);
      if FCanceled then
        raise EmsCanceledError.Create;
      if (rc=SOCKET_ERROR) then
      begin
{$IFDEF VCL}
        if not FBlocking then
        begin
          if (msWinsock.WSAGetLastError=WSAEWOULDBLOCK) or
             (msWinsock.WSAGetLastError=NOERROR) then
          begin
            Done:=false;
          end
          else
          if (not FCanceled) and (not TimedOut) then
            Error(msWinsock.WSAGetLastError);
          end
        else
          Error(msWinsock.WSAGetLastError);
{$ELSE}
          Error(msWinsock.WSAGetLastError);
{$ENDIF}
      end
      else
      begin
{$IFDEF VCL}
        if rc=0 then
          ConnectionReset:=true;
        TimerReset;
{$ENDIF}
        Done:=(StrPos(Buf,^J)<>nil)
{$IFDEF VCL}
          or (ConnectionReset and (rc=0))
{$ENDIF}
          ;
        Inc(p,rc);
      end;
      if p>=BufSize-2 then
        Done:=true;
{$IFDEF VCL}
      if not FBlocking then
        Application.ProcessMessages;
      if FSleepTime>-1 then
        Sleep(FSleepTime);
    until Done or TimedOut or FCanceled;
    if FSleepTime>-1 then
      Sleep(FSleepTime);
    TimerOff;
    if TimedOut then
      raise EmsTimedOutError.Create;
    if FCanceled then
      raise EmsCanceledError.Create;
{$ELSE}
    until Done;
{$ENDIF}
    if p>=BufSize-2 then
      raise EmsTooMuchDataError.Create;
    if (StrLen(Buf)<>0) and (StrPos(Buf,^J)<>nil) then
      (StrPos(Buf,^J))^:=#0;
    Result:=StrPas(Buf);
    p:=Pos(^M,Result);
    if p>0 then
      Delete(Result,p,1);
  finally
    StrDispose(Buf);
  end;
{$IFDEF VCL}
  DoLineReceived(Self,Result);
{$ENDIF}
end;

procedure TmsSocket.SendStream(Stream : TStream; StartPosition: Integer);
var
  Buf : PChar;
  rs : LongInt;
begin
  if Stream.Size>0 then
  begin
    Stream.Seek(StartPosition,soFromBeginning);
    Buf:=StrAlloc(FBufSize);
    try
      repeat
        FillChar(Buf^,StrBufSize(Buf),0);
        rs:=Stream.Read(Buf^,FBufSize);
        Write(Buf^,rs);
{$IFDEF VCL}
        DoTransferProgress(Self,Round(100*(Stream.Position/Stream.Size)),
          Stream.Position,-1);
{$ENDIF}
      until (rs<FBufSize);
    finally
      StrDispose(Buf);
    end;
  end;
end;

{$IFDEF VCL}
function TmsSocket.StreamSocket: boolean;
begin
  Result:=(SocketType=SOCK_STREAM) and (Proto=IPPROTO_IP)
end;
{$ENDIF}

procedure TmsSocket.RecvStream(Stream :TStream; FullSize, StartPosition: Integer);
{Receives stream until connection is reset
  or FullSize bytes received}
var
  Buf : PChar;
  LastError : Integer;
  rs,Total : LongInt;
  Done : boolean;
  TooMuchData: boolean;
begin
  Stream.Seek(StartPosition,soFromBeginning);
  if FullSize=0 then
    FullSize:=-1;
  Buf:=StrAlloc(FBufSize);
  try
    Total:=0;
{$IFDEF VCL}
    TimerOn;
{$ENDIF}
    repeat
      if FullSize>0 then
      begin
        rs:=FullSize-Total;
        if rs>FBufSize then
          rs:=FBufSize;
      end
      else
        rs:=FBufSize;
      rc:=Read(Buf^,rs);
      if FCanceled then
        raise EmsCanceledError.Create;
      if rc=SOCKET_ERROR then
      begin
        LastError:=msWinsock.WSAGetLastError;
{$IFDEF VCL}
        if not FBlocking then
        begin
          if (LastError<>WSAEWOULDBLOCK) and (not FCanceled)
            and (not TimedOut) then
            Error(LastError);
        end
        else
          Error(LastError);
{$ELSE}
          Error(LastError);
{$ENDIF}
      end;
      if rc>0 then
      begin
        Total:=Total+rc;
        Stream.Write(Buf^,rc);
        FillChar(Buf^,StrBufSize(Buf),0);
{$IFDEF VCL}
        if FullSize>0 then
          DoTransferProgress(Self,Round(100*(Stream.Position/FullSize)),
            Stream.Position,-1)
        else
          DoTransferProgress(Self,-1,Stream.Position,-1);
        TimerReset;
{$ENDIF}
      end;
      TooMuchData:=(FStreamLimit>-1) and (Stream.Position>FStreamLimit);
{$IFDEF VCL}
      if StreamSocket then
      begin
        if rc=0 then
          ConnectionReset:=true;
        Done:=(ConnectionReset and (rc=0)) or (Total=FullSize);
      end
      else
        Done:=rc>0;
      if not FBlocking then
        Application.ProcessMessages;
      if FSleepTime>-1 then
        Sleep(FSleepTime);
    until Done or FCanceled or TimedOut or TooMuchData;
    TimerOff;
    if TimedOut then
       raise EmsTimedOutError.Create;
{$ELSE}
      Done:=Total=FullSize;
    until Done or FCanceled or (rc=0) or TooMuchData;
{$ENDIF}
    if FCanceled then
      raise EmsCanceledError.Create;
    if TooMuchData then
      raise EmsTooMuchDataError.Create;
    if (FullSize>-1) and (Total<FullSize) then
      Error(WSAECONNRESET);
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsSocket.SendChunkedStream(Stream : TStream);
var
  Buf : PChar;
  rs : Integer;
begin
  Buf:=StrAlloc(FChunkSize);
  try
    repeat
      rs:=Stream.Read(Buf^,ChunkSize);
      SendLine(IntToHex(rs,4));
      Write(Buf^,rs);
      SendLine('');
    until rs<ChunkSize;
    SendLine('0');
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsSocket.RecvChunkedStream(Stream : TStream);
var
  TempStream : TMemoryStream;
  rs : Integer;
  s : string;
  Done : boolean;
begin
  Stream.Position:=0;
  TempStream:=TMemoryStream.Create;
  try
    repeat
      s:=RecvLine;
      rs:=StrToIntDef(Concat('$',Trim(s)),-1);
      if rs=-1 then
        raise Exception.Create('Error receiving the stream');
      Done:=rs=0;
      if not Done then
      begin
        TempStream.Clear;
        RecvStream(TempStream,rs,0);
        TempStream.SaveToStream(Stream);
      end;
      RecvLine;
    until Done;
  finally
    TempStream.Free;
  end;
end;

procedure TmsSocket.RecvLineStream(Stream : TStream; FullSize : LongInt);
{Receives the stream and ends at CRLF'.'CRLF}
const
  BufEndSign : PChar = ^M^J'.'^M^J;
var
  Buf : PChar;
  BufEnd : array[0..5] of Char;
  Done : boolean;
  LastError : Integer;
  TooMuchData: boolean;
{$IFDEF VCL}
  LineCount,i,Perc: Integer;
{$ENDIF}
begin
  Buf:=StrAlloc(FBufSize);
  try
    FillChar(Buf^,StrBufSize(Buf),0);
    Done:=false;
    Stream.Position:=0;
{$IFDEF VCL}
    LineCount:=0;
    TimerOn;
{$ENDIF}
    repeat
      rc:=Read(Buf^,FBufSize);
      if FCanceled then
        raise EmsCanceledError.Create;
      if rc=SOCKET_ERROR then
      begin
        LastError:=msWinsock.WSAGetLastError;
{$IFDEF VCL}
        if not FBlocking then
        begin
          if (LastError<>WSAEWOULDBLOCK) and (not FCanceled)
            and (not TimedOut) then Error(LastError)
        end
        else
          Error(LastError);
{$ELSE}
          Error(LastError);
{$ENDIF}
      end;
      if rc>0 then
      begin
        Stream.Write(Buf^,rc);
        if StrPas(Buf)='.'^M^J then
          Done:=true
        else
        if Stream.Position>=5 then
        begin
          Stream.Seek(-5,2);
          FillChar(BufEnd,6,0);
          Stream.Read(BufEnd,5);
          Done:=StrComp(@BufEnd,BufEndSign)=0;
        end;
{$IFDEF VCL}
        for i:=0 to StrLen(Buf) do
        begin
          if (Buf+i)^=^M then
            Inc(LineCount);
        end;
        if FullSize>0 then
        begin
          Perc:=Round(100*Stream.Position/FullSize);
          if Perc>100 then
            Perc:=0;
          DoTransferProgress(Self,Perc,Stream.Position,LineCount);
        end
        else
          DoTransferProgress(Self,-1,Stream.Position,LineCount);
        TimerReset;
{$ENDIF}
        FillChar(Buf^,StrBufSize(Buf),0);
      end;
      TooMuchData:=(FStreamLimit>-1) and (Stream.Position>FStreamLimit);
{$IFDEF VCL}
      if rc=0 then
        ConnectionReset:=true;
      if not FBlocking then
        Application.ProcessMessages;
      if FSleepTime>-1 then
        Sleep(FSleepTime);
    until Done or FCanceled or TimedOut or TooMuchData or (ConnectionReset and (rc=0));
{$ELSE}
    until Done or FCanceled or TooMuchData;
{$ENDIF}
    if FCanceled then
      raise EmsCanceledError.Create;
    if TooMuchData then
      raise EmsTooMuchDataError.Create;
{$IFDEF VCL}
    TimerOff;
    if TimedOut then
      raise EmsTimedOutError.Create;
{$ENDIF}
  finally
    StrDispose(Buf);
  end;
end;

procedure TmsSocket.RecvMultiLines(Lines : TStrings);
{Receives multiline reply}
var
  s, ReplyCode : string;
  Done : boolean;
begin
  Lines.Clear;
  s:=RecvLine;
  Lines.Add(s);
  ReplyCode:=Copy(s,1,3);
  if (Length(s)>3) and (s[4]='-') then
  begin
    repeat
      s:=RecvLine;
      Lines.Add(s);
      Done:=(Length(s)>3) and (Copy(s,1,3)=ReplyCode)
        and (s[4]<>'-');
    until Done;
  end;
end;

procedure TmsSocket.SaveLogFile;
begin
  if FLogFileName<>'' then
    Log.SaveToFile(FLogFileName);
end;

procedure TmsSocket.Disconnect;
//var
//  Buf: array[0..255] of Char;
begin
  if FSocket<>INVALID_SOCKET then
  begin
    rc:=msWinsock.shutdown(FSocket,SD_SEND);
    if rc=SOCKET_ERROR then
      Error(msWinsock.WSAGetLastError);
//    if FBlocking then
//      Read(Buf,SizeOf(Buf));
    rc:=msWinsock.closesocket(FSocket);
    if rc=SOCKET_ERROR then
      Error(msWinsock.WSAGetLastError);
{$IFDEF VCL}
    DoDisconnected(Self);
{$ENDIF}
    FSocket:=INVALID_SOCKET;
  end;
end;

{TmsClientSocket}
{$IFDEF VCL}
constructor TmsClientSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDefaultPort:=0;
  FDebug:=false;
end;
{$ELSE}
constructor TmsClientSocket.Create;
begin
  inherited Create;
  FDefaultPort:=0;
  FDebug:=false;
end;
{$ENDIF}

procedure TmsClientSocket.DoConnecting(Sender : TObject);
begin
  if Assigned(FOnConnecting) then
    FOnConnecting(Sender);
end;

procedure TmsClientSocket.SetProxy(const Value: ShortString);
var
  i: Integer;
begin
  i:=Pos(':',Value);
  if i>0 then
  begin
    FProxy:=Copy(Value,1,i-1);
    FProxyPort:=StrToIntDef(Copy(Value,i+1,Length(Value)),0);
  end
  else
  begin
    FProxy:=Value;
    FProxyPort:=0;
    if FProxy='' then
      SetHost(FHost);
  end;
end;

procedure TmsClientSocket.SetHost(const Value: ShortString);
var
  i: Integer;
begin
  i:=Pos(':',Value);
  if (i>0) and (FProxy='') then
  begin
    FHost:=Copy(Value,1,i-1);
    FPort:=StrToIntDef(Copy(Value,i+1,Length(Value)),FDefaultPort);
  end
  else
  begin
    FHost:=Value;
    if FDefaultPort>0 then
      FPort:=FDefaultPort;
  end;
end;

procedure TmsClientSocket.Connect;
var
  SockAddr : TSockAddr;
{$IFDEF VCL}
  LastError : word;
{$ENDIF}
begin
  Reinit;
  DoConnecting(Self);
  FSocket:=msWinsock.socket(PF_INET,SocketType,Proto);
  if FSocket=INVALID_SOCKET then
    Error(msWinsock.WSAGetLastError);
  if Proto=IPPROTO_IP then
    SetLinger;
  with SockAddr do
  begin
    Sin_Family:=PF_INET;
    if FProxy<>'' then
    begin
      Sin_Port:=msWinsock.htons(FProxyPort);
      Sin_Addr:=msWinsock.msGetInAddr(msWinsock.msGetHostByName(FProxy))
    end
    else
    begin
      Sin_Port:=msWinsock.htons(Port);
      Sin_Addr:=msWinsock.msGetInAddr(msWinsock.msGetHostByName(FHost))
    end;
  end;
{$IFDEF VCL}
  SetBlocking(FBlocking);
  SetNetEvents;
  rc:=msWinsock.connect(FSocket,SockAddr,SizeOf(SockAddr));
  if rc=SOCKET_ERROR then
  begin
    if not FBlocking then
    begin
      LastError:=msWinsock.WSAGetLastError;
      if LastError<>WSAEWOULDBLOCK
        then Error(msWinsock.WSAGetLastError)
    end
    else
      Error(msWinsock.WSAGetLastError);
  end;
  if StreamSocket and (not FBlocking) then
  begin
    TimerOn;
    repeat
      Application.ProcessMessages;
    until ConnectionAccepted or (FAsyncError>0) or TimedOut or FCanceled;
    TimerOff;
    if FAsyncError>0 then
      Error(FAsyncError);
    if TimedOut then
      raise EmsTimedOutError.Create;
    if FCanceled then
      raise EmsCanceledError.Create;
  end;
  DoConnected(Self);
{$ELSE}
  rc:=msWinsock.connect(Socket,SockAddr,SizeOf(SockAddr));
  if rc=SOCKET_ERROR then
    Error(msWinsock.WSAGetLastError);
{$ENDIF}
end;

function TmsClientSocket.GetServerReplyCode(const s : string) : Integer;
begin
  Result:=1;
end;

function TmsClientSocket.iRecvLine(var s : string) : Integer;
begin
  s:=RecvLine;
  Result:=GetServerReplyCode(s);
end;

function TmsClientSocket.iRecvLines : Integer;
var
  Code : Integer;
begin
  Code:=iRecvLine(TempS);
  Result:=Code;
  if (Code>0) and (Pos('-',TempS)=4) then {there are more lines}
  begin
    repeat
      Code:=iRecvLine(TempS);
{$IFDEF VCL}
    until (not FBlocking and ConnectionReset) or ((Code=Result) and (Pos(' ',TempS)=4));
{$ELSE}
    until (Code=Result) and (Pos(' ',TempS)=4);
{$ENDIF}
  end;
end;

{ TmsConnList }

{$IFDEF VCL}
constructor TmsConnList.Create;
begin
  inherited Create;
  InitializeCriticalSection(FCS);
  FList:=TList.Create;
end;

destructor TmsConnList.Destroy;
//var
//  i: Integer;
begin
  LockList;
  try
//    for i:=FList.Count-1 DownTo 0 do
//      Items[i].Free;
    FList.Free;
  finally
    UnlockList;
  end;
  DeleteCriticalSection(FCS);
  inherited Destroy;
end;

procedure TmsConnList.LockList;
begin
  EnterCriticalSection(FCS);
end;

procedure TmsConnList.UnlockList;
begin
  LeaveCriticalSection(FCS);
end;

function TmsConnList.GetCount: Integer;
begin
  LockList;
  try
    Result:=FList.Count;
  finally
    UnlockList;
  end;
end;

procedure TmsConnList.Put(Index: Integer; Value: TmsServerThread);
begin
  LockList;
  try
    FList.Items[Index]:=Value;
  finally
    UnlockList;
  end;
end;

function TmsConnList.Get(Index: Integer): TmsServerThread;
begin
  LockList;
  try
    Result:=FList[Index];
  finally
    UnlockList;
  end;
end;

function TmsConnList.Add(Item: TmsServerThread): Integer;
begin
  LockList;
  try
    Result:=FList.Add(Item);
  finally
    UnlockList;
  end;
end;

procedure TmsConnList.Clear;
//var
//  i: Integer;
begin
  LockList;
  try
//    for i:=FList.Count-1 DownTo 0 do
//      Items[i].Free;
    FList.Clear;
  finally
    UnlockList;
  end;
end;

procedure TmsConnList.Delete(Index: Integer);
begin
  LockList;
  try
//    Items[Index].Free;
    FList.Delete(Index);
  finally
    UnlockList;
  end;
end;

procedure TmsConnList.Remove(Item: TmsServerThread);
var
  i: Integer;
begin
  i:=IndexOf(Item);
  if i>-1 then
    Delete(i);
end;

function TmsConnList.IndexOf(Value: TmsServerThread): Integer;
begin
  LockList;
  try
    Result:=FList.IndexOf(Value);
  finally
    UnlockList;
  end;
end;

{TmsListenerSocketBase}
constructor TmsListenerSocketBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServerSocketTimeOut:=60;
  FBlockingServerSockets:=false;
end;

destructor TmsListenerSocketBase.Destroy;
begin
  inherited Destroy;
end;

procedure TmsListenerSocketBase.DoStart(Sender: TObject);
begin
  if Assigned(FOnStart) then
    FOnStart(Sender);
end;

procedure TmsListenerSocketBase.DoStop(Sender: TObject);
begin
  if Assigned(FOnStop) then
    FOnStop(Sender);
end;

procedure TmsListenerSocketBase.WndProcedure(var Msg : TMessage);
begin
  with Msg do
  if Msg=WM_ASYNCNOTIFICATION then
  begin
    FAsyncError:=msWinsock.WSAGetAsyncError(lParam);
    if (FAsyncError=0) then
    begin
      case msWinsock.WSAGetSelectEvent(lParam) of
        FD_ACCEPT :
        try
          ProcessConnectionRequest;
        except
          on E:Exception do
            Application.HandleException(E);
        end;
      end;
    end;
    Result:=0;
  end
  else
    Result:=DefWindowProc(FWindow,Msg,wParam,lParam);
end;

procedure TmsListenerSocketBase.Start;
var
  SockAddr : TSockAddr;
begin
  FSocket:=msWinsock.socket(PF_INET,SOCK_STREAM,IPPROTO_TCP);
  if FSocket=INVALID_SOCKET then
    Error(msWinsock.WSAGetLastError);
  FillChar(SockAddr,SizeOf(SockAddr),0);
  with SockAddr do
  begin
    Sin_Family:=AF_INET;
    Sin_Port:=msWinsock.htons(FPort);
    if FIPHome='' then
      Sin_Addr.s_addr:=INADDR_ANY
    else
      Sin_Addr:=msWinsock.msGetInAddr(FIPHome);
  end;
  rc:=msWinsock.bind(FSocket,SockAddr,SizeOf(TSockAddr));
  if rc=SOCKET_ERROR then
    Error(msWinsock.WSAGetLastError);
  AsyncHandle:=msWinsock.WSAAsyncSelect(FSocket,FWindow,
    WM_ASYNCNOTIFICATION,FD_ACCEPT);
  if AsyncHandle=THandle(SOCKET_ERROR) then
    Error(msWinsock.WSAGetLastError);
  rc:=msWinsock.listen(FSocket,SOMAXCONN);
  if rc=SOCKET_ERROR then
    Error(msWinsock.WSAGetLastError);
  DoStart(Self);
end;

procedure TmsListenerSocketBase.Stop;
begin
  rc:=msWinsock.closesocket(FSocket);
  if rc=SOCKET_ERROR then
    Error(msWinsock.WSAGetLastError);
  DoStop(Self);
end;

{ TmsSimpleListenerSocket }

constructor TmsSimpleListenerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServerSocket:=TmsSocket.Create(Self);
end;

destructor TmsSimpleListenerSocket.Destroy;
begin
  FServerSocket.Free;
  inherited Destroy;
end;

procedure TmsSimpleListenerSocket.DoSLSConnectionRequested(Sender: TObject);
begin
  if Assigned(FOnSLSConnectionRequested) then
    FOnSLSConnectionRequested(Sender);
end;

procedure TmsSimpleListenerSocket.ProcessConnectionRequest;
var
  SockAddr : TSockAddr;
  NameLen : Integer;
  SSH: TSocket;
  FPeer: ShortString;
begin
  NameLen:=SizeOf(SockAddr);
  SSH:=msWinsock.accept(FSocket,SockAddr,NameLen);
  if SSH=INVALID_SOCKET then
    Error(msWinsock.WSAGetLastError);
  FPeer:=StrPas(msWinsock.inet_ntoa(SockAddr.Sin_Addr));
  FServerSocket.Socket:=SSH;
  FServerSocket.SetNetEvents;
  DoSLSConnectionRequested(Self);
end;

{ TmsServerThread }

procedure TmsServerThread.Cancel;
begin
  ServerSocket.Cancel;
end;

{TmsListenerSocket}
constructor TmsCustomListenerSocket.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectionList:=TmsConnList.Create;
  FSuspendedServer:=false;
end;

destructor TmsCustomListenerSocket.Destroy;
begin
  FConnectionList.Free;
  inherited Destroy;
end;

function TmsCustomListenerSocket.GetConnectionCount: Integer;
begin
  Result:=FConnectionList.Count;
end;

procedure TmsCustomListenerSocket.DoConnectionRequested(Sender: TObject; const Peer: string;
  var Allow: boolean);
begin
  if Assigned(FOnConnectionRequested) then
    FOnConnectionRequested(Sender, Peer, Allow);
end;

procedure TmsCustomListenerSocket.DoServerThreadStart(Sender: TObject; ServerThread: TmsServerThread);
begin
  if Assigned(FOnServerThreadStart) then
    FOnServerThreadStart(Sender, ServerThread);
end;

procedure TmsCustomListenerSocket.DoServerThreadTerminate(Sender: TObject; ServerThread: TmsServerThread);
begin
  if Assigned(FOnServerThreadTerminate) then
    FOnServerThreadTerminate(Sender, ServerThread);
end;

procedure TmsCustomListenerSocket.ProcessConnectionRequest;
var
  SockAddr : TSockAddr;
  NameLen: Integer;
  SSH: TSocket;
  ServerThread: TmsServerThread;
  FPeer: ShortString;
  Allow: boolean;
begin
  NameLen:=SizeOf(SockAddr);
  SSH:=msWinsock.accept(FSocket,SockAddr,NameLen);
  if SSH=INVALID_SOCKET then
    Error(msWinsock.WSAGetLastError);
  FPeer:=StrPas(msWinsock.inet_ntoa(SockAddr.Sin_Addr));
  Allow:=true;
  DoConnectionRequested(Self, FPeer, Allow);
  if Allow then
  begin
    ServerThread:=FServerThreadClass.Create(true);
    ServerThread.Peer:=FPeer;
    ServerThread.IPHome:=FIPHome;
//    ServerThread.FreeOnTerminate:=false;
    ServerThread.FreeOnTerminate:=true;
    ServerThread.OnTerminate:=ServerThreadTerminated;
    ServerThread.ServerSocket:=TmsSocket.Create(Self);
    ServerThread.ServerSocket.FSocket:=SSH;
    ServerThread.ServerSocket.TimeOut:=FServerSocketTimeOut;
    ServerThread.ServerSocket.SleepTime:=FSleepTime;
    if FBlockingServerSockets then
      ServerThread.ServerSocket.SetBlocking(true);
    ServerThread.ServerSocket.SetNetEvents;
    DoServerThreadStart(Self,ServerThread);
    FConnectionList.Add(ServerThread);
    if not FSuspendedServer then
       ServerThread.Resume;
  end
  else
    msWinsock.closesocket(SSH);
end;

procedure TmsCustomListenerSocket.ServerThreadTerminated(Sender: TObject);
var
  ServerThread: TmsServerThread;
begin
  DoServerThreadTerminate(Self, Sender as TmsServerThread);
  ServerThread:=Sender as TmsServerThread;
  ServerThread.ServerSocket.Free;
  FConnectionList.Remove(ServerThread);
end;

procedure TmsCustomListenerSocket.CancelAllConnections;
var
  i: Integer;
begin
  repeat
    i:=FConnectionList.Count;
    if i>0 then
    begin
      FConnectionList[0].Cancel;
      repeat
        Application.ProcessMessages;
      until FConnectionList.Count<i;
    end;
  until i=0;
end;
{$ENDIF}

end.
